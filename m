Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3263F0299
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 13:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbhHRL0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 07:26:09 -0400
Received: from mail-dm6nam08on2040.outbound.protection.outlook.com ([40.107.102.40]:29439
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235570AbhHRL0C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 07:26:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XwzDyLdcmPbNnKXSuFYqNmgbco+0MuuDXIUFoMP6Pn3P7rGa5pVVBghUeWNAAE9h1Sdccz52G/2SDKKr/R3yUYVktla14zOEhHJ4WPklr3KhEjWJ8/unYyE7HpkEaK8oUdbLD5pViDcpzh0SLdeHrUk5KbhLZDg2/4gXeYhoKZ6Dw64Y9FmH9U7LTNt9LvGIpOHEseF8F/UheIrK7lCpYfUfDo2nxiwZckVJsifK+0UASnS+YhFSJkUHiHLjIjnoCLwogMGGcw89p82IASGTZDNRUZdriznH/bPnU+T44owykEwfJDj9GmyAu6AQE5juh551Jr7gN4IpPgXmAnZNvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5fHXxGqdFm9XBTC1WV32CCRN+7osRrirtaxou16t1c=;
 b=b/4fFbVtRAdG/cBbr/S0bGZ11EnA0i2hT4snFXa6KqNOR77GsjQ5RCq4sxWvNj358Zme4KBVKhehmaO8qDVV7dYv6D79vS7UC8KIKkk1XTkV06yy3N8g42mKnxNGZ/ReS89lUdGXrO73rHfi6qNI3W0qS1hN7eHeZp2xLDUnfB4TZPlen/+HmBJRcp/W7kWbsPzEeeyK9BzjuUCKXhlqxwHiqBhJrQKAxY4RYiZ/w2YEWNApVW+K3mec3cmmMV99vBT2++NVWyqvxlWXBWHWKzL+cYFNgb/wyEbMulRSw+qYSaHEyEYvbR4qqYbuIY6GBs0bTsvmnGne317xC1B7Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5fHXxGqdFm9XBTC1WV32CCRN+7osRrirtaxou16t1c=;
 b=tHmxY4QTzEjNXjuGmXOwanE7cMWnpFiVImLsx0y5fa6k28BNALOH1nC1HoRvHESqb2/6+xusWQfED/NQmRCbw8XEn/C3RHQyzEmzn9ugK8AJX8NXuf85R3lS1/ym6faUTD1qbLaa6LHosTFgzWWq0K4Lm0N0SooViKM7trUJTZBaMAUTP4Qs8wwwdQcZ3COkxy5RrWzBMhFujSbWBC04MRUJLgItmsxFJnfDVsMPDWXXzfqgxqmoYzPwgOm1DR6nMyNouQPQyF+1EUDZU5/IZcksQDL71o1a7WSYDqGnoCu/AM38mqFF1CRN+Y+34ahjuzFoM5jiLWw+6LFxczrr7A==
Received: from BN6PR22CA0053.namprd22.prod.outlook.com (2603:10b6:404:ca::15)
 by BYAPR12MB3110.namprd12.prod.outlook.com (2603:10b6:a03:d7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Wed, 18 Aug
 2021 11:25:26 +0000
Received: from BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:ca:cafe::32) by BN6PR22CA0053.outlook.office365.com
 (2603:10b6:404:ca::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Wed, 18 Aug 2021 11:25:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT027.mail.protection.outlook.com (10.13.177.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 11:25:25 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 11:25:25 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Aug 2021 11:25:23 +0000
From:   Mark Zhang <markzhang@nvidia.com>
To:     <jgg@nvidia.com>, <dledford@redhat.com>, <saeedm@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH rdma-next 05/10] RDMA/mlx5: Add steering support in optional flow counters
Date:   Wed, 18 Aug 2021 14:24:23 +0300
Message-ID: <20210818112428.209111-6-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20210818112428.209111-1-markzhang@nvidia.com>
References: <20210818112428.209111-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61a9e63e-30b5-445d-b07d-08d9623ae03c
X-MS-TrafficTypeDiagnostic: BYAPR12MB3110:
X-Microsoft-Antispam-PRVS: <BYAPR12MB3110F69D69517971BB95777CC7FF9@BYAPR12MB3110.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8M5yZrkMVIH5AVLv9YCB6M3Su+FTOKTbYCBiyyjCGg9ZyojHg0jD87IbNWpRJVsl8ZTkDEVmHAHRcFz0U8FMhSlExWXDW0sgkwQUdheXjo7vDhpphYoA5yOBLL88Npk05AQj6bGtrbTG/N4oylQU4gGKe5L+OBHqxuaXI2AoRju31HoI69oHmSbe6L+qR+ILgsevFW2+0rSayQzd5/Bdn4pMehh8gJw7nSikwZzyH0MkpYvFaG1YD5akqRRPA4x/Suas23XLbyrLudIY30FrfiwSMeqE78u3z+haR5TRZXbzcptTZxn39O5FwSOFvwF71wipa9ezwN+RY+WcDWKVMHrn58zuqRC2etY9SVr1q1mlkNWAeO5jWBm9eJOObs+AYzoBqytKGqkkOk719HteTUlxSZqTG8CsbqSDwfK1zO0v3EkQAPcxtvWigUv/oJ6D56U4Pi20xKc9ANfI+GB8cIo4esNW8KvVCDgmeYaplcg4ms4lsLNImoJHHldZQGxyfIp5i2GrkZqMx9mXplYb0vZeaEgVcFJG1bYDiOo0C4e0/wVPUiFFB1JMn7mF79P12zgjpHFqcr/yXh9dhVeMet1Bg8u/IsN42KsADrGOUuEuO/vIqZuBo2vuGjuZJaoX8CU7Ko1wBxpnUe6qhz7JdS5RqG88ULzrX5nb7M3rd30wFYts/9wY4hSz0+0T1dyRsF7UxIJ5wwpHDOaNwM5WbA==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(396003)(376002)(36840700001)(46966006)(107886003)(82740400003)(86362001)(2906002)(426003)(36756003)(336012)(70206006)(186003)(47076005)(70586007)(83380400001)(82310400003)(26005)(54906003)(2616005)(8936002)(5660300002)(478600001)(316002)(6636002)(8676002)(356005)(7636003)(36860700001)(4326008)(7696005)(110136005)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 11:25:25.7775
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61a9e63e-30b5-445d-b07d-08d9623ae03c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3110
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Adding steering infrastructure for adding and removing optional counter.
This allows to add and remove the counters dynamically in order not to
hurt performance.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 drivers/infiniband/hw/mlx5/fs.c      | 111 +++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  12 +++
 include/rdma/ib_hdrs.h               |   1 +
 3 files changed, 124 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index 5fbc0a8454b9..be6a00969ddb 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -10,12 +10,14 @@
 #include <rdma/uverbs_std_types.h>
 #include <rdma/mlx5_user_ioctl_cmds.h>
 #include <rdma/mlx5_user_ioctl_verbs.h>
+#include <rdma/ib_hdrs.h>
 #include <rdma/ib_umem.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/fs.h>
 #include <linux/mlx5/fs_helpers.h>
 #include <linux/mlx5/accel.h>
 #include <linux/mlx5/eswitch.h>
+#include <net/inet_ecn.h>
 #include "mlx5_ib.h"
 #include "counters.h"
 #include "devx.h"
@@ -847,6 +849,115 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 	return prio;
 }
 
+enum {
+	RDMA_RX_ECN_OPCOUNTER_PRIO,
+	RDMA_RX_CNP_OPCOUNTER_PRIO,
+};
+
+enum {
+	RDMA_TX_CNP_OPCOUNTER_PRIO,
+};
+
+int mlx5_ib_fs_add_op_fc(struct mlx5_ib_dev *dev, struct mlx5_ib_op_fc *opfc,
+			 enum mlx5_ib_optional_counter_type type)
+{
+	enum mlx5_flow_namespace_type fn_type;
+	struct mlx5_flow_act flow_act = {};
+	struct mlx5_flow_destination dst;
+	struct mlx5_flow_namespace *ns;
+	struct mlx5_ib_flow_prio *prio;
+	struct mlx5_flow_spec *spec;
+	int priority, err = 0;
+
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec)
+		return -ENOMEM;
+
+	switch (type) {
+	case MLX5_IB_OPCOUNTER_CC_RX_CE_PKTS:
+		fn_type = MLX5_FLOW_NAMESPACE_RDMA_RX_COUNTERS;
+		priority = RDMA_RX_ECN_OPCOUNTER_PRIO;
+		spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
+		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
+				 outer_headers.ip_ecn);
+		MLX5_SET(fte_match_param, spec->match_value,
+			 outer_headers.ip_ecn, INET_ECN_CE);
+		break;
+
+	case MLX5_IB_OPCOUNTER_CC_RX_CNP_PKTS:
+		if (!MLX5_CAP_FLOWTABLE(dev->mdev,
+					ft_field_support_2_nic_receive_rdma.bth_opcode)) {
+			err = -EOPNOTSUPP;
+			goto free;
+		}
+		fn_type = MLX5_FLOW_NAMESPACE_RDMA_RX_COUNTERS;
+		priority = RDMA_RX_CNP_OPCOUNTER_PRIO;
+		spec->match_criteria_enable = MLX5_MATCH_MISC_PARAMETERS;
+		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
+				 misc_parameters.bth_opcode);
+		MLX5_SET(fte_match_param, spec->match_value,
+			 misc_parameters.bth_opcode, IB_BTH_OPCODE_CNP);
+		break;
+
+	case MLX5_IB_OPCOUNTER_CC_TX_CNP_PKTS:
+		if (!MLX5_CAP_FLOWTABLE(dev->mdev,
+					ft_field_support_2_nic_transmit_rdma.bth_opcode)) {
+			err = -EOPNOTSUPP;
+			goto free;
+		}
+		fn_type = MLX5_FLOW_NAMESPACE_RDMA_TX_COUNTERS;
+		priority = RDMA_TX_CNP_OPCOUNTER_PRIO;
+		spec->match_criteria_enable = MLX5_MATCH_MISC_PARAMETERS;
+		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
+				 misc_parameters.bth_opcode);
+		MLX5_SET(fte_match_param, spec->match_value,
+			 misc_parameters.bth_opcode, IB_BTH_OPCODE_CNP);
+		break;
+
+	default:
+		err = -EOPNOTSUPP;
+		goto free;
+	}
+
+	ns = mlx5_get_flow_namespace(dev->mdev, fn_type);
+	if (!ns) {
+		err = -EOPNOTSUPP;
+		goto free;
+	}
+	prio = _get_prio(ns, &opfc->prio, priority, 1, 1, 0);
+	if (IS_ERR(prio)) {
+		err = PTR_ERR(prio);
+		goto free;
+	}
+
+	dst.type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
+	dst.counter_id = mlx5_fc_id(opfc->fc);
+
+	flow_act.action =
+		MLX5_FLOW_CONTEXT_ACTION_COUNT | MLX5_FLOW_CONTEXT_ACTION_ALLOW;
+
+	opfc->rule =
+		mlx5_add_flow_rules(prio->flow_table, spec, &flow_act, &dst, 1);
+	if (IS_ERR(opfc->rule)) {
+		put_flow_table(dev, prio, false);
+		err = PTR_ERR(opfc->rule);
+		goto free;
+	}
+	prio->refcount++;
+
+free:
+	kfree(spec);
+	return err;
+}
+
+void mlx5_ib_fs_remove_op_fc(struct mlx5_ib_dev *dev,
+			     struct mlx5_ib_op_fc *opfc)
+{
+	mlx5_del_flow_rules(opfc->rule);
+	put_flow_table(dev, &opfc->prio, true);
+	WARN_ON(opfc->prio.flow_table);
+}
+
 static void set_underlay_qp(struct mlx5_ib_dev *dev,
 			    struct mlx5_flow_spec *spec,
 			    u32 underlay_qpn)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 2ba352702294..130b2ed79ba2 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -805,6 +805,12 @@ enum mlx5_ib_optional_counter_type {
 	MLX5_IB_OPCOUNTER_MAX,
 };
 
