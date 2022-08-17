Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F400596BF4
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 11:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbiHQJSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 05:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiHQJSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 05:18:16 -0400
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755A79FD6;
        Wed, 17 Aug 2022 02:18:15 -0700 (PDT)
Received: by mail-qk1-f177.google.com with SMTP id f4so7938959qkl.7;
        Wed, 17 Aug 2022 02:18:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=5jBoVbzGQCtyTY7INNBLuSnir7aONmr2lpezFOUi2gc=;
        b=lLSrBv8hiFKI883hC067WvGXRYdsRz0QVMSuz6IaK3BRJoMX3mz5kO+XyLY45EqUCu
         VaL1+WMLuordp2GbfygQ+NxnSc3etUO7uCEzxrrsynfz7YIaAy3nw9Cb1VWCHGekJCZz
         ue/DpCO21zOqAbXQNLzeV0hMO6YIYLJzfvi+4ik/bRW+O6waygROAKO/aeXJqd4u+C3B
         wAM2vQqvEhdVWzvKPHVDXe/4DczcXmUaUPlwxNtq8qtth2cAN1rVc4NlgYNsFuvqUjLG
         o572gIJuos2KLiu2RAI99dhH2HABnK2BPg51TspFs7rL1HNaeRE6zdv1UHQiDWqC6xNN
         hjDg==
X-Gm-Message-State: ACgBeo0EnGGbkVIfzplgd25rV2gSLSWd8g9AfvaUkEfWIEjUZ+I3MLxN
        hOFVw2AcaHr/XOdTjsupRrv1w4pRRIV/eg==
X-Google-Smtp-Source: AA6agR7Vxh2jb48IU2Fdspz0HBEVc8nycWpxppsaeLtKdHTjJMk2CEQonvfe80aQNkibGrlsk52RYA==
X-Received: by 2002:a05:620a:2181:b0:6bb:50a1:222e with SMTP id g1-20020a05620a218100b006bb50a1222emr7436719qka.151.1660727894435;
        Wed, 17 Aug 2022 02:18:14 -0700 (PDT)
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com. [209.85.128.171])
        by smtp.gmail.com with ESMTPSA id do7-20020a05620a2b0700b006a6ebde4799sm14162434qkb.90.2022.08.17.02.18.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 02:18:13 -0700 (PDT)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-33387bf0c4aso110701447b3.11;
        Wed, 17 Aug 2022 02:18:12 -0700 (PDT)
X-Received: by 2002:a5b:bcd:0:b0:68f:b4c0:7eca with SMTP id
 c13-20020a5b0bcd000000b0068fb4c07ecamr3297004ybr.202.1660727892477; Wed, 17
 Aug 2022 02:18:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220801233403.258871-1-f.fainelli@gmail.com> <CGME20220812111948eucas1p2bf97e7f4558eb024f419346367a87b45@eucas1p2.samsung.com>
 <27016cc0-f228-748b-ea03-800dda4e5f0c@samsung.com> <8c21e530-8e8f-ce2a-239e-9d3a354996cf@gmail.com>
 <CAMuHMdV8vsbFx+nikAwn1po1-PeZVhzotMaLLk+wXNquZceaRQ@mail.gmail.com> <c1301f39-9202-5eee-a0f6-9c0b66f2dccf@gmail.com>
