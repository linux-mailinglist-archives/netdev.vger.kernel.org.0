Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992013A7D5A
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 13:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhFOLim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 07:38:42 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40798 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229557AbhFOLil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 07:38:41 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15FBUA7l022080;
        Tue, 15 Jun 2021 04:34:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=3zTlqfEFAfrSXa99jK3GMSggjrxCMm/2IGrP/8tsp9g=;
 b=kA9XqRjfQMPu/lkv/CfdE5BTsq+1uE4ycJKdrmGocNYs3f36XLcYb02/UnOm15AKzgla
 F/fg6ycmv/Kk0NzMiPSICR/rQOVmJ4uqT0tJTJY26ZQsXXFooUObiVCVkWHYbyp2TgH1
 wO5s/VBzj2oOnZ+cNi1cijuzFKtkavDswdTf24DsekwaHdgzrFehUB5BMMWbb7HdYZmo
 p5wFQlz6A3ggy8B+6t681TnB85YFAcYGfcVS+8fZTcACZJghBbeq0IoLcrYgj4rnVG+c
 hK+k2fAkfw5JTI6l9A4e6XCRaJdB77cnrTsQ096T1J0OOgKz93s9H6a777Rwl5V8v0RS OA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 396m0uj1ww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 15 Jun 2021 04:34:56 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 15 Jun
 2021 04:34:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 15 Jun 2021 04:34:54 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id A67253F7098;
        Tue, 15 Jun 2021 04:34:51 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 4/5] octeontx2-pf: Use NL_SET_ERR_MSG_MOD for TC
