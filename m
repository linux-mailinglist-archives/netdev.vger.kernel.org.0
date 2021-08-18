Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D483F0297
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 13:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235598AbhHRL0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 07:26:04 -0400
Received: from mail-dm3nam07on2044.outbound.protection.outlook.com ([40.107.95.44]:32736
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235539AbhHRL0B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 07:26:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WqqSTsbAZm0Slk4ojMSOrHXeA1YYoG9/3fGV3/F1d9CrPABNxXSEltymcY5FrE3FcqHQv6c+eyUrpqJO7h9TKAC8Bp7M01jhx1sTs9yY6HJYW1stKJh0lfT89FCBODPswj0Bo0wmILJzL+90+pZqonunrMCtKu+CVCpMH8ylObAbmArLOqmkNHxj8Y3it7xxuJxq44UIRvAbvR099Kjhf5WYWq0Ytd3UdK1kyBLCOo/eRh4UwoOTGAyo3rk7K7pUyjFxw5WWlzcQPpv/Fmgmcog09XwQcMYle2BSI/3i2n6grHIwtxroOyIXdPDBV65DBTtII7MKpXNGwi2xYLZwYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkEoTf7C14IfAv/cp7u8XZpx7f+IeI7b6/6RK5uYip4=;
 b=NOzhY/AyLyBqKe0ba6667kTL2v3cz5Y6o9UDuUXDKGaN+bw3EjUADv/gp12gIVqKoXirI61RWcU09n4divqXtxYccekeZgmQq7tzrXrkCUhvqfZX2imp8kzOa0Fi9i0rUiisUaBX7NqU/VRdwl2upNe06HuIU2C2O16N8icXigxq1BgIb6b+y6aBuePDm58kMNtaaWRumGE51CfrNY9WHzm5rLFjXAjE5had9KpNuzVxQrIZyx4WUnQH5KKtO3PVLPkrDKEgiocwgB7Oo/77qLsePwBzjwCY2ua5opYAIeHcEo8hkR5+VQqK9VjCfYYwwa5KuVWJi0Hezy6hyIeN8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkEoTf7C14IfAv/cp7u8XZpx7f+IeI7b6/6RK5uYip4=;
 b=AkbWazGhro/hWjoCwPZe0U3q556VOoY/vecypMRSuorqgsCej9DfxiQmDYqfOJkl+1VHN7UTxOGL6RuycjB8w1KBwXMx6WZFB4ifx+yRqMyuusM2RrZ15G9KZ7hQFmVthI8aDgDfyZZyfIai0mOQVXDuczbHvnu5iPyNTBCAyPxQHhlYO0pMaIAHL129e4qBGUP8GWQ78kI1jekhc/OXFoa/2lrt6R82+QtuVGd3+dTFvCvpLCQ/8uwviNq2/rAmwDI6wcBuilFUefgNiRfuZV945rdncKilFiqMVJDsO4Jm6Tk8Lm60nL0mm9SJGzEaTrOyvogj6zppLn4GdNVQ4w==
Received: from BN0PR03CA0010.namprd03.prod.outlook.com (2603:10b6:408:e6::15)
 by CY4PR1201MB2518.namprd12.prod.outlook.com (2603:10b6:903:d6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.22; Wed, 18 Aug
 2021 11:25:25 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::ef) by BN0PR03CA0010.outlook.office365.com
 (2603:10b6:408:e6::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Wed, 18 Aug 2021 11:25:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4415.16 via Frontend Transport; Wed, 18 Aug 2021 11:25:25 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 04:25:23 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 11:25:23 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Aug 2021 11:25:20 +0000
From:   Mark Zhang <markzhang@nvidia.com>
To:     <jgg@nvidia.com>, <dledford@redhat.com>, <saeedm@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH rdma-next 04/10] RDMA/mlx5: Add alloc_op_port_stats() support
Date:   Wed, 18 Aug 2021 14:24:22 +0300
Message-ID: <20210818112428.209111-5-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20210818112428.209111-1-markzhang@nvidia.com>
References: <20210818112428.209111-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60b3bace-21c1-4064-34bc-08d9623adfd6
X-MS-TrafficTypeDiagnostic: CY4PR1201MB2518:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB2518FCE17B91AF2C688B7C47C7FF9@CY4PR1201MB2518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5jnw59P1GOYwt7xw1cUE9RK6dkAgCYwae6P7c2R69nagluko5Hin8aIfEl/8EMRjpNU5wvHcS/wQpWykALUJP9STj///Qr1FdXDHnCxsVCvvQJnPr+y9bahmdDrGPvL0YgBjMlUm6mQ0T414ZCtGDw13XBQ+3PKmmMfMgGHfFxkjsD3KHDAcp+fBCfcNR5OUN9vtOG4eQdf6B7BpzYBRORBi9ftfMs3Lfa+B3+zt/+FhO78/AdzQZx+oC6aLY8m4KeW2UxohAzTw/kzwWq3IV5s+SimIsRkhh29zPewETdC6TOthMrJz/2cPEONVw0Ef8cM6d4fDxpOZ287B8OuxuI6U0neStWeIwFzWn6udNTNt5/c1lhxkL+WZkhSfIJ09uMH0C1NS9ggYmMNcLEIKym+jy0OJ9JYZGmtnpdyU0pQDNzT97vx/QeXFAI/0aXlHSpCgj9Atybf/cicoBkETzruYlDhfZBDnG0AvX8w9dYJcYhDO9GHT7crbjSDdCACZIeZHHtGEFYU2ir2lu+KJc0r0LPYdb90cY3FiA/F8WLZ+UXUmQTbQJfy9p+R7EVdRrW5rq9OBahQ7+49VfD6CgHRmKDMu/tTnfpLBakW6m48m00mIKOlHqPwIeoNiz7OYJ+ADnn3Ewb0SVMnP3G/QPF743xmHz4GjiqssmAbUsQr0eAv+efNTACNQhjJUuHgQ6a5uj9w87C79wy5mvHitEg==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(39860400002)(36840700001)(46966006)(336012)(54906003)(47076005)(186003)(107886003)(2616005)(36756003)(26005)(4326008)(8676002)(1076003)(2906002)(6636002)(82310400003)(5660300002)(70206006)(8936002)(110136005)(70586007)(7636003)(7696005)(83380400001)(36860700001)(356005)(82740400003)(86362001)(478600001)(316002)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 11:25:25.1029
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60b3bace-21c1-4064-34bc-08d9623adfd6
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

Add support for ib callback alloc_op_port_stats().

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 drivers/infiniband/hw/mlx5/counters.c | 71 ++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h  |  8 +++
 include/rdma/ib_verbs.h               |  2 +
 3 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index 224ba36f2946..5b4b446727d1 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -187,6 +187,72 @@ mlx5_ib_alloc_hw_port_stats(struct ib_device *ibdev, u32 port_num)
 					  RDMA_HW_STATS_DEFAULT_LIFESPAN);
 }
 
