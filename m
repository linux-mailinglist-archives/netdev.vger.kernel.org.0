Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D26752EFB3
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 17:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351025AbiETPuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 11:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238120AbiETPuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 11:50:51 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F5F5FD8;
        Fri, 20 May 2022 08:50:47 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 02333FF807;
        Fri, 20 May 2022 15:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1653061846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yvpKoQOGv1Kn0EmPRZW9fK4SOYdbsyShPSvaCpDxXbg=;
        b=k1aePD1x/eO9Tqdbb46lSS0XxQpOVA921xMBdcATVTxZ5WLxeGhfwmML/LQcnsxs7qYv8Z
        lkJjgNLsXjXwWJewJaEl4TVtQ+APnZZw9EOjIL6XSwnyTAV9zZCaf6d0LTt/JeK2qA2KXZ
        1eeqnbdknfepet2r0e1OvUvoZJeHzT+MC3f5bAhGdGGyEw1lgm7MlxYfVINvvspmNN0Hhn
        SlgttJCFib6j2KQW46iOJHRtS+GJ0cuc0+qXLTBC1PAkFuKLiV2gzP8EwbqImoXcMLhasA
        87Kj+wXZEV6+1z/rjpwqG5IuEqdJrrHYwT32yaWyh0m41cSxzsQojjBwCtlInQ==
Date:   Fri, 20 May 2022 17:49:34 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
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
Message-ID: <20220520174934.3b9feb88@fixe.home>
In-Reply-To: <20220520154440.jtswi6oyjpseffpu@skbuf>
References: <20220519153107.696864-1-clement.leger@bootlin.com>
        <20220519153107.696864-6-clement.leger@bootlin.com>
        <YoZvZj9sQL2GZAI3@shell.armlinux.org.uk>
        <20220520095241.6bbccdf0@fixe.home>
        <20220520084914.5x6bfu4qaza4tqcz@skbuf>
        <20220520172244.1f17f736@fixe.home>
        <20220520154440.jtswi6oyjpseffpu@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-pc-linux-gnu)
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

Le Fri, 20 May 2022 18:44:40 +0300,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> On Fri, May 20, 2022 at 05:22:44PM +0200, Cl=C3=A9ment L=C3=A9ger wrote:
> > Le Fri, 20 May 2022 11:49:14 +0300,
> > Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :
> > =20
> > > On Fri, May 20, 2022 at 09:52:41AM +0200, Cl=C3=A9ment L=C3=A9ger wro=
te: =20
> > > > > Also, as a request to unbind this driver would be disasterous to =
users,
> > > > > I think you should set ".suppress_bind_attrs =3D true" to prevent=
 the
> > > > > sysfs bind/unbind facility being available. This doesn't complete=
ly
> > > > > solve the problem. =20
> > > >
> > > > Acked. What should I do to make it more robust ? Should I use a
> > > > refcount per pdev and check that in the remove() callback to avoid
> > > > removing the pdev if used ? =20
> > >
> > > I wonder, if you call device_link_add(ds->dev, miic->dev, DL_FLAG_AUT=
OREMOVE_CONSUMER),
> > > wouldn't that be enough to auto-unbind the DSA driver when the MII
> > > converter driver unbinds? =20
> >
> > I looiked at that a bit and I'm not sure how to achieve that cleanly. If
> > I need to create this link, then I need to do it once for the dsa switch
> > device. However, currently, the way I get the references to the MII
> > converter are via the pcs-handle properties which are for each port.
> >
> > So, I'm not sure creating the link multiple times in miic_create() would
> > be ok and also, I'm not sure how to create the link once without adding
> > a specific property which points on the MII converter node and use that
> > to create the link by adding miic_device_add_link() for instance.
> >
> > Do you have any preference ? =20
>=20
> The simplest (although not the most elegant) way would probably be to
> pass the ds->dev as a second argument to miic_create(), and call
> device_link_add() multiple times, letting all but the first call fail,
> and ignoring the resulting NULL return code. Maybe others have a better i=
dea.

That's indeed what I started to do although it's nasty to say the
least... Moreover, the device_link_del() calls in miic_destroy() would
have to be carefully made after all miic ports have been
destroyed. Not sure this is going to be cleaner ! I'll try to think
about it a bit more.

Thanks,

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
