Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFAEF242C54
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 17:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgHLPsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 11:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgHLPsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 11:48:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03259C061383
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 08:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7dHzfJxzsQ8NfAwYImG5lxJtOm/yZ4jFcHtlyuavANc=; b=LGLnF3qz97Jt4/AlElbrv+UwO
        NC+zaD+eVuBks6e2udqH5RaLFyQVvd5kmJdQzl4zRUAv2dbAbCwjQYECmKou+53Nm10oQRgUVl4Kg
        bUNWY3lPOW+0cZwE/YAzsmIvpaCJ5VWbOgEZglbLvG4PzK9RI6Sp2yYEN/5rNSykmkz8f84LlYd83
        9GpLt2qlPuyeZIa9JqjKFTeRAkrOs6YG+Lv8U1Cu0HtkBiKLuwo1CL0a0Cqfv7OScCeHq1zChnJX2
        pg1gRJHoxb2u6SHDORMUTFEvCIExBine+yrmd1IeSpZ4KvISDEyOCqelXxjyDcBGqDw6HRGBF4d6O
        wJ7/X8zrw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51610)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k5szV-0002qb-LH; Wed, 12 Aug 2020 16:48:37 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k5szV-0003vn-6G; Wed, 12 Aug 2020 16:48:37 +0100
Date:   Wed, 12 Aug 2020 16:48:37 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC russell-king 3/4] net: phy: marvell10g: change
 MACTYPE according to phydev->interface
Message-ID: <20200812154837.GQ1551@shell.armlinux.org.uk>
References: <20200810220645.19326-1-marek.behun@nic.cz>
 <20200810220645.19326-4-marek.behun@nic.cz>
 <20200811152144.GN1551@shell.armlinux.org.uk>
 <20200812164431.34cf569f@dellmb.labs.office.nic.cz>
 <20200812150054.GP1551@shell.armlinux.org.uk>
 <20200812173716.140bed4d@dellmb.labs.office.nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200812173716.140bed4d@dellmb.labs.office.nic.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 12, 2020 at 05:37:16PM +0200, Marek Behún wrote:
> On Wed, 12 Aug 2020 16:00:54 +0100
> Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> 
> > On Wed, Aug 12, 2020 at 04:44:31PM +0200, Marek Behún wrote:
> > > There is another problem though: I think the PHY driver, when
> > > deciding whether to set MACTYPE from the XFI with rate matching
> > > mode to the 10GBASE-R/5GBASE-R/2500BASE-X/SGMII with AN mode,
> > > should check which modes the underlying MAC support.  
> > 
> > I'm aware of that problem.  I have some experimental patches which add
> > PHY interface mode bitmaps to the MAC, PHY, and SFP module parsing
> > functions.  I have stumbled on some problems though - it's going to be
> > another API change (and people are already whinging about the phylink
> > API changing "too quickly", were too quickly seems to be defined as
> > once in three years), and in some cases, DSA, it's extremely hard to
> > work out how to properly set such a bitmap due to DSA's layered
> > approach.
> > 
> 
> If by your experimental patches you mean
>   net: mvneta: fill in phy interface mode bitmap
>   net: mvpp2: fill in phy interface mode bitmap
> found here
>   http://git.arm.linux.org.uk/cgit/linux-arm.git/log/?h=clearfog
> I am currently working on top of them.
> 
> > Having bitmaps means that we can take the union of what the MAC and
> > PHY supports, and decide which MACTYPE setting would be most suitable.
> > However, to do that we're into also changing phylib's interfaces as
> > well.
> > 
> > > driver to phylink in the call to phylink_create. But there is no way
> > > for the PHY driver to get this information from phylink currently,
> > > and even if phylink exposed a function to return the config member
> > > of struct phylink, the problem is that at the time when
> > > mv3310_power_up is called, the phydev->phylink is not yet set (this
> > > is done in phylink_bringup_phy, and mv3310_power_up is called
> > > sometime in the phylink_attach_phy).  
> > 
> > We _really_ do not want phylib calling back into phylink functions.
> > That would tie phylink functionality into phylib and cause problems
> > when phylink is not being used.
> > 
> > I would prefer phylib to be passed "the MAC can use these interface
> > types, and would prefer to use this interface type" and have the
> > phylib layer (along with the phylib driver) make the decision about
> > which mode should be used.  That also means that non-phylink MACs
> > can also use it.
> > 
> 
> I may try to propose something, but in the meantime do you think the
> current version of the patch
>   net: phy: marvell10g: change MACTYPE according to phydev->interface
> is acceptable?

Well, I have other questions about it.  Why are you doing it in
the power_up function?  Do you find that the MACTYPE field is
lost when clearing the power down bit?  From what I read, it should
only change on hardware reset, and we don't hardware reset when we
come out of power down - only software reset.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
