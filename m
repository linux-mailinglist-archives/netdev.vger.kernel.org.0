Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5408B43340E
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 12:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235246AbhJSLBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:01:33 -0400
Received: from mail-dm6nam12on2080.outbound.protection.outlook.com ([40.107.243.80]:18529
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230117AbhJSLBc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 07:01:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j9aOe8B9+D5W+4SCEExNL865sEcECrOkZBy2Jg11ryN4p1JrNj/yuMoXjQfJ1J8KLbwOD0GYE6ToQa+rg9hLKAQ2bDiBNMuZPlCdLKWRiHzWe8sIvPPJ0VNxQNHDLF/uV1BZ+OXpFC0iP7CvUoUFO1k49Jn8j6P7ej+RSKRRL01lYLSM+jS+ExRFEKflWpdgWtC/P/hh8Ns+qAwXyGEnn0zz1+xfYpc5b23zesQSQcvHcKt5N4g9JZVTk4edmzi8wJAcnhNC2pebRFO94S3VHXL6ncG6N2/pwRA/SIO4kWmGcnSmbvLpKZoWpHq7w7VVZDBfqKgN3CybvxK9COYaNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4WQC7MbzY4SkKjUkPCgiLuU12kLGzfDWQ2BT0ZKYN6s=;
 b=gwdenvJQOR+y+CX67q3V3rLfmrv47GkvVYtHaK95f0ITjldOregAT7deq7hMWdb92Gs8PmRXiRcL3Sz29IuX7R2oFs4JgpT8R6eJRy0CU5iYQHYw0dUhLRgGk5RvFOz27e9bEZujheJATxbYetwLbnlkggi4QXWWKRrJ7wOo7IJExnwvtD69FsFXETvG4xXWcKSB0Gq/xFWRj7o+c/ScE6WpCiQmlGHdnmnT+ih5zwIpKUESrbqZvmlLf/1JyJxIGhx7VGVDSC8ZQkkLT0128iriF4llwyMvHKnmZQyHAo5Z8/2sDE5Kn/G/ReMdydq1sE6kWrzc/ffxtQMY/N07VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4WQC7MbzY4SkKjUkPCgiLuU12kLGzfDWQ2BT0ZKYN6s=;
 b=oagh23EyK636eF1Ha/Uiws+8fKg/0uFy7tPGUNstujGUrpyv68q3/30vo5814NxtxWvJH/OEAT/7YCYndS7yRAg9UhUu1sN/uWO75QHK6E6cvI0OfQW+VJ0Oxv/5LtTln64ppO4aaHrMRIfuRz/1fbozxFDybBfaZBF+Fvt96agL660BLQhzww/ivQPumUlgxbMQR/nmRhA5oPHAc+oy+E6xJ/qXa4aiuKCs5dpSWC3eDPRvxuEmNbkGtb+UZ6aU3bs6yOU5Htf9UBKKWvVEBLuhgicjK5ABG3hWSNujnzeQBxRC9jOd57aW85G1yAOpc7vVgK0KTNdWsurxsWvkjA==
Received: from BN0PR04CA0008.namprd04.prod.outlook.com (2603:10b6:408:ee::13)
 by DM6PR12MB4562.namprd12.prod.outlook.com (2603:10b6:5:2aa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Tue, 19 Oct
 2021 10:59:18 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::34) by BN0PR04CA0008.outlook.office365.com
 (2603:10b6:408:ee::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 10:59:17 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 03:59:13 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:10 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 mlx5-next 01/14] PCI/IOV: Add pci_iov_vf_id() to get VF index
Date:   Tue, 19 Oct 2021 13:58:25 +0300
Message-ID: <20211019105838.227569-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211019105838.227569-1-yishaih@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ebdae487-bd45-4198-4fd9-08d992ef7f42
X-MS-TrafficTypeDiagnostic: DM6PR12MB4562:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4562C16A0F45683327EC48B0C3BD9@DM6PR12MB4562.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VdmVEh/aFKsKFAOMC6EPfRj4Czc18wRjXpv0iI07nrHHhLWGngDRt4IR7Ffr0wkeTRwicVBN+K7S6XigVVYRqkL7/nSc2rZAfVhQ5Cse+FI3QxratnuG+WbTUGIBemZUfitK8ZZYVS6MeRug3AQDtlLjyDm+DCm493CLrbcJTmA7bGWRzjaYl+KN1vrz1zV0R8CD1NBV1tE7S8MkvLfqhIXp2/DuynBKFO9iELM4iqdqFWaHfltMuPJi4K3uV/OeiY8iWX7Uyh3zX6td/yGsmU69oBW7qTdSZvyC7USb3v7ppB5n44xorNST32vi/qpujgfN1PAb/0W0EG8yaf/xEsWz1VpuRbrIfVN43IxyB1W5ilJZLgsc+ErGWvTbFGJb1ndTdA3YrJgHwA76qKtEhiywH9qdgWS9J/280ZTD5HPOojunD7Jdlm/ZrwZ7KTl0MDoU7pbYdNI42QMqYidwAZr4MpZmhdea5FpMApsNQe2hZvEIhApXWgvXENebKb1nIH5z31+bgqA5qobxjDCara0AYIgaNPIFH02RrRPi+O/aWfZ5hkemIJQuVhH5NWv/HwZsoQbzPXlrsKppvCmwnw2oitUIDoYWgYDjMi2q62UBoKmILOfGdvhBp56Ipv+JVmFLcbWHC2lzek1HSZ61QUe4CSzXcSCYu1yMo6ire7rBhAfkgb4lV9okESWZMCTyZaK+OfONYeqGpn8orCnopQ==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(36756003)(110136005)(82310400003)(6636002)(86362001)(8936002)(5660300002)(54906003)(336012)(8676002)(2616005)(1076003)(426003)(26005)(107886003)(6666004)(508600001)(186003)(36860700001)(7696005)(4326008)(47076005)(70206006)(70586007)(2906002)(7636003)(316002)(356005)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 10:59:17.4480
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ebdae487-bd45-4198-4fd9-08d992ef7f42
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4562
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

The PCI core uses the VF index internally, often called the vf_id,
during the setup of the VF, eg pci_iov_add_virtfn().

This index is needed for device drivers that implement live migration
for their internal operations that configure/control their VFs.

Specifically, mlx5_vfio_pci driver that is introduced in coming patches
from this series needs it and not the bus/device/function which is
exposed today.

Add pci_iov_vf_id() which computes the vf_id by reversing the math that
was used to create the bus/device/function.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/iov.c   | 14 ++++++++++++++
 include/linux/pci.h |  8 +++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index dafdc652fcd0..e7751fa3fe0b 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -33,6 +33,20 @@ int pci_iov_virtfn_devfn(struct pci_dev *dev, int vf_id)
 }
 EXPORT_SYMBOL_GPL(pci_iov_virtfn_devfn);
 
