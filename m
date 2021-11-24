Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4028A45CE85
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 21:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245388AbhKXU74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 15:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244393AbhKXU7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 15:59:55 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C57C061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:56:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1c+yE5X1OmxKz2Cpf1JsSVeUGiy/bjJevgUp1875tQA=; b=YlHxr/RzP4y9sx+fJD+8yoJtXE
        7SJgCDKY3/8YFao9zV1pSrcb45NxcnFnm3R6GKmEFuBKLEDfsJ0nUIiB+dyH+sa2b82xIHEeqhFVJ
        GF+Sye/wbVAozGuqfx8GKxvULPqxgEVjR2mFxe3Yyp+MeXWtauObYpE+Y6m3eyrrL614tuGvduesZ
        0bAQBBkW2n36E60PrbJ1SYEJ463XlybtE15ZHTCrsjxlAru5NSQobKYFa6HHVU0qiOF9na+Grj0dj
        Ic36U8tsbx7DADDoGGrsuEKghy3k9xCBRYfN10XOz1EGQQYQmuzikXkeOfd4L2p5/rQRpc/agn6kL
        rgB1KxCg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55872)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mpzJj-0001DI-8B; Wed, 24 Nov 2021 20:56:35 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mpzJh-0001W5-1h; Wed, 24 Nov 2021 20:56:33 +0000
Date:   Wed, 24 Nov 2021 20:56:33 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH RFC net-next 03/12] net: dsa: replace
 phylink_get_interfaces() with phylink_get_caps()
Message-ID: <YZ6nAcp+CraITcHD@shell.armlinux.org.uk>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwRi-00D8L8-F1@rmk-PC.armlinux.org.uk>
 <20211124181507.cqlvv3bp46grpunz@skbuf>
 <YZ6D6GESyqbduFgz@shell.armlinux.org.uk>
 <YZ6OORjbKuz8eXD5@shell.armlinux.org.uk>
 <20211124202612.iyrq3dx7nefr5zzi@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124202612.iyrq3dx7nefr5zzi@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 08:26:13PM +0000, Vladimir Oltean wrote:
> On Wed, Nov 24, 2021 at 07:10:49PM +0000, Russell King (Oracle) wrote:
> > On Wed, Nov 24, 2021 at 06:26:48PM +0000, Russell King (Oracle) wrote:
> > > On Wed, Nov 24, 2021 at 06:15:08PM +0000, Vladimir Oltean wrote:
> > > > On Wed, Nov 24, 2021 at 05:52:38PM +0000, Russell King (Oracle) wrote:
> > > > > Phylink needs slightly more information than phylink_get_interfaces()
> > > > > allows us to get from the DSA drivers - we need the MAC capabilities.
> > > > > Replace the phylink_get_interfaces() method with phylink_get_caps() to
> > > > > allow DSA drivers to fill in the phylink_config MAC capabilities field
> > > > > as well.
> > > > > 
> > > > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > > > ---
> > > > 
> > > > The effects of submitting new API without any user :)
> > > 
> > > It had users at the time, but they were not submitted, and the addition
> > > of MAC capabilities was a future development. Had they been submitted at
> > > the time, then they would have required updating too.
> > 
> > That was a bit rushed... to explain more fully.
> > 
> > Prior to the merge window, the development work was centered around
> > only eliminating the PHY_INTERFACE_MODE_xxx checks and the complexity
> > that the PHY_INTERFACE_MODE_NA technique brought into the many
> > validation functions. Users of this had already been merged, and
> > included mvneta and mvpp2. See these commits, which are all in
> > v5.16-rc1:
> > 
> > b63f1117aefc net: mvpp2: clean up mvpp2_phylink_validate()
> > 76947a635874 net: mvpp2: drop use of phylink_helper_basex_speed()
> > 6c0c4b7ac06f net: mvpp2: remove interface checks in mvpp2_phylink_validate()
> > 8498e17ed4c5 net: mvpp2: populate supported_interfaces member
> > 
> > 099cbfa286ab net: mvneta: drop use of phylink_helper_basex_speed()
> > d9ca72807ecb net: mvneta: remove interface checks in mvneta_validate()
> > fdedb695e6a8 net: mvneta: populate supported_interfaces member
> > 
> > The original commit adding phylink_get_interfaces() extended this
> > into DSA, and the intention was to submit at least mv88e6xxx, but
> > it was too close to the merge window to do so.
> > 
> > Through making that change and eventually eliminating the basex helper
> > from all drivers that were using it, thereby making the validate()
> > behaviour much cleaner, it then became clear that it was possible to
> > push this cleanup further by also introducing a MAC capabilities field
> > to phylink_config.
> > 
> > The addition of the supported_interfaces member and the addition of the
> > mac_capabilities member are two entirely separate developments, but I
> > have now chosen to combine the two after the merge window in order to
> > reduce the number of patches. They were separate patches in my tree up
> > until relatively recently, and still are for the mt7530 and b53 drivers
> > currently.
> > 
> > So no, this is not "The effects of submitting new API without any user".
> > 
> > Thanks.
> 
> Ok, the patch is not the effect of submitting new API without any user.
> It is just the effect of more development done to API without any user,
> without any causal relationship between the two. My bad.

I do wonder whether you intentionally missed where I said "It had users
at the time, but they were not submitted". This is why we don't get on
well, you're always so confrontational.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
