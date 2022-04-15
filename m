Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E485026F3
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 10:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245712AbiDOIpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 04:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351609AbiDOIpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 04:45:02 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EF3BABB5;
        Fri, 15 Apr 2022 01:42:01 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E444A240007;
        Fri, 15 Apr 2022 08:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650012120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YS+pRs7LHr6e9EuekGh2X2vs14X+J67Z7alkSxxSDok=;
        b=ktD02ECZx7kx3kFU32mZ8y5MqdVj5y9g9zDmajeZLWYT0+97CRn6TOpV9elACOFPk/Df4o
        d+353r3H7Rh8mjl1F+QSic91f+PVkIVIznkWev7FSlDzX5Wd5jKalkj/EuTfDjQYs7Y0wR
        +rz9yb+6uMJNke5C0JTXWIvGyZVGPpsfB+AT1YpeJM0KlAeKY8VXLrbkGYpRcfPAZuJA/0
        EcBBMBZvxZYzlVgedtWwx3SWlBnabgIowz28CF3S31hy5ZbF+reO8nsmMXoFBSAUPSajev
        DvdooxFwCagqrMJw3DZAg6uu6BU11TXuBhH5QwqrYo3hbims22/3vq3TJ+iD8g==
Date:   Fri, 15 Apr 2022 10:40:29 +0200
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
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Laurent Gonzales <laurent.gonzales@non.se.com>,
        Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>,
        Phil Edworthy <phil.edworthy@renesas.com>
Subject: Re: [PATCH net-next 06/12] net: dsa: rzn1-a5psw: add Renesas RZ/N1
 advanced 5 port switch driver
Message-ID: <20220415104029.5e52080b@fixe.home>
In-Reply-To: <YlgbUiXzHa0UNRK+@shell.armlinux.org.uk>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
        <20220414122250.158113-7-clement.leger@bootlin.com>
        <YlgbUiXzHa0UNRK+@shell.armlinux.org.uk>
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

Le Thu, 14 Apr 2022 14:02:10 +0100,
"Russell King (Oracle)" <linux@armlinux.org.uk> a =C3=A9crit :

> On Thu, Apr 14, 2022 at 02:22:44PM +0200, Cl=C3=A9ment L=C3=A9ger wrote:
> > Add Renesas RZ/N1 advanced 5 port switch driver. This switch handles 5
> > ports including 1 CPU management port. A MDIO bus is also exposed by
> > this switch and allows to communicate with PHYs connected to the ports.
> > Each switch port (except for the CPU management ports) are connected to
> > the MII converter.
> >=20
> > This driver include basic bridging support, more support will be added
> > later (vlan, etc). =20
>=20
> This patch looks to me like it needs to be updated...

Hi Russell,

When you say so, do you expect the VLAN support to be included ?

>=20
> > +static void a5psw_phylink_validate(struct dsa_switch *ds, int port,
> > +				   unsigned long *supported,
> > +				   struct phylink_link_state *state)
> > +{
> > +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0 };
> > +
> > +	phylink_set_port_modes(mask);
> > +
> > +	phylink_set(mask, Autoneg);
> > +	phylink_set(mask, Pause);
> > +	phylink_set(mask, Asym_Pause);
> > +
> > +	phylink_set(mask, 1000baseT_Full);
> > +	if (!dsa_is_cpu_port(ds, port)) {
> > +		phylink_set(mask, 10baseT_Half);
> > +		phylink_set(mask, 10baseT_Full);
> > +		phylink_set(mask, 100baseT_Half);
> > +		phylink_set(mask, 100baseT_Full);
> > +	} =20
>=20
> If the port supports e.g. RGMII (as it does via the media converter)
> then it also supports 1000baseX modes as well - because a PHY attached
> to the RGMII port can convert to 1000baseX.
>=20
> > +
> > +	linkmode_and(supported, supported, mask);
> > +	linkmode_and(state->advertising, state->advertising, mask);
> > +} =20
>=20
> This basically means "I support every phy_interface_t mode that has ever
> been implemented" which surely is not what you want. I doubt from the
> above that you support 10GBASE-KR for example.

Hmmm yes indeed, that's not what I meant *at all*.

>=20
> Please instead implement the .phylink_get_caps DSA switch interface, and
> fill in the config->supported_interfaces for all interface modes that
> the port supports (that including the media converter as well) and the
> config->mac_capabilities members.
>=20

Ok, looks indeed more fitted and easier to understand.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
