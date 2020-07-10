Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE2621ADAD
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 05:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgGJDsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 23:48:21 -0400
Received: from mail-eopbgr130078.outbound.protection.outlook.com ([40.107.13.78]:20955
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726615AbgGJDsN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 23:48:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EeASkdQ/Xcir4JK7SPKdp0g6QQZLwNTHSM7dINSo1W79yvkFoPnlyeXSSlq2O/s9xD+DG0HUHshflBNXotUoIET9Y0n+vduW90z21vS+ZNEbsNanR/yzi4BCp7yiDyEaBaS/4EPrl/tPRDMCrsWHLU626a64gk2CUnCs5I2uKE507Tx3y4rI7Z0WkKqYtXpDMTOtgF5/SlfCoNZtbnyMw/N+y9NBDvFvAL/3ZKT1FwaMUkiR5Gplgzn1Ye9CkdwbnOJitkQDCQMRZ4B4SaWYed2q9mHSKnRQY+ngbWxyeLB0UzAtP1Jyyeih48htTtkQmhu9+p5Qe2cQv3KutI6HtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrY9IKI8emBi6/hDvJG5mqgcx79AelsM7stczJqpY+M=;
 b=BLg3SK+jihNAYj4XdM2KsT8IFQmcBF3a1RASTLCXqnUVHuu3lvjvXHrPp7i0HUBhACzBIXVQlxaoY2Pf3WFhBagioEH/wx3bfr+a9c6q+QNum6nCYnKZCUlG9b08LipExpt7rCslJRNmwfFxYSEelfUlt/gZfDbsFYRGfMrmMNdbQQdDJrdHc4WXbohy6Wur9ch0eck05nxciGJkz1iDTVySmiV23shG88ky6Cu5mP8FA62bz9CU5R6jS6R0d0YuYdHAFYcPlna8EtyFIxochPNXGsT5iC1aT0GayM4Lx0gySXjfVskjnoQrG1Vfq0xQsoJmXtIlh3NIV1TE0XNYAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrY9IKI8emBi6/hDvJG5mqgcx79AelsM7stczJqpY+M=;
 b=m27E6KyAQxmb73AhZcE2lEgiS4VlxaqR/jH0g6Lec7SoDGE2Q8Hyj61M1EaNGptZrK3c/ehdP2uVC2N/smFkFykj/VVQPK0Nv2EHLsX7t1gradowuzJHS+7pUJGJH8ypgcv4SzP4ZZqIboX/S/AqdhCU8ay1DHB/M+V9ImN1bcs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4512.eurprd05.prod.outlook.com (2603:10a6:803:44::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 10 Jul
 2020 03:47:55 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 03:47:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/13] net/mlx5e: Export sharing of mod headers to a new file
Date:   Thu,  9 Jul 2020 20:44:26 -0700
Message-Id: <20200710034432.112602-8-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0022.namprd03.prod.outlook.com (2603:10b6:a03:1e0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Fri, 10 Jul 2020 03:47:53 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e8fe1300-52e9-45e9-2a41-08d824840795
X-MS-TrafficTypeDiagnostic: VI1PR05MB4512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB451243A61A5F3B4286C851BEBE650@VI1PR05MB4512.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1JTRdknXUewriPP/F/QoXLyD66RQQrXvzay7yJtQDmqr4UgFC2fR3Oamo2FPdmqWq1Vmf4Eyg0YoxvFye7sk2loIUDcgotMd4rFuj1oNVia2mfauPcY0IxJkR17+yDuUx44P93bZrVM2D48vyWauzfvfeY6cq6EzZXe9twDK8SSaeOstmSIzGAq660UyfxvWrnIjljEDBMyw5HLyhvrMjoYxkurFrmxvTIHAT2eX4Drr8gFViuTi6ujErrnNXFfnevopo70YRTQ5x3z7G4zdXbNUfbR8ekDlC+lX3ZWLvFxMrjnher8DNyYAaoRs8WeV8/UBFehvVeaN3HoHXoIkY9AS5jpS/Z4TXN6GGASQ/qrBdxAqp6N3mx/2bVNuTz29
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(2906002)(107886003)(86362001)(30864003)(8936002)(8676002)(6512007)(5660300002)(83380400001)(16526019)(52116002)(66946007)(54906003)(6486002)(186003)(1076003)(956004)(26005)(66556008)(6666004)(6506007)(36756003)(66476007)(478600001)(2616005)(4326008)(110136005)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: F3TymTliraYG3o25SRVhuhyao35JrrW92sFrTN6CP0FoErSw8R8LWMxeuXe9KIPaS+BSIPlBUHYzmxDWVxBSUP6T4Lg8brm/TR76f0mAMkRHJTiZA/2NGVj5PvKArWp31E1d2+WImc5TV5d/Yj2s43eGIURcvunKA2AdYFW8186nlI/QhDM8kMqwIl+sav433bYRgmFW5/S8nAvt9uQfDYIAVQQ9BYfZAKgK+p5jc9bK4i8Uw+OQGy2O9s3V1S96hPaaYP0mAm8pHzRcsAnOG7guNrOFxO5Px/PJAO8d1N4ElV7FKM1ym+6C3HmfqljiXKV6otIx2cuS5zji96A9qHzzPHO2VDKoOZ98JUxdzyODXsnzmZLYNlPeruCLSGt7y2Ep7uMy5PC2/22N7dXlQ27i/GTnt+MKGGIB3Y6k7HMnwfqpeA9KJrPpPed65I9OjHTA+4+8nL4SpeO0/6EDFDepu3ofUdzzK5ZogRjTi18=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8fe1300-52e9-45e9-2a41-08d824840795
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 03:47:55.6763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /TzCjqWX17T+F52SL8M9o57kqyMqrTtWLhbGBXoB7RutU9N6nK0fZTt4LF48MNBDm6Ig1iW0YraT5eMRAs5hBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4512
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Refactor sharing of mod headers to new file and while there,
remove spin lock and flows list, as this is only used for warn on.

Use the generic API in the next patch to re-use tuple modify headers
for identical modify actions,

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |   2 +
 .../ethernet/mellanox/mlx5/core/en/mod_hdr.c  | 157 +++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/mod_hdr.h  |  31 +++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 179 +++---------------
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |   6 -
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |   6 +-
 7 files changed, 217 insertions(+), 166 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 1e7c7f10db6e..124caec65a34 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -35,7 +35,7 @@ mlx5_core-$(CONFIG_MLX5_EN_RXNFC)    += en_fs_ethtool.o
 mlx5_core-$(CONFIG_MLX5_CORE_EN_DCB) += en_dcbnl.o en/port_buffer.o
 mlx5_core-$(CONFIG_PCI_HYPERV_INTERFACE) += en/hv_vhca_stats.o
 mlx5_core-$(CONFIG_MLX5_ESWITCH)     += lag_mp.o lib/geneve.o lib/port_tun.o \
-					en_rep.o en/rep/bond.o
+					en_rep.o en/rep/bond.o en/mod_hdr.o
 mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en_tc.o en/rep/tc.o en/rep/neigh.o \
 					en/mapping.o esw/chains.o en/tc_tun.o \
 					en/tc_tun_vxlan.o en/tc_tun_gre.o en/tc_tun_geneve.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 385cbff1caf1..6f4767324044 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -4,6 +4,8 @@
 #ifndef __MLX5E_FLOW_STEER_H__
 #define __MLX5E_FLOW_STEER_H__
 
+#include "mod_hdr.h"
+
 enum {
 	MLX5E_TC_FT_LEVEL = 0,
 	MLX5E_TC_TTC_FT_LEVEL,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.c b/drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.c
new file mode 100644
index 000000000000..7edde4d536fd
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.c
@@ -0,0 +1,157 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2020 Mellanox Technologies
+
+#include <linux/jhash.h>
+#include "mod_hdr.h"
+
+#define MLX5_MH_ACT_SZ MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)
+
+struct mod_hdr_key {
+	int num_actions;
+	void *actions;
+};
+
+struct mlx5e_mod_hdr_handle {
+	/* a node of a hash table which keeps all the mod_hdr entries */
+	struct hlist_node mod_hdr_hlist;
+
+	struct mod_hdr_key key;
+
+	struct mlx5_modify_hdr *modify_hdr;
+
+	refcount_t refcnt;
+	struct completion res_ready;
+	int compl_result;
+};
+
+static u32 hash_mod_hdr_info(struct mod_hdr_key *key)
+{
+	return jhash(key->actions,
+		     key->num_actions * MLX5_MH_ACT_SZ, 0);
+}
+
+static int cmp_mod_hdr_info(struct mod_hdr_key *a, struct mod_hdr_key *b)
+{
+	if (a->num_actions != b->num_actions)
+		return 1;
+
+	return memcmp(a->actions, b->actions,
+		      a->num_actions * MLX5_MH_ACT_SZ);
+}
+
+void mlx5e_mod_hdr_tbl_init(struct mod_hdr_tbl *tbl)
+{
+	mutex_init(&tbl->lock);
+	hash_init(tbl->hlist);
+}
+
+void mlx5e_mod_hdr_tbl_destroy(struct mod_hdr_tbl *tbl)
+{
+	mutex_destroy(&tbl->lock);
+}
+
+static struct mlx5e_mod_hdr_handle *mod_hdr_get(struct mod_hdr_tbl *tbl,
+						struct mod_hdr_key *key,
+						u32 hash_key)
+{
+	struct mlx5e_mod_hdr_handle *mh, *found = NULL;
+
+	hash_for_each_possible(tbl->hlist, mh, mod_hdr_hlist, hash_key) {
+		if (!cmp_mod_hdr_info(&mh->key, key)) {
+			refcount_inc(&mh->refcnt);
+			found = mh;
+			break;
+		}
+	}
+
+	return found;
+}
+
+struct mlx5e_mod_hdr_handle *
+mlx5e_mod_hdr_attach(struct mlx5_core_dev *mdev,
+		     struct mod_hdr_tbl *tbl,
+		     enum mlx5_flow_namespace_type namespace,
+		     struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts)
+{
+	int num_actions, actions_size, err;
+	struct mlx5e_mod_hdr_handle *mh;
+	struct mod_hdr_key key;
+	u32 hash_key;
+
+	num_actions  = mod_hdr_acts->num_actions;
+	actions_size = MLX5_MH_ACT_SZ * num_actions;
+
+	key.actions = mod_hdr_acts->actions;
+	key.num_actions = num_actions;
+
+	hash_key = hash_mod_hdr_info(&key);
+
+	mutex_lock(&tbl->lock);
+	mh = mod_hdr_get(tbl, &key, hash_key);
+	if (mh) {
+		mutex_unlock(&tbl->lock);
+		wait_for_completion(&mh->res_ready);
+
+		if (mh->compl_result < 0) {
+			err = -EREMOTEIO;
+			goto attach_header_err;
+		}
+		goto attach_header;
+	}
+
+	mh = kzalloc(sizeof(*mh) + actions_size, GFP_KERNEL);
+	if (!mh) {
+		mutex_unlock(&tbl->lock);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	mh->key.actions = (void *)mh + sizeof(*mh);
+	memcpy(mh->key.actions, key.actions, actions_size);
+	mh->key.num_actions = num_actions;
+	refcount_set(&mh->refcnt, 1);
+	init_completion(&mh->res_ready);
+
+	hash_add(tbl->hlist, &mh->mod_hdr_hlist, hash_key);
+	mutex_unlock(&tbl->lock);
+
+	mh->modify_hdr = mlx5_modify_header_alloc(mdev, namespace,
+						  mh->key.num_actions,
+						  mh->key.actions);
+	if (IS_ERR(mh->modify_hdr)) {
+		err = PTR_ERR(mh->modify_hdr);
+		mh->compl_result = err;
+		goto alloc_header_err;
+	}
+	mh->compl_result = 1;
+	complete_all(&mh->res_ready);
+
+attach_header:
+	return mh;
+
+alloc_header_err:
+	complete_all(&mh->res_ready);
+attach_header_err:
+	mlx5e_mod_hdr_detach(mdev, tbl, mh);
+	return ERR_PTR(err);
+}
+
+void mlx5e_mod_hdr_detach(struct mlx5_core_dev *mdev,
+			  struct mod_hdr_tbl *tbl,
+			  struct mlx5e_mod_hdr_handle *mh)
+{
+	if (!refcount_dec_and_mutex_lock(&mh->refcnt, &tbl->lock))
+		return;
+	hash_del(&mh->mod_hdr_hlist);
+	mutex_unlock(&tbl->lock);
+
+	if (mh->compl_result > 0)
+		mlx5_modify_header_dealloc(mdev, mh->modify_hdr);
+
+	kfree(mh);
+}
+
+struct mlx5_modify_hdr *mlx5e_mod_hdr_get(struct mlx5e_mod_hdr_handle *mh)
+{
+	return mh->modify_hdr;
+}
+
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.h b/drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.h
new file mode 100644
index 000000000000..33b23d8f9182
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020 Mellanox Technologies */
+
+#ifndef __MLX5E_EN_MOD_HDR_H__
+#define __MLX5E_EN_MOD_HDR_H__
+
+#include <linux/hashtable.h>
+#include <linux/mlx5/fs.h>
+
+struct mlx5e_mod_hdr_handle;
+
+struct mlx5e_tc_mod_hdr_acts {
+	int num_actions;
+	int max_actions;
+	void *actions;
+};
+
+struct mlx5e_mod_hdr_handle *
+mlx5e_mod_hdr_attach(struct mlx5_core_dev *mdev,
+		     struct mod_hdr_tbl *tbl,
+		     enum mlx5_flow_namespace_type namespace,
+		     struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts);
+void mlx5e_mod_hdr_detach(struct mlx5_core_dev *mdev,
+			  struct mod_hdr_tbl *tbl,
+			  struct mlx5e_mod_hdr_handle *mh);
+struct mlx5_modify_hdr *mlx5e_mod_hdr_get(struct mlx5e_mod_hdr_handle *mh);
+
+void mlx5e_mod_hdr_tbl_init(struct mod_hdr_tbl *tbl);
+void mlx5e_mod_hdr_tbl_destroy(struct mod_hdr_tbl *tbl);
+
+#endif /* __MLX5E_EN_MOD_HDR_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 090069e936b7..3814c70b5230 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -63,6 +63,7 @@
 #include "en/tc_tun.h"
 #include "en/mapping.h"
 #include "en/tc_ct.h"
+#include "en/mod_hdr.h"
 #include "lib/devcom.h"
 #include "lib/geneve.h"
 #include "diag/en_tc_tracepoint.h"
@@ -140,8 +141,7 @@ struct mlx5e_tc_flow {
 	 */
 	struct encap_flow_item encaps[MLX5_MAX_FLOW_FWD_VPORTS];
 	struct mlx5e_tc_flow    *peer_flow;
-	struct mlx5e_mod_hdr_entry *mh; /* attached mod header instance */
-	struct list_head	mod_hdr; /* flows sharing the same mod hdr ID */
+	struct mlx5e_mod_hdr_handle *mh; /* attached mod header instance */
 	struct mlx5e_hairpin_entry *hpe; /* attached hairpin instance */
 	struct list_head	hairpin; /* flows sharing the same hairpin */
 	struct list_head	peer;    /* flows with peer flow */
@@ -309,29 +309,6 @@ struct mlx5e_hairpin_entry {
 	struct completion res_ready;
 };
 
-struct mod_hdr_key {
-	int num_actions;
-	void *actions;
-};
-
-struct mlx5e_mod_hdr_entry {
-	/* a node of a hash table which keeps all the mod_hdr entries */
-	struct hlist_node mod_hdr_hlist;
-
-	/* protects flows list */
-	spinlock_t flows_lock;
-	/* flows sharing the same mod_hdr entry */
-	struct list_head flows;
-
-	struct mod_hdr_key key;
-
-	struct mlx5_modify_hdr *modify_hdr;
-
-	refcount_t refcnt;
-	struct completion res_ready;
-	int compl_result;
-};
-
 static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
 			      struct mlx5e_tc_flow *flow);
 
@@ -408,148 +385,43 @@ static bool mlx5e_is_offloaded_flow(struct mlx5e_tc_flow *flow)
 	return flow_flag_test(flow, OFFLOADED);
 }
 
-static inline u32 hash_mod_hdr_info(struct mod_hdr_key *key)
-{
-	return jhash(key->actions,
-		     key->num_actions * MLX5_MH_ACT_SZ, 0);
-}
-
-static inline int cmp_mod_hdr_info(struct mod_hdr_key *a,
-				   struct mod_hdr_key *b)
+static int get_flow_name_space(struct mlx5e_tc_flow *flow)
 {
-	if (a->num_actions != b->num_actions)
-		return 1;
-
-	return memcmp(a->actions, b->actions, a->num_actions * MLX5_MH_ACT_SZ);
+	return mlx5e_is_eswitch_flow(flow) ?
+		MLX5_FLOW_NAMESPACE_FDB : MLX5_FLOW_NAMESPACE_KERNEL;
 }
 
 static struct mod_hdr_tbl *
-get_mod_hdr_table(struct mlx5e_priv *priv, int namespace)
+get_mod_hdr_table(struct mlx5e_priv *priv, struct mlx5e_tc_flow *flow)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 
-	return namespace == MLX5_FLOW_NAMESPACE_FDB ? &esw->offloads.mod_hdr :
+	return get_flow_name_space(flow) == MLX5_FLOW_NAMESPACE_FDB ?
+		&esw->offloads.mod_hdr :
 		&priv->fs.tc.mod_hdr;
 }
 
-static struct mlx5e_mod_hdr_entry *
-mlx5e_mod_hdr_get(struct mod_hdr_tbl *tbl, struct mod_hdr_key *key, u32 hash_key)
-{
-	struct mlx5e_mod_hdr_entry *mh, *found = NULL;
-
-	hash_for_each_possible(tbl->hlist, mh, mod_hdr_hlist, hash_key) {
-		if (!cmp_mod_hdr_info(&mh->key, key)) {
-			refcount_inc(&mh->refcnt);
-			found = mh;
-			break;
-		}
-	}
-
-	return found;
-}
-
-static void mlx5e_mod_hdr_put(struct mlx5e_priv *priv,
-			      struct mlx5e_mod_hdr_entry *mh,
-			      int namespace)
-{
-	struct mod_hdr_tbl *tbl = get_mod_hdr_table(priv, namespace);
-
-	if (!refcount_dec_and_mutex_lock(&mh->refcnt, &tbl->lock))
-		return;
-	hash_del(&mh->mod_hdr_hlist);
-	mutex_unlock(&tbl->lock);
-
-	WARN_ON(!list_empty(&mh->flows));
-	if (mh->compl_result > 0)
-		mlx5_modify_header_dealloc(priv->mdev, mh->modify_hdr);
-
-	kfree(mh);
-}
-
-static int get_flow_name_space(struct mlx5e_tc_flow *flow)
-{
-	return mlx5e_is_eswitch_flow(flow) ?
-		MLX5_FLOW_NAMESPACE_FDB : MLX5_FLOW_NAMESPACE_KERNEL;
-}
 static int mlx5e_attach_mod_hdr(struct mlx5e_priv *priv,
 				struct mlx5e_tc_flow *flow,
 				struct mlx5e_tc_flow_parse_attr *parse_attr)
 {
-	int num_actions, actions_size, namespace, err;
-	struct mlx5e_mod_hdr_entry *mh;
-	struct mod_hdr_tbl *tbl;
-	struct mod_hdr_key key;
-	u32 hash_key;
-
-	num_actions  = parse_attr->mod_hdr_acts.num_actions;
-	actions_size = MLX5_MH_ACT_SZ * num_actions;
-
-	key.actions = parse_attr->mod_hdr_acts.actions;
-	key.num_actions = num_actions;
-
-	hash_key = hash_mod_hdr_info(&key);
-
-	namespace = get_flow_name_space(flow);
-	tbl = get_mod_hdr_table(priv, namespace);
-
-	mutex_lock(&tbl->lock);
-	mh = mlx5e_mod_hdr_get(tbl, &key, hash_key);
-	if (mh) {
-		mutex_unlock(&tbl->lock);
-		wait_for_completion(&mh->res_ready);
-
-		if (mh->compl_result < 0) {
-			err = -EREMOTEIO;
-			goto attach_header_err;
-		}
-		goto attach_flow;
-	}
-
-	mh = kzalloc(sizeof(*mh) + actions_size, GFP_KERNEL);
-	if (!mh) {
-		mutex_unlock(&tbl->lock);
-		return -ENOMEM;
-	}
-
-	mh->key.actions = (void *)mh + sizeof(*mh);
-	memcpy(mh->key.actions, key.actions, actions_size);
-	mh->key.num_actions = num_actions;
-	spin_lock_init(&mh->flows_lock);
-	INIT_LIST_HEAD(&mh->flows);
-	refcount_set(&mh->refcnt, 1);
-	init_completion(&mh->res_ready);
-
-	hash_add(tbl->hlist, &mh->mod_hdr_hlist, hash_key);
-	mutex_unlock(&tbl->lock);
+	struct mlx5_modify_hdr *modify_hdr;
+	struct mlx5e_mod_hdr_handle *mh;
 
-	mh->modify_hdr = mlx5_modify_header_alloc(priv->mdev, namespace,
-						  mh->key.num_actions,
-						  mh->key.actions);
-	if (IS_ERR(mh->modify_hdr)) {
-		err = PTR_ERR(mh->modify_hdr);
-		mh->compl_result = err;
-		goto alloc_header_err;
-	}
-	mh->compl_result = 1;
-	complete_all(&mh->res_ready);
+	mh = mlx5e_mod_hdr_attach(priv->mdev, get_mod_hdr_table(priv, flow),
+				  get_flow_name_space(flow),
+				  &parse_attr->mod_hdr_acts);
+	if (IS_ERR(mh))
+		return PTR_ERR(mh);
 
-attach_flow:
-	flow->mh = mh;
-	spin_lock(&mh->flows_lock);
-	list_add(&flow->mod_hdr, &mh->flows);
-	spin_unlock(&mh->flows_lock);
+	modify_hdr = mlx5e_mod_hdr_get(mh);
 	if (mlx5e_is_eswitch_flow(flow))
-		flow->esw_attr->modify_hdr = mh->modify_hdr;
+		flow->esw_attr->modify_hdr = modify_hdr;
 	else
-		flow->nic_attr->modify_hdr = mh->modify_hdr;
+		flow->nic_attr->modify_hdr = modify_hdr;
+	flow->mh = mh;
 
 	return 0;
-
-alloc_header_err:
-	complete_all(&mh->res_ready);
-attach_header_err:
-	mlx5e_mod_hdr_put(priv, mh, namespace);
-	return err;
 }
 
 static void mlx5e_detach_mod_hdr(struct mlx5e_priv *priv,
@@ -559,11 +431,8 @@ static void mlx5e_detach_mod_hdr(struct mlx5e_priv *priv,
 	if (!flow->mh)
 		return;
 
-	spin_lock(&flow->mh->flows_lock);
-	list_del(&flow->mod_hdr);
-	spin_unlock(&flow->mh->flows_lock);
-
-	mlx5e_mod_hdr_put(priv, flow->mh, get_flow_name_space(flow));
+	mlx5e_mod_hdr_detach(priv->mdev, get_mod_hdr_table(priv, flow),
+			     flow->mh);
 	flow->mh = NULL;
 }
 
@@ -4460,7 +4329,6 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
 	flow->priv = priv;
 	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++)
 		INIT_LIST_HEAD(&flow->encaps[out_index].list);
-	INIT_LIST_HEAD(&flow->mod_hdr);
 	INIT_LIST_HEAD(&flow->hairpin);
 	INIT_LIST_HEAD(&flow->l3_to_l2_reformat);
 	refcount_set(&flow->refcnt, 1);
@@ -5064,9 +4932,8 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 	struct mlx5e_tc_table *tc = &priv->fs.tc;
 	int err;
 
+	mlx5e_mod_hdr_tbl_init(&tc->mod_hdr);
 	mutex_init(&tc->t_lock);
-	mutex_init(&tc->mod_hdr.lock);
-	hash_init(tc->mod_hdr.hlist);
 	mutex_init(&tc->hairpin_tbl_lock);
 	hash_init(tc->hairpin_tbl);
 
@@ -5104,7 +4971,7 @@ void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv)
 						      &tc->netdevice_nb,
 						      &tc->netdevice_nn);
 
