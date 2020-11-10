Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3262AE388
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 23:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732452AbgKJWnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 17:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731713AbgKJWnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 17:43:15 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5671C0613D1;
        Tue, 10 Nov 2020 14:43:14 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id dk16so8222ejb.12;
        Tue, 10 Nov 2020 14:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N/PQEE+/FPJ0NMebPS1QLSFSGVBrmG2LTD+JvZjZhrA=;
        b=D6gF6EqSrlCZd90BEdgFKvy5HfV0oHNA1w+wBVLraTax8HCvBdJE6z9M00jaoOkkNH
         sS7dIbvHM2HtO5yVicnl6VkVyJ9AJ0cC3aL5UKRY7BPqGZVutnzSjNEAf66tC90ogd6m
         xWkt0UNK+X6rk95fmVaUesY2Tw8w+zI7+rkTcv2TaIN/DBXN8wZEd0JyMTrbdi/3OBNe
         n334YMTwwyzsp//8LGhwXxfW+h0NKpiQpxj/Lo2zbVAvIFGPvCuhy9MqHj0FZYlsMX0Z
         4btSPdh9UiWJdr6Spkgu2KLZ9HbHVH+/S86OOiluAcLy0U+xbHRH16N3qa2tNd2Seqqd
         X9jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N/PQEE+/FPJ0NMebPS1QLSFSGVBrmG2LTD+JvZjZhrA=;
        b=tRHYhouZWr4lW9p3d8TmODUfMCNEQSOFWQD74anTH+Wf+7mp7AYPdvcWxUgoH6GRFT
         32dJwnRpUg7/oeZnsbjH93ROWu0xC9mOqEJVcLYQPvb9NSXaAp90Kf0QUl4rEqdvKLUZ
         PFR+CHIycYvTcxWpCmJifpeVLn+8yCnksyhDHjGxMNeWyvtcZRAuItN6+CVp4rYQ34zI
         V5TCLLSeqN0W/bsDIqAwdJWjdPq8QhuP2vfkcaKpTpIHb1lsw1s45p2xIjqEBVcijG5Z
         lV50xC8sW2SsCmWmpILL/ojLnIsEEu7azWI/4zeuJIYuDVf32o1xfVtiMcYLwV/c3YF5
         xcKA==
X-Gm-Message-State: AOAM532b6rkNlAKWPUjXJBhfvzB5pVKcOEx85DpHU+mSdCvvD1mnTczF
        JQl0Tb48bxgmrbcz8jmDi9Y=
X-Google-Smtp-Source: ABdhPJwQ4CDUWTmtukolhtYeoKhgrRiaz/vIih5rgiJyldK+BAVzvoXeE6dMZSSEIgfRS7KaK0sXQA==
X-Received: by 2002:a17:906:a195:: with SMTP id s21mr21482422ejy.146.1605048193570;
        Tue, 10 Nov 2020 14:43:13 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id mj17sm74969ejb.59.2020.11.10.14.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 14:43:13 -0800 (PST)
Date:   Wed, 11 Nov 2020 00:43:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Kurt Kanzenbach <kurt@kmk-computers.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "maintainer:BROADCOM IPROC ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:BROADCOM IPROC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 10/10] dt-bindings: net: dsa: b53: Add YAML bindings
Message-ID: <20201110224311.xtgv6wqqzmg77uny@skbuf>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
 <20201110033113.31090-11-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110033113.31090-11-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 07:31:13PM -0800, Florian Fainelli wrote:
> diff --git a/Documentation/devicetree/bindings/net/dsa/b53.yaml b/Documentation/devicetree/bindings/net/dsa/b53.yaml
> new file mode 100644
> index 000000000000..4fcbac1de95b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/b53.yaml
> @@ -0,0 +1,249 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/dsa/b53.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Broadcom BCM53xx Ethernet switches
> +
> +allOf:
> +  - $ref: dsa.yaml#
> +
> +maintainers:
> +  - Florian Fainelli <f.fainelli@gmail.com>
> +
> +description:
> +  Broadcom BCM53xx Ethernet switches
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - const: brcm,bcm5325
> +      - const: brcm,bcm53115
> +      - const: brcm,bcm53125
> +      - const: brcm,bcm53128
> +      - const: brcm,bcm5365
> +      - const: brcm,bcm5395
> +      - const: brcm,bcm5389
> +      - const: brcm,bcm5397
> +      - const: brcm,bcm5398
> +      - items:
> +          - const: brcm,bcm11360-srab
> +          - const: brcm,cygnus-srab
> +      - items:
> +          - enum:
> +              - brcm,bcm53010-srab
> +              - brcm,bcm53011-srab
> +              - brcm,bcm53012-srab
> +              - brcm,bcm53018-srab
> +              - brcm,bcm53019-srab
> +          - const: brcm,bcm5301x-srab
> +      - items:
> +          - enum:
> +              - brcm,bcm11404-srab
> +              - brcm,bcm11407-srab
> +              - brcm,bcm11409-srab
> +              - brcm,bcm58310-srab
> +              - brcm,bcm58311-srab
> +              - brcm,bcm58313-srab
> +          - const: brcm,omega-srab
> +      - items:
> +          - enum:
> +              - brcm,bcm58522-srab
> +              - brcm,bcm58523-srab
> +              - brcm,bcm58525-srab
> +              - brcm,bcm58622-srab
> +              - brcm,bcm58623-srab
> +              - brcm,bcm58625-srab
> +              - brcm,bcm88312-srab
> +          - const: brcm,nsp-srab
> +      - items:
> +          - enum:
> +              - brcm,bcm3384-switch
> +              - brcm,bcm6328-switch
> +              - brcm,bcm6368-switch
> +          - const: brcm,bcm63xx-switch
> +
> +required:
> +  - compatible
> +  - reg
> +
> +# BCM585xx/586xx/88312 SoCs
> +if:
> +  properties:
> +    compatible:
> +      contains:
> +        enum:
> +          - brcm,bcm58522-srab
> +          - brcm,bcm58523-srab
> +          - brcm,bcm58525-srab
> +          - brcm,bcm58622-srab
> +          - brcm,bcm58623-srab
> +          - brcm,bcm58625-srab
> +          - brcm,bcm88312-srab
> +then:
> +  properties:
> +    reg:
> +      minItems: 3
> +      maxItems: 3
> +    reg-names:
> +      items:
> +        - const: srab
> +        - const: mux_config
> +        - const: sgmii_config

