Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2B02040AA
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 21:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgFVTni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 15:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728050AbgFVTnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 15:43:37 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C52C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 12:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=FIIN60Ceos7nN9DZnNnFwnjHWuxAz4Y9Rtonw6hugOw=; b=CBg3DtqqQq6nJHmiEblF9yi7l
        BcxCFD6LW1iXqe3/flKl/Q7ntSR1NBKM665vzJxZeE8KsCyh9+J/A+makRl45SXruiC6itLRBtQp/
        dy4TqqvAZdCC7jJvYV8Ej8e5KQODirCIMT5adwBtOe8sr7s8ZC3jr+ZjHG1Kxi8qMbHi+l8UW6gzj
        SJn9se3ioFcOvW3WKBRolyGD5obePvuVegC3zpCRtj6vEFv2rN/LudG4/byj8zHksVPbXweO6xFg7
        B9qLkP4+RtQy6htoKXE0wXjVKGfi0tOetE9VM/7Zn+XclanvLcCNAQ3V84mEj7pjyYB3OpMYiN2yD
        b7wC6XuJA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58982)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jnSLu-0000nc-2y; Mon, 22 Jun 2020 20:43:34 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jnSLt-0000KZ-Il; Mon, 22 Jun 2020 20:43:33 +0100
Date:   Mon, 22 Jun 2020 20:43:33 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Daniel Mack <daniel@zonque.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com
Subject: Re: [PATCH] net: dsa: mv88e6xxx: Allow MAC configuration for ports
 with internal PHY
Message-ID: <20200622194333.GO1551@shell.armlinux.org.uk>
References: <20200622183443.3355240-1-daniel@zonque.org>
 <20200622184115.GE405672@lunn.ch>
 <b8a67f7d-9854-9854-3f53-983dd4eb8fda@zonque.org>
 <20200622185837.GN1551@shell.armlinux.org.uk>
 <bb89fbef-bde7-2a7f-9089-bbe86323dd63@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb89fbef-bde7-2a7f-9089-bbe86323dd63@zonque.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 09:16:59PM +0200, Daniel Mack wrote:
> Hi Russell,
> 
> On 6/22/20 8:58 PM, Russell King - ARM Linux admin wrote:
> > On Mon, Jun 22, 2020 at 08:44:51PM +0200, Daniel Mack wrote:
> >> On 6/22/20 8:41 PM, Andrew Lunn wrote:
> 
> >>> How are you trying to change the speed?
> >>
> >> With ethtool for instance. But all userspace tools are bailing out early
> >> on this port for the reason I described.
> > 
> > A simple "return" to ignore a call in a void function won't have that
> > effect.
> 
> It has the effect that mv88e6xxx_port_setup_mac() is currently not being
> called from mv88e6xxx_mac_config().

Which is correct.

> > I don't see an issue here:
> > 
> > # ethtool -s lan1 autoneg off speed 10 duplex half
> 
> I've tried that of course, but that doesn't fix the problem here. Which
> switch port does 'lan1' map to in your setup? My CPU port maps to port 4.

This is a clearfog, it maps to the port closest to the SFP port.

> Correct me if I'm mistaken, but speed and duplex settings are only being
> communicated to the MAC driver through the aforementioned chain of
> calls, right?

No, as I explained, the PPU (which is hardware inside the switch)
takes care of keeping the switch port in sync with the internal
PHY.

> > I've also been able to change what is advertised just fine, and the
> > link comes up as expected - in fact, I was running one of the switch
> > ports at 10Mbps to one of my machines and using the 'scope on the
> > ethernet signals over the weekend to debug a problem, which turned
> > out to be broken RGMII clock delay timings.
> 
> To recap, my setup features a Cadence GEM that is connected to a 88E1510
> PHY which is then connected to port 4 of the switch (which has an
> internal PHY) through a transformer-less link. I know this is not
> optimal as the speed is limited to 100M by that, but that was the only
> way as all other ports where used up.

So you have:

switch port <--> internal switch PHY <--> 88E1510 <--> Cadence GEM

and the switch will poll its internal PHY for the status of the link
between the two PHYs.  You should _not_ attach the 88E1510 to the
switch port - it is on the Cadence side of the link, and it should
be up to the Cadence end to manage that PHY, and not the switch side.

This is not much different than the inter-PHY transformer-less link
being a conventional RJ45 cable, except you want to operate the
switch port in "CPU" mode so that management frames are forwarded
out that link?

> The setup works just fine in principle, I'm just struggling with a
> correct way of configuring the drivers to allow that setting.

Right, so this is something new, and a setup we haven't seen before,
so likely it isn't supported.

I wonder if the PPU is being turned off by the fact that the port is
placed into "CPU" mode - I don't know off hand, I don't know the
Marvell DSA code all that well to be able to pull that knowledge out
of the top of my head, and I don't have time right now to read the
code to find out - I'm supposed to be on a Zoom meeting as of 15
minutes ago.

> I can control what is advertised on eth0, which is the GEM, and the PHY
> there reports the correct link speed:
> 
> 
> # ethtool -s eth0 advertise 0x008
> [   79.573992] macb e000b000.ethernet eth0: Link is Down
> [   79.637048] mv88e6085 e000b000.ethernet-ffffffff:02: Link is Down
> [   81.221974] macb e000b000.ethernet eth0: Link is Up - 100Mbps/Full -
> flow control off
> [   81.285639] mv88e6085 e000b000.ethernet-ffffffff:02: Link is Up -
> 100Mbps/Full - flow control off
> 
> However, the MAC in the switch is not changed by that, and it was forced
> to 1 Gbit at probe time of the driver. Hence no packets are being seen
> by the GEM, even though the PHYs seem to see each other just fine
> (traffic is also signaled by an LED on the 88E1510).
> 
> I'm happy to try other solutions of course.

I think this is going to be something that will need discussion with
the DSA folk, given that it's an entirely new setup that hasn't been
catered for.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
