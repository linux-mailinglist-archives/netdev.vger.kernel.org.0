Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A49307B38
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 17:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbhA1Qlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 11:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232655AbhA1QlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 11:41:21 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17B4C061574;
        Thu, 28 Jan 2021 08:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IgLKMIHvPUsI5zslyWKJePRUZ8hujDrhZLqTi4Dvd3Y=; b=fq8rlOT/6xIlLR2u/rhBooz06
        Wt1ta3iLTSJK0QixGBc7B22AnR0Qd98C5t1ghF87/T2t/r6/0KGozlEy/j6lS4qXitgf7iE42AV0j
        VMhlF7GoOIS5OAAPutNUyRJXqFlqcMEQuzwtGfn432ewPskUHig7jGnH6VKbPqPNHJQYQrQ9Erv/i
        NzCikQltxQatXzgW1aqtT3RC+QAIzMbZxfiW0kJve0UUhidbibiefjuHx8nwIKNI6JHJqTSClMcRx
        w7GZd/O3S0MluVNsmTu9TbkqjhQc8OnSTq+Gc5mVO+X/Aii7wW+xDQeYgmtYBUP76T0lEA86f1nSv
        /qsY6e58g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53858)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l5ALG-0006s8-GW; Thu, 28 Jan 2021 16:40:22 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l5ALE-0005yW-8A; Thu, 28 Jan 2021 16:40:20 +0000
Date:   Thu, 28 Jan 2021 16:40:20 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        David Miller <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>, Andrew Lunn <andrew@lunn.ch>,
        Antoine Tenart <atenart@kernel.org>
Subject: Re: [EXT] Re: [PATCH v4 net-next 10/19] net: mvpp2: add FCA RXQ non
 occupied descriptor threshold
Message-ID: <20210128164019.GR1551@shell.armlinux.org.uk>
References: <1611747815-1934-1-git-send-email-stefanc@marvell.com>
 <1611747815-1934-11-git-send-email-stefanc@marvell.com>
 <CAF=yD-Lohx+1DRijK5=qgTj0uctBkS-Loh20zrMF7_Ditb2+pQ@mail.gmail.com>
 <CO6PR18MB3873573FA21D4B82A32948B3B0BB9@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB3873573FA21D4B82A32948B3B0BB9@CO6PR18MB3873.namprd18.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 06:41:32PM +0000, Stefan Chulski wrote:
> 
>  >
> > > From: Stefan Chulski <stefanc@marvell.com>
> > >
> > > RXQ non occupied descriptor threshold would be used by Flow Control
> > > Firmware feature to move to the XOFF mode.
> > > RXQ non occupied threshold would change interrupt cause that polled by
> > > CM3 Firmware.
> > > Actual non occupied interrupt masked and won't trigger interrupt.
> > 
> > Does this mean that this change enables a feature, but it is unused due to a
> > masked interrupt?
> 
> Firmware poll RXQ non occupied cause register to indicate if number of registers bellow threshold.
> We do not trigger any interrupt, just poll this bit in CM3. So this cause always masked.

The functional spec for A8040 says that the register at 0xF2005520
is "RX Exceptions Interrupt Mask" and the bit description talks about
it controlling interrupt signal generation. However, the bit that
allows RX Exceptions to be raised in MVPP2_ISR_RX_TX_MASK_REG is clear,
so it won't proceed beyond the next level up.

So, I think the commit description needs to say something like:

"The firmware needs to monitor the RX Non-occupied descriptor bits for
 flow control to move to XOFF mode. These bits need to be unmasked to
 be functional, but they will not raise interrupts as we leave the
 RX exception summary bit in MVPP2_ISR_RX_TX_MASK_REG clear."

I think that's essentially what you're trying to describe - please
change if not.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
