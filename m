Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A073D2273
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbhGVKYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:24:50 -0400
Received: from mail-mw2nam12on2068.outbound.protection.outlook.com ([40.107.244.68]:54241
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231751AbhGVKYj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:24:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nkcTYaOJ6Hqs4yeh8Y2rmwYU1zuAArHWtal8fIERAgqMXgRGWJdzd1zHwHZOrw4uJx/DTP2CWWEd0DE12BgatykO5rfWBc3tml9eT1FIOWvY5Tdb0eKm3LeOsgsvdUrPFtHW2dg8TAV7y8m6qSWNFzLchaOyXM5vRBgYPPfo0cpQJcpw+o4E+timhZXFaxyg9r6HKGcV+UrMwoyydxU4bpN40d+4Uk5JwK8LIyxgFguX6YYfb2J5RYF8uJUh0BbsK1JJugwzkfACWcBACvR4pDLSy+zosgpEYhZ/9Zo6rKUAZgOnCU0w01PvZgsRVcizHJRdgAY+jXyxc0cJ5m5mIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPpZMFDexWhzDg1HOgN0yPn8umTF5Qbp4zxP4N/zjE4=;
 b=eKAJGtMb4cqMox7OkSKejgsBX5HCefUuCDTHZVTvKWpAW6EnM5iaVG5xzDnsPp5eXplaXgbyGtTjf17v+J+9/0+Hw3XgVCjtsj+EKhgcKAzIhaPKWk57fzvGnVnd4mOJIbg3FCfWLZpDmz1+oEBNF8NMc81NXGqg5oUyAcFPhvvj+LEmmGg3OZy/e9/DBh90f6MRETBuegftYqIhLJ/KiYtr0eQf1/ESPlTi35fheWT8i+tETHZWwEwFRjUl1NzTK1zZbb8MI9NcVQnx7JBhrpNe3FtORl2+j3bcV8a7HqQBgE/Xlr8UGbnlIapHLaYnkaRkquNv1VH67yq9qYorig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=marvell.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPpZMFDexWhzDg1HOgN0yPn8umTF5Qbp4zxP4N/zjE4=;
 b=EbJrdG4DD75Ks0krhIT3Z0rHrfp6zgyf9SU/BMs6mXVLrgnogQtGK/Tu1AD2Bxf35ENCQO7jbxX+2ZzT6f8GiOy9SI6syWnFRsEaGS77v+XY1aTtUdlBXj/q/iZAOnWI4VDVHLBFM7Wn7elYyrYn9VKrOoIt6IoQB+EOSpaF4JBV2ykOEZv3lghlJ2IQE7yJmXvqaza7PuK32ROsD+4U7GKvFK5KmsNt5+uk0meoZ5n0GsSS2ZaF8o7xu+xfVz34mUpssAFXVxHU9Mytb2HQjbUI3suSfWzBjKKFSbd2vdPXXymH7v5rMkWSDQV+SCUglQER56/OcAYRtUWkdtCZRw==
Received: from BN0PR04CA0005.namprd04.prod.outlook.com (2603:10b6:408:ee::10)
 by BL1PR12MB5173.namprd12.prod.outlook.com (2603:10b6:208:308::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22; Thu, 22 Jul
 2021 11:05:12 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::5c) by BN0PR04CA0005.outlook.office365.com
 (2603:10b6:408:ee::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23 via Frontend
 Transport; Thu, 22 Jul 2021 11:05:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:05:12 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:05:11 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:05:07 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v5 net-next 12/36] net/mlx5e: NVMEoTCP offload initialization
Date:   Thu, 22 Jul 2021 14:03:01 +0300
Message-ID: <20210722110325.371-13-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9cf560c-4007-4d40-d0a3-08d94d0093f6
X-MS-TrafficTypeDiagnostic: BL1PR12MB5173:
X-Microsoft-Antispam-PRVS: <BL1PR12MB517376ADA3EDB8E9562BB5BBBDE49@BL1PR12MB5173.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:268;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3lWZqYRSmYl/3OJtTWmsBsod0gZJsEgji0jUhq0dQwwv8zzouFU5DZuB+VUkvr/0zrRmNcWHv4NkfGgMX0khHSoCuP5uotPjT6U5UyGbhg8+4IuWe5vE0uNec6Vakmd4YJ8XY58MaTojFhXxGUVJrSeA7m1U4Eq9v7rZXzGoPR6lY4dZnrDuJKWPbqk0GLCjyc81S1H6Xj3nMDfLjHjaihOewb81TaARHdwQlistFkyT53OLj0IUADJVKdjFhjxwFlEGf2tH+299xYwHCX00Pl7w3CVam0X1TCDPwXMUc5gyzp4JdInbSbkhA47RWKvxlPElM+jdFpM86qlpQPVCoLzS//KGpsFbrg6xvTnlOHo+8ME/RiTfiK3V+tTrl2oSSyIh2ag86khj1rjj0uhZ1zuKvnOsyb3wb20qLsKHNqGRcoHOtqhTXkCeItKs4EncnveMsdvGgw2o6hpD0sx6C5uF3Bchj3+cOYjp/x6227GBTFLWsPLP6kT+f1G670395z66JZP8lwRRZPzSX2gWvOk1a3xrbdi9IitW+OrLon6V40IL+F1skJOWTQu/D/lPOoEab4ScgVUKiO0XfKjLpzwGPU1BLnt86H964/qe5uxcxB1bZUkTiQD4sxv6W920HlCORU6AyLfSr4RPURLmKxxylk95ZcyjJmbxvwaBXQ1JCZvhifbc4sy4LSOM/rfz9uqRRJy+ucCwv5KQThBTCKWKJTa3eor9WoUMwrpxS8A=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39860400002)(36840700001)(46966006)(356005)(7636003)(83380400001)(82310400003)(70586007)(86362001)(70206006)(7416002)(316002)(6666004)(426003)(336012)(82740400003)(4326008)(2906002)(107886003)(8676002)(36756003)(54906003)(110136005)(36906005)(1076003)(30864003)(921005)(8936002)(47076005)(7696005)(186003)(2616005)(478600001)(36860700001)(26005)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:05:12.5771
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9cf560c-4007-4d40-d0a3-08d94d0093f6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5173
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

This commit introduce the initialization blocks for NVMEoTCP offload:
- Use 128B CQEs when NVME-TCP offload is enabled.
- Use a dedicated icosq for NVME-TCP work. This list of SQ is unique in the
  sense that it is driven directly by the NVME-TCP layer to submit and
  invalidate ddp requests.
- Query nvmeotcp capabilities

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |  10 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  11 +
 .../ethernet/mellanox/mlx5/core/en/params.c   |  11 +-
 .../ethernet/mellanox/mlx5/core/en/params.h   |   3 +
 .../mellanox/mlx5/core/en_accel/en_accel.h    |   9 +-
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 196 ++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/nvmeotcp.h    | 117 +++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  26 +++
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c |  17 ++
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |   6 +
 11 files changed, 405 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index e1a5a79e27c7..e6079ff2e917 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -233,3 +233,13 @@ config MLX5_SF_MANAGER
 	port is managed through devlink.  A subfunction supports RDMA, netdevice
 	and vdpa device. It is similar to a SRIOV VF but it doesn't require
 	SRIOV support.
+
+config MLX5_EN_NVMEOTCP
+	bool "NVMEoTCP accelaration"
+	depends on MLX5_CORE_EN
+	depends on ULP_DDP=y
+	default n
+	help
+	Build support for NVMEoTCP accelaration in the NIC.
+	Note: Support for hardware with this capability needs to be selected
+	for this option to become available.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index b5072a3a2585..0ae9e5e38ec7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -101,3 +101,5 @@ mlx5_core-$(CONFIG_MLX5_SF) += sf/vhca_event.o sf/dev/dev.o sf/dev/driver.o
 # SF manager
 #
 mlx5_core-$(CONFIG_MLX5_SF_MANAGER) += sf/cmd.o sf/hw_table.o sf/devlink.o
+
+mlx5_core-$(CONFIG_MLX5_EN_NVMEOTCP) += en_accel/fs_tcp.o en_accel/nvmeotcp.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index b1b51bbba054..1233ebcf311b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -270,6 +270,10 @@ struct mlx5e_params {
 	unsigned int sw_mtu;
 	int hard_mtu;
 	bool ptp_rx;
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	bool nvmeotcp;
+	bool crc_rx_offload;
+#endif
 };
 
 enum {
@@ -678,6 +682,10 @@ struct mlx5e_channel {
 	struct mlx5e_txqsq         sq[MLX5E_MAX_NUM_TC];
 	struct mlx5e_icosq         icosq;   /* internal control operations */
 	struct mlx5e_txqsq __rcu * __rcu *qos_sqs;
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	struct list_head	   list_nvmeotcpsq;   /* nvmeotcp umrs  */
+	spinlock_t                 nvmeotcp_icosq_lock;
+#endif
 	bool                       xdp;
 	struct napi_struct         napi;
 	struct device             *pdev;
@@ -886,6 +894,9 @@ struct mlx5e_priv {
 #endif
 #ifdef CONFIG_MLX5_EN_TLS
 	struct mlx5e_tls          *tls;
+#endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	struct mlx5e_nvmeotcp      *nvmeotcp;
 #endif
 	struct devlink_health_reporter *tx_reporter;
 	struct devlink_health_reporter *rx_reporter;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 150c8e82c738..a84508425e47 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -437,7 +437,8 @@ static void mlx5e_build_common_cq_param(struct mlx5_core_dev *mdev,
 	void *cqc = param->cqc;
 
 	MLX5_SET(cqc, cqc, uar_page, mdev->priv.uar->index);
-	if (MLX5_CAP_GEN(mdev, cqe_128_always) && cache_line_size() >= 128)
+	if (MLX5_CAP_GEN(mdev, cqe_128_always) &&
+	   (cache_line_size() >= 128 || param->force_cqe128))
 		MLX5_SET(cqc, cqc, cqe_sz, CQE_STRIDE_128_PAD);
 }
 
@@ -450,6 +451,12 @@ static void mlx5e_build_rx_cq_param(struct mlx5_core_dev *mdev,
 	void *cqc = param->cqc;
 	u8 log_cq_size;
 
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	/* nvme-tcp offload mandates 128 byte cqes */
+	param->force_cqe128 |= (params->nvmeotcp|| params->crc_rx_offload);
+#endif
+
+
 	switch (params->rq_wq_type) {
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
 		log_cq_size = mlx5e_mpwqe_get_log_rq_size(params, xsk) +
@@ -620,7 +627,7 @@ static u8 mlx5e_build_async_icosq_log_wq_sz(struct mlx5_core_dev *mdev)
 	return MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE;
 }
 
-static void mlx5e_build_icosq_param(struct mlx5_core_dev *mdev,
+void mlx5e_build_icosq_param(struct mlx5_core_dev *mdev,
 				    u8 log_wq_size,
 				    struct mlx5e_sq_param *param)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index e9593f5f0661..4f232ba726ec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -16,6 +16,7 @@ struct mlx5e_cq_param {
 	struct mlx5_wq_param       wq;
 	u16                        eq_ix;
 	u8                         cq_period_mode;
+	bool                       force_cqe128;
 };
 
 struct mlx5e_rq_param {
@@ -147,6 +148,8 @@ int mlx5e_build_channel_param(struct mlx5_core_dev *mdev,
 			      struct mlx5e_params *params,
 			      u16 q_counter,
 			      struct mlx5e_channel_param *cparam);
+void mlx5e_build_icosq_param(struct mlx5_core_dev *mdev,
+			     u8 log_wq_size,struct mlx5e_sq_param *param);
 
 u16 mlx5e_calc_sq_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
 int mlx5e_validate_params(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index d964665eaa63..b9404366e6e8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -39,6 +39,7 @@
 #include "en_accel/ipsec_rxtx.h"
 #include "en_accel/tls.h"
 #include "en_accel/tls_rxtx.h"
+#include "en_accel/nvmeotcp.h"
 #include "en.h"
 #include "en/txrx.h"
 
@@ -195,11 +196,17 @@ static inline void mlx5e_accel_tx_finish(struct mlx5e_txqsq *sq,
 
 static inline int mlx5e_accel_init_rx(struct mlx5e_priv *priv)
 {
-	return mlx5e_ktls_init_rx(priv);
+	int tls, nvmeotcp;
+
+	tls = mlx5e_ktls_init_rx(priv);
+	nvmeotcp = mlx5e_nvmeotcp_init_rx(priv);
+
+	return tls && nvmeotcp;
 }
 
 static inline void mlx5e_accel_cleanup_rx(struct mlx5e_priv *priv)
 {
+	mlx5e_nvmeotcp_cleanup_rx(priv);
 	mlx5e_ktls_cleanup_rx(priv);
 }
 #endif /* __MLX5E_EN_ACCEL_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
new file mode 100644
index 000000000000..04e88042b243
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -0,0 +1,196 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2021 Mellanox Technologies. */
+
+#include <linux/netdevice.h>
+#include <linux/idr.h>
+#include "en_accel/nvmeotcp.h"
+#include "en_accel/fs_tcp.h"
+#include "en/txrx.h"
+
+#define MAX_NVMEOTCP_QUEUES	(512)
+#define MIN_NVMEOTCP_QUEUES	(1)
+
+static const struct rhashtable_params rhash_queues = {
+	.key_len = sizeof(int),
+	.key_offset = offsetof(struct mlx5e_nvmeotcp_queue, id),
+	.head_offset = offsetof(struct mlx5e_nvmeotcp_queue, hash),
+	.automatic_shrinking = true,
+	.min_size = 1,
+	.max_size = MAX_NVMEOTCP_QUEUES,
+};
+
+static int
+mlx5e_nvmeotcp_offload_limits(struct net_device *netdev,
+			      struct ulp_ddp_limits *limits)
+{
+	return 0;
+}
+
+static int
+mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
+			  struct sock *sk,
+			  struct ulp_ddp_config *tconfig)
+{
+	return 0;
+}
+
+static void
+mlx5e_nvmeotcp_queue_teardown(struct net_device *netdev,
+			      struct sock *sk)
+{
+}
+
+static int
+mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
+			 struct sock *sk,
+			 struct ulp_ddp_io *ddp)
+{
+	return 0;
+}
+
+static int
+mlx5e_nvmeotcp_ddp_teardown(struct net_device *netdev,
+			    struct sock *sk,
+			    struct ulp_ddp_io *ddp,
+			    void *ddp_ctx)
+{
+	return 0;
+}
+
+static void
+mlx5e_nvmeotcp_dev_resync(struct net_device *netdev,
+			  struct sock *sk, u32 seq)
+{
+}
+
+static const struct ulp_ddp_dev_ops mlx5e_nvmeotcp_ops = {
+	.ulp_ddp_limits = mlx5e_nvmeotcp_offload_limits,
+	.ulp_ddp_sk_add = mlx5e_nvmeotcp_queue_init,
+	.ulp_ddp_sk_del = mlx5e_nvmeotcp_queue_teardown,
+	.ulp_ddp_setup = mlx5e_nvmeotcp_ddp_setup,
+	.ulp_ddp_teardown = mlx5e_nvmeotcp_ddp_teardown,
+	.ulp_ddp_resync = mlx5e_nvmeotcp_dev_resync,
+};
+
+int set_feature_nvme_tcp(struct net_device *netdev, bool enable)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_params *params = &priv->channels.params;
+	int err = 0;
+
+	mutex_lock(&priv->state_lock);
+	if (enable)
+		err = mlx5e_accel_fs_tcp_create(priv);
+	else
+		mlx5e_accel_fs_tcp_destroy(priv);
+	mutex_unlock(&priv->state_lock);
+	if (err)
+		return err;
+
+	params->nvmeotcp = enable;
+	priv->nvmeotcp->enable = enable;
+	err = mlx5e_safe_reopen_channels(priv);
+	return err;
+}
+
+int set_feature_nvme_tcp_crc(struct net_device *netdev, bool enable)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_params *params = &priv->channels.params;
+	int err = 0;
+
+	mutex_lock(&priv->state_lock);
+	if (enable)
+		err = mlx5e_accel_fs_tcp_create(priv);
+	else
+		mlx5e_accel_fs_tcp_destroy(priv);
+	mutex_unlock(&priv->state_lock);
+
+	params->crc_rx_offload = enable;
+	priv->nvmeotcp->crc_rx_enable = enable;
+	err = mlx5e_safe_reopen_channels(priv);
+	if (err)
+		netdev_err(priv->netdev,
+			   "%s failed to reopen channels, err(%d).\n",
+			   __func__, err);
+
+	return err;
+}
+
+void mlx5e_nvmeotcp_build_netdev(struct mlx5e_priv *priv)
+{
+	struct net_device *netdev = priv->netdev;
+
+	if (!MLX5_CAP_GEN(priv->mdev, nvmeotcp))
+		return;
+
+	if (MLX5_CAP_DEV_NVMEOTCP(priv->mdev, zerocopy)) {
+		netdev->features |= NETIF_F_HW_ULP_DDP;
+		netdev->hw_features |= NETIF_F_HW_ULP_DDP;
+	}
+
+	if (MLX5_CAP_DEV_NVMEOTCP(priv->mdev, crc_rx)) {
+		netdev->features |= NETIF_F_HW_ULP_DDP;
+		netdev->hw_features |= NETIF_F_HW_ULP_DDP;
+	}
+
+	netdev->ulp_ddp_ops = &mlx5e_nvmeotcp_ops;
+}
+
+int mlx5e_nvmeotcp_init_rx(struct mlx5e_priv *priv)
+{
+	int ret = 0;
+
+	if (priv->netdev->features & NETIF_F_HW_ULP_DDP) {
+		ret = mlx5e_accel_fs_tcp_create(priv);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+
+void mlx5e_nvmeotcp_cleanup_rx(struct mlx5e_priv *priv)
+{
+	if (priv->netdev->features & NETIF_F_HW_ULP_DDP)
+		mlx5e_accel_fs_tcp_destroy(priv);
+}
+
+int mlx5e_nvmeotcp_init(struct mlx5e_priv *priv)
+{
+	struct mlx5e_nvmeotcp *nvmeotcp = kzalloc(sizeof(*nvmeotcp), GFP_KERNEL);
+	int ret = 0;
+
+	if (!nvmeotcp)
+		return -ENOMEM;
+
+	ida_init(&nvmeotcp->queue_ids);
+	ret = rhashtable_init(&nvmeotcp->queue_hash, &rhash_queues);
+	if (ret)
+		goto err_ida;
+
+	priv->nvmeotcp = nvmeotcp;
+	priv->nvmeotcp->enable = true;
+	priv->channels.params.nvmeotcp = nvmeotcp;
+	priv->channels.params.nvmeotcp = true;
+	goto out;
+
+err_ida:
+	ida_destroy(&nvmeotcp->queue_ids);
+	kfree(nvmeotcp);
+out:
+	return ret;
+}
+
+void mlx5e_nvmeotcp_cleanup(struct mlx5e_priv *priv)
+{
+	struct mlx5e_nvmeotcp *nvmeotcp = priv->nvmeotcp;
+
+	if (!nvmeotcp)
+		return;
+
+	rhashtable_destroy(&nvmeotcp->queue_hash);
+	ida_destroy(&nvmeotcp->queue_ids);
+	kfree(nvmeotcp);
+	priv->nvmeotcp = NULL;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
new file mode 100644
index 000000000000..b4a27a03578e
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
@@ -0,0 +1,117 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021 Mellanox Technologies. */
+#ifndef __MLX5E_NVMEOTCP_H__
+#define __MLX5E_NVMEOTCP_H__
+
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+
+#include "net/ulp_ddp.h"
+#include "en.h"
+#include "en/params.h"
+
+struct nvmeotcp_queue_entry {
+	struct mlx5e_nvmeotcp_queue	*queue;
+	u32				sgl_length;
+	struct mlx5_core_mkey		klm_mkey;
+	struct scatterlist		*sgl;
+	u32				ccid_gen;
+	u64				size;
+
+	/* for the ddp invalidate done callback */
+	void				*ddp_ctx;
+	struct ulp_ddp_io		*ddp;
+};
+
+struct mlx5e_nvmeotcp_sq {
+	struct list_head		list;
+	struct mlx5e_icosq		icosq;
+};
+
+/**
+ *	struct mlx5e_nvmeotcp_queue - MLX5 metadata for NVMEoTCP queue
+ *	@fh: Flow handle representing the 5-tuple steering for this flow
+ *	@tirn: Destination TIR number created for NVMEoTCP offload
+ *	@id: Flow tag ID used to identify this queue
+ *	@size: NVMEoTCP queue depth
+ *	@sq: Send queue used for sending control messages
+ *	@nvmeotcp_icosq_lock: Spin lock for icosq
+ *	@ccid_table: Table holding metadata for each CC
+ *	@tag_buf_table_id: Tag buffer table for CCIDs
+ *	@hash: Hash table of queues mapped by @id
+ *	@ref_count: Reference count for this structure
+ *	@ccoff: Offset within the current CC
+ *	@pda: Padding alignment
+ *	@ccid_gen: Generation ID for the CCID, used to avoid conflicts in DDP
+ *	@max_klms_per_wqe: Number of KLMs per DDP operation
+ *	@channel_ix: Channel IX for this nvmeotcp_queue
+ *	@sk: The socket used by the NVMe-TCP queue
+ *	@zerocopy: if this queue is used for zerocopy offload.
+ *	@crc_rx: if this queue is used for CRC Rx offload.
+ *	@ccid: ID of the current CC
+ *	@ccsglidx: Index within the scatter-gather list (SGL) of the current CC
+ *	@ccoff_inner: Current offset within the @ccsglidx element
+ *	@priv: mlx5e netdev priv
+ *	@inv_done: invalidate callback of the nvme tcp driver
+ *	@after_resync_cqe: indicate if resync occurred
+ */
+struct mlx5e_nvmeotcp_queue {
+	struct ulp_ddp_ctx		ulp_ddp_ctx;
+	struct mlx5_flow_handle		*fh;
+	int				tirn;
+	int				id;
+	u32				size;
+	struct mlx5e_nvmeotcp_sq	*sq;
+	spinlock_t                      nvmeotcp_icosq_lock;
+	struct nvmeotcp_queue_entry	*ccid_table;
+	u32				tag_buf_table_id;
+	struct rhash_head		hash;
+	refcount_t			ref_count;
+	bool				dgst;
+	int				pda;
+	u32				ccid_gen;
+	u32				max_klms_per_wqe;
+	u32				channel_ix;
+	struct sock			*sk;
+	bool				zerocopy;
+	bool				crc_rx;
+
+	/* current ccid fields */
+	off_t				ccoff;
+	int				ccid;
+	int				ccsglidx;
+	int				ccoff_inner;
+
+	/* for ddp invalidate flow */
+	struct mlx5e_priv		*priv;
+
+	/* for flow_steering flow */
+	struct completion		done;
+	/* for MASK HW resync cqe */
+	bool				after_resync_cqe;
+};
+
+struct mlx5e_nvmeotcp {
+	struct ida			queue_ids;
+	struct rhashtable		queue_hash;
+	bool				enable;
+	bool				crc_rx_enable;
+};
+
+void mlx5e_nvmeotcp_build_netdev(struct mlx5e_priv *priv);
+int mlx5e_nvmeotcp_init(struct mlx5e_priv *priv);
+int set_feature_nvme_tcp(struct net_device *netdev, bool enable);
+int set_feature_nvme_tcp_crc(struct net_device *netdev, bool enable);
+void mlx5e_nvmeotcp_cleanup(struct mlx5e_priv *priv);
+int mlx5e_nvmeotcp_init_rx(struct mlx5e_priv *priv);
+void mlx5e_nvmeotcp_cleanup_rx(struct mlx5e_priv *priv);
+#else
+
+static inline void mlx5e_nvmeotcp_build_netdev(struct mlx5e_priv *priv) { }
+static inline int mlx5e_nvmeotcp_init(struct mlx5e_priv *priv) { return 0; }
+static inline void mlx5e_nvmeotcp_cleanup(struct mlx5e_priv *priv) { }
+static inline int set_feature_nvme_tcp(struct net_device *netdev, bool enable) { return 0; }
+static inline int set_feature_nvme_tcp_crc(struct net_device *netdev, bool enable) { return 0; }
+static inline int mlx5e_nvmeotcp_init_rx(struct mlx5e_priv *priv) { return 0; }
+static inline void mlx5e_nvmeotcp_cleanup_rx(struct mlx5e_priv *priv) { }
+#endif
+#endif /* __MLX5E_NVMEOTCP_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 414a73d16619..ecb12c7fdb7d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -47,6 +47,7 @@
 #include "en_accel/ipsec.h"
 #include "en_accel/en_accel.h"
 #include "en_accel/tls.h"
+#include "en_accel/nvmeotcp.h"
 #include "accel/ipsec.h"
 #include "accel/tls.h"
 #include "lib/vxlan.h"
@@ -2007,6 +2008,10 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 	c->aff_mask = irq_get_effective_affinity_mask(irq);
 	c->lag_port = mlx5e_enumerate_lag_port(priv->mdev, ix);
 
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	INIT_LIST_HEAD(&c->list_nvmeotcpsq);
+	spin_lock_init(&c->nvmeotcp_icosq_lock);
+#endif
 	netif_napi_add(netdev, &c->napi, mlx5e_napi_poll, 64);
 
 	err = mlx5e_open_queues(c, params, cparam);
@@ -3820,6 +3825,9 @@ int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_NTUPLE, set_feature_arfs);
 #endif
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TLS_RX, mlx5e_ktls_set_feature_rx);
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_ULP_DDP, set_feature_nvme_tcp);
+#endif
 
 	if (err) {
 		netdev->features = oper_features;
@@ -3858,6 +3866,17 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 		features &= ~NETIF_F_RXHASH;
 		if (netdev->features & NETIF_F_RXHASH)
 			netdev_warn(netdev, "Disabling rxhash, not supported when CQE compress is active\n");
+
+		features &= ~NETIF_F_HW_ULP_DDP;
+		if (netdev->features & NETIF_F_HW_ULP_DDP)
+			netdev_warn(netdev, "Disabling tcp-ddp offload, not supported when CQE compress is active\n");
+
+	}
+
+	if (netdev->features & NETIF_F_LRO) {
+		features &= ~NETIF_F_HW_ULP_DDP;
+		if (netdev->features & NETIF_F_HW_ULP_DDP)
+			netdev_warn(netdev, "Disabling tcp-ddp offload, not supported when LRO is active\n");
 	}
 
 	if (mlx5e_is_uplink_rep(priv)) {
@@ -4890,6 +4909,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	mlx5e_set_netdev_dev_addr(netdev);
 	mlx5e_ipsec_build_netdev(priv);
 	mlx5e_tls_build_netdev(priv);
+	mlx5e_nvmeotcp_build_netdev(priv);
 }
 
 void mlx5e_create_q_counters(struct mlx5e_priv *priv)
@@ -4950,6 +4970,10 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	if (err)
 		mlx5_core_err(mdev, "TLS initialization failed, %d\n", err);
 
+	err = mlx5e_nvmeotcp_init(priv);
+	if (err)
+		mlx5_core_err(mdev, "NVMEoTCP initialization failed, %d\n", err);
+
 	dl_port = mlx5e_devlink_get_dl_port(priv);
 	if (dl_port->registered)
 		mlx5e_health_create_reporters(priv);
@@ -4963,6 +4987,8 @@ static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
 
 	if (dl_port->registered)
 		mlx5e_health_destroy_reporters(priv);
+
+	mlx5e_nvmeotcp_cleanup(priv);
 	mlx5e_tls_cleanup(priv);
 	mlx5e_ipsec_cleanup(priv);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index 833be29170a1..3fc11b71de67 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -37,6 +37,7 @@
 #include "en/xsk/rx.h"
 #include "en/xsk/tx.h"
 #include "en_accel/ktls_txrx.h"
+#include "en_accel/nvmeotcp.h"
 
 static inline bool mlx5e_channel_no_affinity_change(struct mlx5e_channel *c)
 {
@@ -119,6 +120,10 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 	struct mlx5e_txqsq __rcu **qos_sqs;
 	struct mlx5e_rq *xskrq = &c->xskrq;
 	struct mlx5e_rq *rq = &c->rq;
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	struct mlx5e_nvmeotcp_sq *nvmeotcp_sq;
+	struct list_head *cur;
+#endif
 	bool aff_change = false;
 	bool busy_xsk = false;
 	bool busy = false;
@@ -171,6 +176,12 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 		 * queueing more WQEs and overflowing the async ICOSQ.
 		 */
 		clear_bit(MLX5E_SQ_STATE_PENDING_XSK_TX, &c->async_icosq.state);
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	list_for_each(cur, &c->list_nvmeotcpsq) {
+		nvmeotcp_sq = list_entry(cur, struct mlx5e_nvmeotcp_sq, list);
+		mlx5e_poll_ico_cq(&nvmeotcp_sq->icosq.cq);
+	}
+#endif
 
 	/* Keep after async ICOSQ CQ poll */
 	if (unlikely(mlx5e_ktls_rx_pending_resync_list(c, budget)))
@@ -223,6 +234,12 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 	mlx5e_cq_arm(&rq->cq);
 	mlx5e_cq_arm(&c->icosq.cq);
 	mlx5e_cq_arm(&c->async_icosq.cq);
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	list_for_each(cur, &c->list_nvmeotcpsq) {
+		nvmeotcp_sq = list_entry(cur, struct mlx5e_nvmeotcp_sq, list);
+		mlx5e_cq_arm(&nvmeotcp_sq->icosq.cq);
+	}
+#endif
 	mlx5e_cq_arm(&c->xdpsq.cq);
 
 	if (xsk_open) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index 016d26f809a5..a8a14c15a61f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -262,6 +262,12 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 			return err;
 	}
 
+	if (MLX5_CAP_GEN(dev, nvmeotcp)) {
+		err = mlx5_core_get_caps(dev, MLX5_CAP_DEV_NVMEOTCP);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
-- 
2.24.1

