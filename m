Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2613F02A5
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 13:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235842AbhHRL0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 07:26:21 -0400
Received: from mail-dm6nam12on2070.outbound.protection.outlook.com ([40.107.243.70]:14433
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235793AbhHRL0N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 07:26:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oDTNZDtdW9ADol7OPPD/AyCBuqoaoYe8I181WLwO9puCiJwa9VeE9TrHU4NVwb20Ua95RJQSYZxxRDD7euSwOlEUG/SA0hMNZtdM+XzLL3yAK3V31HyZgcOedeF8KEKLQQTf4oLiZlSs3kx09jTrKx/J29foB1m7i08LnWMdGzorlwUFjWsXA2qnKxaYmODKt0LqrooAmCEJFd5TGrLph/hudEsJJofp4Esf+rnSAmgjuRBNxuo7dQrh/SqWzddOcYdfES+R+dOg71E+rGZtKSA+w0SGjy/WVrrfD2Zwo7LH8A+ix68xqw6BzR5QTdc94n7hTxgWQLqb7/c/CkMJDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axBYdCtotUuUv+amsXhXg0nosBMpRFfuXMe+MjRFVSc=;
 b=nHoHgRqUjN3c2HkLN9eyD2YaD9u7iPOmqFk0M6uCuFFB8HGVr5MjGnHZiAYrtsCIVgwFDExeB4BDMthcNbhX7EZMV5rd2UB8XlL4JrwWfGnsnDgXJuNwqOIxhvKEuLOWSkjTUKiOaczZoKuALG/ZncfhPkri+aJchZdkH5rCzNZUHs5rMZ15VEIIos3RmLalVxD1cW1VTH9dG01lfsi9HKkx+sm72UkEOmQn3Fe9Jee6u2tmXXjBiMOgQ07368TthWjd+mevLP00FBR0nvALZWsw6c+pm4x6FDTJYzau5YS5DHNY37EcfPam3R0kTBOPFx90ZiIqpqqsYo2vo5IGvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axBYdCtotUuUv+amsXhXg0nosBMpRFfuXMe+MjRFVSc=;
 b=ccdL6AtkqeeXHRSxuy5uxelREkaay/WBhFEh8P2215ovwJyznDwalOSLgjL8/g+gQc0h3pMZ4YFRhp6/wN5P2AigvVhIPHC18tDRdMDVDfLrJJ/C9N6PsTbSwvuLrPAty30ouWNmkqwB3jvOkv6TEZCZikBGu2XIwi/DV6vFfTjMPYK7FQOG6yxI1TnU7RtNYfHVoshkNpMZJ44r0SHlvU2hYrsp6kU12vBEx2T7cFpRnJ1vQ5J4mmFWe46NRGe2PsoalJT2uEv7VJlTwD4hIxdxY111E9zQ42hgstEeBvxCSpGOPkX6RI5S1jV/rWGFZuHF7JUL28FFgGv4FbJh/Q==
Received: from BN9PR03CA0584.namprd03.prod.outlook.com (2603:10b6:408:10d::19)
 by DM5PR1201MB0267.namprd12.prod.outlook.com (2603:10b6:4:55::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Wed, 18 Aug
 2021 11:25:37 +0000
Received: from BN8NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10d:cafe::76) by BN9PR03CA0584.outlook.office365.com
 (2603:10b6:408:10d::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Wed, 18 Aug 2021 11:25:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT067.mail.protection.outlook.com (10.13.177.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 11:25:37 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 04:25:36 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Aug 2021 11:25:34 +0000
From:   Mark Zhang <markzhang@nvidia.com>
To:     <jgg@nvidia.com>, <dledford@redhat.com>, <saeedm@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH rdma-next 09/10] RDMA/mlx5: Add get_op_stats() support
Date:   Wed, 18 Aug 2021 14:24:27 +0300
Message-ID: <20210818112428.209111-10-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20210818112428.209111-1-markzhang@nvidia.com>
References: <20210818112428.209111-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06be35b6-cb86-48aa-7604-08d9623ae706
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0267:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0267F7DF9D7A90DE099137D9C7FF9@DM5PR1201MB0267.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IpGzECuith8IiDjGtOdnQq9hQVknQAqb/xCQSNMNfUvsR1OOxMEpHLh/bxwOMpA325m34sqFm4iWch4ct36epttIF8icXyS1Mu0xK4o4LLRMSReWdR2tZ1nf5g6Xda9Em2V5xccFQaTdXmdlLEuTLJLy8TMzjwthkJ1dXyHHBx7tDyvFnAaqfhAas1sRpFQ6+9D7PBTN9YtAwpCljOIVq3BPx2iyy9N1nRBJoAm1l/07Ys19bVlrTYJSoOeJ0uIlrnJdyoiaYkS70lm7oKPY3urw4v+mTYAsyyNe29PGePEIiexfws/jfr04CZ3mOInHuD7ULnnWisTbkFNdpW5AKJKOgsN9GW3wQL3TrXHOLMxDwGEHOOoWv371ww1kK4bx1lNktedcs8uq1K+w+C0Lw8EkX9AxWeIQLbgnHdG5XSJKf1oayY2bGMBpF73Ef/cMsv+Ms5IWk2q0sjza4lAXPaK4OltuxnQsZOV0migL6TavJYNDKIebGQ2Uk5m1RxYe4YEyH7jOX5580R0DITURQlDMI9/Esu8Vf0mFBFxoSKSJpuAO10L/5Oz+dqt2mRG7Arzb6qz6dDospr/q2H+QEXuzOw6n10DcKLjAmkHjD0sISo6Ek0RgOuy5IYBLSTMaLBBiE3P8/1A1lrSFJgHL49ExUu8imtxg3fVfKf4eXm5OzKLujMWdBsrCVeRA4zjLozOY9m7Bj72WhD0aUHrDTw==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(396003)(136003)(46966006)(36840700001)(36756003)(1076003)(26005)(47076005)(8676002)(7636003)(107886003)(4326008)(8936002)(82740400003)(7696005)(6636002)(2616005)(36860700001)(86362001)(70586007)(82310400003)(110136005)(54906003)(356005)(186003)(426003)(5660300002)(336012)(316002)(2906002)(478600001)(6666004)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 11:25:37.1482
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06be35b6-cb86-48aa-7604-08d9623ae706
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0267
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Add support for ib callback alloc_op_port_stats(), to get optional
counter statistics.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 drivers/infiniband/hw/mlx5/counters.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index 5bd1e5a5dffa..5e0cc5af9761 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -797,12 +797,35 @@ static int mlx5_ib_remove_op_stat(struct ib_device *device, u32 port, int type)
 	return 0;
 }
 
+static int mlx5_ib_get_op_stats(struct ib_device *device, u32 port,
+				struct rdma_op_stats *stats)
+{
+	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_op_fc *opfcs = dev->port[port - 1].cnts.opfcs;
+	u64 packets, bytes;
+	int i, ret, type;
+
+	for (i = 0; i < stats->num_opcounters; i++) {
+		type = stats->opcounters[i].type;
+		if (opfcs[type].fc) {
+			ret = mlx5_fc_query(dev->mdev, opfcs[type].fc,
+					    &packets, &bytes);
+			if (ret)
+				return ret;
+			stats->opcounters[i].value = packets;
+		}
+	}
+
+	return 0;
+}
+
 static const struct ib_device_ops stats_ops = {
 	.alloc_hw_port_stats = mlx5_ib_alloc_hw_port_stats,
 	.alloc_op_port_stats = mlx5_ib_alloc_op_port_stats,
 	.add_op_stat = mlx5_ib_add_op_stat,
 	.remove_op_stat = mlx5_ib_remove_op_stat,
 	.get_hw_stats = mlx5_ib_get_hw_stats,
+	.get_op_stats = mlx5_ib_get_op_stats,
 	.counter_bind_qp = mlx5_ib_counter_bind_qp,
 	.counter_unbind_qp = mlx5_ib_counter_unbind_qp,
 	.counter_dealloc = mlx5_ib_counter_dealloc,
-- 
2.26.2

