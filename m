Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD1D43C724
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241397AbhJ0KCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 06:02:05 -0400
Received: from mail-bn8nam08on2046.outbound.protection.outlook.com ([40.107.100.46]:13952
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241404AbhJ0KBO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 06:01:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZHTvXQYJqgIAeOCWpIO2vUVgGdvKpwnpBQngMRh5uApqdxMowcFCbqDyFzad3TkQxJA9YmRf0p4kkn/tvmxHGuXskfsJbegGMfpqWkFPND59REYqwRlWh+6bGKGUVl+bMo027X0OatkwyDRyCXumBpQShawG479b69GSKIhCd3g2tOaH4R7VrZljkpk6jU3X5S8OXxDus7HTHXcmY4M+33TBwU01rM3EfnXm0S8HE2dO/03LJO0MqAAuI7gzxLzyj2KkHjF844x9GawrQxVwxPDwyqexq0C5L2ifYeGMMWagVJsCYFSVVxs7F5fM/T1etJlbGVBQPIfuNvxCRGtJDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gWw4s5zff8tpYbvenChfKHDHCcPIEZCXHB0FTB/vMfM=;
 b=ECmd0WJwUsBMDDL+avrAnF6ZrKM0VPfaXvgKZbmLSAui3wTZce5oATs873Gxqcg0d+771S2+aBg0WUS04LxBCbcduD6fmGbepVDcMA5efmgb8xARg4rZkWqsN81zcJnmtQrZdSWESLrhm9nXZbORfmEhSJcUHjGq28MzsD4fbCJ065iyaek6swMnaKOVPEUwPUl9vosiTMa2kRQ3KhSSgkVPWAJuuSAxqvZv+rIUkXgO8xYSzw7xJi6/3svz16NXkpDaY1LptrPRKSiofN7NOD+xUjP5el9k09h2Sg+LYzMPRzCNMdcvDt6UluYq2ZOpNGApxQIJQFEgh3s0JJJpww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gWw4s5zff8tpYbvenChfKHDHCcPIEZCXHB0FTB/vMfM=;
 b=tQ22dNZEmMaMp2ew3cTErqovk+sfByu9L6/7i97mTA1T+MLhD4mX7PEXU1IIbv41JPvRnDCkOFgN6njCrsZxwqc84S7Xx26Q63+UXT0XDBq5ynMmTV8r9avArU0pgjzJckenh3AgfuAsBRGJfovB4U96+UcGzjMWGiCtKwAizREdyFQaKnYWGH9S/KqhyfixH6CCuPpPWXdRVTqbQq8yzknK0UKnF5VwCFtDVD0RoJaaI5as+4HT1PqBg0eCtvViCG6ApvHlwM5g7xK/JbvlSzHMOt+v8BfB/CSV/ljm8fLV9m8Fs3kiuPCzpf28bfzd3g+p6L/GTUfox+RIpjZcBQ==
Received: from BN6PR14CA0005.namprd14.prod.outlook.com (2603:10b6:404:79::15)
 by DM6PR12MB5022.namprd12.prod.outlook.com (2603:10b6:5:20e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 09:58:47 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:79:cafe::ac) by BN6PR14CA0005.outlook.office365.com
 (2603:10b6:404:79::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend
 Transport; Wed, 27 Oct 2021 09:58:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 09:58:46 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 09:58:34 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 09:58:32 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V5 mlx5-next 13/13] vfio/mlx5: Use its own PCI reset_done error handler
Date:   Wed, 27 Oct 2021 12:56:58 +0300
Message-ID: <20211027095658.144468-14-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211027095658.144468-1-yishaih@nvidia.com>
References: <20211027095658.144468-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f89cc3c2-52bb-4d43-9fda-08d999305e65
X-MS-TrafficTypeDiagnostic: DM6PR12MB5022:
X-Microsoft-Antispam-PRVS: <DM6PR12MB502283BD550B7355AE221008C3859@DM6PR12MB5022.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QWtf67fSUakBnwl2lTKs/+1KTmwYCV5wy4uFvp2506cWqxGt78D80rhRQCF9+wpVjqb83JJCp/D/wwA+ruWoAlF0893y0SWwjcFBvOE9yrlfsypPnkJDzN01Va1ZpdzNNnV40GezUyIFl8JErpy13/QeLzec903s5NLmbU+KH11JnVoO0LL/a1Hl2gu3zPrsXrCspsliPBBtZRHsXjvJoVAjAnbOprs65HyI0/BT9VbYXT5KQsDJ0sPLZ/OXiU4XUdbSWKN3EneQ29zeXp+ed6oXuI2uEKa/wdl2KSSJV6gCXtUieqB4ns4WIsV4VQUf13l13lraXjQP+TJ2YLmufBFZXduWsszSECeZ/sK2uJOeT1KL7GTF74XqQwpMcrxI3qUaONccIbCg/gHTw1Tywan/Y1vNBX0alkr/6WkLfV7H69xtM4OsN+sz4lWNfqMpQWj4NhIPidBkjX6qeOdOYSEVFYGJ8FBXx6/O4U8rcgyQDF6IS56P6Ei17atyVNtSkmmFewA/IK4MhIcOMs444AYoSqvYlO0Yg2TeJg6wdzcLvyj0KgOZofiywvGqYQrk/LQcJHMm0nNp9DgXr6+/sbmKHweomX3DfpuxQbiSRyJbWIwbhSx9m6BBX3PQ5uXoLXz2UcFVrifiuuoXAPdGS9Z3y6oHCpA9YLpd8VgyDhqFK60dSJzfVaht78nBQDyJXc47RGLcseOCxCFD+5obYA==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(36756003)(36906005)(5660300002)(336012)(8676002)(426003)(82310400003)(316002)(7696005)(110136005)(107886003)(508600001)(70206006)(8936002)(36860700001)(6636002)(7636003)(54906003)(186003)(70586007)(83380400001)(1076003)(6666004)(2906002)(4326008)(356005)(2616005)(26005)(47076005)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 09:58:46.7145
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f89cc3c2-52bb-4d43-9fda-08d999305e65
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5022
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register its own handler for pci_error_handlers.reset_done and update
state accordingly.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/mlx5/main.c | 56 ++++++++++++++++++++++++++++++++++--
 1 file changed, 54 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 467dee08ad77..a94cb9cdb82e 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -55,8 +55,11 @@ struct mlx5vf_pci_migration_info {
 struct mlx5vf_pci_core_device {
 	struct vfio_pci_core_device core_device;
 	u8 migrate_cap:1;
+	u8 deferred_reset:1;
 	/* protect migration state */
 	struct mutex state_mutex;
+	/* protect the reset_done flow */
+	spinlock_t reset_lock;
 	struct mlx5vf_pci_migration_info vmig;
 };
 
@@ -473,6 +476,49 @@ mlx5vf_pci_migration_data_rw(struct mlx5vf_pci_core_device *mvdev,
 	return count;
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
 static ssize_t mlx5vf_pci_mig_rw(struct vfio_pci_core_device *vdev,
 				 char __user *buf, size_t count, loff_t *ppos,
 				 bool iswrite)
@@ -541,7 +587,7 @@ static ssize_t mlx5vf_pci_mig_rw(struct vfio_pci_core_device *vdev,
 	}
 
 end:
-	mutex_unlock(&mvdev->state_mutex);
+	mlx5vf_state_mutex_unlock(mvdev);
 	return ret;
 }
 
@@ -636,6 +682,7 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 			if (MLX5_CAP_GEN(mdev, migration)) {
 				mvdev->migrate_cap = 1;
 				mutex_init(&mvdev->state_mutex);
+				spin_lock_init(&mvdev->reset_lock);
 			}
 			mlx5_vf_put_core_dev(mdev);
 		}
@@ -670,12 +717,17 @@ static const struct pci_device_id mlx5vf_pci_table[] = {
 
 MODULE_DEVICE_TABLE(pci, mlx5vf_pci_table);
 
+const struct pci_error_handlers mlx5vf_err_handlers = {
+	.reset_done = mlx5vf_pci_aer_reset_done,
+	.error_detected = vfio_pci_core_aer_err_detected,
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

