Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12ED595D22
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 15:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234611AbiHPNUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 09:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235615AbiHPNUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 09:20:22 -0400
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5E755A8;
        Tue, 16 Aug 2022 06:20:19 -0700 (PDT)
Received: by mail-qt1-f182.google.com with SMTP id x5so8040008qtv.9;
        Tue, 16 Aug 2022 06:20:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=hDkAAnw+hHxd4arV3hgrWxC6jV6Ka7uhFxxYbXDlq84=;
        b=Ie69SXBnTFwHYq+2qoaVNTMJqlSlP9rGPH8gDFzZrNLW3RVfxY+4H6NPLctCFAX7JJ
         MX5LOnbaDo+nw1QfpqvH4maxInHlhgD9n+KbEMkUKI4z7Ytb5ne2Vm+4oLPdjrn1Qaiy
         NV694j6yYFFJxw0Uzi/SjeBXkrZeL5JtZl3W5ohiVAHo7W9JIzDlTk9O60ed9rffZTJk
         5X9BAXDzth5kHhlXJuDqRLV/tGiYDX5jiJi7eia1DxIqdRcUIeUqqbWJFL920Kz2agDA
         LYav3MtVbAtITi5R1OGrUu8t2P5MuVyvReYX80e0lawG4+Khnh2SYVzp5TAkMLccfizw
         IkIw==
X-Gm-Message-State: ACgBeo3QAI8E62iaDX3FIU7RRLJc6/wTBsRdDMvjeoOjmMZQlwNAbSeI
        xPT+fhgD3/pFI51iy7lBG4n2EP7qWPwQGQ==
X-Google-Smtp-Source: AA6agR5mtz+9F5/sG4+zrfZmReY9+LbVHIt/DB8co+JfWJP78E9Xz7B2Q5oRDve48VIykbFBeatPaA==
X-Received: by 2002:ac8:5b0d:0:b0:33b:f61b:d173 with SMTP id m13-20020ac85b0d000000b0033bf61bd173mr18273671qtw.668.1660656017223;
        Tue, 16 Aug 2022 06:20:17 -0700 (PDT)
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com. [209.85.128.177])
        by smtp.gmail.com with ESMTPSA id n17-20020a05620a295100b006b64d36342fsm12047357qkp.68.2022.08.16.06.20.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Aug 2022 06:20:16 -0700 (PDT)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-3321c2a8d4cso97038637b3.5;
        Tue, 16 Aug 2022 06:20:15 -0700 (PDT)
X-Received: by 2002:a81:502:0:b0:32f:dcc4:146e with SMTP id
 2-20020a810502000000b0032fdcc4146emr10295665ywf.316.1660656015710; Tue, 16
 Aug 2022 06:20:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220801233403.258871-1-f.fainelli@gmail.com> <CGME20220812111948eucas1p2bf97e7f4558eb024f419346367a87b45@eucas1p2.samsung.com>
 <27016cc0-f228-748b-ea03-800dda4e5f0c@samsung.com> <8c21e530-8e8f-ce2a-239e-9d3a354996cf@gmail.com>
