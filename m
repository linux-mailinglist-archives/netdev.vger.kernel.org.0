Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A2A1BEF8D
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 07:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgD3FDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 01:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726040AbgD3FDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 01:03:53 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F80C035494
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 22:03:52 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jU1MP-0005xo-Hj; Thu, 30 Apr 2020 07:03:45 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jU1MO-00069c-QN; Thu, 30 Apr 2020 07:03:44 +0200
Date:   Thu, 30 Apr 2020 07:03:44 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>
Subject: Re: [PATCH net-next v3 2/2] net: phy: tja11xx: add support for
 master-slave configuration
Message-ID: <20200430050344.u7bsakcrrw2cakex@pengutronix.de>
References: <20200428075308.2938-1-o.rempel@pengutronix.de>
 <20200428075308.2938-3-o.rempel@pengutronix.de>
 <20200429182053.GM30459@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aevfvnzd6ykgpc2t"
Content-Disposition: inline
In-Reply-To: <20200429182053.GM30459@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:02:42 up 166 days, 20:21, 163 users,  load average: 0.11, 0.08,
 0.02
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--aevfvnzd6ykgpc2t
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 29, 2020 at 08:20:53PM +0200, Andrew Lunn wrote:
> > +static int tja11xx_config_aneg(struct phy_device *phydev)
> > +{
> > +	u16 ctl =3D 0;
> > +	int ret;
> > +
> > +	switch (phydev->master_slave_set) {
> > +	case PORT_MODE_CFG_MASTER_FORCE:
> > +	case PORT_MODE_CFG_MASTER_PREFERRED:
> > +		ctl |=3D MII_CFG1_MASTER_SLAVE;
> > +		break;
> > +	case PORT_MODE_CFG_SLAVE_FORCE:
> > +	case PORT_MODE_CFG_SLAVE_PREFERRED:
> > +		break;
> > +	case PORT_MODE_CFG_UNKNOWN:
> > +		return 0;
> > +	default:
> > +		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
> > +		return -ENOTSUPP;
> > +	}
>=20
> Does the hardware actually support PORT_MODE_CFG_SLAVE_PREFERRED and
> PORT_MODE_CFG_MASTER_PREFERRED? I thought that required autoneg, which
> this PHY does not support? So i would of expected these two values to
> return ENOTSUPP?

I do not have strong opinion here. Will change it.

Regards,
Oleksij
--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--aevfvnzd6ykgpc2t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl6qXDAACgkQ4omh9DUa
UbNSIxAAnuqCCyRXMKpPIyGfOO+VHRzckemdFoGwEclePdskhMp3rMPTED/iOcDa
r75OTE65mCoKQ+epY3Dx5ZitqdinLbSctLlSePg/74lNPsLQBUrr8tH2CnTeQ9z0
qKfakIIgK5B+MdZLxIzV913Vfp7e29f4vjON/LeqkenNLxoxprVCUsz51cQYta+t
d2JnwJVRhlMG+wveRVlfFksItFh0W3I+MbN12ICLEKCzqzRYZqjq57RWWu2PLEDV
sprC2I0p3C9ZZOCzNVqz1LY0nJZnZMFJzbxlCC9BcWT+w3KUk3qoEAxg2jyu2kD4
DW+kmRcKUwgv+4RYWmmn4jiF+Dmfikf7OmdTvQF5w5KzC82eJwTzaP5qb3X3QFC4
QeO0FPc3Uf2o0FvEsm1PYXtofamAaUDq2JyvybNjHn6Rto4HfQZWQXkdKJfE33jJ
h54c9UshwhZ2aOmo0cN2JBJlbQrXV7HtYxVusu9k8nik4w1cNDEetSh74EyeGV5i
yUpkHRs1lD/TI8r+ZR5JCFMQwqA6BxGw53HYjZFdy4kWpLeIF+gcGhlvF6r1hgdK
2omXLdYODGYSUCpe9C9tclb6lhmxq1ue48HgFmM577Xi4jJTFLiYeAywQ3M3B7xp
f1f4WSTdkKKerYzsR+Ce8z/AhmysLBnjCxCb2/bp/Zppq68DCj0=
=U6If
-----END PGP SIGNATURE-----

--aevfvnzd6ykgpc2t--
