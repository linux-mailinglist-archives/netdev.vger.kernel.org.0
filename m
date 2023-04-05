Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D20B6D746E
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 08:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237089AbjDEGeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 02:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237077AbjDEGeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 02:34:13 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897D53A8E
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 23:34:11 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id t10so138344349edd.12
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 23:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680676450;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VX8BaURDAmMiXn1X2BAcvGxFigvEA3txrLdW+Fx+IZw=;
        b=rIPpaehpS5oSvYCoz67/ZyQz6Xbcw80aD8pJkdxX7S9OyExVaWPgYW1gcHrc9Qql8x
         7NwMpEsrh/wgRye2wvUKhikhv/9XlS2ZMG/5NDiGs0162GrMDG2/ztg/Uvgr746m82R7
         BY75kP7HRUgH8QcPYB3QLrcE9AaT3F2ePLLEtIgvYG9UQKCztVEMiKo3+yWEjQU0oDAO
         1oDDFFX02//OkSrSzTvUIohQsonuFPbJV3pVq652hJ7l7DrQhE6ViMOctlEZsdBso/8R
         16uqGLf+oNf7TCU4a5Yo4nIar70+moeNI5PJAtgGyqez5HD4dzcyyxCotM9sqx5k1sas
         5RUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680676450;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VX8BaURDAmMiXn1X2BAcvGxFigvEA3txrLdW+Fx+IZw=;
        b=eTNSCEyej78aI++Kmy//eGK4e73qEjRfA8+Fa/QePediQV+m5a5HkYzmNqjI3jSilF
         kTQ92Re95urVgjndIbTDszxRYUdv8bBM9bFGmJfFqPVoYmqlSpj0NKPKlohW//AXgWEf
         LkGvOohkFtyTyv88Ft20fpw8JldsBgVNclzUDNFYswXXCcIj6Ibz3J3UKeQjdFSm3Ssk
         Qy9z+opFH662DOmvSi5fzsQlDACCkvTd00FHrT+L/vT4AQ3WWa1RTqYMjQT4zdN7H6X+
         OIwSeyOHMAD8jwTf581nuPu8bkChHBPnUIC1iu9bOt+dx/c4bf8O0trmN6/9FZ5pZBy3
         TRZQ==
X-Gm-Message-State: AAQBX9eGUNi7WxGW+mBNwjz+JN08MM8sTo4itmdsJcpzGmHBFyZn8hty
        z4lvLmgsVW8ziWe1bXBK3uJGiQ==
X-Google-Smtp-Source: AKy350a6HrlFnAMQgKd+vCIeoY1a0fFXtmjdYQgCre2Kq5RpcQRJhbuwBnu7NwqDheLpf2xZ72hpHg==
X-Received: by 2002:a17:906:8602:b0:946:b942:ad6f with SMTP id o2-20020a170906860200b00946b942ad6fmr1441549ejx.8.1680676450041;
        Tue, 04 Apr 2023 23:34:10 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:3f:6b2:54cd:498e? ([2a02:810d:15c0:828:3f:6b2:54cd:498e])
        by smtp.gmail.com with ESMTPSA id a24-20020a509b58000000b005027d356613sm6430185edj.63.2023.04.04.23.34.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 23:34:09 -0700 (PDT)
Message-ID: <42dea5c9-96a7-9ab7-21ec-b545059659a0@linaro.org>
Date:   Wed, 5 Apr 2023 08:34:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [net-next v9 4/6] dt-bindings: net: Add support StarFive dwmac
Content-Language: en-US
To:     Samin Guo <samin.guo@starfivetech.com>,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Jose Abreu <joabreu@synopsys.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Conor Dooley <conor@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        Tommaso Merciai <tomm.merciai@gmail.com>
References: <20230328062009.25454-1-samin.guo@starfivetech.com>
 <20230328062009.25454-5-samin.guo@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230328062009.25454-5-samin.guo@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/03/2023 08:20, Samin Guo wrote:
> From: Yanhong Wang <yanhong.wang@starfivetech.com>
> 
> Add documentation to describe StarFive dwmac driver(GMAC).
> 
> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
>  .../bindings/net/starfive,jh7110-dwmac.yaml   | 144 ++++++++++++++++++
>  MAINTAINERS                                   |   6 +
>  3 files changed, 151 insertions(+)
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
> index 000000000000..5861426032bd
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
> @@ -0,0 +1,144 @@
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
> +  reg:
> +    maxItems: 1
> +
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
> +  interrupts:
> +    minItems: 3
> +    maxItems: 3
> +
> +  interrupt-names:
> +    minItems: 3
> +    maxItems: 3
> +
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
> +required:
> +  - compatible
> +  - reg
> +  - clocks
> +  - clock-names
> +  - interrupts
> +  - interrupt-names
> +  - resets
> +  - reset-names

This is a friendly reminder during the review process.

It seems my previous comments were not fully addressed. Maybe my
feedback got lost between the quotes, maybe you just forgot to apply it.
Please go back to the previous discussion and either implement all
requested changes or keep discussing them.

Thank you.


Best regards,
Krzysztof

