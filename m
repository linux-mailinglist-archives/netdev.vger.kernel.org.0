Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420671CF457
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 14:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbgELM3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 08:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727859AbgELM27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 08:28:59 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5812CC061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 05:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=b+mgEwXr12j0qT0ZE11gzLFzfT0QzKjbfPwTQD+2Km4=; b=jy30iJxHa+KIQduvLQGDuGhh5
        b67mpWUFOf4M3uF720F92VjstLNDk5ku/ENGsvc6QtlhWrqPFLRGU9yxFAWKMuSPh73vgondtR4rf
        mN6Czk00n2/do286B2i0Rs3brn+aaqzmoIqOFV7yYRamrn7iBSnlydeFx/YrGMXG40m/+sT/RqTeP
        2+xuGycjULmTJzbf4VEGOIP3LqQ99NKYPB9Ot+E2V92MiapQC4UsCAvX6WkMKCGaUThG8a7TOnMpt
        OSLGMlCbTBQe7cuAtNj7DF8GINs2EhEqqogW8D6gA83ZvVL176vS6yBOLk+3R+Dbt423jfbvHoRkK
        z6uPIrt7A==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:39314)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jYU1f-0001TW-V3; Tue, 12 May 2020 13:28:48 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jYU1c-0006k8-Ld; Tue, 12 May 2020 13:28:44 +0100
Date:   Tue, 12 May 2020 13:28:44 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Julien Beraud <julien.beraud@orolia.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Subject: Re: net: phylink: supported modes set to 0 with genphy sfp module
Message-ID: <20200512122844.GA1551@shell.armlinux.org.uk>
References: <0ee8416c-dfa2-21bc-2688-58337bfa1e2a@orolia.com>
 <20200511182954.GV1551@shell.armlinux.org.uk>
 <4894f014-88ed-227a-7563-e3bf3b16e00c@gmail.com>
 <1b0a20fa-b2ee-e7fa-fdfb-dedabe81b03f@orolia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b0a20fa-b2ee-e7fa-fdfb-dedabe81b03f@orolia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 11:28:40AM +0200, Julien Beraud wrote:
> 
> 
> On 11/05/2020 21:06, Florian Fainelli wrote:
> > 
> > 
> > On 5/11/2020 11:29 AM, Russell King - ARM Linux admin wrote:
> > > On Mon, May 11, 2020 at 05:45:02PM +0200, Julien Beraud wrote:
> > > > Following commit:
> > > > 
> > > > commit 52c956003a9d5bcae1f445f9dfd42b624adb6e87
> > > > Author: Russell King <rmk+kernel@armlinux.org.uk>
> > > > Date:   Wed Dec 11 10:56:45 2019 +0000
> > > > 
> > > >      net: phylink: delay MAC configuration for copper SFP modules
> > > > 
> > > > 
> > > > In function phylink_sfp_connect_phy, phylink_sfp_config is called before
> > > > phylink_attach_phy.
> > > > 
> > > > In the case of a genphy, the "supported" field of the phy_device is filled
> > > > by:
> > > > phylink_attach_phy->phy_attach_direct->phy_probe->genphy_read_abilities.
> > > > 
> > > > It means that:
> > > > 
> > > > ret = phylink_sfp_config(pl, mode, phy->supported, phy->advertising);
> > > > will have phy->supported with no bits set, and then the first call to
> > > > phylink_validate in phylink_sfp_config will return an error:
> > > > 
> > > > return phylink_is_empty_linkmode(supported) ? -EINVAL : 0;
> > > > 
> > > > this results in putting the sfp driver in "failed" state.
> > > 
> > > Which PHY is this?
> 
> The phy seems to be Marvell 88E1111, so the simple solution is to just add the driver for this PHY to my config.
> That said, if for some reason someone plugs a module for which no phy driver is found the issue will happen again.

Right, please use the specific PHY driver for modules that contain the
88E1111 to avoid any surprises, otherwise things can end up being
misconfigured - for example, the PHY using 1000base-X and the host
using SGMII, which may work or may lead to problems.

> > Using the generic PHY with a copper SFP module does not sound like a
> > great idea because without a specialized PHY driver (that is, not the
> > Generic PHY driver) there is not usually much that can happen.
> Thanks for the info. I don't have an advice on whether it is a good idea to use a copper sfp without a specialized driver,
> but before commit 52c956003a9d5bcae1f445f9dfd42b624adb6e87, it used to work and I could at least get a network connection.
> 
> Moreover, this commit didn't explicitely intend to forbid this behavior and the error is not explicit either.
> 
> If phylink+sfp still supports using genphy as a fallback, It may be good to fix the current behavior.
> If not, maybe adding an explicit warning or error would be preferrable.

The commit is designed to increase the range of modules that can be
used, especially when the module supports higher rates than the MAC.

The downside is that we _must_ know the PHYs capabilities before
attaching to it, so that we can choose an appropriate interface to
_attach_ to it with.  It's a chicken and egg problem.

For this to work reliably in cases such as those you've identified,
I need phylib to always give me that information earlier than it
currently seems to for the genphy fallback - but the problem is the
genphy fallback only happens after attaching to it.  So again,
another chicken and egg problem.

Subsituting the SFP modules capabilities seems like a workaround,
but those are also a guess from poor information in the SFP EEPROM.
It is what we were doing before however...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
