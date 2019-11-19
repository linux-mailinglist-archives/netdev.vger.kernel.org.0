Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62E59102DCD
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 21:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfKSUx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 15:53:28 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41247 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbfKSUx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 15:53:28 -0500
Received: by mail-ed1-f68.google.com with SMTP id a21so18356638edj.8
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 12:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NHfA2oyZWSiMeu88Dc6Xz6igYYK7D4Fl4tN7eg2CIuQ=;
        b=kSab6YDPQpv+fDePPiXWG0U6kJk/RSj8/XsnonQzm0hCebjn2zIlxhpYp9Du+nBvkc
         a4I6iHEMRAoW5vmgD0PEDj78jecBdqgvjeibvaNnoHRLBYfW5oxmj93FLUs5xM4TXZKN
         8j/rAMr3lKfburae7IfSDTA+tbOBvXPjbzuKf02/td0p2Sg0y5eBERn1YkN8gLomgBsp
         1iYs1pXR+4lO7ac1A5D8P5vTaj7n9FIdNU8HYhoQ+g+qBDdAITpj5a4VSpoAjzNrQNTz
         7wJHD0GJHTJKcQp6pcpN6kdHURnNOrn7m3cHTTKltuAFZ/BJFjZqxbh3AkC54p6vowUe
         dRkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NHfA2oyZWSiMeu88Dc6Xz6igYYK7D4Fl4tN7eg2CIuQ=;
        b=Kyv4wMQeUADXOA3FltR1NnVoIB0rphFDk85ru4sLtFSPYpW3E5v8ewzJpKSWvhjLS2
         3ogJHkqP0zQvuh/W6HgzX0A6PXKCzZIiOGG0ufl9+cJnwnsF0UwtcB1PKapB7OsqrPz4
         KsPJuX3AvwmFWWIN6IGt23XUAsVCmmuDLQb5OR4GMdARDvxwaQSBKVw1LEeiWa3pRnny
         CS9s6STqxsnG+Wd6vkpKwOt3KyNY60m68nJ2HlyN3+23hsD4pdnpIMitzVlDeO6Z61J0
         ao47XwpUYf6l6/YT/qLG73sbUEYpn4y6Q/YrzWA5gZVYeWzR/dysdxSaKndSujDns8fu
         YBig==
X-Gm-Message-State: APjAAAVD3TgGC953slVWNObzVrnXTs7zgrsLqgxteWjOn0WD53zkY91X
        GsajTCtoPIo7TWiV/M7Il+XnMdWloxzb3Cl0+wk=
X-Google-Smtp-Source: APXvYqwnGrhtZK60gAhpBcixLeDcppEQddvTAh45sG3EqfkzoGc3PiS/HdLzZXH5Q1rLytxebS4e0I3LXMnFFBZqGzk=
X-Received: by 2002:a17:906:f119:: with SMTP id gv25mr7081943ejb.164.1574196805860;
 Tue, 19 Nov 2019 12:53:25 -0800 (PST)
MIME-Version: 1.0
References: <20191118181030.23921-1-olteanv@gmail.com> <20191118231339.ztotkr536udxuzsl@soft-dev3.microsemi.net>
 <CA+h21hpKN+7ifvFUt6KMYARf19i=Jfw_dwciuPxPC6ZyHRF2XQ@mail.gmail.com> <20191119204855.vgiwtrzx3426hbrc@soft-dev3.microsemi.net>
