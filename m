Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67271666E43
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 10:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238488AbjALJac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 04:30:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239946AbjALJ3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 04:29:46 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFFE50F4A
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 01:25:17 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id az20so24159929ejc.1
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 01:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9UOvk5uyQGsRUZs22U+SL6M32TRGuh0Bg7yw7vCjuLU=;
        b=C58mc0fbpRuLE3Z72kvAVwtpYKi0LbbX65IN4430jxWeX2xjysqvFoYLXVQUT3GnCr
         vaiYvBBXQ5VuEJv/D/sJjJIsS4jESwCzgPDTMB+wnHA75UXWCQrf7NKNMyM1VydacYCb
         ZmfDFRvCr4CWiHKL5waTtfy/u5aYTE5eW1BYdSoEiotOLJzcme0MODZ7ZxnReBZhrHbb
         dJF81COjYRjNl0BsIQIwtVP/jYBmXclzUp0O8Yy3/LZ3L1HLSICyMgUjTL6V+CIBj/vA
         jryaJaLINYyct5I6pnaPtPHPRj6RuXWiyuUR3bflR4Ff6YBcuv+zWUNHnOY4IiOQ8JoT
         T3GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9UOvk5uyQGsRUZs22U+SL6M32TRGuh0Bg7yw7vCjuLU=;
        b=zAkMX/9GvjMTCezZCbxj+rDxj3bFeb3CuKESlISGtUsCLcc3D2FAxzMQDohkeSKhgu
         xIUVAn05GRlP5HL2QvhRAAINBsLl0xxnZ8xuRj7ZuRuNTee58ljzucOkHHcKjlxEltCD
         nqHGRtrwY5sVDALteRC6+1BO2kinPurI++vDcXTS3K5vIKnDZeH/1fFGpSuiL4u0+xnS
         kBiLza2M7Kp0vUejssflTCS1pVXbiVnHT8HsCDzh57Jfc+P3tJ24i6A0Xis5UMt+Wkjn
         imzZMkB2pDlP6NP5Hd9aFIM78h/kcA+NSGkQTaTzsqhyvehMrLFG4vTuAS3iDz7P/3gp
         RC9Q==
X-Gm-Message-State: AFqh2ko44LNE4hKPXRiwEouvRncHk61xwHIY1a+CRAg/nUv/8G3kR3q1
        AOfoqYqSHdMX1F3W95i4h2XsyA==
X-Google-Smtp-Source: AMrXdXsYVYTQ5ViFr64/0wXBdnwnuclIkzc6zV64iUrPQVEOpfCuUl7LjG7vIZhvx4wFYE2Xn2Gvcg==
X-Received: by 2002:a17:906:99d1:b0:7ad:cf9c:b210 with SMTP id s17-20020a17090699d100b007adcf9cb210mr60573303ejn.18.1673515516080;
        Thu, 12 Jan 2023 01:25:16 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id gk8-20020a17090790c800b0084d35ffbc20sm6155551ejb.68.2023.01.12.01.25.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 01:25:15 -0800 (PST)
Message-ID: <f566a556-4f9e-f5df-1ea4-2c8f633bdb4c@linaro.org>
Date:   Thu, 12 Jan 2023 10:25:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 1/4] dt-bindings: net: Add FSD EQoS device tree
 bindings
Content-Language: en-US
To:     Sriranjani P <sriranjani.p@samsung.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        alexandre.torgue@foss.st.com, peppe.cavallaro@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, pankaj.dubey@samsung.com,
        alim.akhtar@samsung.com, ravi.patel@samsung.com
References: <20230111075422.107173-1-sriranjani.p@samsung.com>
 <CGME20230111075441epcas5p4f0b503484de61228e3ed71a4041cdd41@epcas5p4.samsung.com>
 <20230111075422.107173-2-sriranjani.p@samsung.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230111075422.107173-2-sriranjani.p@samsung.com>
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

