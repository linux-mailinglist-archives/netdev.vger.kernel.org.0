Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F3CE81E2
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 08:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfJ2HOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 03:14:21 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:52865 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbfJ2HOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 03:14:20 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iPLhg-0008Ec-SG; Tue, 29 Oct 2019 08:14:08 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1iPLhd-0003Um-14; Tue, 29 Oct 2019 08:14:05 +0100
Date:   Tue, 29 Oct 2019 08:14:05 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Jay Cliburn <jcliburn@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Burton <paul.burton@mips.com>,
        Rob Herring <robh+dt@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        James Hogan <jhogan@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH v4 5/5] net: dsa: add support for Atheros AR9331 build-in
 switch
Message-ID: <20191029071404.pl34q4rmadusc2u5@pengutronix.de>
References: <20191022055743.6832-1-o.rempel@pengutronix.de>
 <20191022055743.6832-6-o.rempel@pengutronix.de>
 <20191023005850.GG5707@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ukndbh5m6jokcfed"
Content-Disposition: inline
In-Reply-To: <20191023005850.GG5707@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:32:43 up 161 days, 20:50, 100 users,  load average: 0.01, 0.04,
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


--ukndbh5m6jokcfed
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 23, 2019 at 02:58:50AM +0200, Andrew Lunn wrote:
> > --- a/drivers/net/dsa/Kconfig
> > +++ b/drivers/net/dsa/Kconfig
> > @@ -52,6 +52,8 @@ source "drivers/net/dsa/microchip/Kconfig"
> > =20
> >  source "drivers/net/dsa/mv88e6xxx/Kconfig"
> > =20
> > +source "drivers/net/dsa/qca/Kconfig"
> > +
> >  source "drivers/net/dsa/sja1105/Kconfig"
> > =20
> >  config NET_DSA_QCA8K
>=20
> > diff --git a/drivers/net/dsa/qca/Kconfig b/drivers/net/dsa/qca/Kconfig
> > new file mode 100644
> > index 000000000000..7e4978f46642
> > --- /dev/null
> > +++ b/drivers/net/dsa/qca/Kconfig
> > @@ -0,0 +1,11 @@
> > +# SPDX-License-Identifier: GPL-2.0-only
> > +config NET_DSA_AR9331
> > +	tristate "Atheros AR9331 Ethernet switch support"
>=20
> This is where things are a little bit unobvious. If you do
> make menu
>=20
> and go into the DSA menu, you will find the drivers are all sorted
> into Alphabetic order, based on the tristate text. But you have
> inserted your "Atheros AR9331", after "NXP SJA1105".
>=20
> It would probably be best if you make the tristate "Qualcomm Atheros
> AR9331 ...". The order would be correct then,

done

> > +static int ar9331_sw_port_enable(struct dsa_switch *ds, int port,
> > +				 struct phy_device *phy)
> > +{
> > +	struct ar9331_sw_priv *priv =3D (struct ar9331_sw_priv *)ds->priv;
> > +	struct regmap *regmap =3D priv->regmap;
> > +	int ret;
> > +
> > +	/* nothing to enable. Just set link to initial state */
> > +	ret =3D regmap_write(regmap, AR9331_SW_REG_PORT_STATUS(port), 0);
> > +	if (ret)
> > +		dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
> > +
> > +	return ret;
> > +}
> > +
> > +static void ar9331_sw_port_disable(struct dsa_switch *ds, int port)
> > +{
> > +	struct ar9331_sw_priv *priv =3D (struct ar9331_sw_priv *)ds->priv;
> > +	struct regmap *regmap =3D priv->regmap;
> > +	int ret;
> > +
> > +	ret =3D regmap_write(regmap, AR9331_SW_REG_PORT_STATUS(port), 0);
> > +	if (ret)
> > +		dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
> > +}
>=20
> I've asked this before, but i don't remember the answer. Why are
> port_enable and port_disable the same?

I have only MAC TX/RX enable bit. This bit is set by phylink_mac_link_up and
removed by phylink_mac_link_down.
The port enable I use only to set predictable state of the port
register: all bits cleared. May be i should just drop port enable
function? What do you think?=20

