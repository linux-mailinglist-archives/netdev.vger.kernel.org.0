Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 893E31990D
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 09:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfEJHiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 03:38:00 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39897 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbfEJHiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 03:38:00 -0400
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mgr@pengutronix.de>)
        id 1hP06N-00064e-CT; Fri, 10 May 2019 09:37:55 +0200
Received: from mgr by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mgr@pengutronix.de>)
        id 1hP06N-0002Bv-46; Fri, 10 May 2019 09:37:55 +0200
Date:   Fri, 10 May 2019 09:37:55 +0200
From:   Michael Grzeschik <mgr@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Tristram.Ha@microchip.com, kernel@pengutronix.de,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: Re: [RFC 2/3] ksz: Add Microchip KSZ8873 SMI-DSA driver
Message-ID: <20190510073755.75yho3cjayoi7tfz@pengutronix.de>
References: <20190508211330.19328-1-m.grzeschik@pengutronix.de>
 <20190508211330.19328-3-m.grzeschik@pengutronix.de>
 <20190509144844.GM25013@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jkl7ti7jmabckans"
Content-Disposition: inline
In-Reply-To: <20190509144844.GM25013@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:32:27 up 52 days, 18:43, 90 users,  load average: 1.05, 1.08,
 1.08
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jkl7ti7jmabckans
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 09, 2019 at 04:48:44PM +0200, Andrew Lunn wrote:
> On Wed, May 08, 2019 at 11:13:29PM +0200, Michael Grzeschik wrote:
> > Cc: Tristram.Ha@microchip.com
> > Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> > ---
> >  drivers/net/dsa/microchip/Kconfig       |   16 +
> >  drivers/net/dsa/microchip/Makefile      |    2 +
> >  drivers/net/dsa/microchip/ksz8863.c     | 1026 +++++++++++++++++++++++
> >  drivers/net/dsa/microchip/ksz8863_reg.h |  605 +++++++++++++
> >  drivers/net/dsa/microchip/ksz8863_smi.c |  105 +++
> >  drivers/net/dsa/microchip/ksz_priv.h    |    3 +
> >  include/net/dsa.h                       |    2 +
> >  net/dsa/Kconfig                         |    7 +
> >  net/dsa/tag_ksz.c                       |   45 +
> >  9 files changed, 1811 insertions(+)
> >  create mode 100644 drivers/net/dsa/microchip/ksz8863.c
> >  create mode 100644 drivers/net/dsa/microchip/ksz8863_reg.h
> >  create mode 100644 drivers/net/dsa/microchip/ksz8863_smi.c
> >=20
> > diff --git a/drivers/net/dsa/microchip/Kconfig b/drivers/net/dsa/microc=
hip/Kconfig
> > index bea29fde9f3d1..a6fa6ae972951 100644
> > --- a/drivers/net/dsa/microchip/Kconfig
> > +++ b/drivers/net/dsa/microchip/Kconfig
> > @@ -14,3 +14,19 @@ config NET_DSA_MICROCHIP_KSZ9477_SPI
> >  	depends on NET_DSA_MICROCHIP_KSZ9477 && SPI
> >  	help
> >  	  Select to enable support for registering switches configured throug=
h SPI.
> > +
> > +menuconfig NET_DSA_MICROCHIP_KSZ8863
> > +	tristate "Microchip KSZ8863 series switch support"
> > +	depends on NET_DSA
> > +	select NET_DSA_TAG_KSZ8863
> > +	select NET_DSA_MICROCHIP_KSZ_COMMON
> > +	help
> > +	  This driver adds support for Microchip KSZ8863 switch chips.
> > +
> > +config NET_DSA_MICROCHIP_KSZ8863_SMI
>=20
> > +	tristate "KSZ series SMI connected switch driver"
> > +	depends on NET_DSA_MICROCHIP_KSZ8863
> > +	default y
> > +	help
> > +	  Select to enable support for registering switches configured throug=
h SMI.
>=20
> SMI is a synonym for MDIO. So we should make it clear, this is a
> proprietary version. "... through Microchip SMI".
>=20
> You might also want to either depend on or select mdio-bitbang, since
> that is the other driver which supports Microchip SMI.

Right, I will add the comment and include the depend to mdio-bitbang.

