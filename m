Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE95199826
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 16:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731001AbgCaOIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 10:08:31 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:41646 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730919AbgCaOIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 10:08:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=lnFeysFtcRPhC/sTyWfEszSCpKMDIewp19ccyBmKsdA=; b=RZOoQka7jEA84B6SJiEmjaPtj
        D6aoIqSlNCoCKBfIuscCJZpPhpNmoQMrqTNzwDSqzSZIlAyC/sSHaCtU82LFQGLTi8Zfdw24PLXCU
        YZpWF61vVHZ3gUq0Oik2MqZoPUUYPnmI8Gt81Sb5y02FwziyVxxdQ5+cGgL15hHVNhQVg7LaLKptx
        g3UowzFw3YsBdyxGjPuHV4vi2CV10DhKr+t3dcLlacReivnjqyBxEGvfCb5Ba+2Nlh6LJSVuZMDM0
        OO0QtZ+WBQJuI0ri804Yl4fnL3wF/SPi68gRtFrNQEp9OX+i1sNwRO/ecFs57DfOmUWJSTs5ZkXdu
        PmCWH+o7Q==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:60398)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jJHYy-0000Bx-Mp; Tue, 31 Mar 2020 15:08:20 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jJHYp-0008Aa-Eb; Tue, 31 Mar 2020 15:08:11 +0100
Date:   Tue, 31 Mar 2020 15:08:11 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        linux-imx@nxp.com, kernel@pengutronix.de,
        David Jander <david@protonic.nl>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        mkl@pengutronix.de
Subject: Re: [PATCH v2] ARM: imx: allow to disable board specific PHY fixups
Message-ID: <20200331140811.GN25745@shell.armlinux.org.uk>
References: <20200329110457.4113-1-o.rempel@pengutronix.de>
 <20200329150854.GA31812@lunn.ch>
 <20200330052611.2bgu7x4nmimf7pru@pengutronix.de>
 <40209d08-4acb-75c5-1766-6d39bb826ff9@gmail.com>
 <20200330174114.GG25745@shell.armlinux.org.uk>
 <20200331134520.GA5756@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331134520.GA5756@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 31, 2020 at 03:45:20PM +0200, Oleksij Rempel wrote:
