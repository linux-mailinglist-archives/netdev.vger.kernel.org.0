Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1845C426AB2
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 14:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241501AbhJHM2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 08:28:00 -0400
Received: from mail-sn1anam02on2059.outbound.protection.outlook.com ([40.107.96.59]:7621
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241478AbhJHM16 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 08:27:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KKC6hhIo9Y1fw0FzIbd+x5Gda8sZ0eJQGjAs3FojRbKhyIQAv2GEM4UclzAAtmlND+AJ4FKEt+6Lg3vKW8OF7+vbDV0+qxt+uRdl5o0+dxi11WSSiEv/1Xpo79G5XERICIbpCUadh9BV248oMdBXOHkjzDNb5kX1U3zEu4LjqP1oYyyMhW4n3ypDjKKSUWw1rh9atatCRjl3gKSkCoG24VAlkWOGz6tjxOVTGHCOPy74jOnDtXSfTp1wW6JW/svuxXNdq2Q8qlETEaAGJWJ87ipxUiQUjszZVWHN5ReP1ac08x3M4jyqDZY0G1LfOmo3Y3DNN1wIR9vTrL/7frxWSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CJeF8rsZbSjZJ8vBXHRnEokE9p6ICrdoro9XuaDbr4c=;
 b=W9bdgrk2QWNF903YaTHqQdb8SeBTt8cjkZY4CQ7lqhYdmEuFFmZCaiN8sYlqH4ryzMf9cWUnaN9KTXPhXZcfwZBy0xPfVTPs2qlU+G9mAkLeW+uSK1iOctWQUOjxwRG0qbW72bDGQgPMutr/32edghNmo0OkyOuyKiSzxYd5EGmSlI6M7q6LjvvA4vz/Mkq0BmwCeBy/+sN87Q/2id9JvWGWS9vabgR4FZZmGXhH+EEDnvmRzJYJ6H+QJwvg+iqEZEiXHnJgZyj8PyEALXW1Gtqfe5C+vdoWIuLaducOU4QAJgzU29nc7+wppFl9MjkitkdduTcokzxq+C0YJa/Peg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=chelsio.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CJeF8rsZbSjZJ8vBXHRnEokE9p6ICrdoro9XuaDbr4c=;
 b=PwndSWj/5iCD3l0Zy4nF0+Zy0XEPfGzrj7OWdhn57gBeeHC4X9MmNV6x/gKD8whDgR/Uprfyoz0ZSKgP90QgFewh8SHPJ5wHJr595JwLPbWRUx65TPwpAmbbUCf2GIMqK8PNpqaNvjN5BEqlZW4DribfzeJEME0KozVIbMsw8CpuQEgK8Dmx6xSd+48/CrmRyok7GC9Mfqsgh6PR9cMyz6nd9WvdV1JVuuuWwH2zzsHwc+f5EiddOuMZc8V6+N8uyEQqil1/N4iaw+yWT5V08VTGjy6ex4dJ7edfMqKy4GVTkxpTWulsM39WkVo1OW3uovpfi4XxgbKrwNWNSCjziQ==
Received: from MWHPR12CA0072.namprd12.prod.outlook.com (2603:10b6:300:103::34)
 by MN2PR12MB4335.namprd12.prod.outlook.com (2603:10b6:208:1d4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Fri, 8 Oct
 2021 12:26:01 +0000
Received: from CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:103:cafe::9c) by MWHPR12CA0072.outlook.office365.com
 (2603:10b6:300:103::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend
 Transport; Fri, 8 Oct 2021 12:26:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; chelsio.com; dkim=none (message not signed)
 header.d=none;chelsio.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT068.mail.protection.outlook.com (10.13.175.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 12:26:00 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 8 Oct
 2021 12:25:59 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 8 Oct 2021 05:25:55 -0700
From:   Mark Zhang <markzhang@nvidia.com>
To:     <jgg@nvidia.com>, <dledford@redhat.com>, <saeedm@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        <dennis.dalessandro@cornelisnetworks.com>, <galpress@amazon.com>,
        <kuba@kernel.org>, <maorg@nvidia.com>,
        <mike.marciniszyn@cornelisnetworks.com>,
        <mustafa.ismail@intel.com>, <bharat@chelsio.com>,
        <selvin.xavier@broadcom.com>, <shiraz.saleem@intel.com>,
        <yishaih@nvidia.com>, <zyjzyj2000@gmail.com>,
        "Mark Zhang" <markzhang@nvidia.com>
Subject: [PATCH rdma-next v4 02/13] net/mlx5: Add priorities for counters in RDMA namespaces
Date:   Fri, 8 Oct 2021 15:24:28 +0300
Message-ID: <20211008122439.166063-3-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20211008122439.166063-1-markzhang@nvidia.com>
References: <20211008122439.166063-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 517d0802-c923-49e7-2fbc-08d98a56c9bf
X-MS-TrafficTypeDiagnostic: MN2PR12MB4335:
X-Microsoft-Antispam-PRVS: <MN2PR12MB43357615D1FB5FFC5ED6A293C7B29@MN2PR12MB4335.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ujsesgAaucipN3pD8JvqzSDYIJ6l4jxRYgkwrSOqwpsuR1VaGknHIsftgefDDaiCItHIU6TgifmQ28tX4xnjC/XX1VWxIreEUP4ur7QeFMGHxcgCEVTPwsxMRzDUkgNl4/FodfKnh67EnDVZp+WHg7cViqvDZaI6eA5hPV8yR5z419kvm54J8GZl9GLkeHo/RylpgFxJBzSeOcNDxtyv8ephN19XwPI1XLBm/TeiZstXQOpHkDWbH8fbKTIyX2RkNsEfA3z0AJeC136l59i+ZMFl9O5WMHpuSPwIdGzI9/XzBUIRQm+bSFb4eTyWD/cNCsLWXe1B3g4xnDkNDtQB954zHTFzei+u2JlBBu8n1S+IPQoes4iM+FKu8lEeHNQI1/nYCwFCWajY1CNIImMBfvp49Rqd1BR9D3GCFrOymHDb3FKXID6Sjav0o4BoseGhR0ArHZVg9JWoOAUDLyjYssOSovurYwiNu4yBo2aB4rijRlXVn2R5w9oLaza3eh3tin6SwoTCYMg6wS71zQqLfKu4nZTuBM0rfCZqRQQ06KEC6e+VkDiPx/PolNMZnHV3urNEsQb5x+oMcmXXzx+tNcJFXCFa2bgMcPR5AqYOa1qBcnoOapeolV2ZfqTXPfvnaIdsh0mRiif98jdKuIUexaBMXJzz7/ZS2CQRrAs3afpy/Vt3zJFFK41nIzzGo2U7nIyXMdT94y8R4Q7B3a8yAg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(8936002)(2906002)(82310400003)(36860700001)(186003)(1076003)(26005)(508600001)(4326008)(86362001)(36756003)(8676002)(6666004)(107886003)(7696005)(336012)(54906003)(47076005)(2616005)(70586007)(316002)(83380400001)(426003)(70206006)(6636002)(7416002)(7636003)(5660300002)(356005)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 12:26:00.5047
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 517d0802-c923-49e7-2fbc-08d98a56c9bf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4335
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Add additional flow steering priorities in the RDMA namespace.
This allows adding flow counters to count filtered RDMA traffic and then
continue processing in the regular RDMA steering flow.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 54 ++++++++++++++++---
 include/linux/mlx5/device.h                   |  2 +
 include/linux/mlx5/fs.h                       |  2 +
 3 files changed, 50 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index fe501ba88bea..71a08f84d49d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -99,6 +99,9 @@
 #define LEFTOVERS_NUM_LEVELS 1
 #define LEFTOVERS_NUM_PRIOS 1
 
+#define RDMA_RX_COUNTERS_PRIO_NUM_LEVELS 1
+#define RDMA_TX_COUNTERS_PRIO_NUM_LEVELS 1
+
 #define BY_PASS_PRIO_NUM_LEVELS 1
 #define BY_PASS_MIN_LEVEL (ETHTOOL_MIN_LEVEL + MLX5_BY_PASS_NUM_PRIOS +\
 			   LEFTOVERS_NUM_PRIOS)
@@ -206,34 +209,63 @@ static struct init_tree_node egress_root_fs = {
 	}
 };
 
-#define RDMA_RX_BYPASS_PRIO 0
-#define RDMA_RX_KERNEL_PRIO 1
+enum {
+	RDMA_RX_COUNTERS_PRIO,
+	RDMA_RX_BYPASS_PRIO,
+	RDMA_RX_KERNEL_PRIO,
+};
+
+#define RDMA_RX_BYPASS_MIN_LEVEL MLX5_BY_PASS_NUM_REGULAR_PRIOS
+#define RDMA_RX_KERNEL_MIN_LEVEL (RDMA_RX_BYPASS_MIN_LEVEL + 1)
+#define RDMA_RX_COUNTERS_MIN_LEVEL (RDMA_RX_KERNEL_MIN_LEVEL + 2)
+
 static struct init_tree_node rdma_rx_root_fs = {
 	.type = FS_TYPE_NAMESPACE,
-	.ar_size = 2,
+	.ar_size = 3,
 	.children = (struct init_tree_node[]) {
+		[RDMA_RX_COUNTERS_PRIO] =
+		ADD_PRIO(0, RDMA_RX_COUNTERS_MIN_LEVEL, 0,
+			 FS_CHAINING_CAPS,
+			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
+				ADD_MULTIPLE_PRIO(MLX5_RDMA_RX_NUM_COUNTERS_PRIOS,
+						  RDMA_RX_COUNTERS_PRIO_NUM_LEVELS))),
 		[RDMA_RX_BYPASS_PRIO] =
-		ADD_PRIO(0, MLX5_BY_PASS_NUM_REGULAR_PRIOS, 0,
+		ADD_PRIO(0, RDMA_RX_BYPASS_MIN_LEVEL, 0,
 			 FS_CHAINING_CAPS,
 			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
 				ADD_MULTIPLE_PRIO(MLX5_BY_PASS_NUM_REGULAR_PRIOS,
 						  BY_PASS_PRIO_NUM_LEVELS))),
 		[RDMA_RX_KERNEL_PRIO] =
-		ADD_PRIO(0, MLX5_BY_PASS_NUM_REGULAR_PRIOS + 1, 0,
+		ADD_PRIO(0, RDMA_RX_KERNEL_MIN_LEVEL, 0,
 			 FS_CHAINING_CAPS,
 			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_SWITCH_DOMAIN,
 				ADD_MULTIPLE_PRIO(1, 1))),
 	}
 };
 
