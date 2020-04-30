Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDBB81BEF81
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 07:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgD3FBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 01:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726180AbgD3FBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 01:01:08 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EEAC035494
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 22:01:08 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jU1Jk-0005Iw-SY; Thu, 30 Apr 2020 07:01:00 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jU1Ji-0005mJ-Uo; Thu, 30 Apr 2020 07:00:58 +0200
Date:   Thu, 30 Apr 2020 07:00:58 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>
Subject: Re: [PATCH net-next v3 1/2] ethtool: provide UAPI for PHY
 master/slave configuration.
Message-ID: <20200430050058.cetxv76pyboanbkz@pengutronix.de>
References: <20200428075308.2938-1-o.rempel@pengutronix.de>
 <20200428075308.2938-2-o.rempel@pengutronix.de>
 <20200429195222.GA17581@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ozd5iai3oo5bf5xh"
Content-Disposition: inline
In-Reply-To: <20200429195222.GA17581@lion.mk-sys.cz>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 06:41:45 up 166 days, 20:00, 163 users,  load average: 0.02, 0.03,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ozd5iai3oo5bf5xh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

On Wed, Apr 29, 2020 at 09:52:22PM +0200, Michal Kubecek wrote:
> On Tue, Apr 28, 2020 at 09:53:07AM +0200, Oleksij Rempel wrote:
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
> [...]
> > diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> > index 72c69a9c8a98a..a6a774beb2f90 100644
> > --- a/drivers/net/phy/phy.c
> > +++ b/drivers/net/phy/phy.c
> > @@ -285,6 +285,9 @@ int phy_ethtool_ksettings_set(struct phy_device *ph=
ydev,
> >  	      duplex !=3D DUPLEX_FULL)))
> >  		return -EINVAL;
> > =20
> > +	if (!ethtool_validate_master_slave_cfg(cmd->base.master_slave_cfg))
> > +		return -EINVAL;
> > +
>=20
> Unless we can/want to pass extack down here, I would prefer to have the
> sanity check in ethtool_update_linkmodes() or ethtool_set_linkmodes() so
> that we can set meaningful error message and offending attribute in
> extack. (It could be even part of the policy.) Also, with the check only
> here, drivers/devices not calling phy_ethtool_set_link_ksettings()
> (directly or via phy_ethtool_set_link_ksettings()) and not handling the
> new members themselves would silently ignore any value from userspace.

ok

> >  	phydev->autoneg =3D autoneg;
> > =20
> >  	phydev->speed =3D speed;
> [...]
> > +static int genphy_setup_master_slave(struct phy_device *phydev)
> > +{
> > +	u16 ctl =3D 0;
> > +
> > +	if (!phydev->is_gigabit_capable)
> > +		return 0;
>=20
> Shouldn't we rather return -EOPNOTSUPP if value different from
> CFG_UNKNOWN was requested?

sounds plausible.

> > +
> > +	switch (phydev->master_slave_set) {
> > +	case PORT_MODE_CFG_MASTER_PREFERRED:
> > +		ctl |=3D CTL1000_PREFER_MASTER;
> > +		break;
> > +	case PORT_MODE_CFG_SLAVE_PREFERRED:
> > +		break;
> > +	case PORT_MODE_CFG_MASTER_FORCE:
> > +		ctl |=3D CTL1000_AS_MASTER;
> > +		/* fallthrough */
> > +	case PORT_MODE_CFG_SLAVE_FORCE:
> > +		ctl |=3D CTL1000_ENABLE_MASTER;
> > +		break;
> > +	case PORT_MODE_CFG_UNKNOWN:
> > +		return 0;
> > +	default:
> > +		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
> > +		return 0;
> > +	}
> [...]
> > diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> > index 92f737f101178..eb680e3d6bda5 100644
> > --- a/include/uapi/linux/ethtool.h
> > +++ b/include/uapi/linux/ethtool.h
> > @@ -1666,6 +1666,31 @@ static inline int ethtool_validate_duplex(__u8 d=
uplex)
> >  	return 0;
> >  }
> > =20
> > +/* Port mode */
> > +#define PORT_MODE_CFG_UNKNOWN		0
> > +#define PORT_MODE_CFG_MASTER_PREFERRED	1
> > +#define PORT_MODE_CFG_SLAVE_PREFERRED	2
> > +#define PORT_MODE_CFG_MASTER_FORCE	3
> > +#define PORT_MODE_CFG_SLAVE_FORCE	4
> > +#define PORT_MODE_STATE_UNKNOWN		0
> > +#define PORT_MODE_STATE_MASTER		1
> > +#define PORT_MODE_STATE_SLAVE		2
> > +#define PORT_MODE_STATE_ERR		3
>=20
> You have "MASTER_SLAVE" or "master_slave" everywhere but "PORT_MODE" in
> these constants which is inconsistent.

