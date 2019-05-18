Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41AB622399
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 16:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbfEROPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 10:15:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38947 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727594AbfEROPO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 May 2019 10:15:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vxxOG4cgMteauDySbGtDK/NXhJ11L9YPT09u3ikHPG4=; b=mOGxjCQaZiIvy9wAyAvWyfhMjY
        HmsxsRwgpnHZipAOZiVubrnBmMNdz65OgrOMQstQFUuvakotatlwLgxkTjyJCKG3/+77ERCGsp2QU
        lM9XpB8h1RUS6Am+pqGxLVm4WqkdfCkVlSSooVLBt3+4lSToOK+SWc64rgoDPBLNr+jo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hS06y-0006Ek-HJ; Sat, 18 May 2019 16:14:56 +0200
Date:   Sat, 18 May 2019 16:14:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Subject: Re: [PATCH V5] net: phy: tja11xx: Add TJA11xx PHY driver
Message-ID: <20190518141456.GK14298@lunn.ch>
References: <20190517235123.32261-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517235123.32261-1-marex@denx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 18, 2019 at 01:51:23AM +0200, Marek Vasut wrote:
> Add driver for the NXP TJA1100 and TJA1101 PHYs. These PHYs are special
> BroadRReach 100BaseT1 PHYs used in automotive.

Hi Marek

> +	}, {
> +		PHY_ID_MATCH_MODEL(PHY_ID_TJA1101),
> +		.name		= "NXP TJA1101",
> +		.features       = PHY_BASIC_T1_FEATURES,

One thing i would like to do before this patch goes in is define
ETHTOOL_LINK_MODE_100baseT1_Full_BIT in ethtool.h, and use it here.
We could not do it earlier because were ran out of bits. But with
PHYLIB now using bitmaps, rather than u32, we can.

Once net-next reopens i will submit a patch adding it.

I also see in the data sheet we should be able to correct detect its
features using register 15. So we should extend
genphy_read_abilities(). That will allow us to avoid changing
PHY_BASIC_T1_FEATURES and possibly breaking backwards compatibility of
other T1 PHY which currently say they are plain 100BaseT.

      Andrew
