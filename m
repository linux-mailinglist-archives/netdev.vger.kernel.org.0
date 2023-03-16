Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A166BC841
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 09:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjCPIIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 04:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjCPIIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 04:08:18 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4E0A1FF5
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:08:05 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id h8so4139558ede.8
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678954084;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2t5vgQAFH4zea9C9lwjCcYRFCKm2hCie1XyP3i2whSo=;
        b=FOk180Mybn/nrJNla/QxIEQVZ1i87jWOwt47jh12+zhGW+jJcZzqIo8xeSDzuJX347
         e8X1PQoIiGXM+iMeS/bPsQuYiiTmCVV1T4cqDulvj2IwZNbVuLzvOEB6AMVIuUb9g7Pu
         JLh/noUDGL9/3gNwBjue+NXf5anXljKjgCcEaqqSWDcbqZMihfD621qWkr8tb9Q0z0Q2
         V8sRddtOEDa9IsmSPnES94pgVpxcWEeFBCO+qQJva2qBxjLZ6vu8w5K+vVjPLw6+cOnr
         NP/Qu0N8bJ3J1aYmxANEcyakcVtwFt5AJ/RwABGVAa1+9tjcPzoqnkbf4RFZT2AvIGhU
         ekvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678954084;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2t5vgQAFH4zea9C9lwjCcYRFCKm2hCie1XyP3i2whSo=;
        b=uXAMO4V301rnVqRSyf79Ef9i9+JJeEOTIGsdpvV/XLoGUKxb2zaHnzqrul82wfl8lQ
         paG0QOfv4Lvzwq+kcI+MYfhgiFqwbrZ+ReAGmctB1ERWLhvf1biQDf3PknYgLRZ7sAsG
         GG46it1Mi1GwTohUaN+4VdeXeAGGGlBygdVuxGDz0Fl4wCSNyLdLOu1/3m7GlJxuYdqN
         3d2AyYdFwM+jw+BolYiIH488zQ1fqYiQGp9/5MC2pkdyqCJV6mFBw56HcZCCE3Lmnoch
         l/wBPAeESfhlWWH4R8rv+Pj0/UmLAYLqTcMxenFLjw3t5r9Ffw2DsdYolA2NicV2G8Cr
         pFsQ==
X-Gm-Message-State: AO0yUKUI2VEjqee+bdwRy6JWSqlGD1bQ8ZXKUxL04ttG0YV3EHYna/s/
        HBaV5Vca6szOIOY23Wj1qlA2Xw==
X-Google-Smtp-Source: AK7set+fhPNTk5Netaf52WqB7gcefN//PWAgl+AdB5Q4iDcjAlDmAtCNo/y6ml41RRTaKQ2Vn9KeKA==
X-Received: by 2002:a17:906:16d6:b0:930:310:abf4 with SMTP id t22-20020a17090616d600b009300310abf4mr2419857ejd.50.1678954084026;
        Thu, 16 Mar 2023 01:08:04 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:9827:5f65:8269:a95f? ([2a02:810d:15c0:828:9827:5f65:8269:a95f])
        by smtp.gmail.com with ESMTPSA id q24-20020a1709064cd800b009306be6bed7sm460103ejt.190.2023.03.16.01.08.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 01:08:03 -0700 (PDT)
Message-ID: <60ce1510-6f2f-dad0-005c-7bcb3880872a@linaro.org>
Date:   Thu, 16 Mar 2023 09:08:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 12/16] dt-bindings: net: dwmac: Add MTL Tx Queue
 properties constraints
Content-Language: en-US
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@st.com>
References: <20230313225103.30512-1-Sergey.Semin@baikalelectronics.ru>
 <20230313225103.30512-13-Sergey.Semin@baikalelectronics.ru>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230313225103.30512-13-Sergey.Semin@baikalelectronics.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/03/2023 23:50, Serge Semin wrote:
