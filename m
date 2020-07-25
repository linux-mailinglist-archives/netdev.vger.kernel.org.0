Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2360622D66C
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 11:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgGYJV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 05:21:26 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:39636 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgGYJV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 05:21:26 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C608C1C0BD6; Sat, 25 Jul 2020 11:21:24 +0200 (CEST)
Date:   Sat, 25 Jul 2020 11:21:24 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        jacek.anaszewski@gmail.com, Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v3 1/2] net: phy: add API for LEDs
 controlled by PHY HW
Message-ID: <20200725092124.GA29492@amd>
References: <20200724164603.29148-1-marek.behun@nic.cz>
 <20200724164603.29148-2-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <20200724164603.29148-2-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Many PHYs support various HW control modes for LEDs connected directly
> to them.
>=20
> This code adds a new private LED trigger called phydev-hw-mode. When
> this trigger is enabled for a LED, the various HW control modes which
> the PHY supports for given LED can be get/set via hw_mode sysfs file.
>=20
> A PHY driver wishing to utilize this API needs to register the LEDs on
> its own and set the .trigger_type member of LED classdev to
> &phy_hw_led_trig_type. It also needs to implement the methods
> .led_iter_hw_mode, .led_set_hw_mode and .led_get_hw_mode in struct
> phydev.
>=20
> Signed-off-by: Marek Beh=FAn <marek.behun@nic.cz>

Nothing too wrong.

New sysfs file will require documentation.

Plus I wonder: should we have single hw_mode file? It seems many
different "bits" fit inside. Would it be possible to split it further,
and have bits saying:

"I want the LED to be on if link is 10Mbps".
"I want the LED to be on if link is 100Mbps".
"I want the LED to be on if link is 1000Mbps".
"I want the LED to blink on tx".
"I want the LED to blink on rx".

?

+       { "1Gbps/100Mbps/10Mbps",       { 0x2,  -1,  -1,  -1,  -1,
+       { "1Gbps",                      { 0x7,  -1,  -1,  -1,  -1,
+       { "100Mbps-fiber",              {  -1, 0x5,  -1,  -1,  -1,
+       { "100Mbps-10Mbps",             {  -1, 0x5,  -1,  -1,  -1,
+       { "1Gbps-100Mbps",              {  -1, 0x6,  -1,  -1,  -1,
+       { "1Gbps-10Mbps",               {  -1,  -1, 0x6, 0x6,  -1,
+       { "100Mbps",                    {  -1, 0x7,  -1,  -1,  -1,
+       { "10Mbps",                     {  -1,  -1, 0x7,  -1,  -1,

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8b+ZQACgkQMOfwapXb+vLd1wCgkhr97O6BTEL5wiuKLQeoZNvE
js4AmwavbkmSO264vnR6adMUl7+kGKuq
=j2nQ
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
