Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F1C2C220E
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 10:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731475AbgKXJtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 04:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728886AbgKXJtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 04:49:19 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC83C0613D6
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 01:49:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wWnhMX8z2TZm6R/eePyUTOLI0uVQfiq552roOfXPs1A=; b=m2UNpRTTJ9a1uyAYYLBsKLteN
        GREBFJHepoAysNWf5aOCNy3nL3auOL5qsOfzL3f5SAK9+hSws+1Pa7YBIdiL0DI3iD0ptjW2nuCCy
        hZ4nDL3IzUeJevIUQbVhSyxgNNRQnBCl1wTcDU+3CsKeFqUVhjIikGtS2czM+hnAki2jXooEUbxE5
        KK2OvO+0e0i71OYNsYr26muPFNCBo+GAHLQLLcDas67qtQEazQIITmaxrWftzI4keVOZGMeQSfMB1
        Tm0SiKOcDdVdv/uMrEQGzN2pqxOTQcw8gnjn3cs9jVzS0FaSzCGi2ksfwWccmBiRnVs4v3bJFC3fy
        Ifn5GN1BQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35436)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1khUwn-0007R0-LW; Tue, 24 Nov 2020 09:49:17 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1khUwm-0007F5-WD; Tue, 24 Nov 2020 09:49:17 +0000
Date:   Tue, 24 Nov 2020 09:49:16 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: sfp: add debugfs support
Message-ID: <20201124094916.GD1551@shell.armlinux.org.uk>
References: <E1khJyS-0003UU-9O@rmk-PC.armlinux.org.uk>
 <20201124001431.GA2031446@lunn.ch>
 <20201124084151.GA722671@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124084151.GA722671@shredder.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 10:41:51AM +0200, Ido Schimmel wrote:
> On Tue, Nov 24, 2020 at 01:14:31AM +0100, Andrew Lunn wrote:
> > On Mon, Nov 23, 2020 at 10:06:16PM +0000, Russell King wrote:
> > > Add debugfs support to SFP so that the internal state of the SFP state
> > > machines and hardware signal state can be viewed from userspace, rather
> > > than having to compile a debug kernel to view state state transitions
> > > in the kernel log.  The 'state' output looks like:
> > > 
> > > Module state: empty
> > > Module probe attempts: 0 0
> > > Device state: up
> > > Main state: down
> > > Fault recovery remaining retries: 5
> > > PHY probe remaining retries: 12
> > > moddef0: 0
> > > rx_los: 1
> > > tx_fault: 1
> > > tx_disable: 1
> > > 
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > 
> > Hi Russell
> > 
> > This looks useful. I always seem to end up recompiling the kernel,
> > which as you said, this should avoid.
> 
> FWIW, another option is to use drgn [1]. Especially when the state is
> queried from the kernel and not hardware. We are using that in mlxsw
> [2][3].

Presumably that requires /proc/kcore support, which 32-bit ARM doesn't
have.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
