Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D56866176A1
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 07:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbiKCGOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 02:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiKCGOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 02:14:21 -0400
Received: from out28-1.mail.aliyun.com (out28-1.mail.aliyun.com [115.124.28.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1474518E02;
        Wed,  2 Nov 2022 23:14:19 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.4085879|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00945261-0.000483737-0.990064;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047203;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=16;RT=16;SR=0;TI=SMTPD_---.Q-ERKeq_1667456039;
Received: from sunhua.motor-comm.com(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.Q-ERKeq_1667456039)
          by smtp.aliyun-inc.com;
          Thu, 03 Nov 2022 14:14:15 +0800
From:   Frank <Frank.Sae@motor-comm.com>
To:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     yinghong.zhang@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frank <Frank.Sae@motor-comm.com>,
        kernel test robot <lkp@intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH net-next v1.2] net: phy: fix yt8521 duplicated argument to & or |
Date:   Thu,  3 Nov 2022 14:14:13 +0800
Message-Id: <20221103061413.1866-1-Frank.Sae@motor-comm.com>
X-Mailer: git-send-email 2.31.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cocci warnings: (new ones prefixed by >>)
>> drivers/net/phy/motorcomm.c:1122:8-35: duplicated argument to & or |
  drivers/net/phy/motorcomm.c:1126:8-35: duplicated argument to & or |
  drivers/net/phy/motorcomm.c:1130:8-34: duplicated argument to & or |
  drivers/net/phy/motorcomm.c:1134:8-34: duplicated argument to & or |

 The second YT8521_RC1R_GE_TX_DELAY_xx should be YT8521_RC1R_FE_TX_DELAY_xx.

 Fixes: 70479a40954c ("net: phy: Add driver for Motorcomm yt8521 gigabit ethernet phy")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Frank <Frank.Sae@motor-comm.com>
---
v1.2
 -remove "[net-next,v8.2] " in Fixes tag
 
v1.1
 -change PATCH net to PATCH net-next
 -add warnings info
 
 drivers/net/phy/motorcomm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
index c7593f224177..bd1ab5d0631f 100644
--- a/drivers/net/phy/motorcomm.c
+++ b/drivers/net/phy/motorcomm.c
@@ -1119,19 +1119,19 @@ static int yt8521_config_init(struct phy_device *phydev)
 
 	switch (phydev->interface) {
 	case PHY_INTERFACE_MODE_RGMII:
-		val = YT8521_RC1R_GE_TX_DELAY_DIS | YT8521_RC1R_GE_TX_DELAY_DIS;
+		val = YT8521_RC1R_GE_TX_DELAY_DIS | YT8521_RC1R_FE_TX_DELAY_DIS;
 		val |= YT8521_RC1R_RX_DELAY_DIS;
 		break;
 	case PHY_INTERFACE_MODE_RGMII_RXID:
-		val = YT8521_RC1R_GE_TX_DELAY_DIS | YT8521_RC1R_GE_TX_DELAY_DIS;
+		val = YT8521_RC1R_GE_TX_DELAY_DIS | YT8521_RC1R_FE_TX_DELAY_DIS;
 		val |= YT8521_RC1R_RX_DELAY_EN;
 		break;
 	case PHY_INTERFACE_MODE_RGMII_TXID:
-		val = YT8521_RC1R_GE_TX_DELAY_EN | YT8521_RC1R_GE_TX_DELAY_EN;
+		val = YT8521_RC1R_GE_TX_DELAY_EN | YT8521_RC1R_FE_TX_DELAY_EN;
 		val |= YT8521_RC1R_RX_DELAY_DIS;
 		break;
 	case PHY_INTERFACE_MODE_RGMII_ID:
-		val = YT8521_RC1R_GE_TX_DELAY_EN | YT8521_RC1R_GE_TX_DELAY_EN;
+		val = YT8521_RC1R_GE_TX_DELAY_EN | YT8521_RC1R_FE_TX_DELAY_EN;
 		val |= YT8521_RC1R_RX_DELAY_EN;
 		break;
 	case PHY_INTERFACE_MODE_SGMII:
-- 
2.31.0.windows.1

