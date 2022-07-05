Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23923566802
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 12:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbiGEK3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 06:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiGEK3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 06:29:17 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E4B15802;
        Tue,  5 Jul 2022 03:29:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c6iAGiiNofvmvLhZTioDim/lmVqhWmKSQ9WTJae6b3CY0Gd+NzQDRHjFZpu8x0s2DKgBwfDj1LlvmQQwqAlcNIjQs2ZuLp0rwIWnN1agPJz7WZgr2yiMe2hXzfDXMW15E4QHjgJm62UmXiRmTLVVqYxYhpMzbpZdG6DInXHG6kZQ5UH+a9qBQowSZmKNZuaAyLDIioEc0bM9ub6IUiOB7F6O8OaRkm7e3aqHY2pkA8XfKO9cSLrbvTzrEA3dgI7oRSndQglBaCUvf/tkEaYJOmYZ87BbA3dTJaYgEq44o4Kqg2sGQ7lMObXm8Xpb00HfQCWI08eDMYh/mcvC4u83UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uE6sjx0oSA79BfIgkJVMlmUd3p6BL3oGNTJ2eCqwAtA=;
 b=TcLtc+r802t11w1T6l2daI45ZKfUg7T4lWcBXDFGKiK6fSKjenmKX6x8YWxtHEBEHfcIHtLD7Hj1xLdIIlqQcmZNjgTFfU7VPA7rBr3h5TwINPj46Um8EIY+b3Sq5MJEFYIgaKdKNx8Re+AJ98Qpfst4QrCImm8lXHKY0OJDnEZZH8KEDC1bp2v37SG9OZhxHAmCD2WkgJ3GeUchno70yIXUUFERa/o7zBSPJgtNYhTYYtn4XPQJ6OZdzY3929wgV+mElgGOa+3fVw/KqrIIEzJ4L46AZZJm3LJWZt5NrIcmJJHP8OQ6bi/IfP6r8tUZUZCcONa+UfT2f3jHSQZPJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uE6sjx0oSA79BfIgkJVMlmUd3p6BL3oGNTJ2eCqwAtA=;
 b=hAyge6/Y4FF2jqFN/KqQ2enbhKpLb17KwLkg6JCPRQe89Z5uHssnKXggVPNzJRzY6mRJBzkzMgmIfDS/3ZUJ7ahAoaZaX+7EiTujsgrNTC5rO9jjIMa3i/8uV9IbEHPJy/MphFlyfizRsGMtkPlCuvL0WEQwZaamdlKbdj2uvZG9GzxWnEA1kr9S4OSu+JRY36EYRV+BghuNpD9sO9A1iz8tBs0oc6CTGseuWsiWw8+i1g23Id4C2T01WqtMEFikl/GyJAr+j+3RCqpZpN5vu1klbIPgpXbCR5UL/Uai2wDJF6JGfMf1bfXnM5igyW3UIr0cYsj/MhOzY+Eg1MF9PA==
Received: from MWHPR14CA0015.namprd14.prod.outlook.com (2603:10b6:300:ae::25)
 by MN2PR12MB3069.namprd12.prod.outlook.com (2603:10b6:208:c4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18; Tue, 5 Jul
 2022 10:29:01 +0000
Received: from CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ae:cafe::42) by MWHPR14CA0015.outlook.office365.com
 (2603:10b6:300:ae::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Tue, 5 Jul 2022 10:29:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT060.mail.protection.outlook.com (10.13.175.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Tue, 5 Jul 2022 10:29:00 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 5 Jul 2022 10:28:59 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 5 Jul 2022 03:28:58 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Tue, 5 Jul 2022 03:28:55 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V1 vfio 11/11] vfio/mlx5: Set the driver DMA logging callbacks
Date:   Tue, 5 Jul 2022 13:27:40 +0300
Message-ID: <20220705102740.29337-12-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220705102740.29337-1-yishaih@nvidia.com>
References: <20220705102740.29337-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7d26620-f0d1-40ae-7bf9-08da5e712cfd
X-MS-TrafficTypeDiagnostic: MN2PR12MB3069:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EGwjK3YkHAjjI7ngwZvgQAf9lpVzeB4SS6r1+ysL6pPNTwdyxuqwSlIjKZcY6kqg114ToLQsDHyTNBadXEcs1+obr0JwWx/04UVNmVh04RoVzl0hzGLHxD5XRFioWrqaaP4hMTobko3+v4DvrrtYj+0J5TGNNKUItBkGw3dwQv56djg3bLuKnt5hg0Tstsdic67BmP+N0mFLgfky1NZZxTfNPXi7W0GtwNGBtI78NySvYqSe8xuIJAxKqsUtjR/79+39x3SbxvJ8B3w/nh16CdaGVQf2haTBtOo0FTkM30oZp9oRodtVUcDNxh4Dyy7tdOAlJl4Ln5kdU2dbgiEMg5WKv3Aq4CFrCbP+KPZjNqcoGRDBBVWQ/FsAhUuj/pd4/UL50nDbjEeZMP1RTfawbY6USlPVLY7ZMKrVjBZl8qN4aovWbTi9XjQt1X64aBvBtNzSvZAN4f/BqMHseuqgO4xYATWauxxnSSOHhPGCN8MB/+LOv5sUbTWTo+aQgNhWruQZLg5dHcRJ4UrylzMqZS4Z31sTGu+pdv8KDjL2/o6x2DMRTMBOa896TEatdh6bRw+s2glf9mMq/6FUmIOtRkjpJq3Nux/KDkg2sjS8NCb4QxwMKmzhksYmkwcZlbOnwVnygOMj6dR7NzQUEZnQL854jJWOSWmgS6HDTOkLyAHwqKjhDH8MZD2wLAi2Mt0OWMaUX54wQ952q4fjP/BYsHOpJYyFhoEEx+ais6xW8GWUbRxjpkNMv9S8R8r2ufS8VAE9vct6K3l79mXlRP+XnFtEryK4EOOiJikL8G7CwBKxlPu5DWdoVeq7kYmTQ9VuRp7subJE5JHPcROHtiKth1jvC6J4Gmzd0xUtskvfLEU=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(376002)(136003)(46966006)(36840700001)(40470700004)(8676002)(4326008)(70586007)(70206006)(82310400005)(2906002)(86362001)(5660300002)(356005)(8936002)(40480700001)(81166007)(82740400003)(41300700001)(426003)(47076005)(336012)(83380400001)(26005)(2616005)(186003)(6666004)(7696005)(1076003)(36860700001)(40460700003)(316002)(110136005)(54906003)(6636002)(478600001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 10:29:00.4378
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7d26620-f0d1-40ae-7bf9-08da5e712cfd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3069
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

