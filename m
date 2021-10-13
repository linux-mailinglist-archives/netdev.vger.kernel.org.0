Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B4642BBEF
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238414AbhJMJue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:50:34 -0400
Received: from mail-mw2nam10on2044.outbound.protection.outlook.com ([40.107.94.44]:35744
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237993AbhJMJuc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 05:50:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dE5DlpXThmeMEAcgXVhdSX0KSKjAaTHCKn+Avl/IELcJoKX207cc9/wBGkJTfTuvGb9IWtxQ7OziLOrjgnYL1LWHq210geOKZUvqAnhHoukJHtWFSpHi1PyWte45NzqCLprF0gzxhnk5G9pO/JKkhAzxCErIdQF+S+AB/ThkR89xkInv2zTj8BlwBXJ5sdgdRfOFNpcGG6W9YF3l4TxC7OrtJOAh8k69te86dxR+UkJqNvcGOf20CFCSemmeZTA3ykObRf6zzz6OXtyIkPVEMxdJ9vZPXSdQFsVJlpXVNurbP/2SXUPH08QG8iORFXapjmZ3dsZuUHA4m8e4H8rG1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/bSabJTod8iBa7Cd2YyvY1nY5RPLeJ9SxAs01AZMaXQ=;
 b=bAiEL91Dx5P0yPevhHf7anIcjMALDheL2WyHbmThEJtxr9/uCX3LrG0LB0AMRlaR+Ds3uGKk6TnpcYSm31BOMsmnNLZ0bz4kFjcxFVnjzvKLQO4F/EK4Wdar7NsFOTZwe0dUdFImdr7et1nNS6w+bGqDDkG5dZi+7K0z87ByzfJBhSYSL058KsB86r+VTm1OY3WBDSqjitY0gOFckM69tO3XjItc0yTlClVXTfHjNAzt5U4xKOodddTy6J38FtKtodkHVaGwVIThnYoR6sMmv//V3DlJB+CwBePL2ro0n6Pz8nVXmTERNDLB0S+d+o2Um+iBFPQiWp6sl9zrQKscRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/bSabJTod8iBa7Cd2YyvY1nY5RPLeJ9SxAs01AZMaXQ=;
 b=IogHAm5dejT342+oL9J8Xnv9QL2XnOKiPfQL9Upy0jzrcNM9I9WVBQnMyfuOSKsbnmPcPUQUqTg4YN5twOzgasoA+VcmJgBH4dQsduIa1aUEVuHoNkJsQ/FdJUbGynhQMyj7qwvKXqE8uHSZe5Wox9wNRTlYGN4dw8V63H1mQtHsxj7o0LAgyjviioSzEFaKsAmN7FxNKuBGSog3GBYtSBccA32W+FcyXREGWgztT3tPIkW+IfzTPu/F9YnXfYhOcsxJlrit4bRNwU+IzHAUnlutguiJg28tY+Gn3crsOtL8urCm+fR4SaVaGByxq1kQv9xQChMm3jZ6Bck2cJky+g==
Received: from MW4PR04CA0156.namprd04.prod.outlook.com (2603:10b6:303:85::11)
 by MN2PR12MB3966.namprd12.prod.outlook.com (2603:10b6:208:165::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24; Wed, 13 Oct
 2021 09:48:27 +0000
Received: from CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::f4) by MW4PR04CA0156.outlook.office365.com
 (2603:10b6:303:85::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend
 Transport; Wed, 13 Oct 2021 09:48:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT007.mail.protection.outlook.com (10.13.174.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 09:48:27 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 13 Oct
 2021 09:48:26 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 13 Oct 2021 09:48:23 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 mlx5-next 01/13] PCI/IOV: Provide internal VF index
Date:   Wed, 13 Oct 2021 12:46:55 +0300
Message-ID: <20211013094707.163054-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211013094707.163054-1-yishaih@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 664ee17c-2a77-4e8f-1ac2-08d98e2e9b36
X-MS-TrafficTypeDiagnostic: MN2PR12MB3966:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3966E36A98F6384133EDB487C3B79@MN2PR12MB3966.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4M+hhRcO8VA9P6X9mPqoLwsR0g7Dg9sif0Z0aK9mHf/a2QYOD3oSZ/OfeNx4FI78PBpM999bB0YiU8joxWivjLnOm2Lmy2IBKQc4k9/ge0y4a12ducfibSPnUdskuMFZxwbYyrTciWSgzwETXwXzE0E38Ezt9xMO5maQOjcLKXR4wKSLAyhTtZLPNVZauYTZdWBRqLwNpRGPJqenQbwUnOYFaTpyA/mlqdgNdUr29nzi9mHZOQA1bnDbR36U4/dFMIeifaANe5k4q80me5m29yL7QMg70aQCrn/zj9rePqhHwCSgOsqEgU6xPiCEjjWuLtQI7QOAZpU0gC+/tuXCRW+GPBap52yhpBN9Ro3PzhfZsUL381F6rkckR6J6tcsF4AD2HMonrHKi6ogMCGHdhg7uHTEuIaZrnXwvEEIHxFbiTZyuBJfxa42LP4IiZ413guheTrdvSLJclxNMQjq6Nu3mvgcyt19u8YlZgZHn0UlMzXqGJAWW7hkd8EiOUuUCsIe4jSFnt7FjVa8y6peahjh8z3lFaMspTF5RfEO6EWc+E6uygo/B7o8euCLLariG200IZdPpmrFvCeh3Bq+WlTqwuQuwUJjyGwmBreS+T8RKnvQZ2Opfkb+nXdX8YgRfSC+2phWNx+X6cC2vXyXf5QwdFvL25aZpGygD9DZENTaQ+efqX/lRE5zO1Hb/Oc737H7U6ip9htJPDMkAT77dpw==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(70206006)(82310400003)(6636002)(47076005)(26005)(1076003)(7636003)(5660300002)(36756003)(86362001)(70586007)(508600001)(83380400001)(7696005)(8676002)(2906002)(8936002)(186003)(426003)(110136005)(356005)(2616005)(4326008)(107886003)(336012)(6666004)(316002)(54906003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 09:48:27.2270
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 664ee17c-2a77-4e8f-1ac2-08d98e2e9b36
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3966
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

