Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9DF3E051A
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 18:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239297AbhHDQCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 12:02:11 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:39410 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236453AbhHDQCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 12:02:09 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6B8101C0B76; Wed,  4 Aug 2021 18:01:55 +0200 (CEST)
Date:   Wed, 4 Aug 2021 18:01:54 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Ben Whitten <ben.whitten@gmail.com>, Dan Murphy <dmurphy@ti.com>,
        linux-leds@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: leds: netdev trigger - misleading link state indication at boot
Message-ID: <20210804160154.GD25072@amd>
References: <20210413182051.GR1463@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3Pql8miugIZX0722"
Content-Disposition: inline
In-Reply-To: <20210413182051.GR1463@shell.armlinux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3Pql8miugIZX0722
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> I'm seeing some odd behaviour with the netdev trigger and some WiFi
> interfaces.
>=20
> When the WiFi interface has never been brought up (so is in an
> operationally disabled state), if I bind a LED to the netdev
> trigger, setting the device_name to the WiFi interface name and
> enable the "link" property, the LED illuminates, indicating that
> the WiFi device has link - but it's disabled.
>=20
> If I up/down the WiFi interface, thereby returning it to the
> original state, the link LED goes out.
>=20
> I suspect ledtrig-netdev.c needs to check that the device is both
> up (dev->flags & IFF_UP) and netif_carrier_ok(dev) both return true,
> rather than just relying on netif_carrier_ok(). I don't think using
> netif_running() is appropriate, as that will return true before
> ndo_open() has been called to initialise the carrier state.
>=20
> Agreed?

Seems reasonable to me. Will you do the patch?

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--3Pql8miugIZX0722
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmEKufIACgkQMOfwapXb+vJ3WQCdEnZkrj2Pk2vo3BdffEIfC3ip
3oEAnjYwe3keTT+kDHzMPXpe2Ic2cDwC
=VBi1
-----END PGP SIGNATURE-----

--3Pql8miugIZX0722--
