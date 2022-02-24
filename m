Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3804C2E20
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 15:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235407AbiBXOVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 09:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235405AbiBXOV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 09:21:29 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A76229A56B;
        Thu, 24 Feb 2022 06:20:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eI5GEToHrimgjjkco60dPu/E3Hfj2yhauQ+N6YEZlDpTQJws91OuHDTsapMYCuo8hPVcBVrAabpBNrAAfjimHn+COtAk+AUmgXjN5DwWf1Tht265ht8dnXiw7J5qwDqXzunqSdWWiq0KTCXp5VnvMn3tWbVwYhS2UzNmqnJtrAD6woFZiIyHY7rEdAf1G38T4lO1/f9zOOpXutEsBGeA1lg7FZG3/aPIu6h15T79YhJXOFGTdPGH8HFpwdpmKV0fYHz1AyyK804acxZ1EpoLnaSCz5lyTel0BkUpwavZaEL49ZpDPTU582hDlK7DXAJuIomJmffwZZGqHenWm7MQug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NultjMQVehi+CPwn9nKymN3VP3QKmVagd6D7Y7plSUE=;
 b=EFREEndvagIifCT4Fe/6tQtT+WHD+tZUZShRKmnpyGX3254VWyxCG7Tpgyy4VnHOxU1Ur/5n4RVN7jwnQkdlc3XP8nWYpzsAnyMXV16mX9yGgbkIDmVHBzhNYPIVNI+Lyot26RIMYP0a3RhLavg6n15W1aZxS6D5Sqtuvol50+RSMK0fRPuWbi3NsBqZ7XMjrtWkIBFcCLJepEF4B30CYFTg26Vzqk9K6ugBsgD9hXveNp4hys3MAhJ+D9bRr0eHoxywbGx3t1nQOGgCwyYoBstsfq/VbjqCzk2v+gQxNG3g/+HbK6jGAw5AIG9UvnZOQ1z0zwPo6hMoGUvIOR2VPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NultjMQVehi+CPwn9nKymN3VP3QKmVagd6D7Y7plSUE=;
 b=UUzcrZiWYrDTfHhrf+q9KHMuipuC8lPUOmIP/B7e3x0R6Wm+2CgPCWoAwypfsFPgfzddIFYrIL3qZSw65CQW9mEPei3MwiZosN/UJhvS87c7G8nS+dwxhla92L4ZYs9UWNnse1A+oRDf7QiXMxeb/S3iEOjaTEbpbjNTKEhJEaTCCNH3uMUx9MSyAJI5uxWL900FXqdMz/7CzT8l01FcBKIXb3IWkaYSt5YrRB+61OLaXpxIwnpAc05EtLA3ta16k03zUNkU5+SOptwsqANtIGbSX+jSv0Tg/8zxnhXZJqy0UJtVP18cvuizYEDCaoxMHc62QTbvGHcK+e+yJ/iswg==
Received: from BN9PR03CA0449.namprd03.prod.outlook.com (2603:10b6:408:113::34)
 by MWHPR1201MB0222.namprd12.prod.outlook.com (2603:10b6:301:54::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 14:20:56 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::b8) by BN9PR03CA0449.outlook.office365.com
 (2603:10b6:408:113::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23 via Frontend
 Transport; Thu, 24 Feb 2022 14:20:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 14:20:55 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Feb
 2022 14:20:55 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 24 Feb 2022
 06:20:52 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 24 Feb
 2022 06:20:49 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V9 mlx5-next 01/15] PCI/IOV: Add pci_iov_vf_id() to get VF index
Date:   Thu, 24 Feb 2022 16:20:10 +0200
Message-ID: <20220224142024.147653-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220224142024.147653-1-yishaih@nvidia.com>
References: <20220224142024.147653-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9e20089-0e69-4d31-f33a-08d9f7a0df27
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0222:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0222301509509B8FE1F6913AC33D9@MWHPR1201MB0222.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0RDSJvx68ivSP8ZKKAFgcMJfpttofR0IIon1fBcOBb0Qb3WMAg3oB+L9dnZSoqkaFiOXA90LZIEw6m6F2nDwH9d1h32pUhCT1xc88Ko18gWCG7sTbNJq8rPO25nEbSOr4nFV26r9r0tfl0EX9yrEdDneA0RduQ13ucK/KQbj4Es98vs+nBzmf5kAYAFs04JZRELx7tJyASWDmW037w1MgdlAmcJK3rhHKlcHxjAT5AoXC3BjlUy+d5kNEgca/6ZpBfqFO+O9TWt3Zk6sc0P4pnC52uQrkdsMm/IMuHVjlVSX2TQsR0gtetJ7QWymitMfzCOTeyleMAQexzMzS3Q/zKKqZpEfEOgOckBWTc0Z+ybteE650lcosfRKVa5RRJTZf9HygsYZrFi0Bf8rSmrJoelzYku3nRSFlEhuN0KmRCj3e7UefEAOcHEl36oi8fQO4TEBkS0B2Bb7B6CBHTn9Pk+WtmNWxIZA6hxqrB8UDubw79IRC8p7eOhAMtdZ2FUN5A+D5hx7YDk2uG4tRwFSSzaxbfjgzccoDPQ7gGPl6g0c9GqwVsuM6QEfFq40zf//qTTEK5xy4bIojmy6maIkY6+/krXIVvJTkZEtJA67STUjZcBfv6NGfhkjXhG6oabWUQJnJm07nSrWPNssGD+CbO2erG+FJFBKQeB7xnedZlVadI/pI9VjlMlMf2ruQsCqWEUuw+E0rtWDt095hV185g==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(70206006)(8676002)(316002)(70586007)(86362001)(426003)(508600001)(336012)(4326008)(83380400001)(82310400004)(7696005)(2616005)(6666004)(110136005)(1076003)(6636002)(26005)(186003)(54906003)(36860700001)(40460700003)(356005)(2906002)(81166007)(36756003)(47076005)(7416002)(5660300002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 14:20:55.8526
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c9e20089-0e69-4d31-f33a-08d9f7a0df27
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0222
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/pci/iov.c   | 14 ++++++++++++++
 include/linux/pci.h |  8 +++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 0267977c9f17..2e9f3d70803a 100644
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
index 8253a5413d7c..3d4ff7b35ad1 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2166,7 +2166,7 @@ void __iomem *pci_ioremap_wc_bar(struct pci_dev *pdev, int bar);
 #ifdef CONFIG_PCI_IOV
 int pci_iov_virtfn_bus(struct pci_dev *dev, int id);
 int pci_iov_virtfn_devfn(struct pci_dev *dev, int id);
-
+int pci_iov_vf_id(struct pci_dev *dev);
 int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn);
 void pci_disable_sriov(struct pci_dev *dev);
 
@@ -2194,6 +2194,12 @@ static inline int pci_iov_virtfn_devfn(struct pci_dev *dev, int id)
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

