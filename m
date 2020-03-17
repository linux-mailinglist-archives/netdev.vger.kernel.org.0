Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADC3A188B2E
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 17:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgCQQwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 12:52:19 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:42452 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgCQQwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 12:52:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2Qsd3lIJbtRn8arJ75uUHaRTaOqffAy0TwbJ2K3turg=; b=VnVCQOHMozHWJ8hu7nkJgZTen
        pahZYtiLI6dMC2j1f9GeQ86VC5ZDMoGpj1Jv7Z45/3YKHrVwmtcRiWxnuXofRCqpOjkVtksnHmfir
        oZAwFQ1VnsSjcieP0vs4FUVEgr3ATxepwLvWkysoH2GI1cIGnjwvks4Wput7hPmwM18baKukP4mkw
        eJxTbTcqVDLexrkEeTzOy0Iuzdfm74GdLmGcVFs1OHmfA6XDiD0McWxzmx/q3WzLHwQRX38sOhtai
        9poDo8M7YOz8yVORIuFal9G/4zXz20E5DFj5KCO5kBkrKk7iTcyRlLDMNoI3LFLv+TL+8jmKyhqD6
        ZsYZ2hyzQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37728)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jEFRr-0008FU-0z; Tue, 17 Mar 2020 16:52:11 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jEFRo-0002xv-8S; Tue, 17 Mar 2020 16:52:08 +0000
Date:   Tue, 17 Mar 2020 16:52:08 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC net-next 2/5] net: phylink: add separate pcs operations
 structure
Message-ID: <20200317165208.GT25745@shell.armlinux.org.uk>
References: <20200317144944.GP25745@shell.armlinux.org.uk>
 <E1jEDaN-0008JH-MY@rmk-PC.armlinux.org.uk>
 <BN8PR12MB3266FC193AF677B87DFC98C2D3F60@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200317155610.GS25745@shell.armlinux.org.uk>
 <BN8PR12MB32669A0271475CF06C0008C4D3F60@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB32669A0271475CF06C0008C4D3F60@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 04:04:28PM +0000, Jose Abreu wrote:
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Date: Mar/17/2020, 15:56:10 (UTC+00:00)
> 
> > > Please consider removing this condition and just rely on an_enabled field. 
> > > I have USXGMII support for Clause 73 Autoneg so this won't work with 
> > > that.

Do you really mean USXGMII or XLGMII that you recently contributed?
XLGMII makes more sense for clause 73.

> > That is actually incorrect.  SGMII can have an_enabled being true, but
> > SGMII is not an autonegotiation between the MAC and PHY - it is merely
> > a mechanism for the PHY to inform the MAC what the results of _its_
> > negotiation are.
> > 
> > I suspect USXGMII is the same since it is just an "upgraded" version of
> > SGMII.  Please can you check whether there really is any value in trying
> > (and likely failing) to restart the "handshake" with the PHY from the
> > MAC end, rather than requesting the PHY to restart negotiation on its
> > media side.
> 
> I think we are speaking of different things here. I'm speaking about 
> end-to-end Autoneg. Not PHY <-> PCS <-> MAC.

What do you mean end-to-end autoneg?  Let's take a simple example for
SGMII, here is the complete setup:

MAC <--> PCS <--SGMII--> PHY <--MEDIA--> PHY <--SGMII--> MAC

Generally, asking the PCS to "renegotiate" will either be ignored, or
might cause the PCS to restart the handshake with the PHY depending on
the implementation.  It will not cause the PHY to renegotiate with the
remote PHY.

Asking the PHY to renegotiate will cause the link to drop, which
updates the config_reg word sent to the PCS to indicate link down.
When the link is re-established, the config_reg word is updated again
with the new link parameters and that sent to the PCS.

So, just because something is closer to the MAC does not necessarily
mean that it causes more of the blocks to "renegotiate" when asked to
do so.

In SGMII, the PHY is the "master" and this is what needs negotiation
restarted on "ethtool -r" to have the effect that the user desires.

I believe (but I don't know for certain, because the USXGMII
documentation is not available to me) that USXGMII is SGMII extended
up to additionally include 10G, 5G and 2.5G speeds, and otherwise is
basically the same mechanism.

So, I would suggest that USXGMII and SGMII should be treated the same,
and for both of them, a renegotiation should always be performed at
the PHY and not the PCS.

There is another reason not to try triggering renegotiation at both
the PHY and PCS.  When the PHY is renegotiating, the state machines
at both the PHY and PCS end are in the process of changing - if we
hit the PCS with a request to renegotiate, and the hardware isn't
setup to ignore it, that could occur in an unexpected state - the risk
of triggering a hardware problem could be higher.

So, based on this, I don't think it's a good idea to restart
negotiation at the PCS for SGMII and USXGMII modes.

For the 802.3z based protocols, it makes complete sense to do so,
because the PCS are the blocks involved in the actual media negotiation
and there is no place else to restart negotiation:

MAC <---> PCS <----fiber 1000base-X----> PCS <---> MAC

> I'm so sorry but I'm not an expert in this field, I just deal mostly with 
> IP.
> 
> Anyway, I'm speaking about end-to-end Clause 73 Autoneg which involves 
> exchanging info with the peer. If peer for some reason is not available to 
> receive this info then AutoNeg will not succeed. Hence the reason to 
> restart it.

Clause 73 covers backplane and copper cable, and isn't USXGMII.
In the case of copper, I would expect the setup to be very similar
to what I've outlined above for the SGMII case, but using USXGMII
instead of SGMII, or automatically selecting something like
10GBASE-R, 5GBASE-R, 2500BASE-X, or SGMII depending on the result
from copper negotiation.  Depending on the Ethernet PHY being used,
it may or may not have the in-band control_reg word even for SGMII.
In any case, what I've said above applies: to provoke end-to-end
renegotiation, the PHY needs to be restarted, not the MAC's PCS.

For backplane, things are a little different, and that may indeed
require the MAC's PCS to be restarted, and for that case it may be
reasonable to expand the conditional there.

However, note that for the purposes of this patch, no change of
behaviour over the current behaviour is intended; a change to this
will need to be a separate patch.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
