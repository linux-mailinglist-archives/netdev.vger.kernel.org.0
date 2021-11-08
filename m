Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE72447EA2
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 12:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239093AbhKHLQ2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Nov 2021 06:16:28 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:54401 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239228AbhKHLQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 06:16:07 -0500
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 8E881240004;
        Mon,  8 Nov 2021 11:13:13 +0000 (UTC)
Date:   Mon, 8 Nov 2021 12:13:12 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v2 2/6] dt-bindings: net: convert mscc,vsc7514-switch
 bindings to yaml
Message-ID: <20211108121312.2dd46ec8@fixe.home>
In-Reply-To: <20211103104511.sgynsapyqlsamovi@skbuf>
References: <20211103091943.3878621-1-clement.leger@bootlin.com>
        <20211103091943.3878621-3-clement.leger@bootlin.com>
        <20211103104511.sgynsapyqlsamovi@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Wed, 3 Nov 2021 10:45:12 +0000,
Vladimir Oltean <vladimir.oltean@nxp.com> a écrit :

> On Wed, Nov 03, 2021 at 10:19:39AM +0100, Clément Léger wrote:
> > Convert existing bindings to yaml format. In the same time, remove non
> > exiting properties ("inj" interrupt) and add fdma.
> > 
> > Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> > ---
> >  .../bindings/net/mscc,vsc7514-switch.yaml     | 184 ++++++++++++++++++
> >  .../devicetree/bindings/net/mscc-ocelot.txt   |  83 --------
> >  2 files changed, 184 insertions(+), 83 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
> >  delete mode 100644 Documentation/devicetree/bindings/net/mscc-ocelot.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
> > new file mode 100644
> > index 000000000000..0c96eabf9d2d
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
> > @@ -0,0 +1,184 @@
> > +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/mscc,vsc7514-switch.yaml
> > +$schema: http://devicetree.org/meta-schemas/core.yaml
> > +
> > +title: Microchip VSC7514 Ethernet switch controller
> > +
> > +maintainers:
> > +  - Vladimir Oltean <vladimir.oltean@nxp.com>
> > +  - Claudiu Manoil <claudiu.manoil@nxp.com>
> > +  - Alexandre Belloni <alexandre.belloni@bootlin.com>
> > +
> > +description: |
> > +  The VSC7514 Industrial IoT Ethernet switch contains four integrated dual media
> > +  10/100/1000BASE-T PHYs, two 1G SGMII/SerDes, two 1G/2.5G SGMII/SerDes, and an
> > +  option for either a 1G/2.5G SGMII/SerDes Node Processor Interface (NPI) or a
> > +  PCIe interface for external CPU connectivity. The NPI/PCIe can operate as a
> > +  standard Ethernet port.  
> 
> Technically any port can serve as NPI, not just the SERDES ones. People
> are even using internal PHY ports as NPI.
> https://patchwork.kernel.org/project/netdevbpf/patch/20210814025003.2449143-11-colin.foster@in-advantage.com/#24381029
> 
> Honestly I would not bother talking about NPI, it is confusing to see it here.
> Anything having to do with the NPI port is the realm of DSA.
> 
> Just say how the present driver expects to control the device, don't
> just copy stuff from marketing slides. In this case PCIe is irrelevant
> too, this driver is for a platform device, and it only runs on the
> embedded processor as far as I can tell.
>

Ack
 
