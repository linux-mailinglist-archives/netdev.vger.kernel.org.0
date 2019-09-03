Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99D77A743D
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 22:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbfICUFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 16:05:45 -0400
Received: from mail-eopbgr130049.outbound.protection.outlook.com ([40.107.13.49]:2855
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727097AbfICUFo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 16:05:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tve4CKb+/PzBgi95IaMeoNX5+0nShvEsW4leOdFLmfPFMCiWMmE0fHU9VsqN44jafQUcuziRcULKuDd0XqYYRz4yViO3PQ+ZTPqsc7UzCWkVjobqBa6Mxzeiax7q02co/jLjAI2vPjkYlvrELMOmcAixlFecP7Hv62iyAFd8fXEuOVt9xqCd8duRcHWuczH3MCL8vE4kbfoM9N4Z58s5EBFVAcNaeaixQx6R+c8C9aLuNIZXFAaWGPCn6COmJlnvrEkh1AxKsVIL8rpvjwACE89k+3CFBASP7NyY95z1jRtylpuD/WvnZ467sJrYc/4awfhzCQfN8TZ3jIhEeKAHnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45zUTMG/spy0GUca5qoim7RcdMGHSQ0S6N+hsIpQxxM=;
 b=Cp1Ido3yITR4U6ZYMnoXWR/D6ssvL6tzGP0dmlGxvVMaVgnsRY3NMhgwK9CJKAERV3QkzyxEDZXaCrHWtZpMUIVAPajowJ3d9/aXzZ/0PWYHg1zueH5PeefO9s6vX5gJpNzh9BqljbJh6cz2I5VyIj593T8X2xL7WFjuJQa9O1tM9vF7edezFUXIavJda7mdLad42YuAM+Rd17b8XV6NOAJBZx9ktqxh20WuPBsJm+BHrD1/ZdkgWnTgX9zff12VhWBB6p42s/iiUFKBo/eUhsufdhav19Ci95RGZY9uLNhWKVEQOqddsS1h+hsio5RRfWU5OE7g6rndFnKm/RvyKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45zUTMG/spy0GUca5qoim7RcdMGHSQ0S6N+hsIpQxxM=;
 b=o0L+5QsmHCV1w+k1NzWDqMEZ1pC+gLlXl5rBKFXyhzR/Qse392VnIcYBSGUIhLdEr1e9mtsqRLPqNzSvX7UYzJMuYqvFb4cvTISaeX1FwRBcFj129/5hQzH+9tSrCoxTfZkDr3DUtV+X+G6DH4/z7SmZwrFtNVOxLOUlKABPMCU=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2706.eurprd05.prod.outlook.com (10.172.221.142) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.21; Tue, 3 Sep 2019 20:05:01 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Tue, 3 Sep 2019
 20:05:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 16/18] net/mlx5: Add API to set the namespace steering
 mode
Thread-Topic: [net-next V2 16/18] net/mlx5: Add API to set the namespace
 steering mode
Thread-Index: AQHVYpLe2uzr+SOxcUSZQhyNiFMKHg==
Date:   Tue, 3 Sep 2019 20:05:01 +0000
Message-ID: <20190903200409.14406-17-saeedm@mellanox.com>
References: <20190903200409.14406-1-saeedm@mellanox.com>
In-Reply-To: <20190903200409.14406-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0049.namprd02.prod.outlook.com
 (2603:10b6:a03:54::26) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 86e5f3bd-f128-48c0-6f2b-08d730aa00e8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2706;
