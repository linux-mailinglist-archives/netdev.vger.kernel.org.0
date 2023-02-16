Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E6D698F30
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 09:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjBPI7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 03:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjBPI7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 03:59:04 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2088.outbound.protection.outlook.com [40.107.243.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F109C474FA
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 00:58:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKfTXl1qd/OSIBK8kdmsrRFPqC6v6PX46YzSOtl07izgyeol1DhKiBhXZydxjLPRBn3XV/vFgbuovtNxdL8Q+1osxCoyC1tF0fkmWGEHBAsBv5fcKVIyZsTDa/jLrEob5mJ/STw5WYa9eXhFO4HmBQdEskxrM9S2tYOLWU8kpFpsKhzsFmoaU+k+dYclF3e0Zz2FyTwjoStuaIjxlChp6TB1URJEkevPSr4M2MXGAyJOSNutIvGcuovW5gfxw+N5TdPg0ehgxnA9CQlqcjUAWCh3DXRy131fahUsTy9QKXCpq5Ireb5qqo2i5J9me9sB14CZQezTvG24A63ALwT57w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vTbndpUbJlRmLpbe+G1Wd2YHrvj0WzUSry2f6gNplqg=;
 b=E0nYmTTZrSLGkV+p3n26STC7KhrZRK7qdtMlDyMbK/W2yRvw2iEbGRwZWM58dl/PGOw17Y3kpTs03OAAltZWTq0PmvkPcox3CeGTc/ZnxAYpbGyi3R8JmwwLRGMfAkpszJD/1Fm1A6Qx2N7EvSafPdUpcLqelXP57q3rs+2Gq1+kIoSlyrLhq4EWqGrLOpHpNvNsIUgSH2ouG+8SGC4HXBwoGaY5F9KQh51WZ7yuOPfzfRY77B1JuTKVitOKfacWwPuspov5U500HKCaNpW4zxSV2Osp5MTN0Yj/mbimwK3vtl0VAWoChDC/l4R1/N06nx0YoeTmng/XQuO6YTrszg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTbndpUbJlRmLpbe+G1Wd2YHrvj0WzUSry2f6gNplqg=;
 b=lQ86+MjHM0hrcwNmQ6LFmyhrfZ21FYy7shu86Qt+XEEw5yt3gGG0MG7LW/m+WOJLIwfA3L8ReSsN1HgbWNQZt4I2wc0CiGDEN+l3fyQRNR3sVQGuDF4stI+wKKwpyXATZjlLUTl7B0/AjgxNzVEO1vueQFmDgtwmYzU7p4kMZUlWsg0q9zHCwklybOTIgtDrtt3y0qRFBCRdz7TxPWnNe6aeYG8232E1MVreQvziqyGglukGzGjzfsazGnmypP1WyDlNIZuac98PfjZkQ1jTKMWe/nqnTyP5KYs82gApwT7zjU1yhEwGC/yiEbzFAywyNjjpqOtjs4NmG4n3MibfZg==
Received: from MW4PR03CA0270.namprd03.prod.outlook.com (2603:10b6:303:b4::35)
 by SA0PR12MB4349.namprd12.prod.outlook.com (2603:10b6:806:98::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 08:58:49 +0000
Received: from CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b4:cafe::c4) by MW4PR03CA0270.outlook.office365.com
 (2603:10b6:303:b4::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Thu, 16 Feb 2023 08:58:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT011.mail.protection.outlook.com (10.13.175.186) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.13 via Frontend Transport; Thu, 16 Feb 2023 08:58:48 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 00:58:34 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 00:58:34 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Thu, 16 Feb 2023 00:58:30 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v12 8/8] net/mlx5e: TC, Set CT miss to the specific ct action instance
Date:   Thu, 16 Feb 2023 10:57:53 +0200
Message-ID: <20230216085753.2177-9-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230216085753.2177-1-paulb@nvidia.com>
References: <20230216085753.2177-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT011:EE_|SA0PR12MB4349:EE_
X-MS-Office365-Filtering-Correlation-Id: 52089adc-e9e5-40f2-8687-08db0ffc048c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DtBuBbI/YORt2T+hwmZCvfVXOxCFoO1RPfNQqidHbphKJasZQaVCjs9X3PYfYKF5tcdi+9sJGXkIQTq1maNtdmX7D4BBqgYY39VyTY2E/CTMHzBu6gpjVfUCN8xAMgWrBdGYz1BipuXKBPF4+aOZKNb3c4ykh4mdu0n7/8zWJbvcAXYDqVBzZWT3RtIIjX8C0jgdXOv8K5f7pDND/7u31BRUEhAbu/UXq68Cu4L+3AA5CRpKJ3jOm9ZBXV4j04U83Pv3zpVq8hJ1ncXhRSPnjemRzPUmSIqxTdSwGLfmmIjFz9x8m5I58TzKl7jfh572wQbSq0cmz+kuyCVRA+cqstSiBcJMxTLxDRSaGTdyyEwWVbP7g3tBrVz4nVkym9dGQzQvJ7FngfGio2y/xSB2i7JbBkRiOqyJcIlugqTh+irEFhdc6I3BSOosjCyal1ge8BCz3eCea/9eV1mAt2QpmDW5YVkXlzqLqYJ9Dao9UMRIcWl7TIpdG4GsmwX8Zz7PDGl+PRe2HAWBagGtH4/nSKysWFMz3jlBoOcL0Iyh5d7Xu0QRYfKjRISmgV9aMjzJTExHVj3Hu1btkwgIXiOcm+nh3DKmmCLhJgN0+naxU2CkCzSsrt09up5/j0Z1LWWQu7OpVbJlg/KLcfrkRb79mPtUwulYHnDOEeHIa4h/esZ+dd/ROIXLjDrJeoRZrdh6na41tGAqBIkPWqAd4Zj7cxyvXoFpzjYI4q5MtlkCxrw=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(136003)(376002)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(54906003)(5660300002)(110136005)(41300700001)(66899018)(70206006)(8676002)(8936002)(316002)(70586007)(30864003)(4326008)(2906002)(478600001)(186003)(26005)(6666004)(107886003)(1076003)(2616005)(40460700003)(336012)(36756003)(83380400001)(40480700001)(426003)(47076005)(921005)(7636003)(82310400005)(36860700001)(356005)(82740400003)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 08:58:48.4457
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52089adc-e9e5-40f2-8687-08db0ffc048c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4349
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, CT misses restore the missed chain on the tc skb extension so
tc will continue from the relevant chain. Instead, restore the CT action's
miss cookie on the extension, which will instruct tc to continue from the
this specific CT action instance on the relevant filter's action list.

Map the CT action's miss_cookie to a new miss object (ACT_MISS), and use
this miss mapping instead of the current chain miss object (CHAIN_MISS)
for CT action misses.

To restore this new miss mapping value, add a RX restore rule for each
such mapping value.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Sholmo <ozsh@nvidia.com>
Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 32 +++++-----
 .../ethernet/mellanox/mlx5/core/en/tc_ct.h    |  2 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 64 +++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  6 ++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  2 +
 5 files changed, 82 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index de751d084770..5c58ec279b10 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -59,6 +59,7 @@ struct mlx5_tc_ct_debugfs {
 
 struct mlx5_tc_ct_priv {
 	struct mlx5_core_dev *dev;
+	struct mlx5e_priv *priv;
 	const struct net_device *netdev;
 	struct mod_hdr_tbl *mod_hdr_tbl;
 	struct xarray tuple_ids;
@@ -85,7 +86,6 @@ struct mlx5_ct_flow {
 	struct mlx5_flow_attr *pre_ct_attr;
 	struct mlx5_flow_handle *pre_ct_rule;
 	struct mlx5_ct_ft *ft;
-	u32 chain_mapping;
 };
 
 struct mlx5_ct_zone_rule {
@@ -1445,6 +1445,7 @@ mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 	attr->ct_attr.zone = act->ct.zone;
 	attr->ct_attr.ct_action = act->ct.action;
 	attr->ct_attr.nf_ft = act->ct.flow_table;
+	attr->ct_attr.act_miss_cookie = act->miss_cookie;
 
 	return 0;
 }
@@ -1782,7 +1783,7 @@ mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_ft *ft)
  *	+ ft prio (tc chain)  +
  *	+ original match      +
  *	+---------------------+
- *		 | set chain miss mapping
+ *		 | set act_miss_cookie mapping
  *		 | set fte_id
  *		 | set tunnel_id
  *		 | do decap
@@ -1827,7 +1828,7 @@ __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
 	struct mlx5_flow_attr *pre_ct_attr;
 	struct mlx5_modify_hdr *mod_hdr;
 	struct mlx5_ct_flow *ct_flow;
-	int chain_mapping = 0, err;
+	int act_miss_mapping = 0, err;
 	struct mlx5_ct_ft *ft;
 	u16 zone;
 
@@ -1862,22 +1863,18 @@ __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
 	pre_ct_attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
 			       MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 
-	/* Write chain miss tag for miss in ct table as we
-	 * don't go though all prios of this chain as normal tc rules
-	 * miss.
-	 */
-	err = mlx5_chains_get_chain_mapping(ct_priv->chains, attr->chain,
-					    &chain_mapping);
+	err = mlx5e_tc_action_miss_mapping_get(ct_priv->priv, attr, attr->ct_attr.act_miss_cookie,
+					       &act_miss_mapping);
 	if (err) {
-		ct_dbg("Failed to get chain register mapping for chain");
-		goto err_get_chain;
+		ct_dbg("Failed to get register mapping for act miss");
+		goto err_get_act_miss;
 	}
-	ct_flow->chain_mapping = chain_mapping;
+	attr->ct_attr.act_miss_mapping = act_miss_mapping;
 
 	err = mlx5e_tc_match_to_reg_set(priv->mdev, pre_mod_acts, ct_priv->ns_type,
-					MAPPED_OBJ_TO_REG, chain_mapping);
+					MAPPED_OBJ_TO_REG, act_miss_mapping);
 	if (err) {
-		ct_dbg("Failed to set chain register mapping");
+		ct_dbg("Failed to set act miss register mapping");
 		goto err_mapping;
 	}
 
@@ -1941,8 +1938,8 @@ __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
 	mlx5_modify_header_dealloc(priv->mdev, pre_ct_attr->modify_hdr);
 err_mapping:
 	mlx5e_mod_hdr_dealloc(pre_mod_acts);
-	mlx5_chains_put_chain_mapping(ct_priv->chains, ct_flow->chain_mapping);
-err_get_chain:
+	mlx5e_tc_action_miss_mapping_put(ct_priv->priv, attr, act_miss_mapping);
+err_get_act_miss:
 	kfree(ct_flow->pre_ct_attr);
 err_alloc_pre:
 	mlx5_tc_ct_del_ft_cb(ct_priv, ft);
@@ -1981,7 +1978,7 @@ __mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *ct_priv,
 	mlx5_tc_rule_delete(priv, ct_flow->pre_ct_rule, pre_ct_attr);
 	mlx5_modify_header_dealloc(priv->mdev, pre_ct_attr->modify_hdr);
 
-	mlx5_chains_put_chain_mapping(ct_priv->chains, ct_flow->chain_mapping);
+	mlx5e_tc_action_miss_mapping_put(ct_priv->priv, attr, attr->ct_attr.act_miss_mapping);
 	mlx5_tc_ct_del_ft_cb(ct_priv, ct_flow->ft);
 
 	kfree(ct_flow->pre_ct_attr);
@@ -2154,6 +2151,7 @@ mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
 	}
 
 	spin_lock_init(&ct_priv->ht_lock);