> > +
> > +  The device provides a rich set of Industrial Ethernet switching features such
> > +  as fast protection switching, 1588 precision time protocol, and synchronous
> > +  Ethernet. Advanced TCAM-based VLAN and QoS processing enable delivery of
> > +  differentiated services. Security is assured through frame processing using
> > +  Microsemi’s TCAM-based Versatile Content Aware Processor.  
> 
> Above you say Microchip, and here you say Microsemi.
> 
> > +
> > +  In addition, the device contains a powerful 500 MHz CPU enabling full
> > +  management of the switch.  
> 
> ~powerful~
> 
> > +
> > +properties:
> > +  $nodename:
> > +    pattern: "^switch@[0-9a-f]+$"
> > +
> > +  compatible:
> > +    const: mscc,vsc7514-switch
> > +
> > +  reg:
> > +    items:
> > +      - description: system target
> > +      - description: rewriter target
> > +      - description: qs target
> > +      - description: PTP target
> > +      - description: Port0 target
> > +      - description: Port1 target
> > +      - description: Port2 target
> > +      - description: Port3 target
> > +      - description: Port4 target
> > +      - description: Port5 target
> > +      - description: Port6 target
> > +      - description: Port7 target
> > +      - description: Port8 target
> > +      - description: Port9 target
> > +      - description: Port10 target
> > +      - description: QSystem target
> > +      - description: Analyzer target
> > +      - description: S0 target
> > +      - description: S1 target
> > +      - description: S2 target
> > +      - description: fdma target
> > +
> > +  reg-names:
> > +    items:
> > +      - const: sys
> > +      - const: rew
> > +      - const: qs
> > +      - const: ptp
> > +      - const: port0
> > +      - const: port1
> > +      - const: port2
> > +      - const: port3
> > +      - const: port4
> > +      - const: port5
> > +      - const: port6
> > +      - const: port7
> > +      - const: port8
> > +      - const: port9
> > +      - const: port10
> > +      - const: qsys
> > +      - const: ana
> > +      - const: s0
> > +      - const: s1
> > +      - const: s2
> > +      - const: fdma
> > +
> > +  interrupts:
> > +    minItems: 1
> > +    items:
> > +      - description: PTP ready
> > +      - description: register based extraction
> > +      - description: frame dma based extraction
> > +
> > +  interrupt-names:
> > +    minItems: 1
> > +    items:
> > +      - const: ptp_rdy
> > +      - const: xtr
> > +      - const: fdma
> > +
> > +  ethernet-ports:
> > +    type: object
> > +    patternProperties:
> > +      "^port@[0-9a-f]+$":
> > +        type: object
> > +        description: Ethernet ports handled by the switch
> > +
> > +        allOf:
> > +          - $ref: ethernet-controller.yaml#  
> 
> I'm pretty sure Rob will comment that this can be simplified to:
> 
>            $ref: ethernet-controller.yaml#
> 
> without the allOf: and "-".

Ok

> 
> > +
> > +        properties:
> > +          '#address-cells':
> > +            const: 1
> > +          '#size-cells':
> > +            const: 0
> > +
> > +          reg:
> > +            description: Switch port number
> > +
> > +          phy-handle: true
> > +
> > +          mac-address: true
> > +
> > +        required:
> > +          - reg
> > +          - phy-handle  
> 
> Shouldn't there be additionalProperties: false for the port node as well?
> 
> And actually, phy-handle is not strictly required, if you have a
> fixed-link. I think you should use oneOf.

Ok

