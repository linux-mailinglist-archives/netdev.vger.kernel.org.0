Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 058B66459EC
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 13:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiLGMh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 07:37:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiLGMhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 07:37:55 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9712CDC0
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 04:37:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZRs6gxkGjs7MP9PTjvTsOhn1p+zU6IrGF6XK+qROUesTKrwVT3tTPgRjVRxANCV+ZB5TBqx7n8846LggTl3XKJfk1XO/wcxXa3mnrXmjSGfagH8sD6+Gh0Avyw5fKpP3IqcQIKMlveJ+Voas1smm4cSdaEtyHrcnQW/s8wewBC7SWeQtkGiBENf93Ak0MJdZc1Z6001Yrh6bQikYSgq8dOQJTTXLQfIkgZSD8ubfESdKjKqcrmuF0q/OMjzqgbDQLu4CljtTinWuf5Dg4via1Ps00OPAOvKtbU0yr5D386cgJukBrWQkQQBEFZ1xvda6bj0nsp1CltvglCy10Wf0pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gDt3qytznUVsJNk/rqInjJGfFQT5hOJqRnOEpip/F+U=;
 b=UPahAT0Xj0ByE/SXcpfu3jVuIVCxkT6e98MkofkLSnaCxS73vWf+jWClc8FdI5gobTvxT2JnWAoi29iQLe5+XhV/2SxhLs0+GZUTZLOspOCiKVECceNBd6iwk3fEcV3+XHvBfmH4/rZGIheF8dnFiiRj+0kjr+K46guG4HPSHRGah/oR4v5WRRtphv/As4sqfaMhH2rSOIe37AxYgNSv5IEG8KQoDFgVbrxshO2Y9CJOyPjh29HsTDsGnHzru8UiWDLSHXKm/1VsSnNHzMAZ7K/9lglFhy+Za/e/My24BsxglAkZkD8o9YOBDJwM91Ho+kMQMVFSMOzyxNjog73TVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDt3qytznUVsJNk/rqInjJGfFQT5hOJqRnOEpip/F+U=;
 b=btIVEmsBzoCRxUv8l07/F8CKaaFbtTnXWLuUq0BG7OVSHPGe8xvsJP4vq5thAmk0W08BafvYygk4W9sBrL5mWQZyP60kw0SjKBGhfAdfDtfs7PP/8Yq5BHw23y3WbiSj/vNC691Io5VBib2fQ2KXmu7nkdpADaEA//OE39aFUKfMo3gY2OBl8jzdMwMxWU+6W9f+WSU5l0GmrXvwFd8djv8fPTv330cbZUYtDRXaWBbi+qacGMhmGCYdGF/0/pOFUGxKVxEaJLGQWeMYvpfEXMFFhdWZisYT+XmMHTpLg4Le74ZOZrhyNSTeiWW/kzB1FZ2iuwR0YrI7ELxha14LNg==
Received: from DS7PR06CA0026.namprd06.prod.outlook.com (2603:10b6:8:54::16) by
 DM4PR12MB6279.namprd12.prod.outlook.com (2603:10b6:8:a3::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Wed, 7 Dec 2022 12:37:52 +0000
Received: from DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:54:cafe::89) by DS7PR06CA0026.outlook.office365.com
 (2603:10b6:8:54::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 12:37:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT024.mail.protection.outlook.com (10.13.172.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5901.14 via Frontend Transport; Wed, 7 Dec 2022 12:37:51 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 7 Dec 2022
 04:37:42 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 7 Dec 2022 04:37:39 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Amit Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net 1/6] mlxsw: spectrum_router: Use gen_pool for RIF index allocation
Date:   Wed, 7 Dec 2022 13:36:42 +0100
Message-ID: <f0f6b85c5c23b9361933b57e361a03420a722e5f.1670414573.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT024:EE_|DM4PR12MB6279:EE_
X-MS-Office365-Filtering-Correlation-Id: 16ee48f0-9b2b-43a2-411f-08dad84fdb60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: buqZdUi16GBEamrR8W5IdlAMo3RNSl4MVHu86+mhB9jUqhzaWutOcjybgnfOb0UG6EdDjN4uuV9JqhwhLr8ttqwVeoJme+2bsNE4Yx7xA/YovNNd1/Dsth1VCq5lzr6zFtoUsf98ojHcUQyKknPpmH/TYSBKeSWkwjrDylkDLtq7zaA/QkcxbvTybdXiuuRyaaixA/kxqZDmK9CWMsXrlv4Jqp3WaVGiNgpCzCdFQWGixDSLuulcj8e8VwJb878HbYDXOPojPwuUKF1V974DvOHtMrOxDaGx/mRXy9o4shEii79oyhCXabtYJ+WqP44KiCI4k3xpHfWBZX/8HvsOlRMrO+5gErbsNbD5SFJvlyFihurEKaNnj2KIg6SF/ReZL4nJbSDEEOmdfBYSRiEfXINL82DAnt/3YSrBYqvadAJTlpPe+vDmZxk6a7BMFulbrGl4yIYSMfoMe0W4dse7RUk6/rEAlRdo2w7YPR1PI+GmdJmTHIdBsYv27uGQyfMDlqwp1+d9ak7jNtVY1srWKbCcnjoYrlAmeQfVLFqfe0l8Ec3wb8cAUK73KtUJKpFaNnkq3Akp/KnPQVNEzmyXHUl1f9NEeJh/H41hxehAJFXNaWEW+HOD3/kHZbdeHG1dKq3f80t05HaKjOnS6YDLHXDYZ6BntArv63gxnZBl7c0kFPuWMiB2zvAXJLQPKm5dPIUyV0UIELPG6a3PTfVc5g==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199015)(40470700004)(36840700001)(46966006)(356005)(478600001)(2906002)(7636003)(82740400003)(82310400005)(54906003)(41300700001)(40460700003)(4326008)(8676002)(8936002)(40480700001)(86362001)(5660300002)(426003)(70206006)(70586007)(36756003)(66574015)(47076005)(110136005)(186003)(26005)(16526019)(2616005)(336012)(6666004)(107886003)(83380400001)(316002)(7696005)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 12:37:51.9318
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16ee48f0-9b2b-43a2-411f-08dad84fdb60
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6279
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
table and there are no alignment constraints. This is going to change in
subsequent patches where some RIFs will consume two table entries and
their indexes will need to be aligned to the allocation size (even).

