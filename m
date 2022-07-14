Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5B8574682
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 10:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbiGNIQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 04:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232449AbiGNIP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 04:15:27 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33AC3CBDD;
        Thu, 14 Jul 2022 01:15:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iha49JZN5jxGWQTQ2fodjiR6KUCnLAnPSv70sp7xClSgCLlhGjpMk5dpgot2stdh+qmZ/RmBIWmDnvpVWCGbRjbwBA82MQkT0XS5RcUvTM2StX4LZMCMlXdN/OCMmm1+5FvgFgMLf2T5ecINnnzk7T2Qg00zW7N8Y9g4kAtnZpKejgofw2lHWusMOXMj/aBLkRdxX5JyxvtWIeLSjzcsfIlIPK1iQ+ibxfumNERHdPNOvjUjCJJ1OZfHx2K76DJBWZG8om3a9AUSVzeQTLcuhqB+IhnvCQi00sZyUhnIS7GusSjIwvikZdApiGsdPe0jiv80IVGwKH/jTijVdfK0tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uE6sjx0oSA79BfIgkJVMlmUd3p6BL3oGNTJ2eCqwAtA=;
 b=BN7mOYDaxMLQ0qhgm8n2k1pOMuG0snU4wJfa5zjqiDLEvTiwEVmH9lz4BuXYl+vbDPRkXHj8lPbKLE2T5ZUAH9bfVEXtd2LKVcd7E9mfbN3/HWhNUDAgR+kNos/KTaoLAZgS6pVd/9Bzc8DlDqGYnR4C2GuqsdY9zVI89kyUpr9FeinbbnjFGz9/ZL3ijbWSnP88FTdr88vicDTLgJaRmSRBGQv5HoGpEXoR6TASyrc4jf9fpZfOQcX4ppMUKxzkSYp5n4sNYzp6+IsaL9zcSvVOuKv5IMIqTgOMrMoERnD/XUBsV2H2hPhD/WL7dCyS/5n38+tv+mh7uWPXyxfzmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uE6sjx0oSA79BfIgkJVMlmUd3p6BL3oGNTJ2eCqwAtA=;
 b=sGjOiiZJZuDpGDpLfM85+kPsLre1rnE5O5x4yfOCc8V7Z0uP/PY9Q0mWeMSIcfYJjasgHa4UZlF2AkaxbVrlk7/bibrYOOALHCUt88INxuH1cW6C4mG9VN9hy6b2MkBeRhsj4QmYRq4FUTzcbZoBmAuCQ+T1IiATXFc5BH6TBoX20KItbJD642Woq5I6ibeHHgzhX3dEnGUj+IIWLqCTLj14pmibBqRZTeVXjLnbBVd0FN68MYRvoxxl4InXI2QJN9ZUSWgZYqEimRB2OqsZIfQciJ6vqSSc3G39Kvzq6FGkLgtkt2EMhwT+mg7g/wZJgU2apcX4AiFjAGbHvLRyCw==
Received: from MW3PR06CA0017.namprd06.prod.outlook.com (2603:10b6:303:2a::22)
 by DM6PR12MB4879.namprd12.prod.outlook.com (2603:10b6:5:1b5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Thu, 14 Jul
 2022 08:15:04 +0000
Received: from CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::f6) by MW3PR06CA0017.outlook.office365.com
 (2603:10b6:303:2a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.22 via Frontend
 Transport; Thu, 14 Jul 2022 08:15:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT015.mail.protection.outlook.com (10.13.175.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Thu, 14 Jul 2022 08:15:04 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 14 Jul 2022 08:15:03 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 14 Jul 2022 01:15:03 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 14 Jul 2022 01:14:59 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V2 vfio 11/11] vfio/mlx5: Set the driver DMA logging callbacks
Date:   Thu, 14 Jul 2022 11:12:51 +0300
Message-ID: <20220714081251.240584-12-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220714081251.240584-1-yishaih@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56d0170d-e9ec-4bcb-f3f3-08da6570f4cf
X-MS-TrafficTypeDiagnostic: DM6PR12MB4879:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5cmIoEkzdmbB2ELzp/0BoGV0Pry0AQK/yddp2tZycJZ7625/gsqDukQZ9DfUzruRrx/loF0OGo7g+Dz9KTvKCEypJ9j6ONV9tJ+sPgtRhhzyYNKsZV7e5tmbeS2IKs3uoNIEwLcvwhiMS7pjKvWk4rKXl7PuoO+a1SKnMvHic97hHmUZifVqBI61PKIsU/9EouviOcN2i/ArLZvaCq78R/s8rQmsVxGlkrFqEs2FQyKC5OQqLShDHp1foW/ip5geJ6X29QmNF8Mqri/eaidTorRIOsSxVsqBQnM5fxMQ2d4UK5pgXH58rpiSLBkAArKFW2CFt5PdvUIJwVcXT85uhj/Id+2ueEVmExBtfqonp+HGEG/cnBA3NJF7CA3az7MU2aOEvTeTBZBU7m6FduJGVR8+1kLWlBwwpLMwzcyyPzYZ/bQjtlYtX+sfO3nkIW2f2HzOyoCeP4+hzhKEIwqa7knrnKqR9Ht5bonFQ5JlpYJzer80RNWLNlv3vADflkoi/sEQic4cmir6xjqovs11p5L2cRR7kymz9Hd4sgDT8MF10kiibOMAms+GluSI1puqVOa1P9ZCEDoydsIKNgc5sTgKibkGaeJ1bD+Mza33BUlnlNTkV9dJlaXA6W1JRHmU+yyZz2tYxA7wDCW+HKtiYueqmwEyUmYbFTiS/k1ZlHMlwaqPVXHgczfmZP5Xk/gRa/U6xKgrJ3S5EJu85iCuJSpBFJVH+QwFNPYYO4sMOSJEp47Ej4fSYAnJp51r71aqILxTJCk3Lzfhg7T/xIKd7CVdOlZBcPAIk+ROUoGdtOBm/3d4DfBb4R9Vnel8w2rvpBO3djk6msC8JAKgUVOz9MCF+CEx91zoXT1BcZ1JL+Y=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(396003)(39860400002)(40470700004)(46966006)(36840700001)(82310400005)(6666004)(40460700003)(40480700001)(316002)(83380400001)(2906002)(356005)(41300700001)(478600001)(26005)(36756003)(7696005)(54906003)(110136005)(6636002)(86362001)(1076003)(70206006)(81166007)(2616005)(82740400003)(336012)(36860700001)(47076005)(8676002)(5660300002)(8936002)(186003)(426003)(4326008)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 08:15:04.3264
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56d0170d-e9ec-4bcb-f3f3-08da6570f4cf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4879
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

