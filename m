Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81C0F29428
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 11:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389630AbfEXJFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 05:05:36 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:45153 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389279AbfEXJFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 05:05:36 -0400
X-Originating-IP: 90.88.147.134
Received: from localhost (aaubervilliers-681-1-27-134.w90-88.abo.wanadoo.fr [90.88.147.134])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id B1F24C0017;
        Fri, 24 May 2019 09:05:29 +0000 (UTC)
Date:   Fri, 24 May 2019 11:05:29 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Antoine =?utf-8?Q?T=C3=A9nart?= <antoine.tenart@bootlin.com>
Subject: Re: [PATCH 6/8] dt-bindings: net: stmmac: Convert the binding to a
 schemas
Message-ID: <20190524090529.bvjzapgy35pfcow5@flea>
References: <74d98cc3c744d53710c841381efd41cf5f15e656.1558605170.git-series.maxime.ripard@bootlin.com>
 <ba1a5d8ad34a8c9ab99f504c04fbe65bde42081b.1558605170.git-series.maxime.ripard@bootlin.com>
 <CAL_JsqLrE31vWVhApGgr8JU56sDc1TWWm9HiH=Z-tn5C1GwXQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="feqnt36fgpyz3hlk"
Content-Disposition: inline
In-Reply-To: <CAL_JsqLrE31vWVhApGgr8JU56sDc1TWWm9HiH=Z-tn5C1GwXQA@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--feqnt36fgpyz3hlk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Rob,

On Thu, May 23, 2019 at 10:33:05AM -0500, Rob Herring wrote:
> On Thu, May 23, 2019 at 4:57 AM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> >
> > Switch the STMMAC / Synopsys DesignWare MAC controller binding to a YAML
> > schema to enable the DT validation.
>
> You picked an easy one. ;)

Yeah, that's what happens when you run out of trivial bindings, you
end up with only the hard ones left to work on :)

> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > ---
> >  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 344 +++++++++++-
> >  Documentation/devicetree/bindings/net/stmmac.txt      | 179 +------
> >  2 files changed, 345 insertions(+), 178 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/net/snps,dwmac.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > new file mode 100644
> > index 000000000000..be3ada5121e1
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > @@ -0,0 +1,344 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/snps,dwmac.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Synopsys DesignWare MAC Device Tree Bindings
> > +
> > +maintainers:
> > +  - Alexandre Torgue <alexandre.torgue@st.com>
> > +  - Giuseppe Cavallaro <peppe.cavallaro@st.com>
> > +  - Jose Abreu <joabreu@synopsys.com>
> > +
> > +properties:
> > +  compatible:
> > +    oneOf:
> > +      - const: snps,dwmac
> > +      - const: snps,dwmac-3.50a
> > +      - const: snps,dwmac-3.610
> > +      - const: snps,dwmac-3.70a
> > +      - const: snps,dwmac-3.710
> > +      - const: snps,dwmac-4.00
> > +      - const: snps,dwmac-4.10a
> > +      - const: snps,dwxgmac
> > +      - const: snps,dwxgmac-2.10
> > +      - const: st,spear600-gmac
> > +        description: Deprecated
>
> Like the other, just make this an enum.

Ack.

I did this initially because the sun8i-emac bindings also have
multiple compatibles we can use, and thus I needed an items here, but
since we will move them away in separate files, we can just use an
enum (with a contains).

