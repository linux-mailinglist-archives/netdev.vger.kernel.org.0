Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396D12F092D
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 20:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbhAJTCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 14:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbhAJTCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 14:02:18 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5E2C061794;
        Sun, 10 Jan 2021 11:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=FCzH69y8BHSD5Rxht8f0nb3b2A710HT3Yu3fDqBOYEc=; b=CNTTHGDC451kBE/uOUoLn7A8f
        PvGpc8RyXMcbQWO91zYMT1l1zQ6XaYwOSwrI3h9sCdzUWRsmuUBQUxRcZBGHdvy3K+2E1q535lY5b
        +37DXzMBz/eMIraDQE2zceimwCIGaAdn/4uQQ4XvwU0tWzmvjZ+a6+/PjvSGD24HsW977CDhgPoMi
        pvlT1ULdH3zn4Pbakthd7VjIpRKpHQj/eepcVQowBhXV8Brt1tuA6EKw1f+ZVd8k0aMJs0YEwxxdL
        z7CVH4Q5RC5AcGkJ+3oEYTQ4rBi2cdAz4pGGpj5pamTxsYl3k7wxjPOFT0NiuSz6GUtkZFR6fhxgW
        JS6icAxaQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46284)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kyfxo-00068Q-I4; Sun, 10 Jan 2021 19:01:20 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kyfxm-0004Sc-Tk; Sun, 10 Jan 2021 19:01:18 +0000
Date:   Sun, 10 Jan 2021 19:01:18 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: Re: [EXT] Re: [PATCH RFC net-next  00/19] net: mvpp2: Add TX Flow
 Control support
Message-ID: <20210110190118.GP1551@shell.armlinux.org.uk>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <20210110181727.GK1551@shell.armlinux.org.uk>
 <CO6PR18MB38737A567187B2BBAFACFF6AB0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB38737A567187B2BBAFACFF6AB0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 06:55:11PM +0000, Stefan Chulski wrote:
> > > not connected to the GOP flow control generation mechanism.
> > > To solve this issue Armada has firmware running on CM3 CPU dedectated
> > > for Flow Control support. Firmware monitors Packet Processor resources
> > > and asserts XON/XOFF by writing to Ports Control 0 Register.
> > 
> > What is the minimum firmware version that supports this?
> > 
> 
> Support were added to firmware about two years ago. 
> All releases from 18.09 should has it.

Please add that vital bit of information somewhere appropriate.
I would not be surprised if people are still running e.g. 17.10
on some of their Armada 8040 boards. My Macchiatobin which is
acting as a server currently has 17.10, although I plan to upgrade
it to 18.12 in about three to six months time, once I've well and
truely proven that my ext4 problems are resolved.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