> > +static int ksz_spi_read(struct ksz_device *dev, u32 reg, u8 *data,
> > +			unsigned int len)
> > +{
> > +	int i =3D 0;
> > +
> > +	for (i =3D 0; i < len; i++)
> > +		data[i] =3D (u8)mdiobus_read(dev->bus, 0,
> > +					    (reg + i) | MII_ADDR_SMI0);
>=20
> mdiobus_read() and mdiobus_write() can return an error, which is why
> is returns an int. Please check for the error and return it.

Thanks for pointing this out. I will fix it!

> > diff --git a/include/net/dsa.h b/include/net/dsa.h
> > index 6aaaadd6a413c..57fbf3e722362 100644
> > --- a/include/net/dsa.h
> > +++ b/include/net/dsa.h
> > @@ -44,6 +44,7 @@ struct phylink_link_state;
> >  #define DSA_TAG_PROTO_TRAILER_VALUE		11
> >  #define DSA_TAG_PROTO_8021Q_VALUE		12
> >  #define DSA_TAG_PROTO_SJA1105_VALUE		13
> > +#define DSA_TAG_PROTO_KSZ8863_VALUE		14
> > =20
> >  enum dsa_tag_protocol {
> >  	DSA_TAG_PROTO_NONE		=3D DSA_TAG_PROTO_NONE_VALUE,
> > @@ -60,6 +61,7 @@ enum dsa_tag_protocol {
> >  	DSA_TAG_PROTO_TRAILER		=3D DSA_TAG_PROTO_TRAILER_VALUE,
> >  	DSA_TAG_PROTO_8021Q		=3D DSA_TAG_PROTO_8021Q_VALUE,
> >  	DSA_TAG_PROTO_SJA1105		=3D DSA_TAG_PROTO_SJA1105_VALUE,
> > +	DSA_TAG_PROTO_KSZ8863		=3D DSA_TAG_PROTO_KSZ8863_VALUE,
> >  };
>=20
> Please put all the tag driver changes into a separate patch.

Right, I will ad that to another patch.

> > +static struct sk_buff *ksz8863_rcv(struct sk_buff *skb, struct net_dev=
ice *dev,
> > +				   struct packet_type *pt)
> > +{
> > +	/* Tag decoding */
> > +	u8 *tag =3D skb_tail_pointer(skb) - KSZ_EGRESS_TAG_LEN;
> > +	unsigned int port =3D tag[0] & 1;
>=20
> Does this device only have 2 ports, 0 and 1?
>=20

Yes this is a very basic "switch" only managing two physical ports.

Refer Page 28 Chapter 3.7 "Tail Tagging Mode"
in the Reference Manual of the switch:

http://ww1.microchip.com/downloads/en/DeviceDoc/00002335B.pdf

> > +	unsigned int len =3D KSZ_EGRESS_TAG_LEN;
> > +
> > +	return ksz_common_rcv(skb, dev, port, len);
> > +}
>=20
>   Andrew
>=20

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--jkl7ti7jmabckans
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEElXvEUs6VPX6mDPT8C+njFXoeLGQFAlzVKkwACgkQC+njFXoe
LGTrExAAio9ub4bL3NPDgxwrBcTX+iW8kfLHAt/+g1GZxVHc6V/std8BDDbFza7E
MZ8P7sos0tsXE5Lacc3Vb1NTABR9jL4Yb7LHw16xYv2QCnNGR8RQyuFqeVIKOBc8
XDaQHO9a9jfC3Fz4nAHL+wdc+kfYdqs1Z7iQUVL1Jx23GUmfugm9Z+G/wYng0g3n
dHvyKLs4mETSYtfQPSKRgwXnDX+DQzN+TNjdOTBP8wasMkkaMOzOna4M6UXbMWU1
McCaaTgT/+Bb6sjLXYJMqVXxieigrZ/Ea6hY4zJrKsi97vqnK8pak0Hw2+WKfNNI
EFksNFqzT3qhP9zRB3K6eEpq+bh1Ehfba9O/Lk2gDpyG6AW8pQj22+ifXQoC1ZlV
5YaxlsFpTA/rZIvChYRa2XoHRuxgKihHolZstPMwkfjuyJzZHN7U9HDlDJ53ab/U
IRSUxajCpfQ/vDQdHUWlUd/KhvFZOsX5ssxVAPdQdbhF+htx7bAKdxQh5aRypkxf
ejtjn5sCzRIX4n5d+FsE96KDU1Zy9xSGAVOVY0k3dS9cXTf6ufOdgQfSdqaLrCTA
zYzdeONM+siV7XfaVJ0wt6SN/wWCADIa/eMdx2qjciDHsjhlF3ONqkKQOl4WlKo2
t6RvxBYKauwZNipMEvaQdTb4quhAboyQnVLk2Xn6jG4HSp35DP8=
=/ktI
-----END PGP SIGNATURE-----

--jkl7ti7jmabckans--
