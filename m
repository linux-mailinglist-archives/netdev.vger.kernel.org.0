Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A97A29497B
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 10:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441089AbgJUIsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 04:48:06 -0400
Received: from mailout07.rmx.de ([94.199.90.95]:42820 "EHLO mailout07.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441068AbgJUIsF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 04:48:05 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout07.rmx.de (Postfix) with ESMTPS id 4CGPJv6ytNzBxvh;
        Wed, 21 Oct 2020 10:47:59 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CGPJW2Gj3z2TTLb;
        Wed, 21 Oct 2020 10:47:39 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.165) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Wed, 21 Oct
 2020 10:46:35 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 1/9] dt-bindings: net: dsa: convert ksz bindings document to yaml
Date:   Wed, 21 Oct 2020 10:46:34 +0200
Message-ID: <4900322.CrMBUKQtxU@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <87lfg0rrzi.fsf@kurt>
References: <20201019172435.4416-1-ceggers@arri.de> <20201019172435.4416-2-ceggers@arri.de> <87lfg0rrzi.fsf@kurt>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.165]
X-RMX-ID: 20201021-104741-4CGPJW2Gj3z2TTLb-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, 21 October 2020, 08:52:01 CEST, Kurt Kanzenbach wrote:
> On Mon Oct 19 2020, Christian Eggers wrote:
> > Convert the bindings document for Microchip KSZ Series Ethernet switches
> > from txt to yaml.
> 
> A few comments/questions below.
> 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> > b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml new file
> > mode 100644
> > index 000000000000..f93c3bdd0b83
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> 
> Currently the bindings don't have the company names in front of it.
All current bindings are in .txt format. In other subsystems (like iio),
company names have been added when converting to yaml.

> > @@ -0,0 +1,147 @@
> > +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/dsa/microchip,ksz.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Microchip KSZ Series Ethernet switches
> > +
> > +maintainers:
> > +  - Marek Vasut <marex@denx.de>
> > +  - Woojung Huh <Woojung.Huh@microchip.com>
> > +
> > +properties:
> > +  # See Documentation/devicetree/bindings/net/dsa/dsa.yaml for a list of
> > additional +  # required and optional properties.
> 
> Don't you need to reference the dsa.yaml binding somehow?
I should have taken a look into your binding beforehand...
allOf:
  - $ref: dsa.yaml#

> > ...
> > +examples:
> > +  - |
> > +    #include <dt-bindings/gpio/gpio.h>
> > +
> > +    // Ethernet switch connected via SPI to the host, CPU port wired to eth0:
> > +    eth0 {
> > +        fixed-link {
> > +            speed = <1000>;
> > +            full-duplex;
> > +        };
> > +    };
> > +
> > +    spi0 {
> > +        #address-cells = <1>;
> > +        #size-cells = <0>;
> > +
> > +        pinctrl-0 = <&pinctrl_spi_ksz>;
> > +        cs-gpios = <&pioC 25 0>;
> > +        id = <1>;
> > +
> > +        ksz9477: ksz9477@0 {
> 
> The node names should be switch. See dsa.yaml.
changed

> 
> > +            compatible = "microchip,ksz9477";
> > +            reg = <0>;
> > +            reset-gpios = <&gpio5 0 GPIO_ACTIVE_LOW>;
> > +
> > +            spi-max-frequency = <44000000>;
> > +            spi-cpha;
> > +            spi-cpol;
> > +
> > +            ports {
> 
> ethernet-ports are preferred.
"ports" is also used in the existing driver code (ksz_switch_register()).
Would like to keep it for now, probably I can be changed later.

> 
> Thanks,
> Kurt

Below the current version for the version of the patch series.

Best regards
Christian


# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
%YAML 1.2
---
$id: http://devicetree.org/schemas/net/dsa/microchip,ksz.yaml#
$schema: http://devicetree.org/meta-schemas/core.yaml#

title: Microchip KSZ Series Ethernet switches

allOf:
  - $ref: dsa.yaml#

maintainers:
  - Marek Vasut <marex@denx.de>
  - Woojung Huh <Woojung.Huh@microchip.com>

properties:
  # See Documentation/devicetree/bindings/net/dsa/dsa.yaml for a list of additional
  # required and optional properties.
  compatible:
    enum:
      - "microchip,ksz8765"
      - "microchip,ksz8794"
      - "microchip,ksz8795"
      - "microchip,ksz9477"
      - "microchip,ksz9897"
      - "microchip,ksz9896"
      - "microchip,ksz9567"
      - "microchip,ksz8565"
      - "microchip,ksz9893"
      - "microchip,ksz9563"
      - "microchip,ksz8563"

  reset-gpios:
    description:
      Should be a gpio specifier for a reset line.
    maxItems: 1

  microchip,synclko-125:
    $ref: /schemas/types.yaml#/definitions/flag
    description:
      Set if the output SYNCLKO frequency should be set to 125MHz instead of 25MHz.

required:
  - compatible
  - reg

examples:
  - |
    #include <dt-bindings/gpio/gpio.h>

    // Ethernet switch connected via SPI to the host, CPU port wired to eth0:
    eth0 {
        fixed-link {
            speed = <1000>;
            full-duplex;
        };
    };

    spi0 {
        #address-cells = <1>;
        #size-cells = <0>;

        pinctrl-0 = <&pinctrl_spi_ksz>;
        cs-gpios = <&pioC 25 0>;
        id = <1>;

        ksz9477: switch@0 {
            compatible = "microchip,ksz9477";
            reg = <0>;
            reset-gpios = <&gpio5 0 GPIO_ACTIVE_LOW>;

            spi-max-frequency = <44000000>;
            spi-cpha;
            spi-cpol;

            ethernet-ports {
                #address-cells = <1>;
                #size-cells = <0>;
                port@0 {
                    reg = <0>;
                    label = "lan1";
                };
                port@1 {
                    reg = <1>;
                    label = "lan2";
                };
                port@2 {
                    reg = <2>;
                    label = "lan3";
                };
                port@3 {
                    reg = <3>;
                    label = "lan4";
                };
                port@4 {
                    reg = <4>;
                    label = "lan5";
                };
                port@5 {
                    reg = <5>;
                    label = "cpu";
                    ethernet = <&eth0>;
                    fixed-link {
                        speed = <1000>;
                        full-duplex;
                    };
                };
            };
        };

        ksz8565: switch@1 {
            compatible = "microchip,ksz8565";
            reg = <1>;

            spi-max-frequency = <44000000>;
            spi-cpha;
            spi-cpol;

            ethernet-ports {
                #address-cells = <1>;
                #size-cells = <0>;
                port@0 {
                    reg = <0>;
                    label = "lan1";
                };
                port@1 {
                    reg = <1>;
                    label = "lan2";
                };
                port@2 {
                    reg = <2>;
                    label = "lan3";
                };
                port@3 {
                    reg = <3>;
                    label = "lan4";
                };
                port@6 {
                    reg = <6>;
                    label = "cpu";
                    ethernet = <&eth0>;
                    fixed-link {
                        speed = <1000>;
                        full-duplex;
                    };
                };
            };
        };
    };
...







