Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEBF814008A
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 01:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387418AbgAQAHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 19:07:22 -0500
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:19560
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387998AbgAQAHS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 19:07:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J6cZ6tRZMy5vFFBF0PnkfYV/I8O+/K+HzkQeF4/OaFAHnPNFGHk3w7sz9mKRlwzAJ/TxxZkCKy4ZcZtKpgb++yiMbs/sCNotqbeYNtvfFcnkdexk3dgQVQnArjt2KIH6mBQewKSGXSYy1/FI8A4Vw4NFbdGl4yJzpy116p4neLHz4jWkSR4pKHJiwOorQmpyGWS422H3SZ+pJ3c/O7UMOf2qD2DUl30Snp4GCPJjjF7IgW/vbzApJVuC1gm0tjbztwVGPRhF2ionnYexf1ScvHh6iIvUKB+g3zcNHaaP0KiKStDZNM/VKU2pmDOSLLefhsu3K5BtXEiCHDqAO5PNzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9kv7zBtBB/2+ZwEGOFHmzi41NJ5RrR2CkFXiuBYdUQ0=;
 b=QjNiiavII03yC3UKOt1Lgx4LmrEa1ueLX5WHcRDf3r6ZxkPF6iX/NL+76VuHf5ESl6r8BaEcjiphhl3IpcLQnN2DXMS80+pVBngtZ3+PuqoyFhmPSTQkyCXm5K2NgnnmCGfpqGtSkEm+4e1cqf1lk056Qn7DLJqs/QLP4zT82lUYHG2ITKc5Xi1YSLSwfTHHYtLiN/tOs0+xFl2QDWXURzw3NYQzzhvTzArquc5qrOtLV+nYvcSD8Brj18rVCYyEVasxhHjcRrgd16pDCTOs3KB5xuvltLYnp3zT+wNbBmc8IERs99xV/sdMpvi+jxMmsN3uUDW5Lw3bMZTvJvP7bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9kv7zBtBB/2+ZwEGOFHmzi41NJ5RrR2CkFXiuBYdUQ0=;
 b=dHUK+8RNecmfJRwJ3W25K03Zz3XbQKoTa6Zhz5G+wcMhGfzHJR+cIvP3RvYW753dJeLdB/qb/hBR5ptmkjhsHS3CRlClTNcNmML5OeFnqZeD/W3EIfdgH9ewXCqObhMNP33Uv//Nj3f/mPns7cLcvAGeq1cF9WwLxoW+zg4dlZE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4990.eurprd05.prod.outlook.com (20.177.49.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Fri, 17 Jan 2020 00:07:11 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.015; Fri, 17 Jan 2020
 00:07:10 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR03CA0003.namprd03.prod.outlook.com (2603:10b6:a02:a8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Fri, 17 Jan 2020 00:07:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [mlx5-next 09/16] net/mlx5: Refactor
 mlx5_create_auto_grouped_flow_table
Thread-Topic: [mlx5-next 09/16] net/mlx5: Refactor
 mlx5_create_auto_grouped_flow_table
Thread-Index: AQHVzMoQifuYTC7HKUunVupsVpSDUQ==
Date:   Fri, 17 Jan 2020 00:07:10 +0000
Message-ID: <20200117000619.696775-10-saeedm@mellanox.com>
References: <20200117000619.696775-1-saeedm@mellanox.com>
In-Reply-To: <20200117000619.696775-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::16) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0935ff31-ccfc-4b9f-800e-08d79ae132cd
x-ms-traffictypediagnostic: VI1PR05MB4990:|VI1PR05MB4990:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB499003BEB0F5E62778AA1784BE310@VI1PR05MB4990.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(189003)(199004)(64756008)(6512007)(52116002)(66476007)(26005)(81166006)(86362001)(16526019)(316002)(81156014)(8676002)(2616005)(66556008)(186003)(6486002)(956004)(71200400001)(36756003)(508600001)(66446008)(54906003)(1076003)(5660300002)(2906002)(6506007)(4326008)(110136005)(8936002)(66946007)(6666004)(107886003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4990;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pAHqsm6VxY1tY49tlyO77CVN2TYfU4luMd5jbPOx2k9o/JQ96aNsl4saOHSdg/c0B6C5lbfvlVOjPO8zdFVJSFFqGVGt9OIZ7CQliYdO3UCd863QSDEZc4cgMFRtpYLkNqEaUtxZFotOqLAolAceNWY1Ci68wZAFltg/Pfenp+GcLOZwTfx45IeCkzlvlC3IwgdMyPGxz8mcVx1H80wyt45nssm6petlRiETDzH46QMYOkABJD5hXXRit5y6xRb7rsWgeBPYvldsDx7AY6X5IEWH6x3YzJgWt7p5KPCDouJ6nQf4cL9PWckiDGbGcyhroxcjU3/9Fz8ZaGuovbGffHYT9mJgjlA71BWkmarN9GyxTMGVhvE9I9RYwqaD6uYjZwaf11Pv3i6aovl8uhwHTTnBbijEykKo+2IMYZG9UVAIP3tw0Sd9KiFnIMDAAU26rOqy3QukbHexvJcSqpoXERwX9IXT5bLuw26Pz/6P+PtiAYXHdjitCpiqvvKSSUFSKWfeo2ijcdW1yKQWLcp/M2+mmgsPnNetqEb0J4CRVv0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0935ff31-ccfc-4b9f-800e-08d79ae132cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 00:07:10.8830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3VxNEWFh8PlXAJ2qGx83H9nrhbzwXwc8WQcuiK+HzgCgWJkgB00hNhdhUXLvytItfmUMN8hJ00reA2D8wHGgNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4990
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Refactor mlx5_create_auto_grouped_flow_table() to use ft_attr param
which already carries the max_fte, prio and flags memebers, and is
used the same in similar mlx5_create_flow_table() function.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c             | 10 +++++----
 .../mellanox/mlx5/core/en_fs_ethtool.c        |  9 +++++---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 13 +++++++-----
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  7 +++++--
 .../mellanox/mlx5/core/eswitch_offloads.c     | 13 ++++++------
 .../mlx5/core/eswitch_offloads_termtbl.c      | 11 +++++-----
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 21 ++++++-------------
 include/linux/mlx5/fs.h                       | 16 +++++++-------
 8 files changed, 52 insertions(+), 48 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5=
/main.c
index 997cbfe4b90c..90489c5f0c6f 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3276,12 +3276,14 @@ static struct mlx5_ib_flow_prio *_get_prio(struct m=
lx5_flow_namespace *ns,
 					   int num_entries, int num_groups,
 					   u32 flags)
 {
+	struct mlx5_flow_table_attr ft_attr =3D {};
 	struct mlx5_flow_table *ft;
=20
-	ft =3D mlx5_create_auto_grouped_flow_table(ns, priority,
-						 num_entries,
-						 num_groups,
-						 0, flags);
+	ft_attr.prio =3D priority;
+	ft_attr.max_fte =3D num_entries;
+	ft_attr.flags =3D flags;
+	ft_attr.autogroup.max_num_groups =3D num_groups;
+	ft =3D mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
 	if (IS_ERR(ft))
 		return ERR_CAST(ft);
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c b/driv=
ers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
index acd946f2ddbe..3bc2ac3d53fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
@@ -58,6 +58,7 @@ static struct mlx5e_ethtool_table *get_flow_table(struct =
mlx5e_priv *priv,
 						  struct ethtool_rx_flow_spec *fs,
 						  int num_tuples)
 {
+	struct mlx5_flow_table_attr ft_attr =3D {};
 	struct mlx5e_ethtool_table *eth_ft;
 	struct mlx5_flow_namespace *ns;
 	struct mlx5_flow_table *ft;
@@ -102,9 +103,11 @@ static struct mlx5e_ethtool_table *get_flow_table(stru=
ct mlx5e_priv *priv,
 	table_size =3D min_t(u32, BIT(MLX5_CAP_FLOWTABLE(priv->mdev,
 						       flow_table_properties_nic_receive.log_max_ft_size)),
 			   MLX5E_ETHTOOL_NUM_ENTRIES);
-	ft =3D mlx5_create_auto_grouped_flow_table(ns, prio,
-						 table_size,
-						 MLX5E_ETHTOOL_NUM_GROUPS, 0, 0);
+
+	ft_attr.prio =3D prio;
+	ft_attr.max_fte =3D table_size;
+	ft_attr.autogroup.max_num_groups =3D MLX5E_ETHTOOL_NUM_GROUPS;
+	ft =3D mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
 	if (IS_ERR(ft))
 		return (void *)ft;
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index db614bd6bd1f..5aafbb8d2e8e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -960,7 +960,8 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
=20
 	mutex_lock(&priv->fs.tc.t_lock);
 	if (IS_ERR_OR_NULL(priv->fs.tc.t)) {
-		int tc_grp_size, tc_tbl_size;
+		struct mlx5_flow_table_attr ft_attr =3D {};
+		int tc_grp_size, tc_tbl_size, tc_num_grps;
 		u32 max_flow_counter;
=20
 		max_flow_counter =3D (MLX5_CAP_GEN(dev, max_flow_counter_31_16) << 16) |
@@ -970,13 +971,15 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
=20
 		tc_tbl_size =3D min_t(int, tc_grp_size * MLX5E_TC_TABLE_NUM_GROUPS,
 				    BIT(MLX5_CAP_FLOWTABLE_NIC_RX(dev, log_max_ft_size)));
+		tc_num_grps =3D MLX5E_TC_TABLE_NUM_GROUPS;
=20
+		ft_attr.prio =3D MLX5E_TC_PRIO;
+		ft_attr.max_fte =3D tc_tbl_size;
+		ft_attr.level =3D MLX5E_TC_FT_LEVEL;
+		ft_attr.autogroup.max_num_groups =3D tc_num_grps;
 		priv->fs.tc.t =3D
 			mlx5_create_auto_grouped_flow_table(priv->fs.ns,
-							    MLX5E_TC_PRIO,
-							    tc_tbl_size,
-							    MLX5E_TC_TABLE_NUM_GROUPS,
-							    MLX5E_TC_FT_LEVEL, 0);
+							    &ft_attr);
 		if (IS_ERR(priv->fs.tc.t)) {
 			mutex_unlock(&priv->fs.tc.t_lock);
 			NL_SET_ERR_MSG_MOD(extack,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 2c965ad0d744..05b13a1e829c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -277,6 +277,7 @@ enum {
=20
 static int esw_create_legacy_vepa_table(struct mlx5_eswitch *esw)
 {
+	struct mlx5_flow_table_attr ft_attr =3D {};
 	struct mlx5_core_dev *dev =3D esw->dev;
 	struct mlx5_flow_namespace *root_ns;
 	struct mlx5_flow_table *fdb;
@@ -289,8 +290,10 @@ static int esw_create_legacy_vepa_table(struct mlx5_es=
witch *esw)
 	}
=20
 	/* num FTE 2, num FG 2 */
-	fdb =3D mlx5_create_auto_grouped_flow_table(root_ns, LEGACY_VEPA_PRIO,
-						  2, 2, 0, 0);
+	ft_attr.prio =3D LEGACY_VEPA_PRIO;
+	ft_attr.max_fte =3D 2;
+	ft_attr.autogroup.max_num_groups =3D 2;
+	fdb =3D mlx5_create_auto_grouped_flow_table(root_ns, &ft_attr);
 	if (IS_ERR(fdb)) {
 		err =3D PTR_ERR(fdb);
 		esw_warn(dev, "Failed to create VEPA FDB err %d\n", err);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 243a5440867e..4b0d992263b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -904,6 +904,7 @@ create_next_size_table(struct mlx5_eswitch *esw,
 		       int level,
 		       u32 flags)
 {
+	struct mlx5_flow_table_attr ft_attr =3D {};
 	struct mlx5_flow_table *fdb;
 	int sz;
=20
@@ -911,12 +912,12 @@ create_next_size_table(struct mlx5_eswitch *esw,
 	if (!sz)
 		return ERR_PTR(-ENOSPC);
=20
-	fdb =3D mlx5_create_auto_grouped_flow_table(ns,
-						  table_prio,
-						  sz,
-						  ESW_OFFLOADS_NUM_GROUPS,
-						  level,
-						  flags);
+	ft_attr.max_fte =3D sz;
+	ft_attr.prio =3D table_prio;
+	ft_attr.level =3D level;
+	ft_attr.flags =3D flags;
+	ft_attr.autogroup.max_num_groups =3D ESW_OFFLOADS_NUM_GROUPS;
+	fdb =3D mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
 	if (IS_ERR(fdb)) {
 		esw_warn(esw->dev, "Failed to create FDB Table err %d (table prio: %d, l=
evel: %d, size: %d)\n",
 			 (int)PTR_ERR(fdb), table_prio, level, sz);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termt=
bl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index 366bda1bb1c3..dc08ed9339ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -50,8 +50,8 @@ mlx5_eswitch_termtbl_create(struct mlx5_core_dev *dev,
 			    struct mlx5_flow_act *flow_act)
 {
 	static const struct mlx5_flow_spec spec =3D {};
+	struct mlx5_flow_table_attr ft_attr =3D {};
 	struct mlx5_flow_namespace *root_ns;
-	int prio, flags;
 	int err;
=20
 	root_ns =3D mlx5_get_flow_namespace(dev, MLX5_FLOW_NAMESPACE_FDB);
@@ -63,10 +63,11 @@ mlx5_eswitch_termtbl_create(struct mlx5_core_dev *dev,
 	/* As this is the terminating action then the termination table is the
 	 * same prio as the slow path
 	 */
-	prio =3D FDB_SLOW_PATH;
-	flags =3D MLX5_FLOW_TABLE_TERMINATION;
-	tt->termtbl =3D mlx5_create_auto_grouped_flow_table(root_ns, prio, 1, 1,
-							  0, flags);
+	ft_attr.flags =3D MLX5_FLOW_TABLE_TERMINATION;
+	ft_attr.prio =3D FDB_SLOW_PATH;
+	ft_attr.max_fte =3D 1;
+	ft_attr.autogroup.max_num_groups =3D 1;
+	tt->termtbl =3D mlx5_create_auto_grouped_flow_table(root_ns, &ft_attr);
 	if (IS_ERR(tt->termtbl)) {
 		esw_warn(dev, "Failed to create termination table\n");
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.c
index 8c5df6c7d7b6..51913e2cde5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1103,31 +1103,22 @@ EXPORT_SYMBOL(mlx5_create_lag_demux_flow_table);
=20
 struct mlx5_flow_table*
 mlx5_create_auto_grouped_flow_table(struct mlx5_flow_namespace *ns,
-				    int prio,
-				    int num_flow_table_entries,
-				    int max_num_groups,
-				    u32 level,
-				    u32 flags)
+				    struct mlx5_flow_table_attr *ft_attr)
 {
-	struct mlx5_flow_table_attr ft_attr =3D {};
 	struct mlx5_flow_table *ft;
=20
-	if (max_num_groups > num_flow_table_entries)
+	if (ft_attr->autogroup.max_num_groups > ft_attr->max_fte)
 		return ERR_PTR(-EINVAL);
=20
-	ft_attr.max_fte =3D num_flow_table_entries;
-	ft_attr.prio    =3D prio;
-	ft_attr.level   =3D level;
-	ft_attr.flags   =3D flags;
-
-	ft =3D mlx5_create_flow_table(ns, &ft_attr);
+	ft =3D mlx5_create_flow_table(ns, ft_attr);
 	if (IS_ERR(ft))
 		return ft;
=20
 	ft->autogroup.active =3D true;
-	ft->autogroup.required_groups =3D max_num_groups;
+	ft->autogroup.required_groups =3D ft_attr->autogroup.max_num_groups;
 	/* We save place for flow groups in addition to max types */
-	ft->autogroup.group_size =3D ft->max_fte / (max_num_groups + 1);
+	ft->autogroup.group_size =3D ft->max_fte /
+				   (ft->autogroup.required_groups + 1);
=20
 	return ft;
 }
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 4e5b84e66822..a3f8b63839de 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -145,25 +145,25 @@ mlx5_get_flow_vport_acl_namespace(struct mlx5_core_de=
v *dev,
 				  enum mlx5_flow_namespace_type type,
 				  int vport);
=20
-struct mlx5_flow_table *
-mlx5_create_auto_grouped_flow_table(struct mlx5_flow_namespace *ns,
-				    int prio,
-				    int num_flow_table_entries,
-				    int max_num_groups,
-				    u32 level,
-				    u32 flags);
-
 struct mlx5_flow_table_attr {
 	int prio;
 	int max_fte;
 	u32 level;
 	u32 flags;
+
+	struct {
+		int max_num_groups;
+	} autogroup;
 };
=20
 struct mlx5_flow_table *
 mlx5_create_flow_table(struct mlx5_flow_namespace *ns,
 		       struct mlx5_flow_table_attr *ft_attr);
=20
+struct mlx5_flow_table *
+mlx5_create_auto_grouped_flow_table(struct mlx5_flow_namespace *ns,
+				    struct mlx5_flow_table_attr *ft_attr);
+
 struct mlx5_flow_table *
 mlx5_create_vport_flow_table(struct mlx5_flow_namespace *ns,
 			     int prio,
--=20
2.24.1

