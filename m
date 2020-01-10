Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A71A013765E
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 19:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbgAJSuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 13:50:06 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:44550 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728676AbgAJSuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 13:50:05 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 00AInwX6001024;
        Fri, 10 Jan 2020 12:49:58 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1578682198;
        bh=YkLYeJEKlGhb+RCMV1xyuQRGPxl9AzfqwGb7FDoC+S4=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=QCWbK9/gbeqyLVKP1HoXCElowCSsSvhECLXWbVY7Kxamw3howfLITiLc+ufvqUVLa
         XlOZ5wUW9DUFkTNoXEE4066H1H433NPBvRqA85bQviemrlJQnp8veZGlSqNij+seqZ
         7r6R8PBU0rgLKnrii82YKylpQemCpJugciLc4smU=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 00AInwh6059088
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Jan 2020 12:49:58 -0600
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 10
 Jan 2020 12:49:57 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 10 Jan 2020 12:49:57 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00AInvsN088630;
        Fri, 10 Jan 2020 12:49:57 -0600
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH 4/4] net: phy: DP83822: Add support for additional DP83825 devices
Date:   Fri, 10 Jan 2020 12:47:02 -0600
Message-ID: <20200110184702.14330-5-dmurphy@ti.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200110184702.14330-1-dmurphy@ti.com>
References: <20200110184702.14330-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add PHY IDs for the DP83825CS, DP83825CM and the DP83825S devices to the
DP83822 driver.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/Kconfig   |  3 ++-
 drivers/net/phy/dp83822.c | 12 ++++++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 90c9297280d2..60700a62d74f 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -342,7 +342,8 @@ config DAVICOM_PHY
 config DP83822_PHY
 	tristate "Texas Instruments DP83822/825/826 PHYs"
 	---help---
-	  Supports the DP83822, DP83825I, DP83826C and DP83826NC PHYs.
+	  Supports the DP83822, DP83825I, DP83825CM, DP83825CS, DP83825S,
+	  DP83826C and DP83826NC PHYs.
 
 config DP83TC811_PHY
 	tristate "Texas Instruments DP83TC811 PHY"
diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index 5159b28baa0f..fe9aa3ad52a7 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/*
- * Driver for the Texas Instruments DP83822 PHY
+/* Driver for the Texas Instruments DP83822, DP83825 and DP83826 PHYs.
  *
  * Copyright (C) 2017 Texas Instruments Inc.
  */
@@ -15,7 +14,10 @@
 #include <linux/netdevice.h>
 
 #define DP83822_PHY_ID	        0x2000a240
+#define DP83825S_PHY_ID		0x2000a140
 #define DP83825I_PHY_ID		0x2000a150
+#define DP83825CM_PHY_ID	0x2000a160
+#define DP83825CS_PHY_ID	0x2000a170
 #define DP83826C_PHY_ID		0x2000a130
 #define DP83826NC_PHY_ID	0x2000a110
 
@@ -323,6 +325,9 @@ static struct phy_driver dp83822_driver[] = {
 	DP83822_PHY_DRIVER(DP83825I_PHY_ID, "TI DP83825I"),
 	DP83822_PHY_DRIVER(DP83826C_PHY_ID, "TI DP83826C"),
 	DP83822_PHY_DRIVER(DP83826NC_PHY_ID, "TI DP83826NC"),
+	DP83822_PHY_DRIVER(DP83825S_PHY_ID, "TI DP83825S"),
+	DP83822_PHY_DRIVER(DP83825CM_PHY_ID, "TI DP83825M"),
+	DP83822_PHY_DRIVER(DP83825CS_PHY_ID, "TI DP83825CS"),
 };
 module_phy_driver(dp83822_driver);
 
@@ -331,6 +336,9 @@ static struct mdio_device_id __maybe_unused dp83822_tbl[] = {
 	{ DP83825I_PHY_ID, 0xfffffff0 },
 	{ DP83826C_PHY_ID, 0xfffffff0 },
 	{ DP83826NC_PHY_ID, 0xfffffff0 },
+	{ DP83825S_PHY_ID, 0xfffffff0 },
+	{ DP83825CM_PHY_ID, 0xfffffff0 },
+	{ DP83825CS_PHY_ID, 0xfffffff0 },
 	{ },
 };
 MODULE_DEVICE_TABLE(mdio, dp83822_tbl);
-- 
2.23.0

