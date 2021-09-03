Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C19E40055E
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 20:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351326AbhICSzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 14:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351317AbhICSzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 14:55:38 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 684C1C061575;
        Fri,  3 Sep 2021 11:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LDPyZjoZATgjIoK4fh0rqe2iVjJiFfhqid+X8wbi9L4=; b=SfWG3XvW1LPlQbkBl870Z0j8A
        IG/Gez70wjcdq+LkJf2jIwvtR0aVsVbOrSGu7FwboY+36PZglh3xUC33RUtvKjzrmSjX6NkCGKJKx
        oO2wg1rlJrPRwqaAkfNbYo3PZqrK7x+PnFqaSdkujHRTULW9O8pe0a+bvr2fhJeXtSXPoPTgorPVl
        V42AVLnZU4jwfKehXl06v8wex1pf5UNwcoEASjWdGSnsCBIEEWDbecfP6ra5yjm9hXbGfDwa30ZBk
        ZhzoScF8GmlPpXb38IPcyPdjKpoOG3NRk1KOVmBPHLJMcI2bXZPIBtEQcDFSK9cNjTqTmMGOX69IY
        m5UKHFj1A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48178)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mMEKi-0003R7-1C; Fri, 03 Sep 2021 19:54:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mMEKg-0000jL-UN; Fri, 03 Sep 2021 19:54:34 +0100
Date:   Fri, 3 Sep 2021 19:54:34 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/3] Make the PHY library stop being so
 greedy when binding the generic PHY driver
Message-ID: <20210903185434.GX22278@shell.armlinux.org.uk>
References: <20210902132635.GG22278@shell.armlinux.org.uk>
 <20210902152342.vett7qfhvhiyejvo@skbuf>
 <20210902163144.GH22278@shell.armlinux.org.uk>
 <20210902171033.4byfnu3g25ptnghg@skbuf>
 <20210902175043.GK22278@shell.armlinux.org.uk>
 <20210902190507.shcdmfi3v55l2zuj@skbuf>
 <20210902200301.GM22278@shell.armlinux.org.uk>
 <20210902202124.o5lcnukdzjkbft7l@skbuf>
 <20210902202905.GN22278@shell.armlinux.org.uk>
 <20210903162253.5utsa45zy6h4v76t@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210903162253.5utsa45zy6h4v76t@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 07:22:53PM +0300, Vladimir Oltean wrote:
