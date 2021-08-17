Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0300D3EE5CA
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 06:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237712AbhHQEqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 00:46:03 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:5278 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237344AbhHQEpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 00:45:53 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17H2lc5q006745;
        Mon, 16 Aug 2021 21:45:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=aFPl3T48AGI+Lgar+yFE8nccGtARl4Rgdxkm5LxfN58=;
 b=goR+rgCLbdAiLm/ddGscTtCNoPycH2mtejrXMDypZhdZmPJh2d1gIujqc3onrrTbxb2W
 Kw8CYkZuZts6PWcoajqMdRYnQNN1Zamu3ty+DJL4/Y4w7YNeCp6CfGJOaRM4QScj0jkt
 2jui/3YxrNSs7Q2Hi/f41M6f26ZBjfcsrSlUfEY6pSJnQp0tgH43YunSQuzbuF4ALeZ2
 kR73cm4ay+cWqXxiZ/sWLEzxPZALyO8tMG3Y7oKvdgcJCAz2puhYJN0bCoOt/gjbQQT7
 GlbifV5SO7rRODrcNEbdmvVcr262bp4OPh1W2afUr46nWr+2PoBV1SGyiZKyv4gg+QY4 8A== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3ag4n0ra56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 21:45:20 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 16 Aug
 2021 21:45:18 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 16 Aug 2021 21:45:18 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 9F4323F70AE;
        Mon, 16 Aug 2021 21:45:16 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 07/11] octeontx2-pf: Unify flow management variables
Date:   Tue, 17 Aug 2021 10:14:49 +0530
Message-ID: <1629175493-4895-8-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629175493-4895-1-git-send-email-sbhatta@marvell.com>
References: <1629175493-4895-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: fVrN9enoUemRJMDxbtE53yXVhd7azJNH
X-Proofpoint-ORIG-GUID: fVrN9enoUemRJMDxbtE53yXVhd7azJNH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-17_01,2021-08-16_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Variables used for TC flow management like maximum number
of flows, number of flows installed etc are a copy of ntuple
flow management variables. Since both TC and NTUPLE are not
supported at the same time, it's better to unify these with
common variables.

