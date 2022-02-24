Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63474C2E2A
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 15:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235455AbiBXOWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 09:22:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235446AbiBXOWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 09:22:07 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2047.outbound.protection.outlook.com [40.107.236.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F75E26D4;
        Thu, 24 Feb 2022 06:21:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VOjlVtzEmSB/xyLZJX5I3sL5c08QKSEgZlwup0rh3fbWBCCWcoFlC9n4onzhWFuDVP+XZ4k+HDob3YnFxwfWPEcjhZGzSk+4/82a5jWRdsnO+P1i6g3P1JnbP5DXIRe4m+k95zkRBKCgg9pW0er3RizRIwgDICZFpuJx/BRiuaVMhSS/HQQqNPJGn637ls7OxomPmz1zCjqQUixWtVPwgTJOLjimtjGRF0ZzxNodl8cIG5d3xp4FpjS4W3Zm/+tsU9987bOBrvOdfkQaM2UCEYbUbUBPhKNPQPJMsbSYDYTyRUvL0KlYhXAwcFcbnrc3YoWcTkWqD/ELOsu7uwC2Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQl+V8LeDkajsBdqJm7YYiKiAfvqI75s1JfXQ+T8nKY=;
 b=F8I4udRrVECDrg4Aq4aT2Z/HJhlKh5iWUljDdfTO9wdk3mz1mB/ZptW/IcEmojsFP7tVdSu3J/bw2cXnLaBwaaCmBOBbAcrUt3PjEszcT9zw0Y58IIhEhpKHRZkTNl4ZItV/ryUMfdUAWse5FhFK4qcROb4YDWi8SaO0JDoGJVPla5LErCH7ydHJtApd62vRZeUfz5EqWg1yU3cmv62Q/Qyh1tH/g31+0cyiXD7a0jOI8PYSX40OM+eH/df2b5z+8axYi66TP+7r2d6iMfmRFgmAo/P6swh/88wsxBPlvcnCXUCyT2C5twPv3WlqDVNqKhTLOCPK5qMmkTXpvExlLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQl+V8LeDkajsBdqJm7YYiKiAfvqI75s1JfXQ+T8nKY=;
 b=Ibkl+iB2pq3VcaTcN2omXq24sXow0AdXgTPBH66MkWBEmN4m6o2Le2CNqfInhV0BbUgyoqU3H1fTxbIrilBoRqCK8FouM/IBpHmdPWxB4QinTheZOrqlc/QApbH7NDAbxyMkn3nnIFF+AiTYhq3jzFE8OvGRxA8+tcd/bCXKmqVzk+sihocRVR+8NZgXs4YM/41fny8m1uTYaFt3Dxa1585olioe8CD81KkurrUYouFbWG3BpR6wqfJFdld+jJ5ExjuHmos3zV/2lvYi/aVCs/VPVAW8Ossiq1YmmdLGu1SqNz7lScpelq0twzGZq9YetJXO/SgI6ZNBv7BIZCAqtg==
Received: from BN9PR03CA0862.namprd03.prod.outlook.com (2603:10b6:408:13d::27)
 by DM4PR12MB5392.namprd12.prod.outlook.com (2603:10b6:5:39f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Thu, 24 Feb
 2022 14:21:29 +0000
Received: from BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13d:cafe::7b) by BN9PR03CA0862.outlook.office365.com
 (2603:10b6:408:13d::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22 via Frontend
 Transport; Thu, 24 Feb 2022 14:21:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT030.mail.protection.outlook.com (10.13.177.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 14:21:28 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Feb
 2022 14:21:28 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 24 Feb 2022
 06:21:25 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 24 Feb
 2022 06:21:22 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V9 mlx5-next 08/15] vfio: Have the core code decode the VFIO_DEVICE_FEATURE ioctl
Date:   Thu, 24 Feb 2022 16:20:17 +0200
Message-ID: <20220224142024.147653-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220224142024.147653-1-yishaih@nvidia.com>
References: <20220224142024.147653-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 467e5d2b-602f-433e-9a46-08d9f7a0f2cd
X-MS-TrafficTypeDiagnostic: DM4PR12MB5392:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5392B2B6BB6A3D5899AB15EEC33D9@DM4PR12MB5392.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vrFpkIrcJfqSQ6tYfCiKkTUVBxPHIuYJAgEQwECJAXSClj7Nz14K1ctN5LfygqdLwakoRdydEtYZsfZfO/YRcUJn67aXDQX8PwcYHABWcmZXZlhg8AmdB3z1irQTJ8cwWChjzNb/pWQ9dZzGhFOBRBbx4GFyiw9kZ4XmuAtYGOR6OnGrrgzwaUyCZH/I4VNIcCU9cU2grWxTzvAT1ogLPiF3/2JRiKxHaFEvUYjYpvq8n93bKnO/e3v2f9qC+ZbMaw9eNzgNGNIxJ8FlMiNTAoETeooHjLR4SK1ca/UQUeWNQDWeGRKlAJHJ6rT7vU/DKiEOcClTT2WVhNUiHVEFZbyEx1u/gB5G63xX8RH6B5JKwRnccB8MOGN1iP4DLHWJ00jz6MzFXXl4m4bXYYR5GnMhJ/iz5ZNI4J6Mgq8mejcULBklw03oD1y+mx3DPkzAYdJFHHNow14HNYxz80Lhh/gpKHZsf+PaSVe9xmHwEaqMqO7U+Tuu1PbA+NfhrbHJjA00ZfxcwFblizHmcNdCq+5YQFsZ1d1qUV54NV5fyxWj6Dsawxe5mgNL6TU9OdMDJx5xKPPAeceNcIfOcLlT4UJuZmnMHZMkc440U9uAYsQ9oQGaGwZ5/jOS+I1G+NXZZylMe3Z4Tmy94ERJlv0e5CHImrsu+tzAbG8xIQgZm7Dn98eO2blhS8UGQJzEPSjlnEG4+8ZAAXlWZsxUALU4eQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(36860700001)(47076005)(7416002)(81166007)(2616005)(4326008)(8676002)(70586007)(508600001)(82310400004)(5660300002)(70206006)(356005)(40460700003)(6666004)(54906003)(7696005)(426003)(6636002)(8936002)(110136005)(186003)(36756003)(26005)(83380400001)(86362001)(2906002)(336012)(1076003)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 14:21:28.8149
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 467e5d2b-602f-433e-9a46-08d9f7a0f2cd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5392
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

