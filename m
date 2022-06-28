Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A51B855EA4E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbiF1QxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 12:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233947AbiF1QvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 12:51:09 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E5A21A4;
        Tue, 28 Jun 2022 09:50:47 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 01377240007;
        Tue, 28 Jun 2022 16:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656435046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dz/PyMsuJCPlzxV0NdNxQF4B1f3xTrWyRIxj17TyzNE=;
        b=VvSS27cpBdvgCLlVD9xXQyXFssPJf6KbUMFiYUU4391snY7ZSfiOBLTosXOIdnFkn7AWcC
        aC3TGHr2tEWK+TqR4H6k15+Oy/YYtxGYkq5CTgIpRu/lU9LUBVOmr1AGxqDI1keeFvHZXi
        Dvb71vdSVct1kNBF+U/xZKVI1ZeobWnNCzstTdlqIha1a6Z1dPcfs2dKhDA08H82xoaYqw
        3grtBuceIP1rdakS2TqZNIHgpgzzWChSGoUSdaDeGMZUqUBLX43NCoX2mjCVYVQDx/4DnW
        CoPvIbVqRju5u/9cX8+p914tpqEadfBZs33HAjjZFsySjB1gyyGwieDAmDI6sQ==
Date:   Tue, 28 Jun 2022 18:49:54 +0200
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
Subject: Re: [PATCH net-next v9 05/16] net: pcs: add Renesas MII converter
 driver
Message-ID: <20220628184954.6757ffe4@fixe.home>
In-Reply-To: <YrsvkqBbzUvTYOeI@shell.armlinux.org.uk>
References: <20220624144001.95518-1-clement.leger@bootlin.com>
        <20220624144001.95518-6-clement.leger@bootlin.com>
        <YrsvkqBbzUvTYOeI@shell.armlinux.org.uk>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-pc-linux-gnu)
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

Le Tue, 28 Jun 2022 17:42:58 +0100,
"Russell King (Oracle)" <linux@armlinux.org.uk> a =C3=A9crit :

> > +		break;
> > +	default:
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	val =3D FIELD_PREP(MIIC_CONVCTRL_CONV_MODE, conv_mode) |
> > +	      FIELD_PREP(MIIC_CONVCTRL_CONV_SPEED, speed);
> > +
> > +	miic_reg_rmw(miic, MIIC_CONVCTRL(port),
> > +		     MIIC_CONVCTRL_CONV_MODE | MIIC_CONVCTRL_CONV_SPEED, val);
> > +	miic_converter_enable(miic_port->miic, miic_port->port, 1);
> > +
> > +	return 0;
> > +} =20
>=20
> the stting of the speed here. As this function can be called as a result
> of ethtool setting the configuration while the link is up, this could
> have disasterous effects on the link. This will only happen if there is
> no PHY present and we aren't using fixed-link mode.
>=20
> Therefore, I'm willing to get this pass, but I think it would be better
> if the speed was only updated if the interface setting is actually
> being changed. So:

Hi Russell,

Ok, I'll make a follow-up patch to handle that properly.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
