Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487521B1A38
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 01:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgDTXnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 19:43:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:14658 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726690AbgDTXnS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 19:43:18 -0400
IronPort-SDR: rBOozyQK9K25DMclVSAkITF4dnoJLo6JWesixmaLSyT6i3ablIn6AB6IrZpI83AegE8AnRZd4h
 EfUF4VK0CVdA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 16:43:16 -0700
IronPort-SDR: GI4ltw5FJmrnGMm49WaGUZxUxmDig7/gjTJkpc/f80odSCFRmkJXUfwFSxqcb0Q2vZ/l3Dcsc9
 EaYwEwxxSEVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,408,1580803200"; 
   d="scan'208";a="300428864"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Apr 2020 16:43:16 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/13] igc: Use netdev log helpers in igc_base.c
Date:   Mon, 20 Apr 2020 16:43:07 -0700
Message-Id: <20200420234313.2184282-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420234313.2184282-1-jeffrey.t.kirsher@intel.com>
References: <20200420234313.2184282-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

This patch coverts one pr_debug() call to hw_dbg() in order to keep log
output aligned with the rest of the driver. hw_dbg() is actually a macro
defined in igc_hw.h that expands to netdev_dbg().

It also takes this opportunity to remove the '\n' character at the end
of messages since it is automatically added to by netdev_dbg().

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_base.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_base.c b/drivers/net/ethernet/intel/igc/igc_base.c
index f7fb18d8d8f5..9722db75064f 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.c
+++ b/drivers/net/ethernet/intel/igc/igc_base.c
@@ -26,9 +26,9 @@ static s32 igc_reset_hw_base(struct igc_hw *hw)
 	 */
 	ret_val = igc_disable_pcie_master(hw);
 	if (ret_val)
-		hw_dbg("PCI-E Master disable polling has failed.\n");
+		hw_dbg("PCI-E Master disable polling has failed");
 
-	hw_dbg("Masking off all interrupts\n");
+	hw_dbg("Masking off all interrupts");
 	wr32(IGC_IMC, 0xffffffff);
 
 	wr32(IGC_RCTL, 0);
@@ -39,7 +39,7 @@ static s32 igc_reset_hw_base(struct igc_hw *hw)
 
 	ctrl = rd32(IGC_CTRL);
 
-	hw_dbg("Issuing a global reset to MAC\n");
+	hw_dbg("Issuing a global reset to MAC");
 	wr32(IGC_CTRL, ctrl | IGC_CTRL_DEV_RST);
 
 	ret_val = igc_get_auto_rd_done(hw);
@@ -48,7 +48,7 @@ static s32 igc_reset_hw_base(struct igc_hw *hw)
 		 * return with an error. This can happen in situations
 		 * where there is no eeprom and prevents getting link.
 		 */
-		hw_dbg("Auto Read Done did not complete\n");
+		hw_dbg("Auto Read Done did not complete");
 	}
 
 	/* Clear any pending interrupt events. */
@@ -177,7 +177,7 @@ static s32 igc_init_phy_params_base(struct igc_hw *hw)
 	 */
 	ret_val = hw->phy.ops.reset(hw);
 	if (ret_val) {
-		hw_dbg("Error resetting the PHY.\n");
+		hw_dbg("Error resetting the PHY");
 		goto out;
 	}
 
@@ -292,12 +292,12 @@ static s32 igc_init_hw_base(struct igc_hw *hw)
 	igc_init_rx_addrs(hw, rar_count);
 
 	/* Zero out the Multicast HASH table */
-	hw_dbg("Zeroing the MTA\n");
+	hw_dbg("Zeroing the MTA");
 	for (i = 0; i < mac->mta_reg_count; i++)
 		array_wr32(IGC_MTA, i, 0);
 
 	/* Zero out the Unicast HASH table */
-	hw_dbg("Zeroing the UTA\n");
+	hw_dbg("Zeroing the UTA");
 	for (i = 0; i < mac->uta_reg_count; i++)
 		array_wr32(IGC_UTA, i, 0);
 
@@ -367,7 +367,7 @@ void igc_rx_fifo_flush_base(struct igc_hw *hw)
 	}
 
 	if (ms_wait == 10)
-		pr_debug("Queue disable timed out after 10ms\n");
+		hw_dbg("Queue disable timed out after 10ms");
 
 	/* Clear RLPML, RCTL.SBP, RFCTL.LEF, and set RCTL.LPE so that all
 	 * incoming packets are rejected.  Set enable and wait 2ms so that
-- 
2.25.3

