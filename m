Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01855EEEF3
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbiI2H0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234536AbiI2H0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:26:42 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C447212C691
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:26:41 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id h3so591662lja.1
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=0QojmCv3XyXLKahc21RdevQ8wm/OGlW2KEduxpTikTs=;
        b=wj/ZggVGLQtSixwm02m62S1QU56czuifNAbMW0uaoSWTSgIY88zBE7WzHbcVHxE7sA
         2FAIWDeeIHOV+PFJipkXix2JHOJBwaywfwqkgtDrxQHoyUyLGT1kXMdFNL6m6/p9FiwO
         aZLSEQRKIH0BMN2E+0ILif3JZ2DNBYFzPrarDo5Tv3BmNFHXcYqrjhGB1rhRlhNWnkJu
         u8rBPdYmiP4ZpErdmSQ+4pTzGUgs/Uy27Y/s++DCn/wFhqHE+usYbSM9XHX63/JrcVWl
         uuwqCPhM6BceXJZf06e/t2+LuO/g2jp/dr23oBT8jKV1tHZ5xQ7g813HW+Aokwe/p1rO
         eaXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=0QojmCv3XyXLKahc21RdevQ8wm/OGlW2KEduxpTikTs=;
        b=wwhwUls8CNaV99gvmUz7MyXTTXioyemfRTFEMwXCD2ei9NMT5+HlpPQQeUjIC8sX8z
         7xjz0wrgU+tiskoa2vQfi+oMxPyhaioIZl1ZZPVHUtNiqUPuAJXOywGG5wHVbaNl43sp
         LLF2i5UoDg4b24zH0li6rNgE98pKmht4NuYdGSRN0C9FeFqj6/jiLIPPBPoHWQ36PqTW
         BtpqDt7uZw/j3iARM8Hb4l+DCl8D+LsZ+Bo618DsVjF3fCz71sSTtuWASmcRsZBG5QrR
         X+H6xr1+OlOypxaVr3+iS47FxFR4O9uiSOU1iPftDDIpDYolUpPutudTX1B5tYf5AQOH
         hZNw==
X-Gm-Message-State: ACrzQf3gRXloNejJQU600Cn+L8LUX3FsrQ05g0av267LveN3aLneDuKr
        p6OSpjQ64A1bTTpDSxUV1Evokw==
X-Google-Smtp-Source: AMsMyM7bMSu6MsJnPv+Ov3YJTIFzSVfDQHgLZ3onZn0YpYET5Phht0XophDhqVt78myNxyQcu5j9yw==
X-Received: by 2002:a2e:9bcf:0:b0:26c:5a9d:531f with SMTP id w15-20020a2e9bcf000000b0026c5a9d531fmr610851ljj.144.1664436399972;
        Thu, 29 Sep 2022 00:26:39 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id g5-20020a2eb5c5000000b0026bfc8d4bbbsm632153ljn.125.2022.09.29.00.26.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 00:26:39 -0700 (PDT)
Message-ID: <f0982b75-ede3-cc56-1160-8fda0faae356@linaro.org>
Date:   Thu, 29 Sep 2022 09:26:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH net-next 1/2] nfc: s3fwrn5: fix order of freeing resources
Content-Language: en-US
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220929050426.955139-1-dmitry.torokhov@gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220929050426.955139-1-dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/09/2022 07:04, Dmitry Torokhov wrote:
> Caution needs to be exercised when mixing together regular and managed
> resources. In case of this driver devm_request_threaded_irq() should
> not be used, because it will result in the interrupt being freed too
> late, and there being a chance that it fires up at an inopportune
> moment and reference already freed data structures.

Non-devm was so far recommended only for IRQF_SHARED, not for regular
ones. Otherwise you have to fix half of Linux kernel drivers... why is
s3fwrn5 special?

Please use scripts/get_maintainers.pl to Cc also netdev folks.

> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/nfc/s3fwrn5/i2c.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
Best regards,
Krzysztof