Date:   Tue, 15 Jun 2021 17:04:30 +0530
Message-ID: <1623756871-12524-5-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623756871-12524-1-git-send-email-sbhatta@marvell.com>
References: <1623756871-12524-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: -14jvSllO2ltwtSpDuvbv_mQ7k46xY5-
X-Proofpoint-ORIG-GUID: -14jvSllO2ltwtSpDuvbv_mQ7k46xY5-
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-15_04:2021-06-14,2021-06-15 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch modifies all netdev_err messages in
tc code to NL_SET_ERR_MSG_MOD. NL_SET_ERR_MSG_MOD
does not support format specifiers yet hence
netdev_err messages with only strings are modified.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   | 29 +++++++++++++---------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index af288e4..a46055f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -223,15 +223,17 @@ static int otx2_tc_egress_matchall_delete(struct otx2_nic *nic,
 
 static int otx2_tc_parse_actions(struct otx2_nic *nic,
 				 struct flow_action *flow_action,
-				 struct npc_install_flow_req *req)
+				 struct npc_install_flow_req *req,
+				 struct flow_cls_offload *f)
 {
+	struct netlink_ext_ack *extack = f->common.extack;
 	struct flow_action_entry *act;
 	struct net_device *target;
 	struct otx2_nic *priv;
 	int i;
 
 	if (!flow_action_has_entries(flow_action)) {
-		netdev_info(nic->netdev, "no tc actions specified");
+		NL_SET_ERR_MSG_MOD(extack, "no tc actions specified");
 		return -EINVAL;
 	}
 
@@ -248,8 +250,8 @@ static int otx2_tc_parse_actions(struct otx2_nic *nic,
 			priv = netdev_priv(target);
 			/* npc_install_flow_req doesn't support passing a target pcifunc */
 			if (rvu_get_pf(nic->pcifunc) != rvu_get_pf(priv->pcifunc)) {
-				netdev_info(nic->netdev,
-					    "can't redirect to other pf/vf\n");
+				NL_SET_ERR_MSG_MOD(extack,
+						   "can't redirect to other pf/vf");
 				return -EOPNOTSUPP;
 			}
 			req->vf = priv->pcifunc & RVU_PFVF_FUNC_MASK;
@@ -272,6 +274,7 @@ static int otx2_tc_prepare_flow(struct otx2_nic *nic,
 				struct flow_cls_offload *f,
 				struct npc_install_flow_req *req)
 {
+	struct netlink_ext_ack *extack = f->common.extack;
 	struct flow_msg *flow_spec = &req->packet;
 	struct flow_msg *flow_mask = &req->mask;
 	struct flow_dissector *dissector;
@@ -336,7 +339,7 @@ static int otx2_tc_prepare_flow(struct otx2_nic *nic,
 
 		flow_rule_match_eth_addrs(rule, &match);
 		if (!is_zero_ether_addr(match.mask->src)) {
-			netdev_err(nic->netdev, "src mac match not supported\n");
+			NL_SET_ERR_MSG_MOD(extack, "src mac match not supported");
 			return -EOPNOTSUPP;
 		}
 
@@ -354,11 +357,11 @@ static int otx2_tc_prepare_flow(struct otx2_nic *nic,
 		flow_rule_match_ip(rule, &match);
 		if ((ntohs(flow_spec->etype) != ETH_P_IP) &&
 		    match.mask->tos) {
-			netdev_err(nic->netdev, "tos not supported\n");
+			NL_SET_ERR_MSG_MOD(extack, "tos not supported");
 			return -EOPNOTSUPP;
 		}
 		if (match.mask->ttl) {
-			netdev_err(nic->netdev, "ttl not supported\n");
+			NL_SET_ERR_MSG_MOD(extack, "ttl not supported");
 			return -EOPNOTSUPP;
 		}
 		flow_spec->tos = match.key->tos;
@@ -414,8 +417,8 @@ static int otx2_tc_prepare_flow(struct otx2_nic *nic,
 
 		if (ipv6_addr_loopback(&match.key->dst) ||
 		    ipv6_addr_loopback(&match.key->src)) {
-			netdev_err(nic->netdev,
-				   "Flow matching on IPv6 loopback addr is not supported\n");
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Flow matching IPv6 loopback addr not supported");
 			return -EOPNOTSUPP;
 		}
 
@@ -464,7 +467,7 @@ static int otx2_tc_prepare_flow(struct otx2_nic *nic,
 			req->features |= BIT_ULL(NPC_SPORT_SCTP);
 	}
 
-	return otx2_tc_parse_actions(nic, &rule->action, req);
+	return otx2_tc_parse_actions(nic, &rule->action, req, f);
 }
 
 static int otx2_del_mcam_flow_entry(struct otx2_nic *nic, u16 entry)
@@ -525,6 +528,7 @@ static int otx2_tc_del_flow(struct otx2_nic *nic,
 static int otx2_tc_add_flow(struct otx2_nic *nic,
 			    struct flow_cls_offload *tc_flow_cmd)
 {
+	struct netlink_ext_ack *extack = tc_flow_cmd->common.extack;
 	struct otx2_tc_info *tc_info = &nic->tc_info;
 	struct otx2_tc_flow *new_node, *old_node;
 	struct npc_install_flow_req *req;
@@ -562,7 +566,8 @@ static int otx2_tc_add_flow(struct otx2_nic *nic,
 		otx2_tc_del_flow(nic, tc_flow_cmd);
 
 	if (bitmap_full(tc_info->tc_entries_bitmap, nic->flow_cfg->tc_max_flows)) {
-		netdev_err(nic->netdev, "Not enough MCAM space to add the flow\n");
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Not enough MCAM space to add the flow");
 		otx2_mbox_reset(&nic->mbox.mbox, 0);
 		mutex_unlock(&nic->mbox.lock);
 		return -ENOMEM;
@@ -580,7 +585,7 @@ static int otx2_tc_add_flow(struct otx2_nic *nic,
 	/* Send message to AF */
 	rc = otx2_sync_mbox_msg(&nic->mbox);
 	if (rc) {
-		netdev_err(nic->netdev, "Failed to install MCAM flow entry\n");
+		NL_SET_ERR_MSG_MOD(extack, "Failed to install MCAM flow entry");
 		mutex_unlock(&nic->mbox.lock);
 		goto out;
 	}
-- 
2.7.4

