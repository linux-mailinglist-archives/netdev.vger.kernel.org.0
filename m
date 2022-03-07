Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB1C4CFC1D
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 11:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234987AbiCGK74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 05:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbiCGK5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 05:57:41 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71C4B1AB1;
        Mon,  7 Mar 2022 02:18:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646648308; x=1678184308;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MF4bSZAjSpcDs7XroNbwBWFR0D4m2/1zQ1gUexWfA9w=;
  b=Sft0QAgjBDgieXlDDqukQx7M0j/nfCng60Y8jIj9aYYI9mQoU8I/XVE6
   nnlHTRw09URQxmyQL23fZHmClckEuF/y/IvDWsdJk0Iya9J3tB/giWWla
   DT6UazX5CvlmI5k3aKj0qvTQziap0SSBFyJDgrGsPareXxvz6flJumFcE
   oxIcsITrcK/4CCGRfg4eK1V1USTLE8DRtvCv0GN1fpJ27kF0sE+AjR6Hg
   V+6MlrDv4B6qMNRJ6bx2RzWJqJjG3momgLwpXucILUHPRwFMe3FbmyAse
   K6X45Y3BXIAJoApVZ840dfpv8YeQEO27e2yC7jVzV/G6vgbhnX34azWBR
   A==;
X-IronPort-AV: E=Sophos;i="5.90,161,1643698800"; 
   d="scan'208";a="155932004"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Mar 2022 03:18:28 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 7 Mar 2022 03:18:27 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 7 Mar 2022 03:18:22 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>
Subject: [RFC PATCH net-next 2/2] net: phy: lan87xx: use genphy_read_master_slave in read_status
Date:   Mon, 7 Mar 2022 15:47:43 +0530
Message-ID: <20220307101743.8567-3-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220307101743.8567-1-arun.ramadoss@microchip.com>
References: <20220307101743.8567-1-arun.ramadoss@microchip.com>
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

