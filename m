Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 761F357BF49
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 22:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiGTUjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 16:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiGTUjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 16:39:07 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFAF222BD8;
        Wed, 20 Jul 2022 13:39:06 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id j70so12298766oih.10;
        Wed, 20 Jul 2022 13:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vYo+qaCAy2kmd+JZb7RtHEZUur+lwWu46ajHEuV1OqQ=;
        b=Cms7tZx/N8hxMKc1LO+wj2XK+KfkW1Gs9MVfISeLG0g276h3NoQFWxauM+uGYUYFu7
         1xU/Ca/zZLaN9p8fD1x08wlfZE+9siFYDEiRLQalx/wEOyEu1SFcAy1CXJJvcw8hfNaj
         2xJn4g5slvN+A3TxN53vVbk7/cT/+0Tdi0drQQIEWWL9LZgAYP/qKF3I4QFsjFVsDQvR
         KuSWTxCuLFdSiuOmd0AacGgQ/HUIbhYCqVIXLLG4H73OzAENECDtj/NsnazLw2rQgvcg
         nTblqI5VVZprYEqf4jzI42sl6xv9/vXl6Q9sJFSea3B0oyrH9at6/AkYkUjxq39dN+3A
         0zRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vYo+qaCAy2kmd+JZb7RtHEZUur+lwWu46ajHEuV1OqQ=;
        b=3v2ShkPjeR3hdUqiNKOSBzCd+pe0tM3LjmHBlefctgaDOIb07vrhkqexn7S4+Q2XcJ
         LkawtSqzK+vOZ/jeuL+Zx608ZcHhQlA4PgpNxu+72X3/QrB7NndNIFRzi+tF0kH76Eq1
         d9GHm8bydfOtHfedoFM8yNsEf28beVetJA3Tzg/4HU4Re6TLxV+wEHwMlsdtHOv3RlUn
         dDv/bb39Ru35yFVE+8fRwvRK7RTQOIC5iiGY7V6XyRgBHuifiWx0sNbDn0hz0UqGwisb
         rN4GF5uaqiKXctyxbwqAzNFQhknU693k5cwTLpc/07Jf+4o8+DYAPIvcAf3cWOt2sxQu
         691g==
X-Gm-Message-State: AJIora+ybXcPSk1DXVkNEooDZXu+GLQP/nZF7LLz1hXGnPa9DPdAsdvi
        LYNAaHBqS5gZzFmNl5WY/14=
X-Google-Smtp-Source: AGRyM1sgnAiJ8RYTiJen6TAfK7Sz31x/EYjbsspnQiUv2MhSTyTWZArmOJb0pp8O3A/wRYL3YPQKyQ==
X-Received: by 2002:a05:6808:d48:b0:339:b862:3abb with SMTP id w8-20020a0568080d4800b00339b8623abbmr3391898oik.22.1658349546228;
        Wed, 20 Jul 2022 13:39:06 -0700 (PDT)
Received: from [10.62.118.143] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id q204-20020aca43d5000000b003351fa55a58sm6895269oia.16.2022.07.20.13.39.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 13:39:05 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <741dc563-4702-2004-4be0-01a578524747@lwfinger.net>
Date:   Wed, 20 Jul 2022 15:39:03 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] b43:do not initialise statics to 0.
Content-Language: en-US
To:     Xin Gao <gaoxin@cdjrlc.com>, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220720194245.8442-1-gaoxin@cdjrlc.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20220720194245.8442-1-gaoxin@cdjrlc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/20/22 14:42, Xin Gao wrote:
> do not initialise statics to 0.
> 
> Signed-off-by: Xin Gao <gaoxin@cdjrlc.com>
> ---
>   drivers/net/wireless/broadcom/b43/main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
> index 17bcec5f3ff7..5e233d0e06c0 100644
> --- a/drivers/net/wireless/broadcom/b43/main.c
> +++ b/drivers/net/wireless/broadcom/b43/main.c
> @@ -105,7 +105,7 @@ int b43_modparam_verbose = B43_VERBOSITY_DEFAULT;
>   module_param_named(verbose, b43_modparam_verbose, int, 0644);
>   MODULE_PARM_DESC(verbose, "Log message verbosity: 0=error, 1=warn, 2=info(default), 3=debug");
>   
> -static int b43_modparam_pio = 0;
> +static int b43_modparam_pio;
>   module_param_named(pio, b43_modparam_pio, int, 0644);
>   MODULE_PARM_DESC(pio, "Use PIO accesses by default: 0=DMA, 1=PIO");

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks.

Larry


