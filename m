Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332F7438785
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 10:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbhJXIeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 04:34:16 -0400
Received: from mail-bn8nam12on2048.outbound.protection.outlook.com ([40.107.237.48]:15457
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231670AbhJXIeM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 04:34:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G6blWuZR5izm0cd9TmiN65UmmqiXlRDtcl/SNfYBuAXDxs7tffIvt567aa1bCbX//pwXfVOKjY2UoiQQ9tnCbRv10X+1UhU5QrKE/pD6xZnhR2l5aek6NpdbGkwxlFUPRuEihlpef/NgPTl8piIMx+ki8aEt9pkun2siUwx0U292u6a5gJsfJ9pNYHxUw8eQKbx21xVHeZLdaKRU8UsBaJPitVWE9SuiM5SXPjXgV8uIK+4a/XJ6g/H7A9D7XyosL+d/DSAIfSJq/PfivAN9oMzAZOIwIUvT8Mu9j/URG1YIVVWNU2BkQKMqgpy55B7hY6jD1E4mCdeL96WhtWbV4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PX8vNibUQ+77tQfzz+YEsNNh/fZeI9f68zyWZiZWxw8=;
 b=jAxGj5RzKLS3Fcmo6tOiRlnW2OrzI+5vdMTJVMx9z5i/VAKI6HvHjknqvE6mXp5efsr0JEEaDtnyExGiDwsOvUzS8WFHLCvO7d4xilWVChYJ/vGvt5q9ne2TqEDh4nc5Kqwh77d3KKY+tYNu/rZPBzEZQkNcGlA4nvrsAUzUSGEQJowqhooLCO3A1Q4VpH6uz0e3OaH+3/Z8C5z9/5CW/XBiAND4QFVuiJCnbiueaLtqDdZ/MF2Q/yGHPPdN5XomoRmLqBJFfKF5rVT1BxXu1W3oj5Ki3xgWyRw1TczUJBYKTqA53B79SPyaV9znen6PDQIL+HS6/n4rN5JYz1t9wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PX8vNibUQ+77tQfzz+YEsNNh/fZeI9f68zyWZiZWxw8=;
 b=YJl6h6ZPWxaf5bTWu3yi2IibT2a8MrYSHukvmwTfnj7mQcGzr7krKtrAE4aV3Tg7ExsIYLo9PiWMfxhAMIucpvXRGWYgKGTGPp5+GoRHl1WwIYcloqhiK5XIgBbUx1IVygjH8b49nEsBTefjHZ9PeglJR0iWFNNwzacfAjrPGRfCp+WYQ6kIX8XIoxChNsbeBQHOPekEbTFu5Wpil13YQG0Y0K7iR8AdqqzpazCPHeHAgZFSKFKlkgS1z2bAdtag11YAkj7pc3MAIb9N+HiV6cmgCuHYEkz3jdHp5V7wV1s00Eqz1Z5+Xf/cj4HG92tcjwD56bIlAN015jUuo76UQQ==
Received: from BN6PR13CA0067.namprd13.prod.outlook.com (2603:10b6:404:11::29)
 by SA0PR12MB4383.namprd12.prod.outlook.com (2603:10b6:806:94::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Sun, 24 Oct
 2021 08:31:50 +0000
Received: from BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:11:cafe::96) by BN6PR13CA0067.outlook.office365.com
 (2603:10b6:404:11::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.10 via Frontend
 Transport; Sun, 24 Oct 2021 08:31:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT034.mail.protection.outlook.com (10.13.176.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Sun, 24 Oct 2021 08:31:49 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 24 Oct
 2021 08:31:47 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 24 Oct
 2021 08:31:47 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 24 Oct 2021 01:31:44 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V3 mlx5-next 04/13] PCI/IOV: Add pci_iov_get_pf_drvdata() to allow VF reaching the drvdata of a PF
Date:   Sun, 24 Oct 2021 11:30:10 +0300
Message-ID: <20211024083019.232813-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211024083019.232813-1-yishaih@nvidia.com>
References: <20211024083019.232813-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 423a5e5e-94b5-4ec5-c97f-08d996c8b991
X-MS-TrafficTypeDiagnostic: SA0PR12MB4383:
X-Microsoft-Antispam-PRVS: <SA0PR12MB4383501552B4DEDA25605DE2C3829@SA0PR12MB4383.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EQqejJx+S0nPR1Ts7gRY9bg+ZpeiIFPdgy0gpS1+YzJvZh4++NwtfjSCD9OFTfy5W6cSLHf2mZesXH5XytVXzq8sfWK4KKyj9ai6ymxx8CpXPyrtBfZht64D+7/UjC7LfInvQwG3oYQh/4ZgvvkJ+g/XlULBTeFMjKW9Y3Y+6QY67v3ZmGatXRMZyOMTzOiRojVFRnyrBfpR9Fa11VObUkxkFBnl4j3qPCN4j8f7O8Ibaj9OKwUHwgdXmt/lrqsNNjvhlYoB2OClX0b2pn+FA5QJ2vBYv1VdXuADQzFOOOk6RqPlNihafeTr7DViON5JDYRkwMKvi3ggiJY5UP4t2AOT2Gm/LtZSx9ce8O+J9jU3enNNfnOksG1OfHsB8DiY+1o5soB1XvPRQQLleMtAALg+0m+/TYnb+wlysRnePi2g1fFX0C8MoEj+qcikO2AzzHc482T4WMPhrzERQ538nrjLqto4n3DmKAXpWaGz3Avf7YID0GqdWqvIAautjWb3vYebvJYtdC//tq0kj44Cc1KQ3dCFawJKR3nl5BV8dKH/kid0ajICzn/mFzdykoEqz/0PyUhvco/+TV+Zh53rr2Ptn3iE2P6yqFT0WO/jeA86TrdzEGjiWhax7XDfxEhXX5NgcLpMhlnE9WQTGaGSOtvFGTbPBP89KeiA1apl+5tL6AhAQPIyc1s00/Qu9TwDoqG0fmPJXi8X+h6/utioIg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36906005)(7696005)(316002)(86362001)(82310400003)(36860700001)(356005)(26005)(6636002)(36756003)(508600001)(5660300002)(47076005)(186003)(83380400001)(70586007)(54906003)(70206006)(6666004)(4326008)(7636003)(8676002)(1076003)(336012)(426003)(2906002)(2616005)(110136005)(107886003)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 08:31:49.8851
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 423a5e5e-94b5-4ec5-c97f-08d996c8b991
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4383
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