> Hi Russell,
> 
> On Mon, Mar 30, 2020 at 06:41:14PM +0100, Russell King - ARM Linux admin wrote:
> > On Mon, Mar 30, 2020 at 10:33:03AM -0700, Florian Fainelli wrote:
> > > 
> > > 
> > > On 3/29/2020 10:26 PM, Oleksij Rempel wrote:
> > > > Hi Andrew,
> > > > 
> > > > On Sun, Mar 29, 2020 at 05:08:54PM +0200, Andrew Lunn wrote:
> > > >> On Sun, Mar 29, 2020 at 01:04:57PM +0200, Oleksij Rempel wrote:
> > > >>
> > > >> Hi Oleksij
> > > >>
> > > >>> +config DEPRECATED_PHY_FIXUPS
> > > >>> +	bool "Enable deprecated PHY fixups"
> > > >>> +	default y
> > > >>> +	---help---
> > > >>> +	  In the early days it was common practice to configure PHYs by adding a
> > > >>> +	  phy_register_fixup*() in the machine code. This practice turned out to
> > > >>> +	  be potentially dangerous, because:
> > > >>> +	  - it affects all PHYs in the system
> > > >>> +	  - these register changes are usually not preserved during PHY reset
> > > >>> +	    or suspend/resume cycle.
> > > >>> +	  - it complicates debugging, since these configuration changes were not
> > > >>> +	    done by the actual PHY driver.
> > > >>> +	  This option allows to disable all fixups which are identified as
> > > >>> +	  potentially harmful and give the developers a chance to implement the
> > > >>> +	  proper configuration via the device tree (e.g.: phy-mode) and/or the
> > > >>> +	  related PHY drivers.
> > > >>
> > > >> This appears to be an IMX only problem. Everybody else seems to of got
> > > >> this right. There is no need to bother everybody with this new
> > > >> option. Please put this in arch/arm/mach-mxs/Kconfig and have IMX in
> > > >> the name.
> > > > 
> > > > Actually, all fixups seems to do wring thing:
> > > > arch/arm/mach-davinci/board-dm644x-evm.c:915:		phy_register_fixup_for_uid(LXT971_PHY_ID, LXT971_PHY_MASK,
> > > > 
> > > > Increased MII drive strength. Should be probably enabled by the PHY
> > > > driver.
> > > > 
> > > > arch/arm/mach-imx/mach-imx6q.c:167:		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
> > > > arch/arm/mach-imx/mach-imx6q.c:169:		phy_register_fixup_for_uid(PHY_ID_KSZ9031, MICREL_PHY_ID_MASK,
> > > > arch/arm/mach-imx/mach-imx6q.c:171:		phy_register_fixup_for_uid(PHY_ID_AR8031, 0xffffffef,
> > > > arch/arm/mach-imx/mach-imx6q.c:173:		phy_register_fixup_for_uid(PHY_ID_AR8035, 0xffffffef,
> > 
> > As far as I'm concerned, the AR8035 fixup is there with good reason.
> > It's not just "random" but is required to make the AR8035 usable with
> > the iMX6 SoCs.  Not because of a board level thing, but because it's
> > required for the AR8035 to be usable with an iMX6 SoC.
> > 
> > So, having it registered by the iMX6 SoC code is entirely logical and
> > correct.
> > 
> > That's likely true of the AR8031 situation as well.
> > 
> > I can't speak for any of the others.
> 
> OK, let's analyze it step by step:
> --------------------------------------------------------------------------------
> arch/arm/mach-imx/mach-imx6q.c
> 
> The AR8035 fixup is doing following configurations:
> - disable SmartEEE with following description:
>   /* Ar803x phy SmartEEE feature cause link status generates glitch,
>    * which cause ethernet link down/up issue, so disable SmartEEE
> 
> - enable clock output from PHY, configures it to 125Mhz and configures
>   clock skew. See the comment provided in the source code:
>   * Enable 125MHz clock from CLK_25M on the AR8031.  This
>   * is fed in to the IMX6 on the ENET_REF_CLK (V22) pad.
>   * Also, introduce a tx clock delay.
>   *
>   * This is the same as is the AR8031 fixup.
> 
> - powers on the PHY. Probably to make sure the clock output will run
>   before FEC is probed to avoid clock glitches.
> 
> The AR8031 fixup only enables clock output of PHY, configures it to
> 125Mhz, and configures clock skew. The PHY not powered and although it
> supports SmartEEE, it's not disabled. Let's assume the fixup author did
> the correct configuration and SmartEEE is working without problems.

I'm not arguing as a random third party.  I am the fixup author.

SmartEEE on the Atheros PHYs is enabled by default in the hardware,
and is a non-IEEE 802.3 approved hack to try to provide lower power
utilisation.  However, it has been observed to cause ethernet
corruption on SolidRun boards when connected to _some_ switches.
It appears that the combination of Atheros SmartEEE and some switches
introduces this problem.  This has been looked at by _three_ different
people.

The way SmartEEE works is very different from IEEE 802.3 EEE. The EEE
is terminated at the PHY, and the Ethernet controller is supposed to
know nothing about it.  If the link is in low power mode, then if the
MAC wants to start transmitting, the PHY has to buffer the packet,
wake the link up, and then pass the packet on.  There are configurable
delays in the AR8035, and we've tried adjusting those with no success.

This has nothing to do with anything at board level as far as anyone
can work out.

So, it seems entirely reasonable that the same problem would afflict
other iMX6 designs using the AR8035.  Indeed, it already does - the
SolidRun platforms have been through several different design
iterations, including different board layouts, and they _all_ exhibit
the same issue wrt SmartEEE using any of the iMX6 SoCs.

There is no published information from the manufacturer that suggests
that this is an Errata - if there were, then SolidRun being one of
their customers would have had that information.

Didn't bother to read the rest of the email, too long.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