This patch addresses this unification and also does cleanup of
other minor stuff wrt TC.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   | 17 ++++----
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    | 29 ++++++--------
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 34 ++++++++++------
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   | 46 ++++++++++++++++++----
 4 files changed, 80 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 4f95a69..fc3447a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -268,7 +268,6 @@ struct otx2_mac_table {
 };
 
 struct otx2_flow_config {
-	u16			entry[NPC_MAX_NONCONTIG_ENTRIES];
 	u16			*flow_ent;
 	u16			*def_ent;
 	u16			nr_flows;
@@ -279,16 +278,13 @@ struct otx2_flow_config {
 #define OTX2_MCAM_COUNT		(OTX2_DEFAULT_FLOWCOUNT + \
 				 OTX2_MAX_UNICAST_FLOWS + \
 				 OTX2_MAX_VLAN_FLOWS)
-	u16			ntuple_offset;
 	u16			unicast_offset;
 	u16			rx_vlan_offset;
 	u16			vf_vlan_offset;
 #define OTX2_PER_VF_VLAN_FLOWS	2 /* Rx + Tx per VF */
 #define OTX2_VF_VLAN_RX_INDEX	0
 #define OTX2_VF_VLAN_TX_INDEX	1
-	u16			tc_flower_offset;
-	u16                     ntuple_max_flows;
-	u16			tc_max_flows;
+	u16			max_flows;
 	u8			dmacflt_max_flows;
 	u8			*bmap_to_dmacindex;
 	unsigned long		dmacflt_bmap;
@@ -299,8 +295,7 @@ struct otx2_tc_info {
 	/* hash table to store TC offloaded flows */
 	struct rhashtable		flow_table;
 	struct rhashtable_params	flow_ht_params;
-	DECLARE_BITMAP(tc_entries_bitmap, OTX2_MAX_TC_FLOWS);
-	unsigned long			num_entries;
+	unsigned long			*tc_entries_bitmap;
 };
 
 struct dev_hw_ops {
@@ -353,6 +348,11 @@ struct otx2_nic {
 	struct otx2_vf_config	*vf_configs;
 	struct cgx_link_user_info linfo;
 
+	/* NPC MCAM */
+	struct otx2_flow_config	*flow_cfg;
+	struct otx2_mac_table	*mac_table;
+	struct otx2_tc_info	tc_info;
+
 	u64			reset_count;
 	struct work_struct	reset_task;
 	struct workqueue_struct	*flr_wq;
@@ -360,7 +360,6 @@ struct otx2_nic {
 	struct refill_work	*refill_wrk;
 	struct workqueue_struct	*otx2_wq;
 	struct work_struct	rx_mode_work;
-	struct otx2_mac_table	*mac_table;
 
 	/* Ethtool stuff */
 	u32			msg_enable;
@@ -376,8 +375,6 @@ struct otx2_nic {
 	struct otx2_ptp		*ptp;
 	struct hwtstamp_config	tstamp;
 
-	struct otx2_flow_config	*flow_cfg;
-	struct otx2_tc_info	tc_info;
 	unsigned long		rq_bmap;
 };
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 96e1158..de6ef32 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -31,8 +31,7 @@ static void otx2_clear_ntuple_flow_info(struct otx2_nic *pfvf, struct otx2_flow_
 {
 	devm_kfree(pfvf->dev, flow_cfg->flow_ent);
 	flow_cfg->flow_ent = NULL;
-	flow_cfg->ntuple_max_flows = 0;
-	flow_cfg->tc_max_flows = 0;
+	flow_cfg->max_flows = 0;
 }
 
 static int otx2_free_ntuple_mcam_entries(struct otx2_nic *pfvf)
@@ -41,11 +40,11 @@ static int otx2_free_ntuple_mcam_entries(struct otx2_nic *pfvf)
 	struct npc_mcam_free_entry_req *req;
 	int ent, err;
 
-	if (!flow_cfg->ntuple_max_flows)
+	if (!flow_cfg->max_flows)
 		return 0;
 
 	mutex_lock(&pfvf->mbox.lock);
-	for (ent = 0; ent < flow_cfg->ntuple_max_flows; ent++) {
+	for (ent = 0; ent < flow_cfg->max_flows; ent++) {
 		req = otx2_mbox_alloc_msg_npc_mcam_free_entry(&pfvf->mbox);
 		if (!req)
 			break;
@@ -138,9 +137,7 @@ static int otx2_alloc_ntuple_mcam_entries(struct otx2_nic *pfvf, u16 count)
 exit:
 	mutex_unlock(&pfvf->mbox.lock);
 
-	flow_cfg->ntuple_offset = 0;
-	flow_cfg->ntuple_max_flows = allocated;
-	flow_cfg->tc_max_flows = allocated;
+	flow_cfg->max_flows = allocated;
 
 	pfvf->flags |= OTX2_FLAG_MCAM_ENTRIES_ALLOC;
 	pfvf->flags |= OTX2_FLAG_NTUPLE_SUPPORT;
@@ -236,7 +233,7 @@ int otx2vf_mcam_flow_init(struct otx2_nic *pfvf)
 
 	flow_cfg = pfvf->flow_cfg;
 	INIT_LIST_HEAD(&flow_cfg->flow_list);
-	flow_cfg->ntuple_max_flows = 0;
+	flow_cfg->max_flows = 0;
 
 	count = otx2_alloc_ntuple_mcam_entries(pfvf, OTX2_DEFAULT_FLOWCOUNT);
 	if (count <= 0)
@@ -430,12 +427,12 @@ int otx2_get_maxflows(struct otx2_flow_config *flow_cfg)
 	if (!flow_cfg)
 		return 0;
 
-	if (flow_cfg->nr_flows == flow_cfg->ntuple_max_flows ||
+	if (flow_cfg->nr_flows == flow_cfg->max_flows ||
 	    bitmap_weight(&flow_cfg->dmacflt_bmap,
 			  flow_cfg->dmacflt_max_flows))
-		return flow_cfg->ntuple_max_flows + flow_cfg->dmacflt_max_flows;
+		return flow_cfg->max_flows + flow_cfg->dmacflt_max_flows;
 	else
-		return flow_cfg->ntuple_max_flows;
+		return flow_cfg->max_flows;
 }
 EXPORT_SYMBOL(otx2_get_maxflows);
 
@@ -944,7 +941,7 @@ static int otx2_add_flow_with_pfmac(struct otx2_nic *pfvf,
 
 	pf_mac->entry = 0;
 	pf_mac->dmac_filter = true;
-	pf_mac->location = pfvf->flow_cfg->ntuple_max_flows;
+	pf_mac->location = pfvf->flow_cfg->max_flows;
 	memcpy(&pf_mac->flow_spec, &flow->flow_spec,
 	       sizeof(struct ethtool_rx_flow_spec));
 	pf_mac->flow_spec.location = pf_mac->location;
@@ -1025,7 +1022,7 @@ int otx2_add_flow(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc)
 		flow->dmac_filter = true;
 		flow->entry = find_first_zero_bit(&flow_cfg->dmacflt_bmap,
 						  flow_cfg->dmacflt_max_flows);
-		fsp->location = flow_cfg->ntuple_max_flows + flow->entry;
+		fsp->location = flow_cfg->max_flows + flow->entry;
 		flow->flow_spec.location = fsp->location;
 		flow->location = fsp->location;
 
@@ -1033,11 +1030,11 @@ int otx2_add_flow(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc)
 		otx2_dmacflt_add(pfvf, eth_hdr->h_dest, flow->entry);
 
 	} else {
-		if (flow->location >= pfvf->flow_cfg->ntuple_max_flows) {
+		if (flow->location >= pfvf->flow_cfg->max_flows) {
 			netdev_warn(pfvf->netdev,
 				    "Can't insert non dmac ntuple rule at %d, allowed range %d-0\n",
 				    flow->location,
-				    flow_cfg->ntuple_max_flows - 1);
+				    flow_cfg->max_flows - 1);
 			err = -EINVAL;
 		} else {
 			flow->entry = flow_cfg->flow_ent[flow->location];
@@ -1192,7 +1189,7 @@ int otx2_destroy_ntuple_flows(struct otx2_nic *pfvf)
 	}
 
 	req->start = flow_cfg->flow_ent[0];
-	req->end   = flow_cfg->flow_ent[flow_cfg->ntuple_max_flows - 1];
+	req->end   = flow_cfg->flow_ent[flow_cfg->max_flows - 1];
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
 	mutex_unlock(&pfvf->mbox.lock);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index e0968ca..de8b45e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1787,17 +1787,10 @@ static netdev_tx_t otx2_xmit(struct sk_buff *skb, struct net_device *netdev)
 static netdev_features_t otx2_fix_features(struct net_device *dev,
 					   netdev_features_t features)
 {
-	/* check if n-tuple filters are ON */
-	if ((features & NETIF_F_HW_TC) && (dev->features & NETIF_F_NTUPLE)) {
-		netdev_info(dev, "Disabling n-tuple filters\n");
-		features &= ~NETIF_F_NTUPLE;
-	}
-
-	/* check if tc hw offload is ON */
-	if ((features & NETIF_F_NTUPLE) && (dev->features & NETIF_F_HW_TC)) {
-		netdev_info(dev, "Disabling TC hardware offload\n");
-		features &= ~NETIF_F_HW_TC;
-	}
+	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+		features |= NETIF_F_HW_VLAN_STAG_RX;
+	else
+		features &= ~NETIF_F_HW_VLAN_STAG_RX;
 
 	return features;
 }
@@ -1854,6 +1847,7 @@ static int otx2_set_features(struct net_device *netdev,
 	netdev_features_t changed = features ^ netdev->features;
 	bool ntuple = !!(features & NETIF_F_NTUPLE);
 	struct otx2_nic *pf = netdev_priv(netdev);
+	bool tc = !!(features & NETIF_F_HW_TC);
 
 	if ((changed & NETIF_F_LOOPBACK) && netif_running(netdev))
 		return otx2_cgx_config_loopback(pf,
@@ -1866,12 +1860,26 @@ static int otx2_set_features(struct net_device *netdev,
 	if ((changed & NETIF_F_NTUPLE) && !ntuple)
 		otx2_destroy_ntuple_flows(pf);
 
-	if ((netdev->features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC) &&
-	    pf->tc_info.num_entries) {
+	if ((changed & NETIF_F_HW_TC) && !tc &&
+	    pf->flow_cfg && pf->flow_cfg->nr_flows) {
 		netdev_err(netdev, "Can't disable TC hardware offload while flows are active\n");
 		return -EBUSY;
 	}
 
+	if ((changed & NETIF_F_NTUPLE) && ntuple &&
+	    (netdev->features & NETIF_F_HW_TC) && !(changed & NETIF_F_HW_TC)) {
+		netdev_err(netdev,
+			   "Can't enable NTUPLE when TC is active, disable TC and retry\n");
+		return -EINVAL;
+	}
+
+	if ((changed & NETIF_F_HW_TC) && tc &&
+	    (netdev->features & NETIF_F_NTUPLE) && !(changed & NETIF_F_NTUPLE)) {
+		netdev_err(netdev,
+			   "Can't enable TC when NTUPLE is active, disable NTUPLE and retry\n");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 972b202..77cf3dc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -52,6 +52,25 @@ struct otx2_tc_flow {
 	bool				is_act_police;
 };
 
+static int otx2_tc_alloc_ent_bitmap(struct otx2_nic *nic)
+{
+	struct otx2_tc_info *tc = &nic->tc_info;
+
+	if (!nic->flow_cfg->max_flows)
+		return 0;
+
+	tc->tc_entries_bitmap =
+			kcalloc(BITS_TO_LONGS(nic->flow_cfg->max_flows),
+				sizeof(long), GFP_KERNEL);
+	if (!tc->tc_entries_bitmap) {
+		netdev_err(nic->netdev,
+			   "Unable to alloc TC flow entries bitmap\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
 static void otx2_get_egress_burst_cfg(u32 burst, u32 *burst_exp,
 				      u32 *burst_mantissa)
 {
@@ -596,6 +615,7 @@ static int otx2_del_mcam_flow_entry(struct otx2_nic *nic, u16 entry)
 static int otx2_tc_del_flow(struct otx2_nic *nic,
 			    struct flow_cls_offload *tc_flow_cmd)
 {
+	struct otx2_flow_config *flow_cfg = nic->flow_cfg;
 	struct otx2_tc_info *tc_info = &nic->tc_info;
 	struct otx2_tc_flow *flow_node;
 	int err;
@@ -638,7 +658,7 @@ static int otx2_tc_del_flow(struct otx2_nic *nic,
 	kfree_rcu(flow_node, rcu);
 
 	clear_bit(flow_node->bitpos, tc_info->tc_entries_bitmap);
-	tc_info->num_entries--;
+	flow_cfg->nr_flows--;
 
 	return 0;
 }
@@ -647,6 +667,7 @@ static int otx2_tc_add_flow(struct otx2_nic *nic,
 			    struct flow_cls_offload *tc_flow_cmd)
 {
 	struct netlink_ext_ack *extack = tc_flow_cmd->common.extack;
+	struct otx2_flow_config *flow_cfg = nic->flow_cfg;
 	struct otx2_tc_info *tc_info = &nic->tc_info;
 	struct otx2_tc_flow *new_node, *old_node;
 	struct npc_install_flow_req *req, dummy;
@@ -655,9 +676,9 @@ static int otx2_tc_add_flow(struct otx2_nic *nic,
 	if (!(nic->flags & OTX2_FLAG_TC_FLOWER_SUPPORT))
 		return -ENOMEM;
 
-	if (bitmap_full(tc_info->tc_entries_bitmap, nic->flow_cfg->tc_max_flows)) {
+	if (bitmap_full(tc_info->tc_entries_bitmap, flow_cfg->max_flows)) {
 		NL_SET_ERR_MSG_MOD(extack,
-				   "Not enough MCAM space to add the flow");
+				   "Free MCAM entry not available to add the flow");
 		return -ENOMEM;
 	}
 
@@ -695,10 +716,9 @@ static int otx2_tc_add_flow(struct otx2_nic *nic,
 	memcpy(req, &dummy, sizeof(struct npc_install_flow_req));
 
 	new_node->bitpos = find_first_zero_bit(tc_info->tc_entries_bitmap,
-					       nic->flow_cfg->tc_max_flows);
+					       flow_cfg->max_flows);
 	req->channel = nic->hw.rx_chan_base;
-	req->entry = nic->flow_cfg->flow_ent[nic->flow_cfg->tc_flower_offset +
-				nic->flow_cfg->tc_max_flows - new_node->bitpos];
+	req->entry = flow_cfg->flow_ent[flow_cfg->max_flows - new_node->bitpos - 1];
 	req->intf = NIX_INTF_RX;
 	req->set_cntr = 1;
 	new_node->entry = req->entry;
@@ -723,7 +743,7 @@ static int otx2_tc_add_flow(struct otx2_nic *nic,
 	}
 
 	set_bit(new_node->bitpos, tc_info->tc_entries_bitmap);
-	tc_info->num_entries++;
+	flow_cfg->nr_flows++;
 
 	return 0;
 
@@ -1008,10 +1028,21 @@ static const struct rhashtable_params tc_flow_ht_params = {
 int otx2_init_tc(struct otx2_nic *nic)
 {
 	struct otx2_tc_info *tc = &nic->tc_info;
+	int err;
 
 	/* Exclude receive queue 0 being used for police action */
 	set_bit(0, &nic->rq_bmap);
 
+	if (!nic->flow_cfg) {
+		netdev_err(nic->netdev,
+			   "Can't init TC, nic->flow_cfg is not setup\n");
+		return -EINVAL;
+	}
+
+	err = otx2_tc_alloc_ent_bitmap(nic);
+	if (err)
+		return err;
+
 	tc->flow_ht_params = tc_flow_ht_params;
 	return rhashtable_init(&tc->flow_table, &tc->flow_ht_params);
 }
@@ -1020,5 +1051,6 @@ void otx2_shutdown_tc(struct otx2_nic *nic)
 {
 	struct otx2_tc_info *tc = &nic->tc_info;
 
+	kfree(tc->tc_entries_bitmap);
 	rhashtable_destroy(&tc->flow_table);
 }
-- 
2.7.4

