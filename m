Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D10675017CD
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 18:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239416AbiDNPuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 11:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243690AbiDNPi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 11:38:26 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E295F1FA61;
        Thu, 14 Apr 2022 08:15:40 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id D88736000C;
        Thu, 14 Apr 2022 15:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649949339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kldf5IEa3yAZkGIRecTUUIoT+f9V5tcdBTTm3Fj/R0E=;
        b=KfauuI8udm5OMo/y2S7FtmFocxXA/lFKzTmOSteFep9LasMRYCoO3NSxkZE/5aLMkW9nYR
        MQkfXzScE5Qe31vWvX6SmMQFEQtHou+UGO9iyU+1WMmzn+8yFEGDSI4rFKMrSQ1WJU7I89
        qqiDNFx3A7qIX03nL2GLRHuCXQJyfQedxYH+ikaozYt5a3f9UOHhgbTQLgmbWMCYRa2nJw
        O22a9HqvWw7copMKG1nxE0KIBJB+emaChGyGyM9kW1PK1zbpF8ndwOqhDt9CCN6vjH5mXD
        SvAQrt4vE/GDbBNdMOCqt/b0Qh45nyOyrfG5u6I5pfjsy4U14AQ2gUhpRxgnqg==
Date:   Thu, 14 Apr 2022 17:14:08 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
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
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 04/12] net: pcs: add Renesas MII converter
 driver
Message-ID: <20220414171408.59716a52@fixe.home>
In-Reply-To: <YlgYRGVuHQCwp7FQ@shell.armlinux.org.uk>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
        <20220414122250.158113-5-clement.leger@bootlin.com>
        <YlgYRGVuHQCwp7FQ@shell.armlinux.org.uk>
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

Le Thu, 14 Apr 2022 13:49:08 +0100,
"Russell King (Oracle)" <linux@armlinux.org.uk> a =C3=A9crit :

> On Thu, Apr 14, 2022 at 02:22:42PM +0200, Cl=C3=A9ment L=C3=A9ger wrote:
> > Add PCS driver for the MII converter that is present on Renesas RZ/N1
> > SoC. This MII converter is reponsible of converting MII to RMII/RGMII
> > or act as a MII passtrough. Exposing it as a PCS allows to reuse it
> > in both the switch driver and the stmmac driver. Currently, this driver
> > only allows the PCS to be used by the dual Cortex-A7 subsystem since
> > the register locking system is not used. =20
>=20
> Hi,
>=20
> > +#define MIIC_CONVCTRL_CONV_MODE		GENMASK(4, 0)
> > +#define CONV_MODE_MII			0
> > +#define CONV_MODE_RMII			BIT(2)
> > +#define CONV_MODE_RGMII			BIT(3)
> > +#define CONV_MODE_10MBPS		0
> > +#define CONV_MODE_100MBPS		BIT(0)
> > +#define CONV_MODE_1000MBPS		BIT(1) =20
>=20
> Is this really a single 4-bit wide field? It looks like two 2-bit fields
> to me.

You are right, the datasheet presents that as a single bitfield but
that can be split.

>=20
> > +#define phylink_pcs_to_miic_port(pcs) container_of((pcs), struct miic_=
port, pcs) =20
>=20
> I prefer a helper function to a preprocessor macro for that, but I'm not
> going to insist on that point.

Acked.

>=20
> > +static void miic_link_up(struct phylink_pcs *pcs, unsigned int mode,
> > +			 phy_interface_t interface, int speed, int duplex)
> > +{
> > +	struct miic_port *miic_port =3D phylink_pcs_to_miic_port(pcs);
> > +	struct miic *miic =3D miic_port->miic;
> > +	int port =3D miic_port->port;
> > +	u32 val =3D 0;
> > +
> > +	if (duplex =3D=3D DUPLEX_FULL)
> > +		val |=3D MIIC_CONVCTRL_FULLD;
> > +
> > +	switch (interface) {
> > +	case PHY_INTERFACE_MODE_RMII:
> > +		val |=3D CONV_MODE_RMII;
> > +		break;
> > +	case PHY_INTERFACE_MODE_RGMII:
> > +		val |=3D CONV_MODE_RGMII;
> > +		break;
> > +	case PHY_INTERFACE_MODE_MII:
> > +		val |=3D CONV_MODE_MII;
> > +		break;
> > +	default:
> > +		dev_err(miic->dev, "Unsupported interface %s\n",
> > +			phy_modes(interface));
> > +		return;
> > +	} =20
>=20
> Why are you re-decoding the interface mode? The interface mode won't
> change as a result of a call to link-up. Changing the interface mode
> is a major configuration event that will always see a call to your
> miic_config() function first.

Indeed, seems stupid, I will simply keep the mode bits once split from
speed.

[...]

> > +};
> > +
> > +struct phylink_pcs *miic_create(struct device_node *np)
> > +{
> > +	struct platform_device *pdev;
> > +	struct miic_port *miic_port;
> > +	struct device_node *pcs_np;
> > +	u32 port;
> > +
> > +	if (of_property_read_u32(np, "reg", &port))
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	if (port >=3D MIIC_MAX_NR_PORTS)
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	/* The PCS pdev is attached to the parent node */
> > +	pcs_np =3D of_get_parent(np);
> > +	if (!pcs_np)
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	pdev =3D of_find_device_by_node(pcs_np);
> > +	if (!pdev || !platform_get_drvdata(pdev))
> > +		return ERR_PTR(-EPROBE_DEFER); =20
>=20
> It would be a good idea to have a comment in the probe function to say
> that this relies on platform_set_drvdata() being the very last thing
> after a point where initialisation is complete and we won't fail.

Yep, sounds like a good idea.

>=20
> Thanks!
>=20

Thanks for the review,

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
