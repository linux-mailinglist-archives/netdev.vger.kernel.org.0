Return-Path: <netdev+bounces-3961-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88433709D6B
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:05:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70F341C2126C
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:05:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5092512B61;
	Fri, 19 May 2023 17:05:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D8B125DB
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:05:09 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EBE170B
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 10:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684515882; x=1716051882;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+kZcCa3K50dUjjJydgJqPVv5qwKwIYkPtJ+uOI7/d5I=;
  b=FLcBNXw9CpIfoMdIpiaFRAEEQbHTaW1DUhNDN9tQfsA/JCoEOpmd4Z4h
   YmKaK1G/1qEwnO9VXKVVapZyBJ5CeESzPnSQjh8XVbluNwC2IrdsTvfJV
   gsmaFqbnpRSBrufGZr1G1YhLMDPCcQKnZuEiqBMp8Fu68m0/2mTEj835n
   tILnHgsphbKnXQ9cxOIn+Jt3nlZU2eeMesm6Qyrjy0hyHAkls0xQhJZWE
   uTRac8EzBxu/aid17uXKeccjx7CWVEd6qIu305ILCj5AF4mFVJbQK+W2T
   5zyQ3brjc0MXAqQEsC/Wjc2ThZ6dVUtc0urJCAn7DZ3PUPJVrvCeAmsxQ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="337017680"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="337017680"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 10:04:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="846950277"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="846950277"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga001.fm.intel.com with ESMTP; 19 May 2023 10:04:13 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	anthony.l.nguyen@intel.com,
	Piotr Raczynski <piotr.raczynski@intel.com>,
	Simon Horman <simon.horman@corigine.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Subject: [PATCH net-next 2/5] ice: remove redundant Rx field from rule info
Date: Fri, 19 May 2023 10:00:15 -0700
Message-Id: <20230519170018.2820322-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230519170018.2820322-1-anthony.l.nguyen@intel.com>
References: <20230519170018.2820322-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Information about the direction is currently stored in sw_act.flag.
There is no need to duplicate it in another field.

Setting direction flag doesn't mean that there is a match criteria for
direction in rule. It is only a information for HW from where switch id
should be collected (VSI or port). In current implementation of advance
rule handling, without matching for direction meta data, we can always
set one the same flag and everything will work the same.

Ability to match on direction meta data will be added in follow up
patches.

Recipe 0, 3 and 9 loaded from package has direction match
criteria, but they are handled in other function.

Move ice_adv_rule_info fields to avoid holes.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c |  1 -
 drivers/net/ethernet/intel/ice/ice_switch.c  | 22 ++++++++++----------
 drivers/net/ethernet/intel/ice/ice_switch.h  |  8 +++----
 drivers/net/ethernet/intel/ice/ice_tc_lib.c  |  5 -----
 4 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index f6dd3f8fd936..2c80d57331d0 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -39,7 +39,6 @@ ice_eswitch_add_vf_mac_rule(struct ice_pf *pf, struct ice_vf *vf, const u8 *mac)
 	rule_info.sw_act.flag |= ICE_FLTR_TX;
 	rule_info.sw_act.vsi_handle = ctrl_vsi->idx;
 	rule_info.sw_act.fltr_act = ICE_FWD_TO_Q;
-	rule_info.rx = false;
 	rule_info.sw_act.fwd_id.q_id = hw->func_caps.common_cap.rxq_first_id +
 				       ctrl_vsi->rxq_map[vf->vf_id];
 	rule_info.flags_info.act |= ICE_SINGLE_ACT_LB_ENABLE;
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 5c3f266fa80f..e806dfe69b90 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -6121,8 +6121,7 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	if (rinfo->sw_act.fltr_act == ICE_FWD_TO_VSI)
 		rinfo->sw_act.fwd_id.hw_vsi_id =
 			ice_get_hw_vsi_num(hw, vsi_handle);
-	if (rinfo->sw_act.flag & ICE_FLTR_TX)
-		rinfo->sw_act.src = ice_get_hw_vsi_num(hw, vsi_handle);
+	rinfo->sw_act.src = ice_get_hw_vsi_num(hw, vsi_handle);
 
 	status = ice_add_adv_recipe(hw, lkups, lkups_cnt, rinfo, &rid);
 	if (status)
@@ -6190,19 +6189,20 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 		goto err_ice_add_adv_rule;
 	}
 
-	/* set the rule LOOKUP type based on caller specified 'Rx'
-	 * instead of hardcoding it to be either LOOKUP_TX/RX
+	/* If there is no matching criteria for direction there
+	 * is only one difference between Rx and Tx:
+	 * - get switch id base on VSI number from source field (Tx)
+	 * - get switch id base on port number (Rx)
 	 *
-	 * for 'Rx' set the source to be the port number
-	 * for 'Tx' set the source to be the source HW VSI number (determined
-	 * by caller)
+	 * If matching on direction metadata is chose rule direction is
+	 * extracted from type value set here.
 	 */
