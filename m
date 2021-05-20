Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2BC38B7E2
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 21:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239684AbhETT5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 15:57:31 -0400
Received: from mail-oi1-f172.google.com ([209.85.167.172]:41730 "EHLO
        mail-oi1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231917AbhETT5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 15:57:30 -0400
Received: by mail-oi1-f172.google.com with SMTP id c3so17510513oic.8;
        Thu, 20 May 2021 12:56:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0VijoX5LDfg/1oOMw8LJ4ISDw0Fwkh41HHXpCYwtkuk=;
        b=t4Hwas5F0SLFu3gyJdU4YBsSLWjW8zHAibcmvnmuc7rPThICuUfzO/go/R9aiQXOUi
         8hM47Lm7cY5CiGBoW4SOW87bPu3Q1g4vWvlGe/Gkyat7MF4py3rIWHmvFHAZobcAndjj
         lCS4FpiI/WB4xNXyIeTXHpJ7i4l9xBNz17L9RGG+RZo9iBTGvix2C1VqTXs5mgD1b2sU
         aTaMfnnJQnDxIkYcMTew28eCJreeN2I5Y36U5asapie6KT+r6c8SPhqIdhGU+xoMZQJW
         MqSUvtaVAsKFiIqfIshOpGZ9YANVk44VuwtIPQTEljUHUlIh8mG4D+QmYebzumHhgvXi
         OY5w==
X-Gm-Message-State: AOAM533T+xG6FSfgBittyRhLDuENlgF+BcD6dMP5rogg+uEQ1FHneIef
        IujgOg/EB8X4F39js5wLGg==
X-Google-Smtp-Source: ABdhPJxO098MtKv/xIJDFHZb/QaNSKzx1aj3RdQ/IxvXFpRSQej3EhxKYRK3bRpKefU+2PHk7np0Ew==
X-Received: by 2002:a05:6808:488:: with SMTP id z8mr4563022oid.135.1621540567686;
        Thu, 20 May 2021 12:56:07 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id s4sm846291otr.80.2021.05.20.12.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 12:56:06 -0700 (PDT)
Received: (nullmailer pid 1840621 invoked by uid 1000);
        Thu, 20 May 2021 19:56:05 -0000
Date:   Thu, 20 May 2021 14:56:05 -0500
From:   Rob Herring <robh@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] dt-bindings: net: sms911x: Convert to json-schema
Message-ID: <20210520195605.GA1832858@robh.at.kernel.org>
References: <cover.1621518686.git.geert+renesas@glider.be>
 <f3f33f75c8911697f2c1dbde626f01187199bdc2.1621518686.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3f33f75c8911697f2c1dbde626f01187199bdc2.1621518686.git.geert+renesas@glider.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 03:58:39PM +0200, Geert Uytterhoeven wrote:
> Convert the Smart Mixed-Signal Connectivity (SMSC) LAN911x/912x
> Controller Device Tree binding documentation to json-schema.
> 
> Document missing properties.
> Make "phy-mode" not required, as many DTS files do not have it, and the
> Linux drivers falls back to PHY_INTERFACE_MODE_NA.
> Correct nodename in example.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> I have listed Shawn as the maintainer, as he wrote the original
> bindings.  Shawn: Please scream if this is inappropriate ;-)
> 
> I left "additionalProperties: true", as there are lots of bus-specific
> properties ("qcom,*", "samsung,*", "fsl,*", "gpmc,*", ...) to be found,
> that actually depend on the compatible value of the parent node.

Can you put a comment above additionalProperties to that effect. I need 
to come up with some solution for this, but don't want folks copying 
that when normally not needed.

> 
> ---
>  .../devicetree/bindings/net/gpmc-eth.txt      |   2 +-
>  .../devicetree/bindings/net/smsc,lan9115.yaml | 107 ++++++++++++++++++
>  .../devicetree/bindings/net/smsc911x.txt      |  43 -------
>  3 files changed, 108 insertions(+), 44 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/smsc,lan9115.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/smsc911x.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/gpmc-eth.txt b/Documentation/devicetree/bindings/net/gpmc-eth.txt
> index f7da3d73ca1b2e15..32821066a85b0078 100644
> --- a/Documentation/devicetree/bindings/net/gpmc-eth.txt
> +++ b/Documentation/devicetree/bindings/net/gpmc-eth.txt
> @@ -13,7 +13,7 @@ Documentation/devicetree/bindings/memory-controllers/omap-gpmc.txt
>  
>  For the properties relevant to the ethernet controller connected to the GPMC
>  refer to the binding documentation of the device. For example, the documentation
> -for the SMSC 911x is Documentation/devicetree/bindings/net/smsc911x.txt
> +for the SMSC 911x is Documentation/devicetree/bindings/net/smsc,lan9115.yaml
>  
>  Child nodes need to specify the GPMC bus address width using the "bank-width"
>  property but is possible that an ethernet controller also has a property to
> diff --git a/Documentation/devicetree/bindings/net/smsc,lan9115.yaml b/Documentation/devicetree/bindings/net/smsc,lan9115.yaml
> new file mode 100644
> index 0000000000000000..294fa3edf966695a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/smsc,lan9115.yaml
> @@ -0,0 +1,107 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/smsc,lan9115.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Smart Mixed-Signal Connectivity (SMSC) LAN911x/912x Controller
> +
> +maintainers:
> +  - Shawn Guo <shawnguo@kernel.org>
> +
> +allOf:
> +  - $ref: ethernet-controller.yaml#
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - const: smsc,lan9115
> +      - items:
> +          - enum:
> +              - "smsc,lan89218"
> +              - "smsc,lan9117"
> +              - "smsc,lan9118"
> +              - "smsc,lan9220"
> +              - "smsc,lan9221"

