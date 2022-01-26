Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26AE049C6E8
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 10:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239421AbiAZJzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 04:55:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiAZJzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 04:55:37 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39C6C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 01:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=V8Uqobix5AjhwcCsMkdZlxgySGKpMgvXrCqwp7f4jIE=; b=OFQ2r9Rv9k1+6yjKTg5rruRSU/
        FaiXH+keA6pqHDBj4Uk7/VvJuUiM1BpBr7dqrUA523EXe4ZWSbhBk+cgPjww7neZZPz6jydgs5njF
        4i8CR9EsRnZ2irZeeH49CM+Ryhr2U1TmrFBweqjX8oA2XvIlj0WMMdORTx43s8dfP+xX/7hTp7m7H
        x3+ny3q+Xb4/GNHUTIlH/JFOY8ApXpwdfF8R0I/FKtcbEoRxdQXR/H098BLqPRcw6dzU4VE/QbyVm
        BGw3cdgjqaRSwIGWiI/i2TrfxMkIVcWnmKgC02CCUa2Cd1cwcAcvSLsaDAuupu265gJNz68F4KOg6
        DjPO6WNQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56872)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nCf1L-00035P-6b; Wed, 26 Jan 2022 09:55:19 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nCf17-0004Mp-RT; Wed, 26 Jan 2022 09:55:05 +0000
Date:   Wed, 26 Jan 2022 09:55:05 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/7] net: stmmac/xpcs: convert to pcs_validate()
Message-ID: <YfEaeaES8w7PmB0n@shell.armlinux.org.uk>
References: <YfAnkuhiMoeFcVnb@shell.armlinux.org.uk>
 <E1nCOs4-005LSp-HF@rmk-PC.armlinux.org.uk>
 <20220125105303.2025dfae@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125105303.2025dfae@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 10:53:03AM -0800, Jakub Kicinski wrote:
> On Tue, 25 Jan 2022 16:40:40 +0000 Russell King (Oracle) wrote:
> > stmmac explicitly calls the xpcs driver to validate the ethtool
> > linkmodes. This is no longer necessary as phylink now supports
> > validation through a PCS method. Convert both drivers to use this
> > new mechanism.
> > 
> > Tested-by: Wong Vee Khee <vee.khee.wong@linux.intel.com> # Intel EHL            Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> 
> Sign-offs got scrambled.

Grumble. Never used to happen when I used MicroEMACS, but seems to be a
regular occurence when using vim - because it's pretty much impossible
to see wrapped lines in vim, especially when they have the perfect
amount of white space at the end of the previous line.

> Transient warning from here to patch 6:
> 
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:943:22: warning: unused variable 'priv' [-Wunused-variable]
>         struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
>                             ^

Thanks, v2 will be on its way with both of the above fixed.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
