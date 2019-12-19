Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 918F9125ED6
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 11:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfLSKZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 05:25:06 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:60330 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbfLSKZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 05:25:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VAvUvT2CUeyqBVR/O046dkUQnxjf+FIUDQMz9CmRGPY=; b=p1K0K/IAVP5qF1ZrSuLhFUUdq
        44/bZNBCAgtIoVqVCGtx/60wrKE5S1s2IMS7RxTBSBgdRtNdLZJBRkhbba399wNRjmTldhAQqnQOZ
        1Uhpobnt3aBHK9umKdrr3hlwasf6KpNho96nyo8SXzU2t4AxJGk1QBn0RCoru5L9DwmErshyfcapu
        oegC3zKa4SljW/laij9bcYr8QjQLX5V/Bx6o+Nx9SnRGyW99v4r3vHqxmT1ed9A9Wb8uHOWldWaq/
        qKVu9i4p4bqNHVWdU6vpy9nYJnJU59eGobwb1fOxyToPuy5q+Cnb5cfEDnWS3MgG9Oy6+/WNFmhyh
        /CbR1JOGw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:50904)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ihszJ-0001sY-HD; Thu, 19 Dec 2019 10:24:57 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ihszI-0005IZ-37; Thu, 19 Dec 2019 10:24:56 +0000
Date:   Thu, 19 Dec 2019 10:24:56 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: ensure that phy IDs are correctly typed
Message-ID: <20191219102455.GA25745@shell.armlinux.org.uk>
References: <E1ihsvI-0001bz-3t@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ihsvI-0001bz-3t@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 10:20:48AM +0000, Russell King wrote:
> PHY IDs are 32-bit unsigned quantities. Ensure that they are always
> treated as such, and not passed around as "int"s.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Fixes: 13d0ab6750b2 ("net: phy: check return code when requesting PHY driver module")

> ---
>  drivers/net/phy/phy_device.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index daaeae5f2d96..68d4d49286d7 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -551,7 +551,7 @@ static const struct device_type mdio_bus_phy_type = {
>  	.pm = MDIO_BUS_PHY_PM_OPS,
>  };
>  
> -static int phy_request_driver_module(struct phy_device *dev, int phy_id)
> +static int phy_request_driver_module(struct phy_device *dev, u32 phy_id)
>  {
>  	int ret;
>  
> -- 
> 2.20.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
