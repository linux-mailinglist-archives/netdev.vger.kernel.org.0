Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBEDB614E86
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 16:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbiKAPm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 11:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbiKAPmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 11:42:54 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5961A22D
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 08:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rJQhR5L4U+fNykBEC3w37wasXjF1knve+lJjIPSMeJA=; b=RUwjt6KCun5bSl1KupnPB+Hw55
        8Cs9Uz1h9UcVaOnCQweLzPSGLmZo182u3gtjj8F2mp9xWRoJEBab7GXLNz+HOYKaVPx/HiYVYFL4P
        Pz7sKaJ3X1skjbMuuVV1UlUUPno1Jfz1N+HCPnvxjyauo1Z9kAKsSNBaR9hLLazxOEv+rTJZi4d+6
        53FV5NzNb0exUQ0C2xvvOd0UtmamXIf609SbugdamMtsnhuELey0jZhbkzuA4GIKp/dk1FwRn0s01
        6iJglvsWADH1uEkhw5+nuCHJm+srGXUo+TH7mBhW/YbA1uhD44kghg198wS0RF0kaieaJLaLA7FbM
        ltlTOoBQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35070)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1optPd-0004EJ-Lm; Tue, 01 Nov 2022 15:42:49 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1optPa-0006Yj-Tr; Tue, 01 Nov 2022 15:42:46 +0000
Date:   Tue, 1 Nov 2022 15:42:46 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 4/4] net: dsa: remove phylink_validate() method
Message-ID: <Y2E+dvH+zk1/QPpB@shell.armlinux.org.uk>
References: <20221101114806.1186516-1-vladimir.oltean@nxp.com>
 <20221101114806.1186516-5-vladimir.oltean@nxp.com>
 <Y2EKnLt2SyhjvcNI@shell.armlinux.org.uk>
 <20221101124035.tqlmxvyrqpaqn63h@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101124035.tqlmxvyrqpaqn63h@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 12:40:36PM +0000, Vladimir Oltean wrote:
> On Tue, Nov 01, 2022 at 12:01:32PM +0000, Russell King (Oracle) wrote:
> > On Tue, Nov 01, 2022 at 01:48:06PM +0200, Vladimir Oltean wrote:
> > > Not all DSA drivers provide config->mac_capabilities, for example
> > > mv88e6060, lan9303 and vsc73xx don't. However, there have been users of
> > > those drivers on recent kernels and no one reported that they fail to
> > > establish a link, so I'm guessing that they work (somehow). But I must
> > > admit I don't understand why phylink_generic_validate() works when
> > > mac_capabilities=0. Anyway, these drivers did not provide a
> > > phylink_validate() method before and do not provide one now, so nothing
> > > changes for them.
> > 
> > There is a specific exception:
> > 
> > When config->mac_capabilities is zero, and there is no phylink_validate()
> > function, dsa_port_phylink_validate() becomes a no-op, and the no-op
> > case basically means "everything is allowed", which is how things worked
> > before the generic validation was added, as you will see from commit
> > 5938bce4b6e2 ("net: dsa: support use of phylink_generic_validate()").
> > 
> > Changing this as you propose below will likely break these drivers.
> > 
> > A safer change would be to elimate ds->ops->phylink_validate, leaving
> > the call to phylink_generic_validate() conditional on mac_capabilities
> > having been filled in - which will save breaking these older drivers.
> 
> Yes, this is correct, thanks; our emails crossed.
> 
> Between keeping a no-op phylink_validate() for these drivers and filling
> in mac_capabilities for them, to remove this extra code path in DSA,
> what would be preferred?

My stance has always been - if we don't know the answer to a question
that affects a code path in a way we want to, we can't modify that code
path. That said:

> The 3 drivers I mentioned could all get a blanket MAC_10 | MAC_100 |
> MAC1000FD | MAC_ASYM_PAUSE | MAC_SYM_PAUSE to keep advertising what they
> did, even if this may or may not be 100% correct (lan9303 and mv88e6060
> are not gigabit, and I don't know if they do flow control properly), but
> these issues are not new.

Would almost be no different from what we do today. The exception would
be the lack of 1000HD, which I think should be included even though it
isn't common - because currently it will be included.

I also think that if we're going down this route and putting code to set
those capabilities in the DSA drivers, they need to be accompanied with
a comment stating that they are a guess and may not be correct.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
