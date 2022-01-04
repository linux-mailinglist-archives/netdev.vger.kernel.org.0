Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC16C484416
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 16:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbiADPCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 10:02:54 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50966 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234570AbiADPCw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 10:02:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=09yxHMawDZ1z7mKKYD6EvM/m9RBDRbBGLNGga/wkLxY=; b=Aq8VGdFksWWCYmQGjMkY3Yuauv
        48uEw3tJbJzwy+EIZA1QBynJF3WoUdUz/czXggGL0owr6v2Vxgc3+fEyWfducR71K7DIimCJ/k3hy
        77wlD4rNhTXO65wv3cxpmw2OCbCHIMFOL3aucbH553pMpe6jysyoKcO0T1C/JBcU7tgg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n4lKo-000TVw-0W; Tue, 04 Jan 2022 16:02:46 +0100
Date:   Tue, 4 Jan 2022 16:02:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        linus.walleij@linaro.org, ulli.kroll@googlemail.com,
        kuba@kernel.org, davem@davemloft.net, hkallweit1@gmail.com,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: net: phy: marvell: network working with generic PHY and not with
 marvell PHY
Message-ID: <YdRhlUR4ukwS5WMH@lunn.ch>
References: <YdQoOSXS98+Af1wO@Red>
 <YdQsJnfqjaFrtC0m@shell.armlinux.org.uk>
 <YdQwexJVfrdzEfZK@Red>
 <YdQydK4GhI0P5RYL@shell.armlinux.org.uk>
 <YdQ5i+//UITSbxS/@shell.armlinux.org.uk>
 <YdRVovG9mgEWffkn@Red>
 <YdRZQl6U0y19P/0+@shell.armlinux.org.uk>
 <YdRdu3jFPnGd1DsH@lunn.ch>
 <YdRgXbpK6CFB/eCU@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdRgXbpK6CFB/eCU@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > #define MII_88E1121_PHY_MSCR_RX_DELAY	BIT(5)
> > #define MII_88E1121_PHY_MSCR_TX_DELAY	BIT(4)
> > #define MII_88E1121_PHY_MSCR_DELAY_MASK	(BIT(5) | BIT(4))
> > 
> > Bits 6 is the MSB of the default MAC speed.
> > Bit 13 is the LSB of the default MAC speed. These two should default to 10b = 1000Mbps
> > Bit 12 is reserved, and should be written 1.
> 
> Hmm, seems odd that these speed bits match BMCR, and I'm not sure why
> the default MAC speed would have any bearing on whether gigabit mode
> is enabled. If they default to 10b, then the write should have no effect
> unless boot firmware has changed them.

There is a bit more, which is did not copy:

    Also, used for setting speed of MAC interface during MAC side
    loop-back. Requires that customer set both these bits and force
    speed using register 0 to the same speed.  MAC Interface Speed
    during Link down.

So i don't think they matter during normal operation.

   Andrew
