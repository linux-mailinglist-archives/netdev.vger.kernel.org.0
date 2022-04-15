Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7C2502A02
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 14:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349269AbiDOMhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 08:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353437AbiDOMhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 08:37:18 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485DAC74B8;
        Fri, 15 Apr 2022 05:32:50 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6B01B24000B;
        Fri, 15 Apr 2022 12:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650025969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/rpSdRIr29uNTmJaIt9QZ8DL3HFAoCTObhaQHkW3Kc8=;
        b=PMANM4wIkVW/Tb63MnsMzWSZrCLJdDueAmYFd0HG4+yq3+ZT5dG+bsiust3DfCU+U4ei7C
        zzOUf3jW+4KXkACkNhTB1KyHNhCFPEgYADQ1m5PrHB73iS9qh664xxQpeAbvYNxIwnAH2c
        AvGyCpi/yavxV5erssG/G3WMCJ2XDKhwlcm5FpEj6OyYN1aXFO662a66XW55agee6WsUYe
        j9darq1RkYXSneWVPn/0Mb0fvJ3CakzU22YSd9g4e32I63v+ylnMroET52hF04AWMwm7Xm
        F7bOnFbSW5db9ZXZ9BarWjnDEMov6AYm/ZuwWsnKpi934Rl9+ZWLZZGGOtcTOA==
Date:   Fri, 15 Apr 2022 14:31:20 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
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
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>,
        Phil Edworthy <phil.edworthy@renesas.com>
Subject: Re: [PATCH net-next 06/12] net: dsa: rzn1-a5psw: add Renesas RZ/N1
 advanced 5 port switch driver
Message-ID: <20220415143120.4c406ff9@fixe.home>
In-Reply-To: <20220415110524.4lhue7gcwqlhk2iv@skbuf>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
        <20220414122250.158113-7-clement.leger@bootlin.com>
        <20220414144709.tpxiiaiy2hu4n7fd@skbuf>
        <20220415113453.1a076746@fixe.home>
        <20220415105503.ztl4zhoyua2qzelt@skbuf>
        <20220415110524.4lhue7gcwqlhk2iv@skbuf>
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

Le Fri, 15 Apr 2022 14:05:24 +0300,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> On Fri, Apr 15, 2022 at 01:55:03PM +0300, Vladimir Oltean wrote:
> > > > The selftests don't cover nearly enough, but just to make sure that=
 they
> > > > pass for your switch, when you use 2 switch ports as h1 and h2 (hos=
ts),
> > > > and 2 ports as swp1 and swp2? There's surprisingly little that you =
do on
> > > > .port_bridge_join, I need to study the code more. =20
> > >=20
> > > Port isolation is handled by using a pattern matcher which is enabled
> > > for each port at setup. If set, the port packet will only be forwarded
> > > to the CPU port. When bridging is needed, the pattern matching is
> > > disabled and thus, the packets are forwarded between all the ports th=
at
> > > are enabled in the bridge. =20
> >=20
> > Is there some public documentation for this pattern matcher? =20
>=20
> Again, I realize I haven't made it clear what concerns me here.
> On ->port_bridge_join() and ->port_bridge_leave(), the "bridge" is given
> to you as argument. 2 ports may join br0, and 2 ports may join br1.
> You disregard the "bridge" argument. So you enable forwarding between
> br0 and br1. What I'd like to see is what the hardware can do in terms
> of this "pattern matching", to improve on this situation.

Yes, you are right, the driver currently won't support 2 differents
bridges. Either I add checks to support explicitely only one, or I add
support for multiple bridges. This would probably requires to use VLAN
internally to separate trafic.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
