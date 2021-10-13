Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E1042BC12
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239333AbhJMJvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:51:52 -0400
Received: from mail-bn1nam07on2047.outbound.protection.outlook.com ([40.107.212.47]:26593
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239270AbhJMJvK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 05:51:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IeYI4dt69IRIHiDbYdRKc2b20AnAAPrrTI56/8oVLhUkyF3en96y7O27RHM8xp7n1GGZW5uXutsomI5yLqwIETOyuEgmom8kH+4ruwrgtEhHIpwxOHgJdxfz1WOOgZxV1WdNn4dY/w0K7CVwp4dhIQpXHc4PEDGSy6aUKIGAZcOMyfJGKrEVDbITwCKoiJTWWDux+WB5c1WgAK/02SA6LG4v4dvYY+r3+RpZTlWRYGicLZRzVoObfxd03FIZzkve+aPGY9RqN6f+UvXbRWSqKR34T2C5Na0Mc6A+EkmgcC7c8rNcnX5l8/jdHVe9PyQvMlQPfGIcxJLrtOi6k2UdlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xSIOmvEoHKRIcrswq83VuBpV0kREeMLLxaSFn8uc5u0=;
 b=FrkOAL9pkRk76aDTIcdzb50zdpfnXHzC7y8uGtShrxxc7egaG/2hNOX4cGg0hkRkjhKJydHl0F906+TF876MrstbEMthEn+5z2NGqRvhrSqzugezoNoZ8LG5nti1TONP81Fs09g77nPTZysNLgDl40Dyn76GSYOwHxQBtBj8eqVkIo4vD90ac0bUhO6fMcm921xzuVec+97gC/dIISEDZFET4+vObV1seTBUc8vWfayDHf0Ff9TA24nd4q0Q79OoMh7U2OGzPfLX6iz5W4Rw/ZYgXvnZa56oi2FrVWa820Z5YYK7yWZlre05y5teKrbjYbzqCPQxonlymYKCTN800Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xSIOmvEoHKRIcrswq83VuBpV0kREeMLLxaSFn8uc5u0=;
 b=W2sabPelrNFQq8KrzBeG8YcwDXLWebaIFXZyLWDkb/4Cod4IvC4ktr1311+wUh3QFc5UTs1gwJxB4hqV/ig4+GPuSPsqbQ8P/riMmMnq5NNDURQKIkzNZgAT29u6WWM7CQcKIiEYp2hXcgIl6tI9H5mdrt1pbYXrsf4lJ+g7MwMGpiPpkeR9Mp/X4SGdzwz42TrVr4bNWzueVxiPFHGED6SJTv2cA1m4sp5jOO3Ao1yxSww1NPSu+ILnULvPrFHjrPBGTi20n4dlJ9tYA+sgiMavgS6Hr81aVRPXTKz6lCshTRYu+2+Dz9Nhg3QVApdrmL3PpS2+4c5+N39n3VM9ww==
Received: from BN0PR03CA0056.namprd03.prod.outlook.com (2603:10b6:408:e7::31)
 by MN2PR12MB3200.namprd12.prod.outlook.com (2603:10b6:208:102::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20; Wed, 13 Oct
 2021 09:49:04 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e7:cafe::36) by BN0PR03CA0056.outlook.office365.com
 (2603:10b6:408:e7::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend
 Transport; Wed, 13 Oct 2021 09:49:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 09:49:04 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 13 Oct
 2021 02:49:02 -0700
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 13 Oct 2021 09:48:59 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 mlx5-next 12/13] vfio/pci: Add infrastructure to let vfio_pci_core drivers trap device RESET
Date:   Wed, 13 Oct 2021 12:47:06 +0300
Message-ID: <20211013094707.163054-13-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211013094707.163054-1-yishaih@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63525b10-d92e-4896-99fc-08d98e2eb17d
X-MS-TrafficTypeDiagnostic: MN2PR12MB3200:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3200D14DC7F4E8B625F2EE81C3B79@MN2PR12MB3200.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OGU5wc4tE+lhH2LsGbB/Y+uYI3LzhqjYmFw8uEsTaZjXiZurkZhSDZquQgMrU26GWum8Mp/X6VtLuqqXjPIXOHW6T2ksLzdNoZvfQEgoyZXgQZaA7U5NeHCmfcxS+IHeRgtw8CWQpSb370OO8LKCRhfvmsICNAY0Rjn9vcnogCK3rWXARTBsJxNG62q4sa3qUtvpn0gh4Our+np15xBIqrzniLsLw6akm0mqGDBaMxeLfl4ttny39MrgrQZ3ZtCDvesteRuqG9u4ka6qkhDwxOBWEEaZFNnlZSB28EU85dXwkJTxeZ0Hm1Dh6ukywDl9oIaHzpEOZauv7icj+LHqWoGth3vcwvKIIzRD0ukWldQpPE1QsiEO3zad1YPF1zoIhsUGfhnzHoOILmAMVLHTl+dcvcHu4TqYiC1eBzbTrjp4Rayp8LNJ+cQce8wqJuDop1xITBedvn3eBzc7RarJChGGr9YelCzrY47EmBYUzLVl9UMXhMS+qHd5321RqMX9NsU9sY1CIRVj+mdOSXMA1I5CjxwyyFD3ePpf1HmGzij6umpRE2/OyZqrsDx+KK+3CKDGrKTkYrwE4h60Fo2jdRNaF/p7FqJi5kZuoU+NA16aPYm1dvh8ExrFvmOAopROvjCIeUIloIulwQhuKgKC4+28r+tA9fB5vxlB7RTlrEfobtPHNR1C/nNlzua7JTDLyOmgLFQ8C9KO4/7HSr+8iQ==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(316002)(110136005)(5660300002)(54906003)(6666004)(1076003)(6636002)(2906002)(36860700001)(36756003)(47076005)(7696005)(356005)(107886003)(336012)(70586007)(86362001)(4326008)(8676002)(8936002)(508600001)(7636003)(82310400003)(83380400001)(186003)(426003)(70206006)(2616005)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 09:49:04.5225
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63525b10-d92e-4896-99fc-08d98e2eb17d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add infrastructure to let vfio_pci_core drivers trap device RESET.

The motivation for this is to let the underlay driver be aware that
reset was done and set its internal state accordingly.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_config.c |  8 ++++++--
 drivers/vfio/pci/vfio_pci_core.c   |  2 ++
 include/linux/vfio_pci_core.h      | 10 ++++++++++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 6e58b4bf7a60..002198376f43 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -859,7 +859,9 @@ static int vfio_exp_config_write(struct vfio_pci_core_device *vdev, int pos,
 
 		if (!ret && (cap & PCI_EXP_DEVCAP_FLR)) {
 			vfio_pci_zap_and_down_write_memory_lock(vdev);
-			pci_try_reset_function(vdev->pdev);
+			ret = pci_try_reset_function(vdev->pdev);
+			if (!ret && vdev->ops && vdev->ops->reset_done)
+				vdev->ops->reset_done(vdev);
 			up_write(&vdev->memory_lock);
 		}
 	}
@@ -941,7 +943,9 @@ static int vfio_af_config_write(struct vfio_pci_core_device *vdev, int pos,
 
 		if (!ret && (cap & PCI_AF_CAP_FLR) && (cap & PCI_AF_CAP_TP)) {
 			vfio_pci_zap_and_down_write_memory_lock(vdev);
-			pci_try_reset_function(vdev->pdev);
+			ret = pci_try_reset_function(vdev->pdev);
+			if (!ret && vdev->ops && vdev->ops->reset_done)
+				vdev->ops->reset_done(vdev);
 			up_write(&vdev->memory_lock);
 		}
 	}
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index e581a327f90d..d2497a8ed7f1 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -923,6 +923,8 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 
 		vfio_pci_zap_and_down_write_memory_lock(vdev);
 		ret = pci_try_reset_function(vdev->pdev);
+		if (!ret && vdev->ops && vdev->ops->reset_done)
+			vdev->ops->reset_done(vdev);
 		up_write(&vdev->memory_lock);
 
 		return ret;
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index ef9a44b6cf5d..6ccf5824f098 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -95,6 +95,15 @@ struct vfio_pci_mmap_vma {
 	struct list_head	vma_next;
 };
 
+/**
+ * struct vfio_pci_core_device_ops - VFIO PCI driver device callbacks
+ *
+ * @reset_done: Called when the device was reset
+ */
+struct vfio_pci_core_device_ops {
+	void	(*reset_done)(struct vfio_pci_core_device *vdev);
+};
+
 struct vfio_pci_core_device {
 	struct vfio_device	vdev;
 	struct pci_dev		*pdev;
@@ -137,6 +146,7 @@ struct vfio_pci_core_device {
 	struct mutex		vma_lock;
 	struct list_head	vma_list;
 	struct rw_semaphore	memory_lock;
+	const struct vfio_pci_core_device_ops *ops;
 };
 
 #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
-- 
2.18.1

