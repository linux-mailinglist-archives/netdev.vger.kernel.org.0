Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76669365B91
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 16:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbhDTO4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 10:56:33 -0400
Received: from mail-bn8nam12on2076.outbound.protection.outlook.com ([40.107.237.76]:3329
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232902AbhDTO4Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 10:56:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fjFsjAJIfdqVQJZdy0k6i0E83U+igo3t80Pa7Ohz33C9AEC6MgSywFugHDrP/Dh2CDRBXgMpkzqkToXJtZup/n9lVA6kylILGObR1ypCh+MB6bLNN1zjsNeJKYvZFm2JSREc0cUFWYZd3iX7iUzNg0DBnrEpwqe6qo1K5GKTzlSj9dTzJyM4HeG45AQmvD5uXWmpayFnDlidCWBb5Y+pnazwls67QBvcdWl3hI2N181SrySCB/YaOrGqc/C2X0kpYk10euafUT89ENuUfhxhhj9PFyzSVR0nTVT4q8bI8jl8LxuoUmwNWH65L5NdvsDwekodOxSaHTVVlM4C/hUSpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K//ylPf6bP2bE1R9A9b4Dc3o53VKhbmvqJp4nwC8oCM=;
 b=kIcATt8nw6ML2D/4AhWPgCXf71usXK1ZzQ04eu5H0TJPvnGU+aF6uYjQh9Hs3AVRQj7y5Db6mJfsu2rgHP/AwWC40FvQdd5FVfQI3TU28FaHTsKr0fjDrjkaelvhIC09EdikZcL+JndH8aKeiOVAfxpLq+JoUdwogiqZ2v8N8J7McJAuE1/18rQt5GNvZzIA75I/FsRYN7xSaoRSaVWEA6yLHZkXGtxg+fCNMd5ldPUo5zz/cjbkRjhaOorh5xck8hGA659ZdXY1a9AzuwxwtugPZsK6qBG1aFU4PhmPShPcc9W3CTh2U4lstmhXi/0sRdO16DbkFmgZ0MWSC4oI1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K//ylPf6bP2bE1R9A9b4Dc3o53VKhbmvqJp4nwC8oCM=;
 b=gUqwbtTbJwt97j9EaDZY3vfyNk6Ec9Kk7qlGNBjzlCw3DWoDTSY9glKTmPr0N/3pWEzWMu83olafimNiCXFIv7oNnadydA5jfussM2q2VkDQFk1eDZoZpSIAJa8ShywptTwfZFK5q04F7RN5W6IcNWGPyp/X5JxWwLWbSzaNDJ7B2rNmJ8MPUm1Rv+jI8p+cjg3OHz0K29j+Ef6KqnrlXgZ8DQz3cKxcuB5QaMHiDX+UoGbS/B4nTfBwzdUgztdFL9AOTpdBxRjz8aAIDW+fPL2FQ1KFEOj4Ckh890LktrYffGg5HR8sEapdj04e3VzNFqVZidslNu1QM4E9nNbrCQ==
Received: from BN9PR03CA0582.namprd03.prod.outlook.com (2603:10b6:408:10d::17)
 by BN8PR12MB3089.namprd12.prod.outlook.com (2603:10b6:408:40::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.24; Tue, 20 Apr
 2021 14:55:51 +0000
Received: from BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10d:cafe::77) by BN9PR03CA0582.outlook.office365.com
 (2603:10b6:408:10d::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend
 Transport; Tue, 20 Apr 2021 14:55:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT034.mail.protection.outlook.com (10.13.176.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 14:55:50 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Apr
 2021 14:55:48 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 08/10] mlxsw: spectrum_qdisc: Allocate child qdiscs dynamically
Date:   Tue, 20 Apr 2021 16:53:46 +0200
Message-ID: <5a980350a0e7869c9dd67b4dba3b41dd775db973.1618928119.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <cover.1618928118.git.petrm@nvidia.com>
References: <cover.1618928118.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3f4d7f1-fd12-4cd7-7506-08d9040c63e3
X-MS-TrafficTypeDiagnostic: BN8PR12MB3089:
X-Microsoft-Antispam-PRVS: <BN8PR12MB30892BB737B0423E8D8DC472D6489@BN8PR12MB3089.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PkIWN7o1kdO4WuwAhg5zkWJtUpraQTNHZqbI/Jb+1tkLdCPFDGLXfKlwYrOvKNaKhKDNQtmUhDE1c4mnsS82a7XqcGExRCl8K17xaXPvZKKZJWQmDP1w2xsh/bYIiKL1JKvWauZE47iGRIpCJN5IUREtWkzeL7EJDMt4VS71mf5Bkrz5v2PTaJDXGdmBrDqwVnT3DzWaBcWPUfbhODVutnNJjPK/lXrUsOA5XupxGlwke2YbN9+2tG9Y+3L53clW3mbKAvOuoadzAtic4r7fC/6PljLJbArR9JgaBz3Jnc0P4Om83PG91au+8sR9PITnrNQ59oJQ0cE4BvdqcP7hdZoGIV4ezbiVA1eFG2n6Wg3OzpaPGd1h03tGKP+BQa/909OR2afp0Rn5zqYK1e/sW/orr/KKbLgG8zS7KmVCrdpMtITL0VN1XzIUv3+ywbbe5KhGDXMXDVoEXNX0zX+1u+vQZCJ0RRCMfJFRdBQhJSH7YBx+yIgWAkCY+Rw8zJP0lB1l6/0rLaKc4N48OE+3A00Uymg+YMGzLNuExDDyiTIi9cIhAwRxCw5RMPRwgU6VnUaMTfSyKA54UyU6Q25o+NssQg/Tiu2CQB4j5dYJm+wuJyXrxfSr75//g0yR58CR0HpQXGxiGmMzDznGZGbfbDOpINVxq+zl8UM403EIpJ4=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(46966006)(36840700001)(4326008)(6916009)(2906002)(8936002)(82310400003)(54906003)(5660300002)(186003)(83380400001)(2616005)(336012)(47076005)(36860700001)(7636003)(478600001)(356005)(82740400003)(86362001)(426003)(70206006)(36756003)(8676002)(316002)(36906005)(107886003)(26005)(16526019)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 14:55:50.9866
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e3f4d7f1-fd12-4cd7-7506-08d9040c63e3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3089
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of keeping qdiscs in globally-preallocated arrays, introduce a
per-qdisc-kind value num_classes, and then allocate the necessary child
qdiscs (if any) based on that value. Since now dynamic allocation is
involved, mlxsw_sp_qdisc_replace() gets messy enough that it is worth it to
split it to two cases: a new qdisc allocation and a change of existing
qdisc. (Note that the change also includes what TC formally calls replace,
if the qdisc kind is the same.)

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 115 +++++++++++++-----
 1 file changed, 83 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 9e7f1a0188e8..03c131027fa7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -49,6 +49,7 @@ struct mlxsw_sp_qdisc_ops {
 			  struct mlxsw_sp_qdisc *mlxsw_sp_qdisc, void *params);
 	struct mlxsw_sp_qdisc *(*find_class)(struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 					     u32 parent);
+	unsigned int num_classes;
 };
 
 struct mlxsw_sp_qdisc {
@@ -74,7 +75,6 @@ struct mlxsw_sp_qdisc {
 
 struct mlxsw_sp_qdisc_state {
 	struct mlxsw_sp_qdisc root_qdisc;
-	struct mlxsw_sp_qdisc tclass_qdiscs[IEEE_8021QAZ_MAX_TCS];
 
 	/* When a PRIO or ETS are added, the invisible FIFOs in their bands are
 	 * created first. When notifications for these FIFOs arrive, it is not
@@ -215,29 +215,41 @@ mlxsw_sp_qdisc_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (mlxsw_sp_qdisc->ops->destroy)
 		err = mlxsw_sp_qdisc->ops->destroy(mlxsw_sp_port,
 						   mlxsw_sp_qdisc);
+	if (mlxsw_sp_qdisc->ops->clean_stats)
+		mlxsw_sp_qdisc->ops->clean_stats(mlxsw_sp_port, mlxsw_sp_qdisc);
 
 	mlxsw_sp_qdisc->handle = TC_H_UNSPEC;
 	mlxsw_sp_qdisc->ops = NULL;
-
+	mlxsw_sp_qdisc->num_classes = 0;
+	kfree(mlxsw_sp_qdisc->qdiscs);
+	mlxsw_sp_qdisc->qdiscs = NULL;
 	return err_hdroom ?: err;
 }
 
-static int
-mlxsw_sp_qdisc_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
-		       struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
-		       struct mlxsw_sp_qdisc_ops *ops, void *params)
+static int mlxsw_sp_qdisc_create(struct mlxsw_sp_port *mlxsw_sp_port,
+				 u32 handle,
+				 struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+				 struct mlxsw_sp_qdisc_ops *ops, void *params)
 {
 	struct mlxsw_sp_qdisc *root_qdisc = &mlxsw_sp_port->qdisc->root_qdisc;
 	struct mlxsw_sp_hdroom orig_hdroom;
+	unsigned int i;
 	int err;
 
-	if (mlxsw_sp_qdisc->ops && mlxsw_sp_qdisc->ops->type != ops->type)
-		/* In case this location contained a different qdisc of the
-		 * same type we can override the old qdisc configuration.
-		 * Otherwise, we need to remove the old qdisc before setting the
-		 * new one.
-		 */
-		mlxsw_sp_qdisc_destroy(mlxsw_sp_port, mlxsw_sp_qdisc);
+	err = ops->check_params(mlxsw_sp_port, params);
+	if (err)
+		return err;
+
+	if (ops->num_classes) {
+		mlxsw_sp_qdisc->qdiscs = kcalloc(ops->num_classes,
+						 sizeof(*mlxsw_sp_qdisc->qdiscs),
+						 GFP_KERNEL);
+		if (!mlxsw_sp_qdisc->qdiscs)
+			return -ENOMEM;
+
+		for (i = 0; i < ops->num_classes; i++)
+			mlxsw_sp_qdisc->qdiscs[i].parent = mlxsw_sp_qdisc;
+	}
 
 	orig_hdroom = *mlxsw_sp_port->hdroom;
 	if (root_qdisc == mlxsw_sp_qdisc) {
@@ -253,20 +265,46 @@ mlxsw_sp_qdisc_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 			goto err_hdroom_configure;
 	}
 
+	mlxsw_sp_qdisc->num_classes = ops->num_classes;
+	mlxsw_sp_qdisc->ops = ops;
+	mlxsw_sp_qdisc->handle = handle;
+	err = ops->replace(mlxsw_sp_port, handle, mlxsw_sp_qdisc, params);
+	if (err)
+		goto err_replace;
+
+	return 0;
+
+err_replace:
+	mlxsw_sp_qdisc->handle = TC_H_UNSPEC;
+	mlxsw_sp_qdisc->ops = NULL;
+	mlxsw_sp_qdisc->num_classes = 0;
+	mlxsw_sp_hdroom_configure(mlxsw_sp_port, &orig_hdroom);
+err_hdroom_configure:
+	kfree(mlxsw_sp_qdisc->qdiscs);
+	mlxsw_sp_qdisc->qdiscs = NULL;
+	return err;
+}
+
+static int
+mlxsw_sp_qdisc_change(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
+		      struct mlxsw_sp_qdisc *mlxsw_sp_qdisc, void *params)
+{
+	struct mlxsw_sp_qdisc_ops *ops = mlxsw_sp_qdisc->ops;
+	int err;
+
 	err = ops->check_params(mlxsw_sp_port, params);
 	if (err)
-		goto err_bad_param;
+		goto unoffload;
 
 	err = ops->replace(mlxsw_sp_port, handle, mlxsw_sp_qdisc, params);
 	if (err)
-		goto err_config;
+		goto unoffload;
 
 	/* Check if the Qdisc changed. That includes a situation where an
 	 * invisible Qdisc replaces another one, or is being added for the
 	 * first time.
 	 */
-	if (mlxsw_sp_qdisc->handle != handle || handle == TC_H_UNSPEC) {
-		mlxsw_sp_qdisc->ops = ops;
+	if (mlxsw_sp_qdisc->handle != handle) {
 		if (ops->clean_stats)
 			ops->clean_stats(mlxsw_sp_port, mlxsw_sp_qdisc);
 	}
@@ -274,17 +312,35 @@ mlxsw_sp_qdisc_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 	mlxsw_sp_qdisc->handle = handle;
 	return 0;
 
-err_bad_param:
-err_config:
-	mlxsw_sp_hdroom_configure(mlxsw_sp_port, &orig_hdroom);
-err_hdroom_configure:
-	if (mlxsw_sp_qdisc->handle == handle && ops->unoffload)
+unoffload:
+	if (ops->unoffload)
 		ops->unoffload(mlxsw_sp_port, mlxsw_sp_qdisc, params);
 
 	mlxsw_sp_qdisc_destroy(mlxsw_sp_port, mlxsw_sp_qdisc);
 	return err;
 }
 
+static int
+mlxsw_sp_qdisc_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
+		       struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+		       struct mlxsw_sp_qdisc_ops *ops, void *params)
+{
+	if (mlxsw_sp_qdisc->ops && mlxsw_sp_qdisc->ops->type != ops->type)
+		/* In case this location contained a different qdisc of the
+		 * same type we can override the old qdisc configuration.
+		 * Otherwise, we need to remove the old qdisc before setting the
+		 * new one.
+		 */
+		mlxsw_sp_qdisc_destroy(mlxsw_sp_port, mlxsw_sp_qdisc);
+
+	if (!mlxsw_sp_qdisc->ops)
+		return mlxsw_sp_qdisc_create(mlxsw_sp_port, handle,
+					     mlxsw_sp_qdisc, ops, params);
+	else
+		return mlxsw_sp_qdisc_change(mlxsw_sp_port, handle,
+					     mlxsw_sp_qdisc, params);
+}
+
 static int
 mlxsw_sp_qdisc_get_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 			 struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
@@ -1049,6 +1105,9 @@ __mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 					return err;
 			}
 		}
+
+		child_qdisc->tclass_num = tclass;
+
 		if (old_priomap != child_qdisc->prio_bitmap &&
 		    child_qdisc->ops && child_qdisc->ops->clean_stats) {
 			backlog = child_qdisc->stats_base.backlog;
@@ -1189,6 +1248,7 @@ static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_prio = {
 	.get_stats = mlxsw_sp_qdisc_get_prio_stats,
 	.clean_stats = mlxsw_sp_setup_tc_qdisc_prio_clean_stats,
 	.find_class = mlxsw_sp_qdisc_prio_find_class,
+	.num_classes = IEEE_8021QAZ_MAX_TCS,
 };
 
 static int
@@ -1239,6 +1299,7 @@ static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_ets = {
 	.get_stats = mlxsw_sp_qdisc_get_prio_stats,
 	.clean_stats = mlxsw_sp_setup_tc_qdisc_prio_clean_stats,
 	.find_class = mlxsw_sp_qdisc_prio_find_class,
+	.num_classes = IEEE_8021QAZ_MAX_TCS,
 };
 
 /* Linux allows linking of Qdiscs to arbitrary classes (so long as the resulting
@@ -1926,7 +1987,6 @@ int mlxsw_sp_setup_tc_block_qevent_early_drop(struct mlxsw_sp_port *mlxsw_sp_por
 int mlxsw_sp_tc_qdisc_init(struct mlxsw_sp_port *mlxsw_sp_port)
 {
 	struct mlxsw_sp_qdisc_state *qdisc_state;
-	int i;
 
 	qdisc_state = kzalloc(sizeof(*qdisc_state), GFP_KERNEL);
 	if (!qdisc_state)
@@ -1935,15 +1995,6 @@ int mlxsw_sp_tc_qdisc_init(struct mlxsw_sp_port *mlxsw_sp_port)
 	mutex_init(&qdisc_state->lock);
 	qdisc_state->root_qdisc.prio_bitmap = 0xff;
 	qdisc_state->root_qdisc.tclass_num = MLXSW_SP_PORT_DEFAULT_TCLASS;
-	qdisc_state->root_qdisc.qdiscs = qdisc_state->tclass_qdiscs;
-	qdisc_state->root_qdisc.num_classes = IEEE_8021QAZ_MAX_TCS;
-	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
-		int tclass_num = MLXSW_SP_PRIO_BAND_TO_TCLASS(i);
-
-		qdisc_state->tclass_qdiscs[i].tclass_num = tclass_num;
-		qdisc_state->tclass_qdiscs[i].parent = &qdisc_state->root_qdisc;
-	}
-
 	mlxsw_sp_port->qdisc = qdisc_state;
 	return 0;
 }
-- 
2.26.2