+	ct_priv->priv = priv;
 	ct_priv->ns_type = ns_type;
 	ct_priv->chains = chains;
 	ct_priv->netdev = priv->netdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index 5bbd6b92840f..5c5ddaa83055 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -28,6 +28,8 @@ struct mlx5_ct_attr {
 	struct mlx5_ct_flow *ct_flow;
 	struct nf_flowtable *nf_ft;
 	u32 ct_labels_id;
+	u32 act_miss_mapping;
+	u64 act_miss_cookie;
 };
 
 #define zone_to_reg_ct {\
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index cd16cdddf2ef..b26bca3874db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3820,6 +3820,7 @@ mlx5e_clone_flow_attr_for_post_act(struct mlx5_flow_attr *attr,
 	attr2->parse_attr = parse_attr;
 	attr2->dest_chain = 0;
 	attr2->dest_ft = NULL;
+	attr2->act_id_restore_rule = NULL;
 
 	if (ns_type == MLX5_FLOW_NAMESPACE_FDB) {
 		attr2->esw_attr->out_count = 0;
@@ -5713,14 +5714,19 @@ static bool mlx5e_tc_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb
 	return true;
 }
 
-static bool mlx5e_tc_restore_skb_chain(struct sk_buff *skb, struct mlx5_tc_ct_priv *ct_priv,
-				       u32 chain, u32 zone_restore_id,
-				       u32 tunnel_id,  struct mlx5e_tc_update_priv *tc_priv)
+static bool mlx5e_tc_restore_skb_tc_meta(struct sk_buff *skb, struct mlx5_tc_ct_priv *ct_priv,
+					 struct mlx5_mapped_obj *mapped_obj, u32 zone_restore_id,
+					 u32 tunnel_id,  struct mlx5e_tc_update_priv *tc_priv)
 {
 	struct mlx5e_priv *priv = netdev_priv(skb->dev);
 	struct tc_skb_ext *tc_skb_ext;
+	u64 act_miss_cookie;
+	u32 chain;
 
-	if (chain) {
+	chain = mapped_obj->type == MLX5_MAPPED_OBJ_CHAIN ? mapped_obj->chain : 0;
+	act_miss_cookie = mapped_obj->type == MLX5_MAPPED_OBJ_ACT_MISS ?
+			  mapped_obj->act_miss_cookie : 0;
+	if (chain || act_miss_cookie) {
 		if (!mlx5e_tc_ct_restore_flow(ct_priv, skb, zone_restore_id))
 			return false;
 
@@ -5730,7 +5736,12 @@ static bool mlx5e_tc_restore_skb_chain(struct sk_buff *skb, struct mlx5_tc_ct_pr
 			return false;
 		}
 
-		tc_skb_ext->chain = chain;
+		if (act_miss_cookie) {
+			tc_skb_ext->act_miss_cookie = act_miss_cookie;
+			tc_skb_ext->act_miss = 1;
+		} else {
+			tc_skb_ext->chain = chain;
+		}
 	}
 
 	if (tc_priv)
@@ -5800,8 +5811,9 @@ bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe, struct sk_buff *skb,
 
 	switch (mapped_obj.type) {
 	case MLX5_MAPPED_OBJ_CHAIN:
-		return mlx5e_tc_restore_skb_chain(skb, ct_priv, mapped_obj.chain, zone_restore_id,
-						  tunnel_id, tc_priv);
+	case MLX5_MAPPED_OBJ_ACT_MISS:
+		return mlx5e_tc_restore_skb_tc_meta(skb, ct_priv, &mapped_obj, zone_restore_id,
+						    tunnel_id, tc_priv);
 	case MLX5_MAPPED_OBJ_SAMPLE:
 		mlx5e_tc_restore_skb_sample(priv, skb, &mapped_obj, tc_priv);
 		tc_priv->skb_done = true;
@@ -5835,3 +5847,41 @@ bool mlx5e_tc_update_skb_nic(struct mlx5_cqe64 *cqe, struct sk_buff *skb)
 	return mlx5e_tc_update_skb(cqe, skb, mapping_ctx, mapped_obj_id, ct_priv, zone_restore_id,
 				   0, NULL);
 }
+
+int mlx5e_tc_action_miss_mapping_get(struct mlx5e_priv *priv, struct mlx5_flow_attr *attr,
+				     u64 act_miss_cookie, u32 *act_miss_mapping)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5_mapped_obj mapped_obj = {};
+	struct mapping_ctx *ctx;
+	int err;
+
+	ctx = esw->offloads.reg_c0_obj_pool;
+
+	mapped_obj.type = MLX5_MAPPED_OBJ_ACT_MISS;
+	mapped_obj.act_miss_cookie = act_miss_cookie;
+	err = mapping_add(ctx, &mapped_obj, act_miss_mapping);
+	if (err)
+		return err;
+
+	attr->act_id_restore_rule = esw_add_restore_rule(esw, *act_miss_mapping);
+	if (IS_ERR(attr->act_id_restore_rule))
+		goto err_rule;
+
+	return 0;
+
+err_rule:
+	mapping_remove(ctx, *act_miss_mapping);
+	return err;
+}
+
+void mlx5e_tc_action_miss_mapping_put(struct mlx5e_priv *priv, struct mlx5_flow_attr *attr,
+				      u32 act_miss_mapping)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mapping_ctx *ctx;
+
+	ctx = esw->offloads.reg_c0_obj_pool;
+	mlx5_del_flow_rules(attr->act_id_restore_rule);
+	mapping_remove(ctx, act_miss_mapping);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index dc6ec18de708..48d3319d0b19 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -103,6 +103,7 @@ struct mlx5_flow_attr {
 	struct mlx5_flow_attr *branch_true;
 	struct mlx5_flow_attr *branch_false;
 	struct mlx5_flow_attr *jumping_attr;
+	struct mlx5_flow_handle *act_id_restore_rule;
 	/* keep this union last */
 	union {
 		DECLARE_FLEX_ARRAY(struct mlx5_esw_flow_attr, esw_attr);
@@ -406,4 +407,9 @@ mlx5e_tc_update_skb_nic(struct mlx5_cqe64 *cqe, struct sk_buff *skb)
 { return true; }
 #endif
 
+int mlx5e_tc_action_miss_mapping_get(struct mlx5e_priv *priv, struct mlx5_flow_attr *attr,
+				     u64 act_miss_cookie, u32 *act_miss_mapping);
+void mlx5e_tc_action_miss_mapping_put(struct mlx5e_priv *priv, struct mlx5_flow_attr *attr,
+				      u32 act_miss_mapping);
+
 #endif /* __MLX5_EN_TC_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index fd03f076551b..19e9a77c4633 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -52,12 +52,14 @@ enum mlx5_mapped_obj_type {
 	MLX5_MAPPED_OBJ_CHAIN,
 	MLX5_MAPPED_OBJ_SAMPLE,
 	MLX5_MAPPED_OBJ_INT_PORT_METADATA,
+	MLX5_MAPPED_OBJ_ACT_MISS,
 };
 
 struct mlx5_mapped_obj {
 	enum mlx5_mapped_obj_type type;
 	union {
 		u32 chain;
+		u64 act_miss_cookie;
 		struct {
 			u32 group_id;
 			u32 rate;
-- 
2.30.1

