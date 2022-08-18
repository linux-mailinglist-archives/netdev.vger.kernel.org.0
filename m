Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD55598827
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234229AbiHRPzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344494AbiHRPyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:54:44 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B815558B
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660838001; x=1692374001;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B/Gh8EdwBL/LkLd2lGw7ugYDy1MkR3+F6Fq4AclZ5J4=;
  b=McCvNhBHi78l8l+SM4FXnY6bq76eQzxhhhTP1BUGJUKb3w4hJi3LJt/f
   i9mZURyNHY89qnzXYkoMX/tksQCEVu3nbrGt+K3WSPQW9I2fpAF8lNb5V
   VnY58G7PwR/Cc34wk9yhFnxlWjspHKumn4jTJcsZDIlpIt/RyIqG8vNEs
   VLKEAh5PVVvOpRFFq+lQ9gxtzAI+ATtka26vBfMNKzpePzHbYW2ZK5dyR
   XOIsO+4Z3RVDnnMx5eqXddC3Dc87hhBzw6NSpIxbqvTRjvH61cRchyMqT
   blH9MGN8LN53ErevMmG8vz4r8Sc7sZaQHZrHx200S+5AlT9KR/YEGNgng
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="318817400"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="318817400"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 08:52:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="676104321"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2022 08:52:13 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 4/5] ice: Remove ucast_shared
Date:   Thu, 18 Aug 2022 08:52:06 -0700
Message-Id: <20220818155207.996297-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220818155207.996297-1-anthony.l.nguyen@intel.com>
References: <20220818155207.996297-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>

Remove ucast_shared as it was always true. Remove the code depending on
ucast_shared from ice_add_mac and ice_remove_mac.
Remove ice_find_ucast_rule_entry function as it was only
used when ucast_shared was set to false.

Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c   |   2 -
 drivers/net/ethernet/intel/ice/ice_switch.c | 166 +-------------------
 drivers/net/ethernet/intel/ice/ice_type.h   |   2 -
 3 files changed, 5 insertions(+), 165 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 8dfecdc74a18..d38c848021ef 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4662,8 +4662,6 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		ice_set_safe_mode_caps(hw);
 	}
 
