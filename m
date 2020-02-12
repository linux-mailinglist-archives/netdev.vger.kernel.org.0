Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5AA15B2C8
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 22:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbgBLVeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 16:34:09 -0500
Received: from mga18.intel.com ([134.134.136.126]:18127 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729160AbgBLVeE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 16:34:04 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Feb 2020 13:34:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,434,1574150400"; 
   d="scan'208";a="233911710"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga003.jf.intel.com with ESMTP; 12 Feb 2020 13:34:00 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 12/15] ice: Make print statements more compact
Date:   Wed, 12 Feb 2020 13:33:54 -0800
Message-Id: <20200212213357.2198911-13-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200212213357.2198911-1-jeffrey.t.kirsher@intel.com>
References: <20200212213357.2198911-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Formatting strings in print function calls (like dev_info, dev_err, etc.)
can exceed 80 columns without making checkpatch unhappy. So remove
newlines where applicable and make print statements more compact.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c     |  22 +--
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   7 +-
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c   |  10 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  42 ++---
 drivers/net/ethernet/intel/ice/ice_lib.c      |  36 ++--
 drivers/net/ethernet/intel/ice/ice_main.c     | 167 +++++++-----------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  62 +++----
 drivers/net/ethernet/intel/ice/ice_xsk.c      |   4 +-
 8 files changed, 123 insertions(+), 227 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 8c7d08e2916e..46f427a95056 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -405,8 +405,7 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	/* Absolute queue number out of 2K needs to be passed */
 	err = ice_write_rxq_ctx(hw, &rlan_ctx, pf_q);
 	if (err) {
-		dev_err(ice_pf_to_dev(vsi->back),
-			"Failed to set LAN Rx queue context for absolute Rx queue %d error: %d\n",
+		dev_err(ice_pf_to_dev(vsi->back), "Failed to set LAN Rx queue context for absolute Rx queue %d error: %d\n",
 			pf_q, err);
 		return -EIO;
 	}
@@ -428,8 +427,7 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	      ice_alloc_rx_bufs_slow_zc(ring, ICE_DESC_UNUSED(ring)) :
 	      ice_alloc_rx_bufs(ring, ICE_DESC_UNUSED(ring));
 	if (err)
-		dev_info(ice_pf_to_dev(vsi->back),
-			 "Failed allocate some buffers on %sRx ring %d (pf_q %d)\n",
+		dev_info(ice_pf_to_dev(vsi->back), "Failed allocate some buffers on %sRx ring %d (pf_q %d)\n",
 			 ring->xsk_umem ? "UMEM enabled " : "",
 			 ring->q_index, pf_q);
 
@@ -490,8 +488,7 @@ int ice_vsi_ctrl_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx)
 	/* wait for the change to finish */
 	ret = ice_pf_rxq_wait(pf, pf_q, ena);
 	if (ret)
-		dev_err(ice_pf_to_dev(pf),
-			"VSI idx %d Rx ring %d %sable timeout\n",
+		dev_err(ice_pf_to_dev(pf), "VSI idx %d Rx ring %d %sable timeout\n",
 			vsi->idx, pf_q, (ena ? "en" : "dis"));
 
 	return ret;
@@ -648,8 +645,7 @@ ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_ring *ring,
 	status = ice_ena_vsi_txq(vsi->port_info, vsi->idx, tc, ring->q_handle,
 				 1, qg_buf, buf_len, NULL);
 	if (status) {
-		dev_err(ice_pf_to_dev(pf),
-			"Failed to set LAN Tx queue context, error: %d\n",
+		dev_err(ice_pf_to_dev(pf), "Failed to set LAN Tx queue context, error: %d\n",
 			status);
 		return -ENODEV;
 	}
@@ -815,14 +811,12 @@ ice_vsi_stop_tx_ring(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 	 * queues at the hardware level anyway.
 	 */
 	if (status == ICE_ERR_RESET_ONGOING) {
-		dev_dbg(ice_pf_to_dev(vsi->back),
-			"Reset in progress. LAN Tx queues already disabled\n");
+		dev_dbg(ice_pf_to_dev(vsi->back), "Reset in progress. LAN Tx queues already disabled\n");
 	} else if (status == ICE_ERR_DOES_NOT_EXIST) {
-		dev_dbg(ice_pf_to_dev(vsi->back),
-			"LAN Tx queues do not exist, nothing to disable\n");
+		dev_dbg(ice_pf_to_dev(vsi->back), "LAN Tx queues do not exist, nothing to disable\n");
 	} else if (status) {
-		dev_err(ice_pf_to_dev(vsi->back),
-			"Failed to disable LAN Tx queues, error: %d\n", status);
+		dev_err(ice_pf_to_dev(vsi->back), "Failed to disable LAN Tx queues, error: %d\n",
+			status);
 		return -ENODEV;
 	}
 
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 99ee4c009a96..adc69fe1bd64 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -577,8 +577,7 @@ int ice_init_pf_dcb(struct ice_pf *pf, bool locked)
 		goto dcb_init_err;
 	}
 
-	dev_info(dev,
-		 "DCB is enabled in the hardware, max number of TCs supported on this port are %d\n",
+	dev_info(dev, "DCB is enabled in the hardware, max number of TCs supported on this port are %d\n",
 		 pf->hw.func_caps.common_cap.maxtc);
 	if (err) {
 		struct ice_vsi *pf_vsi;
@@ -588,8 +587,8 @@ int ice_init_pf_dcb(struct ice_pf *pf, bool locked)
 		clear_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags);
 		err = ice_dcb_sw_dflt_cfg(pf, true, locked);
 		if (err) {
-			dev_err(dev,
-				"Failed to set local DCB config %d\n", err);
+			dev_err(dev, "Failed to set local DCB config %d\n",
+				err);
 			err = -EIO;
 			goto dcb_init_err;
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
index 265cf69b321b..b61aba428adb 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
@@ -297,8 +297,7 @@ ice_dcbnl_get_pfc_cfg(struct net_device *netdev, int prio, u8 *setting)
 		return;
 
 	*setting = (pi->local_dcbx_cfg.pfc.pfcena >> prio) & 0x1;
-	dev_dbg(ice_pf_to_dev(pf),
-		"Get PFC Config up=%d, setting=%d, pfcenable=0x%x\n",
+	dev_dbg(ice_pf_to_dev(pf), "Get PFC Config up=%d, setting=%d, pfcenable=0x%x\n",
 		prio, *setting, pi->local_dcbx_cfg.pfc.pfcena);
 }
 
@@ -418,8 +417,8 @@ ice_dcbnl_get_pg_tc_cfg_tx(struct net_device *netdev, int prio,
 		return;
 
 	*pgid = pi->local_dcbx_cfg.etscfg.prio_table[prio];
-	dev_dbg(ice_pf_to_dev(pf),
-		"Get PG config prio=%d tc=%d\n", prio, *pgid);
+	dev_dbg(ice_pf_to_dev(pf), "Get PG config prio=%d tc=%d\n", prio,
+		*pgid);
 }
 
 /**
@@ -882,8 +881,7 @@ ice_dcbnl_vsi_del_app(struct ice_vsi *vsi,
 	sapp.protocol = app->prot_id;
 	sapp.priority = app->priority;
 	err = ice_dcbnl_delapp(vsi->netdev, &sapp);
-	dev_dbg(ice_pf_to_dev(vsi->back),
-		"Deleting app for VSI idx=%d err=%d sel=%d proto=0x%x, prio=%d\n",
+	dev_dbg(ice_pf_to_dev(vsi->back), "Deleting app for VSI idx=%d err=%d sel=%d proto=0x%x, prio=%d\n",
 		vsi->idx, err, app->selector, app->prot_id, app->priority);
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 8110da94c979..4b29d1ae56a7 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -374,8 +374,7 @@ static int ice_reg_pattern_test(struct ice_hw *hw, u32 reg, u32 mask)
 		val = rd32(hw, reg);
 		if (val == pattern)
 			continue;
-		dev_err(dev,
-			"%s: reg pattern test failed - reg 0x%08x pat 0x%08x val 0x%08x\n"
+		dev_err(dev, "%s: reg pattern test failed - reg 0x%08x pat 0x%08x val 0x%08x\n"
 			, __func__, reg, pattern, val);
 		return 1;
 	}
@@ -383,8 +382,7 @@ static int ice_reg_pattern_test(struct ice_hw *hw, u32 reg, u32 mask)
 	wr32(hw, reg, orig_val);
 	val = rd32(hw, reg);
 	if (val != orig_val) {
-		dev_err(dev,
-			"%s: reg restore test failed - reg 0x%08x orig 0x%08x val 0x%08x\n"
+		dev_err(dev, "%s: reg restore test failed - reg 0x%08x orig 0x%08x val 0x%08x\n"
 			, __func__, reg, orig_val, val);
 		return 1;
 	}
@@ -802,8 +800,7 @@ ice_self_test(struct net_device *netdev, struct ethtool_test *eth_test,
 		set_bit(__ICE_TESTING, pf->state);
 
 		if (ice_active_vfs(pf)) {
-			dev_warn(dev,
-				 "Please take active VFs and Netqueues offline and restart the adapter before running NIC diagnostics\n");
+			dev_warn(dev, "Please take active VFs and Netqueues offline and restart the adapter before running NIC diagnostics\n");
 			data[ICE_ETH_TEST_REG] = 1;
 			data[ICE_ETH_TEST_EEPROM] = 1;
 			data[ICE_ETH_TEST_INTR] = 1;
@@ -1211,8 +1208,7 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 			 * events to respond to.
 			 */
 			if (status)
-				dev_info(dev,
-					 "Failed to unreg for LLDP events\n");
+				dev_info(dev, "Failed to unreg for LLDP events\n");
 
 			/* The AQ call to stop the FW LLDP agent will generate
 			 * an error if the agent is already stopped.
@@ -1267,8 +1263,7 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 			/* Register for MIB change events */
 			status = ice_cfg_lldp_mib_change(&pf->hw, true);
 			if (status)
-				dev_dbg(dev,
-					"Fail to enable MIB change events\n");
+				dev_dbg(dev, "Fail to enable MIB change events\n");
 		}
 	}
 	if (test_bit(ICE_FLAG_LEGACY_RX, change_flags)) {
@@ -1761,8 +1756,7 @@ ice_get_settings_link_up(struct ethtool_link_ksettings *ks,
 		ks->base.speed = SPEED_100;
 		break;
 	default:
-		netdev_info(netdev,
-			    "WARNING: Unrecognized link_speed (0x%x).\n",
+		netdev_info(netdev, "WARNING: Unrecognized link_speed (0x%x).\n",
 			    link_info->link_speed);
 		break;
 	}
@@ -2578,13 +2572,11 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
 
 	new_tx_cnt = ALIGN(ring->tx_pending, ICE_REQ_DESC_MULTIPLE);
 	if (new_tx_cnt != ring->tx_pending)
-		netdev_info(netdev,
-			    "Requested Tx descriptor count rounded up to %d\n",
+		netdev_info(netdev, "Requested Tx descriptor count rounded up to %d\n",
 			    new_tx_cnt);
 	new_rx_cnt = ALIGN(ring->rx_pending, ICE_REQ_DESC_MULTIPLE);
 	if (new_rx_cnt != ring->rx_pending)
-		netdev_info(netdev,
-			    "Requested Rx descriptor count rounded up to %d\n",
+		netdev_info(netdev, "Requested Rx descriptor count rounded up to %d\n",
 			    new_rx_cnt);
 
 	/* if nothing to do return success */
@@ -3451,8 +3443,7 @@ ice_set_rc_coalesce(enum ice_container_type c_type, struct ethtool_coalesce *ec,
 		if (ec->rx_coalesce_usecs_high > ICE_MAX_INTRL ||
 		    (ec->rx_coalesce_usecs_high &&
 		     ec->rx_coalesce_usecs_high < pf->hw.intrl_gran)) {
-			netdev_info(vsi->netdev,
-				    "Invalid value, %s-usecs-high valid values are 0 (disabled), %d-%d\n",
+			netdev_info(vsi->netdev, "Invalid value, %s-usecs-high valid values are 0 (disabled), %d-%d\n",
 				    c_type_str, pf->hw.intrl_gran,
 				    ICE_MAX_INTRL);
 			return -EINVAL;
@@ -3470,8 +3461,7 @@ ice_set_rc_coalesce(enum ice_container_type c_type, struct ethtool_coalesce *ec,
 		break;
 	case ICE_TX_CONTAINER:
 		if (ec->tx_coalesce_usecs_high) {
-			netdev_info(vsi->netdev,
-				    "setting %s-usecs-high is not supported\n",
+			netdev_info(vsi->netdev, "setting %s-usecs-high is not supported\n",
 				    c_type_str);
 			return -EINVAL;
 		}
@@ -3488,23 +3478,20 @@ ice_set_rc_coalesce(enum ice_container_type c_type, struct ethtool_coalesce *ec,
 
 	itr_setting = rc->itr_setting & ~ICE_ITR_DYNAMIC;
 	if (coalesce_usecs != itr_setting && use_adaptive_coalesce) {
-		netdev_info(vsi->netdev,
-			    "%s interrupt throttling cannot be changed if adaptive-%s is enabled\n",
+		netdev_info(vsi->netdev, "%s interrupt throttling cannot be changed if adaptive-%s is enabled\n",
 			    c_type_str, c_type_str);
 		return -EINVAL;
 	}
 
 	if (coalesce_usecs > ICE_ITR_MAX) {
-		netdev_info(vsi->netdev,
-			    "Invalid value, %s-usecs range is 0-%d\n",
+		netdev_info(vsi->netdev, "Invalid value, %s-usecs range is 0-%d\n",
 			    c_type_str, ICE_ITR_MAX);
 		return -EINVAL;
 	}
 
 	/* hardware only supports an ITR granularity of 2us */
 	if (coalesce_usecs % 2 != 0) {
-		netdev_info(vsi->netdev,
-			    "Invalid value, %s-usecs must be even\n",
+		netdev_info(vsi->netdev, "Invalid value, %s-usecs must be even\n",
 			    c_type_str);
 		return -EINVAL;
 	}
@@ -3745,8 +3732,7 @@ ice_get_module_info(struct net_device *netdev,
 		}
 		break;
 	default:
-		netdev_warn(netdev,
-			    "SFF Module Type not recognized.\n");
+		netdev_warn(netdev, "SFF Module Type not recognized.\n");
 		return -EINVAL;
 	}
 	return 0;
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 797773a45a98..4f5116554dcc 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -117,8 +117,7 @@ static void ice_vsi_set_num_desc(struct ice_vsi *vsi)
 		vsi->num_tx_desc = ICE_DFLT_NUM_TX_DESC;
 		break;
 	default:
-		dev_dbg(ice_pf_to_dev(vsi->back),
-			"Not setting number of Tx/Rx descriptors for VSI type %d\n",
+		dev_dbg(ice_pf_to_dev(vsi->back), "Not setting number of Tx/Rx descriptors for VSI type %d\n",
 			vsi->type);
 		break;
 	}
@@ -929,8 +928,7 @@ static int ice_vsi_setup_vector_base(struct ice_vsi *vsi)
 	vsi->base_vector = ice_get_res(pf, pf->irq_tracker, num_q_vectors,
 				       vsi->idx);
 	if (vsi->base_vector < 0) {
-		dev_err(dev,
-			"Failed to get tracking for %d vectors for VSI %d, err=%d\n",
+		dev_err(dev, "Failed to get tracking for %d vectors for VSI %d, err=%d\n",
 			num_q_vectors, vsi->vsi_num, vsi->base_vector);
 		return -ENOENT;
 	}
@@ -1392,12 +1390,10 @@ int ice_vsi_kill_vlan(struct ice_vsi *vsi, u16 vid)
 
 	status = ice_remove_vlan(&pf->hw, &tmp_add_list);
 	if (status == ICE_ERR_DOES_NOT_EXIST) {
-		dev_dbg(dev,
-			"Failed to remove VLAN %d on VSI %i, it does not exist, status: %d\n",
+		dev_dbg(dev, "Failed to remove VLAN %d on VSI %i, it does not exist, status: %d\n",
 			vid, vsi->vsi_num, status);
 	} else if (status) {
-		dev_err(dev,
-			"Error removing VLAN %d on vsi %i error: %d\n",
+		dev_err(dev, "Error removing VLAN %d on vsi %i error: %d\n",
 			vid, vsi->vsi_num, status);
 		err = -EIO;
 	}
@@ -1453,8 +1449,7 @@ int ice_vsi_cfg_rxqs(struct ice_vsi *vsi)
 
 		err = ice_setup_rx_ctx(vsi->rx_rings[i]);
 		if (err) {
-			dev_err(ice_pf_to_dev(vsi->back),
-				"ice_setup_rx_ctx failed for RxQ %d, err %d\n",
+			dev_err(ice_pf_to_dev(vsi->back), "ice_setup_rx_ctx failed for RxQ %d, err %d\n",
 				i, err);
 			return err;
 		}
@@ -1834,8 +1829,7 @@ ice_vsi_set_q_vectors_reg_idx(struct ice_vsi *vsi)
 		struct ice_q_vector *q_vector = vsi->q_vectors[i];
 
 		if (!q_vector) {
-			dev_err(ice_pf_to_dev(vsi->back),
-				"Failed to set reg_idx on q_vector %d VSI %d\n",
+			dev_err(ice_pf_to_dev(vsi->back), "Failed to set reg_idx on q_vector %d VSI %d\n",
 				i, vsi->vsi_num);
 			goto clear_reg_idx;
 		}
@@ -1898,8 +1892,7 @@ ice_vsi_add_rem_eth_mac(struct ice_vsi *vsi, bool add_rule)
 		status = ice_remove_eth_mac(&pf->hw, &tmp_add_list);
 
 	if (status)
-		dev_err(dev,
-			"Failure Adding or Removing Ethertype on VSI %i error: %d\n",
+		dev_err(dev, "Failure Adding or Removing Ethertype on VSI %i error: %d\n",
 			vsi->vsi_num, status);
 
 	ice_free_fltr_list(dev, &tmp_add_list);
@@ -2384,8 +2377,7 @@ ice_get_res(struct ice_pf *pf, struct ice_res_tracker *res, u16 needed, u16 id)
 		return -EINVAL;
 
 	if (!needed || needed > res->num_entries || id >= ICE_RES_VALID_BIT) {
-		dev_err(ice_pf_to_dev(pf),
-			"param err: needed=%d, num_entries = %d id=0x%04x\n",
+		dev_err(ice_pf_to_dev(pf), "param err: needed=%d, num_entries = %d id=0x%04x\n",
 			needed, res->num_entries, id);
 		return -EINVAL;
 	}
@@ -2764,8 +2756,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 	status = ice_cfg_vsi_lan(vsi->port_info, vsi->idx, vsi->tc_cfg.ena_tc,
 				 max_txqs);
 	if (status) {
-		dev_err(ice_pf_to_dev(pf),
-			"VSI %d failed lan queue config, error %d\n",
+		dev_err(ice_pf_to_dev(pf), "VSI %d failed lan queue config, error %d\n",
 			vsi->vsi_num, status);
 		if (init_vsi) {
 			ret = -EIO;
@@ -3023,16 +3014,14 @@ int ice_set_dflt_vsi(struct ice_sw *sw, struct ice_vsi *vsi)
 
 	/* another VSI is already the default VSI for this switch */
 	if (ice_is_dflt_vsi_in_use(sw)) {
-		dev_err(dev,
-			"Default forwarding VSI %d already in use, disable it and try again\n",
+		dev_err(dev, "Default forwarding VSI %d already in use, disable it and try again\n",
 			sw->dflt_vsi->vsi_num);
 		return -EEXIST;
 	}
 
 	status = ice_cfg_dflt_vsi(&vsi->back->hw, vsi->idx, true, ICE_FLTR_RX);
 	if (status) {
-		dev_err(dev,
-			"Failed to set VSI %d as the default forwarding VSI, error %d\n",
+		dev_err(dev, "Failed to set VSI %d as the default forwarding VSI, error %d\n",
 			vsi->vsi_num, status);
 		return -EIO;
 	}
@@ -3071,8 +3060,7 @@ int ice_clear_dflt_vsi(struct ice_sw *sw)
 	status = ice_cfg_dflt_vsi(&dflt_vsi->back->hw, dflt_vsi->idx, false,
 				  ICE_FLTR_RX);
 	if (status) {
-		dev_err(dev,
-			"Failed to clear the default forwarding VSI %d, error %d\n",
+		dev_err(dev, "Failed to clear the default forwarding VSI %d, error %d\n",
 			dflt_vsi->vsi_num, status);
 		return -EIO;
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 044995f69748..db7e8069f37b 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -162,8 +162,7 @@ static int ice_init_mac_fltr(struct ice_pf *pf)
 	 * had an error
 	 */
 	if (status && vsi->netdev->reg_state == NETREG_REGISTERED) {
-		dev_err(ice_pf_to_dev(pf),
-			"Could not add MAC filters error %d. Unregistering device\n",
+		dev_err(ice_pf_to_dev(pf), "Could not add MAC filters error %d. Unregistering device\n",
 			status);
 		unregister_netdev(vsi->netdev);
 		free_netdev(vsi->netdev);
@@ -335,8 +334,7 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 		    !test_and_set_bit(__ICE_FLTR_OVERFLOW_PROMISC,
 				      vsi->state)) {
 			promisc_forced_on = true;
-			netdev_warn(netdev,
-				    "Reached MAC filter limit, forcing promisc mode on VSI %d\n",
+			netdev_warn(netdev, "Reached MAC filter limit, forcing promisc mode on VSI %d\n",
 				    vsi->vsi_num);
 		} else {
 			err = -EIO;
@@ -382,8 +380,7 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 			if (!ice_is_dflt_vsi_in_use(pf->first_sw)) {
 				err = ice_set_dflt_vsi(pf->first_sw, vsi);
 				if (err && err != -EEXIST) {
-					netdev_err(netdev,
-						   "Error %d setting default VSI %i Rx rule\n",
+					netdev_err(netdev, "Error %d setting default VSI %i Rx rule\n",
 						   err, vsi->vsi_num);
 					vsi->current_netdev_flags &=
 						~IFF_PROMISC;
@@ -395,8 +392,7 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 			if (ice_is_vsi_dflt_vsi(pf->first_sw, vsi)) {
 				err = ice_clear_dflt_vsi(pf->first_sw);
 				if (err) {
-					netdev_err(netdev,
-						   "Error %d clearing default VSI %i Rx rule\n",
+					netdev_err(netdev, "Error %d clearing default VSI %i Rx rule\n",
 						   err, vsi->vsi_num);
 					vsi->current_netdev_flags |=
 						IFF_PROMISC;
@@ -815,8 +811,7 @@ ice_link_event(struct ice_pf *pf, struct ice_port_info *pi, bool link_up,
 	 */
 	result = ice_update_link_info(pi);
 	if (result)
-		dev_dbg(dev,
-			"Failed to update link status and re-enable link events for port %d\n",
+		dev_dbg(dev, "Failed to update link status and re-enable link events for port %d\n",
 			pi->lport);
 
 	/* if the old link up/down and speed is the same as the new */
@@ -834,8 +829,7 @@ ice_link_event(struct ice_pf *pf, struct ice_port_info *pi, bool link_up,
 
 		result = ice_aq_set_link_restart_an(pi, false, NULL);
 		if (result) {
-			dev_dbg(dev,
-				"Failed to set link down, VSI %d error %d\n",
+			dev_dbg(dev, "Failed to set link down, VSI %d error %d\n",
 				vsi->vsi_num, result);
 			return result;
 		}
@@ -893,15 +887,13 @@ static int ice_init_link_events(struct ice_port_info *pi)
 		       ICE_AQ_LINK_EVENT_MODULE_QUAL_FAIL));
 
 	if (ice_aq_set_event_mask(pi->hw, pi->lport, mask, NULL)) {
-		dev_dbg(ice_hw_to_dev(pi->hw),
-			"Failed to set link event mask for port %d\n",
+		dev_dbg(ice_hw_to_dev(pi->hw), "Failed to set link event mask for port %d\n",
 			pi->lport);
 		return -EIO;
 	}
 
 	if (ice_aq_get_link_info(pi, true, NULL, NULL)) {
-		dev_dbg(ice_hw_to_dev(pi->hw),
-			"Failed to enable link events for port %d\n",
+		dev_dbg(ice_hw_to_dev(pi->hw), "Failed to enable link events for port %d\n",
 			pi->lport);
 		return -EIO;
 	}
@@ -930,8 +922,8 @@ ice_handle_link_event(struct ice_pf *pf, struct ice_rq_event_info *event)
 				!!(link_data->link_info & ICE_AQ_LINK_UP),
 				le16_to_cpu(link_data->link_speed));
 	if (status)
-		dev_dbg(ice_pf_to_dev(pf),
-			"Could not process link event, error %d\n", status);
+		dev_dbg(ice_pf_to_dev(pf), "Could not process link event, error %d\n",
+			status);
 
 	return status;
 }
@@ -980,13 +972,11 @@ static int __ice_clean_ctrlq(struct ice_pf *pf, enum ice_ctl_q q_type)
 			dev_dbg(dev, "%s Receive Queue VF Error detected\n",
 				qtype);
 		if (val & PF_FW_ARQLEN_ARQOVFL_M) {
-			dev_dbg(dev,
-				"%s Receive Queue Overflow Error detected\n",
+			dev_dbg(dev, "%s Receive Queue Overflow Error detected\n",
 				qtype);
 		}
 		if (val & PF_FW_ARQLEN_ARQCRIT_M)
-			dev_dbg(dev,
-				"%s Receive Queue Critical Error detected\n",
+			dev_dbg(dev, "%s Receive Queue Critical Error detected\n",
 				qtype);
 		val &= ~(PF_FW_ARQLEN_ARQVFE_M | PF_FW_ARQLEN_ARQOVFL_M |
 			 PF_FW_ARQLEN_ARQCRIT_M);
@@ -999,8 +989,8 @@ static int __ice_clean_ctrlq(struct ice_pf *pf, enum ice_ctl_q q_type)
 		   PF_FW_ATQLEN_ATQCRIT_M)) {
 		oldval = val;
 		if (val & PF_FW_ATQLEN_ATQVFE_M)
-			dev_dbg(dev,
-				"%s Send Queue VF Error detected\n", qtype);
+			dev_dbg(dev, "%s Send Queue VF Error detected\n",
+				qtype);
 		if (val & PF_FW_ATQLEN_ATQOVFL_M) {
 			dev_dbg(dev, "%s Send Queue Overflow Error detected\n",
 				qtype);
@@ -1049,8 +1039,7 @@ static int __ice_clean_ctrlq(struct ice_pf *pf, enum ice_ctl_q q_type)
 			ice_dcb_process_lldp_set_mib_change(pf, &event);
 			break;
 		default:
-			dev_dbg(dev,
-				"%s Receive Queue unknown event 0x%04x ignored\n",
+			dev_dbg(dev, "%s Receive Queue unknown event 0x%04x ignored\n",
 				qtype, opcode);
 			break;
 		}
@@ -1336,8 +1325,7 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 			vf->num_mdd_events++;
 			if (vf->num_mdd_events &&
 			    vf->num_mdd_events <= ICE_MDD_EVENTS_THRESHOLD)
-				dev_info(dev,
-					 "VF %d has had %llu MDD events since last boot, Admin might need to reload AVF driver with this number of events\n",
+				dev_info(dev, "VF %d has had %llu MDD events since last boot, Admin might need to reload AVF driver with this number of events\n",
 					 i, vf->num_mdd_events);
 		}
 	}
@@ -1379,8 +1367,7 @@ static int ice_force_phys_link_state(struct ice_vsi *vsi, bool link_up)
 	retcode = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_SW_CFG, pcaps,
 				      NULL);
 	if (retcode) {
-		dev_err(dev,
-			"Failed to get phy capabilities, VSI %d error %d\n",
+		dev_err(dev, "Failed to get phy capabilities, VSI %d error %d\n",
 			vsi->vsi_num, retcode);
 		retcode = -EIO;
 		goto out;
@@ -1650,8 +1637,8 @@ static int ice_vsi_req_irq_msix(struct ice_vsi *vsi, char *basename)
 		err = devm_request_irq(dev, irq_num, vsi->irq_handler, 0,
 				       q_vector->name, q_vector);
 		if (err) {
-			netdev_err(vsi->netdev,
-				   "MSIX request_irq failed, error: %d\n", err);
+			netdev_err(vsi->netdev, "MSIX request_irq failed, error: %d\n",
+				   err);
 			goto free_q_irqs;
 		}
 
@@ -2763,8 +2750,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 	}
 
 	if (v_actual < v_budget) {
-		dev_warn(dev,
-			 "not enough OS MSI-X vectors. requested = %d, obtained = %d\n",
+		dev_warn(dev, "not enough OS MSI-X vectors. requested = %d, obtained = %d\n",
 			 v_budget, v_actual);
 /* 2 vectors for LAN (traffic + OICR) */
 #define ICE_MIN_LAN_VECS 2
@@ -2786,8 +2772,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 	goto exit_err;
 
 no_hw_vecs_left_err:
-	dev_err(dev,
-		"not enough device MSI-X vectors. requested = %d, available = %d\n",
+	dev_err(dev, "not enough device MSI-X vectors. requested = %d, available = %d\n",
 		needed, v_left);
 	err = -ERANGE;
 exit_err:
@@ -2920,16 +2905,14 @@ ice_log_pkg_init(struct ice_hw *hw, enum ice_status *status)
 		    !memcmp(hw->pkg_name, hw->active_pkg_name,
 			    sizeof(hw->pkg_name))) {
 			if (hw->pkg_dwnld_status == ICE_AQ_RC_EEXIST)
-				dev_info(dev,
-					 "DDP package already present on device: %s version %d.%d.%d.%d\n",
+				dev_info(dev, "DDP package already present on device: %s version %d.%d.%d.%d\n",
 					 hw->active_pkg_name,
 					 hw->active_pkg_ver.major,
 					 hw->active_pkg_ver.minor,
 					 hw->active_pkg_ver.update,
 					 hw->active_pkg_ver.draft);
 			else
-				dev_info(dev,
-					 "The DDP package was successfully loaded: %s version %d.%d.%d.%d\n",
+				dev_info(dev, "The DDP package was successfully loaded: %s version %d.%d.%d.%d\n",
 					 hw->active_pkg_name,
 					 hw->active_pkg_ver.major,
 					 hw->active_pkg_ver.minor,
@@ -2937,8 +2920,7 @@ ice_log_pkg_init(struct ice_hw *hw, enum ice_status *status)
 					 hw->active_pkg_ver.draft);
 		} else if (hw->active_pkg_ver.major != ICE_PKG_SUPP_VER_MAJ ||
 			   hw->active_pkg_ver.minor != ICE_PKG_SUPP_VER_MNR) {
-			dev_err(dev,
-				"The device has a DDP package that is not supported by the driver.  The device has package '%s' version %d.%d.x.x.  The driver requires version %d.%d.x.x.  Entering Safe Mode.\n",
+			dev_err(dev, "The device has a DDP package that is not supported by the driver.  The device has package '%s' version %d.%d.x.x.  The driver requires version %d.%d.x.x.  Entering Safe Mode.\n",
 				hw->active_pkg_name,
 				hw->active_pkg_ver.major,
 				hw->active_pkg_ver.minor,
@@ -2946,8 +2928,7 @@ ice_log_pkg_init(struct ice_hw *hw, enum ice_status *status)
 			*status = ICE_ERR_NOT_SUPPORTED;
 		} else if (hw->active_pkg_ver.major == ICE_PKG_SUPP_VER_MAJ &&
 			   hw->active_pkg_ver.minor == ICE_PKG_SUPP_VER_MNR) {
-			dev_info(dev,
-				 "The driver could not load the DDP package file because a compatible DDP package is already present on the device.  The device has package '%s' version %d.%d.%d.%d.  The package file found by the driver: '%s' version %d.%d.%d.%d.\n",
+			dev_info(dev, "The driver could not load the DDP package file because a compatible DDP package is already present on the device.  The device has package '%s' version %d.%d.%d.%d.  The package file found by the driver: '%s' version %d.%d.%d.%d.\n",
 				 hw->active_pkg_name,
 				 hw->active_pkg_ver.major,
 				 hw->active_pkg_ver.minor,
@@ -2959,54 +2940,46 @@ ice_log_pkg_init(struct ice_hw *hw, enum ice_status *status)
 				 hw->pkg_ver.update,
 				 hw->pkg_ver.draft);
 		} else {
-			dev_err(dev,
-				"An unknown error occurred when loading the DDP package, please reboot the system.  If the problem persists, update the NVM.  Entering Safe Mode.\n");
+			dev_err(dev, "An unknown error occurred when loading the DDP package, please reboot the system.  If the problem persists, update the NVM.  Entering Safe Mode.\n");
 			*status = ICE_ERR_NOT_SUPPORTED;
 		}
 		break;
 	case ICE_ERR_BUF_TOO_SHORT:
 		/* fall-through */
 	case ICE_ERR_CFG:
-		dev_err(dev,
-			"The DDP package file is invalid. Entering Safe Mode.\n");
+		dev_err(dev, "The DDP package file is invalid. Entering Safe Mode.\n");
 		break;
 	case ICE_ERR_NOT_SUPPORTED:
 		/* Package File version not supported */
 		if (hw->pkg_ver.major > ICE_PKG_SUPP_VER_MAJ ||
 		    (hw->pkg_ver.major == ICE_PKG_SUPP_VER_MAJ &&
 		     hw->pkg_ver.minor > ICE_PKG_SUPP_VER_MNR))
-			dev_err(dev,
-				"The DDP package file version is higher than the driver supports.  Please use an updated driver.  Entering Safe Mode.\n");
+			dev_err(dev, "The DDP package file version is higher than the driver supports.  Please use an updated driver.  Entering Safe Mode.\n");
 		else if (hw->pkg_ver.major < ICE_PKG_SUPP_VER_MAJ ||
 			 (hw->pkg_ver.major == ICE_PKG_SUPP_VER_MAJ &&
 			  hw->pkg_ver.minor < ICE_PKG_SUPP_VER_MNR))
-			dev_err(dev,
-				"The DDP package file version is lower than the driver supports.  The driver requires version %d.%d.x.x.  Please use an updated DDP Package file.  Entering Safe Mode.\n",
+			dev_err(dev, "The DDP package file version is lower than the driver supports.  The driver requires version %d.%d.x.x.  Please use an updated DDP Package file.  Entering Safe Mode.\n",
 				ICE_PKG_SUPP_VER_MAJ, ICE_PKG_SUPP_VER_MNR);
 		break;
 	case ICE_ERR_AQ_ERROR:
 		switch (hw->pkg_dwnld_status) {
 		case ICE_AQ_RC_ENOSEC:
 		case ICE_AQ_RC_EBADSIG:
-			dev_err(dev,
-				"The DDP package could not be loaded because its signature is not valid.  Please use a valid DDP Package.  Entering Safe Mode.\n");
+			dev_err(dev, "The DDP package could not be loaded because its signature is not valid.  Please use a valid DDP Package.  Entering Safe Mode.\n");
 			return;
 		case ICE_AQ_RC_ESVN:
-			dev_err(dev,
-				"The DDP Package could not be loaded because its security revision is too low.  Please use an updated DDP Package.  Entering Safe Mode.\n");
+			dev_err(dev, "The DDP Package could not be loaded because its security revision is too low.  Please use an updated DDP Package.  Entering Safe Mode.\n");
 			return;
 		case ICE_AQ_RC_EBADMAN:
 		case ICE_AQ_RC_EBADBUF:
-			dev_err(dev,
-				"An error occurred on the device while loading the DDP package.  The device will be reset.\n");
+			dev_err(dev, "An error occurred on the device while loading the DDP package.  The device will be reset.\n");
 			return;
 		default:
 			break;
 		}
 		/* fall-through */
 	default:
-		dev_err(dev,
-			"An unknown error (%d) occurred when loading the DDP package.  Entering Safe Mode.\n",
+		dev_err(dev, "An unknown error (%d) occurred when loading the DDP package.  Entering Safe Mode.\n",
 			*status);
 		break;
 	}
@@ -3037,8 +3010,7 @@ ice_load_pkg(const struct firmware *firmware, struct ice_pf *pf)
 		status = ice_init_pkg(hw, hw->pkg_copy, hw->pkg_size);
 		ice_log_pkg_init(hw, &status);
 	} else {
-		dev_err(dev,
-			"The DDP package file failed to load. Entering Safe Mode.\n");
+		dev_err(dev, "The DDP package file failed to load. Entering Safe Mode.\n");
 	}
 
 	if (status) {
@@ -3064,8 +3036,7 @@ ice_load_pkg(const struct firmware *firmware, struct ice_pf *pf)
 static void ice_verify_cacheline_size(struct ice_pf *pf)
 {
 	if (rd32(&pf->hw, GLPCI_CNF2) & GLPCI_CNF2_CACHELINE_SIZE_M)
-		dev_warn(ice_pf_to_dev(pf),
-			 "%d Byte cache line assumption is invalid, driver may have Tx timeouts!\n",
+		dev_warn(ice_pf_to_dev(pf), "%d Byte cache line assumption is invalid, driver may have Tx timeouts!\n",
 			 ICE_CACHE_LINE_BYTES);
 }
 
@@ -3158,8 +3129,7 @@ static void ice_request_fw(struct ice_pf *pf)
 dflt_pkg_load:
 	err = request_firmware(&firmware, ICE_DDP_PKG_FILE, dev);
 	if (err) {
-		dev_err(dev,
-			"The DDP package file was not found or could not be read. Entering Safe Mode\n");
+		dev_err(dev, "The DDP package file was not found or could not be read. Entering Safe Mode\n");
 		return;
 	}
 
@@ -3251,8 +3221,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	 * true
 	 */
 	if (ice_is_safe_mode(pf)) {
-		dev_err(dev,
-			"Package download failed. Advanced features disabled - Device now in Safe Mode\n");
+		dev_err(dev, "Package download failed. Advanced features disabled - Device now in Safe Mode\n");
 		/* we already got function/device capabilities but these don't
 		 * reflect what the driver needs to do in safe mode. Instead of
 		 * adding conditional logic everywhere to ignore these
@@ -3329,8 +3298,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	/* tell the firmware we are up */
 	err = ice_send_version(pf);
 	if (err) {
-		dev_err(dev,
-			"probe failed sending driver version %s. error: %d\n",
+		dev_err(dev, "probe failed sending driver version %s. error: %d\n",
 			ice_drv_ver, err);
 		goto err_alloc_sw_unroll;
 	}
@@ -3471,8 +3439,7 @@ static pci_ers_result_t ice_pci_err_slot_reset(struct pci_dev *pdev)
 
 	err = pci_enable_device_mem(pdev);
 	if (err) {
-		dev_err(&pdev->dev,
-			"Cannot re-enable PCI device after reset, error %d\n",
+		dev_err(&pdev->dev, "Cannot re-enable PCI device after reset, error %d\n",
 			err);
 		result = PCI_ERS_RESULT_DISCONNECT;
 	} else {
@@ -3491,8 +3458,7 @@ static pci_ers_result_t ice_pci_err_slot_reset(struct pci_dev *pdev)
 
 	err = pci_cleanup_aer_uncorrect_error_status(pdev);
 	if (err)
-		dev_dbg(&pdev->dev,
-			"pci_cleanup_aer_uncorrect_error_status failed, error %d\n",
+		dev_dbg(&pdev->dev, "pci_cleanup_aer_uncorrect_error_status failed, error %d\n",
 			err);
 		/* non-fatal, continue */
 
@@ -3511,8 +3477,8 @@ static void ice_pci_err_resume(struct pci_dev *pdev)
 	struct ice_pf *pf = pci_get_drvdata(pdev);
 
 	if (!pf) {
-		dev_err(&pdev->dev,
-			"%s failed, device is unrecoverable\n", __func__);
+		dev_err(&pdev->dev, "%s failed, device is unrecoverable\n",
+			__func__);
 		return;
 	}
 
@@ -3760,8 +3726,7 @@ ice_set_tx_maxrate(struct net_device *netdev, int queue_index, u32 maxrate)
 
 	/* Validate maxrate requested is within permitted range */
 	if (maxrate && (maxrate > (ICE_SCHED_MAX_BW / 1000))) {
-		netdev_err(netdev,
-			   "Invalid max rate %d specified for the queue %d\n",
+		netdev_err(netdev, "Invalid max rate %d specified for the queue %d\n",
 			   maxrate, queue_index);
 		return -EINVAL;
 	}
@@ -3777,8 +3742,8 @@ ice_set_tx_maxrate(struct net_device *netdev, int queue_index, u32 maxrate)
 		status = ice_cfg_q_bw_lmt(vsi->port_info, vsi->idx, tc,
 					  q_handle, ICE_MAX_BW, maxrate * 1000);
 	if (status) {
-		netdev_err(netdev,
-			   "Unable to set Tx max rate, error %d\n", status);
+		netdev_err(netdev, "Unable to set Tx max rate, error %d\n",
+			   status);
 		return -EIO;
 	}
 
@@ -3870,15 +3835,13 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
 
 	/* Don't set any netdev advanced features with device in Safe Mode */
 	if (ice_is_safe_mode(vsi->back)) {
-		dev_err(ice_pf_to_dev(vsi->back),
-			"Device is in Safe Mode - not enabling advanced netdev features\n");
+		dev_err(ice_pf_to_dev(vsi->back), "Device is in Safe Mode - not enabling advanced netdev features\n");
 		return ret;
 	}
 
 	/* Do not change setting during reset */
 	if (ice_is_reset_in_progress(pf->state)) {
-		dev_err(ice_pf_to_dev(vsi->back),
-			"Device is resetting, changing advanced netdev features temporarily unavailable.\n");
+		dev_err(ice_pf_to_dev(vsi->back), "Device is resetting, changing advanced netdev features temporarily unavailable.\n");
 		return -EBUSY;
 	}
 
@@ -4366,21 +4329,18 @@ int ice_down(struct ice_vsi *vsi)
 
 	tx_err = ice_vsi_stop_lan_tx_rings(vsi, ICE_NO_RESET, 0);
 	if (tx_err)
-		netdev_err(vsi->netdev,
-			   "Failed stop Tx rings, VSI %d error %d\n",
+		netdev_err(vsi->netdev, "Failed stop Tx rings, VSI %d error %d\n",
 			   vsi->vsi_num, tx_err);
 	if (!tx_err && ice_is_xdp_ena_vsi(vsi)) {
 		tx_err = ice_vsi_stop_xdp_tx_rings(vsi);
 		if (tx_err)
-			netdev_err(vsi->netdev,
-				   "Failed stop XDP rings, VSI %d error %d\n",
+			netdev_err(vsi->netdev, "Failed stop XDP rings, VSI %d error %d\n",
 				   vsi->vsi_num, tx_err);
 	}
 
 	rx_err = ice_vsi_stop_rx_rings(vsi);
 	if (rx_err)
-		netdev_err(vsi->netdev,
-			   "Failed stop Rx rings, VSI %d error %d\n",
+		netdev_err(vsi->netdev, "Failed stop Rx rings, VSI %d error %d\n",
 			   vsi->vsi_num, rx_err);
 
 	ice_napi_disable_all(vsi);
@@ -4388,8 +4348,7 @@ int ice_down(struct ice_vsi *vsi)
 	if (test_bit(ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA, vsi->back->flags)) {
 		link_err = ice_force_phys_link_state(vsi, false);
 		if (link_err)
-			netdev_err(vsi->netdev,
-				   "Failed to set physical link down, VSI %d error %d\n",
+			netdev_err(vsi->netdev, "Failed to set physical link down, VSI %d error %d\n",
 				   vsi->vsi_num, link_err);
 	}
 
@@ -4400,8 +4359,7 @@ int ice_down(struct ice_vsi *vsi)
 		ice_clean_rx_ring(vsi->rx_rings[i]);
 
 	if (tx_err || rx_err || link_err) {
-		netdev_err(vsi->netdev,
-			   "Failed to close VSI 0x%04X on switch 0x%04X\n",
+		netdev_err(vsi->netdev, "Failed to close VSI 0x%04X on switch 0x%04X\n",
 			   vsi->vsi_num, vsi->vsw->sw_id);
 		return -EIO;
 	}
@@ -4548,8 +4506,7 @@ static void ice_vsi_release_all(struct ice_pf *pf)
 
 		err = ice_vsi_release(pf->vsi[i]);
 		if (err)
-			dev_dbg(ice_pf_to_dev(pf),
-				"Failed to release pf->vsi[%d], err %d, vsi_num = %d\n",
+			dev_dbg(ice_pf_to_dev(pf), "Failed to release pf->vsi[%d], err %d, vsi_num = %d\n",
 				i, err, pf->vsi[i]->vsi_num);
 	}
 }
@@ -4576,8 +4533,7 @@ static int ice_vsi_rebuild_by_type(struct ice_pf *pf, enum ice_vsi_type type)
 		/* rebuild the VSI */
 		err = ice_vsi_rebuild(vsi, true);
 		if (err) {
-			dev_err(dev,
-				"rebuild VSI failed, err %d, VSI index %d, type %s\n",
+			dev_err(dev, "rebuild VSI failed, err %d, VSI index %d, type %s\n",
 				err, vsi->idx, ice_vsi_type_str(type));
 			return err;
 		}
@@ -4585,8 +4541,7 @@ static int ice_vsi_rebuild_by_type(struct ice_pf *pf, enum ice_vsi_type type)
 		/* replay filters for the VSI */
 		status = ice_replay_vsi(&pf->hw, vsi->idx);
 		if (status) {
-			dev_err(dev,
-				"replay VSI failed, status %d, VSI index %d, type %s\n",
+			dev_err(dev, "replay VSI failed, status %d, VSI index %d, type %s\n",
 				status, vsi->idx, ice_vsi_type_str(type));
 			return -EIO;
 		}
@@ -4599,8 +4554,7 @@ static int ice_vsi_rebuild_by_type(struct ice_pf *pf, enum ice_vsi_type type)
 		/* enable the VSI */
 		err = ice_ena_vsi(vsi, false);
 		if (err) {
-			dev_err(dev,
-				"enable VSI failed, err %d, VSI index %d, type %s\n",
+			dev_err(dev, "enable VSI failed, err %d, VSI index %d, type %s\n",
 				err, vsi->idx, ice_vsi_type_str(type));
 			return err;
 		}
@@ -4678,8 +4632,7 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 	}
 
 	if (pf->first_sw->dflt_vsi_ena)
-		dev_info(dev,
-			 "Clearing default VSI, re-enable after reset completes\n");
+		dev_info(dev, "Clearing default VSI, re-enable after reset completes\n");
 	/* clear the default VSI configuration if it exists */
 	pf->first_sw->dflt_vsi = NULL;
 	pf->first_sw->dflt_vsi_ena = false;
@@ -4730,8 +4683,7 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 	/* tell the firmware we are up */
 	ret = ice_send_version(pf);
 	if (ret) {
-		dev_err(dev,
-			"Rebuild failed due to error sending driver version: %d\n",
+		dev_err(dev, "Rebuild failed due to error sending driver version: %d\n",
 			ret);
 		goto err_vsi_rebuild;
 	}
@@ -5179,8 +5131,7 @@ int ice_open(struct net_device *netdev)
 	if (pi->phy.link_info.link_info & ICE_AQ_MEDIA_AVAILABLE) {
 		err = ice_force_phys_link_state(vsi, true);
 		if (err) {
-			netdev_err(netdev,
-				   "Failed to set physical link up, error %d\n",
+			netdev_err(netdev, "Failed to set physical link up, error %d\n",
 				   err);
 			return err;
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 8f1a934a318c..eb60abd8394f 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -199,8 +199,7 @@ static void ice_dis_vf_mappings(struct ice_vf *vf)
 	if (vsi->rx_mapping_mode == ICE_VSI_MAP_CONTIG)
 		wr32(hw, VPLAN_RX_QBASE(vf->vf_id), 0);
 	else
-		dev_err(dev,
-			"Scattered mode for VF Rx queues is not yet implemented\n");
+		dev_err(dev, "Scattered mode for VF Rx queues is not yet implemented\n");
 }
 
 /**
@@ -402,8 +401,7 @@ static void ice_trigger_vf_reset(struct ice_vf *vf, bool is_vflr, bool is_pfr)
 		if ((reg & VF_TRANS_PENDING_M) == 0)
 			break;
 
-		dev_err(dev,
-			"VF %d PCI transactions stuck\n", vf->vf_id);
+		dev_err(dev, "VF %d PCI transactions stuck\n", vf->vf_id);
 		udelay(ICE_PCI_CIAD_WAIT_DELAY_US);
 	}
 }
@@ -1553,8 +1551,7 @@ ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
 		dev_info(dev, "VF %d failed opcode %d, retval: %d\n", vf->vf_id,
 			 v_opcode, v_retval);
 		if (vf->num_inval_msgs > ICE_DFLT_NUM_INVAL_MSGS_ALLOWED) {
-			dev_err(dev,
-				"Number of invalid messages exceeded for VF %d\n",
+			dev_err(dev, "Number of invalid messages exceeded for VF %d\n",
 				vf->vf_id);
 			dev_err(dev, "Use PF Control I/F to enable the VF\n");
 			set_bit(ICE_VF_STATE_DIS, vf->vf_states);
@@ -1569,8 +1566,7 @@ ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
 	aq_ret = ice_aq_send_msg_to_vf(&pf->hw, vf->vf_id, v_opcode, v_retval,
 				       msg, msglen, NULL);
 	if (aq_ret && pf->hw.mailboxq.sq_last_status != ICE_AQ_RC_ENOSYS) {
-		dev_info(dev,
-			 "Unable to send the message to VF %d ret %d aq_err %d\n",
+		dev_info(dev, "Unable to send the message to VF %d ret %d aq_err %d\n",
 			 vf->vf_id, aq_ret, pf->hw.mailboxq.sq_last_status);
 		return -EIO;
 	}
@@ -1914,8 +1910,7 @@ int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena)
 	}
 
 	if (vf_vsi->type != ICE_VSI_VF) {
-		netdev_err(netdev,
-			   "Type %d of VSI %d for VF %d is no ICE_VSI_VF\n",
+		netdev_err(netdev, "Type %d of VSI %d for VF %d is no ICE_VSI_VF\n",
 			   vf_vsi->type, vf_vsi->vsi_num, vf->vf_id);
 		return -ENODEV;
 	}
@@ -1945,8 +1940,7 @@ int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena)
 
 	status = ice_update_vsi(&pf->hw, vf_vsi->idx, ctx, NULL);
 	if (status) {
-		dev_err(dev,
-			"Failed to %sable spoofchk on VF %d VSI %d\n error %d",
+		dev_err(dev, "Failed to %sable spoofchk on VF %d VSI %d\n error %d",
 			ena ? "en" : "dis", vf->vf_id, vf_vsi->vsi_num, status);
 		ret = -EIO;
 		goto out;
@@ -2063,8 +2057,7 @@ static int ice_vc_ena_qs_msg(struct ice_vf *vf, u8 *msg)
 			continue;
 
 		if (ice_vsi_ctrl_rx_ring(vsi, true, vf_q_id)) {
-			dev_err(ice_pf_to_dev(vsi->back),
-				"Failed to enable Rx ring %d on VSI %d\n",
+			dev_err(ice_pf_to_dev(vsi->back), "Failed to enable Rx ring %d on VSI %d\n",
 				vf_q_id, vsi->vsi_num);
 			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 			goto error_param;
@@ -2166,8 +2159,7 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 
 			if (ice_vsi_stop_tx_ring(vsi, ICE_NO_RESET, vf->vf_id,
 						 ring, &txq_meta)) {
-				dev_err(ice_pf_to_dev(vsi->back),
-					"Failed to stop Tx ring %d on VSI %d\n",
+				dev_err(ice_pf_to_dev(vsi->back), "Failed to stop Tx ring %d on VSI %d\n",
 					vf_q_id, vsi->vsi_num);
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 				goto error_param;
@@ -2193,8 +2185,7 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 				continue;
 
 			if (ice_vsi_ctrl_rx_ring(vsi, false, vf_q_id)) {
-				dev_err(ice_pf_to_dev(vsi->back),
-					"Failed to stop Rx ring %d on VSI %d\n",
+				dev_err(ice_pf_to_dev(vsi->back), "Failed to stop Rx ring %d on VSI %d\n",
 					vf_q_id, vsi->vsi_num);
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 				goto error_param;
@@ -2357,8 +2348,7 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 
 	if (qci->num_queue_pairs > ICE_MAX_BASE_QS_PER_VF ||
 	    qci->num_queue_pairs > min_t(u16, vsi->alloc_txq, vsi->alloc_rxq)) {
-		dev_err(ice_pf_to_dev(pf),
-			"VF-%d requesting more than supported number of queues: %d\n",
+		dev_err(ice_pf_to_dev(pf), "VF-%d requesting more than supported number of queues: %d\n",
 			vf->vf_id, min_t(u16, vsi->alloc_txq, vsi->alloc_rxq));
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
@@ -2570,8 +2560,7 @@ ice_vc_handle_mac_addr_msg(struct ice_vf *vf, u8 *msg, bool set)
 	 */
 	if (set && !ice_is_vf_trusted(vf) &&
 	    (vf->num_mac + al->num_elements) > ICE_MAX_MACADDR_PER_VF) {
-		dev_err(ice_pf_to_dev(pf),
-			"Can't add more MAC addresses, because VF-%d is not trusted, switch the VF to trusted mode in order to add more functionalities\n",
+		dev_err(ice_pf_to_dev(pf), "Can't add more MAC addresses, because VF-%d is not trusted, switch the VF to trusted mode in order to add more functionalities\n",
 			vf->vf_id);
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto handle_mac_exit;
@@ -2670,8 +2659,7 @@ static int ice_vc_request_qs_msg(struct ice_vf *vf, u8 *msg)
 		vfres->num_queue_pairs = ICE_MAX_BASE_QS_PER_VF;
 	} else if (req_queues > cur_queues &&
 		   req_queues - cur_queues > tx_rx_queue_left) {
-		dev_warn(dev,
-			 "VF %d requested %u more queues, but only %u left.\n",
+		dev_warn(dev, "VF %d requested %u more queues, but only %u left.\n",
 			 vf->vf_id, req_queues - cur_queues, tx_rx_queue_left);
 		vfres->num_queue_pairs = min_t(u16, max_allowed_vf_queues,
 					       ICE_MAX_BASE_QS_PER_VF);
@@ -2821,8 +2809,8 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 	for (i = 0; i < vfl->num_elements; i++) {
 		if (vfl->vlan_id[i] > ICE_MAX_VLANID) {
 			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			dev_err(dev,
-				"invalid VF VLAN id %d\n", vfl->vlan_id[i]);
+			dev_err(dev, "invalid VF VLAN id %d\n",
+				vfl->vlan_id[i]);
 			goto error_param;
 		}
 	}
@@ -2836,8 +2824,7 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 
 	if (add_v && !ice_is_vf_trusted(vf) &&
 	    vsi->num_vlan >= ICE_MAX_VLAN_PER_VF) {
-		dev_info(dev,
-			 "VF-%d is not trusted, switch the VF to trusted mode, in order to add more VLAN addresses\n",
+		dev_info(dev, "VF-%d is not trusted, switch the VF to trusted mode, in order to add more VLAN addresses\n",
 			 vf->vf_id);
 		/* There is no need to let VF know about being not trusted,
 		 * so we can just return success message here
@@ -2860,8 +2847,7 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 
 			if (!ice_is_vf_trusted(vf) &&
 			    vsi->num_vlan >= ICE_MAX_VLAN_PER_VF) {
-				dev_info(dev,
-					 "VF-%d is not trusted, switch the VF to trusted mode, in order to add more VLAN addresses\n",
+				dev_info(dev, "VF-%d is not trusted, switch the VF to trusted mode, in order to add more VLAN addresses\n",
 					 vf->vf_id);
 				/* There is no need to let VF know about being
 				 * not trusted, so we can just return success
@@ -2889,8 +2875,7 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 				status = ice_cfg_vlan_pruning(vsi, true, false);
 				if (status) {
 					v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-					dev_err(dev,
-						"Enable VLAN pruning on VLAN ID: %d failed error-%d\n",
+					dev_err(dev, "Enable VLAN pruning on VLAN ID: %d failed error-%d\n",
 						vid, status);
 					goto error_param;
 				}
@@ -2903,8 +2888,7 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 							     promisc_m, vid);
 				if (status) {
 					v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-					dev_err(dev,
-						"Enable Unicast/multicast promiscuous mode on VLAN ID:%d failed error-%d\n",
+					dev_err(dev, "Enable Unicast/multicast promiscuous mode on VLAN ID:%d failed error-%d\n",
 						vid, status);
 				}
 			}
@@ -3140,8 +3124,7 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 	case VIRTCHNL_OP_GET_VF_RESOURCES:
 		err = ice_vc_get_vf_res_msg(vf, msg);
 		if (ice_vf_init_vlan_stripping(vf))
-			dev_err(dev,
-				"Failed to initialize VLAN stripping for VF %d\n",
+			dev_err(dev, "Failed to initialize VLAN stripping for VF %d\n",
 				vf->vf_id);
 		ice_vc_notify_vf_link_state(vf);
 		break;
@@ -3313,8 +3296,7 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 	 */
 	ether_addr_copy(vf->dflt_lan_addr.addr, mac);
 	vf->pf_set_mac = true;
-	netdev_info(netdev,
-		    "MAC on VF %d set to %pM. VF driver will be reinitialized\n",
+	netdev_info(netdev, "MAC on VF %d set to %pM. VF driver will be reinitialized\n",
 		    vf_id, mac);
 
 	ice_vc_reset_vf(vf);
@@ -3332,10 +3314,8 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
 {
 	struct ice_pf *pf = ice_netdev_to_pf(netdev);
-	struct device *dev;
 	struct ice_vf *vf;
 
-	dev = ice_pf_to_dev(pf);
 	if (ice_validate_vf_id(pf, vf_id))
 		return -EINVAL;
 
@@ -3358,7 +3338,7 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
 
 	vf->trusted = trusted;
 	ice_vc_reset_vf(vf);
-	dev_info(dev, "VF %u is now %strusted\n",
+	dev_info(ice_pf_to_dev(pf), "VF %u is now %strusted\n",
 		 vf_id, trusted ? "" : "un");
 
 	return 0;
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 149dca0012ba..4d3407bbd4c4 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -338,8 +338,8 @@ static int ice_xsk_umem_dma_map(struct ice_vsi *vsi, struct xdp_umem *umem)
 						    DMA_BIDIRECTIONAL,
 						    ICE_RX_DMA_ATTR);
 		if (dma_mapping_error(dev, dma)) {
-			dev_dbg(dev,
-				"XSK UMEM DMA mapping error on page num %d", i);
+			dev_dbg(dev, "XSK UMEM DMA mapping error on page num %d\n",
+				i);
 			goto out_unmap;
 		}
 
-- 
2.24.1

