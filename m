Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781D4502A2B
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 14:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353488AbiDOMig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 08:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353611AbiDOMiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 08:38:20 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17782C6F32;
        Fri, 15 Apr 2022 05:35:19 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id AB2DBE0003;
        Fri, 15 Apr 2022 12:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650026118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LQPLmfkCXSVq0GahJ2gRBTUAjR3JsLVQ4p3kVKwOaKM=;
        b=B7dqpP8SF1WF50VQZmXuXl3YozrjRVnfKLU7dcyp2BXXJaY8TW2ag755Mu65wWew5i5D4F
        wrvHrK1N1tFIYSuhKf7TbNc8U7TWHw2DZvryTXVNLXEQ8PqOPjk7r2obI8shhUMBg2ZtDA
        a3ISrfpaKUjaaRnjPR1TBYsNncm7L0ZXtNwy0SEXq8lQ9KCWPtSaL1rGvNClBrDzs7UIqH
        MqeXcGzGr+AjgogH1GasetZwVieC0dnJ15uDN6wtS/nTgreX9qr8FWQ5ov8c0whnNBlXSO
        Zg362pue9VXH4wVdrE4pk4lihv4nDvBo5Slucs/fzmw5Y5kXBgH5qYG/2bpMkg==
Date:   Fri, 15 Apr 2022 14:33:49 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
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
        Laurent Gonzales <laurent.gonzales@non.se.com>,
        Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>,
        Phil Edworthy <phil.edworthy@renesas.com>
Subject: Re: [PATCH net-next 06/12] net: dsa: rzn1-a5psw: add Renesas RZ/N1
 advanced 5 port switch driver
Message-ID: <20220415143349.652e9958@fixe.home>
In-Reply-To: <YlhgK3sTKHU3CNUM@lunn.ch>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
        <20220414122250.158113-7-clement.leger@bootlin.com>
        <YlhgK3sTKHU3CNUM@lunn.ch>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Thu, 14 Apr 2022 19:55:55 +0200,
Andrew Lunn <andrew@lunn.ch> a =C3=A9crit :

>  +static int a5psw_mdio_reset(struct mii_bus *bus)
> > +{
> > +	struct a5psw *a5psw =3D bus->priv;
> > +	unsigned long rate;
> > +	unsigned long div;
> > +	u32 cfgstatus;
> > +
> > +	rate =3D clk_get_rate(a5psw->hclk);
> > +	div =3D ((rate / a5psw->mdio_freq) / 2);
> > +	if (div >=3D 511 || div <=3D 5) {
> > +		dev_err(a5psw->dev, "MDIO clock div %ld out of range\n", div);
> > +		return -ERANGE;
> > +	}
> > +
> > +	cfgstatus =3D FIELD_PREP(A5PSW_MDIO_CFG_STATUS_CLKDIV, div);
> > +
> > +	a5psw_reg_writel(a5psw, A5PSW_MDIO_CFG_STATUS, cfgstatus); =20
>=20
> I don't see anything here which does an actual reset. So i think this
> function has the wrong name. Please also pass the frequency as a
> parameter, because at a quick glance it was not easy to see where it
> was used. There does not seem to be any need to store it in a5psw.

Indeed, the reset callback can be removed entirely and the mdio bus
could be setup directly from a5psw_probe_mdio().

>=20
> > +static int a5psw_probe_mdio(struct a5psw *a5psw)
> > +{
> > +	struct device *dev =3D a5psw->dev;
> > +	struct device_node *mdio_node;
> > +	struct mii_bus *bus;
> > +	int err;
> > +
> > +	if (of_property_read_u32(dev->of_node, "clock-frequency",
> > +				 &a5psw->mdio_freq))
> > +		a5psw->mdio_freq =3D A5PSW_MDIO_DEF_FREQ;
> > +
> > +	bus =3D devm_mdiobus_alloc(dev);
> > +	if (!bus)
> > +		return -ENOMEM;
> > +
> > +	bus->name =3D "a5psw_mdio";
> > +	bus->read =3D a5psw_mdio_read;
> > +	bus->write =3D a5psw_mdio_write;
> > +	bus->reset =3D a5psw_mdio_reset; =20
>=20
> As far as i can see, the read and write functions don't support
> C45. Please return -EOPNOTSUPP if they are passed C45 addresses.

Ok.

>=20
>      Andrew



--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
