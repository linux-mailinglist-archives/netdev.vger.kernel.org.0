Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9D35197D1
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 09:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345192AbiEDHHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 03:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345199AbiEDHHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 03:07:13 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2081.outbound.protection.outlook.com [40.107.100.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F086222B30
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 00:03:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mm6Y6PCEqeNoa+mc3JhJxWrtRp0uqLAtySIGPp+9B4lBhzRcELdbuw/SkeDYYkpRW/Nw0LA9u+VPKOQxBwLnFCXABt4OYu9hAZZ0loyQ6SJhI2uZexFWIuvcLLdy6f2Q4z5m1/qgOkdgZkCDngasDkJH7ZFrbwDbYUdg1bViRzH9YCemrP3o9jNKuixVJEGmh93lu9/pL3+PnUZY6XvkldfrfuyeLoS+FHMADQJKkIWmTF6amtaDrKzvxmixlVbirCjmTbPoEmcuxnYtMIw6fKsfKYwMl2ZoCNOJWRill50rp/YI7kn2IGXH2SK+iBbybjCGz9QCAIlCOxt+fSOtCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=txD2HR4bLEvfrDFDRzWO27G2EgIdtuZSHMdDKWwTxQA=;
 b=fFeXuSiC/+kMXyzbQo95gP87IRTgnlhcZdizafqWcb9/ybdxhDnt8nBAGYBuqjjoCuLp+awzUqwcO/BQwd2SRAJcsDoRAY0FuSZaOW/+zdiQx80o2OZtVQiNtilbemgbm/temVv1ODhKbQz8C0IyEPU3bNReqvsUiW7m02HjgtkOmZtfgMtPZxm2Eyl/3FJR+rlmbfrL2zZnzFK8D4LRTiJBCio5bwKJqeXuP32DEmvmmhSK48GTRRXWHPxoZYSOOH+d6Wr5cgovoBNBC1fWbakZmDp4jItHe24cuEDaB2Ug1BxziIr2xEdmWUqsgGXxQ5f02KLiOFgiX5LHA5+KIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=txD2HR4bLEvfrDFDRzWO27G2EgIdtuZSHMdDKWwTxQA=;
 b=tG3BQrPJ+AdnMDmtz3Itql07EKRHMjHIew5NU37UGyOfwkNDSAJ/+qZrQmuGLSb2L7pc1iMdoqLzBSf96AfD5q98NizFESwqDQn0EYYfJO2qjLraH2ut2IirJweuylqBAxiwwKOcYU2/yXLYEtWsPZLW1fXdF6k9Uevexj9hfACu3dVUQjWb/Mphn3gBBB9a71fz4aj9dNlLnp3mg4+7VKVkeWJwu4pzKWyVanaJh7gSCq2OoOCqGpTMF6eF1gDGjn739MYBaak8sSS54ydDVIKLnyntQisvmAmc1yEewiO94RAp9cPNkQhIpqD6zGAWX59XSj29AFYSPFk11G3Mkw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by MN2PR12MB4503.namprd12.prod.outlook.com (2603:10b6:208:264::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 07:03:21 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 07:03:20 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Ariel Levkovich <lariel@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 08/15] net/mlx5e: TC, Fix ct_clear overwriting ct action metadata
Date:   Wed,  4 May 2022 00:02:49 -0700
Message-Id: <20220504070256.694458-9-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504070256.694458-1-saeedm@nvidia.com>
References: <20220504070256.694458-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0018.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::23) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 008d5fef-bcb0-4cd6-ee26-08da2d9c2c4a
X-MS-TrafficTypeDiagnostic: MN2PR12MB4503:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB450350FE22E524C7D776ACD9B3C39@MN2PR12MB4503.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o4Zw3McJFvYY09M7JBttNrUrsqTaxo75ZbY6oYnuG4Q0ZBwlE4xlbRoD6c7Owgyb1LcfEvmu+o1b6gC24USmL1p5pMrVlzkNyE7Uxixb76YLFA2ClSkxqYwnxuyXPnb6P3dlpg0JiZ4yJhhOi/eaHRXC4FaLKgoteQwYJMnmKLQVejhjdf5e4wMnukQ7ok+NAqnfjSdQE4HoI4Q88qqhh6XWiAZlwpoT4b8LbIe+kJYif3+GQnYcxynCVaQoFfODjWJqpSvpnrsCcVaMyGJX7j8TVjsbV3xHnGuImf8W01Ctde7P8125wU/2FHgdJjPE28xEVs3DvNNV3vpoCiO6TIDlq3Wjb9+WcEwINgY/ghtigrvIHPFCLTJMYHPLTbPqhsSNTLCc4KL51yglA3vMcaf7zAAK1B+LRIIjQSG5pVlRhF3zZiuzftv1Jm+Bia+BMtsRVGieexKF+3oMKvjR67GYUkRas6gVn7aCSOb/HlSrIinCrgiFN57cAKvmzUi2i+TuzBRyHDefJDtEzJuTZQ/WzkjOJG/kl0GzK7pHuVEKPoWgV3QF15X/D/UutfYUXQgmAnmigXY4xBicmi6RJaAKEgU0DShh0Lqy1qZVjLQKAbd34y8H/AXxCplhoVSuv3cWiWqfF2wsiiVUgxpblQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(107886003)(6506007)(2906002)(36756003)(8676002)(508600001)(6486002)(38100700002)(66946007)(4326008)(6512007)(66556008)(66476007)(86362001)(8936002)(316002)(5660300002)(186003)(54906003)(1076003)(110136005)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7IKenUf/STFNMavTnwmmt5Mk7qDdWJe/yc2Xw2ZDWS5jdqWov4RM2QDw+hp5?=
 =?us-ascii?Q?5O5xd7ZDD+KzRr/wGPz5Ppz3111EvlUxjI7gpBWqVAEl2r7c1TJYf+UFHUTC?=
 =?us-ascii?Q?R4wKY3Kl6bSoorQLNaQQ6CIaSdXto/L/6rgNMuo6b7KfwTrsmYIEcITZOihK?=
 =?us-ascii?Q?DwKvQ9g/xsl62f9Vr33y3clmo5p5kQlUUDXdZlNulf+0i9iPr33mbXkeaVUv?=
 =?us-ascii?Q?63qqOCYQe879zZOFvK5fYxGvOSGIaf3pCTJcv70YQlED0HEp3o6mPF4C/xh5?=
 =?us-ascii?Q?8ggtX1c0yPt7i5OwknpLLrK45IBvsG0rO/8fkiSMwZ5CUJU8eTNnbKFcuiTY?=
 =?us-ascii?Q?TcMBIhy9YwbCzMsXW/w/Moypj+a/+bBOwiDKvYzQwihc8kjvQmFMrXFcx3IS?=
 =?us-ascii?Q?CqYP/FZfMiF3bKW7A5dMK5NvXs4aRYCpE8oAePVxeBRexPhiHZzDxJMKJbek?=
 =?us-ascii?Q?ND8A+G+47oKIr7Q6izB2BXkoDjqd7nHW0GphvLmLE1YLjdwxK32eck4KF+zI?=
 =?us-ascii?Q?uu0ebNsR2ejimKfWfaMjAqGUNzetapstNl/8ho4qYgMItAXB89df6kry/2Es?=
 =?us-ascii?Q?B91UurCB5ru2F9phH1rfy+fD3nUmVgpXabgxsKNDypjBqylIM+45bzzEo6Kp?=
 =?us-ascii?Q?qf3SCimdRmOpvQVXgV5o7mRuNq/F7IZsRMwOwHgeXhJhqnCXB85LsWurHWJ8?=
 =?us-ascii?Q?IvZNZjj6QwWNEfXW6kjBsK5L4I8I8BhjH+aY7JoOX6GJzkGnDPgogRQ4DuXJ?=
 =?us-ascii?Q?nZ9J6Vjf9b/7f3OgonjOpvXC5/8oXSX1lNEgnIcuiXR2R/Be3MJDzF3KWduD?=
 =?us-ascii?Q?Ln3A8uThjrArzTBe9euO7Wp924N06YKJfVhwu0mZbLtqeDcMBzRvXNliLwvf?=
 =?us-ascii?Q?AJgldFmYpV1QMQe0zsheu0GXB5SV6MpEokDwvzv+oqO70ZVrmpkxNrbKeQ7S?=
 =?us-ascii?Q?YMWuexGlALkmoPhl0fxrdDautrcP7aDLC6yF1aoQlSGqL6yjYjAhB7OALQmr?=
 =?us-ascii?Q?/Lq2LlLsyJ0kyN59NxVORmoqFZWBWpZJRcKmioqJG/hxRrPDYTAxKeaJiUUn?=
 =?us-ascii?Q?IZB/IvMNvOWzQ+RyylL4s+t5Jd+TsN0ZzIz0dGPay1Nr2pw5y4GOmgzDmXci?=
 =?us-ascii?Q?Rlx4ZUJohxBkfsrum1YcrdbbTznnH2Wt26TLTyFXdjHTWOXMTt8CoQKMMYUK?=
 =?us-ascii?Q?gRUvGWnrOdbS8v4XfXcELX7q8YqeTUCO3SxN1wB/jwyNVlSqHfyZICwhPkKh?=
 =?us-ascii?Q?A7MS82oRww8iI5aDR2kFo9vMvNISlm8vjkL1pN2g4tQaF7S1H0pSsVaqsukU?=
 =?us-ascii?Q?O0KbgjOZ9MQNlNV08Ed8F+5oia7xfi4kl7ekSThBT5NPmDII4XJHjy4dS4ee?=
 =?us-ascii?Q?P6/hkWanyYHKEeFzgI4uMlaxkA1JPJLaGMJpce1c21E4PUxUwElTAdvzqP37?=
 =?us-ascii?Q?TJ1xylBOZc56mbbP9q/SkNrxktSixB//pmzT4N5SgyjRBO5yDYR1pEZdliNV?=
 =?us-ascii?Q?HSjGVNS5CsrJiEEqIiIpNNAYDc/6Mlq9YmCvvwpx/l5er/UTDDOR0W5tYXd1?=
 =?us-ascii?Q?GtDS0//je39Zv8nzSpgwdEwcKFP5+bYFR9y19Zx9ysn7UZkWJDSGPt3FKUrt?=
 =?us-ascii?Q?xNHaOWXLjvJdCYUpKQN4mhcXXii/+mKp7cGfxvBmSvIPuoumVqSaFbsAHRdy?=
 =?us-ascii?Q?L4WnOXSRX6n5PHb1Mei2flhD1YRzmuT0fC2mOoLlNfLIsN91pMQ7SuLjgZCs?=
 =?us-ascii?Q?BvYCjNzj8ijYdHQt6UFQru+IApf6atrIWBVemH2NtYCg4iFrZFSU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 008d5fef-bcb0-4cd6-ee26-08da2d9c2c4a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:03:20.8852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 118RzRYmssqeniFOdikQcyiFV5032bL7hs+FSIs+PqtIrCXZ87p9ODHRtutTgqpHTw4NNscYReJnInUbwnSOrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4503
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