+enum {
+	RDMA_TX_COUNTERS_PRIO,
+	RDMA_TX_BYPASS_PRIO,
+};
+
+#define RDMA_TX_BYPASS_MIN_LEVEL MLX5_BY_PASS_NUM_PRIOS
+#define RDMA_TX_COUNTERS_MIN_LEVEL (RDMA_TX_BYPASS_MIN_LEVEL + 1)
+
 static struct init_tree_node rdma_tx_root_fs = {
 	.type = FS_TYPE_NAMESPACE,
-	.ar_size = 1,
+	.ar_size = 2,
 	.children = (struct init_tree_node[]) {
-		ADD_PRIO(0, MLX5_BY_PASS_NUM_PRIOS, 0,
+		[RDMA_TX_COUNTERS_PRIO] =
+		ADD_PRIO(0, RDMA_TX_COUNTERS_MIN_LEVEL, 0,
+			 FS_CHAINING_CAPS,
+			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
+				ADD_MULTIPLE_PRIO(MLX5_RDMA_TX_NUM_COUNTERS_PRIOS,
+						  RDMA_TX_COUNTERS_PRIO_NUM_LEVELS))),
+		[RDMA_TX_BYPASS_PRIO] =
+		ADD_PRIO(0, RDMA_TX_BYPASS_MIN_LEVEL, 0,
 			 FS_CHAINING_CAPS_RDMA_TX,
 			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
-				ADD_MULTIPLE_PRIO(MLX5_BY_PASS_NUM_PRIOS,
+				ADD_MULTIPLE_PRIO(RDMA_TX_BYPASS_MIN_LEVEL,
 						  BY_PASS_PRIO_NUM_LEVELS))),
 	}
 };
