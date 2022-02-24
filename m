Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5594C2E3C
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 15:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235435AbiBXOVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 09:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235420AbiBXOVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 09:21:48 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCCC14FFC6;
        Thu, 24 Feb 2022 06:21:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dS9cDG6pQ4hhLgnxDwCbYk0Esk/1yvJTbZQ9+Mc2oc/FPVQHcsgVavJxk42p87/BlVlmWxgtb6i6T7ihD3/pRrSr/A7MEAd5y9a7hgCTOEPDI7fZeLWL1Xfjy0gK5HpK4P0fALWr8gq8H6XUJjVyB3GZFGgnInlIceU2J/GS040+BX55Lkyc6nFeC/hZiw30QzpaJqJV47dLtH7SM/KWTXuyKJVlqhU7h+8onyvb4fK/QIURHrqW4NnPYi90hH8ti7J+NcmnFk1bXJDcqYWF3lCBN7yuQbxLBJjRWG/8TuxsKxz0IBorRTTCWt4xX3ANQl6MpWRL7sEyMwAY8fd4XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=huHD3ovZNc9rzQ0iGUHiVTaCqum+rUNRny5WgGaN18I=;
 b=dxVfvbRSyEDwjSY31IXHn6gF34i+UuylKa6pKC8Lq2FGBUBWHTJ+ZXH7KVxAsMLT9RKkTddH7twHWk1IJVkJUZ5uLBEcPdSV9DhFdPoatImcwhFne31/eDv5HlgBhmOHNtdjJvRxKF+PV2JVQWgP1KQwhotFMyFtKBXjOdJgqpfn07YShsSyNnmPFPvD40WSICe+xB+xm3e1DD1yQ8ZQhR4h6pcs4MSU5kSoL9/9vgv55uwlRKdGyaL2Q/cZMN21EY9wlDTJs9pjZS2HABxAELulaLi489b1U/HrNqj2jYwiIldC62mOo99NSDRT+Rnapaq5qvvXr3bNBpFhcb/EvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=huHD3ovZNc9rzQ0iGUHiVTaCqum+rUNRny5WgGaN18I=;
 b=i9SR7smxULGU84FWCHK+x5aG2kaaAylOlUBqeYppFOS3bfOFxOLVsfSoSF3QMpZd3VskOcajn8nigV9cAwmbCr6yaHYXLD1dKNsAqPdK19Md2T3BBeezcRhyRWcSl6pLCSyVFqnrOIyisaiFW5rzVHc9zg/OiJM87eMGrqM3841FkTLQzc4i+QUZJTuh4doetdp1VJCtJppG7X6gxEshjrQZpLrjqBmUdk5OroEWd+Bnqn2h9B20KcLV0+LR8L0JxgFTHK4OMImCbeSSj824SvLbhqgcmMfyroNQx9W35yCvQzxynnpxwV6vsZvuUPp9IM+m2gJr5FFoESQ7zTZJuQ==
Received: from MW4PR03CA0053.namprd03.prod.outlook.com (2603:10b6:303:8e::28)
 by BYAPR12MB3495.namprd12.prod.outlook.com (2603:10b6:a03:ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Thu, 24 Feb
 2022 14:21:10 +0000
Received: from CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::52) by MW4PR03CA0053.outlook.office365.com
 (2603:10b6:303:8e::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22 via Frontend
 Transport; Thu, 24 Feb 2022 14:21:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT024.mail.protection.outlook.com (10.13.174.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 14:21:10 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Feb
 2022 14:21:09 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 24 Feb 2022
 06:21:07 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 24 Feb
 2022 06:21:04 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V9 mlx5-next 04/15] PCI/IOV: Add pci_iov_get_pf_drvdata() to allow VF reaching the drvdata of a PF
Date:   Thu, 24 Feb 2022 16:20:13 +0200
Message-ID: <20220224142024.147653-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220224142024.147653-1-yishaih@nvidia.com>
References: <20220224142024.147653-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7e2a447-edde-4829-2c47-08d9f7a0e7a9
X-MS-TrafficTypeDiagnostic: BYAPR12MB3495:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3495CCAFEDF119A7956F0910C33D9@BYAPR12MB3495.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Huh4ocopUnwvcb1CXGegt6MVIR1fIuvRax22kXwDhejRyqIBrPPlJUGbtC60w2HAQ1YiEFhiTJQgw1skBvpqmgOWnVU4pKKys4kVnUiKhd7PJ12qdsrvjt0Ib3QQBkXyoyAQMYUAiAHYtwQdZxK9TVINkUKNwHk4yhIhbKs8i6gxnYT151gpZBE8JxGR/So+96c7oqXvH5K66u2HC662QygePDfpianPalO9xJPY0O1oGlOy4fV3Wzu3fcevuFeZj9bp0iuXWcMtizD/PlgDwS2Fjva0QgiXHvJ/b61R+fC/fLdr90XkyMsXwRSQ+tckcO9nOPwH+UPn6j7lGU/sjotft7Y1y+B9RPxI2duGGeC+j8gayu89Or8+PzUA3VjZ6P/eBL9nVHW+t6zG4VGJ/0uqUj/joiVQ9hG+PV+XeQFUpw6gVhnIXAPIqc/ecehVI2Cq9q+nAaf6eG5K7ZbK5+IL/8/MF3CdJX0GcA5pTjHzunXuliakftRvUMtOWq4RD/XAE1otLvAweKViIgg8Jx20dfbmuJAW5/9g6meEP18x19qXclShNCwE6e9iytKueQZ7YOyadCcu9Amq7FXE6BecvMaBK9j3TspMhgHmqu9Ffqtorf3OgVmlXrXz+4snnBL4t/cV0e7RpUQIivjLDnsnIZ4nCcKzmnkTaJbFgyBvyaKW6WCBwCkt+iFBNXCDlEqd94efqc19iPPf21PLUw==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(36860700001)(6666004)(2906002)(356005)(70586007)(70206006)(7696005)(186003)(336012)(81166007)(7416002)(82310400004)(36756003)(5660300002)(8936002)(26005)(86362001)(2616005)(426003)(1076003)(110136005)(83380400001)(8676002)(316002)(54906003)(4326008)(47076005)(40460700003)(508600001)(6636002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 14:21:10.1994
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d7e2a447-edde-4829-2c47-08d9f7a0e7a9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3495
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

