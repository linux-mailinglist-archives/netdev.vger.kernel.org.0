Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA42E426AC2
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 14:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241835AbhJHM2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 08:28:45 -0400
Received: from mail-bn8nam11on2085.outbound.protection.outlook.com ([40.107.236.85]:39486
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241539AbhJHM2f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 08:28:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K65rhHJRzR30OJ8U6TuhoFknFq/B+Uj3FXBVQMtwISfdD3jk7LvpQmITVdO1X3A7Hnh+ZB0YSZjvQrPMh5i2Sc3K9UK03eG2GuV0M6iARaObEFIht9zDZj+bfBrKCAQCw8U/dZ0rJrMFU1Wf2s9jGzeOSUKqjr4rIS4kBI8S6VKu27Hd1bnamqyVGTXZIaJP/HKKeQub+8DD5nOWPa9+2xAC7/vuB7yFoNbv7/cnMtCpgPKH7dxcX7EcA57vXnkqJjo9uZ53bDIEo7d9GTXNzd90mBEFMq2m9AsTsEyhc57p2TniGXFT/fHnaNN/O/5WaUquPi2H1uVVZQE4Qi/2Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GURo1LgNFr3uEafZnrXT87Qdbqt9coqgY1D9N+uzT7w=;
 b=k++I03qs7AwfBcd+58IyjRiphEKeZE2lI7AI+nE4wRewHb/SdWffFG84tnvQtYmHsUyFoLqS2SuF5+pUitEybDq0dcbW/EkEQQ1qMbVszpYT9d+gYz1bfPQO8Nj5blIqCuPtLKM0aLVokrR/m/GWM1VZ9mYOtRuYI9o2BidvA0YxgugTUY3Q1tWvKc/QtgZ0mYhtPPxzr4FoAVypAvMYus88jQGeHsEhEi5snLRBf3BgyIn/pVw7atPzFEdkLDMKVsQcr9vftN31clqoSEabvoIllSkYgW4MXFAMY7T+KPpr+rceFjbO0cR4iJ3tpp0DGZPg1y/VjUsqaS9mLxO5lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GURo1LgNFr3uEafZnrXT87Qdbqt9coqgY1D9N+uzT7w=;
 b=emIUyo0GfbYN/cbwy7qTzEv1mhgl9Lj7A7LuwGXSdub+gWGjWeGczAUFod5CdCxICcu96b5Xbkjpnuusc7R1iZAa1qbPAqn6Cmn6q1ZYbQsuRoTraWce75hoYwlTE06LjdtvIybmDoAd6g38fXRHqmgng23J0qg3Gri94JAIx+MgvGkF3MphLMnA6xSgmv2rOGZRqTvcQqI4x5AROMQkeC6SZzGQCgqpfzsNCcS3fXbx/O2S/dNGuWqj6gbxAzdoSYgeltEt8RKyonxaZ2ROGghydDcX4KE8zVP3H4Vq+LIcLXqhAu95J6F6ttUGh9EuL5vXTlIQ97q45TvXSQmoGw==
Received: from MWHPR22CA0009.namprd22.prod.outlook.com (2603:10b6:300:ef::19)
 by CH2PR12MB4907.namprd12.prod.outlook.com (2603:10b6:610:68::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Fri, 8 Oct
 2021 12:26:38 +0000
Received: from CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ef:cafe::b7) by MWHPR22CA0009.outlook.office365.com
 (2603:10b6:300:ef::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend
 Transport; Fri, 8 Oct 2021 12:26:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT065.mail.protection.outlook.com (10.13.174.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 12:26:38 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 8 Oct
 2021 05:26:37 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 8 Oct
 2021 12:26:37 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 8 Oct 2021 05:26:33 -0700
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
Subject: [PATCH rdma-next v4 10/13] RDMA/mlx5: Support optional counters in hw_stats initialization
Date:   Fri, 8 Oct 2021 15:24:36 +0300
Message-ID: <20211008122439.166063-11-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20211008122439.166063-1-markzhang@nvidia.com>
References: <20211008122439.166063-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a52add01-eba8-478a-103c-08d98a56e028
X-MS-TrafficTypeDiagnostic: CH2PR12MB4907:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4907886A03EE25FF3EF8D22DC7B29@CH2PR12MB4907.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uGaUFMRBFWCFoZSSIxPm9QzmCsNuNErga569CATLDT6+oB7dbEBTkpzn8EItt7SuW3uIc8MqQrHQXH7S/90e5SNT1C0NHHFcKpx+Q1YcGxlYmTYb6C+WBgZQZVHMAzij2gqAxA4StSoPlzZ9XMMeNcWhWFnj/PeR7uaGq6AGEt8m6WO8pHv90hpWFReJLrUI5TWB1AoyX/qPt996eRrPFFzWuVfhP2+t7L8LMY0M9rLk/DoDepzOLkN6e9QBHSpkrlDyBjL9iG8gI+jcyOhx11Cdh7rJjl4GgUFttpFUOmRhqjHhOYpfD/k1Ql1QQ+pD/qZrO31+sG69ycrejXu0BGTQeWmIbnLSHdBEkHAGt9iKAGPinaUAIpbxlWpMw+HmNTw3s8L7uFWpFjLkU99a38rlXLTrAYg3aY4FoMKDripkEyndom4Dkcpqs3dyyyc/AnvcFkXmJHhF9XEcDVZBBvRAXqmDx/rb+u31mBWLusSsjiJ56mnGCP77Hcg2heW69pps8KQsN6WK9Vh9Q0mZeqyqAOM5NnBEkb/DjTWsqo/vfzQzZ5xDFZR3PIpjf1C8E9lHtJmvAf3H4TWdIwIfVZgTiC43nahhAf/8a34jAFfJpHwZ7lVAGR2LsmEgzN6P4dggXTHTlr/QNXKLnxehvfOoMRfLiMIt1YOatG6Tos7iQQuwPcaKAe4QO+1Jj56Aoca2gXXgQEiubUu+oh9HeQ==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(8676002)(86362001)(47076005)(1076003)(426003)(82310400003)(36860700001)(54906003)(316002)(508600001)(83380400001)(110136005)(6636002)(186003)(4326008)(356005)(2906002)(2616005)(70206006)(7636003)(7696005)(26005)(5660300002)(336012)(70586007)(7416002)(36756003)(107886003)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 12:26:38.1108
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a52add01-eba8-478a-103c-08d98a56e028
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4907
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Add optional counter support when allocate and initialize hw_stats
structure. Optional counters have IB_STAT_FLAG_OPTIONAL flag set
and are disabled by default.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 drivers/infiniband/hw/mlx5/counters.c | 90 ++++++++++++++++++++++-----
 drivers/infiniband/hw/mlx5/mlx5_ib.h  |  1 +
 2 files changed, 75 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index caa35ea14b48..8fe7900b29f0 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -75,6 +75,21 @@ static const struct mlx5_ib_counter ext_ppcnt_cnts[] = {
 	INIT_EXT_PPCNT_COUNTER(rx_icrc_encapsulated),
 };
 
+#define INIT_OP_COUNTER(_name)                                          \
+	{ .name = #_name }
+
+static const struct mlx5_ib_counter basic_op_cnts[] = {
+	INIT_OP_COUNTER(cc_rx_ce_pkts),
+};
+
+static const struct mlx5_ib_counter rdmarx_cnp_op_cnts[] = {
+	INIT_OP_COUNTER(cc_rx_cnp_pkts),
+};
+
+static const struct mlx5_ib_counter rdmatx_cnp_op_cnts[] = {
+	INIT_OP_COUNTER(cc_tx_cnp_pkts),
+};
+
 static int mlx5_ib_read_counters(struct ib_counters *counters,
 				 struct ib_counters_read_attr *read_attr,
 				 struct uverbs_attr_bundle *attrs)
@@ -161,17 +176,34 @@ u16 mlx5_ib_get_counters_id(struct mlx5_ib_dev *dev, u32 port_num)
 	return cnts->set_id;
 }
 
+static struct rdma_hw_stats *do_alloc_stats(const struct mlx5_ib_counters *cnts)
+{
+	struct rdma_hw_stats *stats;
+	u32 num_hw_counters;
+	int i;
+
+	num_hw_counters = cnts->num_q_counters + cnts->num_cong_counters +
+			  cnts->num_ext_ppcnt_counters;
+	stats = rdma_alloc_hw_stats_struct(cnts->descs,
+					   num_hw_counters +
+					   cnts->num_op_counters,
+					   RDMA_HW_STATS_DEFAULT_LIFESPAN);
+	if (!stats)
+		return NULL;
+
+	for (i = 0; i < cnts->num_op_counters; i++)
+		set_bit(num_hw_counters + i, stats->is_disabled);
+
+	return stats;
+}
+
 static struct rdma_hw_stats *
 mlx5_ib_alloc_hw_device_stats(struct ib_device *ibdev)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	const struct mlx5_ib_counters *cnts = &dev->port[0].cnts;
 
-	return rdma_alloc_hw_stats_struct(cnts->descs,
-					  cnts->num_q_counters +
-						  cnts->num_cong_counters +
-						  cnts->num_ext_ppcnt_counters,
-					  RDMA_HW_STATS_DEFAULT_LIFESPAN);
+	return do_alloc_stats(cnts);
 }
 
 static struct rdma_hw_stats *
@@ -180,11 +212,7 @@ mlx5_ib_alloc_hw_port_stats(struct ib_device *ibdev, u32 port_num)
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	const struct mlx5_ib_counters *cnts = &dev->port[port_num - 1].cnts;
 
-	return rdma_alloc_hw_stats_struct(cnts->descs,
-					  cnts->num_q_counters +
-						  cnts->num_cong_counters +
-						  cnts->num_ext_ppcnt_counters,
-					  RDMA_HW_STATS_DEFAULT_LIFESPAN);
+	return do_alloc_stats(cnts);
 }
 
 static int mlx5_ib_query_q_counters(struct mlx5_core_dev *mdev,
@@ -302,11 +330,7 @@ mlx5_ib_counter_alloc_stats(struct rdma_counter *counter)
 	const struct mlx5_ib_counters *cnts =
 		get_counters(dev, counter->port - 1);
 
-	return rdma_alloc_hw_stats_struct(cnts->descs,
-					  cnts->num_q_counters +
-					  cnts->num_cong_counters +
-					  cnts->num_ext_ppcnt_counters,
-					  RDMA_HW_STATS_DEFAULT_LIFESPAN);
+	return do_alloc_stats(cnts);
 }
 
 static int mlx5_ib_counter_update_stats(struct rdma_counter *counter)
@@ -423,13 +447,34 @@ static void mlx5_ib_fill_counters(struct mlx5_ib_dev *dev,
 			offsets[j] = ext_ppcnt_cnts[i].offset;
 		}
 	}
