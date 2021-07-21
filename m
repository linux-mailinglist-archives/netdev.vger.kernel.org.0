Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CB33D11DA
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 17:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239565AbhGUOX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 10:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239486AbhGUOWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 10:22:49 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7C5C061575;
        Wed, 21 Jul 2021 08:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=WaEaZLo99zKGArJnchsGd0Ac07YGVhjisSX1dpfpeSI=; b=zX+QUfarnn/fehC1ZfWAGOfLV
        blrCO/XHwuqrbighF8tOpVDqHqQaNclmDccY6c3gh9J3aiX4Qt3d7Yv5sQEdBAA9KQbwenKo2TNJn
        hnMSrRuDKQpotqEUtXVddkBDhnkupwutBzM3dmC+IP2YZe8vRtEjkvZlRfnj3i1nCpdC5bhpMwtkT
        nWhm+XhKfJqXKpS++Nk1/cvxfpYHooK1IYjn2vMYzLdhW1KnlTdIEe5kTIqS4TjF6K2nHi4ysXHsm
        y8ep21XcgiayhhxaFYu8vlVRJbz+fe1zl/ZlK2OWOl+NnqyqR0M72TNvAPThzKPIFNT1uwtIiSMuY
        dhGvwHwVg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46432)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1m6DkV-0007tl-8J; Wed, 21 Jul 2021 16:03:03 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1m6DkS-0008ND-OM; Wed, 21 Jul 2021 16:03:00 +0100
Date:   Wed, 21 Jul 2021 16:03:00 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Bauer <mail@david-bauer.net>,
        Michael Walle <michael@walle.cc>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Fabio Estevam <festevam@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: at803x: fix at803x_match_phy_id mismatch
Message-ID: <20210721150300.GA22278@shell.armlinux.org.uk>
References: <20210721150141.1737124-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721150141.1737124-1-arnd@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch already sent by Vladimir, and just applied.

On Wed, Jul 21, 2021 at 05:01:28PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> There are two conflicting patches in net-next, one removed
> the at803x_get_features() function and the other added another
> user:
> 
> drivers/net/phy/at803x.c: In function 'at803x_get_features':
> drivers/net/phy/at803x.c:706:14: error: implicit declaration of function 'at803x_match_phy_id' [-Werror=implicit-function-declaration]
> 
> Change the new caller over to an open-coded comparison as well.
> 
> Fixes: 8887ca5474bd ("net: phy: at803x: simplify custom phy id matching")
> Fixes: b856150c8098 ("net: phy: at803x: mask 1000 Base-X link mode")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/phy/at803x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index 0790ffcd3db6..bdac087058b2 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -703,7 +703,7 @@ static int at803x_get_features(struct phy_device *phydev)
>  	if (err)
>  		return err;
>  
> -	if (!at803x_match_phy_id(phydev, ATH8031_PHY_ID))
> +	if (phydev->drv->phy_id != ATH8031_PHY_ID)
>  		return 0;
>  
>  	/* AR8031/AR8033 have different status registers
> -- 
> 2.29.2
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
