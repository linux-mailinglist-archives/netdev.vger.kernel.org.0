Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7914199A64
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 17:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730896AbgCaPyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 11:54:02 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:43050 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730105AbgCaPyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 11:54:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Xbao8KSLFnhUJRMeq0hTDteAoWcuNhiygQmHVbCKMDM=; b=YexFoZsyYEuDb1fxJg7z7vUf7
        qVgp8yDkyCqRvbgqnPpz4d/Dk6VhnmO40ISGRlv4/aVpY2rjMCG98iBp/dO7f6bjhzwvGrUUKJasj
        TTg8HXBtITNqM9oEq+GskI5imueF/JW4fAcQZzS5Hq9Z1wZ7GkvwP7jSYba1Z7kAZ/vFrpwehrkan
        lCRLyoJKkft8YP9hQqoO3I7NtNbOkp3EOhIbkiT+5TaeqvNIRasry/0JaaWrLWsoyzbAfUDx/W7pT
        wdKnGcS1rBBGf4LhwAcSRx6NaC/4hlLdSL6ecDyKMbyZOZsHNeknedEHJ2IWynIDJbVqv5L5COMNW
        edNv35deA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:60426)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jJJD6-0000g4-7a; Tue, 31 Mar 2020 16:53:52 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jJJD4-0008Ex-9p; Tue, 31 Mar 2020 16:53:50 +0100
Date:   Tue, 31 Mar 2020 16:53:50 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     David Jander <david@protonic.nl>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        linux-imx@nxp.com, kernel@pengutronix.de,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2] ARM: imx: allow to disable board specific PHY fixups
Message-ID: <20200331155350.GP25745@shell.armlinux.org.uk>
References: <20200329110457.4113-1-o.rempel@pengutronix.de>
 <20200329150854.GA31812@lunn.ch>
 <20200330052611.2bgu7x4nmimf7pru@pengutronix.de>
 <40209d08-4acb-75c5-1766-6d39bb826ff9@gmail.com>
 <20200330174114.GG25745@shell.armlinux.org.uk>
 <20200331104459.6857474e@erd988>
 <20200331093648.GL25745@shell.armlinux.org.uk>
 <20200331174103.6c8f5a43@erd988>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331174103.6c8f5a43@erd988>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 31, 2020 at 05:41:03PM +0200, David Jander wrote:
