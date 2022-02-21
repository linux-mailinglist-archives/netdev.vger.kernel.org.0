Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59BA94BDFB0
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380916AbiBUQjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 11:39:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380780AbiBUQjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 11:39:11 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09FE24586
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 08:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GDYY8EK9xWQsxzUZhFXXEc31b4QdlfHWLCU5vZo7Cjo=; b=a2ConA7rAS04MTNpzkHJ7hpaJS
        dJ+lpdGUJaVWX+ycGB2Lo5KsoMUqNp3PdUWwsF+/Q1uB/UkfzBzROJJ7Z62h9KzUr8kbpeOfKza80
        vpWqg1SlsOjfwsZ+zxxQsmUpLDFc7LaMMkdN/ZhQgrb5XK3e44zUujSJH73y6Yp3RQXeSTfWELSvg
        7QBcv2B1CId2MzNZImnwpQFzi26RtzCIdlr96+bKMIOfmoTjUL8TQIFWtqDSGTgbcNmfo15UEr9CS
        vh5oHXOxsUms3zW1RhyY0tnIPJnhoLiE00FWEVrL+xT4YJPNrrkQmB8+4PpDLEzIyESmvWrhEiFoR
        VKX5F8ew==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57396)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nMBhu-0000ei-KV; Mon, 21 Feb 2022 16:38:38 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nMBhr-0007Rg-Il; Mon, 21 Feb 2022 16:38:35 +0000
Date:   Mon, 21 Feb 2022 16:38:35 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v2 1/6] net: dsa: add support for phylink
 mac_select_pcs()
Message-ID: <YhPACwMPz22FmpWz@shell.armlinux.org.uk>
References: <Yg6UHt2HAw7YTiwN@shell.armlinux.org.uk>
 <E1nKlY3-009aKs-Oo@rmk-PC.armlinux.org.uk>
 <20220219211241.beyajbwmuz7fg2bt@skbuf>
 <20220219212223.efd2mfxmdokvaosq@skbuf>
 <YhOT4WbZ1FHXDHIg@shell.armlinux.org.uk>
 <20220221143254.3g3iqysqkqrfu5rm@skbuf>
 <YhOlUtcr7CQunM6M@shell.armlinux.org.uk>
 <20220221145540.ek375azxukz3nrvj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221145540.ek375azxukz3nrvj@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 04:55:40PM +0200, Vladimir Oltean wrote:
> On Mon, Feb 21, 2022 at 02:44:34PM +0000, Russell King (Oracle) wrote:
> > > *and as I haven't considered, to be honest. When phylink_major_config()
> > > gets called after a SGMII to 10GBaseR switchover, and mac_select_pcs is
> > > called and returns NULL, the current behavior is to keep working with
> > > the PCS for SGMII. Is that intended?
> > 
> > It was not originally intended, but as a result of the discussion
> > around this patch which didn't go anywhere useful, I dropped it as
> > a means to a path of least resistance.
> > 
> > https://patchwork.kernel.org/project/linux-arm-kernel/patch/E1mpSba-00BXp6-9e@rmk-PC.armlinux.org.uk/
> 
> Oh, but that patch didn't close exactly this condition that we're
> talking about here, did it? It allows phylink_set_pcs() to be called
> with NULL, but phylink_major_config() still has the non-NULL check,
> which prevents it from having any effect in this scenario:
> 
> 	/* If we have a new PCS, switch to the new PCS after preparing the MAC
> 	 * for the change.
> 	 */
> 	if (pcs)
> 		phylink_set_pcs(pl, pcs);
> 
> I re-read the conversation and I still don't see this argument being
> given, otherwise I wouldn't have opposed...

The reason for that condition above is to avoid disrupting the case
where drivers which do not (yet) provide a mac_select_pcs()
implementation (therefore  pcs will be NULL here) but instead register
their PCS by calling phylink_set_pcs() immediately after a call to
phylink_create(). If the above call to phylink_set_pcs() was
unconditional, then:

1) it would break these existing drivers,
2) we would definitely need to make phylink_set_pcs() safe to call
   with a NULL pcs argument to avoid crashing when in e.g. pcs-less
   modes.

If that usage was eliminated, then the problem goes away... but that
means changing drivers, and changing drivers is always a long hard
slog that takes months and several kernel cycles to do.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