+struct mlx5_ib_opcounter {
+	const char *name;
+	enum mlx5_ib_optional_counter_type type;
+};
+
+static const struct mlx5_ib_opcounter basic_op_cnts[] = {
+	{.name = "cc_rx_ce_pkts", .type = MLX5_IB_OPCOUNTER_CC_RX_CE_PKTS},
+};
+
+static const struct mlx5_ib_opcounter rdmarx_cnp_op_cnts[] = {
+	{.name = "cc_rx_cnp_pkts", .type = MLX5_IB_OPCOUNTER_CC_RX_CNP_PKTS},
+};
+
+static const struct mlx5_ib_opcounter rdmatx_cnp_op_cnts[] = {
+	{.name = "cc_tx_cnp_pkts", .type = MLX5_IB_OPCOUNTER_CC_TX_CNP_PKTS},
+};
+
+static struct rdma_op_stats *
+mlx5_ib_alloc_op_port_stats(struct ib_device *ibdev, u32 port_num)
+{
+	struct rdma_op_stats *opstats;
+	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	int num_opcounters, i, j = 0;
+
+	num_opcounters = ARRAY_SIZE(basic_op_cnts);
+
+	if (MLX5_CAP_FLOWTABLE(dev->mdev,
+			       ft_field_support_2_nic_receive_rdma.bth_opcode))
+		num_opcounters += ARRAY_SIZE(rdmarx_cnp_op_cnts);
+
+	if (MLX5_CAP_FLOWTABLE(dev->mdev,
+			       ft_field_support_2_nic_transmit_rdma.bth_opcode))
+		num_opcounters += ARRAY_SIZE(rdmatx_cnp_op_cnts);
+
+	opstats = kzalloc(sizeof(*opstats) +
+			  num_opcounters * sizeof(struct rdma_op_counter),
+			  GFP_KERNEL);
+	if (!opstats)
+		return NULL;
+
+	for (i = 0; i < ARRAY_SIZE(basic_op_cnts); i++, j++) {
+		opstats->opcounters[j].name = basic_op_cnts[i].name;
+		opstats->opcounters[j].type = basic_op_cnts[i].type;
+	}
+
+	if (MLX5_CAP_FLOWTABLE(dev->mdev,
+			       ft_field_support_2_nic_receive_rdma.bth_opcode)) {
+		for (i = 0; i < ARRAY_SIZE(rdmarx_cnp_op_cnts); i++, j++) {
+			opstats->opcounters[j].name = rdmarx_cnp_op_cnts[i].name;
+			opstats->opcounters[j].type = rdmarx_cnp_op_cnts[i].type;
+		}
+	}
+
+	if (MLX5_CAP_FLOWTABLE(dev->mdev,
+			       ft_field_support_2_nic_transmit_rdma.bth_opcode)) {
+		for (i = 0; i < ARRAY_SIZE(rdmatx_cnp_op_cnts); i++, j++) {
+			opstats->opcounters[j].name = rdmatx_cnp_op_cnts[i].name;
+			opstats->opcounters[j].type = rdmatx_cnp_op_cnts[i].type;
+		}
+	}
+
+	opstats->num_opcounters = num_opcounters;
+
+	return opstats;
+}
+
 static int mlx5_ib_query_q_counters(struct mlx5_core_dev *mdev,
 				    const struct mlx5_ib_counters *cnts,
 				    struct rdma_hw_stats *stats,
@@ -672,8 +738,9 @@ void mlx5_ib_counters_clear_description(struct ib_counters *counters)
 	mutex_unlock(&mcounters->mcntrs_mutex);
 }
 