I am only reading these with a human eye, I don't parse YAML syntax.
Does the syntax enforce that these reg-names are declared in this
precise order, which is necessary for the proper operation of the
driver?

> +    interrupts:
> +      minItems: 13
> +      maxItems: 13
> +    interrupt-names:
> +      items:
> +        - const: link_state_p0
> +        - const: link_state_p1
> +        - const: link_state_p2
> +        - const: link_state_p3
> +        - const: link_state_p4
> +        - const: link_state_p5
> +        - const: link_state_p7
> +        - const: link_state_p8
> +        - const: phy
> +        - const: ts
> +        - const: imp_sleep_timer_p5
> +        - const: imp_sleep_timer_p7
> +        - const: imp_sleep_timer_p8
> +  required:
> +    - interrupts
> +else:
> +  properties:
> +    reg:
> +      maxItems: 1
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    mdio {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        switch@1e {

You have renamed a node called 'ethernet-switch' into one called
'switch'. Was it deliberate?

> +            compatible = "brcm,bcm53125";
> +            reg = <30>;
> +
> +            ethernet-ports {
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +
> +                port@0 {
> +                    reg = <0>;
> +                    label = "lan1";
> +                };
> +
> +                port@1 {
> +                    reg = <1>;
> +                    label = "lan2";
> +                };
> +
> +                port@5 {
> +                    reg = <5>;
> +                    label = "cable-modem";
> +                    phy-mode = "rgmii-txid";
> +                    fixed-link {
> +                        speed = <1000>;
> +                        full-duplex;
> +                    };
> +                };
> +
> +                port@8 {
> +                    reg = <8>;
> +                    label = "cpu";
> +                    phy-mode = "rgmii-txid";
> +                    ethernet = <&eth0>;
> +                    fixed-link {
> +                        speed = <1000>;
> +                        full-duplex;
> +                    };
> +                };
> +            };
> +        };
> +    };
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +
> +    axi {
> +        #address-cells = <1>;
> +        #size-cells = <1>;
> +
> +        switch@36000 {
> +            compatible = "brcm,bcm58623-srab", "brcm,nsp-srab";
> +            reg = <0x36000 0x1000>,
> +                  <0x3f308 0x8>,
> +                  <0x3f410 0xc>;
> +            reg-names = "srab", "mux_config", "sgmii_config";
> +            interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 97 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 98 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 99 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 100 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 101 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 102 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 104 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>;
> +            interrupt-names = "link_state_p0",
> +                              "link_state_p1",
> +                              "link_state_p2",
> +                              "link_state_p3",
> +                              "link_state_p4",
> +                              "link_state_p5",
> +                              "link_state_p7",
> +                              "link_state_p8",
> +                              "phy",
> +                              "ts",
> +                              "imp_sleep_timer_p5",
> +                              "imp_sleep_timer_p7",
> +                              "imp_sleep_timer_p8";
> +
> +            ethernet-ports {
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +
> +                port@0 {
> +                    label = "port0";
> +                    reg = <0>;
> +                };
> +
> +                port@1 {
> +                    label = "port1";
> +                    reg = <1>;
> +                };
> +
> +                port@2 {
> +                    label = "port2";
> +                    reg = <2>;
> +                };
> +
> +                port@3 {
> +                    label = "port3";
> +                    reg = <3>;
> +                };
> +
> +                port@4 {
> +                    label = "port4";
> +                    reg = <4>;
> +                };
> +
> +                port@8 {
> +                    ethernet = <&amac2>;
> +                    label = "cpu";
> +                    reg = <8>;
> +                    fixed-link {
> +                        speed = <1000>;
> +                        full-duplex;
> +                    };
> +                };
> +            };
> +        };
> +    };
