Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154CF326A79
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 00:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhBZXor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 18:44:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:52336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229967AbhBZXop (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 18:44:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DE0164F0D;
        Fri, 26 Feb 2021 23:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614383044;
        bh=PA+ARLY/NpCug2D80GT4G+yYaBHM+KekBtHdFqKlK4k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GRPcd1ywmh5UHfCT/EMIUeztX6rfazR1I5D26XzI/wOPESmzhkSOCLQUUIEJ/vFQu
         0pkhdk0o97cjX/ibTX5X/EvGdHT1bG5E4Aak0/2dBIXRIbGWhjk7JcuHA+BOtqB7Ef
         G5R7l/S7J3PSTsEu05/JmXRql2i4EywvsGeKXkLErh84jMp7QhubUr2+0Rz3ALmG6l
         mBRvQG4f0ILOXAbI0xyMfrpmDXtsGlhZ/qPaZKjDqnOYrjf83sTYrownAPWncE4n+T
         s0r5V49hvDqFkvgVpD+f7vD6Sz2aG/aofmmkBvj2279HVTermaRLnVoaqgPXo6v4qx
         a0N05SvD4PqRQ==
Date:   Fri, 26 Feb 2021 15:44:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: make mdio_bus_phy_suspend/resume as
 __maybe_unused
Message-ID: <20210226154403.02550984@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YDgqYBmLFVWvKLX2@lunn.ch>
References: <20210225145748.404410-1-arnd@kernel.org>
        <YDgqYBmLFVWvKLX2@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Feb 2021 23:53:20 +0100 Andrew Lunn wrote:
> On Thu, Feb 25, 2021 at 03:57:27PM +0100, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > When CONFIG_PM_SLEEP is disabled, the compiler warns about unused
> > functions:
> > 
> > drivers/net/phy/phy_device.c:273:12: error: unused function 'mdio_bus_phy_suspend' [-Werror,-Wunused-function]
> > static int mdio_bus_phy_suspend(struct device *dev)
> > drivers/net/phy/phy_device.c:293:12: error: unused function 'mdio_bus_phy_resume' [-Werror,-Wunused-function]
> > static int mdio_bus_phy_resume(struct device *dev)
> > 
> > The logic is intentional, so just mark these two as __maybe_unused
> > and remove the incorrect #ifdef.
> > 
> > Fixes: 4c0d2e96ba05 ("net: phy: consider that suspend2ram may cut off PHY power")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
