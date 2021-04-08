Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F67358956
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbhDHQL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:11:56 -0400
Received: from mga07.intel.com ([134.134.136.100]:15196 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231908AbhDHQLv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 12:11:51 -0400
IronPort-SDR: N/BDx+ZHatm3ryvOOYC7PJSxxmWmyAB5oWRLhEMMcJhwE+ZvoERShOKk7ZeKLSbBdXn9rPVvB6
 Ey56HoC5afaw==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="257557981"
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="257557981"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 09:11:39 -0700
IronPort-SDR: T/GiMOLBysanJooAj2kHdz3JenS2MDsxgHMOm3xs0oLu7YlMoDWChPaWEjncc7Tr5oGb9p4/0J
 Rnf5QmxzJSJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="415841398"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 08 Apr 2021 09:11:38 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 03/15] ice: Align macro names to the specification
Date:   Thu,  8 Apr 2021 09:13:09 -0700
Message-Id: <20210408161321.3218024-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
References: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

For get PHY abilities AQ, the specification defines "report modes"
as "with media", "without media" and "active configuration". For
clarity, rename macros to align with the specification.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h | 10 +++++-----
 drivers/net/ethernet/intel/ice/ice_common.c     | 13 +++++++------
 drivers/net/ethernet/intel/ice/ice_ethtool.c    | 12 ++++++------
 drivers/net/ethernet/intel/ice/ice_main.c       | 12 ++++++------
 4 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index b9491ef5f21c..3f3d51bf0019 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -882,11 +882,11 @@ struct ice_aqc_get_phy_caps {
 	 * 01b - Report topology capabilities
 	 * 10b - Report SW configured
 	 */
-#define ICE_AQC_REPORT_MODE_S		1
-#define ICE_AQC_REPORT_MODE_M		(3 << ICE_AQC_REPORT_MODE_S)
-#define ICE_AQC_REPORT_NVM_CAP		0
-#define ICE_AQC_REPORT_TOPO_CAP		BIT(1)
-#define ICE_AQC_REPORT_SW_CFG		BIT(2)
+#define ICE_AQC_REPORT_MODE_S			1
+#define ICE_AQC_REPORT_MODE_M			(3 << ICE_AQC_REPORT_MODE_S)
+#define ICE_AQC_REPORT_TOPO_CAP_NO_MEDIA	0
+#define ICE_AQC_REPORT_TOPO_CAP_MEDIA		BIT(1)
+#define ICE_AQC_REPORT_ACTIVE_CFG		BIT(2)
 	__le32 reserved1;
 	__le32 addr_high;
 	__le32 addr_low;
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index bde19e30394d..509dce475bff 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -191,7 +191,7 @@ ice_aq_get_phy_caps(struct ice_port_info *pi, bool qual_mods, u8 report_mode,
 	ice_debug(hw, ICE_DBG_LINK, "   module_type[2] = 0x%x\n",
 		  pcaps->module_type[2]);
 
-	if (!status && report_mode == ICE_AQC_REPORT_TOPO_CAP) {
+	if (!status && report_mode == ICE_AQC_REPORT_TOPO_CAP_MEDIA) {
 		pi->phy.phy_type_low = le64_to_cpu(pcaps->phy_type_low);
 		pi->phy.phy_type_high = le64_to_cpu(pcaps->phy_type_high);
 		memcpy(pi->phy.link_info.module_type, &pcaps->module_type,
@@ -922,7 +922,8 @@ enum ice_status ice_init_hw(struct ice_hw *hw)
 
 	/* Initialize port_info struct with PHY capabilities */
 	status = ice_aq_get_phy_caps(hw->port_info, false,
-				     ICE_AQC_REPORT_TOPO_CAP, pcaps, NULL);
+				     ICE_AQC_REPORT_TOPO_CAP_MEDIA, pcaps,
+				     NULL);
 	devm_kfree(ice_hw_to_dev(hw), pcaps);
 	if (status)
 		dev_warn(ice_hw_to_dev(hw), "Get PHY capabilities failed status = %d, continuing anyway\n",
@@ -2734,7 +2735,7 @@ enum ice_status ice_update_link_info(struct ice_port_info *pi)
 		if (!pcaps)
 			return ICE_ERR_NO_MEMORY;
 
-		status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP,
+		status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP_MEDIA,
 					     pcaps, NULL);
 
 		devm_kfree(ice_hw_to_dev(hw), pcaps);
@@ -2894,8 +2895,8 @@ ice_set_fc(struct ice_port_info *pi, u8 *aq_failures, bool ena_auto_link_update)
 		return ICE_ERR_NO_MEMORY;
 
 	/* Get the current PHY config */
-	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_SW_CFG, pcaps,
-				     NULL);
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_ACTIVE_CFG,
+				     pcaps, NULL);
 	if (status) {
 		*aq_failures = ICE_SET_FC_AQ_FAIL_GET;
 		goto out;
@@ -3041,7 +3042,7 @@ ice_cfg_phy_fec(struct ice_port_info *pi, struct ice_aqc_set_phy_cfg_data *cfg,
 	if (!pcaps)
 		return ICE_ERR_NO_MEMORY;
 
-	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP, pcaps,
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP_MEDIA, pcaps,
 				     NULL);
 	if (status)
 		goto out;
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 15152e63f204..84e42e598c85 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1060,7 +1060,7 @@ ice_get_fecparam(struct net_device *netdev, struct ethtool_fecparam *fecparam)
 	if (!caps)
 		return -ENOMEM;
 
-	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP,
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP_MEDIA,
 				     caps, NULL);
 	if (status) {
 		err = -EAGAIN;
@@ -2000,7 +2000,7 @@ ice_get_link_ksettings(struct net_device *netdev,
 		return -ENOMEM;
 
 	status = ice_aq_get_phy_caps(vsi->port_info, false,
-				     ICE_AQC_REPORT_SW_CFG, caps, NULL);
+				     ICE_AQC_REPORT_ACTIVE_CFG, caps, NULL);
 	if (status) {
 		err = -EIO;
 		goto done;
@@ -2037,7 +2037,7 @@ ice_get_link_ksettings(struct net_device *netdev,
 		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_RS);
 
 	status = ice_aq_get_phy_caps(vsi->port_info, false,
-				     ICE_AQC_REPORT_TOPO_CAP, caps, NULL);
+				     ICE_AQC_REPORT_TOPO_CAP_MEDIA, caps, NULL);
 	if (status) {
 		err = -EIO;
 		goto done;
@@ -2243,7 +2243,7 @@ ice_set_link_ksettings(struct net_device *netdev,
 		return -ENOMEM;
 
 	/* Get the PHY capabilities based on media */
-	status = ice_aq_get_phy_caps(p, false, ICE_AQC_REPORT_TOPO_CAP,
+	status = ice_aq_get_phy_caps(p, false, ICE_AQC_REPORT_TOPO_CAP_MEDIA,
 				     abilities, NULL);
 	if (status) {
 		err = -EAGAIN;
@@ -2972,7 +2972,7 @@ ice_get_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
 		return;
 
 	/* Get current PHY config */
-	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_SW_CFG, pcaps,
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_ACTIVE_CFG, pcaps,
 				     NULL);
 	if (status)
 		goto out;
@@ -3039,7 +3039,7 @@ ice_set_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
 		return -ENOMEM;
 
 	/* Get current PHY config */
-	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_SW_CFG, pcaps,
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_ACTIVE_CFG, pcaps,
 				     NULL);
 	if (status) {
 		kfree(pcaps);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index b3c1cadecf21..4379bbece4d9 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -720,7 +720,7 @@ void ice_print_link_msg(struct ice_vsi *vsi, bool isup)
 	}
 
 	status = ice_aq_get_phy_caps(vsi->port_info, false,
-				     ICE_AQC_REPORT_SW_CFG, caps, NULL);
+				     ICE_AQC_REPORT_ACTIVE_CFG, caps, NULL);
 	if (status)
 		netdev_info(vsi->netdev, "Get phy capability failed.\n");
 
@@ -1631,7 +1631,7 @@ static int ice_force_phys_link_state(struct ice_vsi *vsi, bool link_up)
 	if (!pcaps)
 		return -ENOMEM;
 
-	retcode = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_SW_CFG, pcaps,
+	retcode = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_ACTIVE_CFG, pcaps,
 				      NULL);
 	if (retcode) {
 		dev_err(dev, "Failed to get phy capabilities, VSI %d error %d\n",
@@ -1691,7 +1691,7 @@ static int ice_init_nvm_phy_type(struct ice_port_info *pi)
 	if (!pcaps)
 		return -ENOMEM;
 
-	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_NVM_CAP, pcaps,
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP_NO_MEDIA, pcaps,
 				     NULL);
 
 	if (status) {
@@ -1807,7 +1807,7 @@ static int ice_init_phy_user_cfg(struct ice_port_info *pi)
 	if (!pcaps)
 		return -ENOMEM;
 
-	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP, pcaps,
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP_MEDIA, pcaps,
 				     NULL);
 	if (status) {
 		dev_err(ice_pf_to_dev(pf), "Get PHY capability failed.\n");
@@ -1886,7 +1886,7 @@ static int ice_configure_phy(struct ice_vsi *vsi)
 		return -ENOMEM;
 
 	/* Get current PHY config */
-	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_SW_CFG, pcaps,
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_ACTIVE_CFG, pcaps,
 				     NULL);
 	if (status) {
 		dev_err(dev, "Failed to get PHY configuration, VSI %d error %s\n",
@@ -1904,7 +1904,7 @@ static int ice_configure_phy(struct ice_vsi *vsi)
 
 	/* Use PHY topology as baseline for configuration */
 	memset(pcaps, 0, sizeof(*pcaps));
-	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP, pcaps,
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP_MEDIA, pcaps,
 				     NULL);
 	if (status) {
 		dev_err(dev, "Failed to get PHY topology, VSI %d error %s\n",
-- 
2.26.2

