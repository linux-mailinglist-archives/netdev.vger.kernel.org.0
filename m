Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8843593159
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 17:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243052AbiHOPMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 11:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242765AbiHOPMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 11:12:00 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2053.outbound.protection.outlook.com [40.107.212.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F3926107;
        Mon, 15 Aug 2022 08:11:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQwc4FpsUz/M4pofMA99QOJKQjRuLt9DgnPoSuem6wf7bqRs93Xo3YCURg+cwCldQIi3EfNwkhemFPZ4L1FDKBRHXJX9UCX7P1q9c/0xR5C72HDpq+wPwKauwMJ6sKqN78u76U+gZzOaKYph6u0AucTPQzvVQfMmYa+DqWluWD8JOJNBfzXp7FRQiIw2nLtSl/JU827hYf2XJfl13NbOaiJD/gZrmRFN5Br4BRlFJl9QWP7n0p0V8/F9cg98RR2EOChETaqVWEYhgXjnGxA72tYP6c8YoW5LlDvlkg+UsRX2MmLFPfkI/IiX/ijCFcySA7LjIQPcd+g1rwXOMj58yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OUUnqApu16eZA2u401Oa3heefc4WfpgFiavZWMeVgfQ=;
 b=XU9ETRUoRmokeGijvYpaWa2b5tvbm0dvR5DGfvLgBP2eyt4pK3cChEW/plhJZ3yBf13brs/7RjwHc8CQpGV3nrAQAudV6VpxR62ZJihyyuIDZfa2PyKwu8g83Iw9Zih8c57yZJszx9OlK4zWP3ZhWw2lscB+NedOR3sTTbEsRAXEr0u5D7Ec/qZ6bT799l6HRUHoMjqUKctpoupDrxmEjxGlcC7FrSkxooBpbgOILwLj9qFAnrzxpBi2HqyDtz/vODZRmmhTVvq+fMhZk1UWi7JrHdl/r/q6K7CGWwGDkSTfWvyXQr3P10eEpt71/6q1uSjThTLNxOAVRZ32M6GPwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUUnqApu16eZA2u401Oa3heefc4WfpgFiavZWMeVgfQ=;
 b=PC/0gZdy5KIuweP35VUPnK6FVCvHxbB5ZhKdr/WkV38ZfomPuzeB/FKTGtn+BI0YUaAoS4t9v9lkomzvewKYZqbRwdloRo+eYnd6G5BBXfTssGzKPTIRVNXO+f/NIacLtS0gZdFxX7cfw+Mh+JSCbsKy0cZualkOx7nfcXdGshbO23dfP0Y4lLm2UQI86LoH7YM4bR7PADqZp7a5t3cbobsppk5l2DkFRLPC14EcEFyOSKWodImbCQQHkZWzvd5I4albKoDv3AszY9ozr4myEC/LQ/bwQ//ZlaLTz0oSxnMRiaRuS12TP5Az4mJOcd85zn3Vo1fX3OjtQFwy2afrcw==
Received: from MW4PR03CA0225.namprd03.prod.outlook.com (2603:10b6:303:b9::20)
 by MN2PR12MB4608.namprd12.prod.outlook.com (2603:10b6:208:fd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Mon, 15 Aug
 2022 15:11:49 +0000
Received: from CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::f5) by MW4PR03CA0225.outlook.office365.com
 (2603:10b6:303:b9::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.18 via Frontend
 Transport; Mon, 15 Aug 2022 15:11:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT029.mail.protection.outlook.com (10.13.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5525.11 via Frontend Transport; Mon, 15 Aug 2022 15:11:49 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Mon, 15 Aug 2022 15:11:47 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 15 Aug 2022 08:11:47 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Mon, 15 Aug 2022 08:11:44 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V4 vfio 02/10] net/mlx5: Query ADV_VIRTUALIZATION capabilities
Date:   Mon, 15 Aug 2022 18:11:01 +0300
Message-ID: <20220815151109.180403-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220815151109.180403-1-yishaih@nvidia.com>
References: <20220815151109.180403-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29124586-905a-4cb5-7895-08da7ed07a03
X-MS-TrafficTypeDiagnostic: MN2PR12MB4608:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jyGSTRR9+J+QhPTmYJgutwm+9XuKaX0jfEXwT+wlKgfpYYm6QGkgMiEEujkptk23Y1rtQ/jtBbeBiW6DqyNWb/CCAeW6W12DuYHtNW3e73GWZumKqbs8P6R2t6wPQ1JXfL40faD7eC/jOa8CRd0gttEhCvuVLO20okexwlWrRipJrAGQrt8n6dQolhuU+WvEj/AE7+B2D4ao5fETkNQbVkRpUbmEaOR5lzEtbrEc62DGIJkhesYlOGcmFDJ2iIi/oEz+/oiBEABR/tGB8xw8iNdlUDU0atGRgZ7ak17YFnVYUZE2VJ3ewYucHRl4n/jm71iV91bXb+rNjl1HQzGtHqllJd+skAKcfDB5CxM/a6xdHMSAgLt6/oz1XTQwkCNN29vGUFAVkrhOhEj8Xi1rj3CaEZyMnm2F93xE8EKOw6uHyJLc/leHE5nnMvQ2QyMpFsHLljo2/wzEJ46GMgqNW9QmNYJT+/nI/qEhA1a8TIkMwNXQgk7uxHOSS33CYKbWOwdnObK4w8k/dMhHv/hkechcq7a0iDSx0zyGCoBQuoN67dr3wmfbjhOpYrME52k6mE4fwEQJF6lPp9xHUHhiU3zZ1pWCa2yVPsizArLhXWkigbxlEBG/vHOtCe6WMhZn7ri4k5qB695CAkZ8o/mSwRywIK0Roh+Aqxk+GWAdaQczBmLApmR+poKf85rFeFU/mbWfN+zA/+vKpo5y0U1rIu/pUZH/xKLw7fUE4Td4KH61yCnZNRmCS6KnPdniin+2OzzBxWE+j7yjzDAePdnBpaybjNwUzbkpQANxnW2f3IdcNrXqTkSKWvNrcgCvPfhnvFIj7jFdMxzvjqxw4yG4Tw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(346002)(136003)(396003)(40470700004)(36840700001)(46966006)(4326008)(81166007)(5660300002)(478600001)(8676002)(40460700003)(82740400003)(70586007)(41300700001)(70206006)(26005)(47076005)(1076003)(186003)(2616005)(336012)(426003)(7696005)(316002)(6636002)(6666004)(36860700001)(110136005)(8936002)(356005)(82310400005)(2906002)(40480700001)(54906003)(36756003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 15:11:49.0441
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29124586-905a-4cb5-7895-08da7ed07a03
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4608
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 079fa44ada71..483a51870505 100644
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
index bec8d6d0b5f6..806213d5b049 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1488,6 +1488,7 @@ static const int types[] = {
 	MLX5_CAP_IPSEC,
 	MLX5_CAP_PORT_SELECTION,
 	MLX5_CAP_DEV_SHAMPO,
+	MLX5_CAP_ADV_VIRTUALIZATION,
 };
 
 static void mlx5_hca_caps_free(struct mlx5_core_dev *dev)
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index b5f58fd37a0f..5b41b9fb3d48 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1200,6 +1200,7 @@ enum mlx5_cap_type {
 	MLX5_CAP_DEV_SHAMPO = 0x1d,
 	MLX5_CAP_GENERAL_2 = 0x20,
 	MLX5_CAP_PORT_SELECTION = 0x25,
+	MLX5_CAP_ADV_VIRTUALIZATION = 0x26,
 	/* NUM OF CAP Types */
 	MLX5_CAP_NUM
 };
@@ -1365,6 +1366,14 @@ enum mlx5_qcam_feature_groups {
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

