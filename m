Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2422A2FCB1D
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 07:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbhATGin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 01:38:43 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:41847 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729523AbhATGYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 01:24:00 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UMIdawV_1611123780;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UMIdawV_1611123780)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 20 Jan 2021 14:23:10 +0800
From:   Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
To:     jesse.brandeburg@intel.com
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] igc: Assign boolean values to a bool variable
Date:   Wed, 20 Jan 2021 14:22:58 +0800
Message-Id: <1611123778-104125-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./drivers/net/ethernet/intel/igc/igc_main.c:4961:2-14: WARNING:
Assignment of 0/1 to bool variable.

./drivers/net/ethernet/intel/igc/igc_main.c:4955:2-14: WARNING:
Assignment of 0/1 to bool variable.

./drivers/net/ethernet/intel/igc/igc_main.c:4933:1-13: WARNING:
Assignment of 0/1 to bool variable.

./drivers/net/ethernet/intel/igc/igc_main.c:4592:1-24: WARNING:
Assignment of 0/1 to bool variable.

./drivers/net/ethernet/intel/igc/igc_main.c:4438:2-25: WARNING:
Assignment of 0/1 to bool variable.

./drivers/net/ethernet/intel/igc/igc_main.c:4396:2-25: WARNING:
Assignment of 0/1 to bool variable.

./drivers/net/ethernet/intel/igc/igc_main.c:4018:2-25: WARNING:
Assignment of 0/1 to bool variable.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index afd6a62..6abb331 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3597,7 +3597,7 @@ void igc_up(struct igc_adapter *adapter)
 	netif_tx_start_all_queues(adapter->netdev);
 
 	/* start the watchdog. */
-	hw->mac.get_link_status = 1;
+	hw->mac.get_link_status = true;
 	schedule_work(&adapter->watchdog_task);
 }
 
@@ -4016,7 +4016,7 @@ static irqreturn_t igc_msix_other(int irq, void *data)
 	}
 
 	if (icr & IGC_ICR_LSC) {
-		hw->mac.get_link_status = 1;
+		hw->mac.get_link_status = true;
 		/* guard against interrupt when we're going down */
 		if (!test_bit(__IGC_DOWN, &adapter->state))
 			mod_timer(&adapter->watchdog_timer, jiffies + 1);
@@ -4394,7 +4394,7 @@ static irqreturn_t igc_intr_msi(int irq, void *data)
 	}
 
 	if (icr & (IGC_ICR_RXSEQ | IGC_ICR_LSC)) {
-		hw->mac.get_link_status = 1;
+		hw->mac.get_link_status = true;
 		if (!test_bit(__IGC_DOWN, &adapter->state))
 			mod_timer(&adapter->watchdog_timer, jiffies + 1);
 	}
@@ -4436,7 +4436,7 @@ static irqreturn_t igc_intr(int irq, void *data)
 	}
 
 	if (icr & (IGC_ICR_RXSEQ | IGC_ICR_LSC)) {
-		hw->mac.get_link_status = 1;
+		hw->mac.get_link_status = true;
 		/* guard against interrupt when we're going down */
 		if (!test_bit(__IGC_DOWN, &adapter->state))
 			mod_timer(&adapter->watchdog_timer, jiffies + 1);
@@ -4590,7 +4590,7 @@ static int __igc_open(struct net_device *netdev, bool resuming)
 	netif_tx_start_all_queues(netdev);
 
 	/* start the watchdog. */
-	hw->mac.get_link_status = 1;
+	hw->mac.get_link_status = true;
 	schedule_work(&adapter->watchdog_task);
 
 	return IGC_SUCCESS;
@@ -4931,7 +4931,7 @@ int igc_set_spd_dplx(struct igc_adapter *adapter, u32 spd, u8 dplx)
 {
 	struct igc_mac_info *mac = &adapter->hw.mac;
 
-	mac->autoneg = 0;
+	mac->autoneg = false;
 
 	/* Make sure dplx is at most 1 bit and lsb of speed is not set
 	 * for the switch() below to work
@@ -4953,13 +4953,13 @@ int igc_set_spd_dplx(struct igc_adapter *adapter, u32 spd, u8 dplx)
 		mac->forced_speed_duplex = ADVERTISE_100_FULL;
 		break;
 	case SPEED_1000 + DUPLEX_FULL:
-		mac->autoneg = 1;
+		mac->autoneg = true;
 		adapter->hw.phy.autoneg_advertised = ADVERTISE_1000_FULL;
 		break;
 	case SPEED_1000 + DUPLEX_HALF: /* not supported */
 		goto err_inval;
 	case SPEED_2500 + DUPLEX_FULL:
-		mac->autoneg = 1;
+		mac->autoneg = true;
 		adapter->hw.phy.autoneg_advertised = ADVERTISE_2500_FULL;
 		break;
 	case SPEED_2500 + DUPLEX_HALF: /* not supported */
-- 
1.8.3.1

