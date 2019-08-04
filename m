Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 614F080AC5
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 13:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbfHDL7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 07:59:36 -0400
Received: from mga05.intel.com ([192.55.52.43]:50581 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726234AbfHDL73 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Aug 2019 07:59:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Aug 2019 04:59:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,345,1559545200"; 
   d="scan'208";a="178602034"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 04 Aug 2019 04:59:28 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 6/8] fm10k: mark unused parameters with __always_unused
Date:   Sun,  4 Aug 2019 04:59:24 -0700
Message-Id: <20190804115926.31944-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190804115926.31944-1-jeffrey.t.kirsher@intel.com>
References: <20190804115926.31944-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Several functions in the fm10k driver have specific function templates,
as they are used as function pointers. The parameters in these functions
are not always used. Explicitly mark unused parameters with the
__always_unused macro, so that the compiler will not warn about them
when building with the -Wunused-parameter warning enabled.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_mbx.c  |  5 ++--
 drivers/net/ethernet/intel/fm10k/fm10k_pf.c   | 10 ++++----
 drivers/net/ethernet/intel/fm10k/fm10k_tlv.c  |  7 +++---
 drivers/net/ethernet/intel/fm10k/fm10k_type.h |  2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_vf.c   | 25 +++++++++++--------
 5 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c b/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
index aece335b41f8..75e51f91036c 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright(c) 2013 - 2018 Intel Corporation. */
+/* Copyright(c) 2013 - 2019 Intel Corporation. */
 
 #include "fm10k_common.h"
 
