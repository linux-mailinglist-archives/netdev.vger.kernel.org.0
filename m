Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F6364107F
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 23:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbiLBWUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 17:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbiLBWUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 17:20:20 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DB3E8E1F
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 14:20:19 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id s16so2664834iln.4
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 14:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XbwRRbO5HZ0texwF0dw1j20ewkIulyg4TI01mh2rWro=;
        b=UnWWPkF2gG/H6UzceaTgRb3H4v/Sj333aGQxNdrY4fxU0neTBgS3ZijUOjusHqlUcx
         PRzFvPo6moBkGak0jupft9RW6lA+neAII1uIsya4wAStFRHJYdb2YdjUkoWbiXHDnTla
         NwgISB3mGIgyfXTKM2/j46dinSLTPjsIIhyus=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XbwRRbO5HZ0texwF0dw1j20ewkIulyg4TI01mh2rWro=;
        b=OxBy5tftUZDM3/5sKt+5TyXfs6G53r+XomuvLidqxifyDSvOqG1z74HmrKQhSAsDqq
         K9dBkEaCDXpX8b7b63iQDbbKFWMPAU/98uZUHxeG0nWNY1q1+/pYO0VoARqJcgrVtXlf
         ts0DTyGCqUASx82KK/Zi5Q++KEP/WGWvQ+hWNNDhf/XCZu8TknTacIi518cU3jy/mLd8
         7c+NT/auTEaWJypZZV/waUPjL0Q+TzrGB4Ck8AQ8BRyC7v2BOqCmxGT5Lc620Kbp+CIg
         mbmhEX5EVLa+qT7tDeh7Toc8kn1WP1pu5NDOCPsafSlpP9fQOtw+o88JIyLYX/Cyg09b
         GUsQ==
X-Gm-Message-State: ANoB5pkb7qMrhkn4IHeIFRaWQPgifDQvERgHTcBn/Dhds72V2I4VJgae
        le6UQ1W46n4ShEewuKr5kl/tEQ==
X-Google-Smtp-Source: AA0mqf7OvUqnk6aSmqTB+dIl8bs8dlsLWuzc24wNmTgp6rltz6BAC/fLnhVBabmRTetHJPoniu7Itg==
X-Received: by 2002:a92:c5c5:0:b0:303:1215:ea9d with SMTP id s5-20020a92c5c5000000b003031215ea9dmr12824454ilt.242.1670019618260;
        Fri, 02 Dec 2022 14:20:18 -0800 (PST)
Received: from [172.22.22.4] ([98.61.227.136])
        by smtp.googlemail.com with ESMTPSA id cn23-20020a0566383a1700b00374bf3b62a0sm3099678jab.99.2022.12.02.14.20.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 14:20:17 -0800 (PST)
Message-ID: <ff01f296-f3bb-4fdf-d57f-8dd14f1b61d2@ieee.org>
Date:   Fri, 2 Dec 2022 16:20:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] net: ipa: use sysfs_emit() to instead of scnprintf()
Content-Language: en-US
To:     ye.xingchen@zte.com.cn, davem@davemloft.net
Cc:     elder@kernel.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <202212021642142044742@zte.com.cn>
From:   Alex Elder <elder@ieee.org>
In-Reply-To: <202212021642142044742@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/2/22 2:42 AM, ye.xingchen@zte.com.cn wrote:
> From: ye xingchen <ye.xingchen@zte.com.cn>
> 
> Follow the advice of the Documentation/filesystems/sysfs.rst and show()
> should only use sysfs_emit() or sysfs_emit_at() when formatting the
> value to be returned to user space.

The buffer passed is non-null and the existing code properly
limits the buffer to PAGE_SIZE.

But... OK.

Reviewed-by: Alex Elder <elder@linaro.org>

> 
> Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
> ---
>   drivers/net/ipa/ipa_sysfs.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa_sysfs.c b/drivers/net/ipa/ipa_sysfs.c
> index 5cbc15a971f9..14bd2f903045 100644
> --- a/drivers/net/ipa/ipa_sysfs.c
> +++ b/drivers/net/ipa/ipa_sysfs.c
> @@ -46,7 +46,7 @@ version_show(struct device *dev, struct device_attribute *attr, char *buf)
>   {
>   	struct ipa *ipa = dev_get_drvdata(dev);
> 
> -	return scnprintf(buf, PAGE_SIZE, "%s\n", ipa_version_string(ipa));
> +	return sysfs_emit(buf, "%s\n", ipa_version_string(ipa));
>   }
> 
>   static DEVICE_ATTR_RO(version);
> @@ -70,7 +70,7 @@ static ssize_t rx_offload_show(struct device *dev,
>   {
>   	struct ipa *ipa = dev_get_drvdata(dev);
> 
> -	return scnprintf(buf, PAGE_SIZE, "%s\n", ipa_offload_string(ipa));
> +	return sysfs_emit(buf, "%s\n", ipa_offload_string(ipa));
>   }
> 
>   static DEVICE_ATTR_RO(rx_offload);
> @@ -80,7 +80,7 @@ static ssize_t tx_offload_show(struct device *dev,
>   {
>   	struct ipa *ipa = dev_get_drvdata(dev);
> 
> -	return scnprintf(buf, PAGE_SIZE, "%s\n", ipa_offload_string(ipa));
> +	return sysfs_emit(buf, "%s\n", ipa_offload_string(ipa));
>   }
> 
>   static DEVICE_ATTR_RO(tx_offload);

