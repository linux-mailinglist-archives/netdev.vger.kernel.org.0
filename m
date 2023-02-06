Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F4C68BF2D
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 15:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbjBFOCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 09:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbjBFOBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 09:01:40 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7736729438
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 06:00:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EVns4hOR3ojq/nn8XQiOHduGBXmWjpZUrJYm9bRnlOuNTa04qLU3wNMaipCORu4w1vxfK2SMny58RzuxRfS4ALcXAUGkqeTuvF2Mn4o77gnqQobW5BSV0I8ywijAxhW9t4rJYnCzqXS2kUrRPgXYMe5MIcZCjs9rIP9+HdukpHZPwOjEAAXBa7ZXQmVeig5PhqktmBT2a4oMHWezrlX3X5R+sxEStgsu/lgpIJ6ZDBFriCXfb+lv6rkTnzkb/klD0Ie4SHFg9s/umBZukRLg/sfDw+HMlgEHWjJ9FLEs+LpBkMZik2DEm4jlzpntjknmRyIZ88guuAUcSahALCYRhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I1WINQ6yox3Nla3dethRxITIzoiZNf/AcgCIBTGq46c=;
 b=JlOot1XOZEnVWO0HEkSXvkKnOkQeSXei+FHRt7BPqnCzI3i3+tF3nnB0PY9+shSuiNX31ixTtwHDR6mCYI6DRI9/KAl9PFnyN0fVj4bekwFmpHIv/4FHj3CVy+NtPi1hmtJ0/EwcdB2VqdrqS8/Zuh+/hI1eofdP8j9V8mKzYwwoJHLthu+POMp7z269qYYGQOKZHM3X7TWdLl54PJZGTiaUCRecSXeJ7oxtS376nG03U4avAeBEyif5+hbNwE8z6JpXIFX1QpEdZUT01NqPvsW6YUt/8cLW6AM7ru6CYtq/nwkOAXVCR8Q27zBQMyzB1qiK6NXwJq9hhkpA25VBkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I1WINQ6yox3Nla3dethRxITIzoiZNf/AcgCIBTGq46c=;
 b=Qdm5yP7+SAqOnz7QLGH8Z5E9TdEQjziHVQHs6aBFhfSPvWAnxt/z/i6NUml1QMRoBomMMdN2jqkpgG0ay2g0KGb7U5LvXB8hsU7rHQifibqgIN3dvzoxjW6MVTlvDD7JDeCpFnWrfb5bRFKFOH/DWZzyWIkoS9N0p5Ymo87vrrY8F5UFOp1JY03lLNThIpzSni7WZOL1/yUkVyt34RQ9e+nXFuUyuTLm2jSbxyfaspKbfWRSH0qimC1aG1N9CNGiR2pT6zvCJc+5FlgTmPtmyXGi00LJZPZjhJGAAwD69smoTA/iw1rqVVdR/2MXVd/yCAJ/hIZBnf0TYjz5LDrMgw==
Received: from BN9PR03CA0519.namprd03.prod.outlook.com (2603:10b6:408:131::14)
 by SN7PR12MB6713.namprd12.prod.outlook.com (2603:10b6:806:273::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 14:00:44 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:131:cafe::4e) by BN9PR03CA0519.outlook.office365.com
 (2603:10b6:408:131::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Mon, 6 Feb 2023 14:00:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34 via Frontend Transport; Mon, 6 Feb 2023 14:00:43 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 06:00:28 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 6 Feb 2023 06:00:28 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Mon, 6 Feb 2023 06:00:25 -0800
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        "Jiri Pirko" <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "Oz Shlomo" <ozsh@nvidia.com>
Subject: [PATCH  net-next v3 8/9] net/mlx5e: TC, map tc action cookie to a hw counter
Date:   Mon, 6 Feb 2023 15:54:41 +0200
Message-ID: <20230206135442.15671-9-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230206135442.15671-1-ozsh@nvidia.com>
References: <20230206135442.15671-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT009:EE_|SN7PR12MB6713:EE_
X-MS-Office365-Filtering-Correlation-Id: 80c16bca-95c1-46cd-ef61-08db084a8994
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bGtHd/Nk+rASm8DpBmHAByf4ipilG+x/UtYaMnCN53MD4Qi6MaX3Vxi+7xbikFQCz0I3ora1mo/p2Q2nLocyAy2pDXBeYUkQDL7zb4UOvF8kNFbw5IH1TxszNN3KqC+ZPxqk950Ybo1JETbJKm34iKwQ2H6VufUiwDSl8NxndoJ2pEWk+at7LiwPkVdqKVhYy+unUrGbrMyyZcoPzqW20Mul15ZVI1IkbuLNQW85w0eY8CYP99tDHjmhQsPs/DwzjqQpsZojRQqfLCelCCM1Aya0DFtw9u/mhgUEgfzE3rTl4gbwsiGLPvvHoGzuG/sqU+CTKC9KaGfvW7D8qpHYt6NUkoAf/UkeDHloW9f+/F5N1cQYx/nY+L8OxGXiHzhD/hnphtzfyVXFk4I0Hns1iQBIrd9vdumiSGCR1J79xrhYERngILx98itFxcrKXD0AnVyypcErLIstk2eNhnQShYL0qI/Tym89yR58SHBYvaYTWlG3Q+1j0vbbFy9xURPGs0isRKkIKXKSPE/WJqRyikI0dY1Vld+QvI1YMtxyKKK78ICSfZkKiPi0oM0/nnaqXtgrKO+d1xiorvsH6k+1nbKM1O/DEeYphC52lRG+LwwvhDgvlxG8Vu78crfedj2XhSY23M9N/DAgQdhJNajRyqtQM0A6O/Vp1VTxXgnYqvVC91FMREYgjRe8s6Sktr0bJqfPDskvHXV7baONX20Zew==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199018)(46966006)(40470700004)(36840700001)(1076003)(2906002)(36756003)(54906003)(107886003)(356005)(83380400001)(2616005)(316002)(6666004)(40480700001)(336012)(86362001)(82310400005)(47076005)(426003)(478600001)(7636003)(40460700003)(82740400003)(26005)(30864003)(4326008)(8936002)(36860700001)(8676002)(6916009)(70586007)(186003)(5660300002)(70206006)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 14:00:43.0023
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80c16bca-95c1-46cd-ef61-08db084a8994
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6713
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently a hardware counter is associated with a flow cookie.
This does not apply to flows using branching action which are required to
return per action stats.

