Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB7C24BCDF4
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 11:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243576AbiBTJ67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 04:58:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242828AbiBTJ6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 04:58:55 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEAFC54682;
        Sun, 20 Feb 2022 01:58:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gno8WGHHJi9h01GVj4UfUl/qJmHn426/IvdEKGwUOe4bk7PvFfP5Cu3fyeiHSOKkjutt8aguNSJkdrp+ZYbQehu9eCPq91q9Gtw3Z+oUQ3GiTmY2ir+zvkAoxOTOeBIyXUWe1XpnuM+lS+Jt/p+4Ybx716LIsgzoGgEIk2OeFePvOSH6uvBAHTqIoQafcYcBHUPXHsKo59BnydCCbCLkoHcQdGOKhUjbECoyXwEPV1Fg3fKmik3C1cJQjEVXBVfQx90fzznfqmP5yAyEZ/Dnw73vo0RYTM78ZqG59CTsYoUEti7B/cTtwe0JBj5fvBB3Lb1IrAAxk/043G50ZV9y4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q6yP+UcaESGvVDA99CJM19WVOqvMzB4Yg0hQqHcAhk4=;
 b=BgHwvcgDDBskZAGoXcqjeiM4TEKJm3vTyk9ZwV6+Kk6ZHyPeveYls3uIvlVdfqQLOOjUioFXjxM3G8H5gCqr7gLO002OKC8s1MJqk6yDH1f07TPFUrW9A2EPHUDQTTagIXvDbDNFmvU4KsXQIE6DsA8RxXhEBPzixS7nGJG8eBHRH9Vv+DNV1oQqYVAL0+Uz2FwvNmnkcKJiA6Mt1qatLtI5cu/BNuoKryviBmeUhHbxllNH/QcHd4uRlKh9DcgYWwNM/yjVL+ljHJ5LwEM+Rd7hZsF/fOWPTlfRBXI2efGGLJ6Lbt0DYLjGoYlabHVJEru41V3pMlVVWYlDJ3l/xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6yP+UcaESGvVDA99CJM19WVOqvMzB4Yg0hQqHcAhk4=;
 b=e5X2SrNvGbkz6HdkyRIXaR5z2OAbO1XjR3byS3pn90TaSQi2vq6W0H2hLbrMj2oRJxUF+V45ZV8LUXzoIIRUpPx4YFB7sv0yITbHQo4aJpmSQy3Z+nY9tQdwnq+icuJ2EDezVIFXeksvKluueut5sPIWQ/76674PALoGM3LjR6Yp8x5fTZOC5ArSLRTvydbQkmnqmtpKBeKP0ILy1VQWjibxlBZ6G9gMJcEo15GJsOqrbhS5IR443K3pY0EqDsahBt3/D83LorQrmfNnE+duTq/bLRkqvVkqZfIdR4xUC4Dc4mxSmRfUJEfDv1afPeQF4hOWqNAD08W95o9zmrmN1A==
