Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFCF1C8FF9
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 16:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgEGOgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 10:36:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55690 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728381AbgEGOgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 10:36:36 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jWhbb-0004ZE-4U; Thu, 07 May 2020 14:34:31 +0000
From:   Colin King <colin.king@canonical.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Oleksij Rempel <linux@rempel-privat.de>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: phy: fix less than zero comparison with unsigned variable val
Date:   Thu,  7 May 2020 15:34:30 +0100
Message-Id: <20200507143430.50507-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The unsigned variable val is being checked for an error by checking
if it is less than zero. This can never occur because val is unsigned.
Fix this by making val a plain int.

Addresses-Coverity: ("Unsigned compared against zero")
Fixes: bdbdac7649fa ("ethtool: provide UAPI for PHY master/slave configuration.")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/phy/phy_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 83fc8e1b5793..c3a107cf578e 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1948,7 +1948,7 @@ static int genphy_setup_master_slave(struct phy_device *phydev)
 static int genphy_read_master_slave(struct phy_device *phydev)
 {
 	int cfg, state;
-	u16 val;
+	int val;
 
 	if (!phydev->is_gigabit_capable) {
 		phydev->master_slave_get = MASTER_SLAVE_CFG_UNSUPPORTED;
-- 
2.25.1