-	hw->ucast_shared = true;
-
 	err = ice_init_pf(pf);
 	if (err) {
 		dev_err(dev, "ice_init_pf failed: %d\n", err);
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 262e553e3b58..131bdba70d0f 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -3449,31 +3449,15 @@ bool ice_vlan_fltr_exist(struct ice_hw *hw, u16 vlan_id, u16 vsi_handle)
  * ice_add_mac - Add a MAC address based filter rule
  * @hw: pointer to the hardware structure
  * @m_list: list of MAC addresses and forwarding information
- *
- * IMPORTANT: When the ucast_shared flag is set to false and m_list has
- * multiple unicast addresses, the function assumes that all the
- * addresses are unique in a given add_mac call. It doesn't
- * check for duplicates in this case, removing duplicates from a given
- * list should be taken care of in the caller of this function.
  */
 int ice_add_mac(struct ice_hw *hw, struct list_head *m_list)
 {
-	struct ice_sw_rule_lkup_rx_tx *s_rule, *r_iter;
 	struct ice_fltr_list_entry *m_list_itr;
-	struct list_head *rule_head;
-	u16 total_elem_left, s_rule_size;
-	struct ice_switch_info *sw;
-	struct mutex *rule_lock; /* Lock to protect filter rule list */
-	u16 num_unicast = 0;
 	int status = 0;
-	u8 elem_sent;
 
 	if (!m_list || !hw)
 		return -EINVAL;
 
-	s_rule = NULL;
-	sw = hw->switch_info;
-	rule_lock = &sw->recp_list[ICE_SW_LKUP_MAC].filt_rule_lock;
 	list_for_each_entry(m_list_itr, m_list, list_entry) {
 		u8 *add = &m_list_itr->fltr_info.l_data.mac.mac_addr[0];
 		u16 vsi_handle;
@@ -3492,106 +3476,13 @@ int ice_add_mac(struct ice_hw *hw, struct list_head *m_list)
 		if (m_list_itr->fltr_info.lkup_type != ICE_SW_LKUP_MAC ||
 		    is_zero_ether_addr(add))
 			return -EINVAL;
-		if (is_unicast_ether_addr(add) && !hw->ucast_shared) {
-			/* Don't overwrite the unicast address */
-			mutex_lock(rule_lock);
-			if (ice_find_rule_entry(hw, ICE_SW_LKUP_MAC,
-						&m_list_itr->fltr_info)) {
-				mutex_unlock(rule_lock);
-				return -EEXIST;
-			}
-			mutex_unlock(rule_lock);
-			num_unicast++;
-		} else if (is_multicast_ether_addr(add) ||
-			   (is_unicast_ether_addr(add) && hw->ucast_shared)) {
-			m_list_itr->status =
-				ice_add_rule_internal(hw, ICE_SW_LKUP_MAC,
-						      m_list_itr);
-			if (m_list_itr->status)
-				return m_list_itr->status;
-		}
-	}
-
-	mutex_lock(rule_lock);
-	/* Exit if no suitable entries were found for adding bulk switch rule */
-	if (!num_unicast) {
-		status = 0;
-		goto ice_add_mac_exit;
-	}
-
-	rule_head = &sw->recp_list[ICE_SW_LKUP_MAC].filt_rules;
-
-	/* Allocate switch rule buffer for the bulk update for unicast */
-	s_rule_size = ICE_SW_RULE_RX_TX_ETH_HDR_SIZE(s_rule);
-	s_rule = devm_kcalloc(ice_hw_to_dev(hw), num_unicast, s_rule_size,
-			      GFP_KERNEL);
-	if (!s_rule) {
-		status = -ENOMEM;
-		goto ice_add_mac_exit;
-	}
-
-	r_iter = s_rule;
-	list_for_each_entry(m_list_itr, m_list, list_entry) {
-		struct ice_fltr_info *f_info = &m_list_itr->fltr_info;
-		u8 *mac_addr = &f_info->l_data.mac.mac_addr[0];
-
-		if (is_unicast_ether_addr(mac_addr)) {
-			ice_fill_sw_rule(hw, &m_list_itr->fltr_info, r_iter,
-					 ice_aqc_opc_add_sw_rules);
-			r_iter = (typeof(s_rule))((u8 *)r_iter + s_rule_size);
-		}
-	}
-
-	/* Call AQ bulk switch rule update for all unicast addresses */
-	r_iter = s_rule;
-	/* Call AQ switch rule in AQ_MAX chunk */
-	for (total_elem_left = num_unicast; total_elem_left > 0;
-	     total_elem_left -= elem_sent) {
-		struct ice_sw_rule_lkup_rx_tx *entry = r_iter;
-
-		elem_sent = min_t(u8, total_elem_left,
-				  (ICE_AQ_MAX_BUF_LEN / s_rule_size));
-		status = ice_aq_sw_rules(hw, entry, elem_sent * s_rule_size,
-					 elem_sent, ice_aqc_opc_add_sw_rules,
-					 NULL);
-		if (status)
-			goto ice_add_mac_exit;
-		r_iter = (typeof(s_rule))
-			((u8 *)r_iter + (elem_sent * s_rule_size));
-	}
-
-	/* Fill up rule ID based on the value returned from FW */
-	r_iter = s_rule;
-	list_for_each_entry(m_list_itr, m_list, list_entry) {
-		struct ice_fltr_info *f_info = &m_list_itr->fltr_info;
-		u8 *mac_addr = &f_info->l_data.mac.mac_addr[0];
-		struct ice_fltr_mgmt_list_entry *fm_entry;
-
-		if (is_unicast_ether_addr(mac_addr)) {
-			f_info->fltr_rule_id = le16_to_cpu(r_iter->index);
-			f_info->fltr_act = ICE_FWD_TO_VSI;
-			/* Create an entry to track this MAC address */
-			fm_entry = devm_kzalloc(ice_hw_to_dev(hw),
-						sizeof(*fm_entry), GFP_KERNEL);
-			if (!fm_entry) {
-				status = -ENOMEM;
-				goto ice_add_mac_exit;
-			}
-			fm_entry->fltr_info = *f_info;
-			fm_entry->vsi_count = 1;
-			/* The book keeping entries will get removed when
-			 * base driver calls remove filter AQ command
-			 */
 
-			list_add(&fm_entry->list_entry, rule_head);
-			r_iter = (typeof(s_rule))((u8 *)r_iter + s_rule_size);
-		}
+		m_list_itr->status = ice_add_rule_internal(hw, ICE_SW_LKUP_MAC,
+							   m_list_itr);
+		if (m_list_itr->status)
+			return m_list_itr->status;
 	}
 
-ice_add_mac_exit:
-	mutex_unlock(rule_lock);
-	if (s_rule)
-		devm_kfree(ice_hw_to_dev(hw), s_rule);
 	return status;
 }
 
@@ -3978,38 +3869,6 @@ ice_check_if_dflt_vsi(struct ice_port_info *pi, u16 vsi_handle,
 	return ret;
 }
 
-/**
- * ice_find_ucast_rule_entry - Search for a unicast MAC filter rule entry
- * @hw: pointer to the hardware structure
- * @recp_id: lookup type for which the specified rule needs to be searched
- * @f_info: rule information
- *
- * Helper function to search for a unicast rule entry - this is to be used
- * to remove unicast MAC filter that is not shared with other VSIs on the
- * PF switch.
- *
- * Returns pointer to entry storing the rule if found
- */
-static struct ice_fltr_mgmt_list_entry *
-ice_find_ucast_rule_entry(struct ice_hw *hw, u8 recp_id,
-			  struct ice_fltr_info *f_info)
-{
-	struct ice_switch_info *sw = hw->switch_info;
-	struct ice_fltr_mgmt_list_entry *list_itr;
-	struct list_head *list_head;
-
-	list_head = &sw->recp_list[recp_id].filt_rules;
-	list_for_each_entry(list_itr, list_head, list_entry) {
-		if (!memcmp(&f_info->l_data, &list_itr->fltr_info.l_data,
-			    sizeof(f_info->l_data)) &&
-		    f_info->fwd_id.hw_vsi_id ==
-		    list_itr->fltr_info.fwd_id.hw_vsi_id &&
-		    f_info->flag == list_itr->fltr_info.flag)
-			return list_itr;
-	}
-	return NULL;
-}
-
 /**
  * ice_remove_mac - remove a MAC address based filter rule
  * @hw: pointer to the hardware structure
@@ -4026,15 +3885,12 @@ ice_find_ucast_rule_entry(struct ice_hw *hw, u8 recp_id,
 int ice_remove_mac(struct ice_hw *hw, struct list_head *m_list)
 {
 	struct ice_fltr_list_entry *list_itr, *tmp;
-	struct mutex *rule_lock; /* Lock to protect filter rule list */
 
 	if (!m_list)
 		return -EINVAL;
 
-	rule_lock = &hw->switch_info->recp_list[ICE_SW_LKUP_MAC].filt_rule_lock;
 	list_for_each_entry_safe(list_itr, tmp, m_list, list_entry) {
 		enum ice_sw_lkup_type l_type = list_itr->fltr_info.lkup_type;
-		u8 *add = &list_itr->fltr_info.l_data.mac.mac_addr[0];
 		u16 vsi_handle;
 
 		if (l_type != ICE_SW_LKUP_MAC)
@@ -4046,19 +3902,7 @@ int ice_remove_mac(struct ice_hw *hw, struct list_head *m_list)
 
 		list_itr->fltr_info.fwd_id.hw_vsi_id =
 					ice_get_hw_vsi_num(hw, vsi_handle);
-		if (is_unicast_ether_addr(add) && !hw->ucast_shared) {
-			/* Don't remove the unicast address that belongs to
-			 * another VSI on the switch, since it is not being
-			 * shared...
-			 */
-			mutex_lock(rule_lock);
-			if (!ice_find_ucast_rule_entry(hw, ICE_SW_LKUP_MAC,
-						       &list_itr->fltr_info)) {
-				mutex_unlock(rule_lock);
-				return -ENOENT;
-			}
-			mutex_unlock(rule_lock);
-		}
+
 		list_itr->status = ice_remove_rule_internal(hw,
 							    ICE_SW_LKUP_MAC,
 							    list_itr);
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 861b64322959..8651f6c735ba 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -885,8 +885,6 @@ struct ice_hw {
 	/* INTRL granularity in 1 us */
 	u8 intrl_gran;
 
-	u8 ucast_shared;	/* true if VSIs can share unicast addr */
-
 #define ICE_PHY_PER_NAC		1
 #define ICE_MAX_QUAD		2
 #define ICE_NUM_QUAD_TYPE	2
-- 
2.35.1

