Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681FA22A16C
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 23:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733044AbgGVVcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 17:32:13 -0400
Received: from mga18.intel.com ([134.134.136.126]:4536 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733015AbgGVVcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 17:32:03 -0400
IronPort-SDR: 0IX6Fj58XrK3ppOpHav/9RTVH+tv1UV8PyyqyKgep4iaOMeC2L1UKHsYm/La1IhtjUuckB2aRH
 fCRckWyu9lXw==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="137926760"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="137926760"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 14:32:00 -0700
IronPort-SDR: KLZ9fbF1m/2mcS9Gn8KM47pvB0blaD0t7hgivf6Augi689Jz/Vo3camcrtSvLg+lHEN83fId7W
 A57Ase7AvPAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="284361365"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga003.jf.intel.com with ESMTP; 22 Jul 2020 14:32:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 7/8] igc: Clean up the hw_stats structure
Date:   Wed, 22 Jul 2020 14:31:49 -0700
Message-Id: <20200722213150.383393-8-anthony.l.nguyen@intel.com>
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

Remove icrxptc, icrxatc, ictxptc, ictxatc, ictxqec, ictxqmtc,
icrxdmtc, icrxoc, cbrdpc, cbrmpc and htcbdpc fields from
the hw_stats structure. Accordance to the i225 device
specification these fields not in use.
This patch come to clean up the driver code.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_hw.h   | 12 ------------
 drivers/net/ethernet/intel/igc/igc_mac.c  |  3 ---
 drivers/net/ethernet/intel/igc/igc_main.c |  2 --
 drivers/net/ethernet/intel/igc/igc_regs.h |  2 --
 4 files changed, 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_hw.h b/drivers/net/ethernet/intel/igc/igc_hw.h
index 24412a6c2289..b9fe51b91c47 100644
--- a/drivers/net/ethernet/intel/igc/igc_hw.h
+++ b/drivers/net/ethernet/intel/igc/igc_hw.h
@@ -268,21 +268,9 @@ struct igc_hw_stats {
 	u64 tsctc;
 	u64 tsctfc;
 	u64 iac;
-	u64 icrxptc;
-	u64 icrxatc;
-	u64 ictxptc;
-	u64 ictxatc;
-	u64 ictxqec;
-	u64 ictxqmtc;
-	u64 icrxdmtc;
-	u64 icrxoc;
-	u64 cbtmpc;
 	u64 htdpmc;
-	u64 cbrdpc;
-	u64 cbrmpc;
 	u64 rpthc;
 	u64 hgptc;
-	u64 htcbdpc;
 	u64 hgorc;
 	u64 hgotc;
 	u64 lenerrs;
diff --git a/drivers/net/ethernet/intel/igc/igc_mac.c b/drivers/net/ethernet/intel/igc/igc_mac.c
index 02bbb8ac4f68..674b8ad21fea 100644
--- a/drivers/net/ethernet/intel/igc/igc_mac.c
+++ b/drivers/net/ethernet/intel/igc/igc_mac.c
@@ -296,9 +296,6 @@ void igc_clear_hw_cntrs_base(struct igc_hw *hw)
 
 	rd32(IGC_IAC);
 
-	rd32(IGC_ICTXPTC);
-	rd32(IGC_ICTXATC);
-
 	rd32(IGC_RPTHC);
 	rd32(IGC_TLPIC);
 	rd32(IGC_RLPIC);
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index d91fa4c06f2e..7a6f2a0d413f 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3730,8 +3730,6 @@ void igc_update_stats(struct igc_adapter *adapter)
 	adapter->stats.tsctc += rd32(IGC_TSCTC);
 
 	adapter->stats.iac += rd32(IGC_IAC);
-	adapter->stats.ictxptc += rd32(IGC_ICTXPTC);
-	adapter->stats.ictxatc += rd32(IGC_ICTXATC);
 
 	/* Fill out the OS statistics structure */
 	net_stats->multicast = adapter->stats.mprc;
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index 5ff3316717c7..b52dd9d737e8 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -172,8 +172,6 @@
 #define IGC_BPTC	0x040F4  /* Broadcast Packets Tx Count - R/clr */
 #define IGC_TSCTC	0x040F8  /* TCP Segmentation Context Tx - R/clr */
 #define IGC_IAC		0x04100  /* Interrupt Assertion Count */
-#define IGC_ICTXPTC	0x0410C  /* Interrupt Cause Tx Pkt Timer Expire Count */
-#define IGC_ICTXATC	0x04110  /* Interrupt Cause Tx Abs Timer Expire Count */
 #define IGC_RPTHC	0x04104  /* Rx Packets To Host */
 #define IGC_TLPIC	0x04148  /* EEE Tx LPI Count */
 #define IGC_RLPIC	0x0414C  /* EEE Rx LPI Count */
-- 
2.26.2

