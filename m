Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11EF06078A1
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 15:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiJUNij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 09:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiJUNie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 09:38:34 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448A02764CC
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 06:38:26 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id t16so1799509qvm.9
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 06:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KSzkkxJmt+63RR1lkwGlnOxYt96Hz8plGKgcG5hGf78=;
        b=WC1/Vaw070/6Nnw2/72p0FXGDvkc/9JDDi/PrPjA/nbPPFkSpNofj5eiWG2HegS1Iu
         EZxINnRgbYWJPxzi6N3Htly+fhPZlnnIsk/dvkpvMSci1X7chIX34vE694cH3gNODt84
         8sQNDQjRhWpYHsP3/+PnBQh41HYUwuuBCF1M0kbH5adOC8e+Ze0/smvQLB5BwQUmotee
         lBeGupjIoJYlCiKTMgF1bZGxotJWPOG5LEgfWRNe9NmW4KCPcGYrgyR3Mc5i0JOWQahy
         8el//Z5s/Axsfk14aGPP4YsVWB+V+kgBQ8bAY07hiuQKmp7nzm57YuIi0fcftOEB9WK/
         L4rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KSzkkxJmt+63RR1lkwGlnOxYt96Hz8plGKgcG5hGf78=;
        b=aCRUVvTaeBscjhkGj8DG8pK7SlpEIJK6fdtEAya4ugmb0f3n34vzuKW0yP1EqzvDws
         UvvrnBlpxnz4nIGjwDtMCrVIaU3fWl4zakA/keVo3s4MzW9leYkftJsC5KLmIsEtkWRi
         AMyuNbVSPp47buMgdp7Fm/Wc7ySXY6VuLolmkEZRoEwOcg3N9JgWqDFjbZ1DboBsiVqK
         fM6Mpyk838XYrkT96p1zDSXWhX9mvjVC1GhQPo23dEg4mP2oFd8QVY7LJZ+FJUv/V1yX
         imCS1JucH1O02XJwZ8Pzq3/VVTSWzRfg46hk7UtNK7+Tvm405wx3f7AFusKpq0MQzorY
         RWyg==
X-Gm-Message-State: ACrzQf0HkQjp+uXIRpSsH9e5CTKw1H0Qjsks+5eFR89oEiaEWwWDjd9I
        /NqN7gwh9LggU6FgToEtl4YwdQ==
X-Google-Smtp-Source: AMsMyM4FZ01IGdKeTxmwj5pLpoUJHwEmgn6/Mp8bmAqg3DRg9Qw431uomUeIF2iTpThwFCvOjuXusg==
X-Received: by 2002:a0c:ac02:0:b0:4af:a3b1:3167 with SMTP id l2-20020a0cac02000000b004afa3b13167mr16441073qvb.66.1666359505693;
        Fri, 21 Oct 2022 06:38:25 -0700 (PDT)
Received: from [192.168.10.124] (pool-72-83-177-149.washdc.east.verizon.net. [72.83.177.149])
        by smtp.gmail.com with ESMTPSA id br32-20020a05620a462000b006e9b3096482sm9522021qkb.64.2022.10.21.06.38.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Oct 2022 06:38:25 -0700 (PDT)
Message-ID: <a0353e85-8604-a268-5776-2f28b092e57b@linaro.org>
Date:   Fri, 21 Oct 2022 09:38:23 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v5 2/5] net: ipqess: introduce the Qualcomm
 IPQESS driver
Content-Language: en-US
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
References: <20221021124556.100445-1-maxime.chevallier@bootlin.com>
 <20221021124556.100445-3-maxime.chevallier@bootlin.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221021124556.100445-3-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/10/2022 08:45, Maxime Chevallier wrote:
> The Qualcomm IPQESS controller is a simple 1G Ethernet controller found
> on the IPQ4019 chip. This controller has some specificities, in that the
> IPQ4019 platform that includes that controller also has an internal
> switch, based on the QCA8K IP.

Thank you for your patch. There is something to discuss/improve.

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5c6ce094e55e..46fdd3c523c5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17037,6 +17037,12 @@ L:	netdev@vger.kernel.org
>  S:	Maintained
>  F:	drivers/net/ethernet/qualcomm/emac/
>  
> +QUALCOMM IPQESS ETHERNET DRIVER
> +M:	Maxime Chevallier <maxime.chevallier@bootlin.com>
> +L:	netdev@vger.kernel.org
> +S:	Maintained
> +F:	drivers/net/ethernet/qualcomm/ipqess/

Add also bindings.

> +
>  QUALCOMM ETHQOS ETHERNET DRIVER
>  M:	Vinod Koul <vkoul@kernel.org>
>  R:	Bhupesh Sharma <bhupesh.sharma@linaro.org>
> diff --git a/drivers/net/ethernet/qualcomm/Kconfig b/drivers/net/ethernet/qualcomm/Kconfig
> index a4434eb38950..a723ddbea248 100644
> --- a/drivers/net/ethernet/qualcomm/Kconfig
> +++ b/drivers/net/ethernet/qualcomm/Kconfig
> @@ -60,6 +60,17 @@ config QCOM_EMAC
>  	  low power, Receive-Side Scaling (RSS), and IEEE 1588-2008
>  	  Precision Clock Synchronization Protocol.
>  
> +config QCOM_IPQ4019_ESS_EDMA
> +	tristate "Qualcomm Atheros IPQ4019 ESS EDMA support"
> +	depends on OF

I think this is present only on systems where Qualcomm IPQ4019 SoCs is
the main SoC (AP)? If so, I propose not to offer this to non-Qualcomm
SoC builds, because they cannot use it and it makes life of
distro-vendors configurators difficult:

	depends on ARCH_QCOM || COMPILE_TEST

> +	select PHYLINK
> +	help
> +	  This driver supports the Qualcomm Atheros IPQ40xx built-in
> +	  ESS EDMA ethernet controller.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called ipqess.
> +
>  source "drivers/net/ethernet/qualcomm/rmnet/Kconfig"


Best regards,
Krzysztof

