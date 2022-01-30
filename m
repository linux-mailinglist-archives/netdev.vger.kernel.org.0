Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46FD24A3795
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 17:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355607AbiA3QPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 11:15:19 -0500
Received: from mail-bn8nam11on2085.outbound.protection.outlook.com ([40.107.236.85]:12897
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355602AbiA3QPR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jan 2022 11:15:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cWqUM1/7lZ0keQx0GV7R6U6zMyUfp4paSuKURThYHujDLAHon3puuGt4ikLHJYIH8nWH+CuCZoWLq8783CQRmpNAOKZ8LFdzu+xouh3k8HLB5xpZgckNp0SrvkVMnhmEMN3yM1OTvjf8FxHKm8mFr3hZrLMLJ0I6d17+BUCZbb29XUjCIG0LOdaR1BB4oYt0TRCFKSHwpAoizlmhEIYZ6xRJSzhfL0SNBDAnEjfcH5hm1n7j8j6l/ZySf4rJ68Oxy9nD7FUB71OUaHEw/ffpQwxaVKg/7Cyn0pfLCOXrJG1Ad1juTiYEmO1jBdp7qJuDU61Z7K2707zYeGYMf9q7sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=luLR/5eOsjxSK/wUaU1c7tLlZVqG4OK20BeMFQxPs4Q=;
 b=PL9s2Jwg+ZN7uZReEzjywBtrLT2Avmz/KdKmdqJpn2zKYhtJdptWZ+cSHm2wKZfcyLf3XXbCeFEZcFZ8eswk0WWS+W0QtElz1V2v7ZfR6JvY5G/cOUr7QNaGa8PyXRBCjIyQuEiGa8JyGlHNbMA2ijDsWYZiUwKL+IVJ0VaQgtGNlZEUWQbkXwzWOJ1pxIYFvUZ6ZQ3Yu0qSl1UVK2oZeWLwJVjHmsBoNUdp/YzQ4XF6jsHa2J25d7sEBMc2WhCpU8JnWIB0qkeaPgEiBqE1qawqFBNPJby0qd0vsNS0Esnso/CEe5U7N+EhO947aQyfoGDrJYrK6xtpySypACjlcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=luLR/5eOsjxSK/wUaU1c7tLlZVqG4OK20BeMFQxPs4Q=;
 b=RHC0xMgNo5dRfl2S/hnqxm8LEhfP7Q1BJptEfc4GewfxIJDpsZorhas3gHRi2u85MMI8UwN94Tr2pJnJlXqocrTCKMbI2QklahBhr81uPfkbJCrUW3BAZz+s4x0wWp9JU6chElIkJesLotUzwUFk9+u/cTfv4s2XEYQkrfbIBUsWYOJJeIt77azTF+Fajun3DRiBRcBX9cUR60nYyqqEcW3xjO6UqswcFAAUt8t6xm6yPqoGBfznw2O3pZG2xUe+eIzHItbmibKj1hQBU6LEPrvBXvij4CyIIUyyDoVLQt7zc65HsiGQp2tofZsO9yJZngMe9xkO7ZndXMhxPtB9jw==
Received: from DM5PR16CA0023.namprd16.prod.outlook.com (2603:10b6:3:c0::33) by
 BYAPR12MB2805.namprd12.prod.outlook.com (2603:10b6:a03:72::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.18; Sun, 30 Jan 2022 16:15:14 +0000
Received: from DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:c0:cafe::21) by DM5PR16CA0023.outlook.office365.com
 (2603:10b6:3:c0::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.21 via Frontend
 Transport; Sun, 30 Jan 2022 16:15:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT045.mail.protection.outlook.com (10.13.173.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Sun, 30 Jan 2022 16:15:13 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Sun, 30 Jan 2022 16:15:10 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Sun, 30 Jan 2022 08:15:09 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 30 Jan 2022 08:15:06 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V6 mlx5-next 07/15] vfio: Have the core code decode the VFIO_DEVICE_FEATURE ioctl
Date:   Sun, 30 Jan 2022 18:08:18 +0200
Message-ID: <20220130160826.32449-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220130160826.32449-1-yishaih@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84fab4b4-bfa4-49f9-cc21-08d9e40bb22a
X-MS-TrafficTypeDiagnostic: BYAPR12MB2805:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB28050FE5DC0CBF5DB61212E6C3249@BYAPR12MB2805.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wXCTTeGsK9+4T4IjoH5dpSZyZwAae/+XbrwkzNYtV4GhHFhjBlHt6QxmbwL9IdjhdBtyhzqwynw/oqDIk3s9Tf/pBFpBuN1swWErqHPeD+Za2SHI0m5zlR7qbBRV7H1Nkpncjc8Zd8eW2Mn+cVQmma73JMfowiYg+PNGddUbaLcYzsrnYlO3AdJ6AYjixat2RAp+gjoCFzZ7AnpbL0DZGiC3+UVM50yvs9i7Kzk3hyJAW76AmhJD2H2oeF+yDQ+AA6x5UMdoODeAB9Z0c/5K24dUj70GUWeOCkuBAWq5msAJ1NpoL+h1U9EdMQosqASjpswmZ4LWGwafZXTui0ChJVm0mLJNh27qFSoBNdmNFiiTmUCSL8uYyg21uo1eGu35Lu1oSAEX7MAFww3KfDh6rx3HhpE9PM3A0DIdilRldwggaNSTs/i1uD66yQdsj3CDxL4TB+zEM//TkyOSq8j97m32eVZQ4vkdZqzFLicJ2Yy30PcJFbflrBsfTC0Vc7sHic27im6Gb0kao+Ssfp/e2pxztyq3gKvq1ZODUglzdUNhQRf52/4bwxKQAZpKdrwDkBKlc69HGtTPDnHXNwpDDOYXkxWk0Ed2RhQbja1zwCaUmh98blgUm1V4FtBJa5htwBI7iLdaYVbRONV+KcZzCu8/85xWZpbOcQL1EtoOBLNcMJ9bPxz+TPuEGZ2ASQHJ1y2Efg4fhVGJxMx/7z5e9Q==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(336012)(426003)(107886003)(2616005)(26005)(1076003)(186003)(47076005)(82310400004)(86362001)(508600001)(36860700001)(7696005)(6666004)(83380400001)(2906002)(70586007)(70206006)(36756003)(4326008)(8676002)(8936002)(40460700003)(5660300002)(316002)(6636002)(81166007)(110136005)(356005)(54906003)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2022 16:15:13.2995
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84fab4b4-bfa4-49f9-cc21-08d9e40bb22a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2805
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

Invoke a new device op 'device_feature' to handle just the data array
portion of the command. This lifts the ioctl validation to the core code
and makes it simpler for either the core code, or layered drivers, to
implement their own feature values.

Provide vfio_check_feature() to consolidate checking the flags/etc against
what the driver supports.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c      |  1 +
 drivers/vfio/pci/vfio_pci_core.c | 90 ++++++++++++--------------------
 drivers/vfio/vfio.c              | 46 ++++++++++++++--
 include/linux/vfio.h             | 32 ++++++++++++
 include/linux/vfio_pci_core.h    |  2 +
 5 files changed, 109 insertions(+), 62 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index a5ce92beb655..2b047469e02f 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -130,6 +130,7 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.open_device	= vfio_pci_open_device,
 	.close_device	= vfio_pci_core_close_device,
 	.ioctl		= vfio_pci_core_ioctl,
+	.device_feature = vfio_pci_core_ioctl_feature,
 	.read		= vfio_pci_core_read,
 	.write		= vfio_pci_core_write,
 	.mmap		= vfio_pci_core_mmap,
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index f948e6cd2993..14a22ff20ef8 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1114,70 +1114,44 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 
 		return vfio_pci_ioeventfd(vdev, ioeventfd.offset,
 					  ioeventfd.data, count, ioeventfd.fd);
-	} else if (cmd == VFIO_DEVICE_FEATURE) {
-		struct vfio_device_feature feature;
-		uuid_t uuid;
-
-		minsz = offsetofend(struct vfio_device_feature, flags);
-
-		if (copy_from_user(&feature, (void __user *)arg, minsz))
-			return -EFAULT;
-
-		if (feature.argsz < minsz)
-			return -EINVAL;
-
-		/* Check unknown flags */
-		if (feature.flags & ~(VFIO_DEVICE_FEATURE_MASK |
-				      VFIO_DEVICE_FEATURE_SET |
-				      VFIO_DEVICE_FEATURE_GET |
-				      VFIO_DEVICE_FEATURE_PROBE))
-			return -EINVAL;
-
-		/* GET & SET are mutually exclusive except with PROBE */
-		if (!(feature.flags & VFIO_DEVICE_FEATURE_PROBE) &&
-		    (feature.flags & VFIO_DEVICE_FEATURE_SET) &&
-		    (feature.flags & VFIO_DEVICE_FEATURE_GET))
-			return -EINVAL;
-
-		switch (feature.flags & VFIO_DEVICE_FEATURE_MASK) {
-		case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
-			if (!vdev->vf_token)
-				return -ENOTTY;
-
-			/*
-			 * We do not support GET of the VF Token UUID as this
-			 * could expose the token of the previous device user.
-			 */
-			if (feature.flags & VFIO_DEVICE_FEATURE_GET)
-				return -EINVAL;
-
-			if (feature.flags & VFIO_DEVICE_FEATURE_PROBE)
-				return 0;
-
-			/* Don't SET unless told to do so */
-			if (!(feature.flags & VFIO_DEVICE_FEATURE_SET))
-				return -EINVAL;
+	}
+	return -ENOTTY;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
 
-			if (feature.argsz < minsz + sizeof(uuid))
-				return -EINVAL;
+int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
+				void __user *arg, size_t argsz)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(device, struct vfio_pci_core_device, vdev);
+	uuid_t uuid;
+	int ret;
 
-			if (copy_from_user(&uuid, (void __user *)(arg + minsz),
-					   sizeof(uuid)))
-				return -EFAULT;
+	switch (flags & VFIO_DEVICE_FEATURE_MASK) {
+	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
+		if (!vdev->vf_token)
+			return -ENOTTY;
+		/*
+		 * We do not support GET of the VF Token UUID as this could
+		 * expose the token of the previous device user.
+		 */
+		ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET,
+					sizeof(uuid));
+		if (ret != 1)
+			return ret;
 
-			mutex_lock(&vdev->vf_token->lock);
-			uuid_copy(&vdev->vf_token->uuid, &uuid);
-			mutex_unlock(&vdev->vf_token->lock);
+		if (copy_from_user(&uuid, arg, sizeof(uuid)))
+			return -EFAULT;
 
-			return 0;
-		default:
-			return -ENOTTY;
-		}
+		mutex_lock(&vdev->vf_token->lock);
+		uuid_copy(&vdev->vf_token->uuid, &uuid);
+		mutex_unlock(&vdev->vf_token->lock);
+		return 0;
+	default:
+		return -ENOTTY;
 	}
