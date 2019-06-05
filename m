Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC22035691
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 08:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfFEGDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 02:03:45 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40143 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbfFEGDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 02:03:45 -0400
Received: by mail-wr1-f67.google.com with SMTP id p11so13273301wre.7;
        Tue, 04 Jun 2019 23:03:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=kmi7s/cfadEQaPuszzFg2P7DZ7ZEaobVt6Q8JtUSPhA=;
        b=spFbJqhYCz+c6JyzyFM08M14I2mVBwvWs8x5NMj6HOIKHn7IB39Ly1zDUcrezHY9ls
         DVYH9M2V87YMtXSnKEvrkQmo/ZX4Tr6cNtKhsDlCWTfYnP0/UTeNYUHLMgozKxptqUKJ
         uJD8zqsL60JiC5pBXW92JmIi1s0wKI4511ltI6x+4HKG63TdSpQJVn4QuHtL8sbEzNPs
         yg8X0s1YcSeHwmdyor6wgecMRAhtgr4QFE93XakTGePtvxotccZL5IZEo6H4iULuIxSa
         lfPgz2l05ed/n6D0WvWBIKntohl75fNpFBADpxvhG/FjCNw2XQ+NK+jLPGHbin7lIuhC
         +vIw==
X-Gm-Message-State: APjAAAUsLJhKBc6GznoArY8pRQkoa5Vcn2GWflGxzzF/8pL4YRuwCnBQ
        dsSB+NoycXO7/ShfWhqSdGndTa9k
X-Google-Smtp-Source: APXvYqwdIzguPpm1CTWizrwfCtGYFPjAAS2cF4w/4qNA7DBbYHtADvd9DLvrI/JDJ8Kvb/hZ1Vpp7w==
X-Received: by 2002:a5d:684c:: with SMTP id o12mr10280599wrw.305.1559714622475;
        Tue, 04 Jun 2019 23:03:42 -0700 (PDT)
Received: from ?IPv6:2a0b:e7c0:0:107::49? ([2a0b:e7c0:0:107::49])
        by smtp.gmail.com with ESMTPSA id n4sm17590227wrp.61.2019.06.04.23.03.41
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 23:03:41 -0700 (PDT)
Subject: Re: [PATCH v2] sdio: Fix a memory leaking bug in wl1271_probe()
To:     Gen Zhang <blackgod016574@gmail.com>, kvalo@codeaurora.org,
        eyalreizer@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190523144425.GA26766@zhanggen-UX430UQ>
From:   Jiri Slaby <jslaby@suse.cz>
Openpgp: preference=signencrypt
Autocrypt: addr=jslaby@suse.cz; prefer-encrypt=mutual; keydata=
 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
Message-ID: <c09bbf1a-61eb-0ead-99ac-f92498a547a5@suse.cz>
Date:   Wed, 5 Jun 2019 08:03:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523144425.GA26766@zhanggen-UX430UQ>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23. 05. 19, 16:44, Gen Zhang wrote:
> In wl1271_probe(), 'glue->core' is allocated by platform_device_alloc(),
> when this allocation fails, ENOMEM is returned. However, 'pdev_data'
> and 'glue' are allocated by devm_kzalloc() before 'glue->core'. When
> platform_device_alloc() returns NULL, we should also free 'pdev_data'
> and 'glue' before wl1271_probe() ends to prevent leaking memory.
> 
> Similarly, we should free 'pdev_data' when 'glue' is NULL. And we
> should free 'pdev_data' and 'glue' when 'ret' is error.
> 
> Further, we shoulf free 'glue->dev', 'pdev_data' and 'glue' when this
> function normally ends to prevent memory leaking.
> 
> Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
> ---
> diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
> index 4d4b0770..232ce5f 100644
> --- a/drivers/net/wireless/ti/wlcore/sdio.c
> +++ b/drivers/net/wireless/ti/wlcore/sdio.c
...
> @@ -380,11 +382,20 @@ static int wl1271_probe(struct sdio_func *func,
>  		dev_err(glue->dev, "can't add platform device\n");
>  		goto out_dev_put;
>  	}
> +	platform_device_put(glue->core);
> +	devm_kfree(&func->dev, glue);
> +	devm_kfree(&func->dev, pdev_data);
>  	return 0;
>  
>  out_dev_put:
>  	platform_device_put(glue->core);
>  
> +out_free2:
> +	devm_kfree(&func->dev, glue);
> +
> +out_free1:
> +	devm_kfree(&func->dev, pdev_data);

Are you aware of purpose of devm allocations?

thanks,
-- 
js
suse labs
