Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2554C489F15
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 19:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239061AbiAJSUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 13:20:44 -0500
Received: from mail-ot1-f53.google.com ([209.85.210.53]:40899 "EHLO
        mail-ot1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238949AbiAJSUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 13:20:44 -0500
Received: by mail-ot1-f53.google.com with SMTP id h5-20020a9d6a45000000b005908066fa64so15049954otn.7;
        Mon, 10 Jan 2022 10:20:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4gRJe4xW+/qXA8rpqRfXC/2ED3fipmCrJ1/hl7RINx0=;
        b=Gqoh+HXzdl1OdkeVJdM0GwlOVypAP5ci2vamVVXM1BMYxJcBJbDHQg38U0WxK3AoQ4
         zz772iC0iNjFsvLzJGPiJutulIWlLYrbbpKYv+z5G0giE7aCoUINdUoi51NRWLCnuyKU
         hgPUR7UKrIY18qQwzJsFGsjRkroEtc4Cz1E9AR2Ae2NeQPvJaSqKQeRvhhqxZxRISxDe
         +0SVdIX/dF53wHMxlq4XJjbyqqLoTM2A5laxD5uGmzcalVsIwkUtfSS88JjFxMeaAZOA
         Z7XDnEFFmxeoUtyT6S1sKW2Qcu3hc9vfQw32ztbT12kA9SaMovQHFU9V//N34gIy1cTV
         5kdA==
X-Gm-Message-State: AOAM531lRhjxiwz74wOQxRxBC7gyVnXWPGtgqr1Yh+1oXXz4fidIX9TC
        XAgLflaFxlMUxELgAZ43Iw==
X-Google-Smtp-Source: ABdhPJw3HvXs4xW+Md4to/3IrAZCAPU4MXcgNrfddNqua5L84mw2LDm5XnBFrP5XeIISWQNoMcx6zw==
X-Received: by 2002:a05:6830:4493:: with SMTP id r19mr778681otv.251.1641838843639;
        Mon, 10 Jan 2022 10:20:43 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id n26sm1448914ooc.48.2022.01.10.10.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 10:20:43 -0800 (PST)
Received: (nullmailer pid 1226344 invoked by uid 1000);
        Mon, 10 Jan 2022 18:20:42 -0000
Date:   Mon, 10 Jan 2022 12:20:42 -0600
From:   Rob Herring <robh@kernel.org>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: dsa: realtek-smi: convert to YAML
 schema
Message-ID: <Ydx4+o5TsWZkZd45@robh.at.kernel.org>
References: <20211228072645.32341-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211228072645.32341-1-luizluca@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 28, 2021 at 04:26:45AM -0300, Luiz Angelo Daros de Luca wrote:
> Schema changes:
> 
> - "interrupt-controller" was not added as a required property. It might
>   still work polling the ports when missing
> - "interrupt" property was mentioned but never used. According to its
>   description, it was assumed it was really "interrupt-parent"
> 
> Examples changes:
> 
> - renamed "switch_intc" to make it unique between examples
> - removed "dsa-mdio" from mdio compatible property
> - renamed phy@0 to ethernet-phy@0 (not tested with real HW)
>   phy@ requires #phy-cells
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---
>  .../bindings/net/dsa/realtek-smi.txt          | 240 --------------
>  .../bindings/net/dsa/realtek-smi.yaml         | 310 ++++++++++++++++++
>  2 files changed, 310 insertions(+), 240 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/realtek-smi.yaml


> diff --git a/Documentation/devicetree/bindings/net/dsa/realtek-smi.yaml b/Documentation/devicetree/bindings/net/dsa/realtek-smi.yaml
> new file mode 100644
> index 000000000000..c4cd0038f092
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/realtek-smi.yaml
> @@ -0,0 +1,310 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/dsa/realtek-smi.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Realtek SMI-based Switches
> +
> +allOf:
> +  - $ref: dsa.yaml#
> +
> +maintainers:
> +  - Linus Walleij <linus.walleij@linaro.org>
> +
> +description:
> +  The SMI "Simple Management Interface" is a two-wire protocol using
> +  bit-banged GPIO that while it reuses the MDIO lines MCK and MDIO does
> +  not use the MDIO protocol. This binding defines how to specify the
> +  SMI-based Realtek devices. The realtek-smi driver is a platform driver
> +  and it must be inserted inside a platform node.
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - enum:

Don't need oneOf when there is only 1 entry.

> +          - realtek,rtl8365mb
> +          - realtek,rtl8366
> +          - realtek,rtl8366rb
> +          - realtek,rtl8366s
> +          - realtek,rtl8367
> +          - realtek,rtl8367b
> +          - realtek,rtl8368s
> +          - realtek,rtl8369
> +          - realtek,rtl8370
> +    description: |
> +      realtek,rtl8365mb: 4+1 ports
> +      realtek,rtl8366:
> +      realtek,rtl8366rb:
> +      realtek,rtl8366s: 4+1 ports
> +      realtek,rtl8367:
> +      realtek,rtl8367b:
> +      realtek,rtl8368s: 8 ports
> +      realtek,rtl8369:
> +      realtek,rtl8370:  8+2 ports
> +  reg:
> +    maxItems: 1
> +
> +  mdc-gpios:
> +    description: GPIO line for the MDC clock line.
> +    maxItems: 1
> +
> +  mdio-gpios:
> +    description: GPIO line for the MDIO data line.
> +    maxItems: 1
> +
> +  reset-gpios:
> +    description: GPIO to be used to reset the whole device
> +    maxItems: 1
> +
> +  realtek,disable-leds:
> +    type: boolean
> +    description: |
> +      if the LED drivers are not used in the
> +      hardware design this will disable them so they are not turned on
> +      and wasting power.
> +
> +  interrupt-controller:
> +    type: object
> +    description: |
> +      This defines an interrupt controller with an IRQ line (typically
> +      a GPIO) that will demultiplex and handle the interrupt from the single
> +      interrupt line coming out of one of the SMI-based chips. It most
> +      importantly provides link up/down interrupts to the PHY blocks inside
> +      the ASIC.
> +    
> +    properties:
> +
> +      interrupt-controller:
> +        description: see interrupt-controller/interrupts.txt

Don't need generic descriptions. Just 'true' here is fine.

> +
> +      interrupts:
> +        description: TODO

You have to define how many interrupts and what they are.

> +
> +      '#address-cells':
> +        const: 0
> +
> +      '#interrupt-cells':
> +        const: 1
> +
> +    required:
> +      - interrupt-parent

'interrupt-parent' is never required. It's valid for the 
'interrupt-parent' to be in any parent node.

> +      - interrupt-controller
> +      - '#address-cells'
> +      - '#interrupt-cells'
> +
> +  mdio:
> +    type: object
> +    description:
> +      This defines the internal MDIO bus of the SMI device, mostly for the
> +      purpose of being able to hook the interrupts to the right PHY and
> +      the right PHY to the corresponding port.
> +
> +    properties:
> +      compatible:
> +        const: "realtek,smi-mdio"

Don't need quotes.

blank line between properties.

> +      '#address-cells':
> +        const: 1

blank line.

> +      '#size-cells':
> +        const: 0
> +
> +    patternProperties:
> +      "^(ethernet-)?phy@[0-4]$":
> +        type: object
> +
> +        allOf:
> +          - $ref: "http://devicetree.org/schemas/net/mdio.yaml#"

This is applied to the wrong level. It should be applied to 'mdio' node. 
You also need to drop 'http://devicetree.org'. With that, you can drop 
most of the above. IOW, just this:

mdio:
  $ref: /schemas/net/mdio.yaml#
  unevaluatedProperties: false

  properties:
    compatible:
      const: realtek,smi-mdio


> +
> +        properties:
> +          reg:
> +            maxItems: 1
> +
> +        required:
> +          - reg
> +
> +required:
> +  - compatible
> +  - mdc-gpios
> +  - mdio-gpios
> +  - reset-gpios
> +
> +additionalProperties: true

No. 'true' is only allowed for common, incomplete schemas referenced by 
other schemas. 'unevaluatedProperties: false' is what you need here.

> +
> +examples:
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +
> +    switch {
> +            compatible = "realtek,rtl8366rb";
> +            /* 22 = MDIO (has input reads), 21 = MDC (clock, output only) */
> +            mdc-gpios = <&gpio0 21 GPIO_ACTIVE_HIGH>;
> +            mdio-gpios = <&gpio0 22 GPIO_ACTIVE_HIGH>;
> +            reset-gpios = <&gpio0 14 GPIO_ACTIVE_LOW>;
> +
> +            switch_intc1: interrupt-controller {
> +                    /* GPIO 15 provides the interrupt */
> +                    interrupt-parent = <&gpio0>;
> +                    interrupts = <15 IRQ_TYPE_LEVEL_LOW>;
> +                    interrupt-controller;
> +                    #address-cells = <0>;
> +                    #interrupt-cells = <1>;
> +            };
> +
> +            ports {
> +                    #address-cells = <1>;
> +                    #size-cells = <0>;
> +                    port@0 {
> +                            reg = <0>;
> +                            label = "lan0";
> +                            phy-handle = <&phy0>;
> +                    };
> +                    port@1 {
> +                            reg = <1>;
> +                            label = "lan1";
> +                            phy-handle = <&phy1>;
> +                    };
> +                    port@2 {
> +                            reg = <2>;
> +                            label = "lan2";
> +                            phy-handle = <&phy2>;
> +                    };
> +                    port@3 {
> +                            reg = <3>;
> +                            label = "lan3";
> +                            phy-handle = <&phy3>;
> +                    };
> +                    port@4 {
> +                            reg = <4>;
> +                            label = "wan";
> +                            phy-handle = <&phy4>;
> +                    };
> +                    port@5 {
> +                            reg = <5>;
> +                            label = "cpu";
> +                            ethernet = <&gmac0>;
> +                            phy-mode = "rgmii";
> +                            fixed-link {
> +                                    speed = <1000>;
> +                                    full-duplex;
> +                            };
> +                    };
> +            };
> +
> +            mdio {
> +                    compatible = "realtek,smi-mdio";
> +                    #address-cells = <1>;
> +                    #size-cells = <0>;
> +
> +                    phy0: ethernet-phy@0 {
> +                            reg = <0>;
> +                            interrupt-parent = <&switch_intc1>;
> +                            interrupts = <0>;
> +                    };
> +                    phy1: ethernet-phy@1 {
> +                            reg = <1>;
> +                            interrupt-parent = <&switch_intc1>;
> +                            interrupts = <1>;
> +                    };
> +                    phy2: ethernet-phy@2 {
> +                            reg = <2>;
> +                            interrupt-parent = <&switch_intc1>;
> +                            interrupts = <2>;
> +                    };
> +                    phy3: ethernet-phy@3 {
> +                            reg = <3>;
> +                            interrupt-parent = <&switch_intc1>;
> +                            interrupts = <3>;
> +                    };
> +                    phy4: ethernet-phy@4 {
> +                            reg = <4>;
> +                            interrupt-parent = <&switch_intc1>;
> +                            interrupts = <12>;
> +                    };
> +            };
> +    };
> +
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +
> +    switch {
> +            compatible = "realtek,rtl8365mb";
> +            mdc-gpios = <&gpio1 16 GPIO_ACTIVE_HIGH>;
> +            mdio-gpios = <&gpio1 17 GPIO_ACTIVE_HIGH>;
> +            reset-gpios = <&gpio5 0 GPIO_ACTIVE_LOW>;
> +
> +            switch_intc2: interrupt-controller {
> +                    interrupt-parent = <&gpio5>;
> +                    interrupts = <1 IRQ_TYPE_LEVEL_LOW>;
> +                    interrupt-controller;
> +                    #address-cells = <0>;
> +                    #interrupt-cells = <1>;
> +            };
> +
> +            ports {
> +                    #address-cells = <1>;
> +                    #size-cells = <0>;
> +                    port@0 {
> +                            reg = <0>;
> +                            label = "swp0";
> +                            phy-handle = <&ethphy0>;
> +                    };
> +                    port@1 {
> +                            reg = <1>;
> +                            label = "swp1";
> +                            phy-handle = <&ethphy1>;
> +                    };
> +                    port@2 {
> +                            reg = <2>;
> +                            label = "swp2";
> +                            phy-handle = <&ethphy2>;
> +                    };
> +                    port@3 {
> +                            reg = <3>;
> +                            label = "swp3";
> +                            phy-handle = <&ethphy3>;
> +                    };
> +                    port@6 {
> +                            reg = <6>;
> +                            label = "cpu";
> +                            ethernet = <&fec1>;
> +                            phy-mode = "rgmii";
> +                            tx-internal-delay-ps = <2000>;
> +                            rx-internal-delay-ps = <2000>;
> +
> +                            fixed-link {
> +                                    speed = <1000>;
> +                                    full-duplex;
> +                                    pause;
> +                            };
> +                    };
> +            };
> +
> +            mdio {
> +                    compatible = "realtek,smi-mdio";
> +                    #address-cells = <1>;
> +                    #size-cells = <0>;
> +
> +                    ethphy0: ethernet-phy@0 {
> +                            reg = <0>;
> +                            interrupt-parent = <&switch_intc2>;
> +                            interrupts = <0>;
> +                    };
> +                    ethphy1: ethernet-phy@1 {
> +                            reg = <1>;
> +                            interrupt-parent = <&switch_intc2>;
> +                            interrupts = <1>;
> +                    };
> +                    ethphy2: ethernet-phy@2 {
> +                            reg = <2>;
> +                            interrupt-parent = <&switch_intc2>;
> +                            interrupts = <2>;
> +                    };
> +                    ethphy3: ethernet-phy@3 {
> +                            reg = <3>;
> +                            interrupt-parent = <&switch_intc2>;
> +                            interrupts = <3>;
> +                    };
> +            };
> +    };
> -- 
> 2.34.0
> 
> 
