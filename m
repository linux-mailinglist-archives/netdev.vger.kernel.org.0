Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBA551BC81
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 11:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354313AbiEEJxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 05:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbiEEJxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 05:53:48 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206F14F9F6;
        Thu,  5 May 2022 02:50:08 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 72BC64000C;
        Thu,  5 May 2022 09:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651744207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xUjwIJpEfOXdIS7txS+q5utiDVgOIee83y+WNlMxJOM=;
        b=Z+R6SO9jeWSlxn1vJ7ttjTVjgZr/uE6JODAS49E1voO6KnKAxyiZevbldheyhq2G6csPNL
        XX57Dw+5SWkX9qU3VfE6ERnfa3rrBv3/2r372uxe4Jx7TgLjYbSwOGze7bhnveo8wNs8EW
        Xq1eh1nhcfkwj6HZm7FjW90wEADAH6E+GDFOHrO5Er+REgp6DdT3VPN9yo6ZpvVf60mFcM
        YXaCdLjdxidxKY3pIeXPkdJnG22fldwqzQFELY+XqrSI01D3w40Flf6TuLyAsjtC4NOp0f
        DqaHZBvK+ThghqYwtfb5ErHuUHJRe0/UVsO3U1MqUADYgwcKhAnV96xZqbol9Q==
Date:   Thu, 5 May 2022 11:48:46 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
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
Subject: Re: [PATCH net-next v3 00/12] add support for Renesas RZ/N1
 ethernet subsystem devices
Message-ID: <20220505114846.67697021@fixe.home>
In-Reply-To: <CAMuHMdXdGCebeGiDj-4hYH24tBVRVqGsHbPfEqfUGT88GZKZrw@mail.gmail.com>
References: <20220504093000.132579-1-clement.leger@bootlin.com>
        <CAMuHMdXdGCebeGiDj-4hYH24tBVRVqGsHbPfEqfUGT88GZKZrw@mail.gmail.com>
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

Le Thu, 5 May 2022 09:29:43 +0200,
Geert Uytterhoeven <geert@linux-m68k.org> a =C3=A9crit :

> Hi Cl=C3=A9ment,
>=20
> On Wed, May 4, 2022 at 11:31 AM Cl=C3=A9ment L=C3=A9ger <clement.leger@bo=
otlin.com> wrote:
> > This series needs commits bcfb459b25b8 and 542d5835e4f6 which are on
> > the renesas-devel tree in order to enable generic power domain on
> > RZ/N1. =20
>=20
> -ENOENT
>=20
> I assume you mean:
> 14f11da778ff6421 ("soc: renesas: rzn1: Select PM and
> PM_GENERIC_DOMAINS configs")
> ed66b37f916ee23b ("ARM: dts: r9a06g032: Add missing '#power-domain-cells'=
")

Yep totally, did use my cherry-picked sha1 -_-'. Will fix that, sorry.

>=20
> Gr{oetje,eeting}s,
>=20
>                         Geert
>=20
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m6=
8k.org
>=20
> In personal conversations with technical people, I call myself a hacker. =
But
> when I'm talking to journalists I just say "programmer" or something like=
 that.
>                                 -- Linus Torvalds



--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
