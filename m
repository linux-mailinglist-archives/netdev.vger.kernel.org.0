Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D24C75B25E0
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 20:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbiIHSfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 14:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231916AbiIHSff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 14:35:35 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2046.outbound.protection.outlook.com [40.107.244.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DE0985B8;
        Thu,  8 Sep 2022 11:35:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g7o26OOFQr2BDpDka636Lr7APWDZb8je+4SLnAEjHSE7uGWGBbitlu8Bdxz2hMLOPyIH/B11T84UQYbuxFsGkAAzS/YHgms45owZGIIU2UDCrYikZEgOJzs3WmPyJ4ol3nJUk/IvyFcekx9Q8/3V2ayvnjqbVUMSwx9ne5Bhp7WVfrWBFjU7mKutg6ZWjQrFKPAma7S666PR6P9LDm8qdNGVtMcETmgdxNvRAIU99u2lFSTAgbnGEFfd+czKlpGIOU2JKjzFeinuS2skSCfixML1jfvCMPYV5vKGQuOzL5JF7Nv+QySvA5uOXc61jYy8CULxd8dc0sDPU/+g5/5HGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x3zaoNtTsZK8ZWI0R3v+ELDV+kGAUAVD2P96hNhhj/0=;
 b=TzYvxE4mgJamdTXeJ8iRtkD3TZIraTexfBnb458ZLgaNEpRKKTGq1iB7vSWZ3nzLZgEScGtAkT21ubthuB5mwVpLE0AKgL69NVAv5rOQ5rrge8QNRrJ6VaK3xSN89BS3QttABG4MiEliyo2iP63seXKHPIOu4s03UyCHS+CoHvITMl/UhVIwYxXoLaX3Kg9WstS/5J0djrHWPCO2yIE/qdhtX2wtNaQOrK7fODAs6CNRZYuwJhYXHoiV9G9yEsE2kq7K4Slu1Rz15qnVA/8GPtqorQ3K4oXF67KFkXrBf5WVpgwOYyahMQW+kjZ6FR//TFmn9I2PZHYXHFmre5d2Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x3zaoNtTsZK8ZWI0R3v+ELDV+kGAUAVD2P96hNhhj/0=;
 b=gevMtOOki9XtUAGGJ5Dn/ocDf8ZD3SW9XMn4XHXDXzIk1JhsskBrBmWHIMZ01myiRSYBxesn7vz4D6fiVvVWqRgXn/WXNRnusKIfShH6d4tYMb4K/Ez07t8sojQD8d2SR0OTFTPgkYe/59vCBoQrkue4ZXSe82QBOaCyKq9+A2FL/goOSZJYij9W/nq2OuoXNmgKhoReVGVi7mcUBNa5kvZcQ4TmmQll6bSMoQc/tjqFgRUWsDRi0UI9pztO+b0MXbQr8UcSofg80btGOfQX2/XdR0Wix4EP3Fd83L1vStDzp6ESx+fm/xitrLj+1BdF92GF2qAuaXdZiKubgE/ADQ==
Received: from BN0PR10CA0007.namprd10.prod.outlook.com (2603:10b6:408:143::25)
 by SJ1PR12MB6267.namprd12.prod.outlook.com (2603:10b6:a03:456::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.16; Thu, 8 Sep
 2022 18:35:31 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:143:cafe::ad) by BN0PR10CA0007.outlook.office365.com
 (2603:10b6:408:143::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12 via Frontend
 Transport; Thu, 8 Sep 2022 18:35:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.13 via Frontend Transport; Thu, 8 Sep 2022 18:35:30 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 8 Sep
 2022 18:35:29 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 8 Sep 2022
 11:35:28 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Thu, 8 Sep
 2022 11:35:25 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V7 vfio 05/10] vfio: Introduce the DMA logging feature support
Date:   Thu, 8 Sep 2022 21:34:43 +0300
Message-ID: <20220908183448.195262-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220908183448.195262-1-yishaih@nvidia.com>
References: <20220908183448.195262-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT060:EE_|SJ1PR12MB6267:EE_
X-MS-Office365-Filtering-Correlation-Id: 833a5b88-1d04-48d9-1fd6-08da91c8e85f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qhfr0ndWIq08XGyb3U0WXoWxWJJ/YNjlI/qEaw8jZSUmAnDFqsxHVMog4MzOYlS0xKZjBvqFckGz9gEgrWTg/NA28XadLrbCOcICwj0O4kSiHFPu6tEkI+x0gXPIjP8YcGSx2T0iMzewqNEHGNRJYw8D2lRoXycNzZHneElW2mq9F060u12eAMLwwawi7SijrgTcK03li+29Y3f10A/NGtbkXD3imFUiS83plj9a1BDe1OJP4T5vWNHdalDMU7nOROMlMsXNCW841K5B4DMAt+BMjXxPaGQ0Nh3nARBk35sanHU/dtza4hbJGtSKV+Ws7mQSsRwABvyRUcCRSknXzdDwcN+nHUXgjEZkxAnSuyo3v6c4cnX0wZylM4dxj5Uehvb1rxr73HU3qTQ+urjZpyd9AQBaFJEudoz3AZ/QSdsT8E+zTKJmCNcm6Dkgfp8RyMxYNAZhP/RKOCzsEAzq/jDMjACzWdsGj0xk65R96srBJK4dPzllZ0u+loleLK3zTQO+3cQXzZI3xPOXg9/F4KzEJtKrzYjBjBfwGcvFjkFwL67KOQAURyEPGsCaEw+cWEuokvL+3QbYw1kwq+lAamjiU7xtrx2YyA3b3iygveG9XItaXSaY96LKhvakEjF43VBWLUYnByJH4dO0Hx+2/7XsUV+XlQBwiFJfjvO7r30aXKqjBYf4f8NLYDQzbR0cFeqb+vHaVuDKdfILM+2rlggFegparDSz1/lZji+OVLrA/NxxnLL1FZlo3GMW24Agd309q+Agr/nsSFF5s8VvD4wJdEnYru/u/Jw03v+D/NQ=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(396003)(39860400002)(36840700001)(46966006)(40470700004)(82310400005)(36860700001)(186003)(6636002)(1076003)(82740400003)(316002)(110136005)(81166007)(426003)(54906003)(2616005)(47076005)(36756003)(8936002)(40480700001)(6666004)(86362001)(41300700001)(26005)(70586007)(7696005)(2906002)(70206006)(83380400001)(336012)(478600001)(5660300002)(4326008)(356005)(8676002)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 18:35:30.1881
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 833a5b88-1d04-48d9-1fd6-08da91c8e85f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6267
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
 drivers/vfio/vfio_main.c         | 175 +++++++++++++++++++++++++++++++
 include/linux/vfio.h             |  28 ++++-
 4 files changed, 207 insertions(+), 2 deletions(-)

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
index 0d4b49f06b14..0a801aee2f2d 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2128,6 +2128,11 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
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
index 77264d836d52..27d9186f35d5 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -33,6 +33,8 @@
 #include <linux/wait.h>
 #include <linux/sched/signal.h>
 #include <linux/pm_runtime.h>
+#include <linux/interval_tree.h>
+#include <linux/iova_bitmap.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION	"0.3"
@@ -1658,6 +1660,167 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
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
+	u64 iova_end;
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
+
+		if (check_add_overflow(range.iova, range.length, &iova_end) ||
+		    iova_end > ULONG_MAX) {
+			ret = -EOVERFLOW;
+			goto end;
+		}
+
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
+static int vfio_device_log_read_and_clear(struct iova_bitmap *iter,
+					  unsigned long iova, size_t length,
+					  void *opaque)
+{
+	struct vfio_device *device = opaque;
+
+	return device->log_ops->log_read_and_clear(device, iova, length, iter);
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
+	struct iova_bitmap *iter;
+	u64 iova_end;
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
+	if (report.page_size < SZ_4K || !is_power_of_2(report.page_size))
+		return -EINVAL;
+
+	if (check_add_overflow(report.iova, report.length, &iova_end) ||
+	    iova_end > ULONG_MAX)
+		return -EOVERFLOW;
+
+	iter = iova_bitmap_alloc(report.iova, report.length,
+				 report.page_size,
+				 u64_to_user_ptr(report.bitmap));
+	if (IS_ERR(iter))
+		return PTR_ERR(iter);
+
+	ret = iova_bitmap_for_each(iter, device,
+				   vfio_device_log_read_and_clear);
+
+	iova_bitmap_free(iter);
+	return ret;
+}
+
 static int vfio_ioctl_device_feature(struct vfio_device *device,
 				     struct vfio_device_feature __user *arg)
 {
@@ -1691,6 +1854,18 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
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
index e05ddc6fe6a5..0e2826559091 100644
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
@@ -108,6 +110,28 @@ struct vfio_migration_ops {
 				   enum vfio_device_mig_state *curr_state);
 };
 
+/**
+ * @log_start: Optional callback to ask the device start DMA logging.
+ * @log_stop: Optional callback to ask the device stop DMA logging.
+ * @log_read_and_clear: Optional callback to ask the device read
+ *         and clear the dirty DMAs in some given range.
+ *
+ * The vfio core implementation of the DEVICE_FEATURE_DMA_LOGGING_ set
+ * of features does not track logging state relative to the device,
+ * therefore the device implementation of vfio_log_ops must handle
+ * arbitrary user requests. This includes rejecting subsequent calls
+ * to log_start without an intervening log_stop, as well as graceful
+ * handling of log_stop and log_read_and_clear from invalid states.
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

