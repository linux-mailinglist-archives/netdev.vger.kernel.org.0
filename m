Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 323D35667F3
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 12:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbiGEK3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 06:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbiGEK2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 06:28:45 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F747140D1;
        Tue,  5 Jul 2022 03:28:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cBGbvIHSrZmRHWHNAeqHMZtPUcUSM2jvOp9Deg+Hdj3azlvM1T4MQyePjotKNTRjZRUuPtGhOvpgtsJ6Gf1/hb0a9ktg5SRK+F8SSb/IVIhimdjIv6NiPQ7uorqQ6i6Xo84QSAKW0jCpS4iUB/vACZ3UJFPf5IhdWFLndOOmuSa0ITuAUCtm7IqFGXYs5IHHrk+cwYkSGpIeCBUbquMM6a1CBWU/tvqfH0xpt+NxjZXGYCH5DdJ6egJyv3EpzdnS++FGJQx8xJ+Mn3HXcRfPFDN5R8oCfpZX0aSiD1vaqWkzLaB0DpINjzGyKExbUzcBhKDnXOJfznUnTqicHLauHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CbHBdI8fnCnOPRUlmw367VKdozRvUhARyII+OCGOXSY=;
 b=Gpl/f3fCAgVO79D/fsoJSUYgfUDTuMjxm5SKUN9UYtavzGYodaDdSgyDxow8qxlpZR0JAyNM/lK0P12h8kHq2bYAbJz1xS5GBGLlFoprcMVz9SN2x9QjGxXszBqfmWDCRaz3Lq3+oMsiYjH5/Zaou77TkYOP2EmRdfNCSAVyovzsIZANlzZWxFVcC2yTgq/aRdsszN1Qg3T/GNZmXyPGx11xxe9LRe3mb+wXbkxpI1RTnYCPUhI+3KKgmY4BTisXMKFGh1LpSQh139tIiIRD9P56swdmRge/lJtaaKF44DQ5LHTdc43+UJxsj7q3wit2QG/xB0yJEO9u5c2lSMsqrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CbHBdI8fnCnOPRUlmw367VKdozRvUhARyII+OCGOXSY=;
 b=e2rGs5RUX02wP7ydPZXKj+KkliKKj8ucXXn4Pl+NkJ38mcSYgKjao/9pmfXSr7hrr4w6Jmy2YAxcUwF+eV42hSnOvD34x72eprrHWirblFFMJbjAJw7eKl8heCt6Rtj/LHj6AkyCenpQAVY3fhFVXNG5lH2hG6gwLfC+cjtGiLkGjo2fETY+6r96HnY4cEy0r4h4hph+mxN81UOVKhP7SKi3ocVHKYQETPuhP5uQJegQAUQbvfQhi1TyAU2u/vQdHuPPHTdEUrI6KPrbwd+xaAbPtWfz3/IHbdwQ0CkIYvLTHeVb4yqzJ0T0/IF8l0SbRJNvO6LRy7OHCeQvECCb2g==
