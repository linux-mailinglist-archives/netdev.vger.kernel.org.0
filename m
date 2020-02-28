Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 808D4172DAA
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 01:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730572AbgB1Ap4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 19:45:56 -0500
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:20112
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730447AbgB1Apw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 19:45:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1t1swnu8nvxvlFXoXKvXiG/9OpuqtnoGnnLVRT+TsAx51RolnW/TQos7COwxH/RJrVa1bnPDApBFukUW0ZtrYcFcKPVb7d2bo4o/GRsTsvDaVuhWUCSESy60bD+v3YwNA7ni1v3AY0yqhP5SALppLEIZjsaPM5/tagmRjCf5hYT/6H2qI6fADcXoMaY/7vw7i7bZy2Y6CwaBO6oSrkHPoKHj5iG716z+P211rptoAFEhn+0B15bPZXLP6ptuM7M5ybzB8jRp5u2u8ROsm1bz8H9bksWx4eNxs1OmYd+ztDvKPrfuByyRdojEqC5RQI+F9pz4n4n7Ggyt1ZqhZui1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r7V/v849jbFnANEWBq2hkzAlkke65Jr0p4rfqVp7WeE=;
 b=C00rCL5tCnk9/cGnMtZoFvKDGrTfH7Tcgtikrv6McUJ5XUgKzHVSPH305akWLTeMgH7A/MbgSu48ZP8FmqRhCra1qVIx7ncrTbksu3BZSNfNBtDo6I9ack6ZF4o6+ghuNEdO3LAQ/r8eTiMWYuO1rZm2n6Sxv8eONGMm/qE8d+tpKEgf4rvVkw8hAy8Z0dypSNIMLWyXhibUnGoS901AKL6LeP5gvg4HGoq4l+0v8/Kb4Bw7SPliDb+fd+N2TFLMxOslSMrWbEFASR92GxQzi985USz/zXtQ1b7fy5fKGfDfFhvFKse1BxauX52PVTmJU94fmjjh9VGZlo6JiOGAuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r7V/v849jbFnANEWBq2hkzAlkke65Jr0p4rfqVp7WeE=;
 b=tr0MgrFBUnrMdpmWoh7Cx5q6KRJVBJYQDqQRuumIRHvj1Da4xs3VCETlUSk/bUXSi+G0P/CjeCX2Iv0IQ4uq4DO3pD8QtrC0KSlroJq4Wbq7qLcwge8qjO3Yexi1uNvNZO81N02mTjpIvbzBhvJi7nxRlHodiGJdpX7xXmSW3ok=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4189.eurprd05.prod.outlook.com (52.133.14.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Fri, 28 Feb 2020 00:45:42 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.024; Fri, 28 Feb 2020
 00:45:42 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eli Cohen <eli@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 15/16] net/mlx5e: Reduce number of arguments in slow path handling
