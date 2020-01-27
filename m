Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8D1F14A537
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgA0NiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:38:05 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:36234 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgA0NiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:38:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hEVPihTZFlBUB/O1wOv5ir2YG3twNX+UmDFf1Ag2ags=; b=nccEWHjbZecrTrsl3dnNR/7UW
        nimh9OAu7lLkVrt06Ql2e4wDgO2vLZtCyL6rarQuocvwK2ptV91N8avan3rxwmo+iSZz/ooWNR88g
        TVo8EDks9/jzdCdCncKuaHM+xrKMJ+IYpk4AH5Jtf9vrbabO8QGGXbXEiVyeygtMyOSgGq165fvdE
        WZ9rdYZX8v/lu4bvS0XxKg5T55XfoZ/F845vhvU0tQAwGZpjCYHUOXrDi0e7cZLw1OQB5/pEBNqNl
        QthgpQKADD+3EG9NVU1qLBBqFgcAkWxpWYaU1BHZ3Jm8dUEfbRJfLiRxSK3Wk3f42dRWGQU8OLNdT
        MnvJ5MuAA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43996)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iw4aS-0001ap-OS; Mon, 27 Jan 2020 13:37:57 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iw4aO-0001R2-Bf; Mon, 27 Jan 2020 13:37:52 +0000
Date:   Mon, 27 Jan 2020 13:37:52 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC net-next 6/8] net: phylink: Configure MAC/PCS when link is
 up without PHY
Message-ID: <20200127133752.GV25745@shell.armlinux.org.uk>
References: <cover.1580122909.git.Jose.Abreu@synopsys.com>
 <9a2136885d9a892ff170be88fdffeda82c778a10.1580122909.git.Jose.Abreu@synopsys.com>
 <20200127112102.GT25745@shell.armlinux.org.uk>
 <BN8PR12MB3266714AE9EC1A97218120B3D30B0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200127114600.GU25745@shell.armlinux.org.uk>
 <BN8PR12MB3266A7C976B4E63466B5FA35D30B0@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB3266A7C976B4E63466B5FA35D30B0@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 12:50:54PM +0000, Jose Abreu wrote:
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Date: Jan/27/2020, 11:46:00 (UTC+00:00)
> 
> > On Mon, Jan 27, 2020 at 11:38:05AM +0000, Jose Abreu wrote:
> > > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > Date: Jan/27/2020, 11:21:02 (UTC+00:00)
> > > 
> > > > On Mon, Jan 27, 2020 at 12:09:11PM +0100, Jose Abreu wrote:
> > > > > When we don't have any real PHY driver connected and we get link up from
> > > > > PCS we shall configure MAC and PCS for the desired speed and also
> > > > > resolve the flow control settings from MAC side.
> > > > 
> > > > This is certainly the wrong place for it.  Please hold off on this patch
> > > > for the time being.  Thanks.
> > > 
> > > This is actually the change that makes everything work ...
> > > 
> > > I need to configure PCS before Aneg is complete and then I need to 
> > > configure MAC once Aneg is done and link is up with the outcome speed and 
> > > flow control.
> > 
> > Yes, I realise that, but it comes with the expense of potentially
> > breaking mvneta and mvpp2, where the settings are automatically
> > passed between the PCS and MAC in hardware. I also believe DSA
> > works around this, and I need to look at that.
> 
> OK so there is one alternative solution for this that's just saving the 
> last link status on stmmac internal structure (if applicable ofc, 
> something like an_complete is true and link is true) and then just use 
> that info in mac_link_up() callback to configure the MAC when PCS is in 
> use.

I'm not disagreeing that something needs to be done - the assumption
in phylink that the MAC and PCS talk to each other is one that comes
from the hardware which it was developed on, but is not true for all
hardware.  The IEEE 802.3 model doesn't include that behaviour.

So please, don't try to come up with an alternative solution; this
problem _does_ need solving in phylink, but it needs to be done in a
way that doesn't regress the existing users.

I've already started to split the current set of MAC operations into
a purely MAC set of operations and a set of PCS operations, but still,
the problem of how to sensibly deal with mvneta and mvpp2 remain.

The problem is that both these use two registers to control both the
PCS and MAC.  One is a control register, which controls what is
advertised, whether AN is used, what is negotiated and what is forced,
including whether the link is forced up.

The other is a status register that gives the status of the MAC -
whether tx pause and/or rx pause is enabled, what speed and duplex the
MAC is running at, whether the link is in sync, whether the link is up
etc.

Essentially, the PCS and MAC are tightly integrated together in this
hardware, so splitting this into separate PCS and MAC control blocks is
very problematical.

As I say, this is something that needs solving.  A solution needs to be
found, rather than having lots of drivers working around this issue in
their own special ways, and my fear is that the more workarounds we
have, the more the phylink core will become unmaintainable.

So please, no workarounds.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
