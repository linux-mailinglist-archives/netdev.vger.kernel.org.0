Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F24A1B36FF
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 07:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgDVFy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 01:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgDVFy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 01:54:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58190C03C1A6
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 22:54:27 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jR8Kx-0006oq-Ek; Wed, 22 Apr 2020 07:54:19 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jR8Ku-0006g4-TP; Wed, 22 Apr 2020 07:54:16 +0200
Date:   Wed, 22 Apr 2020 07:54:16 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v4 3/4] net: mdio: of: export part of
 of_mdiobus_register_phy()
Message-ID: <20200422055416.gvbitc6rtbhb4khp@pengutronix.de>
References: <20200421125219.8402-1-o.rempel@pengutronix.de>
 <20200421125219.8402-4-o.rempel@pengutronix.de>
 <20200421135147.GE937199@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="a2vjqgfecp5ygula"
Content-Disposition: inline
In-Reply-To: <20200421135147.GE937199@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:52:51 up 158 days, 21:11, 165 users,  load average: 0.23, 0.12,
 0.08
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--a2vjqgfecp5ygula
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 21, 2020 at 03:51:47PM +0200, Andrew Lunn wrote:
> On Tue, Apr 21, 2020 at 02:52:18PM +0200, Oleksij Rempel wrote:
> > This function will be needed in tja11xx driver for secondary PHY
> > support.
> >=20
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  drivers/of/of_mdio.c    | 73 ++++++++++++++++++++++++-----------------
> >  include/linux/of_mdio.h | 11 ++++++-
> >  2 files changed, 52 insertions(+), 32 deletions(-)
> >=20
> > diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
> > index 8270bbf505fb..d9e637b624ce 100644
> > --- a/drivers/of/of_mdio.c
> > +++ b/drivers/of/of_mdio.c
> > @@ -60,39 +60,15 @@ static struct mii_timestamper *of_find_mii_timestam=
per(struct device_node *node)
> >  	return register_mii_timestamper(arg.np, arg.args[0]);
> >  }
> > =20
> > -static int of_mdiobus_register_phy(struct mii_bus *mdio,
> > -				    struct device_node *child, u32 addr)
> > +int __of_mdiobus_register_phy(struct mii_bus *mdio, struct phy_device =
*phy,
> > +			      struct device_node *child, u32 addr)
> >  {
>=20
> Hi Oleksij
>=20
> I would prefer a different name. __foo functions often indicate
> locking is needed, or an internal API which should not be used except
> internally. This is going to be an official API. Maybe call it
> of_mdiobus_phy_device_register() ?

ok, sounds good. I'll send new version

Regards,
Oleksij
--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--a2vjqgfecp5ygula
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl6f3AUACgkQ4omh9DUa
UbPIKg/9Hjw846eYnmqn1bhO3YeHO19adcB1QQof1FU7XQ1IdSNZhRqslxIz9LnY
ORgVoWshdqd+zwLVKUsvUiyc36js8b1EYMrKcYbz5XW2j2xVZY3HUtEnTjWj5KPe
7venVd/pL/2bIx+bOsZVBSOH6bi4BplQzTCyqmZttIIKWWRf/wlC4YvDSOvc/TFO
3un6YTNAzk9Bs0QIGuCTL/mCzw5vMENAUP7O25odBfd8f2tdTAMWj1OHFU7q0UIR
YoWTfp/gTl6VhgBCpn3CuNvIa7wSnU63jruYqrFO3WF618QcnBi83KQy88zqHrvv
6nu1noa0x6kgv8JU9AW7vlsoO/AF5ZP4YYxQEV8YItlf+ynnkFF0h7c0VIfi8f5c
/s1iVEsC+bdfk+oaOJRcMxnq+WEslAwy95djCBxpvJxq7JdEwwjgQ44QirlhYYKJ
caYG9n4iJpjTt4HepU8rfptasOotMGr3OnuuYzvo2Y/SmTAodTWOg44InIVB6gQf
kqxKR71hK26lK5Tx1jme15G8LVZCZtgGL+xD5e99RuRjxyuxHBGGv114uhdWkR9P
JtkUBFLWSTMhc0npa6Fc3JsM+Eq+lkd598GenH6UEFQs0ognbQqvB+ezrIP5cSdJ
I5V8xE1h19ZTfyP0qaUwIkmRHYu7xiqQpz/GCXDpRbvQzR9KhfY=
=tofP
-----END PGP SIGNATURE-----

--a2vjqgfecp5ygula--
