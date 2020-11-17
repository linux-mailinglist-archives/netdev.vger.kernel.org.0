Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4622B5A23
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 08:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbgKQHOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 02:14:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgKQHOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 02:14:47 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5185CC0613CF;
        Mon, 16 Nov 2020 23:14:47 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id 23so22036746wrc.8;
        Mon, 16 Nov 2020 23:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=CUtBCyqo5ZGyuM7QUEphV6yKwsbwY0PU35m2CCb5vDc=;
        b=XC/IZrqgoNDUlrsdarXUYpWeMIqqrkvJCPgf4LguYz1TmPps0Tp0Dfcmb0+gKUXryr
         UOe1U664I7CxgdLFp0tZGeGj0mLt+V4o9xIXZo8rAFQWZiJhiZYeeRTHj1H4pfmCbXP4
         YCuLZZbS7qX4kt9OZPZu1wv70ku50EoyJdFsi8praKskaOomAvXDf5QlOn5YJr7JF3GB
         EEBYUaOwh7gfBrRIF2yIUyD9ZySPszmWfH7IOkySyFojlBXqAva1JcPqqzogcD6nZ2zV
         9ozgyPySfrzOQndcc10LMoko0/MtrVeD7GS3XWqdzFjEf/ft0gpmKKIteH7Cw9Y3FqMP
         yyTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=CUtBCyqo5ZGyuM7QUEphV6yKwsbwY0PU35m2CCb5vDc=;
        b=briBd6E+0BktiYRaI7deoDYR1oiD/+HDIBTY7YuN3HU05r06t6FIeHB3Y1TemI2XUh
         j57uqk23KqIAFTg7DiN2Ow3f1NPxoZha/NjNb0idl+Hi++PYIbjdNWiTadaIUcAv83kR
         62eiFvOoyVOHGOam/OUVLQplxxBchbYwv5XmXNs9CEKMJT7gnQfZwg8TLHcciWw5M/CG
         6TJ3F88MB3PZf2+ePI8qq8epzmjzX6JCrntG/xnkOmJOPUV0V0x9nz6Qc12Xd+nB/UXE
         EcGe2d6lzddkNtRo8XsMLnRHklZ0A1rup3l/D7efV6uz49yVGOwHNyx8J1C3Y7s9jrsD
         Fvpg==
X-Gm-Message-State: AOAM533vmZyzG2PrZGZtiqocLPwnFByHSkRDRAkRtqNJROfVBn35EGuD
        6OCEIRVoHoc7WNW1JnbYPlN84f7ScisOYw==
X-Google-Smtp-Source: ABdhPJzL5bdbdWHO323RYLKSYq8q5YLvu5rCTltMAgSun1F6sTl1s4Hc8/L/r02To0gdetZ0eYq+lA==
X-Received: by 2002:adf:f906:: with SMTP id b6mr23212657wrr.244.1605597285890;
        Mon, 16 Nov 2020 23:14:45 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:703b:c7f4:f658:541b? (p200300ea8f232800703bc7f4f658541b.dip0.t-ipconnect.de. [2003:ea:8f23:2800:703b:c7f4:f658:541b])
        by smtp.googlemail.com with ESMTPSA id n11sm25341365wru.38.2020.11.16.23.14.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 23:14:45 -0800 (PST)
Subject: Re: [PATCH net] atl1c: fix error return code in atl1c_probe()
To:     Zhang Changzhong <zhangchangzhong@huawei.com>, jcliburn@gmail.com,
        chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        yanaijie@huawei.com, christophe.jaillet@wanadoo.fr, mst@redhat.com,
        leon@kernel.org, jesse.brandeburg@intel.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1605581721-36028-1-git-send-email-zhangchangzhong@huawei.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <34800149-ce40-b993-1d82-5f26abc61b28@gmail.com>
Date:   Tue, 17 Nov 2020 08:14:39 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <1605581721-36028-1-git-send-email-zhangchangzhong@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 17.11.2020 um 03:55 schrieb Zhang Changzhong:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 85eb5bc33717 ("net: atheros: switch from 'pci_' to 'dma_' API")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> index 0c12cf7..3f65f2b 100644
> --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> @@ -2543,8 +2543,8 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	 * various kernel subsystems to support the mechanics required by a
>  	 * fixed-high-32-bit system.
>  	 */
> -	if ((dma_set_mask(&pdev->dev, DMA_BIT_MASK(32)) != 0) ||
> -	    (dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32)) != 0)) {
> +	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));

I wonder whether you need this call at all, because 32bit is the default.
See following

"By default, the kernel assumes that your device can address 32-bits
of DMA addressing."

in https://www.kernel.org/doc/Documentation/DMA-API-HOWTO.txt

> +	if (err) {
>  		dev_err(&pdev->dev, "No usable DMA configuration,aborting\n");
>  		goto err_dma;
>  	}
> 

