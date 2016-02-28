//
//  ViewController.m
//  hello
//
//  Created by admin on 16/2/25.
//  Copyright © 2016年 admin. All rights reserved.
//
@import JavaScriptCore;

#import "ViewController.h"
#import "Student.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView * webView;
@end

@implementation ViewController

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * callJSFunctioinBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 80, 44)];
    callJSFunctioinBtn.backgroundColor = [UIColor redColor];
    callJSFunctioinBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [callJSFunctioinBtn setTitle:@"调用JS方法" forState:(UIControlStateNormal)];
    [callJSFunctioinBtn addTarget:self action:@selector(clickCallJSFunctionBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:callJSFunctioinBtn];
    
    CGRect webViewFrame = CGRectMake(0, 100, kWidth, kHeight - 100);
    UIWebView *webView = [[UIWebView alloc] initWithFrame:webViewFrame];
    webView.delegate = self;
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [webView loadRequest:request];
    [self.view addSubview:webView];
    self.webView = webView;
    
    
    
    self.summerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 20, 80, 80)];
    [self.view addSubview:self.summerImageView];
}

- (void)clickCallJSFunctionBtn:(UIButton *)btn{
   // [self.webView stringByEvaluatingJavaScriptFromString:@"callJSFunction()"];
    
   // [self.webView stringByEvaluatingJavaScriptFromString:@"callJSFunctionWithParam(\"mary\")"];
    
    NSArray * params = @[@"tony",@"zack",@"kson"];
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [context setExceptionHandler:^(JSContext *context, JSValue *value) {
        NSLog(@"JS exception: %@", value);
    }];
    JSValue *jsFunction = context[@"callJSFunctionWithParam"];
    JSValue * jsReturnValue =  [jsFunction callWithArguments:@[params]];
    NSLog(@"js return value:%@",[jsReturnValue toString]);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webView finsh load");

    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    [context setExceptionHandler:^(JSContext *context, JSValue *value) {
        NSLog(@"WEB JS: %@", value);
    }];
    
    Student * kson = [[Student alloc] init];
    kson.viewController = self;
    context[@"myStudent"] = kson;
    
    NSString * str =
    @"function spring () {"
    "   myStudent.takePhoto();}"
    "var btn = document.getElementById(\"pid\");"
    "btn.addEventListener('click', spring);";
    
    [context evaluateScript:str];
    
}



@end
