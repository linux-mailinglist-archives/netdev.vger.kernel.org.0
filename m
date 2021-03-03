Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD1E32C496
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445402AbhCDAPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238239AbhCCSFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 13:05:33 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9CAC061756;
        Wed,  3 Mar 2021 10:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=My/MoKrMBRtOg8zhU/75Schf078+7/DO6AlXtF8wtwY=; b=HrMUjp3hfvQhqfw0sFwKn4ACS
        T7MUr/tsEmTP/kX0/QWn4OjpZKtNvoxf8PEL0IGYI9Nku9th986oQ7GB7Z+ztqd7QCQQTVNKqQH6k
        RgSkYBzZsky8hNAJo1Auwf2PB5iN5NtyFxFK1v/l9aj+dpWABPZC7w7c30b8JE+0CCnI9fQTxjWIT
        xEomqmMDAH4c3WoW67jqt9QRCZU4QJhPAuCAGu6qMtGPEcFLkRSSMorWGc1bDhXkX3m1bn/S2lkVc
        qzDR1wmK6IWMdUW/74q1Fgtlep//yAXkWtMO3l9OKsU0ppMzFDQi83uzBy0q90Pmpe621BpNpMcaB
        jqkFwcRGw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48582)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lHVrE-0006E5-NR; Wed, 03 Mar 2021 18:04:24 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lHVrC-0002YO-N9; Wed, 03 Mar 2021 18:04:22 +0000
Date:   Wed, 3 Mar 2021 18:04:22 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH drivers/net] #ifdef mdio_bus_phy_suspend() and
 mdio_bus_phy_suspend()
Message-ID: <20210303180422.GB1463@shell.armlinux.org.uk>
References: <20210303175338.GA15338@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210303175338.GA15338@paulmck-ThinkPad-P72>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 03, 2021 at 09:53:38AM -0800, Paul E. McKenney wrote:
> drivers/net: #ifdef mdio_bus_phy_suspend() and mdio_bus_phy_suspend()
> 
> The following build error is emitted by rcutorture builds of v5.12-rc1:
> 
> drivers/net/phy/phy_device.c:293:12: warning: ‘mdio_bus_phy_resume’ defined but not used [-Wunused-function]
> drivers/net/phy/phy_device.c:273:12: warning: ‘mdio_bus_phy_suspend’ defined but not used [-Wunused-function]
> 
> The problem is that these functions are only used by SIMPLE_DEV_PM_OPS(),
> which creates a dev_pm_ops structure only in CONFIG_PM_SLEEP=y kernels.
> Therefore, the mdio_bus_phy_suspend() and mdio_bus_phy_suspend() functions
> will be used only in CONFIG_PM_SLEEP=y kernels.  This commit therefore
> wraps them in #ifdef CONFIG_PM_SLEEP.

Arnd submitted a patch that Jakub has applied which fix these warnings
in a slightly different way. Please see
20210225145748.404410-1-arnd@kernel.org

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
