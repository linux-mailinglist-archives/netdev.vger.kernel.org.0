Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53A5918B228
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 12:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgCSLOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 07:14:37 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:42896 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgCSLOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 07:14:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NWmhJyR/FZn0qqaoP8c/HxmcqnQMLPHrJh0yCq8jES4=; b=w+4n3MODADQXelkZASzKB9HvO
        ++C2hbQrdzdnTP6PoNmpkWUM2itZ8XREJKWUokOpRJaTyaeU6LuneaC4l4VyNnEJ64k6fCMqvvBU9
        51Q6gQ28ublZpVMZpsohUsG6wosarCOYKHZyDYV+eO8PlDdTYH2FeDgtqhOT9blixRLMH9N6h8ObB
        oRYnCIUm40l1Ex29PHDhtQqODwMGCWUNaIgARQIMdE/Bc9TraL+Do9tX9hWqAaoTlPC+aXx9nyFA3
        FwjPq1nMmuqmNdmFr6GuYvVoC0fuzer+o+e2EeUSgRMommq/Psyj6Al1IxVmDLBNu8AMtyQecpmU7
        tEZjXroeQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38514)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jEt89-0001oX-7r; Thu, 19 Mar 2020 11:14:29 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jEt85-0004jP-5d; Thu, 19 Mar 2020 11:14:25 +0000
Date:   Thu, 19 Mar 2020 11:14:25 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC net-next 2/5] net: phylink: add separate pcs operations
 structure
Message-ID: <20200319111425.GC25745@shell.armlinux.org.uk>
References: <20200317144944.GP25745@shell.armlinux.org.uk>
 <E1jEDaN-0008JH-MY@rmk-PC.armlinux.org.uk>
 <BN8PR12MB3266FC193AF677B87DFC98C2D3F60@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200317155610.GS25745@shell.armlinux.org.uk>
 <BN8PR12MB32669A0271475CF06C0008C4D3F60@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200317165208.GT25745@shell.armlinux.org.uk>
 <BN8PR12MB3266F5CB897B16D0F376300CD3F70@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB3266F5CB897B16D0F376300CD3F70@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 07:45:52AM +0000, Jose Abreu wrote:
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Date: Mar/17/2020, 16:52:08 (UTC+00:00)
> 
> > On Tue, Mar 17, 2020 at 04:04:28PM +0000, Jose Abreu wrote:
> > > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > Date: Mar/17/2020, 15:56:10 (UTC+00:00)
> > > 
> > > > > Please consider removing this condition and just rely on an_enabled field. 
> > > > > I have USXGMII support for Clause 73 Autoneg so this won't work with 
> > > > > that.
> > 
> > Do you really mean USXGMII or XLGMII that you recently contributed?
> > XLGMII makes more sense for clause 73.
> > 
> > > > That is actually incorrect.  SGMII can have an_enabled being true, but
> > > > SGMII is not an autonegotiation between the MAC and PHY - it is merely
> > > > a mechanism for the PHY to inform the MAC what the results of _its_
> > > > negotiation are.
> > > > 
> > > > I suspect USXGMII is the same since it is just an "upgraded" version of
> > > > SGMII.  Please can you check whether there really is any value in trying
> > > > (and likely failing) to restart the "handshake" with the PHY from the
> > > > MAC end, rather than requesting the PHY to restart negotiation on its
> > > > media side.
> > > 
> > > I think we are speaking of different things here. I'm speaking about 
> > > end-to-end Autoneg. Not PHY <-> PCS <-> MAC.
> > 
> > What do you mean end-to-end autoneg?  Let's take a simple example for
> > SGMII, here is the complete setup:
> > 
> > MAC <--> PCS <--SGMII--> PHY <--MEDIA--> PHY <--SGMII--> MAC
> > 
> > Generally, asking the PCS to "renegotiate" will either be ignored, or
> > might cause the PCS to restart the handshake with the PHY depending on
> > the implementation.  It will not cause the PHY to renegotiate with the
> > remote PHY.
> > 
> > Asking the PHY to renegotiate will cause the link to drop, which
> > updates the config_reg word sent to the PCS to indicate link down.
> > When the link is re-established, the config_reg word is updated again
> > with the new link parameters and that sent to the PCS.
> > 
> > So, just because something is closer to the MAC does not necessarily
> > mean that it causes more of the blocks to "renegotiate" when asked to
> > do so.
> > 
> > In SGMII, the PHY is the "master" and this is what needs negotiation
> > restarted on "ethtool -r" to have the effect that the user desires.
> > 
> > I believe (but I don't know for certain, because the USXGMII
> > documentation is not available to me) that USXGMII is SGMII extended
> > up to additionally include 10G, 5G and 2.5G speeds, and otherwise is
> > basically the same mechanism.
> > 
> > So, I would suggest that USXGMII and SGMII should be treated the same,
> > and for both of them, a renegotiation should always be performed at
> > the PHY and not the PCS.
> > 
> > There is another reason not to try triggering renegotiation at both
> > the PHY and PCS.  When the PHY is renegotiating, the state machines
> > at both the PHY and PCS end are in the process of changing - if we
> > hit the PCS with a request to renegotiate, and the hardware isn't
> > setup to ignore it, that could occur in an unexpected state - the risk
> > of triggering a hardware problem could be higher.
> > 
> > So, based on this, I don't think it's a good idea to restart
> > negotiation at the PCS for SGMII and USXGMII modes.
> > 
> > For the 802.3z based protocols, it makes complete sense to do so,
> > because the PCS are the blocks involved in the actual media negotiation
> > and there is no place else to restart negotiation:
> > 
> > MAC <---> PCS <----fiber 1000base-X----> PCS <---> MAC
> 
> That's kind of the setup I have, hence the need for me to restart ... I 
> have this:
> 
> MAC <-> PCS <-> SERDES <-> Copper <-> SERDES <-> PCS <-> MAC
> 
> So, no PHY to restart Autoneg.

And the protocol over the copper is USXGMII?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
