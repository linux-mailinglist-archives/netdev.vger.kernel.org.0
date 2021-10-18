Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC50430FC3
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 07:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhJRFkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 01:40:23 -0400
Received: from mga17.intel.com ([192.55.52.151]:55523 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbhJRFkW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 01:40:22 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10140"; a="208967913"
X-IronPort-AV: E=Sophos;i="5.85,381,1624345200"; 
   d="scan'208";a="208967913"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2021 22:38:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,381,1624345200"; 
   d="scan'208";a="661234884"
Received: from unknown (HELO intel-73.bj.intel.com) ([10.238.154.73])
  by orsmga005.jf.intel.com with ESMTP; 17 Oct 2021 22:38:06 -0700
From:   yanjun.zhu@linux.dev
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        yanjun.zhu@linux.dev
Subject: [PATCH 1/1] ice: compact the file ice_nvm.c
Date:   Mon, 18 Oct 2021 09:17:13 -0400
Message-Id: <20211018131713.3478-1-yanjun.zhu@linux.dev>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@linux.dev>

The function ice_aq_nvm_update_empr is not used, so remove it.

Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 drivers/net/ethernet/intel/ice/ice_nvm.c | 16 ----------------
 drivers/net/ethernet/intel/ice/ice_nvm.h |  1 -
 2 files changed, 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index fee37a5844cf..bad374bd7ab3 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -1106,22 +1106,6 @@ enum ice_status ice_nvm_write_activate(struct ice_hw *hw, u8 cmd_flags)
 	return ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
 }
 
-/**
- * ice_aq_nvm_update_empr
- * @hw: pointer to the HW struct
- *
- * Update empr (0x0709). This command allows SW to
- * request an EMPR to activate new FW.
- */
-enum ice_status ice_aq_nvm_update_empr(struct ice_hw *hw)
-{
-	struct ice_aq_desc desc;
-
-	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_nvm_update_empr);
-
-	return ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
-}
-
 /* ice_nvm_set_pkg_data
  * @hw: pointer to the HW struct
  * @del_pkg_data_flag: If is set then the current pkg_data store by FW
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.h b/drivers/net/ethernet/intel/ice/ice_nvm.h
index c6f05f43d593..925225905491 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.h
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.h
@@ -39,7 +39,6 @@ enum ice_status
 ice_aq_erase_nvm(struct ice_hw *hw, u16 module_typeid, struct ice_sq_cd *cd);
 enum ice_status ice_nvm_validate_checksum(struct ice_hw *hw);
 enum ice_status ice_nvm_write_activate(struct ice_hw *hw, u8 cmd_flags);
-enum ice_status ice_aq_nvm_update_empr(struct ice_hw *hw);
 enum ice_status
 ice_nvm_set_pkg_data(struct ice_hw *hw, bool del_pkg_data_flag, u8 *data,
 		     u16 length, struct ice_sq_cd *cd);
-- 
2.27.0

