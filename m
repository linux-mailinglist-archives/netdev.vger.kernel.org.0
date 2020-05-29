Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF4AF1E750A
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 06:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgE2EkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 00:40:23 -0400
Received: from mga03.intel.com ([134.134.136.65]:40325 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbgE2EkS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 00:40:18 -0400
IronPort-SDR: e8EI46urv7pmmW2rxn1hukUOG6lmrmeUC+zqWN0Rm602RbUknQnKwWkLv/1SobxZtvAGWcLmz4
 u+ld5DvyDaqQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 21:40:06 -0700
IronPort-SDR: /cX27tjvyhBYV4yb8nJAWOo8EvRtsoYalKiijMnjPSs1qKBe/W/KKv5nYA93w0Zx92fdT0TqGl
 VJHK7CWu0wtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="414850934"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 28 May 2020 21:40:05 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/17] igc: Remove symbol error counter
Date:   Thu, 28 May 2020 21:40:00 -0700
Message-Id: <20200529044004.3725307-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529044004.3725307-1-jeffrey.t.kirsher@intel.com>
References: <20200529044004.3725307-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Accordance to the i225 datasheet symbol error counter does not
applicable to the i225 device.
This patch comes to clean up this counter.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_mac.c  | 1 -
 drivers/net/ethernet/intel/igc/igc_main.c | 1 -
 drivers/net/ethernet/intel/igc/igc_regs.h | 1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_mac.c b/drivers/net/ethernet/intel/igc/igc_mac.c
index 89445ab02a98..9de70a24cb9e 100644
--- a/drivers/net/ethernet/intel/igc/igc_mac.c
+++ b/drivers/net/ethernet/intel/igc/igc_mac.c
@@ -235,7 +235,6 @@ s32 igc_force_mac_fc(struct igc_hw *hw)
 void igc_clear_hw_cntrs_base(struct igc_hw *hw)
 {
 	rd32(IGC_CRCERRS);
-	rd32(IGC_SYMERRS);
 	rd32(IGC_MPC);
 	rd32(IGC_SCC);
 	rd32(IGC_ECOL);
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 97d26991c87e..662f06a647e6 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3701,7 +3701,6 @@ void igc_update_stats(struct igc_adapter *adapter)
 	adapter->stats.prc511 += rd32(IGC_PRC511);
 	adapter->stats.prc1023 += rd32(IGC_PRC1023);
 	adapter->stats.prc1522 += rd32(IGC_PRC1522);
-	adapter->stats.symerrs += rd32(IGC_SYMERRS);
 	adapter->stats.sec += rd32(IGC_SEC);
 
 	mpc = rd32(IGC_MPC);
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index 7f999cfc9b39..a3e4ec922948 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -127,7 +127,6 @@
 /* Statistics Register Descriptions */
 #define IGC_CRCERRS	0x04000  /* CRC Error Count - R/clr */
 #define IGC_ALGNERRC	0x04004  /* Alignment Error Count - R/clr */
-#define IGC_SYMERRS	0x04008  /* Symbol Error Count - R/clr */
 #define IGC_RXERRC	0x0400C  /* Receive Error Count - R/clr */
 #define IGC_MPC		0x04010  /* Missed Packet Count - R/clr */
 #define IGC_SCC		0x04014  /* Single Collision Count - R/clr */
-- 
2.26.2

