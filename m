Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671EE20C440
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 23:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbgF0VSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 17:18:55 -0400
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:16519
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725912AbgF0VSx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 17:18:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SUg3bUWW2ANqxGG2qC8s9srj1lr0v26r5ln2lVr9xNC5OMBa3wgqne3fb/H7p7tvnQlfI5OgAzm0dswYKysEUQTis7SbqI4UtWcpwMEB/fAEfzZ62NxdnZjhXG1alTs0udnqYV4NIhWClSxZKTqg9J4OnV3KNKKGCk9PWxIFOutFpd2JwnKj6TGoReIgN35oEa8jLaYtZjYcoo9+T7WC6CQPfRKi/iSgiJn5aePy0ypKMLNEjtoZmO2lpCwJ6BI2NO5jNJXpzne1UALGKd3oweySIQoOMn6DSyxVUd8vENv6nf95R0GP1wgG2lV5GrR0tccOO1JpC1uUzDcSav7qig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+P35CWz1I29eL7OLQRRIfb98inG5OPhulsERtos4oww=;
 b=X2Cp114zxgjji2efQGQSvz4Yoa9pF5d1NelVPvO6EkKq7JsgHLMMQex5uNvXXlxAoDGgCbPMvMHn8A8UBMbTnZz+OFaUabA3JXLkqz54F0TH+S+6tRgUqDRuyoIWKHLmZha6chl2884CsA3EcEl5yW1qOtRNzU/PuHtSpuq8pFraHtJRYRTAlUBFaNuCFXvQE4TPL0bYquRyAnznYTmJl9kEcP+twJ0lMQcRp/LEUsQoCgdhPOTjwWN/p8LUqUHrCGjoceTIVtn5wboseucc29W6n76+Ss4tGJ7ebB2Yuem52JNKpikyKNWQ+jHfXDP9PBrhc3MRd0Ji69kgFsv2rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+P35CWz1I29eL7OLQRRIfb98inG5OPhulsERtos4oww=;
 b=LDfVlORybZY7uCjhCLGgRMT1iHJAppt6ywEhQEbFpBJyJTw1y6p556QeFcnt+qM426sd/hzmw9IN4GzHniX5Ybe4gEbamFzJvKw5AJJoDI8Sr2lxX5MJ7YcCFhV0Bmndbwz05MgFtzcZsarga9n09G+7EqP6m2RccN4WBD7Bpi4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5134.eurprd05.prod.outlook.com (2603:10a6:803:ad::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Sat, 27 Jun
 2020 21:18:42 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.026; Sat, 27 Jun 2020
 21:18:42 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [net-next 03/15] net/mlx5e: API to manipulate TTC rules destinations
Date:   Sat, 27 Jun 2020 14:17:15 -0700
Message-Id: <20200627211727.259569-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200627211727.259569-1-saeedm@mellanox.com>
References: <20200627211727.259569-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0017.namprd03.prod.outlook.com (2603:10b6:a03:1e0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Sat, 27 Jun 2020 21:18:40 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: de81d296-64d4-4f59-296d-08d81adfaabf
X-MS-TrafficTypeDiagnostic: VI1PR05MB5134:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5134D7A14512FC003C9EC744BE900@VI1PR05MB5134.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:275;
X-Forefront-PRVS: 0447DB1C71
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AmmiUq8vp98m3cshk8F5j6zuSwCPrTrygCBmWD26N7706jPfJfcoP0EpfvHNMdrfYxS3X8mbLKmjwgIyFjMzmAdheiRayJbrggskFBd8TCsmbcv2mHhvVLFvUextgz5+N1+tApHC6PY6N+OwP3ZB+7/itoY7PVKYJg4mskEmTkw8udKLy6DFHAIx7lyk+E5qHAVVLsqcCy/OatZS4Ye4HV3tLpvqZ+y5fhIGd5rqzxV1nWQQ5OF3xz9321wiiiC9axTJVTnD7GhLZ73CN9rqFjThl7BKYhh0NECYTrerJVN7TWSnGML4vpxKB/Xlvx7zqJINDZpdYLEoDHjjNW6wdGQhe8y0gOzkzbnCmRbZlP6tEKbNAI1r8LEn8eWjdvMs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(39850400004)(346002)(396003)(66476007)(107886003)(54906003)(478600001)(4326008)(316002)(6512007)(16526019)(6506007)(2616005)(1076003)(6486002)(956004)(6666004)(66556008)(8936002)(52116002)(86362001)(36756003)(5660300002)(66946007)(26005)(8676002)(83380400001)(2906002)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: i9OxxPMK0eKKYMzPjHLvvSImHc+cmEOZDpJAp0cqhnZObtBwMqI5WzhzFk02tU3X0nPwPFEvxVUtnYkK4i/jdOZFsWocp+T0Fb4COZUTb0WxRKj5bvOinbeMJutUVAvNP/mREfL6m9psw1VNgXxjy2LyfkF8ui6MWLn6iZN6aeSw8/3WeCHfnqheWr2mgJyfUulhlaGlVYbGk/sD8dT3a9koN/ZA6/OUfda2LNdG1RfAFbMsMXAJByePQ3hH8a40FinlqTiViDq/hOZEl9LoZMkS1ykfOjST48hb8Xl0F/hN27Oeq6swGIvqWDicx9duxdaTMln9dzR9c/i+IrZmAaFy6C/swDojA0S6jJN3ZFqxh/c0AoaWNTJE9TGYHTE7b0jluJ2Luumvr76szzHMhbE+7a3KAh1nl+ojCY3iWCyXxCusewdRmnoKCyVIuUIYl8vcaO/DdzAt/rTD/o1nX63H2w9wUl82aZllO7sH3P4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de81d296-64d4-4f59-296d-08d81adfaabf
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2020 21:18:41.9677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3a9KmsADD/usU77/s+kCLK0aPgj/myHM0D4xpTWyuor3Pc3Ts54coxK0WMD/T4oQ/Clq+zwEc7F605eChGh/Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5134
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Store the default destinations of the on-load generated TTC
(Traffic Type Classifier) rules in the ttc rules table.

Introduce TTC API functions to manipulate/restore and get the TTC rule
destination and use these API functions in arfs implementation.

This will allow a better decoupling between TTC implementation and its
users.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   | 16 +++-
 .../net/ethernet/mellanox/mlx5/core/en_arfs.c | 34 +++-----
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   | 84 ++++++++++++++-----
 3 files changed, 86 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 0416f7712109..c633579474c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -105,11 +105,16 @@ enum mlx5e_tunnel_types {
 
 bool mlx5e_tunnel_inner_ft_supported(struct mlx5_core_dev *mdev);
 
+struct mlx5e_ttc_rule {
+	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_destination default_dest;
+};
+
 /* L3/L4 traffic type classifier */
 struct mlx5e_ttc_table {
-	struct mlx5e_flow_table  ft;
-	struct mlx5_flow_handle	 *rules[MLX5E_NUM_TT];
-	struct mlx5_flow_handle  *tunnel_rules[MLX5E_NUM_TUNNEL_TT];
+	struct mlx5e_flow_table ft;
+	struct mlx5e_ttc_rule rules[MLX5E_NUM_TT];
+	struct mlx5_flow_handle *tunnel_rules[MLX5E_NUM_TUNNEL_TT];
 };
 
 /* NIC prio FTS */
@@ -248,6 +253,11 @@ void mlx5e_destroy_inner_ttc_table(struct mlx5e_priv *priv,
 				   struct mlx5e_ttc_table *ttc);
 
 void mlx5e_destroy_flow_table(struct mlx5e_flow_table *ft);
+int mlx5e_ttc_fwd_dest(struct mlx5e_priv *priv, enum mlx5e_traffic_types type,
+		       struct mlx5_flow_destination *new_dest);
+struct mlx5_flow_destination
+mlx5e_ttc_get_default_dest(struct mlx5e_priv *priv, enum mlx5e_traffic_types type);
+int mlx5e_ttc_fwd_default_dest(struct mlx5e_priv *priv, enum mlx5e_traffic_types type);
 
 void mlx5e_enable_cvlan_filter(struct mlx5e_priv *priv);
 void mlx5e_disable_cvlan_filter(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index c4c9d6cda7e6..39475f6565c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -90,23 +90,15 @@ static enum mlx5e_traffic_types arfs_get_tt(enum arfs_type type)
 
 static int arfs_disable(struct mlx5e_priv *priv)
 {
-	struct mlx5_flow_destination dest = {};
-	struct mlx5e_tir *tir = priv->indir_tir;
-	int err = 0;
-	int tt;
-	int i;
+	int err, i;
 
-	dest.type = MLX5_FLOW_DESTINATION_TYPE_TIR;
 	for (i = 0; i < ARFS_NUM_TYPES; i++) {
-		dest.tir_num = tir[i].tirn;
-		tt = arfs_get_tt(i);
-		/* Modify ttc rules destination to bypass the aRFS tables*/
-		err = mlx5_modify_rule_destination(priv->fs.ttc.rules[tt],
-						   &dest, NULL);
+		/* Modify ttc rules destination back to their default */
+		err = mlx5e_ttc_fwd_default_dest(priv, arfs_get_tt(i));
 		if (err) {
 			netdev_err(priv->netdev,
-				   "%s: modify ttc destination failed\n",
-				   __func__);
+				   "%s: modify ttc[%d] default destination failed, err(%d)\n",
+				   __func__, arfs_get_tt(i), err);
 			return err;
 		}
 	}
@@ -125,21 +117,17 @@ int mlx5e_arfs_disable(struct mlx5e_priv *priv)
 int mlx5e_arfs_enable(struct mlx5e_priv *priv)
 {
 	struct mlx5_flow_destination dest = {};
-	int err = 0;
-	int tt;
-	int i;
+	int err, i;
 
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	for (i = 0; i < ARFS_NUM_TYPES; i++) {
 		dest.ft = priv->fs.arfs.arfs_tables[i].ft.t;
-		tt = arfs_get_tt(i);
 		/* Modify ttc rules destination to point on the aRFS FTs */
-		err = mlx5_modify_rule_destination(priv->fs.ttc.rules[tt],
-						   &dest, NULL);
+		err = mlx5e_ttc_fwd_dest(priv, arfs_get_tt(i), &dest);
 		if (err) {
 			netdev_err(priv->netdev,
-				   "%s: modify ttc destination failed err=%d\n",
-				   __func__, err);
+				   "%s: modify ttc[%d] dest to arfs, failed err(%d)\n",
+				   __func__, arfs_get_tt(i), err);
 			arfs_disable(priv);
 			return err;
 		}
@@ -186,8 +174,10 @@ static int arfs_add_default_rule(struct mlx5e_priv *priv,
 		return -EINVAL;
 	}
 
+	/* FIXME: Must use mlx5e_ttc_get_default_dest(),
+	 * but can't since TTC default is not setup yet !
+	 */
 	dest.tir_num = tir[tt].tirn;
-
 	arfs_t->default_rule = mlx5_add_flow_rules(arfs_t->ft.t, NULL,
 						   &flow_act,
 						   &dest, 1);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 73d3dc07331f..64d002d92250 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -672,9 +672,9 @@ static void mlx5e_cleanup_ttc_rules(struct mlx5e_ttc_table *ttc)
 	int i;
 
 	for (i = 0; i < MLX5E_NUM_TT; i++) {
-		if (!IS_ERR_OR_NULL(ttc->rules[i])) {
-			mlx5_del_flow_rules(ttc->rules[i]);
-			ttc->rules[i] = NULL;
+		if (!IS_ERR_OR_NULL(ttc->rules[i].rule)) {
+			mlx5_del_flow_rules(ttc->rules[i].rule);
+			ttc->rules[i].rule = NULL;
 		}
 	}
 
@@ -857,7 +857,8 @@ static int mlx5e_generate_ttc_table_rules(struct mlx5e_priv *priv,
 					  struct mlx5e_ttc_table *ttc)
 {
 	struct mlx5_flow_destination dest = {};
-	struct mlx5_flow_handle **rules;
+	struct mlx5_flow_handle **trules;
+	struct mlx5e_ttc_rule *rules;
 	struct mlx5_flow_table *ft;
 	int tt;
 	int err;
@@ -867,39 +868,47 @@ static int mlx5e_generate_ttc_table_rules(struct mlx5e_priv *priv,
 
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_TIR;
 	for (tt = 0; tt < MLX5E_NUM_TT; tt++) {
+		struct mlx5e_ttc_rule *rule = &rules[tt];
+
 		if (tt == MLX5E_TT_ANY)
 			dest.tir_num = params->any_tt_tirn;
 		else
 			dest.tir_num = params->indir_tirn[tt];
-		rules[tt] = mlx5e_generate_ttc_rule(priv, ft, &dest,
-						    ttc_rules[tt].etype,
-						    ttc_rules[tt].proto);
-		if (IS_ERR(rules[tt]))
+
+		rule->rule = mlx5e_generate_ttc_rule(priv, ft, &dest,
+						     ttc_rules[tt].etype,
+						     ttc_rules[tt].proto);
+		if (IS_ERR(rule->rule)) {
+			err = PTR_ERR(rule->rule);
+			rule->rule = NULL;
 			goto del_rules;
+		}
+		rule->default_dest = dest;
 	}
 
 	if (!params->inner_ttc || !mlx5e_tunnel_inner_ft_supported(priv->mdev))
 		return 0;
 
-	rules     = ttc->tunnel_rules;
+	trules    = ttc->tunnel_rules;
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest.ft   = params->inner_ttc->ft.t;
 	for (tt = 0; tt < MLX5E_NUM_TUNNEL_TT; tt++) {
 		if (!mlx5e_tunnel_proto_supported(priv->mdev,
 						  ttc_tunnel_rules[tt].proto))
 			continue;
-		rules[tt] = mlx5e_generate_ttc_rule(priv, ft, &dest,
-						    ttc_tunnel_rules[tt].etype,
-						    ttc_tunnel_rules[tt].proto);
-		if (IS_ERR(rules[tt]))
+		trules[tt] = mlx5e_generate_ttc_rule(priv, ft, &dest,
+						     ttc_tunnel_rules[tt].etype,
+						     ttc_tunnel_rules[tt].proto);
+		if (IS_ERR(trules[tt])) {
+			err = PTR_ERR(trules[tt]);
+			trules[tt] = NULL;
 			goto del_rules;
+		}
 	}
 
 	return 0;
 
 del_rules:
-	err = PTR_ERR(rules[tt]);
-	rules[tt] = NULL;
 	mlx5e_cleanup_ttc_rules(ttc);
 	return err;
 }
@@ -1015,33 +1024,38 @@ static int mlx5e_generate_inner_ttc_table_rules(struct mlx5e_priv *priv,
 						struct mlx5e_ttc_table *ttc)
 {
 	struct mlx5_flow_destination dest = {};
-	struct mlx5_flow_handle **rules;
+	struct mlx5e_ttc_rule *rules;
 	struct mlx5_flow_table *ft;
 	int err;
 	int tt;
 
 	ft = ttc->ft.t;
 	rules = ttc->rules;
-
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_TIR;
+
 	for (tt = 0; tt < MLX5E_NUM_TT; tt++) {
+		struct mlx5e_ttc_rule *rule = &rules[tt];
+
 		if (tt == MLX5E_TT_ANY)
 			dest.tir_num = params->any_tt_tirn;
 		else
 			dest.tir_num = params->indir_tirn[tt];
 
-		rules[tt] = mlx5e_generate_inner_ttc_rule(priv, ft, &dest,
-							  ttc_rules[tt].etype,
-							  ttc_rules[tt].proto);
-		if (IS_ERR(rules[tt]))
+		rule->rule = mlx5e_generate_inner_ttc_rule(priv, ft, &dest,
+							   ttc_rules[tt].etype,
+							   ttc_rules[tt].proto);
+		if (IS_ERR(rule->rule)) {
+			err = PTR_ERR(rule->rule);
+			rule->rule = NULL;
 			goto del_rules;
+		}
+		rule->default_dest = dest;
 	}
 
 	return 0;
 
 del_rules:
-	err = PTR_ERR(rules[tt]);
-	rules[tt] = NULL;
+
 	mlx5e_cleanup_ttc_rules(ttc);
 	return err;
 }
@@ -1210,6 +1224,30 @@ int mlx5e_create_ttc_table(struct mlx5e_priv *priv, struct ttc_params *params,
 	return err;
 }
 
+int mlx5e_ttc_fwd_dest(struct mlx5e_priv *priv, enum mlx5e_traffic_types type,
+		       struct mlx5_flow_destination *new_dest)
+{
+	return mlx5_modify_rule_destination(priv->fs.ttc.rules[type].rule, new_dest, NULL);
+}
+
+struct mlx5_flow_destination
+mlx5e_ttc_get_default_dest(struct mlx5e_priv *priv, enum mlx5e_traffic_types type)
+{
+	struct mlx5_flow_destination *dest = &priv->fs.ttc.rules[type].default_dest;
+
+	WARN_ONCE(dest->type != MLX5_FLOW_DESTINATION_TYPE_TIR,
+		  "TTC[%d] default dest is not setup yet", type);
+
+	return *dest;
+}
+
+int mlx5e_ttc_fwd_default_dest(struct mlx5e_priv *priv, enum mlx5e_traffic_types type)
+{
+	struct mlx5_flow_destination dest = mlx5e_ttc_get_default_dest(priv, type);
+
+	return mlx5e_ttc_fwd_dest(priv, type, &dest);
+}
+
 static void mlx5e_del_l2_flow_rule(struct mlx5e_priv *priv,
 				   struct mlx5e_l2_rule *ai)
 {
-- 
2.26.2

