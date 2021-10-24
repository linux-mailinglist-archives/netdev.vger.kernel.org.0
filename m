Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0386E4387A0
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 10:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbhJXIeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 04:34:46 -0400
Received: from mail-bn8nam12on2064.outbound.protection.outlook.com ([40.107.237.64]:2241
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231837AbhJXIel (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 04:34:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jbt6QkBRvvCDYkgJpYopV1OvRhZLVROVKJh5E5oau+koEFOOhLAHM0y8HEEeEeiHxANH7GAZdj2kRpJ0+L3QPvphvUtdAPGxgU0a3hbGr83WlWNeD/Ho2btYZ7aInveCGVjj+4zTDgVRK+F5MjITJscb/Z6j+Eoo2XIEAovp/AS+I34eEYz4IDm141gqgJQ2pADxIlIgvyTRYyvpUqjdiEgPRAH0VEwY9NOco+fLPlMDVaFJLnY8+F1oY1oAB8kIh8yApOtI4vyQWHN08+1ILt8riws3L+z9sCwrw4e15uEUdThtMIcAhICx06uLLIWEvsvxr8LIpFZjtHM/t9i/8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u3KOUx0jSz7QZczP3nf+xaTthk7sMn9JiO4/y8JK+/4=;
 b=k66Qw8zgxNP8zCYUgmJtRauBcxUamKrzYcDz5k2Gcegx394tqU+iFmuU1pUPMySzmtJv8oalTck7Q6C8Db0rlaFFC/3dM58G3EHD1xt74EhyEE6CwZ6ZHJuCVVjP/WRU9I8KpDnXCquA1Wen8wZmnSBkgSA64hzR3pXuCW3Btqr0r7nvEX4JMsg3hGFB//vyWL16sMp/o+jJXgLVb87XiGgcAvX9wA4GvvZzFTioTE2bIhppyLX7UIVEJI1vMOjdQ+yB/DbFQ1xmnLzgnV6Ew54HBfrd7VWkOMaqIsFX/3vJxRlNyurDNo1suG4KBkte3X8Muy7d50G8BgNWQN1Ajw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u3KOUx0jSz7QZczP3nf+xaTthk7sMn9JiO4/y8JK+/4=;
 b=uMmGfyb88Lxy/GPGPdMF/WwDZjGC32p9BsOE2WnveERg2sHbz2Bb3/x8Z4A/bjMKkAGsJdr0rMXdLU/8FATRXFimgWQ6fAheTByKNkZdStK2gcCJssj7zGL96XhMsmEC7f+9bumhnjTxcH//RTnxY5BwdhmIHc1nv9J5zNxyzk0KlFqe5CepTuK0C7FmzOdUoSpj2+m5HdmFHHyr42k7imC/3jiHSFPzyqe5XXzub8dG1U0g9R2qKIPtYvF7gDw3F2MU35St6ahwC4A8BF4/4pzAhG4Q1X+c8QeCWq9izoNM6DD51tgnbjFVgSzGta2r1PMnDmR6W8dXa7FNZ/owHA==
Received: from BN9PR03CA0274.namprd03.prod.outlook.com (2603:10b6:408:f5::9)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Sun, 24 Oct
 2021 08:32:19 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::2a) by BN9PR03CA0274.outlook.office365.com
 (2603:10b6:408:f5::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend
 Transport; Sun, 24 Oct 2021 08:32:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Sun, 24 Oct 2021 08:32:18 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 24 Oct
 2021 01:32:16 -0700
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 24 Oct 2021 01:32:13 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V3 mlx5-next 13/13] vfio/mlx5: Use its own PCI reset_done error handler
Date:   Sun, 24 Oct 2021 11:30:19 +0300
Message-ID: <20211024083019.232813-14-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211024083019.232813-1-yishaih@nvidia.com>
References: <20211024083019.232813-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a42e7dc8-e167-4755-d7ad-08d996c8cadc
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-Microsoft-Antispam-PRVS: <SA0PR12MB45575F38ECFAAB578A5A64D2C3829@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GQLOq7kvD7UzwGHgaReJB/QDL+y8JDN8OjF0Mvxwm4rz7MbgyLM2V+8lkTCs2ij00iL27BMr1ns7DeEeNERfvgkomfZOECdFgLZxr1D2ojTwmZE2M6JMNLm8WN9wcFSdBBcJ7/QAcgMMdp5HRjXJ3UknVoAJBRAVLCJ+ru58sTmOFKTHblaRZDe1WQAV3coBq2aopstbwF/TLTIgAFcWMqDtvQKdtkTTMaVyDGquBqcG6Ezolzzo4XcQd//q9IXnC/XcqmsYdrb5y3Q+GT71cXHf2Hd4qtcZjINmnTUwWQV5RXYRP3LrZEebDUnQbHvbwpRpfqBHxhsL9O5vxnprHIjGH1tzWaJRpgGQk7yspiOpDAT7fz59mOBCCZeeyRxxC5r9cay7MvYqKkCfiTLxrJT4n5O4QWiuVPgmTFD2J0x4TIJMUQsZUFUoP1VcU3zDWq3PyX1ImG0HYeLMiiqCfwbi70h5k+XOyU2MdHyiQiCHJR8RRL3qyxUu+bTIHKvejZL1E4J6EjoqBlmHFcc7X05hniLskB73/Jc4ZD0k6boCI9KWwmX+EuiGmJ5J4987AnpmNwvbVhTXKpaBqQRDO0GpSPDHyzaQb/XEnl5S3mAf9OQgLfON6MtBvznU1KlZQlTDr7FyHxNh+qnAVQwShY+odd2dGJo9sO2zQqaji/JEcjayVLPRaJnj9/ULdlgmgyC+ieIt8+awHbwhO7T2Sw==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(8936002)(36756003)(70586007)(47076005)(82310400003)(107886003)(336012)(110136005)(4326008)(1076003)(356005)(83380400001)(186003)(36860700001)(8676002)(508600001)(54906003)(316002)(2616005)(5660300002)(7636003)(7696005)(426003)(86362001)(2906002)(26005)(70206006)(6636002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 08:32:18.8403
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a42e7dc8-e167-4755-d7ad-08d996c8cadc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
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
index 4b21b388dcc5..ca7e5692a7ff 100644
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
+	spin_unlock(&mvdev->reset_lock);
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

