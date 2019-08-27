Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F3F9F43D
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 22:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbfH0UkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 16:40:16 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45929 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbfH0UkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 16:40:16 -0400
Received: by mail-wr1-f66.google.com with SMTP id q12so140855wrj.12
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 13:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LVY+aGgV5phVkgMSXjfnQV4zLurQzKqT7u/u8Bbhqn4=;
        b=SdSulqDQhvJQaCl/gqpRI29PMKcIigY1c472uiQr0zBUH0suP/3zID/TWaFKLGGxt6
         wJU4/jiPdnLLZ98QU2A5JBMHijilc4FRAF9U1kvjapIdUhWELzGMNFxpZJT2qx3bai4t
         XnCyR06QWZxXtqEDbK+YC3i+qsylW9SxNrCTY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LVY+aGgV5phVkgMSXjfnQV4zLurQzKqT7u/u8Bbhqn4=;
        b=Sjr3jX6ofZEkKJTZMhnGtr2IovxLZToiXDHnCAN6CXWmt7DUdG1iC8CUbiXYGsIQmy
         tZYDOSIdKWjrMt60WefY8xuIMs/FJ+jTBdqXxA7GGc6eW1n/dXrWFidLx8ap/6BinC/b
         EZ5az53F7vFHvV1asOpFiyBtqYZTcgF/Uk/tc0oUZoLBLyQGhG3fvetvQm/+r+LxQzLS
         pdJFBsTV2qs8TZL/8mji4K8/DEdt9XG6TWWaYDnpJn/6GX2MZSEx619vIC8uRXs7ofKI
         WztZcFamYMvqqibAANETQDPoAocEPRCxrJGyqmqcifZ2RSi/F31eP4D5GGyg3wk2MlYR
         kG1A==
X-Gm-Message-State: APjAAAWhVCdQBOi/DbDMesyhAKPzOHGklH4AKf76mgBPm14e5SYYhXwC
        Qqd3fuwG8M7CsiPWyG63GtHcfg==
X-Google-Smtp-Source: APXvYqw2S8S1S6srBLnhNXgrsUaeESkm3bBtz02xDGo7Ut/x/S+256UHwPqj2L8/y9Wugysbq7pyJQ==
X-Received: by 2002:adf:ce81:: with SMTP id r1mr133139wrn.114.1566938414417;
        Tue, 27 Aug 2019 13:40:14 -0700 (PDT)
Received: from rj-aorus.ric.broadcom.com ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id d69sm189454wmd.4.2019.08.27.13.40.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 13:40:13 -0700 (PDT)
Subject: Re: [PATCH net-next] phy: mdio-bcm-iproc: use
 devm_platform_ioremap_resource() to simplify code
To:     YueHaibing <yuehaibing@huawei.com>, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        rjui@broadcom.com, sbranden@broadcom.com
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20190827134616.11396-1-yuehaibing@huawei.com>
From:   Ray Jui <ray.jui@broadcom.com>
Message-ID: <27e43388-bc8f-6a36-5696-beb3b8d140d4@broadcom.com>
Date:   Tue, 27 Aug 2019 13:40:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190827134616.11396-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019-08-27 6:46 a.m., YueHaibing wrote:
> Use devm_platform_ioremap_resource() to simplify the code a bit.
> This is detected by coccinelle.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>   drivers/net/phy/mdio-bcm-iproc.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/mdio-bcm-iproc.c b/drivers/net/phy/mdio-bcm-iproc.c
> index 7d0f388..7e9975d 100644
> --- a/drivers/net/phy/mdio-bcm-iproc.c
> +++ b/drivers/net/phy/mdio-bcm-iproc.c
> @@ -123,15 +123,13 @@ static int iproc_mdio_probe(struct platform_device *pdev)
>   {
>   	struct iproc_mdio_priv *priv;
>   	struct mii_bus *bus;
> -	struct resource *res;
>   	int rc;
>   
>   	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
>   	if (!priv)
>   		return -ENOMEM;
>   
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	priv->base = devm_ioremap_resource(&pdev->dev, res);
> +	priv->base = devm_platform_ioremap_resource(pdev, 0);
>   	if (IS_ERR(priv->base)) {
>   		dev_err(&pdev->dev, "failed to ioremap register\n");
>   		return PTR_ERR(priv->base);
> 

Looks good to me. Thanks.

Reviewed-by: Ray Jui <ray.jui@broadcom.com>
