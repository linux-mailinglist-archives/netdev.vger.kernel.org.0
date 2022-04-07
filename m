Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD4F4F74F5
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 06:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240796AbiDGEsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 00:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240777AbiDGEsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 00:48:33 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E16D5F7A;
        Wed,  6 Apr 2022 21:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649306791; x=1680842791;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TCnYwVQoYkx47uY3j4vmsuPp6FiPP/5oOwUS7qaivmA=;
  b=gGX5yRT6RnWwFYz8neW1rlbib1lr7zz3Uk/9n6/U7h3kkWO/zA9rl/Rf
   h2n4nsnLsX2/3C268qIHNsGzfPuBi2ZHp92zVvdhH+6OO2TZzCHEbnU/K
   i85CekIDpvXOqCZo1H+8MDvMJ3Lc/Neq31QzYrMTvSK43tEszb5Ep/T6A
   JulJ1DYjXvZGhHtHBMIbmEKrFGbwCB1TTMtHkhOfii1H0hYD23z94gMYk
   /yYzX/eabNg9A8xrCQKdBK84ErJwTSY9a9B/hNO+SuJBhY4iJY4Zb9M3G
   /LxWj+SNggf5ArlVPTbanzObMSejG8GyJokQ4DTsPom7GxjFoto8fTyVl
   g==;
X-IronPort-AV: E=Sophos;i="5.90,241,1643698800"; 
   d="scan'208";a="91573260"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Apr 2022 21:46:29 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 6 Apr 2022 21:46:28 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 6 Apr 2022 21:46:24 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Russell King" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "Andrew Lunn" <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>
Subject: [Patch net v2] net: phy: LAN87xx: remove genphy_softreset in config_aneg
Date:   Thu, 7 Apr 2022 10:16:10 +0530
Message-ID: <20220407044610.8710-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the T1 phy master/slave state is changed, at the end of config_aneg
function genphy_softreset is called. After the reset all the registers
configured during the config_init are restored to default value.
To avoid this, removed the genphy_softreset call.

v1->v2
------
Added the author in cc

Fixes: 8a1b415d70b7 ("net: phy: added ethtool master-slave configuration support")
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/phy/microchip_t1.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index 389df3f4293c..3f79bbbe62d3 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -706,7 +706,6 @@ static int lan87xx_read_status(struct phy_device *phydev)
 static int lan87xx_config_aneg(struct phy_device *phydev)
 {
 	u16 ctl = 0;
-	int rc;
 
 	switch (phydev->master_slave_set) {
 	case MASTER_SLAVE_CFG_MASTER_FORCE:
@@ -722,11 +721,7 @@ static int lan87xx_config_aneg(struct phy_device *phydev)
 		return -EOPNOTSUPP;
 	}
 
-	rc = phy_modify_changed(phydev, MII_CTRL1000, CTL1000_AS_MASTER, ctl);
-	if (rc == 1)
-		rc = genphy_soft_reset(phydev);
-
-	return rc;
+	return phy_modify_changed(phydev, MII_CTRL1000, CTL1000_AS_MASTER, ctl);
 }
 
 static struct phy_driver microchip_t1_phy_driver[] = {
-- 
2.33.0

