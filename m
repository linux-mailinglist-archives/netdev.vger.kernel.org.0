Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8A644CAEF
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 22:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbhKJVG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 16:06:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233173AbhKJVG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 16:06:56 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B401DC061766
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 13:04:08 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mkulI-0006W5-PC; Wed, 10 Nov 2021 22:04:04 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1mkulF-0003X9-FF; Wed, 10 Nov 2021 22:04:00 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mkulE-0001cP-Af; Wed, 10 Nov 2021 22:04:00 +0100
Date:   Wed, 10 Nov 2021 22:03:46 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        kernel@pengutronix.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next] net: dsa: Some cleanups in remove code
Message-ID: <20211110210346.qthmuarwbuajpcp2@pengutronix.de>
References: <20211109113921.1020311-1-u.kleine-koenig@pengutronix.de>
 <20211109115434.oejplrd7rzmvad34@skbuf>
 <20211109175055.46rytrdejv56hkxv@pengutronix.de>
 <20211110131540.qxxeczi5vtzs277f@skbuf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bdgughoyimkrarul"
Content-Disposition: inline
In-Reply-To: <20211110131540.qxxeczi5vtzs277f@skbuf>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bdgughoyimkrarul
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Vladimir,

On Wed, Nov 10, 2021 at 03:15:40PM +0200, Vladimir Oltean wrote:
> On Tue, Nov 09, 2021 at 06:50:55PM +0100, Uwe Kleine-K=F6nig wrote:
> > On Tue, Nov 09, 2021 at 01:54:34PM +0200, Vladimir Oltean wrote:
> > > Your commit prefix does not reflect the fact that you are touching the
> > > vsc73xx driver. Try "net: dsa: vsc73xx: ".
> >=20
> > Oh, I missed that indeed.
> >=20
> > > On Tue, Nov 09, 2021 at 12:39:21PM +0100, Uwe Kleine-K=F6nig wrote:
> > > > vsc73xx_remove() returns zero unconditionally and no caller checks =
the
> > > > returned value. So convert the function to return no value.
> > >=20
> > > This I agree with.
> > >=20
> > > > For both the platform and the spi variant ..._get_drvdata() will ne=
ver
> > > > return NULL in .remove() because the remove callback is only called=
 after
> > > > the probe callback returned successfully and in this case driver da=
ta was
> > > > set to a non-NULL value.
> > >=20
> > > Have you read the commit message of 0650bf52b31f ("net: dsa: be
> > > compatible with masters which unregister on shutdown")?
> >=20
> > No. But I did now. I consider it very surprising that .shutdown() calls
> > the .remove() callback and would recommend to not do this. The commit
> > log seems to prove this being difficult.
>=20
> Why do you consider it surprising?

In my book .shutdown should be minimal and just silence the device, such
that it e.g. doesn't do any DMA any more.

> Many drivers implement ->shutdown by calling ->remove for the simple
> reason that ->remove provides for a well-tested code path already, and
> leaves the hardware in a known state, workable for kexec and others.
>=20
> Many drivers have buses beneath them. Those buses go away when these
> drivers unregister, and so do their children.
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> =3D> some drivers do both =3D> children of these buses should expect to be
> potentially unregistered after they've been shut down.

Do you know this happens, or do you "only" fear it might happen?

> > > To remove the check for dev_get_drvdata =3D=3D NULL in ->remove, you =
need to
> > > prove that ->remove will never be called after ->shutdown. For platfo=
rm
> > > devices this is pretty easy to prove, for SPI devices not so much.
> > > I intentionally kept the code structure the same because code gets
> > > copied around a lot, it is easy to copy from the wrong place.
> >=20
> > Alternatively remove spi_set_drvdata(spi, NULL); from
> > vsc73xx_spi_shutdown()?
>=20
> What is the end goal exactly?

My end goal is:

diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index eb7ac8a1e03c..183cf15fbdd2 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -280,7 +280,7 @@ struct spi_message;
 struct spi_driver {
        const struct spi_device_id *id_table;
        int                     (*probe)(struct spi_device *spi);
-       int                     (*remove)(struct spi_device *spi);
+       void                    (*remove)(struct spi_device *spi);
        void                    (*shutdown)(struct spi_device *spi);
        struct device_driver    driver;
 };

As (nearly) all spi drivers must be touched in the same commit, the
preparing goal is to have these remove callbacks simple, such that I
only have to replace their "return 0;" by "return;" (or nothing if it's
at the end of the function). Looking at vsc73xx's remove function I
didn't stop at this minimal goal and simplified the stuff that I thought
to be superflous.

> > Also I'm not aware how platform devices are
> > different to spi devices that the ordering of .remove and shutdown() is
> > more or less obvious than on the other bus?!
>=20
> Not sure what you mean. See the explanation above. For the "platform"
> bus, there simply isn't any code path that unregisters children on the
> ->shutdown callback. For other buses, there is.

OK, with your last mail I understood that now, thanks.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--bdgughoyimkrarul
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmGMM6wACgkQwfwUeK3K
7Algewf/ZQFbMOp8Kycq4SjYya4kmcgHgYXos/iNDk4mlsw8KQMabRszoOqB3CYO
Ox/DynLFy4VYAE8lBoEum7r8Snof1HiKfSkMicTTgpRYSekOAGhzc7Pi3N+c/CKa
mrN9haCK7RJl24dX1n59umNIa++iMBpMvOdsb4gRcbao58mZB+2eGT8RHnMW7+kg
3yl1/cq2mcMGcnkM41F4RDX/tqoyxkVV1+uKGCTdbFminxTI9FqlRH7ZA9ybNTLb
YERpggJCKK65aUlnrwg+lUrI39PUsyqZbGRXa08JNfAbyDfU2ZH5B/9tk9D7Pzvu
5fr5kjsW0IKlWUNqZUZC5WChvEKkhw==
=bqci
-----END PGP SIGNATURE-----

--bdgughoyimkrarul--
