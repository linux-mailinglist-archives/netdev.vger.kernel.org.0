Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010741CEA6B
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 04:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbgELCB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 22:01:29 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:45748 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727892AbgELCB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 22:01:29 -0400
Received: by mail-oi1-f196.google.com with SMTP id k133so16736039oih.12;
        Mon, 11 May 2020 19:01:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=czrIsdP31tdcxDtB1xe4T17Dg1vLDkIDYdtdygiUTRo=;
        b=MNwXB6tjvtR2LoarcSdmXUtD8jQoeuwk5DvKSQ0idPhpti5RCW366AW+k8BgNsq9Cm
         70BOa95/KJilI0O2lumqCEER5B/OE5ebWP0uW9y+5OZWPoByvjKIxacdzDjMjG4GmEo5
         MZe3gDVms/2DKXffLNeRV4/BxAK2KtfdmA+BXafXvvhLbrLZbmpwbDVz+9LNDtGmUvo4
         PYY0Uq9LFg6ikZn603R11bzh7FD8LDZnkU08PRvKIVOzVSoKhRs6QFO6vcv74i2tYfQN
         o6zma0G+FgVKloTqFo/Y3sjykqkUIctCX9zNjTmhcJnA3+zs0QofVPphgLcHG9KiCcRT
         uHtg==
X-Gm-Message-State: AGi0PuZazfsqsgdNps31KiaGA9Kxt0oYZM0/FDKTSRMKVJ4xauJ0FCI0
        pETsB2Z7Z9Te+r9TXH7dDw==
X-Google-Smtp-Source: APiQypLgYcOz8qrWFrjJhzlHKPYHwX9/yN/oW9ISWgjWp+EMSVnfdHDAulPu0L/QF7egHog7BK6v9A==
X-Received: by 2002:aca:4e10:: with SMTP id c16mr21922126oib.140.1589248887866;
        Mon, 11 May 2020 19:01:27 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 60sm3120813oth.38.2020.05.11.19.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 19:01:27 -0700 (PDT)
Received: (nullmailer pid 26411 invoked by uid 1000);
        Tue, 12 May 2020 02:01:26 -0000
Date:   Mon, 11 May 2020 21:01:26 -0500
From:   Rob Herring <robh@kernel.org>
To:     Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] dt-bindings: net: Convert UniPhier AVE4 controller
 to json-schema
Message-ID: <20200512020126.GA22178@bogus>
References: <1588055482-13012-1-git-send-email-hayashi.kunihiko@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1588055482-13012-1-git-send-email-hayashi.kunihiko@socionext.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 03:31:22PM +0900, Kunihiko Hayashi wrote:
> Convert the UniPhier AVE4 controller binding to DT schema format.
> This changes phy-handle property to required.
> 
> Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
> ---
>  .../bindings/net/socionext,uniphier-ave4.txt       |  64 ------------
>  .../bindings/net/socionext,uniphier-ave4.yaml      | 109 +++++++++++++++++++++
>  MAINTAINERS                                        |   2 +-
>  3 files changed, 110 insertions(+), 65 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/socionext,uniphier-ave4.txt
>  create mode 100644 Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.txt b/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.txt
> deleted file mode 100644
> index 4e85fc4..0000000
> --- a/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.txt
> +++ /dev/null
> @@ -1,64 +0,0 @@
> -* Socionext AVE ethernet controller
> -
> -This describes the devicetree bindings for AVE ethernet controller
> -implemented on Socionext UniPhier SoCs.
> -
> -Required properties:
> - - compatible: Should be
> -	- "socionext,uniphier-pro4-ave4" : for Pro4 SoC
> -	- "socionext,uniphier-pxs2-ave4" : for PXs2 SoC
> -	- "socionext,uniphier-ld11-ave4" : for LD11 SoC
> -	- "socionext,uniphier-ld20-ave4" : for LD20 SoC
> -	- "socionext,uniphier-pxs3-ave4" : for PXs3 SoC
> - - reg: Address where registers are mapped and size of region.
> - - interrupts: Should contain the MAC interrupt.
> - - phy-mode: See ethernet.txt in the same directory. Allow to choose
> -	"rgmii", "rmii", "mii", or "internal" according to the PHY.
> -	The acceptable mode is SoC-dependent.
> - - phy-handle: Should point to the external phy device.
> -	See ethernet.txt file in the same directory.
> - - clocks: A phandle to the clock for the MAC.
> -	For Pro4 SoC, that is "socionext,uniphier-pro4-ave4",
> -	another MAC clock, GIO bus clock and PHY clock are also required.
> - - clock-names: Should contain
> -	- "ether", "ether-gb", "gio", "ether-phy" for Pro4 SoC
> -	- "ether" for others
> - - resets: A phandle to the reset control for the MAC. For Pro4 SoC,
> -	GIO bus reset is also required.
> - - reset-names: Should contain
> -	- "ether", "gio" for Pro4 SoC
> -	- "ether" for others
> - - socionext,syscon-phy-mode: A phandle to syscon with one argument
> -	that configures phy mode. The argument is the ID of MAC instance.
> -
> -The MAC address will be determined using the optional properties
> -defined in ethernet.txt.
> -
> -Required subnode:
> - - mdio: A container for child nodes representing phy nodes.
> -         See phy.txt in the same directory.
> -
> -Example:
> -
> -	ether: ethernet@65000000 {
> -		compatible = "socionext,uniphier-ld20-ave4";
> -		reg = <0x65000000 0x8500>;
> -		interrupts = <0 66 4>;
> -		phy-mode = "rgmii";
> -		phy-handle = <&ethphy>;
> -		clock-names = "ether";
> -		clocks = <&sys_clk 6>;
> -		reset-names = "ether";
> -		resets = <&sys_rst 6>;
> -		socionext,syscon-phy-mode = <&soc_glue 0>;
> -		local-mac-address = [00 00 00 00 00 00];
> -
> -		mdio {
> -			#address-cells = <1>;
> -			#size-cells = <0>;
> -
> -			ethphy: ethphy@1 {
> -				reg = <1>;
> -			};
> -		};
> -	};
> diff --git a/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml b/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml
> new file mode 100644
> index 0000000..fd31e87
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml
> @@ -0,0 +1,109 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/socionext,uniphier-ave4.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Socionext AVE ethernet controller
> +
> +maintainers:
> +  - Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
> +
> +description: |
> +  This describes the devicetree bindings for AVE ethernet controller
> +  implemented on Socionext UniPhier SoCs.
> +
> +allOf:
> +  - $ref: ethernet-controller.yaml#
> +
> +properties:
> +  compatible:
> +    enum:
> +      - socionext,uniphier-pro4-ave4
> +      - socionext,uniphier-pxs2-ave4
> +      - socionext,uniphier-ld11-ave4
> +      - socionext,uniphier-ld20-ave4
> +      - socionext,uniphier-pxs3-ave4
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  phy-mode:
> +    $ref: ethernet-controller.yaml#/properties/phy-mode
> +
> +  phy-handle:
> +    $ref: ethernet-controller.yaml#/properties/phy-handle