Prepare for this change by converting the RIF index allocation to use
gen_pool with the 'gen_pool_first_fit_order_align' algorithm.

No Kconfig changes necessary as mlxsw already selects
'GENERIC_ALLOCATOR'.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 73 ++++++++++++++++---
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  4 +
 2 files changed, 67 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 48f1fa62a4fd..47d8c1635897 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -18,6 +18,7 @@
 #include <linux/jhash.h>
 #include <linux/net_namespace.h>
 #include <linux/mutex.h>
+#include <linux/genalloc.h>
 #include <net/netevent.h>
 #include <net/neighbour.h>
 #include <net/arp.h>
@@ -7828,16 +7829,18 @@ mlxsw_sp_dev_rif_type(const struct mlxsw_sp *mlxsw_sp,
 
 static int mlxsw_sp_rif_index_alloc(struct mlxsw_sp *mlxsw_sp, u16 *p_rif_index)
 {
-	int i;
+	*p_rif_index = gen_pool_alloc(mlxsw_sp->router->rifs_table, 1);
+	if (*p_rif_index == 0)
+		return -ENOBUFS;
+	*p_rif_index -= MLXSW_SP_ROUTER_GENALLOC_OFFSET;
 
-	for (i = 0; i < MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS); i++) {
-		if (!mlxsw_sp->router->rifs[i]) {
-			*p_rif_index = i;
-			return 0;
-		}
-	}
+	return 0;
+}
 
