Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21BC550A38
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 13:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729878AbfFXL4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 07:56:06 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:57855 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbfFXL4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 07:56:05 -0400
X-Originating-IP: 92.137.69.152
Received: from localhost (alyon-656-1-672-152.w92-137.abo.wanadoo.fr [92.137.69.152])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id DF4521BF213;
        Mon, 24 Jun 2019 11:55:58 +0000 (UTC)
Date:   Mon, 24 Jun 2019 13:55:58 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Allan Nielsen <Allan.Nielsen@microsemi.com>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next 4/6] arm64: dts: fsl: ls1028a: Add Felix switch
 port DT node
Message-ID: <20190624115558.GA5690@piout.net>
References: <1561131532-14860-1-git-send-email-claudiu.manoil@nxp.com>
 <1561131532-14860-5-git-send-email-claudiu.manoil@nxp.com>
 <20190621164940.GL31306@lunn.ch>
 <VI1PR04MB4880D8F90BBCD30BF8A69C9696E00@VI1PR04MB4880.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB4880D8F90BBCD30BF8A69C9696E00@VI1PR04MB4880.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/06/2019 11:45:37+0000, Claudiu Manoil wrote:
> Hi Andrew,
> 
> >-----Original Message-----
> >From: Andrew Lunn <andrew@lunn.ch>
> >Sent: Friday, June 21, 2019 7:50 PM
> >To: Claudiu Manoil <claudiu.manoil@nxp.com>
> >Cc: David S . Miller <davem@davemloft.net>; devicetree@vger.kernel.org;
> >Alexandre Belloni <alexandre.belloni@bootlin.com>; netdev@vger.kernel.org;
> >Alexandru Marginean <alexandru.marginean@nxp.com>; linux-
> >kernel@vger.kernel.org; UNGLinuxDriver@microchip.com; Allan Nielsen
> ><Allan.Nielsen@microsemi.com>; Rob Herring <robh+dt@kernel.org>; linux-
> >arm-kernel@lists.infradead.org
> >Subject: Re: [PATCH net-next 4/6] arm64: dts: fsl: ls1028a: Add Felix switch port
> >DT node
> >
> >On Fri, Jun 21, 2019 at 06:38:50PM +0300, Claudiu Manoil wrote:
> >> The switch device features 6 ports, 4 with external links
> >> and 2 internally facing to the ls1028a SoC and connected via
> >> fixed links to 2 internal enetc ethernet controller ports.
> >
> >Hi Claudiu
> >
> >> +			switch@0,5 {
> >> +				compatible = "mscc,felix-switch";
> >> +				reg = <0x000500 0 0 0 0>;
> >> +
> >> +				ethernet-ports {
> >> +					#address-cells = <1>;
> >> +					#size-cells = <0>;
> >> +
> >> +					/* external ports */
> >> +					switch_port0: port@0 {
> >> +						reg = <0>;
> >> +					};
> >> +					switch_port1: port@1 {
> >> +						reg = <1>;
> >> +					};
> >> +					switch_port2: port@2 {
> >> +						reg = <2>;
> >> +					};
> >> +					switch_port3: port@3 {
> >> +						reg = <3>;
> >> +					};
> >> +					/* internal to-cpu ports */
> >> +					port@4 {
> >> +						reg = <4>;
> >> +						fixed-link {
> >> +							speed = <1000>;
> >> +							full-duplex;
> >> +						};
> >> +					};
> >> +					port@5 {
> >> +						reg = <5>;
> >> +						fixed-link {
> >> +							speed = <1000>;
> >> +							full-duplex;
> >> +						};
> >> +					};
> >> +				};
> >> +			};
> >
> >This sounds like a DSA setup, where you have SoC ports connected to
> >the switch. With DSA, the CPU ports of the switch are special. We
> >don't create netdev's for them, the binding explicitly list which SoC
> >interface they are bound to, etc.
> >
> >What model are you using here? I'm just trying to understand the setup
> >to ensure it is consistent with the swichdev model.
> >
> 
> Yeah, there are 2 ethernet controller ports (managed by the enetc driver) 
> connected inside the SoC via SGMII links to 2 of the switch ports, one of
> these switch ports can be configured as CPU port (with follow-up patches).
> 
> This configuration may look prettier on DSA, but the main restriction here
> is that the entire functionality is provided by the ocelot driver which is a
> switchdev driver.  I don't think it would be a good idea to copy-paste code
> from ocelot to a separate dsa driver.
> 

We should probably make the ocelot driver a DSA driver then...


-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
