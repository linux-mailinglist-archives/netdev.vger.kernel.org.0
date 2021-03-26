Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC9634A3B4
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 10:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhCZJH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 05:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbhCZJHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 05:07:46 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC288C0613AA
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 02:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Yynoo5MZdC2W7+mVwmD5pliZXlXEXpfUOkHbGHCvLrg=; b=yRm4szfFv6F4LcZxaxgS6vZIl
        Q6AmoJKX4QcELIZ6aBRi3XCYCRzo+ThVs3A3ZPXTcizneDNjgpiF0HoZaA0+wdeuTc3n6WZnb3iHM
        L4IdLn7LAOLdKEFfjORxTeexVYANY9Tr02cIoFrHnPe4yDpoHSBqaBD8jc2pRvIjg1D5tF5reBIEX
        f+q3CtXNCm5cybyGskQ1d8U8OaGT/JXYaXddMtsv8HKKpSUWfBMFYpmbBpp6D9OOg9FcMnoG5kOSz
        1RiXACJ9zORLX7jNzPSbkL8S9q8kCGYosyFzNgMk5tPPPSOZG04L6bsnPLot9fEgw6yoJQnFEm5bP
        Z/1icPB5Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51788)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lPiRL-0005Qv-QQ; Fri, 26 Mar 2021 09:07:35 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lPiRK-00070E-Gw; Fri, 26 Mar 2021 09:07:34 +0000
Date:   Fri, 26 Mar 2021 09:07:34 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, kuba@kernel.org
Subject: Re: [PATCH net-next v2 11/12] net: phy: marvell10g: print exact model
Message-ID: <20210326090734.GP1463@shell.armlinux.org.uk>
References: <20210325131250.15901-1-kabel@kernel.org>
 <20210325131250.15901-12-kabel@kernel.org>
 <20210325155452.GO1463@shell.armlinux.org.uk>
 <20210325212905.3d8f8b39@thinkpad>
 <418e86fb-dd7b-acbb-e648-1641f06b254b@gmail.com>
 <20210325215414.23fffe6c@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210325215414.23fffe6c@thinkpad>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 09:54:14PM +0100, Marek Behún wrote:
> On Thu, 25 Mar 2021 21:44:21 +0100
> Heiner Kallweit <hkallweit1@gmail.com> wrote:
> 
> > On 25.03.2021 21:29, Marek Behún wrote:
> > > On Thu, 25 Mar 2021 15:54:52 +0000
> > > Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> > >   
> > >> The 88X3310 and 88X3340 can be differentiated by bit 3 in the revision.
> > >> In other words, 88X3310 is 0x09a0..0x09a7, and 88X3340 is
> > >> 0x09a8..0x09af. We could add a separate driver structure, which would
> > >> then allow the kernel to print a more specific string via standard
> > >> methods, like we do for other PHYs. Not sure whether that would work
> > >> for the 88X21x0 family though.  
> > > 
> > > According to release notes it seems that we can also differentiate
> > > 88E211X from 88E218X (via bit 3 in register 1.3):
> > >  88E211X has 0x09B9
> > >  88E218X has 0x09B1
> > > 
> > > but not 88E2110 from 88E2111
> > >     nor 88E2180 from 88E2181.
> > > 
> > > These can be differentiated via register
> > >   3.0004.7
> > > (bit 7 of MDIO_MMD_PCS.MDIO_SPEED., which says whether device is capable
> > >  of 5g speed)
> > >   
> > 
> > If the PHY ID's are the same but you can use this register to
> > differentiate the two versions, then you could implement the
> > match_phy_device callback. This would allow you to have separate
> > PHY drivers. This is just meant to say you have this option, I don't
> > know the context good enough to state whether it's the better one.
> 
> Nice, didn't know about that. But I fear whether this would always work
> for the 88X3310 vs 88X3310P, it is possible that this feature is only
> recognizable if the firmware in the PHY is already running.

The ID registers aren't programmable and contain the proper IDs even if
there isn't firmware loaded (I've had such a PHY here.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
