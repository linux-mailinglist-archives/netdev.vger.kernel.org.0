Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1505617DD
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbiF3K1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbiF3K0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:26:52 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4374F646;
        Thu, 30 Jun 2022 03:26:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ezuKIhmhtbbkRlIMq94xntYNA57h0Yk8XBrU9VH4jKjJqJ9cJYikFANQ/Okt02AfpIYtGBiV22D/vP6PJ0Opp+5NAOb1fQ5tBp7Vw57zNXaP4JZLu6E+rTmnxS2DJC7J8HjRqcNIqDNcL90DfMV251l3mlR8Zd2gb3ttd9pCH2nuPJAkem7WBo70FOwKKbToU0+PsInx/i78Yo43AUEsIRCeAOiITonfAh8u8q8lsD0+KePy7qyUHrmLfNdIax887ky4R1DUK00KuI66mt7y24yRqOjFlEZ2OF/sbvx08fKiSrP/G8xbp4gQQiTHxSCIkGLhScN7m18qMLu8VySt3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/y6m8YqO2bO7jLDKjYVSYMXd4szDRHMsrnudh9HESYA=;
 b=BJAyl61iTglriAU4U+wdKeYlfBzJKX896ru383FQx7rI30e/ThE/tyGtdz3tHEiKm6vPh4yGbFOfIAAQhR3czASibL0hNJt/h86IXCC8A7i7NTUzAhGYoSj7E8ALYH1nXccmlkHwKH+V99NlcxKF8CKswtQurlJdCZ6yqwfNL/GiFcwL8j9K6gd4C78w5cPR3v0Y4vlxRd173p8X6mfPTowD940I9+cbYbio1quzcMLUMj2rSb+K8TZsQ9wT3QXFwiuPBQTin1TujzGTyUxl97sPDnbeIU2wa/J1MdgeAd7U1fl3ScIry37V9Ot9q8NEbMq6HlnI3YbJsIDhphAjag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/y6m8YqO2bO7jLDKjYVSYMXd4szDRHMsrnudh9HESYA=;
 b=bcT6lMcv7ejtsMJJpUqpVqAsVJ2ax6TB/b1YBnKRQQi4oT0ndpvfWuUgqpqVeNsXGKny4BERW2jla92LuDn92oi2I1KFBde32KvNREkBxfuqW6sGAaj2kkBYNR3+Idk3vMJE9KjrmMw7qHgmkXPLm1DcUrMZwQp9YqHV09OHRhqzwayQwER1rQz1+YvZZtJzZnTh487s5SmDxyBiHCSGB/rUuBy7ZTjUkXOo7BwHhPnKGGuJYCD5idmCBnPxDjzhtsGnV3b34R/aqqq1FoOIjdpXichFL/LBn6wMc9NofEaNc6seFwzljoqlgbZK+NmHkhtv3J3pT/bgdCdjpTybNQ==
