Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B57B3F029E
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 13:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235649AbhHRL0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 07:26:17 -0400
Received: from mail-co1nam11on2043.outbound.protection.outlook.com ([40.107.220.43]:57376
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235666AbhHRL0I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 07:26:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cKyLdt7ZN6nCQQEcdUpUJAkjBPwmu3IwmYxOiaUUgziRcq2bB+X8jICZrQ1vNw1jH7vBoF3lU/4uzlY2dvDYbWxssc/5ratz4Vq5GOEjQtb6l3OxhMwhCIK7PGuw5CtBoQriI+I6bwEVW08LN1xilC0HXt67zS9hITkUfiyaGgkkv87AF4x8q2CHnenCAArm8HEBhhsEWgC3gMxR4nmbRL9QRRc8S8/JyVpv82TB4a0Fg1l7sY86Rk+BhtoYgYbeJDijzURJp8SKxjcabvNY2CxL+dYvEt4j9awvLOU8ItQE3oCQ+wZm38aCV5y3e2Z8fCQoPUot+jKm7OKKS6NCIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Kqog8Gh14fdKptZuXLF2uYnKpmdck7CxBJ6fyfByYE=;
 b=kD6RL76TC8bjYCZ9H3ETP31bFMKCVJz9uxSs15wmE9PEN+JmNZmT2+OPhuPhid8HkRdgDDPLd6pny7qiDLTancOJmAWjVDgHgQpMvg2FODLVzO3gt44r5OnJFRjBzh7iOWr06Py45UuYle/UPD9iiQ1OUnyS7ZCAFXWo2ZwD+Ss8SFlqqJvWdKYhQqZIWVuh83fRpxhfMkGoFRVEXdNLpfIssrkTEzeabBVNggHPfXCtTj6TI7Ghu/w52UFe1FmG0/5KJTSBN3r1kMabj1HwSwOoxcNoHR7oteI5rkuBhRYx4W29SaQA51xMRWNC1f/j/1IQUqHUNXLuUp1J5+KYgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Kqog8Gh14fdKptZuXLF2uYnKpmdck7CxBJ6fyfByYE=;
 b=IDMbJqp7uIyp6K2wcUIwf1qKs1kL8WbftxbGEXLSNxfU0t7V2CojJQqG1KkBtnFJLMF/lIbX7jgqT6d91WzUHuESBW8jIG603n2bEWVlh/UQS++0yNbvNcJT6U2FwhRm5gSj9IQKMx5mAPOQ4H5CDhr2hj8qTlcgfBwokLukLDCJaweUHXRZYmIQIJLKgmae8PXGDboRdJrP9x+C/qKH8YQxW6sAee94+xUsJq798mZzhWoH/MiIyPhm4XRaqGbbjGBfXJkl0mWH09ePGfmenBI3wn/71/HP2aJ9u42QwVCCbB1riPko1aiOyv2utIRguX8oH4wsVulBp3sUiIDwIg==
Received: from BN9PR03CA0225.namprd03.prod.outlook.com (2603:10b6:408:f8::20)
 by DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Wed, 18 Aug
 2021 11:25:32 +0000
Received: from BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::86) by BN9PR03CA0225.outlook.office365.com
 (2603:10b6:408:f8::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Wed, 18 Aug 2021 11:25:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT035.mail.protection.outlook.com (10.13.177.116) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 11:25:32 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 11:25:31 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 11:25:31 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Aug 2021 11:25:28 +0000
From:   Mark Zhang <markzhang@nvidia.com>
To:     <jgg@nvidia.com>, <dledford@redhat.com>, <saeedm@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH rdma-next 07/10] RDMA/mlx5: Add add_op_stat() and remove_op_stat() support
Date:   Wed, 18 Aug 2021 14:24:25 +0300
Message-ID: <20210818112428.209111-8-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20210818112428.209111-1-markzhang@nvidia.com>
References: <20210818112428.209111-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 485391c9-2936-403e-c29a-08d9623ae41e
X-MS-TrafficTypeDiagnostic: DM4PR12MB5040:
X-Microsoft-Antispam-PRVS: <DM4PR12MB50409A90D9CC2D20EF00272FC7FF9@DM4PR12MB5040.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1013;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d+JXucw9WSnBSIqgco8nHfYsNsoX+e2TwqHFaHAf8DDf3s/yJ7QifYTKM7R9AGJ9DEBUhwXEmkG0keNB83tXZtor/rX45uJ/L9o2EQSZ8LuLsg7Wr/Fdcs2uQQQkZx78KFkxS6p4zcoN9hpLZVKFmlyUieXjNtbYorD2fHO5bbwj+U9i+LeVbKgJfwOGM0xjZ8MBbR1n6Axt1zNzbJbxqGHYmznxC5IH7KLS3EWCo4KLLuCJnjWC0aoLWkrW82aspB6a3pceMcOFgdlL1hpbz3RvC+lkt92inDKQ60x3I4a32mklqq3L4vdGXqgXw45PSws5yVoNX0CpBZwQSeFVdOpUty/+UzgrL7CxkEJ+a1H6KKy5WD1WQFKvUoEhbjb3ZPfDzpEaMUYNEMc9j/kqB/8Iaw2PYAcF0NJpFBBD91TWbhAKXs+hbtBo4N5RxBLvtmRY2UKkgxFjG4N9V9cPDl+Zl8B9y2VE/u0pF7+XS4pQ4AvvdTVzpeTkN8FsQ8eLJkjUmGvAlh9pUKMB4mrMpmF5dwl1C2Z3o+5CAReSggwm/Rm1NAgooOfbEnduQFSk7timBmImMx6WSUJiExW/ozK275lhkVMddv9MQKYXURP9GGWbDC83DJ+gxpms4+Vjk6XqonkSxXr3JcjT4xhk77hjD4+B34hY71nVH9NngnPixJUpddTnXKXTZnR81l7ZSd2WdzJa0KV2ITZZ39EodA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(136003)(376002)(46966006)(36840700001)(5660300002)(70586007)(70206006)(47076005)(83380400001)(186003)(26005)(6636002)(2906002)(7696005)(36756003)(426003)(478600001)(1076003)(36860700001)(2616005)(336012)(82740400003)(86362001)(356005)(8936002)(7636003)(6666004)(82310400003)(8676002)(54906003)(36906005)(107886003)(4326008)(110136005)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 11:25:32.2793
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 485391c9-2936-403e-c29a-08d9623ae41e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Add support for ib callback add_op_stat() and remove_op_stat().
When adding an optional counter statistic, a steering flow table is
created with a rule that catches and counts all the matching packets.
When removing this counter, the table and flow counter are being
destroyed.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 drivers/infiniband/hw/mlx5/counters.c | 63 ++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h  |  1 +
 2 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index 5b4b446727d1..5bd1e5a5dffa 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -544,7 +544,7 @@ static void mlx5_ib_dealloc_counters(struct mlx5_ib_dev *dev)
 {
 	u32 in[MLX5_ST_SZ_DW(dealloc_q_counter_in)] = {};
 	int num_cnt_ports;
-	int i;
+	int i, j;
 
 	num_cnt_ports = is_mdev_switchdev_mode(dev->mdev) ? 1 : dev->num_ports;
 
@@ -559,6 +559,16 @@ static void mlx5_ib_dealloc_counters(struct mlx5_ib_dev *dev)
 		}
 		kfree(dev->port[i].cnts.names);
 		kfree(dev->port[i].cnts.offsets);