No need for these $ref, the 1st reference did this. Just:

phy-mode: true

> +
> +  clocks:
> +    minItems: 1
> +    maxItems: 4
> +
> +  clock-names:
> +    oneOf:
> +      - items:          # for Pro4
> +        - const: gio
> +        - const: ether
> +        - const: ether-gb
> +        - const: ether-phy
> +      - const: ether    # for others
> +
> +  resets:
> +    minItems: 1
> +    maxItems: 2
> +
> +  reset-names:
> +    oneOf:
> +      - items:          # for Pro4
> +        - const: gio
> +        - const: ether
> +      - const: ether    # for others
> +
> +  socionext,syscon-phy-mode:
> +    $ref: /schemas/types.yaml#definitions/phandle-array
> +    description:
> +      A phandle to syscon with one argument that configures phy mode.
> +      The argument is the ID of MAC instance.
> +
> +  mdio:
> +    $ref: mdio.yaml#
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - phy-mode
> +  - phy-handle
> +  - clocks
> +  - clock-names
> +  - resets
> +  - reset-names
> +  - mdio
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    ether: ethernet@65000000 {
> +        compatible = "socionext,uniphier-ld20-ave4";
> +                reg = <0x65000000 0x8500>;
> +                interrupts = <0 66 4>;
> +                phy-mode = "rgmii";
> +                phy-handle = <&ethphy>;
> +                clock-names = "ether";
> +                clocks = <&sys_clk 6>;
> +                reset-names = "ether";
> +                resets = <&sys_rst 6>;
> +                socionext,syscon-phy-mode = <&soc_glue 0>;
> +
> +                mdio {
> +                        #address-cells = <1>;
> +                        #size-cells = <0>;
> +
> +                        ethphy: ethernet-phy@1 {
> +                                reg = <1>;
> +                        };
> +                };
> +        };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a1558eb..0ee65e2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15590,7 +15590,7 @@ SOCIONEXT (SNI) AVE NETWORK DRIVER
>  M:	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
>  L:	netdev@vger.kernel.org
>  S:	Maintained
> -F:	Documentation/devicetree/bindings/net/socionext,uniphier-ave4.txt
> +F:	Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml
>  F:	drivers/net/ethernet/socionext/sni_ave.c
>  
>  SOCIONEXT (SNI) NETSEC NETWORK DRIVER
> -- 
> 2.7.4
> 
