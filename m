Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD4F14C91E
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 11:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgA2K5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 05:57:14 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38948 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgA2K5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 05:57:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/ZFMtqqol7eFnZfCWpoSSjEmgXpVt9jrMtqoDKVehag=; b=pvIxPeo7+9fmKM0RXNZHct4lS
        p/1nkNvglrNo+JfaXQEH06zg+kVUYUx0svw3KLbyEL3BJH4wl3kzwQF5zQB+EbxpDFO1S1u+6GWUj
        ebWsOVzNLWYrYNmIOZ5iOi5NPrqRRGSLIWM7HJ++1IZmmONFwiGw4v0YqGdl4iqxxs4GKUGqVL/tf
        d758KfAs4h6NOtfHwL0uspbLlA3CcKuppkNfIfxrvsCMobbSRrkA2VrIfAmUeQKyeVJXV/ehVryAv
        62SL2GRBDiIJYmkMY9Jv4y3oQnKPFbXB8CxmfvL68qA73dwSZPV2+gdgYuLX1sIckb2dlRCwblcIp
        biNGe5WsA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44848)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iwl1r-0004wG-Rg; Wed, 29 Jan 2020 10:57:04 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iwl1o-0003Kr-I2; Wed, 29 Jan 2020 10:57:00 +0000
Date:   Wed, 29 Jan 2020 10:57:00 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ykaukab@suse.de" <ykaukab@suse.de>
Subject: Re: [PATCH net-next 1/2] net: phy: aquantia: add rate_adaptation
 indication
Message-ID: <20200129105700.GF25745@shell.armlinux.org.uk>
References: <1579701573-6609-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1579701573-6609-2-git-send-email-madalin.bucur@oss.nxp.com>
 <68921c8a-06b6-d5c0-e857-14e7bc2c0a94@gmail.com>
 <DB8PR04MB6985606F38572D8512E8D27EEC0F0@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <77e3ddcb-bddb-32d8-9c87-48ba9a7f2773@gmail.com>
 <CA+h21hq7U_EtetuLZN5rjXcq+cRUoD0y_76LxuHpoC53J70CEQ@mail.gmail.com>
 <DB8PR04MB6985139D4ABED85B701445A9EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <CA+h21hpSpgQsQ0kRmSaC2qfmFj=0KadDjwEK2Bvkz72g+iGxBQ@mail.gmail.com>
 <DB8PR04MB6985B0A712634DCFCD5390A4EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB6985B0A712634DCFCD5390A4EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 29, 2020 at 10:53:03AM +0000, Madalin Bucur (OSS) wrote:
> Meanwhile, a real issue is that in the current design, the
> ethernet driver needs to remove modes that are invalid from the PHY
> advertising, but needs to refrain from doing that when coupled with
> a PHY that does rate adaptation. This bit provides just an indication
> of that ability.

That should be phylink's job, not the ethernet driver.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
