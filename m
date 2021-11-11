Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E71F44D2CB
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 08:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhKKIAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 03:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbhKKIAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 03:00:50 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBAA8C061766
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 23:58:01 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1ml4y7-0006dU-Bf; Thu, 11 Nov 2021 08:57:59 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1ml4y6-0005ws-Ef; Thu, 11 Nov 2021 08:57:57 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1ml4y5-0003TV-BL; Thu, 11 Nov 2021 08:57:57 +0100
Date:   Thu, 11 Nov 2021 08:57:54 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next] net: dsa: Some cleanups in remove code
Message-ID: <20211111075754.wnwtcfun3hjthh4v@pengutronix.de>
References: <20211109113921.1020311-1-u.kleine-koenig@pengutronix.de>
 <20211109115434.oejplrd7rzmvad34@skbuf>
 <20211109175055.46rytrdejv56hkxv@pengutronix.de>
 <20211110131540.qxxeczi5vtzs277f@skbuf>
 <20211110210346.qthmuarwbuajpcp2@pengutronix.de>
 <20211110225611.h6klnoscntufdsv3@skbuf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="w77zmxw3lswici7c"
Content-Disposition: inline
In-Reply-To: <20211110225611.h6klnoscntufdsv3@skbuf>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--w77zmxw3lswici7c
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Vladimir,

On Thu, Nov 11, 2021 at 12:56:11AM +0200, Vladimir Oltean wrote:
> On Wed, Nov 10, 2021 at 10:03:46PM +0100, Uwe Kleine-K=F6nig wrote:
> > Hello Vladimir,
> >=20
> > On Wed, Nov 10, 2021 at 03:15:40PM +0200, Vladimir Oltean wrote:
> > > On Tue, Nov 09, 2021 at 06:50:55PM +0100, Uwe Kleine-K=F6nig wrote:
> > > > On Tue, Nov 09, 2021 at 01:54:34PM +0200, Vladimir Oltean wrote:
> > > > > Your commit prefix does not reflect the fact that you are touchin=
g the
> > > > > vsc73xx driver. Try "net: dsa: vsc73xx: ".
> > > >=20
> > > > Oh, I missed that indeed.
> > > >=20
> > > > > On Tue, Nov 09, 2021 at 12:39:21PM +0100, Uwe Kleine-K=F6nig wrot=
e:
> > > > > > vsc73xx_remove() returns zero unconditionally and no caller che=
cks the
> > > > > > returned value. So convert the function to return no value.
> > > > >=20
> > > > > This I agree with.
> > > > >=20
> > > > > > For both the platform and the spi variant ..._get_drvdata() wil=
l never
> > > > > > return NULL in .remove() because the remove callback is only ca=
lled after
> > > > > > the probe callback returned successfully and in this case drive=
r data was
> > > > > > set to a non-NULL value.
> > > > >=20
> > > > > Have you read the commit message of 0650bf52b31f ("net: dsa: be
> > > > > compatible with masters which unregister on shutdown")?
> > > >=20
> > > > No. But I did now. I consider it very surprising that .shutdown() c=
alls
> > > > the .remove() callback and would recommend to not do this. The comm=
it
> > > > log seems to prove this being difficult.
> > >=20
> > > Why do you consider it surprising?
> >=20
> > In my book .shutdown should be minimal and just silence the device, such
> > that it e.g. doesn't do any DMA any more.
>=20
> To me, the more important thing to consider is that many drivers lack
> any ->shutdown hook at all, and making their ->shutdown simply call
> ->remove is often times the least-effort path of doing something
> reasonable towards quiescing the hardware. Not to mention the lesser
> evil compared to not having a ->shutdown at all.
>=20
> That's not to say I am not in favor of a minimal shutdown procedure if
> possible. Notice how DSA has dsa_switch_shutdown() vs dsa_unregister_swit=
ch().
> But judging what should go into dsa_switch_shutdown() was definitely not
> simple and there might still be corner cases that I missed - although it
> works for now, knock on wood.
>=20
> The reality is that you'll have a very hard time convincing people to
> write a dedicated code path for shutdown, if you can convince them to
> write one at all. They wouldn't even know if it does all the right
> things - it's not like you kexec every day (unless you're using Linux as
> a bootloader - but then again, if you do that you're kind of asking for
> trouble - the reason why this is the case is exactly because not having
> a ->shutdown hook implemented by drivers is an option, and the driver
> core doesn't e.g. fall back to calling the ->remove method, even with
> all the insanity that might ensue).

