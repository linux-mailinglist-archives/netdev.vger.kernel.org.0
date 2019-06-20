Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08A924CA59
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 11:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731557AbfFTJJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 05:09:03 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:48317 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731164AbfFTJJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 05:09:03 -0400
X-Originating-IP: 90.88.23.150
Received: from localhost (aaubervilliers-681-1-81-150.w90-88.abo.wanadoo.fr [90.88.23.150])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 145D4FF80E;
        Thu, 20 Jun 2019 09:08:57 +0000 (UTC)
Date:   Thu, 20 Jun 2019 11:08:57 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Antoine =?utf-8?Q?T=C3=A9nart?= <antoine.tenart@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v3 01/16] dt-bindings: net: Add YAML schemas for the
 generic Ethernet options
Message-ID: <20190620090857.z6gru4cilq6z7e4w@flea>
References: <27aeb33cf5b896900d5d11bd6957eda268014f0c.1560937626.git-series.maxime.ripard@bootlin.com>
 <20190619140314.GC18352@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="52tq5ryctgrkeugj"
Content-Disposition: inline
In-Reply-To: <20190619140314.GC18352@lunn.ch>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--52tq5ryctgrkeugj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andrew,

On Wed, Jun 19, 2019 at 04:03:14PM +0200, Andrew Lunn wrote:
> > +  phy-connection-type:
> > +    description:
> > +      Operation mode of the PHY interface
> > +    enum:
> > +      # There is not a standard bus between the MAC and the PHY,
> > +      # something proprietary is being used to embed the PHY in the
> > +      # MAC.
>
> ...
>
> > +
> > +  phy-mode:
> > +    $ref: "#/properties/phy-connection-type"
> > +    deprecated: true
>
> I don't think phy-mode is actually deprecated. ethernet.txt actually says:
>
> "This is now a de-facto standard property;" and no mentions that is
> should not be used. Looking at actual device trees, phy-mode is by far
> more popular than phy-connection-type.

Looking at the phy-connection-type documentation, I was under this
impression, sorry.

I'll drop it then.

> fwnode_get_phy_mode() first looks for phy-mode and only falls back to
> phy-connection-type if it is not present. The same is true for
> of_get_phy_mode().
>
> > +  fixed-link:
> > +    allOf:
> > +      - if:
> > +          type: array
> > +        then:
> > +          minItems: 1
> > +          maxItems: 1
> > +          items:
> > +            items:
> > +              - minimum: 0
> > +                maximum: 31
> > +                description:
> > +                  Emulated PHY ID, choose any but unique to the all
> > +                  specified fixed-links
> > +
> > +              - enum: [0, 1]
> > +                description:
> > +                  Duplex configuration. 0 for half duplex or 1 for
> > +                  full duplex
> > +
> > +              - enum: [10, 100, 1000]
> > +                description:
> > +                  Link speed in Mbits/sec.
> > +
> > +              - enum: [0, 1]
> > +                description:
> > +                  Pause configuration. 0 for no pause, 1 for pause
> > +
> > +              - enum: [0, 1]
> > +                description:
> > +                  Asymmetric pause configuration. 0 for no asymmetric
> > +                  pause, 1 for asymmetric pause
> > +
>
> This array of 5 values format should be marked as deprecated.

Right, I'll add it.

> > +
> > +      - if:
> > +          type: object
> > +        then:
> > +          properties:
> > +            speed:
> > +              allOf:
> > +                - $ref: /schemas/types.yaml#definitions/uint32
> > +                - enum: [10, 100, 1000]
>
> This recently changed, depending on context. If PHYLINK is being used,
> any speed is allowed. If phylib is used, then only these speeds are
> allowed. And we are starting to see some speeds other than listed
> here.

phylink seems to be described in a separate binding document, maybe we
can adjust that later?

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--52tq5ryctgrkeugj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXQtNKQAKCRDj7w1vZxhR
xU1mAP9UxX/bUs/+sGjv2lf1IVQAuWCDAFQPe+SNpltGaaRbzAD/Z9kZa0JhhgBo
aIO1LH2YT0uPFhUlcf7U7bvipC2mnQ0=
=QITW
-----END PGP SIGNATURE-----

--52tq5ryctgrkeugj--
