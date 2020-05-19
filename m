Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37CD1D8CE8
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 03:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbgESBGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 21:06:02 -0400
Received: from mga04.intel.com ([192.55.52.120]:20288 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728183AbgESBGB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 21:06:01 -0400
IronPort-SDR: Tjk3oVNBRzaf/KVl1uSsJHkb2z8nkjsBD6TAc897olYzfwAF25UBwghJv0NCedbBJTG/3juTHF
 SKi1ZXtc/xdQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2020 18:03:46 -0700
IronPort-SDR: +a3b3253x8K5jQuDnIutyLo1jj57FQbr4t6UziJGzh2f1sVD69cdmGZlXVBEP5ioXyoaY1dYHm
 CBY6i14c7gnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,408,1583222400"; 
   d="scan'208";a="267713986"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga006.jf.intel.com with ESMTP; 18 May 2020 18:03:45 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v5 7/9] igc: Use netdev log helpers in igc_base.c
Date:   Mon, 18 May 2020 18:03:41 -0700
Message-Id: <20200519010343.2386401-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200519010343.2386401-1-jeffrey.t.kirsher@intel.com>
References: <20200519010343.2386401-1-jeffrey.t.kirsher@intel.com>
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