Received: from BN8PR16CA0024.namprd16.prod.outlook.com (2603:10b6:408:4c::37)
 by BN6PR12MB1395.namprd12.prod.outlook.com (2603:10b6:404:1f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 30 Jun
 2022 10:26:35 +0000
Received: from BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:4c:cafe::3b) by BN8PR16CA0024.outlook.office365.com
 (2603:10b6:408:4c::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.21 via Frontend
 Transport; Thu, 30 Jun 2022 10:26:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT028.mail.protection.outlook.com (10.13.176.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Thu, 30 Jun 2022 10:26:35 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 30 Jun 2022 10:26:34 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 30 Jun 2022 03:26:32 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 30 Jun 2022 03:26:29 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH vfio 02/13] vfio: Split migration ops from main device ops
Date:   Thu, 30 Jun 2022 13:25:34 +0300
Message-ID: <20220630102545.18005-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220630102545.18005-1-yishaih@nvidia.com>
References: <20220630102545.18005-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17b36582-017c-4f71-1113-08da5a83027c
X-MS-TrafficTypeDiagnostic: BN6PR12MB1395:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2bWSoM5bJ62A0vLo/e4vbivJbBGgmU+62wgDOVsuuGIqFcYpr8ZOmM8z53DdjyCy359zjVYtVWv5Z2Z4NUv2MXeeT+DWPWCmsKLlQevnrBHAV3SxDNZxvUPw+IeOPkfW0FRulE4M8Lr84yPvXYtt0w2Z+kf7096niyt6QuIY7+Jd5AeF83AZ16fMz+wPKX3nQ3hK5QKv2z51ShBOEqrFKBwDTNx5Xmb1exFwcVGSdm7Y/7WQ9Pg87dA4/O2/IWAMb3by08O3iE6w2odvQdA24ZrZqWwvIjWZG2uodeEtU0pA8vgvjxqvtvXdHl0R+7OmP95vc2WQA+XU654Jq0EWbnK9QLTVie27RGm+2V8ko6q1fEpzmiCS6h8MROkt3tMcmKUJNCZQIqy14VTuYdlupvJD5PHnkW94ud1RpCFrbuty73yDkw7Md+llHug0XIgx4VV31aO2IVJxPOrHSlrcm6pqSMd0YluuEIrB2KC19hKzqkKd7UaTyRfnYE0V77uxUc1iWPH31DSNl5gJ8b3AEsWOeJ/j7IQ0QhQ9gRMixSEHq2mEVik5stVO8cciMKlI7b37tZiC8ASBAYlgbMZrQgo8YMKdnzl/fWKAh//aXULWavcdu90dPMAcO67/OmPEzukQptgHcdS/qkrtTb+tpcYp35Of+9IwzGEXrNMxPVzbjdIQocCuFjgP4isG3wA6VUhSF8Y0vMLamI3OcFuzEE+iZE77tCFOLZieDbaQaCgNzUuzt57WWAjhYz9DZPhh3Ya/zyrYH52JgP0ncO0HZ2Zk5Dok3HrSQ717bYhiwQN5qfqQgvejfZWjEvBpyOH4E5xSlhajflZGtHrG5XxtlbgTUuCmPJMapkF/T47GflA=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(346002)(376002)(46966006)(40470700004)(36840700001)(7696005)(26005)(336012)(5660300002)(186003)(1076003)(426003)(54906003)(47076005)(316002)(6666004)(4326008)(110136005)(30864003)(8676002)(70586007)(2616005)(41300700001)(2906002)(8936002)(70206006)(6636002)(36860700001)(82310400005)(83380400001)(40480700001)(478600001)(36756003)(82740400003)(40460700003)(356005)(81166007)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 10:26:35.2903
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17b36582-017c-4f71-1113-08da5a83027c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1395
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vfio core checks whether the driver sets some migration op (e.g.
set_state/get_state) and accordingly calls its op.

However, currently mlx5 driver sets the above ops without regards to its
migration caps.

This might lead to unexpected usage/Oops if user space may call to the
above ops even if the driver doesn't support migration. As for example,
the migration state_mutex is not initialized in that case.

The cleanest way to manage that seems to split the migration ops from
the main device ops, this will let the driver setting them separately
from the main ops when it's applicable.

As part of that, validate ops construction on registration and include a
check for VFIO_MIGRATION_STOP_COPY since the uAPI claims it must be set
in migration_flags.

HISI driver was changed as well to match this scheme.

This scheme may enable down the road to come with some extra group of
ops (e.g. DMA log) that can be set without regards to the other options
based on driver caps.

Fixes: 6fadb021266d ("vfio/mlx5: Implement vfio_pci driver for mlx5 devices")
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 11 +++++--
 drivers/vfio/pci/mlx5/cmd.c                   |  4 ++-
 drivers/vfio/pci/mlx5/cmd.h                   |  3 +-
 drivers/vfio/pci/mlx5/main.c                  |  9 ++++--
 drivers/vfio/pci/vfio_pci_core.c              |  7 +++++
 drivers/vfio/vfio.c                           | 11 ++++---
 include/linux/vfio.h                          | 30 ++++++++++++-------
 7 files changed, 51 insertions(+), 24 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 4def43f5f7b6..ea762e28c1cc 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1185,7 +1185,7 @@ static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
 	if (ret)
 		return ret;
 
-	if (core_vdev->ops->migration_set_state) {
+	if (core_vdev->mig_ops) {
 		ret = hisi_acc_vf_qm_init(hisi_acc_vdev);
 		if (ret) {
 			vfio_pci_core_disable(vdev);
@@ -1208,6 +1208,11 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
 	vfio_pci_core_close_device(core_vdev);
 }
 
+static const struct vfio_migration_ops hisi_acc_vfio_pci_migrn_state_ops = {
+	.migration_set_state = hisi_acc_vfio_pci_set_device_state,
+	.migration_get_state = hisi_acc_vfio_pci_get_device_state,
+};
+
 static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
 	.name = "hisi-acc-vfio-pci-migration",
 	.open_device = hisi_acc_vfio_pci_open_device,
@@ -1219,8 +1224,6 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
 	.mmap = hisi_acc_vfio_pci_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
-	.migration_set_state = hisi_acc_vfio_pci_set_device_state,
-	.migration_get_state = hisi_acc_vfio_pci_get_device_state,
 };
 
 static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
@@ -1272,6 +1275,8 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
 		if (!ret) {
 			vfio_pci_core_init_device(&hisi_acc_vdev->core_device, pdev,
 						  &hisi_acc_vfio_pci_migrn_ops);
+			hisi_acc_vdev->core_device.vdev.mig_ops =
+					&hisi_acc_vfio_pci_migrn_state_ops;
 		} else {
 			pci_warn(pdev, "migration support failed, continue with generic interface\n");
 			vfio_pci_core_init_device(&hisi_acc_vdev->core_device, pdev,
diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index cdd0c667dc77..dd5d7bfe0a49 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -108,7 +108,8 @@ void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev)
 	destroy_workqueue(mvdev->cb_wq);
 }
 
-void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev)
+void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
+			       const struct vfio_migration_ops *mig_ops)
 {
 	struct pci_dev *pdev = mvdev->core_device.pdev;
 	int ret;
@@ -149,6 +150,7 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev)
 	mvdev->core_device.vdev.migration_flags =
 		VFIO_MIGRATION_STOP_COPY |
 		VFIO_MIGRATION_P2P;