Don't need quotes.

> +          - const: smsc,lan9115
> +
> +  reg:
> +    maxItems: 1
> +
> +  reg-shift: true
> +
> +  reg-io-width:
> +    enum: [ 2, 4 ]
> +    default: 2
> +
> +  interrupts:
> +    minItems: 1
> +    items:
> +      - description:
> +          LAN interrupt line
> +      - description:
> +          Optional PME (power management event) interrupt that is able to wake
> +          up the host system with a 50ms pulse on network activity
> +
> +  clocks:
> +    maxItems: 1
> +
> +  phy-mode: true
> +
> +  smsc,irq-active-high:
> +    type: boolean
> +    description: Indicates the IRQ polarity is active-high
> +
> +  smsc,irq-push-pull:
> +    type: boolean
> +    description: Indicates the IRQ type is push-pull
> +
> +  smsc,force-internal-phy:
> +    type: boolean
> +    description: Forces SMSC LAN controller to use internal PHY
> +
> +  smsc,force-external-phy:
> +    type: boolean
> +    description: Forces SMSC LAN controller to use external PHY
> +
> +  smsc,save-mac-address:
> +    type: boolean
> +    description:
> +      Indicates that MAC address needs to be saved before resetting the
> +      controller
> +
> +  reset-gpios:
> +    maxItems: 1
> +    description:
> +      A GPIO line connected to the RESET (active low) signal of the device.
> +      On many systems this is wired high so the device goes out of reset at
> +      power-on, but if it is under program control, this optional GPIO can
> +      wake up in response to it.
> +
> +  vdd33a-supply:
> +    description: 3.3V analog power supply
> +
> +  vddvario-supply:
> +    description: IO logic power supply
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +
> +additionalProperties: true
> +
> +examples:
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +
> +    ethernet@f4000000 {
> +            compatible = "smsc,lan9220", "smsc,lan9115";
> +            reg = <0xf4000000 0x2000000>;
> +            phy-mode = "mii";
> +            interrupt-parent = <&gpio1>;
> +            interrupts = <31>, <32>;
> +            reset-gpios = <&gpio1 30 GPIO_ACTIVE_LOW>;
> +            reg-io-width = <4>;
> +            smsc,irq-push-pull;
> +    };
> diff --git a/Documentation/devicetree/bindings/net/smsc911x.txt b/Documentation/devicetree/bindings/net/smsc911x.txt
> deleted file mode 100644
> index acfafc8e143c4c85..0000000000000000
> --- a/Documentation/devicetree/bindings/net/smsc911x.txt
> +++ /dev/null
> @@ -1,43 +0,0 @@
> -* Smart Mixed-Signal Connectivity (SMSC) LAN911x/912x Controller
> -
> -Required properties:
> -- compatible : Should be "smsc,lan<model>", "smsc,lan9115"
> -- reg : Address and length of the io space for SMSC LAN
> -- interrupts : one or two interrupt specifiers
> -  - The first interrupt is the SMSC LAN interrupt line
> -  - The second interrupt (if present) is the PME (power
> -    management event) interrupt that is able to wake up the host
> -     system with a 50ms pulse on network activity
> -- phy-mode : See ethernet.txt file in the same directory
> -
> -Optional properties:
> -- reg-shift : Specify the quantity to shift the register offsets by
> -- reg-io-width : Specify the size (in bytes) of the IO accesses that
> -  should be performed on the device.  Valid value for SMSC LAN is
> -  2 or 4.  If it's omitted or invalid, the size would be 2.
> -- smsc,irq-active-high : Indicates the IRQ polarity is active-high
> -- smsc,irq-push-pull : Indicates the IRQ type is push-pull
> -- smsc,force-internal-phy : Forces SMSC LAN controller to use
> -  internal PHY
> -- smsc,force-external-phy : Forces SMSC LAN controller to use
> -  external PHY
> -- smsc,save-mac-address : Indicates that mac address needs to be saved
> -  before resetting the controller
> -- reset-gpios : a GPIO line connected to the RESET (active low) signal
> -  of the device. On many systems this is wired high so the device goes
> -  out of reset at power-on, but if it is under program control, this
> -  optional GPIO can wake up in response to it.
> -- vdd33a-supply, vddvario-supply : 3.3V analog and IO logic power supplies
> -
> -Examples:
> -
> -lan9220@f4000000 {
> -	compatible = "smsc,lan9220", "smsc,lan9115";
> -	reg = <0xf4000000 0x2000000>;
> -	phy-mode = "mii";
> -	interrupt-parent = <&gpio1>;
> -	interrupts = <31>, <32>;
> -	reset-gpios = <&gpio1 30 GPIO_ACTIVE_LOW>;
> -	reg-io-width = <4>;
> -	smsc,irq-push-pull;
> -};
> -- 
> 2.25.1
> 
