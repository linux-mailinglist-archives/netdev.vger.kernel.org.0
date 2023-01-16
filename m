Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCC166CF2D
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 19:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjAPSyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 13:54:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjAPSyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 13:54:31 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACDB4ED2;
        Mon, 16 Jan 2023 10:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+9G8OHC7CPLaqNm9tobemDqrAtOL7+MTWGHz+pkwenE=; b=mC4mIgyxv5rSrGPBZrOOOBwF12
        VzVbMB3CzlsjsaxBB/LRrjQ3RHD+pGCuT1jtiC7gBb6o80XPg3pCM8RVjABZJdEtQXxsF0pCpkEm1
        osNkBf/HKI1b6FINh3ys7nJBH/ZGf6R2bwPW+PhpI2qu7b92u29ksxrjs8Dte3pCDbGvu/QBjTWRQ
        Sgn/iGnepSqmtRyptk+dz59KUpLWNuk9oKzAnLkk4YmU7fGaREarDqq9uoc4XWHdciGd7WDbpN+I1
        hn/kRjDtxIjzU90EIi+njfKT1xPjlyvPvgBFrdD5Ai8hkJaQAU0tV+Bgbh+0LwFVaL7KZULzY8UAR
        y2AmW3zg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36146)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pHUcV-0005hg-Mm; Mon, 16 Jan 2023 18:54:11 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pHUcP-0006F2-U2; Mon, 16 Jan 2023 18:54:05 +0000
Date:   Mon, 16 Jan 2023 18:54:05 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
Message-ID: <Y8WdTVU141f2L1R5@shell.armlinux.org.uk>
References: <Y8VmSrjHTlllaDy2@shell.armlinux.org.uk>
 <87bkmy33ph.fsf@miraculix.mork.no>
 <Y8Vt9vfEa4w8HXHQ@shell.armlinux.org.uk>
 <875yd630cu.fsf@miraculix.mork.no>
 <871qnu2ztz.fsf@miraculix.mork.no>
 <Y8WNxAQ6C6NyUUn1@shell.armlinux.org.uk>
 <87pmbe1hu0.fsf@miraculix.mork.no>
 <87lem21hkq.fsf@miraculix.mork.no>
 <Y8WT6GwMqwi8rBe7@shell.armlinux.org.uk>
 <87a62i1ge4.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87a62i1ge4.fsf@miraculix.mork.no>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 07:30:27PM +0100, Bjørn Mork wrote:
> "Russell King (Oracle)" <linux@armlinux.org.uk> writes:
> 
> > That all looks fine. However, I'm running out of ideas.
> 
> Thanks a lot for the effort in any case.  It's comforting that even the
> top experts can't figure out this one :-)
> 
> 
> > What we seem to have is:
> >
> > PHY:
> > VSPEC1_SGMII_CTRL = 0x34da
> > VSPEC1_SGMII_STAT = 0x000e
> >
> > The PHY is programmed to exchange SGMII with the host PCS, and it
> > says that it hasn't completed that exchange (bit 5 of STAT).
> >
> > The Mediatek PCS says:
> > BMCR = 0x1140		AN enabled
> > BMSR = 0x0008		AN capable
> > ADVERTISE = 0x0001	SGMII response (bit 14 is clear, hardware is
> > 			supposed to manage that bit)
> > LPA = 0x0000		SGMII received control word (nothing)
> > SGMII_MODE = 0x011b	SGMII mode, duplex AN, 1000M, Full duplex,
> > 			Remote fault disable
> >
> > which all looks like it should work - but it isn't.
> >
> > One last thing I can think of trying at the moment would be writing
> > the VSPEC1_SGMII_CTRL with 0x36da, setting bit 9 which allegedly
> > restarts the SGMII exchange. There's some comments in the PHY driver
> > that this may be needed - maybe it's necessary once the MAC's PCS
> > has been switched to SGMII mode.
> 
> 
> Tried that now.  Didn't change anything.  And still no packets.
> 
> root@OpenWrt:/# mdio mdio-bus 6:30 raw 8
> 0x34da
> root@OpenWrt:/# mdio mdio-bus 6:30 raw 9
> 0x000e
> root@OpenWrt:/# mdio mdio-bus 6:30 raw 8 0x36da
> root@OpenWrt:/# mdio mdio-bus 6:30 raw 8
> 0x34da
> root@OpenWrt:/# mdio mdio-bus 6:30 raw 9
> 0x000e

If bit 9 is indeed the restart-an bit, it will be self-clearing, so
I wouldn't expect a read back of it to change to 0x36da.

I guess next thing to try is clearing and setting the AN enable bit,
bit 12, so please try this:

mdio mdio-bus 6:30 raw 8 0x24da
mdio mdio-bus 6:30 raw 8 0x36da
mdio mdio-bus 6:30 raw 9

If that doesn't work, then let's try something a bit harder:

mdio mdio-bus 6:30 raw 8 0xb4da
mdio mdio-bus 6:30 raw 9

Please let me know the results from those.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
