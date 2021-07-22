Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF623D2285
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbhGVK0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:26:13 -0400
Received: from mail-co1nam11on2046.outbound.protection.outlook.com ([40.107.220.46]:41185
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231693AbhGVK0I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:26:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pb97q/s1+ZXHF0lcWUHy8CJe1Qxst49HeMkznwLrTkRJhPhdvy/y40WeMJE+zRACsvEH1qiNW7zR7RQ0Wv10esQRPM72U9udQdUkMncQRt/mn1Qt8t6Ze62XG5FAGgz54y1ELVja0S+tSOauMHLCb3eiuLvT1lkWvj4q8mzNF/Di7KDnZxlR+wnf+naSz4i9SweJiKiUO07tUHATh7x12hwpRYrSK4yeh5jUXy698g5B921UanwxYbqtTeENUz6C5Mrm+Hi6RNqfA55aZ6qMINiyqH0Y8bNuqcYNxH2cZ27Al4VDRV/Viru2xXsN5Ki8vnhTITLIMCDWoi/pnAyfqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6hgX2eAKk6eToFJ+7VZTHz3wQjJMmNFuvM8vG0/psnk=;
 b=C1C3qp2xD8lUC8vdvI9r7+d2rcoW6ZK5sg+J4MeT1PU+rEyjrH3jy23cXWrtCDoEKJFXPOXra/zxty2aXl2lJWbPIrDpIlEOmhGZNOxUtNguGYlW+WTRWB4c1904R0wIV5KMjpod1+wxRm3zxP/9bm8PSEFA9QIzxbjnOLifX4d8TM//EPunDML8sIaY/cy0iGIEpz0iyexplRAFJccW2XyXhTFPo2yTJ3A7EKHjPYbN6+QuJAyUveSpawVSCzeTLkZcrym25jc4kwcSN2rVXuGV60w5OAIkagIM39zBTCAG/AP24S1KzyAO4dCpbtZqNqCDUBFfGn3m2ewRYjiRyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=marvell.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6hgX2eAKk6eToFJ+7VZTHz3wQjJMmNFuvM8vG0/psnk=;
 b=UgxAd9wiuIA4Dt/7+qcj2+SYtjUEMFeG0swVCAUmbShZd9SqxkALDx/I9E5Xtpq+10JCg2Biz1pAAFNR83ihOSDb0rvW9w9+K/ZyLrx9ULkxi/0j8PAPPj2d22bbCFvA138I7LDSIPVjJYbffRCS63ecnmOLVg8masQVb6nU6QCtZ8w1Ziqltyqd3r23LKhw8VJQEWBn3wA4dEW+IA9/cb5/s9EfQQRsFZjVBhrmiSD4eLJLhEGmZnen/dIliGpMb5UXdl+TLoSubP80DQjBPE3Wn69YbU4XGTmEt9N3PXDsBQQvFxj2JK7b+0KmQVIyeWcVKHNqzfLk282imthA7w==
Received: from DM3PR12CA0138.namprd12.prod.outlook.com (2603:10b6:0:51::34) by
 MN2PR12MB4519.namprd12.prod.outlook.com (2603:10b6:208:262::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.24; Thu, 22 Jul
 2021 11:06:42 +0000
Received: from DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:51:cafe::83) by DM3PR12CA0138.outlook.office365.com
 (2603:10b6:0:51::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend
 Transport; Thu, 22 Jul 2021 11:06:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT020.mail.protection.outlook.com (10.13.172.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:06:41 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 04:06:40 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:06:35 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>
Subject: [PATCH v5 net-next 30/36] net/mlx5e: NVMEoTCP DDGST TX offload TIS
Date:   Thu, 22 Jul 2021 14:03:19 +0300
Message-ID: <20210722110325.371-31-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e535892-c5af-4d47-cccb-08d94d00c917
X-MS-TrafficTypeDiagnostic: MN2PR12MB4519:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4519EB60AC510F897B6BF065BDE49@MN2PR12MB4519.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:25;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fRhrv8gPZ6lYjbeXOtH6dg0sZFzA9KTCh9NEWJXhjS6Dia3ERscy6eAONkH5vV4w8F0bF/grEJN+/x/Qc0tW57qxrzc4G8HlMoOzb1wX4KlgDmy93hLp3+MaLHpZvNmIdPyznqDZsfjzdUeMRzl8CmP0UI7uMRmxXmq14E4hnihdnpvVIl38ZyF+ROWgNKmUtdQFxddHdpR9FKn1l0TitMN+NpXx6slZvoCq7st5xw80Ax6c4+ZYkji6DNM/YDoDuJjejtJEgpM19OmPVxFnPxEZ1WPS5xk3jUrnLwD6Gr0QeGGKmw8O3UkXDWFY6eTG+SBlsIiMnE01QqPaqDTwIW2gXXKtfNwq62XFNgBhsINpJFWL68iasYYvXZxUxQGsyl8D+0vSQQAI77e8jQE8qVbUtYruaCwCwaAnlYavH9t28SWl1rMoMZLcS3F6OXDf3Ve4Kud6hliFg1Y8XEvVku8HniV4KUt9ud1iOY0lgO19HGXNNoW5hQ7p3iaGF+LnhRt+b9FCcj1kOcHQEMj37SZnOJFEffkVyPEYthFHEPfOegE8BzCB+E2RQc30XxymmU8QfQmVK6bYdicGZP0nxYz4CmTwIURwXR9kFaqE9xtN6lXUlwTfBpZZSPrlSfJR/jl6cLcqhDn7QU1K1TcvQoOtOh0lg7QwOzXyCU0VnL3aHQRCgB1iMD9b6cOENR/ROaJEdJkYTMfEK1FnkUCacJpDketeprA2tV3j7uPlNyo=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(346002)(136003)(46966006)(36840700001)(2616005)(426003)(6666004)(70586007)(110136005)(186003)(5660300002)(356005)(83380400001)(478600001)(4326008)(8676002)(7696005)(8936002)(36860700001)(82310400003)(316002)(107886003)(336012)(36756003)(54906003)(70206006)(82740400003)(2906002)(7416002)(921005)(1076003)(86362001)(26005)(7636003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:06:41.7655
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e535892-c5af-4d47-cccb-08d94d00c917
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4519
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoray Zack <yorayz@nvidia.com>

NVMEoTCP DDGST Tx offload needs TIS.
This commit add the infrastructer for this TIS.

Signed-off-by: Yoray Zack <yorayz@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c      | 17 +++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c   |  2 +-
 include/linux/mlx5/mlx5_ifc.h                   |  3 ++-
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index db6ca734d129..d42f346ac8f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -35,6 +35,11 @@ static void mlx5e_nvmeotcp_destroy_tir(struct mlx5e_priv *priv, int tirn)
 	mlx5_core_destroy_tir(priv->mdev, tirn);
 }
 
+static void mlx5e_nvmeotcp_delete_tis(struct mlx5e_priv *priv, int tisn)
+{
+	mlx5_core_destroy_tis(priv->mdev, tisn);
+}
+
 static inline u32
 mlx5e_get_channel_ix_from_io_cpu(struct mlx5e_priv *priv, u32 io_cpu)
 {
@@ -137,6 +142,18 @@ void mlx5_destroy_nvmeotcp_tag_buf_table(struct mlx5_core_dev *mdev, u32 uid)
 	mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 }
 
+static int mlx5e_nvmeotcp_create_tis(struct mlx5_core_dev *mdev, u32 *tisn)
+{
+	u32 in[MLX5_ST_SZ_DW(create_tis_in)] = {};
+	void *tisc;
+
+	tisc = MLX5_ADDR_OF(create_tis_in, in, ctx);
+
+	MLX5_SET(tisc, tisc, nvmeotcp_en, 1);
+
+	return mlx5e_create_tis(mdev, in, tisn);
+}
+
 #define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_TIR_PARAMS 0x2
 #define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_NVMEOTCP_TIR_STATIC_PARAMS 0x2
 #define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_UMR 0x0
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b76e590c237b..2a9718d3c2d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3152,7 +3152,7 @@ int mlx5e_create_tis(struct mlx5_core_dev *mdev, void *in, u32 *tisn)
 
 	MLX5_SET(tisc, tisc, transport_domain, mdev->mlx5e_res.hw_objs.td.tdn);
 
-	if (MLX5_GET(tisc, tisc, tls_en))
+	if (MLX5_GET(tisc, tisc, tls_en) || MLX5_GET(tisc, tisc, nvmeotcp_en))
 		MLX5_SET(tisc, tisc, pd, mdev->mlx5e_res.hw_objs.pdn);
 
 	if (mlx5_lag_is_lacp_owner(mdev))
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index f0310c24f408..a4965bf1e607 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -3300,7 +3300,8 @@ struct mlx5_ifc_traffic_counter_bits {
 struct mlx5_ifc_tisc_bits {
 	u8         strict_lag_tx_port_affinity[0x1];
 	u8         tls_en[0x1];
-	u8         reserved_at_2[0x2];
+	u8         nvmeotcp_en[0x1];
+	u8         reserved_at_3[0x1];
 	u8         lag_tx_port_affinity[0x04];
 
 	u8         reserved_at_8[0x4];
-- 
2.24.1

