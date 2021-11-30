Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70BB46397B
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238773AbhK3POA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:14:00 -0500
Received: from mail-mw2nam12on2077.outbound.protection.outlook.com ([40.107.244.77]:20160
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235496AbhK3PLk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 10:11:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1SjpmcIpLobvEJMgnpdvve1ZFwwL5p8kiljhObUHVV9JdPmLPbcWmBHHGWwcSpuQC3D1EeL1VFIYe9FlxW2xbvj65MLur1hDMDG5rF9SWW/ITAajZmpM0H+I/nfrOyiR2n5ymbMlcptc5kg7cvMcF7ply9Gq5dl8lqSpt0hIAXRuEUBMjUFbYnH8EOqoemrHUnO5v5BDVWU1y8NlK/jwCMEpNj0633elXTr7p9Qg8exEZm3+XbO3/x1ymsAYTuoJDTzOI33ynE1e+NEJ4T1MOazp+1BIBkeOqh75QrOO4N74qOH0YPi6zgXSd/0qEYqgY/n+2hC50ZJcOLEP1YMEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dY2fIAdYEjEvJGGZP4CUyphTqj4zdP+p9J8si413sKs=;
 b=QXKeXCHKe6sLz5M96Di3XDT/ugiYCyfComHzj/ZHcC0gdC3KDeSB6xENe5XlqI1kFUtd6225CRLpdFB2c8/iF2emEGtZUNp9J/6XLVwAd0BTVUw4Lsi416rBKBdjZjpQ5UTIK/wlIHw/kbLmwrvzhz//PBS0r5cQKfN4R+PxBlWOA7tLaEZMrffmhbXVOCyLO7ls5g5GFlx7EpgBPTHiYHuklmSEgEQ9YZxK3yCI8/mdyjVvyWXvUftzwQjD+sFnJiE6ZgYz3a2UBZgGJwCFpKkhrs/OlFrbuUr3PTVnhuMUpe6z8aRCzm1RQF9I3MCIDK46gO6L3VOcYtReMn6DoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dY2fIAdYEjEvJGGZP4CUyphTqj4zdP+p9J8si413sKs=;
 b=Kgj5HtrEEd1oGK1acudNG6wABIvI5pc5yuTfT09ueqt3yEXRzMxOENylxB+b3eeTQg7wFGI1SNtyz1JoJqLnA2ChJjWs7uSZdX4Ta0opHGLDrRcuAx7VOPIO+s3vloq72M1wbtXP3mdNnGhe4/2tJDETiEnhe3b2gwfwWc08aEDwI5oH6hUTZh/CpQMrn4rbikjpASaOXzwM0Rqyb4FwB0dyjWtVB1ish8hx6LJAKdsqIQqwhtEzb0ue1ZbByMSrG/mOD73KTuB5HrBkSXnQbqJ5wPSW2bTroufl+OT67IyranG9wcXAMIYV+TBquIMzUFRG15KRXmnTnj39kD64Xg==
Received: from BN6PR14CA0014.namprd14.prod.outlook.com (2603:10b6:404:79::24)
 by MN2PR12MB3023.namprd12.prod.outlook.com (2603:10b6:208:c8::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Tue, 30 Nov
 2021 15:08:17 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:79:cafe::af) by BN6PR14CA0014.outlook.office365.com
 (2603:10b6:404:79::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend
 Transport; Tue, 30 Nov 2021 15:08:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Tue, 30 Nov 2021 15:08:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 30 Nov
 2021 07:08:03 -0800
Received: from nps-server-23.mtl.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.5;
 Tue, 30 Nov 2021 07:08:00 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <jiri@nvidia.com>, <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 2/4] net/mlx5: Let user configure event_eq_size resource
Date:   Tue, 30 Nov 2021 17:07:04 +0200
Message-ID: <20211130150705.19863-3-shayd@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 237e76fb-53c9-493f-456d-08d9b4133bc3
X-MS-TrafficTypeDiagnostic: MN2PR12MB3023:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3023A8F0B115E96BCA6BC85BCF679@MN2PR12MB3023.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DhuKjrFt3THHK7jmh5miGtMA7pKJg+sHIswxbNaESk7gar4q/7E59kShJYxthERegA8LhFOyJcgc5QB6WNQVuYbn5D/TVamvXHdyN9/43IzFBiN/WnPql3nJtALLdj7P7WfaHcmL9gnfeLworVry5S+BnGzZ/+VIiMeMIJ0ZsyDTBI+Q6MizOoItEG5KLjYZa1kP0pbH6Zi6LLRrfzSM4LREyh6VRzDrFdZqmHqnIEqm6m+vNbIm7pn+LzuQL1umGLJcsyrSsOC7CGbM4/OZjewXqaQNLxfdeVKmhCOap1n73Wjyvuq9kEeD8GnYxWzsp1h9lYNt/aGHRNOazMxqAqoN92B/zHT+tBsmnrsXlfHinTBD1Sf7MV+36Vrvy1PXhYEslku91jexRtIaBCvhJWwVnL24BRtyULcb4F8bIQokyUSS9rASgjYTK5n3GawhtvYC+0tLtEY5Tx/MAsMTlXy7H3XzcC1mqk2Ozmp1P+n35ZwvxYJ5sx+HDR/v7WJVz27lpwNGT2/lrdfN7fgV3hWH2B9ltViuLxhTC388BUA7tU4nvaG71vYL+O7PoM3MKcGCRzOib7Cbg48zXVU/LHGQcNHAGP8DQ5HyR9v6xTg23NIJq/2A/KuQSa8m9D8HkdgCgOAEJzqs9jyzp/pKhK/A1sABz642mQJZ+jN9zL3gK8stfsbSYfdxZBL18XcPSAPXwUmgZELsT37fpa0SgsfQ4BtUQ3dk4BZcUcZFcr3KEtbKrJWqFKKaOML0ndph5R3DfNsr0L1f4c8MkxpOzg==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(40460700001)(36756003)(54906003)(70206006)(36860700001)(70586007)(8936002)(47076005)(107886003)(1076003)(110136005)(316002)(82310400004)(4326008)(2906002)(8676002)(5660300002)(186003)(16526019)(83380400001)(2616005)(86362001)(7636003)(336012)(26005)(356005)(508600001)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 15:08:14.7328
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 237e76fb-53c9-493f-456d-08d9b4133bc3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3023
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Event EQ is an EQ which received the notification of almost all the
events generated by the NIC.
Currently, each event EQ is taking 512KB of memory. This size is not
needed in most use cases, and is critical with large scale. Hence,
allow user to configure the size of the event EQ.

For example to reduce event EQ size to 64, execute::
$ devlink resource set pci/0000:00:0b.0 path /event_eq_size/ size 64
$ devlink dev reload pci/0000:00:0b.0

In addition, add it as a "Generic Resource" in order for different
drivers to be aligned by the same resource name when exposing to
user space.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 .../networking/devlink/devlink-resource.rst   |  2 ++
 .../net/ethernet/mellanox/mlx5/core/devlink.h |  1 +
 .../ethernet/mellanox/mlx5/core/devlink_res.c | 26 ++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  2 +-
 include/linux/mlx5/eq.h                       |  1 -
 include/net/devlink.h                         |  1 +
 6 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-resource.rst b/Documentation/networking/devlink/devlink-resource.rst
index d5df5e65d057..7c66ae6df2e6 100644
--- a/Documentation/networking/devlink/devlink-resource.rst
+++ b/Documentation/networking/devlink/devlink-resource.rst
@@ -38,6 +38,8 @@ device drivers and their description must be added to the following table:
      - A limited capacity of physical ports that the switch ASIC can support
    * - ``io_eq_size``
      - Control the size of I/O completion EQs
+   * - ``event_eq_size``
+     - Control the size of the asynchronous control events EQ
 
 example usage
 -------------
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
index 4192f23b1446..674415fd0b3a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
@@ -8,6 +8,7 @@
 
 enum mlx5_devlink_resource_id {
 	MLX5_DL_RES_COMP_EQ = 1,
+	MLX5_DL_RES_ASYNC_EQ,
 
 	__MLX5_ID_RES_MAX,
 	MLX5_ID_RES_MAX = __MLX5_ID_RES_MAX - 1,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink_res.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink_res.c
index 2b7a956b7779..8cbe08577c05 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink_res.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink_res.c
@@ -7,6 +7,7 @@
 enum {
 	MLX5_EQ_MIN_SIZE = 64,
 	MLX5_EQ_MAX_SIZE = 4096,
+	MLX5_NUM_ASYNC_EQE = 4096,
 	MLX5_COMP_EQ_SIZE = 1024,
 };
 
@@ -22,13 +23,35 @@ static int comp_eq_res_register(struct mlx5_core_dev *dev)
 					 DEVLINK_RESOURCE_ID_PARENT_TOP, &comp_eq_size);
 }
 
