Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7284F4A37AE
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 17:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355655AbiA3QQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 11:16:04 -0500
Received: from mail-bn8nam12on2054.outbound.protection.outlook.com ([40.107.237.54]:38720
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355650AbiA3QPj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jan 2022 11:15:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mpnUnvSq7zHG+CrJ76yFhOkRkCwc2KLXMYbs+xpK4c/OoenbPlRcvQEww4oYzxsDVkytChcBrsBxL+DdvXme6JPNE8Noo+0jvdirgbQ+BOS4xzR+KTr0LuSKoN32F6mdq0M132RaVEGS/BfWdnXodARuI8lIduEjAcn+EU+aIj1lIsJVq6rseWRqsb0hNMSHPQ5TybACohWubE/yROU/716LxqpdiaODl8oIn1Eujq6JTi5W/IRLx5VacdIH/xjTK5qz6LD4s1HoQ5jOXzA6A0IfAajMwlCJPwdOUvdAD3xB9LZHeyJasSE25Q9e3K1ww6mkIQ/5U4p4Z17Mjb2CWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/+0mt7qdDKlnU65NPIo8DzZ8LUs4CDMN15Xw+s+7oXE=;
 b=LNDOuyUR1jp17A38uM1+63r+MrsrOVFAYAGbL9/Stia0E8N/w8UYX++KhqSDfjccRelkREZIQP5Gd/5Nw4p4nYNn5d5hl4vxbOyol7DvmEnBGzJCF9xlqzCVzjZ+vagO612gZMpRZbSAA6Hb7KFf8eFMa+KbPhD3+tMexPU1XJ/2w7cj3EdzRfWLabR+5WhG8Qv8naLDCVezEv5anqWhSmZ5rVRvRNkGB4areM+nTGZXd2B0Z3eCD8nWLk+xWXrYg4ZWcjfjfl1i3Oz2clZrEjLqD+QgqZAtqlLbTtfaru053Igx14Z3wGuymTNDl6rt9ncAqK+6YOSc9wzojyV8RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/+0mt7qdDKlnU65NPIo8DzZ8LUs4CDMN15Xw+s+7oXE=;
 b=ep1NNk0GsWrIz4Q7aNaB50uqqux+iF1QRv5/hp1NDM3TXh/+Z2WReJjcUmek13A1Y5Qecajou1Omsq2R0qvUrJDeoUznlALiMU70WSBTuaORW73idBUDavz7SeQWmN+/NZkZhMH5QXhGchnEbTOpiQjYD0K87IrsiuNExBwc6WYQ4n4Pd/Z4f/GaeXvXUoLfn+w8vuywtXx5jgzruxQGO+SUIlQ0Ib3T/3SGZxeQGyGH3fnbCqNhGdVWjodOnFHrriXOJ97pZMnqpzTHTZGyD7tlisE+OjJpV5d51JrO4IY/NFz5JnBhLaue/+XCQ6q1Bgqs9fQy9Kg6AvHaiJLZAw==
Received: from MWHPR22CA0002.namprd22.prod.outlook.com (2603:10b6:300:ef::12)
 by SA0PR12MB4432.namprd12.prod.outlook.com (2603:10b6:806:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Sun, 30 Jan
 2022 16:15:36 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ef:cafe::42) by MWHPR22CA0002.outlook.office365.com
 (2603:10b6:300:ef::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.21 via Frontend
 Transport; Sun, 30 Jan 2022 16:15:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Sun, 30 Jan 2022 16:15:35 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Sun, 30 Jan 2022 16:15:34 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Sun, 30 Jan 2022 08:15:33 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 30 Jan 2022 08:15:30 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V6 mlx5-next 14/15] vfio/mlx5: Use its own PCI reset_done error handler
Date:   Sun, 30 Jan 2022 18:08:25 +0200
Message-ID: <20220130160826.32449-15-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220130160826.32449-1-yishaih@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ab91048-3306-4e92-d058-08d9e40bbf48
X-MS-TrafficTypeDiagnostic: SA0PR12MB4432:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB4432DABF78BE338AE7F8D14AC3249@SA0PR12MB4432.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A7JIyS3OtSXrIM8jlvXpmfIJksl/DBeSON6CDte9bNXDfgVI9iBm1uk6Ev5ira0htLZk54Pfx3PHG+omPTF7yIyjSz8o4N0a/g4d7rKDGraABAT5XtjMdZQZEhCxy7DrTpwNzAduS5VC4C5aqo27MP0bTaQID0/AIkktQ6hUDRmhgL/l8/FdMeeLEb5wltN0JwxtHc8cu45hGPYIATNjsk2t3aTND19kj4YhE4vF0C+AhOWB29wTic5T1GqNLj0WfENwrRTTaMStSPdYlujByW4m+vFsFHOnLvvbzDMLqQ36jPe6mcFEI3BILzkTtvTjyW6YNZBiv8BAry7HQFLmNJiN6UQoF7m6ivt8SkhAwKHR2ksAlYGFyUbicBMbdSYheVGYKQyJRnj9rXWsGNlJUxftztgsHbgX9g0xAWqTTRpkJsL09ZJKNJYnXeYQGivlsa4FEToL49yCgbDXblqpH/2cz5IIfpqdYW9F4wuXgnn8Jgekf8GytahCP5qpYQsjRlseI1N/Kv+tAcfymevzbSvHSjOyuugvLUy/kmq/x+zwW6TCArMYVjTu6dyvh+YwF7BDW8eaXAPIpPhxU78h/YAs2TXiKeBMBTTlmmkgeWo3pMfcL+lktTnN3jYSM7Sp9EEnvfuVxFhtvE25CaHwe5W5zeVIbufzD73UmSRRNNtrVJJR4wjVXCmi58L6O0Hty46krTbSF3FWhPZlGDyObw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(82310400004)(7696005)(426003)(336012)(6666004)(107886003)(5660300002)(2616005)(2906002)(186003)(1076003)(26005)(81166007)(356005)(40460700003)(86362001)(83380400001)(47076005)(70206006)(70586007)(8676002)(54906003)(110136005)(8936002)(6636002)(508600001)(4326008)(36756003)(316002)(36860700001)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2022 16:15:35.3535
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ab91048-3306-4e92-d058-08d9e40bbf48
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4432
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register its own handler for pci_error_handlers.reset_done and update
state accordingly.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/mlx5/main.c | 55 +++++++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index c15c8eed85d3..4d65a5c2d3b3 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -28,9 +28,12 @@
 struct mlx5vf_pci_core_device {
 	struct vfio_pci_core_device core_device;
 	u8 migrate_cap:1;
+	u8 deferred_reset:1;
 	/* protect migration state */
 	struct mutex state_mutex;
 	enum vfio_device_mig_state mig_state;
+	/* protect the reset_done flow */
+	spinlock_t reset_lock;
 	u16 vhca_id;
 	struct mlx5_vf_migration_file *resuming_migf;
 	struct mlx5_vf_migration_file *saving_migf;
@@ -437,6 +440,25 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 	return ERR_PTR(-EINVAL);
 }
 
+/*
+ * This function is called in all state_mutex unlock cases to
+ * handle a 'deferred_reset' if exists.
+ */
+static void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev)
+{
+again:
+	spin_lock(&mvdev->reset_lock);
+	if (mvdev->deferred_reset) {
+		mvdev->deferred_reset = false;
+		spin_unlock(&mvdev->reset_lock);
+		mvdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
+		mlx5vf_disable_fds(mvdev);
+		goto again;
+	}
+	mutex_unlock(&mvdev->state_mutex);
+	spin_unlock(&mvdev->reset_lock);
+}
+
 static struct file *
 mlx5vf_pci_set_device_state(struct vfio_device *vdev,
 			    enum vfio_device_mig_state new_state,
@@ -466,10 +488,34 @@ mlx5vf_pci_set_device_state(struct vfio_device *vdev,
 		}
 	}
 	*final_state = mvdev->mig_state;
