Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB17B5617F6
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbiF3K1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235004AbiF3K1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:27:19 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2069.outbound.protection.outlook.com [40.107.94.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852B619003;
        Thu, 30 Jun 2022 03:27:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mykKvHI+nYzUMHoPXsiCjwnCGyjc4Fy3AZ/nK7sAfOtlkXiXIa2Uxn9GrM20gWAm5kfiR4XQiFQAOfsQt0OPpoUIH2KojmSSxM7K1CwBXna8pzcq0dXH1z1YVq9vPbic2N4lj9Ob9uvlP+kzSeVSrqMukkcWrPbV82ra4iq8mRcmMn3OZYqjR4Huf/9x1VUTLhim+GpxtwGVYd4hP3hPHhcSinN1D2FEKRCyOZIWMu47awTJGfg5z9GATIi/5Ndx44xAA8Hp/z0OlpqpkVuw50HdTaC5l2oRqiq74nl+6i6WNLARA76X9dbjrXDKEqpQmk6G1hqrcjMvBFpAUGhCbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uE6sjx0oSA79BfIgkJVMlmUd3p6BL3oGNTJ2eCqwAtA=;
 b=PWaTE7P4OFcgMj+chS7KRf3uaapJOY2yTgKZeHzkgxlmRVw17mENed3K5qNQIyD96OxlojWwiBRQRPYClIqvW1tKFA0kGGkuPMEAXR44m1YJ3porJlZFu+HJoV+yeqB3vL3taPS0pAIbCiJflCiX17nKoK0V8GKqSjjE2rZt4uyrhyD6yw8hLFeWmJ4ePs7JxHQiaZSIyU4L20jU1aMIgJX8Y//N+oodQebPeFpdCVTm4zAUMq0Ofl7gQJjzZSPP9DZbtoBp+a+9vWXR2W8r+Y15M50NpC4uHkR5AE0d4pngqdaPf6vB/O3lMvDeaH+U8M4c+JYlV7UHj9KYicSb3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uE6sjx0oSA79BfIgkJVMlmUd3p6BL3oGNTJ2eCqwAtA=;
 b=beXYWIj0QpfrgekkFHvK1CwA1Pij1VK7+FCaH0hcuHCxPgxQFkeFr3gs4Kav6r4eSqqKV/gdXBOZiaSqa0VCLz4HVd3WC1XVB5phR8fZKRLD9djDU6juTrfr+MxSwc2ZDTI/lN8q+gbfRMe4lXFWwW+/N01KghkZ6Uqo1qAAy2thwzwZptZHn2nQq6f1Nm/DsbOz5gJuUoH9Xtb6vq0mNR15HkQ9QdZxNCu4swxEOnMKI/35kXdZNyCjGku+v8VP6OWJX4njuGRyqMrza48hb64Vwgh8ALE9JYkkzuHkwU/TTa/goYKQqgFydBIogo8DTZdNw/Xo1LYSpCaVipjmmg==
Received: from BN0PR04CA0007.namprd04.prod.outlook.com (2603:10b6:408:ee::12)
 by BYAPR12MB2997.namprd12.prod.outlook.com (2603:10b6:a03:db::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Thu, 30 Jun
 2022 10:27:15 +0000
Received: from BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::87) by BN0PR04CA0007.outlook.office365.com
 (2603:10b6:408:ee::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Thu, 30 Jun 2022 10:27:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT045.mail.protection.outlook.com (10.13.177.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Thu, 30 Jun 2022 10:27:14 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 30 Jun 2022 10:27:13 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 30 Jun 2022 03:27:12 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 30 Jun 2022 03:27:09 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH vfio 13/13] vfio/mlx5: Set the driver DMA logging callbacks
Date:   Thu, 30 Jun 2022 13:25:45 +0300
Message-ID: <20220630102545.18005-14-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220630102545.18005-1-yishaih@nvidia.com>
References: <20220630102545.18005-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: abcfa49e-2849-4976-7327-08da5a8319ed
X-MS-TrafficTypeDiagnostic: BYAPR12MB2997:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U+nNVXNa5mchpYn6NtA29K6QcZbTRwjVFJIUnONm5+KK091omDv9KCEgx5zcXg+o029Xp55V1E9n4e1/2wGa/cAM2zx2n54/BMMrcMQz2KkphB6UtuWuHBi/yTQ8Kwwlrzv+PRFauyC+0gEBbOfErb5TjNuj6Y5U/GPKoTPtXkz+YaUHg0ssYHVylk9pYCCjtjiHxuKA3h7i0TJje0d/VU4qyhXCfdGTQyDUzVY2rIRLdbq8saOQ87pvTI62U4jZZwHuva+bbtNw5cwTklRPlgu5ermKgg8pPkI45D/DbMI+k8sHmfjBYNP4NDb70JpX/ElpZOsZOCteo2MFA2HaVB17JIi4cWNvIMCz/vAulZ90fmt7gaSxwUDTGPfQywqPpXFlNjNPyfWUzOItDiAwYCaCCcDcf+xjgkLmZ9tq6AwB7aVA+htwD277Cky//HgCgGoCzIZ3yAQk5IkfALjZk2ao471s0VfcoZ+WVTLJspk6FFC/zwQVM2GGql/MqsqV2yoJtO8wby7SAkWtgczXk2XsmOLpfj4pvAx4w2IMGUDD1IwwzVhgHotO7zlbwIwocwjONRk628C4lhLtCs3a3yTdzGgyaeAz1JiPl1vfDO7wEqQxkPg3CaTXZzxS69gkbaCnZOIkxk4vbBmU/dKm3MAZUf/eimb3/oNpN5Nhwry49GCnDRt228vs8h36UHSuTcUhqmWFLepFHcpN+h3sM+bU5bWZNR/XGIZuCYPNThPrApNVd1TK0jZ2vRN+ybetdVkg92Zfy/0osLQ4/4+uEZW/thC5bBm5oB8+DqM8UVi3ugArXaPXu+nbpOjFDeLYQouoV2ONcy4eoqe/Y0FkcbCPYs97CkSMCOnJNOogQQw=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(396003)(376002)(136003)(40470700004)(36840700001)(46966006)(54906003)(110136005)(41300700001)(2906002)(6666004)(478600001)(82740400003)(40480700001)(5660300002)(81166007)(186003)(356005)(8936002)(316002)(86362001)(26005)(2616005)(6636002)(1076003)(82310400005)(40460700003)(83380400001)(336012)(70586007)(426003)(47076005)(7696005)(36860700001)(36756003)(70206006)(4326008)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 10:27:14.6679
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: abcfa49e-2849-4976-7327-08da5a8319ed
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2997
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