x-ms-traffictypediagnostic: AM4PR0501MB2706:|AM4PR0501MB2706:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB270614A19AC6D6CFD62049A7BEB90@AM4PR0501MB2706.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(1496009)(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(199004)(189003)(2906002)(102836004)(256004)(26005)(11346002)(50226002)(186003)(66446008)(386003)(6506007)(64756008)(66556008)(14444005)(66476007)(71190400001)(66946007)(2616005)(476003)(76176011)(71200400001)(5660300002)(8936002)(66066001)(446003)(81166006)(81156014)(478600001)(54906003)(6916009)(8676002)(486006)(36756003)(3846002)(7736002)(53936002)(6436002)(305945005)(14454004)(6116002)(52116002)(6512007)(86362001)(316002)(99286004)(1076003)(6486002)(4326008)(107886003)(25786009)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2706;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KuxcnsmcuRMDp5Fm2wQsfBVRUHsV8kZkM3Q/CfHbgLhskkyY2jZW4GYB6DeS0HVihcBE+TRarZbSziWogN1PvjndEcCCs+pdFdb1GY8zEzAmjttWORT9a3OZT1ZqtfrctlplvGpDnDgvPsL+6flhCQM4+m8VP7tvY4wqkpR9wdeRpwvSEFB3KhMvNrGKQDXWbptlfINoMjzKetrh6ywz8ku0PCIPZkemKPtU0FYN+AXOWgeh0SL9ZhHWK2FEsqixrhimUDrPG/+qxQZ+sUdmBr3giRwjNG394MHC/HtEmG4K23DvZQbWc4x8l07NAFEpXZsqjdp99LhG4PQHKpb+Eoyk8e/oCypVCUf26AmG2HCypD5Lz+VIjrFriRHFZqIoJTlItRDJplnI9KK+bUvZqk4FnZabNgOIuSo9lwkDBJg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86e5f3bd-f128-48c0-6f2b-08d730aa00e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2019 20:05:01.5730
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hfYFO01dmz/CkjWUBG6+nBX9bw5o3l3p/03ZrsyQTr6nE53f93GCjx8OChm2SriRQlI4pSG926+QjcdYD7+HCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2706
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

Add API to set the flow steering root namesapce mode.
Setting new mode should be called before any steering operation
is executed on the namespace.
This API is going to be used by steering users such switchdev.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 49 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/fs_core.h | 12 ++++-
 2 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.c
index c2d6e9f4cb90..3bbb49354829 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2995,5 +2995,54 @@ EXPORT_SYMBOL(mlx5_packet_reformat_dealloc);
 int mlx5_flow_namespace_set_peer(struct mlx5_flow_root_namespace *ns,
 				 struct mlx5_flow_root_namespace *peer_ns)
 {
+	if (peer_ns && ns->mode !=3D peer_ns->mode) {
+		mlx5_core_err(ns->dev,
+			      "Can't peer namespace of different steering mode\n");
+		return -EINVAL;
+	}
+
 	return ns->cmds->set_peer(ns, peer_ns);
 }
+
+/* This function should be called only at init stage of the namespace.
+ * It is not safe to call this function while steering operations
+ * are executed in the namespace.
+ */
+int mlx5_flow_namespace_set_mode(struct mlx5_flow_namespace *ns,
+				 enum mlx5_flow_steering_mode mode)
+{
+	struct mlx5_flow_root_namespace *root;
+	const struct mlx5_flow_cmds *cmds;
+	int err;
+
+	root =3D find_root(&ns->node);
+	if (&root->ns !=3D ns)
+	/* Can't set cmds to non root namespace */
+		return -EINVAL;
+
+	if (root->table_type !=3D FS_FT_FDB)
+		return -EOPNOTSUPP;
+
+	if (root->mode =3D=3D mode)
+		return 0;
+
+	if (mode =3D=3D MLX5_FLOW_STEERING_MODE_SMFS)
+		cmds =3D mlx5_fs_cmd_get_dr_cmds();
+	else
+		cmds =3D mlx5_fs_cmd_get_fw_cmds();
+	if (!cmds)
+		return -EOPNOTSUPP;
+
+	err =3D cmds->create_ns(root);
+	if (err) {
+		mlx5_core_err(root->dev, "Failed to create flow namespace (%d)\n",
+			      err);
+		return err;
+	}
+
+	root->cmds->destroy_ns(root);
+	root->cmds =3D cmds;
+	root->mode =3D mode;
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.h
index a133ec5487ae..00717eba2256 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -98,9 +98,15 @@ enum fs_fte_status {
 	FS_FTE_STATUS_EXISTING =3D 1UL << 0,
 };
=20
+enum mlx5_flow_steering_mode {
+	MLX5_FLOW_STEERING_MODE_DMFS,
+	MLX5_FLOW_STEERING_MODE_SMFS
+};
+
 struct mlx5_flow_steering {
 	struct mlx5_core_dev *dev;
-	struct kmem_cache               *fgs_cache;
+	enum   mlx5_flow_steering_mode	mode;
+	struct kmem_cache		*fgs_cache;
 	struct kmem_cache               *ftes_cache;
 	struct mlx5_flow_root_namespace *root_ns;
 	struct mlx5_flow_root_namespace *fdb_root_ns;
@@ -235,6 +241,7 @@ struct mlx5_flow_group {
=20
 struct mlx5_flow_root_namespace {
 	struct mlx5_flow_namespace	ns;
+	enum   mlx5_flow_steering_mode	mode;
 	struct mlx5_fs_dr_domain	fs_dr_domain;
 	enum   fs_flow_table_type	table_type;
 	struct mlx5_core_dev		*dev;
@@ -258,6 +265,9 @@ const struct mlx5_flow_cmds *mlx5_fs_cmd_get_fw_cmds(vo=
id);
 int mlx5_flow_namespace_set_peer(struct mlx5_flow_root_namespace *ns,
 				 struct mlx5_flow_root_namespace *peer_ns);
=20
+int mlx5_flow_namespace_set_mode(struct mlx5_flow_namespace *ns,
+				 enum mlx5_flow_steering_mode mode);
+
 int mlx5_init_fs(struct mlx5_core_dev *dev);
 void mlx5_cleanup_fs(struct mlx5_core_dev *dev);
=20
--=20
2.21.0