+struct mlx5_ib_op_fc {
+	struct mlx5_fc *fc;
+	struct mlx5_ib_flow_prio prio;
+	struct mlx5_flow_handle *rule;
+};
+
 struct mlx5_ib_counters {
 	const char **names;
 	size_t *offsets;
@@ -814,6 +820,12 @@ struct mlx5_ib_counters {
 	u16 set_id;
 };
 
+int mlx5_ib_fs_add_op_fc(struct mlx5_ib_dev *dev, struct mlx5_ib_op_fc *opfc,
+			 enum mlx5_ib_optional_counter_type type);
+
+void mlx5_ib_fs_remove_op_fc(struct mlx5_ib_dev *dev,
+			     struct mlx5_ib_op_fc *opfc);
+
 struct mlx5_ib_multiport_info;
 
 struct mlx5_ib_multiport {
diff --git a/include/rdma/ib_hdrs.h b/include/rdma/ib_hdrs.h
index 7e542205861c..8ae07c0ecdf7 100644
--- a/include/rdma/ib_hdrs.h
+++ b/include/rdma/ib_hdrs.h
@@ -232,6 +232,7 @@ static inline u32 ib_get_sqpn(struct ib_other_headers *ohdr)
 #define IB_BTH_SE_SHIFT	23
 #define IB_BTH_TVER_MASK	0xf
 #define IB_BTH_TVER_SHIFT	16
+#define IB_BTH_OPCODE_CNP	0x81
 
 static inline u8 ib_bth_get_pad(struct ib_other_headers *ohdr)
 {
-- 
2.26.2

