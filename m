Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A943D2284
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbhGVK0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:26:06 -0400
Received: from mail-dm6nam12on2062.outbound.protection.outlook.com ([40.107.243.62]:40131
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231830AbhGVK0C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:26:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPQYS7auD4l8+XRDQ/7tNcqsm61hffHbYOF1YZEUeNKOlnv9ZQZkaXjQ4/VYxy3q/MeKl+QkqMTI+E6zm5U6ONiTRfOQ7hN9DCqNHTB55LuJRH6qYB7rUEVyvm3+HRUG+rlVKLRpkmi/y1culVP9RyE6/FkIceBkAUb7xAih7YrRjMLq8MvkMEj3r6HKG5LaSfK4DxyI1B5M9NgQAJ/5+aEJIz2+e0zgiD8MNlreCdgUroz91Z1cmsyOUxoR2vErqgSMN8NLscDgi+YBAXKdILWU3Mw7zPiDP8r0JsbQyBejX4K4WJ3JLyEfUZwDYCw4wxCEq5KQCZFLtdVQSfZTkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFWAURlZn+oTTIbQ4EusZH6LHrHcGZ+656qWJEmoB20=;
 b=Qz4wBSK37w8aLr802+RaXZL5A0vKY2ZMjYv2PzUhJjpCN4jQ1d72qb58h+0O5PEGVJ6ygAkFdcU1lUnIb/GYgOX8CfJJi5/CIvHJjtmhygSodQrRJ9gmFMHxdcvVf0imPHIRHFb8UK0ro5vDNbLmd0y1yBnAmrq9QLV+T5WuUOsYc5mVQUTV0w6FGz9ky2Vj3D4XS3HUBjzGtm6ghsHv1mBG1BzpWIh/eRbr+sKz/Ttgy6MghNDACFX4VRRVwUvGVoUZPVQPT+6ZPo8rsXWDRA5MZN/+sGBSvWbG6Y0HluJmKKZyqikSj6TimdqQFrJDQAU2PmZ217bLt+lwLYhSCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=marvell.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFWAURlZn+oTTIbQ4EusZH6LHrHcGZ+656qWJEmoB20=;
 b=Kevom7opTg5whHCR4fmxlSzg5IhtPHzybrIFnMqwvOB5QahZP+I9B3cEMsP+kunnWB1pUTbDgIMDU0MFweyPBAFf2UUdxcRcT8Z6MAWNMbbDM+Cz6thOv4tprZf1UMNG5kOrcwmJJTrUE2tp5in1JnHATkHqJscbvNL+wR/TcuTCj9yhUTFibiH7s3i5PayhrERaNSyogG9RVhQzw7tZVvHE+b3/1cQybv3SrngZsV2/8YIChxg7hrLVc5UwNE3MrFOEgTM8gFdhjkecoZe14ELv8ChLLnxC9d9lT7qKuocqCRkmPSBj4WiVlaRE/VYbKnFByQQPxwcD0XdANVpxvg==
Received: from BN8PR12CA0021.namprd12.prod.outlook.com (2603:10b6:408:60::34)
 by DM6PR12MB3035.namprd12.prod.outlook.com (2603:10b6:5:3a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Thu, 22 Jul
 2021 11:06:36 +0000
Received: from BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:60:cafe::91) by BN8PR12CA0021.outlook.office365.com
 (2603:10b6:408:60::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend
 Transport; Thu, 22 Jul 2021 11:06:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT062.mail.protection.outlook.com (10.13.177.34) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:06:35 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:06:35 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:06:30 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>
Subject: [PATCH v5 net-next 29/36] mlx5: Add support to NETIF_F_HW_TCP_DDP_CRC_TX feature
Date:   Thu, 22 Jul 2021 14:03:18 +0300
Message-ID: <20210722110325.371-30-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa6f2228-9ac5-4409-2b78-08d94d00c577
X-MS-TrafficTypeDiagnostic: DM6PR12MB3035:
X-Microsoft-Antispam-PRVS: <DM6PR12MB30358BE3CE50E3B5A9343F38BDE49@DM6PR12MB3035.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:346;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mTh8PngNsRmpAoKQQJRU6cZ4xS+jahvvj358diA27WmmZAuub+ebFYxvMv06Ls1M+u9PEbOfD2kOUz4HqMVLCCdB0OGkmyhWJrH8diOt+qK5urftl4KpMq61x1r5afI0x9GuvaxVv0UzVgMq2Zd3CMp46S/L2o+xdW3vBoz82OnwA/+qKrXM2kPlU8XYwLz8Ua0Th1O1hloa1srATeLDg/gA6D4IQMh2JiuutX8hvRgRkz15pGc+shYqVe5y6WPcOXGhC72oUZTh1ZhN21VvmoL2hSe1VxheXuFETNa7JFwDREIsjNQ7i5w3FZI72znL11J5aA1Dym42BEGhiHAMFGpGo1wDEFf6BbzshXbg9FMvMioBHN9lrM4WhhLKKpExpeSJcz6H8CSV3npk2BGASGbCd6l9CIN6UsAg+Ps2yfY2MI7CBLMJ7pj/e38V1S1TJjxeqS6VZeGChRYlV6boU7K2ifh+R4/0ASuopwF3h42pAbOfxxrBTkqVhF3pn5+PcUZgsoQH9ElUu6m0pB4XuV+g3nh3WFGpLozPMd+hv618pWqgsvsy7KbU5lFh7u8sDlKcsWbNGo1sEQLwL4YXhj4/Te2AMenx2N2aPCi8nC1G0AiOz7P4N+1UQh8YT8rUcsNXfbxqKV8Fv1pJ9nY6X7luUCj+K2aRdlFBL1coTbQIM0tzXr3fiY0qbtqdWFux9P+M73fzqPkr8uJhnDoIOQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(46966006)(36840700001)(5660300002)(8936002)(70586007)(1076003)(356005)(36756003)(4326008)(107886003)(7696005)(26005)(316002)(36906005)(6666004)(70206006)(86362001)(7636003)(8676002)(82310400003)(54906003)(110136005)(2616005)(186003)(36860700001)(921005)(478600001)(4744005)(82740400003)(2906002)(426003)(47076005)(7416002)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:06:35.6227
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa6f2228-9ac5-4409-2b78-08d94d00c577
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3035
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoray Zack <yorayz@nvidia.com>

Signed-off-by: Yoray Zack <yorayz@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index 7f6607cac9fb..db6ca734d129 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -961,6 +961,11 @@ void mlx5e_nvmeotcp_build_netdev(struct mlx5e_priv *priv)
 		netdev->hw_features |= NETIF_F_HW_ULP_DDP;
 	}
 
+	if (MLX5_CAP_DEV_NVMEOTCP(priv->mdev, crc_tx)) {
+		netdev->features |= NETIF_F_HW_ULP_DDP;
+		netdev->hw_features |= NETIF_F_HW_ULP_DDP;
+	}
+
 	netdev->ulp_ddp_ops = &mlx5e_nvmeotcp_ops;
 }
 
-- 
2.24.1

