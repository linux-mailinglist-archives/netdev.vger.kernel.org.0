Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CB03FF2D5
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 19:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346606AbhIBRvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 13:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhIBRvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 13:51:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2C5C061575;
        Thu,  2 Sep 2021 10:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=OusQquGhwJGsRnBdFB4RXDtm+X461oQTZldrBYaJmXs=; b=P9t/99c9ogFwi3DZKNBYfrBwo
        MBpHeLw3zdE61KVasCF5h1NjVpPWISwKU+XGBdoj2gMB8NPGMB4j0o7bb5AhspU5qbmYWYJZZHkd3
        018i3V5sx/r/3TYHGBZRhGqw6kk3eYwjnrVi6mHIYmepUBiZP9BQQkFC6TaaGA060UNyP4VTVWDpU
        kP1Ixy/+ryks26OYhJvlx0yBRcPnnT7QHnQ1xu7EkJQ0862Y715oVLcfKo4EN3uLD66oVuoE46kVd
        MmD536pwmQ8Rug7z6+HPcFvQMVCsVwYlLPeB4D551a/ZrdsobrLD73SMiQkLQQ2UjKV+2yuA8S7b2
        aVCx/bw/w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48098)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mLqrO-0001o3-8d; Thu, 02 Sep 2021 18:50:46 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mLqrM-00084X-03; Thu, 02 Sep 2021 18:50:44 +0100
Date:   Thu, 2 Sep 2021 18:50:43 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 0/3] Make the PHY library stop being so
 greedy when binding the generic PHY driver
Message-ID: <20210902175043.GK22278@shell.armlinux.org.uk>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210902121927.GE22278@shell.armlinux.org.uk>
 <20210902123532.ruvuecxoig67yv5v@skbuf>
 <20210902132635.GG22278@shell.armlinux.org.uk>
 <20210902152342.vett7qfhvhiyejvo@skbuf>
 <20210902163144.GH22278@shell.armlinux.org.uk>
 <20210902171033.4byfnu3g25ptnghg@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902171033.4byfnu3g25ptnghg@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 05:10:34PM +0000, Vladimir Oltean wrote:
> On Thu, Sep 02, 2021 at 05:31:44PM +0100, Russell King (Oracle) wrote:
> > On Thu, Sep 02, 2021 at 06:23:42PM +0300, Vladimir Oltean wrote:
> > > On Thu, Sep 02, 2021 at 02:26:35PM +0100, Russell King (Oracle) wrote:
> > > > Debian has had support for configuring bridges at boot time via
> > > > the interfaces file for years. Breaking that is going to upset a
> > > > lot of people (me included) resulting in busted networks. It
> > > > would be a sure way to make oneself unpopular.
> > > >
> > > > > I expect there to be 2 call paths of phy_attach_direct:
> > > > > - At probe time. Both the MAC driver and the PHY driver are probing.
> > > > >   This is what has this patch addresses. There is no issue to return
> > > > >   -EPROBE_DEFER at that time, since drivers connect to the PHY before
> > > > >   they register their netdev. So if connecting defers, there is no
> > > > >   netdev to unregister, and user space knows nothing of this.
> > > > > - At .ndo_open time. This is where it maybe gets interesting, but not to
> > > > >   user space. If you open a netdev and it connects to the PHY then, I
> > > > >   wouldn't expect the PHY to be undergoing a probing process, all of
> > > > >   that should have been settled by then, should it not? Where it might
> > > > >   get interesting is with NFS root, and I admit I haven't tested that.
> > > >
> > > > I don't think you can make that assumption. Consider the case where
> > > > systemd is being used, DSA stuff is modular, and we're trying to
> > > > setup a bridge device on DSA. DSA could be probing while the bridge
> > > > is being setup.
> > > >
> > > > Sadly, this isn't theoretical. I've ended up needing:
> > > >
> > > > 	pre-up sleep 1
> > > >
> > > > in my bridge configuration to allow time for DSA to finish probing.
> > > > It's not a pleasant solution, nor a particularly reliable one at
> > > > that, but it currently works around the problem.
> > > 
> > > What problem? This is the first time I've heard of this report, and you
> > > should definitely not need that.
> > 
> > I found it when upgrading the Clearfog by the DSL modems to v5.13.
> > When I rebooted it with a previously working kernel (v5.7) it has
> > never had a problem. With v5.13, it failed to add all the lan ports
> > into the bridge, because the bridge was still being setup by the
> > kernel while userspace was trying to configure it. Note that I have
> > extra debug in my kernels, hence the extra messages:
> 
> Ok, first you talked about the interfaces file, then systemd. If it's
> not about systemd's network manager then I don't see how it is relevant.