> Currently none of the MTL Tx Queues QoS-related DT-properties have been
> equipped with the proper constraints meanwhile they can be specified at
> least based on the corresponding CSR field sizes or the DW (x|xG)MAC
> IP-core synthesize parameter constraints. Let's do that:
> + snps,tx-queues-to-use - number of Tx queues to utilise is limited with a
> number of available queues. DW MAC/GMAC: no queues, DW Eth QoS: <= 8, DW
> xGMAC: <= 16.
> + snps,weight - Tx Queue/Traffic Class quantum/weight utilised depending
> on enabled algorithm for the Data Center Bridging feature: DWRR (up to
> 0x1312D0 bytes to add to credit) or WFQ (up to 0x3FFF - least bandwidth)
> or WFQ (up to 0x64). DW MAC/GMAC: no queues, DW Eth QoS: <= 0x1312D0, DW
> xGMAC: <= 0x1312D0.
> + snps,send_slope - Tx Queue/Traffic Class Send-Slope credit value
> subtracted from the accumulated credit for the Audio/Video bridging
> feature (CBS algorithm, bits per cycle scaled up by 1,024). DW MAC/GMAC:
> no queues, DW Eth QoS: <= 0x2000, DW xGMAC: <= 0x3FFF.
> + snps,idle_slope - same meaning as snps,send_slope except it's determines
> the Idle-Slope credit of CBS algorithm. DW MAC/GMAC: no queues, DW Eth
> QoS: <= 0x2000, DW xGMAC: <= 0x8000.
> + snps,high_credit/snps,low_credit - maximum and minimum values
> accumulated in the credit for the Audio/Video bridging feature (CBS
> algorithm, bits scaled up by 1,024). DW MAC/GMAC: no queues, DW Eth
> QoS: <= 0x1FFFFFFF, DW xGMAC: <= 0x1FFFFFFF.
> + snps,priority - Tx Queue/Traffic Class priority (enabled by the
> PFC-packets) limits determined by the VLAN tag PRI field width (it's 7).
> DW MAC/GMAC: no queues, DW Eth QoS: 0xff, DW xGMAC: 0xff.
> 
> Since the constraints vary for different IP-cores and the DT-schema is
> common for all of them the least restrictive values are chosen. The info
> above can be used for the IP-core specific DT-schemas if anybody ever is
> bothered with one to create.
> 
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> ---
>  .../bindings/net/snps,dwmac-generic.yaml      |  2 +-
>  .../devicetree/bindings/net/snps,dwmac.yaml   | 24 ++++++++++++++++++-
>  2 files changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac-generic.yaml b/Documentation/devicetree/bindings/net/snps,dwmac-generic.yaml
> index ae740a1ab213..2974af79511d 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac-generic.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac-generic.yaml
> @@ -137,7 +137,7 @@ examples:
>                  snps,send_slope = <0x1000>;
>                  snps,idle_slope = <0x1000>;
>                  snps,high_credit = <0x3E800>;
> -                snps,low_credit = <0xFFC18000>;
> +                snps,low_credit = <0x1FC18000>;
>                  snps,priority = <0x1>;
>              };
>          };
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index e5662b1498b7..2ebf7995426b 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -250,6 +250,10 @@ properties:
>        snps,tx-queues-to-use:
>          $ref: /schemas/types.yaml#/definitions/uint32
>          description: number of TX queues to be used in the driver
> +        default: 1
> +        minimum: 1
> +        maximum: 16
> +
>        snps,tx-sched-wrr:
>          type: boolean
>          description: Weighted Round Robin
> @@ -296,13 +300,16 @@ properties:
>              snps,tx-sched-wfq: false
>              snps,tx-sched-dwrr: false
>      patternProperties:
> -      "^queue[0-9]$":
> +      "^queue([0-9]|1[0-5])$":
>          description: Each subnode represents a queue.
>          type: object
>          properties:
>            snps,weight:
>              $ref: /schemas/types.yaml#/definitions/uint32
>              description: TX queue weight (if using a DCB weight algorithm)
> +            minimum: 0
> +            maximum: 0x1312D0
> +
>            snps,dcb-algorithm:
>              type: boolean
>              description: TX queue will be working in DCB
> @@ -315,15 +322,27 @@ properties:
>            snps,send_slope:
>              $ref: /schemas/types.yaml#/definitions/uint32
>              description: enable Low Power Interface
> +            minimum: 0
> +            maximum: 0x3FFF

lowercase hex everywhere.

Best regards,
Krzysztof

