Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0635A9368
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 11:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbiIAJl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 05:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233392AbiIAJla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 05:41:30 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2055.outbound.protection.outlook.com [40.107.100.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B62134D68;
        Thu,  1 Sep 2022 02:41:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k9XhS75B/fsn0FWmrZeutgN1W8WGcLqAroKZcykKPU1eie0izw76ThQZi2m9OdqEj5Voo7UmIq3TPHbOSgcVzQgEpefddjGt65m3UPhhJjfSCfsojJD0ri+gDTDB89j8jeNgNKTb4y7TduRbaSdc6ZcdBkOavlF80VSPWguOZkNTxK5N0wb45vj6hL383csT40PI8T0d1dbunoocYGYqeZkJ7WpTVlGLobclipa5K8LhBBcLnioOLahddZwT8Mjd2VDK1tM+rGtene6VwkhGSCNMVKYExhHE2mLVMtCLGjo8i5MGnQ5b52Q4UHlEKCZDD+4uvHMSioTEy+nGYV/4MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uE6sjx0oSA79BfIgkJVMlmUd3p6BL3oGNTJ2eCqwAtA=;
 b=fJ4/3Ihu8f2qif3itaCxQCgJP8C+h8fNcNH95Af+tV9HwlhbaP56JNgPjfxCByq+hzuNTh9CxYQD7N5DzaPq4FNL68SwwUuKiwduUVHcxRwNyaoDXWJlpG/3+1mcG5sD7UOWnA3BtK9A46tEmD0sVkFHpOIlpfGwxQhGz5iOGn6v875vWbqpBmi4zlcWRYH6/81QTEDY8p6x67QCktWSGd+zF4PJdWmUO/XUfwU0lDTk7QCwGaMWqsv2bkfMlZ6fehcW0YAj/6g428gTrXgSCHLvn/7+CTcmZHPXXzvIEYehikF6DsIlyRYgUKo61V+VVjM1+/IJYJ2GF9HfLky4lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uE6sjx0oSA79BfIgkJVMlmUd3p6BL3oGNTJ2eCqwAtA=;
 b=XFtIboH1+2ONoU/h4ea3DuPzXTXB4QBF034mYBR072Cm80jw53CqCgxJTQr9DSQIXENrxnVNPnozWO5+rdCphH8D1in2PcSbG0+1JEzYKkxt+O80qaHuYh5ilyX2wmZ7TUHmtZMT5ccNFmvBX9f+3pNZn52I7bKU+7UxbABupdlU7G6mr4R033lvydnoyjq0KccayyBrP+vv8V44Ys4bDkryRq68Xx19U/r+Gsx8svM1IqUyGktC9xEa1m1fitBFn88pzJtPEXB1sQF7KKh/mstf20ev1saGGCtdbDBnm6RqsiI/uzgPPUwwygT18En99DDGCw8p08eLAX5OchUrpg==
Received: from DM6PR07CA0038.namprd07.prod.outlook.com (2603:10b6:5:74::15) by
 MN2PR12MB4503.namprd12.prod.outlook.com (2603:10b6:208:264::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 09:41:26 +0000
Received: from DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::84) by DM6PR07CA0038.outlook.office365.com
 (2603:10b6:5:74::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.13 via Frontend
 Transport; Thu, 1 Sep 2022 09:41:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT096.mail.protection.outlook.com (10.13.173.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Thu, 1 Sep 2022 09:41:26 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Thu, 1 Sep 2022 09:41:02 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Thu, 1 Sep 2022 02:41:02 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Thu, 1 Sep 2022 02:40:59 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V5 vfio 10/10] vfio/mlx5: Set the driver DMA logging callbacks
Date:   Thu, 1 Sep 2022 12:38:53 +0300
Message-ID: <20220901093853.60194-11-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220901093853.60194-1-yishaih@nvidia.com>
References: <20220901093853.60194-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba4c36c7-f528-44c0-2b2c-08da8bfe23ba
X-MS-TrafficTypeDiagnostic: MN2PR12MB4503:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 743Vt38QdsOUlonVq2J/6g9OmEJkOvcg7EMmH6juffLV+mv/va7C3aJ4Q0vAwptF5KkI3E7BuhUojBu50Xejow95WaiXF0soyfkKggCO/YBw0XgrfktTMGk2ss5/Cy/x9mjz2e4OHa3i/6R9ghSt9SMdzsKUzdcEdim0MnJYJG7+kd3qsrdq3tuGn9yMDGANAT0+spM26qmXr60URCd830li1c2yspN7MXgRUkkEtpS81hk+JyN9GYuWwhZhks5rYaWrlRngJFb+u1P/zpIwtt8FoGnI9q7MJ3gKljbM333a+815Sz90t6lcrhIWIQZ7hDmJUqY40SmubiEwrp1W0zZ12EwM3jn2e2E0nF7sTvpqUspgMWKQ++KtjDlTR6puVgPLyCXQW86jyoPd+7rc3iFhrzeLJvHwEKIHOE5VfScw6Sn+sh80zKO/9gDfEm7SVHKpQActtCa9WxQFkWinYg3Bcbdhk3UVin81uVY7A/i36QTa4aDJIzadT63iZZr3AnOTAt34vj2hmW46LZpy/Ij9jhwm+ZRSTzSS/BU0G5O3g0ev/VLs7S7TemrNVCawNViZf+axunUCguDiJ8jsCYZTh7UvpqxPF8JJz5HAAR869VKOAVmPVsfTQdG3IpXxFSn5GG2Os/9z61bJygZAo2kr/U7LT770BJA0MOLxtJJKwGh75p8e/l8q7h+xEHRLz9BZqpNX3/9Cp63q3mR0Tq28Iup7jUEUfUHyhSs4YcB8Zg2Wrbu0ZDCRg84xiuBrK7OT7e74kbD126oNuJP+6z/DOY/tMqgeFpjD06uTw7/imRV9n8Xc6zeDIAaVlnDn
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(39860400002)(396003)(36840700001)(46966006)(40470700004)(110136005)(8936002)(6636002)(81166007)(83380400001)(5660300002)(54906003)(86362001)(36756003)(316002)(2616005)(186003)(1076003)(336012)(82310400005)(82740400003)(47076005)(36860700001)(70586007)(70206006)(478600001)(8676002)(4326008)(40460700003)(426003)(41300700001)(26005)(40480700001)(2906002)(7696005)(356005)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 09:41:26.2453
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba4c36c7-f528-44c0-2b2c-08da8bfe23ba
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4503
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that everything is ready set the driver DMA logging callbacks if
supported by the device.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 5 ++++-
 drivers/vfio/pci/mlx5/cmd.h  | 3 ++-
 drivers/vfio/pci/mlx5/main.c | 9 ++++++++-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 3e92b4d92be2..c604b70437a5 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -126,7 +126,8 @@ void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev)
 }
 
 void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