A single counter may apply to multiple actions.
Scan the flow actions in reverse (from the last to the first action) while
caching the last counter.
Associate all the flow attribute tc action cookies with the current
cached counter.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>

---
Change log:

V2 -> V3:
    - Change commit message title
---
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act_stats.c  | 153 +++++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/tc/act_stats.h  |  23 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  44 ++++++
 5 files changed, 224 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index cd4a1ab0ea78..06f511fcbd8e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -47,7 +47,7 @@ mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en_tc.o en/rep/tc.o en/rep/neigh.o \
 					en/tc_tun_vxlan.o en/tc_tun_gre.o en/tc_tun_geneve.o \
 					en/tc_tun_mplsoudp.o diag/en_tc_tracepoint.o \
 					en/tc/post_act.o en/tc/int_port.o en/tc/meter.o \
-					en/tc/post_meter.o
+					en/tc/post_meter.o en/tc/act_stats.o
 
 mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en/tc/act/act.o en/tc/act/drop.o en/tc/act/trap.o \
 					en/tc/act/accept.o en/tc/act/mark.o en/tc/act/goto.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
new file mode 100644
index 000000000000..d1272c0f883c
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
@@ -0,0 +1,153 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include <linux/rhashtable.h>
+#include <net/flow_offload.h>
+#include "en/tc_priv.h"
+#include "act_stats.h"
+#include "en/fs.h"
+
+struct mlx5e_tc_act_stats_handle {
+	struct rhashtable ht;
+	spinlock_t ht_lock; /* protects hashtable */
+};
+
+struct mlx5e_tc_act_stats {
+	unsigned long		tc_act_cookie;
+
+	struct mlx5_fc		*counter;
+	u64			lastpackets;
+	u64			lastbytes;
+
+	struct rhash_head	hash;
+	struct rcu_head		rcu_head;
+};
+
+static const struct rhashtable_params act_counters_ht_params = {
+	.head_offset = offsetof(struct mlx5e_tc_act_stats, hash),
+	.key_offset = 0,
+	.key_len = offsetof(struct mlx5e_tc_act_stats, counter),
+	.automatic_shrinking = true,
+};
+
+struct mlx5e_tc_act_stats_handle *
+mlx5e_tc_act_stats_create(void)
+{
+	struct mlx5e_tc_act_stats_handle *handle;
+	int err;
+
+	handle = kvzalloc(sizeof(*handle), GFP_KERNEL);
+	if (IS_ERR(handle))
+		return ERR_PTR(-ENOMEM);
+
+	err = rhashtable_init(&handle->ht, &act_counters_ht_params);
+	if (err)
+		goto err;
+
+	spin_lock_init(&handle->ht_lock);
+	return handle;
+err:
+	kvfree(handle);
+	return ERR_PTR(err);
+}
+
+void mlx5e_tc_act_stats_free(struct mlx5e_tc_act_stats_handle *handle)
+{
+	rhashtable_destroy(&handle->ht);
+	kvfree(handle);
+}
+
+static int
+mlx5e_tc_act_stats_add(struct mlx5e_tc_act_stats_handle *handle,
+		       unsigned long act_cookie,
+		       struct mlx5_fc *counter)
+{
+	struct mlx5e_tc_act_stats *act_stats, *old_act_stats;
+	struct rhashtable *ht = &handle->ht;
+	int err = 0;
+
+	act_stats = kvzalloc(sizeof(*act_stats), GFP_KERNEL);
+	if (!act_stats)
+		return -ENOMEM;
+
+	act_stats->tc_act_cookie = act_cookie;
+	act_stats->counter = counter;
+
+	rcu_read_lock();
+	old_act_stats = rhashtable_lookup_get_insert_fast(ht,
+							  &act_stats->hash,
+							  act_counters_ht_params);
+	if (IS_ERR(old_act_stats)) {
+		err = PTR_ERR(old_act_stats);
+		goto err_hash_insert;
+	} else if (old_act_stats) {
+		err = -EEXIST;
+		goto err_hash_insert;
+	}
+	rcu_read_unlock();
+
+	return 0;
+
+err_hash_insert:
+	rcu_read_unlock();
+	kvfree(act_stats);
+	return err;
+}
+
+void
+mlx5e_tc_act_stats_del_flow(struct mlx5e_tc_act_stats_handle *handle,
+			    struct mlx5e_tc_flow *flow)
+{
+	struct mlx5_flow_attr *attr;
+	struct mlx5e_tc_act_stats *act_stats;
+	int i;
+
+	list_for_each_entry(attr, &flow->attrs, list) {
+		for (i = 0; i < attr->tc_act_cookies_count; i++) {
+			struct rhashtable *ht = &handle->ht;
+
+			spin_lock(&handle->ht_lock);
+			act_stats = rhashtable_lookup_fast(ht,
+							   &attr->tc_act_cookies[i],
+							   act_counters_ht_params);
+			if (act_stats &&
+			    rhashtable_remove_fast(ht, &act_stats->hash,
+						   act_counters_ht_params) == 0)
+				kvfree_rcu(act_stats, rcu_head);
+
+			spin_unlock(&handle->ht_lock);
+		}
+	}
+}
+
+int
+mlx5e_tc_act_stats_add_flow(struct mlx5e_tc_act_stats_handle *handle,
+			    struct mlx5e_tc_flow *flow)
+{
+	struct mlx5_fc *curr_counter = NULL;
+	unsigned long last_cookie = 0;
+	struct mlx5_flow_attr *attr;
+	int err;
+	int i;
+
+	list_for_each_entry(attr, &flow->attrs, list) {
+		if (attr->counter)
+			curr_counter = attr->counter;
+
+		for (i = 0; i < attr->tc_act_cookies_count; i++) {
+			/* jump over identical ids (e.g. pedit)*/
+			if (last_cookie == attr->tc_act_cookies[i])
+				continue;
+
+			err = mlx5e_tc_act_stats_add(handle, attr->tc_act_cookies[i], curr_counter);
+			if (err)
+				goto out_err;
+			last_cookie = attr->tc_act_cookies[i];
+		}
+	}
+
+	return 0;
+out_err:
+	mlx5e_tc_act_stats_del_flow(handle, flow);
+	return err;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.h
new file mode 100644
index 000000000000..4929301a5260
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#ifndef __MLX5_EN_ACT_STATS_H__
+#define __MLX5_EN_ACT_STATS_H__
+
+#include <net/flow_offload.h>
+#include "en/tc_priv.h"
+
+struct mlx5e_tc_act_stats_handle;
+
+struct mlx5e_tc_act_stats_handle *mlx5e_tc_act_stats_create(void);
+void mlx5e_tc_act_stats_free(struct mlx5e_tc_act_stats_handle *handle);
+
+int
+mlx5e_tc_act_stats_add_flow(struct mlx5e_tc_act_stats_handle *handle,
+			    struct mlx5e_tc_flow *flow);
+
+void
+mlx5e_tc_act_stats_del_flow(struct mlx5e_tc_act_stats_handle *handle,
+			    struct mlx5e_tc_flow *flow);
+
+#endif /* __MLX5_EN_ACT_STATS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index b4e691760da9..0abe3313c673 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -100,6 +100,9 @@ struct mlx5_rep_uplink_priv {
 	struct mlx5e_tc_int_port_priv *int_port_priv;
 
 	struct mlx5e_flow_meters *flow_meters;
+
+	/* tc action stats */
+	struct mlx5e_tc_act_stats_handle *action_stats_handle;
 };
 
 struct mlx5e_rep_priv {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index a5118da3ed6c..ec5d1fbae22e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -45,6 +45,7 @@
 #include <net/bonding.h>
 #include "en.h"
 #include "en/tc/post_act.h"
+#include "en/tc/act_stats.h"
 #include "en_rep.h"
 #include "en/rep/tc.h"
 #include "en/rep/neigh.h"
@@ -101,6 +102,9 @@ struct mlx5e_tc_table {
 	struct mapping_ctx             *mapping;
 	struct mlx5e_hairpin_params    hairpin_params;
 	struct dentry                  *dfs_root;
+
+	/* tc action stats */
+	struct mlx5e_tc_act_stats_handle *action_stats_handle;
 };
 
 struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
@@ -286,6 +290,24 @@ struct mlx5_fs_chains *mlx5e_nic_chains(struct mlx5e_tc_table *tc)
 	return err;
 }
 
