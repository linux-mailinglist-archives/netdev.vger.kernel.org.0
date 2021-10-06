Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90FBC423D97
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 14:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238491AbhJFMUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 08:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238471AbhJFMUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 08:20:43 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A11C061749
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 05:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gYQ0Am+jpqhDlV/+FdxBNLGDxV7amI54MtGKJ4Mopec=; b=ldBsmoB4mu10si1U/3AjSPQIvY
        rFSKwLa/qKJmPe/bunqXX0kVnp+f/Mbv8Zkx9USliYq7NI0LfDekYuIdOjFG1aqsP2OCQ+J87/NYh
        QxG9TpvYsjL3QTv575SfMuOzy5PI8M1MTArkoq3spzDgYL6xf83kaCtrCwEEP56EKtYkMxJMQ9ebh
        6wf+HHrSa4NI9sCasbQM/SJrAXrl7/gFXgSRIcuKFGI/9ADFFLMOOuS6pNA+fVkPAbwB66WoM7ZlG
        sDDWLeWMVDUaaxFIwA+psAByMVQdjeuYa5SDjLkzJAuw8dQZD0rk9jW46DVFyYO/vQfD67bjW0hO5
        y5tBrXBw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54978)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mY5si-0001L1-HK; Wed, 06 Oct 2021 13:18:44 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mY5sf-0000yI-Jw; Wed, 06 Oct 2021 13:18:41 +0100
Date:   Wed, 6 Oct 2021 13:18:41 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] Add mdiobus_modify_changed() helper
Message-ID: <YV2UIa2eU+UjmWaE@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Sean Anderson's recent patch series is introducing more read-write
operations on the MDIO bus that only need to happen if a change is
being made.

We have similar logic in __mdiobus_modify_changed(), but we didn't
add its correponding locked variant mdiobus_modify_changed() as we
had very few users. Now that we are getting more, let's add the
helper.

v2: fix build warnings in patch2, add Andrew's RB to patch 1

 drivers/net/phy/mdio_bus.c | 22 ++++++++++++++++++++++
 drivers/net/phy/phylink.c  | 29 ++++-------------------------
 include/linux/mdio.h       |  2 ++
 3 files changed, 28 insertions(+), 25 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
