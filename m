Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D5257466C
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 10:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbiGNIO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 04:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbiGNIOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 04:14:23 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA901D331;
        Thu, 14 Jul 2022 01:14:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eLKAj57meaVj/+yDrIG2fkkBcgvcE9lSV3m/kkLwScXERNzysmKo+4UvZqo2j05O//6Coso/f253496RhK9LNWRUnbFfzyzdC07q8KCcytty9OcG0sMnTOJ9Se/a3OjxXpe0m/JEQmdWY41H+0ifHoFKXt+dNE59aGTj/X/asLNF+0TdtIvl1Re+8t7k7sxtHAaKSYRuScahT5NS+c5SZZHyyb79exkYH0EavQjjdonQR9oBnvnbfCNFNsCSUC9+PUoIgfSVnjj50pQhUm3CMHkBB9jA+L3xaezmOrzG655DR/aRbhTIa06uDWVX5N7Zex5LsVN2hsNVnzBCuJ0/Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=acCF7blEo0YjpEeOeRgjmYbLma0/7FOpN21VoQVXpVI=;
 b=QWzM7ALwigzLH3Uk0t5S+UPApl5PtRkbk8dJDjyQ6KUchnltJTmMD6uQbOoeVMfm8powT50purqPV5+iT2gi4664snGqKfWxs2HlKxVYJA1QtZQNkuvnZpaiMKNObTWmDq5/zChCpnx8sfEgaseMLfJE0mffWo7lCCxFehiLIQZUCwNcNl8X3D0oRG2auNarogm3lZ1nmMIbsvolji80uGm4JUiB7/RMw4qITDz1NvxiTF+TxQzXBnHiEenH5MUu5x7bxXbDrqgnWmMsKuFUaMH0zFkvE/zJINxIbKh1Tf4EIjMVxJ2hSx8HTuhA/8lpPyZ6jGJd9WxQ3Uk+Qp+Qww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acCF7blEo0YjpEeOeRgjmYbLma0/7FOpN21VoQVXpVI=;
 b=PrDfQuhi/aw0FKyI9rpWPqsUnGvHz+UNrz4fdAgZbrAbuO24GIvmpEXiGVaPZBm22coA3xIvyCKDLUvs1qqo9jJO8+hxLS8gaAcJqwbSgK8Nq6wnFRg9A44jdISSGc2rCVF72wZCB1I/OtwfyM8lhNTnN4z5VCM8LhX7zHdYDOEBYNbk1Dkd2C0eL0TqDP1RKfJ1NVhML813IqeLdaceI3F7ECrrhnCxgicp+C7BMFa1c5PJKIOTycu3VgiR2/1smaX0YJD9tBR6P5ThM40zW+qkGP6JJrul+Q4XRIW4oHTHe3uNXJ3NxSv3xR61bnVsfDYEphCXqBse3+HYCXtWXA==
Received: from MW4P220CA0015.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::20)
 by BN6PR12MB1857.namprd12.prod.outlook.com (2603:10b6:404:102::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Thu, 14 Jul
 2022 08:14:19 +0000
Received: from CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::7f) by MW4P220CA0015.outlook.office365.com
 (2603:10b6:303:115::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25 via Frontend
 Transport; Thu, 14 Jul 2022 08:14:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT059.mail.protection.outlook.com (10.13.174.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Thu, 14 Jul 2022 08:14:18 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 14 Jul 2022 08:14:18 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 14 Jul 2022 01:14:17 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 14 Jul 2022 01:14:12 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V2 vfio 02/11] net/mlx5: Query ADV_VIRTUALIZATION capabilities
Date:   Thu, 14 Jul 2022 11:12:42 +0300
Message-ID: <20220714081251.240584-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220714081251.240584-1-yishaih@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d88416b9-bd34-4bcb-cd62-08da6570d98f
X-MS-TrafficTypeDiagnostic: BN6PR12MB1857:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LN7AAz3sTIvG3bOGFmh5Epjp0fkN4UiRAHAGEVGVw/lLUYCyRckhwPX1ZISGPqOQrWZJdiLVsBRO2ZGL/2AmXpC79eP3r8YvZ4CzOWEKhxadPFUdwZkFQ8ykjGg+ECGFkBz59/cCoW29c5zeFlk7RjtjRYfat5W0RhDpdYDd9NtXRjYTTTBEEvz5OgBJ0YGQpSVguyciXzZSG5J1fe5BgQ1IKcGE0R9bgW682mLvm6PfA2zvFRtf9fdPF/g01o42dLHzZaa+uH9uVg4Liwl3Zeeh11WuIlqW2IItRj8FjrN9EwXetS6DCNGe/XGlSoGWTejik4WvdpzvC8rNMcRuIh6m55FQUj9KqhRHnRLLfr/RwFGstsUCSrMZGbODmKkklxjQ1kkQ3sE/vGVI5rC8VnIaTn8nYwgtVoWg5Fj7RXYgebLKuSh2uuuhbWkmmMyvkX82ORococAXLCrgANCGZTpQea3FZrNgoz9QiFITEslRrMw1wYOFbMRk01InWX6aeb/LkXSLFTvDxaut8TbkoKgUE/nKKmMSrXnq4Cuaa8Rnf5Mv8GMtBEXygIkVbUizs2W10NUF5zSddtvtFBw/GcXtftJFdm7mmZLLfS9hYGCYH/I6jdBgoCESnNRP0TCYG1/C71EbcY3+nhOlpVYvJRSQlLlcyhlrAzAac1TTArxmcRhgQOr+bMrh3Lr0K4rz3WPgfB3IcWDI8jgpHBe/CO0edIl/DObAsjyiAs4m4P+Pam8RkD71RiXriYhU/D/uImjmUgad/z3JU3GHZbX8oz1/eHsbFnr1Mg2hSOjQrVhvD19Dbzvdjt8m5To735E5GQd9Tx+FseAavZLvNzj+JzfqMcWqNEdBqsBnhiI34oM=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(396003)(346002)(136003)(36840700001)(46966006)(40470700004)(186003)(336012)(86362001)(81166007)(47076005)(41300700001)(110136005)(6666004)(1076003)(426003)(36860700001)(2906002)(36756003)(2616005)(8936002)(5660300002)(40480700001)(54906003)(70206006)(70586007)(4326008)(6636002)(82310400005)(8676002)(316002)(40460700003)(82740400003)(26005)(7696005)(478600001)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 08:14:18.6075
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d88416b9-bd34-4bcb-cd62-08da6570d98f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1857
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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

