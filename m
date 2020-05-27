Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D20A1E3EEE
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 12:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbgE0K0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 06:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726965AbgE0K0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 06:26:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C8BC061A0F
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 03:26:43 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jdtGZ-0003gm-6h; Wed, 27 May 2020 12:26:31 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jdtGP-0002lk-0P; Wed, 27 May 2020 12:26:21 +0200
Date:   Wed, 27 May 2020 12:26:20 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>,
        Amit Cohen <amitc@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Subject: Re: [PATCH ethtool v1] netlink: add master/slave configuration
 support
Message-ID: <20200527102620.legyuohgu2xj7pfk@pengutronix.de>
References: <20200526091025.25243-1-o.rempel@pengutronix.de>
 <20200526124139.mvsn52cixu2t5ljz@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pgvkh5uu574hkgt3"
Content-Disposition: inline
In-Reply-To: <20200526124139.mvsn52cixu2t5ljz@lion.mk-sys.cz>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:22:51 up 194 days,  1:41, 196 users,  load average: 0.03, 0.09,
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


--pgvkh5uu574hkgt3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 26, 2020 at 02:41:39PM +0200, Michal Kubecek wrote:
> On Tue, May 26, 2020 at 11:10:25AM +0200, Oleksij Rempel wrote:
> > This UAPI is needed for BroadR-Reach 100BASE-T1 devices. Due to lack of
> > auto-negotiation support, we needed to be able to configure the
> > MASTER-SLAVE role of the port manually or from an application in user
> > space.
> >=20
> > The same UAPI can be used for 1000BASE-T or MultiGBASE-T devices to
> > force MASTER or SLAVE role. See IEEE 802.3-2018:
> > 22.2.4.3.7 MASTER-SLAVE control register (Register 9)
> > 22.2.4.3.8 MASTER-SLAVE status register (Register 10)
> > 40.5.2 MASTER-SLAVE configuration resolution
> > 45.2.1.185.1 MASTER-SLAVE config value (1.2100.14)
> > 45.2.7.10 MultiGBASE-T AN control 1 register (Register 7.32)
> >=20
> > The MASTER-SLAVE role affects the clock configuration:
> >=20
> > -----------------------------------------------------------------------=
--------
> > When the  PHY is configured as MASTER, the PMA Transmit function shall
> > source TX_TCLK from a local clock source. When configured as SLAVE, the
> > PMA Transmit function shall source TX_TCLK from the clock recovered from
> > data stream provided by MASTER.
> >=20
> > iMX6Q                     KSZ9031                XXX
> > ------\                /-----------\        /------------\
> >       |                |           |        |            |
> >  MAC  |<----RGMII----->| PHY Slave |<------>| PHY Master |
> >       |<--- 125 MHz ---+-<------/  |        | \          |
> > ------/                \-----------/        \------------/
> >                                                ^
> >                                                 \-TX_TCLK
> >=20
> > -----------------------------------------------------------------------=
--------
> >=20
> > Since some clock or link related issues are only reproducible in a
> > specific MASTER-SLAVE-role, MAC and PHY configuration, it is beneficial
> > to provide generic (not 100BASE-T1 specific) interface to the user space
> > for configuration flexibility and trouble shooting.
> >=20
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
>=20
> Please document the new command line argument in both "ethtool --help"
> output and manual page.
>=20
> I would also prefer updating the UAPI header copies in a separate commit
> which would update all of them to a state of a specific kernel commit
> (either 4.8-rc1 or current net-next); cherry picking specific changes
> may lead to missing some parts. An easy way would be
>=20
>   # switch to kernel repository and check out what you want to copy from
>   make ... INSTALL_HDR_PATH=3D$somewhere headers_install
>   # switch back to ethtool repository
>   cd uapi
>   find . -type f -exec cp -v ${somewhere}/include/{} {} \;
>=20
> Also, as the kernel counterpart is only in net-next at the moment, this
> should probably wait until after ethtool 5.7 release (perhaps it would
> be helpful to have a "next" branch like iproute2). I'll submit my queued
> patches for 5.7 later this week; should have done so long ago but
> I hoped to have the netlink friendly test framework finished before I do
> (test-features.c is tied to ioctl interface too tightly).

OK, should I resend fixed patch now, or wait until kernel 5.8-rc1?=20

Regards,
Oleksij
--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--pgvkh5uu574hkgt3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl7OQB8ACgkQ4omh9DUa
UbOm1RAAqL//9H25o9ZZfQpbXmw561PdSUziMxat/5QesgthB84s/4hZG7iaRppl
Gm7vxsAK/8aRr86Kl4gEI/6bl2lZceaskF0hAH+p9LTKIS2jjhUroTAEsibo5Cz7
DPpX8/WPsgdZbrkdkH5euhp7wPc0TrXQ6CCMKrPKV+1IwnOVKr2PY/xXRvsqbjVg
Ds0mgB1N3zDm7kFZWZmuApGxfaPK0GR89QjKvLUvreIp6UvehE4jefCvCEZcp3fw
hWNkZ9KE5Jfp8/67cL2UEuEaoAZk/QVr4zspreMurON9yw280FgDRciaIHLQhv26
1Cg0xvCJ41PgXS1RbOsH/rgf5SvYpk1Tm8LcUXoGkTirJo0si6FZXQklU96dEWoc
2UAeocmQ+4RAJFoBofa9wQLaDSUdFZsPuWu4oZFZS7a+rH4nG7zUGACDI93GNfy+
C6VWw3yhkaBah95kk4whxGad+F9ilAzugPZFjuM7J8U1xfgnQio5wJ7KtWGjwI/U
PhWM79rZe/GuEYLmCFy/u6gB0W6i95tmUfKAlzZREew7UQ1DCSx03ELI/qUNteRn
3mURmq4SG4rN8QxRwAslhS9G6taMCviy4/SBTyACRc+CjxTsB+i+D0kicjhhpfFV
mIENYsYihmZ36u4kUxCOSlnJ55OkX558vKhlgn6B7fue0KPpLOI=
=8+5A
-----END PGP SIGNATURE-----

--pgvkh5uu574hkgt3--
