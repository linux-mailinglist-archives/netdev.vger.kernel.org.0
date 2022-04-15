Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C2B50262E
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 09:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351079AbiDOH1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 03:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351026AbiDOH1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 03:27:04 -0400
X-Greylist: delayed 68390 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 15 Apr 2022 00:24:33 PDT
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80370F5B;
        Fri, 15 Apr 2022 00:24:29 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A522840012;
        Fri, 15 Apr 2022 07:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650007468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WkE50f/cylqb9wbDSyPkHo6fWi5moEO5EYl1lk9fvRg=;
        b=Uvry18gYDkJPxtbJtJFk+TH3yaLIJHSvc/UhFGB/1uuZNZ/TbHMuBF7631vl3Hb6NDTUtl
        SEkQYeyf+2kQjxS7Q46J3CDXQ0Ckyrm+MU9UDhsI5W+f2OBE1Qkj7jw7NrjYRbNoNLGbAM
        0wvd7KJ4CW05bkwAwx1WQWiFBK1N6DCxMGZVnqic5nC2ZpQ8x7d9UerDCjDywIdLLM56FK
        lswzTAFUAD1NyDiYoM29B0TeyLl9H2WCBY2yuQbDf6KVL/Joy3Yvbq8qa0zvf2ADRTRKqu
        GegfrRPzsoy2qlbhHdYKTXdr46iba8Hoh2oLgcG2wTYxeqjTITSE6tzmWn+Hgw==
Date:   Fri, 15 Apr 2022 09:23:00 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
Subject: Re: [PATCH net-next 02/12] net: dsa: add Renesas RZ/N1 switch tag
 driver
Message-ID: <20220415092300.009ef819@fixe.home>
In-Reply-To: <YlhKkriHziPsWBCV@shell.armlinux.org.uk>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
        <20220414122250.158113-3-clement.leger@bootlin.com>
        <20220414142242.vsvv3vxexc7i3ukm@skbuf>
        <20220414163546.3f6c5157@fixe.home>
        <20220414151146.a2fncklswo6utiyd@skbuf>
        <20220414181815.5037651e@fixe.home>
        <YlhKkriHziPsWBCV@shell.armlinux.org.uk>
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

Le Thu, 14 Apr 2022 17:23:46 +0100,
"Russell King (Oracle)" <linux@armlinux.org.uk> a =C3=A9crit :

> On Thu, Apr 14, 2022 at 06:18:15PM +0200, Cl=C3=A9ment L=C3=A9ger wrote:
> > Le Thu, 14 Apr 2022 18:11:46 +0300,
> > Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :
> >  =20
> > > On Thu, Apr 14, 2022 at 04:35:46PM +0200, Cl=C3=A9ment L=C3=A9ger wro=
te: =20
> > > > > Please keep variable declarations sorted in decreasing order of l=
ine
> > > > > length (applies throughout the patch series, I won't repeat this =
comment).   =20
> > > >=20
> > > > Acked, both PCS and DSA driver are ok with that rule. Missed that o=
ne
> > > > though.   =20
> > >=20
> > > Are you sure? Because a5psw_port_stp_state_set() says otherwise. =20
> >=20
> > Weeeeell, ok let's say I missed these two. Would be useful to have such
> > checks in checkpatch.pl. =20
>=20
> Note that it's a local networking coding-style issue, rather than being
> kernel-wide.
>=20

Hi Russell, Yes I was aware of that but if I remember correctly, there
are some netowrking checks like multi line comments without an empty
first line in checkpatch. Anyway, I'll make sure to check that mroe
carefully next time.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
