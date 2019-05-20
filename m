Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6F423BF1
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 17:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391494AbfETPVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 11:21:44 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:48922 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731389AbfETPVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 11:21:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=XAMWyt6V6y7UA5xa4YOe7lYuFmkkQIW6KUQ1NFyZKNY=; b=0HKDyMoZx3t73mCQoXEtVSOWr
        W/83R7tihLrSs6GWkt+xFqd8tssFv5KrdFyu+uIyxRwzTO7pW8ljY491ZwZILgY2zZs/+ysaCdIYY
        2CqPVbjXsX98FzujWJi0Gs2Vu09s8cGr+UJByRfN1aV+KqT3B63oqHBkWO65ioIUnfmqb7UfRgv0p
        UWhzj1djncOc1bHJfbR5kinApwXvGK9FjLsIhFEyqXuHw4fglOpQz7EkAiJ1rsEzo7wITLoXuynvu
        1v7Ot7fPU3hIIpZgvo6i5RUxW9EknxuyMm1mnwuA2bOlNjkiAXEOPylLqJJkWbfgPZuh0Sbxf+gyo
        Qt0MSN3kw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52548)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hSk6a-0003ab-5d; Mon, 20 May 2019 16:21:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hSk6Y-00051d-87; Mon, 20 May 2019 16:21:34 +0100
Date:   Mon, 20 May 2019 16:21:34 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/4] phylink/sfp updates
Message-ID: <20190520152134.qyka5t7c2i7drk4a@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I realise that net-next probably isn't open yet, but I believe folk
will find these patches "interesting" so I'm sending them to share
them with people working on this code, rather than expecting them to
be picked up this week.

The first patch adds support for using interrupts when using a GPIO
for link status tracking, rather than polling it at one second
intervals.  This reduces the need to wakeup the CPU every second.

The second patch adds support to the MII ioctl API to read and write
Clause 45 PHY registers.  I don't know how desirable this is for
mainline, but I have used this facility extensively to investigate
the Marvell 88x3310 PHY.

There have been discussions about removing "netdev" from phylink.
The last two patches remove netdev from the sfp code, which would be
a necessary step in that direction.

 drivers/net/phy/phy.c     | 33 ++++++++++++++++++++--------
 drivers/net/phy/phylink.c | 55 +++++++++++++++++++++++++++++++++++++++++------
 drivers/net/phy/sfp-bus.c | 14 +++++-------
 include/linux/sfp.h       | 12 +++++++----
 4 files changed, 86 insertions(+), 28 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
