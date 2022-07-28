Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9E71584214
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 16:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbiG1OpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 10:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiG1OpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 10:45:16 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6DAF05
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 07:45:14 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id n138so1540560iod.4
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 07:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gcyZrD41WVmZL+M0duphde7MAmJcRr0cSttFggdiwxY=;
        b=b/CEO7IqYeTQ9QzVCWitr8QpUBO316wbQg1T6Nry3tEYtE7CL80UsVwnpkEBo+HCQr
         xGZKSoGwiOYWl5JPJT5pRxvNBJ2ic4RiCGyEr1lWflulBlD1taVWLpJrw+lWB1NsW5uq
         oPn7NT7tFF98uvZEnaWfZBctq/8NBZVyPiv5WTX4cpxMAc/Jken/pG2GzTC6QtMKmZAT
         PiGqfVrJ0EN3vq0cReIqnQuocZj3IAb8Xkecvfg/Hql6RC6JDpZa7Ts+dwb8hfra3GWZ
         e3DUHon1AWUkxFoBaTBNMGgIjk4QWaerJcem4Ctl0qlFXhH04Q1gDOMnYklFoiSunhUg
         INSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gcyZrD41WVmZL+M0duphde7MAmJcRr0cSttFggdiwxY=;
        b=511+576tbO3dCTA3wOit96L52Hcym2vm2MsGE9r15JJ8bwzAep9LeWep6Zyk9e2eni
         HOmnZpeWqS6w0s5fwyENgUaqB97RUTeDgNvOlt8TB8dU7MkD2x+oXORyILzTgmHCrv/L
         n4KiaN95lUyJBEdrbKB2DaW5Rb8CBGcGp1Ekw9I2y8cmEVmnAAeR3VphLjVWd80+Takz
         9kSb3aGJwiZw5y+TIqXj21UI7RAPEp+KJnBTsfysdCAKo3pByyko9m5iA2kXcf82F4kb
         /6z+XnlDNg/1blFMPn4Hytjz6RYuXs9ia7YmFTpIL7eQhW2NQ37rN9GAsvRagAPByFaT
         8x1w==
X-Gm-Message-State: AJIora/Qgk8Bye3z+iaIZITsPvDErGwcbptTMJC8yecpeNNthh9aMWk7
        NMzwmdZOtyUGI+iB1qAyNKhj87n3d5lL29cR9PCyR5KM2EU=
X-Google-Smtp-Source: AGRyM1sOGuuRJVY3QjWMJGNLX2I++qh0kl7GBkhuC4fi/bYbIFz0o0rOoNRlGrrJBj1XaBJt1ko2HyRIgHj+/gFR6TE=
X-Received: by 2002:a05:6638:1394:b0:341:4d18:3d41 with SMTP id
 w20-20020a056638139400b003414d183d41mr11403482jad.90.1659019513390; Thu, 28
 Jul 2022 07:45:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAFZh4h-JVWt80CrQWkFji7tZJahMfOToUJQgKS5s0_=9zzpvYQ@mail.gmail.com>
 <fd16ebb3-2435-ef01-d9f1-b873c9c0b389@gmail.com> <CAFZh4h-FJHha_uo--jHQU3w4AWh2k3+D6Lrz=ce5sbu3=BmTTw@mail.gmail.com>
 <20220727233249.fpn7gyivnkdg5uhe@skbuf>
In-Reply-To: <20220727233249.fpn7gyivnkdg5uhe@skbuf>
From:   Brian Hutchinson <b.hutchman@gmail.com>
Date:   Thu, 28 Jul 2022 10:45:02 -0400
Message-ID: <CAFZh4h-w739Xq6x13PpFvCFX=dCD571k1bdMyfk1Wvtkk_vvCw@mail.gmail.com>
Subject: Re: Bonded multicast traffic causing packet loss when using DSA with
 Microchip KSZ9567 switch
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        andrew@lunn.ch, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Wed, Jul 27, 2022 at 7:32 PM Vladimir Oltean <olteanv@gmail.com> wrote:

> > bond1: flags=5187<UP,BROADCAST,RUNNING,MASTER,MULTICAST>  mtu 1500  metric 1
> >        inet 192.168.1.6  netmask 255.255.255.0  broadcast 0.0.0.0
> >        inet6 fd1c:a799:6054:0:60e2:5ff:fe75:6716  prefixlen 64  scopeid 0x0<global>
> >        inet6 fe80::60e2:5ff:fe75:6716  prefixlen 64  scopeid 0x20<link>
> >        ether 62:e2:05:75:67:16  txqueuelen 1000  (Ethernet)
>
> I see bond1, lan1 and lan2 all have the same MAC address (62:e2:05:75:67:16).
> Does this happen even when they are all different?