-			       const struct vfio_migration_ops *mig_ops)
+			       const struct vfio_migration_ops *mig_ops,
+			       const struct vfio_log_ops *log_ops)
 {
 	struct pci_dev *pdev = mvdev->core_device.pdev;
 	int ret;
@@ -169,6 +170,8 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
 		VFIO_MIGRATION_P2P;
 	mvdev->core_device.vdev.mig_ops = mig_ops;
 	init_completion(&mvdev->tracker_comp);
+	if (MLX5_CAP_GEN(mvdev->mdev, adv_virtualization))
+		mvdev->core_device.vdev.log_ops = log_ops;
 
 end:
 	mlx5_vf_put_core_dev(mvdev->mdev);
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 8b0ae40c620c..921d5720a1e5 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -118,7 +118,8 @@ int mlx5vf_cmd_resume_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod);
 int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 					  size_t *state_size);
 void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
-			       const struct vfio_migration_ops *mig_ops);
+			       const struct vfio_migration_ops *mig_ops,
+			       const struct vfio_log_ops *log_ops);
 void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev);
 void mlx5vf_cmd_close_migratable(struct mlx5vf_pci_core_device *mvdev);
 int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index a9b63d15c5d3..759a5f5f7b3f 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -579,6 +579,12 @@ static const struct vfio_migration_ops mlx5vf_pci_mig_ops = {
 	.migration_get_state = mlx5vf_pci_get_device_state,
 };
 
+static const struct vfio_log_ops mlx5vf_pci_log_ops = {
+	.log_start = mlx5vf_start_page_tracker,
+	.log_stop = mlx5vf_stop_page_tracker,
+	.log_read_and_clear = mlx5vf_tracker_read_and_clear,
+};
+
 static const struct vfio_device_ops mlx5vf_pci_ops = {
 	.name = "mlx5-vfio-pci",
 	.open_device = mlx5vf_pci_open_device,
@@ -602,7 +608,8 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 	if (!mvdev)
 		return -ENOMEM;
 	vfio_pci_core_init_device(&mvdev->core_device, pdev, &mlx5vf_pci_ops);
-	mlx5vf_cmd_set_migratable(mvdev, &mlx5vf_pci_mig_ops);
+	mlx5vf_cmd_set_migratable(mvdev, &mlx5vf_pci_mig_ops,
+				  &mlx5vf_pci_log_ops);
 	dev_set_drvdata(&pdev->dev, &mvdev->core_device);
 	ret = vfio_pci_core_register_device(&mvdev->core_device);
 	if (ret)
-- 
2.18.1

