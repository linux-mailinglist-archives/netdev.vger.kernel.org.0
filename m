Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E99502779
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 11:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351783AbiDOJiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 05:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245380AbiDOJiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 05:38:52 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DB5A997D;
        Fri, 15 Apr 2022 02:36:23 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 474BA60012;
        Fri, 15 Apr 2022 09:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650015382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mMgy3Vt8tIp5CbMmqA1LFW/mKTOyJ2Q1HfluOipEiKo=;
        b=pGUwaMg/3eaSAM2NU4yX77x+pQpj6rPYYOc9m9bBHTGTXo0+AnmAS14I7eMSGdmAdzvA70
        DPbtWxhby/8MLXmeNI35Ol9zCc3DOksqVb8Wjdu9OFBqTI2OzmczOTx9ZX6x5BzW8Oyt6o
        4AwTKjv0/SkzpODZ8oqETTL+U9KwCDE+FBv+mEU5j0/Rc2VJC9kq5XJpP/rmThAn9lax4U
        psav3gHgNFBNGKuInBMyMzjpbwaLkcv8XYdjbexVxty97u2LX0L9op4SWV11KoaZucvS0m
        lUtmJ2/iHCM4nZHMLX6fjbPEjOIBI4SGNOq3SkjnClh2u8uRYbDss/SUHKcGgQ==
Date:   Fri, 15 Apr 2022 11:34:53 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>,
        Phil Edworthy <phil.edworthy@renesas.com>
Subject: Re: [PATCH net-next 06/12] net: dsa: rzn1-a5psw: add Renesas RZ/N1
 advanced 5 port switch driver
Message-ID: <20220415113453.1a076746@fixe.home>
In-Reply-To: <20220414144709.tpxiiaiy2hu4n7fd@skbuf>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
        <20220414122250.158113-7-clement.leger@bootlin.com>
        <20220414144709.tpxiiaiy2hu4n7fd@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Thu, 14 Apr 2022 17:47:09 +0300,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

>=20
> > later (vlan, etc).
> >=20
> > Suggested-by: Laurent Gonzales <laurent.gonzales@non.se.com>
> > Suggested-by: Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>
> > Suggested-by: Phil Edworthy <phil.edworthy@renesas.com> =20
>=20
> Suggested? What did they suggest? "You should write a driver"?
> We have a Co-developed-by: tag, maybe it's more appropriate here?

This driver was written from scratch but some ideas (port isolation
using pattern matcher) was inspired from a previous driver. I thought it
would be nice to give them credit for that.

[...]

> >  obj-y				+=3D hirschmann/
> >  obj-y				+=3D microchip/
> > diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
> > new file mode 100644
> > index 000000000000..5bee999f7050
> > --- /dev/null
> > +++ b/drivers/net/dsa/rzn1_a5psw.c
> > @@ -0,0 +1,676 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Copyright (C) 2022 Schneider-Electric
> > + *
> > + * Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>
> > + */
> > +
> > +#include <linux/clk.h>
> > +#include <linux/etherdevice.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/of.h>
> > +#include <linux/of_mdio.h>
> > +#include <net/dsa.h>
> > +#include <uapi/linux/if_bridge.h> =20
>=20
> Why do you need to include this header?

It defines BR_STATE_* but I guess linux/if_bridge.h does include it.

> > +
> > +static void a5psw_port_pattern_set(struct a5psw *a5psw, int port, int =
pattern,
> > +				   bool enable)
> > +{
> > +	u32 rx_match =3D 0;
> > +
> > +	if (enable)
> > +		rx_match |=3D A5PSW_RXMATCH_CONFIG_PATTERN(pattern);
> > +
> > +	a5psw_reg_rmw(a5psw, A5PSW_RXMATCH_CONFIG(port),
> > +		      A5PSW_RXMATCH_CONFIG_PATTERN(pattern), rx_match);
> > +}
> > +
> > +static void a5psw_port_mgmtfwd_set(struct a5psw *a5psw, int port, bool=
 enable) =20
>=20
> Some explanation on what "management forward" means/does?

I'll probably rename that cpu_port_forward to match the dsa naming.
It'll actually isolate the port from other ports by only forwarding the
packets to the CPU port.

