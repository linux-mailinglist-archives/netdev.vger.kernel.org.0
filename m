Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED668617482
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 03:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbiKCCwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 22:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiKCCwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 22:52:10 -0400
Received: from out29-170.mail.aliyun.com (out29-170.mail.aliyun.com [115.124.29.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B9715A00;
        Wed,  2 Nov 2022 19:51:27 -0700 (PDT)
X-Alimail-AntiSpam: AC=SUSPECT;BC=0.6395016|-1;BR=01201311R831b1;CH=blue;DM=|SUSPECT|false|;DS=CONTINUE|ham_system_inform|0.0202667-0.000889277-0.978844;FP=3240711654452809652|1|1|3|0|-1|-1|-1;HT=ay29a033018047202;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=16;RT=16;SR=0;TI=SMTPD_---.Q-4cLR7_1667443832;
Received: from sunhua.motor-comm.com(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.Q-4cLR7_1667443832)
          by smtp.aliyun-inc.com;
          Thu, 03 Nov 2022 10:51:18 +0800
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
Subject: [PATCH net] net: phy: fix yt8521 duplicated argument to & or
Date:   Thu,  3 Nov 2022 10:50:47 +0800
Message-Id: <20221103025047.1862-1-Frank.Sae@motor-comm.com>
X-Mailer: git-send-email 2.31.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 The second YT8521_RC1R_GE_TX_DELAY_xx should be YT8521_RC1R_FE_TX_DELAY_xx.

 Fixes: 70479a40954c ("[net-next,v8.2] net: phy: Add driver for Motorcomm yt8521 gigabit ethernet phy")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Frank <Frank.Sae@motor-comm.com>
---
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

