Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17773A58B0
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 15:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhFMN3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 09:29:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53613 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbhFMN3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 09:29:48 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lsQ9M-0002Rk-D3; Sun, 13 Jun 2021 13:27:40 +0000
From:   Colin King <colin.king@canonical.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: phy: micrel: remove redundant assignment to pointer of_node
Date:   Sun, 13 Jun 2021 14:27:40 +0100
Message-Id: <20210613132740.73854-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The pointer of_node is being initialized with a value that is never
read and it is being updated later with a new value inside a do-while
loop. The initialization is redundant and can be removed and the
pointer dev is no longer required and can be removed too.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/phy/micrel.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index a14a00328fa3..93cf9500728f 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -488,8 +488,7 @@ static int ksz9021_load_values_from_of(struct phy_device *phydev,
 
 static int ksz9021_config_init(struct phy_device *phydev)
 {
-	const struct device *dev = &phydev->mdio.dev;
-	const struct device_node *of_node = dev->of_node;
+	const struct device_node *of_node;
 	const struct device *dev_walker;
 
 	/* The Micrel driver has a deprecated option to place phy OF
@@ -711,8 +710,7 @@ static int ksz9031_config_rgmii_delay(struct phy_device *phydev)
 
 static int ksz9031_config_init(struct phy_device *phydev)
 {
-	const struct device *dev = &phydev->mdio.dev;
-	const struct device_node *of_node = dev->of_node;
+	const struct device_node *of_node;
 	static const char *clk_skews[2] = {"rxc-skew-ps", "txc-skew-ps"};
 	static const char *rx_data_skews[4] = {
 		"rxd0-skew-ps", "rxd1-skew-ps",
@@ -907,8 +905,7 @@ static int ksz9131_config_rgmii_delay(struct phy_device *phydev)
 
 static int ksz9131_config_init(struct phy_device *phydev)
 {
-	const struct device *dev = &phydev->mdio.dev;
-	struct device_node *of_node = dev->of_node;
+	struct device_node *of_node;
 	char *clk_skews[2] = {"rxc-skew-psec", "txc-skew-psec"};
 	char *rx_data_skews[4] = {
 		"rxd0-skew-psec", "rxd1-skew-psec",
-- 
2.31.1