In-Reply-To: <20191119204855.vgiwtrzx3426hbrc@soft-dev3.microsemi.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 19 Nov 2019 22:53:14 +0200
Message-ID: <CA+h21hpBYXwJyqR4xjHR9=B893dKVF6r-TpX3CODpAH9HH-AWQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] Convert Ocelot and Felix switches to PHYLINK
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Nov 2019 at 22:49, Horatiu Vultur
<horatiu.vultur@microchip.com> wrote:
>
> The 11/19/2019 14:42, Vladimir Oltean wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> >
> > On Tue, 19 Nov 2019 at 01:13, Horatiu Vultur
> > <horatiu.vultur@microchip.com> wrote:
> > >
> > > The 11/18/2019 20:10, Vladimir Oltean wrote:
> > > > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > > >
> > > > This series is needed on NXP LS1028A to support the CPU port which runs
> > > > at 2500Mbps fixed-link, a setting which PHYLIB can't hold in its swphy
> > > > design.
> > > >
> > > > In DSA, PHYLINK comes "for free". I added the PHYLINK ops to the Ocelot
> > > > driver, integrated them to the VSC7514 ocelot_board module, then tested
> > > > them via the Felix front-end. The VSC7514 integration is only
> > > > compile-tested.
> > > >
> > > > Vladimir Oltean (2):
> > > >   net: mscc: ocelot: treat SPEED_UNKNOWN as SPEED_10
> > > >   net: mscc: ocelot: convert to PHYLINK
> > > >
> > > >  drivers/net/dsa/ocelot/felix.c           |  65 +++++++---
> > > >  drivers/net/ethernet/mscc/Kconfig        |   2 +-
> > > >  drivers/net/ethernet/mscc/ocelot.c       | 153 ++++++++++++-----------
> > > >  drivers/net/ethernet/mscc/ocelot.h       |  13 +-
> > > >  drivers/net/ethernet/mscc/ocelot_board.c | 151 +++++++++++++++++++---
> > > >  include/soc/mscc/ocelot.h                |  21 +++-
> > > >  6 files changed, 285 insertions(+), 120 deletions(-)
> > > >
> > > > --
> > > >
> > > > Horatiu, I am sorry for abusing your goodwill. Could you please test
> > > > this series and confirm it causes no regression on VSC7514?
> > >
> > > Hi Vladimir,
> > >
> > > Sorry for late reply, I have tried your patches but unfortunetly I get
> > > a segmentation fault when I try to set the link up.
> > > Here is the stack trace:
> > >
> > > # ip link set dev eth0 up
> > > [  259.978564] CPU 0 Unable to handle kernel paging request at virtual address 00000008, epc == 805aa7a4, ra == 805aa79c
> > > [  259.989679] Oops[#1]:
> > > [  259.992007] CPU: 0 PID: 98 Comm: ip Not tainted
> > > 5.4.0-rc7-01844-g0d53d4ce24f5 #2
> > > [  259.999428] $ 0   : 00000000 00000001 80910000 fffffff8
> > > [  260.004687] $ 4   : 8090838c 0000000e 9e51589c 9e515cbc
> > > [  260.009940] $ 8   : 00000000 807bea44 00000000 00000000
> > > [  260.015193] $12   : 00000000 00000020 00402f1c 00000002
> > > [  260.020445] $16   : 00000000 808e0000 808074f4 9f8a4828
> > > [  260.025699] $20   : 00000000 9e515cbc 9e515ba0 9e54fc10
> > > [  260.030952] $24   : 00000000 9e515dac
> > > [  260.036206] $28   : 9e514000 9e515840 00000000 805aa79c
> > > [  260.041460] Hi    : 00000129
> > > [  260.044351] Lo    : 00001a94
> > > [  260.047311] epc   : 805aa7a4 phylink_start+0x20/0x2e0
> > > [  260.052387] ra    : 805aa79c phylink_start+0x18/0x2e0
> > > [  260.057454] Status: 11008403 KERNEL EXL IE
> > > [  260.061661] Cause : 00800008 (ExcCode 02)
> > > [  260.065683] BadVA : 00000008
> > > [  260.068575] PrId  : 02019654 (MIPS 24KEc)
> > > [  260.072596] Modules linked in:
> > > [  260.075673] Process ip (pid: 98, threadinfo=(ptrval), task=(ptrval), tls=77e564a0)
> > > [  260.083263] Stack : 00000000 00000000 9f8a4800 808e0000 808074f4 9e515cbc 00000000 9f8a4800
> > > [  260.091662]         808e0000 805b7898 00000000 00000000 00000000 808e0000 808074f4 8062cf20
> > > [  260.100058]         00000000 00000000 00000000 00000000 00000000 00000000 00000000 9f8a4800
> > > [  260.108453]         9e515cbc 0295ff75 00000000 9f8a4800 00001003 808e0000 00000000 8062d39c
> > > [  260.116850]         00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> > > [  260.125245]         ...
> > > [  260.127706] Call Trace:
> > > [  260.130176] [<805aa7a4>] phylink_start+0x20/0x2e0
> > > [  260.134955] [<805b7898>] ocelot_port_open+0x10/0x20
> > > [  260.139897] [<8062cf20>] __dev_open+0x10c/0x194
> > > [  260.144457] [<8062d39c>] __dev_change_flags+0x1b0/0x210
> > > [  260.149712] [<8062d420>] dev_change_flags+0x24/0x68
> > > [  260.154625] [<806482d4>] do_setlink+0x340/0xaec
> > > [  260.159182] [<8064978c>] __rtnl_newlink+0x484/0x7d8
> > > [  260.164086] [<80649b30>] rtnl_newlink+0x50/0x84
> > > [  260.168676] [<80643484>] rtnetlink_rcv_msg+0x2e8/0x3b8
> > > [  260.173859] [<8067c9c0>] netlink_rcv_skb+0xa0/0x150
> > > [  260.178766] [<8067abdc>] netlink_unicast+0x1c4/0x26c
> > > [  260.183760] [<8067b478>] netlink_sendmsg+0x2cc/0x3e0
> > > [  260.188758] [<80601df8>] ___sys_sendmsg+0xec/0x280
> > > [  260.193584] [<80603b9c>] __sys_sendmsg+0x60/0xac
> > > [  260.198246] [<80115e98>] syscall_common+0x34/0x58
> > > [  260.202979] Code: afb10020  10400055  3c028091 <8e020008> 8c420004 10400086  24030001  1043006d  00000000
> > > [  260.212788]
> > > [  260.214696] ---[ end trace 42880f8a413b404b ]---
> > > Segmentation fault
> > > #
> > >
> > > The reason of this segmentation is that, before it was fine to use the
> > > phy PHY_INTERFACE_MODE_NA. Now if the phy interface is
> > > PHY_INTERFACE_MODE_NA it would not create the phylink. I think this can
> > > be fixed in the device tree.
> > >
> >
> > Oops, that does not sound good. But what crashes in phylink_start,
> > exactly, and why? I see there is a print right at the beginning of the
> > function, and it isn't visible in your log. Does it crash at the
> > print?
>
> Yes it crashes at the print because in the function 'ocelot_port_open'
> the priv->phylink is NULL. In the function mscc_ocelot_probe the phylink
> is not created because the function 'of_get_phy_mode' sets phy_mode to
> PHY_INTERFACE_MODE_NA because there is no 'phy-mode' attribut in the DT.
> And after that it checks the phy_mode and if it is PHY_INTERFACE_MODE_NA
> it would just continue to create the next interface so the phylink is
> always NULL.
>
> Before this commit it was ok to use PHY_INTERFACE_MODE_NA but now that
> is not true anymore. In this case we have 4 ports that have phy and
> then 6 sfp ports. So I was looking to describe this in DT but without
> any success. If you have any advice that would be great.
>

What driver does your embedded PHY use?
If we use phylink_connect_phy instead of phylink_of_phy_connect, we
might be able to make use of Florian's patch:

commit 4904b6ea1f9dbf47107f50b1c502a22d0160712d
Author: Florian Fainelli <f.fainelli@gmail.com>
Date:   Tue Dec 12 16:00:26 2017 -0800

    net: phy: phylink: Use PHY device interface if N/A

    We may not always be able to resolve a correct phy_interface_t value before
    actually connecting to the PHY device, when that happens, just have
    phylink_connect_phy() utilize what the PHY device/driver provided.

    Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

and have your embedded PHY driver provide a valid phydev->interface
that can be used instead of PHY_INTERFACE_MODE_NA.
That's my best idea at the moment. Comments from others of course welcome.

> >
> > > Apparently there is another issue: mscc mdio bus driver fails to be
> > > probed. So first I need to see this issue and then I will try your
> > > patches.
> > >
> > > >
> > > > 2.17.1
> > > >
> > >
> > > --
> > > /Horatiu
> >
> > Thanks,
> > -Vladimir
>
> --
> /Horatiu

Thanks,
-Vladimir