+static struct mlx5e_tc_act_stats_handle  *
+get_act_stats_handle(struct mlx5e_priv *priv)
+{
+	struct mlx5e_tc_table *tc = mlx5e_fs_get_tc(priv->fs);
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5_rep_uplink_priv *uplink_priv;
+	struct mlx5e_rep_priv *uplink_rpriv;
+
+	if (is_mdev_switchdev_mode(priv->mdev)) {
+		uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+		uplink_priv = &uplink_rpriv->uplink_priv;
+
+		return uplink_priv->action_stats_handle;
+	}
+
+	return tc->action_stats_handle;
+}
+
 struct mlx5e_tc_int_port_priv *
 mlx5e_get_int_port_priv(struct mlx5e_priv *priv)
 {
@@ -2035,6 +2057,10 @@ int mlx5e_tc_query_route_vport(struct net_device *out_dev, struct net_device *ro
 	if (err)
 		goto err_out;
 
+	err = mlx5e_tc_act_stats_add_flow(get_act_stats_handle(priv), flow);
+	if (err)
+		goto err_out;
+
 	/* we get here if one of the following takes place:
 	 * (1) there's no error
 	 * (2) there's an encap action and we don't have valid neigh
@@ -2131,6 +2157,8 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	if (flow_flag_test(flow, L3_TO_L2_DECAP))
 		mlx5e_detach_decap(priv, flow);
 
+	mlx5e_tc_act_stats_del_flow(get_act_stats_handle(priv), flow);
+
 	free_flow_post_acts(flow);
 	free_branch_attr(flow, attr->branch_true);
 	free_branch_attr(flow, attr->branch_false);
@@ -5342,8 +5370,16 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 
 	mlx5e_tc_debugfs_init(tc, mlx5e_fs_get_debugfs_root(priv->fs));
 
+	tc->action_stats_handle = mlx5e_tc_act_stats_create();
+	if (IS_ERR(tc->action_stats_handle))
+		goto err_act_stats;
+
 	return 0;
 
+err_act_stats:
+	unregister_netdevice_notifier_dev_net(priv->netdev,
+					      &tc->netdevice_nb,
+					      &tc->netdevice_nn);
 err_reg:
 	mlx5_tc_ct_clean(tc->ct);
 	mlx5e_tc_post_act_destroy(tc->post_act);
@@ -5393,6 +5429,7 @@ void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv)
 	mapping_destroy(tc->mapping);
 	mlx5_chains_destroy(tc->chains);
 	mlx5e_tc_nic_destroy_miss_table(priv);
+	mlx5e_tc_act_stats_free(tc->action_stats_handle);
 }
 
 int mlx5e_tc_ht_init(struct rhashtable *tc_ht)
@@ -5469,8 +5506,14 @@ int mlx5e_tc_esw_init(struct mlx5_rep_uplink_priv *uplink_priv)
 		goto err_register_fib_notifier;
 	}
 
+	uplink_priv->action_stats_handle = mlx5e_tc_act_stats_create();
+	if (IS_ERR(uplink_priv->action_stats_handle))
+		goto err_action_counter;
+
 	return 0;
 
+err_action_counter:
+	mlx5e_tc_tun_cleanup(uplink_priv->encap);
 err_register_fib_notifier:
 	mapping_destroy(uplink_priv->tunnel_enc_opts_mapping);
 err_enc_opts_mapping:
@@ -5497,6 +5540,7 @@ void mlx5e_tc_esw_cleanup(struct mlx5_rep_uplink_priv *uplink_priv)
 	mlx5_tc_ct_clean(uplink_priv->ct_priv);
 	mlx5e_flow_meters_cleanup(uplink_priv->flow_meters);
 	mlx5e_tc_post_act_destroy(uplink_priv->post_act);
+	mlx5e_tc_act_stats_free(uplink_priv->action_stats_handle);
 }
 
 int mlx5e_tc_num_filters(struct mlx5e_priv *priv, unsigned long flags)
-- 
1.8.3.1

