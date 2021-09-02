Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4DEF3FF48F
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 22:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243511AbhIBUEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 16:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhIBUEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 16:04:07 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C866EC061575;
        Thu,  2 Sep 2021 13:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HjCPobaicATTQhQvs0MFgxl93rLs6U0O7or7Fen91wA=; b=uqsMXDZaQHY+hAnQkNxWRvQq3
        K7o5qh8Z0AxzTtcdHTzhA7OgJdalCne+0doPhBBrOXfVIHhyNndMh82OQu8I1HdSW88a8V/Fw+XWz
        jIetSLLC3jC6v6QWY7v3J66ZVwq6p0WHxclG/I8+ifo+DTAMEnjUF1WESIAnAWc3PSbwEFmnlnWtL
        5Mu1YLsrpKy/7URjauscklPrpEXQJbTGaqUu50da8d79zHO7yReGwthKMC5rPV+vFP714EF/W+BHZ
        klxn+wdE+UdRxD8JYYJC2sKHrJZoGlklxmEzJGT4OqvArrPt5UucPj+unzmb9pwmyME6tuWqmkMfA
        dRzNeni1Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48108)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mLsvQ-0001xW-IY; Thu, 02 Sep 2021 21:03:04 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mLsvN-0008Ao-SB; Thu, 02 Sep 2021 21:03:01 +0100
Date:   Thu, 2 Sep 2021 21:03:01 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
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
Message-ID: <20210902200301.GM22278@shell.armlinux.org.uk>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210902121927.GE22278@shell.armlinux.org.uk>
 <20210902123532.ruvuecxoig67yv5v@skbuf>
 <20210902132635.GG22278@shell.armlinux.org.uk>
 <20210902152342.vett7qfhvhiyejvo@skbuf>
 <20210902163144.GH22278@shell.armlinux.org.uk>
 <20210902171033.4byfnu3g25ptnghg@skbuf>
 <20210902175043.GK22278@shell.armlinux.org.uk>
 <20210902190507.shcdmfi3v55l2zuj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210902190507.shcdmfi3v55l2zuj@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 10:05:07PM +0300, Vladimir Oltean wrote:
> On Thu, Sep 02, 2021 at 06:50:43PM +0100, Russell King (Oracle) wrote:
> > On Thu, Sep 02, 2021 at 05:10:34PM +0000, Vladimir Oltean wrote:
> > > On Thu, Sep 02, 2021 at 05:31:44PM +0100, Russell King (Oracle) wrote:
> > > > On Thu, Sep 02, 2021 at 06:23:42PM +0300, Vladimir Oltean wrote:
> > > > > On Thu, Sep 02, 2021 at 02:26:35PM +0100, Russell King (Oracle) wrote:
> > > > > > Debian has had support for configuring bridges at boot time via
> > > > > > the interfaces file for years. Breaking that is going to upset a
> > > > > > lot of people (me included) resulting in busted networks. It
> > > > > > would be a sure way to make oneself unpopular.
> > > > > >
> > > > > > > I expect there to be 2 call paths of phy_attach_direct:
> > > > > > > - At probe time. Both the MAC driver and the PHY driver are probing.
> > > > > > >   This is what has this patch addresses. There is no issue to return
> > > > > > >   -EPROBE_DEFER at that time, since drivers connect to the PHY before
> > > > > > >   they register their netdev. So if connecting defers, there is no
> > > > > > >   netdev to unregister, and user space knows nothing of this.
> > > > > > > - At .ndo_open time. This is where it maybe gets interesting, but not to
> > > > > > >   user space. If you open a netdev and it connects to the PHY then, I
> > > > > > >   wouldn't expect the PHY to be undergoing a probing process, all of
> > > > > > >   that should have been settled by then, should it not? Where it might
> > > > > > >   get interesting is with NFS root, and I admit I haven't tested that.
> > > > > >
> > > > > > I don't think you can make that assumption. Consider the case where
> > > > > > systemd is being used, DSA stuff is modular, and we're trying to
> > > > > > setup a bridge device on DSA. DSA could be probing while the bridge
> > > > > > is being setup.
> > > > > >
> > > > > > Sadly, this isn't theoretical. I've ended up needing:
> > > > > >
> > > > > > 	pre-up sleep 1
> > > > > >
> > > > > > in my bridge configuration to allow time for DSA to finish probing.
> > > > > > It's not a pleasant solution, nor a particularly reliable one at
> > > > > > that, but it currently works around the problem.
> > > > >
> > > > > What problem? This is the first time I've heard of this report, and you
> > > > > should definitely not need that.
> > > >
> > > > I found it when upgrading the Clearfog by the DSL modems to v5.13.
> > > > When I rebooted it with a previously working kernel (v5.7) it has
> > > > never had a problem. With v5.13, it failed to add all the lan ports
> > > > into the bridge, because the bridge was still being setup by the
> > > > kernel while userspace was trying to configure it. Note that I have
> > > > extra debug in my kernels, hence the extra messages:
> > >
> > > Ok, first you talked about the interfaces file, then systemd. If it's
> > > not about systemd's network manager then I don't see how it is relevant.
> >
> > You're reading in stuff to what I write that I did not write... I said:
> >
> > "Consider the case where systemd is being used, DSA stuff is modular,
> > and we're trying to setup a bridge device on DSA."
> >
> > That does not mean I'm using systemd's network manager - which is
> > something I know little about and have never used.
> 
> You should definitely try it out, it gets a lot of new features added
> all the time, it uses the netlink interface, it reacts on udev events.
> 
> > The reason I mentioned systemd is precisely because with systemd, you
> > get a hell of a lot happening parallel - and that's significiant in
> > this case, because it's very clear that modules are being loaded in
> > parallel with networking being brought up - and that is where the
> > problems begin. In fact, modules themselves get loaded in paralllel
> > with systemd.
> 
> So that's what I don't understand. You're saying that the ifupdown
> service runs in parallel with systemd-modules-load.service, and
> networking is a kernel module? Doesn't that mean it behaves as expected,
> then? /shrug/
> Have you tried adding an 'After=systemd-modules-load.service' dependency
> to the ifupdown service? I don't think that DSA is that bad that it
> registers its net devices outside of the process context in which the
> insmod mv88e6xxx.ko is called. Quite the opposite, I think (but I
> haven't actually taken a close look yet) that the component stuff
> Saravana is proposing would do exactly that. So you "fix" one issue, you
> introduce another.

# systemctl list-dependencies networking.service
networking.service
  ├─ifupdown-pre.service
  ├─system.slice
  └─network.target
# systemctl list-dependencies ifupdown-pre.service
ifupdown-pre.service
  ├─system.slice
  └─systemd-udevd.service

Looking in the service files for a better idea:

networking.service:
Requires=ifupdown-pre.service
Wants=network.target
After=local-fs.target network-pre.target apparmor.service systemd-sysctl.service systemd-modules-load.service ifupdown-pre.service
Before=network.target shutdown.target network-online.target

ifupdown-pre.service:
Wants=systemd-udevd.service
After=systemd-udev-trigger.service
Before=network.target

So, the dependency you mention is already present. As is a dependency
on udev. The problem is udev does all the automatic module loading
asynchronously and in a multithreaded way.

I don't think there's a way to make systemd wait for all module loads
to complete.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
