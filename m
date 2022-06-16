Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F68F54DB4F
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 09:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358535AbiFPHNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 03:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359041AbiFPHNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 03:13:24 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335B123143;
        Thu, 16 Jun 2022 00:13:21 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id BD72E240004;
        Thu, 16 Jun 2022 07:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1655363600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/ylwRydwSJ1vl505rIcsqlZRV8qHAjzTkuzOn3IJaxY=;
        b=LJPb2Nd1CvgSZLX2nP41tGlPv6KZN9tbzWLxHLWLbPbK9vWbVOfa2G9oJIScPODdB0HHDT
        puwfaAEjZa/qWjni4mrATRg9Hz7OeZLFCOsfBJ5FR2sDgQ0iYz2EWLU+zzqnlR3ISNN+UK
        kCJLFH1N7RiaMBpRqW0k5sHPRqdAanVW2V35vB4PwRIGqsSXtZhvyvpr08lMa/PYhf0rzh
        j0L0DdnBx+4gdnxlLgaDcPB7nEqxhKeGBT5RpzJg64e9nAoYbPNGq1GX+GoOneNGxY4BsT
        QDhKQKrPWQl1OIiQlFTNoZgWS+brgsq7PcScRJNlKSfPZw2mD7Kk/onqljfLqA==
Date:   Thu, 16 Jun 2022 09:12:22 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RESEND net-next v7 05/16] net: pcs: add Renesas MII
 converter driver
Message-ID: <20220616091222.4dbf9de3@fixe.home>
In-Reply-To: <20220614223109.603935fb@kernel.org>
References: <20220610103712.550644-1-clement.leger@bootlin.com>
        <20220610103712.550644-6-clement.leger@bootlin.com>
        <20220614223109.603935fb@kernel.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-pc-linux-gnu)
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

Le Tue, 14 Jun 2022 22:31:09 -0700,
Jakub Kicinski <kuba@kernel.org> a =C3=A9crit :

> On Fri, 10 Jun 2022 12:37:01 +0200 Cl=C3=A9ment L=C3=A9ger wrote:
> > Subject: [PATCH RESEND net-next v7 05/16] net: pcs: add Renesas MII con=
verter driver
> >=20
> > Add a PCS driver for the MII converter that is present on the Renesas
> > RZ/N1 SoC. This MII converter is reponsible for converting MII to
> > RMII/RGMII or act as a MII pass-trough. Exposing it as a PCS allows to
> > reuse it in both the switch driver and the stmmac driver. Currently,
> > this driver only allows the PCS to be used by the dual Cortex-A7
> > subsystem since the register locking system is not used. =20
>=20
> Could someone with MII &| PCS knowledge cast an eye over this code?
> All I can do is point out error path issues...
>=20
> > +struct phylink_pcs *miic_create(struct device *dev, struct device_node=
 *np)
> > +{
> > +	struct platform_device *pdev;
> > +	struct miic_port *miic_port;
> > +	struct device_node *pcs_np;
> > +	struct miic *miic;
> > +	u32 port;
> > +
> > +	if (!of_device_is_available(np))
> > +		return ERR_PTR(-ENODEV);
> > +
> > +	if (of_property_read_u32(np, "reg", &port))
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	if (port > MIIC_MAX_NR_PORTS || port < 1)
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	/* The PCS pdev is attached to the parent node */
> > +	pcs_np =3D of_get_parent(np); =20
>=20
> of_get_parent()? ..
>=20
> > +	if (!pcs_np)
> > +		return ERR_PTR(-ENODEV);
> > +
> > +	if (!of_device_is_available(pcs_np))
> > +		return ERR_PTR(-ENODEV); =20
>=20
> .. more like of_leak_parent()

Indeed, I'll fix that.

>=20
> > +	pdev =3D of_find_device_by_node(pcs_np);
> > +	if (!pdev || !platform_get_drvdata(pdev))
> > +		return ERR_PTR(-EPROBE_DEFER);
> > +
> > +	miic_port =3D kzalloc(sizeof(*miic_port), GFP_KERNEL);
> > +	if (!miic_port)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	miic =3D platform_get_drvdata(pdev);
> > +	device_link_add(dev, miic->dev, DL_FLAG_AUTOREMOVE_CONSUMER);
> > +
> > +	miic_port->miic =3D miic;
> > +	miic_port->port =3D port - 1;
> > +	miic_port->pcs.ops =3D &miic_phylink_ops;
> > +
> > +	return &miic_port->pcs;
> > +}
> > +EXPORT_SYMBOL(miic_create); =20
>=20
> > +static int miic_parse_dt(struct device *dev, u32 *mode_cfg)
> > +{
> > +	s8 dt_val[MIIC_MODCTRL_CONF_CONV_NUM];
> > +	struct device_node *np =3D dev->of_node;
> > +	struct device_node *conv;
> > +	u32 conf;
> > +	int port;
> > +
> > +	memset(dt_val, MIIC_MODCTRL_CONF_NONE, sizeof(dt_val));
> > +
> > +	of_property_read_u32(np, "renesas,miic-switch-portin", &conf);
> > +	dt_val[0] =3D conf;
> > +
> > +	for_each_child_of_node(np, conv) {
> > +		if (of_property_read_u32(conv, "reg", &port))
> > +			continue;
> > +
> > +		if (!of_device_is_available(conv))
> > +			continue;
> > +
> > +		if (of_property_read_u32(conv, "renesas,miic-input", &conf) =3D=3D 0)
> > +			dt_val[port] =3D conf;
> > +
> > +		of_node_put(conv); =20
>=20
> Don't these iteration functions put() the current before taking the
> next one all by themselves? Or is there supposed to be a "break" here?

Yes, of_node_put() should actually only be called in case of early exit.
I'll fix that.


--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
