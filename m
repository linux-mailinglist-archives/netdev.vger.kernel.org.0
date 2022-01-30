Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82804A378F
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 17:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355559AbiA3QPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 11:15:12 -0500
Received: from mail-dm6nam08on2084.outbound.protection.outlook.com ([40.107.102.84]:7009
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355572AbiA3QPE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jan 2022 11:15:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KzsURB9N/buvaKA7g8C8meozkxAlnp3BUa5cIB/ZbrCwN0iAt5PzB+ITm/iRYkucx3g7X/7iVtlTQBqQxOL4vhwSZ5p1vj8YummE70A5IVNgUKollzsukZKMlDGuKv06NqSJo10FFNKFSKzoilIWjsY6IL4Eq4bjC6t8uyCSO0FDYP116tVzu/rKsRNEONYfeo6KyXdhY9jmfc4Mj+5IybhNICrNATzUo1dkUz1qdcfqgLiLgqwmlTUsg+CIY3+xIuyoI2+T9zn8vdHpKbVa5CGffGfi8fTUWte34LmvH/Yo2QBvJPeaJn67uV1MJzzi4zbGQoLhmtaZUuOCAArn9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=huHD3ovZNc9rzQ0iGUHiVTaCqum+rUNRny5WgGaN18I=;
 b=BSAFynGfi9P8/2RKczaMOtx92lNemV9lrlX2cFQj10My5JU3XIJHy5zDWYKfo56rrwB6xb3QgBQI3i7VjH+gSmgmWmwI59iQyNMVp0tSbC28ZPIMcXr04QyuS/eeETWudPeddrI/URy0w4JVqg0U2ZhKJEHKl/wrEpIjbm5kY6TDLZmGQw7EF0fkjxnbxTK8tXuGoWtI9iiItIYOHPg9oEpPdl8fN7YIsxsl4OO45t3XyAqiq8Zv1l0ChYvUr5+lATTjrpqsruBZUdFmRFkrVBsdN907rWNmP94Ft46WNQG4K7f2aiMxWdWUn7kB5GJdauMQxoI0WyCAZBZBUf1avQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=huHD3ovZNc9rzQ0iGUHiVTaCqum+rUNRny5WgGaN18I=;
 b=sGCpeg5g82XaE5ipQrBFmoL/htHewtHibDERkMWuPmeufTTc/g7PNZjTVVW4Za9enReZ0rigRYvqPyhOPlPeM9vuceWIVo/0CZ4VP/IWCmjFzVyf7UWeAbyFr+7gTM/ZZ0v6LX/2em4YTlr2ftuhW9Tp8pKP6W6Gz4qSamK0y5nC/mb5dc/LjV0tJJMDE/dkEWTwg4js0oIHydTGWIuynKXMgDLKBgRfT7r08fXg3Ip9RpVAT9U5ykIL1C0uwGfgBcIkGBsJ7pSkSPdzdVvrNN+PQ6IsO4rdOsM9y/3XYoFjrsHrbvTUPmhUfTauZBvqwfmfEvBV+YCidQbISg4cXA==
Received: from MWHPR11CA0023.namprd11.prod.outlook.com (2603:10b6:301:1::33)
 by CO6PR12MB5443.namprd12.prod.outlook.com (2603:10b6:303:13a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Sun, 30 Jan
 2022 16:15:01 +0000
Received: from CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:1:cafe::52) by MWHPR11CA0023.outlook.office365.com
 (2603:10b6:301:1::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Sun, 30 Jan 2022 16:15:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT024.mail.protection.outlook.com (10.13.174.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Sun, 30 Jan 2022 16:15:00 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Sun, 30 Jan 2022 16:14:59 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Sun, 30 Jan 2022 08:14:59 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 30 Jan 2022 08:14:56 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V6 mlx5-next 04/15] PCI/IOV: Add pci_iov_get_pf_drvdata() to allow VF reaching the drvdata of a PF
Date:   Sun, 30 Jan 2022 18:08:15 +0200
Message-ID: <20220130160826.32449-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220130160826.32449-1-yishaih@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f166d07-8ce4-4d6d-ee63-08d9e40baa95
X-MS-TrafficTypeDiagnostic: CO6PR12MB5443:EE_
X-Microsoft-Antispam-PRVS: <CO6PR12MB544309A59B4658E2B7A1F0E9C3249@CO6PR12MB5443.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nFa46Kdj0ryTIN4iEEOPvcVRrVT+ewT4yIKBhEvolCClpIRNu/FCQ5ddCIsirypEGrpsOXGBmrQsJHcuy/8uEUHsjSQtzvqeu3kcBIpDx4L11oD3PBwNS6sGo2eWeYKzp0PlbypRSo0nIE3tmHxUFJVMZd29//XEv1pjq8Ne+kH8TJjl9ozhM6ZAFVuIocJRVM0Ig2RwHZ2skNCMx/NWvUQ+vcrky7zGryHQIQMcOd7pKOM1pI7/+knZp9H04/ld5FjM1ciW+sHmurDSXyrjziTqpsC4mve0HMZ+DFFxoioZGiRxAEFZbDxEwnhFwpCGTAPR8d3zKtTHskhsY3zXjg/Q/QLiK4VLwdelU2CLlEFKsQQWwXF7219lTYygrPww6Wl8+nMTGbklED0bARi8f6loUmOxdUQHz/WF4wc9lbIcV1xRtPi3MeJMeljJGkHpiVIVmqTqgLdJFN7u33mhxLu0Cj0LvtHw5v9fDjpX7kYv54iFef4UNkz8ueQGAcCq6PjYjWVT6vs28bqNVw0Gn/3OxHdLgQhFb78nJ4FXHWFIwdMHj1NfT5DeyT5dnrNjeLAEwDSTxNLdhjj9aGk9/K77/nsoMbD2LrUAZ08NIoqRtg4sAIk1oF1qcyVG82Za/4Mhy0I5AQFQFKVxtI9DrvnuWbrM8J+Egx6CXDZxyrEN9+OsQfvIAtazGsbKvTExPv4zJJhRiKldG+KL76irRQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(356005)(336012)(110136005)(70586007)(6666004)(54906003)(426003)(36756003)(82310400004)(8676002)(70206006)(6636002)(83380400001)(8936002)(4326008)(81166007)(316002)(36860700001)(7696005)(5660300002)(1076003)(186003)(26005)(508600001)(40460700003)(47076005)(86362001)(2616005)(2906002)(107886003)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2022 16:15:00.4705
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f166d07-8ce4-4d6d-ee63-08d9e40baa95
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5443
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
index 2e9f3d70803a..28ec952e1221 100644
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
index 3d4ff7b35ad1..60d423d8f0c4 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2167,6 +2167,7 @@ void __iomem *pci_ioremap_wc_bar(struct pci_dev *pdev, int bar);
 int pci_iov_virtfn_bus(struct pci_dev *dev, int id);
 int pci_iov_virtfn_devfn(struct pci_dev *dev, int id);
 int pci_iov_vf_id(struct pci_dev *dev);
+void *pci_iov_get_pf_drvdata(struct pci_dev *dev, struct pci_driver *pf_driver);
 int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn);
 void pci_disable_sriov(struct pci_dev *dev);
 
@@ -2200,6 +2201,12 @@ static inline int pci_iov_vf_id(struct pci_dev *dev)
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