ct_clear action is translated to clearing reg_c metadata
which holds ct state and zone information using mod header
actions.
These actions are allocated during the actions parsing, as
part of the flow attributes main mod header action list.

If ct action exists in the rule, the flow's main mod header
is used only in the post action table rule, after the ct tables
which set the ct info in the reg_c as part of the ct actions.

Therefore, if the original rule has a ct_clear action followed
by a ct action, the ct action reg_c setting will be done first and
will be followed by the ct_clear resetting reg_c and overwriting
the ct info.

Fix this by moving the ct_clear mod header actions allocation from
the ct action parsing stage to the ct action post parsing stage where
it is already known if ct_clear is followed by a ct action.
In such case, we skip the mod header actions allocation for the ct
clear since the ct action will write to reg_c anyway after clearing it.

Fixes: 806401c20a0f ("net/mlx5e: CT, Fix multiple allocations and memleak of mod acts")
Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/act/ct.c         | 34 +++++++++++++++++--
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 20 ++++-------
 .../ethernet/mellanox/mlx5/core/en/tc_ct.h    | 11 ++++++
 3 files changed, 49 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
index b9d38fe807df..a829c94289c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
@@ -45,12 +45,41 @@ tc_act_parse_ct(struct mlx5e_tc_act_parse_state *parse_state,
 	if (mlx5e_is_eswitch_flow(parse_state->flow))
 		attr->esw_attr->split_count = attr->esw_attr->out_count;
 
-	if (!clear_action) {
+	if (clear_action) {
+		parse_state->ct_clear = true;
+	} else {
 		attr->flags |= MLX5_ATTR_FLAG_CT;
 		flow_flag_set(parse_state->flow, CT);
 		parse_state->ct = true;
 	}
-	parse_state->ct_clear = clear_action;
+
+	return 0;
+}
+
+static int
+tc_act_post_parse_ct(struct mlx5e_tc_act_parse_state *parse_state,
+		     struct mlx5e_priv *priv,
+		     struct mlx5_flow_attr *attr)
+{
+	struct mlx5e_tc_mod_hdr_acts *mod_acts = &attr->parse_attr->mod_hdr_acts;
+	int err;
+
+	/* If ct action exist, we can ignore previous ct_clear actions */
+	if (parse_state->ct)
+		return 0;
+
+	if (parse_state->ct_clear) {
+		err = mlx5_tc_ct_set_ct_clear_regs(parse_state->ct_priv, mod_acts);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(parse_state->extack,
+					   "Failed to set registers for ct clear");
+			return err;
+		}
+		attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+
+		/* Prevent handling of additional, redundant clear actions */
+		parse_state->ct_clear = false;
+	}
 
 	return 0;
 }
