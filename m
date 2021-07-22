Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808C93D2283
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhGVK0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:26:03 -0400
Received: from mail-dm6nam08on2053.outbound.protection.outlook.com ([40.107.102.53]:22369
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231691AbhGVKZ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:25:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aXOxi2YxmS3eoFFcwMC5tDKTAC/E9hOWUHn91KR7w1A9OgA+7zTDYEPAWdscN1/VhlS/yLYvIUQSnJ9FzXOZ6JuexYCf/wR1Wo2/3Xu+u2PtF44fdH6PJfTbw5RLlhdsykysDMycD3uMO9TmH/DweaMgHZCtRxMFvflIQRM9FUFpcdk+Hv9tvc/1tqh4VV2seXMx7KJRpA8M5tYjh4wjH6Um08OSfm/6dnDDEw6jRkY2BpnvIdCJfueYva5sXRYAjVCChhhPVA2X0ODSnm+7g90D2nh1ohSl7i6DkZDy6g7ey6xLkEky1Jwx9CxJ89VZ+VPPamPT0aaySC6Cws28MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z3Xi7Jm7cHtuQga9L9DUfGVQhLB2apL3CHtkwPPf1io=;
 b=AxJrxxPQCGuwZjag4WbAzjmhYxRaPycShKkLyk2SEJh/RHxau5t7RYcEKFVboBjTU9354WUfpw9CiZbr74nBIryg5DCD/A68CoAUdVWf6vQN85aQJXnAiRfrNhm0TNzDMjoQHI7b6AKai5Z4UksJJAdXvpuX5CjNTyjjHHkIF/ZCL7MbgURDhqxGuu1BfAs15YGyQIwyVhdTWlibDAqOBdic9OcQKd2H8fYoZD8TqTy+1AmGx7G6AZpf8W5g1hlw/nSyw92zENWw/YmU603U3lTGRVX42Qj1guqeRGn8C1ILhLLbhYP3BAtpSP/91xbribnEx7cwNXDtCsy/oRwRSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=marvell.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z3Xi7Jm7cHtuQga9L9DUfGVQhLB2apL3CHtkwPPf1io=;
 b=QG0sg1VAysxZWuqopAVFw6PJpaipDqQ9hXhqHc2CpMhhAvP6ZCF+06Xl4nqlPaGhM96jn5U95s5aGSK2LY2f9m2E8ple6R0UPHupKmjSweHX2qwWQIS5bfbKruwgrDgJyy4Xra28BuFHn6vN90ux19ryUNO056a99mHQ9YheyqW5pRlVhv4mwYIowPIwXRMSnDqBR9e735yQlFESkirri/ISICbUN6N/KdfGpHGzw0ZmgWWcjQIyC7n+WPMAt0Cq2aYL3kRz/ObJMYBfwzjK1T7f6piVBs1H7R6ubr+4LY2fcSd7ru7Re6KNUvlx4drTy6TZNsk8ZDMvclt8yYl5+Q==
Received: from DM5PR10CA0011.namprd10.prod.outlook.com (2603:10b6:4:2::21) by
 CH2PR12MB4183.namprd12.prod.outlook.com (2603:10b6:610:7a::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4331.24; Thu, 22 Jul 2021 11:06:30 +0000
Received: from DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:2:cafe::29) by DM5PR10CA0011.outlook.office365.com
 (2603:10b6:4:2::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend
 Transport; Thu, 22 Jul 2021 11:06:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT058.mail.protection.outlook.com (10.13.172.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:06:30 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:06:29 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:06:24 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>
Subject: [PATCH v5 net-next 28/36] mlx5: Add sq state test bit for nvmeotcp
Date:   Thu, 22 Jul 2021 14:03:17 +0300
Message-ID: <20210722110325.371-29-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e23eaa1-fd0e-4fe9-7b9e-08d94d00c236
X-MS-TrafficTypeDiagnostic: CH2PR12MB4183:
X-Microsoft-Antispam-PRVS: <CH2PR12MB41835EB2BE6274495A086677BDE49@CH2PR12MB4183.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:758;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r75aQZjRqbawv/5XgB31v2O4zrzVpSNLwP6jHXhTRkWK3Bc/TCt7jt+kpOFUkyWRC7efFd8U1Ous9fxCBSA5NqiulXDf6X6fASg4HcmI68h3V/Sg0M9GAzyMA5LuBCtaaUfuUjJ8UPdd8FosQtt6Qt+4eLulH2EF9yyZqi6QWe4tRlRxVsvvKRZXVFwF6lw46ZZhhG0M2uG8O5eU3eqyTkFwBWH79Hzhv6OdRUk7P61JQg9q5ZlWw8UdZvdt363zvOpPY95C9XjbSEUsuRcLJNGgi36Gk3iLNCQ/ctKnaVUkZkZsvdUOPSkkr1SczZM7rLjUxfKuIKNkdmokzKcKj9KtcZow2+RikLJb6KjFN4W+npVsZbTvpxjD2QkUxwwoqbwF833yG7+TB+J6orDXzGybHI0EDgKo+vLL7USW3N3qtdEp/0g7QTzAj6fCDg4wMwsGqxUiOfasTs/IuMwpGTH+4ODEPdbo7vFo7dAGZ5jgXBrV5bTWs7uIgXkIiSkcGpqwuaF2h3V96k/gQWzHjdWkC5Nnu4pkG6JxBCSw8XWlSiOoG0zFnIIe8+ZYYEsFbqm2ke1I6X5vHxTLZsZNQmW9oMrZw51WRN3DqM9WPV6VRLqETRUGMzsvuyAzG2ZgGZFpR3YhCUBxqOrq/QQ8CzW4kkZBq8W8FhnDLyBi9B6VDUGrFtoEEZJ/YjRlRHi/y1/01mOUwtiqr8z/rS9tkp5O/lj7GfZYTZen/UQIW5k=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(5660300002)(356005)(70586007)(36756003)(1076003)(107886003)(26005)(86362001)(36906005)(70206006)(6666004)(316002)(4326008)(7636003)(8676002)(82310400003)(54906003)(36860700001)(8936002)(110136005)(2616005)(47076005)(7696005)(336012)(186003)(921005)(2906002)(7416002)(508600001)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:06:30.2205
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e23eaa1-fd0e-4fe9-7b9e-08d94d00c236
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4183
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoray Zack <yorayz@nvidia.com>

Add to the sq state a bit indicate if their is an nvmeotcp crc tx offload.

Signed-off-by: Yoray Zack <yorayz@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index c87f32492ea4..58724d4c27e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -353,6 +353,7 @@ enum {
 	MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE,
 	MLX5E_SQ_STATE_PENDING_XSK_TX,
 	MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC,
+	MLX5E_SQ_STATE_NVMEOTCP,
 };
 
 struct mlx5e_tx_mpwqe {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ecb12c7fdb7d..b76e590c237b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1142,6 +1142,8 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 		set_bit(MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE, &sq->state);
 	if (MLX5_IPSEC_DEV(c->priv->mdev))
 		set_bit(MLX5E_SQ_STATE_IPSEC, &sq->state);
+	if (MLX5_CAP_DEV_NVMEOTCP(c->priv->mdev, crc_tx))
+		set_bit(MLX5E_SQ_STATE_NVMEOTCP, &sq->state);
 	if (param->is_mpw)
 		set_bit(MLX5E_SQ_STATE_MPWQE, &sq->state);
 	sq->stop_room = param->stop_room;
-- 
2.24.1