You're reading in stuff to what I write that I did not write... I said:

"Consider the case where systemd is being used, DSA stuff is modular,
and we're trying to setup a bridge device on DSA."

That does not mean I'm using systemd's network manager - which is
something I know little about and have never used.

The reason I mentioned systemd is precisely because with systemd, you
get a hell of a lot happening parallel - and that's significiant in
this case, because it's very clear that modules are being loaded in
parallel with networking being brought up - and that is where the
problems begin. In fact, modules themselves get loaded in paralllel
with systemd.

> What package and version is this exactly, ifupdown, ifupdown2,
> ifupdown-ng, busybox ifupdown? I think they all use the interfaces file.

It's a standard uptodate debian oldstable (buster) install, not yet
upgraded to bullseye:

ifupdown 0.8.35
bridge-utils 1.6-2

> > We get the link to eno1 going down/up due to DSA's actions:
> 
> What "actions"? There were only 2 DSA changes related to the state of
> the master interface, but DSA never forces the master to go down. Quite
> the opposite, it forces the master up when it needs to, and it goes down
> when the master goes down. See:
> 
> 9d5ef190e561 ("net: dsa: automatically bring up DSA master when opening user port")
> c0a8a9c27493 ("net: dsa: automatically bring user ports down when master goes down")

mv88e6xxx will temporarily force the link down while the port is
being configured if one asks it to operate in in-band mode (which
I have.)

> So if eno1 goes down and that causes breakage, DSA did not trigger it.
> Also, please note that eno1 goes down in your "working" example too.

I'm not complaining about this. It's a non-problem. It does however
serve as an indication where we are through the bring-up.