> Though, what to do on deprecated things? If we expect dts files to be
> updated, then we should remove or disallow in the schema (e.g. 'prop:
> false' for properties).

Oh, so that's what the false are here for. I wanted to send a PR to
the meta-schemas because *-gpio was not working, and that binding uses
one, but I guess that solves it.

For the deprecation process, I haven't made up my mind yet. We could
put in comment the deprecated properties and compatibles, but that has
two significant drawbacks:

  - for the compatibles, we wouldn't have the nodes with a deprecated
    compatible validated, and thus we wouldn't even have a warning
    that our compatible is deprecated in the first place. And any
    property we might have not used properly will be ignored as well.

  - for the other properties, it's still pretty hard to disable
    additionalProperties, so any deprecated property wouldn't be
    validated if they were in a comment, and we wouldn't have a
    warning either if additionalProperties is true, because we
    tolerate them.

I guess we can workaround the first one with a custom select that has
all the supported compatibles (including the deprecated ones), but
only list the non-deprecated options in the compatible properties.

I don't really see a solution for the second one.

> The issue with updating dts files, is it may break old kernels with
> new dtbs.

While this is something that is mentionned by some people, and I can
see how it's problematic to some, it's also something we never really
committed to, so I'm fine with that.

> > +  snps,axi-config:
> > +    $ref: /schemas/types.yaml#definitions/phandle
> > +    description:
> > +      AXI BUS Mode parameters. Phandle to a node that can contain the
> > +      following properties
> > +        * snps,lpi_en, enable Low Power Interface
> > +        * snps,xit_frm, unlock on WoL
> > +        * snps,wr_osr_lmt, max write outstanding req. limit
> > +        * snps,rd_osr_lmt, max read outstanding req. limit
> > +        * snps,kbbe, do not cross 1KiB boundary.
> > +        * snps,blen, this is a vector of supported burst length.
> > +        * snps,fb, fixed-burst
> > +        * snps,mb, mixed-burst
> > +        * snps,rb, rebuild INCRx Burst
>
> This obviously needs its own schema, but that can come latter.

I haven't been able to describe a node that doesn't have any
particular copmatible or node name, but we just need to follow a
phandle.

How could we do this?

> > +  snps,reset-gpio:
> > +    description:
> > +      PHY Reset GPIO
>
> maxItems: 1
>
> > +
> > +  snps,reset-active-low:
> > +    $ref: /schemas/types.yaml#definitions/flag
> > +    description:
> > +      Indicates that the PHY Reset is active low
>
> Would be nice to deprecate these 2 properties for just 'reset-gpios'.
> Though really, this should be in the phy node as this is a phy reset.

The PHYs already have such a property, so we should just deprecate
them.

> > +
> > +  snps,reset-delay-us:
> > +    allOf:
> > +      - $ref: /schemas/types.yaml#definitions/uint32-array
> > +      - minItems: 3
> > +        maxItems: 3
> > +    description:
> > +      Triplet of delays. The 1st cell is reset pre-delay in micro
> > +      seconds. The 2nd cell is reset pulse in micro seconds. The 3rd
> > +      cell is reset post-delay in micro seconds.

And this one too I guess?

> > +  snps,aal:
> > +    $ref: /schemas/types.yaml#definitions/flag
> > +    description:
> > +      Use Address-Aligned Beats
> > +
> > +  snps,fixed-burst:
> > +    $ref: /schemas/types.yaml#definitions/flag
> > +    description:
> > +      Program the DMA to use the fixed burst mode
> > +
> > +  snps,mixed-burst:
> > +    $ref: /schemas/types.yaml#definitions/flag
> > +    description:
> > +      Program the DMA to use the mixed burst mode
> > +
> > +  snps,force_thresh_dma_mode:
> > +    $ref: /schemas/types.yaml#definitions/flag
> > +    description:
> > +      Force DMA to use the threshold mode for both tx and rx
> > +
> > +  snps,force_sf_dma_mode:
> > +    $ref: /schemas/types.yaml#definitions/flag
> > +    description:
> > +      Force DMA to use the Store and Forward mode for both tx and
> > +      rx. This flag is ignored if force_thresh_dma_mode is set.
> > +
> > +  snps,en-tx-lpi-clockgating:
> > +    $ref: /schemas/types.yaml#definitions/flag
> > +    description:
> > +      Enable gating of the MAC TX clock during TX low-power mode
> > +
> > +  snps,multicast-filter-bins:
> > +    $ref: /schemas/types.yaml#definitions/uint32
> > +    description:
> > +      Number of multicast filter hash bins supported by this device
> > +      instance
> > +
> > +  snps,perfect-filter-entries:
> > +    $ref: /schemas/types.yaml#definitions/uint32
> > +    description:
> > +      Number of perfect filter entries supported by this device
> > +      instance
> > +
> > +  snps,ps-speed:
> > +    $ref: /schemas/types.yaml#definitions/uint32
> > +    description:
> > +      Port selection speed that can be passed to the core when PCS
> > +      is supported. For example, this is used in case of SGMII and
> > +      MAC2MAC connection.
> > +
> > +  mdio:
> > +    type: object
> > +    description:
> > +      Creates and registers an MDIO bus.
> > +
> > +    properties:
> > +      compatible:
> > +        const: snps,dwmac-mdio
>
> required?

Yep, I'll add it.

Thanks!
Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--feqnt36fgpyz3hlk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXOez2QAKCRDj7w1vZxhR
xe/NAPwPdSE4B39GjzI0+sjp0j/vK4Hlg4A+3uLLJjEAO/CpowD/cRbzLnJfLN2U
cEJXc12nJ54M6GHljxzLwfapQynBkQU=
=sFc+
-----END PGP SIGNATURE-----

--feqnt36fgpyz3hlk--
