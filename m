Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C526517244
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 17:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385677AbiEBPNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 11:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352318AbiEBPNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 11:13:39 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3405311A21;
        Mon,  2 May 2022 08:10:09 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E7FE0240003;
        Mon,  2 May 2022 15:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651504204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=za927fpKikdw7PliunLHAWJEoeYWCuskj6yGi1D7Ozc=;
        b=Z1LvIl9xyl/xEIQi4dtlKJgKmI46QfH3fQBm9jDTREx/8s108jliKTJDpmwmPirh/5ea79
        KQ0I1h/uZxnm71CCY1ihIhOqHExlKkf0zdi5IerYlVy2QRkzVWvvbyfCXqgptcoOnAt5ok
        DDQHVp5FpQ1vg+HHfdoij3Z3H9/1Pt6J3PyMoGVknfUw+4wvxB7nC+V3VnajlkRFqKoTFW
        QnCQR9DhP/OC/uXWbU0GUxxRk77iT2SMUot3Hj1pm4gyBY2Ett9KvkA6O2tmjIypOvC6lo
        ty3Iuge8/OiiWLRfslMQXZjHsnCavv6sRMlGTpSJP9MEjowL5ZDBRbntp19LNg==
Date:   Mon, 2 May 2022 17:08:46 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [net-next v2 00/12] add support for Renesas RZ/N1 ethernet
 subsystem devices
Message-ID: <20220502170846.24e5e003@fixe.home>
In-Reply-To: <CAMuHMdVKY7=CjfazEjNw-5vGP0_eQFX=K1H7DOSWajo2u-dkAQ@mail.gmail.com>
References: <20220429143505.88208-1-clement.leger@bootlin.com>
 <20220429123235.3098ed12@kernel.org>
 <20220502085103.19b4f47b@fixe.home>
 <CAMuHMdVKY7=CjfazEjNw-5vGP0_eQFX=K1H7DOSWajo2u-dkAQ@mail.gmail.com>
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

Le Mon, 2 May 2022 14:27:38 +0200,
Geert Uytterhoeven <geert@linux-m68k.org> a =C3=A9crit :

> Hi Cl=C3=A9ment,
>=20
> On Mon, May 2, 2022 at 8:52 AM Cl=C3=A9ment L=C3=A9ger
> <clement.leger@bootlin.com> wrote:
> > Le Fri, 29 Apr 2022 12:32:35 -0700,
> > Jakub Kicinski <kuba@kernel.org> a =C3=A9crit :
> > =20
> > > On Fri, 29 Apr 2022 16:34:53 +0200 Cl=C3=A9ment L=C3=A9ger wrote: =20
> > > > The Renesas RZ/N1 SoCs features an ethernet subsystem which
> > > > contains (most notably) a switch, two GMACs, and a MII
> > > > converter [1]. This series adds support for the switch and the
> > > > MII converter.
> > > >
> > > > The MII converter present on this SoC has been represented as a
> > > > PCS which sit between the MACs and the PHY. This PCS driver is
> > > > probed from the device-tree since it requires to be configured.
> > > > Indeed the MII converter also contains the registers that are
> > > > handling the muxing of ports (Switch, MAC, HSR, RTOS, etc)
> > > > internally to the SoC.
> > > >
> > > > The switch driver is based on DSA and exposes 4 ports + 1 CPU
> > > > management port. It include basic bridging support as well as
> > > > FDB and statistics support. =20
> > >
> > > Build's not happy (W=3D1 C=3D1):
> > >
> > > drivers/net/dsa/rzn1_a5psw.c:574:29: warning: symbol
> > > 'a5psw_switch_ops' was not declared. Should it be static? In file
> > > included from ../drivers/net/dsa/rzn1_a5psw.c:17:
> > > drivers/net/dsa/rzn1_a5psw.h:221:1: note: offset of packed
> > > bit-field =E2=80=98port_mask=E2=80=99 has changed in GCC 4.4 221 | } =
__packed; | ^
> > > =20
> >
> > Hi Jakub, I only had this one (due to the lack of W=3D1 C=3D1 I guess)
> > which I thought (wrongly) that it was due to my GCC version:
> >
> >   CC      net/dsa/switch.o
> >   CC      net/dsa/tag_8021q.o
> > In file included from ../drivers/net/dsa/rzn1_a5psw.c:17:
> > ../drivers/net/dsa/rzn1_a5psw.h:221:1: note: offset of packed
> > bit-field =E2=80=98port_mask=E2=80=99 has changed in GCC 4.4 221 | } __=
packed;
> >       | ^
> >   CC      kernel/module.o
> >   CC      drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.o
> >   CC      drivers/net/ethernet/stmicro/stmmac/dwmac100_core.o
> >
> > I'll fix the other errors which are more trivial, however, I did not
> > found a way to fix the packed bit-field warning. =20
>=20
> The "port_mask" field is split across 2 u8s.
> What about using u16 instead, and adding explicit padding while
> at it? The below gets rid of the warning, while the generated code
> is the same.
>=20
> --- a/drivers/net/dsa/rzn1_a5psw.h
> +++ b/drivers/net/dsa/rzn1_a5psw.h
> @@ -169,10 +169,11 @@
>=20
>  struct fdb_entry {
>         u8 mac[ETH_ALEN];
> -       u8 valid:1;
> -       u8 is_static:1;
> -       u8 prio:3;
> -       u8 port_mask:5;
> +       u16 valid:1;
> +       u16 is_static:1;
> +       u16 prio:3;
> +       u16 port_mask:5;
> +       u16 reserved:6;
>  } __packed;

Hi Geert ! Indeed, while looking a bit more in depth at this error I
found that using u16 avoids this error. I did switch to u16 but did not
add any "reserved" field at the end and there is no more error. Do you
think adding the "reserved" field would be preferable ?

Thanks

>=20
>  union lk_data {
>=20
> Gr{oetje,eeting}s,
>=20
>                         Geert
>=20
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 --
> geert@linux-m68k.org
>=20
> In personal conversations with technical people, I call myself a
> hacker. But when I'm talking to journalists I just say "programmer"
> or something like that. -- Linus Torvalds

