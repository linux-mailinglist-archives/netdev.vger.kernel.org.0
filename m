Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48BD7437BD
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732569AbfFMPAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:00:55 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:49258 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732573AbfFMOly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 10:41:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NN093k/4zOu6ret47fyds3hlSzjchrozRXYvjJo+p+Q=; b=ivcTti12y0W8Ar29hzvQyoaHM
        PYmBQy9FN4ulikfqgolkFn/e3myNpqOgxE6Jze023uZ9XyJXwZ6EJOIzpgzeqalMG59ZfrFUv3TcA
        SP2N6NHtkwwzrs6Oft06u4MuSKsfVnYcpVTfeqQq/j4i8/cfUzDi/+kmeeWvM3IWt2nphpZTtBhsh
        mCtMW8+ea/9ubFGtyemKSRmChxaX3B2QmEZ/BiJRN4q50wd8hOmMYE2vdkOjh7oPYp5WrUFg6oTh0
        I8fCiDaFT/UWMX29ueicV+LXWosb9ckIFUcBUkr0NsQ4oD4AV4EmntQpgcJjgX4y2Rn/wDr6sYc0B
        2ju3KCixA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:56362)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hbQvC-0003cz-4U; Thu, 13 Jun 2019 15:41:46 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hbQv9-0001Ja-JR; Thu, 13 Jun 2019 15:41:43 +0100
Date:   Thu, 13 Jun 2019 15:41:43 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: phylink: set the autoneg state in phylink_phy_change
Message-ID: <20190613144143.lx54zqh5qg47cead@shell.armlinux.org.uk>
References: <1560407871-5642-1-git-send-email-ioana.ciornei@nxp.com>
 <20190613081400.2cicsjpslxoidoox@shell.armlinux.org.uk>
 <VI1PR0402MB2800B6F4FC9C90C96E22979AE0EF0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
 <20190613093437.p4c6xiolrwzikmhq@shell.armlinux.org.uk>
 <VI1PR0402MB28005B0C87815A58789B8B04E0EF0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB28005B0C87815A58789B8B04E0EF0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 02:32:06PM +0000, Ioana Ciornei wrote:
> 
> > Subject: Re: [PATCH] net: phylink: set the autoneg state in
> > phylink_phy_change
> > 
> > On Thu, Jun 13, 2019 at 08:55:16AM +0000, Ioana Ciornei wrote:
> > > > Subject: Re: [PATCH] net: phylink: set the autoneg state in
> > > > phylink_phy_change
> > > >
> > > > On Thu, Jun 13, 2019 at 09:37:51AM +0300, Ioana Ciornei wrote:
> > > > > The phy_state field of phylink should carry only valid information
> > > > > especially when this can be passed to the .mac_config callback.
> > > > > Update the an_enabled field with the autoneg state in the
> > > > > phylink_phy_change function.
> > > >
> > > > an_enabled is meaningless to mac_config for PHY mode.  Why do you
> > > > think this is necessary?
> > >
> > > Well, it's not necessarily used in PHY mode but, from my opinion, it should
> > be set to the correct value nonetheless.
> > >
> > > Just to give you more context, I am working on adding phylink support on
> > NXP's DPAA2 platforms where any interaction between the PHY
> > management layer and the Ethernet devices is made through a firmware.
> > > When the .mac_config callback is invoked, the driver communicates the
> > new configuration to the firmware so that the corresponding net_device can
> > see the correct info.
> > > In this case, the an_enabled field is not used for other purpose than to
> > inform the net_device of the current configuration and nothing more.
> > 
> > The fields that are applicable depend on the negotiation mode:
> > 
> > - Non-inband (PHY or FIXED): set the speed, duplex and pause h/w
> >    parameters as per the state's speed, duplex and pause settings.
> >    Every other state setting should be ignored; they are not defined
> >    for this mode of operation.
> > 
> > - Inband SGMII: set for inband SGMII reporting of speed and duplex
> >    h/w parameters.  Set pause mode h/w parameters as per the state's
> >    pause settings.  Every other state setting should be ignored; they
> >    are not defined for this mode of operation.
> > 
> > - Inband 802.3z: set for 1G or 2.5G depending on the PHY interface mode.
> >    If an_enabled is true, allow inband 802.3z to set the duplex h/w
> >    parameter.  If an_enabled and the MLO_PAUSE_AN bit of the pause
> >    setting are true, allow 802.3z to set the pause h/w parameter.
> >    Advertise capabilities depending on the 'advertising' setting.
> > 
> > There's only one case where an_enabled is used, which is 802.3z negotiation,
> > because the MAC side is responsible for negotiating the link mode.  In all
> > other cases, the MAC is not responsible for any autonegotiation.
> 
> It's clear for me that an_enabled is of use for the MAC only when clause 37 auto-negotiation is used.
> 
> However,  the DPAA2 software architecture abstracts the MAC and the network interface into 2 separate entities that are managed by two different drivers.
> These drivers communicate only through a firmware.
> 
> This means that any ethtool issued on a DPAA2 network interface will go directly to the firmware for the latest link information.

So you won't be calling phylink_ethtool_ksettings_get(), which means
you won't be returning correct information anyway.

> When the MAC driver is not capable to inform the firmware of the proper link configuration (eg whether the autoneg is on or not), the ethtool output will not be the correct one.

You don't get to know the list of supported link modes, so I don't see
how the ethtool information can be correct.

I'd like to see the patches _before_ I consider accepting your proposed
phylink change.

> > It is important to stick to the above, which will ensure correct functioning of
> > your driver - going off and doing your own thing (such as reading from other
> > fields) is not guaranteed to give good results.
> 
> You're right, but unfortunately I am not dealing with a straight-forward architecture. 

At this point, I think you need to explain why you want to use phylink,
as you seem to be saying that your driver is unable to conform to what
phylink expects due to firmware.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