> 
> And you know what else is required? phy-mode. See commits e6e12df625f2
> ("net: mscc: ocelot: convert to phylink") and eba54cbb92d2 ("MIPS: mscc:
> ocelot: mark the phy-mode for internal PHY ports").

Ok, so I guess the binding text file was not updated back then. I'll fix
that.

> 
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - reg-names
> > +  - interrupts
> > +  - interrupt-names
> > +  - ethernet-ports
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    switch@1010000 {
> > +      compatible = "mscc,vsc7514-switch";
> > +      reg = <0x1010000 0x10000>,
> > +            <0x1030000 0x10000>,
> > +            <0x1080000 0x100>,
> > +            <0x10e0000 0x10000>,
> > +            <0x11e0000 0x100>,
> > +            <0x11f0000 0x100>,
> > +            <0x1200000 0x100>,
> > +            <0x1210000 0x100>,
> > +            <0x1220000 0x100>,
> > +            <0x1230000 0x100>,
> > +            <0x1240000 0x100>,
> > +            <0x1250000 0x100>,
> > +            <0x1260000 0x100>,
> > +            <0x1270000 0x100>,
> > +            <0x1280000 0x100>,
> > +            <0x1800000 0x80000>,
> > +            <0x1880000 0x10000>,
> > +            <0x1040000 0x10000>,
> > +            <0x1050000 0x10000>,
> > +            <0x1060000 0x10000>,
> > +            <0x1a0 0x1c4>;
> > +      reg-names = "sys", "rew", "qs", "ptp", "port0", "port1",
> > +            "port2", "port3", "port4", "port5", "port6",
> > +            "port7", "port8", "port9", "port10", "qsys",
> > +            "ana", "s0", "s1", "s2", "fdma";
> > +      interrupts = <18 21 16>;
> > +      interrupt-names = "ptp_rdy", "xtr", "fdma";
> > +
> > +      ethernet-ports {
> > +        #address-cells = <1>;
> > +        #size-cells = <0>;
> > +
> > +        port0: port@0 {
> > +          reg = <0>;
> > +          phy-handle = <&phy0>;
> > +        };
> > +        port1: port@1 {
> > +          reg = <1>;
> > +          phy-handle = <&phy1>;
> > +        };
> > +      };
> > +    };
> > +
> > +...
> > +#  vim: set ts=2 sw=2 sts=2 tw=80 et cc=80 ft=yaml :
> > diff --git a/Documentation/devicetree/bindings/net/mscc-ocelot.txt b/Documentation/devicetree/bindings/net/mscc-ocelot.txt
> > deleted file mode 100644
> > index 3b6290b45ce5..000000000000
> > --- a/Documentation/devicetree/bindings/net/mscc-ocelot.txt
> > +++ /dev/null
> > @@ -1,83 +0,0 @@
> > -Microsemi Ocelot network Switch
> > -===============================
> > -
> > -The Microsemi Ocelot network switch can be found on Microsemi SoCs (VSC7513,
> > -VSC7514)
> > -
> > -Required properties:
> > -- compatible: Should be "mscc,vsc7514-switch"
> > -- reg: Must contain an (offset, length) pair of the register set for each
> > -  entry in reg-names.
> > -- reg-names: Must include the following entries:
> > -  - "sys"
> > -  - "rew"
> > -  - "qs"
> > -  - "ptp" (optional due to backward compatibility)
> > -  - "qsys"
> > -  - "ana"
> > -  - "portX" with X from 0 to the number of last port index available on that
> > -    switch
> > -- interrupts: Should contain the switch interrupts for frame extraction,
> > -  frame injection and PTP ready.
> > -- interrupt-names: should contain the interrupt names: "xtr", "inj". Can contain
> > -  "ptp_rdy" which is optional due to backward compatibility.
> > -- ethernet-ports: A container for child nodes representing switch ports.
> > -
> > -The ethernet-ports container has the following properties
> > -
> > -Required properties:
> > -
> > -- #address-cells: Must be 1
> > -- #size-cells: Must be 0
> > -
> > -Each port node must have the following mandatory properties:
> > -- reg: Describes the port address in the switch
> > -
> > -Port nodes may also contain the following optional standardised
> > -properties, described in binding documents:
> > -
> > -- phy-handle: Phandle to a PHY on an MDIO bus. See
> > -  Documentation/devicetree/bindings/net/ethernet.txt for details.
> > -
> > -Example:
> > -
> > -	switch@1010000 {
> > -		compatible = "mscc,vsc7514-switch";
> > -		reg = <0x1010000 0x10000>,
> > -		      <0x1030000 0x10000>,
> > -		      <0x1080000 0x100>,
> > -		      <0x10e0000 0x10000>,
> > -		      <0x11e0000 0x100>,
> > -		      <0x11f0000 0x100>,
> > -		      <0x1200000 0x100>,
> > -		      <0x1210000 0x100>,
> > -		      <0x1220000 0x100>,
> > -		      <0x1230000 0x100>,
> > -		      <0x1240000 0x100>,
> > -		      <0x1250000 0x100>,
> > -		      <0x1260000 0x100>,
> > -		      <0x1270000 0x100>,
> > -		      <0x1280000 0x100>,
> > -		      <0x1800000 0x80000>,
> > -		      <0x1880000 0x10000>;
> > -		reg-names = "sys", "rew", "qs", "ptp", "port0", "port1",
> > -			    "port2", "port3", "port4", "port5", "port6",
> > -			    "port7", "port8", "port9", "port10", "qsys",
> > -			    "ana";
> > -		interrupts = <18 21 22>;
> > -		interrupt-names = "ptp_rdy", "xtr", "inj";
> > -
> > -		ethernet-ports {
> > -			#address-cells = <1>;
> > -			#size-cells = <0>;
> > -
> > -			port0: port@0 {
> > -				reg = <0>;
> > -				phy-handle = <&phy0>;
> > -			};
> > -			port1: port@1 {
> > -				reg = <1>;
> > -				phy-handle = <&phy1>;
> > -			};
> > -		};
> > -	};
> > -- 
> > 2.33.0
>   



-- 
Clément Léger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
