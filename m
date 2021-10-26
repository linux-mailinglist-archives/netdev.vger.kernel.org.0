Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4E643AEAE
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234825AbhJZJKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:10:44 -0400
Received: from mail-bn8nam11on2067.outbound.protection.outlook.com ([40.107.236.67]:38689
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234846AbhJZJKT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 05:10:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W5LDHDHdKuG2ajzqJlW6zV6nWiyxElZC0lvghsF3J90WN8htjeLmCO43rGgU72YYWwVOyXA+jkQnb8KwxDN66NE4GByHtOJGTAPcZzlJFxf3GHdUW+sGkyeMZUbTQ1n09Af9gQbNcn2NRDr9d7aqKM89vA6VsLtYZxTL62lVs9s7WN5pUvcL9AgdC36xurYmkY3sJ94Zmzl7b1qR5rrGRvnSuuMwmVzqn9Rn7MWkQPVuFYa6/e3epz1jUX30MMfRT9S1A6PgZEOk32MfYag1F0czs16MxeQY1wlIkN5G0rjaF5enCbhG/P+F4pzsia0Rymd6NQxWES76cHAPBa5aaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XkRA4DFUZn0VJAIEvzyZVOlw5UCUadvKQvMwbQOb93E=;
 b=EMqr+7e3Zid+TRNK37qy6RTmrQ0PzH0JcABMOpDHOmfAzNdM7cqdHMbiq7LZoC2j+HUh/JW/HWvXE01o7jlUuFVz/eq1zWxcgnvebuBGzoNlz8az0eDNVA1ikBjkKt9kaHd7QIAqhUpIdE+sfmFYY/Jvu1gGLxIYTD9wyZv011GlL07et6bBDm0IyzBCtpTAc9osRPrY+kg8mgCw97CF03q5yJzUJY3CpKuE1oKcvuTbtoWNqB3TslaNYcadvPjempvnPAbxXBJA2rM5m+0gBSjHxf+EPZc7pTtcSyDgH3TdOEQ09Ac3UkrAlifR1sXUL3ypq0RnbGRmpXsrqn7X0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XkRA4DFUZn0VJAIEvzyZVOlw5UCUadvKQvMwbQOb93E=;
 b=ObOSgEw3qtLk5a/kI8cg1RqL2tytFtz4iF1LNvtqjgF1Ocj/tA8GIwTvFU/g3pPDLM48ZOySPSnsY/Al3U7oKdH/d4cYSiXsrrpKo0rmK+cTch22mj0kvp/6JO0564+bLTD+NHsqhiq/+JjCPh4SxQI4txuoFC+nZigNhNsN7rC0VZ775pBbxSGffVx9EaAmFuwzZhG/cu9PHfl91r+Km054/PZoepRDXahuKHH8IveTORsRfGuD281/CEqrEyaDTXcB6LUdzGXGuLo5PSHbhxLAoTZpVUTmcESDCC4FZWrlleZ83pwT7+y0MwZlaMSCN6hfaAG+HPPCumL23oB1/w==
Received: from BN6PR18CA0019.namprd18.prod.outlook.com (2603:10b6:404:121::29)
 by BN9PR12MB5275.namprd12.prod.outlook.com (2603:10b6:408:100::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Tue, 26 Oct
 2021 09:07:54 +0000
Received: from BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:121:cafe::34) by BN6PR18CA0019.outlook.office365.com
 (2603:10b6:404:121::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend
 Transport; Tue, 26 Oct 2021 09:07:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT033.mail.protection.outlook.com (10.13.177.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 09:07:53 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 09:07:53 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 09:07:50 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V4 mlx5-next 13/13] vfio/mlx5: Use its own PCI reset_done error handler
Date:   Tue, 26 Oct 2021 12:06:05 +0300
Message-ID: <20211026090605.91646-14-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211026090605.91646-1-yishaih@nvidia.com>
References: <20211026090605.91646-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7a74c0f-c1fa-400b-3880-08d998601832
X-MS-TrafficTypeDiagnostic: BN9PR12MB5275:
X-Microsoft-Antispam-PRVS: <BN9PR12MB52758DDCDD5884E2518874DFC3849@BN9PR12MB5275.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KYYYYp172F/72dVAhCyCcv2MjhuIyswYNoTQsNDAFCZm6lnX1rTXqUzDQbQRv3vjsVP5vZ16uciobzdcamOS5OKKPhYZPgkcr47CyKc5M5spTTmxvK430tBZD47BrMuIC9SNWvecrZYMSTr8K2Lh2tG65WhIpOCXRg2NdE0+PKHp7ZEIuReF6NrVeaTZItOnIVGh5TxCG2XzU4zxFD3JJKA6a7LUQScIWIDQCjtLl2DKD6jxn2hw6FZKC1T6x1FCPWNvmImN+ZlzLGr4Q5yAYTd8XYNov3S1wWm1yAoL4Xvj95OA9ep/mvbHWp5BLViRfIQpDYpGb3l4IDeYxKxek1TfS51aMKxe9S2oXW4hMeIx4FlrD931wHevHBi3M5siJ9uD1DXcWwGVnXtKjS2UFdryXFMgcNhMrSu48WbgOFknka8xSGKFPlwfcckurFOZvDw3DwSKsjs72qqYJug7064oby2wiamu4RfirQVHwBoJk3b5IsclKiUfIm/yg67D1ypGBC6pyLHn0sbtvYCJtDuqDet0UDBS+/B20tq+Geule8WNzisn2F3pZueHI2PdopyXT0onoApEg6a9Refa+UOM25Z+gu8G3YnnpoERP495Lty9pFWt6cM1HCWR8J+RxkpWnDjLAXsG3a9c4Xxcw6meBZTAZcsCOXn8PVMyXjhWlnN22lst0KqvMtxeZECBuY5i5qemAFRhtyTi2s6vcQ==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36860700001)(110136005)(2906002)(36756003)(36906005)(7696005)(83380400001)(47076005)(5660300002)(26005)(356005)(2616005)(336012)(70586007)(7636003)(8676002)(508600001)(107886003)(82310400003)(86362001)(8936002)(54906003)(186003)(316002)(6666004)(4326008)(426003)(1076003)(70206006)(6636002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 09:07:53.8093
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7a74c0f-c1fa-400b-3880-08d998601832
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5275
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register its own handler for pci_error_handlers.reset_done and update
state accordingly.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/mlx5/main.c | 54 ++++++++++++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 4b21b388dcc5..c157f540d384 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -55,8 +55,11 @@ struct mlx5vf_pci_migration_info {
 struct mlx5vf_pci_core_device {
 	struct vfio_pci_core_device core_device;
 	u8 migrate_cap:1;
+	u8 defered_reset:1;
 	/* protect migration state */
 	struct mutex state_mutex;
+	/* protect the reset_done flow */
+	spinlock_t reset_lock;
 	struct mlx5vf_pci_migration_info vmig;
 };
 
@@ -471,6 +474,47 @@ mlx5vf_pci_migration_data_rw(struct mlx5vf_pci_core_device *mvdev,
 	return count;
 }
 
+/* This function is called in all state_mutex unlock cases to
+ * handle a 'defered_reset' if exists.
+ */
+static void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev)
+{
+again:
+	spin_lock(&mvdev->reset_lock);
+	if (mvdev->defered_reset) {
+		mvdev->defered_reset = false;
+		spin_unlock(&mvdev->reset_lock);
+		mlx5vf_reset_mig_state(mvdev);
+		mvdev->vmig.vfio_dev_state = VFIO_DEVICE_STATE_RUNNING;
+		goto again;
+	}
+	mutex_unlock(&mvdev->state_mutex);
+	spin_unlock(&mvdev->reset_lock);
+}
+
+static void mlx5vf_pci_aer_reset_done(struct pci_dev *pdev)
+{
+	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
+
+	if (!mvdev->migrate_cap)
+		return;
+
+	/* As the higher VFIO layers are holding locks across reset and using
+	 * those same locks with the mm_lock we need to prevent ABBA deadlock
+	 * with the state_mutex and mm_lock.
+	 * In case the state_mutex was taken alreday we differ the cleanup work
+	 * to the unlock flow of the other running context.
+	 */
+	spin_lock(&mvdev->reset_lock);
+	mvdev->defered_reset = true;
+	if (!mutex_trylock(&mvdev->state_mutex)) {
+		spin_unlock(&mvdev->reset_lock);
+		return;
+	}
+	spin_unlock(&mvdev->reset_lock);
+	mlx5vf_state_mutex_unlock(mvdev);
+}
+
 static ssize_t mlx5vf_pci_mig_rw(struct vfio_pci_core_device *vdev,
 				 char __user *buf, size_t count, loff_t *ppos,
 				 bool iswrite)
@@ -539,7 +583,7 @@ static ssize_t mlx5vf_pci_mig_rw(struct vfio_pci_core_device *vdev,
 	}
 
 end:
-	mutex_unlock(&mvdev->state_mutex);
+	mlx5vf_state_mutex_unlock(mvdev);
 	return ret;
 }
 
@@ -634,6 +678,7 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 			if (MLX5_CAP_GEN(mdev, migration)) {
 				mvdev->migrate_cap = 1;
 				mutex_init(&mvdev->state_mutex);
+				spin_lock_init(&mvdev->reset_lock);
 			}
 			mlx5_vf_put_core_dev(mdev);
 		}
@@ -668,12 +713,17 @@ static const struct pci_device_id mlx5vf_pci_table[] = {
 
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