+int pci_iov_vf_id(struct pci_dev *dev)
+{
+	struct pci_dev *pf;
+
+	if (!dev->is_virtfn)
+		return -EINVAL;
+
+	pf = pci_physfn(dev);
+	return (((dev->bus->number << 8) + dev->devfn) -
+		((pf->bus->number << 8) + pf->devfn + pf->sriov->offset)) /
+	       pf->sriov->stride;
+}
+EXPORT_SYMBOL_GPL(pci_iov_vf_id);
+
 /*
  * Per SR-IOV spec sec 3.3.10 and 3.3.11, First VF Offset and VF Stride may
  * change when NumVFs changes.
diff --git a/include/linux/pci.h b/include/linux/pci.h
index cd8aa6fce204..2337512e67f0 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2153,7 +2153,7 @@ void __iomem *pci_ioremap_wc_bar(struct pci_dev *pdev, int bar);
 #ifdef CONFIG_PCI_IOV
 int pci_iov_virtfn_bus(struct pci_dev *dev, int id);
 int pci_iov_virtfn_devfn(struct pci_dev *dev, int id);
-
+int pci_iov_vf_id(struct pci_dev *dev);
 int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn);
 void pci_disable_sriov(struct pci_dev *dev);
 
@@ -2181,6 +2181,12 @@ static inline int pci_iov_virtfn_devfn(struct pci_dev *dev, int id)
 {
 	return -ENOSYS;
 }
+
+static inline int pci_iov_vf_id(struct pci_dev *dev)
+{
+	return -ENOSYS;
+}
+
 static inline int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn)
 { return -ENODEV; }
 
-- 
2.18.1

