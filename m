Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9C566244FB
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 16:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbiKJPBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 10:01:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbiKJPBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 10:01:36 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5FF1084;
        Thu, 10 Nov 2022 07:01:35 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id y16so2619744wrt.12;
        Thu, 10 Nov 2022 07:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+nltbjQBKpVbTJLMAnxljJZEHRKo2FfTGRd7DlcozC8=;
        b=GgegB9t4B9Y0hPUanSoNKX5L1wf0K9nDiDeSpUMm8Ez5oRfuUtO+tumApucC0JjPU9
         u2+phshdrSIkW0GOdf5f1ywFm/Iz5qd7TsFXkhazZuB+2cNMwPPp2jQGnK3lE4LMtWN9
         DI7gVYNpMASxkPrBs2IdjjvItsWoVQIBRHd23MvzUijg7mlCFGOqHEyQJ1Db0J2KxQHa
         MBvpNd4ViOfJti62CNYwF8doLRLByU7W+Mz5jVzLvoWPD8yaBKDPhiAqXcPoiRmplHHN
         XSngBvQ84JlxcEC2qEi2JNgUwuWC6ls0nE23QUBXNxRt5XXFW/ypGJ4oY5bNRceu2ygb
         qlWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+nltbjQBKpVbTJLMAnxljJZEHRKo2FfTGRd7DlcozC8=;
        b=qfir/33A/E7PFn4BfIPLc/4DiHdWnFmIjkpyTeNv2CYgUf0VCzoSRO3TYmVhVApumt
         iUEfGQRPIs74k5zunuIl/QdlcQYnHjI9n+I/GC6rbAtNQ97aPvlEH2segOhicelKBY2m
         te6/5dE2EMGithrO/qTl6zQkl0MCnhjQC7ClR6c3jOiJF4d/KOonIJ7axVp9oiBoYxeP
         nJk9DIzsdzblAfxPYNnMlfqFVH7kQmSOvYKZD1dX7eM0fbqk7KbpQv8C64QpG/RP/WjJ
         5TS61Poy75O7ZnP5NByVd/APo0hyd2go48T9IG7GH/GaEIKQIyQ1TZyhUpCUgHFZfzp7
         iVEw==
X-Gm-Message-State: ACrzQf24XPjqAHw+0J05j61QdXfbuifSnlBuwxNvSTS5lrJx+5qfRh1a
        tTWmX698xOjugLSQB9RvgIoScN/2OJ0=
X-Google-Smtp-Source: AMsMyM5pnlAfcRgoDfICNzkU8Ea1J3Zqsj5SBdPX3jUoGJ3dOJcau0gxXyh9lVZXEvACgFs/ChHRTg==
X-Received: by 2002:a5d:6250:0:b0:236:dc52:adae with SMTP id m16-20020a5d6250000000b00236dc52adaemr33555190wrv.111.1668092493642;
        Thu, 10 Nov 2022 07:01:33 -0800 (PST)
Received: from [192.168.0.105] ([77.126.19.155])
        by smtp.gmail.com with ESMTPSA id h18-20020a5d6e12000000b002365730eae8sm16060704wrz.55.2022.11.10.07.01.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 07:01:33 -0800 (PST)
Message-ID: <939ca9bb-0207-2b14-8d44-09c47deb72c6@gmail.com>
Date:   Thu, 10 Nov 2022 17:01:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v3] net/mlx5e: Use kzalloc() in
 mlx5e_accel_fs_tcp_create()
To:     YueHaibing <yuehaibing@huawei.com>, borisp@nvidia.com,
        saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lkayal@nvidia.com, tariqt@nvidia.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221110134319.47076-1-yuehaibing@huawei.com>
Content-Language: en-US
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20221110134319.47076-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/10/2022 3:43 PM, YueHaibing wrote:
> 'accel_tcp' is allocted by kvzalloc() now, which is a small chunk.
> Use kzalloc() directly instead of kvzalloc(), fix the mismatch free.
> 
> Fixes: f52f2faee581 ("net/mlx5e: Introduce flow steering API")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
> v3: use kzalloc() instead of kvzalloc()
> v2: fix the same issue in mlx5e_accel_fs_tcp_destroy() and a commit log typo
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
> index 285d32d2fd08..88a5aed9d678 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
> @@ -377,7 +377,7 @@ int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs)
>   	if (!MLX5_CAP_FLOWTABLE_NIC_RX(mlx5e_fs_get_mdev(fs), ft_field_support.outer_ip_version))
>   		return -EOPNOTSUPP;
>   
> -	accel_tcp = kvzalloc(sizeof(*accel_tcp), GFP_KERNEL);
> +	accel_tcp = kzalloc(sizeof(*accel_tcp), GFP_KERNEL);
>   	if (!accel_tcp)
>   		return -ENOMEM;
>   	mlx5e_fs_set_accel_tcp(fs, accel_tcp);

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks.
