Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9158F6C3B34
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 21:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjCUUE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 16:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbjCUUEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 16:04:23 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E8320565
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 13:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679429003; x=1710965003;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6y9z2cKyCTJ3eYI8kduE2OP56jrTKij3hi3YFvR9pbo=;
  b=CA68r30CbJ8A0XfuuriCMNBSbPdpJaoqomXKsMvp9TfSDVHwbkncqDOD
   gS+YNOAwXKvvJPTIZ7Fg/BuByuygFjwIuOfbdSJH90pbRqe7AKX8wAj/4
   ej69D2g6KR5Qv31UXA11xjWr5WdiXASLUPV0u6nYeWCLo7LVIGLWa1HQi
   jH5C6+muEhbJxkvg81Amotq0ggoePdzjQ3OAPvsabtAEa5ATJfrjNgFnW
   Ajuneusp9LO/M5zROujHCJ6fPU3/ToZEn+Ru2r6CPHwiiMxzTL1GCaQhY
   c2OHiSxgr/oHklT14yhwRJxcQYceNzT+47pzqVg4pgBX8O/8ZIxSxMM+P
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="403934798"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="403934798"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 13:01:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="658911194"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="658911194"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga006.jf.intel.com with ESMTP; 21 Mar 2023 13:01:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, anthony.l.nguyen@intel.com,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 3/3] igc: Remove obsolete DMA coalescing code
Date:   Tue, 21 Mar 2023 13:00:13 -0700
Message-Id: <20230321200013.2866582-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230321200013.2866582-1-anthony.l.nguyen@intel.com>
References: <20230321200013.2866582-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

DMA coalescing is not applicable for i225 parts. This patch comes to tidy
up the driver code.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h |  3 ---
 drivers/net/ethernet/intel/igc/igc_i225.c    | 19 +++++--------------
 drivers/net/ethernet/intel/igc/igc_regs.h    |  1 -
 3 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 9dec3563ce3a..44a507029946 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -662,9 +662,6 @@
  */
 #define IGC_TW_SYSTEM_100_MASK		0x0000FF00
 #define IGC_TW_SYSTEM_100_SHIFT		8
-#define IGC_DMACR_DMAC_EN		0x80000000 /* Enable DMA Coalescing */
-#define IGC_DMACR_DMACTHR_MASK		0x00FF0000
-#define IGC_DMACR_DMACTHR_SHIFT		16
 /* Reg val to set scale to 1024 nsec */
 #define IGC_LTRMINV_SCALE_1024		2
 /* Reg val to set scale to 32768 nsec */
diff --git a/drivers/net/ethernet/intel/igc/igc_i225.c b/drivers/net/ethernet/intel/igc/igc_i225.c
index 59d5c467ea6e..17546a035ab1 100644
--- a/drivers/net/ethernet/intel/igc/igc_i225.c
+++ b/drivers/net/ethernet/intel/igc/igc_i225.c
@@ -593,20 +593,11 @@ s32 igc_set_ltr_i225(struct igc_hw *hw, bool link)
 		size = rd32(IGC_RXPBS) &
 		       IGC_RXPBS_SIZE_I225_MASK;
 
-		/* Calculations vary based on DMAC settings. */
-		if (rd32(IGC_DMACR) & IGC_DMACR_DMAC_EN) {
-			size -= (rd32(IGC_DMACR) &
-				 IGC_DMACR_DMACTHR_MASK) >>
-				 IGC_DMACR_DMACTHR_SHIFT;
-			/* Convert size to bits. */
-			size *= 1024 * 8;
-		} else {
-			/* Convert size to bytes, subtract the MTU, and then
-			 * convert the size to bits.
-			 */
-			size *= 1024;
-			size *= 8;
-		}
+		/* Convert size to bytes, subtract the MTU, and then
+		 * convert the size to bits.
+		 */
+		size *= 1024;
+		size *= 8;
 
 		if (size < 0) {
 			hw_dbg("Invalid effective Rx buffer size %d\n",
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index 01c86d36856d..dba5a5759b1c 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -292,7 +292,6 @@
 
 /* LTR registers */
 #define IGC_LTRC	0x01A0 /* Latency Tolerance Reporting Control */
-#define IGC_DMACR	0x02508 /* DMA Coalescing Control Register */
 #define IGC_LTRMINV	0x5BB0 /* LTR Minimum Value */
 #define IGC_LTRMAXV	0x5BB4 /* LTR Maximum Value */
 
-- 
2.38.1