> > Aug 30 11:29:53 sw-dsl kernel: [    4.291882] mvneta f1030000.ethernet eno1: Link is Down
> > Aug 30 11:29:53 sw-dsl kernel: [    4.309425] mvneta f1030000.ethernet eno1: mac link down
> > Aug 30 11:29:53 sw-dsl kernel: [    4.309425] mvneta f1030000.ethernet eno1: mac link down
> > Aug 30 11:29:53 sw-dsl kernel: [    4.309440] mvneta f1030000.ethernet eno1: configuring for inband/1000base-x link mode
> > Aug 30 11:29:53 sw-dsl kernel: [    4.309447] mvneta f1030000.ethernet eno1: major config 1000base-x
> > Aug 30 11:29:53 sw-dsl kernel: [    4.309454] mvneta f1030000.ethernet eno1: phylink_mac_config: mode=inband/1000base-x/Unknown/Unknown adv=0000000,00000200,00002240 pause=04 link=0 an=1
> > Aug 30 11:29:53 sw-dsl kernel: [    4.345013] mvneta f1030000.ethernet eno1: mac link up
> > Aug 30 11:29:53 sw-dsl kernel: [    4.345014] mvneta f1030000.ethernet eno1: mac link up
> > Aug 30 11:29:53 sw-dsl kernel: [    4.345036] mvneta f1030000.ethernet eno1: Link is Up - 1Gbps/Full - flow control rx/tx
> > 
> > DSA then starts initialising the ports:
> > 
> > Aug 30 11:29:53 sw-dsl kernel: [    4.397647] mv88e6085 f1072004.mdio-mii:04 lan5 (uninitialized): PHY [mv88e6xxx-0:00] driver [Marvell 88E1540] (irq=75)
> > Aug 30 11:29:53 sw-dsl kernel: [    4.397663] mv88e6085 f1072004.mdio-mii:04 lan5 (uninitialized): phy: setting supported 0000000,00000000,000022ef advertising
> > 0000000,00000000,000022ef
> > Aug 30 11:29:53 sw-dsl kernel: [    4.493080] mv88e6085 f1072004.mdio-mii:04 lan4 (uninitialized): PHY [mv88e6xxx-0:01] driver [Marvell 88E1540] (irq=76)
> > Aug 30 11:29:53 sw-dsl kernel: [    4.493093] mv88e6085 f1072004.mdio-mii:04 lan4 (uninitialized): phy: setting supported 0000000,00000000,000022ef advertising
> > 0000000,00000000,000022ef
> > Aug 30 11:29:53 sw-dsl kernel: [    4.577070] mv88e6085 f1072004.mdio-mii:04 lan3 (uninitialized): PHY [mv88e6xxx-0:02] driver [Marvell 88E1540] (irq=77)
> > Aug 30 11:29:53 sw-dsl kernel: [    4.577081] mv88e6085 f1072004.mdio-mii:04 lan3 (uninitialized): phy: setting supported 0000000,00000000,000022ef advertising
> > 0000000,00000000,000022ef
> > 
> > Meanwhile userspace is trying to setup the bridge while this is going
> > on, and has tried to add the non-existent lan2 at this point, but
> > lan4 has just been created in time, so Debian's bridge support adds
> > it to the brdsl bridge:
> > 
> > Aug 30 11:29:53 sw-dsl kernel: [    4.652237] brdsl: port 1(lan4) entered blocking state
> > Aug 30 11:29:53 sw-dsl kernel: [    4.652250] brdsl: port 1(lan4) entered disabled state
> > 
> > DSA continues setting up the other ports, here lan2, but the bridge
> > setup scripts have already moved on past lan2.
> 
> How does this program know that lan2 exists before it starts attempting
> to enslave it to a bridge via the brctl program, and what does DSA do to
> violate that assumption?

This is the whole point I'm trying to get across to you - these are
_scripts_. They aren't some fancy program that runs in the background.
They assume that the interfaces are already there - as can be seen
from my v5.7 log, they are. With v5.13, they aren't because stuff starts
coming up while DSA is still initialising.

