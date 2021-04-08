Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7088357ECB
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 11:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbhDHJLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 05:11:21 -0400
Received: from mail-dm6nam11on2045.outbound.protection.outlook.com ([40.107.223.45]:18176
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230397AbhDHJLR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 05:11:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d4qDzHiv5Sz9e9umdFx4NIXAp7mFzi41ReJ5pC5LMD1Y7ara8fQoFrGZpxPJuwkpi2V7TAq/lxqAq78pAGf0V+NTCtVcn1o62jXbcZzu37V/6F3us2c3BvC/docEBaZ7r9i7SkCszv58GKFoGpJOdMA5dUy1QGpddqLGCp3WL9CrHj3BoeN4T9ke8sE+VkHSKMNQ77DX5vVzeJ9e5+CNQxVhFnyLC1vPYu8EbBEgK4K4ehi6wm4R4ofUuNJp6GjtXUNMalXJh5/nPyVDfLlmR1gEtHrFsVMPXLQfMnyK9QKSzRr6s+3gPFBF366pkoRlEgph6/LT4A+lIfYtpwCGUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Coptz7DuRbmfq6qEdxYioO0mT5ALK1Kx9sK7KD7Pso=;
 b=PeVylaeu/BC0KgT8J0ibqdj8bxNBJhYKAZCqJtUe1e3A7Bfr8BuJqy+Hn962gWtDBqiq8VOQf30yhZgh1RoBZqoYOzPAcLC1dinJBlvP2Ey9/orb1TvL9Ue3atQV+LfRVjkytpF9l+qFmgAz9a0ooPTCgtz28nJ1FUhhc+zhAIjUIjh7VWLPwAt7O0o1hthUzhPbwRkK/9T4cbw3F5yQWBtYZKxgBdNTY/ShXBTNvkNieGwrDWIOO12qgDg/ymKOFjgL3osYGwPpPRbbneb32LEOWn6u9zcuzaNeBkMv1XIaUblOIARH+W8xywdyCesXgMdWUbvzxBRqQ7C8Pahlxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Coptz7DuRbmfq6qEdxYioO0mT5ALK1Kx9sK7KD7Pso=;
 b=AH3DQgW6dRC1RDUd7fBcW+BQ+OTMG0LJjH9N8lJlFJyk21wXRaX7JDeF6vEpaOWIvp2dlfPCPrUdCODGO7TrKH5QNfc7p5vcJMAiguQGzTOBLZTkigmwnQ6auyHN/XMotd2PEsi46RUODpbHdlRsd+T/dbWD9715QbW5zziflGsF4hASOciL94yEBA38JS72fL9BULEO55taruKaCWmOGmyKkMQcXYVr1uM2Sh6fsm6thPFLj0GzoI1Tyo/srypO8k/0cJpzWV2Mx+962N3juQ+tcVKEt8WCzV9o0HEUEAIRo6bTETcvoQpgkBGJuWkscEVbD+MD1ztGTc6GKZqZeg==
Received: from MWHPR18CA0048.namprd18.prod.outlook.com (2603:10b6:320:31::34)
 by BYAPR12MB3525.namprd12.prod.outlook.com (2603:10b6:a03:13b::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Thu, 8 Apr
 2021 09:11:05 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:320:31:cafe::2f) by MWHPR18CA0048.outlook.office365.com
 (2603:10b6:320:31::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Thu, 8 Apr 2021 09:11:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 09:11:03 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Apr
 2021 02:11:03 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 8 Apr 2021 09:11:01 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <parav@nvidia.com>,
        <si-wei.liu@oracle.com>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Eli Cohen <elic@nvidia.com>
Subject: [PATCH 4/5] vdpa/mlx5: Fix wrong use of bit numbers
Date:   Thu, 8 Apr 2021 12:10:46 +0300
Message-ID: <20210408091047.4269-5-elic@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210408091047.4269-1-elic@nvidia.com>
References: <20210408091047.4269-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe604ead-f8c6-4477-ad04-08d8fa6e3c7f
X-MS-TrafficTypeDiagnostic: BYAPR12MB3525:
X-Microsoft-Antispam-PRVS: <BYAPR12MB35257763D056A8A49188CC7FAB749@BYAPR12MB3525.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S9ANR9COJB+K1NtfiWoGfm6slgroDC17YQ8gpilBzYCVYb2E4k7M85vZYWd7ed4GgA3eiC7BlV6o05+Wd3vTgiym0dApq3QlY/IFvEBstwQW9o2Z0m7Xs3B6kR6Ut/Y9rLD9B0P92ZU4xJPRxgCfg/vY1to1G2Qpcdn2OiIPC8hYF+ARXR45VgYcbRysi49kyArQzxkpAEAUybBmMOfSeCjFj5dD+CR0mzFugkac+XEuyvU1vezbqXbc6R1x7mGWBZo00bOeRbA0lvGjxA5rNAu2bs0uZSgO5mdVrO7GGL5R2xsAKYKJazl/IBwTAMJBXzXsWpTGLyhs9XCdLQmaCP9QmX6giAAe6dXhyAfaApmcE7bTSVhz3KINVbxm64Q2fX9MjqLigSMEhauz3DwL6XqtI/RoyW0dC9cVHObdKb2/jOO7hh+c0O6ySuA8cDq13gCFkn1aTBtY7gJvgCTUwCoGeZFVdsZ+UBGUqrzVblfOplTr6ttx1DbdEA5WGkspfaGMSZGurRNAZEbQGod4m0a4VEH7H08y3fJQPE7sMKQEWc6TTmM7C5WgJxDTEfJ9dLpT/HWRh0pN3aEffVCKVPms+25eL/gnxP234vUrg/tP6mGVIiyhveKuzrRK3htGEBicUGrSedV3HbZql3nqpTopvE6LmNZCNauTXPIbNyg=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(39860400002)(376002)(36840700001)(46966006)(47076005)(186003)(2616005)(36860700001)(1076003)(8676002)(83380400001)(110136005)(6666004)(5660300002)(36756003)(70206006)(26005)(70586007)(336012)(426003)(54906003)(316002)(2906002)(8936002)(7696005)(107886003)(478600001)(356005)(82310400003)(7636003)(86362001)(4326008)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 09:11:03.9962
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe604ead-f8c6-4477-ad04-08d8fa6e3c7f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3525
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VIRTIO_F_VERSION_1 is a bit number. Use BIT_ULL() with mask
conditionals.

Also, in mlx5_vdpa_is_little_endian() use BIT_ULL for consistency with
the rest of the code.

Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index a49ebb250253..6fe61fc57790 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -820,7 +820,7 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
 	MLX5_SET(virtio_q, vq_ctx, event_qpn_or_msix, mvq->fwqp.mqp.qpn);
 	MLX5_SET(virtio_q, vq_ctx, queue_size, mvq->num_ent);
 	MLX5_SET(virtio_q, vq_ctx, virtio_version_1_0,
-		 !!(ndev->mvdev.actual_features & VIRTIO_F_VERSION_1));
+		 !!(ndev->mvdev.actual_features & BIT_ULL(VIRTIO_F_VERSION_1)));
 	MLX5_SET64(virtio_q, vq_ctx, desc_addr, mvq->desc_addr);
 	MLX5_SET64(virtio_q, vq_ctx, used_addr, mvq->device_addr);
 	MLX5_SET64(virtio_q, vq_ctx, available_addr, mvq->driver_addr);
@@ -1554,7 +1554,7 @@ static void clear_virtqueues(struct mlx5_vdpa_net *ndev)
 static inline bool mlx5_vdpa_is_little_endian(struct mlx5_vdpa_dev *mvdev)
 {
 	return virtio_legacy_is_little_endian() ||
-		(mvdev->actual_features & (1ULL << VIRTIO_F_VERSION_1));
+		(mvdev->actual_features & BIT_ULL(VIRTIO_F_VERSION_1));
 }
 
 static __virtio16 cpu_to_mlx5vdpa16(struct mlx5_vdpa_dev *mvdev, u16 val)
-- 
2.30.1

