Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099D822F656
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 19:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730496AbgG0RN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 13:13:59 -0400
Received: from mga12.intel.com ([192.55.52.136]:43935 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730226AbgG0RNq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 13:13:46 -0400
IronPort-SDR: 3Eb8UDJsiJw6fFE0aEdImZMGHWjrGAFYaQwDBreuGApMIAXvsxTiUyY16QWthr9y5/62DhCvBm
 fyF57N/8OA7A==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="130631839"
X-IronPort-AV: E=Sophos;i="5.75,402,1589266800"; 
   d="scan'208";a="130631839"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 10:13:45 -0700
IronPort-SDR: 15clv5c5LRJO8V6vLujhUpQOsfVF1IXbPfNNGfdmqN3UfYEw92iM5q/iquCK0O+UouPE8OI3pk
 yBTkKROFNgvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,402,1589266800"; 
   d="scan'208";a="394048650"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jul 2020 10:13:44 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v2 4/8] igc: Fix registers definition
Date:   Mon, 27 Jul 2020 10:13:34 -0700
Message-Id: <20200727171338.3698640-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200727171338.3698640-1-anthony.l.nguyen@intel.com>
References: <20200727171338.3698640-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

IGC_ICTXPTC and IGC_ICTXATC are already defined elsewhere, remove this
double definition. Also, remove unneeded registers as they are not
applicable to i225 devices.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_hw.h   | 4 ----
 drivers/net/ethernet/intel/igc/igc_mac.c  | 4 ----
 drivers/net/ethernet/intel/igc/igc_main.c | 4 ----
 drivers/net/ethernet/intel/igc/igc_regs.h | 8 --------
 4 files changed, 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_hw.h b/drivers/net/ethernet/intel/igc/igc_hw.h
index f11fa0a4baff..ac3de58e6e26 100644
--- a/drivers/net/ethernet/intel/igc/igc_hw.h
+++ b/drivers/net/ethernet/intel/igc/igc_hw.h
@@ -276,12 +276,8 @@ struct igc_hw_stats {
 	u64 tsctc;
 	u64 tsctfc;
 	u64 iac;
-	u64 icrxptc;
-	u64 icrxatc;
 	u64 ictxptc;
 	u64 ictxatc;
-	u64 icrxdmtc;
-	u64 icrxoc;
 	u64 cbtmpc;
 	u64 htdpmc;
 	u64 cbrdpc;
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

