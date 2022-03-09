Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5554D2FA6
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbiCINEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbiCINEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:04:09 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2076.outbound.protection.outlook.com [40.107.212.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A478B6928A
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 05:03:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IOkCJqyMFoIPl/L6XFXCVMk7nMjG2tiHJQQ2kJbker4u+B960Yyr68TNG4ivXe9r8cfOf0dCWwnu/lNC4oWbiwa13SEScq95TujY3TEjPyUU5OLW0uxfnM3NDq68l/qNugP5AkHiUCPczBHQBWZTnBcKwJbUVyu8bBKv1DWuxLcUnVKHcS+nCAa+Yricr9MvfEaey/3CjMnwfkfVG5UhdUvb3GIqkliUGXPHM5PfNmJFBjIHdHYuchRDemoYmuPdLXx6xP/xQdgwUhxrVLQM1Gr2zdafedyLfUnlMjneRji282IvPQj/TNHURPqc/zhncXROr84yIAxPeSaNYtgBTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VVFcc60432q5u0ays/+xZ/pJZPkkppZ9WseiR+5eCiA=;
 b=J/LTrw4gISv6Hgl0nay3JOGJQilqzJdBvZefBKgjjdfckAtrzBLLnhA+2oVktgOweYhmmOlyyxddvM2f+HpTj+moapHUhxeKgddfttJN1woNQCIOjw3l+rQmLatHzGEYxTmSijQaECdf38iUImgwxvds8HsxzPlyyikQX3qLm3Fh+I/rAh1/gYQaNRRtEk+ZhZLzqRVjTpbElv6KaEbH0aFi3xGvJIrCbS7sSajbm6tWVf7RQz+rBCy3A2PSKu85zqicE0EWKjNbHqGpmHDcBDb1w7qY0XeIDXFWfQRSujKuSXTytn5+RpM6JRo50SPSJ78XKFPgmRKXx0J4V5rQuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VVFcc60432q5u0ays/+xZ/pJZPkkppZ9WseiR+5eCiA=;
 b=NNBt8rcIfD7Tb8JciTB439rW1tIB5yamd37ohYau41bbahjUAVkpBw3vHh40vcZDcQ4/2Zk1oMNKPIM+zetK/NujOuiAIlHUuXRsNqZKNUlaRmiFUDt9zFwUac6rVAXf+FurkS4t0nXbOvd+Byac/Rus6/VHtuyhlIZareiNrZ5NW3LioTLOjJ5CnIl4nrkvHR0O4bpUhdH7cq4dt2Wc5JYPpI3PchL0d2+Jwx/DBHe5KRG9haG7aTWSoppsmVjdDUX766ONcgi2hQQ+Sab8ftnUMAja5a6H4zrKqeLoqqnWL0mBvLWgkBU5qiJD2B1F+tTBQLvK3JbO6MUTA74oDw==
Received: from BN0PR03CA0024.namprd03.prod.outlook.com (2603:10b6:408:e6::29)
 by DM5PR1201MB2491.namprd12.prod.outlook.com (2603:10b6:3:eb::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 13:03:08 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::26) by BN0PR03CA0024.outlook.office365.com
 (2603:10b6:408:e6::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Wed, 9 Mar 2022 13:03:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Wed, 9 Mar 2022 13:03:07 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 9 Mar
 2022 13:03:05 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 9 Mar 2022
 05:03:04 -0800
Received: from dev-r-vrt-138.mtr.labs.mlnx (10.127.8.10) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Wed, 9 Mar 2022 05:03:02 -0800
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 2/3] net/mlx5e: MPLSoUDP decap, use vlan push_eth instead of pedit
Date:   Wed, 9 Mar 2022 15:02:55 +0200
Message-ID: <20220309130256.1402040-3-roid@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309130256.1402040-1-roid@nvidia.com>
References: <20220309130256.1402040-1-roid@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e90c2f54-2965-420b-910c-08da01cd27fd
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2491:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB24918DF67C7D014021958045B80A9@DM5PR1201MB2491.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QR6dljOdJwWia63oieetbCQkGQKrxIvoVmEacj1PiitUMYCUaBgs/QP6B9eSWZjL3pFzTes6kgZKmYuQ0/L79gXIxzC1zYyV6a1rdqyQngEkAGLiOWxPvzQmK1IqXSJ+XtJhixUtRSoF+Pv3MwxyDoOIDLE6eYD+YMhWFuY2e23T6A8OajZL5zq+/Hu+/cfoQgfZNUjwSuXicgklQY/pOWQIte6EQ7XvqCDdU3B0Ly7CbvVb2wOB236mxSap8lP1rEewHaSno3An0Ecgsxs39uDJULTt4e1/da7JtsenaY/sCt/X4m6sAYlfZzQrmdK8xCRjJMoVwzb1LQVUmpB4R/5LwKMFujrQQllVD7Wi4HBjEzZNMCcoeDlhip0hgnpnq2n6I4e0CYB+gz2wr1H5uS1aS7RV5OEDe9dnTKoSA+7R8TaVhvcEvDRS28quwb3J0J8YNlfk8QKQg0T+NdIUdDovW2NtJszavWzPZ3/N/Bfg5r6PA7+fUB3vOOWmR9dgkT5UdQUmUbCJ0LXP+fWmYqUra85SOcu7W6hRc/4l954UW4EFeqSDfWtc2xnojnwuLDfEtChMlU7RvCjNoYzbmt97o6SuffRQlBK+Wgi7jFDgE0rDb6+ObtS6pxL8bzNRjBSeXKii7WFCqt9dHPPgR75d9gerEF/YSm4y+vn7yM2f94ZIPH38aqhFbq0dZ4G840fiUKeYnnvkGCeVR+TNOQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(2906002)(426003)(336012)(86362001)(40460700003)(26005)(186003)(316002)(54906003)(6916009)(1076003)(107886003)(2616005)(36860700001)(81166007)(82310400004)(356005)(83380400001)(70586007)(8676002)(4326008)(70206006)(508600001)(47076005)(30864003)(36756003)(5660300002)(8936002)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 13:03:07.1574
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e90c2f54-2965-420b-910c-08da01cd27fd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2491
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

Currently action pedit of source and destination MACs is used
to fill the MACs in L2 push step in MPLSoUDP decap offload,
this isn't aligned to tc SW which use vlan eth_push action
to do this.

To fix that, offload support for vlan veth_push action is
added together with mpls pop action, and deprecate the use
of pedit of MACs.

Flow example:
filter protocol mpls_uc pref 1 flower chain 0
filter protocol mpls_uc pref 1 flower chain 0 handle 0x1
  eth_type 8847
  mpls_label 555
  enc_dst_port 6635
  in_hw in_hw_count 1
        action order 1: tunnel_key  unset pipe
         index 2 ref 1 bind 1
        used_hw_stats delayed

        action order 2: mpls  pop protocol ip pipe
         index 2 ref 1 bind 1
        used_hw_stats delayed

        action order 3: vlan  push_eth dst_mac de:a2:ec:d6:69:c8 src_mac de:a2:ec:d6:69:c8 pipe
         index 2 ref 1 bind 1
        used_hw_stats delayed

        action order 4: mirred (Egress Redirect to device enp8s0f0_0) stolen
        index 2 ref 1 bind 1
        used_hw_stats delayed

Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/act/act.c        |  6 ++
 .../mellanox/mlx5/core/en/tc/act/act.h        |  1 +
 .../mellanox/mlx5/core/en/tc/act/mirred.c     |  5 ++
 .../mellanox/mlx5/core/en/tc/act/mpls.c       |  7 ++-
 .../mellanox/mlx5/core/en/tc/act/pedit.c      | 59 +++----------------
 .../mellanox/mlx5/core/en/tc/act/pedit.h      |  3 +-
 .../mellanox/mlx5/core/en/tc/act/vlan.c       | 16 +++--
 .../mlx5/core/en/tc/act/vlan_mangle.c         |  4 +-
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  |  1 -
 .../mellanox/mlx5/core/en/tc_tun_encap.c      | 10 ++--
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 11 files changed, 43 insertions(+), 70 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
index cb8f7593a00c..24403593b952 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
@@ -35,6 +35,12 @@ static struct mlx5e_tc_act *tc_acts_fdb[NUM_FLOW_ACTIONS] = {
 	NULL, /* FLOW_ACTION_CT_METADATA, */
 	&mlx5e_tc_act_mpls_push,
 	&mlx5e_tc_act_mpls_pop,
+	NULL, /* FLOW_ACTION_MPLS_MANGLE, */
+	NULL, /* FLOW_ACTION_GATE, */
+	NULL, /* FLOW_ACTION_PPPOE_PUSH, */
+	NULL, /* FLOW_ACTION_JUMP, */
+	NULL, /* FLOW_ACTION_PIPE, */
+	&mlx5e_tc_act_vlan,
 };
 
 /* Must be aligned with enum flow_action_id. */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index 94a7cf38d6b1..2616aee6ebf0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -22,6 +22,7 @@ struct mlx5e_tc_act_parse_state {
 	bool encap;
 	bool decap;
 	bool mpls_push;
+	bool eth_push;
 	bool ptype_host;
 	const struct ip_tunnel_info *tun_info;
 	struct mlx5e_mpls_info mpls_info;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
index 05a42fb4ba97..14cfa39d30f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
@@ -125,6 +125,11 @@ tc_act_can_offload_mirred(struct mlx5e_tc_act_parse_state *parse_state,
 		return false;
 	}
 
+	if (flow_flag_test(parse_state->flow, L3_TO_L2_DECAP) && !parse_state->eth_push) {
+		NL_SET_ERR_MSG_MOD(extack, "mpls pop is only supported with vlan eth push");
+		return false;
+	}
+
 	if (mlx5e_is_ft_flow(flow) && out_dev == priv->netdev) {
 		/* Ignore forward to self rules generated
 		 * by adding both mlx5 devs to the flow table
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mpls.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mpls.c
index 96a80e03d129..f106190bf37c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mpls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mpls.c
@@ -57,12 +57,13 @@ tc_act_can_offload_mpls_pop(struct mlx5e_tc_act_parse_state *parse_state,
 	filter_dev = attr->parse_attr->filter_dev;
 
 	/* we only support mpls pop if it is the first action
+	 * or it is second action after tunnel key unset
 	 * and the filter net device is bareudp. Subsequent
 	 * actions can be pedit and the last can be mirred
 	 * egress redirect.
 	 */
-	if (act_index) {
-		NL_SET_ERR_MSG_MOD(extack, "mpls pop supported only as first action");
+	if ((act_index == 1 && !parse_state->decap) || act_index > 1) {
+		NL_SET_ERR_MSG_MOD(extack, "mpls pop supported only as first action or with decap");
 		return false;
 	}
 
@@ -80,7 +81,7 @@ tc_act_parse_mpls_pop(struct mlx5e_tc_act_parse_state *parse_state,
 		      struct mlx5e_priv *priv,
 		      struct mlx5_flow_attr *attr)
 {
-	attr->parse_attr->eth.h_proto = act->mpls_pop.proto;
+	attr->esw_attr->eth.h_proto = act->mpls_pop.proto;
 	attr->action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
 	flow_flag_set(parse_state->flow, L3_TO_L2_DECAP);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.c
index 39f8f71bed9e..47597c524e59 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.c
@@ -42,13 +42,12 @@ set_pedit_val(u8 hdr_type, u32 mask, u32 val, u32 offset,
 	return -EOPNOTSUPP;
 }
 
-static int
-parse_pedit_to_modify_hdr(struct mlx5e_priv *priv,
-			  const struct flow_action_entry *act, int namespace,
-			  struct mlx5e_tc_flow_parse_attr *parse_attr,
-			  struct netlink_ext_ack *extack)
+int
+mlx5e_tc_act_pedit_parse_action(struct mlx5e_priv *priv,
+				const struct flow_action_entry *act, int namespace,
+				struct pedit_headers_action *hdrs,
+				struct netlink_ext_ack *extack)
 {
-	struct pedit_headers_action *hdrs = parse_attr->hdrs;
 	u8 cmd = (act->id == FLOW_ACTION_MANGLE) ? 0 : 1;
 	u8 htype = act->mangle.htype;
 	int err = -EOPNOTSUPP;
@@ -79,46 +78,6 @@ parse_pedit_to_modify_hdr(struct mlx5e_priv *priv,
 	return err;
 }
 
-static int
-parse_pedit_to_reformat(const struct flow_action_entry *act,
-			struct mlx5e_tc_flow_parse_attr *parse_attr,
-			struct netlink_ext_ack *extack)
-{
-	u32 mask, val, offset;
-	u32 *p;
-
-	if (act->id != FLOW_ACTION_MANGLE) {
-		NL_SET_ERR_MSG_MOD(extack, "Unsupported action id");
-		return -EOPNOTSUPP;
-	}
-
-	if (act->mangle.htype != FLOW_ACT_MANGLE_HDR_TYPE_ETH) {
-		NL_SET_ERR_MSG_MOD(extack, "Only Ethernet modification is supported");
-		return -EOPNOTSUPP;
-	}
-
-	mask = ~act->mangle.mask;
-	val = act->mangle.val;
-	offset = act->mangle.offset;
-	p = (u32 *)&parse_attr->eth;
-	*(p + (offset >> 2)) |= (val & mask);
-
-	return 0;
-}
-
-int
-mlx5e_tc_act_pedit_parse_action(struct mlx5e_priv *priv,
-				const struct flow_action_entry *act, int namespace,
-				struct mlx5e_tc_flow_parse_attr *parse_attr,
-				struct mlx5e_tc_flow *flow,
-				struct netlink_ext_ack *extack)
-{
-	if (flow && flow_flag_test(flow, L3_TO_L2_DECAP))
-		return parse_pedit_to_reformat(act, parse_attr, extack);
-
-	return parse_pedit_to_modify_hdr(priv, act, namespace, parse_attr, extack);
-}
-
 static bool
 tc_act_can_offload_pedit(struct mlx5e_tc_act_parse_state *parse_state,
 			 const struct flow_action_entry *act,
@@ -141,20 +100,16 @@ tc_act_parse_pedit(struct mlx5e_tc_act_parse_state *parse_state,
 
 	ns_type = mlx5e_get_flow_namespace(flow);
 
-	err = mlx5e_tc_act_pedit_parse_action(flow->priv, act, ns_type, attr->parse_attr,
-					      flow, parse_state->extack);
+	err = mlx5e_tc_act_pedit_parse_action(flow->priv, act, ns_type, attr->parse_attr->hdrs,
+					      parse_state->extack);
 	if (err)
 		return err;
 
-	if (flow_flag_test(flow, L3_TO_L2_DECAP))
-		goto out;
-
 	attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 
 	if (ns_type == MLX5_FLOW_NAMESPACE_FDB)
 		esw_attr->split_count = esw_attr->out_count;
 
-out:
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.h
index 258f030a2dc6..434c8bd710a2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.h
@@ -24,8 +24,7 @@ struct pedit_headers_action {
 int
 mlx5e_tc_act_pedit_parse_action(struct mlx5e_priv *priv,
 				const struct flow_action_entry *act, int namespace,
-				struct mlx5e_tc_flow_parse_attr *parse_attr,
-				struct mlx5e_tc_flow *flow,
+				struct pedit_headers_action *hdrs,
 				struct netlink_ext_ack *extack);
 
 #endif /* __MLX5_EN_TC_ACT_PEDIT_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
index 6378b7558ba2..b78e99ab60c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
@@ -34,7 +34,8 @@ parse_tc_vlan_action(struct mlx5e_priv *priv,
 		     const struct flow_action_entry *act,
 		     struct mlx5_esw_flow_attr *attr,
 		     u32 *action,
-		     struct netlink_ext_ack *extack)
+		     struct netlink_ext_ack *extack,
+		     struct mlx5e_tc_act_parse_state *parse_state)
 {
 	u8 vlan_idx = attr->total_vlan;
 
@@ -84,6 +85,13 @@ parse_tc_vlan_action(struct mlx5e_priv *priv,
 			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH;
 		}
 		break;
+	case FLOW_ACTION_VLAN_PUSH_ETH:
+		if (!flow_flag_test(parse_state->flow, L3_TO_L2_DECAP))
+			return -EOPNOTSUPP;
+		parse_state->eth_push = true;
+		memcpy(attr->eth.h_dest, act->vlan_push_eth_dst, ETH_ALEN);
+		memcpy(attr->eth.h_source, act->vlan_push_eth_src, ETH_ALEN);
+		break;
 	default:
 		NL_SET_ERR_MSG_MOD(extack, "Unexpected action id for VLAN");
 		return -EINVAL;
@@ -109,7 +117,7 @@ mlx5e_tc_act_vlan_add_push_action(struct mlx5e_priv *priv,
 	};
 	int err;
 
-	err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, &attr->action, extack);
+	err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, &attr->action, extack, NULL);
 	if (err)
 		return err;
 
@@ -139,7 +147,7 @@ mlx5e_tc_act_vlan_add_pop_action(struct mlx5e_priv *priv,
 						priv->netdev->lower_level;
 	while (nest_level--) {
 		err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, &attr->action,
-					   extack);
+					   extack, NULL);
 		if (err)
 			return err;
 	}
@@ -174,7 +182,7 @@ tc_act_parse_vlan(struct mlx5e_tc_act_parse_state *parse_state,
 							   parse_state->extack);
 	} else {
 		err = parse_tc_vlan_action(priv, act, esw_attr, &attr->action,
-					   parse_state->extack);
+					   parse_state->extack, parse_state);
 	}
 
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan_mangle.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan_mangle.c
index 28444d4ffd73..9a8a1a6bd99e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan_mangle.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan_mangle.c
@@ -43,8 +43,8 @@ mlx5e_tc_act_vlan_add_rewrite_action(struct mlx5e_priv *priv, int namespace,
 		return -EOPNOTSUPP;
 	}
 
-	err = mlx5e_tc_act_pedit_parse_action(priv, &pedit_act, namespace, parse_attr,
-					      NULL, extack);
+	err = mlx5e_tc_act_pedit_parse_action(priv, &pedit_act, namespace, parse_attr->hdrs,
+					      extack);
 	*action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 
 	return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index 03c953dacb09..3b74a6fd5c43 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -41,7 +41,6 @@ struct mlx5e_tc_flow_parse_attr {
 	struct pedit_headers_action hdrs[__PEDIT_CMD_MAX];
 	struct mlx5e_tc_mod_hdr_acts mod_hdr_acts;
 	int mirred_ifindex[MLX5_MAX_FLOW_FWD_VPORTS];
-	struct ethhdr eth;
 	struct mlx5e_tc_act_parse_state parse_state;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 5105c8018d37..5aff97914367 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -906,20 +906,18 @@ int mlx5e_attach_decap(struct mlx5e_priv *priv,
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5_esw_flow_attr *attr = flow->attr->esw_attr;
 	struct mlx5_pkt_reformat_params reformat_params;
-	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5e_decap_entry *d;
 	struct mlx5e_decap_key key;
 	uintptr_t hash_key;
 	int err = 0;
 
-	parse_attr = flow->attr->parse_attr;
-	if (sizeof(parse_attr->eth) > MLX5_CAP_ESW(priv->mdev, max_encap_header_size)) {
+	if (sizeof(attr->eth) > MLX5_CAP_ESW(priv->mdev, max_encap_header_size)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "encap header larger than max supported");
 		return -EOPNOTSUPP;
 	}
 
-	key.key = parse_attr->eth;
+	key.key = attr->eth;
 	hash_key = hash_decap_info(&key);
 	mutex_lock(&esw->offloads.decap_tbl_lock);
 	d = mlx5e_decap_get(priv, &key, hash_key);
@@ -949,8 +947,8 @@ int mlx5e_attach_decap(struct mlx5e_priv *priv,
 
 	memset(&reformat_params, 0, sizeof(reformat_params));
 	reformat_params.type = MLX5_REFORMAT_TYPE_L3_TUNNEL_TO_L2;
-	reformat_params.size = sizeof(parse_attr->eth);
-	reformat_params.data = &parse_attr->eth;
+	reformat_params.size = sizeof(attr->eth);
+	reformat_params.data = &attr->eth;
 	d->pkt_reformat = mlx5_packet_reformat_alloc(priv->mdev,
 						     &reformat_params,
 						     MLX5_FLOW_NAMESPACE_FDB);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 973281bdb4a2..bac5160837c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -474,6 +474,7 @@ struct mlx5_esw_flow_attr {
 		int src_port_rewrite_act_id;
 	} dests[MLX5_MAX_FLOW_FWD_VPORTS];
 	struct mlx5_rx_tun_attr *rx_tun_attr;
+	struct ethhdr eth;
 	struct mlx5_pkt_reformat *decap_pkt_reformat;
 };
 
-- 
2.34.1

