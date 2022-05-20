Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6878C52EF1A
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 17:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350784AbiETPYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 11:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350831AbiETPYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 11:24:05 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D308617855D;
        Fri, 20 May 2022 08:23:57 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 23225FF809;
        Fri, 20 May 2022 15:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1653060236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y2eVv2sbUXjs+9RjlT2SeuyRq4O8E4/f2RMuQg0THiI=;
        b=GeW2ux4oA0T5tY4/Oz5778QiBwJAqCaEtqHvz0IktDXqURyB3nKl8PRDSob4ipt+UJ+clQ
        RHgA+1ViJcedEMObN3EDKXNNkjC1A9f8Du99IDEW+FNTHKVla8JUn+/LLgEaGNaXr4MILQ
        11Cu1m4cFTVsGWXYLPSq7uTXWYafEE9qb8dr1jKEmbfL2GIMzopgOgjqepC9lUiHRxAxMq
        FZQO+KJxEZPtLzPJoE+/XIhozOXQ6l9pRO/WHy+z73K47u1rfY8cZRhlH7tRZ1tbjjnilG
        wdbNWOecFk1qbrlbmEj4D0npoVAZr46UB2w4W2GiNNidXC2jG5DBKaNlhvuQyQ==
Date:   Fri, 20 May 2022 17:22:44 +0200
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
Message-ID: <20220520172244.1f17f736@fixe.home>
In-Reply-To: <20220520084914.5x6bfu4qaza4tqcz@skbuf>
References: <20220519153107.696864-1-clement.leger@bootlin.com>
        <20220519153107.696864-6-clement.leger@bootlin.com>
        <YoZvZj9sQL2GZAI3@shell.armlinux.org.uk>
        <20220520095241.6bbccdf0@fixe.home>
        <20220520084914.5x6bfu4qaza4tqcz@skbuf>
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

Le Fri, 20 May 2022 11:49:14 +0300,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> On Fri, May 20, 2022 at 09:52:41AM +0200, Cl=C3=A9ment L=C3=A9ger wrote:
> > > Also, as a request to unbind this driver would be disasterous to user=
s,
> > > I think you should set ".suppress_bind_attrs =3D true" to prevent the
> > > sysfs bind/unbind facility being available. This doesn't completely
> > > solve the problem. =20
> >=20
> > Acked. What should I do to make it more robust ? Should I use a
> > refcount per pdev and check that in the remove() callback to avoid
> > removing the pdev if used ? =20
>=20
> I wonder, if you call device_link_add(ds->dev, miic->dev, DL_FLAG_AUTOREM=
OVE_CONSUMER),
> wouldn't that be enough to auto-unbind the DSA driver when the MII
> converter driver unbinds?

I looiked at that a bit and I'm not sure how to achieve that cleanly. If
I need to create this link, then I need to do it once for the dsa switch
device. However, currently, the way I get the references to the MII
converter are via the pcs-handle properties which are for each port.

So, I'm not sure creating the link multiple times in miic_create() would
be ok and also, I'm not sure how to create the link once without adding
a specific property which points on the MII converter node and use that
to create the link by adding miic_device_add_link() for instance.

Do you have any preference ?

Thanks,

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
