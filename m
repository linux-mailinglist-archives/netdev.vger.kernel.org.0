Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B5B42BBF8
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239165AbhJMJun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:50:43 -0400
Received: from mail-bn7nam10on2079.outbound.protection.outlook.com ([40.107.92.79]:16544
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239088AbhJMJul (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 05:50:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oGhCoGTrs0Ywgr6I/vtO11luWYntUKB2XGkSYdqOSLjOBsY62Tew+F/SbZ15eu8ZZzeOFuUT7tUlRx9vu+sZUyhG3+t91qz3aYLPcePVN5pSd5PK+wYM3dAGApgcgaaUrVMguTtb/78TpF78nuwKm8B91CUivPvPN5oun5ZkLbPrhq8+uM77PYzX0i+NcHMsMg3r+u3NWqF/rLSVJtZjKki9VaaErZU/a203M7I8h0ieCb0sMofyEtMrH9SBk0O6d2OI9l5LX/jA8iWdl7VU+n0sv6UdNdfkhWTps73SOLEXXlY4uWBqsZeBgCFepwA3OzvhVWUqeSgY4WZnzym4nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cv9rIA1aETU/Br6Z1NTt9bnAf2Pupu0QwloBKZrPakY=;
 b=BtAm8psB2Bz+qYcXYhm9tb0wU/a0AQmTfx/vDsXCuPkCHCpOuXu5ct1w1VY0223+xIJ4BkvAJzjWVLfBLpG1KplMgz1KwwhcE37Rwd0kbBvRs1HUBJTJJzLvLq+blS36KgkbKZ2ZCjrsRH2QHqG98UtmfRe+4dQXoWV2uYnJ2Fu6+0G4i4eDsDzME/WedjL4+OJ+3QTE9FJN5hv5fJKU2/bBf+fA8QCNL1AMkzQd5pVL719GFPpI11WSqIc4ISSbLsnBCMUao0TI8ZlVM8bAH3HardyqgHCwAPFMMMO1APQsYdyaprzW4AlNlK0W2n60RVzsYwAZTKqrQhphMNdnnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cv9rIA1aETU/Br6Z1NTt9bnAf2Pupu0QwloBKZrPakY=;
 b=NryLKTHv8aepXol5wgPZEkdXXrgG8wcKjWR3rJEFdfRbAagRdI122RHQvBezmzK/XGDbkuE/KYhXQ3NxXnxC1Gza0gfTfCZMfGGI2tz5EER0dIX1q6QCTgwijOsB9txkSjUA60M9oj3YNaamfyAQZhQXYkEndRNjnhWUzSnnpYYeSDRH1Bg9hNJAeJy2kYzUjMsJjWp5exzMah5EvC4hC9z/ezjmF4XAjzlhn+nlAFjBJd5ywOp4Rx+8g0hVa0ZxOBRB9Nk19PgK58VI1tK0nFSW+A3QxuVWC81Kan85LhPB4ppx/3LZ/TZizDOf6B0mMdcD+vgpDtnycIJBjofZcg==
Received: from DM5PR20CA0037.namprd20.prod.outlook.com (2603:10b6:3:13d::23)
 by BN8PR12MB3378.namprd12.prod.outlook.com (2603:10b6:408:61::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Wed, 13 Oct
 2021 09:48:37 +0000
Received: from DM6NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:13d:cafe::89) by DM5PR20CA0037.outlook.office365.com
 (2603:10b6:3:13d::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend
 Transport; Wed, 13 Oct 2021 09:48:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT032.mail.protection.outlook.com (10.13.173.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 09:48:37 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 13 Oct
 2021 09:48:36 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 13 Oct
 2021 09:48:36 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 13 Oct 2021 09:48:33 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 mlx5-next 04/13] PCI/IOV: Allow SRIOV VF drivers to reach the drvdata of a PF
Date:   Wed, 13 Oct 2021 12:46:58 +0300
Message-ID: <20211013094707.163054-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211013094707.163054-1-yishaih@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31490a3d-8463-47be-389b-08d98e2ea118
X-MS-TrafficTypeDiagnostic: BN8PR12MB3378:
X-Microsoft-Antispam-PRVS: <BN8PR12MB3378F93BD44AC612EF802C9BC3B79@BN8PR12MB3378.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ie+kPxsQKWKJ4UlP4jZm32Rbz2FCNErcDbydfi73bd/FEz+CeymF9C48jSuDmXaauPo4O1PXklO3aSMzV8G0aDj1xEmSwpjoenIwFP4WQw/cTRS9g8Asbo0SVRbUjDJggmoGH7LJ7GtcJBFMDqlc4XrNNRMfT/Xh0T7oHITsCp/LBK1RJvLCVzmP4Gsr1dudKOc2uT3CuJgEHJRYG3OD10nZN3Wefljf5FehUaQjPGMXKFDOh8CmSbsyRVMhGeNajKG1qocTC0ew57flL9UaOhSiRgy2ntiTR6Be7dxVqh5aXuf6rryR4u/9KG34s7/dgCoONHbqLMy26dbsfYaSa10hgsEc7suzErqh5Tfva8/qhX/BCjNWZEgyf5yyZv06DNkUfLQbPP9A8re1VlLx19j/X9MYUbqMsgZ5JaktUt3Wx9/qQz61/MfiG+lpcoWZq+DzXq+Lg6fFyQ6gux8u/sXfWIwDjadWgYazwZY476nc32elKJjKVkHHGphKRtLkjtO/fJ3WYD0mO2S9ctUg73xJB3VYs420Z1wkgjvyK3vA98saViE7zxUuKQ9Hdl7a+FGeBL6LHAbGJG1ogspm9MVlCufkxa04NzBlvlzkXS+RlG9HLeoV+6sGjSIzkpaoEFNjNOwh/F1N0mv/CTOzsVijWiN7rqqH6CFlruyytl8HizD7MC9j9YxAuYS1SSruxtg2rcazfe/hr70D0DFF3A==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(316002)(36860700001)(7636003)(8676002)(4326008)(356005)(36756003)(5660300002)(2906002)(8936002)(110136005)(82310400003)(7696005)(1076003)(86362001)(107886003)(54906003)(47076005)(26005)(70206006)(70586007)(508600001)(426003)(6636002)(2616005)(186003)(83380400001)(336012)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 09:48:37.0875
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31490a3d-8463-47be-389b-08d98e2ea118
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3378
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

There are some cases where a SRIOV VF driver will need to reach into and
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
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/pci/iov.c   | 29 +++++++++++++++++++++++++++++
 include/linux/pci.h |  7 +++++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index e7751fa3fe0b..ca696730f761 100644
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
+	if (dev->is_physfn)
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

