Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30627585EF9
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 14:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbiGaM4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 08:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232307AbiGaM4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 08:56:07 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2060.outbound.protection.outlook.com [40.107.101.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C27637D;
        Sun, 31 Jul 2022 05:56:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EOH4c2rA4JbU7oD5hGQSU5ulJv/nCuQWSV3nQMcSwxobMUlqbsm55s+S73PX/PGPBvc1lko48OhAGa2TdPktRJ5ZLehwLLnUBa/PeXpNE95+lHc/p3WQwE9+HKZ6L4gRvjhlM0BgAgp81N/YbDqMTeD4WwfmzJMsZTatAd5ABpnnvSFtFPUM0ZofdsUWPxoEq2kJEDd+rkEt0F/E+3pSwFygpcc9AX8OpX7i1jW3NTr5DnDGcgPP1eYR0MIZgI1oo7YhCuUWXT2UU+Fzv+wqfN+NA5b3u5QfgJpbfygfFhBVcy5RGV+3vtZTOOt5yyKObxbLaU6hLN2/GRUWFVUq4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=acCF7blEo0YjpEeOeRgjmYbLma0/7FOpN21VoQVXpVI=;
 b=KHC/NodYUP6TA5ITUrAFVco9YzKDX5+K68UNXxaPnpAl1FCjGESWArTXWSKwdk4pW2ZXAtHiVSQPHJdHt8qACEHvudBYCzqhYKhgIMW1VuZ+K0S/aIZhOkr+PL6PFozKN/DGxL3b8wKMyTMHtVmhuqn5fp5Y1xFAf21SBYPTs+Z7zDFSx82blho14hETOgDoDWIee73ZVYvRy9onKJ2oxwZl4uhY+Q8+1e9LchzL5p04TU3gMny1F7YQgY54gA7hge9t0lsOOPeoED411MAN33wzjmqVh58GHtO2k4F/CmjS7QTCYUbCaOdmqpWmDC7yNxmWx1TkI4ZEZ0JL17PoeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acCF7blEo0YjpEeOeRgjmYbLma0/7FOpN21VoQVXpVI=;
 b=PH4ZjM1m01ikTH8qsKZ7HdV6sRuPLbBistFqmWfoe5QR0M07/n62bK8Fdq12eXhMMnvboDOiQb2VfF1X/XHQ5C4WrT66A+/szhddU2mOhhUlnmMx+PGRn6IesCqUi6/vnsIeB8vrLpyRDR2sZ0b2fvH70b6uCc4AOhZKV06VhlcYEgQi2RvfTSPv/hLxJqPeU4Fq/eJjhEUI+Lyz4zZPQOoU5mgGvWJw1o9jxWi8zoIh0F4AhX/JGRF41PFVNxgztHjkErVvT7uG0wrfrdDJkDahlcUcfYRMSa2OzXNwxm/iGr79QUOknisuh/JXMydD3F+4AMk64gogHJ5rLuttSw==
Received: from BN9PR03CA0750.namprd03.prod.outlook.com (2603:10b6:408:110::35)
 by MN2PR12MB3664.namprd12.prod.outlook.com (2603:10b6:208:159::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Sun, 31 Jul
 2022 12:56:03 +0000
Received: from BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:110:cafe::e4) by BN9PR03CA0750.outlook.office365.com
 (2603:10b6:408:110::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11 via Frontend
 Transport; Sun, 31 Jul 2022 12:56:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT004.mail.protection.outlook.com (10.13.176.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Sun, 31 Jul 2022 12:56:03 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 31 Jul
 2022 12:56:02 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 31 Jul
 2022 05:56:02 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Sun, 31 Jul
 2022 05:55:59 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V3 vfio 02/11] net/mlx5: Query ADV_VIRTUALIZATION capabilities
Date:   Sun, 31 Jul 2022 15:54:54 +0300
Message-ID: <20220731125503.142683-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220731125503.142683-1-yishaih@nvidia.com>
References: <20220731125503.142683-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e800d48-b4ec-486e-a63f-08da72f406ca
X-MS-TrafficTypeDiagnostic: MN2PR12MB3664:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A97CLTNxpGcx7ROJY62Hc/N7ec3pQOTQR8jxaXgX0u++4El8ZIT5O+1/GNORQhi8rwn4UoS0zFN6cdSFmZVPNp6O96RWygl5E0rjVSuidDMyAq/O3T1NaPESUhODHP4jz8xQjyoqilmUDVlGrsdmFFAtbXpTCTbhVkVfUuopduEwg7U8O+Hu/BSa2IgdP0ZwtFFQUdRgobDczK6kkLggx95jyo73WuROEpx0BFcdt/2L4TYwLnR1kpVVcBwCT9yTfxk1gK+kYt0N8+Et7R6czN/AKXjr9oNVEYxoMRXtCZv+/Cg6qBfn7B5m/ebng43zu7hP7Qh7m285ak2X90qL/QrtPd6RGCwFbaLMijBcHgKURaVIpeL+ixrpavRjSgRfoqGqdmHIJcMs1oBbt2fqalCR0q12m+jxNs2bIpBa4j3IxN8yD5uW+e3h2rkUmoOh46ijNc2hjKlCt55YE7Ha1r7GTIP7EBq5bA1TfRCGfaiR/Yx7PxaDZL6jYOb4OEArsm8gIf0imx8UliaEc5DpEkidBIsd6ImNbT9tjBqslJ87ud2KhMzoqvcL2ojlPQZ5y7iE1R14GDmL1QYrsf+d1VGy2hk4gc5ps1cDZtUJ2TDPQEF11ywp3O07ZgrlkDxqnhYxHi8DceBS6OIOWtRqCDSO/VdcL+YOPbh35FnQxFOY2o5MqeLXyWmV7soG7EYD+/IRmeJ+wl+utuANSFaFLjY4rUgHYzgmrHwZFqITzdb2wcyP9rNLTvs7+Dp3aNKuJFVUOazsdxzLUNFNxTVdIYSbbU3GjySzNUIl+eR22pwvWyT/6vPa7nA0uvqi/pSOLjiCuBPlJf9wqAVzzpMPhw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(39860400002)(376002)(346002)(46966006)(36840700001)(40470700004)(82740400003)(2906002)(356005)(41300700001)(81166007)(6666004)(7696005)(47076005)(1076003)(2616005)(40480700001)(186003)(336012)(26005)(426003)(82310400005)(86362001)(316002)(478600001)(36860700001)(70586007)(54906003)(4326008)(6636002)(8676002)(70206006)(36756003)(40460700003)(5660300002)(110136005)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2022 12:56:03.6158
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e800d48-b4ec-486e-a63f-08da72f406ca
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3664
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Query ADV_VIRTUALIZATION capabilities which provide information for
advanced virtualization related features.

Current capabilities refer to the page tracker object which is used for
tracking the pages that are dirtied by the device.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw.c   | 6 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 1 +
 include/linux/mlx5/device.h                    | 9 +++++++++
 3 files changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index cfb8bedba512..45b9891b7947 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -273,6 +273,12 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 			return err;
 	}
 
+	if (MLX5_CAP_GEN(dev, adv_virtualization)) {
+		err = mlx5_core_get_caps(dev, MLX5_CAP_ADV_VIRTUALIZATION);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index c9b4e50a593e..5ecaaee2624c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1432,6 +1432,7 @@ static const int types[] = {
 	MLX5_CAP_IPSEC,
 	MLX5_CAP_PORT_SELECTION,
 	MLX5_CAP_DEV_SHAMPO,
+	MLX5_CAP_ADV_VIRTUALIZATION,
 };
 
 static void mlx5_hca_caps_free(struct mlx5_core_dev *dev)
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 604b85dd770a..96ea0c1796f8 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1204,6 +1204,7 @@ enum mlx5_cap_type {
 	MLX5_CAP_DEV_SHAMPO = 0x1d,
 	MLX5_CAP_GENERAL_2 = 0x20,
 	MLX5_CAP_PORT_SELECTION = 0x25,
+	MLX5_CAP_ADV_VIRTUALIZATION = 0x26,
 	/* NUM OF CAP Types */
 	MLX5_CAP_NUM
 };
@@ -1369,6 +1370,14 @@ enum mlx5_qcam_feature_groups {
 	MLX5_GET(port_selection_cap, \
 		 mdev->caps.hca[MLX5_CAP_PORT_SELECTION]->max, cap)
 
+#define MLX5_CAP_ADV_VIRTUALIZATION(mdev, cap) \
+	MLX5_GET(adv_virtualization_cap, \
+		 mdev->caps.hca[MLX5_CAP_ADV_VIRTUALIZATION]->cur, cap)
+
+#define MLX5_CAP_ADV_VIRTUALIZATION_MAX(mdev, cap) \
+	MLX5_GET(adv_virtualization_cap, \
+		 mdev->caps.hca[MLX5_CAP_ADV_VIRTUALIZATION]->max, cap)
+
 #define MLX5_CAP_FLOWTABLE_PORT_SELECTION(mdev, cap) \
 	MLX5_CAP_PORT_SELECTION(mdev, flow_table_properties_port_selection.cap)
 
-- 
2.18.1