@@ -2134,7 +2134,8 @@ static s32 fm10k_sm_mbx_process(struct fm10k_hw *hw,
  *  DWORDs, not bytes.  Any invalid values will cause the mailbox to return
  *  error.
  **/
-s32 fm10k_sm_mbx_init(struct fm10k_hw *hw, struct fm10k_mbx_info *mbx,
+s32 fm10k_sm_mbx_init(struct fm10k_hw __always_unused *hw,
+		      struct fm10k_mbx_info *mbx,
 		      const struct fm10k_msg_data *msg_data)
 {
 	mbx->mbx_reg = FM10K_GMBX;
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_pf.c b/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
index e85b2f2eef05..095c5b0e4096 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright(c) 2013 - 2018 Intel Corporation. */
+/* Copyright(c) 2013 - 2019 Intel Corporation. */
 
 #include "fm10k_pf.h"
 #include "fm10k_vf.h"
@@ -1152,7 +1152,7 @@ static void fm10k_iov_update_stats_pf(struct fm10k_hw *hw,
  *  assumption is that in this case it is acceptable to just directly
  *  hand off the message from the VF to the underlying shared code.
  **/
-s32 fm10k_iov_msg_msix_pf(struct fm10k_hw *hw, u32 **results,
+s32 fm10k_iov_msg_msix_pf(struct fm10k_hw *hw, u32 __always_unused **results,
 			  struct fm10k_mbx_info *mbx)
 {
 	struct fm10k_vf_info *vf_info = (struct fm10k_vf_info *)mbx;
@@ -1641,7 +1641,7 @@ const struct fm10k_tlv_attr fm10k_lport_map_msg_attr[] = {
  *  switch API.
  **/
 s32 fm10k_msg_lport_map_pf(struct fm10k_hw *hw, u32 **results,
-			   struct fm10k_mbx_info *mbx)
+			   struct fm10k_mbx_info __always_unused *mbx)
 {
 	u16 glort, mask;
 	u32 dglort_map;
@@ -1684,7 +1684,7 @@ const struct fm10k_tlv_attr fm10k_update_pvid_msg_attr[] = {
  *  This handler configures the default VLAN for the PF
  **/
 static s32 fm10k_msg_update_pvid_pf(struct fm10k_hw *hw, u32 **results,
-				    struct fm10k_mbx_info *mbx)
+				    struct fm10k_mbx_info __always_unused *mbx)
 {
 	u16 glort, pvid;
 	u32 pvid_update;
@@ -1745,7 +1745,7 @@ const struct fm10k_tlv_attr fm10k_err_msg_attr[] = {
  *  messages that the PF has sent.
  **/
 s32 fm10k_msg_err_pf(struct fm10k_hw *hw, u32 **results,
-		     struct fm10k_mbx_info *mbx)
+		     struct fm10k_mbx_info __always_unused *mbx)
 {
 	struct fm10k_swapi_error err_msg;
 	s32 err;
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_tlv.c b/drivers/net/ethernet/intel/fm10k/fm10k_tlv.c
index f4c42a40f934..21eff0895a7a 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_tlv.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_tlv.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright(c) 2013 - 2018 Intel Corporation. */
+/* Copyright(c) 2013 - 2019 Intel Corporation. */
 
 #include "fm10k_tlv.h"
 
@@ -587,8 +587,9 @@ s32 fm10k_tlv_msg_parse(struct fm10k_hw *hw, u32 *msg,
  *  a minimum it just indicates that the message requested was
  *  unimplemented.
  **/
-s32 fm10k_tlv_msg_error(struct fm10k_hw *hw, u32 **results,
-			struct fm10k_mbx_info *mbx)
+s32 fm10k_tlv_msg_error(struct fm10k_hw __always_unused *hw,
+			u32 __always_unused **results,
+			struct fm10k_mbx_info __always_unused *mbx)
 {
 	return FM10K_NOT_IMPLEMENTED;
 }
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_type.h b/drivers/net/ethernet/intel/fm10k/fm10k_type.h
index 9fb9fca375e3..15ac1c7885bc 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_type.h
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_type.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright(c) 2013 - 2018 Intel Corporation. */
+/* Copyright(c) 2013 - 2019 Intel Corporation. */
 
 #ifndef _FM10K_TYPE_H_
 #define _FM10K_TYPE_H_
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_vf.c b/drivers/net/ethernet/intel/fm10k/fm10k_vf.c
index a8519c1f0406..dc8ccd378ec9 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_vf.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_vf.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright(c) 2013 - 2018 Intel Corporation. */
+/* Copyright(c) 2013 - 2019 Intel Corporation. */
 
 #include "fm10k_vf.h"
 
@@ -198,7 +198,7 @@ static s32 fm10k_update_vlan_vf(struct fm10k_hw *hw, u32 vid, u8 vsi, bool set)
  *  This function should determine the MAC address for the VF
  **/
 s32 fm10k_msg_mac_vlan_vf(struct fm10k_hw *hw, u32 **results,
-			  struct fm10k_mbx_info *mbx)
+			  struct fm10k_mbx_info __always_unused *mbx)
 {
 	u8 perm_addr[ETH_ALEN];
 	u16 vid;
@@ -267,8 +267,10 @@ static s32 fm10k_read_mac_addr_vf(struct fm10k_hw *hw)
  *  This function is used to add or remove unicast MAC addresses for
  *  the VF.
  **/
-static s32 fm10k_update_uc_addr_vf(struct fm10k_hw *hw, u16 glort,
-				   const u8 *mac, u16 vid, bool add, u8 flags)
+static s32 fm10k_update_uc_addr_vf(struct fm10k_hw *hw,
+				   u16 __always_unused glort,
+				   const u8 *mac, u16 vid, bool add,
+				   u8 __always_unused flags)
 {
 	struct fm10k_mbx_info *mbx = &hw->mbx;
 	u32 msg[7];
@@ -309,7 +311,8 @@ static s32 fm10k_update_uc_addr_vf(struct fm10k_hw *hw, u16 glort,
  *  This function is used to add or remove multicast MAC addresses for
  *  the VF.
  **/
-static s32 fm10k_update_mc_addr_vf(struct fm10k_hw *hw, u16 glort,
+static s32 fm10k_update_mc_addr_vf(struct fm10k_hw *hw,
+				   u16 __always_unused glort,
 				   const u8 *mac, u16 vid, bool add)
 {
 	struct fm10k_mbx_info *mbx = &hw->mbx;
@@ -373,7 +376,7 @@ const struct fm10k_tlv_attr fm10k_lport_state_msg_attr[] = {
  *  are ready to bring up the interface.
  **/
 s32 fm10k_msg_lport_state_vf(struct fm10k_hw *hw, u32 **results,
-			     struct fm10k_mbx_info *mbx)
+			     struct fm10k_mbx_info __always_unused *mbx)
 {
 	hw->mac.dglort_map = !results[FM10K_LPORT_STATE_MSG_READY] ?
 			     FM10K_DGLORTMAP_NONE : FM10K_DGLORTMAP_ZERO;
@@ -392,8 +395,9 @@ s32 fm10k_msg_lport_state_vf(struct fm10k_hw *hw, u32 **results,
  *  enabled we can add filters, if it is disabled all filters for this
  *  logical port are flushed.
  **/
-static s32 fm10k_update_lport_state_vf(struct fm10k_hw *hw, u16 glort,
-				       u16 count, bool enable)
+static s32 fm10k_update_lport_state_vf(struct fm10k_hw *hw,
+				       u16 __always_unused glort,
+				       u16 __always_unused count, bool enable)
 {
 	struct fm10k_mbx_info *mbx = &hw->mbx;
 	u32 msg[2];
@@ -420,7 +424,8 @@ static s32 fm10k_update_lport_state_vf(struct fm10k_hw *hw, u16 glort,
  *  so that it can enable either multicast, multicast promiscuous, or
  *  promiscuous mode of operation.
  **/
-static s32 fm10k_update_xcast_mode_vf(struct fm10k_hw *hw, u16 glort, u8 mode)
+static s32 fm10k_update_xcast_mode_vf(struct fm10k_hw *hw,
+				      u16 __always_unused glort, u8 mode)
 {
 	struct fm10k_mbx_info *mbx = &hw->mbx;
 	u32 msg[3];
@@ -475,7 +480,7 @@ static void fm10k_rebind_hw_stats_vf(struct fm10k_hw *hw,
  *  that information to then populate a DGLORTMAP/DEC entry and the queues
  *  to which it has been assigned.
  **/
-static s32 fm10k_configure_dglort_map_vf(struct fm10k_hw *hw,
+static s32 fm10k_configure_dglort_map_vf(struct fm10k_hw __always_unused *hw,
 					 struct fm10k_dglort_cfg *dglort)
 {
 	/* verify the dglort pointer */
-- 
2.21.0

