Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D66367BE37
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 22:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236700AbjAYVYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 16:24:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236661AbjAYVYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 16:24:40 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A674C45F6E
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 13:24:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674681878; x=1706217878;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hZUAQWs/46HdYKzfazwwFC7eNE1FwjifC9VUEF7Ge9Y=;
  b=QWRtDakyHHn+0NsIgdt5qddvvR6qP+pP7D39a6DoyK8ylDzL+Hci9AXA
   NmCcNaVAA9vTSCbCcXEALZ2vfYquvZifuTl3EPM6zlDo7bGTp/m0gVnu/
   heRzikbVY4vDj5kgeqa9QBlCXiDM1Tn9AiaDcfPO4zme7Dswm0l7A6r02
   YUJjxB7n0aYMy1j/odX2m5+aO3Qc83IXAVJ7YaYBPX891EBhtylP3s7k3
   jnXaaAwQYCaqHf4AfFrNF0OIDh37V5voK2Dg6foY8rXZmn4vC0C3LK/br
   4y9vr9n5iQCzQcydcFkvQ5Ixk2tdDeR1zqC19F+UjIEufUeHE9pKc/sEJ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="328767505"
X-IronPort-AV: E=Sophos;i="5.97,246,1669104000"; 
   d="scan'208";a="328767505"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 13:24:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="770894115"
X-IronPort-AV: E=Sophos;i="5.97,246,1669104000"; 
   d="scan'208";a="770894115"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga002.fm.intel.com with ESMTP; 25 Jan 2023 13:24:36 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jakub Andrysiak <jakub.andrysiak@intel.com>
Subject: [PATCH net-next 4/4] virtchnl: i40e/iavf: rename iwarp to rdma
Date:   Wed, 25 Jan 2023 13:24:41 -0800
Message-Id: <20230125212441.4030014-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230125212441.4030014-1-anthony.l.nguyen@intel.com>
References: <20230125212441.4030014-1-anthony.l.nguyen@intel.com>
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

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

Since the latest Intel hardware does both IWARP and ROCE, rename the
term IWARP in the virtchnl header to be RDMA. Do this for both upper and
lower case instances. Many of the non-virtchnl.h changes were done with
regular expression replacements using perl like:
perl -p -i -e 's/_IWARP/_RDMA/' <files>
perl -p -i -e 's/_iwarp/_rdma/' <files>
and I had to pick up a few instances manually.

The virtchnl.h header has some comments and clarity added around when to
use certain defines.

note: had to fix a checkpatch warning for a long line by wrapping one of
the lines I changed.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Jakub Andrysiak <jakub.andrysiak@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_client.c |  2 +-
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 63 +++++++++---------
 .../ethernet/intel/i40e/i40e_virtchnl_pf.h    |  6 +-
 drivers/net/ethernet/intel/iavf/iavf.h        |  6 +-
 drivers/net/ethernet/intel/iavf/iavf_client.c | 32 ++++-----
 drivers/net/ethernet/intel/iavf/iavf_client.h |  2 +-
 drivers/net/ethernet/intel/iavf/iavf_common.c |  4 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  2 +-
 drivers/net/ethernet/intel/iavf/iavf_status.h |  2 +-
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  6 +-
 include/linux/avf/virtchnl.h                  | 65 +++++++++++--------
 11 files changed, 100 insertions(+), 90 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.c b/drivers/net/ethernet/intel/i40e/i40e_client.c
