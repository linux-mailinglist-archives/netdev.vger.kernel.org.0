Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1195A9362
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 11:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbiIAJly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 05:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233383AbiIAJla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 05:41:30 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2071.outbound.protection.outlook.com [40.107.95.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89586134D52;
        Thu,  1 Sep 2022 02:41:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h5dE898yPGibKdFamuhyZHDR5z+Qeav+jV9/sDaxsYtCE/WACfbebtKufx2/IEcCudyEpnxiDRAfcGfcmLE5WM5FonRKDR2B7EjbaDxvFvlY8IHATurVkWJFXpH+srh80qfFmk9JHbITesuEeb5FqxzPbOzNx+TVJiC+6/YQTIXapiHKE9cL52kUIDq+sUm0NPV7fOZ6bbVc+g3NcL1dVVrbJNHXE5V/4KX2o8tIJucWAfVhKyy9wBO36aftgUXUBGkoeSEGHO8SG640kp6g2tX1UqW/fgLGVSt/icJ3ISmzs1YE1TAsD20JcVlVKRvJYnMTKIFoKDjD+TAdJUmz5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Kpjssiwr10C/jwwOFY87ewiIyPPGiRqn+DCM921VcA=;
 b=cTyLgP5n9rHTIbeIDWEDIVfVeBjrK/iTtkQsu07tumLfHdXNGlqVb0f47efTIEjNLoNk5jZQa584WO2/aPw6MHq0lWtlNDKkimI6fMu8Cw3qF2ZnGDVOeHn572RtI667DHdmtmX2wHT8SI2zpoAqhgQaPnizeQ5nvfsjUtIcrgOCU12sVP8gj43qkIWNbbDUc6Z/iF8ZYsZp/5tiHxyJeus+3X3HI8cdBYumBvp2v6CLxFJbEsH3QW1+ivU8u1ku1lGDKjM+ghsCvzxPOfPEKFaaK0viASRBWwMGjIrYoCwkgqvkC6BdqKaf52uUEKb7eSxp3JtjfvPZ7/NBlptwIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Kpjssiwr10C/jwwOFY87ewiIyPPGiRqn+DCM921VcA=;
 b=EsJGKIEaHekrbmy52OUyD0QPtGg2DCibPd1VwyBHliApv69kv0uA14UePleQdIPG7m46COJ4dFEGImvcR+HoaiLamYFz0K1ixVyqiIt3foHKtBe5cT6xAECMjbG2jfjc/Kk00Sz0Hk7Qiw5qzEJmXu9jVaLK5hzkNdKTo06uFiklU90K1vFv26zc+Nq0NuSp4/oFeMTWvELLkdNfCH2ytjXu2Kyu+6fVxk00PuzUi2cfRix7N1Q4C/P59ktbnLUqb6Xt1BohU4NcbJek7CdT3SOQDV4hPa0fdDrgsCqcEQOdua5BS3IfFlmXIVJRqWP82GriBzEDe1H+03xQruFpvA==
Received: from BN9PR03CA0292.namprd03.prod.outlook.com (2603:10b6:408:f5::27)
 by MN0PR12MB6032.namprd12.prod.outlook.com (2603:10b6:208:3cc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 09:41:24 +0000
Received: from BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::40) by BN9PR03CA0292.outlook.office365.com
 (2603:10b6:408:f5::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10 via Frontend
 Transport; Thu, 1 Sep 2022 09:41:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT030.mail.protection.outlook.com (10.13.177.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Thu, 1 Sep 2022 09:41:24 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Thu, 1 Sep 2022 09:40:46 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Thu, 1 Sep 2022 02:40:45 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Thu, 1 Sep 2022 02:40:42 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V5 vfio 05/10] vfio: Introduce the DMA logging feature support
Date:   Thu, 1 Sep 2022 12:38:48 +0300
Message-ID: <20220901093853.60194-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220901093853.60194-1-yishaih@nvidia.com>
References: <20220901093853.60194-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39f8b547-0619-4f2c-1b01-08da8bfe2277
X-MS-TrafficTypeDiagnostic: MN0PR12MB6032:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kFpr+bAvkSO8Nd2/dSKP03oH1x4YX5xJsMHNnxodmaKgaF+yLu5kB5QhGf6lRp75sHfoKfZUpd5/0NO12p3S5Ewggq3XFlUxyNOq8VBT38XYEdCGphmrUoA7hWxKVkyWy+YFiIIriGtf0E1eT1JQZJSzsc+ZxlQs9PLTEY11CYlNCvBQJPMyDMjTyb1HtlWudVoeaoKzKLGNaI3/bqV9ZbC+WLH1eYVNvCuMC7ypHomsxwtTSkwhzd8R81Cr1vFE6I9HCgZQfC6I5B1dpA51MUYWKf/CvssghA8b9JtReXcBGvWW1h8LfvrBcB7Izi3J2nT4UhJlUk8lMwPilTkEk0ZDT7toaHvZuL56ytUgatehiJxwzQEDxxNlMdJJLfbZnzfYk2fE2mF33XfhwopOljPYWRjlRxTbt3Vla15Z5t0W428J5WCqHM5wSXkLqsTuMjqjK6JGTd9Wn8l0P8s2FRuYgoBV0fM4S2WxHLWP4SUo9aMdD/nLNrZhSLQs00EAr71m/NYfi23Xibd32q32JMfHZ0+WmxVvF1Yughr29aESCp+At8paaIAhUcSctzGCISNoWE8/lW+PKRNrVEBNioIY3IXPj9MXD/jU+UTE4XvBWLQzrzGC8J/HvrVPzkg/25Qfkpn3l7nPDeY9lKHsGDH1Ja3NPFC3ADtQjgIw6Ztsi3TNOBFMlQ/77SSmjLr7fw2DDUEmGVOza9A2mfLQLM9rG7ZhUd/dUrUx07p9D3mdXrRVtwhAD+jd4fQuyhFwK6/6lI26fJN78G8AzhVsf2EuHpmpMYXXunJPw69SFrlYBYWszy2pS+bWiVwsXjMy
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(39860400002)(376002)(136003)(46966006)(36840700001)(40470700004)(82310400005)(40460700003)(8676002)(4326008)(478600001)(316002)(36860700001)(70206006)(86362001)(70586007)(2616005)(1076003)(186003)(81166007)(356005)(47076005)(8936002)(426003)(2906002)(40480700001)(26005)(7696005)(83380400001)(336012)(82740400003)(54906003)(110136005)(6636002)(5660300002)(41300700001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 09:41:24.0812
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39f8b547-0619-4f2c-1b01-08da8bfe2277
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6032
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
 include/linux/vfio.h             |  21 +++-
 4 files changed, 200 insertions(+), 2 deletions(-)

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
index 7cb56c382c97..bdac797b5059 100644
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
@@ -1628,6 +1630,167 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
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
@@ -1661,6 +1824,18 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
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

