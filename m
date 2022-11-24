Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37133637321
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 08:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiKXHxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 02:53:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiKXHxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 02:53:06 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289EB8D48E;
        Wed, 23 Nov 2022 23:53:03 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id g12so1368747lfh.3;
        Wed, 23 Nov 2022 23:53:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ECjtCwFK8AKreBAAxlUKM9FsJ3BgsuoUjjzjmNTBDC0=;
        b=HHZTpNla/L/+yqMDzKQOkn8YDQQpbbLVkIdHEyKg1/mjjMX5krc1sK3IcNQxFZoK5o
         2JFGyHdOCElQeltInVStrUw0wTSlXUv4GjdbCiNDR0YIWXSzoJaj0Z+yuuBOCfbsa0Kw
         B0mw81hdpvcDbXEwSA+aaXDtfW/+yBW5YBQl1Tt6piBo+tqVk7llgps485pHU7sanMnU
         pLgw2RAKo9YFykom11Vwi48H35qZsIbROrvfWb19up5lxT6bsTzxrcIxBThDyNNwxjq/
         +Ftt/GWNPA0S4CFtNZfq2LWLrfiLH4zaqVjvLHqmktFYxfdVvXNq3DWb+yUwcc485ev3
         iaeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ECjtCwFK8AKreBAAxlUKM9FsJ3BgsuoUjjzjmNTBDC0=;
        b=zCpFX6B0Q4UL1xXnYo+F0fkO+QJHCjFjcYKpVKbCE2aghRrqPeEVZnBuYtRR3VxDwT
         U2QE92UVsyAEdmXYx5C+UZVjO0zNxWxQCTjLurxRa2YjZA3pH4b/eBdj2ii2Ru8735N0
         Ca1HYDrG+DSVtoNXQ4j2mdHmGwQHv2tPy3wHTmcqvfqClU0YcJZVI5HitZjhUwCa4lsd
         9fwuhYSHnA3+u+edfaqHzrIuyoMTR5DCLL1cs5gnIKy6dXo0tnCovaJ1lFIaT9a/Wrp9
         aDvwbkEhs0+B+U0JQwkyvxDlDlhz0g92anBVXdekcDbh/cdBWG4c//KSduO1qwNbf0+T
         BR4Q==
X-Gm-Message-State: ANoB5pnOchsW8VGz26VuJlAcXFoir/JNAbel9LZ7uyT3Z79OsPyvL+2x
        iNTMwGFFzPr0U9ZtaTU73eo=
X-Google-Smtp-Source: AA0mqf6NqRgy2OhgU00e4xP+vqQ9+HMPjtvDVeIq9b271UlSEpQvJG7qPKtNyBOgz2PNDBGmutMbYA==
X-Received: by 2002:a05:6512:31d1:b0:4ae:6bbc:e8af with SMTP id j17-20020a05651231d100b004ae6bbce8afmr6500765lfe.411.1669276381375;
        Wed, 23 Nov 2022 23:53:01 -0800 (PST)
Received: from ?IPV6:2001:999:485:946b:e412:ce24:16c6:ba10? ([2001:999:485:946b:e412:ce24:16c6:ba10])
        by smtp.gmail.com with ESMTPSA id v26-20020ac258fa000000b004b0b2212315sm43472lfo.121.2022.11.23.23.52.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Nov 2022 23:53:00 -0800 (PST)
Message-ID: <7775f7ff-b297-eeab-dd46-e7ac5e1c14fb@gmail.com>
Date:   Thu, 24 Nov 2022 09:54:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
To:     Nicolas Frayer <nfrayer@baylibre.com>, nm@ti.com,
        ssantosh@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, vkoul@kernel.org,
        dmaengine@vger.kernel.org, grygorii.strashko@ti.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     khilman@baylibre.com, glaroque@baylibre.com
References: <20221108181144.433087-1-nfrayer@baylibre.com>
 <20221108181144.433087-3-nfrayer@baylibre.com>
