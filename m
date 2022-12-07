Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4C96459ED
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 13:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiLGMiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 07:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiLGMh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 07:37:57 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2063.outbound.protection.outlook.com [40.107.100.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61DD129C9D
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 04:37:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UuXM8oAu84CAe5V+4FrtEqO43P8ctFbDS1u2Y+mqA2KFVP8IIbSHkQtAHfYDMyUvOpM9hhKqE3VMIZq+p0dcF5Tuyg8+qPX9ip0wiFzhXYJ+EzyPwIhq2yBqA61PuJiCgoHIqC/BjoN1PA/Lp5D0BmLIEYJUnIapK0RPQGl3FoGQhPDlE3sTgWNSYFn0lMGbEiufp8UTy858ZF1Q5PhdW/D503XUQrPfw5MBfsRcWXwlf9+za6ZG45Lyx+6MOA5hT1cbmK4hCFrcwRb9mxltkVYlPzxo7bbOuBBUbwFlfs9Kn6CoyinMi8k2mojqz+n2/1Z1N6GIkY5jPxQ6UElMcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7YyLY019gvwRyPj1Fhik7MC8hPWZkETR1JJ/iGhSyx8=;
 b=OmtKxuiHLXnMS5Vpw+5/WITjXOrOCtmsRcY940WxBV6t42n/LQWavE72MYNQZViP6I2NfgD0Im3eLbMWkCBL5jGtVFGZk8H5/C6/7IRX8eIaRzKpSlyHnpYSK2fetD38FzrTIjpwbh3APo9YfpihrjG+XIoapN+XTlAa76NKFXObqCL2I0PfAUkn59cH7L1Amdd7QtlQNwSZd0HLId+VGRg3m6rvL5Tw0NFX9t0ead8KoiuX0v71XiD0scsG+/A9mc1sFlz3MoED3pazQ0U4oBlkT/DPnbI5RUvyIC1bymvVAeSQcQxIJ+teVT/HqdrFwY9M8Jid642vBAm8H+oqnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7YyLY019gvwRyPj1Fhik7MC8hPWZkETR1JJ/iGhSyx8=;
 b=JPykQZbYMX/jpfR6ES17tlyWoar71yEKY1zGk1xVUajSk38BpjPZ6/Ah4WfQ/1acFIHdb9HuC9A1ov+jSfl76CAHjatmER2iuHLf39X3Ue/5xqjldPoluZE+hF4OHfS8ykc/26ZVoZOps1DPktaTiS1IB8nMt4Prb4C+I8p2HztX4H35O2iw0131xhpsKPpL92gJ/D1wh8kpcVv6yyyVhhT2g9xZM+V7taEDRxRCHCU72NOf87QFVWPDrCsdLMpHA8QEpBdIFZp8qoM1H5gmESdhp/ImQMLlxaXBY3oxNUbKQw98zN68Tt0ercIYLwRTESB3qqhaakrkGrfaRZig3w==
Received: from DS7PR06CA0037.namprd06.prod.outlook.com (2603:10b6:8:54::12) by
 DM4PR12MB5986.namprd12.prod.outlook.com (2603:10b6:8:69::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.10; Wed, 7 Dec 2022 12:37:54 +0000
Received: from DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:54:cafe::23) by DS7PR06CA0037.outlook.office365.com
 (2603:10b6:8:54::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 12:37:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT024.mail.protection.outlook.com (10.13.172.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5901.14 via Frontend Transport; Wed, 7 Dec 2022 12:37:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 7 Dec 2022
 04:37:44 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 7 Dec 2022 04:37:42 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Amit Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net 2/6] mlxsw: spectrum_router: Parametrize RIF allocation size
Date:   Wed, 7 Dec 2022 13:36:43 +0100
Message-ID: <cfa67891ba37bc578ed59b3bb2d6cb8c79c4bd50.1670414573.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1670414573.git.petrm@nvidia.com>
References: <cover.1670414573.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT024:EE_|DM4PR12MB5986:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e0b7d4d-49c8-43c8-eda5-08dad84fdcd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KMpSmOVnTUzNMsTSUIZvIPjd1JPj19byczfPea+0ZAMjroSnuSmLCGje9nVVmWQqHDtUcvRuiyCevZU1SB7S83ax+4m2vHpahHXZOtNt5SSMpSBrLSFBooKJfyfmsNLCxMIOk6BgA45AyBQv3Yi/qxQkmPQFOvEjTqChTL99IIl/bgdo4VjMYtwx6AMLZv7l3kzRfyJR8g12GIGUgYmWgXlO6kP0c+S5wa1zr/pcmlp7kM13PqnLBg0MT9xrIlBJWm4toljkw1ObhMVkz7sGQuxGRbPOVKM827SYbb5wOnhgrlu2T5ozLvys1E/uYCoiVpsNiLFqW7PnLRIs8f1RbLnhCBoTbt9ATISfJIBqZF0iOZGFr9BPTkZ0UaS5CDG1EhOIv2wc4LsMC4tnV/oj7VUzf+1ARyN+vhqAjuzrKwUFnGI28dKv/IfAQROVHD4s+XYurEKLM9xRQSsxpVHU/2IrV2jxE39CJt8wanweccXZbXtUABirz6WFeb6+PWjkkcranqGfOZqQMvgLUBg23Dze7FLSTRRhuBOSqOroIz3kc8UWjTu6IId0Hh4vGdsM+443irXi2H+p54JHbLrlPwl+eoV4wbeYSXze0xtcV1o5WSNYwdtD+aSyFu2PXWHjdWLggMaqklmxfMOBhVIWDGr+Phmr2c5OG3RuMxja/a4jV1vPtryrMkmd4rDfuAyJ2O52w3D+hSisG73FD071VQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(39860400002)(346002)(451199015)(40470700004)(46966006)(36840700001)(16526019)(47076005)(82740400003)(186003)(2616005)(8676002)(36756003)(5660300002)(8936002)(66574015)(82310400005)(7636003)(41300700001)(4326008)(54906003)(70586007)(70206006)(316002)(110136005)(336012)(40480700001)(36860700001)(86362001)(2906002)(40460700003)(426003)(7696005)(356005)(26005)(478600001)(83380400001)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 12:37:54.4160
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e0b7d4d-49c8-43c8-eda5-08dad84fdcd8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5986
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Currently, each router interface (RIF) consumes one entry in the RIFs
table. This is going to change in subsequent patches where some RIFs
will consume two table entries.

Prepare for this change by parametrizing the RIF allocation size. For
now, always pass '1'.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 41 ++++++++++++-------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 47d8c1635897..f3ace20dca8b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -60,6 +60,7 @@ struct mlxsw_sp_rif {
 	int mtu;
 	u16 rif_index;
 	u8 mac_profile_id;
+	u8 rif_entries;
 	u16 vr_id;
 	const struct mlxsw_sp_rif_ops *ops;
 	struct mlxsw_sp *mlxsw_sp;
@@ -7827,20 +7828,26 @@ mlxsw_sp_dev_rif_type(const struct mlxsw_sp *mlxsw_sp,
 	return mlxsw_sp_fid_type_rif_type(mlxsw_sp, type);
 }
 
-static int mlxsw_sp_rif_index_alloc(struct mlxsw_sp *mlxsw_sp, u16 *p_rif_index)
+static int mlxsw_sp_rif_index_alloc(struct mlxsw_sp *mlxsw_sp, u16 *p_rif_index,
+				    u8 rif_entries)
 {
-	*p_rif_index = gen_pool_alloc(mlxsw_sp->router->rifs_table, 1);
+	*p_rif_index = gen_pool_alloc(mlxsw_sp->router->rifs_table,
+				      rif_entries);
 	if (*p_rif_index == 0)
 		return -ENOBUFS;
 	*p_rif_index -= MLXSW_SP_ROUTER_GENALLOC_OFFSET;
 
+	/* RIF indexes must be aligned to the allocation size. */
+	WARN_ON_ONCE(*p_rif_index % rif_entries);
+
 	return 0;
 }
 
-static void mlxsw_sp_rif_index_free(struct mlxsw_sp *mlxsw_sp, u16 rif_index)
+static void mlxsw_sp_rif_index_free(struct mlxsw_sp *mlxsw_sp, u16 rif_index,
+				    u8 rif_entries)
 {
 	gen_pool_free(mlxsw_sp->router->rifs_table,
-		      MLXSW_SP_ROUTER_GENALLOC_OFFSET + rif_index, 1);
+		      MLXSW_SP_ROUTER_GENALLOC_OFFSET + rif_index, rif_entries);
 }
 
 static struct mlxsw_sp_rif *mlxsw_sp_rif_alloc(size_t rif_size, u16 rif_index,
@@ -8090,6 +8097,7 @@ mlxsw_sp_rif_create(struct mlxsw_sp *mlxsw_sp,
 	enum mlxsw_sp_rif_type type;
 	struct mlxsw_sp_rif *rif;
 	struct mlxsw_sp_vr *vr;
+	u8 rif_entries = 1;
 	u16 rif_index;
 	int i, err;
 
@@ -8101,7 +8109,7 @@ mlxsw_sp_rif_create(struct mlxsw_sp *mlxsw_sp,
 		return ERR_CAST(vr);
 	vr->rif_count++;
 
-	err = mlxsw_sp_rif_index_alloc(mlxsw_sp, &rif_index);
+	err = mlxsw_sp_rif_index_alloc(mlxsw_sp, &rif_index, rif_entries);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Exceeded number of supported router interfaces");
 		goto err_rif_index_alloc;
@@ -8116,6 +8124,7 @@ mlxsw_sp_rif_create(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp->router->rifs[rif_index] = rif;
 	rif->mlxsw_sp = mlxsw_sp;
 	rif->ops = ops;
+	rif->rif_entries = rif_entries;
 
 	if (ops->fid_get) {
 		fid = ops->fid_get(rif, extack);
@@ -8149,7 +8158,7 @@ mlxsw_sp_rif_create(struct mlxsw_sp *mlxsw_sp,
 		mlxsw_sp_rif_counters_alloc(rif);
 	}
 
-	atomic_inc(&mlxsw_sp->router->rifs_count);
+	atomic_add(rif_entries, &mlxsw_sp->router->rifs_count);
 	return rif;
 
 err_stats_enable:
@@ -8165,7 +8174,7 @@ mlxsw_sp_rif_create(struct mlxsw_sp *mlxsw_sp,
 	dev_put(rif->dev);
 	kfree(rif);
 err_rif_alloc:
-	mlxsw_sp_rif_index_free(mlxsw_sp, rif_index);
+	mlxsw_sp_rif_index_free(mlxsw_sp, rif_index, rif_entries);
 err_rif_index_alloc:
 	vr->rif_count--;
 	mlxsw_sp_vr_put(mlxsw_sp, vr);
@@ -8177,11 +8186,12 @@ static void mlxsw_sp_rif_destroy(struct mlxsw_sp_rif *rif)
 	const struct mlxsw_sp_rif_ops *ops = rif->ops;
 	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
 	struct mlxsw_sp_fid *fid = rif->fid;
+	u8 rif_entries = rif->rif_entries;
 	u16 rif_index = rif->rif_index;
 	struct mlxsw_sp_vr *vr;
 	int i;
 
-	atomic_dec(&mlxsw_sp->router->rifs_count);
+	atomic_sub(rif_entries, &mlxsw_sp->router->rifs_count);
 	mlxsw_sp_router_rif_gone_sync(mlxsw_sp, rif);
 	vr = &mlxsw_sp->router->vrs[rif->vr_id];
 
@@ -8203,7 +8213,7 @@ static void mlxsw_sp_rif_destroy(struct mlxsw_sp_rif *rif)
 	mlxsw_sp->router->rifs[rif->rif_index] = NULL;
 	dev_put(rif->dev);
 	kfree(rif);
-	mlxsw_sp_rif_index_free(mlxsw_sp, rif_index);
+	mlxsw_sp_rif_index_free(mlxsw_sp, rif_index, rif_entries);
 	vr->rif_count--;
 	mlxsw_sp_vr_put(mlxsw_sp, vr);
 }
@@ -9777,10 +9787,11 @@ mlxsw_sp_ul_rif_create(struct mlxsw_sp *mlxsw_sp, struct mlxsw_sp_vr *vr,
 		       struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp_rif *ul_rif;
+	u8 rif_entries = 1;
 	u16 rif_index;
 	int err;
 
-	err = mlxsw_sp_rif_index_alloc(mlxsw_sp, &rif_index);
+	err = mlxsw_sp_rif_index_alloc(mlxsw_sp, &rif_index, rif_entries);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Exceeded number of supported router interfaces");
 		return ERR_PTR(err);
@@ -9794,31 +9805,33 @@ mlxsw_sp_ul_rif_create(struct mlxsw_sp *mlxsw_sp, struct mlxsw_sp_vr *vr,
 
 	mlxsw_sp->router->rifs[rif_index] = ul_rif;
 	ul_rif->mlxsw_sp = mlxsw_sp;
+	ul_rif->rif_entries = rif_entries;
 	err = mlxsw_sp_rif_ipip_lb_ul_rif_op(ul_rif, true);
 	if (err)
 		goto ul_rif_op_err;
 
-	atomic_inc(&mlxsw_sp->router->rifs_count);
+	atomic_add(rif_entries, &mlxsw_sp->router->rifs_count);
 	return ul_rif;
 
 ul_rif_op_err:
 	mlxsw_sp->router->rifs[rif_index] = NULL;
 	kfree(ul_rif);
 err_rif_alloc:
-	mlxsw_sp_rif_index_free(mlxsw_sp, rif_index);
+	mlxsw_sp_rif_index_free(mlxsw_sp, rif_index, rif_entries);
 	return ERR_PTR(err);
 }
 
 static void mlxsw_sp_ul_rif_destroy(struct mlxsw_sp_rif *ul_rif)
 {
 	struct mlxsw_sp *mlxsw_sp = ul_rif->mlxsw_sp;
+	u8 rif_entries = ul_rif->rif_entries;
 	u16 rif_index = ul_rif->rif_index;
 
-	atomic_dec(&mlxsw_sp->router->rifs_count);
+	atomic_sub(rif_entries, &mlxsw_sp->router->rifs_count);
 	mlxsw_sp_rif_ipip_lb_ul_rif_op(ul_rif, false);
 	mlxsw_sp->router->rifs[ul_rif->rif_index] = NULL;
 	kfree(ul_rif);
-	mlxsw_sp_rif_index_free(mlxsw_sp, rif_index);
+	mlxsw_sp_rif_index_free(mlxsw_sp, rif_index, rif_entries);
 }
 
 static struct mlxsw_sp_rif *
-- 
2.35.3

