Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 507C4585F0E
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 14:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237210AbiGaM50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 08:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237220AbiGaM5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 08:57:01 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16627DFCA;
        Sun, 31 Jul 2022 05:56:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OCgH8NY8tpEK4Pi0dUEPGCg8za38ivnwq8Owg783dK4CluixlJJDgjHsbPsfqNfTn+V90ZOyGwBiIatKY5/kEM4qoKR+zYIf64519o0lFUwd44uFefGRqg/M07eJiYvUKC/uVd77BNtF3Jr5ze3NRYI7YS4kjSriDM9LrrJAj/eh+79UTuy1YerwswSe+uh8zSlUd5NKb0ugXqMQy14JgRm0lqDxWhBgbxutgFfL8janxwezNKRtP1Q8RxcgJMcpFBhPnRAkTLrzX8OCpDGadzbhv1NZ9ujVF+IUdMO/sQrHBiJlLLXYC0theNcidtobfFHbhi2ni9aVzcIqD231iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uE6sjx0oSA79BfIgkJVMlmUd3p6BL3oGNTJ2eCqwAtA=;
 b=CkYn0hU2/CljtZhPT0y2qn5qkwVu2MUAsFiRZjBJJr8TrOUHoAgcQdGKGOwD66N10CZEX+BKLLRaTTI+dJZZtf7Eq51fJMT2yfkTYHuZ/WhJLvFzUTP9rl07gRgAmMcnSsBWQ+AvpAzYbfC4ZIg/ytUDxcBxdSU223cYbRHlV9CEk2kQ6Ik/UuMddoiK0jyfSQ/W2iFxORY6ZqiLAuHUF5Jl9akPc1tXkOU3RHwS8MqLG1gyc0dYG9lSbzu/E/SYBb1pbT5uxN5gN4dHrsnP7CWDiwy/Mkjvx7+/c0tT6LAUFTQe3McrCwoxMftTtKcQVwhWrydEoFQGOA8GiyuTLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uE6sjx0oSA79BfIgkJVMlmUd3p6BL3oGNTJ2eCqwAtA=;
 b=rHeNxoTdy3ru9xyZu0r8EnsSweXt7Sj3JTcp05cKtM9kmosgeDm7O9ynj1HzD8AgaONKCZMEh1AmgLpi0APlTp37MwRWjREPX8zlkYtOpSzcNz9yb4EpQZ/JVHLNJOfRT4xsFvabNofdLRti90dTOvNn2DAD3vVmtgbdz6+GR+GQfl7ccifA5WOU3v6oG7duUshGfwYmQprG3BubNEn7+oU62oKLu2i8cvpdQmbk583qx9Y0W2RAwhWVNMooxn2AqZgHQLvRni+WmvmeKszn6cUlGOlUtJO6mj+Q9FPFqGaDRlE8ShjVMIP+EMYYpz0tG8lspoGLV25yKkCvBmw2/w==
Received: from DM6PR11CA0035.namprd11.prod.outlook.com (2603:10b6:5:190::48)
 by PH7PR12MB7017.namprd12.prod.outlook.com (2603:10b6:510:1b7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12; Sun, 31 Jul
 2022 12:56:38 +0000
Received: from DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:190:cafe::b3) by DM6PR11CA0035.outlook.office365.com
 (2603:10b6:5:190::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14 via Frontend
 Transport; Sun, 31 Jul 2022 12:56:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT055.mail.protection.outlook.com (10.13.173.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Sun, 31 Jul 2022 12:56:38 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 31 Jul
 2022 12:56:37 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 31 Jul
 2022 05:56:36 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Sun, 31 Jul
 2022 05:56:33 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V3 vfio 11/11] vfio/mlx5: Set the driver DMA logging callbacks
Date:   Sun, 31 Jul 2022 15:55:03 +0300
Message-ID: <20220731125503.142683-12-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220731125503.142683-1-yishaih@nvidia.com>
References: <20220731125503.142683-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6b5f938-d15e-4166-6f75-08da72f41b44
X-MS-TrafficTypeDiagnostic: PH7PR12MB7017:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tweNy3qXdb6WWpYrflggDhFe54gtbZr2lvuZXq0vXf7TpVDaHxmk+ldYz+MqEtEoPoTEZCzLotT8ibXmHn6g2ILmpo+4oba5HVR9oDfbf4xe35ABfK2bObKfGaBeyG+kjJsLYpD/hL7KVKjV0rBz8UdpXGrxWyh2MJl1PVdvS0Qm2YQk4rhSfHkwKmZw19/rEM/dABxUUGDiTy8vKfKnTVIxH7+pkBykLlXfSMst790GIe29Fn3f9hT1Fm4blYCmmKR9T4xQoHYp0J5FDm9AJhXldXewRtlabFBMt/aRF5snA2a7jc2djUuLxXYIH26sXpOLjdHxwUKMIUrS6pLD2/JhvQCBU9b1/JDIUjyDICZDbCKWlUHxpfbhVFvBAY4Yv78oSeaf2YuOcApQ5sYgu2Py4oO8t0ZN+PPOEfPHSGfV5LNfRVx/t60peszMXfdO5AbVxxL88o5CXo6PRRDMIUYLywms9WYAH/Qoz6LLAGHRwYhbb+E5Hg6U20OFKx4IUxGl4GOcDatOJwLngnvTZl4b4rSj1dOcPSaNCBmDPEpuQfhsTvsXOObbCKFawK9j4xznZR/hvXjhcpN4Z/Qz6AxxSDIV6slHG1r/9VzZlmr9mEIst7M8V0ApAvgxkV7x9cyhKKnq/rLL+AaqVNNHI2g1xdGYqbx6f4HwpFcHgNWPewPoYpITQKP2mShqW8CbGg1/xgMDv1paZ9l1ZcySszR3bK9MT7YtBGlW9zPiFECFAtrvzcDcBGp49qDENmiR+YMo0m2ztlxhjSX2XfUvGQlMLntPeY5oepGivOaD8eogjexlyhoBeaLMauod/7/KVUSh8SPyH1UUC4NL5+Nt2Q==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(136003)(376002)(39860400002)(36840700001)(40470700004)(46966006)(1076003)(186003)(83380400001)(2616005)(70206006)(8676002)(70586007)(4326008)(82310400005)(40480700001)(86362001)(36756003)(426003)(2906002)(336012)(81166007)(356005)(47076005)(36860700001)(5660300002)(8936002)(82740400003)(54906003)(41300700001)(110136005)(6666004)(478600001)(7696005)(316002)(40460700003)(6636002)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2022 12:56:38.0153
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6b5f938-d15e-4166-6f75-08da72f41b44
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7017
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