Content-Language: en-US
From:   =?UTF-8?Q?P=c3=a9ter_Ujfalusi?= <peter.ujfalusi@gmail.com>
Subject: Re: [PATCH v4 2/4] soc: ti: Add module build support
In-Reply-To: <20221108181144.433087-3-nfrayer@baylibre.com>
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



On 08/11/2022 20:11, Nicolas Frayer wrote:
> Added module build support for the TI K3 SoC info driver.

Subject: "soc: ti: k3-socinfo: ..."

> 
> Signed-off-by: Nicolas Frayer <nfrayer@baylibre.com>
> ---
>   arch/arm64/Kconfig.platforms |  1 -
>   drivers/soc/ti/Kconfig       |  3 ++-
>   drivers/soc/ti/k3-socinfo.c  | 11 +++++++++++
>   3 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig.platforms b/arch/arm64/Kconfig.platforms
> index 76580b932e44..4f2f92eb499f 100644
> --- a/arch/arm64/Kconfig.platforms
> +++ b/arch/arm64/Kconfig.platforms
> @@ -130,7 +130,6 @@ config ARCH_K3
>   	select TI_SCI_PROTOCOL
>   	select TI_SCI_INTR_IRQCHIP
>   	select TI_SCI_INTA_IRQCHIP
> -	select TI_K3_SOCINFO
>   	help
>   	  This enables support for Texas Instruments' K3 multicore SoC
>   	  architecture.
> diff --git a/drivers/soc/ti/Kconfig b/drivers/soc/ti/Kconfig
> index 7e2fb1c16af1..1a730c057cce 100644
> --- a/drivers/soc/ti/Kconfig
> +++ b/drivers/soc/ti/Kconfig
> @@ -74,7 +74,8 @@ config TI_K3_RINGACC
>   	  If unsure, say N.
>   
>   config TI_K3_SOCINFO
> -	bool
> +	tristate "TI K3 SoC info driver"
> +	default y

Why it is a good thing to have this driver as module compared to always 
built in?
It has no dependencies, just things depending on it.
It is small, just couple of lines long

I don't really see the benefit of building it as a module, not even an 
academic one...


>   	depends on ARCH_K3 || COMPILE_TEST
>   	select SOC_BUS
>   	select MFD_SYSCON
> diff --git a/drivers/soc/ti/k3-socinfo.c b/drivers/soc/ti/k3-socinfo.c
> index 19f3e74f5376..98348f998e0f 100644
> --- a/drivers/soc/ti/k3-socinfo.c
> +++ b/drivers/soc/ti/k3-socinfo.c
> @@ -13,6 +13,7 @@
>   #include <linux/slab.h>
>   #include <linux/string.h>
>   #include <linux/sys_soc.h>
> +#include <linux/module.h>
>   
>   #define CTRLMMR_WKUP_JTAGID_REG		0
>   /*
> @@ -141,6 +142,7 @@ static const struct of_device_id k3_chipinfo_of_match[] = {
>   	{ .compatible = "ti,am654-chipid", },
>   	{ /* sentinel */ },
>   };
> +MODULE_DEVICE_TABLE(of, k3_chipinfo_of_match);
>   
>   static struct platform_driver k3_chipinfo_driver = {
>   	.driver = {
> @@ -156,3 +158,12 @@ static int __init k3_chipinfo_init(void)
>   	return platform_driver_register(&k3_chipinfo_driver);
>   }
>   subsys_initcall(k3_chipinfo_init);

subsys_initcall for a module?

> +
> +static void __exit k3_chipinfo_exit(void)
> +{
> +	platform_driver_unregister(&k3_chipinfo_driver);
> +}
> +module_exit(k3_chipinfo_exit);
> +
> +MODULE_DESCRIPTION("TI K3 SoC info driver");
> +MODULE_LICENSE("GPL");

-- 
Péter
