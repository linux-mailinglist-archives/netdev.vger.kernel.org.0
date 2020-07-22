Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9262E22A168
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 23:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733032AbgGVVcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 17:32:06 -0400
Received: from mga18.intel.com ([134.134.136.126]:4540 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732945AbgGVVcC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 17:32:02 -0400
IronPort-SDR: IrMaW6jaR249emAI+JQoA9cw/0szjRC1pjAkMl/BCSs5LASRMPtWveoJ1+pYukSYG60yVYYSMG
 TXs1fB/ObeuA==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="137926757"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="137926757"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 14:32:00 -0700
IronPort-SDR: UJ+LV8w1ma8PHbD3ioQeQKdHn+AJwCFe4mBYAJm/wC54vQb5yqUJShKl9EMt/oXneA7u45IObD
 8kjlJtGyttWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="284361358"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga003.jf.intel.com with ESMTP; 22 Jul 2020 14:32:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 4/8] igc: Fix registers definition
Date:   Wed, 22 Jul 2020 14:31:46 -0700
Message-Id: <20200722213150.383393-5-anthony.l.nguyen@intel.com>
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

Fix double definition and remove unneeded registers.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_mac.c  | 4 ----
 drivers/net/ethernet/intel/igc/igc_main.c | 4 ----
 drivers/net/ethernet/intel/igc/igc_regs.h | 8 --------
 3 files changed, 16 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_mac.c b/drivers/net/ethernet/intel/igc/igc_mac.c
index f85c8bcd7f70..02bbb8ac4f68 100644
--- a/drivers/net/ethernet/intel/igc/igc_mac.c
+++ b/drivers/net/ethernet/intel/igc/igc_mac.c
@@ -295,13 +295,9 @@ void igc_clear_hw_cntrs_base(struct igc_hw *hw)
 	rd32(IGC_MGTPTC);
 
 	rd32(IGC_IAC);
-	rd32(IGC_ICRXOC);
 
-	rd32(IGC_ICRXPTC);
-	rd32(IGC_ICRXATC);
 	rd32(IGC_ICTXPTC);
 	rd32(IGC_ICTXATC);
-	rd32(IGC_ICRXDMTC);
 
 	rd32(IGC_RPTHC);
 	rd32(IGC_TLPIC);
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 6f86783836c5..d91fa4c06f2e 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3730,12 +3730,8 @@ void igc_update_stats(struct igc_adapter *adapter)
 	adapter->stats.tsctc += rd32(IGC_TSCTC);
 
 	adapter->stats.iac += rd32(IGC_IAC);
-	adapter->stats.icrxoc += rd32(IGC_ICRXOC);
-	adapter->stats.icrxptc += rd32(IGC_ICRXPTC);
-	adapter->stats.icrxatc += rd32(IGC_ICRXATC);
 	adapter->stats.ictxptc += rd32(IGC_ICTXPTC);
 	adapter->stats.ictxatc += rd32(IGC_ICTXATC);
-	adapter->stats.icrxdmtc += rd32(IGC_ICRXDMTC);
 
 	/* Fill out the OS statistics structure */
 	net_stats->multicast = adapter->stats.mprc;
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index 23554d39ad18..5ff3316717c7 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -58,14 +58,6 @@
 #define IGC_IVAR_MISC		0x01740  /* IVAR for "other" causes - RW */
 #define IGC_GPIE		0x01514  /* General Purpose Intr Enable - RW */
 
-/* Interrupt Cause */
-#define IGC_ICRXPTC		0x04104  /* Rx Packet Timer Expire Count */
-#define IGC_ICRXATC		0x04108  /* Rx Absolute Timer Expire Count */
-#define IGC_ICTXPTC		0x0410C  /* Tx Packet Timer Expire Count */
-#define IGC_ICTXATC		0x04110  /* Tx Absolute Timer Expire Count */
-#define IGC_ICRXDMTC		0x04120  /* Rx Descriptor Min Threshold Count */
-#define IGC_ICRXOC		0x04124  /* Receiver Overrun Count */
-
 /* MSI-X Table Register Descriptions */
 #define IGC_PBACL		0x05B68  /* MSIx PBA Clear - R/W 1 to clear */
 
-- 
2.26.2

