Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56CE3F0293
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 13:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235481AbhHRLZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 07:25:57 -0400
Received: from mail-dm6nam10on2086.outbound.protection.outlook.com ([40.107.93.86]:49986
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235428AbhHRLZ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 07:25:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D3ArylxTPJih1HfCuOSfYhOF+O8JQ7X0WOR2mOncvWyMENdxoHVy5r1NtOIhgl4vMHtBwaL2gdEublLml9GzlkGpJcS2U/yWLu9Gu2JpxUa2AM9YFl6fIAo1gffrWEzJ76It6YYi2j4GUbd3Bbqt2yKv2VyREYRmbYr2w7Wq6Hq9OzmEsTFvEHH57Rb0IAUQqbnKx58+9G1N1bvDrRbKaOT5SBuUYpDl78Dt1osKl0pjGdUVYacsCqXmycQ3qpka9FIlShkUwdF0Nfb/QRgGQbtcJ34jkuXJh+1fsy210tUxOBcxRMH9Y+1af6IpNKwmlZLw9ufa0e+9zHYH1VUrQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BH2oOBdn1YhR9r+tZQIucAQ5hAiDTvvKjfnfLIOZMY4=;
 b=iGdGHRrEQNabNXzpFAjyNMlMaurdn36wnc/6WX70LBuV2DsRq61ARxqlgNW1Iyg+FzfuhhSaKrBoh4RG0hg3Marw0df+i+MKMIHWld0xB9NIy4b4YuTp7/6etTqs+0craJhV8PfOgiYW1xkBDI7r5VUyT1pSC3O+7zzUofP9wW+Vfllg3nA2shmI5EZ/Fhxf6Zpka6hShFl2lnIRmjN1e2jMDeGpr/A0HDbfmWdIdaLyW9BfKUDqrwPlCGdtJ4cH0W3m2vAJHlhouAyNRrbK65lrKP4QND+cgh2poXYdsr6fpZ3ZUuIH5iih+R4FZL2VRqdN+ZvXLK/IHeiRPJZTkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BH2oOBdn1YhR9r+tZQIucAQ5hAiDTvvKjfnfLIOZMY4=;
 b=CCkpOLPEj3EzqKa0BLIsrPjNbE24BV1RZ0PZ0RIp9WEihL19PxiZmGQbuQmcfimwTD+Gs6T3sTi55wklxf1iRh95Fa32da4rVZFzZ3NYqIUIM2CwM7aLEAFFBDuD9pdv3NDLpdvQrjhBajUlctJFUNzsxJej1GNSUGReW9kfdJiXSe7aT31YHaEwKfslaZUEAsXT9kBR9VBzMrAjEZt2uND2kNjKRgzCX2K3bd7ay90yLtdrMO5oRkxpLkWAEEdjpLko0RF4yjx5N1/uq0iGwmglxjc4WwXz0nSjnbumfl5EClJudEZnNe3C/zq+6rXhLy4gH5IS6QiGpg4mgphpnQ==
Received: from BN0PR03CA0010.namprd03.prod.outlook.com (2603:10b6:408:e6::15)
 by CY4PR1201MB2518.namprd12.prod.outlook.com (2603:10b6:903:d6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.22; Wed, 18 Aug
 2021 11:25:20 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::10) by BN0PR03CA0010.outlook.office365.com
 (2603:10b6:408:e6::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Wed, 18 Aug 2021 11:25:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4415.16 via Frontend Transport; Wed, 18 Aug 2021 11:25:19 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 04:25:18 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 11:25:17 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Aug 2021 11:25:15 +0000
From:   Mark Zhang <markzhang@nvidia.com>
To:     <jgg@nvidia.com>, <dledford@redhat.com>, <saeedm@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH rdma-next 02/10] net/mlx5: Add priorities for counters in RDMA namespaces
Date:   Wed, 18 Aug 2021 14:24:20 +0300
Message-ID: <20210818112428.209111-3-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20210818112428.209111-1-markzhang@nvidia.com>
References: <20210818112428.209111-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60402229-4e72-4a58-abd4-08d9623adcb2
X-MS-TrafficTypeDiagnostic: CY4PR1201MB2518:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB25180DC9E9BC048F02223598C7FF9@CY4PR1201MB2518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xbipdz0kYyUYle0/UF/QdaUsDipnsb7ptSE6IgTWjsnXQthDeL2KSpYy7xFhet0eV8GJC9kRWxjYcdWvSp31brFv9Di3aqxaF7LBQyR+NbVlAKBp3LQjhfVx6bilwgWiDZ/4KjfN02Cy8pFSPIs9kFcUmt+X4q8MbwBVLDj7SNx9LR/yydgIhrq2R29Xe7hU/N7QDqE0pHSykfwSUJdYc9l/w2HXiiMjieTOS5YHjk1l+/ZY09nmTmRSKA1B6Yp7WZd31HPWMn0BENM1m6jrN7mL6QgTVUcihrPmYID98ecqwDTveUlZx4XlTTvKjNtPcNAie4Qf+c2XGcMqOhVIgBz03ig26/FE9s1zWjsUBrp8tOm0CF2XFHF8M87QFO2Mjqet1BOXI+5Hmsz4M2pLMa23q9WE5XsatCx8WUKE5Hdf5CexQc10z+M8FfAC4OstyzLsKM22y1L9ZE5fwUgiDF5aSc5uy2PA6vnwySKZAtxFq0jHtN5xf9GCof8xHfyUCNxco4QrEMq23eU5QTSZHDKD1FFIFk0D60uKJEEq5PQzBdJMhoqbHo4U0bA+QDzpkUTcXfA+etbrl1gOPKchW5xvTAS1aYi6tAVt3LxcVNbX4BdzxUDaptBOYVHdeclcsrwL/Dvjw29f7x41kPUsZ0MjqvyIiham6PXkhfNugsQZkryZQcWsnq61cYAXgfgF97kBJafEWb6hnHgubVmOEg==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(39860400002)(36840700001)(46966006)(336012)(54906003)(47076005)(186003)(107886003)(2616005)(36756003)(26005)(4326008)(8676002)(1076003)(2906002)(6636002)(82310400003)(5660300002)(70206006)(8936002)(6666004)(110136005)(70586007)(7636003)(7696005)(83380400001)(36860700001)(356005)(82740400003)(86362001)(478600001)(316002)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 11:25:19.8398
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60402229-4e72-4a58-abd4-08d9623adcb2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2518
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Add additional flow steering priorities in the RDMA namespace.
This allows adding flow counters to count filtered RDMA traffic and then
continue processing in the regular RDMA steering flow.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 54 ++++++++++++++++---
 include/linux/mlx5/device.h                   |  2 +
 include/linux/mlx5/fs.h                       |  2 +
 3 files changed, 50 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index d7bf0a3e4a52..f9064661f2ec 100644
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
@@ -2212,6 +2244,12 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_RX_KERNEL) {
 		root_ns = steering->rdma_rx_root_ns;
 		prio = RDMA_RX_KERNEL_PRIO;
+	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_RX_COUNTERS) {
+		root_ns = steering->rdma_rx_root_ns;
+		prio = RDMA_RX_COUNTERS_PRIO;
+	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_TX_COUNTERS) {
+		root_ns = steering->rdma_tx_root_ns;
+		prio = RDMA_TX_COUNTERS_PRIO;
 	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_TX) {
 		root_ns = steering->rdma_tx_root_ns;
 	} else { /* Must be NIC RX */
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 0025913505ab..c2c0380fd608 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1453,6 +1453,8 @@ static inline u16 mlx5_to_sw_pkey_sz(int pkey_sz)
 	return MLX5_MIN_PKEY_TABLE_SIZE << pkey_sz;
 }
 
+#define MLX5_RDMA_RX_NUM_COUNTERS_PRIOS 2
+#define MLX5_RDMA_TX_NUM_COUNTERS_PRIOS 1
 #define MLX5_BY_PASS_NUM_REGULAR_PRIOS 16
 #define MLX5_BY_PASS_NUM_DONT_TRAP_PRIOS 16
 #define MLX5_BY_PASS_NUM_MULTICAST_PRIOS 1
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 77746f7e35b8..39722897e5c7 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -81,6 +81,8 @@ enum mlx5_flow_namespace_type {
 	MLX5_FLOW_NAMESPACE_RDMA_RX,
 	MLX5_FLOW_NAMESPACE_RDMA_RX_KERNEL,
 	MLX5_FLOW_NAMESPACE_RDMA_TX,
+	MLX5_FLOW_NAMESPACE_RDMA_RX_COUNTERS,
+	MLX5_FLOW_NAMESPACE_RDMA_TX_COUNTERS,
 };
 
 enum {
-- 
2.26.2

