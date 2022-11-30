Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9308363D9ED
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 16:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiK3Pvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 10:51:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiK3Pvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 10:51:37 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49F7286FC
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 07:51:35 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id b9so21354925ljr.5
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 07:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PG0uNEVGK4q7da5/MLy+snrbykYNb1/tHqcYAuUGVuE=;
        b=YNd1J19Wgi306BQblAaPgKiipYJCYfpfdz/CeUQkZXVXZRPmnsfMyUS9HiqfBZqkX9
         W2xdcA4Xj1qpFuxp+n2t4RVMuRUn0EUCcTy3drHjothY/1Zk3YeD6ONjthQnfkoBF95f
         mBMzqQSRhGWl2rnmw4V47jbq3KbVB/1EF73YnKCD+Os3ZtXVnOmKkLmujB9mCtqcatPZ
         adja1EwtKGVjCwLIHZWDCAGICaD58aKB5SRN1Y1e5c1jseRZfXRieRnLe11+MIiSBNgU
         npmdm0g2HeUCZCLRaphw12jBLOzLpOfikY3wLxNgzadTyp3AS4G0jQiMWTTWe2My+pZD
         Owxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PG0uNEVGK4q7da5/MLy+snrbykYNb1/tHqcYAuUGVuE=;
        b=eS/TYYwkjfgL8ER5Q6P/Tc4q2twxhcx+Ru+tzkW40Fvj8aEQubVT2bxL8AKJ3FrWpa
         Npl2tKw69ynpC7VJw7S4jLfpBfmAbJsgLpGbuiehpMdvi1hDHI5Yqfg8RMQSsjMeKMFn
         N2NxcUYuAA5XN6w+QxKzDl95R/6GFMWoOQv6fynjRB7rLW+5P9L2dgjwiqCCmbXQr7Si
         XQhsYE4C8CfcAKCfs930BnOi4KearKwQ7TF306NCs1a2kassJYtNUV3iysfLnA+n8e0z
         ja/GJ9e0B3YUJ7IqFgcmd+4ePq2oWtIpKydT3lnCjCCWb7GERC/GiUU+DPP2Fdvflh6v
         qn1g==
X-Gm-Message-State: ANoB5pmTUleQY4EUq/GcHnkkO/478YWfa5EXnu5b0d6ub7ENNJAxnWwT
        IeqbMgCSn5Rvj6cvYPWJ+OP+HQ==
X-Google-Smtp-Source: AA0mqf7WjHG5qZxOo7GtR4qXw/4cWciSGicSqr/rFLFWR/5xIAagdnHXnwB0zrmbHNC8Q/jGHdM8iw==
X-Received: by 2002:a2e:bc88:0:b0:26f:ae32:a207 with SMTP id h8-20020a2ebc88000000b0026fae32a207mr21540208ljf.321.1669823493993;
        Wed, 30 Nov 2022 07:51:33 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id t3-20020a056512208300b004acbfa4a18bsm296625lfr.173.2022.11.30.07.51.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 07:51:33 -0800 (PST)
Message-ID: <4a7a9bf7-f831-e1c1-0a31-8afcf92ae84c@linaro.org>
Date:   Wed, 30 Nov 2022 16:51:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2 2/5] dt-bindings: net: add schema for NXP S32CC dwmac
 glue driver
Content-Language: en-US
To:     Chester Lin <clin@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jan Petrous <jan.petrous@nxp.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        s32@nxp.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>,
        Matthias Brugger <mbrugger@suse.com>
References: <20221128054920.2113-1-clin@suse.com>
 <20221128054920.2113-3-clin@suse.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221128054920.2113-3-clin@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/11/2022 06:49, Chester Lin wrote:
> Add the DT schema for the DWMAC Ethernet controller on NXP S32 Common
> Chassis.
> 
> Signed-off-by: Jan Petrous <jan.petrous@nxp.com>
> Signed-off-by: Chester Lin <clin@suse.com>

Thank you for your patch. There is something to discuss/improve.