> > Aug 30 11:29:53 sw-dsl kernel: [    4.674038] mv88e6085 f1072004.mdio-mii:04 lan2 (uninitialized): PHY [mv88e6xxx-0:03] driver [Marvell 88E1540] (irq=78)
> > Aug 30 11:29:53 sw-dsl kernel: [    4.674052] mv88e6085 f1072004.mdio-mii:04 lan2 (uninitialized): phy: setting supported 0000000,00000000,000022ef advertising
> > 0000000,00000000,000022ef
> > Aug 30 11:29:53 sw-dsl kernel: [    4.674612] device lan4 entered promiscuous mode
> > Aug 30 11:29:53 sw-dsl kernel: [    4.785886] device eno1 entered promiscuous mode
> > Aug 30 11:29:53 sw-dsl kernel: [    4.786971] mv88e6085 f1072004.mdio-mii:04 lan4: configuring for phy/gmii link mode
> > Aug 30 11:29:53 sw-dsl kernel: [    4.786980] mv88e6085 f1072004.mdio-mii:04 lan4: major config gmii
> > Aug 30 11:29:53 sw-dsl kernel: [    4.786986] mv88e6085 f1072004.mdio-mii:04 lan4: phylink_mac_config: mode=phy/gmii/Unknown/Unknown adv=0000000,00000000,00000000 pause=00 link=0 an=0
> > Aug 30 11:29:53 sw-dsl kernel: [    4.786996] mv88e6085 f1072004.mdio-mii:04: p1: dsa_port_phylink_mac_config()
> > Aug 30 11:29:53 sw-dsl kernel: [    4.789977] 8021q: adding VLAN 0 to HW filter
> > on device lan4
> > Aug 30 11:29:53 sw-dsl kernel: [    4.836720] brdsl: port 2(eno2) entered blocking state
> > Aug 30 11:29:53 sw-dsl kernel: [    4.836733] brdsl: port 2(eno2) entered disabled state
> > 
> > Here, the SFP port (on eno2) is added to the bridge.
> > 
> > Aug 30 11:29:53 sw-dsl kernel: [    4.836907] device eno2 entered promiscuous mode
> > Aug 30 11:29:53 sw-dsl kernel: [    4.837011] brdsl: port 2(eno2) entered blocking state
> > Aug 30 11:29:53 sw-dsl kernel: [    4.837019] brdsl: port 2(eno2) entered forwarding state
> > Aug 30 11:29:53 sw-dsl kernel: [    4.837058] IPv6: ADDRCONF(NETDEV_CHANGE): brdsl: link becomes ready
> > Aug 30 11:29:53 sw-dsl kernel: [    4.846989] mv88e6085 f1072004.mdio-mii:04 lan4: phy link down gmii/Unknown/Unknown/off
> > Aug 30 11:29:53 sw-dsl kernel: [    4.896264] mv88e6085 f1072004.mdio-mii:04 lan1 (uninitialized): PHY [mv88e6xxx-0:04] driver [Marvell 88E1540] (irq=79)
> > Aug 30 11:29:53 sw-dsl kernel: [    4.896278] mv88e6085 f1072004.mdio-mii:04 lan1 (uninitialized): phy: setting supported 0000000,00000000,000022ef advertising
> > 0000000,00000000,000022ef
> > Aug 30 11:29:53 sw-dsl kernel: [    4.934514] DSA: tree 0 setup
> > 
> > Here, the DSA tree has finally finished initialising in the kernel.
> > 
> > Aug 30 11:29:53 sw-dsl kernel: [    4.986877] mv88e6085 f1072004.mdio-mii:04 lan1: configuring for phy/gmii link mode
> > Aug 30 11:29:53 sw-dsl kernel: [    4.986890] mv88e6085 f1072004.mdio-mii:04 lan1: major config gmii
> > Aug 30 11:29:53 sw-dsl kernel: [    4.986896] mv88e6085 f1072004.mdio-mii:04 lan1: phylink_mac_config: mode=phy/gmii/Unknown/Unknown adv=0000000,00000000,00000000 pause=00 link=0 an=0
> > Aug 30 11:29:53 sw-dsl kernel: [    4.986907] mv88e6085 f1072004.mdio-mii:04: p4: dsa_port_phylink_mac_config()
> > Aug 30 11:29:53 sw-dsl kernel: [    4.990199] 8021q: adding VLAN 0 to HW filter
> > on device lan1
> > Aug 30 11:29:54 sw-dsl kernel: [    5.041313] mv88e6085 f1072004.mdio-mii:04 lan1: phy link down gmii/Unknown/Unknown/off
> > Aug 30 11:29:56 sw-dsl kernel: [    7.630016] mv88e6085 f1072004.mdio-mii:04 lan4: phy link up gmii/1Gbps/Full/off
> > Aug 30 11:29:56 sw-dsl kernel: [    7.630031] mv88e6085 f1072004.mdio-mii:04 lan4: phylink_mac_config: mode=phy/gmii/1Gbps/Full adv=0000000,00000000,00000000 pause=00 link=1 an=0
> > Aug 30 11:29:56 sw-dsl kernel: [    7.630043] mv88e6085 f1072004.mdio-mii:04: p1: dsa_port_phylink_mac_config()
> > Aug 30 11:29:56 sw-dsl kernel: [    7.630294] mv88e6085 f1072004.mdio-mii:04 lan4: Link is Up - 1Gbps/Full - flow control off
> > Aug 30 11:29:56 sw-dsl kernel: [    7.630312] brdsl: port 1(lan4) entered blocking state
> > Aug 30 11:29:56 sw-dsl kernel: [    7.630321] brdsl: port 1(lan4) entered forwarding state
> > 
> > I then notice that my Internet connection hasn't come back, so I start
> > poking about with it, first adding it to the bridge:
> > 
> > Aug 30 11:31:13 sw-dsl kernel: [   84.990122] brdsl: port 3(lan2) entered blocking state
> > Aug 30 11:31:13 sw-dsl kernel: [   84.990134] brdsl: port 3(lan2) entered disabled state
> > Aug 30 11:31:14 sw-dsl kernel: [   85.063971] device lan2 entered promiscuous mode
> > 
> > And then setting it to up state and configuring its vlan settings:
> > 
> > Aug 30 11:32:45 sw-dsl kernel: [  176.476090] mv88e6085 f1072004.mdio-mii:04 lan2: configuring for phy/gmii link mode
> > Aug 30 11:32:45 sw-dsl kernel: [  176.476103] mv88e6085 f1072004.mdio-mii:04 lan2: major config gmii
> > Aug 30 11:32:45 sw-dsl kernel: [  176.476109] mv88e6085 f1072004.mdio-mii:04 lan2: phylink_mac_config: mode=phy/gmii/Unknown/Unknown adv=0000000,00000000,00000000 pause=00 link=0 an=0
> > Aug 30 11:32:45 sw-dsl kernel: [  176.476120] mv88e6085 f1072004.mdio-mii:04: p3: dsa_port_phylink_mac_config()
> > Aug 30 11:32:45 sw-dsl kernel: [  176.479495] 8021q: adding VLAN 0 to HW filter
> > on device lan2
> > Aug 30 11:32:45 sw-dsl kernel: [  176.537796] mv88e6085 f1072004.mdio-mii:04 lan2: phy link down gmii/Unknown/Unknown/off
> > Aug 30 11:32:48 sw-dsl kernel: [  179.280863] mv88e6085 f1072004.mdio-mii:04 lan2: phy link up gmii/1Gbps/Full/rx/tx
> > Aug 30 11:32:48 sw-dsl kernel: [  179.280877] mv88e6085 f1072004.mdio-mii:04 lan2: phylink_mac_config: mode=phy/gmii/1Gbps/Full adv=0000000,00000000,00000000 pause=03 link=1 an=0
> > Aug 30 11:32:48 sw-dsl kernel: [  179.280888] mv88e6085 f1072004.mdio-mii:04: p3: dsa_port_phylink_mac_config()
> > Aug 30 11:32:48 sw-dsl kernel: [  179.280894] mv88e6085 f1072004.mdio-mii:04: p3: dsa_port_phylink_mac_link_up()
> > Aug 30 11:32:48 sw-dsl kernel: [  179.282958] mv88e6085 f1072004.mdio-mii:04 lan2: Link is Up - 1Gbps/Full - flow control rx/tx
> > 
> > I had:
> > 
> > iface brdsl inet manual
> >         bridge-ports lan2 lan4
> >         bridge-maxwait 0
> > 	up brctl addif $IFACE eno2
> > 
> > I now have:
> > iface brdsl inet manual
> >         bridge-ports lan2 lan4
> >         bridge-waitport 10
> >         bridge-maxwait 0
> >         pre-up sleep 1
> > 	up brctl addif $IFACE eno2
> 
> I searched google for the "bridge-ports" keyword relative to ifupdown
> and could not find the source code of a program which parses this. Could
> you let me know what is the source code of the program you are using?

