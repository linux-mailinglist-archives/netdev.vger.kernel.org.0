Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 522A95667EB
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 12:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiGEK2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 06:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiGEK2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 06:28:32 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B970FB86;
        Tue,  5 Jul 2022 03:28:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NuVjlet/ui4A6q7I1OIxWHtwu7IutNnCnUXGjuEyrxHj+7DMH00NvXo1RAp3o0kvh3ij/rrP/1LzfHoUNq0TNSKy28YU8uO1QIJo0tcksO0UzEB8KSz4C/clZB1mtU5SEZI+HlcoLXpZSyDwBD06r+f2ZZA/zphThmnRsakax3ClVAaXMktUs8HdsF6ToxeQcWo8n5nxUS4Fn8uDQEHr5FV5SfPPrjCf7fDI0j8jzJMOmLqOTX2Q2cXMgRRRtSo+CVQb4D3G0NKjJ7tS/8Wv0AWvj6PzwpWhaNx5aerAL8ASIsutSjCGTr0gEUQ3QtQxFqkqRtJKfO2L4n/BMTMxFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=acCF7blEo0YjpEeOeRgjmYbLma0/7FOpN21VoQVXpVI=;
 b=MwFgm9IOiY8icY1o2mBhi5yjxFn1CDX/+Y7/wNCl9N0OKtNNjIHqknLyknKLqAaItVMQyYjK76XHnBUDWThlgGdkGGYAeJIy9XQ+SgDrRL4NbV6VfX1VvpOAjyCvI8CChib1DnNQVALDL+j9wDPl9ps9AglbdQY8XJEMWZeSdwkVv2xWpmg5P4m9fI8UY+jtPx5wf1l50Xa4piqwa2+IOj4j3S47h2mhT/OB+EW4nAMvVG1SjUDUXJ+EP2Jz1ueUzvpnJhRD435ljDkalVmSTjzacHRyZ1qgP/9kBiK1ur/kYeHK9s2th6PpqLHLxWot2fB+ElLTVN9w2577pi9oHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acCF7blEo0YjpEeOeRgjmYbLma0/7FOpN21VoQVXpVI=;
 b=lkkHUnys5VTSIpFgVydW57HBGpSuDTHH8ZuWTP/6HXj4J1V3yxAWhZWA8l2wmvpnsXxPFC4X1Ls89c4EvJ+aBETfjnZnCVpxmmGtmhYlpjff8AKhv7g8jKpGUU46lE+U4LlWBx1U+rddKsiboI/SZ45IJQkGl5DNQ49o4dBFupWXqF7VYJaoO04m0jgcnoIgKct3IWXlhT65bSqTZ5Ou4NVza161amCpVCmHDAI9gJ0WcxK7mu2GsDqfQs0a9PheeHOhDsmJI79VdjCeFi0K6T0ZVl5PnfT+eSrAUwFe6jO7OI6Ro2QgLVAAldouYB76/t/KYyIm0GREU6KNICVU2g==
Received: from DM6PR12CA0026.namprd12.prod.outlook.com (2603:10b6:5:1c0::39)
 by IA1PR12MB6459.namprd12.prod.outlook.com (2603:10b6:208:3a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Tue, 5 Jul
 2022 10:28:27 +0000
Received: from DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::9c) by DM6PR12CA0026.outlook.office365.com
 (2603:10b6:5:1c0::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18 via Frontend
 Transport; Tue, 5 Jul 2022 10:28:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT051.mail.protection.outlook.com (10.13.172.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Tue, 5 Jul 2022 10:28:27 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 5 Jul 2022 10:28:26 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 5 Jul 2022 03:28:25 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Tue, 5 Jul 2022 03:28:22 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V1 vfio 02/11] net/mlx5: Query ADV_VIRTUALIZATION capabilities
Date:   Tue, 5 Jul 2022 13:27:31 +0300
Message-ID: <20220705102740.29337-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220705102740.29337-1-yishaih@nvidia.com>
References: <20220705102740.29337-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35464fff-4ae3-41ed-d63f-08da5e71196b
X-MS-TrafficTypeDiagnostic: IA1PR12MB6459:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0S9ux9hMYbNQr5COUk4m2C2h0m4w4EDQMNtOY6RKgD7cPIwiAhn+dJxIZESFyY91DJmk2gRi02Bo8hX0xsD5Yeq6A6wD0gMAtyyyUM1+7l/SI4rp9THOMRZTbY6dEIuKY79OlFR/s2R1BvUoQE/a/n/LzNW8QTLIb9C6kCDUlXUaqpuEwXz4u+km9rlPv25ZDTeHPPXnVp4RDpt6lMc3XgU2P57LRal7C1Xgj7E+jeBChUbl3lPI6vIZgK7o0Zoqs9tIFHo1lMRhoPWjzCoD7D3P0u4cjMk8NlT+mwByeraB67LbXeSIzCsHdbBF11sU/lGAJ/pqOvjTdkOHBZAvhT/mTwgtWwKtJY5walcNvOHKWQ0kMsDyor6SoSxM0WTTvtQXIrtvBbJUhTfy088xXB6VK79Foxyo2SC8hW3J5DH99YbnqBFfyjxPPEelvfjStulBOnX7S5uczb1XEW0E9ndCFM+5OunR0vp2sgghclI7ePVwgHqbi37qz2uHpulT5idicSMRQOhS3BIBCEY5iXG/iBJzWVvEOloSNc1iGHV3YGLkF8yERPRV72SUReKoWxVMPvjr5WYXMCWqrWmQ67J+L0ZjWOgbnLsYQz9YVIVeho6ckN7gToBPpVyTq/2EKDTTkqTHqyUXneMQQIPCYOOxn1QDQ4tfLrSkmBtBwmMUnsezry+MsM1Qzs4wzyEapqWDbZ/pQC99EuL+UCKCAjBDszqUrSrKJBbyuL353gMK+7jIUVwQ4zY/okDdkb2mYv34Is8S95C7xdRGNkrZsLFlCIzkzTAVxxtDpCJk9hcbeNMI45SVXwB/GlHCrXr14l9mD1532I4z0eQ4/qYQF1LZVoWohDqiotiX2jzdiog=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(39860400002)(396003)(36840700001)(46966006)(40470700004)(316002)(2906002)(41300700001)(82310400005)(8676002)(6666004)(478600001)(86362001)(110136005)(54906003)(7696005)(4326008)(26005)(40480700001)(70206006)(40460700003)(70586007)(6636002)(426003)(2616005)(336012)(47076005)(5660300002)(36756003)(82740400003)(8936002)(36860700001)(186003)(1076003)(356005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 10:28:27.5909
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 35464fff-4ae3-41ed-d63f-08da5e71196b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6459
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