Received: from BN6PR19CA0069.namprd19.prod.outlook.com (2603:10b6:404:e3::31)
 by BN6PR12MB1346.namprd12.prod.outlook.com (2603:10b6:404:1e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Sun, 20 Feb
 2022 09:58:33 +0000
Received: from BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:e3:cafe::96) by BN6PR19CA0069.outlook.office365.com
 (2603:10b6:404:e3::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.26 via Frontend
 Transport; Sun, 20 Feb 2022 09:58:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT039.mail.protection.outlook.com (10.13.177.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 09:58:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 09:58:31 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 01:58:30 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Sun, 20 Feb
 2022 01:58:25 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V8 mlx5-next 03/15] net/mlx5: Disable SRIOV before PF removal
Date:   Sun, 20 Feb 2022 11:57:04 +0200
Message-ID: <20220220095716.153757-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220220095716.153757-1-yishaih@nvidia.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29a073df-8789-4717-ace2-08d9f4578d7e
X-MS-TrafficTypeDiagnostic: BN6PR12MB1346:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB13463FD9434B1CB8C55129F8C3399@BN6PR12MB1346.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZYDubx9KuGdOzxfeZJk+mynu6WAQf6lp7OVjKlvoi7yQzuZSk3h8QyP8hQ5HCooRkm2dmE7Qo8FWIkEoi8oXf99rm1FjCFxcz5uixTr91u3x40tGHso5QMLYp7oTkcrav+j2nljonDgC36tpvFQML+AKkqC1BhcBqyPLKqe393kCcvSHm5SxqRCKNdsUSoXS+jO1KLxeGcEM2Y3w/1WaSR/qVkgf24jaQpV/8TVcKLE13CCqJUF8x5sTqpqsAYuoBHTZwCRFfnwuYelmHkI2j8j9AYNdvWxraXCQD2ZSEVVz7ibEGNAcgOgSbM8ZuxMbrJFVRpGKp1zY1R9wnpD0UiBKkxyAUSKfVPKg+Uf1ZyGBC4MjE3wMRUcbC6wPAzuv6FbBdi0uCVu/DmEt555IuhYPL48emYKhcpaxmvnGW5B7/TYgeoAcBLaHtgaIdFj+JjaXlWlJyrkj+cNpwzkZY23YhU2NF8aK1SF26+Ibjhc5i3qXvtrxmc7yeAE1h61S3NE5DvvqxhM9JmBFVtL5JdkUDyFP+kYk68YlOSQHOYFPgYxcJz9usIBJFKBE6RoZwZoBL7tb305nSwl8GPAiJow+8NGbp7Fbu7Iwid1bzoWqfryOb/26FNMB+dj4RUGRMIrntBae8osRYgi8s9veT882o2E4iwc+5NAB3ZhkIKmIJexB6ItBFs+RPVoj6niXTIE0hMo3pEZk7lqnFIzIbw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(8676002)(1076003)(81166007)(356005)(70206006)(70586007)(508600001)(4326008)(36756003)(83380400001)(6666004)(316002)(86362001)(82310400004)(2906002)(7696005)(5660300002)(7416002)(40460700003)(36860700001)(186003)(26005)(8936002)(47076005)(426003)(336012)(110136005)(54906003)(2616005)(6636002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 09:58:32.1138
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29a073df-8789-4717-ace2-08d9f4578d7e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1346
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Virtual functions depend on physical function for device access (for example
firmware host PAGE management), so make sure to disable SRIOV once PF is gone.

This will prevent also the below warning if PF has gone before disabling SRIOV.
"driver left SR-IOV enabled after remove"

Next patch from this series will rely on that when the VF may need to
access safely the PF 'driver data'.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c      | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c     | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 2c774f367199..5b8958186157 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1620,6 +1620,7 @@ static void remove_one(struct pci_dev *pdev)
 	struct devlink *devlink = priv_to_devlink(dev);
 
 	devlink_unregister(devlink);
+	mlx5_sriov_disable(pdev);
 	mlx5_crdump_disable(dev);
 	mlx5_drain_health_wq(dev);
 	mlx5_uninit_one(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 6f8baa0f2a73..37b2805b3bf3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -164,6 +164,7 @@ void mlx5_sriov_cleanup(struct mlx5_core_dev *dev);
 int mlx5_sriov_attach(struct mlx5_core_dev *dev);
 void mlx5_sriov_detach(struct mlx5_core_dev *dev);
 int mlx5_core_sriov_configure(struct pci_dev *dev, int num_vfs);
+void mlx5_sriov_disable(struct pci_dev *pdev);
 int mlx5_core_sriov_set_msix_vec_count(struct pci_dev *vf, int msix_vec_count);
 int mlx5_core_enable_hca(struct mlx5_core_dev *dev, u16 func_id);
 int mlx5_core_disable_hca(struct mlx5_core_dev *dev, u16 func_id);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index 24c4b4f05214..887ee0f729d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -161,7 +161,7 @@ static int mlx5_sriov_enable(struct pci_dev *pdev, int num_vfs)
 	return err;
 }
 
-static void mlx5_sriov_disable(struct pci_dev *pdev)
+void mlx5_sriov_disable(struct pci_dev *pdev)
 {
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
 	int num_vfs = pci_num_vf(dev->pdev);
-- 
2.18.1