+static int async_eq_res_register(struct mlx5_core_dev *dev)
+{
+	struct devlink_resource_size_params async_eq_size;
+	struct devlink *devlink = priv_to_devlink(dev);
+
+	devlink_resource_size_params_init(&async_eq_size, MLX5_EQ_MIN_SIZE,
+					  MLX5_EQ_MAX_SIZE, 1, DEVLINK_RESOURCE_UNIT_ENTRY);
+	return devlink_resource_register(devlink, DEVLINK_RESOURCE_GENERIC_NAME_EVENT_EQ,
+					 MLX5_NUM_ASYNC_EQE, MLX5_DL_RES_ASYNC_EQ,
+					 DEVLINK_RESOURCE_ID_PARENT_TOP,
+					 &async_eq_size);
+}
+
 void mlx5_devlink_res_register(struct mlx5_core_dev *dev)
 {
 	int err;
 
 	err = comp_eq_res_register(dev);
 	if (err)
-		mlx5_core_err(dev, "Failed to register resources, err = %d\n", err);
+		goto err_msg;
+
+	err = async_eq_res_register(dev);
+	if (err)
+		goto err;
+	return;
+err:
+	devlink_resources_unregister(priv_to_devlink(dev), NULL);
+err_msg:
+	mlx5_core_err(dev, "Failed to register resources, err = %d\n", err);
 }
 
 void mlx5_devlink_res_unregister(struct mlx5_core_dev *dev)