> ---
> 
> Changes in v2:
>   - Fix schema issues.
>   - Add minItems to clocks & clock-names.
>   - Replace all sgmii/SGMII terms with pcs/PCS.
> 
>  .../bindings/net/nxp,s32cc-dwmac.yaml         | 135 ++++++++++++++++++
>  1 file changed, 135 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml b/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
> new file mode 100644
> index 000000000000..c6839fd3df40
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
> @@ -0,0 +1,135 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +# Copyright 2021-2022 NXP
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/net/nxp,s32cc-dwmac.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"

Drop quotes from both.

> +
> +title: NXP S32CC DWMAC Ethernet controller
> +
> +maintainers:
> +  - Jan Petrous <jan.petrous@nxp.com>
> +  - Chester Lin <clin@suse.com>
> +
> +allOf:
> +  - $ref: "snps,dwmac.yaml#"

Drop quotes.

> +
> +properties:
> +  compatible:
> +    enum:
> +      - nxp,s32cc-dwmac
> +
> +  reg:
> +    items:
> +      - description: Main GMAC registers
> +      - description: S32 MAC control registers
> +
> +  dma-coherent: true
> +
> +  clocks:
> +    minItems: 5

Why only 5 clocks are required? Receive clocks don't have to be there?
Is such system - only with clocks for transmit - usable?

> +    items:
> +      - description: Main GMAC clock
> +      - description: Peripheral registers clock
> +      - description: Transmit PCS clock
> +      - description: Transmit RGMII clock
> +      - description: Transmit RMII clock
> +      - description: Transmit MII clock
> +      - description: Receive PCS clock
> +      - description: Receive RGMII clock
> +      - description: Receive RMII clock
> +      - description: Receive MII clock
> +      - description:
> +          PTP reference clock. This clock is used for programming the
> +          Timestamp Addend Register. If not passed then the system
> +          clock will be used.
> +
> +  clock-names:
> +    minItems: 5
> +    items:
> +      - const: stmmaceth
> +      - const: pclk
> +      - const: tx_pcs
> +      - const: tx_rgmii
> +      - const: tx_rmii
> +      - const: tx_mii
> +      - const: rx_pcs
> +      - const: rx_rgmii
> +      - const: rx_rmii
> +      - const: rx_mii
> +      - const: ptp_ref
> +
> +  tx-fifo-depth:
> +    const: 20480
> +
> +  rx-fifo-depth:
> +    const: 20480
> +
> +required:
> +  - compatible
> +  - reg
> +  - tx-fifo-depth
> +  - rx-fifo-depth
> +  - clocks
> +  - clock-names
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +
> +    #define S32GEN1_SCMI_CLK_GMAC0_AXI
> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_PCS
> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_RGMII
> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_RMII
> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_MII
> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_PCS
> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_RGMII
> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_RMII
> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_MII
> +    #define S32GEN1_SCMI_CLK_GMAC0_TS

Why defines? Your clock controller is not ready? If so, just use raw
numbers.

> +
> +    soc {
> +      #address-cells = <1>;
> +      #size-cells = <1>;
> +
> +      gmac0: ethernet@4033c000 {
> +        compatible = "nxp,s32cc-dwmac";
> +        reg = <0x4033c000 0x2000>, /* gmac IP */
> +              <0x4007C004 0x4>;    /* S32 CTRL_STS reg */

Lowercase hex.

> +        interrupt-parent = <&gic>;
> +        interrupts = <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>;
> +        interrupt-names = "macirq";
> +        phy-mode = "rgmii-id";
> +        tx-fifo-depth = <20480>;
> +        rx-fifo-depth = <20480>;
> +        dma-coherent;
> +        clocks = <&clks S32GEN1_SCMI_CLK_GMAC0_AXI>,
> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_AXI>,
> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_TX_PCS>,
> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_TX_RGMII>,
> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_TX_RMII>,
> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_TX_MII>,
> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_RX_PCS>,
> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_RX_RGMII>,
> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_RX_RMII>,
> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_RX_MII>,
> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_TS>;


Best regards,
Krzysztof

