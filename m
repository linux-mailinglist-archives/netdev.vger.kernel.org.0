Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5944D31D740
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 11:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhBQKFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 05:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbhBQKF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 05:05:26 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3AF5C061574;
        Wed, 17 Feb 2021 02:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sIy7gBsa1UBwDw3g43JgExgJM94EyjO03MD5xoq9r0g=; b=tTlU3WYEybTdZHgK0w4bBM0Zs
        MqtN89SS0fZWNalwN1CSjKYFJuyxBogX2NCP260JGDKIxsddOEdUn/UJH/r/fISWKQReNpcO0rRTP
        fLDS6NOuxllDbMVANekGSr29546tbBcxdACivCCp5I6PrjQycrM35OMtyZI8TEXVDjYxgVwTUA+44
        M8Z07ug/xizrZuexYszLWd67EESET5qSxR1tBrAfypRaI1D+h9Dy2goriSsJHPEGleIPrIQc50KMO
        kGNHFI9/69LVbZQyqftjrtKMqMaBrvD5Ojc9haFL1zqXO5zKRtLv2pF4KaBas8FiYzDizrMFMGssI
        zqFD2SG7Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44548)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lCJh0-0002Vw-Gm; Wed, 17 Feb 2021 10:04:22 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lCJgz-0003e1-0A; Wed, 17 Feb 2021 10:04:21 +0000
Date:   Wed, 17 Feb 2021 10:04:20 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: icplus: Call phy_restore_page() when
 phy_select_page() fails
Message-ID: <20210217100420.GD1463@shell.armlinux.org.uk>
References: <YCy1F5xKFJAaLBFw@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCy1F5xKFJAaLBFw@mwanda>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 09:17:59AM +0300, Dan Carpenter wrote:
> Smatch warns that there is a locking issue in this function:
> 
> drivers/net/phy/icplus.c:273 ip101a_g_config_intr_pin()
> warn: inconsistent returns '&phydev->mdio.bus->mdio_lock'.
>   Locked on  : 242
>   Unlocked on: 273
> 
> It turns out that the comments in phy_select_page() say we have to call
> phy_restore_page() even if the call to phy_select_page() fails.

It seems it's a total waste of time documenting functions...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