Received: from MWHPR14CA0020.namprd14.prod.outlook.com (2603:10b6:300:ae::30)
 by MW3PR12MB4410.namprd12.prod.outlook.com (2603:10b6:303:5b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18; Tue, 5 Jul
 2022 10:28:42 +0000
Received: from CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ae:cafe::ad) by MWHPR14CA0020.outlook.office365.com
 (2603:10b6:300:ae::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Tue, 5 Jul 2022 10:28:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT047.mail.protection.outlook.com (10.13.174.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Tue, 5 Jul 2022 10:28:41 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 5 Jul 2022 10:28:41 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 5 Jul 2022 03:28:40 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Tue, 5 Jul 2022 03:28:36 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V1 vfio 06/11] vfio: Introduce the DMA logging feature support
Date:   Tue, 5 Jul 2022 13:27:35 +0300
Message-ID: <20220705102740.29337-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220705102740.29337-1-yishaih@nvidia.com>
References: <20220705102740.29337-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8be3cf3-1456-47bf-ca8d-08da5e7121f8
X-MS-TrafficTypeDiagnostic: MW3PR12MB4410:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kqoeH7AiAJWaG7dh5yGyMUwt1URoiXunr8V1UjNfUi+VAXPycEAdvanm+uM4v1LfCtvQZIoYM5FGZkfHEdUuM5OCLvQfgaiomh773giZxr6moYoQEuuA2l85y3bfvjWR8jJd0OkZK3fSg+6DjrxwxiGJG1KpQtPxmoTixM7Khfv4n4wbbGK8QoWg/lb1OycN4uNNl2A8QJ3fU0YD8mtOPiy+IeRyqs+Avogxa+ok1hEZfjIgC2YC/065NppCLkMpCnvJFKO092fJ/PsKkPphj0CgDMICwSz/owfAXzALrb0OIQiPvJaXeQM6WBOKvTsAEUyew0xNoNoz3U7cigYa4L6pMFcNcji632z9tRyuBawWR3+g0/Kn2ftHhKMhFggWBqDDJhDTDI3D/0zFk6dP5VHZlRKKZx0M6xzc39+s7UHDltd+BHcIuM/WS35CGXX+6/gIqAZbjl4AerMBWkTF9azj80TMb+oCn0iEX9DVgLvebrMvP+wMwcNfXjTMz5Pl8QLiMgRJxZlF5Mjonru1wafk/u44abwrpT84OTGbCszhS6T0AbCnNA4a1y2jilq+xOY3psX/QkwWvoOxVUhAg3fV/+i9QQC81P9mxroVRh8WYWUz0GT/Vps0lKNjVTv/AY5ZrndwrMcrjO9Exe0VlcMB8d+AfnEz+M2eMto+opdqH1fYgmfiNznZIeWnoMEZIA1qQainvD6WDMT6riJVBfCgC17mMQHK7Ur9Mp2M+FMjmvdash50C2OaRfE3sqdjPkE9uLelJmCMWEeKAVQDODBc6LKB2kWe0eOhYQhqCqHv8h/tdNItd1Jkn+daeDOR4fSPVodN0mdwCal6XXn+WUbmPGdMSQH75Q08wnr8InQ=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(396003)(39860400002)(376002)(36840700001)(46966006)(40470700004)(47076005)(110136005)(6636002)(336012)(40460700003)(26005)(54906003)(426003)(82310400005)(186003)(36756003)(316002)(83380400001)(1076003)(86362001)(2616005)(5660300002)(70586007)(2906002)(81166007)(40480700001)(36860700001)(7696005)(478600001)(8936002)(8676002)(4326008)(41300700001)(70206006)(82740400003)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 10:28:41.9521
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8be3cf3-1456-47bf-ca8d-08da5e7121f8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4410
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/vfio/pci/vfio_pci_core.c |   5 +
 drivers/vfio/vfio_main.c         | 161 +++++++++++++++++++++++++++++++
 include/linux/vfio.h             |  21 +++-
 3 files changed, 185 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 2efa06b1fafa..b6dabf398251 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1862,6 +1862,11 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
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
index bd84ca7c5e35..2414d827e3c8 100644
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
@@ -1603,6 +1605,153 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
 	return 0;
 }
 
+#define LOG_MAX_RANGES 1024
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
+	if (!nnodes || nnodes > LOG_MAX_RANGES)
+		return -EINVAL;
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
+	if (report.page_size < PAGE_SIZE)
+		return -EINVAL;
+
+	iova_bitmap_init(&iter.dirty, report.iova, ilog2(report.page_size));
+	ret = iova_bitmap_iter_init(&iter, report.iova, report.length,
+				    u64_to_user_ptr(report.bitmap));
+	if (ret)
+		return ret;
+
+	for (; !iova_bitmap_iter_done(&iter);
+	     iova_bitmap_iter_advance(&iter)) {
+		ret = iova_bitmap_iter_get(&iter);
+		if (ret)
+			break;
+
+		ret = device->log_ops->log_read_and_clear(device,
+			iova_bitmap_iova(&iter),
+			iova_bitmap_length(&iter), &iter.dirty);
+
+		iova_bitmap_iter_put(&iter);
+
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
@@ -1636,6 +1785,18 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
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
index 4d26e149db81..feed84d686ec 100644
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
@@ -104,6 +106,21 @@ struct vfio_migration_ops {
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

