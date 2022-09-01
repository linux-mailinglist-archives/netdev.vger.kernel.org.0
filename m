Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D115D5A9354
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 11:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233426AbiIAJky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 05:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233392AbiIAJku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 05:40:50 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2058.outbound.protection.outlook.com [40.107.96.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A146B1223B0;
        Thu,  1 Sep 2022 02:40:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gu5104nWL3MjIFAFAIqBGNr9V0oMd3EmbUoVNGY7/ZwY7YiF/Jh5rtunKr9NGd+vb2L/p6DsL3b0pETAWWkaWmputgCxh23dS3aJsAYDOIveKTRqb4EcwgasALv0x+xKaAvW8bPGaL4pnEBxq1Los2sPQfDMhWMaDmUmlQkbHkxkP6VEM5ZUNKyJfV8cUIilA/OAZLf0RqjS6fW+9/jCBlS1hZ1SenRYQJoVLG0xfBkfuT0ZFFqYY5+OfOUjkaT8L7MjgXUohDJ0MOJx9NXKx3lumNIKtM5icc4b0HUI5W3KCiBXjziAO0hfIqb+K0Mdy7PiEmfN8o/D0FlLgydpNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OUUnqApu16eZA2u401Oa3heefc4WfpgFiavZWMeVgfQ=;
 b=Vldw7a7NFLarYsAt/2nJFiClDlhJB/IIwkWpDcL9f+ls2Sz8StDE55aQCPTU7Kz1T3oN0tTu6+1AEBIDYrbVrQeBWBChUSx6257Uyj6KExv+Kon/Lot6Z1Z/B71/e4iJYDBNhaXK+UJoqTjFW0zYte/2zWGXnpmMrpIZqZi6zZria2LhoC5iavpc1ZOLxseTmFD0Nb7dHRQNKRSge9Ks7w4obQRwOpTlEUY0r+ZKqeh0Eo+9ZIsHrTkEiTvLkq64fau/y5shuXF7jlBrxe5084+1uBt6SuaAtHW6vBPGWaapg4wP8pseIXY3hDlFYWTuksyxqo+Sm3n5C0MKiBxrYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUUnqApu16eZA2u401Oa3heefc4WfpgFiavZWMeVgfQ=;
 b=Ij+BslrBEU99FaztzS7nPYG3eu4v/at0L991xM0fjIyMMm89kC0SaTrHUEM0t/S3KTFxQIvAiI0mFwsGOLby4bMCJ6nDcaYe5kQ9fwN4nO9HhRYzd33ih53JF/AA+ynyRE3Q3ViPaH95918KFdZhqY6Hcid5UAab4dRJOeSStGzRZ42AJTGM72Z4iodXchFiF75478XDlPwRcfYlZVQ4aw91DtI4Ws/7Na3cb86vIW1EiP8I7E9kqNEIRk0KeekDI80XZN+EXYcJvVWOByI/koxhPBfoeQS9Xfqh/sSX0as/Kh4Eqqtf088etD+mOGEsWu3bwnB31W5qQYNTtaCRqw==
Received: from BN9PR03CA0476.namprd03.prod.outlook.com (2603:10b6:408:139::31)
 by CY5PR12MB6527.namprd12.prod.outlook.com (2603:10b6:930:30::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 09:40:38 +0000
Received: from BN8NAM11FT072.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::1) by BN9PR03CA0476.outlook.office365.com
 (2603:10b6:408:139::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10 via Frontend
 Transport; Thu, 1 Sep 2022 09:40:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT072.mail.protection.outlook.com (10.13.176.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Thu, 1 Sep 2022 09:40:37 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Thu, 1 Sep 2022 09:40:36 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Thu, 1 Sep 2022 02:40:35 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Thu, 1 Sep 2022 02:40:32 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V5 vfio 02/10] net/mlx5: Query ADV_VIRTUALIZATION capabilities
Date:   Thu, 1 Sep 2022 12:38:45 +0300
Message-ID: <20220901093853.60194-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220901093853.60194-1-yishaih@nvidia.com>
References: <20220901093853.60194-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbc6eab0-ccc3-43f4-b65c-08da8bfe06a8
X-MS-TrafficTypeDiagnostic: CY5PR12MB6527:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BOAhwvcWau9TTSuHil0KqFwwbs9BhrWrW4Hhbb9hfJFgUb6fPU7mVpaFRu8qgdTxp/wSz5buT/bOP05yP5XR3G5LX7h9U5iCu5Vmdftaeqn4mi3q2JNV4MMC9qXc5XkqTk8kjMRJWAOfsXxXicithDbXar8a6+xk+cwUv6nLZz/AsNBazvo02PAKj9oMT34gJmjrgxfcq425Ecj8AVww36YwDO71RHtEV600GahsP+LjCwKACso5+RUZ2vBaCpKHOOOASOqrhIfIyCY/CyZVUQQSi199vOLLpqOGrXbnt5d7xd4renHi9Lr48IYID0Pixz8odI6veWG0SuRtF4KWmU9eMNWxwcYAQIKuvsUijGa+u0jpe3jNOL3V98q79v72gxC7Z/D0Y2tk1AH6nrwWoaAy1LsQ39lxZuEXkMP5GPKLhZmSr/PzifabOivx3FwWHJOOnwfg4RlZKajdo9bQY6i84UCVUIRCTuV4+jL5IkJuSNKKMFCtDC0xbFC1TxmVAbHyHqEt3xCoEoVBEVxOSP54jTBdkOawH9Zu12L4/Lv1ZBwY6tW3h3UM69QxZqbONY/r9sOqHLI9/jAXLSj1sA05M5VffE/G/0H2j5lpnxYkmsNGtwHn8doQQDFfDplXvGUXfFMJkCr4r7WEjYcyqCy/73pEKGbXO8SRCc+pQuH2G+/novwz25Ng3JDwPqlMyJMzD+kB8kjwdOAVP/fDDTBriQqX+Y1wP/8YR7YmcxwXLkynDYAgC5JgWWIjd7rMy+LRJFsNMs9F/SRdGaILKaFiyFtaf2a8uXXzIiPnotnUi5r4Ar4tAhNwfppVV+fZ
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(346002)(376002)(39860400002)(46966006)(36840700001)(40470700004)(86362001)(110136005)(7696005)(47076005)(26005)(426003)(1076003)(40480700001)(2906002)(5660300002)(8936002)(186003)(36756003)(2616005)(336012)(478600001)(41300700001)(6666004)(356005)(81166007)(36860700001)(82310400005)(54906003)(70206006)(4326008)(6636002)(70586007)(40460700003)(8676002)(82740400003)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 09:40:37.4145
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bbc6eab0-ccc3-43f4-b65c-08da8bfe06a8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT072.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6527
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

