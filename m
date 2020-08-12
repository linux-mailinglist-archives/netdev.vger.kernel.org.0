Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B976242CD0
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 18:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHLQBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 12:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgHLQBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 12:01:34 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8D0C061383
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 09:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IQeiFsfyPZxegGB6H/AjIt/seX3Os+djLpv8DQ3/Qko=; b=QzYvm+y18AiLzCfln35n2MkIB
        MCrD+NUiaJuN1vGVhhpI6xcMLfqMGh8Izog+GMbHThGYEOISyS9wOScBJA6jvc1Qa+SozB5cXCDe6
        ONt0kJhOUk5AfZLl/wF6tlWAgwTz+iCVnuEqycnm3d4H82pJRMokzWISa8UiivuxqT98pzcwtAkOj
        k8SKjhRN9UfEgjxQUznCTNtagqB35st7cCixVRmT2lBgT8Na05bCkzvYYIwv8Pd2ApO17MIXnwWPX
        i4n69O39PeE8z6CwRrgwx4oM0mcCvH99Myu9r1tm7DRDpDzZPjnOvGP6UPvzGcxwzSJRwKX2cgFCh
        DS+emjmbA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51622)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k5tC0-0002ry-AU; Wed, 12 Aug 2020 17:01:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k5tBz-0003wE-VP; Wed, 12 Aug 2020 17:01:31 +0100
Date:   Wed, 12 Aug 2020 17:01:31 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC russell-king 3/4] net: phy: marvell10g: change
 MACTYPE according to phydev->interface
Message-ID: <20200812160131.GS1551@shell.armlinux.org.uk>
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

That's fine, because you also have the patches further down in
net-queue.  So, what you list above are basically not all the patches.

net: mvpp2: fill in phy interface mode bitmap
net: mvneta: fill in phy interface mode bitmap
net: phylink: use phy interface mode bitmaps
net: sfp: add interface bitmap
net: phy: add supported_interfaces to marvell10g PHYs
net: phy: add supported_interfaces to marvell PHYs
net: phy: add supported_interfaces to bcm84881
net: phy: add supported_interfaces to phylib

Now, I think there's going to be a problem - if you look at the phylink
code for this, we assume that the supported_interfaces we get from
phylib is what the PHY will be doing.  However, if we then go and change
the interface mode, what then...

I guess if we rework it along the lines that I've mentioned - phylib
is passed the MAC supported interfaces, and phylib/phy drivers choose
which interface to use, then I guess we no longer need to specify to
phylib what interface mode should be used (what do we then do with
the DT phy-mode property?) and we don't need some of the logic in
"net: phylink: use phy interface mode bitmaps".

Please note that it's been a number of months since I last looked at
this, so I may be rusty - it's also rediculously sweltering hot over
here in the UK right now, so I may not be thinking straight... (which
is probably why I forgot to reply to your above point.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