+
+	for (i = 0; i < ARRAY_SIZE(basic_op_cnts); i++, j++) {
+		descs[j].name = basic_op_cnts[i].name;
+		descs[j].flags |= IB_STAT_FLAG_OPTIONAL;
+	}
+
+	if (MLX5_CAP_FLOWTABLE(dev->mdev,
+			       ft_field_support_2_nic_receive_rdma.bth_opcode)) {
+		for (i = 0; i < ARRAY_SIZE(rdmarx_cnp_op_cnts); i++, j++) {
+			descs[j].name = rdmarx_cnp_op_cnts[i].name;
+			descs[j].flags |= IB_STAT_FLAG_OPTIONAL;
+		}
+	}
+
+	if (MLX5_CAP_FLOWTABLE(dev->mdev,
+			       ft_field_support_2_nic_transmit_rdma.bth_opcode)) {
+		for (i = 0; i < ARRAY_SIZE(rdmatx_cnp_op_cnts); i++, j++) {
+			descs[j].name = rdmatx_cnp_op_cnts[i].name;
+			descs[j].flags |= IB_STAT_FLAG_OPTIONAL;
+		}
+	}
 }
 
 
 static int __mlx5_ib_alloc_counters(struct mlx5_ib_dev *dev,
 				    struct mlx5_ib_counters *cnts)
 {
-	u32 num_counters;
+	u32 num_counters, num_op_counters;
 
 	num_counters = ARRAY_SIZE(basic_q_cnts);
 
@@ -455,6 +500,19 @@ static int __mlx5_ib_alloc_counters(struct mlx5_ib_dev *dev,
 		cnts->num_ext_ppcnt_counters = ARRAY_SIZE(ext_ppcnt_cnts);
 		num_counters += ARRAY_SIZE(ext_ppcnt_cnts);
 	}
+
+	num_op_counters = ARRAY_SIZE(basic_op_cnts);
+
+	if (MLX5_CAP_FLOWTABLE(dev->mdev,
+			       ft_field_support_2_nic_receive_rdma.bth_opcode))
+		num_op_counters += ARRAY_SIZE(rdmarx_cnp_op_cnts);
+
+	if (MLX5_CAP_FLOWTABLE(dev->mdev,
+			       ft_field_support_2_nic_transmit_rdma.bth_opcode))
+		num_op_counters += ARRAY_SIZE(rdmatx_cnp_op_cnts);
+
+	cnts->num_op_counters = num_op_counters;
+	num_counters += num_op_counters;
 	cnts->descs = kcalloc(num_counters,
 			      sizeof(struct rdma_stat_desc), GFP_KERNEL);
 	if (!cnts->descs)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 6f5451d96dd7..8215d7ab579d 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -803,6 +803,7 @@ struct mlx5_ib_counters {
 	u32 num_q_counters;
 	u32 num_cong_counters;
 	u32 num_ext_ppcnt_counters;
+	u32 num_op_counters;
 	u16 set_id;
 };
 
-- 
2.26.2

