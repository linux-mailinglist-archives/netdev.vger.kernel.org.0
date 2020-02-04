Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 817BD151F67
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 18:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbgBDR0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 12:26:22 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:53354 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbgBDR0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 12:26:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fuRn3g8vdxzS8ojzL5QRRJS2jUGnGpT8caDLxsYatmQ=; b=Y5jKMthKHAI9FOfanUN9jkW1Y
        Gk917K+zqz+3pxHIwKpA/gA8LKkfx3JpVX/51xPKVjM7pnsnQELGv0vlKNhzRfNfc78YwkX6V/9kd
        Tdetkbe82pfXqFef4AKCD8RTa5ROsYvfoYt5ElgZRie3BFFfvVbQxSPWVk6d9s0vHfeIMDdGi+1qj
        VdpFKdj+pwfMAMBJgly0tjVNdDsqIcLpmqIIjSgx+xYAJrNohJmnPlCLiyY1PE5gpsQQ8+LyFtfOO
        S/U6a8zegLN9OrzkZWLXvf+7V6Es9zU+sGRX5vpD5hspoPYo6O0BzUrPtSzgzQfs40UOI/ztwQdpX
        U/NNZVRtQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47580)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iz1xh-0003Mr-Eh; Tue, 04 Feb 2020 17:26:09 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iz1xb-00015C-Tp; Tue, 04 Feb 2020 17:26:03 +0000
Date:   Tue, 4 Feb 2020 17:26:03 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC net-next 6/8] net: phylink: Configure MAC/PCS when link is
 up without PHY
Message-ID: <20200204172603.GS25745@shell.armlinux.org.uk>
References: <20200127112102.GT25745@shell.armlinux.org.uk>
 <BN8PR12MB3266714AE9EC1A97218120B3D30B0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200127114600.GU25745@shell.armlinux.org.uk>
 <20200127140038.GD13647@lunn.ch>
 <20200127140834.GW25745@shell.armlinux.org.uk>
 <20200127145107.GE13647@lunn.ch>
 <20200127161132.GX25745@shell.armlinux.org.uk>
 <20200127162206.GJ13647@lunn.ch>
 <c3e863b8-2143-fee3-bb0b-65699661d7ab@gmail.com>
 <BN8PR12MB3266B69DA09E1CC215843C3CD30A0@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB3266B69DA09E1CC215843C3CD30A0@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 28, 2020 at 11:12:05AM +0000, Jose Abreu wrote:
> Hi Russell,
> 
> Please check bellow for another possibility. On this one I moved almost 
> everything to PHYLINK, except the HW related logic which is still in XPCS 
> module.
> 
> https://github.com/joabreu/linux/commits/stmmac-next

I think this is going a little too far; it has the effect of limiting
phylink to using one PCS, but a device may have multiple PCS attached
to the MAC subsystem.

I know that mvpp2's network interfaces are a bit like that - there is
the 10/100/1G/2.5G MAC+PCS subsystem, and an entirely separate 10G
MAC+XPCS/MPCS subsystem which are switched between on the fly.

Similar is true on the LX2160A (which is what I've been working on
over the last week, having dug out some additional information on it
that was hidden inside the PDFs - reference manual PDFs within other
reference manual PDFs is not a nice way to provide documentation -
unless you stumble over the internal link to the file in the outer
PDF, you have no idea that the sub-documentation even exists.)

There, there is one MAC, but there are multiple different PCS - one
for SGMII and 1000base-X, another for 10G, another for 25G, etc.
These PCS are accessed via a MDIO adapter embedded in each of the
MAC hardware blocks.

LX2160A provides some additional complexities at the moment as we
don't yet know whether it's possible to reconfigure the Serdes on
the fly to switch between the various speeds, so we can't get
dynamically switch between (SGMII, 1000base-X), 10G, 25G, 40G,
100G - but a request has been put into NXP before Christmas to see
what would be possible.

So, right now I don't like the idea that we have this probing
mechanism bolted into phylink for PCS PHYs - I think that's a
decision that the MAC driver needs to be making.

Now, you've introduced this phylink_pcs_ops thing - which is similar
to a patch that I've had in my tree for a few weeks while working on
this issue.  As I've already said to you, the issue you currently
have affects multiple people, and I've been working on solving it
in a way that *isn't* specific to one particular hardware - but with
an overview of all the problems that everyone has.

Plus, it's not like we need to rush - we're in the middle of a merge
window right now, so we have about three months before the code will
ultimately be merged into mainline.  We might as well use that time
to work out a solution that doesn't mess up someone else.

Much of the prototype stuff for the LX2160A, including some revised
patches I've sent out during January, are available in my "cex7" and
"phy" branches - but not yet the mac_ops vs pcs_ops bits, which I'm
still working on.  What is in the "cex7" branch is fairly close to
being split into separate MAC / PCS operations, but I haven't yet
moved out my MAC / PCS operations split patches yet.

Now, one of the important changes which may not be obvious from those
branches is the way we pass the link state to the MAC and PCS.
Currently, that was only available via mac_config(), which assumes an
integrated MAC / PCS solution - mac_config() will not be called
(intentionally) for in-band links where no PHY is attached, and I don't
want to change that for several reasons.  Instead, the link_up()
methods get passed the resolved state, and this is the state that a
split MAC / PCS setup should be using to configure the MAC or PCS
when the link comes up.  All fields are guaranteed to be the resolved
state, so no SPEED_UNKNOWN / DUPLEX_UNKNOWN issues unless something
has gone wrong elsewhere - which is one of the other reasons for this,
various users have been having issues due to those passed to
mac_config().

It's not production-ready yet, but I will continue working on it
over the coming week.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