@@ -2215,6 +2247,12 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 		prio = RDMA_RX_KERNEL_PRIO;
 	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_TX) {
 		root_ns = steering->rdma_tx_root_ns;
+	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_RX_COUNTERS) {
+		root_ns = steering->rdma_rx_root_ns;
+		prio = RDMA_RX_COUNTERS_PRIO;
+	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_TX_COUNTERS) {
+		root_ns = steering->rdma_tx_root_ns;
+		prio = RDMA_TX_COUNTERS_PRIO;
 	} else { /* Must be NIC RX */
 		root_ns = steering->root_ns;
 		prio = type;
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 66eaf0aa7f69..ed0230ff9422 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1456,6 +1456,8 @@ static inline u16 mlx5_to_sw_pkey_sz(int pkey_sz)
 	return MLX5_MIN_PKEY_TABLE_SIZE << pkey_sz;
 }
 
+#define MLX5_RDMA_RX_NUM_COUNTERS_PRIOS 2
+#define MLX5_RDMA_TX_NUM_COUNTERS_PRIOS 1
 #define MLX5_BY_PASS_NUM_REGULAR_PRIOS 16
 #define MLX5_BY_PASS_NUM_DONT_TRAP_PRIOS 16
 #define MLX5_BY_PASS_NUM_MULTICAST_PRIOS 1
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 0106c67e8ccb..f2c3da2006d9 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -83,6 +83,8 @@ enum mlx5_flow_namespace_type {
 	MLX5_FLOW_NAMESPACE_RDMA_RX,
 	MLX5_FLOW_NAMESPACE_RDMA_RX_KERNEL,
 	MLX5_FLOW_NAMESPACE_RDMA_TX,
+	MLX5_FLOW_NAMESPACE_RDMA_RX_COUNTERS,
+	MLX5_FLOW_NAMESPACE_RDMA_TX_COUNTERS,
 };
 
 enum {
-- 
2.26.2