In-Reply-To: <8c21e530-8e8f-ce2a-239e-9d3a354996cf@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 16 Aug 2022 15:20:03 +0200
X-Gmail-Original-Message-ID: <CAMuHMdV8vsbFx+nikAwn1po1-PeZVhzotMaLLk+wXNquZceaRQ@mail.gmail.com>
Message-ID: <CAMuHMdV8vsbFx+nikAwn1po1-PeZVhzotMaLLk+wXNquZceaRQ@mail.gmail.com>
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
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Fri, Aug 12, 2022 at 6:39 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
> On 8/12/22 04:19, Marek Szyprowski wrote:
> > On 02.08.2022 01:34, Florian Fainelli wrote:
> >> Calling mdio_bus_phy_resume() with neither the PHY state machine set to
> >> PHY_HALTED nor phydev->mac_managed_pm set to true is a good indication
> >> that we can produce a race condition looking like this:
> >>
> >> CPU0                                         CPU1
> >> bcmgenet_resume
> >>    -> phy_resume
> >>      -> phy_init_hw
> >>    -> phy_start
> >>      -> phy_resume
> >>                                                   phy_start_aneg()
> >> mdio_bus_phy_resume
> >>    -> phy_resume
> >>       -> phy_write(..., BMCR_RESET)
> >>        -> usleep()                                  -> phy_read()
> >>
> >> with the phy_resume() function triggering a PHY behavior that might have
> >> to be worked around with (see bf8bfc4336f7 ("net: phy: broadcom: Fix
> >> brcm_fet_config_init()") for instance) that ultimately leads to an error
> >> reading from the PHY.
> >>
> >> Fixes: fba863b81604 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
> >> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >
> > This patch, as probably intended, triggers a warning during system
> > suspend/resume cycle in the SMSC911x driver. I've observed it on ARM
> > Juno R1 board on the kernel compiled from next-202208010:
> >
> >    ------------[ cut here ]------------
> >    WARNING: CPU: 1 PID: 398 at drivers/net/phy/phy_device.c:323
> > mdio_bus_phy_resume+0x34/0xc8

I am seeing the same on the ape6evm and kzm9g development
boards with smsc911x Ethernet, and on various boards with Renesas
Ethernet (sh_eth or ravb) if Wake-on-LAN is disabled.

> Yes this is catching an actual issue in the driver in that the PHY state
> machine is still running while the system is trying to suspend. We could
> go about fixing it in a different number of ways, though I believe this
> one is probably correct enough to work and fix the warning:

> --- a/drivers/net/ethernet/smsc/smsc911x.c
> +++ b/drivers/net/ethernet/smsc/smsc911x.c
> @@ -1037,6 +1037,8 @@ static int smsc911x_mii_probe(struct net_device *dev)
>                  return ret;
>          }
>
> +       /* Indicate that the MAC is responsible for managing PHY PM */
> +       phydev->mac_managed_pm = true;
>          phy_attached_info(phydev);
>
>          phy_set_max_speed(phydev, SPEED_100);
> @@ -2587,6 +2589,8 @@ static int smsc911x_suspend(struct device *dev)
>          if (netif_running(ndev)) {
>                  netif_stop_queue(ndev);
>                  netif_device_detach(ndev);
> +               if (!device_may_wakeup(dev))
> +                       phy_suspend(dev->phydev);
>          }
>
>          /* enable wake on LAN, energy detection and the external PME
> @@ -2628,6 +2632,8 @@ static int smsc911x_resume(struct device *dev)
>          if (netif_running(ndev)) {
>                  netif_device_attach(ndev);
>                  netif_start_queue(ndev);
> +               if (!device_may_wakeup(dev))
> +                       phy_resume(dev->phydev);
>          }
>
>          return 0;

Thanks for your patch, but unfortunately this does not work on ape6evm
and kzm9g, where the smsc911x device is connected to a power-managed
bus.  It looks like the PHY registers are accessed while the device
is already suspended, causing a crash during system suspend:

8<--- cut here ---
Unhandled fault: imprecise external abort (0x1406) at 0x00000000
[00000000] *pgd=00000000
Internal error: : 1406 [#1] SMP ARM
CPU: 2 PID: 75 Comm: kworker/2:2 Not tainted
6.0.0-rc1-ape6evm-00977-gdc70725fbca5-dirty #375
Hardware name: Generic R8A73A4 (Flattened Device Tree)
Workqueue: events_power_efficient phy_state_machine
PC is at smsc911x_reg_read+0x30/0x48
LR is at smsc911x_reg_read+0x30/0x48
pc : [<c03807cc>]    lr : [<c03807cc>]    psr: 20030093
sp : f0891e30  ip : 00000000  fp : eff98605
r10: c092af80  r9 : c202e6e8  r8 : 20030013
r7 : c202e70c  r6 : 000000a4  r5 : 20030093  r4 : c202e6c0
r3 : f0a31000  r2 : 00000002  r1 : f0a310a4  r0 : 00000000
Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 10c5387d  Table: 4552006a  DAC: 00000051
Register r0 information: NULL pointer
Register r1 information: 0-page vmalloc region starting at 0xf0a31000
allocated at smsc911x_drv_probe+0x108/0x934
Register r2 information: non-paged memory
Register r3 information: 0-page vmalloc region starting at 0xf0a31000
allocated at smsc911x_drv_probe+0x108/0x934
Register r4 information: slab kmalloc-4k start c202e000 pointer offset
1728 size 4096
Register r5 information: non-paged memory
Register r6 information: non-paged memory
Register r7 information: slab kmalloc-4k start c202e000 pointer offset
1804 size 4096
Register r8 information: non-paged memory
Register r9 information: slab kmalloc-4k start c202e000 pointer offset
1768 size 4096
Register r10 information: non-slab/vmalloc memory
Register r11 information: non-slab/vmalloc memory
Register r12 information: NULL pointer
Process kworker/2:2 (pid: 75, stack limit = 0x5239c21f)
Stack: (0xf0891e30 to 0xf0892000)
1e20:                                     c202e6c0 00000006 c19da000 c202e6c0
1e40: 20030013 c03815bc 00000000 00000001 c19da000 c0381820 00000001 c19da000
1e60: c19da000 00000000 c39eacc0 00000000 c092af80 c037e694 c19da000 00000001
1e80: 00000000 c19da758 c19da000 00000001 00000000 c037e888 c29a0000 c29a03f4
1ea0: 00000078 c29a0448 c39eacc0 c037c878 c29a0000 c037cab4 c29a0000 c29a03f4
1ec0: c29a0000 c037fbc8 c29a0000 c29a03f4 c29a0000 c29a0448 00000004 c0377540
1ee0: c3ac8f00 c29a03f4 c29a0000 c0378588 009a03f4 c07cce88 c3ac8f00 c29a03f4
1f00: eff96780 00000000 eff98600 00000080 c092af80 c00426f0 00000001 00000000
1f20: c00425c4 c07cce88 c07bb574 00000000 c13fa5b8 c0da3f6c 00000000 c071c1da
1f40: 00000000 c07cce88 00000000 c3ac8f00 c3ac8f18 eff96780 c092a665 c07c9d00
1f60: eff967bc c0934e20 00000000 c0042b30 c2b8a500 c2ba65c0 c3ac8880 f0901ebc
1f80: c00428f0 c3ac8f00 00000000 c00494c4 c2ba65c0 c00493f4 00000000 00000000
1fa0: 00000000 00000000 00000000 c0009108 00000000 00000000 00000000 00000000
1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
1fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
 smsc911x_reg_read from smsc911x_mac_read+0x4c/0xa0
 smsc911x_mac_read from smsc911x_mii_read+0x38/0xb4
 smsc911x_mii_read from __mdiobus_read+0x70/0xc4
 __mdiobus_read from mdiobus_read+0x34/0x48
 mdiobus_read from genphy_update_link+0x10/0xc8
 genphy_update_link from genphy_read_status+0x10/0xc4
 genphy_read_status from lan87xx_read_status+0x10/0x11c
 lan87xx_read_status from phy_check_link_status+0x5c/0xbc
 phy_check_link_status from phy_state_machine+0x78/0x218
 phy_state_machine from process_one_work+0x2f0/0x4c4
 process_one_work from worker_thread+0x240/0x2d0
 worker_thread from kthread+0xd0/0xe0
 kthread from ret_from_fork+0x14/0x2c
Exception stack(0xf0891fb0 to 0xf0891ff8)
1fa0:                                     00000000 00000000 00000000 00000000
1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
Code: e5933000 e1a05000 e1a00004 e12fff33 (e1a01005)
---[ end trace 0000000000000000 ]---

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
