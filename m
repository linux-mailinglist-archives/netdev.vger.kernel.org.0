Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 036A05AD104
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 13:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237820AbiIEK7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 06:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237968AbiIEK72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 06:59:28 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E39BC0F;
        Mon,  5 Sep 2022 03:59:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AyMH8larCdLnR4u0BXAOSz7/vnlcpp6ja0qWusx7no7ZLbKPK92BdOEJ151IZV9t3afp3VnkBHVr6AxcBP+oPYHsknXUiSCzziMLf3P8/OeWDKayGswEZBBkLSq9IAOXn/IREiZaznymKFSDIyaHLXXXUF8JRpsx+1Qkl8YouOnfP+lJzTmGPeQagn1PYnYezmDJqjJqKGAxVfVRoBrqQPbd4sCPfCwEN2Atk9sVr5xw1Ge9WdDUxRto8rPF9i92SsiPjX/gJbxlB1ChgqrwO8SioL5QZUxR0ewVT1dZe7qO3mjJKbdJqMsl+oYY9ELdDPrWgAfCJ5OsOMKOVrYjnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BnIlSwJ06iYNjceq+jVzPQMtj9fK4PNS/WWz6aoqcqs=;
 b=VUt9zdyie6NmaaFrpdz2ClAmA3tuTvFardQFA5rLp0bbA8wH5ALui9QO7QOYfdwCPlBn0Xk4Mpe7/xRRGK09ma8o6aadsCLlxmbM1YYW1ep1CWI//tk/1znwP2DJ6eOOt/a9vyh+OFS/ye/AFimn7rqDw5QAW2eDWVqLikMFiYZJ0ICzsWc4rQ/kwf5TPLl74TKL+jJVjRg+BWMOw9LP27zo1UCTElzC2Zl36PqGWYK7zWg/42jfxesj4vVlgnnvHDscxjaN1nh2af7mRDtBfr9DJH130LvPv26EFscihT1DB7Vm6FivShvSVlNfvj+vMKsUJqIiBGNVO+q7YUW8xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnIlSwJ06iYNjceq+jVzPQMtj9fK4PNS/WWz6aoqcqs=;
 b=Zmntj+FZ8YOAmHIQ/r6+7EiwmQ2m7vfQ2vSwv7ryJq1d4WYPNycWjB0Yii6hl/BnEayDxFE+v6fAhhSuHnbcONjkhDPYujabnp3MgoSXLNA7SVFTZB+6l1G64SPP6LZ+qHrw5ViUCoPYxf/osVL0afJtawmPL384CFMTvBO7mIMXC2cQY0lpoXo2uKXPfndAXfdrIkW1DdUp0wofjV1tswAcg2wo9AuPexYgvqjskRchJPUSVRzUbs8dBViObNcxD69FZe71TvQROcqVI0HdjeTFtYB+6jgZyXlP/dc5dblOewXfLd3LRdQLNLkVMlGsJZoY6xcaYClNvypHKtrW3g==
Received: from BN9PR03CA0618.namprd03.prod.outlook.com (2603:10b6:408:106::23)
 by CY5PR12MB6057.namprd12.prod.outlook.com (2603:10b6:930:2e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Mon, 5 Sep
 2022 10:59:22 +0000
Received: from BN8NAM11FT085.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::c1) by BN9PR03CA0618.outlook.office365.com
 (2603:10b6:408:106::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.13 via Frontend
 Transport; Mon, 5 Sep 2022 10:59:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT085.mail.protection.outlook.com (10.13.176.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Mon, 5 Sep 2022 10:59:22 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Mon, 5 Sep 2022 10:59:22 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 5 Sep 2022 03:59:21 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Mon, 5 Sep 2022 03:59:18 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V6 vfio 02/10] net/mlx5: Query ADV_VIRTUALIZATION capabilities
Date:   Mon, 5 Sep 2022 13:58:44 +0300
Message-ID: <20220905105852.26398-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220905105852.26398-1-yishaih@nvidia.com>
References: <20220905105852.26398-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3055b37-5d9d-4e13-4ec2-08da8f2db087
X-MS-TrafficTypeDiagnostic: CY5PR12MB6057:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sb/ccr4Li+ZF1ABnPQMJbO8Zd8G8ozrCl10UwCEByj8K2Rqa56d7gU3z38OvHjyiPrwM7jNujw2daDxe5d7n55QWcLrKc6izSO0I99oaYZCQUHu9KPydzhDkkQgRfwA8ZyH/y2/LPv2PpAgAawJhVdVd2mwzIGQOcp9cqtDSkO0baKoBth+5yE5nVIeGKdjy5kvdCNQGavkLOC/WoblZTmokB5lxJqVfpSbYG37nojF9VfEO5qrxS+mn8eDCgEQkJ6GCCRy9b4bMYYQ0vv/1ZjOTy5FGjWQusYxBhOZ6LzvKtzhlOZqlcj8DRtvnDMd+DfT5/CZo2g6L7cngVqGtQNDXPcpkKdf6bSnH99xIvhvttTkFaaM8g1cJR/8Yr7hUKddZ2vruwjuYF4TkDORabQwwvxHjxSuceEU71h8Hs1ny0yvaDyqjyU9F7MQsq9U+12LIdoNsrOVN693MDpUs9qTX1in8WrERIvQtfZ0fIK/xM7wy/95B4ReWIxzZeD5lg6f8zDeg6mSiDdl0MP7CcQvnlWRrCR336VAYrmxy5NCBZiuV29bm84RtYtjNk0FAG76HRe4Lehc8xedZEb37f1ezILlfY6zfgergU+rV066Sk43yeAHBkb9yz5yAKJOOWajgNXEkTPwAWq3LXpvW7LPRg7lF40PmT98/a9WZhOMmNCRyyzz1hyd8589Jw3AXCLIa8SzaplXLk0+poFHU1D68+cHEgwZm2hgp4sNeBi/lBUJVd/fNeq9AcI7I0QInku47eBNQNrQcJWKAWN4uPsWiITj/ZvOGmCxm9oRzMMLDLwBEwf0mmgfaj1VD3waQ
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(346002)(376002)(39860400002)(40470700004)(36840700001)(46966006)(47076005)(426003)(186003)(1076003)(336012)(2616005)(40480700001)(8936002)(26005)(5660300002)(36756003)(86362001)(478600001)(41300700001)(6666004)(7696005)(40460700003)(82740400003)(356005)(316002)(70586007)(82310400005)(70206006)(36860700001)(54906003)(110136005)(6636002)(2906002)(81166007)(4326008)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 10:59:22.2585
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d3055b37-5d9d-4e13-4ec2-08da8f2db087
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT085.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6057
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
index c085b031abfc..de9c315a85fc 100644
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

