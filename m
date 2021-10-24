Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70DA043877D
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 10:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbhJXIeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 04:34:01 -0400
Received: from mail-dm6nam12on2068.outbound.protection.outlook.com ([40.107.243.68]:27360
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229844AbhJXIeA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 04:34:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e62/isbjChHv5CHnU/hoV2Nm9OKo7s+AqlG63TBI6CnYUV+9hxNSCEGVjZL6ZN0NyvYwfnMHu4YFKLxRXAmAg29jIb+osHvbwD99Q2Q/6f47ZIE1MY1CCPs0A4NmgElHTN6t77hpePSat0fIPgS1KWlZcQBd0suUXrdALKhpGeGSV4SHM3vBVZj3WKN4uu/5JYJ7lTSwW4bGabVrrksgJfLE1QtmQHr3vBkOS5gbd7VqVBN8KxcUoXOpZ2clT0ivAjq4eqHJ4zO4qjsRiAjLFoxw6SE3U8igbhy15wMJAVCPXtD9qHdwNMuHGpTsVupp4Czm5PHZceZUB/J28H7+nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4WQC7MbzY4SkKjUkPCgiLuU12kLGzfDWQ2BT0ZKYN6s=;
 b=btkj9FphTdBeObOjdIuUwMZSscl8c9zOmqLnHkN7kDv77zFROsUeUfTZoghLniqPywcvjtjTr3tuvFJdqgNIzX//p3ziBbZX+/lg5kShy/QpWGRwSQ1bi+ZqS+0eO624sGIy+UcmXP8S7hW9pHX0xmBqDDjOdMP2jeMb19EVfjmYMv4+fUDuduJEoP74tLV/I8jCc3PLJxHXMwrezIrO47r9RX3w8YVJXjdSZPRn4eELHLzJc0WpSyMw0KfcSTE7cMilHuYOyE63XfUvCEaWAc8chrrt9NITacKJiQoLt5xqiK1xV8IhCcKdmi5E4zOv80nxowLzItsQReg7eUuC2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4WQC7MbzY4SkKjUkPCgiLuU12kLGzfDWQ2BT0ZKYN6s=;
 b=Xws+8MU8/H4JWndIWbwNYOOCBiSiEBoHQVjgybO0X4J38GIA7S1oU5Yd/Q6p+vJM2EM9ukBNZmZ+PG7RCnjfTSTifLQ2MNHqL97UPYNJmReNP4fMgOtpsRFjRLCizzHxdn3yt5BXjxBz8HCVQ7WPwhGJmPbnwgRpd5VGFscl2VRX25LLHKqX52GY7Pj4Q3FBtL/h+zhgNr+7ndUXKKxHm1sTqXvBtj9gul1dm83TxiZzjsbohaPx+uiX0j2lwp3UOZRe6Id02TfRGU1sVxtwyEifFs2mP2Gg3RWIfLzggTHwT68R8utwUFBHJWKa2Qgyp5s+hjbnAS6o5nOICObTeA==
Received: from BN8PR15CA0011.namprd15.prod.outlook.com (2603:10b6:408:c0::24)
 by MW3PR12MB4506.namprd12.prod.outlook.com (2603:10b6:303:53::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Sun, 24 Oct
 2021 08:31:38 +0000
Received: from BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:c0:cafe::59) by BN8PR15CA0011.outlook.office365.com
 (2603:10b6:408:c0::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend
 Transport; Sun, 24 Oct 2021 08:31:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT037.mail.protection.outlook.com (10.13.177.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Sun, 24 Oct 2021 08:31:37 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 24 Oct
 2021 01:31:36 -0700
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 24 Oct 2021 01:31:33 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V3 mlx5-next 01/13] PCI/IOV: Add pci_iov_vf_id() to get VF index
Date:   Sun, 24 Oct 2021 11:30:07 +0300
Message-ID: <20211024083019.232813-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211024083019.232813-1-yishaih@nvidia.com>
References: <20211024083019.232813-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8203ec9-6178-4393-acf4-08d996c8b258
X-MS-TrafficTypeDiagnostic: MW3PR12MB4506:
X-Microsoft-Antispam-PRVS: <MW3PR12MB45068335E788FFCDC77345D4C3829@MW3PR12MB4506.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dpT14LwDUo11zj7Boh3kT7CO444V6oPkpfX9yzukqakMNjczrnayCbSJnt8LglDAAlnKxGN6cpPD+6AG6LyCtN2zKBMGRHC3VfT0z4eoYf+F/6fxIblBNzbNM33n3Jot8A1/9vNDZ5jJ0SaUeWNHyVJsmyqgrCBOEaLzVggh7mqQrfFuzddAIhMU/sJcrctmzN1EWPF826jdlJ+zJdOpvn28IHPtt/LkE4MSxSMNbUp6pZ5/4HCmlqozlQjRFcpuAbJ+wJvlTpp0FCK3xjUDwZoTWFVK1LaseGPJxoZ/7/Yssq8sitWndaq2Ahz7dLRievVf1vvB/aGnXOITW1JpiSR0/dSMZo8Nbpgz+M16WuYKjJGeJFTmcM++aDNoL2wjgDPXGbZlEH3TQrKHT0EhgIUFoX7AM43d2Mfa00QsMphv2BY6LlrK8wlWYmzp+4K9O7gNNoPBHe38s9g7uxOxvkqc8Yv0umYaDexkUe4GoSjlOoPExJrRRkrmTee04F2m7Y64z/lIB7EnaO3ishCLW1thuP3ObT9A/8N6FFkPtysWfXqqoE2/y+SLzCnEsECT1VcVJyFEPcVUAnROvnwh8MRUDAHncYGAE2BtLffSzqJSjv6s/LkT5yMRi5FfYZpJ4jywZa89Ez364KQXK1tcrdF8zU4Vl0Jxy3KSo1iSdhBzQo8ijybPsdRhXpV6eQid+fOHOIgYuCxc599qLH/oWw==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(26005)(6666004)(82310400003)(54906003)(7636003)(107886003)(356005)(186003)(5660300002)(8676002)(2906002)(2616005)(36756003)(7696005)(508600001)(110136005)(83380400001)(4326008)(1076003)(426003)(6636002)(47076005)(8936002)(70586007)(70206006)(336012)(36860700001)(86362001)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 08:31:37.7628
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c8203ec9-6178-4393-acf4-08d996c8b258
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4506
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

