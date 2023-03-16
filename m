Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC946BC707
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 08:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjCPH1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 03:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjCPH1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 03:27:53 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7891020A34
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 00:27:51 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id eg48so3719195edb.13
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 00:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678951670;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XK209g2VbExh/TqurSdOwtwH2IufznodX/JmW/3KLmc=;
        b=HChaTJc3kHVEAb6hVQADOZpU05dX3YjTZxKyDvkpBFOo1Oe4dPjb+DMmdM14GNyeIS
         6JRluNCuzmDmCmE7bSlEA4J4RTmi6HSugb5kpT65Jb6FjFTJbSApl6cd9zx1arvIHTEg
         ShmjqyCKMqbOtfPgiVNOwlu2VFKGo4XaHnzNET0qVG3WeZLajFMbDEu8N7NGGUYwqNcD
         7HD0yqK4Hsuo9OLS2JxWg10s4JB7f/263Amjs5sIJTlaeHT4bv94CS9612bSWAE/rT2/
         kIXdmlmM8eC5JUa4B9+S7APiUC45tc3cTaBPdglv1N+IfqoaZFW7fqo8fzADdN52nLE3
         8yCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678951670;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XK209g2VbExh/TqurSdOwtwH2IufznodX/JmW/3KLmc=;
        b=nWfJgUyMThzBSqqEB9QYWnDHMptjekZE04JeE0DvHkk63VPluA/qoz4X4R93VM9fRd
         D3IbQrkfTDNXxNw90vjOYgpmQcmADpn99vP9tpUBVjxv7eEdmSwmMqjNhBwPhFP6lnI6
         4z74eo0qm0M4F5B3QeJoj6tu4zVjWAeV9vEvHw2oSoofhbZyOxqoiO0LiMcML215IYXW
         gSp70CzNSW39f229m+36OSt3uOJm+BNVWE0/SLPehQPw/0ULIlbc44GmS6OLactO+kKT
         lCkgUGg+VNcNrIUfszlDj7dH3k6Synd7R8slnitsqBYVHQT+Lt+pQllo0oQzK1QELRmw
         hkiw==
X-Gm-Message-State: AO0yUKWW4jCVQR4l16k0ZGTYhWnJva9auJZKoqTJkvLycFCuF2PLeMxd
        E0Ey6Rd+tQzPKowdtec9IEfycQ==
X-Google-Smtp-Source: AK7set/Dr0fYdr41RCJNO5h+athWj3NTIYT68gO1NkqweUmCPxsQgXs+rJYrxMRigcX9FdXMNWx5XA==
X-Received: by 2002:a17:907:e93:b0:92f:22b1:57f9 with SMTP id ho19-20020a1709070e9300b0092f22b157f9mr5914949ejc.2.1678951669987;
        Thu, 16 Mar 2023 00:27:49 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:9827:5f65:8269:a95f? ([2a02:810d:15c0:828:9827:5f65:8269:a95f])
        by smtp.gmail.com with ESMTPSA id si2-20020a170906cec200b008e68d2c11d8sm3458672ejb.218.2023.03.16.00.27.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 00:27:49 -0700 (PDT)
Message-ID: <cfeec762-de75-f90f-7ba1-6c0bd8b70dff@linaro.org>
Date:   Thu, 16 Mar 2023 08:27:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v7 4/6] dt-bindings: net: Add support StarFive dwmac
Content-Language: en-US
To:     Samin Guo <samin.guo@starfivetech.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        Tommaso Merciai <tomm.merciai@gmail.com>
References: <20230316043714.24279-1-samin.guo@starfivetech.com>
 <20230316043714.24279-5-samin.guo@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230316043714.24279-5-samin.guo@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/03/2023 05:37, Samin Guo wrote:
> From: Yanhong Wang <yanhong.wang@starfivetech.com>
> 
> Add documentation to describe StarFive dwmac driver(GMAC).
> 
Thank you for your patch. There is something to discuss/improve.

> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
> Tested-by: Tommaso Merciai <tomm.merciai@gmail.com>
> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
>  .../bindings/net/starfive,jh7110-dwmac.yaml   | 130 ++++++++++++++++++
>  MAINTAINERS                                   |   6 +
>  3 files changed, 137 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index e4519cf722ab..245f7d713261 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -91,6 +91,7 @@ properties:
>          - snps,dwmac-5.20
>          - snps,dwxgmac
>          - snps,dwxgmac-2.10
> +        - starfive,jh7110-dwmac
>  
>    reg:
>      minItems: 1
> diff --git a/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml b/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
> new file mode 100644
> index 000000000000..b59e6bd8201f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
> @@ -0,0 +1,130 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +# Copyright (C) 2022 StarFive Technology Co., Ltd.
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/starfive,jh7110-dwmac.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: StarFive JH7110 DWMAC glue layer
> +
> +maintainers:
> +  - Emil Renner Berthing <kernel@esmil.dk>
> +  - Samin Guo <samin.guo@starfivetech.com>
> +
> +select:
> +  properties:
> +    compatible:
> +      contains:
> +        enum:
> +          - starfive,jh7110-dwmac
> +  required:
> +    - compatible
> +
> +properties:
> +  compatible:
> +    items:
> +      - enum:
> +          - starfive,jh7110-dwmac
> +      - const: snps,dwmac-5.20
> +

reg:
  maxItems: 1


> +  clocks:
> +    items:
> +      - description: GMAC main clock
> +      - description: GMAC AHB clock
> +      - description: PTP clock
> +      - description: TX clock
> +      - description: GTX clock
> +
> +  clock-names:
> +    items:
> +      - const: stmmaceth
> +      - const: pclk
> +      - const: ptp_ref
> +      - const: tx
> +      - const: gtx
> +

interrupts: ???

> +  resets:
> +    items:
> +      - description: MAC Reset signal.
> +      - description: AHB Reset signal.
> +
> +  reset-names:
> +    items:
> +      - const: stmmaceth
> +      - const: ahb
> +
> +  starfive,tx-use-rgmii-clk:
> +    description:
> +      Tx clock is provided by external rgmii clock.
> +    type: boolean
> +
> +  starfive,syscon:
> +    $ref: /schemas/types.yaml#/definitions/phandle-array
> +    items:
> +      - items:
> +          - description: phandle to syscon that configures phy mode
> +          - description: Offset of phy mode selection
> +          - description: Shift of phy mode selection
> +    description:
> +      A phandle to syscon with two arguments that configure phy mode.
> +      The argument one is the offset of phy mode selection, the
> +      argument two is the shift of phy mode selection.
> +
> +allOf:
> +  - $ref: snps,dwmac.yaml#
> +
> +unevaluatedProperties: false
> +
Best regards,
Krzysztof

