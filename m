Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B5C5AD118
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 13:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238151AbiIELAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 07:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237995AbiIEK7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 06:59:53 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAD71707D;
        Mon,  5 Sep 2022 03:59:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CTxe0fI88nvyn7LEcb13jH91KwlJAxU9VHCqmdjBTUcKCm7r9Z47ZNo8fpsElqsUq4tC9u9f+c3OHBS0/jwcb1huYUKUiSpYNry3LIlqonaC5mCoezp6b08aD3DaHRplnlo3nyOn0wgMYIU50u7WdADyQ7P9qgZHkxNyjINR3jtNGtqu4k66xkZRv5MLj/HuW+ucrt1Y46PQNk+gfwh3Q+IFtEbryvc+wudWtuo38WoyHECbTkvs0/R3Yw/hVIw3kgm64rA8dxADE2YxIrHkCn3ygx46XIknPttS4ya+TDHYvY0D0v8YQxqo8MlKNl9+gimNIZZuOjoNPdGjqQKdHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uE6sjx0oSA79BfIgkJVMlmUd3p6BL3oGNTJ2eCqwAtA=;
 b=BiIGQuqpTmVWatYRlVE4+8hEtPvkQHXTv1RhO2Dz6WGF1yQ6G5jiuraOLR1aapMcBAYNNMD8ZEZazd2qkvRQsLr5ULs5AL4jRkJkUNvHUm5QgJ7Mc/uBt7rdufl9qR+/3ZiODdrFNrnWZw9HD6ttJaLVSUnBvh6o5vkt+8V4FVR74kxQeDIqNmM2znlvMqDe6J4HtvSFICp7qAXzQ7wJjBXgwKSugHvCGJDVguT+Ew+JOO4aJT+We8N7gAzhHKN2hZiCFPMjjCClwvHATHRoQn4bVFAxdSAqXjlLMwUBzJ7OG8DHdCBXLVEK1a9HarbKhdDYrx8qlkg9XJqMaAoLMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uE6sjx0oSA79BfIgkJVMlmUd3p6BL3oGNTJ2eCqwAtA=;
 b=l2STwdazBwwS4G9ipVNDFXUQFhpT6f1eJGcuuVgtih7qRl0yQLHJYopshlqrDprtIoyqwSGE9v5x8+soDK7SkTjT6d8UhQGThebIeod/r9PS4KIUeVuqL0ailKEMhvVbrXDVKZNTbSsVooR42nxgVaFGqoTTzRGpt9904rbt1EDKUm0B5XfSTNoauwLWl5pPOb0QrEKNJg/lZ9RrSkSBwcvFSqJsZixGuYDO4331x0aQTdp0AodCBssoxqk7t2HNpJdnmUij5QVc2on+2rRI9i4ObRhZToS9k1LFQnZwc+38gPLzxYbXM5V42I3sDktzQd4709Qr5/zZm48PHfUeig==
Received: from BN9PR03CA0570.namprd03.prod.outlook.com (2603:10b6:408:138::35)
 by SJ1PR12MB6267.namprd12.prod.outlook.com (2603:10b6:a03:456::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.16; Mon, 5 Sep
 2022 10:59:49 +0000
Received: from BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:138:cafe::82) by BN9PR03CA0570.outlook.office365.com
 (2603:10b6:408:138::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18 via Frontend
 Transport; Mon, 5 Sep 2022 10:59:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT004.mail.protection.outlook.com (10.13.176.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Mon, 5 Sep 2022 10:59:49 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Mon, 5 Sep 2022 10:59:48 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 5 Sep 2022 03:59:48 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Mon, 5 Sep 2022 03:59:45 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V6 vfio 10/10] vfio/mlx5: Set the driver DMA logging callbacks
Date:   Mon, 5 Sep 2022 13:58:52 +0300
Message-ID: <20220905105852.26398-11-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220905105852.26398-1-yishaih@nvidia.com>
References: <20220905105852.26398-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca38ab54-68ba-4e15-098f-08da8f2dc0b8
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6267:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jm8vFtnnjKIxe4w3bb4lGEGibzQBOrqj9D6+GLrHcVFcxZuiY73od3mITEZx/lD0Tloni2miCbXhpzXFyJ3Ya21XJMMSmpQThp3Ld0Fbo8I3FlTOd78dkr/VFTkADSEWB8mXdUI+hTeXxeuNR9Nr6l671G/d3A96ehMle8z8/wUP6AJPuPqOLsawW/SWbAwH8FEXkv/u+912HkGPVvnmBMxGleAywmT+ByK555gLUgg41ZOqgTubJG1PGHO7Fy3ig69A3UWO+n8FuqHwHpt3OZhm9U3bCv3r1Q6BBEIHoqWvSRxablbnD+2wd6HTHbmjWhFLks651vml7/SP7QjCnASxtzqLLtQjNcog6Zyu038nl/AlrjPD8JfR7zWAXZkDDkqsUhMoqACW8yuZdSYNZWiy12/OFpaVI2ElQ2/00o0OK4a+7Pxdz15kkc0oxSA5ji4FMsolBFBC/fAyDjM/mvr/sQh9Nl1mCJAChdPH5GhIKzE95PQGCO7pO0qeRsJbD5NA7H6GEr9x7BZgEGxBvEVQxVYAf2COtigW8wjLx/0axPjDsdUNmFO95NDQ0BiSUqrskWtPzYIBnIXCeU+AgrS0qwpZDYebTFJBR8v3qqMstt0TXpiziRknLZnEC2fWCaIR7Q3Xi0qYqTG5XMwjRK3hGw8my0kw4hx1gJb9UsMqvEBl98jjNpaNo4TegxxA9RTxDEls7H22hPL7N6CNxrdnKF0j1cNBnZOEtvCJQDqqlOPpcTW3reiTUFUhw4wm9NfwstHzo1I7LTxtq+PN72tZorAfFtMzPTjD7TulQhJ5WiotGXAU5EJSaI2ypMzz
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(346002)(39860400002)(46966006)(40470700004)(36840700001)(86362001)(41300700001)(36756003)(8936002)(40480700001)(7696005)(40460700003)(6666004)(70586007)(2906002)(336012)(478600001)(26005)(5660300002)(8676002)(4326008)(70206006)(356005)(83380400001)(1076003)(186003)(36860700001)(82310400005)(82740400003)(6636002)(426003)(47076005)(54906003)(2616005)(316002)(81166007)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 10:59:49.4058
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca38ab54-68ba-4e15-098f-08da8f2dc0b8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6267
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

