Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A45E0520EB2
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 09:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237839AbiEJHhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 03:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241123AbiEJH2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 03:28:17 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0EB1F63B7;
        Tue, 10 May 2022 00:24:17 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 505051C000A;
        Tue, 10 May 2022 07:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652167456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+GKGEOMV8HdvRtCTi7Q1ZSPYbY21Obt2PJMYQBlni4g=;
        b=bhhu1IcacSZrxL8ddeSJT6p7EYsCv0sPfh5KN6uv0Ab+Bya349FAyQE7V/xbeYGFTDBJ+1
        f09y1FQ7SreSrhRVS5hV2mH/cPOo6CO/nx8oKC//l24s9vIdqRe0I8uITZUOTekJvTZ97d
        SuZnRowWLWuVwoIrEOD4oZ0nJ2isKLtzBkaHWi6o6iD/MXevcZeSAg1qsMax8jW7Prnjtm
        8GSrbbqxQLqKbzXhsw7TCmRYN6qltcTPWpU+2oHgdHX9Dbpl/tnGCq7bhaWImOFCYgZXEP
        UGS+bOKGyI4tvhGKW7fVnKOfMbugNW7ia5g1Dx+piTpjTm305dkAD0JWmIQkUA==
Date:   Tue, 10 May 2022 09:24:10 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 04/12] net: pcs: add Renesas MII converter
 driver
Message-ID: <20220510092410.1c1f5eaa@xps-bootlin>
In-Reply-To: <Ynl3jpuJFqXLscvE@shell.armlinux.org.uk>
References: <20220509131900.7840-1-clement.leger@bootlin.com>
        <20220509131900.7840-5-clement.leger@bootlin.com>
        <Ynl3jpuJFqXLscvE@shell.armlinux.org.uk>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Mon, 9 May 2022 21:20:30 +0100,
"Russell King (Oracle)" <linux@armlinux.org.uk> a =C3=A9crit :

> Hi,
>=20
> On Mon, May 09, 2022 at 03:18:52PM +0200, Cl=C3=A9ment L=C3=A9ger wrote:
> > +#define MIIC_PRCMD			0x0
> > +#define MIIC_ESID_CODE			0x4
> > +
> > +#define MIIC_MODCTRL			0x20
> > +#define MIIC_MODCTRL_SW_MODE		GENMASK(4, 0)
> > +
> > +#define MIIC_CONVCTRL(port)		(0x100 + (port) * 4)
> > +
> > +#define MIIC_CONVCTRL_CONV_SPEED	GENMASK(1, 0)
> > +#define CONV_MODE_10MBPS		0
> > +#define CONV_MODE_100MBPS		BIT(0)
> > +#define CONV_MODE_1000MBPS		BIT(1) =20
>=20
> I think this is an inappropriate use of the BIT() macro. BIT() should
> be used for single bit rather than for field values.
>=20
> You seem to have a two bit field in bits 1 and 0 of a register, which
> has the values of:
> 0 - 10MBPS
> 1 - 100MBPS
> 2 - 1GBPS
>=20
> I'd guess 3 is listed as "undefined", "do not use" or something
> similar?

You are right, this is actually values rather than individual bits.

>=20
> > +
> > +#define MIIC_CONVCTRL_CONV_MODE		GENMASK(3, 2)
> > +#define CONV_MODE_MII			0
> > +#define CONV_MODE_RMII			BIT(0)
> > +#define CONV_MODE_RGMII			BIT(1) =20
>=20
> This looks similar. a 2-bit field in bits 3 and 2 taking values:
> 0 - MII
> 1 - RMII
> 2 - RGMII
>=20
> ...
>=20
> > +static int miic_config(struct phylink_pcs *pcs, unsigned int mode,
> > +		       phy_interface_t interface,
> > +		       const unsigned long *advertising, bool
> > permit) +{
> > +	u32 speed =3D CONV_MODE_10MBPS, conv_mode =3D CONV_MODE_MII,
> > val;
> > +	struct miic_port *miic_port =3D
> > phylink_pcs_to_miic_port(pcs);
> > +	struct miic *miic =3D miic_port->miic;
> > +	int port =3D miic_port->port;
> > +
> > +	switch (interface) {
> > +	case PHY_INTERFACE_MODE_RMII:
> > +		conv_mode =3D CONV_MODE_RMII;
> > +		speed =3D CONV_MODE_100MBPS;
> > +		break;
> > +	case PHY_INTERFACE_MODE_RGMII:
> > +		conv_mode =3D CONV_MODE_RGMII;
> > +		speed =3D CONV_MODE_1000MBPS;
> > +		break;
> > +	case PHY_INTERFACE_MODE_MII: =20
>=20
> I'm not sure why you need to initialise "speed" and "conv_mode" above
> when you could set them here.

It only seemed to me that 0 value was the default init one but I'll
move that in that case.

>=20
> Thanks.=20
>=20

