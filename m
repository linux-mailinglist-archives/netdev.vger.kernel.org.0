Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60415617B2
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbiF3K1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234707AbiF3K0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:26:54 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2081.outbound.protection.outlook.com [40.107.212.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC745F58;
        Thu, 30 Jun 2022 03:26:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UBxuHSg+ojegcFjsX7DyUt1I4TxJX6VzZIBI95LoBadToJRkRU6YodyaIhbcvGZkztunoqLVOMWAs7Z7ypFUQdJ3jvdokTH4oYp9T+IynROYON8nqvs3r7PjV8T1FFEYHjvhSPI4BjD1BVhHrNBF7jehqUvYWa+IE+MH5DE7dKMpP+5EvoiCxNnmGvZfa2DKOLGP6eBtYZZN8mwaDjImk6Fj8Bwg8fJFTDBX7YnHZyucUOtiywZFcIKyQ/0KAYWpJ+ZibvWrawXCi/cTcU+u5DfYiAaisXQJBPvCoAcLIa9HEfX2V6LVvl+topZC70cd1JYLKhBxNOXyP/F2baD9Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=acCF7blEo0YjpEeOeRgjmYbLma0/7FOpN21VoQVXpVI=;
 b=OVJDRfw8bv3Tr7h2lFj6mU+GsRJanknQ1HIhhGArZKGOlo+TQE5Itl1Mnzy1c7Z/oJpU0lPZaELGXJ6PiodYtzRMwvtRsnwC2YVPX7TRWcsSRyyoh4S4l/FWlXGsgNskFIuJCUpeNSW8dEygQlErp9secLAWaLhf2S+Mz3g2X6NyVl9XhK+3Nl6piqktfAQgGf+Rn+M7fxMtSliMNNHr3dqYDNjgXP4HWW80J0NOmChAaK/39tDo2jpETmlX9X3dvQrAmV9iNWSM9HaLQpnZJVy2ieOi62a/lzAWl01ZKr7HKU3UueF0FELxi7OrQCd60c0vB4Yw42mZ/D0wvz1X1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acCF7blEo0YjpEeOeRgjmYbLma0/7FOpN21VoQVXpVI=;
 b=X4red4eZCW8nF3IHGFb09hN4fBzekPJyUxbEDp/ea9LTTYFGLvDf9G+vezg+AT+Esa8oLiVw5SgL0uU/Wd7bSu6t+jEusXhwlMExtFZFUSJ65pWQQewUrD+mOmAq8iIU+ExzHhqFo171GK+TYlBqEY/06tmDrlbrjnrNS1+prz1ItX8w4jmEeoiII6oVGC0wkYUlcfvvbnVeElTOM12hB9OwAuN+/HsalvEUWXQ9h2Tbbepe1di6jyKp0leUpNuWifxIlJNPff9zXi0gQOXUEVbxpcYQjMwijcooO2UhRXZinycXK3gisP1UV3oT1PDI9nxZmqQ2rbT6zpOGRvtP5w==
Received: from DS7PR05CA0085.namprd05.prod.outlook.com (2603:10b6:8:56::15) by
 DS0PR12MB6462.namprd12.prod.outlook.com (2603:10b6:8:c6::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.15; Thu, 30 Jun 2022 10:26:42 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:56:cafe::58) by DS7PR05CA0085.outlook.office365.com
 (2603:10b6:8:56::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.8 via Frontend
 Transport; Thu, 30 Jun 2022 10:26:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Thu, 30 Jun 2022 10:26:42 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 30 Jun 2022 10:26:41 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 30 Jun 2022 03:26:40 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 30 Jun 2022 03:26:36 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH vfio 04/13] net/mlx5: Query ADV_VIRTUALIZATION capabilities
Date:   Thu, 30 Jun 2022 13:25:36 +0300
Message-ID: <20220630102545.18005-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220630102545.18005-1-yishaih@nvidia.com>
References: <20220630102545.18005-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4cba7f9-d2b6-4cab-fbe1-08da5a830697
X-MS-TrafficTypeDiagnostic: DS0PR12MB6462:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 90C/ZPMYZzjrhWNHJxdDNWRThaXVAHjb8s8dcFeuwnbcOSIvUgt7j4OL6q8+ggbgXMGcUu9on4W7KaltFHVuTsRTWm/28gQKo4BErYwYv9iS2kTCNYlaSLGlyHwJv2Fgkdd7Y5sL+gFHhDKgY2r2ZJjnb7IbmyUcVvBe1E7LMydkIx9PXsX5xxkNSv3LhiJHQWN+6CkW+XrT2vpx8lA9pRMm43a3z6ZTEee55fF2wEdkLFYoe5sAw/fTUQml5hbK1ZLntcDH06V5R3YImcSY3ZLgj1FXMlVSf01FDf1WrfRvT+XGLE8dSgmbPpVRiHULkcTgqTskwz6slNFKsa8FM4V4ErWC/1l31cT6ZdRdrnvZawlYVEnpt09sQuNiymLAM7w8qBqx7eERc7YynGrNU6CCxorp9AEwDtYMLJUnlwaCnmZWRc05M+paHOnuazRea9FHkKRAydyB5GKKieyi1ot8M4dOPXhCl3qyZC07Cq3JxAYOvSUA7lPzOop3YM8RNph6ZHKxFJznkSjr5FQ12K9T7gxCwpb5h/xk+IWRGlIO68DzhAYRRbsf83SBWSgx7XmhxejXMLB48m+hW0mhkP93KOtvMJpWzoR2Ap5GUjlDdks0v2ITBaK5BNZyI97mEhroKNEP4GYeVnEr06wil0hqkzkNQp7TmqoHkaB09VbcTNL8yVULt+os6qzPKytops+E9Z9imwqN8tyPEIVG3ZTQoZBdmVrxTtrxHjzdYKdl7AA0s/p+cTxg6xu/y/D6ucAlb2jzW0/2TxQ9OAChdjT+VWNNwAteSK7Q/8nAhi1QwOEUOdaabxRqA2yfYXlRK7JYdYKglzQFJyspw0ZRDYIVK9tWLhE6cVrnF/NXRQU=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(136003)(39860400002)(346002)(36840700001)(40470700004)(46966006)(336012)(26005)(5660300002)(7696005)(70586007)(36756003)(8676002)(478600001)(6636002)(2616005)(110136005)(54906003)(41300700001)(82310400005)(81166007)(186003)(1076003)(8936002)(426003)(2906002)(86362001)(36860700001)(4326008)(40480700001)(40460700003)(70206006)(316002)(47076005)(82740400003)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 10:26:42.2935
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f4cba7f9-d2b6-4cab-fbe1-08da5a830697
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6462
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

