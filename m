Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98512426AC8
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 14:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242006AbhJHM3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 08:29:17 -0400
Received: from mail-dm6nam12on2075.outbound.protection.outlook.com ([40.107.243.75]:47488
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242005AbhJHM2u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 08:28:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BxI2JyCeE57ntCTjb9XTGl/rKnLgCpdI2I64j/LbmzqdAmQE+Ntrd+zeNEWUtxu3Ly66dP6ZOo8J1dCShKVdwwFoTbOI9WbOA+Gg26GT8SRFVu3rT3F/t9I6ERTJwKXu3IeP9vMMn+Cl9MZ5MpfRNZLlTJ6CtBth0j5DXi0vBHS+atJ+QoqRwgAEtTbgrTKWETS1Uv2faHstN8y3WqmhlN8pVwPVNgA8UoSKu/4j0/8IyP51nw0oSncqOJc+99f3zl1kb0qRiXasdh+w4t63DwpqHOem8ae+LKFI+W1ZjY5UND1rFayn5JRB25zWrsdX3Sl4HW68FwnjBugR2eulxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W3rPJQHfvyOG47C86ZWTy/4sGzJkUYPvDjb7YjmoTEU=;
 b=jP90pLz7dmTtkk8YoI4uxE/fzmD1PgXKD5mMwDH6Cf37E7YCdeb35PGQkx14VNQohjOxKGSbaJj1wQofJKpGfoPZMOKWp7ZvbmlYoAeD5UQNdnEAGYNyhub/ZYL8cxpFCkSWMv88d1u84p6aELq7UqP6+qHyq15HHnXsgwS3gizeDbhQPsZ958rLwYKhqwxnwnW+yBX6Dj7GveCeSHpEDvrZCIZX0xQxUXBOsN82Wjgt62UIzWc8NnsnwgZSDKRL8n8rs+/nyd/m8CnwLVNrR0FDToP75LGcF8pFvvYsXcDTW0icTonz1fATqFEriJEkz4nJS8F4RsSTCHzgAjA+tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=chelsio.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3rPJQHfvyOG47C86ZWTy/4sGzJkUYPvDjb7YjmoTEU=;
 b=gX8E2VhQOxkiolUiQdDZntGV+wvFMaqs8v7DLZdTQWHXDAW4cc32nqEgOsJ3HXxYA4E1WCbDzrKqa0Lwj/Tdrpq+j08V3k/jei+LVPG+lijIOyPc18EARvP/fhbJxHSEfjyXLgNn12YAuQ9oxHRi14PNQ4t5M9YW/yuZdbjJfFOVXcwnsNQKBH/Jp+9/lc1ERy2GuqD6hXt9EgKKJc7iRrHHadZsF1fjjBGB8ltScl16+QVjb8Brf8kZLAihuo/szDp7IxgAPO8OcR7OB2b8u967nO53q0bxlOSs8D1WdUQ6UhXmNTJQcIOI+4mWOqRWX1B4EuChtT9TwiosEaFqLg==
Received: from BN9PR03CA0179.namprd03.prod.outlook.com (2603:10b6:408:f4::34)
 by CH2PR12MB3734.namprd12.prod.outlook.com (2603:10b6:610:2a::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20; Fri, 8 Oct
 2021 12:26:53 +0000
Received: from BN8NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f4:cafe::33) by BN9PR03CA0179.outlook.office365.com
 (2603:10b6:408:f4::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend
 Transport; Fri, 8 Oct 2021 12:26:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; chelsio.com; dkim=none (message not signed)
 header.d=none;chelsio.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT067.mail.protection.outlook.com (10.13.177.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 12:26:52 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 8 Oct
 2021 12:26:51 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 8 Oct 2021 05:26:47 -0700
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
Subject: [PATCH rdma-next v4 13/13] RDMA/mlx5: Add optional counter support in get_hw_stats callback
Date:   Fri, 8 Oct 2021 15:24:39 +0300
Message-ID: <20211008122439.166063-14-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20211008122439.166063-1-markzhang@nvidia.com>
References: <20211008122439.166063-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98b34a54-bb2d-466f-0fb8-08d98a56e8bc
X-MS-TrafficTypeDiagnostic: CH2PR12MB3734:
X-Microsoft-Antispam-PRVS: <CH2PR12MB37341C40AEA32970E753CE83C7B29@CH2PR12MB3734.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mf4GAo1VyCj4t3AS68jM6ypPLZ6LPwQRZ+RNzwaXWLmoqSY5Y/mcDe8ZldqmL7eDR6+k4am9/PC/ZL3eVZTLuM3IB/KAxrEdbos+eVAT3obTv1FHIR7yfxGp4LyzI2Iwzn0dS4xqw6LsEWUAvO4dqw4zkPyOQ9fNcWlFDFwOKKWf/YkNeWxnxt8O2pDKVcgZwTVf1mzDYBGf1baX0gFLkKIw3plgyFs9n7dpKCeIHGTaGdYnvHWLXBWC8JY7tPoL4gfNllC2I4+tOGAzxgDSn9NjFipZFl8uie+9hhmVadcz5XbGoNqTu9EHD5eJ7QO5YCRdbQkO9cErvLXnJWSWyqqtvE70/SqoafuGwwVcQ37dUCN0mYf5M92hRv668y6gDqNqcY39opGC0bCymlbYZ7f82agzrE482CU+U9cMYccS358AqPUJbhfHi7v84yUXjE0/XyYI7kmJOHit8Ddu7n9wMIoKeU3x1GsN3oNl/DfeXWJr4U9qZZpFrVnG/Njr+Viwqd1Qui0Ck9t2multrWzT5CHBNuvaV8kyDKzlYlVON+P34ZvYt7wtiHg+tUlaaUupsra3J/1vKXVXBszKMgnGE2nLp9khjJops67siM+Rg9loOz4G+xNZqYuZUzhmLXDhs5Dy1T7TO5bpb3VZiE9nfflkmM4iQOJI+UMs6jbnCNEefsK5i91cS03rq0Ruo3pM30/sMH1NKHJur1biOg==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(36860700001)(508600001)(356005)(47076005)(5660300002)(2906002)(1076003)(70206006)(70586007)(7636003)(8936002)(316002)(4326008)(110136005)(7416002)(82310400003)(6636002)(83380400001)(6666004)(336012)(426003)(186003)(54906003)(36756003)(107886003)(8676002)(26005)(2616005)(7696005)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 12:26:52.4506
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98b34a54-bb2d-466f-0fb8-08d98a56e8bc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3734
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

When get_hw_stats is called, query and return the optional counter
statistic as well.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 drivers/infiniband/hw/mlx5/counters.c | 88 ++++++++++++++++++++++++++-
 1 file changed, 85 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index 6ee340c63b20..6f1c4b57110e 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -270,9 +270,9 @@ static int mlx5_ib_query_ext_ppcnt_counters(struct mlx5_ib_dev *dev,
 	return ret;
 }
 
-static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
-				struct rdma_hw_stats *stats,
-				u32 port_num, int index)
+static int do_get_hw_stats(struct ib_device *ibdev,
+			   struct rdma_hw_stats *stats,
+			   u32 port_num, int index)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	const struct mlx5_ib_counters *cnts = get_counters(dev, port_num - 1);
@@ -324,6 +324,88 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 	return num_counters;
 }
 
+static int do_get_op_stat(struct ib_device *ibdev,
+			  struct rdma_hw_stats *stats,
+			  u32 port_num, int index)
+{
+	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	const struct mlx5_ib_counters *cnts;
+	const struct mlx5_ib_op_fc *opfcs;
+	u64 packets = 0, bytes;
+	u32 type;
+	int ret;
+
+	cnts = get_counters(dev, port_num - 1);
+	opfcs = cnts->opfcs;
+	type = *(u32 *)cnts->descs[index].priv;
+	if (type >= MLX5_IB_OPCOUNTER_MAX)
+		return -EINVAL;
+
+	if (!opfcs[type].fc)
+		goto out;
+
+	ret = mlx5_fc_query(dev->mdev, opfcs[type].fc,
+			    &packets, &bytes);
+	if (ret)
+		return ret;
+
+out:
+	stats->value[index] = packets;
+	return index;
+}
+
+static int do_get_op_stats(struct ib_device *ibdev,
+			   struct rdma_hw_stats *stats,
+			   u32 port_num)
+{
+	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	const struct mlx5_ib_counters *cnts;
+	int index, ret, num_hw_counters;
+
+	cnts = get_counters(dev, port_num - 1);
+	num_hw_counters = cnts->num_q_counters + cnts->num_cong_counters +
+			  cnts->num_ext_ppcnt_counters;
+	for (index = num_hw_counters;
+	     index < (num_hw_counters + cnts->num_op_counters); index++) {
+		ret = do_get_op_stat(ibdev, stats, port_num, index);
+		if (ret != index)
+			return ret;
+	}
+
+	return cnts->num_op_counters;
+}
+
+static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
+				struct rdma_hw_stats *stats,
+				u32 port_num, int index)
+{
+	int num_counters, num_hw_counters, num_op_counters;
+	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	const struct mlx5_ib_counters *cnts;
+
+	cnts = get_counters(dev, port_num - 1);
+	num_hw_counters = cnts->num_q_counters + cnts->num_cong_counters +
+		cnts->num_ext_ppcnt_counters;
+	num_counters = num_hw_counters + cnts->num_op_counters;
+
+	if (index < 0 || index > num_counters)
+		return -EINVAL;
+	else if (index > 0 && index < num_hw_counters)
+		return do_get_hw_stats(ibdev, stats, port_num, index);
+	else if (index >= num_hw_counters && index < num_counters)
+		return do_get_op_stat(ibdev, stats, port_num, index);
+
+	num_hw_counters = do_get_hw_stats(ibdev, stats, port_num, index);
+	if (num_hw_counters < 0)
+		return num_hw_counters;
+
+	num_op_counters = do_get_op_stats(ibdev, stats, port_num);
+	if (num_op_counters < 0)
+		return num_op_counters;
+
+	return num_hw_counters + num_op_counters;
+}
+
 static struct rdma_hw_stats *
 mlx5_ib_counter_alloc_stats(struct rdma_counter *counter)
 {
-- 
2.26.2

