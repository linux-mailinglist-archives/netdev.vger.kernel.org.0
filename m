Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2B3426AC4
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 14:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241783AbhJHM2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 08:28:52 -0400
Received: from mail-sn1anam02on2040.outbound.protection.outlook.com ([40.107.96.40]:27809
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241815AbhJHM2p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 08:28:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F70O40m2AJ6I6phKwekeRnqpPPrWmrFBPYlWaF06nRJTwT+yXkNRHfrSFM6qh/uupMXwp9NEPHcxfX8SfxMzvdVSOq2bY5XycFsutGVq2qGgEGoh8DshmhUmis4F3aGv/pJUwMVy3tjHYVnV5eiehMo6+tZfKUwn8MYO9AzLB5PkMMRJiEvjXToGBPCDMgxNsXaRRkPc9atAWjR2IcIpYUz71PYB9AYXh/2FisnLNaGT0RZLbNw2ELhXZqh58W6q4worXskexkDLI88rwwsjPlo3RIWQd7sJR5xepbfoz7R/qldLfXRGkyX+t4Je356atVju3GLeEbgACHdZEJGhsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bFvBgx1x2jxFv68ewEQx8uDbhhJyfNF6dGKK6T+fMds=;
 b=VWQQ5LnXGm3M+HAZ/sYGy91xz+bcXGuEFUeCffzsJGbX/1P6ofI+N8lnFiCS83nDMRqfxsqFbzzjt61SSNSRNpyfc44iWGqgwXi/IL88bQ1Dl9TIkI6HLqEN/ECqoVjq0wG4DRYo8aQzwc3Fs+Hfr67Lf6eiAs9dKe9GN8mERxz5lVqwsEH5dLw89HKtbvvgrsn/TSwA8LqCJwXq3Bw6wdYm0GTyw/70fPsciu+j9ekaoyr+jINvPRaWGtPQBd5YPGz+UFMmFm7jYjWTcohpGGOR5LxDOKooNMv/i9EyO77WT7SlKZ8yshrCAwt5lhO1YPn6dUQ3Cxbw7/NHxjR7wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=chelsio.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bFvBgx1x2jxFv68ewEQx8uDbhhJyfNF6dGKK6T+fMds=;
 b=c7IM3sIHrGiwoYacvsFEiNbKNcETJvaglGU7gaJObdRs16CR8sGrLSPweTSVFSgsbuijBZgC68HJpzx8L8T7USQ3L7HFOm3/J61CKED8VGCoLl/x55ZlHum/R0hyU7DqvYy9WD0iJYQ4Tt7I6EHA1GVb9rAr4CjW1IlYowZUYTAQ/Jncwsm5Q3kpQBnwLYE+PDINTiD2DcNw1EFp8nWnyPITqnjLcpt9Jd2SV8LOxq3OmIF9v6iTWg/uSGi3MLq81N89AFlYv8IBeueQwosFNIpixH6iGSZtIeq7GecsyNCnac8l7DjAijICrFJgUXlRuKlsCwOGPLOPCp/UGtRJNg==
Received: from BN1PR10CA0016.namprd10.prod.outlook.com (2603:10b6:408:e0::21)
 by DM5PR1201MB0041.namprd12.prod.outlook.com (2603:10b6:4:56::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Fri, 8 Oct
 2021 12:26:48 +0000
Received: from BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e0:cafe::1e) by BN1PR10CA0016.outlook.office365.com
 (2603:10b6:408:e0::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend
 Transport; Fri, 8 Oct 2021 12:26:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; chelsio.com; dkim=none (message not signed)
 header.d=none;chelsio.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT062.mail.protection.outlook.com (10.13.177.34) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 12:26:48 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 8 Oct
 2021 12:26:47 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 8 Oct 2021 05:26:42 -0700
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
        "Mark Zhang" <markzhang@nvidia.com>
Subject: [PATCH rdma-next v4 12/13] RDMA/mlx5: Add modify_op_stat() support
Date:   Fri, 8 Oct 2021 15:24:38 +0300
Message-ID: <20211008122439.166063-13-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20211008122439.166063-1-markzhang@nvidia.com>
References: <20211008122439.166063-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92da45b2-3f0d-45af-3a9a-08d98a56e61e
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0041:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0041D07968CC1C2CE1934BFEC7B29@DM5PR1201MB0041.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6fiNO3F5TRVjKVZCJwb497X83QuHHpSmLl2GeYfbwBi9xnsOAn1oulLJTbWCd2OxJcWwRsBUytCH9xj5FFAYou/bHPFbRHSwV9CSQRyjk9rTMDpju9sap2I0SuFeO5odWwKlOxj77MRPUtRt/xGt9toMP6jwQ1hx2+rlJ1Jg87ehwm5X0A2nszYd2RdmG9BRIaRZm9YQeTjqqc1mrTr2D5cdzb3SwooRla2ymXYSjPzz/FxuMTyC7QgaDF4x11ZtG4NB+Ri58XLb8BcIXKeds9Ls3CGDVrNRWiW237jol/cgR+67m8uGnMAHfGjGCd1yhLLzeemw77WplEq1fL2kNqPg2yjEcj7lEtWPOEtnYZ3pVbNCWbmC4ZIkB2psEV6D+C9rAtu1MVa8LRsVfGD5mvMLw2w63GrvKhvNTMIr8iwCxwXh0XpPRN6LeeLBK6LdKjwY+emf+d5ZEB9SYX4ebqf7URDfZ/FRZTIru88ch1kHw/sJlp07W3DGp3P/9YTcDvRiZm1nCk5C3yatX3NT+KjPN+4R0goCPnBXz2MJfuh8juvht5+UNO67y6r59q7U7Ixp2QkDhV/SUux+XlgidcCk8FHL3LP9Nyf4NBQfoYsvyyvloFcRZtLqG8z8qdKG2h8EqG8jJ2yTc1ZRdSnaTUyvCM7fRtIW+Ib9ownv4LXaPq+X7pupQrgzZ3ZT2+dMBj+fwgf/WopgsgqKj+LqtA==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(70586007)(36860700001)(107886003)(7696005)(70206006)(4326008)(6636002)(316002)(86362001)(36756003)(5660300002)(356005)(426003)(8676002)(83380400001)(2616005)(7636003)(1076003)(6666004)(54906003)(186003)(508600001)(47076005)(8936002)(2906002)(7416002)(336012)(82310400003)(110136005)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 12:26:48.0538
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92da45b2-3f0d-45af-3a9a-08d98a56e61e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0041
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Add support for ib callback modify_op_stat() to add or remove an
optional counter. When adding, a steering flow table is created
with a rule that catches and counts all the matching packets;
When removing, the table and flow counter are destroyed.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 drivers/infiniband/hw/mlx5/counters.c | 79 +++++++++++++++++++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h  |  1 +
 include/rdma/ib_verbs.h               |  2 +
 3 files changed, 76 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index 8fe7900b29f0..6ee340c63b20 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -12,6 +12,7 @@
 struct mlx5_ib_counter {
 	const char *name;
 	size_t offset;
+	u32 type;
 };
 
 #define INIT_Q_COUNTER(_name)		\
@@ -75,19 +76,19 @@ static const struct mlx5_ib_counter ext_ppcnt_cnts[] = {
 	INIT_EXT_PPCNT_COUNTER(rx_icrc_encapsulated),
 };
 
-#define INIT_OP_COUNTER(_name)                                          \
-	{ .name = #_name }
+#define INIT_OP_COUNTER(_name, _type)		\
+	{ .name = #_name, .type = MLX5_IB_OPCOUNTER_##_type}
 
 static const struct mlx5_ib_counter basic_op_cnts[] = {
-	INIT_OP_COUNTER(cc_rx_ce_pkts),
+	INIT_OP_COUNTER(cc_rx_ce_pkts, CC_RX_CE_PKTS),
 };
 
 static const struct mlx5_ib_counter rdmarx_cnp_op_cnts[] = {
-	INIT_OP_COUNTER(cc_rx_cnp_pkts),
+	INIT_OP_COUNTER(cc_rx_cnp_pkts, CC_RX_CNP_PKTS),
 };
 
 static const struct mlx5_ib_counter rdmatx_cnp_op_cnts[] = {
-	INIT_OP_COUNTER(cc_tx_cnp_pkts),
+	INIT_OP_COUNTER(cc_tx_cnp_pkts, CC_TX_CNP_PKTS),
 };
 
 static int mlx5_ib_read_counters(struct ib_counters *counters,
@@ -451,6 +452,7 @@ static void mlx5_ib_fill_counters(struct mlx5_ib_dev *dev,
 	for (i = 0; i < ARRAY_SIZE(basic_op_cnts); i++, j++) {
 		descs[j].name = basic_op_cnts[i].name;
 		descs[j].flags |= IB_STAT_FLAG_OPTIONAL;
+		descs[j].priv = &basic_op_cnts[i].type;
 	}
 
 	if (MLX5_CAP_FLOWTABLE(dev->mdev,
@@ -458,6 +460,7 @@ static void mlx5_ib_fill_counters(struct mlx5_ib_dev *dev,
 		for (i = 0; i < ARRAY_SIZE(rdmarx_cnp_op_cnts); i++, j++) {
 			descs[j].name = rdmarx_cnp_op_cnts[i].name;
 			descs[j].flags |= IB_STAT_FLAG_OPTIONAL;
+			descs[j].priv = &rdmarx_cnp_op_cnts[i].type;
 		}
 	}
 
@@ -466,6 +469,7 @@ static void mlx5_ib_fill_counters(struct mlx5_ib_dev *dev,
 		for (i = 0; i < ARRAY_SIZE(rdmatx_cnp_op_cnts); i++, j++) {
 			descs[j].name = rdmatx_cnp_op_cnts[i].name;
 			descs[j].flags |= IB_STAT_FLAG_OPTIONAL;
+			descs[j].priv = &rdmatx_cnp_op_cnts[i].type;
 		}
 	}
 }
@@ -535,7 +539,7 @@ static void mlx5_ib_dealloc_counters(struct mlx5_ib_dev *dev)
 {
 	u32 in[MLX5_ST_SZ_DW(dealloc_q_counter_in)] = {};
 	int num_cnt_ports;
-	int i;
+	int i, j;
 
 	num_cnt_ports = is_mdev_switchdev_mode(dev->mdev) ? 1 : dev->num_ports;
 
@@ -550,6 +554,18 @@ static void mlx5_ib_dealloc_counters(struct mlx5_ib_dev *dev)
 		}
 		kfree(dev->port[i].cnts.descs);
 		kfree(dev->port[i].cnts.offsets);
+
+		for (j = 0; j < MLX5_IB_OPCOUNTER_MAX; j++) {
+			if (!dev->port[i].cnts.opfcs[j].fc)
+				continue;
+
+			mlx5_ib_fs_remove_op_fc(dev,
+						&dev->port[i].cnts.opfcs[j],
+						j);
+			mlx5_fc_destroy(dev->mdev,
+					dev->port[i].cnts.opfcs[j].fc);
+			dev->port[i].cnts.opfcs[j].fc = NULL;
+		}
 	}
 }
 
@@ -729,6 +745,56 @@ void mlx5_ib_counters_clear_description(struct ib_counters *counters)
 	mutex_unlock(&mcounters->mcntrs_mutex);
 }
 
+static int mlx5_ib_modify_stat(struct ib_device *device, u32 port,
+			       unsigned int index, bool enable)
+{
+	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_counters *cnts;
+	struct mlx5_ib_op_fc *opfc;
+	u32 num_hw_counters, type;
+	int ret;
+
+	cnts = &dev->port[port - 1].cnts;
+	num_hw_counters = cnts->num_q_counters + cnts->num_cong_counters +
+		cnts->num_ext_ppcnt_counters;
+	if (index < num_hw_counters ||
+	    index >= (num_hw_counters + cnts->num_op_counters))
+		return -EINVAL;
+
+	if (!(cnts->descs[index].flags & IB_STAT_FLAG_OPTIONAL))
+		return -EINVAL;
+
+	type = *(u32 *)cnts->descs[index].priv;
+	if (type >= MLX5_IB_OPCOUNTER_MAX)
+		return -EINVAL;
+
+	opfc = &cnts->opfcs[type];
+
+	if (enable) {
+		if (opfc->fc)
+			return -EEXIST;
+
+		opfc->fc = mlx5_fc_create(dev->mdev, false);
+		if (IS_ERR(opfc->fc))
+			return PTR_ERR(opfc->fc);
+
+		ret = mlx5_ib_fs_add_op_fc(dev, port, opfc, type);
+		if (ret) {
+			mlx5_fc_destroy(dev->mdev, opfc->fc);
+			opfc->fc = NULL;
+		}
+		return ret;
+	}
+
+	if (!opfc->fc)
+		return -EINVAL;
+
+	mlx5_ib_fs_remove_op_fc(dev, opfc, type);
+	mlx5_fc_destroy(dev->mdev, opfc->fc);
+	opfc->fc = NULL;
+	return 0;
+}
+
 static const struct ib_device_ops hw_stats_ops = {
 	.alloc_hw_port_stats = mlx5_ib_alloc_hw_port_stats,
 	.get_hw_stats = mlx5_ib_get_hw_stats,
@@ -737,6 +803,7 @@ static const struct ib_device_ops hw_stats_ops = {
 	.counter_dealloc = mlx5_ib_counter_dealloc,
 	.counter_alloc_stats = mlx5_ib_counter_alloc_stats,
 	.counter_update_stats = mlx5_ib_counter_update_stats,
+	.modify_hw_stat = mlx5_ib_modify_stat,
 };
 
 static const struct ib_device_ops hw_switchdev_stats_ops = {
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index d81ff5078e5e..cf8b0653f0ce 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -821,6 +821,7 @@ struct mlx5_ib_counters {
 	u32 num_ext_ppcnt_counters;
 	u32 num_op_counters;
 	u16 set_id;
+	struct mlx5_ib_op_fc opfcs[MLX5_IB_OPCOUNTER_MAX];
 };
 
 int mlx5_ib_fs_add_op_fc(struct mlx5_ib_dev *dev, u32 port_num,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 2207f60b002f..7688720411a3 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -553,10 +553,12 @@ enum ib_stat_flag {
  * struct rdma_stat_desc
  * @name - The name of the counter
  * @flags - Flags of the counter; For example, IB_STAT_FLAG_OPTIONAL
+ * @priv - Driver private information; Core code should not use
  */
 struct rdma_stat_desc {
 	const char *name;
 	unsigned int flags;
+	const void *priv;
 };
 
 /**
-- 
2.26.2