index 10d7a982a5b9..6ea43ef40540 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -543,7 +543,7 @@ static int i40e_client_virtchnl_send(struct i40e_info *ldev,
 	struct i40e_hw *hw = &pf->hw;
 	i40e_status err;
 
-	err = i40e_aq_send_msg_to_vf(hw, vf_id, VIRTCHNL_OP_IWARP,
+	err = i40e_aq_send_msg_to_vf(hw, vf_id, VIRTCHNL_OP_RDMA,
 				     0, msg, len, NULL);
 	if (err)
 		dev_err(&pf->pdev->dev, "Unable to send iWarp message to VF, error %d, aq status %d\n",
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 635f93d60318..8fa0f0c12fde 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -441,14 +441,14 @@ static void i40e_config_irq_link_list(struct i40e_vf *vf, u16 vsi_id,
 }
 
 /**
- * i40e_release_iwarp_qvlist
+ * i40e_release_rdma_qvlist
  * @vf: pointer to the VF.
  *
  **/
-static void i40e_release_iwarp_qvlist(struct i40e_vf *vf)
+static void i40e_release_rdma_qvlist(struct i40e_vf *vf)
 {
 	struct i40e_pf *pf = vf->pf;
-	struct virtchnl_iwarp_qvlist_info *qvlist_info = vf->qvlist_info;
+	struct virtchnl_rdma_qvlist_info *qvlist_info = vf->qvlist_info;
 	u32 msix_vf;
 	u32 i;
 
@@ -457,7 +457,7 @@ static void i40e_release_iwarp_qvlist(struct i40e_vf *vf)
 
 	msix_vf = pf->hw.func_caps.num_msix_vectors_vf;
 	for (i = 0; i < qvlist_info->num_vectors; i++) {
-		struct virtchnl_iwarp_qv_info *qv_info;
+		struct virtchnl_rdma_qv_info *qv_info;
 		u32 next_q_index, next_q_type;
 		struct i40e_hw *hw = &pf->hw;
 		u32 v_idx, reg_idx, reg;
@@ -491,18 +491,19 @@ static void i40e_release_iwarp_qvlist(struct i40e_vf *vf)
 }
 
 /**
- * i40e_config_iwarp_qvlist
+ * i40e_config_rdma_qvlist
  * @vf: pointer to the VF info
  * @qvlist_info: queue and vector list
  *
  * Return 0 on success or < 0 on error
  **/
-static int i40e_config_iwarp_qvlist(struct i40e_vf *vf,
-				    struct virtchnl_iwarp_qvlist_info *qvlist_info)
+static int
+i40e_config_rdma_qvlist(struct i40e_vf *vf,
+			struct virtchnl_rdma_qvlist_info *qvlist_info)
 {
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_hw *hw = &pf->hw;
-	struct virtchnl_iwarp_qv_info *qv_info;
+	struct virtchnl_rdma_qv_info *qv_info;
 	u32 v_idx, i, reg_idx, reg;
 	u32 next_q_idx, next_q_type;
 	u32 msix_vf;
@@ -2123,11 +2124,11 @@ static int i40e_vc_get_vf_resources_msg(struct i40e_vf *vf, u8 *msg)
 		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_VLAN;
 
 	if (i40e_vf_client_capable(pf, vf->vf_id) &&
-	    (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_IWARP)) {
-		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_IWARP;
-		set_bit(I40E_VF_STATE_IWARPENA, &vf->vf_states);
+	    (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_RDMA)) {
+		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_RDMA;
+		set_bit(I40E_VF_STATE_RDMAENA, &vf->vf_states);
 	} else {
-		clear_bit(I40E_VF_STATE_IWARPENA, &vf->vf_states);
+		clear_bit(I40E_VF_STATE_RDMAENA, &vf->vf_states);
 	}
 
 	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_RSS_PF) {
@@ -3187,21 +3188,21 @@ static int i40e_vc_remove_vlan_msg(struct i40e_vf *vf, u8 *msg)
 }
 
 /**
- * i40e_vc_iwarp_msg
+ * i40e_vc_rdma_msg
  * @vf: pointer to the VF info
  * @msg: pointer to the msg buffer
  * @msglen: msg length
  *
  * called from the VF for the iwarp msgs
  **/
-static int i40e_vc_iwarp_msg(struct i40e_vf *vf, u8 *msg, u16 msglen)
+static int i40e_vc_rdma_msg(struct i40e_vf *vf, u8 *msg, u16 msglen)
 {
 	struct i40e_pf *pf = vf->pf;
 	int abs_vf_id = vf->vf_id + pf->hw.func_caps.vf_base_id;
 	i40e_status aq_ret = 0;
 
 	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states) ||
-	    !test_bit(I40E_VF_STATE_IWARPENA, &vf->vf_states)) {
+	    !test_bit(I40E_VF_STATE_RDMAENA, &vf->vf_states)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
 	}
@@ -3211,42 +3212,42 @@ static int i40e_vc_iwarp_msg(struct i40e_vf *vf, u8 *msg, u16 msglen)
 
 error_param:
 	/* send the response to the VF */
-	return i40e_vc_send_resp_to_vf(vf, VIRTCHNL_OP_IWARP,
+	return i40e_vc_send_resp_to_vf(vf, VIRTCHNL_OP_RDMA,
 				       aq_ret);
 }
 
 /**
- * i40e_vc_iwarp_qvmap_msg
+ * i40e_vc_rdma_qvmap_msg
  * @vf: pointer to the VF info
  * @msg: pointer to the msg buffer
  * @config: config qvmap or release it
  *
  * called from the VF for the iwarp msgs
  **/
-static int i40e_vc_iwarp_qvmap_msg(struct i40e_vf *vf, u8 *msg, bool config)
+static int i40e_vc_rdma_qvmap_msg(struct i40e_vf *vf, u8 *msg, bool config)
 {
-	struct virtchnl_iwarp_qvlist_info *qvlist_info =
-				(struct virtchnl_iwarp_qvlist_info *)msg;
+	struct virtchnl_rdma_qvlist_info *qvlist_info =
+				(struct virtchnl_rdma_qvlist_info *)msg;
 	i40e_status aq_ret = 0;
 
 	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states) ||
-	    !test_bit(I40E_VF_STATE_IWARPENA, &vf->vf_states)) {
+	    !test_bit(I40E_VF_STATE_RDMAENA, &vf->vf_states)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
 	}
 
 	if (config) {
-		if (i40e_config_iwarp_qvlist(vf, qvlist_info))
+		if (i40e_config_rdma_qvlist(vf, qvlist_info))
 			aq_ret = I40E_ERR_PARAM;
 	} else {
-		i40e_release_iwarp_qvlist(vf);
+		i40e_release_rdma_qvlist(vf);
 	}
 
 error_param:
 	/* send the response to the VF */
 	return i40e_vc_send_resp_to_vf(vf,
-			       config ? VIRTCHNL_OP_CONFIG_IWARP_IRQ_MAP :
-			       VIRTCHNL_OP_RELEASE_IWARP_IRQ_MAP,
+			       config ? VIRTCHNL_OP_CONFIG_RDMA_IRQ_MAP :
+			       VIRTCHNL_OP_RELEASE_RDMA_IRQ_MAP,
 			       aq_ret);
 }
 
@@ -4112,14 +4113,14 @@ int i40e_vc_process_vf_msg(struct i40e_pf *pf, s16 vf_id, u32 v_opcode,
 	case VIRTCHNL_OP_GET_STATS:
 		ret = i40e_vc_get_stats_msg(vf, msg);
 		break;
-	case VIRTCHNL_OP_IWARP:
-		ret = i40e_vc_iwarp_msg(vf, msg, msglen);
+	case VIRTCHNL_OP_RDMA:
+		ret = i40e_vc_rdma_msg(vf, msg, msglen);
 		break;
-	case VIRTCHNL_OP_CONFIG_IWARP_IRQ_MAP:
-		ret = i40e_vc_iwarp_qvmap_msg(vf, msg, true);
+	case VIRTCHNL_OP_CONFIG_RDMA_IRQ_MAP:
+		ret = i40e_vc_rdma_qvmap_msg(vf, msg, true);
 		break;
-	case VIRTCHNL_OP_RELEASE_IWARP_IRQ_MAP:
-		ret = i40e_vc_iwarp_qvmap_msg(vf, msg, false);
+	case VIRTCHNL_OP_RELEASE_RDMA_IRQ_MAP:
+		ret = i40e_vc_rdma_qvmap_msg(vf, msg, false);
 		break;
 	case VIRTCHNL_OP_CONFIG_RSS_KEY:
 		ret = i40e_vc_config_rss_key(vf, msg);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
index 358bbdb58795..895b8feb2567 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
@@ -34,7 +34,7 @@ enum i40e_queue_ctrl {
 enum i40e_vf_states {
 	I40E_VF_STATE_INIT = 0,
 	I40E_VF_STATE_ACTIVE,
-	I40E_VF_STATE_IWARPENA,
+	I40E_VF_STATE_RDMAENA,
 	I40E_VF_STATE_DISABLED,
 	I40E_VF_STATE_MC_PROMISC,
 	I40E_VF_STATE_UC_PROMISC,
@@ -46,7 +46,7 @@ enum i40e_vf_states {
 enum i40e_vf_capabilities {
 	I40E_VIRTCHNL_VF_CAP_PRIVILEGE = 0,
 	I40E_VIRTCHNL_VF_CAP_L2,
-	I40E_VIRTCHNL_VF_CAP_IWARP,
+	I40E_VIRTCHNL_VF_CAP_RDMA,
 };
 
 /* In ADq, max 4 VSI's can be allocated per VF including primary VF VSI.
@@ -108,7 +108,7 @@ struct i40e_vf {
 	u16 num_cloud_filters;
 
 	/* RDMA Client */
-	struct virtchnl_iwarp_qvlist_info *qvlist_info;
+	struct virtchnl_rdma_qvlist_info *qvlist_info;
 };
 
 void i40e_free_vfs(struct i40e_pf *pf);
diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 0d1bab4ac1b0..437056e9a9ca 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -275,8 +275,8 @@ struct iavf_adapter {
 	u64 hw_csum_rx_error;
 	u32 rx_desc_count;
 	int num_msix_vectors;
-	int num_iwarp_msix;
-	int iwarp_base_vector;
+	int num_rdma_msix;
+	int rdma_base_vector;
 	u32 client_pending;
 	struct iavf_client_instance *cinst;
 	struct msix_entry *msix_entries;
@@ -383,7 +383,7 @@ struct iavf_adapter {
 	enum virtchnl_ops current_op;
 #define CLIENT_ALLOWED(_a) ((_a)->vf_res ? \
 			    (_a)->vf_res->vf_cap_flags & \
-				VIRTCHNL_VF_OFFLOAD_IWARP : \
+				VIRTCHNL_VF_OFFLOAD_RDMA : \
 			    0)
 #define CLIENT_ENABLED(_a) ((_a)->cinst)
 /* RSS by the PF should be preferred over RSS via other methods. */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_client.c b/drivers/net/ethernet/intel/iavf/iavf_client.c
index 0c77e4171808..93c903c02c64 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_client.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_client.c
@@ -127,7 +127,7 @@ void iavf_notify_client_open(struct iavf_vsi *vsi)
 }
 
 /**
- * iavf_client_release_qvlist - send a message to the PF to release iwarp qv map
+ * iavf_client_release_qvlist - send a message to the PF to release rdma qv map
  * @ldev: pointer to L2 context.
  *
  * Return 0 on success or < 0 on error
@@ -141,12 +141,12 @@ static int iavf_client_release_qvlist(struct iavf_info *ldev)
 		return -EAGAIN;
 
 	err = iavf_aq_send_msg_to_pf(&adapter->hw,
-				     VIRTCHNL_OP_RELEASE_IWARP_IRQ_MAP,
+				     VIRTCHNL_OP_RELEASE_RDMA_IRQ_MAP,
 				     IAVF_SUCCESS, NULL, 0, NULL);
 
 	if (err)
 		dev_err(&adapter->pdev->dev,
-			"Unable to send iWarp vector release message to PF, error %d, aq status %d\n",
+			"Unable to send RDMA vector release message to PF, error %d, aq status %d\n",
 			err, adapter->hw.aq.asq_last_status);
 
 	return err;
@@ -215,9 +215,9 @@ iavf_client_add_instance(struct iavf_adapter *adapter)
 	cinst->lan_info.params = params;
 	set_bit(__IAVF_CLIENT_INSTANCE_NONE, &cinst->state);
 
-	cinst->lan_info.msix_count = adapter->num_iwarp_msix;
+	cinst->lan_info.msix_count = adapter->num_rdma_msix;
 	cinst->lan_info.msix_entries =
-			&adapter->msix_entries[adapter->iwarp_base_vector];
+			&adapter->msix_entries[adapter->rdma_base_vector];
 
 	mac = list_first_entry(&cinst->lan_info.netdev->dev_addrs.list,
 			       struct netdev_hw_addr, list);
@@ -425,17 +425,17 @@ static u32 iavf_client_virtchnl_send(struct iavf_info *ldev,
 	if (adapter->aq_required)
 		return -EAGAIN;
 
-	err = iavf_aq_send_msg_to_pf(&adapter->hw, VIRTCHNL_OP_IWARP,
+	err = iavf_aq_send_msg_to_pf(&adapter->hw, VIRTCHNL_OP_RDMA,
 				     IAVF_SUCCESS, msg, len, NULL);
 	if (err)
-		dev_err(&adapter->pdev->dev, "Unable to send iWarp message to PF, error %d, aq status %d\n",
+		dev_err(&adapter->pdev->dev, "Unable to send RDMA message to PF, error %d, aq status %d\n",
 			err, adapter->hw.aq.asq_last_status);
 
 	return err;
 }
 
 /**
- * iavf_client_setup_qvlist - send a message to the PF to setup iwarp qv map
+ * iavf_client_setup_qvlist - send a message to the PF to setup rdma qv map
  * @ldev: pointer to L2 context.
  * @client: Client pointer.
  * @qvlist_info: queue and vector list
@@ -446,7 +446,7 @@ static int iavf_client_setup_qvlist(struct iavf_info *ldev,
 				    struct iavf_client *client,
 				    struct iavf_qvlist_info *qvlist_info)
 {
-	struct virtchnl_iwarp_qvlist_info *v_qvlist_info;
+	struct virtchnl_rdma_qvlist_info *v_qvlist_info;
 	struct iavf_adapter *adapter = ldev->vf;
 	struct iavf_qv_info *qv_info;
 	enum iavf_status err;
@@ -463,23 +463,23 @@ static int iavf_client_setup_qvlist(struct iavf_info *ldev,
 			continue;
 		v_idx = qv_info->v_idx;
 		if ((v_idx >=
-		    (adapter->iwarp_base_vector + adapter->num_iwarp_msix)) ||
-		    (v_idx < adapter->iwarp_base_vector))
+		    (adapter->rdma_base_vector + adapter->num_rdma_msix)) ||
+		    (v_idx < adapter->rdma_base_vector))
 			return -EINVAL;
 	}
 
-	v_qvlist_info = (struct virtchnl_iwarp_qvlist_info *)qvlist_info;
+	v_qvlist_info = (struct virtchnl_rdma_qvlist_info *)qvlist_info;
 	msg_size = struct_size(v_qvlist_info, qv_info,
 			       v_qvlist_info->num_vectors - 1);
 
-	adapter->client_pending |= BIT(VIRTCHNL_OP_CONFIG_IWARP_IRQ_MAP);
+	adapter->client_pending |= BIT(VIRTCHNL_OP_CONFIG_RDMA_IRQ_MAP);
 	err = iavf_aq_send_msg_to_pf(&adapter->hw,
-				VIRTCHNL_OP_CONFIG_IWARP_IRQ_MAP, IAVF_SUCCESS,
+				VIRTCHNL_OP_CONFIG_RDMA_IRQ_MAP, IAVF_SUCCESS,
 				(u8 *)v_qvlist_info, msg_size, NULL);
 
 	if (err) {
 		dev_err(&adapter->pdev->dev,
-			"Unable to send iWarp vector config message to PF, error %d, aq status %d\n",
+			"Unable to send RDMA vector config message to PF, error %d, aq status %d\n",
 			err, adapter->hw.aq.asq_last_status);
 		goto out;
 	}
@@ -488,7 +488,7 @@ static int iavf_client_setup_qvlist(struct iavf_info *ldev,
 	for (i = 0; i < 5; i++) {
 		msleep(100);
 		if (!(adapter->client_pending &
-		      BIT(VIRTCHNL_OP_CONFIG_IWARP_IRQ_MAP))) {
+		      BIT(VIRTCHNL_OP_CONFIG_RDMA_IRQ_MAP))) {
 			err = 0;
 			break;
 		}
diff --git a/drivers/net/ethernet/intel/iavf/iavf_client.h b/drivers/net/ethernet/intel/iavf/iavf_client.h
index 9a7cf39ea75a..c5d51d7dc7cc 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_client.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_client.h
@@ -159,7 +159,7 @@ struct iavf_client {
 #define IAVF_CLIENT_FLAGS_LAUNCH_ON_PROBE	BIT(0)
 #define IAVF_TX_FLAGS_NOTIFY_OTHER_EVENTS	BIT(2)
 	u8 type;
-#define IAVF_CLIENT_IWARP 0
+#define IAVF_CLIENT_RDMA 0
 	struct iavf_client_ops *ops;	/* client ops provided by the client */
 };
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_common.c b/drivers/net/ethernet/intel/iavf/iavf_common.c
index 34e46a23894f..16c490965b61 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_common.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_common.c
@@ -223,8 +223,8 @@ const char *iavf_stat_str(struct iavf_hw *hw, enum iavf_status stat_err)
 		return "IAVF_ERR_ADMIN_QUEUE_FULL";
 	case IAVF_ERR_ADMIN_QUEUE_NO_WORK:
 		return "IAVF_ERR_ADMIN_QUEUE_NO_WORK";
-	case IAVF_ERR_BAD_IWARP_CQE:
-		return "IAVF_ERR_BAD_IWARP_CQE";
+	case IAVF_ERR_BAD_RDMA_CQE:
+		return "IAVF_ERR_BAD_RDMA_CQE";
 	case IAVF_ERR_NVM_BLANK_MODE:
 		return "IAVF_ERR_NVM_BLANK_MODE";
 	case IAVF_ERR_NOT_IMPLEMENTED:
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index adc02adef83a..c4e135ff0b2a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -106,7 +106,7 @@ int iavf_status_to_errno(enum iavf_status status)
 	case IAVF_ERR_SRQ_ENABLED:
 	case IAVF_ERR_ADMIN_QUEUE_ERROR:
 	case IAVF_ERR_ADMIN_QUEUE_FULL:
-	case IAVF_ERR_BAD_IWARP_CQE:
+	case IAVF_ERR_BAD_RDMA_CQE:
 	case IAVF_ERR_NVM_BLANK_MODE:
 	case IAVF_ERR_PE_DOORBELL_NOT_ENABLED:
 	case IAVF_ERR_DIAG_TEST_FAILED:
diff --git a/drivers/net/ethernet/intel/iavf/iavf_status.h b/drivers/net/ethernet/intel/iavf/iavf_status.h
index 2ea5c7c339bc..0e493ee9e9d1 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_status.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_status.h
@@ -64,7 +64,7 @@ enum iavf_status {
 	IAVF_ERR_BUF_TOO_SHORT			= -55,
 	IAVF_ERR_ADMIN_QUEUE_FULL		= -56,
 	IAVF_ERR_ADMIN_QUEUE_NO_WORK		= -57,
-	IAVF_ERR_BAD_IWARP_CQE			= -58,
+	IAVF_ERR_BAD_RDMA_CQE			= -58,
 	IAVF_ERR_NVM_BLANK_MODE			= -59,
 	IAVF_ERR_NOT_IMPLEMENTED		= -60,
 	IAVF_ERR_PE_DOORBELL_NOT_ENABLED	= -61,
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 24a701fd140e..6956a406b5ec 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -2290,7 +2290,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		if (v_opcode != adapter->current_op)
 			return;
 		break;
-	case VIRTCHNL_OP_IWARP:
+	case VIRTCHNL_OP_RDMA:
 		/* Gobble zero-length replies from the PF. They indicate that
 		 * a previous message was received OK, and the client doesn't
 		 * care about that.
@@ -2299,9 +2299,9 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 			iavf_notify_client_message(&adapter->vsi, msg, msglen);
 		break;
 
-	case VIRTCHNL_OP_CONFIG_IWARP_IRQ_MAP:
+	case VIRTCHNL_OP_CONFIG_RDMA_IRQ_MAP:
 		adapter->client_pending &=
-				~(BIT(VIRTCHNL_OP_CONFIG_IWARP_IRQ_MAP));
+				~(BIT(VIRTCHNL_OP_CONFIG_RDMA_IRQ_MAP));
 		break;
 	case VIRTCHNL_OP_GET_RSS_HENA_CAPS: {
 		struct virtchnl_rss_hena *vrh = (struct virtchnl_rss_hena *)msg;
diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index 5c630c818370..c15221dcb75e 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -114,9 +114,13 @@ enum virtchnl_ops {
 	VIRTCHNL_OP_GET_STATS = 15,
 	VIRTCHNL_OP_RSVD = 16,
 	VIRTCHNL_OP_EVENT = 17, /* must ALWAYS be 17 */
+	/* opcode 19 is reserved */
 	VIRTCHNL_OP_IWARP = 20, /* advanced opcode */
+	VIRTCHNL_OP_RDMA = VIRTCHNL_OP_IWARP,
 	VIRTCHNL_OP_CONFIG_IWARP_IRQ_MAP = 21, /* advanced opcode */
+	VIRTCHNL_OP_CONFIG_RDMA_IRQ_MAP = VIRTCHNL_OP_CONFIG_IWARP_IRQ_MAP,
 	VIRTCHNL_OP_RELEASE_IWARP_IRQ_MAP = 22, /* advanced opcode */
+	VIRTCHNL_OP_RELEASE_RDMA_IRQ_MAP = VIRTCHNL_OP_RELEASE_IWARP_IRQ_MAP,
 	VIRTCHNL_OP_CONFIG_RSS_KEY = 23,
 	VIRTCHNL_OP_CONFIG_RSS_LUT = 24,
 	VIRTCHNL_OP_GET_RSS_HENA_CAPS = 25,
@@ -228,7 +232,8 @@ VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_vsi_resource);
  * TX/RX Checksum offloading and TSO for non-tunnelled packets.
  */
 #define VIRTCHNL_VF_OFFLOAD_L2			BIT(0)
-#define VIRTCHNL_VF_OFFLOAD_IWARP		BIT(1)
+#define VIRTCHNL_VF_OFFLOAD_RDMA		BIT(1)
+#define VIRTCHNL_VF_CAP_RDMA			VIRTCHNL_VF_OFFLOAD_RDMA
 #define VIRTCHNL_VF_OFFLOAD_RSS_AQ		BIT(3)
 #define VIRTCHNL_VF_OFFLOAD_RSS_REG		BIT(4)
 #define VIRTCHNL_VF_OFFLOAD_WB_ON_ITR		BIT(5)
@@ -1021,34 +1026,36 @@ struct virtchnl_pf_event {
 
 VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_pf_event);
 
-/* VIRTCHNL_OP_CONFIG_IWARP_IRQ_MAP
- * VF uses this message to request PF to map IWARP vectors to IWARP queues.
- * The request for this originates from the VF IWARP driver through
- * a client interface between VF LAN and VF IWARP driver.
+/* used to specify if a ceq_idx or aeq_idx is invalid */
+#define VIRTCHNL_RDMA_INVALID_QUEUE_IDX	0xFFFF
+/* VIRTCHNL_OP_CONFIG_RDMA_IRQ_MAP
+ * VF uses this message to request PF to map RDMA vectors to RDMA queues.
+ * The request for this originates from the VF RDMA driver through
+ * a client interface between VF LAN and VF RDMA driver.
  * A vector could have an AEQ and CEQ attached to it although
- * there is a single AEQ per VF IWARP instance in which case
- * most vectors will have an INVALID_IDX for aeq and valid idx for ceq.
- * There will never be a case where there will be multiple CEQs attached
- * to a single vector.
+ * there is a single AEQ per VF RDMA instance in which case
+ * most vectors will have an VIRTCHNL_RDMA_INVALID_QUEUE_IDX for aeq and valid
+ * idx for ceqs There will never be a case where there will be multiple CEQs
+ * attached to a single vector.
  * PF configures interrupt mapping and returns status.
  */
 
-struct virtchnl_iwarp_qv_info {
+struct virtchnl_rdma_qv_info {
 	u32 v_idx; /* msix_vector */
-	u16 ceq_idx;
-	u16 aeq_idx;
+	u16 ceq_idx; /* set to VIRTCHNL_RDMA_INVALID_QUEUE_IDX if invalid */
+	u16 aeq_idx; /* set to VIRTCHNL_RDMA_INVALID_QUEUE_IDX if invalid */
 	u8 itr_idx;
 	u8 pad[3];
 };
 
-VIRTCHNL_CHECK_STRUCT_LEN(12, virtchnl_iwarp_qv_info);
+VIRTCHNL_CHECK_STRUCT_LEN(12, virtchnl_rdma_qv_info);
 
-struct virtchnl_iwarp_qvlist_info {
+struct virtchnl_rdma_qvlist_info {
 	u32 num_vectors;
-	struct virtchnl_iwarp_qv_info qv_info[1];
+	struct virtchnl_rdma_qv_info qv_info[1];
 };
 
-VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_iwarp_qvlist_info);
+VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_rdma_qvlist_info);
 
 /* VF reset states - these are written into the RSTAT register:
  * VFGEN_RSTAT on the VF
@@ -1287,7 +1294,7 @@ VIRTCHNL_CHECK_STRUCT_LEN(2604, virtchnl_fdir_rule);
 /* Status returned to VF after VF requests FDIR commands
  * VIRTCHNL_FDIR_SUCCESS
  * VF FDIR related request is successfully done by PF
- * The request can be OP_ADD/DEL.
+ * The request can be OP_ADD/DEL/QUERY_FDIR_FILTER.
  *
  * VIRTCHNL_FDIR_FAILURE_RULE_NORESOURCE
  * OP_ADD_FDIR_FILTER request is failed due to no Hardware resource.
@@ -1308,6 +1315,10 @@ VIRTCHNL_CHECK_STRUCT_LEN(2604, virtchnl_fdir_rule);
  * VIRTCHNL_FDIR_FAILURE_RULE_TIMEOUT
  * OP_ADD/DEL_FDIR_FILTER request is failed due to timing out
  * for programming.
+ *
+ * VIRTCHNL_FDIR_FAILURE_QUERY_INVALID
+ * OP_QUERY_FDIR_FILTER request is failed due to parameters validation,
+ * for example, VF query counter of a rule who has no counter action.
  */
 enum virtchnl_fdir_prgm_status {
 	VIRTCHNL_FDIR_SUCCESS = 0,
@@ -1317,6 +1328,7 @@ enum virtchnl_fdir_prgm_status {
 	VIRTCHNL_FDIR_FAILURE_RULE_NONEXIST,
 	VIRTCHNL_FDIR_FAILURE_RULE_INVALID,
 	VIRTCHNL_FDIR_FAILURE_RULE_TIMEOUT,
+	VIRTCHNL_FDIR_FAILURE_QUERY_INVALID,
 };
 
 /* VIRTCHNL_OP_ADD_FDIR_FILTER
@@ -1444,7 +1456,7 @@ virtchnl_vc_validate_vf_msg(struct virtchnl_version_info *ver, u32 v_opcode,
 	case VIRTCHNL_OP_GET_STATS:
 		valid_len = sizeof(struct virtchnl_queue_select);
 		break;
-	case VIRTCHNL_OP_IWARP:
+	case VIRTCHNL_OP_RDMA:
 		/* These messages are opaque to us and will be validated in
 		 * the RDMA client code. We just need to check for nonzero
 		 * length. The firmware will enforce max length restrictions.
@@ -1454,19 +1466,16 @@ virtchnl_vc_validate_vf_msg(struct virtchnl_version_info *ver, u32 v_opcode,
 		else
 			err_msg_format = true;
 		break;
-	case VIRTCHNL_OP_RELEASE_IWARP_IRQ_MAP:
+	case VIRTCHNL_OP_RELEASE_RDMA_IRQ_MAP:
 		break;
-	case VIRTCHNL_OP_CONFIG_IWARP_IRQ_MAP:
-		valid_len = sizeof(struct virtchnl_iwarp_qvlist_info);
+	case VIRTCHNL_OP_CONFIG_RDMA_IRQ_MAP:
+		valid_len = sizeof(struct virtchnl_rdma_qvlist_info);
 		if (msglen >= valid_len) {
-			struct virtchnl_iwarp_qvlist_info *qv =
-				(struct virtchnl_iwarp_qvlist_info *)msg;
-			if (qv->num_vectors == 0) {
-				err_msg_format = true;
-				break;
-			}
+			struct virtchnl_rdma_qvlist_info *qv =
+				(struct virtchnl_rdma_qvlist_info *)msg;
+
 			valid_len += ((qv->num_vectors - 1) *
-				sizeof(struct virtchnl_iwarp_qv_info));
+				sizeof(struct virtchnl_rdma_qv_info));
 		}
 		break;
 	case VIRTCHNL_OP_CONFIG_RSS_KEY:
-- 
2.38.1

