Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4661A51729B
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 17:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385816AbiEBPfj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 2 May 2022 11:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385799AbiEBPfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 11:35:33 -0400
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5390B84D;
        Mon,  2 May 2022 08:32:04 -0700 (PDT)
Received: by mail-qt1-f173.google.com with SMTP id x9so11327812qts.6;
        Mon, 02 May 2022 08:32:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QjZfb+3ITLJWXClmfGWV99+ID1+wL1sj8gOCc0jKQYs=;
        b=iUDq0kuZymd6Zu7t6FQeB23+oxyIVSVbcCnUAU2iksGK+l37qJ6sObWx68BhuvEusT
         Tncp1tIetlTHEZDMUeRsJxEnU0yy9Hnj+7q3NoNNxfOlkCIwn1UxGaYovczG9klfcUuT
         1TfPVyy9aukn/pgg25BrsaNAlNSf0EyPpsgtcWUCpIfR2ecC1fE9o9ItLUnhwkbYFUe+
         ZXtXMA7kgpuCvQJgB5yCdDewdElP4I0v+tEnC6Jjkp2ymAqp7B8K6vtQR4yOfcksCff6
         5b8BTZR5cbSeZTflgQmAdxIjwmR00QZ5cV0RpkeTIMHmSemLn61CbXu3HzpJAj2RDQvb
         Tf0Q==
X-Gm-Message-State: AOAM5331VFt+cTZbvpt0yEkFVNcqphFI1H84HaqcthwCXo+k2qS2Ttup
        M4VKx83uNfhR4NzzTAll9WTKDEsSAp6S2A==
X-Google-Smtp-Source: ABdhPJxzU7oegChzm6ml1tArrHFkw7150iPmbgna/hfEe1IoczLQaxVC2k3QjlITqbIfGUMcuzJDLQ==
X-Received: by 2002:a05:622a:550:b0:2f3:87b2:47bf with SMTP id m16-20020a05622a055000b002f387b247bfmr10718918qtx.137.1651505523528;
        Mon, 02 May 2022 08:32:03 -0700 (PDT)
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com. [209.85.128.178])
        by smtp.gmail.com with ESMTPSA id i62-20020a37b841000000b0069fc13ce20esm4404484qkf.63.2022.05.02.08.32.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 May 2022 08:32:02 -0700 (PDT)
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-2f7d19cac0bso151467617b3.13;
        Mon, 02 May 2022 08:32:02 -0700 (PDT)
X-Received: by 2002:a81:913:0:b0:2f7:c833:f304 with SMTP id
 19-20020a810913000000b002f7c833f304mr11881281ywj.283.1651505522091; Mon, 02
 May 2022 08:32:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220429143505.88208-1-clement.leger@bootlin.com>
 <20220429123235.3098ed12@kernel.org> <20220502085103.19b4f47b@fixe.home>
 <CAMuHMdVKY7=CjfazEjNw-5vGP0_eQFX=K1H7DOSWajo2u-dkAQ@mail.gmail.com> <20220502170846.24e5e003@fixe.home>
In-Reply-To: <20220502170846.24e5e003@fixe.home>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 2 May 2022 17:31:50 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXUFa9brq0jTOv2ZWMYE7Y9ytf+0+kkK1xN9e7sFcHOzA@mail.gmail.com>
Message-ID: <CAMuHMdXUFa9brq0jTOv2ZWMYE7Y9ytf+0+kkK1xN9e7sFcHOzA@mail.gmail.com>
Subject: Re: [net-next v2 00/12] add support for Renesas RZ/N1 ethernet
 subsystem devices
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
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
        =?UTF-8?Q?Miqu=C3=A8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Clément,

On Mon, May 2, 2022 at 5:10 PM Clément Léger <clement.leger@bootlin.com> wrote:
> Le Mon, 2 May 2022 14:27:38 +0200,
> Geert Uytterhoeven <geert@linux-m68k.org> a écrit :
> > On Mon, May 2, 2022 at 8:52 AM Clément Léger
> > <clement.leger@bootlin.com> wrote:
> > > Le Fri, 29 Apr 2022 12:32:35 -0700,
> > > Jakub Kicinski <kuba@kernel.org> a écrit :
> > >
> > > > On Fri, 29 Apr 2022 16:34:53 +0200 Clément Léger wrote:
> > > > > The Renesas RZ/N1 SoCs features an ethernet subsystem which
> > > > > contains (most notably) a switch, two GMACs, and a MII
> > > > > converter [1]. This series adds support for the switch and the
> > > > > MII converter.
> > > > >
> > > > > The MII converter present on this SoC has been represented as a
> > > > > PCS which sit between the MACs and the PHY. This PCS driver is
> > > > > probed from the device-tree since it requires to be configured.
> > > > > Indeed the MII converter also contains the registers that are
> > > > > handling the muxing of ports (Switch, MAC, HSR, RTOS, etc)
> > > > > internally to the SoC.
> > > > >
> > > > > The switch driver is based on DSA and exposes 4 ports + 1 CPU
> > > > > management port. It include basic bridging support as well as
> > > > > FDB and statistics support.
> > > >
> > > > Build's not happy (W=1 C=1):
> > > >
> > > > drivers/net/dsa/rzn1_a5psw.c:574:29: warning: symbol
> > > > 'a5psw_switch_ops' was not declared. Should it be static? In file
> > > > included from ../drivers/net/dsa/rzn1_a5psw.c:17:
> > > > drivers/net/dsa/rzn1_a5psw.h:221:1: note: offset of packed
> > > > bit-field ‘port_mask’ has changed in GCC 4.4 221 | } __packed; | ^
> > > >
> > >
> > > Hi Jakub, I only had this one (due to the lack of W=1 C=1 I guess)
> > > which I thought (wrongly) that it was due to my GCC version:
> > >
> > >   CC      net/dsa/switch.o
> > >   CC      net/dsa/tag_8021q.o
> > > In file included from ../drivers/net/dsa/rzn1_a5psw.c:17:
> > > ../drivers/net/dsa/rzn1_a5psw.h:221:1: note: offset of packed
> > > bit-field ‘port_mask’ has changed in GCC 4.4 221 | } __packed;
> > >       | ^
> > >   CC      kernel/module.o
> > >   CC      drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.o
> > >   CC      drivers/net/ethernet/stmicro/stmmac/dwmac100_core.o
> > >
> > > I'll fix the other errors which are more trivial, however, I did not
> > > found a way to fix the packed bit-field warning.
> >
> > The "port_mask" field is split across 2 u8s.
> > What about using u16 instead, and adding explicit padding while
> > at it? The below gets rid of the warning, while the generated code
> > is the same.
> >
> > --- a/drivers/net/dsa/rzn1_a5psw.h
> > +++ b/drivers/net/dsa/rzn1_a5psw.h
> > @@ -169,10 +169,11 @@
> >
> >  struct fdb_entry {
> >         u8 mac[ETH_ALEN];
> > -       u8 valid:1;
> > -       u8 is_static:1;
> > -       u8 prio:3;
> > -       u8 port_mask:5;
> > +       u16 valid:1;
> > +       u16 is_static:1;
> > +       u16 prio:3;
> > +       u16 port_mask:5;
> > +       u16 reserved:6;
> >  } __packed;
>
> Hi Geert ! Indeed, while looking a bit more in depth at this error I
> found that using u16 avoids this error. I did switch to u16 but did not
> add any "reserved" field at the end and there is no more error. Do you
> think adding the "reserved" field would be preferable ?

As this structure reflects a hardware definition, I think it is better to
make this explicit.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
