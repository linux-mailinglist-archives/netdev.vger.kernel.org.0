Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81FEA43AE9E
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbhJZJKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:10:03 -0400
Received: from mail-mw2nam12on2049.outbound.protection.outlook.com ([40.107.244.49]:27104
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233795AbhJZJJu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 05:09:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g1T7oP8sAlYWlJVt6eg9XchLB0wCbF2Q5GUJFHXRYxb9V4Gf7r8J3n4/9VcwdSw6Sxr+Sjw+gm6sW+Q+6z0LoEY08tgcUmE8UPOGazeCY4SCE+SdCZxWWdHgMNqIB6ojONfHpaqXZpoooEl1lfhiIRTmf1bNazJ3Az0SyvvhO7sZkOk7whftGbbsxGdxVNZMCLBCBI4YMzSsxKToHc4k8Fb7KHYmI1ooCq0r5tqsM+uFl4A09B4ccxXMu6AX+4oRpHkwIFHPCrkYnsq+ijDHS4rYvy3UEqgLEAYRMzz4SeQLKvzUxy9ayUpQcJMMcu92UWbcs7OKbu3MIDpPo0Db7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PX8vNibUQ+77tQfzz+YEsNNh/fZeI9f68zyWZiZWxw8=;
 b=B6hK7/pyK6CT8JU7QFvxim6ibSHzwbsADcVEkwIQpvm2E7/ySl7wswKKTVcikAIIRoCzKFr0+pzorLtfbYwchGiG0r8SN82gQfRoOGfTfGowQc0HqOJ2taglk1NCAcC063jnFfLOa8vt1QkrOxyc/g1bvN54wDluCbXU7roSYt87003m+VUTpHdRKpTN4hAxgR3lmIlySlyUeLWsA5ajVpBF5Jm8o2zFQF5bQM211Louc0Z3HGyjYuxqxD+4TL7NH7VN0/2D/WlOT2fpvr9959BgrSdmzM6R6V/Sht+iIueEMDgSpuNwiQhEoMhj1DIxR5uullF4JLVoVkdPP5Qhig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PX8vNibUQ+77tQfzz+YEsNNh/fZeI9f68zyWZiZWxw8=;
 b=dsvC8kO1ZLAdkzz3aCALEh47sjQtOegVjlhnhvI7yAyytwO3F8yQZJ/MRopTF/uj6FcM89JhCOzn022ZiAkXdFQPM2oJbBAGGUHb1R3/UhoAfJNjOpfmCWk+V8hupLHZkVXBX8g6hQOOPRafg5dB8r+7L9YbKOg6Z8rrUijLkFPWUZJzXM/YWdjMSgZO2JTCmD+3oSXqqC4AwRSN1EHcE/51f57eGVEBLoz/Ot7nnPFA3A21luhf8m3PbBuhSvDmzMGcqGikgaxklXPdY7ZVFOe1TLhLhRvbLgzpGtITrcFQJNWdCEdWqTTpQzANxa8RupZIQ9ok5Yt28owywzp3SA==
Received: from DM5PR15CA0026.namprd15.prod.outlook.com (2603:10b6:4:4b::12) by
 BN6PR12MB1681.namprd12.prod.outlook.com (2603:10b6:405:7::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.18; Tue, 26 Oct 2021 09:07:24 +0000
Received: from DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4b:cafe::31) by DM5PR15CA0026.outlook.office365.com
 (2603:10b6:4:4b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13 via Frontend
 Transport; Tue, 26 Oct 2021 09:07:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT041.mail.protection.outlook.com (10.13.172.98) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 09:07:23 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 09:07:23 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 09:07:19 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V4 mlx5-next 04/13] PCI/IOV: Add pci_iov_get_pf_drvdata() to allow VF reaching the drvdata of a PF
Date:   Tue, 26 Oct 2021 12:05:56 +0300
Message-ID: <20211026090605.91646-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211026090605.91646-1-yishaih@nvidia.com>
References: <20211026090605.91646-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1b3b9f7-b179-4261-87c1-08d998600659
X-MS-TrafficTypeDiagnostic: BN6PR12MB1681:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1681ECC12265F08CBB1DB741C3849@BN6PR12MB1681.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2hT4fJRKBI3Z4suNdmY6jKx1epuA1NCyfbY345mOsRWuLdsDT/UpSZ025+vttMR46svu4bSFk3WIne2iwX716joAXdbPiwvLwfjLMuNHmOO4sfUUZ8i7fZGWG0CBuXWttuAcNNl4ccoBFJSZiSbaeyQ+hu3Kska2UXGYiKHJ1L4bu6t2YXjxKVF/taZmG0rspy063qHq2u4aRE0EqBT4MJXip1Uf8CIsdHfbTTeaq8UtkCk6lsr7oU2JCmi4KDg9x4MFCD1HtRhBYj2W29NXag2VRaRFs54gILf7PnSHDy5ftd3tJ8DC72V2UdLQUK6kp9V3wibpG34X+H6yohBD4LZvfLh7/59jUD7TViLZqga9i2rLAvn6e/b0NsF3OPJDqLbCnkbnWn0+cvlh3huh+CXKHCTIimaKnMg1q0Ie/mRVfvGkEfdhdEgXU3dhpwA3IvI9430wOV4X4VM7zWilNn8bjXRBHFmm9UGVx3v18U54GwLsEPdCF7bsPW7KsY98Agl2KU169ulOtUXdoFGiqnTR9cI5CXpib1XQYX0pXpKXKxWUfPXC72vc1PzopjkrPaC5zBW/4co5ETBVDD8QS5vGBmK18cJOGuIP1Wr2tVJ6xyUR06UJkiqzHPL3A5oXidrlNtmYna6XWN7We5l2PrHBjXvzx5GNh4Cumj9eA+siYR33n7Wr2ac9/B1d48gYxCjz2KRECkZt7vGHi5GXwA==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(7696005)(82310400003)(6636002)(26005)(6666004)(36860700001)(8936002)(83380400001)(356005)(2906002)(7636003)(70586007)(4326008)(70206006)(336012)(86362001)(186003)(5660300002)(8676002)(1076003)(110136005)(107886003)(426003)(54906003)(36756003)(316002)(2616005)(47076005)(508600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 09:07:23.9339
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1b3b9f7-b179-4261-87c1-08d998600659
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1681
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