@@ -38,6 +61,7 @@ void mlx5_devlink_res_unregister(struct mlx5_core_dev *dev)
 
 static const size_t default_vals[MLX5_ID_RES_MAX + 1] = {
 	[MLX5_DL_RES_COMP_EQ] = MLX5_COMP_EQ_SIZE,
+	[MLX5_DL_RES_ASYNC_EQ] = MLX5_NUM_ASYNC_EQE,
 };
 
 size_t mlx5_devlink_res_size(struct mlx5_core_dev *dev, enum mlx5_devlink_resource_id id)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 4dda6e2a4cbc..31e69067284b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -647,7 +647,7 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 
 	param = (struct mlx5_eq_param) {
 		.irq_index = MLX5_IRQ_EQ_CTRL,
-		.nent = MLX5_NUM_ASYNC_EQE,
+		.nent = mlx5_devlink_res_size(dev, MLX5_DL_RES_ASYNC_EQ),
 	};
 
 	gather_async_events_mask(dev, param.mask);
diff --git a/include/linux/mlx5/eq.h b/include/linux/mlx5/eq.h
index ea3ff5a8ced3..11161e427608 100644
--- a/include/linux/mlx5/eq.h
+++ b/include/linux/mlx5/eq.h
@@ -5,7 +5,6 @@
 #define MLX5_CORE_EQ_H
 
 #define MLX5_NUM_CMD_EQE   (32)
-#define MLX5_NUM_ASYNC_EQE (0x1000)
 #define MLX5_NUM_SPARE_EQE (0x80)
 
 struct mlx5_eq;
diff --git a/include/net/devlink.h b/include/net/devlink.h
index ecc55ee526fa..43b6fdd9ffa5 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -365,6 +365,7 @@ typedef u64 devlink_resource_occ_get_t(void *priv);
 
 #define DEVLINK_RESOURCE_GENERIC_NAME_PORTS "physical_ports"
 #define DEVLINK_RESOURCE_GENERIC_NAME_IO_EQ "io_eq_size"
+#define DEVLINK_RESOURCE_GENERIC_NAME_EVENT_EQ "event_eq_size"
 
 #define __DEVLINK_PARAM_MAX_STRING_VALUE 32
 enum devlink_param_type {
-- 
2.21.3

