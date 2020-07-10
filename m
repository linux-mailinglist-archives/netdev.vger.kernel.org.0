Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B51D21ADAF
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 05:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgGJDsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 23:48:24 -0400
Received: from mail-eopbgr80070.outbound.protection.outlook.com ([40.107.8.70]:20294
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726996AbgGJDsU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 23:48:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jBBYI4ejKFpuTWvfskb8i1AZDC9wJzawSdlA6gR259CiaKwry+WZ6B7xy727ivcTx68AzogSP36RAEV4gr7i0YTae9jG8yWCr401ZiZx94imZ9AN/UEpwfmOila9wZEn0Y2t7jK8AV7CMIfc7bjgkFVwDMNgm75LEskMoQIkV/cMD8vSWGuDpB+4RUcdrH3cjLBoKRWHp4fdeJWx/GDGBJsQ4jirphGqjFYJjmyTQ0hzJrsUUOykTlA/uc71aRgjMG8klFXbU7SzgnxvfnKHqll1+svr2b1V8vfRkSbgUBLWdxQWEeOR5KL/7Ah1B6DwhT8SjqKFkBUkIVQo9L/GCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z1obP7f+WVnDKojQLf1iqsiCCwes4YGP/ob3MhyoUYU=;
 b=MSz9gbqibF7ny2H2PZY1C21TJifrvKkb2z7hviR1SlqR10Q7Vgkgx4NtJDF+Ru3mQsTSyb1LqduoBrX/9o9u5SryG9yff1fg7leZJ0oNNXCms3ZnfYP967d3fZAa18jqWCRzkvPv/ugdsHSF8Dfh3NP7jh8ihrXx8eK16xGYkuLSN/A0+uQmkjX8GUDn7URRmIkZmn1uFbF1r91aTDUEchD7FiJtug6ckWpUXjwF0scGw5dtokcp5nlik/qbm7fXe+C/T12vK1t99CcMGayiFgafA5cbEqxW53crJFKcHCQqMIyMH0FlLYYIIfWqTNf8x2BSvkM+aSWWF3yHsXthYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z1obP7f+WVnDKojQLf1iqsiCCwes4YGP/ob3MhyoUYU=;
 b=roI6NL4U6Rrnq+PV/xkrKozxsRN5xeCMno7FcwoyFLsLROPuJv4wsQUnX7YuqHnONihf7egOTklUdCcGEfeppiqzywXzQjL7i6y6GbBHlNsMq3ACBUYkJjXlwUFckkBsLohTZ16x0m9o42TW7yBTGENcuutbwvwf6Yb5otb1SIM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4512.eurprd05.prod.outlook.com (2603:10a6:803:44::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 10 Jul
 2020 03:48:05 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 03:48:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Subject: [net-next 11/13] net/mlx5e: CT: Return err_ptr from internal functions
Date:   Thu,  9 Jul 2020 20:44:30 -0700
Message-Id: <20200710034432.112602-12-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710034432.112602-1-saeedm@mellanox.com>
References: <20200710034432.112602-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0022.namprd03.prod.outlook.com (2603:10b6:a03:1e0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Fri, 10 Jul 2020 03:48:03 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ff42d100-8181-4ab1-5d80-08d824840d32
X-MS-TrafficTypeDiagnostic: VI1PR05MB4512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB45122BE9FD0125BE2298E4F2BE650@VI1PR05MB4512.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AYHif0RtNaIuU4gM/zEC17NJb3datBFB5xI2Ssm8X8S1Zb5RShTuBQhhNNbFruc3bORdno++quM0bJOGVtknz5hTl59cJk9pMR6OpIBwmanvDnEcd3NRM7J5POpYXM/pXuvS2krRF7hyChIc8FXmGU0f4UNGLFxKBdHgRdwA3tT2BPM3rKOR/mwtawLDzRwG76ClNs0NRFNlYGu05756lbkcP+hSd1gs1B+uEWgrnHGIJM0amYi3rK5uzh7kUK9NbxU0Zj5JR7cz047UHeF87kaQS9j+llayyjrriitHJUnIHafvCKbcMWqx/1TuAJwzRiFyhFzueqadg4ekRNTgvreb2ciUsTMdx8kNkwTYSZHcJUWkrABj1G6NCFd2jcWm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(2906002)(107886003)(86362001)(8936002)(8676002)(6512007)(5660300002)(83380400001)(16526019)(52116002)(66946007)(54906003)(6486002)(186003)(1076003)(956004)(26005)(66556008)(6666004)(6506007)(36756003)(66476007)(478600001)(2616005)(4326008)(110136005)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: F8N3B8AuM6OkWDLdVZQMk0mJV/AzP95M+b/pQoZvcU3MQTJL4fUHPTyN5ADqHipstJkYnJ6a+jfMvcorS/298jEt2w0TJqaUbVpvZL2M/vzzNhRQyI1K3N7SZh90mDQaf8CDtoAxnym72yP7+G6adWqdB3mf4Gs7l0NskLOjkvD9Z8EDvm8bGradcZaft3m0t/tX6u4uggnGNmFhmyk+DsJHTYc6EUChPOW45s7lV4O0PhYvp3lDKQEWcVuyWomxB55qLr64ms5/KwJ9GV9h6sP8BRBC23GmfTjM4yd6zRgJGe1rUFW2jtUf81/tCyWroyRzi5WtTNTpqQ2aq5jNUZUB3++PEiFiYP+Sft7p6wTtaKorAkBB+03dGxbuHqFkTsFZj+BNdrFxFTXbFs0vT6HTR8mu4f6T041zcWD6fPlQUie96NNIMP9NjiAEZg8JO83Jm6YjDk/FtQRkhTehWyDJxZE615Le4E/dDZUxD/8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff42d100-8181-4ab1-5d80-08d824840d32
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 03:48:05.1321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A4FixfwgH4/XwLrNPdsY1vmJDfMRhbcT+YxMeLVzfLT8HHdNPJn1tyM/VdGvHuIVr9XKec5mg7aGA/s3C5Gc9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4512
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of having to deal with converting between int and ERR_PTR for
return values in mlx5_tc_ct_flow_offload(), make the internal helper
functions return a ptr to mlx5_flow_handle instead of passing it as
output param, this will also avoid gcc confusion and false alarms,
thus we remove the redundant ERR_PTR rule initialization.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Suggested-by: Jason Gunthorpe <jgg@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 37 +++++++------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 3802a26e944c..709ad0012c24 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1400,12 +1400,11 @@ mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_ft *ft)
  * + fte_id match +------------------------>
  * +--------------+
  */
-static int
+static struct mlx5_flow_handle *
 __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 			  struct mlx5e_tc_flow *flow,
 			  struct mlx5_flow_spec *orig_spec,
-			  struct mlx5_esw_flow_attr *attr,
-			  struct mlx5_flow_handle **flow_rule)
+			  struct mlx5_esw_flow_attr *attr)
 {
 	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
 	bool nat = attr->ct_attr.ct_action & TCA_CT_ACT_NAT;
@@ -1425,7 +1424,7 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 	if (!post_ct_spec || !ct_flow) {
 		kfree(post_ct_spec);
 		kfree(ct_flow);
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	/* Register for CT established events */
@@ -1546,11 +1545,10 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 	}
 
 	attr->ct_attr.ct_flow = ct_flow;
-	*flow_rule = ct_flow->post_ct_rule;
 	dealloc_mod_hdr_actions(&pre_mod_acts);
 	kfree(post_ct_spec);
 
-	return 0;
+	return rule;
 
 err_insert_orig:
 	mlx5_eswitch_del_offloaded_rule(ct_priv->esw, ct_flow->post_ct_rule,
@@ -1568,16 +1566,15 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 	kfree(post_ct_spec);
 	kfree(ct_flow);
 	netdev_warn(priv->netdev, "Failed to offload ct flow, err %d\n", err);
-	return err;
+	return ERR_PTR(err);
 }
 
-static int
+static struct mlx5_flow_handle *
 __mlx5_tc_ct_flow_offload_clear(struct mlx5e_priv *priv,
 				struct mlx5e_tc_flow *flow,
 				struct mlx5_flow_spec *orig_spec,
 				struct mlx5_esw_flow_attr *attr,
-				struct mlx5e_tc_mod_hdr_acts *mod_acts,
-				struct mlx5_flow_handle **flow_rule)
+				struct mlx5e_tc_mod_hdr_acts *mod_acts)
 {
 	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
 	struct mlx5_eswitch *esw = ct_priv->esw;
@@ -1589,7 +1586,7 @@ __mlx5_tc_ct_flow_offload_clear(struct mlx5e_priv *priv,
 
 	ct_flow = kzalloc(sizeof(*ct_flow), GFP_KERNEL);
 	if (!ct_flow)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	/* Base esw attributes on original rule attribute */
 	pre_ct_attr = &ct_flow->pre_ct_attr;
@@ -1624,16 +1621,14 @@ __mlx5_tc_ct_flow_offload_clear(struct mlx5e_priv *priv,
 
 	attr->ct_attr.ct_flow = ct_flow;
 	ct_flow->pre_ct_rule = rule;
-	*flow_rule = rule;
-
-	return 0;
+	return rule;
 
 err_insert:
 	mlx5_modify_header_dealloc(priv->mdev, mod_hdr);
 err_set_registers:
 	netdev_warn(priv->netdev,
 		    "Failed to offload ct clear flow, err %d\n", err);
-	return err;
+	return ERR_PTR(err);
 }
 
 struct mlx5_flow_handle *
@@ -1645,22 +1640,18 @@ mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 {
 	bool clear_action = attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR;
 	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
-	struct mlx5_flow_handle *rule = ERR_PTR(-EINVAL);
-	int err;
+	struct mlx5_flow_handle *rule;
 
 	if (!ct_priv)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	mutex_lock(&ct_priv->control_lock);
+
 	if (clear_action)
-		err = __mlx5_tc_ct_flow_offload_clear(priv, flow, spec, attr,
-						      mod_hdr_acts, &rule);
+		rule = __mlx5_tc_ct_flow_offload_clear(priv, flow, spec, attr, mod_hdr_acts);
 	else
-		err = __mlx5_tc_ct_flow_offload(priv, flow, spec, attr,
-						&rule);
+		rule = __mlx5_tc_ct_flow_offload(priv, flow, spec, attr);
 	mutex_unlock(&ct_priv->control_lock);
-	if (err)
-		return ERR_PTR(err);
 
 	return rule;
 }
-- 
2.26.2

