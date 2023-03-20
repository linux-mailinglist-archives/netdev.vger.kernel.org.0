Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D9B6C2210
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 20:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbjCTT6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 15:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjCTT6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 15:58:13 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A422211F;
        Mon, 20 Mar 2023 12:58:05 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id r5so14640233qtp.4;
        Mon, 20 Mar 2023 12:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679342284;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TGnI0RGnU2ls6PagCH9hokSMfn9Gk7J24Ud+r6p+d30=;
        b=ODwC5TdTRL/j2RFGh8/aYdJYTbh9WuHfyLxFn772z6p7g+TaS5CwCRgPSn25XgepUd
         yjKy0XhPBwI5x3Djl3Py/rQOMJEwiTYVk9cmXdadk49sr/7AXrov8b46cZfJ1j6z29oY
         fEG+HSK1xxGqg/pazIq4OPk+mGarEsupfKh+YW8HweVL+3DJSCVLcVWgllCvocfDMpZz
         qm7zLijcXCpcQIMGwMjG3Knh2tRRRnL9OVSlA1P/3cUxoFTj5OTeuN6YK16ZIdcm087r
         1Ud2fhojqRUsqispFo2K23yHzsUIluzVCUsGwhBtvA2XKrtS6UA51rt2S8rut2NrWvVi
         g0Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679342284;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TGnI0RGnU2ls6PagCH9hokSMfn9Gk7J24Ud+r6p+d30=;
        b=0+95c1WYrWTIN24AvsTakquA34ETCimJGbKPYkDS5aJkAFcB0Fu8l/R5QEDX4cAYM+
         XycjvEILcrtk82BFPsDVK67IV42SbcsOk8ZoDd2Ok1od3FIPibxI1+3UjLpRay4ksrr1
         EXcdIo0JumEO7RYAh/q9amHNb8W2qHDdo0rRbWuDvilvyuaJvkmN+5EDv4oDCPybsgau
         +F3drUFeTLt0JS/Qs27l3Z0Siqd9dn+ZO3bqHZayFAC4r1BfyoZUheF4J/W+RSplehpT
         6qI3xdmFLTnASHwlRHSP6qWnd6UZ/0xKddHjnOZIMFqWe91scKxhulCCQD4FfofzaeBN
         jB3g==
X-Gm-Message-State: AO0yUKWlk1PAQxAuGqLvAq9/ySOP+ajvIM54aZuUU0+gXcpLyF71VAyG
        cJJVuIPb5LcyYvjidMxRGAo=
X-Google-Smtp-Source: AK7set/+aZthoyWWOP55PKwaHSoV0LjqI0oDcTGY38QA46K7O7fFjD+m8G/9oxV7atM2jFXlY7sb9g==
X-Received: by 2002:ac8:4e4e:0:b0:3bf:d0d2:142d with SMTP id e14-20020ac84e4e000000b003bfd0d2142dmr623958qtw.24.1679342284454;
        Mon, 20 Mar 2023 12:58:04 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r14-20020ac867ce000000b003c034837d8fsm6918286qtp.33.2023.03.20.12.57.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 12:57:59 -0700 (PDT)
Message-ID: <f2bdb314-b795-9ea3-4c1c-62b52aac031b@gmail.com>
Date:   Mon, 20 Mar 2023 12:57:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 3/4] net: dsa: b53: mmap: allow passing a chip ID
Content-Language: en-US
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        andrew@lunn.ch, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230320155024.164523-1-noltari@gmail.com>
 <20230320155024.164523-4-noltari@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230320155024.164523-4-noltari@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/20/23 08:50, Álvaro Fernández Rojas wrote:
> BCM63268 SoCs require a special handling for their RGMIIs, so we should be
> able to identify them as a special BCM63xx switch.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> ---
>   drivers/net/dsa/b53/b53_mmap.c | 32 +++++++++++++++++++++++---------
>   drivers/net/dsa/b53/b53_priv.h |  9 ++++++++-
>   2 files changed, 31 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
> index 464c77e10f60..706df04b6cee 100644
> --- a/drivers/net/dsa/b53/b53_mmap.c
> +++ b/drivers/net/dsa/b53/b53_mmap.c
> @@ -248,7 +248,7 @@ static int b53_mmap_probe_of(struct platform_device *pdev,
>   		return -ENOMEM;
>   
>   	pdata->regs = mem;
> -	pdata->chip_id = BCM63XX_DEVICE_ID;
> +	pdata->chip_id = (u32)device_get_match_data(dev);
>   	pdata->big_endian = of_property_read_bool(np, "big-endian");
>   
>   	of_ports = of_get_child_by_name(np, "ports");
> @@ -330,14 +330,28 @@ static void b53_mmap_shutdown(struct platform_device *pdev)
>   }
>   
>   static const struct of_device_id b53_mmap_of_table[] = {
> -	{ .compatible = "brcm,bcm3384-switch" },
> -	{ .compatible = "brcm,bcm6318-switch" },
> -	{ .compatible = "brcm,bcm6328-switch" },
> -	{ .compatible = "brcm,bcm6362-switch" },
> -	{ .compatible = "brcm,bcm6368-switch" },
> -	{ .compatible = "brcm,bcm63268-switch" },
> -	{ .compatible = "brcm,bcm63xx-switch" },
> -	{ /* sentinel */ },
> +	{
> +		.compatible = "brcm,bcm3384-switch",
> +		.data = (void *)BCM63XX_DEVICE_ID,
> +	}, {
> +		.compatible = "brcm,bcm6318-switch",
> +		.data = (void *)BCM63XX_DEVICE_ID,

You will want to also pass BCM63268_DEVICE_ID here, see my comment in 
patch 4.
-- 
Florian