> [ trimming the CC list, I'm sure most people don't care, if they do,
>   they can watch the mailing list ]
> 
> On Thu, Sep 02, 2021 at 09:29:05PM +0100, Russell King (Oracle) wrote:
> > On Thu, Sep 02, 2021 at 11:21:24PM +0300, Vladimir Oltean wrote:
> > > On Thu, Sep 02, 2021 at 09:03:01PM +0100, Russell King (Oracle) wrote:
> > > > # systemctl list-dependencies networking.service
> > > > networking.service
> > > >   ├─ifupdown-pre.service
> > > >   ├─system.slice
> > > >   └─network.target
> > > > # systemctl list-dependencies ifupdown-pre.service
> > > > ifupdown-pre.service
> > > >   ├─system.slice
> > > >   └─systemd-udevd.service
> > > > 
> > > > Looking in the service files for a better idea:
> > > > 
> > > > networking.service:
> > > > Requires=ifupdown-pre.service
> > > > Wants=network.target
> > > > After=local-fs.target network-pre.target apparmor.service systemd-sysctl.service systemd-modules-load.service ifupdown-pre.service
> > > > Before=network.target shutdown.target network-online.target
> > > > 
> > > > ifupdown-pre.service:
> > > > Wants=systemd-udevd.service
> > > > After=systemd-udev-trigger.service
> > > > Before=network.target
> > > > 
> > > > So, the dependency you mention is already present. As is a dependency
> > > > on udev. The problem is udev does all the automatic module loading
> > > > asynchronously and in a multithreaded way.
> > > > 
> > > > I don't think there's a way to make systemd wait for all module loads
> > > > to complete.
> > > 
> > > So ifupdown-pre.service has a call to "udevadm settle". This "watches
> > > the udev event queue, and exits if all current events are handled",
> > > according to the man page. But which current events? ifupdown-pre.service
> > > does not have the dependency on systemd-modules-load.service, just
> > > networking.service does. So maybe ifupdown-pre.service does not wait for
> > > DSA to finish initializing, then it tells networking.service that all is ok.
> > 
> > ifupdown-pre.service does have a call to udevadm settle, and that
> > does get called from what I can tell.
> > 
> > systemd-modules-load.service is an entire red herring. The only
> > module listed in the various modules-load.d directories is "tun"
> > for openvpn (which isn't currently being used.)
> > 
> > As I've already told you (and you seem to have ignored), DSA gets
> > loaded by udev, not by systemd-modules-load.service.
> > systemd-modules-load.service is irrelevant to my situation.
> > 
> > I think there's a problem with "and exits if all current events are
> > handled" - does that mean it's fired off a modprobe process which
> > is in progress, or does that mean that the modprobe process has
> > completed.
> > 
> > Given that we can see that ifup is being run while the DSA module is
> > still in the middle of probing, the latter interpretation can not be
> > true - unless systemd is ignoring the dependencies. Or just in
> > general, systemd being systemd (I have very little faith in systemd
> > behaving as it should.)
> 
> So I've set a fresh installation of Debian Buster on my Turris MOX,
> which has 3 mv88e6xxx switches, and I've put the mv88e6xxx driver inside
> the rootfs as a module to be loaded by udev based on modaliases just
> like you've said.  Additionally, the PHY driver is also a module.
> The kernel is built straight from the v5.13 tag, absolutely no changes.
> 
> Literally the only changes I've done to this system are:
> 1. install bridge-utils
> 2. create this file, it is sourced by /etc/network/interfaces:
> root@debian:~# cat /etc/network/interfaces.d/bridge
> auto br0
> iface br0 inet manual
>         bridge_ports lan1 lan2 lan3 lan4 lan5 lan6 lan7 lan8 lan9 lan10 lan11 lan12 lan13 lan14 lan15 lan16 lan17 lan18 lan19 lan20 lan21 lan22 lan23 lan24 sfp
>         bridge_maxwait 0
> 
> I've rebooted the board about 10 times and it has never skipped
> enslaving a port to the bridge.

What do you do about the host CPU interface, which needs to be up
before you can bring up any of the bridge ports?

What does the useful "systemd-analyse plot" show? It seems a useful
tool which I've only recently found to analyse what is going on at
boot.

I think I have an idea why it's happening here.

eno1 is connected to the switch. Because eno1 needs to be up first,
I did this:

# eno1: Switch uplink
auto eno1
allow-hotplug eno1
iface eno1 inet manual
	# custom hack to disable IPv6 addresses on this interface.
        ipv6-disable 1
        up ip link set $IFACE up
        up ifup --allow=$IFACE -a || :
        down ifdown --allow=$IFACE -a || :
        down ip link set $IFACE down

with:

allow-eno1 brdsl
iface brdsl inet manual
        bridge-ports lan2 lan3 lan4 lan5
        bridge-maxwait 0
        pre-up sleep 1
        up ip li set $IFACE type bridge vlan_filtering 1

The effect of that is the "allow-hotplug eno1" causes the systemd
unit ifup@eno1 to be triggered as soon as eno1 appears - this is
_before_ DSA has loaded. Once eno1 is up, that then triggers brdsl
to be configured - but DSA is still probing at that point.

I think removing the "allow-hotplug eno1" should move all that forward
to being started by networking.service, rather than all being triggered
by ifup@eno1. I haven't tested that yet though.

Sadly, this behaviour is not documented in the interfaces(5) man page.

Systemd is too complex, not well documented, it's interactions aren't
documented, it's too easy to non-obviously misconfigure, and it's
sometimes way too clever. In case it's not obvious - I absolutely hate
systemd.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