Date:   Thu, 27 Feb 2020 16:44:45 -0800
Message-Id: <20200228004446.159497-16-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200228004446.159497-1-saeedm@mellanox.com>
References: <20200228004446.159497-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (209.116.155.178) by BY5PR04CA0004.namprd04.prod.outlook.com (2603:10b6:a03:1d0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Fri, 28 Feb 2020 00:45:40 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c11ed468-5d87-4c97-1d30-08d7bbe789bc
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:|VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4189CE10924B83B1235D044EBEE80@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 0327618309
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(199004)(189003)(66556008)(66946007)(66476007)(6506007)(316002)(4326008)(6512007)(107886003)(478600001)(52116002)(54906003)(6486002)(26005)(8676002)(81166006)(86362001)(8936002)(16526019)(186003)(36756003)(81156014)(5660300002)(2616005)(956004)(2906002)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4189;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jtiIhs7f3vn/VBfRGLrygWlldoKCACqr6+lSkcd8oC57IIEhXFiWKppCKt0FTioz2v6a7HsQEfPk7hdb0YQE03rZ80RCmXBjC84D/InMGXilXmGS8ebiBKMmlvl3v8BwD8V2+5zopEtFaPNkgdZywkNSa/HuUAQxJQNbI4YVyAtmK7VJnUNFKu3B4I7HzZMLqTvknfQhK/PL8/TuLjKrj1JWA9awnM1SlrcnJuD38Zt4rpH0jngL4TWsK0/3J8Ea0xgry0epLbr5/sHa0gLCMgG14L+VBRl4bV3tFIAaQ6Z9/qPyU1GGPL8dvE59JnUjD+NjMjdS8mfyuuTERthAgJgIYqPuL0xDb/SXb2FA3nqgsflKw/QwYY/G6HFaBfYuu3rCOFshdhaKV3J6x61ymI9MFe9SREEI0yCP8NX8j7G1YbM0cXaQa9D55rIQGFThQm9T4y6jo+lIqA2ImBFBLFbzBSt1GhmmlvVGuiUZWhV+twqEKu9jgcKxd3i4DMdrLVJ1M+HWoPtjuCMHUJaki8JIpRjK+M5aZop8ww6R60U=
X-MS-Exchange-AntiSpam-MessageData: zji4YErAxDEBZUqHKFeDhdaKQWF9HDTDfCq7Od02CwblcO3TyB7gnvQ9/cl773E2Kph6WMWFoBuc1mQYT2PhTdEX5X7rmFhCBmDY0iAOjV+kuvxIEuADxg8Qxqkl32YAZk/oQOrEBbuI42lOeMi22w==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c11ed468-5d87-4c97-1d30-08d7bbe789bc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2020 00:45:42.0969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p+AnX71nkZfqO0EfUlAmUvxlP+HkK/uagX0FhOQ5HfHRnJg6bMXqZB0FmVemQ6yAPVbcv0hlKKJ5ObpMugzqjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

mlx5e_tc_offload_to_slow_path() and mlx5e_tc_unoffload_from_slow_path()
take an extra argument allocated on the stack of the caller but not used
by the caller. Avoid the extra argument and use local variable in the
function itself.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 43 +++++++++----------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 1d62743ec251..333c3ec59b17 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1076,17 +1076,17 @@ mlx5e_tc_unoffload_fdb_rules(struct mlx5_eswitch *esw,
 static struct mlx5_flow_handle *
 mlx5e_tc_offload_to_slow_path(struct mlx5_eswitch *esw,
 			      struct mlx5e_tc_flow *flow,
-			      struct mlx5_flow_spec *spec,
-			      struct mlx5_esw_flow_attr *slow_attr)
+			      struct mlx5_flow_spec *spec)
 {
+	struct mlx5_esw_flow_attr slow_attr;
 	struct mlx5_flow_handle *rule;
 
-	memcpy(slow_attr, flow->esw_attr, sizeof(*slow_attr));
-	slow_attr->action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
-	slow_attr->split_count = 0;
-	slow_attr->flags |= MLX5_ESW_ATTR_FLAG_SLOW_PATH;
+	memcpy(&slow_attr, flow->esw_attr, sizeof(slow_attr));
+	slow_attr.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	slow_attr.split_count = 0;
+	slow_attr.flags |= MLX5_ESW_ATTR_FLAG_SLOW_PATH;
 
-	rule = mlx5e_tc_offload_fdb_rules(esw, flow, spec, slow_attr);
+	rule = mlx5e_tc_offload_fdb_rules(esw, flow, spec, &slow_attr);
 	if (!IS_ERR(rule))
 		flow_flag_set(flow, SLOW);
 
@@ -1095,14 +1095,15 @@ mlx5e_tc_offload_to_slow_path(struct mlx5_eswitch *esw,
 
 static void
 mlx5e_tc_unoffload_from_slow_path(struct mlx5_eswitch *esw,
-				  struct mlx5e_tc_flow *flow,
-				  struct mlx5_esw_flow_attr *slow_attr)
+				  struct mlx5e_tc_flow *flow)
 {
-	memcpy(slow_attr, flow->esw_attr, sizeof(*slow_attr));
-	slow_attr->action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
-	slow_attr->split_count = 0;
-	slow_attr->flags |= MLX5_ESW_ATTR_FLAG_SLOW_PATH;
-	mlx5e_tc_unoffload_fdb_rules(esw, flow, slow_attr);
+	struct mlx5_esw_flow_attr slow_attr;
+
+	memcpy(&slow_attr, flow->esw_attr, sizeof(slow_attr));
+	slow_attr.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	slow_attr.split_count = 0;
+	slow_attr.flags |= MLX5_ESW_ATTR_FLAG_SLOW_PATH;
+	mlx5e_tc_unoffload_fdb_rules(esw, flow, &slow_attr);
 	flow_flag_clear(flow, SLOW);
 }
 
@@ -1242,9 +1243,7 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	 */
 	if (!encap_valid) {
 		/* continue with goto slow path rule instead */
-		struct mlx5_esw_flow_attr slow_attr;
-
-		flow->rule[0] = mlx5e_tc_offload_to_slow_path(esw, flow, &parse_attr->spec, &slow_attr);
+		flow->rule[0] = mlx5e_tc_offload_to_slow_path(esw, flow, &parse_attr->spec);
 	} else {
 		flow->rule[0] = mlx5e_tc_offload_fdb_rules(esw, flow, &parse_attr->spec, attr);
 	}
@@ -1275,7 +1274,6 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5_esw_flow_attr *attr = flow->esw_attr;
-	struct mlx5_esw_flow_attr slow_attr;
 	int out_index;
 
 	if (flow_flag_test(flow, NOT_READY)) {
@@ -1286,7 +1284,7 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 
 	if (mlx5e_is_offloaded_flow(flow)) {
 		if (flow_flag_test(flow, SLOW))
-			mlx5e_tc_unoffload_from_slow_path(esw, flow, &slow_attr);
+			mlx5e_tc_unoffload_from_slow_path(esw, flow);
 		else
 			mlx5e_tc_unoffload_fdb_rules(esw, flow, attr);
 	}
@@ -1315,7 +1313,7 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
 			      struct list_head *flow_list)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct mlx5_esw_flow_attr slow_attr, *esw_attr;
+	struct mlx5_esw_flow_attr *esw_attr;
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
 	struct mlx5e_tc_flow *flow;
@@ -1368,7 +1366,7 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
 			continue;
 		}
 
-		mlx5e_tc_unoffload_from_slow_path(esw, flow, &slow_attr);
+		mlx5e_tc_unoffload_from_slow_path(esw, flow);
 		flow->rule[0] = rule;
 		/* was unset when slow path rule removed */
 		flow_flag_set(flow, OFFLOADED);
@@ -1380,7 +1378,6 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 			      struct list_head *flow_list)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct mlx5_esw_flow_attr slow_attr;
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
 	struct mlx5e_tc_flow *flow;
@@ -1392,7 +1389,7 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 		spec = &flow->esw_attr->parse_attr->spec;
 
 		/* update from encap rule to slow path rule */
-		rule = mlx5e_tc_offload_to_slow_path(esw, flow, spec, &slow_attr);
+		rule = mlx5e_tc_offload_to_slow_path(esw, flow, spec);
 		/* mark the flow's encap dest as non-valid */
 		flow->esw_attr->dests[flow->tmp_efi_index].flags &= ~MLX5_ESW_DEST_ENCAP_VALID;
 
-- 
2.24.1

