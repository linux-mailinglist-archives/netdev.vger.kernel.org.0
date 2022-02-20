Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C213E4BCDA1
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 11:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240603AbiBTJ70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 04:59:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243604AbiBTJ7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 04:59:21 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2087.outbound.protection.outlook.com [40.107.243.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0186E54191;
        Sun, 20 Feb 2022 01:59:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aisiOFmZ8IFJmx+KPeYWYGz3mE64kLvohR5rNu7TY8POBi3K4ZS6WcX3jC8gVIIpR9O8SVx2GRxo6QVuIb+4rlcbO7FEO1ekdzcUw+7kc8zBLRya8zlM44fwC2PiImNyDldMQ1wwJkl+0GcfJCp3o33MR+qQvrhfEVA3Lw47zlQwtTxeoRGptPJS9zJRJZtoTeKfcpUoYa7AfedLJCMYwg6EwBiEkDX1S/K/sItBDfnHCGHac0yKnp2n80kHyAlUxlu2H0qVe0ar6jnneiuZjG97kl6FP/jUSX1S/OLDspwlVLfDMDbQwGNBUSWeJppb1wzx4lR+MYhFeh8X1epngw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQl+V8LeDkajsBdqJm7YYiKiAfvqI75s1JfXQ+T8nKY=;
 b=lrFYu86d5gbzKxWIOnx7BAeYTFMf5633G71+kr/Q/5TRwxhNbuxIlI+QuWGk8VccymznCcHiDdFaJrx9sCN8IUSm+EKrG1GQiXlPU4jdPU7/mIx+P1Qc6ca1dYwR5Ol3ouijgR4503i6Hx9hQsXEj2LoZSgn85JEgiGZeUJQheG4MdVRi8mu6pgRRT6Z2Azbt4xR0zjvsYwEjugg+nsB8STGh8ouIlNYYuIXW/czPZpikEJ/ig4iKh7yikji7UNAIFvwFqrJS91Lk0JO1u5gQlLI1j6fbVq+SaV6pCfDHeSVX410tRWh0r9UTDjexo9yQ/74wJIPs9UpP5sShj10Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQl+V8LeDkajsBdqJm7YYiKiAfvqI75s1JfXQ+T8nKY=;
 b=MJ71N4nbgKU/0TZWbTy1m80IpEWfmA5sJZp5IqVGPUXLNyvCDU2UOeSn13f9b5a3MKcMbm5trw52pDVvBUUbydbZlsRiyOxGGeUJfa20G/kcOrqc3aNKmPFt8PgTq/lAXEQ1RBOx9ad//mrfoOV9a0oDRGo/gA/SV3S3yU+Pq8s9PD/PHh/x2iyrAW5sXhHBOcl9Swa2qjrznQs6lWnS9VUR6sYi9XzQRLZU+2vtb+kReVpl4is51k6hzuGA7okeQZWf0f+43/bTW7hhLh2RdDEfRV4hpFidMWIQ14qie8CAv1tHQnVdr5KmALIN+8+BDshxIJ/osqF5brK0ahae6w==
Received: from BN7PR02CA0026.namprd02.prod.outlook.com (2603:10b6:408:20::39)
 by BN8PR12MB3171.namprd12.prod.outlook.com (2603:10b6:408:99::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Sun, 20 Feb
 2022 09:58:58 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::2f) by BN7PR02CA0026.outlook.office365.com
 (2603:10b6:408:20::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.19 via Frontend
 Transport; Sun, 20 Feb 2022 09:58:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 09:58:57 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 09:58:56 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 01:58:56 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Sun, 20 Feb
 2022 01:58:51 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V8 mlx5-next 08/15] vfio: Have the core code decode the VFIO_DEVICE_FEATURE ioctl
Date:   Sun, 20 Feb 2022 11:57:09 +0200
Message-ID: <20220220095716.153757-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220220095716.153757-1-yishaih@nvidia.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac6e4dac-2084-4963-6c67-08d9f4579cd5
X-MS-TrafficTypeDiagnostic: BN8PR12MB3171:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3171D28FF1E0B5DFDB648931C3399@BN8PR12MB3171.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ognM8KZwt4wonSe+/RpK5h9qDv78aPetVaxs7pTYsSGcA3GmJ1XeYRR/rXvvZGUe+oYqifPrNXtVZVTt+E+XBxnAJslbR95qxIUT97DpsXL9EYFP2Tau9RqIi96TtL0rkiSB6A81skexHeHxiJaA1L5IytQKKq9B7aDPNVdOB0I9+EGS7UmbUbxO9x+6MndS64q37/nEkVNycuXru9U75p3R09A9cf8/0nPBy0iHchCUgpQJeyH8kMdotSpYb4Mm5YCXFt5iWq2ahU0ShYbjXxCB7Fng2GCT171+8nNs1fOjTIcL/475Xxswa/caN3WFQ3lob00TDEvtpKMLAM7ZGOX3vEQzQPCM/bhJbIINPpkg+l7s3U2vhbp4R9ihiJg8dA+gu2K2uphnwEHKmffeI+dzUpES30dNJ+6+6ADaQCoM2w5i23rH4l0+wnfN5lHQes/BrATIXlH2w1EiE5U9igAB9LSwhD8R/BQI7iNmnZd661iAAVoh3W/QULESa/NjyHqMY2/JHWrYWB2y1quX+cOoP5bqXg/xw4ujz4g7kDezn3Hja/H7a0t69qKUiHtzDIfFKUrx/doUaU9zkENZ1w4B0y6tkgeyBnREgDRkKIE36pESD6Ku1hmHRX7j35maPSUXwQS5Pg35fn7jrHy0x99CHr6HiIkiEXQiRItaAP+n9DYaSV55zmThO5CldcqlaXi7UPZ/+TanT47ywlcnA==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(4326008)(70586007)(8676002)(1076003)(2616005)(70206006)(186003)(82310400004)(5660300002)(26005)(83380400001)(336012)(426003)(86362001)(54906003)(7416002)(356005)(81166007)(110136005)(8936002)(316002)(36860700001)(6636002)(40460700003)(36756003)(508600001)(47076005)(7696005)(6666004)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 09:58:57.7700
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac6e4dac-2084-4963-6c67-08d9f4579cd5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3171
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

Invoke a new device op 'device_feature' to handle just the data array
portion of the command. This lifts the ioctl validation to the core code
and makes it simpler for either the core code, or layered drivers, to
implement their own feature values.

Provide vfio_check_feature() to consolidate checking the flags/etc against
what the driver supports.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c      |  1 +
 drivers/vfio/pci/vfio_pci_core.c | 94 +++++++++++++-------------------
 drivers/vfio/vfio.c              | 46 ++++++++++++++--
 include/linux/vfio.h             | 32 +++++++++++
 include/linux/vfio_pci_core.h    |  2 +
 5 files changed, 114 insertions(+), 61 deletions(-)

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
index f948e6cd2993..106e1970d653 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1114,70 +1114,50 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 
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
+	}
+	return -ENOTTY;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
 