-	return -ENOBUFS;
+static void mlxsw_sp_rif_index_free(struct mlxsw_sp *mlxsw_sp, u16 rif_index)
+{
+	gen_pool_free(mlxsw_sp->router->rifs_table,
+		      MLXSW_SP_ROUTER_GENALLOC_OFFSET + rif_index, 1);
 }
 
 static struct mlxsw_sp_rif *mlxsw_sp_rif_alloc(size_t rif_size, u16 rif_index,
@@ -8162,6 +8165,7 @@ mlxsw_sp_rif_create(struct mlxsw_sp *mlxsw_sp,
 	dev_put(rif->dev);
 	kfree(rif);
 err_rif_alloc:
+	mlxsw_sp_rif_index_free(mlxsw_sp, rif_index);
 err_rif_index_alloc:
 	vr->rif_count--;
 	mlxsw_sp_vr_put(mlxsw_sp, vr);
@@ -8173,6 +8177,7 @@ static void mlxsw_sp_rif_destroy(struct mlxsw_sp_rif *rif)
 	const struct mlxsw_sp_rif_ops *ops = rif->ops;
 	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
 	struct mlxsw_sp_fid *fid = rif->fid;
+	u16 rif_index = rif->rif_index;
 	struct mlxsw_sp_vr *vr;
 	int i;
 
@@ -8198,6 +8203,7 @@ static void mlxsw_sp_rif_destroy(struct mlxsw_sp_rif *rif)
 	mlxsw_sp->router->rifs[rif->rif_index] = NULL;
 	dev_put(rif->dev);
 	kfree(rif);
+	mlxsw_sp_rif_index_free(mlxsw_sp, rif_index);
 	vr->rif_count--;
 	mlxsw_sp_vr_put(mlxsw_sp, vr);
 }
@@ -9781,8 +9787,10 @@ mlxsw_sp_ul_rif_create(struct mlxsw_sp *mlxsw_sp, struct mlxsw_sp_vr *vr,
 	}
 
 	ul_rif = mlxsw_sp_rif_alloc(sizeof(*ul_rif), rif_index, vr->id, NULL);
-	if (!ul_rif)
-		return ERR_PTR(-ENOMEM);
+	if (!ul_rif) {
+		err = -ENOMEM;
+		goto err_rif_alloc;
+	}
 
 	mlxsw_sp->router->rifs[rif_index] = ul_rif;
 	ul_rif->mlxsw_sp = mlxsw_sp;
@@ -9796,17 +9804,21 @@ mlxsw_sp_ul_rif_create(struct mlxsw_sp *mlxsw_sp, struct mlxsw_sp_vr *vr,
 ul_rif_op_err:
 	mlxsw_sp->router->rifs[rif_index] = NULL;
 	kfree(ul_rif);
+err_rif_alloc:
+	mlxsw_sp_rif_index_free(mlxsw_sp, rif_index);
 	return ERR_PTR(err);
 }
 
 static void mlxsw_sp_ul_rif_destroy(struct mlxsw_sp_rif *ul_rif)
 {
 	struct mlxsw_sp *mlxsw_sp = ul_rif->mlxsw_sp;
+	u16 rif_index = ul_rif->rif_index;
 
 	atomic_dec(&mlxsw_sp->router->rifs_count);
 	mlxsw_sp_rif_ipip_lb_ul_rif_op(ul_rif, false);
 	mlxsw_sp->router->rifs[ul_rif->rif_index] = NULL;
 	kfree(ul_rif);
+	mlxsw_sp_rif_index_free(mlxsw_sp, rif_index);
 }
 
 static struct mlxsw_sp_rif *
@@ -9940,11 +9952,43 @@ static const struct mlxsw_sp_rif_ops *mlxsw_sp2_rif_ops_arr[] = {
 	[MLXSW_SP_RIF_TYPE_IPIP_LB]	= &mlxsw_sp2_rif_ipip_lb_ops,
 };
 
+static int mlxsw_sp_rifs_table_init(struct mlxsw_sp *mlxsw_sp)
+{
+	struct gen_pool *rifs_table;
+	int err;
+
+	rifs_table = gen_pool_create(0, -1);
+	if (!rifs_table)
+		return -ENOMEM;
+
+	gen_pool_set_algo(rifs_table, gen_pool_first_fit_order_align,
+			  NULL);
+
+	err = gen_pool_add(rifs_table, MLXSW_SP_ROUTER_GENALLOC_OFFSET,
+			   MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS), -1);
+	if (err)
+		goto err_gen_pool_add;
+
+	mlxsw_sp->router->rifs_table = rifs_table;
+
+	return 0;
+
+err_gen_pool_add:
+	gen_pool_destroy(rifs_table);
+	return err;
+}
+
+static void mlxsw_sp_rifs_table_fini(struct mlxsw_sp *mlxsw_sp)
+{
+	gen_pool_destroy(mlxsw_sp->router->rifs_table);
+}
+
 static int mlxsw_sp_rifs_init(struct mlxsw_sp *mlxsw_sp)
 {
 	u64 max_rifs = MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS);
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	struct mlxsw_core *core = mlxsw_sp->core;
+	int err;
 
 	if (!MLXSW_CORE_RES_VALID(core, MAX_RIF_MAC_PROFILES))
 		return -EIO;
@@ -9957,6 +10001,10 @@ static int mlxsw_sp_rifs_init(struct mlxsw_sp *mlxsw_sp)
 	if (!mlxsw_sp->router->rifs)
 		return -ENOMEM;
 
+	err = mlxsw_sp_rifs_table_init(mlxsw_sp);
+	if (err)
+		goto err_rifs_table_init;
+
 	idr_init(&mlxsw_sp->router->rif_mac_profiles_idr);
 	atomic_set(&mlxsw_sp->router->rif_mac_profiles_count, 0);
 	atomic_set(&mlxsw_sp->router->rifs_count, 0);
@@ -9970,6 +10018,10 @@ static int mlxsw_sp_rifs_init(struct mlxsw_sp *mlxsw_sp)
 				       mlxsw_sp);
 
 	return 0;
+
+err_rifs_table_init:
+	kfree(mlxsw_sp->router->rifs);
+	return err;
 }
 
 static void mlxsw_sp_rifs_fini(struct mlxsw_sp *mlxsw_sp)
@@ -9986,6 +10038,7 @@ static void mlxsw_sp_rifs_fini(struct mlxsw_sp *mlxsw_sp)
 					 MLXSW_SP_RESOURCE_RIF_MAC_PROFILES);
 	WARN_ON(!idr_is_empty(&mlxsw_sp->router->rif_mac_profiles_idr));
 	idr_destroy(&mlxsw_sp->router->rif_mac_profiles_idr);
+	mlxsw_sp_rifs_table_fini(mlxsw_sp);
 	kfree(mlxsw_sp->router->rifs);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index c5dfb972b433..37d6e4c80e6a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -15,8 +15,12 @@ struct mlxsw_sp_router_nve_decap {
 	u8 valid:1;
 };
 
+/* gen_pool_alloc() returns 0 when allocation fails, so use an offset */
+#define MLXSW_SP_ROUTER_GENALLOC_OFFSET 0x100
+
 struct mlxsw_sp_router {
 	struct mlxsw_sp *mlxsw_sp;
+	struct gen_pool *rifs_table;
 	struct mlxsw_sp_rif **rifs;
 	struct idr rif_mac_profiles_idr;
 	atomic_t rif_mac_profiles_count;
-- 
2.35.3

