Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4CA342784
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 22:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhCSVQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 17:16:31 -0400
Received: from mga18.intel.com ([134.134.136.126]:20600 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230092AbhCSVP6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 17:15:58 -0400
IronPort-SDR: +9kGVGj47+efK+Byqst+ybTlZdTobAGMPzDEhsbIkHJD76FJrRbyZdP42egkdGznCjZkQzGFej
 kOPisdlzz6/w==
X-IronPort-AV: E=McAfee;i="6000,8403,9928"; a="177554728"
X-IronPort-AV: E=Sophos;i="5.81,262,1610438400"; 
   d="scan'208";a="177554728"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 14:15:57 -0700
IronPort-SDR: tFC2nHgQlGPEEDo5BBcAJDh4RyOBFQjgR6vhyJ6jHkLac/hoLZmAosfYXZ2Jd0Xazz5kGFiJUW
 xnJxIIL0GD0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,262,1610438400"; 
   d="scan'208";a="451005078"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 19 Mar 2021 14:15:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, Abaci Robot <abaci@linux.alibaba.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 4/5] igc: Assign boolean values to a bool variable
Date:   Fri, 19 Mar 2021 14:17:22 -0700
Message-Id: <20210319211723.1488244-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210319211723.1488244-1-anthony.l.nguyen@intel.com>
References: <20210319211723.1488244-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>

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
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 059ffcfb0bda..a476837eafca 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3580,7 +3580,7 @@ void igc_up(struct igc_adapter *adapter)
 	netif_tx_start_all_queues(adapter->netdev);
 
 	/* start the watchdog. */
-	hw->mac.get_link_status = 1;
+	hw->mac.get_link_status = true;
 	schedule_work(&adapter->watchdog_task);
 }
 
@@ -4000,7 +4000,7 @@ static irqreturn_t igc_msix_other(int irq, void *data)
 	}
 
 	if (icr & IGC_ICR_LSC) {
-		hw->mac.get_link_status = 1;
+		hw->mac.get_link_status = true;
 		/* guard against interrupt when we're going down */
 		if (!test_bit(__IGC_DOWN, &adapter->state))
 			mod_timer(&adapter->watchdog_timer, jiffies + 1);
@@ -4378,7 +4378,7 @@ static irqreturn_t igc_intr_msi(int irq, void *data)
 	}
 
 	if (icr & (IGC_ICR_RXSEQ | IGC_ICR_LSC)) {
-		hw->mac.get_link_status = 1;
+		hw->mac.get_link_status = true;
 		if (!test_bit(__IGC_DOWN, &adapter->state))
 			mod_timer(&adapter->watchdog_timer, jiffies + 1);
 	}
@@ -4420,7 +4420,7 @@ static irqreturn_t igc_intr(int irq, void *data)
 	}
 
 	if (icr & (IGC_ICR_RXSEQ | IGC_ICR_LSC)) {
-		hw->mac.get_link_status = 1;
+		hw->mac.get_link_status = true;
 		/* guard against interrupt when we're going down */
 		if (!test_bit(__IGC_DOWN, &adapter->state))
 			mod_timer(&adapter->watchdog_timer, jiffies + 1);
@@ -4574,7 +4574,7 @@ static int __igc_open(struct net_device *netdev, bool resuming)
 	netif_tx_start_all_queues(netdev);
 
 	/* start the watchdog. */
-	hw->mac.get_link_status = 1;
+	hw->mac.get_link_status = true;
 	schedule_work(&adapter->watchdog_task);
 
 	return IGC_SUCCESS;
@@ -4915,7 +4915,7 @@ int igc_set_spd_dplx(struct igc_adapter *adapter, u32 spd, u8 dplx)
 {
 	struct igc_mac_info *mac = &adapter->hw.mac;
 
-	mac->autoneg = 0;
+	mac->autoneg = false;
 
 	/* Make sure dplx is at most 1 bit and lsb of speed is not set
 	 * for the switch() below to work
@@ -4937,13 +4937,13 @@ int igc_set_spd_dplx(struct igc_adapter *adapter, u32 spd, u8 dplx)
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
2.26.2

