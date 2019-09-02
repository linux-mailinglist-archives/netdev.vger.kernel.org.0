Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD301A4FC1
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 09:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbfIBHY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 03:24:27 -0400
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:61185
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729635AbfIBHY1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 03:24:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iGg7NgGsq3i/elkKpldAeTMinNyVK17Jy9NBvwbCAm8BtZbjH6+f2qnELEgS/wxMR+dC/F2ox23L6NHXedKYWRvm3Cw8xG9wCZ6cSkDX3DTi51zuBAEfMHkN4Z1c5DI84fQQYJtV4NOPDYT9pT2VI6O4vWPT9YPH6CGfGkh7AhhZqLt/pH6zPPmKxofZ69H3b/fRL8wUVnpqz2rwZzLyqYPAXsERqQTfSvBLyzcSuHKxd+y9nsR5AtJzh22VgcmbT3FJiY78TJtf2nx+M7od+Bl9X6w9J9aN005SetOHUlgG9tH02bWPG0Ki5ATZJPBizIdapSQZT/fuckPzH6ex7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=csFuY0E3pQbay3XW+hqLhPzEZkOTba4jnM9cUltYhng=;
 b=K960yRtXxs330I+ODRgd5He6KEC7XFsrwSr9Y6kAJxgJwT1UAilaR+c7qJTfluDCdhhcB9L0SI87zxDp5SlAEBz0+cyfsvYZUs22CMgvRCM4vI3yW+9ouHHIGzRAi+k0L47df2LTMLCFh8nZm0nbPXNCjgdzYxP6xFYe4Tj1q6hUPNpNH4W3omYcjeQVIW01QoaDbjzLuYSh5NOfVIaB8kXcfX/wM141SrzZDNuHpto/8BFIN7+FOBaJcSphgEXoR35spMIbkXvsccbb7Q2BZb4uiFlJVXHHoSDWLxOsoGFO9qYu4ziIcZDUOoArYxZNmt+p+139pN1leqke2kYJbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=csFuY0E3pQbay3XW+hqLhPzEZkOTba4jnM9cUltYhng=;
 b=UN5LVWAiN1iSU+C9UKczRxLe7uRmhbLsTQojsnD1sQA4/cG5qa0LtpRXWpU5Opgwca2xMsDng4yT0CtDs2DLWWhcRjon0J4UUD9490P2kz1FbB1UrGF+ookVgvmBlFCgvG7Esa6UuavD/iq7AhTVPVTfcqf00tUwgOeWINmCTL4=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2259.eurprd05.prod.outlook.com (10.165.38.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Mon, 2 Sep 2019 07:23:24 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Mon, 2 Sep 2019
 07:23:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 15/18] net/mlx5: Add direct rule fs_cmd implementation
