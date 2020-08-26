//
//  ViewController.m
//  GPUImage_demo02
//
//  Created by tlab on 2020/8/26.
//  Copyright © 2020 yuanfangzhuye. All rights reserved.
//

#import "ViewController.h"
#import <GPUImage/GPUImage.h>

@interface ViewController ()

//饱和度滤镜
@property (nonatomic, strong) GPUImageSaturationFilter *saturationFilter;

@property (nonatomic, strong) UIImageView *gpuImageView;
@property (nonatomic, strong) UIImage *customImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    self.gpuImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.gpuImageView.image = [UIImage imageNamed:@"kunkun1.jpeg"];
    [self.view addSubview:self.gpuImageView];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 80, [UIScreen mainScreen].bounds.size.width, 30)];
    [slider addTarget:self action:@selector(sliderClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    //1.获取图片
    _customImage = [UIImage imageNamed:@"kunkun1.jpeg"];
}

- (void)sliderClick:(UISlider *)sender {
    
    //2.选择合适的滤镜
    //饱和度：应用于图像的饱和度或去饱和度（0.0 - 2.0，默认为1.0）
    if (!_saturationFilter) {
        _saturationFilter = [[GPUImageSaturationFilter alloc] init];
        //设置饱和度值
        _saturationFilter.saturation = 1.0;
    }
    
    //设置要渲染的区域 --图片大小
    [_saturationFilter forceProcessingAtSize:_customImage.size];
    //使用单个滤镜
    [_saturationFilter useNextFrameForImageCapture];
    //调整饱和度
    _saturationFilter.saturation = sender.value;
    
    //3.创建图片组件--数据源头(静态图片)
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:_customImage];
    //为图片添加一个滤镜
    [stillImageSource addTarget:_saturationFilter];
    //处理图片
    [stillImageSource processImage];
    
    //4.处理完成,从FrameBuffer帧缓存区中获取图
    UIImage *newImage = [_saturationFilter imageFromCurrentFramebuffer];
    //更新图片
    self.gpuImageView.image = newImage;
}


@end
