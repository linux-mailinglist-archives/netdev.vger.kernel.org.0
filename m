Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E049E43343F
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 13:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbhJSLCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:02:47 -0400
Received: from mail-dm6nam10on2043.outbound.protection.outlook.com ([40.107.93.43]:14849
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235388AbhJSLCM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 07:02:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NaX5rY8ooHy+6Q4byJxWy9tqh40f6vqrwHh3MiazYFfnpymAZv13a0059zyG6FFzAj2pXsBhPfwiyUcyCv32HT753OTHGHLFL4htsC9L3k7sqbVuavEwq1VpNQfEY3jjydCcEW2bTkisjZKcW/nGRxn0YB8lbHk0YI6GX8o5b29AIvfL6BBKsIWbcnt028LRMgJ6E+TWWHPZ10pek85MBw2mqD4uDjikgyPqew8ictNQncYiyreo9JXfll0ASs+oIow/4WNVeO2gbhSDmKsjlfYr6YpG74VJMCnxLJ6/et/5lkWb6OuOSeMF0YTlty1z20pCrGRazrEssAEhLmLJqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gvbYG69wMjK0H/k9CGU5MIxs8tnAxFc7USLq1c6B0+4=;
 b=HKioM8qPONcBOpjtSep84EeHU7/VM1ecY5/nc9XwVVNYuvUtsc5kR4hx+Zfa+pP2nBte4LhnpPxJCVY9KvFhJF8DE8SbFNoDkOh6en9SQNN3KhszLdLr/AV2baCEVz/LBIml0nYOistTR6xQ2Ud8DLO+1qJjJ8pImMJOGmtrZeqZg6ksbLNy5DyNYK+Hm4/vUSrQ8b31ymottjAXanN0loQbdViuZQRO4mdTA39vI9JZk7e7mARSK74EcmuSYqb42wlrac/SXoF3AKE+RxdTOinf8GV4T3MQ+geTADrzwFw2B9s+ZmDkrMlMLiZqBJr0DSHTCDO/iJgdbH/jvSKpew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gvbYG69wMjK0H/k9CGU5MIxs8tnAxFc7USLq1c6B0+4=;
 b=LVg/Bk9Kg9chMGXjs1NJP1CLIL59fwBqQGNQWDHuQzjCvq0+kdzf3h2juKl56ihgiBc95gDP3LXiLbMIKBrCvalWBVk+yPQNiSN37zRoboajr8++0WJZGLxmJkWnzk6YmYPe3vWXOYANuKN8uZpFgP4LF4EZIUQQcB2/kEWy0yIW2iTtGoMFENQs/HnsdG6VMnhaBjH0I98jSK6spYSf7VIMBi6mk/GWX7otTcEJVMJiVkJsqJ6yFY505CO0dFQ7AJ9ZPJAZWD8II1MRW4Il+/tXsDbs+Emo3Gwfk3dD184nP81O7sXbK9tGIVryjCwEtAj5sZzWfcFsOPkg2DXe8Q==
Received: from DM6PR02CA0062.namprd02.prod.outlook.com (2603:10b6:5:177::39)
 by DM6PR12MB2858.namprd12.prod.outlook.com (2603:10b6:5:182::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Tue, 19 Oct
 2021 10:59:59 +0000
Received: from DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::a6) by DM6PR02CA0062.outlook.office365.com
 (2603:10b6:5:177::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT027.mail.protection.outlook.com (10.13.172.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 10:59:58 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 03:59:57 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 10:59:57 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:54 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 mlx5-next 14/14] vfio/mlx5: Use its own PCI reset_done error handler
Date:   Tue, 19 Oct 2021 13:58:38 +0300
Message-ID: <20211019105838.227569-15-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211019105838.227569-1-yishaih@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34352b90-7e02-4d95-f4bc-08d992ef977c
X-MS-TrafficTypeDiagnostic: DM6PR12MB2858:
X-Microsoft-Antispam-PRVS: <DM6PR12MB28588AB77B92F63A6D11064DC3BD9@DM6PR12MB2858.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WZoqKUn72M/DsTec5opTj7Z1dwUOWRIrIyiAUFsGIzYwko/ziC3AtbUYyKi23y4hsx65MhFfVskEXHG/F0q6I/BFkcNoC90NtkuquMSZZA3Sls5+U8LjPEVa2YH27CnWFwxRfW4Fuk86LduU61qfDJQJupNxDvIWJcwis9w+W9g4oobLz2fC0m2f+ZX2VfigsaJGA1UmohaerpxpFoJe10yFJwqtdbquIZ9oEBli6G6igXukbgc6D3sAVKhSUUcMkv4yD6d+D6MwTHI4jhvPcr0kjF2z9bMPngam38ooO4K7W+5tDEIpPwQd9uT+cJ0XyaymozUHvIVT1alHYpcADH8WVnptZSxi0mctiXAFOiqCPALv4WrGLs/wfhD43qq+Jh1q5142G3kG2/MTnP7tyPns2aC2VgN4hr3N3fPzYEdta2Sw1ZhzkXejCROPQE7q9GtlXP+cHSCtPwkXK+XS3UqigRv/MuYrjlm7XiwTPezHTWA6WlvlJqcffLO2sEf5hUt67//fAk+bMlesrIaDScFPZRYc9Kl8wYQjnnC9shAT4oH3YkwCScoSdcr3vgndP60rb0t91zidcMWMJISH1/ujJZSsaUkLBZuvWO3XjDw2fZAdPO7Ayyyaafve9UfECm0nfdi88mpGo6uphP5XINalJfFIkAw7ZUlu8L9XUXphdBEZsG3REwA5wDacuNjXv66+iuzsVCs3oSGaQV1y7g==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(426003)(6666004)(82310400003)(70586007)(2906002)(47076005)(70206006)(8936002)(86362001)(6636002)(4326008)(5660300002)(336012)(316002)(36756003)(83380400001)(110136005)(8676002)(26005)(7696005)(107886003)(356005)(186003)(1076003)(7636003)(36860700001)(54906003)(508600001)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 10:59:58.4854
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 34352b90-7e02-4d95-f4bc-08d992ef977c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2858
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register its own handler for pci_error_handlers.reset_done and update
state accordingly.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/mlx5/main.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 621b7fc60544..b759c6e153b6 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -58,6 +58,7 @@ struct mlx5vf_pci_core_device {
 	/* protect migartion state */
 	struct mutex state_mutex;
 	struct mlx5vf_pci_migration_info vmig;
+	struct work_struct work;
 };
 
 static int mlx5vf_pci_unquiesce_device(struct mlx5vf_pci_core_device *mvdev)
@@ -615,6 +616,27 @@ static const struct vfio_device_ops mlx5vf_pci_ops = {
 	.match = vfio_pci_core_match,
 };
 
+static void mlx5vf_reset_work_handler(struct work_struct *work)
+{
+	struct mlx5vf_pci_core_device *mvdev =
+		container_of(work, struct mlx5vf_pci_core_device, work);
+
+	mutex_lock(&mvdev->state_mutex);
+	mlx5vf_reset_mig_state(mvdev);
+	mvdev->vmig.vfio_dev_state = VFIO_DEVICE_STATE_RUNNING;
+	mutex_unlock(&mvdev->state_mutex);
+}
+
+static void mlx5vf_pci_aer_reset_done(struct pci_dev *pdev)
+{
+	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
+
+	if (!mvdev->migrate_cap)
+		return;
+
+	schedule_work(&mvdev->work);
+}
+
 static int mlx5vf_pci_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *id)
 {
@@ -634,6 +656,8 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 			if (MLX5_CAP_GEN(mdev, migration)) {
 				mvdev->migrate_cap = 1;
 				mutex_init(&mvdev->state_mutex);
+				INIT_WORK(&mvdev->work,
+					  mlx5vf_reset_work_handler);
 			}
 			mlx5_vf_put_core_dev(mdev);
 		}
@@ -656,6 +680,8 @@ static void mlx5vf_pci_remove(struct pci_dev *pdev)
 {
 	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
 
+	if (mvdev->migrate_cap)
+		cancel_work_sync(&mvdev->work);
 	vfio_pci_core_unregister_device(&mvdev->core_device);
 	vfio_pci_core_uninit_device(&mvdev->core_device);
 	kfree(mvdev);
@@ -668,12 +694,17 @@ static const struct pci_device_id mlx5vf_pci_table[] = {
 
 MODULE_DEVICE_TABLE(pci, mlx5vf_pci_table);
 
+const struct pci_error_handlers mlx5vf_err_handlers = {
+	.reset_done = mlx5vf_pci_aer_reset_done,
+	.error_detected = vfio_pci_aer_err_detected,
+};
+
 static struct pci_driver mlx5vf_pci_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = mlx5vf_pci_table,
 	.probe = mlx5vf_pci_probe,
 	.remove = mlx5vf_pci_remove,
-	.err_handler = &vfio_pci_core_err_handlers,
+	.err_handler = &mlx5vf_err_handlers,
 };
 
 static void __exit mlx5vf_pci_cleanup(void)
-- 
2.18.1