What will be preferred name?

> > +
> > +static inline int ethtool_validate_master_slave_cfg(__u8 cfg)
> > +{
> > +	switch (cfg) {
> > +	case PORT_MODE_CFG_MASTER_PREFERRED:
> > +	case PORT_MODE_CFG_SLAVE_PREFERRED:
> > +	case PORT_MODE_CFG_MASTER_FORCE:
> > +	case PORT_MODE_CFG_SLAVE_FORCE:
> > +	case PORT_MODE_CFG_UNKNOWN:
> > +		return 1;
> > +	}
> > +
> > +	return 0;
> > +}
>=20
> Should we really allow CFG_UNKNOWN in client requests? As far as I can
> see, this value is handled as no-op which should be rather expressed by
> absence of the attribute. Allowing the client to request a value,
> keeping current one and returning 0 (success) is IMHO wrong.

ok

> Also, should this function be in UAPI header?

It is placed together with other validate functions:
ethtool_validate_duplex
ethtool_validate_speed

Doing it in a different place, would be inconsistent.

> [...]
> > @@ -119,7 +123,12 @@ static int linkmodes_fill_reply(struct sk_buff *sk=
b,
> >  	}
> > =20
> >  	if (nla_put_u32(skb, ETHTOOL_A_LINKMODES_SPEED, lsettings->speed) ||
> > -	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_DUPLEX, lsettings->duplex))
> > +	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_DUPLEX, lsettings->duplex) ||
> > +	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,
> > +		       lsettings->master_slave_cfg) ||
> > +	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,
> > +		       lsettings->master_slave_state))
> > +
> >  		return -EMSGSIZE;
>=20
> From the two handlers you introduced, it seems we only get CFG_UNKNOWN
> or STATE_UNKNOWN if driver or device does not support the feature at all
> so it would be IMHO more appropriate to omit the attribute in such case.

STATE_UNKNOWN is returned if link is not active.

Regards,
Oleksij
--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--ozd5iai3oo5bf5xh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl6qW4IACgkQ4omh9DUa
UbMW6BAAvgl7UtjAUh2IOL/8TkPA1gr3AEo/DMbY5sDi1EEf03GXGLxo4L481es8
KJe7FSfkmI5Nn/mXu3zM3phxvA3E6BoBpD+JXPiJdwsfOvqCHU/7u16LxUuK5SBH
8QFm884aBs4441xaiPKYKshOF/wyP8QeStIAi71LEiiBvFDsYnijGBQ0LCmgoaN3
22RVSz0hQvgFbYEY8B9Nygw0SEjA+IEREkutJnI2AXDPlJyVlWyfAOovKM9+0UuP
WaK2HcHoInL/g8PCBS2hm98m5r0eeIls9UvJrQySyd4Qm/p7nnOsgc2x3OhYRyrP
osUAwbI28A1AGyQNgjuJ4t6isRetE9hvp7yXNN8weXmH+o5jL7AJ0/urJkIHtuyX
nHQXNQDuBn/R2Hzr9XRMYXR0WakD/qR3gJCfssLrWqlTSl8d/ppgSQqxNRxcLyoj
E9fm7eNzdXiLZ3+2jd8hkdkcIJd2Pvvi0GLHMqUsBQbD3zfH4Cp69VGypRc8Rbiv
tvmgdPft8/gRM/ziXz+8VjzadjPcd921E1tZDwK79NDhHKibX7/glRf0/3fyUjnD
gIVFu/cP6IDSXjyyeD77eg5A6S0WBrCyxFw7L7+tU1rRPpGUoTHWlCkG3KliupAn
/hIqM9pmlKhGBbvyn2ZeSU1mLUAf625L87paPE+xFEeDQv+b9Ao=
=oSOt
-----END PGP SIGNATURE-----

--ozd5iai3oo5bf5xh--
