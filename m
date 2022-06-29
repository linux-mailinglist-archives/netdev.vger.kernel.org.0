Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C7F55FC58
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbiF2Jno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 05:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiF2Jnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:43:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE042C649
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 02:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/0f0mtJY9AEVyG9cKutPtOpi9e0QBZowrNf+7r5nfHQ=; b=O9hU6gJ9Cm4QGif7+OHrsFDoK+
        N/KBHkiZetFbU6fRkM9mVr+ZJDjpRl1uY4+K8BwYbSCtQa2aIlYQnOXYtLUXUoSLDVGiOmsMbyGYM
        FRUPpwwozk6IL/xCy5unJV3tFKyKdGjo7OYe1v0lXKOU8lXaW9HvrCo6b6thTguKKxq568CdAeetI
        d0nVHqbCcyJytKISetWwFzETW+gWwCV/BLQAAcG03nsqC4F9nYxpFG+jCGAunenoOikYbS3XNi7UE
        UlTQcM3HG4dId4ZLIa84KSbtddqTKDJ23OQvD0crkGcnKJDdAbwiTkLpdgGWHRUuWOOjXiYA7plM9
        WzN3CBXw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33086)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o6UEI-0002mF-Ue; Wed, 29 Jun 2022 10:43:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o6UEF-0005ki-OW; Wed, 29 Jun 2022 10:43:23 +0100
Date:   Wed, 29 Jun 2022 10:43:23 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH RFC net-next 0/4] net: dsa: always use phylink
Message-ID: <YrweuzL2LYNbfvAY@shell.armlinux.org.uk>
References: <YrWi5oBFn7vR15BH@shell.armlinux.org.uk>
 <YrtvoRhUK+4BneYC@shell.armlinux.org.uk>
 <Yrv8snvIChmoNPwh@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yrv8snvIChmoNPwh@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 09:18:10AM +0200, Andrew Lunn wrote:
> > I should point out that if a DSA port can be programmed in software to
> > support both SGMII and 1000baseX, this will end up selecting SGMII
> > irrespective of what the hardware was wire-strapped to and how it was
> > initially configured. Do we believe that would be acceptable?
> 
> I'm pretty sure the devel b board has 1000BaseX DSA links between its
> two switches. Since both should end up SGMII that should be O.K.

Would such a port have a programmable C_Mode, and would it specify that
it supports both SGMII and 1000BaseX ? Without going through a lot of
boards and documentation for every switch, I can't say.

I don't think we can come to any conclusion on what the right way to
deal with this actually is - we don't have enough information about how
this is used across all the platforms we have. I think we can only try
something, get it merged into net-next, and wait to see whether anyone
complains.

When we have a CPU or DSA port without a fixed-link, phy or sfp specified,
I think we should:
(a) use the phy-mode property if present, otherwise,
(b,i) have the DSA driver return the interface mode that it wants to use
for max speed for CPU and DSA ports.
(b,ii) in the absence of the DSA driver returning a valid interface mode,
we use the supported_interfaces to find an interface which gives the
maximum speed (irrespective of duplex?) that falls within the
mac capabilities.

If all those fail, then things will break, and we will have to wait for
people to report that breakage. Does this sound a sane approach, or
does anyone have any other suggestions how to solve this?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
