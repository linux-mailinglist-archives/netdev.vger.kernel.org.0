Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375DE641F7F
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 21:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiLDUWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 15:22:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiLDUWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 15:22:52 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A0714019;
        Sun,  4 Dec 2022 12:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9jwAG3909Peo6UDO7woumSwTvJq5Wz3OnvO8JhZdm0E=; b=YQ8zx74NVEoDXO8ds3TOE31Orf
        tLJcFQZZ5c/RWvduKPuX2fk9TPPThTuFJQFHMWcr05ObOmLw0f2EmVqazi5wx8yic7EKAUaEdOPce
        l9v+nZa3a1mdPRH8+x4D1kt4Kx2psrGYYjprFTetSIJEm5Sz60Wci+6kwDYwgJ+OM/VPd1UwDsa7O
        hOFDzzC3pNAcBY9fjosIqu2X9b70XYuOFEu+cOElLo/J2kpDrOA7Zh7FP1si1rWlAokqu9R0JkS/B
        Axn4UqqkRw/gFMvTQDIlNWmqEuUm4jUOAOIHTwshQVswGP7fz3ujWrbiymMaoNc5z7l0kZvlPT2wc
        5vXn9thw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35570)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p1vVb-00064M-Ma; Sun, 04 Dec 2022 20:22:43 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p1vVY-0006Yc-Mi; Sun, 04 Dec 2022 20:22:40 +0000
Date:   Sun, 4 Dec 2022 20:22:40 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 4/4] driver/ncn26000: add PLCA support
Message-ID: <Y40BkLMOhk8qR2IC@shell.armlinux.org.uk>
References: <cover.1670119328.git.piergiorgio.beruto@gmail.com>
 <38623984f6235a1521e6b0ad2ea958abc84ad708.1670119328.git.piergiorgio.beruto@gmail.com>
 <Y4zTqvSxLJG+G8V+@shell.armlinux.org.uk>
 <Y4zreLCwdx+fyuCe@lunn.ch>
 <Y4z+ZKZh4c14mFzA@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4z+ZKZh4c14mFzA@gvm01>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 04, 2022 at 09:09:08PM +0100, Piergiorgio Beruto wrote:
> On Sun, Dec 04, 2022 at 07:48:24PM +0100, Andrew Lunn wrote:
> > On Sun, Dec 04, 2022 at 05:06:50PM +0000, Russell King (Oracle) wrote:
> > > On Sun, Dec 04, 2022 at 03:32:06AM +0100, Piergiorgio Beruto wrote:
> > > > --- a/include/uapi/linux/mdio.h
> > > > +++ b/include/uapi/linux/mdio.h
> > > > @@ -26,6 +26,7 @@
> > > >  #define MDIO_MMD_C22EXT		29	/* Clause 22 extension */
> > > >  #define MDIO_MMD_VEND1		30	/* Vendor specific 1 */
> > > >  #define MDIO_MMD_VEND2		31	/* Vendor specific 2 */
> > > > +#define MDIO_MMD_OATC14		MDIO_MMD_VEND2
> > > 
> > > If this is in the vendor 2 register set, I doubt that this is a feature
> > > described by IEEE 802.3, since they allocated the entirety of this MMD
> > > over to manufacturers to do whatever they please with this space.
> > > 
> > > If this is correct, then these definitions have no place being in this
> > > generic header file, since they are likely specific to the vendors PHY.
> > 
> > Piergiorgio can give you the full details.
> > 
> > As i understand it, IEEE 802.3 defines the basic functionality, but
> > did not extend the standard to define the registers.
> > 
> > The Open Alliance member got together and added the missing parts, and
> > published an Open Alliance document.
> > 
> > Piergiorgio, i suggest you add a header file for these defines, named
> > to reflect that the Open Alliance defined them. And put in a comment,
> > explaining their origin, maybe a link to the standard. I also don't
> > think this needs to be a uapi header, they are not needed outside of
> > the kernel.
> > 
> > I also would not use MDIO_MMD_OATC14, but rather MDIO_MMD_VEND2. There
> > is no guarantee they are not being used for other things, and
> > MDIO_MMD_VEND2 gives a gentle warning about this.
> Thanks Andrew for commenting on this one. This is right, in the IEEE
> 802.3cg group we could not allocate an MMD for the PLCA reconciliation
> sublayer because of an 'unfriendly' wording in Clause 45 ruling out
> Reconciliation Sublayers from what can be configured via registers.
> Clause 45 says you can have registers for the PHY, while it should have
> said 'Physical Layer" and there is a subtle difference between the two
> words. PLCA, for example, is part of the Physical Layer but not of the
> PHY. Since we could not change that wording, we had to define
> configuration parameters in Clause 30, and let organizations outside the
> IEEE define memory maps for PHYs that integrate PLCA.
> 
> The OPEN Alliance SIG (see the reference in the patches) defined
> registers for the PLCA RS in MMD31, which is in fact vendor-specific
> from an IEEE perspective, but part of it is now standardized in the OPEN
> Alliance. So unfortunately we have to live with this somehow.
> 
> So ok, I can separate these definitions into a different non-UAPI header
> as Andrew is suggesting. I'll do this in the next patchset.

Sounds like yet another clause 45 mess :(

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
