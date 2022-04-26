Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA91B50FFEA
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 16:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345706AbiDZOFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 10:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237262AbiDZOFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 10:05:18 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D9D32EDC;
        Tue, 26 Apr 2022 07:02:10 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 78A2BC0008;
        Tue, 26 Apr 2022 14:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650981728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7PQZCwiv2zEHTrq79VR/VdsVP2v14TZgynrsHMuTV/0=;
        b=GqrophupVFhOrusBv9A1zJ+E8bt3QYe/6VKg+dF4uAcEDBOcMdPM/ms2t2RY7ms+XfPhqE
        TKY4kXPXOQxkdjJ9AocBAj4EHj2bGV+Iox7dkQtp4mcFwCBv+15WFpRXnBqyzXo1yG1TWI
        lcv+9wSjnqcjjiiVWzWmgKgAH86bZCUfQ7QgQHTlQzYALRjxuc2zBNHwstmIrCY0b7WhQ8
        mCORk9Kzwq5iFkouEnUyEYEzNqArXLc1B98EoHbOZHaWhlAeE0hqRqjL1X0PYS3B088MDy
        COySCDCntcmYyoWU3Cd35fvgbjT49Ov9b+H4AFQRCCKUBdYlGgdCJ5wdqDDpFg==
Date:   Tue, 26 Apr 2022 16:02:06 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next 4/5] net: dt-bindings: Introduce the Qualcomm
 IPQESS Ethernet controller
Message-ID: <20220426160206.1a8d425c@pc-19.home>
In-Reply-To: <34d3bfdc-cf8c-bf63-4f67-57c8d6c9b780@linaro.org>
References: <20220422180305.301882-1-maxime.chevallier@bootlin.com>
        <20220422180305.301882-5-maxime.chevallier@bootlin.com>
        <34d3bfdc-cf8c-bf63-4f67-57c8d6c9b780@linaro.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof

On Sat, 23 Apr 2022 19:49:30 +0200
Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> wrote:

Thanks a lot for the review, I'll address all your comments in a V2.

> On 22/04/2022 20:03, Maxime Chevallier wrote:
> > Add the DT binding for the IPQESS Ethernet Controller. This is a
> > simple controller, only requiring the phy-mode, interrupts, clocks,
> > and possibly a MAC address setting.
> > 
> > Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> > ---
> >  .../devicetree/bindings/net/qcom,ipqess.yaml  | 94
> > +++++++++++++++++++ 1 file changed, 94 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/net/qcom,ipqess.yaml
> > 
> > diff --git a/Documentation/devicetree/bindings/net/qcom,ipqess.yaml
> > b/Documentation/devicetree/bindings/net/qcom,ipqess.yaml new file
> > mode 100644 index 000000000000..8fec5633692f
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/qcom,ipqess.yaml
> > @@ -0,0 +1,94 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/qcom,ipqess.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Qualcomm IPQ ESS EDMA Ethernet Controller Device Tree
> > Bindings  
> 
> s/Device Tree Bindings//
> 
> > +
> > +allOf:
> > +  - $ref: "ethernet-controller.yaml#"  
> 
> allOf goes after maintainers.
> 
> > +
> > +maintainers:
> > +  - Maxime Chevallier <maxime.chevallier@bootlin.com>
> > +
> > +properties:
> > +  compatible:
> > +    const: qcom,ipq4019e-ess-edma
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  interrupts:
> > +    minItems: 2
> > +    maxItems: 32
> > +    description: One interrupt per tx and rx queue, with up to 16
> > queues. +
> > +  clocks:
> > +    maxItems: 1
> > +
> > +  phy-mode: true
> > +
> > +  fixed-link: true
> > +
> > +  mac-address: true  
> 
> You don't need all these three. They come from ethernet-controller and
> you use unevaluatedProperties.
> 
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - interrupts
> > +  - clocks
> > +  - phy-mode
> > +
> > +unevaluatedProperties: false
> > +
> > +examples:
> > +  - |
> > +    gmac: ethernet@c080000 {
> > +        compatible = "qcom,ipq4019-ess-edma";
> > +        reg = <0xc080000 0x8000>;
> > +        interrupts = <GIC_SPI  65 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI  66 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI  67 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI  68 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI  69 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI  70 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI  71 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI  72 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI  73 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI  74 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI  75 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI  76 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI  77 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI  78 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI  79 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI  80 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI 240 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI 241 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI 242 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI 243 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI 244 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI 245 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI 246 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI 247 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI 248 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI 249 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI 250 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI 251 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI 252 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI 253 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI 254 IRQ_TYPE_EDGE_RISING>,
> > +                     <GIC_SPI 255 IRQ_TYPE_EDGE_RISING>;
> > +
> > +        status = "okay";  
> 
> No status in the example.
> 
> > +
> > +        phy-mode = "internal";
> > +        fixed-link {
> > +            speed = <1000>;
> > +            full-duplex;
> > +            pause;
> > +            asym-pause;
> > +        };
> > +    };
> > +
> > +...  
> 
> 
> Best regards,
> Krzysztof

Best Regards,

Maxime
