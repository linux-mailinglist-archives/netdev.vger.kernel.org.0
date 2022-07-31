Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF65A585F04
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 14:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237178AbiGaM4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 08:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237060AbiGaM4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 08:56:43 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2086.outbound.protection.outlook.com [40.107.223.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1575FE0B1;
        Sun, 31 Jul 2022 05:56:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TCCfsr4RI3VfZK4Gif+7hNH+Yk96zFnuSBhJ54v2IY4+hPBcJwQoGYsBzbMXiuaE/dNlnuephqU2KjGIB6GX4viklLnpIY+MrryRzZzboM8wL1UNK76AH9ud5dGMnDZBWpDLU4Z7HfkwwoStX2iM2L6QHS/tQl2YrorWzZv7meis4c4RcNDdnfof7jrLvHHe7JucUx5tm6cPGSF24pS1UUq7O+yShP2MPhRI8liPMVmdrnFiyRfwqB8vK05BrEJ5PeeFmMgdxkcIsDouGWbqme2C/7UjfvF7/Z0OH5BQ6JXlrLA5BsmMkxFJii5cMbS3O/AB2kAD/iVGO+hs6PEXVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iTntXPBgaoRuqaR89heyoG/Bv3h28ctO1QPxvEkXZVk=;
 b=Dy2fIxcBLg+QgMaC4SgmGsxd1AR0+RuVUviX2EAcDab08XTtqgBa+hl4DeP87m0ZuciTgxWfvxswmN821zdaS0YORAcMG7xqGJbtgJKvqMiYyADw0mn4H447lbzI60RuFm0xAefeYPNDTjA1tIbealEfzQ3/oHC/ka1Uyt7DADSFesEcPJoXCf2zBIb5HSJKrULOhxojFvbcw7wA5ymXbT2yN2NnfRQ1e0fbiDoFs3yE4rv4+mZ1glfJ5kZx009uXbzGNg21W7auCVNwR1Bo2xB5FnlwWhezDdqv7nmYaxGRB4B8Mhnzj47ANUVcssuyq+6IubsuNe8XRR5Wkp9nOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iTntXPBgaoRuqaR89heyoG/Bv3h28ctO1QPxvEkXZVk=;
 b=uLBuzXOsskWJLx2Xju1nRqDNgF8ZpV2mE5qsTOU+hdSXbLpwSdursaMs8g4fxs2FZafocxU+Jo4tRxBpLP9jol66ZnG/qmPNPxnpJ65sV4g8EwTRvNqYQS+HgUuodkl0Byg5V4dEbZ/2GkOpljlx9VNsoNxn1seql9QMAHX1FCUupdLBSXIADuK8AKAGEa6GJgu1fVSIKh26GmL4czOFbAB2AsizYrmZimVBkvCsSXGUqnL5/s3NFn7nOhXQ48E6ojA4oFQ1FQXjOz7q6E7TMY6XPwXuzCAoBWzBIxiB5yupWldzdzsykoCkwXvO8fsEy3hiAgYZ38hbl5k7kP6Jfg==
Received: from BN0PR10CA0019.namprd10.prod.outlook.com (2603:10b6:408:143::8)
 by MN2PR12MB4175.namprd12.prod.outlook.com (2603:10b6:208:1d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Sun, 31 Jul
 2022 12:56:19 +0000
Received: from BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:143:cafe::9) by BN0PR10CA0019.outlook.office365.com
 (2603:10b6:408:143::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14 via Frontend
 Transport; Sun, 31 Jul 2022 12:56:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT044.mail.protection.outlook.com (10.13.177.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Sun, 31 Jul 2022 12:56:18 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 31 Jul
 2022 12:56:17 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 31 Jul
 2022 05:56:17 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Sun, 31 Jul
 2022 05:56:14 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V3 vfio 06/11] vfio: Introduce the DMA logging feature support
Date:   Sun, 31 Jul 2022 15:54:58 +0300
Message-ID: <20220731125503.142683-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220731125503.142683-1-yishaih@nvidia.com>
References: <20220731125503.142683-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7970ed30-3285-4c36-3520-08da72f40fd6
X-MS-TrafficTypeDiagnostic: MN2PR12MB4175:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2YAM9EbapjPDdMKvSjcKBzhX0mGOPYMp8wTw9pdZGBuh+pwWTalNbyDssylsnl/eafYqaVFABJfekdFCWdW5c0DJtQ5TRraIyJ3a/KU4YhevO5b4GbS5OAW2dRBUwOitiaM/BhsRyRxGvvy7AtgtQAamDYXFA2DcqhbCDum7kRvJm7+xieOn8vAshE25tZD+bdmiHlR5GiGJLPjYvFuuv63ZDGflHbaR+uH0qTZdEBRpitIP1K0gZcB5jI78ikOcmRnF2pyz+qqKHvNr+lLBNnxpMTr1WSdMNSlOGh3YrrbwfhZJDdIs/x01XfUV4q5SJ42Ir7eKdLZ6uvMwHjOuo9hU9d3uwlv9tp7fbQWg1dHzGgf7qxeFr0Q1e+Jq2e8R50JjVLVg0yGzwouMXASeKE9T11dyXH1OK5fbnXyDp+mH0iO7fgZqkZnnTGnfI+SL8yPFaQSRMrAXpPv0EIXeSMeD/sNYtfJv4YV7/6FArNkuXLPwGef5y4lrSjrMvDo2NDZ1tyeq0M1N7j4D/YhetvV38cQgJ2HZjG9GQa3KD2r00vmhmMEvXwYxGRSEkPORYN/uSdzlPnZd5SDUGv1ick5RUG5HXs4UzWSJe1rxwnUQtEvW+FHBytvLLHpUpJ+AkS2p0dNFlx7Edi8HkP+ErIRXTk04j9xKiVYRZxMly+PHcIOzWjSeyf0CeDzkUVHbSUS9xcDeQbxKj4ItgBlGA/kRhOOfaybFKvCWg9W/y8RSL1znVa8wWk8ThD62EraXRMwuDtJOCXyTokStkpWmCQplTJCbeHcV7Ji1axVvTfh+djEA6rF3FDIBadV/b/WofT8cBFzAaAWxNUa4cbkluQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(136003)(346002)(396003)(46966006)(40470700004)(36840700001)(1076003)(426003)(336012)(47076005)(2616005)(186003)(6666004)(41300700001)(2906002)(7696005)(26005)(86362001)(82310400005)(81166007)(82740400003)(40460700003)(356005)(83380400001)(36860700001)(40480700001)(70206006)(70586007)(36756003)(8676002)(478600001)(4326008)(5660300002)(8936002)(110136005)(316002)(6636002)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2022 12:56:18.7129
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7970ed30-3285-4c36-3520-08da72f40fd6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4175
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
index 8e23ca59ceed..ce926ff36183 100644
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
@@ -1625,6 +1627,151 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
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
@@ -1658,6 +1805,18 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
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

