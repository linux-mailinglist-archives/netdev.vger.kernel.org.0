Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B16D730243
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfE3Suv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:50:51 -0400
Received: from mga04.intel.com ([192.55.52.120]:30432 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726697AbfE3Suk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 14:50:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 11:50:37 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 30 May 2019 11:50:37 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/15] ice: Use a different ICE_DBG bit for firmware log messages
Date:   Thu, 30 May 2019 11:50:43 -0700
Message-Id: <20190530185045.3886-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530185045.3886-1-jeffrey.t.kirsher@intel.com>
References: <20190530185045.3886-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Replace the use of the ICE_DBG_AQ_MSG bit when dumping firmware logging
messages with a separate distinct type ICE_DBG_FW_LOG. This is useful
so that developers may enable ICE_DBG_FW_LOG and get firmware logging
messages, without also dumping AdminQ messages at the same time.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 6 +++---
 drivers/net/ethernet/intel/ice/ice_type.h   | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 1c94be588716..724f2975f3da 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -681,10 +681,10 @@ static enum ice_status ice_cfg_fw_log(struct ice_hw *hw, bool enable)
  */
 void ice_output_fw_log(struct ice_hw *hw, struct ice_aq_desc *desc, void *buf)
 {
-	ice_debug(hw, ICE_DBG_AQ_MSG, "[ FW Log Msg Start ]\n");
-	ice_debug_array(hw, ICE_DBG_AQ_MSG, 16, 1, (u8 *)buf,
+	ice_debug(hw, ICE_DBG_FW_LOG, "[ FW Log Msg Start ]\n");
+	ice_debug_array(hw, ICE_DBG_FW_LOG, 16, 1, (u8 *)buf,
 			le16_to_cpu(desc->datalen));
-	ice_debug(hw, ICE_DBG_AQ_MSG, "[ FW Log Msg End ]\n");
+	ice_debug(hw, ICE_DBG_FW_LOG, "[ FW Log Msg End ]\n");
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index b6d0399f49b9..3474bccbab6d 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -23,6 +23,7 @@ static inline bool ice_is_tc_ena(u8 bitmap, u8 tc)
 
 /* debug masks - set these bits in hw->debug_mask to control output */
 #define ICE_DBG_INIT		BIT_ULL(1)
+#define ICE_DBG_FW_LOG		BIT_ULL(3)
 #define ICE_DBG_LINK		BIT_ULL(4)
 #define ICE_DBG_PHY		BIT_ULL(5)
 #define ICE_DBG_QCTX		BIT_ULL(6)
-- 
2.21.0