It's a script, see the debian bridge-utils package:
/lib/bridge-utils/ifupdown.sh

Also see the ifup man page - ifup converts much of the interfaces
file into environment variables for called hook scripts in
/etc/network/*.d to make use of. So e.g. bridge-ports becomes
$IF_BRIDGE_PORTS etc.

Debian has been using this method since probably shortly after
bridge support was introduced - it's been around for a very long
time.

> > to ensure that all ports get properly configured.
> > 
> > What can be seen from the above is that there is most definitely a race.
> > It is possible to start configuring a DSA switch before the DSA switch
> > driver has finished being probed by the kernel.
> > 
> > Here is the kernel log from v5.7 which has never showed these problems,
> > because DSA seemed to always setup everything in kernel space prior to
> > userspace beginning configuration:
> > 
> > Aug 25 23:03:54 sw-dsl kernel: [    5.793137] mvneta f1030000.ethernet eno1: configuring for inband/1000base-x link mode
> > Aug 25 23:03:54 sw-dsl kernel: [    5.793148] mvneta f1030000.ethernet eno1: config interface 1000base-x
> > Aug 25 23:03:54 sw-dsl kernel: [    5.793157] mvneta f1030000.ethernet eno1: phylink_mac_config: mode=inband/1000base-x/Unknown/Unknown adv=000,00000200,00002240 pause=04 link=0 an=1
> > Aug 25 23:03:54 sw-dsl kernel: [    5.793168] mvneta f1030000.ethernet eno1: mac link down
> > Aug 25 23:03:54 sw-dsl kernel: [    5.793170] mvneta f1030000.ethernet eno1: mac link down
> > Aug 25 23:03:54 sw-dsl kernel: [    5.819769] mvneta f1030000.ethernet eno1: mac link up
> > Aug 25 23:03:54 sw-dsl kernel: [    5.819792] mvneta f1030000.ethernet eno1: Link is Up - 1Gbps/Full - flow control rx/tx
> > Aug 25 23:03:54 sw-dsl kernel: [    5.948900] 8021q: 802.1Q VLAN Support v1.8
> >   6.459779] mv88e6085 f1072004.mdio-mii:04: nonfatal error -95 setting MTU on port 0
> > Aug 25 23:03:54 sw-dsl kernel: [    6.462890] mv88e6085 f1072004.mdio-mii:04 lan5 (uninitialized): PHY [mv88e6xxx-0:00] driver [Marvell 88E1540] (irq=67)
> > Aug 25 23:03:54 sw-dsl kernel: [    6.462905] mv88e6085 f1072004.mdio-mii:04 lan5 (uninitialized): phy: setting supported 000,00000000,000022ef advertising 000,00000000,000022ef
> > Aug 25 23:03:54 sw-dsl kernel: [    6.465904] mv88e6085 f1072004.mdio-mii:04: nonfatal error -95 setting MTU on port 1
> > Aug 25 23:03:54 sw-dsl kernel: [    6.468101] mv88e6085 f1072004.mdio-mii:04 lan4 (uninitialized): PHY [mv88e6xxx-0:01] driver [Marvell 88E1540] (irq=68)
> > Aug 25 23:03:54 sw-dsl kernel: [    6.468109] mv88e6085 f1072004.mdio-mii:04 lan4 (uninitialized): phy: setting supported 000,00000000,000022ef advertising 000,00000000,000022ef
> > Aug 25 23:03:54 sw-dsl kernel: [    6.472162] mv88e6085 f1072004.mdio-mii:04: nonfatal error -95 setting MTU on port 2
> > Aug 25 23:03:54 sw-dsl kernel: [    6.474247] mv88e6085 f1072004.mdio-mii:04 lan3 (uninitialized): PHY [mv88e6xxx-0:02] driver [Marvell 88E1540] (irq=69)
> > Aug 25 23:03:54 sw-dsl kernel: [    6.474261] mv88e6085 f1072004.mdio-mii:04 lan3 (uninitialized): phy: setting supported 000,00000000,000022ef advertising 000,00000000,000022ef
> > Aug 25 23:03:54 sw-dsl kernel: [    6.481824] mv88e6085 f1072004.mdio-mii:04: nonfatal error -95 setting MTU on port 3
> > Aug 25 23:03:54 sw-dsl kernel: [    6.486354] mv88e6085 f1072004.mdio-mii:04 lan2 (uninitialized): PHY [mv88e6xxx-0:03] driver [Marvell 88E1540] (irq=70)
> > Aug 25 23:03:54 sw-dsl kernel: [    6.486363] mv88e6085 f1072004.mdio-mii:04 lan2 (uninitialized): phy: setting supported 000,00000000,000022ef advertising 000,00000000,000022ef
> > Aug 25 23:03:54 sw-dsl kernel: [    6.498494] mv88e6085 f1072004.mdio-mii:04: nonfatal error -95 setting MTU on port 4
> > Aug 25 23:03:54 sw-dsl kernel: [    6.502272] mv88e6085 f1072004.mdio-mii:04 lan1 (uninitialized): PHY [mv88e6xxx-0:04] driver [Marvell 88E1540] (irq=71)
> > Aug 25 23:03:54 sw-dsl kernel: [    6.502279] mv88e6085 f1072004.mdio-mii:04 lan1 (uninitialized): phy: setting supported 000,00000000,000022ef advertising 000,00000000,000022ef
> > Aug 25 23:03:54 sw-dsl kernel: [    6.532258] mv88e6085 f1072004.mdio-mii:04: nonfatal error -95 setting MTU on port 6
> > Aug 25 23:03:54 sw-dsl kernel: [    6.535877] mvneta f1030000.ethernet eno1: Link is Down
> > Aug 25 23:03:54 sw-dsl kernel: [    6.541733] mvneta f1030000.ethernet eno1: configuring for inband/1000base-x link mode
> > Aug 25 23:03:54 sw-dsl kernel: [    6.541741] mvneta f1030000.ethernet eno1: config interface 1000base-x
> > Aug 25 23:03:54 sw-dsl kernel: [    6.541754] mvneta f1030000.ethernet eno1: phylink_mac_config: mode=inband/1000base-x/Unknown/Unknown adv=000,00000200,00002240 pause=04 link=0 an=1
> > Aug 25 23:03:54 sw-dsl kernel: [    6.541771] mvneta f1030000.ethernet eno1: mac link down
> > Aug 25 23:03:54 sw-dsl kernel: [    6.541779] mvneta f1030000.ethernet eno1: mac link down
> > Aug 25 23:03:54 sw-dsl kernel: [    6.541907] DSA: tree 0 setup
> > 
> > Here, the kernel DSA switch driver has finished doing its setup
> > before we even get to configuring the bridge device below.
> > 
> > Aug 25 23:03:54 sw-dsl kernel: [    6.569105] mvneta f1030000.ethernet eno1: mac link up
> > Aug 25 23:03:54 sw-dsl kernel: [    6.569113] mvneta f1030000.ethernet eno1: mac link up
> > Aug 25 23:03:54 sw-dsl kernel: [    6.569139] mvneta f1030000.ethernet eno1: Link is Up - 1Gbps/Full - flow control rx/tx
> > Aug 25 23:03:55 sw-dsl kernel: [    6.931763] brdsl: port 1(lan2) entered blocking state
> > Aug 25 23:03:55 sw-dsl kernel: [    6.931769] brdsl: port 1(lan2) entered disabled state
> > Aug 25 23:03:55 sw-dsl kernel: [    6.932863] device lan2 entered promiscuous mode
> > Aug 25 23:03:55 sw-dsl kernel: [    7.032838] device eno1 entered promiscuous mode
> > Aug 25 23:03:55 sw-dsl kernel: [    7.032902] mv88e6085 f1072004.mdio-mii:04 lan2: configuring for phy/gmii link mode
> > Aug 25 23:03:55 sw-dsl kernel: [    7.032907] mv88e6085 f1072004.mdio-mii:04 lan2: config interface gmii
> > Aug 25 23:03:55 sw-dsl kernel: [    7.032916] mv88e6085 f1072004.mdio-mii:04 lan2: phylink_mac_config: mode=phy/gmii/Unknown/Unknown adv=000,00000000,00000000 pause=00 link=0 an=0
> > Aug 25 23:03:55 sw-dsl kernel: [    7.032920] mv88e6085 f1072004.mdio-mii:04: p3: dsa_port_phylink_mac_config()
> > Aug 25 23:03:55 sw-dsl kernel: [    7.037225] 8021q: adding VLAN 0 to HW filter
> > on device lan2
> > Aug 25 23:03:55 sw-dsl kernel: [    7.044979] brdsl: port 2(lan4) entered blocking state
> > Aug 25 23:03:55 sw-dsl kernel: [    7.044985] brdsl: port 2(lan4) entered disabled state
> > Aug 25 23:03:55 sw-dsl kernel: [    7.056189] device lan4 entered promiscuous mode
> > Aug 25 23:03:55 sw-dsl kernel: [    7.107067] mv88e6085 f1072004.mdio-mii:04 lan4: configuring for phy/gmii link mode
> > Aug 25 23:03:55 sw-dsl kernel: [    7.107073] mv88e6085 f1072004.mdio-mii:04 lan4: config interface gmii
> > Aug 25 23:03:55 sw-dsl kernel: [    7.107080] mv88e6085 f1072004.mdio-mii:04 lan4: phylink_mac_config: mode=phy/gmii/Unknown/Unknown adv=000,00000000,00000000 pause=00 link=0 an=0
> > Aug 25 23:03:55 sw-dsl kernel: [    7.107084] mv88e6085 f1072004.mdio-mii:04: p1: dsa_port_phylink_mac_config()
> > Aug 25 23:03:55 sw-dsl kernel: [    7.118831] 8021q: adding VLAN 0 to HW filter
> > on device lan4
> > Aug 25 23:03:55 sw-dsl kernel: [    7.153604] brdsl: port 3(eno2) entered blocking state
> > Aug 25 23:03:55 sw-dsl kernel: [    7.153610] brdsl: port 3(eno2) entered disabled state
> > Aug 25 23:03:55 sw-dsl kernel: [    7.153720] mv88e6085 f1072004.mdio-mii:04 lan2: phy link down gmii/Unknown/Unknown/off
> > Aug 25 23:03:55 sw-dsl kernel: [    7.153790] device eno2 entered promiscuous mode
> > Aug 25 23:03:55 sw-dsl kernel: [    7.153890] brdsl: port 3(eno2) entered blocking state
> > Aug 25 23:03:55 sw-dsl kernel: [    7.153895] brdsl: port 3(eno2) entered forwarding state
> > Aug 25 23:03:55 sw-dsl kernel: [    7.153930] IPv6: ADDRCONF(NETDEV_CHANGE): brdsl: link becomes ready
> > Aug 25 23:03:55 sw-dsl kernel: [    7.295739] mv88e6085 f1072004.mdio-mii:04 lan4: phy link down gmii/Unknown/Unknown/off
> > Aug 25 23:03:55 sw-dsl kernel: [    7.575615] mv88e6085 f1072004.mdio-mii:04 lan1: configuring for phy/gmii link mode
> > Aug 25 23:03:55 sw-dsl kernel: [    7.575622] mv88e6085 f1072004.mdio-mii:04 lan1: config interface gmii
> > Aug 25 23:03:55 sw-dsl kernel: [    7.575630] mv88e6085 f1072004.mdio-mii:04 lan1: phylink_mac_config: mode=phy/gmii/Unknown/Unknown adv=000,00000000,00000000 pause=00 link=0 an=0
> > Aug 25 23:03:55 sw-dsl kernel: [    7.575634] mv88e6085 f1072004.mdio-mii:04: p4: dsa_port_phylink_mac_config()
> > Aug 25 23:03:55 sw-dsl kernel: [    7.579334] 8021q: adding VLAN 0 to HW filter
> > on device lan1
> > Aug 25 23:03:55 sw-dsl kernel: [    7.635966] mv88e6085 f1072004.mdio-mii:04 lan1: phy link down gmii/Unknown/Unknown/off
> > 
> > -- 
> > RMK's Patch system: https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.armlinux.org.uk%2Fdeveloper%2Fpatches%2F&amp;data=04%7C01%7Cvladimir.oltean%40nxp.com%7C4226a7652ae7497284df08d96e2f29e4%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637661971114812881%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=6hDf%2FS%2FMnpRhzEYuW14zuaEAcaTgdMsQJPpmR9WA5cI%3D&amp;reserved=0
> > FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
