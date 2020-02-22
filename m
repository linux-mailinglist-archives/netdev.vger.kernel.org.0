Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96D4E168E8A
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 12:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgBVLis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 06:38:48 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:60237 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgBVLis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 06:38:48 -0500
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id EF21D22F43;
        Sat, 22 Feb 2020 12:38:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1582371525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pYMuUm/RjiwigJasXlwzaROJLDQFtW/xLZX6dbkkEw8=;
        b=jjxb1gxl+A/CKSJ72cuwnqNBf6ArHNnKzSPD9x7iZC4F08A4m8eVioHSlnMGJGBlgeyiGV
        cweNejZu9JJDDdlC7tJUspPxkW+s5Z8g+gzKdPpxox7KEoEIJ34dH68J/lPMjX3w/Nro49
        QTqgTnoVhuPdn6I/YjUnutYZSa30wIQ=
From:   Michael Walle <michael@walle.cc>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, davem@davemloft.net, devicetree@vger.kernel.org,
        f.fainelli@gmail.com, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, netdev@vger.kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, vivien.didelot@gmail.com,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH v2 net-next/devicetree 4/5] arm64: dts: fsl: ls1028a: add node for Felix switch
Date:   Sat, 22 Feb 2020 12:38:29 +0100
Message-Id: <20200222113829.32431-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200219151259.14273-5-olteanv@gmail.com>
References: <20200219151259.14273-5-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++
X-Spam-Level: ****
X-Rspamd-Server: web
X-Spam-Status: No, score=4.90
X-Spam-Score: 4.90
X-Rspamd-Queue-Id: EF21D22F43
X-Spamd-Result: default: False [4.90 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[dt];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         NEURAL_SPAM(0.00)[0.629];
         DKIM_SIGNED(0.00)[];
         DBL_PROHIBIT(0.00)[0.0.0.4:email,0.0.0.2:email,0.0.0.0:email,0.0.0.3:email,0.0.0.5:email,0.0.0.1:email];
         RCPT_COUNT_TWELVE(0.00)[12];
         MID_CONTAINS_FROM(1.00)[];
         FREEMAIL_TO(0.00)[gmail.com];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c::/31, country:DE];
         FREEMAIL_CC(0.00)[lunn.ch,davemloft.net,vger.kernel.org,gmail.com,arm.com,kernel.org,walle.cc]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> Add the switch device node, available on PF5, so that the switch port
> sub-nodes (net devices) can be linked to corresponding board specific
> phy nodes (external ports) or have their link mode defined (internal
> ports).
> 
> The switch device features 6 ports, 4 with external links and 2
> internally facing to the LS1028A SoC and connected via fixed links to 2
> internal ENETC Ethernet controller ports.
> 
> Add the corresponding ENETC host port device nodes, mapped to PF2 and
> PF6 PCIe functions. Since the switch only supports tagging on one CPU
> port, only one port pair (swp4, eno2) is enabled by default and the
> other, lower speed, port pair is disabled to prevent the PCI core from
> probing them. If enabled, swp5 will be a fixed-link slave port.
> 
> DSA tagging can also be moved from the swp4-eno2 2.5G port pair to the
> 1G swp5-eno3 pair by changing the ethernet = <&enetc_port2> phandle to
> <&enetc_port3> and moving it under port5, but in that case enetc_port2
> should not be disabled, because it is the hardware owner of the Felix
> PCS and disabling its memory would result in access faults in the Felix
> DSA driver.
> 
> All ports are disabled by default, except one CPU port.
> 
> The switch's INTB interrupt line signals:
> - PTP timestamp ready in timestamp FIFO
> - TSN Frame Preemption
> 
> And don't forget to enable the 4MB BAR4 in the root complex ECAM space,
> where the switch registers are mapped.
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v2:
> Adapted phy-mode = "gmii" to phy-mode = "internal".
> 
>  .../arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 84 ++++++++++++++++++-
>  1 file changed, 83 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
> index dfead691e509..a6b9c6d1eb5e 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
> @@ -700,7 +700,9 @@
>  				  /* PF1: VF0-1 BAR0 - non-prefetchable memory */
>  				  0x82000000 0x0 0x00000000  0x1 0xf8210000  0x0 0x020000
>  				  /* PF1: VF0-1 BAR2 - prefetchable memory */
> -				  0xc2000000 0x0 0x00000000  0x1 0xf8230000  0x0 0x020000>;
> +				  0xc2000000 0x0 0x00000000  0x1 0xf8230000  0x0 0x020000
> +				  /* BAR4 (PF5) - non-prefetchable memory */
> +				  0x82000000 0x0 0x00000000  0x1 0xfc000000  0x0 0x400000>;
>  
>  			enetc_port0: ethernet@0,0 {
>  				compatible = "fsl,enetc";
> @@ -710,6 +712,18 @@
>  				compatible = "fsl,enetc";
>  				reg = <0x000100 0 0 0 0>;
>  			};
> +
> +			enetc_port2: ethernet@0,2 {
> +				compatible = "fsl,enetc";
> +				reg = <0x000200 0 0 0 0>;
> +				phy-mode = "gmii";
Can we disable this port by default in this dtsi? As mentioned in the other
mail, I'd prefer to have all ports disabled because it doesn't make sense
to have this port while having all the external ports disabled.

> +
> +				fixed-link {
> +					speed = <1000>;
> +					full-duplex;
> +				};
> +			};
> +
>  			enetc_mdio_pf3: mdio@0,3 {
>  				compatible = "fsl,enetc-mdio";
>  				reg = <0x000300 0 0 0 0>;
> @@ -722,6 +736,74 @@
>  				clocks = <&clockgen 4 0>;
>  				little-endian;
>  			};
> +
> +			ethernet-switch@0,5 {
> +				reg = <0x000500 0 0 0 0>;
> +				/* IEP INT_B */
> +				interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>;
> +
> +				ports {
> +					#address-cells = <1>;
> +					#size-cells = <0>;
> +
> +					/* external ports */
> +					mscc_felix_port0: port@0 {
> +						reg = <0>;
> +						status = "disabled";
> +					};
> +
> +					mscc_felix_port1: port@1 {
> +						reg = <1>;
> +						status = "disabled";
> +					};
> +
> +					mscc_felix_port2: port@2 {
> +						reg = <2>;
> +						status = "disabled";
> +					};
> +
> +					mscc_felix_port3: port@3 {
> +						reg = <3>;
> +						status = "disabled";
> +					};
> +
> +					/* Internal port with DSA tagging */
> +					mscc_felix_port4: port@4 {
> +						reg = <4>;
> +						phy-mode = "internal";
> +						ethernet = <&enetc_port2>;
Likewise, I'd prefer to have this disabled.

> +
> +						fixed-link {
> +							speed = <2500>;
> +							full-duplex;
> +						};
> +					};
> +
> +					/* Internal port without DSA tagging */
> +					mscc_felix_port5: port@5 {
> +						reg = <5>;
> +						phy-mode = "internal";
> +						status = "disabled";
> +
> +						fixed-link {
> +							speed = <1000>;
> +							full-duplex;
> +						};
> +					};
> +				};
> +			};
> +
> +			enetc_port3: ethernet@0,6 {
> +				compatible = "fsl,enetc";
> +				reg = <0x000600 0 0 0 0>;
> +				status = "disabled";
> +				phy-mode = "gmii";
shouldn't the status be after the phy-mode property?

-michael

> +
> +				fixed-link {
> +					speed = <1000>;
> +					full-duplex;
> +				};
> +			};
>  		};
>  	};
>  
> -- 
> 2.17.1
