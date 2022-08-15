Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B97D593168
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 17:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243011AbiHOPMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 11:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239464AbiHOPMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 11:12:03 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2089.outbound.protection.outlook.com [40.107.102.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAE3220C3;
        Mon, 15 Aug 2022 08:12:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gyBmptw4Gw8TxpsfrQTz4BlgelFvSBVEmBgEV/le7U3axIl86CLNVfe/Qp5u4llMJtoaz8N/DtY61HqOwnGORW4oxNpP8gB0OiehOURHKVvncjo7kwuwRn9KoM2V7A3R//fKZnP/Vj6E419eK7bX0SS9559XpqpXwnOBZ1/DF4owO9r9HPtFZghTGGajUOZz69kR3l1QfV7KQ4lXouDpZ8dMI5Wee8WhIh0NfCCuRCcXC717hY4xZSBmRuCDlJzR2hWEqrziO23Sx+ZN+y9n9kvLK1lE+HRIGx4ll/1DS6p1Rw4uI8UWUXgyRGYoHqVEKEh7dlxDXzMP6hvgzzynJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cHRP30nIVqNL2DIGhmhNc6/eH4zSozRgngh+b7NbgLE=;
 b=Phw5Z3KdSswxjCbamsgOdJmCs5BLJ908QxWTeS3GJ34eh8Xchl/bJTHKiJARu82dmwYIQN108XIhOdXoohE0RVWyxoSkmn50n8rGLo/DbkmZrs3mlfvvZyjeS3qZVT0BkJn/2TWy4lfkQV9L1mtW+oCIxQr+VMQnoKV1C1n69E8vg090YPoWbAys3qoELDWVHF5VJecQnbzjBbqSc0pvT0/+4dBN+PFKoCjMqBVPGMV5TUnnLJxPmwWNpHqedUpVYd8WLCcIoOzb2aJXJRin0TeQpicMzqj68IS0CTaAXK44QAyueU6YzGdIk7XGCM+3pUuko5Fm19nmaJXKurStcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cHRP30nIVqNL2DIGhmhNc6/eH4zSozRgngh+b7NbgLE=;
 b=CO15QgJIUAIDkSNFA9TgRISv9ax9qsJT2n34xQdC3z1jqrmheiJwdqk2r/qYeVosADJo5ot9YrX+Q/fRvksiv8s1yq/H8CkEXWptoJ0ozU0BkACoMJRdj9W90L6uvAZpYkqhY1/sabOeAYxXqcNTwAh2bKUPNkqSSRdqQBFBqolMj3h1gyZmqWqIPMTBQZh/XscSk8bHoKuh680lIaUHVBon748e4D010/tu/iF9XUGzqpxoGc3+wOE39lzT7otgEEw3uaWpnzOxHL5JTKpBER+BbBXHd5xPY1aUrzf/be4xgcRsO02tmUWiOb+1owSREf3o4U7Iaybj1C4zPN2Pug==
Received: from MW4PR03CA0259.namprd03.prod.outlook.com (2603:10b6:303:b4::24)
 by BN6PR12MB1170.namprd12.prod.outlook.com (2603:10b6:404:20::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Mon, 15 Aug
 2022 15:11:59 +0000
Received: from CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b4:cafe::c) by MW4PR03CA0259.outlook.office365.com
 (2603:10b6:303:b4::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10 via Frontend
 Transport; Mon, 15 Aug 2022 15:11:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT043.mail.protection.outlook.com (10.13.174.193) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5525.11 via Frontend Transport; Mon, 15 Aug 2022 15:11:58 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Mon, 15 Aug 2022 15:11:57 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 15 Aug 2022 08:11:57 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Mon, 15 Aug 2022 08:11:54 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V4 vfio 05/10] vfio: Introduce the DMA logging feature support
Date:   Mon, 15 Aug 2022 18:11:04 +0300
Message-ID: <20220815151109.180403-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220815151109.180403-1-yishaih@nvidia.com>
References: <20220815151109.180403-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c28b774-9136-4ac9-a254-08da7ed07fcd
X-MS-TrafficTypeDiagnostic: BN6PR12MB1170:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zlVHlk2Kbl3smDbvkjxfgQS9SkQ2dYTRSTgJ/NDzYPrzoJBwP27iGnI4wjgRvaBpAL7Pqvg2PLoX5OEo6iP87y2n2K8rj68notllxM7oeWglmCwPIXtyO4Xc/+me4JNtN5Z6q20/Q1TCYenMsDXpziaOOLB7Ni/txFE0LPAmOin9jMY0ySiXiQ0HU5a7axhp3ao9xSB+4BEX7T8CiGy4AyY8GMSJUmHdqvxTZfCOn2hoAa+bgavxzGnplVV20cxEDnJWjXcz/nos71p3npp71QT7wodRKEgG7l4FSyl1aMQiEsRkREj803kR0MEu0HhI+TwS0uH6bFeotKPA9Nw5E2vX/EG7oFBPrN1rBtWND2JBl6jAaxrXPOkyPnMBjo8f7zeDo6LCyH4UE0JLnpwotuLJw7Z6stcrxCyp/Ka9ok53n7tkxolgkl+J218t5HC0ukPq1ubu0fX2qxTr/yRixc5B49sNW0txPJapDEmHdUk6eMc5abGz9CoBK5RwM9H8jx+goPMxAtFz8LKX/AD73Aou3VmKRUNKR2bVAKyFRDiG2uF32Dl0a/WCVM5CBP3PC8IoNmRQjBrOxWx532ep+XHuSUlwmSsMDmR+kxzLaDASaXzSCvY48spraJGA1uoxRLfusrZuX9W3sc14HWB/afNNSHh9rnlBrZ27GltgkR9MeCMPc8zPXlV0OBbWoYto8Xxn/FJF5/wIH75IgLPYUNeQAN6WoFkucte2JwxPxv6o8kyoJWWQZKpegPUWGciQZFrjrHm/mW83SVw39Fc2yyZ75Gep4Mr7u1Fifuk0JRsSBNhkUGM2lrFJOlZd8R3AMv8R5fVaE8VM/7hgHcEDQw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(396003)(136003)(376002)(36840700001)(40470700004)(46966006)(8676002)(36860700001)(316002)(6636002)(40480700001)(70206006)(4326008)(70586007)(54906003)(40460700003)(82310400005)(8936002)(82740400003)(2906002)(356005)(5660300002)(81166007)(86362001)(186003)(47076005)(41300700001)(336012)(6666004)(36756003)(7696005)(26005)(83380400001)(1076003)(2616005)(478600001)(110136005)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 15:11:58.7420
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c28b774-9136-4ac9-a254-08da7ed07fcd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1170
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the DMA logging feature support in the vfio core layer.

It includes the processing of the device start/stop/report DMA logging
UAPIs and calling the relevant driver 'op' to do the work.

Specifically,
Upon start, the core translates the given input ranges into an interval
tree, checks for unexpected overlapping, non aligned ranges and then
pass the translated input to the driver for start tracking the given
ranges.

Upon report, the core translates the given input user space bitmap and
page size into an IOVA kernel bitmap iterator. Then it iterates it and
call the driver to set the corresponding bits for the dirtied pages in a
specific IOVA range.

Upon stop, the driver is called to stop the previous started tracking.

The next patches from the series will introduce the mlx5 driver
implementation for the logging ops.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/Kconfig             |   1 +
 drivers/vfio/pci/vfio_pci_core.c |   5 +
 drivers/vfio/vfio_main.c         | 159 +++++++++++++++++++++++++++++++
 include/linux/vfio.h             |  21 +++-
 4 files changed, 184 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 6130d00252ed..86c381ceb9a1 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -3,6 +3,7 @@ menuconfig VFIO
 	tristate "VFIO Non-Privileged userspace driver framework"
 	select IOMMU_API
 	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
+	select INTERVAL_TREE
 	help
 	  VFIO provides a framework for secure userspace device drivers.
 	  See Documentation/driver-api/vfio.rst for more details.
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index c8d3b0450fb3..2b31184dddde 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1875,6 +1875,11 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 			return -EINVAL;
 	}
 