@@ -70,5 +99,6 @@ struct mlx5e_tc_act mlx5e_tc_act_ct = {
 	.can_offload = tc_act_can_offload_ct,
 	.parse_action = tc_act_parse_ct,
 	.is_multi_table_act = tc_act_is_multi_table_act_ct,
+	.post_parse = tc_act_post_parse_ct,
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index e49f51124c74..73a1e0a4818d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -582,6 +582,12 @@ mlx5_tc_ct_entry_set_registers(struct mlx5_tc_ct_priv *ct_priv,
 	return 0;
 }
 
+int mlx5_tc_ct_set_ct_clear_regs(struct mlx5_tc_ct_priv *priv,
+				 struct mlx5e_tc_mod_hdr_acts *mod_acts)
+{
+		return mlx5_tc_ct_entry_set_registers(priv, mod_acts, 0, 0, 0, 0);
+}
+
 static int
 mlx5_tc_ct_parse_mangle_to_mod_act(struct flow_action_entry *act,
 				   char *modact)
@@ -1410,9 +1416,6 @@ mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 			const struct flow_action_entry *act,
 			struct netlink_ext_ack *extack)
 {
-	bool clear_action = act->ct.action & TCA_CT_ACT_CLEAR;
-	int err;
-
 	if (!priv) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "offload of ct action isn't available");
