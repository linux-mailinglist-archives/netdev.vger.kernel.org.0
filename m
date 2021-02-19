Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDCC31F87C
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 12:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhBSLh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 06:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbhBSLh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 06:37:56 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E10CC061574;
        Fri, 19 Feb 2021 03:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CvYM9Xv/GTgYHR498cfIR4pFKJC4ax2Wjc7Cx2QMJf8=; b=WDqN3KxIEiOBH0eonvQFNCT3t
        EkvonffqzDJZ+p11BexcQ3QC5Vl0wpeCx99iLOVlAtjS7g2Pm9T2QHMzKOhvUly+DGG0Ihitd++zk
        W4Z8D3GYfWd6dai1EO3pCXo4brczKBfqEewWtOEzwtMaNPNOrOP8RqPk/NcnB7qtsKjCzP0b1ZQ/w
        KUBSd/8IMNPQaRMehTJNZkHrMVsVBPHgS8PXdcgu4AueXvNOeN/q2+HFa5VIYWWz4Cdhe9WMjtAyQ
        4sEci3QHSgxWOGB7KtrDDA1OuUMFab/nrtAvzYeLu8uhEsdufLGtn/PeOewMzJwzwDIVqSWgc5SAo
        U2AjfNKcA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45424)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lD45X-0004Ag-5l; Fri, 19 Feb 2021 11:36:47 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lD45U-0007T8-Fs; Fri, 19 Feb 2021 11:36:44 +0000
Date:   Fri, 19 Feb 2021 11:36:44 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: phy: icplus: call phy_restore_page()
 when phy_select_page() fails
Message-ID: <20210219113644.GK1463@shell.armlinux.org.uk>
References: <YC+OpFGsDPXPnXM5@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YC+OpFGsDPXPnXM5@mwanda>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 19, 2021 at 01:10:44PM +0300, Dan Carpenter wrote:
> The comments to phy_select_page() say that "phy_restore_page() must
> always be called after this, irrespective of success or failure of this
> call."  If we don't call phy_restore_page() then we are still holding
> the phy_lock_mdio_bus() so it eventually leads to a dead lock.
> 
> Fixes: 32ab60e53920 ("net: phy: icplus: add MDI/MDIX support for IP101A/G")
> Fixes: f9bc51e6cce2 ("net: phy: icplus: fix paged register access")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks.
-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