> > +static int ar9331_sw_irq_init(struct ar9331_sw_priv *priv)
> > +{
> > +	struct device_node *np =3D priv->dev->of_node;
> > +	struct device *dev =3D priv->dev;
> > +	int ret, irq;
> > +
> > +	irq =3D of_irq_get(np, 0);
> > +	if (irq <=3D 0) {
> > +		dev_err(dev, "failed to get parent IRQ\n");
> > +		return irq ? irq : -EINVAL;
> > +	}
> > +
> > +	ret =3D devm_request_threaded_irq(dev, irq, NULL, ar9331_sw_irq,
> > +					IRQF_ONESHOT, AR9331_SW_NAME, priv);
> > +	if (ret) {
> > +		dev_err(dev, "unable to request irq: %d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	priv->irqdomain =3D irq_domain_add_linear(np, 1, &ar9331_sw_irqdomain=
_ops,
> > +						priv);
> > +	if (!priv->irqdomain) {
> > +		dev_err(dev, "failed to create IRQ domain\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	irq_set_parent(irq_create_mapping(priv->irqdomain, 0), irq);
> > +
> > +	return 0;
> > +}
>=20
>=20
> > +static int ar9331_sw_probe(struct mdio_device *mdiodev)
> > +{
> > +	struct ar9331_sw_priv *priv;
> > +	int ret;
> > +
> > +	priv =3D devm_kzalloc(&mdiodev->dev, sizeof(*priv), GFP_KERNEL);
> > +	if (!priv)
> > +		return -ENOMEM;
> > +
> > +	priv->regmap =3D devm_regmap_init(&mdiodev->dev, &ar9331_sw_bus, priv,
> > +					&ar9331_mdio_regmap_config);
> > +	if (IS_ERR(priv->regmap)) {
> > +		ret =3D PTR_ERR(priv->regmap);
> > +		dev_err(&mdiodev->dev, "regmap init failed: %d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	priv->sw_reset =3D devm_reset_control_get(&mdiodev->dev, "switch");
> > +	if (IS_ERR(priv->sw_reset)) {
> > +		dev_err(&mdiodev->dev, "missing switch reset\n");
> > +		return PTR_ERR(priv->sw_reset);
> > +	}
> > +
> > +	priv->sbus =3D mdiodev->bus;
> > +	priv->dev =3D &mdiodev->dev;
> > +
> > +	ret =3D ar9331_sw_irq_init(priv);
> > +	if (ret)
> > +		return ret;
> > +
> > +	priv->ds =3D dsa_switch_alloc(&mdiodev->dev, AR9331_SW_PORTS);
> > +	if (!priv->ds)
> > +		return -ENOMEM;
> > +
> > +	priv->ds->priv =3D priv;
> > +	priv->ops =3D ar9331_sw_ops;
> > +	priv->ds->ops =3D &priv->ops;
> > +	dev_set_drvdata(&mdiodev->dev, priv);
> > +
> > +	return dsa_register_switch(priv->ds);
>=20
> If there is an error here, you need to undo the IRQ code, etc.

done

> > +}
> > +
> > +static void ar9331_sw_remove(struct mdio_device *mdiodev)
> > +{
> > +	struct ar9331_sw_priv *priv =3D dev_get_drvdata(&mdiodev->dev);
> > +
> > +	mdiobus_unregister(priv->mbus);
> > +	dsa_unregister_switch(priv->ds);
> > +
> > +	reset_control_assert(priv->sw_reset);
>=20
> You also need to clean up the IRQ code here.

ok, thx!

Regards,
Oleksij

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--ukndbh5m6jokcfed
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl235rwACgkQ4omh9DUa
UbOi/g/9GhCsf6/3MQ5EKn1oCn0cUwNKlM/isGsBqi8iLgClz7+QazmiapaK0jlw
57RSmTpeYLc3TGOCwVsWYv3iZf0v9/jCI35Y8IVjAnenf4VIjXN7ITjLlEERX5bf
CRZKkLxiRTPzkXOdb3qmKyD/PYHy4VhZuU3Mn6lbTUTW8wTrCmODrJZIavql+PQw
JGlB71peAurPA7t5POg+Q/Fn38xv/yM7lWui+WjxIEFMLx0pMV7QFJt5Q1+AhFy9
JmXTnAUiOZ8EOFq5ZJgd4SWCNP6yyC4LZViVPOPpfggmxj3YpG2hhoe04qtTs3Da
+AuUyUeRk1llB7UShpSsBM3zyGp0uxLS4+DZkz4ebXYmd2uERq/ooMb8RFLCfGEY
YhWnri6cgj7d2Y014RxsKB9GWiwGncm/rHctexfGv1zhi1rpWvzgYZss1kooO7KE
RvBGnj38gDh689GgE2y5bGt7Zxx2S6BMStaMuBSANTNXQsXXWWfpDxhF5/IVbNlQ
FdG++c5OJVoEimqdD1JLVt6USXBzoCArNb8FiZuozJYrk8SxvZCo91Q1EpzC9EFW
JfXx9j+GCJp2OeS69mOyz83OgtAdNojRNmTI1w2bK5lKjSW52jz+uoubC4i+uGRA
lHd1z3gV/i0BzazoBuR0B1hZWgn3X0eh+/my7LUrFZRvuqfxYw4=
=s3/2
-----END PGP SIGNATURE-----

--ukndbh5m6jokcfed--
