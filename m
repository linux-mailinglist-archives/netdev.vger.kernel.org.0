Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A303A6692
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbhFNMbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbhFNMba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 08:31:30 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AAEAC061574
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 05:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CYuIHF0T+b+/KoeFeu3HuaXS+reF8n/pa4hZBHRoCCA=; b=F9yuvg1E6OCpaYVw4mi8ngCdE
        /7Sb88u2ZNskCofK+1CLaQQGtoudMewRkYyTEyyETWBLcD46SW22IhY6o2cQGjsdY5cmwMxP+qEvU
        jhS7KGMSCe1Enrk5nRetb44q9zFk1raxn1DXBET+xI+5SQFnTRU0XV7BVaCJ02KruHsWOM69Jsjt7
        vTP5rQTMlQL85si4b3wnZaLvmpuq9igFowPX4uiRXw3ehNA4FIPOj0qyYei1zumZeA5No/yBe9OUj
        U2spTIZw44oLo6kI0ZbLKYnqGENxSzjYUAd9jNOQq6Q6+AIvLb5GJnuFrS86AyR4MJzD6TzjH2Ebs
        fec+MpoEw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45000)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lsliT-0004F7-71; Mon, 14 Jun 2021 13:29:21 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lsliR-00046y-Ir; Mon, 14 Jun 2021 13:29:19 +0100
Date:   Mon, 14 Jun 2021 13:29:19 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 3/3] net: phy: nxp-c45-tja11xx: enable MDIO
 write access to the master/slave registers
Message-ID: <20210614122919.GR22278@shell.armlinux.org.uk>
References: <20210614121849.437119-1-olteanv@gmail.com>
 <20210614121849.437119-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614121849.437119-4-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 03:18:49PM +0300, Vladimir Oltean wrote:
> diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
> index 118b393b1cbb..b4dc112d4881 100644
> --- a/drivers/net/phy/nxp-c45-tja11xx.c
> +++ b/drivers/net/phy/nxp-c45-tja11xx.c
> @@ -1035,6 +1035,9 @@ static int nxp_c45_config_init(struct phy_device *phydev)
>  		return ret;
>  	}
>  
> +	phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x01F8, 1);
> +	phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x01F9, 2);

I think this deserves a comment - especially since the code uses numeric
values here.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
