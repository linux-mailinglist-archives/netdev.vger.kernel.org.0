Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3781C1D4465
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 06:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgEOEV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 00:21:58 -0400
Received: from mga18.intel.com ([134.134.136.126]:35154 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbgEOEVr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 00:21:47 -0400
IronPort-SDR: 9U54Mdw1vgw7ExxhyAG+/dj2sF00k9BkGqtcW5Xj4coLBBF+j+dzi9ihRnq3XWszhgrwiWvHAh
 iDMUkCvElK5Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 21:21:41 -0700
IronPort-SDR: mz8KarMp4A6zXeI4jdm/a1edd0LR59wGEpyZN/78RM/HV61bX4nqfKEWNAuAn++v4DO3zjFvlc
 oTB157CQFGfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,393,1583222400"; 
   d="scan'208";a="263066083"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga003.jf.intel.com with ESMTP; 14 May 2020 21:21:41 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v3 7/9] igc: Use netdev log helpers in igc_base.c
Date:   Thu, 14 May 2020 21:21:37 -0700
Message-Id: <20200515042139.749859-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515042139.749859-1-jeffrey.t.kirsher@intel.com>
References: <20200515042139.749859-1-jeffrey.t.kirsher@intel.com>
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
 drivers/net/ethernet/intel/igc/igc_base.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_base.c b/drivers/net/ethernet/intel/igc/igc_base.c
index f7fb18d8d8f5..cc5a6cf531c7 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.c
+++ b/drivers/net/ethernet/intel/igc/igc_base.c
@@ -26,7 +26,7 @@ static s32 igc_reset_hw_base(struct igc_hw *hw)
 	 */
 	ret_val = igc_disable_pcie_master(hw);
 	if (ret_val)
-		hw_dbg("PCI-E Master disable polling has failed.\n");
+		hw_dbg("PCI-E Master disable polling has failed\n");
 
 	hw_dbg("Masking off all interrupts\n");
 	wr32(IGC_IMC, 0xffffffff);
@@ -177,7 +177,7 @@ static s32 igc_init_phy_params_base(struct igc_hw *hw)
 	 */
 	ret_val = hw->phy.ops.reset(hw);
 	if (ret_val) {
-		hw_dbg("Error resetting the PHY.\n");
+		hw_dbg("Error resetting the PHY\n");
 		goto out;
 	}
 
@@ -367,7 +367,7 @@ void igc_rx_fifo_flush_base(struct igc_hw *hw)
 	}
 
 	if (ms_wait == 10)
-		pr_debug("Queue disable timed out after 10ms\n");
+		hw_dbg("Queue disable timed out after 10ms\n");
 
 	/* Clear RLPML, RCTL.SBP, RFCTL.LEF, and set RCTL.LPE so that all
 	 * incoming packets are rejected.  Set enable and wait 2ms so that
-- 
2.26.2

