Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D509952E69D
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 09:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346670AbiETHx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 03:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239607AbiETHx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 03:53:57 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A83106561;
        Fri, 20 May 2022 00:53:54 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 47E2640005;
        Fri, 20 May 2022 07:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1653033233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yoEhYOBRBgutAiogB53ii3LuQRNfEBwgcYFElSjLpok=;
        b=ZmWzl7IxUoJcigm7KAJ6beUJS8SRedasi70dWc0Kbosm4M7OOt2E2Owdtc8KXe01b3TIGT
        mmlDczU27RaBYK0zd0FcMFwnPve8hDoNtHlrEMTC3Qhco+sUz8ki9P2uzlXJJcdx5FIYJH
        8/bnejuAUVW0mxqzXv/p4bAi5IWOIoAUeooFdlhfNqyeBRlqMUaTrA2/Ba9ZHfjzgQCay4
        OsWld18d4Ma9PFTgXmTA9bbZ6JDz9GCE73ygcVZmpiI0uXnn/wOmQ+Fal9r7pjw/9mnG+j
        EcNjJtVKYFiNNXEibMED3xGc6YP23pdRdY3H+ARJKgVnyYu9ATqhe4tND1zQcA==
Date:   Fri, 20 May 2022 09:52:41 +0200
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
Subject: Re: [PATCH net-next v5 05/13] net: pcs: add Renesas MII converter
 driver
Message-ID: <20220520095241.6bbccdf0@fixe.home>
In-Reply-To: <YoZvZj9sQL2GZAI3@shell.armlinux.org.uk>
References: <20220519153107.696864-1-clement.leger@bootlin.com>
        <20220519153107.696864-6-clement.leger@bootlin.com>
        <YoZvZj9sQL2GZAI3@shell.armlinux.org.uk>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-pc-linux-gnu)
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

Le Thu, 19 May 2022 17:25:10 +0100,
"Russell King (Oracle)" <linux@armlinux.org.uk> a =C3=A9crit :

> Hi,
>=20
> On Thu, May 19, 2022 at 05:30:59PM +0200, Cl=C3=A9ment L=C3=A9ger wrote:
> > Add a PCS driver for the MII converter that is present on the Renesas
> > RZ/N1 SoC. This MII converter is reponsible for converting MII to
> > RMII/RGMII or act as a MII pass-trough. Exposing it as a PCS allows to
> > reuse it in both the switch driver and the stmmac driver. Currently,
> > this driver only allows the PCS to be used by the dual Cortex-A7
> > subsystem since the register locking system is not used.
> >=20
> > Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com> =20
>=20
> Looks much better now, thanks. Only one thing I've spotted is:
>=20
> > +static int miic_validate(struct phylink_pcs *pcs, unsigned long *suppo=
rted,
> > +			 const struct phylink_link_state *state)
> > +{
> > +	if (state->interface =3D=3D PHY_INTERFACE_MODE_RGMII ||
> > +	    state->interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||
> > +	    state->interface =3D=3D PHY_INTERFACE_MODE_RGMII_TXID ||
> > +	    state->interface =3D=3D PHY_INTERFACE_MODE_RGMII_RXID || =20
>=20
> The above could use:
>=20
> 	if (phy_interface_mode_is_rgmii(state->interface) ||

Thanks, I did found the one to set the bit for phylink part but not
this one.

>=20
> Also, as a request to unbind this driver would be disasterous to users,
> I think you should set ".suppress_bind_attrs =3D true" to prevent the
> sysfs bind/unbind facility being available. This doesn't completely
> solve the problem.

Acked. What should I do to make it more robust ? Should I use a
refcount per pdev and check that in the remove() callback to avoid
removing the pdev if used ?

Thanks,

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
