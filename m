Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785CE3D2271
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhGVKYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:24:47 -0400
Received: from mail-dm6nam12on2058.outbound.protection.outlook.com ([40.107.243.58]:31968
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231718AbhGVKYe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:24:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wa9Kjch7NcPik1grpx8A9lv6SCR3gxgxWuaSB4JdsU4R0Z1MQrE0/MPV1dF6vXEjwmphxyE1IMt77yLNb1H84A7ewfOtv3jg7zJvf8Wo1dEvQkT1unHfme2FK3iTh0IRQw3Lcqy6PtNRwpdg4Osn/h6QpIhANcWuA5baOQ2b2AfG/g5Y5Grv8g5scde2Bm1ieDUUsZJKv+gUPhfIjNPA8AE1JbdwS5F2HQYLPNDqI9yiLBqtey3M/8nkA8QquTMRy7K2WnSWfDNjNjqa8/QPnAW/tvzKssA3gTxoTqo9fmXZNJnQYbUUAVN4VtSIsIv+WAo3J7tOC0NVjvETnasOrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w9dSDgtM8uufd6jUhzV5bb5tlCJSXGPodLbDpo4FHWw=;
 b=gBzMshFWlEsZEyzu9HW9RLcOeRcCggmNWm4+ZoBKB5aIN1ih9eFjr70gOkb/WEvwETp7i5b8XP+dN9+0RXbhWoAffVjyUMfqNAnV8CYf2qq8cBFOpmo9opJLngJY6HJtMzAiPS0TIMFDXMjo9xQeAz/E5O5hzOiHJOr11U5RoU4iRQwJlWs0JuWvrKdJTJPseKhf8kJRMS8qq7mdcn6+bJMkrWjGcA09k9pFp8HDfvTbDsFby2zNrqmiEuM3dzqNiB7jNCTSTZGtFy0FPOPp8Y+mebU4FWDFBEpRK5TiLthSm0x/HgvSeHfpXSrc35xvQapZB5OBqo5mapbw0Y591A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=marvell.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w9dSDgtM8uufd6jUhzV5bb5tlCJSXGPodLbDpo4FHWw=;
 b=HZoI/KtyLoK5KFG45FX/fIPTCG/4dOy8y7eZs9qF4l9dhfP3l/+54ALUKTI2+URe6VA+hXxf+gb9jgBkbbxAaLTwpGquJhe64lyVa5m2ujT8eL8ODAmv9ii1vs2WfscvuhV9bUai5/izH0wD7vN/fSk+7t16UXVTOy0qUksepOqqnvhbxeDxhWrRCMIXM5lqZEKu+lDzzYM8kdoZXA7hzRQtDTUDaITOcoUK2Qipl1Wy/A0T2Jpx4cArSSFCyD1EZD3YsJQbAzdSxSWsp07yESDG3pJcia/JEJ4N+sM2OCMeEoVx0HFal82ZHHSdWQJBo5HPRaFhAAIb+ZAhBVGKsw==
Received: from BN9PR03CA0666.namprd03.prod.outlook.com (2603:10b6:408:10e::11)
 by DM6PR12MB4651.namprd12.prod.outlook.com (2603:10b6:5:1f6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Thu, 22 Jul
 2021 11:05:08 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10e:cafe::b4) by BN9PR03CA0666.outlook.office365.com
 (2603:10b6:408:10e::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend
 Transport; Thu, 22 Jul 2021 11:05:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:05:07 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:05:07 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:05:02 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v5 net-next 11/36] net/mlx5e: TCP flow steering for nvme-tcp
Date:   Thu, 22 Jul 2021 14:03:00 +0300
Message-ID: <20210722110325.371-12-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8217087-c568-4a94-d30d-08d94d009127
X-MS-TrafficTypeDiagnostic: DM6PR12MB4651:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4651E74A2F8019ECFBA82948BDE49@DM6PR12MB4651.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:632;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ChfRYvNHS3TDLOgzDCiXAggr9Si3p28gA+eVBxOvEqz2q4RYkHwUEqRGJ1UBt+l1oWWE7yuxbiEvIOte9jprPLdnMW9KRmupYVp5SeOXf1OWGgkjLjpkBtZMykKlZkiYiJf0UFvEc5Jnfd1r78JAy4qj3pOqlfid//sbpwImKoEf5KxZ7j+7moFBr0sghkzonII6gLFsxW4QTCUbGukc8+rJ9tTwcNbOsmuJRMlqRoptpDYogrvUg9RwpgWwW8IJGVwU0EtMikD4785/2gAQ+V/1yXPOJanu9P9mbQcCS3fPNSMBEy0l7NqOkX9WpizI1eMpuqi8/J+4p4nn/xDG/ojDAV79xoleUaroBZ9You6aYpVTDQLLtMHLCVF7ygECYg3Og1s17gcJ7exMW4/a7L7elYdGLpCgQaau+TX0vSxPO+kRbmQBUlGFClrJyP4ORqk+C6G5udGTOul0D8KzdjJowxnEsvITlOF+Ab+AU8ejynzsxSqM0Zk7KQ6UkSbQ0Tr0zn30n/K7ZGeMJSUTKUfCp3CqinxoxoP0ogmxKDQBdq6/uwqXBw8bHioMs/i8CQI7fk4Ek4+INa7AsL+TF3+y6Z2TYXgO7AhYCgeVuQiKDLjigo2tB6wYOEJ2FGNV+lPkX3Mr6S2bwqMEmjzqXpDbK0yuXsT/my7Ao4fq17rMV+2+z89/bDhrAF9spMC/mJHcyh28txjY6oPSrSNPVXkRm4pvBzaKoBky4Wjw4E=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(5660300002)(107886003)(82310400003)(83380400001)(2906002)(356005)(426003)(7636003)(2616005)(8676002)(186003)(47076005)(86362001)(54906003)(70206006)(7696005)(1076003)(4326008)(336012)(36756003)(26005)(110136005)(316002)(508600001)(70586007)(36860700001)(921005)(7416002)(8936002)(36906005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:05:07.8661
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8217087-c568-4a94-d30d-08d94d009127
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4651
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Pismenny <borisp@mellanox.com>

Both nvme-tcp and tls require tcp flow steering. Compile it for both of
them. Additionally, use reference counting to allocate/free TCP flow
steering.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h        |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c  | 10 ++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h  |  2 +-
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 1d5ce07b83f4..8690919f2cde 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -132,7 +132,7 @@ enum {
 	MLX5E_INNER_TTC_FT_LEVEL,
 	MLX5E_FS_TT_UDP_FT_LEVEL = MLX5E_INNER_TTC_FT_LEVEL + 1,
 	MLX5E_FS_TT_ANY_FT_LEVEL = MLX5E_INNER_TTC_FT_LEVEL + 1,
-#ifdef CONFIG_MLX5_EN_TLS
+#if defined(CONFIG_MLX5_EN_TLS) || defined(CONFIG_MLX5_EN_NVMEOTCP)
 	MLX5E_ACCEL_FS_TCP_FT_LEVEL = MLX5E_INNER_TTC_FT_LEVEL + 1,
 #endif
 #ifdef CONFIG_MLX5_EN_ARFS
@@ -231,7 +231,7 @@ struct mlx5e_flow_steering {
 #ifdef CONFIG_MLX5_EN_ARFS
 	struct mlx5e_arfs_tables       *arfs;
 #endif
-#ifdef CONFIG_MLX5_EN_TLS
+#if defined(CONFIG_MLX5_EN_TLS) || defined(CONFIG_MLX5_EN_NVMEOTCP)
 	struct mlx5e_accel_fs_tcp      *accel_tcp;
 #endif
 	struct mlx5e_fs_udp            *udp;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
index e51f60b55daa..21341a92f355 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -14,6 +14,7 @@ enum accel_fs_tcp_type {
 struct mlx5e_accel_fs_tcp {
 	struct mlx5e_flow_table tables[ACCEL_FS_TCP_NUM_TYPES];
 	struct mlx5_flow_handle *default_rules[ACCEL_FS_TCP_NUM_TYPES];
+	refcount_t		ref_count;
 };
 
 static enum mlx5e_traffic_types fs_accel2tt(enum accel_fs_tcp_type i)
@@ -337,6 +338,7 @@ static int accel_fs_tcp_enable(struct mlx5e_priv *priv)
 			return err;
 		}
 	}
+	refcount_set(&priv->fs.accel_tcp->ref_count, 1);
 	return 0;
 }
 
@@ -360,6 +362,9 @@ void mlx5e_accel_fs_tcp_destroy(struct mlx5e_priv *priv)
 	if (!priv->fs.accel_tcp)
 		return;
 
+	if (!refcount_dec_and_test(&priv->fs.accel_tcp->ref_count))
+		return;
+
 	accel_fs_tcp_disable(priv);
 
 	for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++)
@@ -376,6 +381,11 @@ int mlx5e_accel_fs_tcp_create(struct mlx5e_priv *priv)
 	if (!MLX5_CAP_FLOWTABLE_NIC_RX(priv->mdev, ft_field_support.outer_ip_version))
 		return -EOPNOTSUPP;
 
+	if (priv->fs.accel_tcp) {
+		refcount_inc(&priv->fs.accel_tcp->ref_count);
+		return 0;
+	}
+
 	priv->fs.accel_tcp = kzalloc(sizeof(*priv->fs.accel_tcp), GFP_KERNEL);
 	if (!priv->fs.accel_tcp)
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h
index 589235824543..8aff9298183c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h
@@ -6,7 +6,7 @@
 
 #include "en.h"
 
-#ifdef CONFIG_MLX5_EN_TLS
+#if defined(CONFIG_MLX5_EN_TLS) || defined(CONFIG_MLX5_EN_NVMEOTCP)
 int mlx5e_accel_fs_tcp_create(struct mlx5e_priv *priv);
 void mlx5e_accel_fs_tcp_destroy(struct mlx5e_priv *priv);
 struct mlx5_flow_handle *mlx5e_accel_fs_add_sk(struct mlx5e_priv *priv,
-- 
2.24.1

