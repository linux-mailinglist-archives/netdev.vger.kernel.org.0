Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEB6445230
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 12:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhKDLbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 07:31:40 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:52420
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229705AbhKDLbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 07:31:39 -0400
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com [209.85.167.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id A681B3F1F6
        for <netdev@vger.kernel.org>; Thu,  4 Nov 2021 11:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1636025340;
        bh=NpUBP66UVdunnGSJXrV9MYZkv3lMfmqOm8B19Xoiuvk=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=G+9T6zBxl0AiuYT6L3DzYPttzZixNcK73U8OOs77HQFuqR2IcDB3HIxdv8s165ixT
         SU90McAVKQZLHB4ouJxU3HgA3LKat91ZO2tG68iUaNXUVkabk9oQqqy+h6XXo5EQw/
         iQDbK2rJXMVswEYtnvVeXVUAO+n+eJBfFtZkyk+7pBqAKPrQRWNBUPDI2WSzSjsEKE
         GDDEtwTiwLJ0fFXp2JG/acboPBny/mIh+HG98ind+d9PlmnvtEBshMr7moVPdn1aym
         OYazu66sA7iZZqpbSGSnLSqgpSTNKKXFPIYpOftJFFvLi4jTZUuQ9skgqAZw5EBuom
         UuyFTSqjauaNQ==
Received: by mail-lf1-f69.google.com with SMTP id s18-20020ac25c52000000b004016bab6a12so1818576lfp.21
        for <netdev@vger.kernel.org>; Thu, 04 Nov 2021 04:29:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NpUBP66UVdunnGSJXrV9MYZkv3lMfmqOm8B19Xoiuvk=;
        b=7HucQzbl3zqpq9ISxXCGIzZFwRH/JODNXT4L7jWE0mlNI/xVgYgHJ6gtACHv5fo0zD
         ZyFSBHDUHxsGsfBv++AD8ImuWRWzOwejWtyYhcXCSBjaHLnoxQbZ6FIyk32NrZzKkm71
         6oG5vpZHPjAyYDOHAS88lENQVPJFTtWIpQScrQmimXyIFvNcZOxrZ+kwXBt+oUvRcFEt
         EC4mzL37Bo10REVG/i0d9bEpPNg23t2fxnGAWME/mtoZ70sfjpahZs2z6IvcbbeBedTY
         RSV2xK28G9Phc71SWq2heMCTYkykO2CWe7id+0yTKa7Gvm6/PuuA2cG/JnMlzm929Rr3
         Il7Q==
X-Gm-Message-State: AOAM531H1pEBeaT0SwO0cMk1CXoMRqX/2v1TLuXGDyCcTSVUZpoyixgD
        K1egtvQqLv4OXJqkCyEqHM+r72tGpEBH7mSdvBsmAMpV84RWRIBkIHFCv9UV6ESq8xk903oXuIk
        CyQeTUJQYY2CXEqBoRs+f7ZDQcicsj9xOQA==
X-Received: by 2002:a2e:7301:: with SMTP id o1mr6662022ljc.235.1636025340117;
        Thu, 04 Nov 2021 04:29:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyeX31B6zCRIiyvHLyGOoVtci4xHbnv+GEY5H8J18mHLr+O6D7itEh3+7wiurlv+14lA6Nnpg==
X-Received: by 2002:a2e:7301:: with SMTP id o1mr6662003ljc.235.1636025339871;
        Thu, 04 Nov 2021 04:28:59 -0700 (PDT)
Received: from [192.168.3.67] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id u4sm47193lff.38.2021.11.04.04.28.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 04:28:59 -0700 (PDT)
Message-ID: <339a6580-4c03-8aeb-e790-8645b6501831@canonical.com>
Date:   Thu, 4 Nov 2021 12:28:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH] NFC: nfcmrvl: add unanchor after anchor
Content-Language: en-US
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>, yashsri421@gmail.com,
        davem@davemloft.net, rdunlap@infradead.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1636016141-3645490-1-git-send-email-jiasheng@iscas.ac.cn>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <1636016141-3645490-1-git-send-email-jiasheng@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/11/2021 09:55, Jiasheng Jiang wrote:
> In the error path, the anchored urb is unanchored.
> But in the successful path, the anchored urb is not.
> Therefore, it might be better to add unanchor().
> 
> Fixes: f26e30c ("NFC: nfcmrvl: Initial commit for Marvell NFC driver")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>  drivers/nfc/nfcmrvl/usb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nfc/nfcmrvl/usb.c b/drivers/nfc/nfcmrvl/usb.c
> index bcd563c..f8ae517 100644
> --- a/drivers/nfc/nfcmrvl/usb.c
> +++ b/drivers/nfc/nfcmrvl/usb.c
> @@ -146,9 +146,9 @@ nfcmrvl_submit_bulk_urb(struct nfcmrvl_usb_drv_data *drv_data, gfp_t mem_flags)
>  		if (err != -EPERM && err != -ENODEV)
>  			nfc_err(&drv_data->udev->dev,
>  				"urb %p submission failed (%d)\n", urb, -err);
> -		usb_unanchor_urb(urb);
>  	}
>  
> +	usb_unanchor_urb(urb);
>  	usb_free_urb(urb);
>  
>  	return err;
> 

Why only this place in the driver? And why only this driver - some
others miss it as well (e.g. btusb which was probably the template for
this one). Are you sure it is a correct patch? Did you test it?

Best regards,
Krzysztof