In-Reply-To: <c1301f39-9202-5eee-a0f6-9c0b66f2dccf@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 17 Aug 2022 11:18:00 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXiawCULreUKZsBD0LNc3FTqMxpfM11N46OqppChT91Kw@mail.gmail.com>
Message-ID: <CAMuHMdXiawCULreUKZsBD0LNc3FTqMxpfM11N46OqppChT91Kw@mail.gmail.com>
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
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Wed, Aug 17, 2022 at 4:28 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
> On 8/16/2022 6:20 AM, Geert Uytterhoeven wrote:
> > On Fri, Aug 12, 2022 at 6:39 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
> >> On 8/12/22 04:19, Marek Szyprowski wrote:
> >>> On 02.08.2022 01:34, Florian Fainelli wrote:
> >>>> Calling mdio_bus_phy_resume() with neither the PHY state machine set to
> >>>> PHY_HALTED nor phydev->mac_managed_pm set to true is a good indication
> >>>> that we can produce a race condition looking like this:
> >>>>
> >>>> CPU0                                         CPU1
> >>>> bcmgenet_resume
> >>>>     -> phy_resume
> >>>>       -> phy_init_hw
> >>>>     -> phy_start
> >>>>       -> phy_resume
> >>>>                                                    phy_start_aneg()
> >>>> mdio_bus_phy_resume
> >>>>     -> phy_resume
> >>>>        -> phy_write(..., BMCR_RESET)
> >>>>         -> usleep()                                  -> phy_read()
> >>>>
> >>>> with the phy_resume() function triggering a PHY behavior that might have
> >>>> to be worked around with (see bf8bfc4336f7 ("net: phy: broadcom: Fix
> >>>> brcm_fet_config_init()") for instance) that ultimately leads to an error
> >>>> reading from the PHY.
> >>>>
> >>>> Fixes: fba863b81604 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
> >>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >>>
> >>> This patch, as probably intended, triggers a warning during system
> >>> suspend/resume cycle in the SMSC911x driver. I've observed it on ARM
> >>> Juno R1 board on the kernel compiled from next-202208010:
> >>>
> >>>     ------------[ cut here ]------------
> >>>     WARNING: CPU: 1 PID: 398 at drivers/net/phy/phy_device.c:323
> >>> mdio_bus_phy_resume+0x34/0xc8
> >
> > I am seeing the same on the ape6evm and kzm9g development
> > boards with smsc911x Ethernet, and on various boards with Renesas
> > Ethernet (sh_eth or ravb) if Wake-on-LAN is disabled.
> >
> >> Yes this is catching an actual issue in the driver in that the PHY state
> >> machine is still running while the system is trying to suspend. We could
> >> go about fixing it in a different number of ways, though I believe this
> >> one is probably correct enough to work and fix the warning:
> >
> >> --- a/drivers/net/ethernet/smsc/smsc911x.c
> >> +++ b/drivers/net/ethernet/smsc/smsc911x.c
> >> @@ -1037,6 +1037,8 @@ static int smsc911x_mii_probe(struct net_device *dev)
> >>                   return ret;
> >>           }
> >>
> >> +       /* Indicate that the MAC is responsible for managing PHY PM */
> >> +       phydev->mac_managed_pm = true;
> >>           phy_attached_info(phydev);
> >>
> >>           phy_set_max_speed(phydev, SPEED_100);
> >> @@ -2587,6 +2589,8 @@ static int smsc911x_suspend(struct device *dev)
> >>           if (netif_running(ndev)) {
> >>                   netif_stop_queue(ndev);
> >>                   netif_device_detach(ndev);
> >> +               if (!device_may_wakeup(dev))
> >> +                       phy_suspend(dev->phydev);
> >>           }
> >>
> >>           /* enable wake on LAN, energy detection and the external PME
> >> @@ -2628,6 +2632,8 @@ static int smsc911x_resume(struct device *dev)
> >>           if (netif_running(ndev)) {
> >>                   netif_device_attach(ndev);
> >>                   netif_start_queue(ndev);
> >> +               if (!device_may_wakeup(dev))
> >> +                       phy_resume(dev->phydev);
> >>           }
> >>
> >>           return 0;
> >
> > Thanks for your patch, but unfortunately this does not work on ape6evm
> > and kzm9g, where the smsc911x device is connected to a power-managed
> > bus.  It looks like the PHY registers are accessed while the device
> > is already suspended, causing a crash during system suspend:
>
> Does it work better if you replace phy_suspend() with phy_stop() and
> phy_resume() with phy_start()?

Thank you, much better!
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
