Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299BA1AA2E9
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 15:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370649AbgDONAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 09:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2505704AbgDONAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 09:00:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F28C061A0C
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 06:00:41 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jOhed-00063e-5D; Wed, 15 Apr 2020 15:00:35 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jOhec-0004un-B2; Wed, 15 Apr 2020 15:00:34 +0200
Date:   Wed, 15 Apr 2020 15:00:34 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        mkl@pengutronix.de, Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v1] ethtool: provide UAPI for PHY master/slave
 configuration.
Message-ID: <20200415130034.7zbizr4x4vnxto6a@pengutronix.de>
References: <20200415121209.12197-1-o.rempel@pengutronix.de>
 <20200415121940.2du33zckvayfqjrb@pengutronix.de>
 <20200415124343.GZ3141@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wmkigrreuigkomxv"
Content-Disposition: inline
In-Reply-To: <20200415124343.GZ3141@unicorn.suse.cz>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:58:11 up 152 days,  4:16, 170 users,  load average: 0.03, 0.06,
 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wmkigrreuigkomxv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 15, 2020 at 02:43:43PM +0200, Michal Kubecek wrote:
> On Wed, Apr 15, 2020 at 02:19:40PM +0200, Oleksij Rempel wrote:
> > Cc: Marek Vasut <marex@denx.de>
> >=20
> > On Wed, Apr 15, 2020 at 02:12:09PM +0200, Oleksij Rempel wrote:
> > > This UAPI is needed for BroadR-Reach 100BASE-T1 devices. Due to lack =
of
> > > auto-negotiation support, we needed to be able to configure the
> > > MASTER-SLAVE role of the port manually or from an application in user
> > > space.
> > >=20
> > > The same UAPI can be used for 1000BASE-T or MultiGBASE-T devices to
> > > force MASTER or SLAVE role. See IEEE 802.3-2018:
> > > 22.2.4.3.7 MASTER-SLAVE control register (Register 9)
> > > 22.2.4.3.8 MASTER-SLAVE status register (Register 10)
> > > 40.5.2 MASTER-SLAVE configuration resolution
> > > 45.2.1.185.1 MASTER-SLAVE config value (1.2100.14)
> > > 45.2.7.10 MultiGBASE-T AN control 1 register (Register 7.32)
> > >=20
> > > The MASTER-SLAVE role affects the clock configuration:
> > >=20
> > > ---------------------------------------------------------------------=
----------
> > > When the  PHY is configured as MASTER, the PMA Transmit function shall
> > > source TX_TCLK from a local clock source. When configured as SLAVE, t=
he
> > > PMA Transmit function shall source TX_TCLK from the clock recovered f=
rom
> > > data stream provided by MASTER.
> > >=20
> > > iMX6Q                     KSZ9031                XXX
> > > ------\                /-----------\        /------------\
> > >       |                |           |        |            |
> > >  MAC  |<----RGMII----->| PHY Slave |<------>| PHY Master |
> > >       |<--- 125 MHz ---+-<------/  |        | \          |
> > > ------/                \-----------/        \------------/
> > >                                                ^
> > >                                                 \-TX_TCLK
> > >=20
> > > ---------------------------------------------------------------------=
----------
> > >=20
> > > Since some clock or link related issues are only reproducible in a
> > > specific MASTER-SLAVE-role, MAC and PHY configuration, it is benefici=
al
> > > to provide generic (not 100BASE-T1 specific) interface to the user sp=
ace
> > > for configuration flexibility and trouble shooting.
> > >=20
> > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > > ---
> [...]
> > > +/* Port mode */
> > > +#define PORT_MODE_MASTER	0x00
> > > +#define PORT_MODE_SLAVE		0x01
> > > +#define PORT_MODE_MASTER_FORCE	0x02
> > > +#define PORT_MODE_SLAVE_FORCE	0x03
> > > +#define PORT_MODE_UNKNOWN	0xff
>=20
> Shouldn't 0 rather be something like PORT_MODE_UNSUPPORTED or
> PORT_MODE_NONE? If I see correctly, all drivers not setting the new
> field (which would be all drivers right now and almost all later) will
> leave the value at 0 which would be interpreted as PORT_MODE_MASTER.

Yes, you right. I was thinking about it and decided to follow the duplex
code pattern. Will fix in the next version.

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--wmkigrreuigkomxv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl6XBXEACgkQ4omh9DUa
UbOglg//ZJyaMVRb7Ez1auRpbMdUrJ2zn7i1rb3lNG7CbUPgu6Ga2o+Vfr9VBXqv
itDyVtiSnnMeamfoqpF+/2MguMcYdHfKDaEV9iZiDiWRqSHbpxqzK3HO8/rm6Ees
aj2rb6WV2csMf2+yMGfpOdD21j2u3zwMHZJxPvGI0zzBQ3Q93X350k0Vq3+NdgL6
P72GncsF2v9JXPcu6gqKkvBigQ6fHnIQTnD+O7PEDnyNII5acludGG/HysEILtcc
jFGgZr38/pofHvLFEUYmeBYVKXulLN+iNEu6oD4dVkiV3z3N/s6fVHPu8grgRc0x
tNOYfIePD3RjF7CjpxXJrZpDdd4Vc419eEmZxCEpTcJWm/sj4XNSF2g0VDWFGU78
3K3vHODzwz1sO4Fn7gJwwF4RTZabftkpYMjXR7PCDqIhq2W3TlpZCojkqx7sn/zS
2leZ0aqynSqgFxDBz+p9f09P6C7rTfhNeYWl6NsdPHQBZxnR6lAU01XZIR/C6r7m
huP2iH8rUXYuyaNGqH5AY8tLc/EbZbfeR7QkWER6XrSbXE/bEsh6wr2CLjwhvyP4
wHNQ7kNbZl402RLYjoUwhyvVfvYmBUqrWRZtw8Mr5W/oR/+4KA5OaBR31aYTd2AF
mbY4uR7Q4tKOdo9a3gDHJ9O8Ti+5TGwLNu29PQVxy1Om3MgMb/k=
=tQSm
-----END PGP SIGNATURE-----

--wmkigrreuigkomxv--
