Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB897433416
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 12:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbhJSLBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:01:45 -0400
Received: from mail-bn8nam12on2048.outbound.protection.outlook.com ([40.107.237.48]:12897
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235313AbhJSLBm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 07:01:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mI4pWCMtcuZ4//lLN5vovN7rhPFsliPlLI5vArjXOi8ID85GQnabaEX8y2bGSKzuYBPca6wpT3hFdGMbneHccrWjc+S+8qFIjCmQzTrH61ehEjtX8sDLGQU2DnyqBl1fVTuT4f0rZvDOuEKZ6wkUbolq4CC6qOc+G98DuROP7o/r0dK7cBTx15XQRmPGTnUmdOvckF2IpeFgEJXyKwl0NFuNcI2Fdwss3oN4Z4gIbA4IaFmuzgzLXOgt9lxnzac/V83lhSKbYgADwUwnCZ59cdt66ZRTBi9/lqY+sDXAR4W7+mZ5yDYpQy8sZOSDzHtcr4Wp9gEC7Y5d45FxkTpzKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PX8vNibUQ+77tQfzz+YEsNNh/fZeI9f68zyWZiZWxw8=;
 b=nQYXS2MCo+Pvv/rIKnFDQMUhKSNos+CtZf5YY1cpiSJtlBOWPs+S5+I4n0shKUO0lTfAyJefnbDxO1rtDvxQ6DCr9V3tMWF6EeHR9Upwm+iEg686DukIdJtFzza0HsqsMZ6h8RmU7cTOtMhNqwggPy+4rUDsjBvmkA2T64rVybxWw/3g3XQM8BabDPoJlrKsEWx+n4WKMEchPvFPdWuM/QBCxwQgeoVcziHftqMdep2qBFssdDf/BFjoQTJvh8t92eUTpJjvtw6qlbzPMtnPCO1PfAAor/3MPY4zI/uDG740RAelBSb1uHyogXvOpdVkCMCmuZWh352xWubMsSCFYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PX8vNibUQ+77tQfzz+YEsNNh/fZeI9f68zyWZiZWxw8=;
 b=XfUXOvVn9KZXBCZbxxMWx1aIE7CrxGh0g138PPFBnUJIKVykZODzmdG74lRKN8DsDTaphYcBq0MJgIFaMi8PzuSPxmM0KNfIphsUwwmvZOo9LcyaHb2bwy2y4mbMLP8RNcpLWdN51LmD9PgvIDs2d2a4hqZS/L/Pqluxm0Ym42d5+Zj4UoPSYoR6e8igGy2CFZeO0DpkMXiG59DszaH9wkvf6514CL40pEJrkLF1wu7nnPBOrBYZRB4Y6Mq+3DdCo3vnmszehVCfnCWJlxvQKYDLZEG8zCAufIhrJSJ6uzK62PpLigO9eMWmGCtG+R/7MeG+cZ4rCazvrqIICJjgDg==
Received: from BN8PR15CA0016.namprd15.prod.outlook.com (2603:10b6:408:c0::29)
 by SN1PR12MB2447.namprd12.prod.outlook.com (2603:10b6:802:27::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Tue, 19 Oct
 2021 10:59:28 +0000
Received: from BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:c0:cafe::f0) by BN8PR15CA0016.outlook.office365.com
 (2603:10b6:408:c0::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT008.mail.protection.outlook.com (10.13.177.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 10:59:27 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 10:59:23 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:20 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 mlx5-next 04/14] PCI/IOV: Add pci_iov_get_pf_drvdata() to allow VF reaching the drvdata of a PF
Date:   Tue, 19 Oct 2021 13:58:28 +0300
Message-ID: <20211019105838.227569-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211019105838.227569-1-yishaih@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f697d0cb-f59b-4715-fdea-08d992ef8539
X-MS-TrafficTypeDiagnostic: SN1PR12MB2447:
X-Microsoft-Antispam-PRVS: <SN1PR12MB2447353399E9B3BCF4F1B68DC3BD9@SN1PR12MB2447.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FmAnxwlkMmz0bEjvfhggbbwQjA6QEL+rXYtbH7gGLlz856M2vB9wFhG+K6fsb4eOhJmj3cGG6qYiC268nsEMPOHyocJORl6Hf95yN7OAlhSV7AHoowWqRv5fLWIbxlBiz9LRjzKSON4dKXn2yXNOiFpGwP/GKK/RNUJc+WsdhQckONQRytmSWHY2uZWPo/ye3i5LYkOg50QgdxwAujMAyDVbQnKsy9Fo5G3mxZjVt5BZ43XCj0EscF+beRJ4+XvtLcFfVsgWRFzP1phslDoqqePyRfpLZ4s05bC3JnviYTZAbvYryOSlw2c24JhrkC2vIifviIfb05Rqtp6b/S4GaAxvy6o0Jr2nWLVgOE14/IWHf/MtwGYzyUd4eBPDooEyVJn+h3Csd5RfojFPM9QBxhKCViSVtUI6hw4EsI34tsAUm4Ftzb6vDr2v2yY0EX9HHZodwZDWNehhLFfKlYNd30IEB7rGSLQb1ikQxx6ldX34LzTOl/I7acAyJkk+xNtPQDLuAtzQhZWbNf8ARndlRSZ5bynwWTFO+ZHfbemkM+F1TOKlVUL9VVfvcEJh/QNSJzu5KIwtvA2SuDbpUJSvmztIOI2JIWYfr1ukAX27QXtsQMyqSzD7trszMDMuoaPOHGrgD+2RUVcT78kFbR8u0361SvhuQw+CYofArZ3Bxd+IKvQjsP77aZBKrB8CZL0OnISeZhi5T9n3TrKhOD2zOw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36860700001)(426003)(82310400003)(26005)(356005)(36756003)(186003)(36906005)(70206006)(4326008)(5660300002)(86362001)(7636003)(336012)(508600001)(8936002)(83380400001)(110136005)(2616005)(70586007)(54906003)(6636002)(7696005)(316002)(8676002)(2906002)(107886003)(1076003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 10:59:27.4198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f697d0cb-f59b-4715-fdea-08d992ef8539
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2447
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

