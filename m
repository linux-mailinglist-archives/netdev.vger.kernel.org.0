Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1700828B36
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 22:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387705AbfEWUCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 16:02:05 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:50449 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387414AbfEWUCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 16:02:05 -0400
X-Originating-IP: 90.89.68.76
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 6398FC0006;
        Thu, 23 May 2019 20:01:53 +0000 (UTC)
Date:   Thu, 23 May 2019 22:01:52 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>, devicetree@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Antoine =?utf-8?Q?T=C3=A9nart?= <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/8] dt-bindings: net: Add a YAML schemas for the generic
 PHY options
Message-ID: <20190523200152.c2sz6mrzxgblslya@flea>
References: <74d98cc3c744d53710c841381efd41cf5f15e656.1558605170.git-series.maxime.ripard@bootlin.com>
 <aa5ec90854429c2d9e2c565604243e1b10cfd94b.1558605170.git-series.maxime.ripard@bootlin.com>
 <20190523143744.GB19369@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523143744.GB19369@lunn.ch>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

(Sorry for not CC'ing you on this)

On Thu, May 23, 2019 at 04:37:44PM +0200, Andrew Lunn wrote:
> On Thu, May 23, 2019 at 11:56:45AM +0200, Maxime Ripard wrote:
> > The networking PHYs have a number of available device tree properties that
> > can be used in their device tree node. Add a YAML schemas for those.
> >
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > ---
> >  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 148 +++++++++-
> >  Documentation/devicetree/bindings/net/phy.txt           |  80 +-----
> >  2 files changed, 149 insertions(+), 79 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/net/ethernet-phy.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > new file mode 100644
> > index 000000000000..eb79ee6db977
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > @@ -0,0 +1,148 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/ethernet-phy.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Ethernet PHY Generic Binding
> > +
> > +maintainers:
> > +  - David S. Miller <davem@davemloft.net>
> > +
> > +properties:
> > +  $nodename:
> > +    pattern: "^ethernet-phy(@[a-f0-9])?$"
> > +
> > +  compatible:
> > +    oneOf:
>
> I don't know the language. It is valid to have both
> ethernet-phy-ieee802.3-c45 and
> ethernet-phy-id[a-f0-9]{4}\\.[a-f0-9]{4}$".  Does this oneOf prevent
> multiple compatible strings?

I haven't tested it, I will make sure it works

> Also, the general case is no compatible at all.

This is covered already. The description here just mentions the values
available if the property is set.

The required keyword a bit later lists the required property. In this
case, compatible is omitted so we just list the available values for
the compatible property.

> > +      - const: ethernet-phy-ieee802.3-c22
> > +        description: PHYs that implement IEEE802.3 clause 22
> > +      - const: ethernet-phy-ieee802.3-c45
> > +        description: PHYs that implement IEEE802.3 clause 45
> > +      - pattern: "^ethernet-phy-id[a-f0-9]{4}\\.[a-f0-9]{4}$"
> > +        description:
> > +          The first group of digits is the 16 bit Phy Identifier 1
> > +          register, this is the chip vendor OUI bits 3:18. The
> > +          second group of digits is the Phy Identifier 2 register,
> > +          this is the chip vendor OUI bits 19:24, followed by 10
> > +          bits of a vendor specific ID.
>
> Could we try to retain:
>
> > -  If the PHY reports an incorrect ID (or none at all) then the
> > -  "compatible" list may contain an entry with the correct PHY ID in the
>      ...
>
> Using it is generally wrong, and that is not clear in the new text.

Ok, I'll add it back.

> > +
> > +  reg:
> > +    maxItems: 1
> > +    minimum: 0
> > +    maximum: 31
> > +    description:
> > +      The ID number for the PHY.
> > +
> > +  interrupts:
> > +    maxItems: 1
> > +
> > +  max-speed:
> > +    enum:
> > +      - 10
> > +      - 100
> > +      - 1000
>
> This is outdated in the text description. Any valid speed is
> supported, currently 10 - 200000, as listed in phy_setting settings().

Ack, I'll update it

Thanks!
Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
