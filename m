Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEA5319490
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 21:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhBKUfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 15:35:36 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:32892 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhBKUfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 15:35:31 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id BFD321C0B8A; Thu, 11 Feb 2021 21:34:31 +0100 (CET)
Date:   Thu, 11 Feb 2021 21:34:31 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Claudiu.Beznea@microchip.com, linux@armlinux.org.uk,
        andrew@lunn.ch, davem@davemloft.net, kuba@kernel.org,
        rjw@rjwysocki.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] net: phy: micrel: reconfigure the phy on resume
Message-ID: <20210211203430.GA8510@amd>
References: <ce20d4f3-3e43-154a-0f57-2c2d42752597@microchip.com>
 <ee0fd287-c737-faa5-eee1-99ffa120540a@gmail.com>
 <ae4e73e9-109f-fdb9-382c-e33513109d1c@microchip.com>
 <7976f7df-c22f-d444-c910-b0462b3d7f61@gmail.com>
 <d9fcf8da-c0b0-0f18-48e9-a7534948bc93@microchip.com>
 <20210114102508.GO1551@shell.armlinux.org.uk>
 <fe4c31a0-b807-0eb2-1223-c07d7580e1fc@microchip.com>
 <56366231-4a1f-48c3-bc29-6421ed834bdf@gmail.com>
 <20210211121701.GA31708@amd>
 <0ac6414e-b785-1f82-94a2-9aa26b357d02@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <0ac6414e-b785-1f82-94a2-9aa26b357d02@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2021-02-11 13:36:16, Heiner Kallweit wrote:
> On 11.02.2021 13:17, Pavel Machek wrote:
> > On Thu 2021-01-14 12:05:21, Heiner Kallweit wrote:
> >> On 14.01.2021 11:41, Claudiu.Beznea@microchip.com wrote:
> >>>
> >>>
> >>> On 14.01.2021 12:25, Russell King - ARM Linux admin wrote:
> >>>>
> >>>> As I've said, if phylib/PHY driver is not restoring the state of the
> >>>> PHY on resume from suspend-to-ram, then that's an issue with phylib
> >>>> and/or the phy driver.
> >>>
> >>> In the patch I proposed in this thread the restoring is done in PHY d=
river.
> >>> Do you think I should continue the investigation and check if somethi=
ng
> >>> should be done from the phylib itself?
> >>>
> >> It was the right move to approach the PM maintainers to clarify whether
> >> the resume PM callback has to assume that power had been cut off and
> >> it has to completely reconfigure the device. If they confirm this
> >> understanding, then:
> >=20
> > Power to some devices can be cut during s2ram, yes.
> >=20
> Thanks for the confirmation.
>=20
> >> - the general question remains why there's separate resume and restore
> >>   callbacks, and what restore is supposed to do that resume doesn't
> >>   have to do
> >=20
> > You'll often have same implementation, yes.
> >=20
>=20
> If resume and restore both have to assume that power was cut off,
> then they have to fully re-initialize the device. Therefore it's still
> not clear to me when you would have differing implementations for both
> callbacks.

Full re-init is easiest way, yes.

But restore had different Linux kernel already booting on device, and
maybe touching the hardware, and resume may or may not cut power to
all devices.

So yes they can be different.

Regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmAllNYACgkQMOfwapXb+vKKKwCeOJD/Y9x0bzJ0MCwFogtjpIS0
Vp8An3BO6zNGlPXqApDmQl2M87YN/7FM
=zSCl
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
