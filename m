Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859704222D5
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 11:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbhJEJ5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 05:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233810AbhJEJ5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 05:57:40 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB731C06161C;
        Tue,  5 Oct 2021 02:55:49 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g10so16498150edj.1;
        Tue, 05 Oct 2021 02:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=srL4Qc/NMYm6rlvLBzZbiYw1agH6jOJPHwX6Rpu/UI0=;
        b=fsvQsgb8NAQiXsaKD06fpe4VcWpeSE2h/YnCThGpMgqo6P7KPBzq0Qd9aBmP4g7q3W
         hs67lk3G4F8J9oEYM9dJZLz8xUkF4F57j0i/RxrfSbY5Br21qHQLNjG+PX1UHU6dkxkM
         Zcygtrzw5ymjFnnVJIU17W2a/UfLSie0elOg5RckCVhmaAeXQwl7E7afnnfIziYoMMxh
         SVstzsAWufruDwZGL5418S0PVatbtn2H7Yh1NRA7vzXNYR3tu7yKBExuDYoQwJ6dLfBx
         ugnqlLysW6m+IC33XOk+RUnULiV0/DCorU2vjy5y+X6Yke6mRL8GF54aLM3yj7/041pI
         wC1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=srL4Qc/NMYm6rlvLBzZbiYw1agH6jOJPHwX6Rpu/UI0=;
        b=B3Uxay/H79zohNWMmQLhAD4IHah5tjDYMS9t0rkPrM0ukXRp67daO35MmLzz0w16fz
         3IwJE1GUPRWXGWFh9iWvkJv8+VKdIzwG7f6rl5BRz542i/JfkUUMmxu+FGZ7vkazc6pY
         S3gsqttoan30ncmWP4D516Iu5EkxxfK1+U8eDKLsbkwXvMWP96JHTROSi8VsyPSWMFnZ
         q6RSSiVWCJwYXSXf3kyrww8x6dn7r3J0RN+BPdeb0UAr0Pve4HwkGa7Jgee3mLhM0UCJ
         P+YgEBfpsBhG16XUiL/uLXckPe8uBMNtSJozlpmB5ptbArFs56Zg9GQph4V43wpdOgtK
         WhnA==
X-Gm-Message-State: AOAM530zcw2/VeiM5+HynU7B4N+SAYfCMYtWtEV1OVUlELMNdmAH8L2W
        jMfZDwNbPk25wvwGckfWMLQhasKe990=
X-Google-Smtp-Source: ABdhPJzL9GRwgy4tB6GUlY4cDC2w1J+KaqcDCFZ9c7aSkKTx+Xgt8gp/t7pstQ+3Fmbs7UHlyxl+ww==
X-Received: by 2002:aa7:cb92:: with SMTP id r18mr25370814edt.282.1633427744515;
        Tue, 05 Oct 2021 02:55:44 -0700 (PDT)
Received: from [192.168.0.108] ([176.228.98.2])
        by smtp.gmail.com with ESMTPSA id m6sm8057887edv.52.2021.10.05.02.55.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 02:55:44 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] mlx4: replace mlx4_mac_to_u64() with
 ether_addr_to_u64()
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, tariqt@nvidia.com, yishaih@nvidia.com,
        linux-rdma@vger.kernel.org
References: <20211004191446.2127522-1-kuba@kernel.org>
 <20211004191446.2127522-2-kuba@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <a428a7fd-1c2b-ab8e-b032-f7b8d4b293d9@gmail.com>
Date:   Tue, 5 Oct 2021 12:55:42 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211004191446.2127522-2-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/4/2021 10:14 PM, Jakub Kicinski wrote:
> mlx4_mac_to_u64() predates and opencodes ether_addr_to_u64().
> It doesn't make the argument constant so it'll be problematic
> when dev->dev_addr becomes a const. Convert to the generic helper.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   drivers/infiniband/hw/mlx4/main.c              |  2 +-
>   drivers/infiniband/hw/mlx4/qp.c                |  2 +-
>   drivers/net/ethernet/mellanox/mlx4/cmd.c       |  2 +-
>   drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 16 ++++++++--------
>   drivers/net/ethernet/mellanox/mlx4/fw.c        |  2 +-
>   include/linux/mlx4/driver.h                    | 12 ------------
>   6 files changed, 12 insertions(+), 24 deletions(-)
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

