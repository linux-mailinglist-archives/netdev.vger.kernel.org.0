Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E430C51C012
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378498AbiEENEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378730AbiEENEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:04:13 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4620345AFF;
        Thu,  5 May 2022 06:00:29 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8C0F34000A;
        Thu,  5 May 2022 13:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651755628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bodixTdgPk47fJS2fv6/SDLCRRt2eNXHEOnwvcENoeU=;
        b=HOF8jFvm9xvlhKdBSlAw1PWPlaN+8+ATfW6po0knLyCkuU4poMNPBUKvGpfgLsN0ofUQgp
        gzoZ/9p9NYAjhyI4T5Lz4O7RnqRvlh2F/cX+mhMypMs8ZwsB9oBPQkZZacJBDfOA1sLAuA
        OwF/DdbQAsmM5luCqzLgUGp1vXze9LAlpftBOeRu6kL+DXlhpab2xDKzFkQNilMoaa2b8b
        XLP8Dv8bByYV2bF4s2Vd1euGhXwXpK9pQcRsAaW0bk9sPhXgwOT56mZlgvuDIQNxs2s9fY
        Svu3IZEkGyaaD446j5B8OUxj3X1XdqzoeNxuMk+ELNVyTClPZamt4tKSZmqhlQ==
Date:   Thu, 5 May 2022 14:59:08 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>,
        Phil Edworthy <phil.edworthy@renesas.com>
Subject: Re: [PATCH net-next v3 06/12] net: dsa: rzn1-a5psw: add Renesas
 RZ/N1 advanced 5 port switch driver
Message-ID: <20220505145908.5436d846@fixe.home>
In-Reply-To: <20220504161414.u6riybjcrgachjvh@skbuf>
References: <20220504093000.132579-1-clement.leger@bootlin.com>
        <20220504093000.132579-7-clement.leger@bootlin.com>
        <20220504161414.u6riybjcrgachjvh@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Wed, 4 May 2022 19:14:14 +0300,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> On Wed, May 04, 2022 at 11:29:54AM +0200, Cl=C3=A9ment L=C3=A9ger wrote:
> > Add Renesas RZ/N1 advanced 5 port switch driver. This switch handles 5
> > ports including 1 CPU management port. A MDIO bus is also exposed by
> > this switch and allows to communicate with PHYs connected to the ports.
> > Each switch port (except for the CPU management ports) is connected to
> > the MII converter.
> >=20
> > This driver includes basic bridging support, more support will be added
> > later (vlan, etc).
> >=20
> > Suggested-by: Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>
> > Suggested-by: Phil Edworthy <phil.edworthy@renesas.com>
> > Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>
> > ---
> > +static void a5psw_port_disable(struct dsa_switch *ds, int port)
> > +{
> > +	struct a5psw *a5psw =3D ds->priv;
> > +
> > +	a5psw_port_authorize_set(a5psw, port, false);
> > +	a5psw_port_enable_set(a5psw, port, false);
> > +	a5psw_port_fdb_flush(a5psw, port); =20
>=20
> The bridge core takes care of this by setting the port state to
> DISABLED, which makes DSA call dsa_port_fast_age(), no?

Yes you are right.

>=20
> Standalone ports shouldn't need fast ageing because they shouldn't have
> address learning enabled in the first place.

Ok, makes sense.

>=20
> > +} =20
>=20
> > +static int a5psw_port_bridge_join(struct dsa_switch *ds, int port,
> > +				  struct dsa_bridge bridge,
> > +				  bool *tx_fwd_offload,
> > +				  struct netlink_ext_ack *extack)
> > +{
> > +	struct a5psw *a5psw =3D ds->priv;
> > +
> > +	/* We only support 1 bridge device */
> > +	if (a5psw->br_dev && bridge.dev !=3D a5psw->br_dev)
> > +		return -EINVAL; =20
>=20
> return -EOPNOTSUPP, to allow software bridging.

Ok.

> You might also want to set an extack message here and avoid overwriting
> it in dsa_slave_changeupper() with "Offloading not supported", but say
> something more specific like "Forwarding offload supported for a single
> bridge".
>=20
> > +		a5psw->br_dev =3D NULL;
> > +} =20
>=20
> > +static int a5psw_pcs_get(struct a5psw *a5psw)
> > +{
> > +	struct device_node *ports, *port, *pcs_node;
> > +	struct phylink_pcs *pcs;
> > +	int ret;
> > +	u32 reg;
> > +
> > +	ports =3D of_get_child_by_name(a5psw->dev->of_node, "ports"); =20
>=20
> Can you please do:
>=20
> 	ports =3D of_get_child_by_name(a5psw->dev->of_node, "ethernet-ports");
> 	if (!ports)
> 		ports =3D of_get_child_by_name(a5psw->dev->of_node, "ports");

Acked.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
