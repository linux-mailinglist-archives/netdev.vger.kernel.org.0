Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73AAD1270D3
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 23:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfLSWk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 17:40:58 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40872 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbfLSWk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 17:40:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SAC4B1vwEm/Go4KqaiBb5EEymWV9Egg6mJ7y8ZA4ZeE=; b=M3BnDtNv1rzeHdpQxuL/Fl2Zx
        zzzKG2zYax+nyfuOagZ/OsE60VBZy1Ch98XJs6aEbQjd010o1N5DJGA5J5uN66a15yIx0T8fq4JJX
        hLDXiSjtbiXIFkzXZCLhwtZD66hSbC2ithIH+40cA+M0Dugyc1apnVDVHBAITWNwDWTn9zMIrJX2D
        +R3u8+Z5k/JjFeFCwlC104HY5EuYl+fJ/z8Bai01cG2JxRliD1Yx6hwdRhE0UBIKU/h0nfTqjlq9w
        UvsMhJKF9edZHt//o3qeYGL5L4QqCg4toBCRErgBThLpaHVu7o4S83HLikJRT4UnN0eGT2pLgr7VL
        dj+39kyhw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55260)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ii4TT-0005At-7Q; Thu, 19 Dec 2019 22:40:51 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ii4TR-0005jm-0Z; Thu, 19 Dec 2019 22:40:49 +0000
Date:   Thu, 19 Dec 2019 22:40:48 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: ensure that phy IDs are correctly typed
Message-ID: <20191219224048.GH25745@shell.armlinux.org.uk>
References: <E1ihsvI-0001bz-3t@rmk-PC.armlinux.org.uk>
 <20191219210100.GQ17475@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219210100.GQ17475@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 10:01:00PM +0100, Andrew Lunn wrote:
> On Thu, Dec 19, 2019 at 10:20:48AM +0000, Russell King wrote:
> > PHY IDs are 32-bit unsigned quantities. Ensure that they are always
> > treated as such, and not passed around as "int"s.
> 
> Hi Russell
> 
> Do we want to fix all cases?
> 
> struct phy_device *phy_device_create(struct mii_bus *bus, int addr, int phy_id,

There's also the format specifier in phydev_err() - we already have
one instance where we case the u32 to unsigned long in order to get
a consistent type that is large enough to print without any issues.

Revised patch on its way.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
