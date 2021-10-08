Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A59426AC6
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 14:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242036AbhJHM26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 08:28:58 -0400
Received: from mail-mw2nam10on2075.outbound.protection.outlook.com ([40.107.94.75]:65089
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241740AbhJHM2l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 08:28:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dISF4/g556zWMvUNPyP5Rn316/Ih/+Mhv3MqwYyLodPVb9o/sUVtROVLecmIfE7knSsO8HlO5ANMzkUHuonvUVN3ZcJj1Knodb+/wFsFDSUb3MkyhyHmuOTydvZz2WtnzheoLWZ6l92Qfm2rHBeKpKYrhHwRY9EKcylhQ5xnxzETUG8tnmMbg4eMRb3vNI4SyK31hLIdUP/JOnlH1nfHicPLOuEhSLqnHY9SYOOxm1Ms3hL849HITRWqeAH5UXOCRuPu44nJ6AHSer/Cexzrdhh8pUs/+o8l4dN1hyZibAoWZ5qplPkzxuexv2jEsoqaHDE4ZZrXgveEL1ZkukqJxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QZiHEXyFyddFQS76mKyxB+n7w7kei6ba6k/voWayA2g=;
 b=kbD4/x5g37xRMTIhAE9ZhImoM7jnn4M35gysUndHZjOKkN56LUOjzCKG+g1Ysvhz66q4cpjwrs6+ef/69ViA4V3lHngtHL9lPJoeM1EtmCdyylHd0jgHO4r04KSPqhA5dN8ddUEVQmNY6SnQk0yT+BFAX68LEiQpYJ0sS5TSzc7aeCunjOIaFqWcsDRBMefunu8XJs5aZ2AsZVjJW8h572Bokeq1XWj5J4dc6cWxtYOPMFmqCbv8UDW7HZXUOuJLv2TG6VvUZfOT5XDJVOqCP/VpkK7ucLLnNqCs2yt1Qkv2BHuPDwsLNG/m6VxL66Fb+jkPPMqYAjkRSKBYrHUCLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=chelsio.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QZiHEXyFyddFQS76mKyxB+n7w7kei6ba6k/voWayA2g=;
 b=YkXCNdigF4MWZ9wV6+cx8PF8Y/EHVniKb2Wvf7Jzc13RmDwYZ/39PPNfQpTt82bNryKoT6Pw//0Fvchq5y0B2iqRvwc5r07fd1+ovxqf6psN9qwWqT3qnU5AKl74AvdeuoDrBB/9VPTywQNElQgTHOVkjAponFn8+A8CS8xVXGoOi/znHbBwNzzxioHgw8urKQE7RstqnilSYJxS7i6M0iCLZ+LuVY8OgCT2kFyO0OKM8xPqRma+hi/wyIhW7iDvbHAX119gtf7ktamqOkxM+DycBZJTsL1SiDn6pxBiX7rovwQkqfDYqV90JdZbmIZouEiCWA/jo1wqjZ2haWIB1Q==
Received: from MW4PR03CA0156.namprd03.prod.outlook.com (2603:10b6:303:8d::11)
 by BL1PR12MB5063.namprd12.prod.outlook.com (2603:10b6:208:31a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Fri, 8 Oct
 2021 12:26:43 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::db) by MW4PR03CA0156.outlook.office365.com
 (2603:10b6:303:8d::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19 via Frontend
 Transport; Fri, 8 Oct 2021 12:26:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; chelsio.com; dkim=none (message not signed)
 header.d=none;chelsio.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 12:26:42 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 8 Oct
 2021 05:26:42 -0700
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 8 Oct 2021 05:26:37 -0700
From:   Mark Zhang <markzhang@nvidia.com>
To:     <jgg@nvidia.com>, <dledford@redhat.com>, <saeedm@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        <dennis.dalessandro@cornelisnetworks.com>, <galpress@amazon.com>,
        <kuba@kernel.org>, <maorg@nvidia.com>,
        <mike.marciniszyn@cornelisnetworks.com>,
        <mustafa.ismail@intel.com>, <bharat@chelsio.com>,
        <selvin.xavier@broadcom.com>, <shiraz.saleem@intel.com>,
        <yishaih@nvidia.com>, <zyjzyj2000@gmail.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH rdma-next v4 11/13] RDMA/mlx5: Add steering support in optional flow counters
Date:   Fri, 8 Oct 2021 15:24:37 +0300
Message-ID: <20211008122439.166063-12-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20211008122439.166063-1-markzhang@nvidia.com>
References: <20211008122439.166063-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b31f18e-2937-4766-9ff8-08d98a56e2fa
X-MS-TrafficTypeDiagnostic: BL1PR12MB5063:
X-Microsoft-Antispam-PRVS: <BL1PR12MB506307A93794091A653807D5C7B29@BL1PR12MB5063.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tdNIgIJ0zHI1hGBfcJ1/vBGk38lFVo8Ixq+BoqCn3IaFGuMeXJdIA2omcnSD2r5pMTfySyk/+cICP9156FpKjmlVuBftI+j8jP20JeLAPUjhbnfgna7phixCflW/ApVBWLjsvd7RgZ5IeDUx3m7G1RI8BsXMN3NMRfBKcZRXWI5YVRfwU85R3u0yoxGkmyDcdwgwftUzLWZpi97foxUkNdsqDC3mq17MnI1bDVvA/mgoCdP47cPbA+1eSu9Se+G3S3Q9uGeVHIXi5EiiXcuC0e+T+YDmEPAhUSYBp6ZNteh8FfCcMA/+gQSBkOTWZtB+25UOdoMNT9JjFDSMBT3f6UZqIU++NRo9Cag5MkJNjYlQvAR8o/sRnxyJ3ULosc0po4CUCC/idh+ungHFNhB1SndvmWUrtbC/FHttpblEJSUbADAbEdCiS3M7hM9Xd/AqhzFTZZl2neMk7Wuf6PJIY4VcwVDHXAp/nDW0lQHSYPwg+3DjVsUMG1SaM3kjzOmpdzU7YN8gncYiT+6GGzhme+ApnSy00Ht/4xzWj5TzOvZ0OptgRxJwhIXVFebmZ8b+KcNe+NfhwNp6LdqDiaD+eDhbYA9AGzP2fZ7jyXnUt3+omk02vUEHO3OkDYbF0ePa05KTvpiEUkajUUYg2ydpoCyzRolFmbd7zefoSd1OGHPM9BepQwkt7LwXxzlo68wF02KkbzU/tA6FnIOFTxPUmg==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(316002)(2616005)(82310400003)(5660300002)(1076003)(8676002)(107886003)(356005)(8936002)(4326008)(7636003)(36756003)(47076005)(186003)(83380400001)(36860700001)(7416002)(86362001)(6636002)(336012)(2906002)(508600001)(7696005)(54906003)(110136005)(426003)(70206006)(70586007)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 12:26:42.8379
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b31f18e-2937-4766-9ff8-08d98a56e2fa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5063
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Adding steering infrastructure for adding and removing optional counter.
This allows to add and remove the counters dynamically in order not to
hurt performance.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 drivers/infiniband/hw/mlx5/fs.c      | 187 +++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  24 ++++
 include/rdma/ib_hdrs.h               |   1 +
 3 files changed, 212 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index 5fbc0a8454b9..b780185d9dc6 100644
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
@@ -847,6 +849,191 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
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
+static int set_vhca_port_spec(struct mlx5_ib_dev *dev, u32 port_num,
+			      struct mlx5_flow_spec *spec)
+{
+	if (!MLX5_CAP_FLOWTABLE_RDMA_RX(dev->mdev,
+					ft_field_support.source_vhca_port) ||
+	    !MLX5_CAP_FLOWTABLE_RDMA_TX(dev->mdev,
+					ft_field_support.source_vhca_port))
+		return -EOPNOTSUPP;
+
+	MLX5_SET_TO_ONES(fte_match_param, &spec->match_criteria,
+			 misc_parameters.source_vhca_port);
+	MLX5_SET(fte_match_param, &spec->match_value,
+		 misc_parameters.source_vhca_port, port_num);
+
+	return 0;
+}
+
+static int set_ecn_ce_spec(struct mlx5_ib_dev *dev, u32 port_num,
+			   struct mlx5_flow_spec *spec, int ipv)
+{
+	if (!MLX5_CAP_FLOWTABLE_RDMA_RX(dev->mdev,
+					ft_field_support.outer_ip_version))
+		return -EOPNOTSUPP;
+
+	if (mlx5_core_mp_enabled(dev->mdev) &&
+	    set_vhca_port_spec(dev, port_num, spec))
+		return -EOPNOTSUPP;
+
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
+			 outer_headers.ip_ecn);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ip_ecn,
+		 INET_ECN_CE);
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
+			 outer_headers.ip_version);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ip_version,
+		 ipv);
+
+	spec->match_criteria_enable =
+		get_match_criteria_enable(spec->match_criteria);
+
+	return 0;
+}
+
+static int set_cnp_spec(struct mlx5_ib_dev *dev, u32 port_num,
+			struct mlx5_flow_spec *spec)
+{
+	if (mlx5_core_mp_enabled(dev->mdev) &&
+	    set_vhca_port_spec(dev, port_num, spec))
+		return -EOPNOTSUPP;
+
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
+			 misc_parameters.bth_opcode);
+	MLX5_SET(fte_match_param, spec->match_value, misc_parameters.bth_opcode,
+		 IB_BTH_OPCODE_CNP);
+
+	spec->match_criteria_enable =
+		get_match_criteria_enable(spec->match_criteria);
+
+	return 0;
+}
+
+int mlx5_ib_fs_add_op_fc(struct mlx5_ib_dev *dev, u32 port_num,
+			 struct mlx5_ib_op_fc *opfc,
+			 enum mlx5_ib_optional_counter_type type)
+{
+	enum mlx5_flow_namespace_type fn_type;
+	int priority, i, err, spec_num;
+	struct mlx5_flow_act flow_act = {};
+	struct mlx5_flow_destination dst;
+	struct mlx5_flow_namespace *ns;
+	struct mlx5_ib_flow_prio *prio;
+	struct mlx5_flow_spec *spec;
+
+	spec = kcalloc(MAX_OPFC_RULES, sizeof(*spec), GFP_KERNEL);
+	if (!spec)
+		return -ENOMEM;
+
+	switch (type) {
+	case MLX5_IB_OPCOUNTER_CC_RX_CE_PKTS:
+		if (set_ecn_ce_spec(dev, port_num, &spec[0],
+				    MLX5_FS_IPV4_VERSION) ||
+		    set_ecn_ce_spec(dev, port_num, &spec[1],
+				    MLX5_FS_IPV6_VERSION)) {
+			err = -EOPNOTSUPP;
+			goto free;
+		}
+		spec_num = 2;
+		fn_type = MLX5_FLOW_NAMESPACE_RDMA_RX_COUNTERS;
+		priority = RDMA_RX_ECN_OPCOUNTER_PRIO;
+		break;
+
+	case MLX5_IB_OPCOUNTER_CC_RX_CNP_PKTS:
+		if (!MLX5_CAP_FLOWTABLE(dev->mdev,
+					ft_field_support_2_nic_receive_rdma.bth_opcode) ||
+		    set_cnp_spec(dev, port_num, &spec[0])) {
+			err = -EOPNOTSUPP;
+			goto free;
+		}
+		spec_num = 1;
+		fn_type = MLX5_FLOW_NAMESPACE_RDMA_RX_COUNTERS;
+		priority = RDMA_RX_CNP_OPCOUNTER_PRIO;
+		break;
+
+	case MLX5_IB_OPCOUNTER_CC_TX_CNP_PKTS:
+		if (!MLX5_CAP_FLOWTABLE(dev->mdev,
+					ft_field_support_2_nic_transmit_rdma.bth_opcode) ||
+		    set_cnp_spec(dev, port_num, &spec[0])) {
+			err = -EOPNOTSUPP;
+			goto free;
+		}
+		spec_num = 1;
+		fn_type = MLX5_FLOW_NAMESPACE_RDMA_TX_COUNTERS;
+		priority = RDMA_TX_CNP_OPCOUNTER_PRIO;
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
+
+	prio = &dev->flow_db->opfcs[type];
+	if (!prio->flow_table) {
+		prio = _get_prio(ns, prio, priority,
+				 dev->num_ports * MAX_OPFC_RULES, 1, 0);
+		if (IS_ERR(prio)) {
+			err = PTR_ERR(prio);
+			goto free;
+		}
+	}
+
+	dst.type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
+	dst.counter_id = mlx5_fc_id(opfc->fc);
+
+	flow_act.action =
+		MLX5_FLOW_CONTEXT_ACTION_COUNT | MLX5_FLOW_CONTEXT_ACTION_ALLOW;
+
+	for (i = 0; i < spec_num; i++) {
+		opfc->rule[i] = mlx5_add_flow_rules(prio->flow_table, &spec[i],
+						    &flow_act, &dst, 1);
+		if (IS_ERR(opfc->rule[i])) {
+			err = PTR_ERR(opfc->rule[i]);
+			goto del_rules;
+		}
+	}
+	prio->refcount += spec_num;
+	kfree(spec);
+
+	return 0;
+
+del_rules:
+	for (i -= 1; i >= 0; i--)
+		mlx5_del_flow_rules(opfc->rule[i]);
+	put_flow_table(dev, prio, false);
+free:
+	kfree(spec);
+	return err;
+}
+
+void mlx5_ib_fs_remove_op_fc(struct mlx5_ib_dev *dev,
+			     struct mlx5_ib_op_fc *opfc,
+			     enum mlx5_ib_optional_counter_type type)
+{
+	int i;
+
+	for (i = 0; i < MAX_OPFC_RULES && opfc->rule[i]; i++) {
+		mlx5_del_flow_rules(opfc->rule[i]);
+		put_flow_table(dev, &dev->flow_db->opfcs[type], true);
+	}
+}
+
 static void set_underlay_qp(struct mlx5_ib_dev *dev,
 			    struct mlx5_flow_spec *spec,
 			    u32 underlay_qpn)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 8215d7ab579d..d81ff5078e5e 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -263,6 +263,14 @@ struct mlx5_ib_pp {
 	struct mlx5_core_dev *mdev;
 };
 
+enum mlx5_ib_optional_counter_type {
+	MLX5_IB_OPCOUNTER_CC_RX_CE_PKTS,
+	MLX5_IB_OPCOUNTER_CC_RX_CNP_PKTS,
+	MLX5_IB_OPCOUNTER_CC_TX_CNP_PKTS,
+
+	MLX5_IB_OPCOUNTER_MAX,
+};
+
 struct mlx5_ib_flow_db {
 	struct mlx5_ib_flow_prio	prios[MLX5_IB_NUM_FLOW_FT];
 	struct mlx5_ib_flow_prio	egress_prios[MLX5_IB_NUM_FLOW_FT];
@@ -271,6 +279,7 @@ struct mlx5_ib_flow_db {
 	struct mlx5_ib_flow_prio	fdb;
 	struct mlx5_ib_flow_prio	rdma_rx[MLX5_IB_NUM_FLOW_FT];
 	struct mlx5_ib_flow_prio	rdma_tx[MLX5_IB_NUM_FLOW_FT];
+	struct mlx5_ib_flow_prio	opfcs[MLX5_IB_OPCOUNTER_MAX];
 	struct mlx5_flow_table		*lag_demux_ft;
 	/* Protect flow steering bypass flow tables
 	 * when add/del flow rules.
@@ -797,6 +806,13 @@ struct mlx5_ib_resources {
 	struct mlx5_ib_port_resources ports[2];
 };
 
+#define MAX_OPFC_RULES 2
+
+struct mlx5_ib_op_fc {
+	struct mlx5_fc *fc;
+	struct mlx5_flow_handle *rule[MAX_OPFC_RULES];
+};
+
 struct mlx5_ib_counters {
 	struct rdma_stat_desc *descs;
 	size_t *offsets;
@@ -807,6 +823,14 @@ struct mlx5_ib_counters {
 	u16 set_id;
 };
 
+int mlx5_ib_fs_add_op_fc(struct mlx5_ib_dev *dev, u32 port_num,
+			 struct mlx5_ib_op_fc *opfc,
+			 enum mlx5_ib_optional_counter_type type);
+
+void mlx5_ib_fs_remove_op_fc(struct mlx5_ib_dev *dev,
+			     struct mlx5_ib_op_fc *opfc,
+			     enum mlx5_ib_optional_counter_type type);
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