Thread-Topic: [net-next 15/18] net/mlx5: Add direct rule fs_cmd implementation
Thread-Index: AQHVYV9OTG6pwd+TgU2nNyxMniXlPw==
Date:   Mon, 2 Sep 2019 07:23:24 +0000
Message-ID: <20190902072213.7683-16-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: c1eed356-bf62-4baa-0b7d-08d72f7670ec
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2259;
x-ms-traffictypediagnostic: AM4PR0501MB2259:|AM4PR0501MB2259:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB225909E40C7A447F1D1B97BDBEBE0@AM4PR0501MB2259.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(1496009)(39860400002)(136003)(376002)(346002)(396003)(366004)(199004)(189003)(64756008)(478600001)(66946007)(66556008)(71190400001)(71200400001)(6916009)(5660300002)(54906003)(6486002)(8676002)(14454004)(81156014)(36756003)(81166006)(76176011)(1076003)(186003)(50226002)(99286004)(25786009)(4326008)(8936002)(316002)(30864003)(102836004)(386003)(6506007)(2906002)(26005)(14444005)(3846002)(256004)(6116002)(2616005)(66066001)(86362001)(53936002)(52116002)(53946003)(107886003)(486006)(6436002)(305945005)(7736002)(6512007)(446003)(476003)(66446008)(11346002)(66476007)(579004)(559001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2259;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WboOcyBBxf+Bt4tJTMgy5c9jS/CcQsKi4RspdDTCDkrRLx5Zi+iC80qTCparNx1JhI78CrH0kyzryijxgaGQv/05nmhOwRl4Gq9ejR+noYiEVH7ve+uBawCAYGIbll5Xs6+RzQM5MoW8XzGak0wcmpzUJEilTOdtZka89k0eTiZchObC809mh6YBZknPA8XhCdQYbYfpzj8SntESqt2x2S0iVZ9RyS9xcWyskvzLDze71Ro5nbRfc+LWvdRxfEEjGZcwQZUdqPjpr8MbKHz6C9nHtuNaK2KCxQ6+LqUbV/zKoR1z0Ug3oko6UEmfqeeppSM8GWCMiFCskJw4X29UKIi7FkHqtQoXCHrz1vPMuscLXdaPA1Oqv6L/aoO+kM1L3l8oNg/aRGrllRWYq8RVahjVQLPdd9LSrPCTntFvtqQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1eed356-bf62-4baa-0b7d-08d72f7670ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2019 07:23:24.7146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5oE+yHyhNh7P1erP70L8BGmxOv0n6zl4bc3GPLOy9ROMLE07bJ+Ipp9RLzWb8MUaG2Hm0Aw1WTUbojI6wxNOLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2259
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

Add support to create flow steering objects
via direct rule API (SW steering).
New layer is added - fs_dr, this layer translates the command that
fs_core sends to the FW into direct rule API. In case that direct
rule is not supported in some feature then -EOPNOTSUPP is
returned.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  28 +-
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.h  |   7 +
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |   6 +
 .../net/ethernet/mellanox/mlx5/core/fs_core.h |  20 +-
 .../mellanox/mlx5/core/steering/fs_dr.c       | 600 ++++++++++++++++++
 .../mellanox/mlx5/core/steering/fs_dr.h       |  60 ++
 7 files changed, 717 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.=
c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.=
h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net=
/ethernet/mellanox/mlx5/core/Makefile
index 716558476eda..5708fcc079ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -73,4 +73,4 @@ mlx5_core-$(CONFIG_MLX5_SW_STEERING) +=3D steering/dr_dom=
ain.o steering/dr_table.o
 					steering/dr_icm_pool.o steering/dr_crc32.o \
 					steering/dr_ste.o steering/dr_send.o \
 					steering/dr_cmd.o steering/dr_fw.o \
-					steering/dr_action.o
+					steering/dr_action.o steering/fs_dr.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net=
/ethernet/mellanox/mlx5/core/fs_cmd.c
index 488f50dfb404..579c306caa7b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -135,6 +135,22 @@ static void mlx5_cmd_stub_modify_header_dealloc(struct=
 mlx5_flow_root_namespace
 {
 }
=20
+static int mlx5_cmd_stub_set_peer(struct mlx5_flow_root_namespace *ns,
+				  struct mlx5_flow_root_namespace *peer_ns)
+{
+	return 0;
+}
+
+static int mlx5_cmd_stub_create_ns(struct mlx5_flow_root_namespace *ns)
+{
+	return 0;
+}
+
+static int mlx5_cmd_stub_destroy_ns(struct mlx5_flow_root_namespace *ns)
+{
+	return 0;
+}
+
 static int mlx5_cmd_update_root_ft(struct mlx5_flow_root_namespace *ns,
 				   struct mlx5_flow_table *ft, u32 underlay_qpn,
 				   bool disconnect)
@@ -838,7 +854,10 @@ static const struct mlx5_flow_cmds mlx5_flow_cmds =3D =
{
 	.packet_reformat_alloc =3D mlx5_cmd_packet_reformat_alloc,
 	.packet_reformat_dealloc =3D mlx5_cmd_packet_reformat_dealloc,
 	.modify_header_alloc =3D mlx5_cmd_modify_header_alloc,
-	.modify_header_dealloc =3D mlx5_cmd_modify_header_dealloc
+	.modify_header_dealloc =3D mlx5_cmd_modify_header_dealloc,
+	.set_peer =3D mlx5_cmd_stub_set_peer,
+	.create_ns =3D mlx5_cmd_stub_create_ns,
+	.destroy_ns =3D mlx5_cmd_stub_destroy_ns,
 };
=20
 static const struct mlx5_flow_cmds mlx5_flow_cmd_stubs =3D {
@@ -854,10 +873,13 @@ static const struct mlx5_flow_cmds mlx5_flow_cmd_stub=
s =3D {
 	.packet_reformat_alloc =3D mlx5_cmd_stub_packet_reformat_alloc,
 	.packet_reformat_dealloc =3D mlx5_cmd_stub_packet_reformat_dealloc,
 	.modify_header_alloc =3D mlx5_cmd_stub_modify_header_alloc,
-	.modify_header_dealloc =3D mlx5_cmd_stub_modify_header_dealloc
+	.modify_header_dealloc =3D mlx5_cmd_stub_modify_header_dealloc,
+	.set_peer =3D mlx5_cmd_stub_set_peer,
+	.create_ns =3D mlx5_cmd_stub_create_ns,
+	.destroy_ns =3D mlx5_cmd_stub_destroy_ns,
 };
=20
-static const struct mlx5_flow_cmds *mlx5_fs_cmd_get_fw_cmds(void)
+const struct mlx5_flow_cmds *mlx5_fs_cmd_get_fw_cmds(void)
 {
 	return &mlx5_flow_cmds;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h b/drivers/net=
/ethernet/mellanox/mlx5/core/fs_cmd.h
index 3268654d6748..d62de642eca9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
@@ -93,6 +93,12 @@ struct mlx5_flow_cmds {
=20
 	void (*modify_header_dealloc)(struct mlx5_flow_root_namespace *ns,
 				      struct mlx5_modify_hdr *modify_hdr);
+
+	int (*set_peer)(struct mlx5_flow_root_namespace *ns,
+			struct mlx5_flow_root_namespace *peer_ns);
+
+	int (*create_ns)(struct mlx5_flow_root_namespace *ns);
+	int (*destroy_ns)(struct mlx5_flow_root_namespace *ns);
 };
=20
 int mlx5_cmd_fc_alloc(struct mlx5_core_dev *dev, u32 *id);
@@ -108,5 +114,6 @@ int mlx5_cmd_fc_bulk_query(struct mlx5_core_dev *dev, u=
32 base_id, int bulk_len,
 			   u32 *out);
=20
 const struct mlx5_flow_cmds *mlx5_fs_cmd_get_default(enum fs_flow_table_ty=
pe type);
+const struct mlx5_flow_cmds *mlx5_fs_cmd_get_fw_cmds(void);
=20
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.c
index 1d2333fd3080..c2d6e9f4cb90 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2991,3 +2991,9 @@ void mlx5_packet_reformat_dealloc(struct mlx5_core_de=
v *dev,
 	kfree(pkt_reformat);
 }
 EXPORT_SYMBOL(mlx5_packet_reformat_dealloc);
+
+int mlx5_flow_namespace_set_peer(struct mlx5_flow_root_namespace *ns,
+				 struct mlx5_flow_root_namespace *peer_ns)
+{
+	return ns->cmds->set_peer(ns, peer_ns);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.h
index ea0f221685ab..a133ec5487ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -37,16 +37,23 @@
 #include <linux/mlx5/fs.h>
 #include <linux/rhashtable.h>
 #include <linux/llist.h>
+#include <steering/fs_dr.h>
=20
 struct mlx5_modify_hdr {
 	enum mlx5_flow_namespace_type ns_type;
-	u32 id;
+	union {
+		struct mlx5_fs_dr_action action;
+		u32 id;
+	};
 };
=20
 struct mlx5_pkt_reformat {
 	enum mlx5_flow_namespace_type ns_type;
 	int reformat_type; /* from mlx5_ifc */
-	u32 id;
+	union {
+		struct mlx5_fs_dr_action action;
+		u32 id;
+	};
 };
=20
 /* FS_TYPE_PRIO_CHAINS is a PRIO that will have namespaces only,
@@ -139,6 +146,7 @@ struct mlx5_flow_handle {
 /* Type of children is mlx5_flow_group */
 struct mlx5_flow_table {
 	struct fs_node			node;
+	struct mlx5_fs_dr_table		fs_dr_table;
 	u32				id;
 	u16				vport;
 	unsigned int			max_fte;
@@ -179,6 +187,7 @@ struct mlx5_ft_underlay_qp {
 /* Type of children is mlx5_flow_rule */
 struct fs_fte {
 	struct fs_node			node;
+	struct mlx5_fs_dr_rule		fs_dr_rule;
 	u32				val[MLX5_ST_SZ_DW_MATCH_PARAM];
 	u32				dests_size;
 	u32				index;
@@ -214,6 +223,7 @@ struct mlx5_flow_group_mask {
 /* Type of children is fs_fte */
 struct mlx5_flow_group {
 	struct fs_node			node;
+	struct mlx5_fs_dr_matcher	fs_dr_matcher;
 	struct mlx5_flow_group_mask	mask;
 	u32				start_index;
 	u32				max_ftes;
@@ -225,6 +235,7 @@ struct mlx5_flow_group {
=20
 struct mlx5_flow_root_namespace {
 	struct mlx5_flow_namespace	ns;
+	struct mlx5_fs_dr_domain	fs_dr_domain;
 	enum   fs_flow_table_type	table_type;
 	struct mlx5_core_dev		*dev;
 	struct mlx5_flow_table		*root_ft;
@@ -242,6 +253,11 @@ void mlx5_fc_queue_stats_work(struct mlx5_core_dev *de=
v,
 void mlx5_fc_update_sampling_interval(struct mlx5_core_dev *dev,
 				      unsigned long interval);
=20
+const struct mlx5_flow_cmds *mlx5_fs_cmd_get_fw_cmds(void);
+
+int mlx5_flow_namespace_set_peer(struct mlx5_flow_root_namespace *ns,
+				 struct mlx5_flow_root_namespace *peer_ns);
+
 int mlx5_init_fs(struct mlx5_core_dev *dev);
 void mlx5_cleanup_fs(struct mlx5_core_dev *dev);
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
new file mode 100644
index 000000000000..3d587d0bdbbe
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -0,0 +1,600 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2019 Mellanox Technologies */
+
+#include "mlx5_core.h"
+#include "fs_core.h"
+#include "fs_cmd.h"
+#include "mlx5dr.h"
+#include "fs_dr.h"
+
+static bool mlx5_dr_is_fw_table(u32 flags)
+{
+	if (flags & MLX5_FLOW_TABLE_TERMINATION)
+		return true;
+
+	return false;
+}
+
+static int mlx5_cmd_dr_update_root_ft(struct mlx5_flow_root_namespace *ns,
+				      struct mlx5_flow_table *ft,
+				      u32 underlay_qpn,
+				      bool disconnect)
+{
+	return mlx5_fs_cmd_get_fw_cmds()->update_root_ft(ns, ft, underlay_qpn,
+							 disconnect);
+}
+
+static int set_miss_action(struct mlx5_flow_root_namespace *ns,
+			   struct mlx5_flow_table *ft,
+			   struct mlx5_flow_table *next_ft)
+{
+	struct mlx5dr_action *old_miss_action;
+	struct mlx5dr_action *action =3D NULL;
+	struct mlx5dr_table *next_tbl;
+	int err;
+
+	next_tbl =3D next_ft ? next_ft->fs_dr_table.dr_table : NULL;
+	if (next_tbl) {
+		action =3D mlx5dr_action_create_dest_table(next_tbl);
+		if (!action)
+			return -EINVAL;
+	}
+	old_miss_action =3D ft->fs_dr_table.miss_action;
+	err =3D mlx5dr_table_set_miss_action(ft->fs_dr_table.dr_table, action);
+	if (err && action) {
+		err =3D mlx5dr_action_destroy(action);
+		if (err) {
+			action =3D NULL;
+			mlx5_core_err(ns->dev, "Failed to destroy action (%d)\n",
+				      err);
+		}
+	}
+	ft->fs_dr_table.miss_action =3D action;
+	if (old_miss_action) {
+		err =3D mlx5dr_action_destroy(old_miss_action);
+		if (err)
+			mlx5_core_err(ns->dev, "Failed to destroy action (%d)\n",
+				      err);
+	}
+
+	return err;
+}
+
+static int mlx5_cmd_dr_create_flow_table(struct mlx5_flow_root_namespace *=
ns,
+					 struct mlx5_flow_table *ft,
+					 unsigned int log_size,
+					 struct mlx5_flow_table *next_ft)
+{
+	struct mlx5dr_table *tbl;
+	int err;
+
+	if (mlx5_dr_is_fw_table(ft->flags))
+		return mlx5_fs_cmd_get_fw_cmds()->create_flow_table(ns, ft,
+								    log_size,
+								    next_ft);
+
+	tbl =3D mlx5dr_table_create(ns->fs_dr_domain.dr_domain,
+				  ft->level);
+	if (!tbl) {
+		mlx5_core_err(ns->dev, "Failed creating dr flow_table\n");
+		return -EINVAL;
+	}
+
+	ft->fs_dr_table.dr_table =3D tbl;
+	ft->id =3D mlx5dr_table_get_id(tbl);
+
+	if (next_ft) {
+		err =3D set_miss_action(ns, ft, next_ft);
+		if (err) {
+			mlx5dr_table_destroy(tbl);
+			ft->fs_dr_table.dr_table =3D NULL;
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+static int mlx5_cmd_dr_destroy_flow_table(struct mlx5_flow_root_namespace =
*ns,
+					  struct mlx5_flow_table *ft)
+{
+	struct mlx5dr_action *action =3D ft->fs_dr_table.miss_action;
+	int err;
+
+	if (mlx5_dr_is_fw_table(ft->flags))
+		return mlx5_fs_cmd_get_fw_cmds()->destroy_flow_table(ns, ft);
+
+	err =3D mlx5dr_table_destroy(ft->fs_dr_table.dr_table);
+	if (err) {
+		mlx5_core_err(ns->dev, "Failed to destroy flow_table (%d)\n",
+			      err);
+		return err;
+	}
+	if (action) {
+		err =3D mlx5dr_action_destroy(action);
+		if (err) {
+			mlx5_core_err(ns->dev, "Failed to destroy action(%d)\n",
+				      err);
+			return err;
+		}
+	}
+
+	return err;
+}
+
+static int mlx5_cmd_dr_modify_flow_table(struct mlx5_flow_root_namespace *=
ns,
+					 struct mlx5_flow_table *ft,
+					 struct mlx5_flow_table *next_ft)
+{
+	return set_miss_action(ns, ft, next_ft);
+}
+
+static int mlx5_cmd_dr_create_flow_group(struct mlx5_flow_root_namespace *=
ns,
+					 struct mlx5_flow_table *ft,
+					 u32 *in,
+					 struct mlx5_flow_group *fg)
+{
+	struct mlx5dr_matcher *matcher;
+	u16 priority =3D MLX5_GET(create_flow_group_in, in,
+				start_flow_index);
+	u8 match_criteria_enable =3D MLX5_GET(create_flow_group_in,
+					    in,
+					    match_criteria_enable);
+	struct mlx5dr_match_parameters mask;
+
+	if (mlx5_dr_is_fw_table(ft->flags))
+		return mlx5_fs_cmd_get_fw_cmds()->create_flow_group(ns, ft, in,
+								    fg);
+
+	mask.match_buf =3D MLX5_ADDR_OF(create_flow_group_in,
+				      in, match_criteria);
+	mask.match_sz =3D sizeof(fg->mask.match_criteria);
+
+	matcher =3D mlx5dr_matcher_create(ft->fs_dr_table.dr_table,
+					priority,
+					match_criteria_enable,
+					&mask);
+	if (!matcher) {
+		mlx5_core_err(ns->dev, "Failed creating matcher\n");
+		return -EINVAL;
+	}
+
+	fg->fs_dr_matcher.dr_matcher =3D matcher;
+	return 0;
+}
+
+static int mlx5_cmd_dr_destroy_flow_group(struct mlx5_flow_root_namespace =
*ns,
+					  struct mlx5_flow_table *ft,
+					  struct mlx5_flow_group *fg)
+{
+	if (mlx5_dr_is_fw_table(ft->flags))
+		return mlx5_fs_cmd_get_fw_cmds()->destroy_flow_group(ns, ft, fg);
+
+	return mlx5dr_matcher_destroy(fg->fs_dr_matcher.dr_matcher);
+}
+
+static struct mlx5dr_action *create_vport_action(struct mlx5dr_domain *dom=
ain,
+						 struct mlx5_flow_rule *dst)
+{
+	struct mlx5_flow_destination *dest_attr =3D &dst->dest_attr;
+
+	return mlx5dr_action_create_dest_vport(domain, dest_attr->vport.num,
+					       dest_attr->vport.flags &
+					       MLX5_FLOW_DEST_VPORT_VHCA_ID,
+					       dest_attr->vport.vhca_id);
+}
+
+static struct mlx5dr_action *create_ft_action(struct mlx5_core_dev *dev,
+					      struct mlx5_flow_rule *dst)
+{
+	struct mlx5_flow_table *dest_ft =3D dst->dest_attr.ft;
+
+	if (mlx5_dr_is_fw_table(dest_ft->flags))
+		return mlx5dr_create_action_dest_flow_fw_table(dest_ft, dev);
+	return mlx5dr_action_create_dest_table(dest_ft->fs_dr_table.dr_table);
+}
+
+static struct mlx5dr_action *create_action_push_vlan(struct mlx5dr_domain =
*domain,
+						     struct mlx5_fs_vlan *vlan)
+{
+	u16 n_ethtype =3D vlan->ethtype;
+	u8  prio =3D vlan->prio;
+	u16 vid =3D vlan->vid;
+	u32 vlan_hdr;
+
+	vlan_hdr =3D (u32)n_ethtype << 16 | (u32)(prio) << 12 |  (u32)vid;
+	return mlx5dr_action_create_push_vlan(domain, htonl(vlan_hdr));
+}
+
+#define MLX5_FLOW_CONTEXT_ACTION_MAX  20
+static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
+				  struct mlx5_flow_table *ft,
+				  struct mlx5_flow_group *group,
+				  struct fs_fte *fte)
+{
+	struct mlx5dr_domain *domain =3D ns->fs_dr_domain.dr_domain;
+	struct mlx5dr_action *term_action =3D NULL;
+	struct mlx5dr_match_parameters params;
+	struct mlx5_core_dev *dev =3D ns->dev;
+	struct mlx5dr_action **fs_dr_actions;
+	struct mlx5dr_action *tmp_action;
+	struct mlx5dr_action **actions;
+	bool delay_encap_set =3D false;
+	struct mlx5dr_rule *rule;
+	struct mlx5_flow_rule *dst;
+	int fs_dr_num_actions =3D 0;
+	int num_actions =3D 0;
+	size_t match_sz;
+	int err =3D 0;
+	int i;
+
+	if (mlx5_dr_is_fw_table(ft->flags))
+		return mlx5_fs_cmd_get_fw_cmds()->create_fte(ns, ft, group, fte);
+
+	actions =3D kcalloc(MLX5_FLOW_CONTEXT_ACTION_MAX, sizeof(*actions),
+			  GFP_KERNEL);
+	if (!actions)
+		return -ENOMEM;
+
+	fs_dr_actions =3D kcalloc(MLX5_FLOW_CONTEXT_ACTION_MAX,
+				sizeof(*fs_dr_actions), GFP_KERNEL);
+	if (!fs_dr_actions) {
+		kfree(actions);
+		return -ENOMEM;
+	}
+
+	match_sz =3D sizeof(fte->val);
+
+	/* The order of the actions are must to be keep, only the following
+	 * order is supported by SW steering:
+	 * TX: push vlan -> modify header -> encap
+	 * RX: decap -> pop vlan -> modify header
+	 */
+	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH) {
+		tmp_action =3D create_action_push_vlan(domain, &fte->action.vlan[0]);
+		if (!tmp_action) {
+			err =3D -ENOMEM;
+			goto free_actions;
+		}
+		fs_dr_actions[fs_dr_num_actions++] =3D tmp_action;
+		actions[num_actions++] =3D tmp_action;
+	}
+
+	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2) {
+		tmp_action =3D create_action_push_vlan(domain, &fte->action.vlan[1]);
+		if (!tmp_action) {
+			err =3D -ENOMEM;
+			goto free_actions;
+		}
+		fs_dr_actions[fs_dr_num_actions++] =3D tmp_action;
+		actions[num_actions++] =3D tmp_action;
+	}
+
+	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_DECAP) {
+		enum mlx5dr_action_reformat_type decap_type =3D
+			DR_ACTION_REFORMAT_TYP_TNL_L2_TO_L2;
+
+		tmp_action =3D mlx5dr_action_create_packet_reformat(domain,
+								  decap_type, 0,
+								  NULL);
+		if (!tmp_action) {
+			err =3D -ENOMEM;
+			goto free_actions;
+		}
+		fs_dr_actions[fs_dr_num_actions++] =3D tmp_action;
+		actions[num_actions++] =3D tmp_action;
+	}
+
+	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT) {
+		bool is_decap =3D fte->action.pkt_reformat->reformat_type =3D=3D
+			MLX5_REFORMAT_TYPE_L3_TUNNEL_TO_L2;
+
+		if (is_decap)
+			actions[num_actions++] =3D
+				fte->action.pkt_reformat->action.dr_action;
+		else
+			delay_encap_set =3D true;
+	}
+
+	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP) {
+		tmp_action =3D
+			mlx5dr_action_create_pop_vlan();
+		if (!tmp_action) {
+			err =3D -ENOMEM;
+			goto free_actions;
+		}
+		fs_dr_actions[fs_dr_num_actions++] =3D tmp_action;
+		actions[num_actions++] =3D tmp_action;
+	}
+
+	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP_2) {
+		tmp_action =3D
+			mlx5dr_action_create_pop_vlan();
+		if (!tmp_action) {
+			err =3D -ENOMEM;
+			goto free_actions;
+		}
+		fs_dr_actions[fs_dr_num_actions++] =3D tmp_action;
+		actions[num_actions++] =3D tmp_action;
+	}
+
+	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
+		actions[num_actions++] =3D
+			fte->action.modify_hdr->action.dr_action;
+
+	if (delay_encap_set)
+		actions[num_actions++] =3D
+			fte->action.pkt_reformat->action.dr_action;
+
+	/* The order of the actions below is not important */
+
+	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_DROP) {
+		tmp_action =3D mlx5dr_action_create_drop();
+		if (!tmp_action) {
+			err =3D -ENOMEM;
+			goto free_actions;
+		}
+		fs_dr_actions[fs_dr_num_actions++] =3D tmp_action;
+		term_action =3D tmp_action;
+	}
+
+	if (fte->flow_context.flow_tag) {
+		tmp_action =3D
+			mlx5dr_action_create_tag(fte->flow_context.flow_tag);
+		if (!tmp_action) {
+			err =3D -ENOMEM;
+			goto free_actions;
+		}
+		fs_dr_actions[fs_dr_num_actions++] =3D tmp_action;
+		actions[num_actions++] =3D tmp_action;
+	}
+
+	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
+		list_for_each_entry(dst, &fte->node.children, node.list) {
+			enum mlx5_flow_destination_type type =3D dst->dest_attr.type;
+			u32 id;
+
+			if (num_actions =3D=3D MLX5_FLOW_CONTEXT_ACTION_MAX) {
+				err =3D -ENOSPC;
+				goto free_actions;
+			}
+
+			switch (type) {
+			case MLX5_FLOW_DESTINATION_TYPE_COUNTER:
+				id =3D dst->dest_attr.counter_id;
+
+				tmp_action =3D
+					mlx5dr_action_create_flow_counter(id);
+				if (!tmp_action) {
+					err =3D -ENOMEM;
+					goto free_actions;
+				}
+				fs_dr_actions[fs_dr_num_actions++] =3D tmp_action;
+				actions[num_actions++] =3D tmp_action;
+				break;
+			case MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE:
+				tmp_action =3D create_ft_action(dev, dst);
+				if (!tmp_action) {
+					err =3D -ENOMEM;
+					goto free_actions;
+				}
+				fs_dr_actions[fs_dr_num_actions++] =3D tmp_action;
+				term_action =3D tmp_action;
+				break;
+			case MLX5_FLOW_DESTINATION_TYPE_VPORT:
+				tmp_action =3D create_vport_action(domain, dst);
+				if (!tmp_action) {
+					err =3D -ENOMEM;
+					goto free_actions;
+				}
+				fs_dr_actions[fs_dr_num_actions++] =3D tmp_action;
+				term_action =3D tmp_action;
+				break;
+			default:
+				err =3D -EOPNOTSUPP;
+				goto free_actions;
+			}
+		}
+	}
+
+	params.match_sz =3D match_sz;
+	params.match_buf =3D (u64 *)fte->val;
+
+	if (term_action)
+		actions[num_actions++] =3D term_action;
+
+	rule =3D mlx5dr_rule_create(group->fs_dr_matcher.dr_matcher,
+				  &params,
+				  num_actions,
+				  actions);
+	if (!rule) {
+		err =3D -EINVAL;
+		goto free_actions;
+	}
+
+	kfree(actions);
+	fte->fs_dr_rule.dr_rule =3D rule;
+	fte->fs_dr_rule.num_actions =3D fs_dr_num_actions;
+	fte->fs_dr_rule.dr_actions =3D fs_dr_actions;
+
+	return 0;
+
+free_actions:
+	for (i =3D 0; i < fs_dr_num_actions; i++)
+		if (!IS_ERR_OR_NULL(fs_dr_actions[i]))
+			mlx5dr_action_destroy(fs_dr_actions[i]);
+
+	mlx5_core_err(dev, "Failed to create dr rule err(%d)\n", err);
+	kfree(actions);
+	kfree(fs_dr_actions);
+	return err;
+}
+
+static int mlx5_cmd_dr_packet_reformat_alloc(struct mlx5_flow_root_namespa=
ce *ns,
+					     int reformat_type,
+					     size_t size,
+					     void *reformat_data,
+					     enum mlx5_flow_namespace_type namespace,
+					     struct mlx5_pkt_reformat *pkt_reformat)
+{
+	struct mlx5dr_domain *dr_domain =3D ns->fs_dr_domain.dr_domain;
+	struct mlx5dr_action *action;
+	int dr_reformat;
+
+	switch (reformat_type) {
+	case MLX5_REFORMAT_TYPE_L2_TO_VXLAN:
+	case MLX5_REFORMAT_TYPE_L2_TO_NVGRE:
+	case MLX5_REFORMAT_TYPE_L2_TO_L2_TUNNEL:
+		dr_reformat =3D DR_ACTION_REFORMAT_TYP_L2_TO_TNL_L2;
+		break;
+	case MLX5_REFORMAT_TYPE_L3_TUNNEL_TO_L2:
+		dr_reformat =3D DR_ACTION_REFORMAT_TYP_TNL_L3_TO_L2;
+		break;
+	case MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL:
+		dr_reformat =3D DR_ACTION_REFORMAT_TYP_L2_TO_TNL_L3;
+		break;
+	default:
+		mlx5_core_err(ns->dev, "Packet-reformat not supported(%d)\n",
+			      reformat_type);
+		return -EOPNOTSUPP;
+	}
+
+	action =3D mlx5dr_action_create_packet_reformat(dr_domain,
+						      dr_reformat,
+						      size,
+						      reformat_data);
+	if (!action) {
+		mlx5_core_err(ns->dev, "Failed allocating packet-reformat action\n");
+		return -EINVAL;
+	}
+
+	pkt_reformat->action.dr_action =3D action;
+
+	return 0;
+}
+
+static void mlx5_cmd_dr_packet_reformat_dealloc(struct mlx5_flow_root_name=
space *ns,
+						struct mlx5_pkt_reformat *pkt_reformat)
+{
+	mlx5dr_action_destroy(pkt_reformat->action.dr_action);
+}
+
+static int mlx5_cmd_dr_modify_header_alloc(struct mlx5_flow_root_namespace=
 *ns,
+					   u8 namespace, u8 num_actions,
+					   void *modify_actions,
+					   struct mlx5_modify_hdr *modify_hdr)
+{
+	struct mlx5dr_domain *dr_domain =3D ns->fs_dr_domain.dr_domain;
+	struct mlx5dr_action *action;
+	size_t actions_sz;
+
+	actions_sz =3D MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto) *
+		num_actions;
+	action =3D mlx5dr_action_create_modify_header(dr_domain, 0,
+						    actions_sz,
+						    modify_actions);
+	if (!action) {
+		mlx5_core_err(ns->dev, "Failed allocating modify-header action\n");
+		return -EINVAL;
+	}
+
+	modify_hdr->action.dr_action =3D action;
+
+	return 0;
+}
+
+static void mlx5_cmd_dr_modify_header_dealloc(struct mlx5_flow_root_namesp=
ace *ns,
+					      struct mlx5_modify_hdr *modify_hdr)
+{
+	mlx5dr_action_destroy(modify_hdr->action.dr_action);
+}
+
+static int mlx5_cmd_dr_update_fte(struct mlx5_flow_root_namespace *ns,
+				  struct mlx5_flow_table *ft,
+				  struct mlx5_flow_group *group,
+				  int modify_mask,
+				  struct fs_fte *fte)
+{
+	return -EOPNOTSUPP;
+}
+
+static int mlx5_cmd_dr_delete_fte(struct mlx5_flow_root_namespace *ns,
+				  struct mlx5_flow_table *ft,
+				  struct fs_fte *fte)
+{
+	struct mlx5_fs_dr_rule *rule =3D &fte->fs_dr_rule;
+	int err;
+	int i;
+
+	if (mlx5_dr_is_fw_table(ft->flags))
+		return mlx5_fs_cmd_get_fw_cmds()->delete_fte(ns, ft, fte);
+
+	err =3D mlx5dr_rule_destroy(rule->dr_rule);
+	if (err)
+		return err;
+
+	for (i =3D 0; i < rule->num_actions; i++)
+		if (!IS_ERR_OR_NULL(rule->dr_actions[i]))
+			mlx5dr_action_destroy(rule->dr_actions[i]);
+
+	kfree(rule->dr_actions);
+	return 0;
+}
+
+static int mlx5_cmd_dr_set_peer(struct mlx5_flow_root_namespace *ns,
+				struct mlx5_flow_root_namespace *peer_ns)
+{
+	struct mlx5dr_domain *peer_domain =3D NULL;
+
+	if (peer_ns)
+		peer_domain =3D peer_ns->fs_dr_domain.dr_domain;
+	mlx5dr_domain_set_peer(ns->fs_dr_domain.dr_domain,
+			       peer_domain);
+	return 0;
+}
+
+static int mlx5_cmd_dr_create_ns(struct mlx5_flow_root_namespace *ns)
+{
+	ns->fs_dr_domain.dr_domain =3D
+		mlx5dr_domain_create(ns->dev,
+				     MLX5DR_DOMAIN_TYPE_FDB);
+	if (!ns->fs_dr_domain.dr_domain) {
+		mlx5_core_err(ns->dev, "Failed to create dr flow namespace\n");
+		return -EOPNOTSUPP;
+	}
+	return 0;
+}
+
+static int mlx5_cmd_dr_destroy_ns(struct mlx5_flow_root_namespace *ns)
+{
+	return mlx5dr_domain_destroy(ns->fs_dr_domain.dr_domain);
+}
+
+bool mlx5_fs_dr_is_supported(struct mlx5_core_dev *dev)
+{
+	return mlx5dr_is_supported(dev);
+}
+
+static const struct mlx5_flow_cmds mlx5_flow_cmds_dr =3D {
+	.create_flow_table =3D mlx5_cmd_dr_create_flow_table,
+	.destroy_flow_table =3D mlx5_cmd_dr_destroy_flow_table,
+	.modify_flow_table =3D mlx5_cmd_dr_modify_flow_table,
+	.create_flow_group =3D mlx5_cmd_dr_create_flow_group,
+	.destroy_flow_group =3D mlx5_cmd_dr_destroy_flow_group,
+	.create_fte =3D mlx5_cmd_dr_create_fte,
+	.update_fte =3D mlx5_cmd_dr_update_fte,
+	.delete_fte =3D mlx5_cmd_dr_delete_fte,
+	.update_root_ft =3D mlx5_cmd_dr_update_root_ft,
+	.packet_reformat_alloc =3D mlx5_cmd_dr_packet_reformat_alloc,
+	.packet_reformat_dealloc =3D mlx5_cmd_dr_packet_reformat_dealloc,
+	.modify_header_alloc =3D mlx5_cmd_dr_modify_header_alloc,
+	.modify_header_dealloc =3D mlx5_cmd_dr_modify_header_dealloc,
+	.set_peer =3D mlx5_cmd_dr_set_peer,
+	.create_ns =3D mlx5_cmd_dr_create_ns,
+	.destroy_ns =3D mlx5_cmd_dr_destroy_ns,
+};
+
+const struct mlx5_flow_cmds *mlx5_fs_cmd_get_dr_cmds(void)
+{
+		return &mlx5_flow_cmds_dr;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.h b/dri=
vers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.h
new file mode 100644
index 000000000000..1fb185d6ac7f
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.h
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+ * Copyright (c) 2019 Mellanox Technologies
+ */
+
+#ifndef _MLX5_FS_DR_
+#define _MLX5_FS_DR_
+
+#include "mlx5dr.h"
+
+struct mlx5_flow_root_namespace;
+struct fs_fte;
+
+struct mlx5_fs_dr_action {
+	struct mlx5dr_action *dr_action;
+};
+
+struct mlx5_fs_dr_ns {
+	struct mlx5_dr_ns *dr_ns;
+};
+
+struct mlx5_fs_dr_rule {
+	struct mlx5dr_rule    *dr_rule;
+	/* Only actions created by fs_dr */
+	struct mlx5dr_action  **dr_actions;
+	int                      num_actions;
+};
+
+struct mlx5_fs_dr_domain {
+	struct mlx5dr_domain	*dr_domain;
+};
+
+struct mlx5_fs_dr_matcher {
+	struct mlx5dr_matcher *dr_matcher;
+};
+
+struct mlx5_fs_dr_table {
+	struct mlx5dr_table  *dr_table;
+	struct mlx5dr_action *miss_action;
+};
+
+#ifdef CONFIG_MLX5_SW_STEERING
+
+bool mlx5_fs_dr_is_supported(struct mlx5_core_dev *dev);
+
+const struct mlx5_flow_cmds *mlx5_fs_cmd_get_dr_cmds(void);
+
+#else
+
+static inline const struct mlx5_flow_cmds *mlx5_fs_cmd_get_dr_cmds(void)
+{
+	return NULL;
+}
+
+static inline bool mlx5_fs_dr_is_supported(struct mlx5_core_dev *dev)
+{
+	return false;
+}
+
+#endif /* CONFIG_MLX5_SW_STEERING */
+#endif
--=20
2.21.0

