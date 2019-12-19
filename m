Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65743125EC0
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 11:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfLSKU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 05:20:56 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:60264 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfLSKUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 05:20:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xb5nNcfB+UjT/RaHF85kryTHYmv3MjijD0vxX5n0CGo=; b=yroAKF1zg89+UXuitEv5T+O5c1
        iwufdOGt4vCSCu8Kw4oT52GCroUcra7gbRIZ8bQevgQWLSqegyuWUNNTJow0z3At7b0FfiEi9VXtC
        MQZCZxe0w9wYpL3IMY1btBLtVrVATUnlJ90rg3Q8qCPDG80HMItEpNR4c3bYMIxNPmoRdFujblsNb
        p7TpO7phc8fxXgakbZ5XscWhl2WpqMIfLV8x7JVGPmjnwbd+yXjdGEVwjKslQT9BIxz7jWempeNKk
        9EgYcGbul39ptdhQGghNqwZ2Al8HHA1yehKP8TrlmsNr8w5ol2UQ+4b+WCkwKOZC92NQ2F+8eifVk
        KcE/whYA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:45230 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihsvJ-0001qe-8F; Thu, 19 Dec 2019 10:20:49 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihsvI-0001bz-3t; Thu, 19 Dec 2019 10:20:48 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] net: phy: ensure that phy IDs are correctly typed
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ihsvI-0001bz-3t@rmk-PC.armlinux.org.uk>
Date:   Thu, 19 Dec 2019 10:20:48 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PHY IDs are 32-bit unsigned quantities. Ensure that they are always
treated as such, and not passed around as "int"s.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index daaeae5f2d96..68d4d49286d7 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -551,7 +551,7 @@ static const struct device_type mdio_bus_phy_type = {
 	.pm = MDIO_BUS_PHY_PM_OPS,
 };
 
-static int phy_request_driver_module(struct phy_device *dev, int phy_id)
+static int phy_request_driver_module(struct phy_device *dev, u32 phy_id)
 {
 	int ret;
 
-- 
2.20.1

