Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F2252D58C
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 16:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236329AbiESOFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 10:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237997AbiESOFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 10:05:13 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359B14C782;
        Thu, 19 May 2022 07:05:12 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4CA1D240003;
        Thu, 19 May 2022 14:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652969110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h9OtmF/QnBskBXyVSE7sGC2GHmkFioOm7LT2WIKzJbc=;
        b=KxRcDdArQgaY69JxMzMuTdO9NjsAs3aSAQ4kHrk2KgTmGzTtbzNvbCS2T98EvNtc0ehiZy
        dl4rqa6yhw3/96EV9ALjFM6GuMakI5J3Elciw6omfsikhvUJ78Wnt1yhSkNNNj5Q/OcgYX
        hBQEVOrY6t+8NuMlY6UINONjqks/PoYDAwGI5wDxyoBJvml8o5oMsPTvgLVVldXgV8OQA8
        +5ZDpdZEWPXK7WiSauAnN0BS8A8L0+9OHPGKDYNiuT4sNOtuv+Qr6VfWnQ7m/GKZcObW5m
        z1PZHu+DN7faJEmrCaiHiY7jYxNbe/0MZOf7lDVsbt2jzFfMSFa0AFbY1pPDDQ==
Date:   Thu, 19 May 2022 16:03:53 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
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
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>,
        Phil Edworthy <phil.edworthy@renesas.com>
Subject: Re: [PATCH net-next v4 06/12] net: dsa: rzn1-a5psw: add Renesas
 RZ/N1 advanced 5 port switch driver
Message-ID: <20220519160353.12ee7463@fixe.home>
In-Reply-To: <20220511093638.kc32n6ldtaqfwupi@skbuf>
References: <20220509131900.7840-1-clement.leger@bootlin.com>
        <20220509131900.7840-7-clement.leger@bootlin.com>
        <20220509160813.stfqb4c2houmfn2g@skbuf>
        <20220510103458.381aaee2@xps-bootlin>
        <20220511093638.kc32n6ldtaqfwupi@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-pc-linux-gnu)
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

Le Wed, 11 May 2022 12:36:38 +0300,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> On Tue, May 10, 2022 at 10:34:58AM +0200, Cl=C3=A9ment L=C3=A9ger wrote:
> > > By the way, does this switch pass
> > > tools/testing/selftests/drivers/net/dsa/no_forwarding.sh? =20
> >=20
> > Unfortunately, the board I have only has 2 ports availables and thus, I
> > can only test one bridge or two separated ports at a time... I *should*
> > receive a 4 ports one in a near future but that not yet sure. =20
>=20
> 2 switch ports or 2 ports in total? h1 and h2 can be non-switch ports
> (should work with USB-Ethernet adapters etc).

Ok, I finally got the tests running. They seems to work for the
standalone variant.

TEST: Standalone switch ports: Unicast non-IP untagged              [ OK ]
TEST: Standalone switch ports: Multicast non-IP untagged            [ OK ]
TEST: Standalone switch ports: Broadcast non-IP untagged            [ OK ]
TEST: Standalone switch ports: Unicast IPv4 untagged                [ OK ]
TEST: Standalone switch ports: Multicast IPv4 untagged              [ OK ]
TEST: Standalone switch ports: Unicast IPv6 untagged                [ OK ]
TEST: Standalone switch ports: Multicast IPv6 untagged              [ OK ]

I disabled tests two_bridges and one_bridge_two_pvids since the
switch driver does only support 1 bridge and do not have vlan support
yet.

I also ran ./test_bridge_fdb_stress.sh which did reveal some sleep in
spin_lock() issue due to poll_io_timeout() being used. I switch the FDB
lock to use a mutex instead of a spinlock.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
