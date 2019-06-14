Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1CE45946
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 11:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbfFNJuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 05:50:54 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:38133 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfFNJuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 05:50:54 -0400
X-Originating-IP: 90.88.23.150
Received: from localhost (aaubervilliers-681-1-81-150.w90-88.abo.wanadoo.fr [90.88.23.150])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id F1BB4C0008;
        Fri, 14 Jun 2019 09:50:48 +0000 (UTC)
Date:   Fri, 14 Jun 2019 11:50:48 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Mark Rutland <mark.rutland@arm.com>,
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
        Antoine =?utf-8?Q?T=C3=A9nart?= <antoine.tenart@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2 05/11] dt-bindings: net: sun4i-emac: Convert the
 binding to a schemas
Message-ID: <20190614095048.j2xwdsucucbakkl2@flea>
References: <91618c7e9a5497462afa74c6d8a947f709f54331.1560158667.git-series.maxime.ripard@bootlin.com>
 <d198d29119b37b2fdb700d8992b31963e98b6693.1560158667.git-series.maxime.ripard@bootlin.com>
 <20190610143139.GG28724@lunn.ch>
 <CAL_JsqJahCJcdu=+fA=ewbGezuEJ2W6uwMVxkQpdY6w+1OWVVA@mail.gmail.com>
 <20190611145856.ua2ggkn6ccww6vpp@flea>
 <CAL_Jsq+KwH-j8f+r+fWhMuqJPWcHdBQau+nUz3NRAXYTpsyuvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="arfnxch5fo5pq4gp"
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+KwH-j8f+r+fWhMuqJPWcHdBQau+nUz3NRAXYTpsyuvg@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--arfnxch5fo5pq4gp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Rob,

On Thu, Jun 13, 2019 at 11:32:30AM -0600, Rob Herring wrote:
> On Thu, Jun 13, 2019 at 7:25 AM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> > On Mon, Jun 10, 2019 at 12:59:29PM -0600, Rob Herring wrote:
> > > On Mon, Jun 10, 2019 at 8:31 AM Andrew Lunn <andrew@lunn.ch> wrote:
> > > >
> > > > > +required:
> > > > > +  - compatible
> > > > > +  - reg
> > > > > +  - interrupts
> > > > > +  - clocks
> > > > > +  - phy
> > > > > +  - allwinner,sram
> > > >
> > > > Quoting ethernet.txt:
> > > >
> > > > - phy: the same as "phy-handle" property, not recommended for new bindings.
> > > >
> > > > - phy-handle: phandle, specifies a reference to a node representing a PHY
> > > >   device; this property is described in the Devicetree Specification and so
> > > >   preferred;
> > > >
> > > > Can this be expressed in Yaml? Accept phy, but give a warning. Accept
> > > > phy-handle without a warning? Enforce that one or the other is
> > > > present?
> > >
> > > The common schema could have 'phy: false'. This works as long as we've
> > > updated (or plan to) all the dts files to use phy-handle. The issue is
> > > how far back do you need kernels to work with newer dtbs.
> >
> > I guess another question being raised by this is how hard do we want
> > to be a deprecating things, and should the DT validation be a tool to
> > enforce that validation.
> >
> > For example, you've used in you GPIO meta-schema false for anything
> > ending with -gpio, since it's deprecated. This means that we can't
> > convert any binding using a deprecated property without introducing a
> > build error in the schemas, which in turn means that you'll have a lot
> > of friction to support schemas, since you would have to convert your
> > driver to support the new way of doing things, before being able to
> > have a schema for your binding.
>
> I've err'ed on the stricter side. We may need to back off on some
> things to get to warning free builds. Really, I'd like to have levels
> to separate checks for existing bindings, new bindings, and pedantic
> checks.

That would be awesome. Do you have a plan for that already though? I
can't really think of a way to implement it at the moment.

> For '-gpio', we may be okay because the suffix is handled in the GPIO
> core. It should be safe to update the binding to use the preferred
> form.

It might require a bit of work though in drivers, since the fallback
is only handled if you're using the gpiod API, and not the legacy one.

> > And then, we need to agree on how to express the deprecation. I guess
> > we could allow the deprecated keyword that will be there in the
> > draft-8, instead of ad-hoc solutions?
>
> Oh, nice! I hadn't seen that. Seems like we should use that. We can
> start even without draft-8 support because unknown keywords are
> ignored (though we probably have to add it to our meta-schema). Then
> at some point we can add a 'disallow deprecated' flag to the tool.

So, in the generic ethernet binding, we would have:

properties:
  phy-handle:
    $ref: /schemas/types.yaml#definitions/phandle
    description:
      Specifies a reference to a node representing a PHY device.

  phy:
    $ref: "#/properties/phy-handle"
    deprecated: true

  phy-device:
    $ref: "#/properties/phy-handle"
    deprecated: true

Does that sound good?

Now, how do we handle the case above, in the device specific binding?
We just require the non-deprecated one, or the three?

Thanks!
Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--arfnxch5fo5pq4gp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXQNt+AAKCRDj7w1vZxhR
xc/rAP9oYo3RLFWNkmJJDZDeoHTXzgtXwUn55miw6RmHtD9HuQEAvRCq1//X+pH0
3IHUv+mhhSTrjKtCcpuBHvJv5oWybg4=
=S27r
-----END PGP SIGNATURE-----

--arfnxch5fo5pq4gp--
