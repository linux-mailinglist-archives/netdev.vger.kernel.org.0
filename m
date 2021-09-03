Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523CC400651
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 22:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350270AbhICUJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 16:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350037AbhICUJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 16:09:07 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BC9C061575;
        Fri,  3 Sep 2021 13:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZIOI/2yqLpItcJlSK/DcowYElmlHDPzT6/km/gTWj/M=; b=ZIVbpyKJbwva+DZJ4Qxivs457
        XuKNnD9/ZugcgzG1ahfmNpsgoAnzD+sBrIw89GdGpC5MFKCNgT9/86pqNUoyhI1Inb7HafV9k0NNA
        +PQ7SmrDSzMXhxDL6EFWVQxVGTkXs1zvelIA5kfza6U5cMt3bg/nxuOt0UvFdXhEH5uPlpJ38kd/g
        7NNaTGF7xBtXG7DHRIQlbiLoYfSc3ua9UWqLAqFjh1pvl69QYQ8LrrGvMs8PLoiYIPJ/d4hQMaC/v
        9dom7pGbTNP5SNErj83nkr61sf1xTErWQeLEJzayrWWOiKgv2EPCaUqUEEl/9WiGBsu+Q3nuF75O1
        OThvcTE0A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48184)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mMFTo-0003Xd-Te; Fri, 03 Sep 2021 21:08:04 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mMFTn-0000n0-T2; Fri, 03 Sep 2021 21:08:03 +0100
Date:   Fri, 3 Sep 2021 21:08:03 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/3] Make the PHY library stop being so
 greedy when binding the generic PHY driver
Message-ID: <20210903200803.GZ22278@shell.armlinux.org.uk>
References: <20210902171033.4byfnu3g25ptnghg@skbuf>
 <20210902175043.GK22278@shell.armlinux.org.uk>
 <20210902190507.shcdmfi3v55l2zuj@skbuf>
 <20210902200301.GM22278@shell.armlinux.org.uk>
 <20210902202124.o5lcnukdzjkbft7l@skbuf>
 <20210902202905.GN22278@shell.armlinux.org.uk>
 <20210903162253.5utsa45zy6h4v76t@skbuf>
 <YTJZj/Js+nmDTG0y@lunn.ch>
 <20210903185850.GY22278@shell.armlinux.org.uk>
 <YTJ90frD66C3mVga@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTJ90frD66C3mVga@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 09:56:01PM +0200, Andrew Lunn wrote:
> On Fri, Sep 03, 2021 at 07:58:50PM +0100, Russell King (Oracle) wrote:
> > On Fri, Sep 03, 2021 at 07:21:19PM +0200, Andrew Lunn wrote:
> > > Hi Russell
> > > 
> > > Do you have
> > > 
> > > auto brdsl
> > > 
> > > in your /etc/network/interfaces?
> > > 
> > > Looking at /lib/udev/bridge-network-interface it seems it will only do
> > > hotplug of interfaces if auto is set on the bridge interface. Without
> > > auto, it only does coldplug. So late appearing switch ports won't get
> > > added.
> > 
> > I think you're looking at this:
> > 
> > [ "$BRIDGE_HOTPLUG" = "no" ] && exit 0
> > 
> > ?
> 
> No, i was meaning this bit:
> 
>    for i in $(ifquery --list --allow auto); do
>         ports=$(ifquery $i | sed -n -e's/^bridge[_-]ports: //p')
> 
> Inside this is the actual adding of the interface to the bridge:
> 
>                                         brctl addif $i $port && ip link set dev $port up
> 
> 
> $ /sbin/ifquery --list --allow auto
> lo
> eth0
> br42
> 
> I have various tap interfaces for VMs which get added to br42 when
> they appear.

For the for loop to be reached, you needed to have set BRIDGE_HOTPLUG
to "yes" in /etc/default/bridge-utils, which otherwise defaults to "no"
and disables this script. So, to make that work you need to both
set BRIDGE_HOTPLUG=yes, and also set the bridge device to "auto" mode.

However, the danger with setting the bridge device to "auto" mode is
that then the CPU network device is not brought up before the bridge.
It's undocumented what order ifup -a processes the devices it finds
marked as "auto". I've been there in the past, which is why I ended
up with what I presently have.

I'm also wondering what the ordering is with bridge-network-interface
vs networking.service, and whether bridge-network-interface can run
before the bridge device has been created - in which case "brctl
addif" will fail and spit stuff on stderr... which isn't nice.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
