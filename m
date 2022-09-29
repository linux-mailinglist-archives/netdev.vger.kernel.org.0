Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CA05EEF71
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235476AbiI2Hmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235357AbiI2HmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:42:21 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23BB13A06E
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:42:11 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id j16so1017832lfg.1
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=kXmjrEaLlec7+gdoCuLabMghz8f21Tz9CFZIlFPg0Qo=;
        b=dI/7FVNx0lYahIDhTsowid/xFSehN616UCnRe2mV4g0RRXOBhjPX29eGBlYr2OD5NW
         l6IE/cbEeXEJiUv4eGnha4zDNsJ9rvdkOcxXo3doqlz8NGHCBWb0UGQuTNAae4PF1eRx
         FiZrc45v7ZE2jrvtJTI/XXpm54JCuFWzP+wKJrvZgSyptapLzln9fEeZm+qStiWs48vH
         m1xoMkqH/55iZHAtqGtAaFc9b7BazTDMKdh26iMKjHXYZ88A5d8wKJvMWK4wFBF6MlOm
         b6U6PCK5ajY4re5eiMHM8DsxZTnbedzGKC4jQ4ayds+Qn6uXDJTaIx17o/Ti6ERUa63r
         +EqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=kXmjrEaLlec7+gdoCuLabMghz8f21Tz9CFZIlFPg0Qo=;
        b=JQHtiqnCCXpuEmza3sxHZsvEgDzAaz26PCK4tEJ9C3nSFpvEUoIJds7P27BGu4GF2b
         4Jbo3byD+mfE4VnTfMheU6YLkrHySZarg5dmd1ispjW9zvescRWAMGuxYhNLDRvvWN3n
         WRARJxUDz+rhwWNPpvZ8afiXrsxsC/16WtTQX6BAIjHG9k5tu7B+nCOLO2D4O1Ri9pu5
         kaoW6h7NzbvH5WOj2S7ZsgoQqS/gG8e7vjoUxSp8PF8ZIAfnOGYoF3di6kJj9nHec4U6
         LiwnPuBHwQYRKLqWkR/kdGRYghmAAl9ow92n5v9qlmBAC/I78ZduDfu1KCH/B/pWo44S
         rW2w==
X-Gm-Message-State: ACrzQf1XmrnQP99G6Ha+MjgdCQ//EIgkCJd9WkaneW52RqMRd7DeA7CC
        BtIca0Ax0qc3UPODxsD39qUmZw==
X-Google-Smtp-Source: AMsMyM70EePOHmDIEssJp2wfplCnqghvpyBPntj6tkSU9ZJ5Ug6bzEipuEa63KEVcVoxoLMRyBJHTA==
X-Received: by 2002:a05:6512:2586:b0:4a0:54f2:772e with SMTP id bf6-20020a056512258600b004a054f2772emr796758lfb.663.1664437329639;
        Thu, 29 Sep 2022 00:42:09 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id n13-20020a05651203ed00b004978e51b691sm709115lfq.266.2022.09.29.00.42.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 00:42:09 -0700 (PDT)
Message-ID: <1b81d1ec-3050-b983-654b-52c955091274@linaro.org>
Date:   Thu, 29 Sep 2022 09:42:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH net-next 1/2] nfc: s3fwrn5: fix order of freeing resources
Content-Language: en-US
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220929050426.955139-1-dmitry.torokhov@gmail.com>
 <f0982b75-ede3-cc56-1160-8fda0faae356@linaro.org>
 <26fd03ad-181c-97c5-f620-6ac296cf1829@linaro.org>
 <36AC4067-78C6-4986-8B97-591F93E266D8@gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <36AC4067-78C6-4986-8B97-591F93E266D8@gmail.com>
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

On 29/09/2022 09:37, Dmitry Torokhov wrote:
> On September 29, 2022 12:27:19 AM PDT, Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> wrote:
>> On 29/09/2022 09:26, Krzysztof Kozlowski wrote:
>>> On 29/09/2022 07:04, Dmitry Torokhov wrote:
>>>> Caution needs to be exercised when mixing together regular and managed
>>>> resources. In case of this driver devm_request_threaded_irq() should
>>>> not be used, because it will result in the interrupt being freed too
>>>> late, and there being a chance that it fires up at an inopportune
>>>> moment and reference already freed data structures.
>>>
>>> Non-devm was so far recommended only for IRQF_SHARED, not for regular
>>> ones.
> 
> If we are absolutely sure there is no possibility of interrupts firing then devm
> should be ok, but it is much safer not to use it. Or use custom devm actions
> to free non-managed resources.

I am not sure and the pattern itself is a bit risky, I agree. However
the driver calls s3fwrn5_remove() which then calls
s3fwrn5_phy_power_ctrl() which cuts the power via GPIO pin. I assume
that the hardware should stop generating interrupts at this point.

> 
>>> Otherwise you have to fix half of Linux kernel drivers... 
> 
> Yes, if they are doing the wrong thing.

What I meant, that this pattern appears pretty often. If we agree that
this driver has a risky pattern (hardware might not be off after
remove() callback), then we should maybe document it somewhere and
include it in usual reviews.

Best regards,
Krzysztof

