Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF11922BA5E
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 01:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgGWXrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 19:47:49 -0400
Received: from mga12.intel.com ([192.55.52.136]:33991 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbgGWXra (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 19:47:30 -0400
IronPort-SDR: LFg9Z/Ti5fQKp3oyjdpYN1V1wKDT1rIf34BWp6VXWfX3w44jYBT3gZ1TsuD2c4TizCGb0Q2hv+
 RjZKQ+sFbsIw==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="130200246"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="130200246"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 16:47:26 -0700
IronPort-SDR: ku+GrwFQcohbcx1WMYb4HM1hq+Il13vJXQ5hDFHY8Rln3OKXPIRwZRO4nwOJBjpp7GSlL6RoKY
 mARj8adLC3kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="328742316"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 23 Jul 2020 16:47:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Lev Faerman <lev.faerman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 12/15] ice: Rename low_power_ctrl
Date:   Thu, 23 Jul 2020 16:47:17 -0700
Message-Id: <20200723234720.1547308-13-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200723234720.1547308-1-anthony.l.nguyen@intel.com>
References: <20200723234720.1547308-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lev Faerman <lev.faerman@intel.com>

Rename the low_power_ctrl field to low_power_ctrl_an to be properly
descriptive of it being an autoneg field.

Signed-off-by: Lev Faerman <lev.faerman@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h    |  4 ++--
 drivers/net/ethernet/intel/ice/ice_common.c    | 18 +++++++++---------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 800364be3bc8..31b6fd8dc0dc 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -961,7 +961,7 @@ struct ice_aqc_get_phy_caps_data {
 #define ICE_AQC_GET_PHY_EN_MOD_QUAL			BIT(5)
 #define ICE_AQC_PHY_EN_AUTO_FEC				BIT(7)
 #define ICE_AQC_PHY_CAPS_MASK				ICE_M(0xff, 0)
-	u8 low_power_ctrl;
+	u8 low_power_ctrl_an;
 #define ICE_AQC_PHY_EN_D3COLD_LOW_POWER_AUTONEG		BIT(0)
 #define ICE_AQC_PHY_AN_EN_CLAUSE28			BIT(1)
 #define ICE_AQC_PHY_AN_EN_CLAUSE73			BIT(2)
@@ -1036,7 +1036,7 @@ struct ice_aqc_set_phy_cfg_data {
 #define ICE_AQ_PHY_ENA_AUTO_LINK_UPDT	BIT(5)
 #define ICE_AQ_PHY_ENA_LESM		BIT(6)
 #define ICE_AQ_PHY_ENA_AUTO_FEC		BIT(7)
-	u8 low_power_ctrl;
+	u8 low_power_ctrl_an;
 	__le16 eee_cap; /* Value from ice_aqc_get_phy_caps */
 	__le16 eeer_value;
 	u8 link_fec_opt; /* Use defines from ice_aqc_get_phy_caps */
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index ea8f09497d44..695711e48acc 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -173,8 +173,8 @@ ice_aq_get_phy_caps(struct ice_port_info *pi, bool qual_mods, u8 report_mode,
 	ice_debug(hw, ICE_DBG_LINK, "	phy_type_high = 0x%llx\n",
 		  (unsigned long long)le64_to_cpu(pcaps->phy_type_high));
 	ice_debug(hw, ICE_DBG_LINK, "	caps = 0x%x\n", pcaps->caps);
-	ice_debug(hw, ICE_DBG_LINK, "	low_power_ctrl = 0x%x\n",
-		  pcaps->low_power_ctrl);
+	ice_debug(hw, ICE_DBG_LINK, "	low_power_ctrl_an = 0x%x\n",
+		  pcaps->low_power_ctrl_an);
 	ice_debug(hw, ICE_DBG_LINK, "	eee_cap = 0x%x\n", pcaps->eee_cap);
 	ice_debug(hw, ICE_DBG_LINK, "	eeer_value = 0x%x\n",
 		  pcaps->eeer_value);
@@ -2525,8 +2525,8 @@ ice_aq_set_phy_cfg(struct ice_hw *hw, struct ice_port_info *pi,
 	ice_debug(hw, ICE_DBG_LINK, "	phy_type_high = 0x%llx\n",
 		  (unsigned long long)le64_to_cpu(cfg->phy_type_high));
 	ice_debug(hw, ICE_DBG_LINK, "	caps = 0x%x\n", cfg->caps);
-	ice_debug(hw, ICE_DBG_LINK, "	low_power_ctrl = 0x%x\n",
-		  cfg->low_power_ctrl);
+	ice_debug(hw, ICE_DBG_LINK, "	low_power_ctrl_an = 0x%x\n",
+		  cfg->low_power_ctrl_an);
 	ice_debug(hw, ICE_DBG_LINK, "	eee_cap = 0x%x\n", cfg->eee_cap);
 	ice_debug(hw, ICE_DBG_LINK, "	eeer_value = 0x%x\n", cfg->eeer_value);
 	ice_debug(hw, ICE_DBG_LINK, "	link_fec_opt = 0x%x\n",
@@ -2811,7 +2811,7 @@ ice_phy_caps_equals_cfg(struct ice_aqc_get_phy_caps_data *phy_caps,
 	if (phy_caps->phy_type_low != phy_cfg->phy_type_low ||
 	    phy_caps->phy_type_high != phy_cfg->phy_type_high ||
 	    ((phy_caps->caps & caps_mask) != (phy_cfg->caps & cfg_mask)) ||
-	    phy_caps->low_power_ctrl != phy_cfg->low_power_ctrl ||
+	    phy_caps->low_power_ctrl_an != phy_cfg->low_power_ctrl_an ||
 	    phy_caps->eee_cap != phy_cfg->eee_cap ||
 	    phy_caps->eeer_value != phy_cfg->eeer_value ||
 	    phy_caps->link_fec_options != phy_cfg->link_fec_opt)
@@ -2841,7 +2841,7 @@ ice_copy_phy_caps_to_cfg(struct ice_port_info *pi,
 	cfg->phy_type_low = caps->phy_type_low;
 	cfg->phy_type_high = caps->phy_type_high;
 	cfg->caps = caps->caps;
-	cfg->low_power_ctrl = caps->low_power_ctrl;
+	cfg->low_power_ctrl_an = caps->low_power_ctrl_an;
 	cfg->eee_cap = caps->eee_cap;
 	cfg->eeer_value = caps->eeer_value;
 	cfg->link_fec_opt = caps->link_fec_options;
@@ -4245,9 +4245,9 @@ ice_get_link_default_override(struct ice_link_default_override_tlv *ldo,
 bool ice_is_phy_caps_an_enabled(struct ice_aqc_get_phy_caps_data *caps)
 {
 	if (caps->caps & ICE_AQC_PHY_AN_MODE ||
-	    caps->low_power_ctrl & (ICE_AQC_PHY_AN_EN_CLAUSE28 |
-				    ICE_AQC_PHY_AN_EN_CLAUSE73 |
-				    ICE_AQC_PHY_AN_EN_CLAUSE37))
+	    caps->low_power_ctrl_an & (ICE_AQC_PHY_AN_EN_CLAUSE28 |
+				       ICE_AQC_PHY_AN_EN_CLAUSE73 |
+				       ICE_AQC_PHY_AN_EN_CLAUSE37))
 		return true;
 
 	return false;
-- 
2.26.2

