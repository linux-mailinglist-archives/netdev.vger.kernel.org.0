Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC10C22AC
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 16:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731569AbfI3OHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 10:07:15 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:44446 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730809AbfI3OHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 10:07:15 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 2B05225AD5C;
        Tue,  1 Oct 2019 00:07:13 +1000 (AEST)
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id 2DD7C9403AD; Mon, 30 Sep 2019 16:07:11 +0200 (CEST)
Date:   Mon, 30 Sep 2019 16:07:11 +0200
From:   Simon Horman <horms@verge.net.au>
To:     David Miller <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: sh_eth convert bindings to json-schema
Message-ID: <20190930140616.5ssfpyiahnuixc4e@verge.net.au>
References: <20190930140352.12401-1-horms+renesas@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930140352.12401-1-horms+renesas@verge.net.au>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 04:03:52PM +0200, Simon Horman wrote:
> Convert Renesas Electronics SH EtherMAC bindings documentation to
> json-schema.  Also name bindings documentation file according to the compat
> string being documented.
> 
> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
> ---

Sorry, I missed annotating this as being targeted at net-next.

> * Based on v5.3
> * Tested using:
>   # ARCH=arm64 make dtbs_check DT_SCHEMA_FILES=Documentation/devicetree/bindings/net/renesas,ether.yaml
>   # ARCH=arm   make dtbs_check DT_SCHEMA_FILES=Documentation/devicetree/bindings/net/renesas,ether.yaml
> ---
>  .../devicetree/bindings/net/renesas,ether.yaml     | 114 +++++++++++++++++++++
>  Documentation/devicetree/bindings/net/sh_eth.txt   |  69 -------------
>  MAINTAINERS                                        |   2 +-
>  3 files changed, 115 insertions(+), 70 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/renesas,ether.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/sh_eth.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/renesas,ether.yaml b/Documentation/devicetree/bindings/net/renesas,ether.yaml
> new file mode 100644
> index 000000000000..7f84df9790e2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/renesas,ether.yaml
> @@ -0,0 +1,114 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/renesas,ether.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Renesas Electronics SH EtherMAC
> +
> +allOf:
> +  - $ref: ethernet-controller.yaml#
> +
> +maintainers:
> +  - Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - items:
> +          - enum:
> +              - renesas,gether-r8a7740   # device is a part of R8A7740 SoC
> +              - renesas,gether-r8a77980  # device is a part of R8A77980 SoC
> +              - renesas,ether-r7s72100   # device is a part of R7S72100 SoC
> +              - renesas,ether-r7s9210    # device is a part of R7S9210 SoC
> +      - items:
> +          - enum:
> +              - renesas,ether-r8a7778    # device is a part of R8A7778 SoC
> +              - renesas,ether-r8a7779    # device is a part of R8A7779 SoC
> +          - enum:
> +              - renesas,rcar-gen1-ether  # a generic R-Car Gen1 device
> +      - items:
> +          - enum:
> +              - renesas,ether-r8a7745    # device is a part of R8A7745 SoC
> +              - renesas,ether-r8a7743    # device is a part of R8A7743 SoC
> +              - renesas,ether-r8a7790    # device is a part of R8A7790 SoC
> +              - renesas,ether-r8a7791    # device is a part of R8A7791 SoC
> +              - renesas,ether-r8a7793    # device is a part of R8A7793 SoC
> +              - renesas,ether-r8a7794    # device is a part of R8A7794 SoC
> +          - enum:
> +              - renesas,rcar-gen2-ether  # a generic R-Car Gen2 or RZ/G1 device
> +
> +  reg:
> +    items:
> +       - description: E-DMAC/feLic registers
> +       - description: TSU registers
> +    minItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  '#address-cells':
> +    description: number of address cells for the MDIO bus
> +    const: 1
> +
> +  '#size-cells':
> +    description: number of size cells on the MDIO bus
> +    const: 0
> +
> +  clocks:
> +    maxItems: 1
> +
> +  pinctrl-0: true
> +
> +  pinctrl-names: true
> +
> +  renesas,no-ether-link:
> +    type: boolean
> +    description:
> +      specify when a board does not provide a proper Ether LINK signal
> +
> +  renesas,ether-link-active-low:
> +    type: boolean
> +    description:
> +      specify when the Ether LINK signal is active-low instead of normal
> +      active-high
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - phy-mode
> +  - phy-handle
> +  - '#address-cells'
> +  - '#size-cells'
> +  - clocks
> +  - pinctrl-0
> +
> +examples:
> +  # Lager board
> +  - |
> +    #include <dt-bindings/clock/r8a7790-clock.h>
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +
> +    ethernet@ee700000 {
> +        compatible = "renesas,ether-r8a7790", "renesas,rcar-gen2-ether";
> +        reg = <0 0xee700000 0 0x400>;
> +        interrupt-parent = <&gic>;
> +        interrupts = <0 162 IRQ_TYPE_LEVEL_HIGH>;
> +        clocks = <&mstp8_clks R8A7790_CLK_ETHER>;
> +        phy-mode = "rmii";
> +        phy-handle = <&phy1>;
> +        pinctrl-0 = <&ether_pins>;
> +        pinctrl-names = "default";
> +        renesas,ether-link-active-low;
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        phy1: ethernet-phy@1 {
> +            reg = <1>;
> +            interrupt-parent = <&irqc0>;
> +            interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
> +            pinctrl-0 = <&phy1_pins>;
> +            pinctrl-names = "default";
> +        };
> +    };
> diff --git a/Documentation/devicetree/bindings/net/sh_eth.txt b/Documentation/devicetree/bindings/net/sh_eth.txt
> deleted file mode 100644
> index abc36274227c..000000000000
> --- a/Documentation/devicetree/bindings/net/sh_eth.txt
> +++ /dev/null
> @@ -1,69 +0,0 @@
> -* Renesas Electronics SH EtherMAC
> -
> -This file provides information on what the device node for the SH EtherMAC
> -interface contains.
> -
> -Required properties:
> -- compatible: Must contain one or more of the following:
> -	      "renesas,gether-r8a7740" if the device is a part of R8A7740 SoC.
> -	      "renesas,ether-r8a7743"  if the device is a part of R8A7743 SoC.
> -	      "renesas,ether-r8a7745"  if the device is a part of R8A7745 SoC.
> -	      "renesas,ether-r8a7778"  if the device is a part of R8A7778 SoC.
> -	      "renesas,ether-r8a7779"  if the device is a part of R8A7779 SoC.
> -	      "renesas,ether-r8a7790"  if the device is a part of R8A7790 SoC.
> -	      "renesas,ether-r8a7791"  if the device is a part of R8A7791 SoC.
> -	      "renesas,ether-r8a7793"  if the device is a part of R8A7793 SoC.
> -	      "renesas,ether-r8a7794"  if the device is a part of R8A7794 SoC.
> -	      "renesas,gether-r8a77980" if the device is a part of R8A77980 SoC.
> -	      "renesas,ether-r7s72100" if the device is a part of R7S72100 SoC.
> -	      "renesas,ether-r7s9210" if the device is a part of R7S9210 SoC.
> -	      "renesas,rcar-gen1-ether" for a generic R-Car Gen1 device.
> -	      "renesas,rcar-gen2-ether" for a generic R-Car Gen2 or RZ/G1
> -	                                device.
> -
> -	      When compatible with the generic version, nodes must list
> -	      the SoC-specific version corresponding to the platform
> -	      first followed by the generic version.
> -
> -- reg: offset and length of (1) the E-DMAC/feLic register block (required),
> -       (2) the TSU register block (optional).
> -- interrupts: interrupt specifier for the sole interrupt.
> -- phy-mode: see ethernet.txt file in the same directory.
> -- phy-handle: see ethernet.txt file in the same directory.
> -- #address-cells: number of address cells for the MDIO bus, must be equal to 1.
> -- #size-cells: number of size cells on the MDIO bus, must be equal to 0.
> -- clocks: clock phandle and specifier pair.
> -- pinctrl-0: phandle, referring to a default pin configuration node.
> -
> -Optional properties:
> -- pinctrl-names: pin configuration state name ("default").
> -- renesas,no-ether-link: boolean, specify when a board does not provide a proper
> -			 Ether LINK signal.
> -- renesas,ether-link-active-low: boolean, specify when the Ether LINK signal is
> -				 active-low instead of normal active-high.
> -
> -Example (Lager board):
> -
> -	ethernet@ee700000 {
> -		compatible = "renesas,ether-r8a7790",
> -		             "renesas,rcar-gen2-ether";
> -		reg = <0 0xee700000 0 0x400>;
> -		interrupt-parent = <&gic>;
> -		interrupts = <0 162 IRQ_TYPE_LEVEL_HIGH>;
> -		clocks = <&mstp8_clks R8A7790_CLK_ETHER>;
> -		phy-mode = "rmii";
> -		phy-handle = <&phy1>;
> -		pinctrl-0 = <&ether_pins>;
> -		pinctrl-names = "default";
> -		renesas,ether-link-active-low;
> -		#address-cells = <1>;
> -		#size-cells = <0>;
> -
> -		phy1: ethernet-phy@1 {
> -			reg = <1>;
> -			interrupt-parent = <&irqc0>;
> -			interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
> -			pinctrl-0 = <&phy1_pins>;
> -			pinctrl-names = "default";
> -		};
> -	};
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 296de2b51c83..496e8f156925 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13810,7 +13810,7 @@ R:	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>  L:	netdev@vger.kernel.org
>  L:	linux-renesas-soc@vger.kernel.org
>  F:	Documentation/devicetree/bindings/net/renesas,*.txt
> -F:	Documentation/devicetree/bindings/net/sh_eth.txt
> +F:	Documentation/devicetree/bindings/net/renesas,*.yaml
>  F:	drivers/net/ethernet/renesas/
>  F:	include/linux/sh_eth.h
>  
> -- 
> 2.11.0
> 
