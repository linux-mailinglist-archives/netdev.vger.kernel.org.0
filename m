Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6254D5BCFBC
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 16:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiISO7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 10:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiISO6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 10:58:51 -0400
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37AEF1C107;
        Mon, 19 Sep 2022 07:58:50 -0700 (PDT)
Received: by mail-qv1-f49.google.com with SMTP id c6so22008095qvn.6;
        Mon, 19 Sep 2022 07:58:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=FO5wWOn3ONwax1YxwjpQU9wWpYS3F4tNurhG31VaKKQ=;
        b=hG8syZiLpluIy/oVGfIWQL61BcoVqNSWDPLToJ2YdmpeUZ0lzS+XeX43yp2qN6QIMr
         mlFv6Ya9bg8GefoFA2WZBEPwUBC3XWB9bK6myO4/Db19IpCt3WCFJc+Rt0FzZHiXd7QF
         anaR6H0fNcxw1M0gOqQXtRPQOZzCuzMZGr/RRJuXJkrdPDZX883B95qSgG6xq5XpGF/W
         TpHVT0sHBc873mWm6Uw9PSPtlkzUjHfWl/0wjfnPsiP5+rkKB/VKW4PhYvk5tp+4tfIc
         WJTahj9+FkG0AEaEt/DAXHPCnB72bR67DGz/7Ho+M3drip2XJyjaRg/rfCatamrEW+lY
         xhIg==
X-Gm-Message-State: ACrzQf0qZvGfzWyLWs/v2aFz46BUYixRqrDbcvikiTbvAZ8t7SQzuC5u
        bCO1udUbN9MeFwKw9vWY6OvF38L4jQ4M2A==
X-Google-Smtp-Source: AMsMyM6kjLuA5nYgqvMlKY19FFmGZixm4EyyrXABIC8EgWEkAR/8bk1PlcsJ2fiy9taZqWuiS8eZIg==
X-Received: by 2002:a05:6214:763:b0:4ac:85f8:84c with SMTP id f3-20020a056214076300b004ac85f8084cmr15191249qvz.123.1663599529202;
        Mon, 19 Sep 2022 07:58:49 -0700 (PDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id e12-20020ac8670c000000b0035bb6298526sm10633511qtp.17.2022.09.19.07.58.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 07:58:49 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id 125so21607102ybt.12;
        Mon, 19 Sep 2022 07:58:48 -0700 (PDT)
X-Received: by 2002:a0d:dd09:0:b0:344:fca5:9b44 with SMTP id
 g9-20020a0ddd09000000b00344fca59b44mr14741007ywe.358.1663599116003; Mon, 19
 Sep 2022 07:51:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220801233403.258871-1-f.fainelli@gmail.com> <CGME20220812111948eucas1p2bf97e7f4558eb024f419346367a87b45@eucas1p2.samsung.com>
 <27016cc0-f228-748b-ea03-800dda4e5f0c@samsung.com> <8c21e530-8e8f-ce2a-239e-9d3a354996cf@gmail.com>
 <CAMuHMdV8vsbFx+nikAwn1po1-PeZVhzotMaLLk+wXNquZceaRQ@mail.gmail.com>
In-Reply-To: <CAMuHMdV8vsbFx+nikAwn1po1-PeZVhzotMaLLk+wXNquZceaRQ@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 19 Sep 2022 16:51:44 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWwdKJQT9aoGmkc7RkeOfGtzO7fKAgH4=x-5fckrOR7tA@mail.gmail.com>
Message-ID: <CAMuHMdWwdKJQT9aoGmkc7RkeOfGtzO7fKAgH4=x-5fckrOR7tA@mail.gmail.com>
Subject: Re: [PATCH net] net: phy: Warn about incorrect mdio_bus_phy_resume() state
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        netdev <netdev@vger.kernel.org>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Doug Berger <opendmb@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 3:20 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Fri, Aug 12, 2022 at 6:39 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
> > On 8/12/22 04:19, Marek Szyprowski wrote:
> > > On 02.08.2022 01:34, Florian Fainelli wrote:
> > >> Calling mdio_bus_phy_resume() with neither the PHY state machine set to
> > >> PHY_HALTED nor phydev->mac_managed_pm set to true is a good indication
> > >> that we can produce a race condition looking like this:
> > >>
> > >> CPU0                                         CPU1
> > >> bcmgenet_resume
> > >>    -> phy_resume
> > >>      -> phy_init_hw
> > >>    -> phy_start
> > >>      -> phy_resume
> > >>                                                   phy_start_aneg()
> > >> mdio_bus_phy_resume
> > >>    -> phy_resume
> > >>       -> phy_write(..., BMCR_RESET)
> > >>        -> usleep()                                  -> phy_read()
> > >>
> > >> with the phy_resume() function triggering a PHY behavior that might have
> > >> to be worked around with (see bf8bfc4336f7 ("net: phy: broadcom: Fix
> > >> brcm_fet_config_init()") for instance) that ultimately leads to an error
> > >> reading from the PHY.
> > >>
> > >> Fixes: fba863b81604 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
> > >> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > >
> > > This patch, as probably intended, triggers a warning during system
> > > suspend/resume cycle in the SMSC911x driver. I've observed it on ARM
> > > Juno R1 board on the kernel compiled from next-202208010:
> > >
> > >    ------------[ cut here ]------------
> > >    WARNING: CPU: 1 PID: 398 at drivers/net/phy/phy_device.c:323
> > > mdio_bus_phy_resume+0x34/0xc8
>
> I am seeing the same on the ape6evm and kzm9g development
> boards with smsc911x Ethernet, and on various boards with Renesas

So the smsc911x issue was fixed by commit 3ce9f2bef7552893
("net: smsc911x: Stop and start PHY during suspend and resume").

> Ethernet (sh_eth or ravb) if Wake-on-LAN is disabled.

The issue is still seen with sh_eth and ravb.  I have sent to fixes:
https://lore.kernel.org/r/c6e1331b9bef61225fa4c09db3ba3e2e7214ba2d.1663598886.git.geert+renesas@glider.be
https://lore.kernel.org/r/c6e1331b9bef61225fa4c09db3ba3e2e7214ba2d.1663598886.git.geert+renesas@glider.be

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
