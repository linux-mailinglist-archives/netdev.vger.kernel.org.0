Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A41585F00
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 14:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbiGaM4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 08:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237019AbiGaM4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 08:56:17 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2049.outbound.protection.outlook.com [40.107.212.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB746DF44;
        Sun, 31 Jul 2022 05:56:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WxA77sXjRegc/aKhCcTIiPFijTQG3tXld27g5Zj/YmKwvWSPyOro+jv/ViBgsvcnITVzxhtspfJLT8pvZ5B0H4bSEUVUJRsgYWTMQGuLBCqVIzeyGRPgjCGwc1F8//UFmtnQUt/rpN8Dk0No0gGXPUgcV7VDT9aq+inPvTrup7ih7qibsY0O394Dkn2MsSgXuy9bylRxblm5k2016MX/eMExw3//UWfzCyujo3TQ+oHokkKqUaYBQMrYfKo7Cmn7ypBPgQ0FPz+t6vCocF64cCHSymUp10+H6JtMT/giQiRhadxWktwe5Uy0Zze6dGvsnXj69SPt7/NupKT6K1Xx+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D/cSgoMv4xefjZf262Y85o2OcBrR3dR1lozAZKJZH9c=;
 b=FQ1AgDFoE+SV2w9IXZryPorVNCo1TNnMnma1mfu2Gi3oXkdPXOue+2RbodJvroC9Lm6Uf/QmhtOI2wcrPH3JoKwFzC0/odg+lQOvnihaptrrgyN70ut7NGo4u8VFl7TvEa1bNinw1CewzXNF+LVtjUly4Q9iuMmVzov/8ezB51yCOXRFrJ5DY5H1uOMNWQZKD3+LYTKyCWBPAEjOX7GQxcAgxz89RyaR1nt+PrzMT0bcnzPT5YKBXzi1r87/ZWrq95f/XXWrX8upG8lRhcJ+GFAoo7o5HPBUxCW3KHv9NRkLRt7mM4v7hcEpldG8BS3hMWOlbBkpexCJpxKVuxsddw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D/cSgoMv4xefjZf262Y85o2OcBrR3dR1lozAZKJZH9c=;
 b=nMHDd1A3KuXS0dQ9CuE5g10ETTwCIbDSgqTD23BRWRyiC/svLjIYYbYZsVMTWLV1ZroSPQxFzW1ua3JH6sy1w4TJ4vdWZg3JSBX88Lg4ZvSO9O6RVpYoKb3gaRM6biWrVVESBfG6ksYTI9ztBuKlDgBiT/+1ptY5BbwV0sWD2qdET1q8LCK73oBcG8Wyz1eSgha9tC+AJgpiIlHX1luTrpenoMtTHU0C2t/wBQafYNBEvq6jt5if+8hzK8RyfWtKKBWJtU8xjKMcH7B06UoDaqbn05TH9X50ugaQkiu9XWtKsNMf8FACwIWLc7oRSMGettuHCn9BxjzlxhX4trugXA==
Received: from DM6PR05CA0043.namprd05.prod.outlook.com (2603:10b6:5:335::12)
 by SN1PR12MB2590.namprd12.prod.outlook.com (2603:10b6:802:2e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.15; Sun, 31 Jul
 2022 12:56:11 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::d9) by DM6PR05CA0043.outlook.office365.com
 (2603:10b6:5:335::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.7 via Frontend
 Transport; Sun, 31 Jul 2022 12:56:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Sun, 31 Jul 2022 12:56:11 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 31 Jul
 2022 12:56:06 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 31 Jul
 2022 05:56:05 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Sun, 31 Jul
 2022 05:56:02 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V3 vfio 03/11] vfio: Introduce DMA logging uAPIs
Date:   Sun, 31 Jul 2022 15:54:55 +0300
Message-ID: <20220731125503.142683-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220731125503.142683-1-yishaih@nvidia.com>
References: <20220731125503.142683-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 075971d0-edaa-4da8-9467-08da72f40b38
X-MS-TrafficTypeDiagnostic: SN1PR12MB2590:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +Bp0bd3mw3ZhUBwGQyrqx2fzVmAmtXo8Xlz9jsSY3qbyYlrOLddDdznASIuqIGm+WRLZP095mc8n9F8ek36okacL0A2B2o88pnPHHqGzfyedynOLJOnc82qt3TGU3BzBcKNdlbgfSJvVV0xNPGMLyZh8LGWMyfxM06H9qT211WNLJyRQkQjFEGJDDC+oJde3CPq7bWVaNUMuPhbQQx7yzwmzRZLFPUrvAfqSNrvIFbM7/dYRBAKnAMg4l9bEJMGXE+MOCjYPzlHlGRx5uCBRlqIrKGv583W4CPrrLwcZF558dgQxjKIIRA9SJk2dWL3UdLAu7NprHiyLz9vTnOtSSD/jj8SNWTQCZNc3xAzkBgIjqzOOSiBVBTdsvdOp6q1Gm8S46RaT+JhSCt36n8AuDmz4SsHxy+Ouz+ph90nbIpuLxkxaM2ypniZGTSkQ7u+OPIDk6/tONfWbb/M/qemqLLCpPtGFzaHCkLTo51J+1LU6vz4dYHMcjerUp/i/Cs2ONfgfLiDzsLFOY0TFzLiydrEd6yg2vO4+jGT5NQipqVZ9fp2hxdOYCWVl/PfsDjHZjDZQr7Tt7sHKD25SsZAzUPs9T022i84KmPyS35Y3iza+ijT1HBjiKmEiC/7mprOHCYGG1zBP6bbyg+GrL7AVahMn04WVm4an627v0LzfrmGyYv+2fS8RMuxKVCqpYMjaGLpsbqEZx9HmScg8WsfKvlZdvxvwViHMSYRoMRteNJj7SfF0L8PuzXlFyrso3cFjVBaci67neuA41IR+qPCdbOo5hebIwV6TBvYkDNuprkCNsClAaVHoIUZxrasMuy7aDwD0MXBHufBABgk+oHIjCA==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(396003)(136003)(346002)(36840700001)(46966006)(40470700004)(40460700003)(478600001)(41300700001)(110136005)(54906003)(47076005)(426003)(336012)(83380400001)(36860700001)(6636002)(356005)(26005)(82740400003)(7696005)(6666004)(81166007)(186003)(316002)(1076003)(2616005)(4326008)(8676002)(8936002)(2906002)(5660300002)(70206006)(70586007)(86362001)(36756003)(40480700001)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2022 12:56:11.0940
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 075971d0-edaa-4da8-9467-08da72f40b38
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2590
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DMA logging allows a device to internally record what DMAs the device is
initiating and report them back to userspace. It is part of the VFIO
migration infrastructure that allows implementing dirty page tracking
during the pre copy phase of live migration. Only DMA WRITEs are logged,
and this API is not connected to VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.

This patch introduces the DMA logging involved uAPIs.

It uses the FEATURE ioctl with its GET/SET/PROBE options as of below.

It exposes a PROBE option to detect if the device supports DMA logging.
It exposes a SET option to start device DMA logging in given IOVAs
ranges.
It exposes a SET option to stop device DMA logging that was previously
started.
It exposes a GET option to read back and clear the device DMA log.

Extra details exist as part of vfio.h per a specific option.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/uapi/linux/vfio.h | 88 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 733a1cddde30..d6a59b5d4312 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -986,6 +986,94 @@ enum vfio_device_mig_state {
 	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
 };
 
+/*
+ * Upon VFIO_DEVICE_FEATURE_SET start/stop device DMA logging.
+ * VFIO_DEVICE_FEATURE_PROBE can be used to detect if the device supports
+ * DMA logging.
+ *
+ * DMA logging allows a device to internally record what DMAs the device is
+ * initiating and report them back to userspace. It is part of the VFIO
+ * migration infrastructure that allows implementing dirty page tracking
+ * during the pre copy phase of live migration. Only DMA WRITEs are logged,
+ * and this API is not connected to VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.
+ *
+ * When DMA logging is started a range of IOVAs to monitor is provided and the
+ * device can optimize its logging to cover only the IOVA range given. Each
+ * DMA that the device initiates inside the range will be logged by the device
+ * for later retrieval.
+ *
+ * page_size is an input that hints what tracking granularity the device
+ * should try to achieve. If the device cannot do the hinted page size then
+ * it's the driver choice which page size to pick based on its support.
+ * On output the device will return the page size it selected.
+ *
+ * ranges is a pointer to an array of
+ * struct vfio_device_feature_dma_logging_range.
+ *
+ * The core kernel code guarantees to support by minimum num_ranges that fit
+ * into a single kernel page. User space can try higher values but should give
+ * up if the above can't be achieved as of some driver limitations.
+ *
+ * A single call to start device DMA logging can be issued and a matching stop
+ * should follow at the end. Another start is not allowed in the meantime.
+ */
+struct vfio_device_feature_dma_logging_control {
+	__aligned_u64 page_size;
+	__u32 num_ranges;
+	__u32 __reserved;
+	__aligned_u64 ranges;
+};
+
+struct vfio_device_feature_dma_logging_range {
+	__aligned_u64 iova;
+	__aligned_u64 length;
+};
+
+#define VFIO_DEVICE_FEATURE_DMA_LOGGING_START 3
+
+/*
+ * Upon VFIO_DEVICE_FEATURE_SET stop device DMA logging that was started
+ * by VFIO_DEVICE_FEATURE_DMA_LOGGING_START
+ */
+#define VFIO_DEVICE_FEATURE_DMA_LOGGING_STOP 4
+
+/*
+ * Upon VFIO_DEVICE_FEATURE_GET read back and clear the device DMA log
+ *
+ * Query the device's DMA log for written pages within the given IOVA range.
+ * During querying the log is cleared for the IOVA range.
+ *
+ * bitmap is a pointer to an array of u64s that will hold the output bitmap
+ * with 1 bit reporting a page_size unit of IOVA. The mapping of IOVA to bits
+ * is given by:
+ *  bitmap[(addr - iova)/page_size] & (1ULL << (addr % 64))
+ *
+ * The input page_size can be any power of two value and does not have to
+ * match the value given to VFIO_DEVICE_FEATURE_DMA_LOGGING_START. The driver
+ * will format its internal logging to match the reporting page size, possibly
+ * by replicating bits if the internal page size is lower than requested.
+ *
+ * Bits will be updated in bitmap using atomic OR to allow userspace to
+ * combine bitmaps from multiple trackers together.
+ * The LOGGING_REPORT will only set bits in the bitmap and never clear or
+ * perform any initialization of the user provided bitmap.
+ *
+ * If any error is returned userspace should assume that the dirty log is
+ * corrupted. Error recovery is to consider all memory dirty and try to
+ * restart the dirty tracking, or to abort/restart the whole migration.
+ *
+ * If DMA logging is not enabled, an error will be returned.
+ *
+ */
+struct vfio_device_feature_dma_logging_report {
+	__aligned_u64 iova;
+	__aligned_u64 length;
+	__aligned_u64 page_size;
+	__aligned_u64 bitmap;
+};
+
+#define VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT 5
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.18.1

