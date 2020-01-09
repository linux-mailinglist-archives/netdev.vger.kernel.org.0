Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19AEB1363A5
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 00:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbgAIXKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 18:10:39 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:60088 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgAIXKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 18:10:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jtDiWHHllC8OGNwI0jm1R8SllToFHT0s+I/jIG7Mmu0=; b=ir8vhWZ/jloFfuHK4UuJmdYuQ
        BpIO2FiEtOeAz+9b6rvQTlpQ0mFUpxWDeaA8GZt322+yHycm3phJBXVthHC/eySB7ol7ai3tKyh2K
        ZFMr1ncUismUs/3uF8gZT4rqfloF7/oD7qiCLuGUW+UVuOJJ7oXNeINvmRws2w0nryRvKelfibHH4
        rnpk9YAS4wgPwPYX8ZKnBhMEy8D2DHZ32uPfqcgiFh9BV2vwwCmOQBOgf6t/zvolTdxGKFUUit+AN
        AEHCYZLh+5Rlv0GZmSQcRb70rLYj/TIj+4AuW4VVdLXsqOINuRb6zsrTIuTkpd9IFWDdGqO8MPuxZ
        gW98YIcMg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:52822)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ipgwl-0007rn-58; Thu, 09 Jan 2020 23:10:35 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ipgwk-0000tY-Bx; Thu, 09 Jan 2020 23:10:34 +0000
Date:   Thu, 9 Jan 2020 23:10:34 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?utf-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
Message-ID: <20200109231034.GW25745@shell.armlinux.org.uk>
References: <d8d595ff-ec35-3426-ec43-9afd67c15e3d@gmx.net>
 <20200109144106.GA24459@lunn.ch>
 <513d6fe7-65b2-733b-1d17-b3a40b8161cf@gmx.net>
 <20200109155809.GQ25745@shell.armlinux.org.uk>
 <bb2c2eed-5efa-00f6-0e52-1326669c1b0d@gmx.net>
 <20200109174322.GR25745@shell.armlinux.org.uk>
 <acd4d7e4-7f8e-d578-c9c9-b45f062f4fe2@gmx.net>
 <7ebee7c5-4bf3-134d-bc57-ea71e0bdfc60@gmx.net>
 <20200109215903.GV25745@shell.armlinux.org.uk>
 <c7b4bec1-3f1f-8a34-cf22-8fb1f68914f3@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c7b4bec1-3f1f-8a34-cf22-8fb1f68914f3@gmx.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 09, 2020 at 10:40:24PM +0000, ѽ҉ᶬḳ℠ wrote:
> 
> On 09/01/2020 21:59, Russell King - ARM Linux admin wrote:
> > 
> > Also, note that the Metanoia MT-V5311 (at least mine) uses 1000BASE-X
> > not SGMII. It sends a 16-bit configuration word of 0x61a0, which is:
> > 
> > 		1000BASE-X			SGMII
> > Bit 15	0	No next page			Link down
> > 	1	Ack				Ack
> > 	1	Remote fault 2			Reserved (0)
> > 	0	Remote fault 1			Duplex (0 = Half)
> > 
> > 	0	Reserved (0)			Speed bit 1
> > 	0	Reserved (0)			Speed bit 0 (00=10Mbps)
> > 	0	Reserved (0)			Reserved (0)
> > 	1	Asymetric pause direction	Reserved (0)
> > 
> > 	1	Pause				Reserved (0)
> > 	0	Half duplex not supported	Reserved (0)
> > 	1	Full duplex supported		Reserved (0)
> > 	0	Reserved (0)			Reserved (0)
> > 
> > 	0	Reserved (0)			Reserved (0)
> > 	0	Reserved (0)			Reserved (0)
> > 	0	Reserved (0)			Reserved (0)
> > Bit 0	0	Reserved (0)			Must be 1
> > 
> > So it clearly fits 802.3 Clause 37 1000BASE-X format, reporting 1G
> > Full duplex, and not SGMII (10M Half duplex).
> > 
> > I have a platform here that allows me to get at the raw config_reg
> > word that the other end has sent which allows analysis as per the
> > above.
> > 
> 
> The driver reports also 1000base-x for this Metonia/Allnet module:
> 
> mvneta f1034000.ethernet eth2: switched to inband/1000base-x link mode
> 
> mii-tool -v eth2 producing
> 
> eth2: 1000 Mbit, full duplex, link ok
>   product info: vendor 00:00:00, model 0 rev 0
>   basic mode:   10 Mbit, full duplex
>   basic status: autonegotiation complete, link ok
>   capabilities:
>   advertising:  1000baseT-HD 1000baseT-FD 100baseT4 100baseTx-FD
> 100baseTx-HD 10baseT-FD 10baseT-HD flow-control

Please don't use mii-tool with SFPs that do not have a PHY; the "PHY"
registers are emulated, and are there just for compatibility. Please
use ethtool in preference, especially for SFPs.

> On 09/01/2020 21:34, Russell King - ARM Linux admin wrote:
> > You can check the state of the GPIOs by looking at
> > /sys/kernel/debug/gpio, and you will probably see that TX_FAULT is
> > being asserted by the module.
> 
> With OpenWrt trying to save space wherever they can
> 
> # CONFIG_DEBUG_GPIO is not set
> 
> this avenue is unfortunately is not available. Is there some other way
> (Linux userland) to query TX_FAULT and RX_LOS and whether either/both being
> asserted or deasserted?

CONFIG_DEBUG_GPIO is not the same as having debugfs support enabled.
If debugfs is enabled, then gpiolib will provide the current state
of gpios through debugfs.  debugfs is normally mounted on
/sys/kernel/debug, but may not be mounted by default depending on
policy.  Looking in /proc/filesystems will tell you definitively
whether debugfs is enabled or not in the kernel.

> On 09/01/2020 21:34, Russell King - ARM Linux admin wrote:
> > BTW, I notice in you original kernel that you have at least one of my
> > "experimental" patches on your stable kernel taken from my "phy" branch
> > which has never been in mainline, so I guess you're using the OpenWRT
> > kernel?
> I am not aware were the code originated from. It is not exactly OpenWrt but
> TOS (for the Turris Omnia router), being a downstream patchset that builds
> on top of OpenWrt. The TOS developers might be known at Linux kernel
> development, recently added their MOX platform and also with regard to
> Multi-CPU-DSA.

So, if that is correct...

Current OpenWRT is derived from 4.19-stable kernels, which include
experimental patches picked at some point from my "phy" branch, and
TOS is derived from OpenWRT.

That makes it very difficult for anyone in the mainline kernel
community to do anything about this; sending you a patch is likely
useless since you're not going to be able to test it.

> On 09/01/2020 21:34, Russell King - ARM Linux admin wrote:
> > You're reading/way/  too much into the state machine.
> 
> How so? Those intermittent failures cause disruption in the WAN connectivity
> - nothing life threatening but somewhat inconvenient.

You think the state machines are doing something clever. They don't.
They are all very simple and quite dumb.

> I am trying to get to the bottom of it, with my limited capabilities and
> with your input it has helped. I will ping Allnet again and see whether they
> bother to respond and shed some light of what their modules does with regard
> to TX_FAULT and RX_LOS.

The only real way to get to the bottom of it is to manually enable
debug in sfp.c so its possible to watch what happens, not only with
the hardware signals but also what the state machines are doing.
However, I'm very certain that there is no problem with the state
machines, and it is that the Allnet module is raising TX_FAULT.

I also think from what you've said above that rebuilding a kernel
to enable debug in sfp.c is going to not be possible for you.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