-			/* Don't SET unless told to do so */
-			if (!(feature.flags & VFIO_DEVICE_FEATURE_SET))
-				return -EINVAL;
+static int vfio_pci_core_feature_token(struct vfio_device *device, u32 flags,
+				       void __user *arg, size_t argsz)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(device, struct vfio_pci_core_device, vdev);
+	uuid_t uuid;
+	int ret;
 
-			if (feature.argsz < minsz + sizeof(uuid))
-				return -EINVAL;
+	if (!vdev->vf_token)
+		return -ENOTTY;
+	/*
+	 * We do not support GET of the VF Token UUID as this could
+	 * expose the token of the previous device user.
+	 */
+	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET,
+				 sizeof(uuid));
+	if (ret != 1)
+		return ret;
 
-			if (copy_from_user(&uuid, (void __user *)(arg + minsz),
-					   sizeof(uuid)))
-				return -EFAULT;
+	if (copy_from_user(&uuid, arg, sizeof(uuid)))
+		return -EFAULT;
 
-			mutex_lock(&vdev->vf_token->lock);
-			uuid_copy(&vdev->vf_token->uuid, &uuid);
-			mutex_unlock(&vdev->vf_token->lock);
+	mutex_lock(&vdev->vf_token->lock);
+	uuid_copy(&vdev->vf_token->uuid, &uuid);
+	mutex_unlock(&vdev->vf_token->lock);
+	return 0;
+}
 
-			return 0;
-		default:
-			return -ENOTTY;
-		}
+int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
+				void __user *arg, size_t argsz)
+{
+	switch (flags & VFIO_DEVICE_FEATURE_MASK) {
+	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
+		return vfio_pci_core_feature_token(device, flags, arg, argsz);
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

