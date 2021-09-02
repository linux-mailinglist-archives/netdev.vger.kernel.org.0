Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15B43FF019
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 17:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345798AbhIBPYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 11:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345712AbhIBPYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 11:24:45 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E891C061575;
        Thu,  2 Sep 2021 08:23:46 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id e26so1554655wmk.2;
        Thu, 02 Sep 2021 08:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4+qre20SAt2J5nhjwYberL+MSrwIJu2vrpb7BANREbc=;
        b=XE0Y1ExJHXBK8VQkIswm8JyDHLO/TeOWXUQCTWX0+AllaYld92JRfQTBmjfhiWnAj9
         /RPQ2mcq+CpPxkqy15KkyYRs731PCfJDzloskFwcOoesTIDpdXZpr5FQIljI1XHKvrQK
         auSZJAjHCC3LcAYzzHlP9magalW1O7tjyhIQJTTbp9I8St2sy6K4oU0//DXRA06iEhGC
         5f/IrJ7B1+IiYnLtXt5jBEdZo+/A2EfL7P5yoYVZxzqzAO3JHuSBBKN2KD8mykWOTRS/
         oGHA/Zo6oToCp5nHBMj8bDWokQdOF1neTu25s57WeYfPBYYcxKaKqRdIBzWgyStxW+K+
         eS4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4+qre20SAt2J5nhjwYberL+MSrwIJu2vrpb7BANREbc=;
        b=qFL4xsO7TzOJbWFUa4l/KSRbXuqkl9lk5jhnRmBbl9YC9elEGRGOz3yO/cDIDsq/ki
         L1I8NypkaPkRw8P1KlYKg6KAeVHBowdT7czgAlchPaXHvA2hrwo6DrWmZ5wdOS8M5Gpq
         HyBpjuT3qMLrKfENwqhMh25CvFXlgtPTHIY0Z/nCWNpFNtpyKCvR0Y9N6PG/wvK9FEjj
         h4jTwTDbqagzvMFdZXWtp/pM0tSjuuV/KPSgiPKfLfcksNBMd4UKgl18t686vBpqVyyh
         KVePAw+QWyEunDY+IWTknoKx4/KP4LDOn0EGEELczT4OaEeH6eD3rSNhv0UUi3LwU3eH
         9nYQ==
X-Gm-Message-State: AOAM532b2t2WQVL+CV1ZPXj8C0TqOFmF98kLStIK1fiZOY698LGirsNR
        sA6R0npE0V+4j6+wDL+qdSA=
X-Google-Smtp-Source: ABdhPJyhy2WhpoB1L+Z1yPnxo05H488rwWDFWlNzG69vB9YgZrRbvv1/bLfWJgc084JaZPMwWQWVew==
X-Received: by 2002:a7b:c7cc:: with SMTP id z12mr3676532wmk.108.1630596224612;
        Thu, 02 Sep 2021 08:23:44 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id p13sm2170191wro.8.2021.09.02.08.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 08:23:44 -0700 (PDT)
Date:   Thu, 2 Sep 2021 18:23:42 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 0/3] Make the PHY library stop being so
 greedy when binding the generic PHY driver
Message-ID: <20210902152342.vett7qfhvhiyejvo@skbuf>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210902121927.GE22278@shell.armlinux.org.uk>
 <20210902123532.ruvuecxoig67yv5v@skbuf>
 <20210902132635.GG22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902132635.GG22278@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 02:26:35PM +0100, Russell King (Oracle) wrote:
> On Thu, Sep 02, 2021 at 03:35:32PM +0300, Vladimir Oltean wrote:
> > On Thu, Sep 02, 2021 at 01:19:27PM +0100, Russell King (Oracle) wrote:
> > > On Thu, Sep 02, 2021 at 01:50:50AM +0300, Vladimir Oltean wrote:
> > > > The central point of that discussion is that DSA seems "broken" for
> > > > expecting the PHY driver to probe immediately on PHYs belonging to the
> > > > internal MDIO buses of switches. A few suggestions were made about what
> > > > to do, but some were not satisfactory and some did not solve the problem.
> > >
> > > I think you need to describe the mechanism here. Why wouldn't a PHY
> > > belonging to an internal MDIO bus of a switch not probe immediately?
> > > What resources may not be available?
> >
> > As you point out below, the interrupt-controller is what is not available.
> > There is a mechanism called fw_devlink which infers links from one OF
> > node to another based on phandles. When you have an interrupt-parent,
> > that OF node becomes a supplier to you. Those OF node links are then
> > transferred to device links once the devices having those OF nodes are
> > created.
> >
> > > If we have a DSA driver that tries to probe the PHYs before e.g. the
> > > interrupt controller inside the DSA switch has been configured, aren't
> > > we just making completely unnecessary problems for ourselves?
> >
> > This is not what happens, if that were the case, of course I would fix
> > _that_ and not in this way.
> >
> > > Wouldn't it be saner to ensure that the interrupt controller has been
> > > setup and become available prior to attempting to setup anything that
> > > relies upon that interrupt controller?
> >
> > The interrupt controller _has_ been set up. The trouble is that the
> > interrupt controller has the same OF node as the switch itself, and the
> > same OF node. Therefore, fw_devlink waits for the _entire_ switch to
> > finish probing, it doesn't have insight into the fact that the
> > dependency is just on the interrupt controller.
> >
> > > From what I see of Marvell switches, the internal PHYs only ever rely
> > > on internal resources of the switch they are embedded in.
> > >
> > > External PHYs to the switch are a different matter - these can rely on
> > > external clocks, and in that scenario, it would make sense for a
> > > deferred probe to cause the entire switch to defer, since we don't
> > > have all the resources for the switch to be functional (and, because we
> > > want the PHYs to be present at switch probe time, not when we try to
> > > bring up the interface, I don't see there's much other choice.)
> > >
> > > Trying to move that to interface-up time /will/ break userspace - for
> > > example, Debian's interfaces(8) bridge support will become unreliable,
> > > and probably a whole host of other userspace. It will cause regressions
> > > and instability to userspace. So that's a big no.
> >
> > Why a big no?
>
> Fundamental rule of kernel programming: we do not break existing
> userspace.

Of course, I wasn't asking why we shouldn't be breaking user space, but
about the specifics of why this change would do that.

> Debian has had support for configuring bridges at boot time via
> the interfaces file for years. Breaking that is going to upset a
> lot of people (me included) resulting in busted networks. It
> would be a sure way to make oneself unpopular.
>
> > I expect there to be 2 call paths of phy_attach_direct:
> > - At probe time. Both the MAC driver and the PHY driver are probing.
> >   This is what has this patch addresses. There is no issue to return
> >   -EPROBE_DEFER at that time, since drivers connect to the PHY before
> >   they register their netdev. So if connecting defers, there is no
> >   netdev to unregister, and user space knows nothing of this.
> > - At .ndo_open time. This is where it maybe gets interesting, but not to
> >   user space. If you open a netdev and it connects to the PHY then, I
> >   wouldn't expect the PHY to be undergoing a probing process, all of
> >   that should have been settled by then, should it not? Where it might
> >   get interesting is with NFS root, and I admit I haven't tested that.
>
> I don't think you can make that assumption. Consider the case where
> systemd is being used, DSA stuff is modular, and we're trying to
> setup a bridge device on DSA. DSA could be probing while the bridge
> is being setup.
>
> Sadly, this isn't theoretical. I've ended up needing:
>
> 	pre-up sleep 1
>
> in my bridge configuration to allow time for DSA to finish probing.
> It's not a pleasant solution, nor a particularly reliable one at
> that, but it currently works around the problem.

What problem? This is the first time I've heard of this report, and you
should definitely not need that.

I do have a system set up to use systemd-networkd, and I did want to try
this out:

$ for file in /etc/systemd/network/*; do echo ${file}; cat ${file}; done
/etc/systemd/network/br0.netdev
[NetDev]
Name=br0
Kind=bridge

[Bridge]
VLANFiltering=no
DefaultPVID=1
STP=no

[VLAN]
MVRP=no
/etc/systemd/network/br0.network
[Match]
Name=br0

[Network]
DHCP=ipv4
/etc/systemd/network/eth0.network
[Match]
Name=eth0

[Network]
Bridge=br0
/etc/systemd/network/eth1.network
[Match]
Name=eth1

[Network]
Bridge=br0
/etc/systemd/network/eth2.network
[Match]
Name=eth2

[Network]
LinkLocalAddressing=yes
/etc/systemd/network/swp.network
[Match]
Name=swp*

[Network]
BindCarrier=eth2
Bridge=br0
# Before
# bridge link
7: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 4
8: eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
# Kick off the probing
$ insmod sja1105.ko
[   34.922908] sja1105 spi0.1: Probed switch chip: SJA1105T
$ insmod tag_sja1105.ko
$ echo spi0.1 > /sys/bus/spi/drivers/sja1105/bind
[   51.345993] sja1105 spi0.1: Probed switch chip: SJA1105T
[   51.378063] sja1105 spi0.1 swp5 (uninitialized): PHY [mdio@2d24000:06] driver [Broadcom BCM5464] (irq=POLL)
[   51.389880] sja1105 spi0.1 swp2 (uninitialized): PHY [mdio@2d24000:03] driver [Broadcom BCM5464] (irq=POLL)
[   51.401806] sja1105 spi0.1 swp3 (uninitialized): PHY [mdio@2d24000:04] driver [Broadcom BCM5464] (irq=POLL)
[   51.413710] sja1105 spi0.1 swp4 (uninitialized): PHY [mdio@2d24000:05] driver [Broadcom BCM5464] (irq=POLL)
[   51.424859] fsl-gianfar soc:ethernet@2d90000 eth2: Link is Up - 1Gbps/Full - flow control off
[   51.453768] sja1105 spi0.1: configuring for fixed/rgmii link mode
[   51.460094] device eth2 entered promiscuous mode
[   51.464856] DSA: tree 0 setup
[   51.477105] br0: port 3(swp2) entered blocking state
[   51.478394] sja1105 spi0.1: Link is Up - 1Gbps/Full - flow control off
[   51.482080] br0: port 3(swp2) entered disabled state
[   51.531585] device swp2 entered promiscuous mode
[   51.550365] sja1105 spi0.1 swp2: configuring for phy/rgmii-id link mode
[   51.559631] br0: port 4(swp5) entered blocking state
[   51.564597] br0: port 4(swp5) entered disabled state
[   51.586224] device swp5 entered promiscuous mode
[   51.647483] sja1105 spi0.1 swp5: configuring for phy/rgmii-id link mode
[   51.665995] br0: port 5(swp4) entered blocking state
[   51.671004] br0: port 5(swp4) entered disabled state
[   51.677991] device swp4 entered promiscuous mode
[   51.685967] br0: port 6(swp3) entered blocking state
[   51.690935] br0: port 6(swp3) entered disabled state
[   51.698246] device swp3 entered promiscuous mode
[   51.746640] sja1105 spi0.1 swp4: configuring for phy/rgmii-id link mode
[   51.754986] sja1105 spi0.1 swp3: configuring for phy/rgmii-id link mode
[   54.716225] sja1105 spi0.1 swp2: Link is Up - 1Gbps/Full - flow control off
[   54.723208] IPv6: ADDRCONF(NETDEV_CHANGE): swp2: link becomes ready
[   54.729620] br0: port 3(swp2) entered blocking state
[   54.734576] br0: port 3(swp2) entered forwarding state
[   54.796136] sja1105 spi0.1 swp5: Link is Up - 1Gbps/Full - flow control off
[   54.803117] IPv6: ADDRCONF(NETDEV_CHANGE): swp5: link becomes ready
[   54.809527] br0: port 4(swp5) entered blocking state
[   54.814484] br0: port 4(swp5) entered forwarding state
[   54.876397] sja1105 spi0.1 swp3: Link is Up - 1Gbps/Full - flow control off
[   54.883378] IPv6: ADDRCONF(NETDEV_CHANGE): swp3: link becomes ready
[   54.889790] br0: port 6(swp3) entered blocking state
[   54.894744] br0: port 6(swp3) entered forwarding state
# After
$ bridge link
7: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 4
8: eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
12: swp5@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 4
13: swp2@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 4
14: swp3@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 4
15: swp4@eth2: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100

The ports are ready to pass traffic, and are doing it.

So what does "wait for DSA to finish probing" mean? What driver, kernel
and systemd-networkd version is this, exactly, and what is it that needs
waiting?
