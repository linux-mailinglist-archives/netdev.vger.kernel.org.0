Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D47C67451D
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 22:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbjASVnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 16:43:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbjASVji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 16:39:38 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2549F3B6
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 13:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674163687; x=1705699687;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bbogxn4dTFOoS30SWxO8ied0q5yWF514D5Cn8p8wyK4=;
  b=BUAD0+MIn2c/T0gJy1vNWXQqDz94hRxfzP1KUTgZsB9U+KsbhETJHjDt
   opW0y63ezKCM2WO8fy2CcjCSPb+Gb8LzNXMFekVr/FTFB9jC6pMLb3HcW
   MDEAPmSBH3NY7ZFJaihWxSlC5l4iBpMt2QuuEKOA6RSIieoB+mI3GTRAU
   aAA2CHeM+z90NuumrUa7F4omPFZkXq0KAtT8dxU3yYRl0z5OZq+rRz49t
   nosYi3o+KPrga54hBRM87D130YgMS+c7XtOkoxvT/Wd+qQNO+Yi/+IGGx
   qFyf3pWXW0BVTAAY/amTxacL78SmC3Dc/vtheHk3ciO5Gfk+isDUShAR9
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="323120645"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="323120645"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 13:27:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="692589900"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="692589900"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 19 Jan 2023 13:27:28 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 11/15] ice: Reduce scope of variables
Date:   Thu, 19 Jan 2023 13:27:38 -0800
Message-Id: <20230119212742.2106833-12-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230119212742.2106833-1-anthony.l.nguyen@intel.com>
References: <20230119212742.2106833-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some places where the scope of a variable can
be reduced, so do that.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
---
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c | 9 ++++++---
 drivers/net/ethernet/intel/ice/ice_sched.c     | 6 ++++--
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index fc74bfcc3b1e..5ce413965930 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -391,10 +391,11 @@ ice_upd_dvm_boost_entry(struct ice_hw *hw, struct ice_dvm_entry *entry)
  */
 int ice_set_dvm_boost_entries(struct ice_hw *hw)
 {
-	int status;
 	u16 i;
 
 	for (i = 0; i < hw->dvm_upd.count; i++) {
+		int status;
+
 		status = ice_upd_dvm_boost_entry(hw, &hw->dvm_upd.tbl[i]);
 		if (status)
 			return status;
@@ -3195,12 +3196,13 @@ ice_rem_vsig(struct ice_hw *hw, enum ice_block blk, u16 vsig,
 	u16 idx = vsig & ICE_VSIG_IDX_M;
 	struct ice_vsig_vsi *vsi_cur;
 	struct ice_vsig_prof *d, *t;
-	int status;
 
 	/* remove TCAM entries */
 	list_for_each_entry_safe(d, t,
 				 &hw->blk[blk].xlt2.vsig_tbl[idx].prop_lst,
 				 list) {
+		int status;
+
 		status = ice_rem_prof_id(hw, blk, d);
 		if (status)
 			return status;
@@ -3251,12 +3253,13 @@ ice_rem_prof_id_vsig(struct ice_hw *hw, enum ice_block blk, u16 vsig, u64 hdl,
 {
 	u16 idx = vsig & ICE_VSIG_IDX_M;
 	struct ice_vsig_prof *p, *t;
-	int status;
 
 	list_for_each_entry_safe(p, t,
 				 &hw->blk[blk].xlt2.vsig_tbl[idx].prop_lst,
 				 list)
 		if (p->profile_cookie == hdl) {
+			int status;
+
 			if (ice_vsig_prof_id_count(hw, blk, vsig) == 1)
 				/* this is the last profile, remove the VSIG */
 				return ice_rem_vsig(hw, blk, vsig, chg);
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 70568f8af72a..4eca8d195ef0 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -1654,12 +1654,13 @@ ice_sched_add_vsi_child_nodes(struct ice_port_info *pi, u16 vsi_handle,
 	u32 first_node_teid;
 	u16 num_added = 0;
 	u8 i, qgl, vsil;
-	int status;
 
 	qgl = ice_sched_get_qgrp_layer(hw);
 	vsil = ice_sched_get_vsi_layer(hw);
 	parent = ice_sched_get_vsi_node(pi, tc_node, vsi_handle);
 	for (i = vsil + 1; i <= qgl; i++) {
+		int status;
+
 		if (!parent)
 			return -EIO;
 
@@ -1755,13 +1756,14 @@ ice_sched_add_vsi_support_nodes(struct ice_port_info *pi, u16 vsi_handle,
 	u32 first_node_teid;
 	u16 num_added = 0;
 	u8 i, vsil;
-	int status;
 
 	if (!pi)
 		return -EINVAL;
 
 	vsil = ice_sched_get_vsi_layer(pi->hw);
 	for (i = pi->hw->sw_entry_point_layer; i <= vsil; i++) {
+		int status;
+
 		status = ice_sched_add_nodes_to_layer(pi, tc_node, parent,
 						      i, num_nodes[i],
 						      &first_node_teid,
-- 
2.38.1