+	if (vdev->vdev.log_ops && !(vdev->vdev.log_ops->log_start &&
+	    vdev->vdev.log_ops->log_stop &&
+	    vdev->vdev.log_ops->log_read_and_clear))
+		return -EINVAL;
+
 	/*
 	 * Prevent binding to PFs with VFs enabled, the VFs might be in use
 	 * by the host or other users.  We cannot capture the VFs if they
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 7cb56c382c97..e961e9ff449f 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -32,6 +32,8 @@
 #include <linux/vfio.h>
 #include <linux/wait.h>
 #include <linux/sched/signal.h>
+#include <linux/interval_tree.h>
+#include <linux/iova_bitmap.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION	"0.3"
@@ -1628,6 +1630,151 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
 	return 0;
 }
 
+/* Ranges should fit into a single kernel page */
+#define LOG_MAX_RANGES \
+	(PAGE_SIZE / sizeof(struct vfio_device_feature_dma_logging_range))
+
+static int
+vfio_ioctl_device_feature_logging_start(struct vfio_device *device,
+					u32 flags, void __user *arg,
+					size_t argsz)
+{
+	size_t minsz =
+		offsetofend(struct vfio_device_feature_dma_logging_control,
+			    ranges);
+	struct vfio_device_feature_dma_logging_range __user *ranges;
+	struct vfio_device_feature_dma_logging_control control;
+	struct vfio_device_feature_dma_logging_range range;
+	struct rb_root_cached root = RB_ROOT_CACHED;
+	struct interval_tree_node *nodes;
+	u32 nnodes;
+	int i, ret;
+
+	if (!device->log_ops)
+		return -ENOTTY;
+
+	ret = vfio_check_feature(flags, argsz,
+				 VFIO_DEVICE_FEATURE_SET,
+				 sizeof(control));
+	if (ret != 1)
+		return ret;
+
+	if (copy_from_user(&control, arg, minsz))
+		return -EFAULT;
+
+	nnodes = control.num_ranges;
+	if (!nnodes)
+		return -EINVAL;
+
+	if (nnodes > LOG_MAX_RANGES)
+		return -E2BIG;
+
+	ranges = u64_to_user_ptr(control.ranges);
+	nodes = kmalloc_array(nnodes, sizeof(struct interval_tree_node),
+			      GFP_KERNEL);
+	if (!nodes)
+		return -ENOMEM;
+
+	for (i = 0; i < nnodes; i++) {
+		if (copy_from_user(&range, &ranges[i], sizeof(range))) {
+			ret = -EFAULT;
+			goto end;
+		}
+		if (!IS_ALIGNED(range.iova, control.page_size) ||
+		    !IS_ALIGNED(range.length, control.page_size)) {
+			ret = -EINVAL;
+			goto end;
+		}
+		nodes[i].start = range.iova;
+		nodes[i].last = range.iova + range.length - 1;
+		if (interval_tree_iter_first(&root, nodes[i].start,
+					     nodes[i].last)) {
+			/* Range overlapping */
+			ret = -EINVAL;
+			goto end;
+		}
+		interval_tree_insert(nodes + i, &root);
+	}
+
+	ret = device->log_ops->log_start(device, &root, nnodes,
+					 &control.page_size);
+	if (ret)
+		goto end;
+
+	if (copy_to_user(arg, &control, sizeof(control))) {
+		ret = -EFAULT;
+		device->log_ops->log_stop(device);
+	}
+
+end:
+	kfree(nodes);
+	return ret;
+}
+
+static int
+vfio_ioctl_device_feature_logging_stop(struct vfio_device *device,
+				       u32 flags, void __user *arg,
+				       size_t argsz)
+{
+	int ret;
+
+	if (!device->log_ops)
+		return -ENOTTY;
+
+	ret = vfio_check_feature(flags, argsz,
+				 VFIO_DEVICE_FEATURE_SET, 0);
+	if (ret != 1)
+		return ret;
+
+	return device->log_ops->log_stop(device);
+}
+
+static int
+vfio_ioctl_device_feature_logging_report(struct vfio_device *device,
+					 u32 flags, void __user *arg,
+					 size_t argsz)
+{
+	size_t minsz =
+		offsetofend(struct vfio_device_feature_dma_logging_report,
+			    bitmap);
+	struct vfio_device_feature_dma_logging_report report;
+	struct iova_bitmap_iter iter;
+	int ret;
+
+	if (!device->log_ops)
+		return -ENOTTY;
+
+	ret = vfio_check_feature(flags, argsz,
+				 VFIO_DEVICE_FEATURE_GET,
+				 sizeof(report));
+	if (ret != 1)
+		return ret;
+
+	if (copy_from_user(&report, arg, minsz))
+		return -EFAULT;
+
+	if (report.page_size < PAGE_SIZE || !is_power_of_2(report.page_size))
+		return -EINVAL;
+
+	ret = iova_bitmap_iter_init(&iter, report.iova, report.length,
+				    report.page_size,
+				    u64_to_user_ptr(report.bitmap));
+	if (ret)
+		return ret;
+
+	for (; !iova_bitmap_iter_done(&iter) && !ret;
+	     ret = iova_bitmap_iter_advance(&iter)) {
+		ret = device->log_ops->log_read_and_clear(device,
+			iova_bitmap_iova(&iter),
+			iova_bitmap_length(&iter), &iter.dirty);
+		if (ret)
+			break;
+	}
+
+	iova_bitmap_iter_free(&iter);
+	return ret;
+}
+
 static int vfio_ioctl_device_feature(struct vfio_device *device,
 				     struct vfio_device_feature __user *arg)
 {
@@ -1661,6 +1808,18 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
 		return vfio_ioctl_device_feature_mig_device_state(
 			device, feature.flags, arg->data,
 			feature.argsz - minsz);
+	case VFIO_DEVICE_FEATURE_DMA_LOGGING_START:
+		return vfio_ioctl_device_feature_logging_start(
+			device, feature.flags, arg->data,
+			feature.argsz - minsz);
+	case VFIO_DEVICE_FEATURE_DMA_LOGGING_STOP:
+		return vfio_ioctl_device_feature_logging_stop(
+			device, feature.flags, arg->data,
+			feature.argsz - minsz);
+	case VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT:
+		return vfio_ioctl_device_feature_logging_report(
+			device, feature.flags, arg->data,
+			feature.argsz - minsz);
 	default:
 		if (unlikely(!device->ops->device_feature))
 			return -EINVAL;
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e05ddc6fe6a5..b17f2f454389 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -14,6 +14,7 @@
 #include <linux/workqueue.h>
 #include <linux/poll.h>
 #include <uapi/linux/vfio.h>
+#include <linux/iova_bitmap.h>
 
 struct kvm;
 
@@ -33,10 +34,11 @@ struct vfio_device {
 	struct device *dev;
 	const struct vfio_device_ops *ops;
 	/*
-	 * mig_ops is a static property of the vfio_device which must be set
-	 * prior to registering the vfio_device.
+	 * mig_ops/log_ops is a static property of the vfio_device which must
+	 * be set prior to registering the vfio_device.
 	 */
 	const struct vfio_migration_ops *mig_ops;
+	const struct vfio_log_ops *log_ops;
 	struct vfio_group *group;
 	struct vfio_device_set *dev_set;
 	struct list_head dev_set_list;
@@ -108,6 +110,21 @@ struct vfio_migration_ops {
 				   enum vfio_device_mig_state *curr_state);
 };
 
+/**
+ * @log_start: Optional callback to ask the device start DMA logging.
+ * @log_stop: Optional callback to ask the device stop DMA logging.
+ * @log_read_and_clear: Optional callback to ask the device read
+ *         and clear the dirty DMAs in some given range.
+ */
+struct vfio_log_ops {
+	int (*log_start)(struct vfio_device *device,
+		struct rb_root_cached *ranges, u32 nnodes, u64 *page_size);
+	int (*log_stop)(struct vfio_device *device);
+	int (*log_read_and_clear)(struct vfio_device *device,
+		unsigned long iova, unsigned long length,
+		struct iova_bitmap *dirty);
+};
+
 /**
  * vfio_check_feature - Validate user input for the VFIO_DEVICE_FEATURE ioctl
  * @flags: Arg from the device_feature op
-- 
2.18.1

