Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B26C4BCD99
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 11:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243589AbiBTJ7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 04:59:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242828AbiBTJ7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 04:59:01 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2053.outbound.protection.outlook.com [40.107.236.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6539454191;
        Sun, 20 Feb 2022 01:58:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OqKlOQs3Knw7uLrvozKYGSktFLbfQZJ8YAU9MDFdj99RIOCF0Og29SckwGvwXju1F4NgsKIQqCy7F/7V1nO1EE0DFiBEWZAH+u8dRfuiK3f6hTfJId/VmxyS3Sq2B6ex2h3rK/z+C7id+TyI/UsIcyZhGyfHP+U2PW5xyatzpaMSoUQVZfpWEY9QxfQTHdzJ5d86vzsC2DAG+tWjl/SJMa2+3jU2n4mi5D7aOLECOYzBQpNCdvBqqPEPPLaUMZ9e6nAKOeOHDdDsKfc3+r9JlKGN2eCX/lVehHVJFvTFw8B9nh7ig4mMCoa8gDE+WdaNdQGfPoBdE3SwiExMWtTXtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=huHD3ovZNc9rzQ0iGUHiVTaCqum+rUNRny5WgGaN18I=;
 b=bIxESURoA51boNIcCXF734yYenEho7u3RsFvQR9xzlTbpyNCnzkopixcgMmqVZF9ogiMdxPPDoH0y2Kpr5G6w0Sh+qsv63JYPdSDxkVUna+QmhqYTxGO2NTGTq7LmFlZ4JthnexDgcNyPMDbQy5xk8XAWf+P7aZ2NYtP+IxG0T+bIukh4QtVMJ5sjz6pH+pplSqopHDVO0kTBkDd79FFJXUwgEqa3Orr0IUVlkgZf6mmnXBmUKKGlBZvVz2x3MRuCPS6a7eK1XFi4jvS0Fk22Ni+gP79MMVV+lVuyOGQPSpxXKgxi9g1sbhj+gM4+CD7Ay47OuSTu9FNXuTjOM7ZPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=huHD3ovZNc9rzQ0iGUHiVTaCqum+rUNRny5WgGaN18I=;
 b=Irg8IeNzd4oMGBqST7i35abtMTp3ed9oqHZK55RUH56CkjVCcVDFelqzf7Vg4xmBHAz79g+K0IH54WOV/aWhjR16tqPVr8Uavx1PrzL8TyIbLLQjm/P5I7A1351fVFtTdJQa/YOril7bFBcF9QG5U+z2PBnls1yvoiyha2ol/cUToD5G0xQ/qtFRcXtay5TnnutlZK8WSKphvg8mtqycGJH9L3SjMhWARj4jymQCTgheC1Y/BfDbydassYG8M/jay5lu/Qh5jD9EPbF2R3m1E9IhRSpGy9ei6FWVTDzkpF6cl1Ygw7mQKQcBETpHPll9AaW1ubxyH5Lgq/pO9N/7OA==
Received: from MWHPR13CA0012.namprd13.prod.outlook.com (2603:10b6:300:16::22)
 by MWHPR12MB1806.namprd12.prod.outlook.com (2603:10b6:300:10d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Sun, 20 Feb
 2022 09:58:37 +0000
Received: from CO1NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:16:cafe::a4) by MWHPR13CA0012.outlook.office365.com
 (2603:10b6:300:16::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.9 via Frontend
 Transport; Sun, 20 Feb 2022 09:58:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT025.mail.protection.outlook.com (10.13.175.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 09:58:36 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 09:58:36 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 01:58:35 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Sun, 20 Feb
 2022 01:58:31 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V8 mlx5-next 04/15] PCI/IOV: Add pci_iov_get_pf_drvdata() to allow VF reaching the drvdata of a PF
Date:   Sun, 20 Feb 2022 11:57:05 +0200
Message-ID: <20220220095716.153757-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220220095716.153757-1-yishaih@nvidia.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8df2c4b-39d5-4b6a-1927-08d9f4579052
X-MS-TrafficTypeDiagnostic: MWHPR12MB1806:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1806414FCD4B044279A12317C3399@MWHPR12MB1806.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cqM+kj/q9CcLymX2x0HUghCNBxji9Yqvbm4L9roFNtB+yyOH4zKwBu0dEpVeIC2yy+a3jEQjPZMk6cHNDdKo4kJtSZEyUunPBh/T/Mr2I1FSLpZYJbVrDHJkw+Vy46b/N+hqt+j/zoFeWrE8OdBuZCAqEbFQjHQNnmDDd4Uv8pSe0DS4/T/MEfAbdYTLnE9DcA+OU23Ouy66byERr7W2C+T0f9ieLhKq/z63qTRdoqBV+iCZP6IAM4DYD0jdG89YMuMyQ7tSU1PJrWFvT3evrKD0HduBD6K+UgwXYfLeMgoip0U7cUZgD5vP1ZtNG1cmjktwTMkDh1/2XGU7lqJ04QCOvU1p6PSj3YIvCNfyHh+vjwKYc22v/ng4JCcealcjGLxgfofCOGIP56CjrpUTFZ0Y0L6K91wq1ZQNlQFuMspqqprao2clZTWeOry8S/mAOjrPTYuA7c32kBmzxAjie0ybtXxhclnVZ4ynND/GiaM/EJDgMCDSsJn+S31Zd+DzFmQyZvITww6j0j9WI17z9f8e1iuMFQH/DqfKj0CWBJMZHiKsXWzvKf84PBhRFb2WAR8l4RUENO24QXcBEuCYBLWC9G/a8+XW3hs4uGS87Mx+1IFXV7bjhnve2VIPMI77ms4zdhnCx7Ds+MQ+htX9MT2mBQdih2qhGQT2La3yfWPTbgDcp4xHEfxw8Z9H/JzMsICXE1rywbw7kK/nZopKJg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(54906003)(6636002)(110136005)(5660300002)(316002)(7696005)(7416002)(8936002)(70586007)(508600001)(8676002)(4326008)(40460700003)(6666004)(86362001)(82310400004)(36860700001)(26005)(186003)(83380400001)(70206006)(36756003)(1076003)(2616005)(336012)(426003)(81166007)(356005)(47076005)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 09:58:36.9173
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8df2c4b-39d5-4b6a-1927-08d9f4579052
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1806
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

