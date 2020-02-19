Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B899E16521F
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 23:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgBSWHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 17:07:03 -0500
Received: from mga03.intel.com ([134.134.136.65]:62535 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbgBSWHB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 17:07:01 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 14:06:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="239824827"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.76])
  by orsmga006.jf.intel.com with ESMTP; 19 Feb 2020 14:06:54 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/13] ice: add backslash-n to strings
Date:   Wed, 19 Feb 2020 14:06:49 -0800
Message-Id: <20200219220652.2255171-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200219220652.2255171-1-jeffrey.t.kirsher@intel.com>
References: <20200219220652.2255171-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

There were several strings found without line feeds, fix
them by adding a line feed, as is typical.  Without this
lotsofmessagescanbejumbledtogether.

This patch has known checkpatch warnings from long lines
for the NL_* messages, because checkpatch doesn't know
how to ignore them.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c        |  3 +--
 drivers/net/ethernet/intel/ice/ice_ethtool.c     |  8 ++++----
 drivers/net/ethernet/intel/ice/ice_main.c        | 12 ++++--------
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c |  2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c         |  6 +++---
 5 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 54aa533f36d4..a19cd6f5436b 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -203,8 +203,7 @@ static void ice_cfg_itr_gran(struct ice_hw *hw)
  */
 static u16 ice_calc_q_handle(struct ice_vsi *vsi, struct ice_ring *ring, u8 tc)
 {
-	WARN_ONCE(ice_ring_is_xdp(ring) && tc,
-		  "XDP ring can't belong to TC other than 0");
+	WARN_ONCE(ice_ring_is_xdp(ring) && tc, "XDP ring can't belong to TC other than 0\n");
 
 	/* Idea here for calculation is that we subtract the number of queue
 	 * count from TC that ring belongs to from it's absolute queue index
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 63a69ea02d22..4f625c8dfdb5 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -673,7 +673,7 @@ static u64 ice_loopback_test(struct net_device *netdev)
 
 	test_vsi = ice_lb_vsi_setup(pf, pf->hw.port_info);
 	if (!test_vsi) {
-		netdev_err(netdev, "Failed to create a VSI for the loopback test");
+		netdev_err(netdev, "Failed to create a VSI for the loopback test\n");
 		return 1;
 	}
 
@@ -732,7 +732,7 @@ static u64 ice_loopback_test(struct net_device *netdev)
 	devm_kfree(dev, tx_frame);
 remove_mac_filters:
 	if (ice_remove_mac(&pf->hw, &tmp_list))
-		netdev_err(netdev, "Could not remove MAC filter for the test VSI");
+		netdev_err(netdev, "Could not remove MAC filter for the test VSI\n");
 free_mac_list:
 	ice_free_fltr_list(dev, &tmp_list);
 lbtest_mac_dis:
@@ -745,7 +745,7 @@ static u64 ice_loopback_test(struct net_device *netdev)
 lbtest_vsi_close:
 	test_vsi->netdev = NULL;
 	if (ice_vsi_release(test_vsi))
-		netdev_err(netdev, "Failed to remove the test VSI");
+		netdev_err(netdev, "Failed to remove the test VSI\n");
 
 	return ret;
 }
@@ -835,7 +835,7 @@ ice_self_test(struct net_device *netdev, struct ethtool_test *eth_test,
 			int status = ice_open(netdev);
 
 			if (status) {
-				dev_err(dev, "Could not open device %s, err %d",
+				dev_err(dev, "Could not open device %s, err %d\n",
 					pf->int_name, status);
 			}
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index f11e0934dc03..8de63c84e4d6 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1924,8 +1924,7 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 	if (if_running && !test_and_set_bit(__ICE_DOWN, vsi->state)) {
 		ret = ice_down(vsi);
 		if (ret) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Preparing device for XDP attach failed");
+			NL_SET_ERR_MSG_MOD(extack, "Preparing device for XDP attach failed");
 			return ret;
 		}
 	}
@@ -1934,13 +1933,11 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 		vsi->num_xdp_txq = vsi->alloc_txq;
 		xdp_ring_err = ice_prepare_xdp_rings(vsi, prog);
 		if (xdp_ring_err)
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Setting up XDP Tx resources failed");
+			NL_SET_ERR_MSG_MOD(extack, "Setting up XDP Tx resources failed");
 	} else if (ice_is_xdp_ena_vsi(vsi) && !prog) {
 		xdp_ring_err = ice_destroy_xdp_rings(vsi);
 		if (xdp_ring_err)
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Freeing XDP Tx resources failed");
+			NL_SET_ERR_MSG_MOD(extack, "Freeing XDP Tx resources failed");
 	} else {
 		ice_vsi_assign_bpf_prog(vsi, prog);
 	}
@@ -1973,8 +1970,7 @@ static int ice_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	struct ice_vsi *vsi = np->vsi;
 
 	if (vsi->type != ICE_VSI_PF) {
-		NL_SET_ERR_MSG_MOD(xdp->extack,
-				   "XDP can be loaded only on PF VSI");
+		NL_SET_ERR_MSG_MOD(xdp->extack, "XDP can be loaded only on PF VSI");
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index e5c99bb8529e..de6317e91724 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2018,7 +2018,7 @@ int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena)
 
 	status = ice_update_vsi(&pf->hw, vf_vsi->idx, ctx, NULL);
 	if (status) {
-		dev_err(dev, "Failed to %sable spoofchk on VF %d VSI %d\n error %d",
+		dev_err(dev, "Failed to %sable spoofchk on VF %d VSI %d\n error %d\n",
 			ena ? "en" : "dis", vf->vf_id, vf_vsi->vsi_num, status);
 		ret = -EIO;
 		goto out;
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 3fd31ad73e0e..8279db15e870 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -457,7 +457,7 @@ int ice_xsk_umem_setup(struct ice_vsi *vsi, struct xdp_umem *umem, u16 qid)
 	if (if_running) {
 		ret = ice_qp_dis(vsi, qid);
 		if (ret) {
-			netdev_err(vsi->netdev, "ice_qp_dis error = %d", ret);
+			netdev_err(vsi->netdev, "ice_qp_dis error = %d\n", ret);
 			goto xsk_umem_if_up;
 		}
 	}
@@ -471,11 +471,11 @@ int ice_xsk_umem_setup(struct ice_vsi *vsi, struct xdp_umem *umem, u16 qid)
 		if (!ret && umem_present)
 			napi_schedule(&vsi->xdp_rings[qid]->q_vector->napi);
 		else if (ret)
-			netdev_err(vsi->netdev, "ice_qp_ena error = %d", ret);
+			netdev_err(vsi->netdev, "ice_qp_ena error = %d\n", ret);
 	}
 
 	if (umem_failure) {
-		netdev_err(vsi->netdev, "Could not %sable UMEM, error = %d",
+		netdev_err(vsi->netdev, "Could not %sable UMEM, error = %d\n",
 			   umem_present ? "en" : "dis", umem_failure);
 		return umem_failure;
 	}
-- 
2.24.1

