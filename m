Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2315421A903
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 22:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgGIUbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 16:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgGIUbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 16:31:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C471DC08C5CE;
        Thu,  9 Jul 2020 13:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Koqd6kCw0kFF9cQ+B8QeO0El7U/kaG6Z8/n9tod5TOg=; b=IvgeTeN2x0f/Xu41dh0Jtt43E
        ab7TM2+A2KH+t+kIXz6OB22IIg/CDFop78jPS70LfusrdJQfLrVK4K42mg+fqKmbW0T9VqwasG526
        BC/ZzctqVt3zMj2EJCYZLtw6PUoA2ip4gRkjBxil/FBOrz0Rm3UI7HhzuJzGm8sqItDWz8L1/6jIz
        Jgt8Wh5eSbPHuNaLc0Yz1Uov0lIcnS5XcJMEZSVfozmjzoRi9rLN3XRX20ttGRmC/Skh7UMtA3Ndv
        81gTPavt8z8Eokby2ne6SXDkBRjmNPYNAtgRCbmF8Yy7fSdvprCxMKclacB/Zqx2WT7uMZvaOZRm7
        cH2Ipjsyg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37450)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jtdCj-0000xj-W6; Thu, 09 Jul 2020 21:31:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jtdCg-0002Xp-Gd; Thu, 09 Jul 2020 21:31:34 +0100
Date:   Thu, 9 Jul 2020 21:31:34 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Frank Wunderlich <frank-w@public-files.de>, netdev@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        linux-mediatek@lists.infradead.org,
        John Crispin <john@phrozen.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        linux-arm-kernel@lists.infradead.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v2] net: ethernet: mtk_eth_soc: fix mtu warning
Message-ID: <20200709203134.GI1551@shell.armlinux.org.uk>
References: <20200709055742.3425-1-frank-w@public-files.de>
 <20200709134115.GK928075@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200709134115.GK928075@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 03:41:15PM +0200, Andrew Lunn wrote:
> On Thu, Jul 09, 2020 at 07:57:42AM +0200, Frank Wunderlich wrote:
> > From: René van Dorst <opensource@vdorst.com>
> > 
> > in recent Kernel-Versions there are warnings about incorrect MTU-Size
> > like these:
> > 
> > mt7530 mdio-bus:00: nonfatal error -95 setting MTU on port x
> > eth0: mtu greater than device maximum
> > mtk_soc_eth 1b100000.ethernet eth0: error -22 setting MTU to include DSA overhead
> > 
> > Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
> > Fixes: 72579e14a1d3 ("net: dsa: don't fail to probe if we couldn't set the MTU")
> > Fixes: 7a4c53bee332 ("net: report invalid mtu value via netlink extack")
> > Signed-off-by: René van Dorst <opensource@vdorst.com>
> > Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> > ---
> > changes in v2:
> >   Fixes: tag show 12-chars of sha1 and moved above other tags
> > ---
> >  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > index 85735d32ecb0..00e3d70f7d07 100644
> > --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > @@ -2891,6 +2891,10 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
> >  	eth->netdev[id]->irq = eth->irq[0];
> >  	eth->netdev[id]->dev.of_node = np;
> > 
> > +	eth->netdev[id]->mtu = 1536;
> 
> Hi Frank
> 
> Don't change to MTU from the default. Anybody using this interface for
> non-DSA traffic expects the default MTU. DSA will change it as needed.
> 
> > +	eth->netdev[id]->min_mtu = ETH_MIN_MTU;
> 
> No need to set the minimum. ether_setup() will initialize it.
> 
> > +	eth->netdev[id]->max_mtu = 1536;
> 
> I assume this is enough to make the DSA warning go away, but it is the
> true max? I have a similar patch for the FEC driver which i should
> post sometime. Reviewing the FEC code and after some testing, i found
> the real max was 2K - 64.

Are there any plans to solve these warnings for Marvell 88e6xxx DSA ports?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
