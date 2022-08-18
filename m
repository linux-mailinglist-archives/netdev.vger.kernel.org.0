Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFF3B598823
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344466AbiHRPzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344465AbiHRPyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:54:43 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAE6267C
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660838000; x=1692374000;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+XSlFo76cz0brYvMzxLon8+5AyYb5F0MG+zsGZdkCx8=;
  b=jRqk4SxwNMuVSvtXuKg5Zq2sU1advDloCGrEKppJ4FSxlvVivSd3B6HV
   1BbUx2kA/nfzu8473F7Zur7McOo2O8Is4TOOu5QEx5D6rAgJfCVmMHNBs
   Ct0WkOL1gWDWFvXlwMxyyNyyMm4EA5a2dXmjyiDlipbYEBrO0eRqOoUk0
   HRTICSYyYL0XMCuiA7HRRQELMMs3vXiAk2r6zsUfA2zBC/eyUKLbhx6XE
   dI/XknePqYNdWJaGVx1FjiOsifZsLfymv4o36voLAdF7lvJ+GJadtKTad
   0a1lS76le01Gyce5FFjlEnYMAi+BPRkrgsadVSLkEG/9i809eKUxLRlCa
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="318817396"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="318817396"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 08:52:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="676104316"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2022 08:52:13 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Chinh T Cao <chinh.t.cao@intel.com>,
        Mikael Barsehyan <mikael.barsehyan@intel.com>,
        Kavya AV <kavyax.av@intel.com>
Subject: [PATCH net-next 3/5] ice: Allow 100M speeds for some devices
Date:   Thu, 18 Aug 2022 08:52:05 -0700
Message-Id: <20220818155207.996297-4-anthony.l.nguyen@intel.com>
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

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

For certain devices, 100M speeds are supported. Do not mask off
100M speed for these devices.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Co-developed-by: Chinh T Cao <chinh.t.cao@intel.com>
Signed-off-by: Chinh T Cao <chinh.t.cao@intel.com>
Signed-off-by: Mikael Barsehyan <mikael.barsehyan@intel.com>
Tested-by: Kavya AV <kavyax.av@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c  | 20 ++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.h  |  1 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 11 +++++++----
 3 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 27d0cbbd29da..c8d95b299fee 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -2775,6 +2775,26 @@ ice_aq_set_port_params(struct ice_port_info *pi, bool double_vlan,
 	return ice_aq_send_cmd(hw, &desc, NULL, 0, cd);
 }
 
+/**
+ * ice_is_100m_speed_supported
+ * @hw: pointer to the HW struct
+ *
+ * returns true if 100M speeds are supported by the device,
+ * false otherwise.
+ */
+bool ice_is_100m_speed_supported(struct ice_hw *hw)
+{
+	switch (hw->device_id) {
+	case ICE_DEV_ID_E822C_SGMII:
+	case ICE_DEV_ID_E822L_SGMII:
+	case ICE_DEV_ID_E823L_1GBE:
+	case ICE_DEV_ID_E823C_SGMII:
+		return true;
+	default:
+		return false;
+	}
+}
+
 /**
  * ice_get_link_speed_based_on_phy_type - returns link speed
  * @phy_type_low: lower part of phy_type
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 61b7c60db689..d08f7f9ea8b7 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -204,6 +204,7 @@ ice_aq_set_gpio(struct ice_hw *hw, u16 gpio_ctrl_handle, u8 pin_idx, bool value,
 int
 ice_aq_get_gpio(struct ice_hw *hw, u16 gpio_ctrl_handle, u8 pin_idx,
 		bool *value, struct ice_sq_cd *cd);
+bool ice_is_100m_speed_supported(struct ice_hw *hw);
 int
 ice_aq_set_lldp_mib(struct ice_hw *hw, u8 mib_type, void *buf, u16 buf_size,
 		    struct ice_sq_cd *cd);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index ad6cffb2d3e0..b7be84bbe72d 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1470,20 +1470,22 @@ ice_get_ethtool_stats(struct net_device *netdev,
 
 /**
  * ice_mask_min_supported_speeds
+ * @hw: pointer to the HW structure
  * @phy_types_high: PHY type high
  * @phy_types_low: PHY type low to apply minimum supported speeds mask
  *
  * Apply minimum supported speeds mask to PHY type low. These are the speeds
  * for ethtool supported link mode.
  */
-static
-void ice_mask_min_supported_speeds(u64 phy_types_high, u64 *phy_types_low)
+static void
+ice_mask_min_supported_speeds(struct ice_hw *hw,
+			      u64 phy_types_high, u64 *phy_types_low)
 {
 	/* if QSFP connection with 100G speed, minimum supported speed is 25G */
 	if (*phy_types_low & ICE_PHY_TYPE_LOW_MASK_100G ||
 	    phy_types_high & ICE_PHY_TYPE_HIGH_MASK_100G)
 		*phy_types_low &= ~ICE_PHY_TYPE_LOW_MASK_MIN_25G;
-	else
+	else if (!ice_is_100m_speed_supported(hw))
 		*phy_types_low &= ~ICE_PHY_TYPE_LOW_MASK_MIN_1G;
 }
 
@@ -1533,7 +1535,8 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 		phy_types_low = le64_to_cpu(pf->nvm_phy_type_lo);
 		phy_types_high = le64_to_cpu(pf->nvm_phy_type_hi);
 
-		ice_mask_min_supported_speeds(phy_types_high, &phy_types_low);
+		ice_mask_min_supported_speeds(&pf->hw, phy_types_high,
+					      &phy_types_low);
 		/* determine advertised modes based on link override only
 		 * if it's supported and if the FW doesn't abstract the
 		 * driver from having to account for link overrides
-- 
2.35.1

