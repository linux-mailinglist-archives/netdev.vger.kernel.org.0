Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0F82CBDAF
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 14:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgLBNEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 08:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgLBNEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 08:04:06 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD2DC0613D4
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 05:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=eOZ7z5velyq5bdei6VCUp1fW8vdaBjNCQa7/5Sefxkw=; b=OyZ7gq3Nord0cyzxriWovXAwp
        w1Vd/AgQXUXCSMgnpy0ML22Um1g2vUVZrp69hel61eadkD0D7q+tzdYSrexit8sw/foKRoinkNdGY
        cEms4U6jcRjmlR4Mc9r3OBtNKw7f/6JeJwHV0wC2w9rTZGsqUU8yLKTWebLW9JXt/a4ycd55QiSg3
        8hKrMuUmD29gMBdn8e0gjumpoqp51S+Yy09TUPlKP6IYMksx+lhXsF/S//At3nJDlSifoQJfXuXVc
        8eR0Q7lEJUAQAlbjowU2C++acinBdD9HNUS+/GYbE7lcVpat0zHjlDegSY5jFM1mDn2R53aTH07w3
        8OOl1NYmw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38834)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kkRmx-0001VQ-JI; Wed, 02 Dec 2020 13:03:19 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kkRmw-000734-7N; Wed, 02 Dec 2020 13:03:18 +0000
Date:   Wed, 2 Dec 2020 13:03:18 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@idosch.org>
Subject: Re: [PATCH net-next] net: sfp: add debugfs support
Message-ID: <20201202130318.GD1551@shell.armlinux.org.uk>
References: <E1khJyS-0003UU-9O@rmk-PC.armlinux.org.uk>
 <20201124001431.GA2031446@lunn.ch>
 <20201124084151.GA722671@shredder.lan>
 <20201124094916.GD1551@shell.armlinux.org.uk>
 <20201124104640.GA738122@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124104640.GA738122@shredder.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub,

What's your opinion on this patch? It seems to have stalled...

Regards,
Russell

On Tue, Nov 24, 2020 at 12:46:40PM +0200, Ido Schimmel wrote:
> On Tue, Nov 24, 2020 at 09:49:16AM +0000, Russell King - ARM Linux admin wrote:
> > On Tue, Nov 24, 2020 at 10:41:51AM +0200, Ido Schimmel wrote:
> > > On Tue, Nov 24, 2020 at 01:14:31AM +0100, Andrew Lunn wrote:
> > > > On Mon, Nov 23, 2020 at 10:06:16PM +0000, Russell King wrote:
> > > > > Add debugfs support to SFP so that the internal state of the SFP state
> > > > > machines and hardware signal state can be viewed from userspace, rather
> > > > > than having to compile a debug kernel to view state state transitions
> > > > > in the kernel log.  The 'state' output looks like:
> > > > > 
> > > > > Module state: empty
> > > > > Module probe attempts: 0 0
> > > > > Device state: up
> > > > > Main state: down
> > > > > Fault recovery remaining retries: 5
> > > > > PHY probe remaining retries: 12
> > > > > moddef0: 0
> > > > > rx_los: 1
> > > > > tx_fault: 1
> > > > > tx_disable: 1
> > > > > 
> > > > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > > 
> > > > Hi Russell
> > > > 
> > > > This looks useful. I always seem to end up recompiling the kernel,
> > > > which as you said, this should avoid.
> > > 
> > > FWIW, another option is to use drgn [1]. Especially when the state is
> > > queried from the kernel and not hardware. We are using that in mlxsw
> > > [2][3].
> > 
> > Presumably that requires /proc/kcore support, which 32-bit ARM doesn't
> > have.
> 
> Yes, it does seem to be required for live debugging. I mostly work with
> x86 systems, I guess it's completely different for Andrew and you.
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
