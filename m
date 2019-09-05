Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67EC1AAD11
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 22:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404003AbfIEUeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 16:34:19 -0400
Received: from mga06.intel.com ([134.134.136.31]:45336 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391672AbfIEUeQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 16:34:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 13:34:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,471,1559545200"; 
   d="scan'208";a="267136574"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga001.jf.intel.com with ESMTP; 05 Sep 2019 13:34:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 16/16] ice: Rework around device/function capabilities
Date:   Thu,  5 Sep 2019 13:34:06 -0700
Message-Id: <20190905203406.4152-17-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190905203406.4152-1-jeffrey.t.kirsher@intel.com>
References: <20190905203406.4152-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

ice_parse_caps is printing capabilities in a different way when
compared to the variable names. This makes it difficult to search for
the right strings in the debug logs. So this patch updates the
print strings to be exactly the same as the fields' name in the
structure.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 40 ++++++++++-----------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index e8397e5b6267..8b2c46615834 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1551,29 +1551,29 @@ ice_parse_caps(struct ice_hw *hw, void *buf, u32 cap_count,
 		case ICE_AQC_CAPS_VALID_FUNCTIONS:
 			caps->valid_functions = number;
 			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: valid functions = %d\n", prefix,
+				  "%s: valid_functions (bitmap) = %d\n", prefix,
 				  caps->valid_functions);
 			break;
 		case ICE_AQC_CAPS_SRIOV:
 			caps->sr_iov_1_1 = (number == 1);
 			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: SR-IOV = %d\n", prefix,
+				  "%s: sr_iov_1_1 = %d\n", prefix,
 				  caps->sr_iov_1_1);
 			break;
 		case ICE_AQC_CAPS_VF:
 			if (dev_p) {
 				dev_p->num_vfs_exposed = number;
 				ice_debug(hw, ICE_DBG_INIT,
-					  "%s: VFs exposed = %d\n", prefix,
+					  "%s: num_vfs_exposed = %d\n", prefix,
 					  dev_p->num_vfs_exposed);
 			} else if (func_p) {
 				func_p->num_allocd_vfs = number;
 				func_p->vf_base_id = logical_id;
 				ice_debug(hw, ICE_DBG_INIT,
-					  "%s: VFs allocated = %d\n", prefix,
+					  "%s: num_allocd_vfs = %d\n", prefix,
 					  func_p->num_allocd_vfs);
 				ice_debug(hw, ICE_DBG_INIT,
-					  "%s: VF base_id = %d\n", prefix,
+					  "%s: vf_base_id = %d\n", prefix,
 					  func_p->vf_base_id);
 			}
 			break;
@@ -1581,17 +1581,17 @@ ice_parse_caps(struct ice_hw *hw, void *buf, u32 cap_count,
 			if (dev_p) {
 				dev_p->num_vsi_allocd_to_host = number;
 				ice_debug(hw, ICE_DBG_INIT,
-					  "%s: num VSI alloc to host = %d\n",
+					  "%s: num_vsi_allocd_to_host = %d\n",
 					  prefix,
 					  dev_p->num_vsi_allocd_to_host);
 			} else if (func_p) {
 				func_p->guar_num_vsi =
 					ice_get_num_per_func(hw, ICE_MAX_VSI);
 				ice_debug(hw, ICE_DBG_INIT,
-					  "%s: num guaranteed VSI (fw) = %d\n",
+					  "%s: guar_num_vsi (fw) = %d\n",
 					  prefix, number);
 				ice_debug(hw, ICE_DBG_INIT,
-					  "%s: num guaranteed VSI = %d\n",
+					  "%s: guar_num_vsi = %d\n",
 					  prefix, func_p->guar_num_vsi);
 			}
 			break;
@@ -1600,56 +1600,56 @@ ice_parse_caps(struct ice_hw *hw, void *buf, u32 cap_count,
 			caps->active_tc_bitmap = logical_id;
 			caps->maxtc = phys_id;
 			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: DCB = %d\n", prefix, caps->dcb);
+				  "%s: dcb = %d\n", prefix, caps->dcb);
 			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: active TC bitmap = %d\n", prefix,
+				  "%s: active_tc_bitmap = %d\n", prefix,
 				  caps->active_tc_bitmap);
 			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: TC max = %d\n", prefix, caps->maxtc);
+				  "%s: maxtc = %d\n", prefix, caps->maxtc);
 			break;
 		case ICE_AQC_CAPS_RSS:
 			caps->rss_table_size = number;
 			caps->rss_table_entry_width = logical_id;
 			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: RSS table size = %d\n", prefix,
+				  "%s: rss_table_size = %d\n", prefix,
 				  caps->rss_table_size);
 			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: RSS table width = %d\n", prefix,
+				  "%s: rss_table_entry_width = %d\n", prefix,
 				  caps->rss_table_entry_width);
 			break;
 		case ICE_AQC_CAPS_RXQS:
 			caps->num_rxq = number;
 			caps->rxq_first_id = phys_id;
 			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: num Rx queues = %d\n", prefix,
+				  "%s: num_rxq = %d\n", prefix,
 				  caps->num_rxq);
 			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: Rx first queue ID = %d\n", prefix,
+				  "%s: rxq_first_id = %d\n", prefix,
 				  caps->rxq_first_id);
 			break;
 		case ICE_AQC_CAPS_TXQS:
 			caps->num_txq = number;
 			caps->txq_first_id = phys_id;
 			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: num Tx queues = %d\n", prefix,
+				  "%s: num_txq = %d\n", prefix,
 				  caps->num_txq);
 			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: Tx first queue ID = %d\n", prefix,
+				  "%s: txq_first_id = %d\n", prefix,
 				  caps->txq_first_id);
 			break;
 		case ICE_AQC_CAPS_MSIX:
 			caps->num_msix_vectors = number;
 			caps->msix_vector_first_id = phys_id;
 			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: MSIX vector count = %d\n", prefix,
+				  "%s: num_msix_vectors = %d\n", prefix,
 				  caps->num_msix_vectors);
 			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: MSIX first vector index = %d\n", prefix,
+				  "%s: msix_vector_first_id = %d\n", prefix,
 				  caps->msix_vector_first_id);
 			break;
 		case ICE_AQC_CAPS_MAX_MTU:
 			caps->max_mtu = number;
-			ice_debug(hw, ICE_DBG_INIT, "%s: max MTU = %d\n",
+			ice_debug(hw, ICE_DBG_INIT, "%s: max_mtu = %d\n",
 				  prefix, caps->max_mtu);
 			break;
 		default:
-- 
2.21.0

