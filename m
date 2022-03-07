Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A71D4D03D1
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 17:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239370AbiCGQQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 11:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244079AbiCGQQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 11:16:40 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154BF47074;
        Mon,  7 Mar 2022 08:15:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646669741; x=1678205741;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qMFXxfhvtEnIeHrpQBvOSvU8Z2F1O4k3USLqBd25jWw=;
  b=dT9iv/NUJcpYQfYv70qbQvuJ42w9L5RlqzqxhkT9WWx+yMEBfq62lgWV
   AQNxHFZgiycmisehThV7wbwTx4w4OesT0CePgVACmTE25k2bCFL4BJT5v
   wbsF/ZMLycptxotasr0u61xwzCCsAp8LttEZF31N3gdcuZiSl9Gc3n7l+
   yP92wx3EZonlyDAjC5UfN4Cg2PZ18lM5ILtaz4w4uuniVbTP6VEvSzp3c
   Nk10p/HmcZIidGJu74VBKpCDl8ES+90nGVv5dRQ0ch6LdHf2yMyFJIG2U
   Xi2QcEdS7o7+eH/6Z62YvXCSLAghSbonCRH4Ac5Mn57+ClMa9Q1L9mKzN
   g==;
X-IronPort-AV: E=Sophos;i="5.90,162,1643698800"; 
   d="scan'208";a="164797058"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Mar 2022 09:15:41 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 7 Mar 2022 09:15:41 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 7 Mar 2022 09:15:37 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next 2/2] net: phy: lan87xx: use genphy_read_master_slave in read_status
Date:   Mon, 7 Mar 2022 21:45:15 +0530
Message-ID: <20220307161515.14970-3-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220307161515.14970-1-arun.ramadoss@microchip.com>
References: <20220307161515.14970-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To read the master slave configuration of the LAN87xx T1 phy, used the
generic phy driver genphy_read_master_slave function. Removed the local
lan87xx_read_master_slave function.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/microchip_t1.c | 30 +-----------------------------
 1 file changed, 1 insertion(+), 29 deletions(-)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index 8292f7305805..389df3f4293c 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -674,34 +674,6 @@ static int lan87xx_cable_test_get_status(struct phy_device *phydev,
 	return 0;
 }
 
-static int lan87xx_read_master_slave(struct phy_device *phydev)
-{
-	int rc = 0;
-
-	phydev->master_slave_get = MASTER_SLAVE_CFG_UNKNOWN;
-	phydev->master_slave_state = MASTER_SLAVE_STATE_UNKNOWN;
-
-	rc = phy_read(phydev, MII_CTRL1000);
-	if (rc < 0)
-		return rc;
-
-	if (rc & CTL1000_AS_MASTER)
-		phydev->master_slave_get = MASTER_SLAVE_CFG_MASTER_FORCE;
-	else
-		phydev->master_slave_get = MASTER_SLAVE_CFG_SLAVE_FORCE;
-
-	rc = phy_read(phydev, MII_STAT1000);
-	if (rc < 0)
-		return rc;
-
-	if (rc & LPA_1000MSRES)
-		phydev->master_slave_state = MASTER_SLAVE_STATE_MASTER;
-	else
-		phydev->master_slave_state = MASTER_SLAVE_STATE_SLAVE;
-
-	return rc;
-}
-
 static int lan87xx_read_status(struct phy_device *phydev)
 {
 	int rc = 0;
@@ -720,7 +692,7 @@ static int lan87xx_read_status(struct phy_device *phydev)
 	phydev->pause = 0;
 	phydev->asym_pause = 0;
 
-	rc = lan87xx_read_master_slave(phydev);
+	rc = genphy_read_master_slave(phydev);
 	if (rc < 0)
 		return rc;
 
-- 
2.33.0

