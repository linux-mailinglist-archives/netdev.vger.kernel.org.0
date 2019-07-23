Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30BE971DD5
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 19:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391154AbfGWRhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 13:37:09 -0400
Received: from mga17.intel.com ([192.55.52.151]:49109 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391140AbfGWRhI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 13:37:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jul 2019 10:37:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,299,1559545200"; 
   d="scan'208";a="197203623"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 23 Jul 2019 10:37:01 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 3/6] igc: Update the MAC reset flow
Date:   Tue, 23 Jul 2019 10:36:47 -0700
Message-Id: <20190723173650.23276-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190723173650.23276-1-jeffrey.t.kirsher@intel.com>
References: <20190723173650.23276-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Use Device Reset flow instead of Port Reset flow.
This flow performs a reset of the entire controller device,
resulting in a state nearly approximating the state
following a power-up reset or internal PCIe reset,
except for system PCI configuration.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_base.c    | 2 +-
 drivers/net/ethernet/intel/igc/igc_defines.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_base.c b/drivers/net/ethernet/intel/igc/igc_base.c
index 59258d791106..46206b3dabfb 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.c
+++ b/drivers/net/ethernet/intel/igc/igc_base.c
@@ -40,7 +40,7 @@ static s32 igc_reset_hw_base(struct igc_hw *hw)
 	ctrl = rd32(IGC_CTRL);
 
 	hw_dbg("Issuing a global reset to MAC\n");
-	wr32(IGC_CTRL, ctrl | IGC_CTRL_RST);
+	wr32(IGC_CTRL, ctrl | IGC_CTRL_DEV_RST);
 
 	ret_val = igc_get_auto_rd_done(hw);
 	if (ret_val) {
diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index fc0ccfe38a20..11b99acf4abe 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -54,7 +54,7 @@
 #define IGC_ERR_SWFW_SYNC		13
 
 /* Device Control */
-#define IGC_CTRL_RST		0x04000000  /* Global reset */
+#define IGC_CTRL_DEV_RST	0x20000000  /* Device reset */
 
 #define IGC_CTRL_PHY_RST	0x80000000  /* PHY Reset */
 #define IGC_CTRL_SLU		0x00000040  /* Set link up (Force Link) */
-- 
2.21.0

