Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F560358957
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbhDHQL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:11:57 -0400
Received: from mga12.intel.com ([192.55.52.136]:30353 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231918AbhDHQLv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 12:11:51 -0400
IronPort-SDR: RayDdndrIag7hDxY6iGETb6E9uDbrhW1I1m/cffjMuuJUJ+WxUvCeWOTQ39d04xPeFXo0A5fje
 yvr03jhYSN1g==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="173052701"
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="173052701"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 09:11:40 -0700
IronPort-SDR: YrnS/K4iVRlJAJ8rtGCD3f2NCPAzLORpZqYhoPciYQYZ81gynuMVuMJb4oLO7XnkjAQRZAe31T
 g7TAMaM04Q2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="415841417"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 08 Apr 2021 09:11:39 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 06/15] ice: Rename a couple of variables
Date:   Thu,  8 Apr 2021 09:13:12 -0700
Message-Id: <20210408161321.3218024-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
References: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

In ice_set_link_ksettings, change 'abilities' to 'phy_caps' and 'p' to
'pi'. This is more consistent with similar usages elsewhere in the
driver.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 50 ++++++++++----------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index c8a8fdac4977..a31b6cf8d599 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2196,12 +2196,12 @@ ice_set_link_ksettings(struct net_device *netdev,
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ethtool_link_ksettings safe_ks, copy_ks;
-	struct ice_aqc_get_phy_caps_data *abilities;
 	u8 autoneg, timeout = TEST_SET_BITS_TIMEOUT;
+	struct ice_aqc_get_phy_caps_data *phy_caps;
 	struct ice_aqc_set_phy_cfg_data config;
 	u16 adv_link_speed, curr_link_speed;
 	struct ice_pf *pf = np->vsi->back;
-	struct ice_port_info *p;
+	struct ice_port_info *pi;
 	u8 autoneg_changed = 0;
 	enum ice_status status;
 	u64 phy_type_high = 0;
@@ -2209,25 +2209,25 @@ ice_set_link_ksettings(struct net_device *netdev,
 	int err = 0;
 	bool linkup;
 
-	p = np->vsi->port_info;
+	pi = np->vsi->port_info;
 
-	if (!p)
+	if (!pi)
 		return -EOPNOTSUPP;
 
-	if (p->phy.media_type != ICE_MEDIA_BASET &&
-	    p->phy.media_type != ICE_MEDIA_FIBER &&
-	    p->phy.media_type != ICE_MEDIA_BACKPLANE &&
-	    p->phy.media_type != ICE_MEDIA_DA &&
-	    p->phy.link_info.link_info & ICE_AQ_LINK_UP)
+	if (pi->phy.media_type != ICE_MEDIA_BASET &&
+	    pi->phy.media_type != ICE_MEDIA_FIBER &&
+	    pi->phy.media_type != ICE_MEDIA_BACKPLANE &&
+	    pi->phy.media_type != ICE_MEDIA_DA &&
+	    pi->phy.link_info.link_info & ICE_AQ_LINK_UP)
 		return -EOPNOTSUPP;
 
-	abilities = kzalloc(sizeof(*abilities), GFP_KERNEL);
-	if (!abilities)
+	phy_caps = kzalloc(sizeof(*phy_caps), GFP_KERNEL);
+	if (!phy_caps)
 		return -ENOMEM;
 
 	/* Get the PHY capabilities based on media */
-	status = ice_aq_get_phy_caps(p, false, ICE_AQC_REPORT_TOPO_CAP_MEDIA,
-				     abilities, NULL);
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP_MEDIA,
+				     phy_caps, NULL);
 	if (status) {
 		err = -EAGAIN;
 		goto done;
@@ -2289,26 +2289,26 @@ ice_set_link_ksettings(struct net_device *netdev,
 	 * configuration is initialized during probe from PHY capabilities
 	 * software mode, and updated on set PHY configuration.
 	 */
-	memcpy(&config, &p->phy.curr_user_phy_cfg, sizeof(config));
+	memcpy(&config, &pi->phy.curr_user_phy_cfg, sizeof(config));
 
 	config.caps |= ICE_AQ_PHY_ENA_AUTO_LINK_UPDT;
 
 	/* Check autoneg */
-	err = ice_setup_autoneg(p, &safe_ks, &config, autoneg, &autoneg_changed,
+	err = ice_setup_autoneg(pi, &safe_ks, &config, autoneg, &autoneg_changed,
 				netdev);
 
 	if (err)
 		goto done;
 
 	/* Call to get the current link speed */
-	p->phy.get_link_info = true;
-	status = ice_get_link_status(p, &linkup);
+	pi->phy.get_link_info = true;
+	status = ice_get_link_status(pi, &linkup);
 	if (status) {
 		err = -EAGAIN;
 		goto done;
 	}
 
-	curr_link_speed = p->phy.link_info.link_speed;
+	curr_link_speed = pi->phy.link_info.link_speed;
 	adv_link_speed = ice_ksettings_find_adv_link_speed(ks);
 
 	/* If speed didn't get set, set it to what it currently is.
@@ -2327,7 +2327,7 @@ ice_set_link_ksettings(struct net_device *netdev,
 	}
 
 	/* save the requested speeds */
-	p->phy.link_info.req_speeds = adv_link_speed;
+	pi->phy.link_info.req_speeds = adv_link_speed;
 
 	/* set link and auto negotiation so changes take effect */
 	config.caps |= ICE_AQ_PHY_ENA_LINK;
@@ -2343,9 +2343,9 @@ ice_set_link_ksettings(struct net_device *netdev,
 	 * for set PHY configuration
 	 */
 	config.phy_type_high = cpu_to_le64(phy_type_high) &
-			abilities->phy_type_high;
+			phy_caps->phy_type_high;
 	config.phy_type_low = cpu_to_le64(phy_type_low) &
-			abilities->phy_type_low;
+			phy_caps->phy_type_low;
 
 	if (!(config.phy_type_high || config.phy_type_low)) {
 		/* If there is no intersection and lenient mode is enabled, then
@@ -2365,7 +2365,7 @@ ice_set_link_ksettings(struct net_device *netdev,
 	}
 
 	/* If link is up put link down */
-	if (p->phy.link_info.link_info & ICE_AQ_LINK_UP) {
+	if (pi->phy.link_info.link_info & ICE_AQ_LINK_UP) {
 		/* Tell the OS link is going down, the link will go
 		 * back up when fw says it is ready asynchronously
 		 */
@@ -2375,7 +2375,7 @@ ice_set_link_ksettings(struct net_device *netdev,
 	}
 
 	/* make the aq call */
-	status = ice_aq_set_phy_cfg(&pf->hw, p, &config, NULL);
+	status = ice_aq_set_phy_cfg(&pf->hw, pi, &config, NULL);
 	if (status) {
 		netdev_info(netdev, "Set phy config failed,\n");
 		err = -EAGAIN;
@@ -2383,9 +2383,9 @@ ice_set_link_ksettings(struct net_device *netdev,
 	}
 
 	/* Save speed request */
-	p->phy.curr_user_speed_req = adv_link_speed;
+	pi->phy.curr_user_speed_req = adv_link_speed;
 done:
-	kfree(abilities);
+	kfree(phy_caps);
 	clear_bit(__ICE_CFG_BUSY, pf->state);
 
 	return err;
-- 
2.26.2