On 11/01/2023 08:54, Sriranjani P wrote:
> Add FSD Ethernet compatible in Synopsys dt-bindings document. Add FSD
> Ethernet YAML schema to enable the DT validation.
> 
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> Signed-off-by: Ravi Patel <ravi.patel@samsung.com>
> Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
>  .../net/tesla,dwc-qos-ethernet-4.21.yaml      | 103 ++++++++++++++++++
>  2 files changed, 104 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/tesla,dwc-qos-ethernet-4.21.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index 2f909ffe2fe8..e8d53061fd35 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -89,6 +89,7 @@ properties:
>          - snps,dwmac-5.10a
>          - snps,dwxgmac
>          - snps,dwxgmac-2.10
> +        - tesla,dwc-qos-ethernet-4.21

I don't get, why did you add the IP version number? Can Tesla FSD come
with different ones? The compatible should be specific to SoC and that's
all. Also keep consistent naming, so this is a "mac", right?

>  
>    reg:
>      minItems: 1
> diff --git a/Documentation/devicetree/bindings/net/tesla,dwc-qos-ethernet-4.21.yaml b/Documentation/devicetree/bindings/net/tesla,dwc-qos-ethernet-4.21.yaml
> new file mode 100644
> index 000000000000..d0dfc4a38d17
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/tesla,dwc-qos-ethernet-4.21.yaml
> @@ -0,0 +1,103 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/tesla,dwc-qos-ethernet-4.21.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: FSD Ethernet Quality of Service Device Tree Bindings

Drop "Device Tree Bindings"


> +
> +allOf:
> +  - $ref: "snps,dwmac.yaml#"

Drop quoets.

> +
> +maintainers:
> +  - Sriranjani P <sriranjani.p@samsung.com>
> +
> +properties:
> +  compatible:
> +    const: tesla,dwc-qos-ethernet-4.21.yaml
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  clocks:
> +    minItems: 4
> +
> +  clock-names:
> +    minItems: 4

Why rx clock might be not connected?

> +    items:
> +      - const: ptp_ref
> +      - const: master_bus
> +      - const: slave_bus
> +      - const: tx
> +      - const: rx
> +      - const: master2_bus
> +      - const: slave2_bus
> +      - const: eqos_rxclk_mux
> +      - const: eqos_phyrxclk
> +      - const: dout_peric_rgmii_clk

You have here 10 clocks, but snps,dwmac allows maximum 8. You need to
update it and fix any other dependent schemas.

> +
> +  rx-clock-skew:

Does not look like generic property. Missing vendor prefix, description,
constraints.

> +    $ref: /schemas/types.yaml#/definitions/phandle-array
> +
> +  iommus:
> +    maxItems: 1
> +
> +  phy-mode:
> +    $ref: ethernet-controller.yaml#/properties/phy-connection-type
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - clocks
> +  - clock-names
> +  - rx-clock-skew
> +  - iommus
> +  - phy-mode
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/fsd-clk.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +    ethernet_1: ethernet@14300000 {
> +              compatible = "tesla,dwc-qos-ethernet-4.21";
> +              reg = <0x0 0x14300000 0x0 0x10000>;

Are you sure you tested the bindings? 100% sure?

> +              interrupts = <GIC_SPI 176 IRQ_TYPE_LEVEL_HIGH>;
> +              clocks =

Don't introduce fake blank lines.

> +                       <&clock_peric PERIC_EQOS_TOP_IPCLKPORT_CLK_PTP_REF_I>,
> +                       <&clock_peric PERIC_EQOS_TOP_IPCLKPORT_ACLK_I>,
> +                       <&clock_peric PERIC_EQOS_TOP_IPCLKPORT_HCLK_I>,
> +                       <&clock_peric PERIC_EQOS_TOP_IPCLKPORT_RGMII_CLK_I>,
> +                       <&clock_peric PERIC_EQOS_TOP_IPCLKPORT_CLK_RX_I>,
> +                       <&clock_peric PERIC_BUS_D_PERIC_IPCLKPORT_EQOSCLK>,
> +                       <&clock_peric PERIC_BUS_P_PERIC_IPCLKPORT_EQOSCLK>,
> +                       <&clock_peric PERIC_EQOS_PHYRXCLK_MUX>,
> +                       <&clock_peric PERIC_EQOS_PHYRXCLK>,
> +                       <&clock_peric PERIC_DOUT_RGMII_CLK>;
> +              clock-names =

Ditto

> +                            "ptp_ref",
> +                            "master_bus",

Best regards,
Krzysztof

