Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B1037BEF8
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 15:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhELN4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 09:56:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58674 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbhELN4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 09:56:08 -0400
Received: from mail-vk1-f199.google.com ([209.85.221.199])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lgpKF-0001HB-1V
        for netdev@vger.kernel.org; Wed, 12 May 2021 13:54:59 +0000
Received: by mail-vk1-f199.google.com with SMTP id v194-20020a1f2fcb0000b02901ecbeef0648so3049950vkv.15
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 06:54:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=08/+1Aj4jEy4gK05fIKfXFMVV/kT+0I43RKPwzZata8=;
        b=Evls3TJOEam2bxg6wuDVVfE2mmlbXHovyH4NQaaXwWrLLT3hxIVSvboF2gFb3iBN1x
         gTqf+LAwbPiTiWL8pzm60ptvUYzLq5j/g4FlvjATiP534pu7jWxO+yDAzXlWKnb/+P8t
         mEeDelSteN51dfJBBt7pp5wzMjMB3VdC7kNF1iqiCe3fhYKobvGGBBdmvB2YUYdWyTAw
         AbbXBKm+lpPMiB0Z5HYIvSZFnXzzYygkoaKWNDqdvxVzMy4T7OEkzlXk6Oyald9+vVJl
         mMGqHQNb1CYU0ldchlsAi8MnXyhIaYLMGtxwgkNcmWuGabTwqXapshfDEeflj04c6f0B
         6+mQ==
X-Gm-Message-State: AOAM5330kyfUNu1OpFwWDntLhsjuSJYLKwbyLQO+E9SMMm/sf1Df1MsX
        PXgXfNykQ99Mx9O1IE/2SfDFlVPL0UWvCTeOSJpX79neED4ZcBpEN1d8jGfnKOQaO6xAM3akEeg
        +Z8EwyGoRWwuj5BQl8btfwdoZZJgP1RGatQ==
X-Received: by 2002:a05:6102:392:: with SMTP id m18mr32323885vsq.40.1620827697644;
        Wed, 12 May 2021 06:54:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrxfpUpULT3L7xt6Zj4sj9UXYXHp9f3OZeTPl+LwAsQyX6v2O/9LdvHC94imaHMxW9WYsIoQ==
X-Received: by 2002:a05:6102:392:: with SMTP id m18mr32323869vsq.40.1620827697461;
        Wed, 12 May 2021 06:54:57 -0700 (PDT)
Received: from [192.168.1.4] ([45.237.48.2])
        by smtp.gmail.com with ESMTPSA id a5sm2432668vkl.19.2021.05.12.06.54.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 06:54:56 -0700 (PDT)
Subject: Re: [linux-nfc] [PATCH] NFC: cooperation with runtime PM
To:     Oliver Neukum <oneukum@suse.com>, clement.perrochaud@effinnov.com,
        charles.gorand@effinnov.com, linux-nfc@lists.01.org,
        netdev@vger.kernel.org
References: <20210512134413.31808-1-oneukum@suse.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <0a8ca4c7-ce55-3c92-cc29-b383e546d563@canonical.com>
Date:   Wed, 12 May 2021 09:54:55 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210512134413.31808-1-oneukum@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks for the patch. Few notes:

On 12/05/2021 09:44, Oliver Neukum wrote:
> We cannot rely on the underlying hardware to do correct
> runtime PM. NFC core needs to get PM reference while
> a device is operational, lest it be suspended when
> it is supposed to be waiting for a target to come
> into range.


Your word wrapping is unusually early - please wrap the commit msg as in
coding style (so around 75-character).
https://elixir.bootlin.com/linux/latest/source/Documentation/process/submitting-patches.rst#L578

> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> ---
>  net/nfc/core.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/net/nfc/core.c b/net/nfc/core.c
> index 573c80c6ff7a..5ca4597c39c7 100644
> --- a/net/nfc/core.c
> +++ b/net/nfc/core.c
> @@ -15,6 +15,7 @@
>  #include <linux/slab.h>
>  #include <linux/rfkill.h>
>  #include <linux/nfc.h>
> +#include <linux/pm_runtime.h>
>  
>  #include <net/genetlink.h>
>  
> @@ -37,6 +38,7 @@ int nfc_fw_download(struct nfc_dev *dev, const char *firmware_name)
>  	pr_debug("%s do firmware %s\n", dev_name(&dev->dev), firmware_name);
>  
>  	device_lock(&dev->dev);
> +	pm_runtime_get_sync(&dev->dev);

This can fail. Probably you wanted pm_runtime_resume_and_get() here.

>  
>  	if (!device_is_registered(&dev->dev)) {
>  		rc = -ENODEV;
> @@ -58,7 +60,10 @@ int nfc_fw_download(struct nfc_dev *dev, const char *firmware_name)
>  	if (rc)
>  		dev->fw_download_in_progress = false;

goto error

>  
> +	device_unlock(&dev->dev);
> +	return rc;

Since last rc cannot be != 0, return 0

Blank line

>  error:
> +	pm_runtime_put(&dev->dev);
>  	device_unlock(&dev->dev);
>  	return rc;
>  }
> @@ -73,9 +78,13 @@ int nfc_fw_download(struct nfc_dev *dev, const char *firmware_name)
>  int nfc_fw_download_done(struct nfc_dev *dev, const char *firmware_name,
>  			 u32 result)
>  {
> +	int rv;

"int rc"

> +
>  	dev->fw_download_in_progress = false;
>  
> -	return nfc_genl_fw_download_done(dev, firmware_name, result);
> +	rv = nfc_genl_fw_download_done(dev, firmware_name, result);
> +	pm_runtime_put(&dev->dev);
> +	return rv;
>  }
>  EXPORT_SYMBOL(nfc_fw_download_done);
>  
> @@ -93,6 +102,7 @@ int nfc_dev_up(struct nfc_dev *dev)
>  	pr_debug("dev_name=%s\n", dev_name(&dev->dev));
>  
>  	device_lock(&dev->dev);
> +	pm_runtime_get_sync(&dev->dev);

Same comments as before.

>  
>  	if (dev->rfkill && rfkill_blocked(dev->rfkill)) {
>  		rc = -ERFKILL;
> @@ -124,7 +134,11 @@ int nfc_dev_up(struct nfc_dev *dev)
>  	if (dev->ops->discover_se && dev->ops->discover_se(dev))
>  		pr_err("SE discovery failed\n");
>  
> +	device_unlock(&dev->dev);
> +	return rc;

Probably same comments as before apply.

> +
>  error:
> +	pm_runtime_put(&dev->dev);
>  	device_unlock(&dev->dev);
>  	return rc;
>  }
> @@ -161,6 +175,9 @@ int nfc_dev_down(struct nfc_dev *dev)
>  		dev->ops->dev_down(dev);
>  
>  	dev->dev_up = false;
> +	pm_runtime_put(&dev->dev);
> +	device_unlock(&dev->dev);
> +	return rc;

return 0

>  
>  error:
>  	device_unlock(&dev->dev);
> 


Best regards,
Krzysztof
