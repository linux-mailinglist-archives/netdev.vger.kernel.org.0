Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 979AC2280EA
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 15:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgGUN3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 09:29:41 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:44467 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgGUN3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 09:29:41 -0400
X-Originating-IP: 90.65.108.121
Received: from localhost (lfbn-lyo-1-1676-121.w90-65.abo.wanadoo.fr [90.65.108.121])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id DA736E000C;
        Tue, 21 Jul 2020 13:29:36 +0000 (UTC)
Date:   Tue, 21 Jul 2020 15:29:36 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, robh+dt@kernel.org,
        ludovic.desroches@microchip.com
Subject: Re: [PATCH net-next 2/7] macb: bindings doc: use an MDIO node as a
 container for PHY nodes
Message-ID: <20200721132936.GQ3428@piout.net>
References: <20200721100234.1302910-1-codrin.ciubotariu@microchip.com>
 <20200721100234.1302910-3-codrin.ciubotariu@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721100234.1302910-3-codrin.ciubotariu@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The proper subject prefix is dt-bindings: net: macb:

On 21/07/2020 13:02:29+0300, Codrin Ciubotariu wrote:
> The MACB driver embeds an MDIO bus controller and for this reason there
> was no need for an MDIO sub-node present to contain the PHY nodes. Adding
> MDIO devies directly under an Ethernet node is deprecated, so an MDIO node
> is included to contain of the PHY nodes (and other MDIO devices' nodes).
> 
> Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
> ---
>  Documentation/devicetree/bindings/net/macb.txt | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
> index 0b61a90f1592..88d5199c2279 100644
> --- a/Documentation/devicetree/bindings/net/macb.txt
> +++ b/Documentation/devicetree/bindings/net/macb.txt
> @@ -32,6 +32,11 @@ Required properties:
>  The MAC address will be determined using the optional properties
>  defined in ethernet.txt.
>  
> +Optional subnodes:
> +- mdio : specifies the MDIO bus in the MACB, used as a container for PHY nodes or other
> +  nodes of devices present on the MDIO bus. Please see ethernet-phy.yaml in the same
> +  directory for more details.
> +
>  Optional properties for PHY child node:
>  - reset-gpios : Should specify the gpio for phy reset
>  - magic-packet : If present, indicates that the hardware supports waking
> @@ -48,8 +53,12 @@ Examples:
>  		local-mac-address = [3a 0e 03 04 05 06];
>  		clock-names = "pclk", "hclk", "tx_clk";
>  		clocks = <&clkc 30>, <&clkc 30>, <&clkc 13>;
> -		ethernet-phy@1 {
> -			reg = <0x1>;
> -			reset-gpios = <&pioE 6 1>;
> +		mdio {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			ethernet-phy@1 {
> +				reg = <0x1>;
> +				reset-gpios = <&pioE 6 1>;
> +			};
>  		};
>  	};
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
