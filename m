Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 889B1A4FC2
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 09:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729764AbfIBHYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 03:24:31 -0400
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:61185
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729598AbfIBHYa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 03:24:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBMcGLlVP/Cy8vliByIZJbgy3o2bei2MSddQugA+hUk7ZN1IUtWYNqn895xYpl5Cql40tZb5Ht1PMqf72RR/sn3s1Z/ugsOlGMMzh/jMOqQYZ41wJlg0ZgOL4DCwovF2ns5Vw1d2Djd0t5KO19FiNz4U0N9qrfGWJhLWAr+Je3PQGlxaqTShm7EyxUnZaG/loWQEmuQPStxGKqOPCvF+DJ9H0CvEgkdOew+jTtRxLNbJpYPWj84s+pn69a8JBzRtM7VqYk6x1D0Wi0dlvhJGd0gc5RP7/TUMSZ/HEKuO7GgrRwMY8EA03J09EAbGjbCaZrdtWVQEtPM9Xv3cuooTzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45zUTMG/spy0GUca5qoim7RcdMGHSQ0S6N+hsIpQxxM=;
 b=lm39AiXfhZRfPfCtN31vyUzZ4Dns/7BtbNUa8SAj3b6dX3+6RDfx8yHM0eXQKuQSJmoTPAzLwYvtb6ivbhHd1KB4vP4rSPYlQSH7rYTVmFu7nHxk09AB68K5Pj+iZY57vVSE8ptVpSOsk8ofv754lD1stCHFakD/GW+BozGcQvLUJnTvF7VkdGlR4inbUTCwB5XzNZoufUFLaP+YqxgcG+xw4UEjGksN936b9tDqZcV7tzmErXwXtRXVA7IYzivPkJ5NSrIvZ7xtHWro59GbCrRWpJHvQpuidIo+OFRiba4JZwuSFKLRFjWMyRrabq9eBTEQDVKaEDFW3tZS2lpkSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45zUTMG/spy0GUca5qoim7RcdMGHSQ0S6N+hsIpQxxM=;
 b=s82M6KySgg1SKOuHGw6AtX6Ep/wQCyfy/G+xSip+Moqqz99gPrFpguOghXbJKZeZH0gPufp95EP89lCe5cq2lNUFOUwRgtyeSp8hW6oVtOUV2rZOB28aw0i3GpI6bDfb2F/PCbw1uQ/RCGL5cXrs4mCmzERIZcareMxLmD0pNu8=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2259.eurprd05.prod.outlook.com (10.165.38.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Mon, 2 Sep 2019 07:23:27 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Mon, 2 Sep 2019
 07:23:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 16/18] net/mlx5: Add API to set the namespace steering mode
Thread-Topic: [net-next 16/18] net/mlx5: Add API to set the namespace steering
 mode
Thread-Index: AQHVYV9QwEZsEtxoNEaCsp4LlIYASA==
Date:   Mon, 2 Sep 2019 07:23:27 +0000
Message-ID: <20190902072213.7683-17-saeedm@mellanox.com>
References: <20190902072213.7683-1-saeedm@mellanox.com>
In-Reply-To: <20190902072213.7683-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR11CA0085.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::26) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a00b3316-afbb-4198-d4fc-08d72f767292
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2259;
x-ms-traffictypediagnostic: AM4PR0501MB2259:|AM4PR0501MB2259:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB22591FA8BA36BA0BFABCFFC9BEBE0@AM4PR0501MB2259.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(1496009)(39860400002)(136003)(376002)(346002)(396003)(366004)(199004)(189003)(64756008)(478600001)(66946007)(66556008)(71190400001)(71200400001)(6916009)(5660300002)(54906003)(6486002)(8676002)(14454004)(81156014)(36756003)(81166006)(76176011)(1076003)(186003)(50226002)(99286004)(25786009)(4326008)(8936002)(316002)(102836004)(386003)(6506007)(2906002)(26005)(14444005)(3846002)(256004)(6116002)(2616005)(66066001)(86362001)(53936002)(52116002)(107886003)(486006)(6436002)(305945005)(7736002)(6512007)(446003)(476003)(66446008)(11346002)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2259;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: oUgNPQfbV61EagHNtyGLXg/gm4KqFIiZmf51Q+VNplORhXPBdhGAnHwhzn+7DY1lq1O53tkzNBep/5gPu6XcG8Z3IcGtuMRaqLSd6who6IkPESJaFihb+HzYei0wE+ZkqGvczu95eoatFDSk5dXRkDswWU0C0gdjtWxax62d/w5YaCdpG+ZmRrNxrJOqwYYBFde7kjf2i4LQoDnwWhAUy09kzAIczwvUv23bqAVoGFT+S+dXIFfweGi5U6agoli5Q4sa81kGYFq7UjMA7Zk58B3ADM08GoET1YgyKZouKjXnryOvMFrEBKYkCmmSb9IbzeOWv2hldsjUalNcDsKXBv757vRwA4lu1f6k2chfEsU8rJfQG512RdiT4CFeE9L2RhhNLMCTdmm8wcufFPPl9mtWFogBMmjb4iQnngsehFk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a00b3316-afbb-4198-d4fc-08d72f767292
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2019 07:23:27.3215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2kjr0cfkiBRI0VPJIJ2ZKScQAyNIMSRhZ7r3LsL20rgZQGzS0kYd7MAUBQocO+7dg+DEViAnyR23tUHfsQK+Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2259
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