-
-	return -ENOTTY;
 }
-EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
+EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl_feature);
 
 static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			   size_t count, loff_t *ppos, bool iswrite)
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 735d1d344af9..71763e2ac561 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1557,15 +1557,53 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	return 0;
 }
 
+static int vfio_ioctl_device_feature(struct vfio_device *device,
+				     struct vfio_device_feature __user *arg)
+{
+	size_t minsz = offsetofend(struct vfio_device_feature, flags);
+	struct vfio_device_feature feature;
+
+	if (copy_from_user(&feature, arg, minsz))
+		return -EFAULT;
+
+	if (feature.argsz < minsz)
+		return -EINVAL;
+
+	/* Check unknown flags */
+	if (feature.flags &
+	    ~(VFIO_DEVICE_FEATURE_MASK | VFIO_DEVICE_FEATURE_SET |
+	      VFIO_DEVICE_FEATURE_GET | VFIO_DEVICE_FEATURE_PROBE))
+		return -EINVAL;
+
+	/* GET & SET are mutually exclusive except with PROBE */
+	if (!(feature.flags & VFIO_DEVICE_FEATURE_PROBE) &&
+	    (feature.flags & VFIO_DEVICE_FEATURE_SET) &&
+	    (feature.flags & VFIO_DEVICE_FEATURE_GET))
+		return -EINVAL;
+
+	switch (feature.flags & VFIO_DEVICE_FEATURE_MASK) {
+	default:
+		if (unlikely(!device->ops->device_feature))
+			return -EINVAL;
+		return device->ops->device_feature(device, feature.flags,
+						   arg->data,
+						   feature.argsz - minsz);
+	}
+}
+
 static long vfio_device_fops_unl_ioctl(struct file *filep,
 				       unsigned int cmd, unsigned long arg)
 {
 	struct vfio_device *device = filep->private_data;
 
-	if (unlikely(!device->ops->ioctl))
-		return -EINVAL;
-
-	return device->ops->ioctl(device, cmd, arg);
+	switch (cmd) {
+	case VFIO_DEVICE_FEATURE:
+		return vfio_ioctl_device_feature(device, (void __user *)arg);
+	default:
+		if (unlikely(!device->ops->ioctl))
+			return -EINVAL;
+		return device->ops->ioctl(device, cmd, arg);
+	}
 }
 
 static ssize_t vfio_device_fops_read(struct file *filep, char __user *buf,
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 76191d7abed1..ca69516f869d 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -55,6 +55,7 @@ struct vfio_device {
  * @match: Optional device name match callback (return: 0 for no-match, >0 for
  *         match, -errno for abort (ex. match with insufficient or incorrect
  *         additional args)
+ * @device_feature: Fill in the VFIO_DEVICE_FEATURE ioctl
  */
 struct vfio_device_ops {
 	char	*name;
@@ -69,8 +70,39 @@ struct vfio_device_ops {
 	int	(*mmap)(struct vfio_device *vdev, struct vm_area_struct *vma);
 	void	(*request)(struct vfio_device *vdev, unsigned int count);
 	int	(*match)(struct vfio_device *vdev, char *buf);
+	int	(*device_feature)(struct vfio_device *device, u32 flags,
+				  void __user *arg, size_t argsz);
 };
 
+/**
+ * vfio_check_feature - Validate user input for the VFIO_DEVICE_FEATURE ioctl
+ * @flags: Arg from the device_feature op
+ * @argsz: Arg from the device_feature op
+ * @supported_ops: Combination of VFIO_DEVICE_FEATURE_GET and SET the driver
+ *                 supports
+ * @minsz: Minimum data size the driver accepts
+ *
+ * For use in a driver's device_feature op. Checks that the inputs to the
+ * VFIO_DEVICE_FEATURE ioctl are correct for the driver's feature. Returns 1 if
+ * the driver should execute the get or set, otherwise the relevant
+ * value should be returned.
+ */
+static inline int vfio_check_feature(u32 flags, size_t argsz, u32 supported_ops,
+				    size_t minsz)
+{
+	if ((flags & (VFIO_DEVICE_FEATURE_GET | VFIO_DEVICE_FEATURE_SET)) &
+	    ~supported_ops)
+		return -EINVAL;
+	if (flags & VFIO_DEVICE_FEATURE_PROBE)
+		return 0;
+	/* Without PROBE one of GET or SET must be requested */
+	if (!(flags & (VFIO_DEVICE_FEATURE_GET | VFIO_DEVICE_FEATURE_SET)))
+		return -EINVAL;
+	if (argsz < minsz)
+		return -EINVAL;
+	return 1;
+}
+
 void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
 			 const struct vfio_device_ops *ops);
 void vfio_uninit_group_dev(struct vfio_device *device);
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index ef9a44b6cf5d..beba0b2ed87d 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -220,6 +220,8 @@ int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn);
 extern const struct pci_error_handlers vfio_pci_core_err_handlers;
 long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		unsigned long arg);
+int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
+				void __user *arg, size_t argsz);
 ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
 		size_t count, loff_t *ppos);
 ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
-- 
2.18.1

