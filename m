Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598742D40DC
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 12:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730580AbgLILSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 06:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730484AbgLILSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 06:18:15 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D965DC0613D6
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 03:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=g5AdEpLv7O32lt5w5qUbtAUdKwiOShp0d/By1jAAmqo=; b=g6QYrjiKCDGE402d5frtqNIbF
        RzmMuSzuoJmfRf7wqivug7fK6kFtQgvAW2PVXgjME6BvF3CES2KkZ1zIDd2qRO1EwZ62VhD6M2KtV
        IfZSSS7uvREB3ep2SDxtZY5XY1cLJA4Zs/Ub4xLrKwfoYlDQH7oT1r7ELCIBscNh7YYD9rUJHx/NU
        YNVmZp98ciOaKnq1+Qi2EQ+XXwCSEhzHCfjN2L6mGLlGZd2yrGqQZ08Xc2tdUkv9Q7ti7sSk3k02U
        Yqumpz6KChQjWosf9V5suwb24u2GAhQJiTPGmWBS4Eli0sZkph6j3C/fMp6l3j/LCXgY9kFXkMek8
        tk/Mtb96g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41728)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kmxTR-0002IM-0H; Wed, 09 Dec 2020 11:17:33 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kmxTQ-0006yi-FW; Wed, 09 Dec 2020 11:17:32 +0000
Date:   Wed, 9 Dec 2020 11:17:32 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Subject: Re: [PATCH net-next 0/2] Add support for VSOL V2801F/CarlitoxxPro
 CPGOS03 GPON module
Message-ID: <20201209111732.GL1605@shell.armlinux.org.uk>
References: <20201204143451.GL1551@shell.armlinux.org.uk>
 <20201209111109.GR1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201209111109.GR1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oh, it's because Pali Rohar's name contains UTF-8 and I can't
encode that prior to sending the actual patches themselves.

Sorry, I'm going to have to have to limit to ASCII only in the
header lines when mailing list patches - scripting the encoding
for UTF-8 characters in shell is far from simple.

On Wed, Dec 09, 2020 at 11:11:09AM +0000, Russell King - ARM Linux admin wrote:
> Jakub,
> 
> What's happening with these patches?
> 
> If I'm getting the patchwork URLs correct, these patches seem not to
> appear in patchwork. They both went to netdev as normal and where
> accepted by vger from what I can see.
> 
> Thanks.
> 
> On Fri, Dec 04, 2020 at 02:34:52PM +0000, Russell King - ARM Linux admin wrote:
> > Hi,
> > 
> > This patch set adds support for the V2801F / CarlitoxxPro module. This
> > requires two changes:
> > 
> > 1) the module only supports single byte reads to the ID EEPROM,
> >    while we need to still permit sequential reads to the diagnostics
> >    EEPROM for atomicity reasons.
> > 
> > 2) we need to relax the encoding check when we have no reported
> >    capabilities to allow 1000base-X based on the module bitrate.
> > 
> > Thanks to Pali Rohár for responsive testing over the last two days.
> > 
> >  drivers/net/phy/sfp-bus.c | 11 ++++-----
> >  drivers/net/phy/sfp.c     | 63 +++++++++++++++++++++++++++++++++++++++++++----
> >  2 files changed, 63 insertions(+), 11 deletions(-)
> > 
> > -- 
> > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
> > 
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