-static const struct ib_device_ops hw_stats_ops = {
+static const struct ib_device_ops stats_ops = {
 	.alloc_hw_port_stats = mlx5_ib_alloc_hw_port_stats,
+	.alloc_op_port_stats = mlx5_ib_alloc_op_port_stats,
 	.get_hw_stats = mlx5_ib_get_hw_stats,
 	.counter_bind_qp = mlx5_ib_counter_bind_qp,
 	.counter_unbind_qp = mlx5_ib_counter_unbind_qp,
@@ -710,7 +777,7 @@ int mlx5_ib_counters_init(struct mlx5_ib_dev *dev)
 	if (is_mdev_switchdev_mode(dev->mdev))
 		ib_set_device_ops(&dev->ib_dev, &hw_switchdev_stats_ops);
 	else
-		ib_set_device_ops(&dev->ib_dev, &hw_stats_ops);
+		ib_set_device_ops(&dev->ib_dev, &stats_ops);
 	return mlx5_ib_alloc_counters(dev);
 }
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index bf20a388eabe..2ba352702294 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -797,6 +797,14 @@ struct mlx5_ib_resources {
 	struct mlx5_ib_port_resources ports[2];
 };
 
+enum mlx5_ib_optional_counter_type {
+	MLX5_IB_OPCOUNTER_CC_RX_CE_PKTS,
+	MLX5_IB_OPCOUNTER_CC_RX_CNP_PKTS,
+	MLX5_IB_OPCOUNTER_CC_TX_CNP_PKTS,
+
+	MLX5_IB_OPCOUNTER_MAX,
+};
+
 struct mlx5_ib_counters {
 	const char **names;
 	size_t *offsets;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index e8763d336df1..40b0f7825975 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -600,10 +600,12 @@ static inline struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
 
 /**
  * struct rdma_op_counter
+ * @type - The vendor-specific type of the counter
  * @name - The name of the counter
  * @value - The value of the counter
  */
 struct rdma_op_counter {
+	int type;
 	const char *name;
 	u64 value;
 };
-- 
2.26.2