-	mutex_destroy(&tc->mod_hdr.lock);
+	mlx5e_mod_hdr_tbl_destroy(&tc->mod_hdr);
 	mutex_destroy(&tc->hairpin_tbl_lock);
 
 	rhashtable_destroy(&tc->ht);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 856e034b92f3..b69f0e376ec0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -148,12 +148,6 @@ extern struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[];
 bool mlx5e_is_valid_eswitch_fwd_dev(struct mlx5e_priv *priv,
 				    struct net_device *out_dev);
 
-struct mlx5e_tc_mod_hdr_acts {
-	int num_actions;
-	int max_actions;
-	void *actions;
-};
-
 int mlx5e_tc_match_to_reg_set(struct mlx5_core_dev *mdev,
 			      struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts,
 			      enum mlx5e_tc_attr_to_reg type,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index d70543ea57dd..c181f6b63f59 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -42,6 +42,7 @@
 #include "fs_core.h"
 #include "devlink.h"
 #include "ecpf.h"
+#include "en/mod_hdr.h"
 
 enum {
 	MLX5_ACTION_NONE = 0,
@@ -1748,10 +1749,9 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 
 	mutex_init(&esw->offloads.encap_tbl_lock);
 	hash_init(esw->offloads.encap_tbl);
-	mutex_init(&esw->offloads.mod_hdr.lock);
-	hash_init(esw->offloads.mod_hdr.hlist);
 	mutex_init(&esw->offloads.decap_tbl_lock);
 	hash_init(esw->offloads.decap_tbl);
+	mlx5e_mod_hdr_tbl_init(&esw->offloads.mod_hdr);
 	atomic64_set(&esw->offloads.num_flows, 0);
 	ida_init(&esw->offloads.vport_metadata_ida);
 	mutex_init(&esw->state_lock);
@@ -1793,7 +1793,7 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 	mutex_destroy(&esw->mode_lock);
 	mutex_destroy(&esw->state_lock);
 	ida_destroy(&esw->offloads.vport_metadata_ida);
-	mutex_destroy(&esw->offloads.mod_hdr.lock);
+	mlx5e_mod_hdr_tbl_destroy(&esw->offloads.mod_hdr);
 	mutex_destroy(&esw->offloads.encap_tbl_lock);
 	mutex_destroy(&esw->offloads.decap_tbl_lock);
 	kfree(esw->vports);
-- 
2.26.2