+	mvdev->core_device.vdev.mig_ops = mig_ops;
 
 end:
 	mlx5_vf_put_core_dev(mvdev->mdev);
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index aa692d9ce656..8208f4701a90 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -62,7 +62,8 @@ int mlx5vf_cmd_suspend_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod);
 int mlx5vf_cmd_resume_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod);
 int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 					  size_t *state_size);
-void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev);
+void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
+			       const struct vfio_migration_ops *mig_ops);
 void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev);
 void mlx5vf_cmd_close_migratable(struct mlx5vf_pci_core_device *mvdev);
 int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index d754990f0662..a9b63d15c5d3 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -574,6 +574,11 @@ static void mlx5vf_pci_close_device(struct vfio_device *core_vdev)
 	vfio_pci_core_close_device(core_vdev);
 }
 
+static const struct vfio_migration_ops mlx5vf_pci_mig_ops = {
+	.migration_set_state = mlx5vf_pci_set_device_state,
+	.migration_get_state = mlx5vf_pci_get_device_state,
+};
+
 static const struct vfio_device_ops mlx5vf_pci_ops = {
 	.name = "mlx5-vfio-pci",
 	.open_device = mlx5vf_pci_open_device,
@@ -585,8 +590,6 @@ static const struct vfio_device_ops mlx5vf_pci_ops = {
 	.mmap = vfio_pci_core_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
-	.migration_set_state = mlx5vf_pci_set_device_state,
-	.migration_get_state = mlx5vf_pci_get_device_state,
 };
 
 static int mlx5vf_pci_probe(struct pci_dev *pdev,
@@ -599,7 +602,7 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 	if (!mvdev)
 		return -ENOMEM;
 	vfio_pci_core_init_device(&mvdev->core_device, pdev, &mlx5vf_pci_ops);
-	mlx5vf_cmd_set_migratable(mvdev);
+	mlx5vf_cmd_set_migratable(mvdev, &mlx5vf_pci_mig_ops);
 	dev_set_drvdata(&pdev->dev, &mvdev->core_device);
 	ret = vfio_pci_core_register_device(&mvdev->core_device);
 	if (ret)
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a0d69ddaf90d..2e003913c561 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1855,6 +1855,13 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
 		return -EINVAL;
 
+	if (vdev->vdev.mig_ops) {
+		if (!(vdev->vdev.mig_ops->migration_get_state &&
+		       vdev->vdev.mig_ops->migration_set_state) ||
+		    !(vdev->vdev.migration_flags & VFIO_MIGRATION_STOP_COPY))
+			return -EINVAL;
+	}
+
 	/*
 	 * Prevent binding to PFs with VFs enabled, the VFs might be in use
 	 * by the host or other users.  We cannot capture the VFs if they
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 61e71c1154be..aac9213a783d 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1541,8 +1541,7 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
 	struct file *filp = NULL;
 	int ret;
 
-	if (!device->ops->migration_set_state ||
-	    !device->ops->migration_get_state)
+	if (!device->mig_ops)
 		return -ENOTTY;
 
 	ret = vfio_check_feature(flags, argsz,
@@ -1558,7 +1557,8 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
 	if (flags & VFIO_DEVICE_FEATURE_GET) {
 		enum vfio_device_mig_state curr_state;
 
-		ret = device->ops->migration_get_state(device, &curr_state);
+		ret = device->mig_ops->migration_get_state(device,
+							   &curr_state);
 		if (ret)
 			return ret;
 		mig.device_state = curr_state;
@@ -1566,7 +1566,7 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
 	}
 
 	/* Handle the VFIO_DEVICE_FEATURE_SET */
-	filp = device->ops->migration_set_state(device, mig.device_state);
+	filp = device->mig_ops->migration_set_state(device, mig.device_state);
 	if (IS_ERR(filp) || !filp)
 		goto out_copy;
 
@@ -1589,8 +1589,7 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
 	};
 	int ret;
 
-	if (!device->ops->migration_set_state ||
-	    !device->ops->migration_get_state)
+	if (!device->mig_ops)
 		return -ENOTTY;
 
 	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_GET,
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 49580fa2073a..4d26e149db81 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -32,6 +32,11 @@ struct vfio_device_set {
 struct vfio_device {
 	struct device *dev;
 	const struct vfio_device_ops *ops;
+	/*
+	 * mig_ops is a static property of the vfio_device which must be set
+	 * prior to registering the vfio_device.
+	 */
+	const struct vfio_migration_ops *mig_ops;
 	struct vfio_group *group;
 	struct vfio_device_set *dev_set;
 	struct list_head dev_set_list;
@@ -61,16 +66,6 @@ struct vfio_device {
  *         match, -errno for abort (ex. match with insufficient or incorrect
  *         additional args)
  * @device_feature: Optional, fill in the VFIO_DEVICE_FEATURE ioctl
- * @migration_set_state: Optional callback to change the migration state for
- *         devices that support migration. It's mandatory for
- *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
- *         The returned FD is used for data transfer according to the FSM
- *         definition. The driver is responsible to ensure that FD reaches end
- *         of stream or error whenever the migration FSM leaves a data transfer
- *         state or before close_device() returns.
- * @migration_get_state: Optional callback to get the migration state for
- *         devices that support migration. It's mandatory for
- *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
  */
 struct vfio_device_ops {
 	char	*name;
@@ -87,6 +82,21 @@ struct vfio_device_ops {
 	int	(*match)(struct vfio_device *vdev, char *buf);
 	int	(*device_feature)(struct vfio_device *device, u32 flags,
 				  void __user *arg, size_t argsz);
+};
+
+/**
+ * @migration_set_state: Optional callback to change the migration state for
+ *         devices that support migration. It's mandatory for
+ *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
+ *         The returned FD is used for data transfer according to the FSM
+ *         definition. The driver is responsible to ensure that FD reaches end
+ *         of stream or error whenever the migration FSM leaves a data transfer
+ *         state or before close_device() returns.
+ * @migration_get_state: Optional callback to get the migration state for
+ *         devices that support migration. It's mandatory for
+ *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
+ */
+struct vfio_migration_ops {
 	struct file *(*migration_set_state)(
 		struct vfio_device *device,
 		enum vfio_device_mig_state new_state);
-- 
2.18.1