-	mutex_unlock(&mvdev->state_mutex);
+	mlx5vf_state_mutex_unlock(mvdev);
 	return res;
 }
 
+static void mlx5vf_pci_aer_reset_done(struct pci_dev *pdev)
+{
+	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
+
+	if (!mvdev->migrate_cap)
+		return;
+
+	/*
+	 * As the higher VFIO layers are holding locks across reset and using
+	 * those same locks with the mm_lock we need to prevent ABBA deadlock
+	 * with the state_mutex and mm_lock.
+	 * In case the state_mutex was taken already we defer the cleanup work
+	 * to the unlock flow of the other running context.
+	 */
+	spin_lock(&mvdev->reset_lock);
+	mvdev->deferred_reset = true;
+	if (!mutex_trylock(&mvdev->state_mutex)) {
+		spin_unlock(&mvdev->reset_lock);
+		return;
+	}
+	spin_unlock(&mvdev->reset_lock);
+	mlx5vf_state_mutex_unlock(mvdev);
+}
+
 static int mlx5vf_pci_open_device(struct vfio_device *core_vdev)
 {
 	struct mlx5vf_pci_core_device *mvdev = container_of(
@@ -550,6 +596,7 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 					VFIO_MIGRATION_STOP_COPY |
 					VFIO_MIGRATION_P2P;
 				mutex_init(&mvdev->state_mutex);
+				spin_lock_init(&mvdev->reset_lock);
 			}
 			mlx5_vf_put_core_dev(mdev);
 		}
@@ -584,11 +631,17 @@ static const struct pci_device_id mlx5vf_pci_table[] = {
 
 MODULE_DEVICE_TABLE(pci, mlx5vf_pci_table);
 
+static const struct pci_error_handlers mlx5vf_err_handlers = {
+	.reset_done = mlx5vf_pci_aer_reset_done,
+	.error_detected = vfio_pci_core_aer_err_detected,
+};
+
 static struct pci_driver mlx5vf_pci_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = mlx5vf_pci_table,
 	.probe = mlx5vf_pci_probe,
 	.remove = mlx5vf_pci_remove,
+	.err_handler = &mlx5vf_err_handlers,
 };
 
 static void __exit mlx5vf_pci_cleanup(void)
-- 
2.18.1