> > +
> > +static int a5psw_setup(struct dsa_switch *ds)
> > +{
> > +	struct a5psw *a5psw =3D ds->priv;
> > +	int port, vlan, ret;
> > +	u32 reg;
> > +
> > +	/* Configure management port */
> > +	reg =3D A5PSW_CPU_PORT | A5PSW_MGMT_CFG_DISCARD;
> > +	a5psw_reg_writel(a5psw, A5PSW_MGMT_CFG, reg); =20
>=20
> Perhaps you should validate the DT blob that the CPU port is the one
> that you think it is?

You are right, the datasheet says that the management port should
actually always be the CPU port so I guess a check would be nice.

> > +
> > +	/* Reset learn count to 0 */
> > +	reg =3D A5PSW_LK_LEARNCOUNT_MODE_SET;
> > +	a5psw_reg_writel(a5psw, A5PSW_LK_LEARNCOUNT, reg);
> > +
> > +	/* Clear VLAN resource table */
> > +	reg =3D A5PSW_VLAN_RES_WR_PORTMASK | A5PSW_VLAN_RES_WR_TAGMASK;
> > +	for (vlan =3D 0; vlan < A5PSW_VLAN_COUNT; vlan++)
> > +		a5psw_reg_writel(a5psw, A5PSW_VLAN_RES(vlan), reg);
> > +
> > +	/* Reset all ports */
> > +	for (port =3D 0; port < ds->num_ports; port++) { =20
>=20
> Because dsa_is_cpu_port() internally calls dsa_to_port() which iterates
> through a list, we tend to avoid the pattern where we call a list
> iterating function from a loop over essentially the same data.
> Instead, we have:
>=20
> 	dsa_switch_for_each_port(dp, ds) {
> 		if (dsa_port_is_unused(dp))
> 			do stuff with dp->index
> 		if (dsa_port_is_cpu(dp))
> 			...
> 		if (dsa_port_is_user(dp))
> 			...
> 	}

Nice catch indeed, I'll convert that.

> > +
> > +static int a5psw_probe_mdio(struct a5psw *a5psw)
> > +{
> > +	struct device *dev =3D a5psw->dev;
> > +	struct device_node *mdio_node;
> > +	struct mii_bus *bus;
> > +	int err;
> > +
> > +	if (of_property_read_u32(dev->of_node, "clock-frequency",
> > +				 &a5psw->mdio_freq))
> > +		a5psw->mdio_freq =3D A5PSW_MDIO_DEF_FREQ; =20
>=20
> Shouldn't the clock-frequency be a property of the "mdio" node?
> At least I see it in Documentation/devicetree/bindings/net/mdio.yaml.

Yes, totally.

> > +static const struct of_device_id a5psw_of_mtable[] =3D {
> > +	{ .compatible =3D "renesas,rzn1-a5psw", },
> > +	{ /* sentinel */ },
> > +};
> > +MODULE_DEVICE_TABLE(of, a5psw_of_mtable);
> > +
> > +static struct platform_driver a5psw_driver =3D {
> > +	.driver =3D {
> > +		.name	 =3D "rzn1_a5psw",
> > +		.of_match_table =3D of_match_ptr(a5psw_of_mtable),
> > +	},
> > +	.probe =3D a5psw_probe,
> > +	.remove =3D a5psw_remove, =20
>=20
> Please implement .shutdown too, it's non-optional.

Hum, platform_shutdown does seems to check for the .shutdown callback:

static void platform_shutdown(struct device *_dev)
{
	struct platform_device *dev =3D to_platform_device(_dev);
	struct platform_driver *drv;

	if (!_dev->driver)
		return;

	drv =3D to_platform_driver(_dev->driver);
	if (drv->shutdown)
		drv->shutdown(dev);
}

Is there some documentation specifying that this is mandatory ?
If so, should I just set it to point to an empty shutdown function then
?

>=20
> > +/**
> > + * struct a5psw - switch struct
> > + * @base: Base address of the switch
> > + * @hclk_rate: hclk_switch clock rate
> > + * @clk_rate: clk_switch clock rate
> > + * @dev: Device associated to the switch
> > + * @mii_bus: MDIO bus struct
> > + * @mdio_freq: MDIO bus frequency requested
> > + * @pcs: Array of PCS connected to the switch ports (not for the CPU)
> > + * @ds: DSA switch struct
> > + * @lk_lock: Lock for the lookup table
> > + * @reg_lock: Lock for register read-modify-write operation =20
>=20
> Interesting concept. Generally we see higher-level locking schemes
> (i.e. a rmw lock won't really ensure much in terms of consistency of
> settings if that's the only thing that serializes concurrent thread
> accesses to some register).

Agreed, this does not guarantee consistency of settings but guarantees
that rmw modifications are atomic between devices. I wasn't sure about
the locking guarantee that I could have. After looking at other
drivers, I guess I will switch to something more common such as using
a global mutex for register accesses.

>=20
> Anyway, probably doesn't hurt to have it.
>=20
> > + * @flooding_ports: List of ports that should be flooded
> > + */
> > +struct a5psw {
> > +	void __iomem *base;
> > +	struct clk* hclk;
> > +	struct clk* clk;
> > +	struct device *dev;
> > +	struct mii_bus	*mii_bus;
> > +	u32 mdio_freq;
> > +	struct phylink_pcs *pcs[A5PSW_PORTS_NUM - 1];
> > +	struct dsa_switch ds;
> > +	spinlock_t lk_lock;
> > +	spinlock_t reg_lock;
> > +	u32 flooding_ports;
> > +};
> > --=20
> > 2.34.1
> >  =20
>=20
> We have some selftests in tools/testing/selftests/net/forwarding/, like
> for example bridge_vlan_unaware.sh. They create veth pairs by default,
> but if you edit the NETIF_CREATE configuration you should be able to
> pass your DSA interfaces.

Ok, great to know that there are some tests that can be used.

> The selftests don't cover nearly enough, but just to make sure that they
> pass for your switch, when you use 2 switch ports as h1 and h2 (hosts),
> and 2 ports as swp1 and swp2? There's surprisingly little that you do on
> .port_bridge_join, I need to study the code more.

Port isolation is handled by using a pattern matcher which is enabled
for each port at setup. If set, the port packet will only be forwarded
to the CPU port. When bridging is needed, the pattern matching is
disabled and thus, the packets are forwarded between all the ports that
are enabled in the bridge.

Thanks,

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
