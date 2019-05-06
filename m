Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90F4F14B76
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 16:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbfEFOEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 10:04:11 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:57613 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbfEFOEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 10:04:10 -0400
Received: from localhost (aaubervilliers-681-1-29-145.w90-88.abo.wanadoo.fr [90.88.149.145])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 44D5920001E;
        Mon,  6 May 2019 14:04:05 +0000 (UTC)
Date:   Mon, 6 May 2019 16:04:04 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alban Bedel <albeu@free.fr>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 01/10] of_net: add NVMEM support to of_get_mac_address
Message-ID: <20190506140404.rg63wecj4qet2244@flea>
References: <1556893635-18549-1-git-send-email-ynezz@true.cz>
 <1556893635-18549-2-git-send-email-ynezz@true.cz>
 <20190503143643.hhfamnptcuriav4k@flea>
 <20190503154407.GE71477@meh.true.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="p37qtcksadkvh5cm"
Content-Disposition: inline
In-Reply-To: <20190503154407.GE71477@meh.true.cz>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--p37qtcksadkvh5cm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 03, 2019 at 05:44:07PM +0200, Petr =C5=A0tetiar wrote:
> Maxime Ripard <maxime.ripard@bootlin.com> [2019-05-03 16:36:43]:
>
> Hi,
>
> ...
>
> > > +	pp =3D devm_kzalloc(&pdev->dev, sizeof(*pp), GFP_KERNEL);
> > > +	if (!pp)
> > > +		return ERR_PTR(-ENOMEM);
> > > +
> > > +	pp->name =3D "nvmem-mac-address";
> > > +	pp->length =3D ETH_ALEN;
> > > +	pp->value =3D devm_kmemdup(&pdev->dev, mac, ETH_ALEN, GFP_KERNEL);
> > > +	if (!pp->value) {
> > > +		ret =3D -ENOMEM;
> > > +		goto free;
> > > +	}
> > > +
> > > +	ret =3D of_add_property(np, pp);
> > > +	if (ret)
> > > +		goto free;
> > > +
> > > +	return pp->value;
> >
> > I'm not sure why you need to do that allocation here, and why you need
> > to modify the DT?
>
> I was asked about that in v2[0] already, so just copy&pasting relevant pa=
rt of
> my response here:
>
>  I've just carried it over from v1 ("of_net: add mtd-mac-address support =
to
>  of_get_mac_address()")[1] as nobody objected about this so far.
>
>  Honestly I don't know if it's necessary to have it, but so far address,
>  mac-address and local-mac-address properties provide this DT nodes, so I=
've
>  simply thought, that it would be good to have it for MAC address from NV=
MEM as
>  well in order to stay consistent.
>
>  [...]
>
> 0. https://patchwork.ozlabs.org/patch/1092248/#2164089
> 1. https://patchwork.ozlabs.org/patch/1086628/
>
> > can't you just return the mac address directly since it's what the
> > of_get_mac_address caller will expect anyway?
>
> I don't need this stuff, I can remove it, please just tell me what is
> appropriate and I'm going to do that.

Well, if no ones need it, then there's no point in adding support for
it then?

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--p37qtcksadkvh5cm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXNA+1AAKCRDj7w1vZxhR
xbBPAQDGD/fKy0R05WqaOtYm+o/xz3E7fmM55x4yVTtBBNPaBwEAlrB12chRxf7D
hQKQJNr947sM00pol0dDHf0AdNW3xwk=
=fTWI
-----END PGP SIGNATURE-----

--p37qtcksadkvh5cm--