@@ -1423,17 +1426,6 @@ mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 	attr->ct_attr.ct_action = act->ct.action;
 	attr->ct_attr.nf_ft = act->ct.flow_table;
 
-	if (!clear_action)
-		goto out;
-
-	err = mlx5_tc_ct_entry_set_registers(priv, mod_acts, 0, 0, 0, 0);
-	if (err) {
-		NL_SET_ERR_MSG_MOD(extack, "Failed to set registers for ct clear");
-		return err;
-	}
-	attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
-
-out:
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index 36d3652bf829..00a3ba862afb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -129,6 +129,10 @@ bool
 mlx5e_tc_ct_restore_flow(struct mlx5_tc_ct_priv *ct_priv,
 			 struct sk_buff *skb, u8 zone_restore_id);
 
+int
+mlx5_tc_ct_set_ct_clear_regs(struct mlx5_tc_ct_priv *priv,
+			     struct mlx5e_tc_mod_hdr_acts *mod_acts);
+
 #else /* CONFIG_MLX5_TC_CT */
 
 static inline struct mlx5_tc_ct_priv *
@@ -170,6 +174,13 @@ mlx5_tc_ct_add_no_trk_match(struct mlx5_flow_spec *spec)
 	return 0;
 }
 
+static inline int
+mlx5_tc_ct_set_ct_clear_regs(struct mlx5_tc_ct_priv *priv,
+			     struct mlx5e_tc_mod_hdr_acts *mod_acts)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int
 mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 			struct mlx5_flow_attr *attr,
-- 
2.35.1