Maybe I'm missing an important point here, but I thought it to be fine
for most drivers not to have a .shutdown hook.

> > > Many drivers implement ->shutdown by calling ->remove for the simple
> > > reason that ->remove provides for a well-tested code path already, and
> > > leaves the hardware in a known state, workable for kexec and others.
> > >=20
> > > Many drivers have buses beneath them. Those buses go away when these
> > > drivers unregister, and so do their children.
> > >=20
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >=20
> > > =3D> some drivers do both =3D> children of these buses should expect =
to be
> > > potentially unregistered after they've been shut down.
> >=20
> > Do you know this happens, or do you "only" fear it might happen?
>=20
> Are you asking whether there are SPI controllers that implement
> ->shutdown as ->remove?

No I ask if it happens a lot / sometimes / ever that a driver's remove
callback is run for a device that was already shut down.

> Just search for "\.shutdown" in drivers/spi.
> 3 out of 3 implementations call ->remove.
>=20
> If you really have time to waste, here, have fun: Lino Sanfilippo had
> not one, but two (!!!) reboot problems with his ksz9897 Ethernet switch
> connected to a Raspberry Pi, both of which were due to other drivers
> implementing their ->shutdown as ->remove. First driver was the DSA
> master/host port (bcmgenet), the other was the bcm2835_spi controller.
> https://patchwork.kernel.org/project/netdevbpf/cover/20210909095324.12978=
-1-LinoSanfilippo@gmx.de/
> https://patchwork.kernel.org/project/netdevbpf/cover/20210912120932.99344=
0-1-vladimir.oltean@nxp.com/
> https://patchwork.kernel.org/project/netdevbpf/cover/20210917133436.55399=
5-1-vladimir.oltean@nxp.com/
> As soon as we implemented ->shutdown in DSA drivers (which we had mostly
> not done up until that thread) we ran into the surprise that ->remove
> will get called too. Yay. It wasn't trivial to sort out, but we did it
> eventually in a more systematic way. Not sure whether there's anything
> to change at the drivers/base/ level.

What I wonder is: There are drivers that call .remove from .shutdown. Is
the right action to make other parts of the kernel robust with this
behaviour, or should the drivers changed to not call .remove from
=2Eshutdown?

IMHO this is a question of promises of/expectations against the core
device layer. It must be known if for a shut down device there is (and
should be) a possibility that .remove is called. Depending on that
device drivers must be ready for this to happen, or can rely on it not
to happen.

=46rom a global maintenance POV it would be good if it could not happen,
because then the complexity is concentrated to a small place (i.e. the
driver core, or maybe generic code in all subsystems) instead of making
each and every driver robust to this possible event that a considerable
part of the driver writers isn't aware of.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--w77zmxw3lswici7c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmGMzP8ACgkQwfwUeK3K
7Ak5Qgf/dNhqKBiPdckShWuvioQwsc0pZuMPEfqk56rMQ8jbUkhBmeNKxuNJ2zaP
BheOMlwoU1oHucbGd+hGM5S8jJRqV3INY6dL5O1ZQqm95D95G4pjHpzZEoREKA7J
XpRHC+bmmLQlL9pmO2AzSYXFkqyRTc5Cl0WbWUE5J6G0uGoi4DQ82SxzFYCI2+v+
INf7xRkpvc/xhS7jEhdzCZsQTTVBAqyXkPRKylATz3N1Wyg/YPUCaebIC6pX5fG+
WUKvpYwPuYCTuS96yJ+8tbljivgiVwPX8xa1FLFEtK3Zca+CtADeSx5aHKHHbtTk
pZVOFvu5YZx6O+khr4rPsZlz44OvIQ==
=JVHD
-----END PGP SIGNATURE-----

--w77zmxw3lswici7c--