So I have (when bond is setup using Systemd) assigned unique MAC
addresses for eth0, lan1 and lan2 ... but default action of bonding is
to assign the bond (bond1) and the slaves (lan1, lan2) a MAC that is
all the same among all the interfaces.  There are settings (controlled
by fail_over_mac) to specify which MAC is chosen to seed the MAC of
the other interfaces but bottom line is bonding makes both the bond
and active slave at a minimum the same MAC.

>
> >        RX packets 2557  bytes 3317974 (3.1 MiB)
> >        RX errors 0  dropped 2  overruns 0  frame 0
> >        TX packets 2370  bytes 3338160 (3.1 MiB)
> >        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
> >
> > eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1506  metric 1
> >        inet6 fe80::f21f:afff:fe6b:b218  prefixlen 64  scopeid 0x20<link>
> >        ether f0:1f:af:6b:b2:18  txqueuelen 1000  (Ethernet)
> >        RX packets 2557  bytes 3371671 (3.2 MiB)
> >        RX errors 0  dropped 0  overruns 0  frame 0
> >        TX packets 2394  bytes 3345891 (3.1 MiB)
> >        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
> >
> > lan1: flags=6211<UP,BROADCAST,RUNNING,SLAVE,MULTICAST>  mtu 1500  metric 1
> >        ether 62:e2:05:75:67:16  txqueuelen 1000  (Ethernet)
> >        RX packets 248  bytes 19384 (18.9 KiB)
> >        RX errors 0  dropped 0  overruns 0  frame 0
> >        TX packets 2370  bytes 3338160 (3.1 MiB)
> >        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
> >
> > lan2: flags=6211<UP,BROADCAST,RUNNING,SLAVE,MULTICAST>  mtu 1500  metric 1
> >        ether 62:e2:05:75:67:16  txqueuelen 1000  (Ethernet)
> >        RX packets 2309  bytes 3298590 (3.1 MiB)
> >        RX errors 0  dropped 1  overruns 0  frame 0
>
> I find this extremely strange. AFAIK, ifconfig reads stats from /proc/net/dev,
> which in turn takes them from the driver using dev_get_stats():
> https://elixir.bootlin.com/linux/v5.10.69/source/net/core/net-procfs.c#L78
>
> But DSA didn't even report the "dropped" count via ndo_get_stats64 in 5.10...
> https://elixir.bootlin.com/linux/v5.10.69/source/net/dsa/slave.c#L1257
>
> I have no idea why this shows 1. I'll have to ignore this information
> for now.
>
.
.
.
>
> Would you mind trying to test the exact same scenario again with the
> patch attached? (also pasted below in plain text) Still the same MAC
> address for all interfaces for now.

No problem at all.  I'm stumped too and welcome ideas to figure out
what is going on.

>
> From 033e3a8650a498de73cd202375b2e3f843e9a376 Mon Sep 17 00:00:00 2001
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date: Thu, 28 Jul 2022 02:07:08 +0300
> Subject: [PATCH] ksz9477: force-disable address learning
>
> I suspect that what Brian Hutchinson experiences with the rx_discards
> counter incrementing is due to his setup, where 2 external switches
> connect together 2 bonded KSZ9567 switch ports, in such a way that one
> KSZ port is able to see packets sent by the other (this is probably
> aggravated by the multicast sent at a high data rate, which is treated
> as broadcast by the external switches and flooded).

So I mentioned in a recent PM that I was looking at other vendor DSA
drivers and I see code that smells like some of the concerns you have.

I did some grepping on /drivers/net/dsa and while I get hits for
things like 'flood', 'multicast', 'igmp' etc. in marvel and broadcom
drivers ... I get nothing on microchip.  Hardware documentation has
whole section on ingress and egress rate limiting and shaping but
doesn't look like drivers use any of it.

Example:

/drivers/net/dsa/mv88e6xxx$ grep -i multicast *.c
chip.c: { "in_multicasts",              4, 0x07, STATS_TYPE_BANK0, },
chip.c: { "out_multicasts",             4, 0x12, STATS_TYPE_BANK0, },
chip.c:                  is_multicast_ether_addr(addr))
chip.c: /* Upstream ports flood frames with unknown unicast or multicast DA */
chip.c:  * forwarding of unknown unicasts and multicasts.
chip.c:         dev_err(ds->dev, "p%d: failed to load multicast MAC address\n",
chip.c:                                  bool unicast, bool multicast)
chip.c:                                                       multicast);
global2.c:      /* Consider the frames with reserved multicast destination
global2.c:      /* Consider the frames with reserved multicast destination
port.c:                              bool unicast, bool multicast)
port.c: if (unicast && multicast)
port.c: else if (multicast)
port.c:                                       int port, bool multicast)
port.c: if (multicast)
port.c:                              bool unicast, bool multicast)
port.c: return mv88e6185_port_set_default_for
ward(chip, port, multicast);

Wondering if some needed support is missing.

Will try your patch and report back.

Regards,

Brian
