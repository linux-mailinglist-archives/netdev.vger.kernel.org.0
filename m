Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D1D43C704
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241303AbhJ0KAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 06:00:36 -0400
Received: from mail-dm6nam10on2070.outbound.protection.outlook.com ([40.107.93.70]:1761
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237126AbhJ0KAc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 06:00:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KsZSGP4K+3GrWz8SfcXHGPMwIaheA2eYTNbtNmNw1Uce1iCQaklkXZBOiol2iixSBFaFAK3Qtbo+F6kU/EFuzTCuS6fIx9jDGmPtszCP/un6IXuoeGoLgsh+H/eeIYnBUXsEMouQoarCzFb+3gW8gRme8jB3VOI41o3N9o7iFp6sf04qIJEO5YUZXOLqQZwI8YB4xWAObq9ezShgQnrta+FkvdWIm5g63E2C6vrj7mUNryH48w+D/D1HLEm9199LhVzoO5QvDTkWkMVUMk6qpjuZIv1ZtSW9AMlB06jWCLvizLrn8PAVNHVvhh8eeUgtkMcSs9ySsz3KYdDWgkzcBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PX8vNibUQ+77tQfzz+YEsNNh/fZeI9f68zyWZiZWxw8=;
 b=aCsjrCEoA9BYlQaqZbZ2Ua+7srm5X47JDNcLRA1MmQ6/jBPa1SqUGkK91BARhUGXt6knc3DUAbkon7LYCCLJet8TmMSonr2dEfrvFzsl6DAVamMz84sgutP3ydaZkGHR87Uf6cRivWhinxaBKutNHaNVfZn9L8uT8juhBei3n27Q8d0RWurcWsOwDbQZpn2pg0Hg7YWIIF9ySXDcxJCdaenybLumvE1SdJsdQcOPQfkI8ZMyAZ43TI2r12AgY5bSbsmFV5XxE8sizXNphEMmZAqt0BIfWNs1L96NHBqR1F8wiJTY4/NbaTj3avf+Ms0nU4TSgR49YIJpXTF9bQH2DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PX8vNibUQ+77tQfzz+YEsNNh/fZeI9f68zyWZiZWxw8=;
 b=cQmGflL3BQI7IT2EwBZGDGjF0GCRL+37ScZkcAGzdIWkradbKIKIFY8B5E/bvWOmCMdNOYZs15sVnODIFeJ3hSjGdTdkEP0b+pzztzAqenJxhFy6GIdzard8MoAbAE3b4XS5yAskw1XYiT4Bec8XHlLzeKShYAIaXiorfV8fW2nWmzsDoXduedCftbYNE8QJ4+Zz6m+eBV7YqxhBCj7UqfmbFjGzCOGzBkHBJzKb82ptuk5Epgnq5vWERJP7TfvxMyY1HjdwrJ2GDjAfibQTNeCPTK1g6EEi/Kenbe7kDwnJBHtQ3we9avRi0q5fuHwksIqWRxRV10UYTc24WSrpGQ==
Received: from DM6PR11CA0051.namprd11.prod.outlook.com (2603:10b6:5:14c::28)
 by PH0PR12MB5497.namprd12.prod.outlook.com (2603:10b6:510:eb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 09:58:05 +0000
Received: from DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::6c) by DM6PR11CA0051.outlook.office365.com
 (2603:10b6:5:14c::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend
 Transport; Wed, 27 Oct 2021 09:58:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT044.mail.protection.outlook.com (10.13.173.185) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 09:58:05 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 09:58:04 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 09:58:01 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V5 mlx5-next 04/13] PCI/IOV: Add pci_iov_get_pf_drvdata() to allow VF reaching the drvdata of a PF
Date:   Wed, 27 Oct 2021 12:56:49 +0300
Message-ID: <20211027095658.144468-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211027095658.144468-1-yishaih@nvidia.com>
References: <20211027095658.144468-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85387722-f879-4503-6e79-08d99930457a
X-MS-TrafficTypeDiagnostic: PH0PR12MB5497:
X-Microsoft-Antispam-PRVS: <PH0PR12MB5497D213CCE6B461986D4F26C3859@PH0PR12MB5497.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MpWyJkcnGhJccs/g1BzU27cagWvJt0xLFycQ2LBRTD3FRvl8/1baDVnUR7UX7C0BTukaCglaynT9e+yFoYinCjTqav0/1U9MXJsp6BS/zg1qMt+JlcRRsr/KLsCZZUG0mcWRUQjmjxVpMMHm8O7IBzwqVbMVLRVeM4a9rRmdonoZUn36QzYuxGuVRxBH9pBIkZemLwz0UGj3KSNvCsOxmGf6Z1zAyEdx3PNA7bj11RoLZO5e5evru88xeyPQRyAJ26hxxLRrVWqMTIzfrAa43udV+my9fOtCBpwvb37jxZ5D32RQLLcoHgX1Vd8ZcankfLLCdUxE2VGraqMSuW6JRiqgFcHPH30WLPt0/BT4XNSjmCPrXMpejF2oxmXgE+XgRLbBhM+NYH+7QoYt4tffDEdczl+C+fI/yF63R3CXoSOyQlnEVCamp9b3TugPW3XxIXb8VMGmgsxxJvFIE6ZGkOAz0M9vCYjKpfjyx6gkKhZgv++lO7R6llW6/m9LoWdWCCX1OK/2/BSt2KQc0foVkvewmtmc7os/abq/mG+vReUyYoAAptjn3LnmJWube46rAtcc/uv2LP+xJmkswqa7xsrq6Err5kL0ZjsVRh9nl9cU4tXBNZ1aLtEBJltjC/u1lReY5rEI/S6Lv5PjdBQ1HZLtvLIVDVnxNiFSwZdIj800pxthaWnMkPODTSHlqyJ8SM7qGC94QA/CYxTIwENTdA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(86362001)(82310400003)(36756003)(36860700001)(6636002)(110136005)(70206006)(7696005)(54906003)(107886003)(83380400001)(336012)(4326008)(36906005)(186003)(26005)(47076005)(8936002)(1076003)(8676002)(5660300002)(6666004)(426003)(7636003)(356005)(508600001)(2906002)(70586007)(316002)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 09:58:05.1757
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85387722-f879-4503-6e79-08d99930457a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5497
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

There are some cases where a SR-IOV VF driver will need to reach into and
interact with the PF driver. This requires accessing the drvdata of the PF.

Provide a function pci_iov_get_pf_drvdata() to return this PF drvdata in a
safe way. Normally accessing a drvdata of a foreign struct device would be
done using the device_lock() to protect against device driver
probe()/remove() races.

However, due to the design of pci_enable_sriov() this will result in a
ABBA deadlock on the device_lock as the PF's device_lock is held during PF
sriov_configure() while calling pci_enable_sriov() which in turn holds the
VF's device_lock while calling VF probe(), and similarly for remove.

This means the VF driver can never obtain the PF's device_lock.

Instead use the implicit locking created by pci_enable/disable_sriov(). A
VF driver can access its PF drvdata only while its own driver is attached,
and the PF driver can control access to its own drvdata based on when it
calls pci_enable/disable_sriov().

To use this API the PF driver will setup the PF drvdata in the probe()
function. pci_enable_sriov() is only called from sriov_configure() which
cannot happen until probe() completes, ensuring no VF races with drvdata
setup.

For removal, the PF driver must call pci_disable_sriov() in its remove
function before destroying any of the drvdata. This ensures that all VF
drivers are unbound before returning, fencing concurrent access to the
drvdata.

The introduction of a new function to do this access makes clear the
special locking scheme and the documents the requirements on the PF/VF
drivers using this.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/pci/iov.c   | 29 +++++++++++++++++++++++++++++
 include/linux/pci.h |  7 +++++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index e7751fa3fe0b..8c724bc134c7 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -47,6 +47,35 @@ int pci_iov_vf_id(struct pci_dev *dev)
 }
 EXPORT_SYMBOL_GPL(pci_iov_vf_id);
 
