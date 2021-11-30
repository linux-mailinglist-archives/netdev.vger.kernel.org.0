Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF136463978
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239337AbhK3PNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:13:48 -0500
Received: from mail-bn8nam11on2081.outbound.protection.outlook.com ([40.107.236.81]:16065
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242982AbhK3PLY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 10:11:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YmU8FkHmWC6FlJ79hCfW+GnYuZMFG3IBckKvAmERzmlS+twitPZ4t7UIA/X0RoUsybALF0NCDK5KqGMkKntZ9LQtg2MCkHMLl6nBFenkN1B3Xjwj+YLZCuyCyPpScA7+S3/qBkgMXCywvASDpnGgcZnE0lwR+O5vLGaJYsRpLZawSnEnjpMJ+FvBV5MK9Kc9IKVznSFtEwCVAQWxTTFtzxeSHZMkdN6SURmJ6Qw2phZZOaEYRDfKnQganhwXIrf81Kj79f4F4jT8E2AaYLv9Uik2Q62QjvejzqU0z5G6Q5HU/6bdW+pcARVmnGdWdCW2V0alZMHR50Dv3zQxUVLL+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZAjGwWbhhB0JyNbg00j7BfI9rJ3BolMyHQ8QS/TX9r0=;
 b=GSEvi/rKiafkufMSJs5eh7DRjg+R8bdXOLlgSL+z8Y9Q41OU5xFIntLcohXvgN5b/ieW13+O24IGBLFymlnAILN62SOrix7ZFTqMKM5STwALM9wwu7XTjg1kiHGj8bJadWvTAJGQ+KW8IwnxZbifHAuubVyljQwvpliiiC1yB7bb+BW/ObawjKCpmPYgER4V6NAkjYszYdR77X4kqEb59wU5sYLmvTcjNJjOytN0RCr9K+5jR30LycVN4q9nc+wCmOSxvxBHucTTj0piDi6nAUs0vaHnK0mq564x3azjRZyTLv9ma4UBirvK+OjstecwlHRFPRI9rVygQCcBVYFlxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZAjGwWbhhB0JyNbg00j7BfI9rJ3BolMyHQ8QS/TX9r0=;
 b=hC28yy0sGI2GnAVelonpGhbFKXIBbcA8TY1ygd8VbJG8Ne15zE11lkJVwiGNV0l/z4gIrLiulL3k8LCwDSFtwh21q9BCfcEqUpwtlNI6jo50yh3mH7shKwixqx//3SHvBvTayCHGo1mcUGk+GLmGKE2XvW3FcCHhHXMTtNB/x2UGJoBWEMa1cXiruw6Wtj/Hv5vq1o6hLHuEl5516cZmorq2i+Y7smgfAwtzBygJRLu9/JL8q8PZkAjRmIqqxT7zUmjgpDQwk3tO8Qrg2na+KazCGOJg2nLI4oe6hR6yky+5UY/WkEpxE2YNmxZvLpIiAcYpy1MrMpttIkE6wS9E5Q==
Received: from DM5PR07CA0040.namprd07.prod.outlook.com (2603:10b6:3:16::26) by
 CH2PR12MB3894.namprd12.prod.outlook.com (2603:10b6:610:2b::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.23; Tue, 30 Nov 2021 15:08:02 +0000
Received: from DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:16:cafe::3c) by DM5PR07CA0040.outlook.office365.com
 (2603:10b6:3:16::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend
 Transport; Tue, 30 Nov 2021 15:08:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT041.mail.protection.outlook.com (10.13.172.98) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Tue, 30 Nov 2021 15:08:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 30 Nov
 2021 15:08:00 +0000
Received: from nps-server-23.mtl.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.5;
 Tue, 30 Nov 2021 07:07:56 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <jiri@nvidia.com>, <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 1/4] net/mlx5: Let user configure io_eq_size resource
Date:   Tue, 30 Nov 2021 17:07:03 +0200
Message-ID: <20211130150705.19863-2-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20211130150705.19863-1-shayd@nvidia.com>
References: <20211130150705.19863-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9d24359-91f8-48b3-0c47-08d9b4133412
X-MS-TrafficTypeDiagnostic: CH2PR12MB3894:
X-Microsoft-Antispam-PRVS: <CH2PR12MB3894C7BDA589F6F913843107CF679@CH2PR12MB3894.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NH9SbP+D1IPVotMmnqIhLYvKalCLT8hML+sUFXvrqg8ccxtvIUrPkvPqojecE0RXCbR+yfhzRhHn4rK/v9GqR9uA3rl1Gh+MdQxzgtLiMd8zgFxyrScFuWIxOg2r2uUTBbYz7qXwkfbBQjQaFwUhJmv4o4AimmtaSLdU3zZIU6jHFQaDkph4G7R9IAogsorJ2/riKIy8wHRylRKFECNMjkkpQxgqp9E84086T58c70RSUulfLSbnm6Oms8BQ7s+J0+3+HJj24wbuylvC8vWDvDu/YUxq1v6oRUrDK+GbV74RtKQbVrEJ1t+6H60eZzje6IYkg7BcPEDNnWiB85k8ZXpPX8n2MFvBPEUAt8jzGI8mReDiNu+yBpIib3ksGkZqWH2Ctep2bD2JOYBnpAMxNI+zPYjGNe1tDFeSO/VjykuN/Arr7kyrXouQhDvco1EtF51gxfVPhQ1SBto7ILhhezYjz58rs4uq25pgpwCVHaaFQx2VxluMKImLwSRZqixgoY36YLhafeSohc5SPOTVdPw//5js12SIWpscI5tTfzq71BePq1D9i6ZZySY7iMPMHgegUSCaw0ahd5Iy3cjYOW7nzfd8JJXUfhNibXTcN32661SvQ31yZxXnCJgsZ2ZE8cLg6ALG7FHASJWB1BDBZ322jp/IU3cYxTzPXOhM32ecQVgR7u+bN7K+dnxNfCPKY9bvBhWFoRZALGGVoxJIb6DXnrsjouVHHktLGZYFUr5kCKgQFmw7OVh44ZYqn69ZMRZIh5f1R1lX20NFp4oerA==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(26005)(316002)(8936002)(336012)(110136005)(2616005)(47076005)(5660300002)(2906002)(86362001)(8676002)(54906003)(83380400001)(70586007)(70206006)(82310400004)(36860700001)(508600001)(36756003)(16526019)(40460700001)(4326008)(1076003)(186003)(7636003)(107886003)(6666004)(426003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 15:08:01.9079
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9d24359-91f8-48b3-0c47-08d9b4133412
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3894
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, each I/O EQ is taking 128KB of memory. This size
is not needed in all use cases, and is critical with large scale.
Hence, allow user to configure the size of I/O EQs.

For example, to reduce I/O EQ size to 64, execute:
$ devlink resource set pci/0000:00:0b.0 path /io_eq_size/ size 64
$ devlink dev reload pci/0000:00:0b.0

In addition, add it as a "Generic Resource" in order for different
drivers to be aligned by the same resource name when exposing to
user space.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 .../networking/devlink/devlink-resource.rst   |  2 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.h | 11 ++++
 .../ethernet/mellanox/mlx5/core/devlink_res.c | 55 +++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  3 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  3 +
 include/linux/mlx5/driver.h                   |  4 --
 include/net/devlink.h                         |  1 +
 8 files changed, 75 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/devlink_res.c

diff --git a/Documentation/networking/devlink/devlink-resource.rst b/Documentation/networking/devlink/devlink-resource.rst
index 3d5ae51e65a2..d5df5e65d057 100644
--- a/Documentation/networking/devlink/devlink-resource.rst
+++ b/Documentation/networking/devlink/devlink-resource.rst
@@ -36,6 +36,8 @@ device drivers and their description must be added to the following table:
      - Description
    * - ``physical_ports``
      - A limited capacity of physical ports that the switch ASIC can support
+   * - ``io_eq_size``
+     - Control the size of I/O completion EQs
 
 example usage
 -------------
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index e63bb9ceb9c0..19656ea025c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -16,7 +16,7 @@ mlx5_core-y :=	main.o cmd.o debugfs.o fw.o eq.o uar.o pagealloc.o \
 		transobj.o vport.o sriov.o fs_cmd.o fs_core.o pci_irq.o \
 		fs_counters.o fs_ft_pool.o rl.o lag/lag.o dev.o events.o wq.o lib/gid.o \
 		lib/devcom.o lib/pci_vsc.o lib/dm.o lib/fs_ttc.o diag/fs_tracepoint.o \
-		diag/fw_tracer.o diag/crdump.o devlink.o diag/rsc_dump.o \
+		diag/fw_tracer.o diag/crdump.o devlink.o devlink_res.o diag/rsc_dump.o \
 		fw_reset.o qos.o lib/tout.o
 
 #
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
index 30bf4882779b..4192f23b1446 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
@@ -6,6 +6,13 @@
 
 #include <net/devlink.h>
 
+enum mlx5_devlink_resource_id {
+	MLX5_DL_RES_COMP_EQ = 1,
+
+	__MLX5_ID_RES_MAX,
+	MLX5_ID_RES_MAX = __MLX5_ID_RES_MAX - 1,
+};
+
 enum mlx5_devlink_param_id {
 	MLX5_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
 	MLX5_DEVLINK_PARAM_ID_FLOW_STEERING_MODE,
@@ -31,6 +38,10 @@ int mlx5_devlink_trap_get_num_active(struct mlx5_core_dev *dev);
 int mlx5_devlink_traps_get_action(struct mlx5_core_dev *dev, int trap_id,
 				  enum devlink_trap_action *action);
 
+void mlx5_devlink_res_register(struct mlx5_core_dev *dev);
+void mlx5_devlink_res_unregister(struct mlx5_core_dev *dev);
+size_t mlx5_devlink_res_size(struct mlx5_core_dev *dev, enum mlx5_devlink_resource_id id);
+
 struct devlink *mlx5_devlink_alloc(struct device *dev);
 void mlx5_devlink_free(struct devlink *devlink);
 int mlx5_devlink_register(struct devlink *devlink);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink_res.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink_res.c
new file mode 100644
index 000000000000..2b7a956b7779
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink_res.c
@@ -0,0 +1,55 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. */
+
+#include "devlink.h"
+#include "mlx5_core.h"
+
+enum {
+	MLX5_EQ_MIN_SIZE = 64,
+	MLX5_EQ_MAX_SIZE = 4096,
+	MLX5_COMP_EQ_SIZE = 1024,
+};
+
+static int comp_eq_res_register(struct mlx5_core_dev *dev)
+{
+	struct devlink_resource_size_params comp_eq_size;
+	struct devlink *devlink = priv_to_devlink(dev);
+
+	devlink_resource_size_params_init(&comp_eq_size, MLX5_EQ_MIN_SIZE,
+					  MLX5_EQ_MAX_SIZE, 1, DEVLINK_RESOURCE_UNIT_ENTRY);
+	return devlink_resource_register(devlink, DEVLINK_RESOURCE_GENERIC_NAME_IO_EQ,
+					 MLX5_COMP_EQ_SIZE, MLX5_DL_RES_COMP_EQ,
+					 DEVLINK_RESOURCE_ID_PARENT_TOP, &comp_eq_size);
+}
+
+void mlx5_devlink_res_register(struct mlx5_core_dev *dev)
+{
+	int err;
+
+	err = comp_eq_res_register(dev);
+	if (err)
+		mlx5_core_err(dev, "Failed to register resources, err = %d\n", err);
+}
+
+void mlx5_devlink_res_unregister(struct mlx5_core_dev *dev)
+{
+	devlink_resources_unregister(priv_to_devlink(dev), NULL);
+}
+
+static const size_t default_vals[MLX5_ID_RES_MAX + 1] = {
+	[MLX5_DL_RES_COMP_EQ] = MLX5_COMP_EQ_SIZE,
+};
+
+size_t mlx5_devlink_res_size(struct mlx5_core_dev *dev, enum mlx5_devlink_resource_id id)
+{
+	struct devlink *devlink = priv_to_devlink(dev);
+	u64 size;
+	int err;
+
+	err = devlink_resource_size_get(devlink, id, &size);
+	if (!err)
+		return size;
+	mlx5_core_err(dev, "Failed to get param. using default. err = %d, id = %u\n",
+		      err, id);
+	return default_vals[id];
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 792e0d6aa861..4dda6e2a4cbc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -19,6 +19,7 @@
 #include "lib/clock.h"
 #include "diag/fw_tracer.h"
 #include "mlx5_irq.h"
+#include "devlink.h"
 
 enum {
 	MLX5_EQE_OWNER_INIT_VAL	= 0x1,
@@ -807,7 +808,7 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 
 	INIT_LIST_HEAD(&table->comp_eqs_list);
 	ncomp_eqs = table->num_comp_eqs;
-	nent = MLX5_COMP_EQ_SIZE;
+	nent = mlx5_devlink_res_size(dev, MLX5_DL_RES_COMP_EQ);
 	for (i = 0; i < ncomp_eqs; i++) {
 		struct mlx5_eq_param param = {};
 		int vecidx = i;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index a92a92a52346..f55a89bd3736 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -922,6 +922,8 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 	dev->hv_vhca = mlx5_hv_vhca_create(dev);
 	dev->rsc_dump = mlx5_rsc_dump_create(dev);
 
+	mlx5_devlink_res_register(dev);
+
 	return 0;
 
 err_sf_table_cleanup:
@@ -957,6 +959,7 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 
 static void mlx5_cleanup_once(struct mlx5_core_dev *dev)
 {
+	mlx5_devlink_res_unregister(dev);
 	mlx5_rsc_dump_destroy(dev);
 	mlx5_hv_vhca_destroy(dev->hv_vhca);
 	mlx5_fw_tracer_destroy(dev->tracer);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index a623ec635947..d07359e98fd4 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -781,10 +781,6 @@ struct mlx5_db {
 	int			index;
 };
 
-enum {
-	MLX5_COMP_EQ_SIZE = 1024,
-};
-
 enum {
 	MLX5_PTYS_IB = 1 << 0,
 	MLX5_PTYS_EN = 1 << 2,
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 043fcec8b0aa..ecc55ee526fa 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -364,6 +364,7 @@ typedef u64 devlink_resource_occ_get_t(void *priv);
 #define DEVLINK_RESOURCE_ID_PARENT_TOP 0
 
 #define DEVLINK_RESOURCE_GENERIC_NAME_PORTS "physical_ports"
+#define DEVLINK_RESOURCE_GENERIC_NAME_IO_EQ "io_eq_size"
 
 #define __DEVLINK_PARAM_MAX_STRING_VALUE 32
 enum devlink_param_type {
-- 
2.21.3

