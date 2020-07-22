Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F8D22A166
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 23:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732873AbgGVVcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 17:32:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:4536 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbgGVVcC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 17:32:02 -0400
IronPort-SDR: /RA5OT5rk1ja1IRUlVrxv0ZZ6Mt6DFE9X/HXmXXdDDYDx2U9WAzEkcwhsvmSn6L8RIU3Ng6lfy
 9xmZa5iBfz4Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="137926756"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="137926756"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 14:32:00 -0700
IronPort-SDR: jVRtf7J+Wv3GlyzsYfBDmFHWxp0o7IRDgKa1IZj8HdN2qzWQXXnyKNWL9Ro9unAb/+w9e/Ossv
 +Os/L1gTAi7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="284361354"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga003.jf.intel.com with ESMTP; 22 Jul 2020 14:32:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 3/8] igc: Remove unneeded ICTXQMTC register
Date:   Wed, 22 Jul 2020 14:31:45 -0700
Message-Id: <20200722213150.383393-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200722213150.383393-1-anthony.l.nguyen@intel.com>
References: <20200722213150.383393-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Tx Queue Min Threshold Count register no applicable for the i225 device.
This patch comes to clean up it.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_mac.c  | 1 -
 drivers/net/ethernet/intel/igc/igc_main.c | 1 -
 drivers/net/ethernet/intel/igc/igc_regs.h | 2 --
 3 files changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_mac.c b/drivers/net/ethernet/intel/igc/igc_mac.c
index 3a618e69514e..f85c8bcd7f70 100644
--- a/drivers/net/ethernet/intel/igc/igc_mac.c
+++ b/drivers/net/ethernet/intel/igc/igc_mac.c
@@ -301,7 +301,6 @@ void igc_clear_hw_cntrs_base(struct igc_hw *hw)
 	rd32(IGC_ICRXATC);
 	rd32(IGC_ICTXPTC);
 	rd32(IGC_ICTXATC);
-	rd32(IGC_ICTXQMTC);
 	rd32(IGC_ICRXDMTC);
 
 	rd32(IGC_RPTHC);
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index e620d7a78d05..6f86783836c5 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3735,7 +3735,6 @@ void igc_update_stats(struct igc_adapter *adapter)
 	adapter->stats.icrxatc += rd32(IGC_ICRXATC);
 	adapter->stats.ictxptc += rd32(IGC_ICTXPTC);
 	adapter->stats.ictxatc += rd32(IGC_ICTXATC);
-	adapter->stats.ictxqmtc += rd32(IGC_ICTXQMTC);
 	adapter->stats.icrxdmtc += rd32(IGC_ICRXDMTC);
 
 	/* Fill out the OS statistics structure */
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index d6ed1b1ebcbc..23554d39ad18 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -63,7 +63,6 @@
 #define IGC_ICRXATC		0x04108  /* Rx Absolute Timer Expire Count */
 #define IGC_ICTXPTC		0x0410C  /* Tx Packet Timer Expire Count */
 #define IGC_ICTXATC		0x04110  /* Tx Absolute Timer Expire Count */
-#define IGC_ICTXQMTC		0x0411C  /* Tx Queue Min Threshold Count */
 #define IGC_ICRXDMTC		0x04120  /* Rx Descriptor Min Threshold Count */
 #define IGC_ICRXOC		0x04124  /* Receiver Overrun Count */
 
@@ -183,7 +182,6 @@
 #define IGC_IAC		0x04100  /* Interrupt Assertion Count */
 #define IGC_ICTXPTC	0x0410C  /* Interrupt Cause Tx Pkt Timer Expire Count */
 #define IGC_ICTXATC	0x04110  /* Interrupt Cause Tx Abs Timer Expire Count */
-#define IGC_ICTXQMTC	0x0411C  /* Interrupt Cause Tx Queue Min Thresh Count */
 #define IGC_RPTHC	0x04104  /* Rx Packets To Host */
 #define IGC_TLPIC	0x04148  /* EEE Tx LPI Count */
 #define IGC_RLPIC	0x0414C  /* EEE Rx LPI Count */
-- 
2.26.2

