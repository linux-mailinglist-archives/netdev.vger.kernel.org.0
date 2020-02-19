Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDFCA164D8C
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 19:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgBSSVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 13:21:37 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:54478 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbgBSSVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 13:21:36 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01JILIGk015406;
        Wed, 19 Feb 2020 12:21:18 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1582136478;
        bh=au41jVMNZVVyoK32FVyeoksJNT9R9w3OPUwvi6D1Si4=;
        h=From:To:CC:Subject:Date;
        b=pr/tai/MepQMv1hq/68bmruqZS4r2VeiJe5znF5PCGp5MFKwpT/0XQ9b6+h39BCYY
         btXqQ1zKR2cxPMdcg/NKYZ6sTDBrd519NNsSm78MNsYTnnPKeXq7MHuTRfpeRK6CAf
         Onw/xbYRDHYihDkmNttWWEbNuhtmSvTmlSSgV8V4=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01JILIM1065394
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Feb 2020 12:21:18 -0600
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 19
 Feb 2020 12:21:18 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 19 Feb 2020 12:21:18 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01JILILv036974;
        Wed, 19 Feb 2020 12:21:18 -0600
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>
CC:     <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <afd@ti.com>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-master] net: phy: dp83848: Add the TI TLK05/06 PHY ID
Date:   Wed, 19 Feb 2020 12:16:13 -0600
Message-ID: <20200219181613.5898-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the TLK05/06 PHY ID to the DP83848 driver.  The TI website indicates
that the DP83822 device is a drop in replacement for the TLK05 device
but the TLK device does not have WoL support.  The TLK device is
register compatible to the DP83848 and the DP83848 does not support WoL
either.  So this PHY can be associated with the DP83848 driver.

The initial TLKx PHY ID in the driver is a legacy ID and the public data
sheet indicates a new PHY ID.  So not to break any kernels out there
both IDs will continue to be supported in this driver.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/dp83848.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/dp83848.c b/drivers/net/phy/dp83848.c
index 54c7c1b44e4d..66907cfa816a 100644
--- a/drivers/net/phy/dp83848.c
+++ b/drivers/net/phy/dp83848.c
@@ -12,6 +12,7 @@
 #define TI_DP83620_PHY_ID		0x20005ce0
 #define NS_DP83848C_PHY_ID		0x20005c90
 #define TLK10X_PHY_ID			0x2000a210
+#define TLK105_06_PHY_ID		0x2000a211
 
 /* Registers */
 #define DP83848_MICR			0x11 /* MII Interrupt Control Register */
@@ -85,6 +86,7 @@ static struct mdio_device_id __maybe_unused dp83848_tbl[] = {
 	{ NS_DP83848C_PHY_ID, 0xfffffff0 },
 	{ TI_DP83620_PHY_ID, 0xfffffff0 },
 	{ TLK10X_PHY_ID, 0xfffffff0 },
+	{ TLK105_06_PHY_ID, 0xfffffff0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(mdio, dp83848_tbl);
@@ -115,6 +117,8 @@ static struct phy_driver dp83848_driver[] = {
 			   dp83848_config_init),
 	DP83848_PHY_DRIVER(TLK10X_PHY_ID, "TI TLK10X 10/100 Mbps PHY",
 			   NULL),
+	DP83848_PHY_DRIVER(TLK105_06_PHY_ID, "TI TLK105/06 10/100 Mbps PHY",
+			   NULL),
 };
 module_phy_driver(dp83848_driver);
 
-- 
2.25.0