+
+		for (j = 0; j < MLX5_IB_OPCOUNTER_MAX; j++) {
+			if (dev->port[i].cnts.opfcs[j].fc) {
+				mlx5_ib_fs_remove_op_fc(dev,
+							&dev->port[i].cnts.opfcs[j]);
+				mlx5_fc_destroy(dev->mdev,
+						dev->port[i].cnts.opfcs[j].fc);
+				dev->port[i].cnts.opfcs[j].fc = NULL;
+			}
+		}
 	}
 }
 
@@ -738,9 +748,60 @@ void mlx5_ib_counters_clear_description(struct ib_counters *counters)
 	mutex_unlock(&mcounters->mcntrs_mutex);
 }
 
+static int mlx5_ib_add_op_stat(struct ib_device *device, u32 port, int type)
+{
+	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_op_fc *opfc;
+	int ret;
+
+	if (mlx5_core_mp_enabled(dev->mdev))
+		return -EOPNOTSUPP;
+
+	if (type >= MLX5_IB_OPCOUNTER_MAX)
+		return -EINVAL;
+
+	opfc = &dev->port[port - 1].cnts.opfcs[type];
+	if (opfc->fc)
+		return -EEXIST;
+
+	opfc->fc = mlx5_fc_create(dev->mdev, false);
+	if (IS_ERR(opfc->fc))
+		return PTR_ERR(opfc->fc);
+
+	ret = mlx5_ib_fs_add_op_fc(dev, opfc, type);
+	if (ret) {
+		mlx5_fc_destroy(dev->mdev, opfc->fc);
+		opfc->fc = NULL;
+		return ret;
+	}
+
+	return ret;
+}
+
+static int mlx5_ib_remove_op_stat(struct ib_device *device, u32 port, int type)
+{
+	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_op_fc *opfc;
+
+	if (type >= MLX5_IB_OPCOUNTER_MAX)
+		return -EINVAL;
+
+	opfc = &dev->port[port - 1].cnts.opfcs[type];
+	if (!opfc->fc)
+		return -EINVAL;
+
+	mlx5_ib_fs_remove_op_fc(dev, opfc);
+	mlx5_fc_destroy(dev->mdev, opfc->fc);
+	opfc->fc = NULL;
+
+	return 0;
+}
+
 static const struct ib_device_ops stats_ops = {
 	.alloc_hw_port_stats = mlx5_ib_alloc_hw_port_stats,
 	.alloc_op_port_stats = mlx5_ib_alloc_op_port_stats,
+	.add_op_stat = mlx5_ib_add_op_stat,
+	.remove_op_stat = mlx5_ib_remove_op_stat,
 	.get_hw_stats = mlx5_ib_get_hw_stats,
 	.counter_bind_qp = mlx5_ib_counter_bind_qp,
 	.counter_unbind_qp = mlx5_ib_counter_unbind_qp,
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 130b2ed79ba2..4dd4e43f118e 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -818,6 +818,7 @@ struct mlx5_ib_counters {
 	u32 num_cong_counters;
 	u32 num_ext_ppcnt_counters;
 	u16 set_id;
+	struct mlx5_ib_op_fc opfcs[MLX5_IB_OPCOUNTER_MAX];
 };
 
 int mlx5_ib_fs_add_op_fc(struct mlx5_ib_dev *dev, struct mlx5_ib_op_fc *opfc,
-- 
2.26.2