> 
> Dear Russell,
> 
> On Tue, 31 Mar 2020 10:36:49 +0100
> Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> 
> > On Tue, Mar 31, 2020 at 10:44:59AM +0200, David Jander wrote:
> > > On Mon, 30 Mar 2020 18:41:14 +0100
> > > Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> > >   
> > > > On Mon, Mar 30, 2020 at 10:33:03AM -0700, Florian Fainelli wrote:  
> > > > > 
> > > > > 
> > > > > On 3/29/2020 10:26 PM, Oleksij Rempel wrote:    
> > > > > > Hi Andrew,
> > > > > > 
> > > > > > On Sun, Mar 29, 2020 at 05:08:54PM +0200, Andrew Lunn wrote:    
> > > > > >> On Sun, Mar 29, 2020 at 01:04:57PM +0200, Oleksij Rempel wrote:
> > > > > >>
> > > > > >> Hi Oleksij
> > > > > >>    
> > > > > >>> +config DEPRECATED_PHY_FIXUPS
> > > > > >>> +	bool "Enable deprecated PHY fixups"
> > > > > >>> +	default y
> > > > > >>> +	---help---
> > > > > >>> +	  In the early days it was common practice to configure PHYs by adding a
> > > > > >>> +	  phy_register_fixup*() in the machine code. This practice turned out to
> > > > > >>> +	  be potentially dangerous, because:
> > > > > >>> +	  - it affects all PHYs in the system
> > > > > >>> +	  - these register changes are usually not preserved during PHY reset
> > > > > >>> +	    or suspend/resume cycle.
> > > > > >>> +	  - it complicates debugging, since these configuration changes were not
> > > > > >>> +	    done by the actual PHY driver.
> > > > > >>> +	  This option allows to disable all fixups which are identified as
> > > > > >>> +	  potentially harmful and give the developers a chance to implement the
> > > > > >>> +	  proper configuration via the device tree (e.g.: phy-mode) and/or the
> > > > > >>> +	  related PHY drivers.    
> > > > > >>
> > > > > >> This appears to be an IMX only problem. Everybody else seems to of got
> > > > > >> this right. There is no need to bother everybody with this new
> > > > > >> option. Please put this in arch/arm/mach-mxs/Kconfig and have IMX in
> > > > > >> the name.    
> > > > > > 
> > > > > > Actually, all fixups seems to do wring thing:
> > > > > > arch/arm/mach-davinci/board-dm644x-evm.c:915:		phy_register_fixup_for_uid(LXT971_PHY_ID, LXT971_PHY_MASK,
> > > > > > 
> > > > > > Increased MII drive strength. Should be probably enabled by the PHY
> > > > > > driver.
> > > > > > 
> > > > > > arch/arm/mach-imx/mach-imx6q.c:167:		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
> > > > > > arch/arm/mach-imx/mach-imx6q.c:169:		phy_register_fixup_for_uid(PHY_ID_KSZ9031, MICREL_PHY_ID_MASK,
> > > > > > arch/arm/mach-imx/mach-imx6q.c:171:		phy_register_fixup_for_uid(PHY_ID_AR8031, 0xffffffef,
> > > > > > arch/arm/mach-imx/mach-imx6q.c:173:		phy_register_fixup_for_uid(PHY_ID_AR8035, 0xffffffef,    
> > > > 
> > > > As far as I'm concerned, the AR8035 fixup is there with good reason.
> > > > It's not just "random" but is required to make the AR8035 usable with
> > > > the iMX6 SoCs.  Not because of a board level thing, but because it's
> > > > required for the AR8035 to be usable with an iMX6 SoC.  
> > > 
> > > I have checked with the datasheet of the AR8035, and AFAICS, what the code
> > > does is this:
> > > 
> > >  - Disable the SmartEEE feature of the phy. The comment in the code implies
> > >    that for some reason it doesn't work, but the reason itself is not given.
> > >    Anyway, disabling SmartEEE should IMHO opinion be controlled by a DT
> > >    setting. There is no reason to believe this problem is specific to the
> > >    i.MX6. Besides, it is a feature of the phy, so it seems logical to expose
> > >    that via the DT. Once that is done, it has no place here.
> > > 
> > >  - Set the external clock output to 125MHz. This is needed because the i.MX6
> > >    needs a 125MHz reference clock input. But it is not a requirement to use
> > >    this output. It is perfectly fine and possible to design a board that uses
> > >    an external oscillator for this. It is also possible that an i.MX6 design
> > >    has such a phy connected to a MAC behind a switch or some other interface.
> > >    Independent of i.MX6 this setting can also be necessary for other hardware
> > >    designs, based on different SoC's. In summary, this is a feature of the
> > >    specific hardware design at hand, and has nothing to do with the i.MX6
> > >    specifically. This should definitely be exposed through the DT and not be
> > >    here.
> > > 
> > >  - Enable TXC delay. To clarify, the RGMII specification version 1 specified
> > >    that the RXC and TXC traces should be routed long enough to introduce a
> > >    certain delay to the clock signal, or the delay should be introduced via
> > >    other means. In a later version of the spec, a provision was given for MAC
> > >    or PHY devices to generate this delay internally. The i.MX6 MAC interface
> > >    is unable to generate the required delay internally, so it has to be taken
> > >    care of either by the board layout, or by the PHY device. This is the
> > >    crucial point: The amount of delay set by the PHY delay register depends on
> > >    the board layout. It should NEVER be hard-coded in SoC setup code. The
> > >    correct way is to specify it in the DT. Needless to say that this too,
> > >    isn't i.MX6-specific.
> > >   
> > > > So, having it registered by the iMX6 SoC code is entirely logical and
> > > > correct.  
> > > 
> > > I'm afraid I don't agree. See above. This code really should never have been
> > > here. It is not i.MX6-specific as I pointed out above, nor is it necessarily
> > > applicable to all i.MX6 boards that use those phy devices.  
> > 
> > Then we will have to agree to disagree, sorry.
> 
> Please forgive me if I am appearing a bit stubborn.
> If it is not too much to ask, I would really like to know where my reasoning
> is wrong?
> Maybe you can explain to me how to solve the following real-life conflict that
> this introduces:
> 
> Suppose we have a board with an i.MX6Q and a KSZ9031 connected to it. Suppose
> I now take a USB stick with a LAN7800 ethernet chip and a KSZ9031 PHY. These
> USB sticks do exist, and it does not seem unthinkable to me that one would
> connect them to such an i.MX6 system in order to get a second LAN port.

Thanks.  I've already covered how this can be delt with in some code
I've posted in this thread.  Therefore, I have nothing further to add
to this point, apart from pointing out that I've provided a solution
so as far as I'm concerned, it's entirely solvable, and warrants no
further argument.

Maybe a discussion about solutions would be appropriate, but merely
re-raising the same point while ignoring proposed solutions is not
a productive way forward.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
