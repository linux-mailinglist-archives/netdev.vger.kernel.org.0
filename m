Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B99451B7FC
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 08:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244602AbiEEGhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 02:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244518AbiEEGhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 02:37:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181642F3B4
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 23:33:34 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nmV3B-00047U-E1; Thu, 05 May 2022 08:33:21 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nmV3B-000SS4-RR; Thu, 05 May 2022 08:33:20 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nmV38-001F6a-Ti; Thu, 05 May 2022 08:33:18 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v3 6/7] net: phy: export genphy_c45_baset1_read_status()
Date:   Thu,  5 May 2022 08:33:17 +0200
Message-Id: <20220505063318.296280-7-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220505063318.296280-1-o.rempel@pengutronix.de>
References: <20220505063318.296280-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export genphy_c45_baset1_read_status() to make it reusable by PHY drivers.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/phy-c45.c | 3 ++-
 include/linux/phy.h       | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index 40620e3c9467..6616e4f580a4 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -784,7 +784,7 @@ EXPORT_SYMBOL_GPL(genphy_c45_pma_read_abilities);
  * is forced or not, it is read from BASE-T1 AN advertisement
  * register 7.514.
  */
-static int genphy_c45_baset1_read_status(struct phy_device *phydev)
+int genphy_c45_baset1_read_status(struct phy_device *phydev)
 {
 	int ret;
 	int cfg;
@@ -814,6 +814,7 @@ static int genphy_c45_baset1_read_status(struct phy_device *phydev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(genphy_c45_baset1_read_status);
 
 /**
  * genphy_c45_read_status - read PHY status
diff --git a/include/linux/phy.h b/include/linux/phy.h
index a7490df8e1ec..eb3423ffa81e 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1621,6 +1621,7 @@ int genphy_c45_read_mdix(struct phy_device *phydev);
 int genphy_c45_pma_read_abilities(struct phy_device *phydev);
 int genphy_c45_pma_baset1_read_master_slave(struct phy_device *phydev);
 int genphy_c45_read_status(struct phy_device *phydev);
+int genphy_c45_baset1_read_status(struct phy_device *phydev);
 int genphy_c45_config_aneg(struct phy_device *phydev);
 int genphy_c45_loopback(struct phy_device *phydev, bool enable);
 int genphy_c45_pma_resume(struct phy_device *phydev);
-- 
2.30.2