-	if (rinfo->rx) {
-		s_rule->hdr.type = cpu_to_le16(ICE_AQC_SW_RULES_T_LKUP_RX);
-		s_rule->src = cpu_to_le16(hw->port_info->lport);
-	} else {
+	if (rinfo->sw_act.flag & ICE_FLTR_TX) {
 		s_rule->hdr.type = cpu_to_le16(ICE_AQC_SW_RULES_T_LKUP_TX);
 		s_rule->src = cpu_to_le16(rinfo->sw_act.src);
+	} else {
+		s_rule->hdr.type = cpu_to_le16(ICE_AQC_SW_RULES_T_LKUP_RX);
+		s_rule->src = cpu_to_le16(hw->port_info->lport);
 	}
 
 	s_rule->recipe_id = cpu_to_le16(rid);
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
index 68d8e8a6a189..8e77868d6dca 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.h
+++ b/drivers/net/ethernet/intel/ice/ice_switch.h
@@ -10,7 +10,6 @@
 #define ICE_DFLT_VSI_INVAL 0xff
 #define ICE_FLTR_RX BIT(0)
 #define ICE_FLTR_TX BIT(1)
-#define ICE_FLTR_TX_RX (ICE_FLTR_RX | ICE_FLTR_TX)
 #define ICE_VSI_INVAL_ID 0xffff
 #define ICE_INVAL_Q_HANDLE 0xFFFF
 
@@ -188,11 +187,10 @@ struct ice_adv_rule_flags_info {
 
 struct ice_adv_rule_info {
 	enum ice_sw_tunnel_type tun_type;
-	struct ice_sw_act_ctrl sw_act;
-	u32 priority;
-	u8 rx; /* true means LOOKUP_RX otherwise LOOKUP_TX */
-	u16 fltr_rule_id;
 	u16 vlan_type;
+	u16 fltr_rule_id;
+	u32 priority;
+	struct ice_sw_act_ctrl sw_act;
 	struct ice_adv_rule_flags_info flags_info;
 };
 
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index d1a31f236d26..2b1a34586f47 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -698,12 +698,10 @@ ice_eswitch_add_tc_fltr(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr)
 	if (fltr->direction == ICE_ESWITCH_FLTR_INGRESS) {
 		rule_info.sw_act.flag |= ICE_FLTR_RX;
 		rule_info.sw_act.src = hw->pf_id;
-		rule_info.rx = true;
 		rule_info.flags_info.act = ICE_SINGLE_ACT_LB_ENABLE;
 	} else {
 		rule_info.sw_act.flag |= ICE_FLTR_TX;
 		rule_info.sw_act.src = vsi->idx;
-		rule_info.rx = false;
 		rule_info.flags_info.act = ICE_SINGLE_ACT_LAN_ENABLE;
 	}
 
@@ -910,7 +908,6 @@ ice_add_tc_flower_adv_fltr(struct ice_vsi *vsi,
 		rule_info.sw_act.vsi_handle = dest_vsi->idx;
 		rule_info.priority = ICE_SWITCH_FLTR_PRIO_VSI;
 		rule_info.sw_act.src = hw->pf_id;
-		rule_info.rx = true;
 		dev_dbg(dev, "add switch rule for TC:%u vsi_idx:%u, lkups_cnt:%u\n",
 			tc_fltr->action.fwd.tc.tc_class,
 			rule_info.sw_act.vsi_handle, lkups_cnt);
@@ -921,7 +918,6 @@ ice_add_tc_flower_adv_fltr(struct ice_vsi *vsi,
 		rule_info.sw_act.vsi_handle = dest_vsi->idx;
 		rule_info.priority = ICE_SWITCH_FLTR_PRIO_QUEUE;
 		rule_info.sw_act.src = hw->pf_id;
-		rule_info.rx = true;
 		dev_dbg(dev, "add switch rule action to forward to queue:%u (HW queue %u), lkups_cnt:%u\n",
 			tc_fltr->action.fwd.q.queue,
 			tc_fltr->action.fwd.q.hw_queue, lkups_cnt);
@@ -929,7 +925,6 @@ ice_add_tc_flower_adv_fltr(struct ice_vsi *vsi,
 	case ICE_DROP_PACKET:
 		rule_info.sw_act.flag |= ICE_FLTR_RX;
 		rule_info.sw_act.src = hw->pf_id;
-		rule_info.rx = true;
 		rule_info.priority = ICE_SWITCH_FLTR_PRIO_VSI;
 		break;
 	default:
-- 
2.38.1