+/**
+ * pci_iov_get_pf_drvdata - Return the drvdata of a PF
+ * @dev - VF pci_dev
+ * @pf_driver - Device driver required to own the PF
+ *
+ * This must be called from a context that ensures that a VF driver is attached.
+ * The value returned is invalid once the VF driver completes its remove()
+ * callback.
+ *
+ * Locking is achieved by the driver core. A VF driver cannot be probed until
+ * pci_enable_sriov() is called and pci_disable_sriov() does not return until
+ * all VF drivers have completed their remove().
+ *
+ * The PF driver must call pci_disable_sriov() before it begins to destroy the
+ * drvdata.
+ */
+void *pci_iov_get_pf_drvdata(struct pci_dev *dev, struct pci_driver *pf_driver)
+{
+	struct pci_dev *pf_dev;
+
+	if (!dev->is_virtfn)
+		return ERR_PTR(-EINVAL);
+	pf_dev = dev->physfn;
+	if (pf_dev->driver != pf_driver)
+		return ERR_PTR(-EINVAL);
+	return pci_get_drvdata(pf_dev);
+}
+EXPORT_SYMBOL_GPL(pci_iov_get_pf_drvdata);
+
 /*
  * Per SR-IOV spec sec 3.3.10 and 3.3.11, First VF Offset and VF Stride may
  * change when NumVFs changes.
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 2337512e67f0..639a0a239774 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2154,6 +2154,7 @@ void __iomem *pci_ioremap_wc_bar(struct pci_dev *pdev, int bar);
 int pci_iov_virtfn_bus(struct pci_dev *dev, int id);
 int pci_iov_virtfn_devfn(struct pci_dev *dev, int id);
 int pci_iov_vf_id(struct pci_dev *dev);
+void *pci_iov_get_pf_drvdata(struct pci_dev *dev, struct pci_driver *pf_driver);
 int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn);
 void pci_disable_sriov(struct pci_dev *dev);
 
@@ -2187,6 +2188,12 @@ static inline int pci_iov_vf_id(struct pci_dev *dev)
 	return -ENOSYS;
 }
 
+static inline void *pci_iov_get_pf_drvdata(struct pci_dev *dev,
+					   struct pci_driver *pf_driver)
+{
+	return ERR_PTR(-EINVAL);
+}
+
 static inline int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn)
 { return -ENODEV; }
 
-- 
2.18.1

