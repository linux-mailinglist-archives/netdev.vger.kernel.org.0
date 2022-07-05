Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308AE5667F1
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 12:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbiGEK2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 06:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbiGEK2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 06:28:41 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3128C140D1;
        Tue,  5 Jul 2022 03:28:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aQp2Iz05zSZzkLNd0l2IINiI2hpA56F+XRj5pk7ICJjdPsAvfbyImKzV0ov+9i9QERf3OGgUqh0pJxsoyEYjr5KkBvqmm2m8MUedAl+D3yUK+NvL1U+RSfXSyx1kGvzJvFarA5Jk55vNx0PPHiZcTi281KzyvWAUVaX5qtqSmUK3MHysdoT+0ZtuSM3LqqU67y9xonYoWYF5i+1CYA5lGsiEgcRELy1mlx3jVJcqhi55DzlP7Yz2UDMM3L9hfh3SWbqrQxLQPzceDr1bAdV2cgrSeqy+u/WYS/CNvsglPiD9fQpbWlL5uDqn/saf52F+0AVbUm5XxXJGSGlrd/K8og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5EqIIRI1FyOZ8HM4UPb1WkhAWy887FklMrDRGyedfgY=;
 b=Q/bp4HdbkIKU/zthLKUDjPcd7yyv5OfOcL5mtQEbWHagfkHqJEZMfW/yZZRBGfkWQZavKYzqyQUWWHt4RKCrK3UXz/PUpeVk6Y1qex36d4VBHJRUxT9UcGIqtBf34DS8PGU2tvHHwp0gmNICud5EbiER86i47mvYg0uWzdUT5wcZ6hg6Q50ETSBoCWBcME5Rs0hR1Fveklc4qpZJIQn8zEBXbATtnYP96K5JounbA821HUYuYwqdYzLvV9/AubSE5mVFp62qvUWPfYYg8leU51hfEDgFse4jAti87BiY5ZcFj+9klkFlArfSimJzO4ufj0wXpc4UHQ0Lc1dELMbZcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5EqIIRI1FyOZ8HM4UPb1WkhAWy887FklMrDRGyedfgY=;
 b=smH5Ey4SOdIy44PxoUhVI751NEZqZ8dCZLUPkTYBSMiMlCSw14Ip8lUn5WkWvTBUPf0tIXDy86bHYBW86KJv4zARPL4D69S0MwBJwpkc03uhTP3gMH1xrpROb9SUjIEwVh1RRHLJyc8RDj8Ovg5RH3YeSDLGyB+9JS/IKVUmeaJAwxRw6u/6382KzV9NC5Hzx43wI5Z9CV0+LIb7x+/iIPrgjXZeY/9A/FNcpHYFgUtfmzRyBXwSw2TR/CSG8AOTti26ZqBX4US09pv305Fp+yZG7ZXT7xgv0VAd6iK05ykjGQUF/dJpJEjiwGwKs7AbIDrxTdaAItr43Kfc3Vs/HA==
Received: from MWHPR17CA0066.namprd17.prod.outlook.com (2603:10b6:300:93::28)
 by CY4PR12MB1239.namprd12.prod.outlook.com (2603:10b6:903:3d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Tue, 5 Jul
 2022 10:28:36 +0000
Received: from CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:93:cafe::1e) by MWHPR17CA0066.outlook.office365.com
 (2603:10b6:300:93::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21 via Frontend
 Transport; Tue, 5 Jul 2022 10:28:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT009.mail.protection.outlook.com (10.13.175.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Tue, 5 Jul 2022 10:28:35 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 5 Jul 2022 10:28:30 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 5 Jul 2022 03:28:28 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Tue, 5 Jul 2022 03:28:26 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V1 vfio 03/11] vfio: Introduce DMA logging uAPIs
Date:   Tue, 5 Jul 2022 13:27:32 +0300
Message-ID: <20220705102740.29337-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220705102740.29337-1-yishaih@nvidia.com>
References: <20220705102740.29337-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1219caf-8602-4d3a-b494-08da5e711e41
X-MS-TrafficTypeDiagnostic: CY4PR12MB1239:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HneHgBEt6Ou9Eqfxvpq0hNl3urOBUZNgcwOlwI0RrpcmLsgPfj781dLc2kS1h/VWuA2aXqj/TEk+vkDPdKRY56iqtlbJzzAMuZx3iACCJULoRE7u2wQHjudblRHOeh5YDIRn9RFDY7TElmXrQuOG6Ve1DBzDyEV3TLX9uLztD81iQDvAFrPT7uuVm19sNzQWoPSVTziepKwkuam9yd9bhq4+gn7+oVwwIlPFeQISQbWfHOpwJOPj14Qg7ZVyIe12PEceAxHeypz5x+QWeKdnEYFNMcPTy+dy++/ddkWBu2GR1WSYZojYj1MG0MKmy6BNEEfEcwapiebYDrr2hDW5liSRHSVsPyFIN+7Iatc7qu+44d1dyHcP2QCqzjO5j7itDW7Ce2tK3XrbG9HewMot323kWIG3vTcWYtpaFXEH92YMB561xiXKToM5COXO7Ac/MrxZAFojH+DAWwledmeEWd0wnE6JylCAT3mH4dQwD/hTyFkg1DZuiOuY7aioF6DTS7knwdVUO/wDGzeTe72G5aEwRpSjEuG4fCk2WH7L7+O3w+rNknnUc3M52d2Jlp2XJWCxepUn7L1fW1HhUqTWBQX+Fu1M6oTA9Iwc+JT+D+0bJAkgSRXmEFqcbJXzetYKi02jsuNJURhtRhUouw/KSd/aHAeUqTqrRIA6mNPGSx9C3lG+SwbSePLux64dKj2VBJov9JPi9x91FPG5YlFI2U2kf+4U/Z8kp+afHxQv4T4dCy5RH1DPfRQUQEF+dZep3k9DRPy6wjJx9jlnAjRItdtr20YjObDUuoZTyh0GqvHBLiYXLU+oMfOiPEyRw5U6KYfhGWu3V+h4LJyxKyBmzjxtwBRy4Xk0j4MghuScOq4=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(396003)(39860400002)(46966006)(36840700001)(40470700004)(36756003)(26005)(7696005)(2616005)(40460700003)(47076005)(186003)(82740400003)(83380400001)(1076003)(336012)(478600001)(40480700001)(2906002)(8676002)(70206006)(70586007)(4326008)(54906003)(41300700001)(86362001)(82310400005)(8936002)(81166007)(5660300002)(426003)(36860700001)(6636002)(6666004)(316002)(356005)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 10:28:35.7034
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1219caf-8602-4d3a-b494-08da5e711e41
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1239
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 include/uapi/linux/vfio.h | 79 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 733a1cddde30..81475c3e7c92 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -986,6 +986,85 @@ enum vfio_device_mig_state {
 	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
 };
 
+/*
+ * Upon VFIO_DEVICE_FEATURE_SET start device DMA logging.
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
+ * should try to achieve. If the device cannot do the hinted page size then it
+ * should pick the next closest page size it supports. On output the device
+ * will return the page size it selected.
+ *
+ * ranges is a pointer to an array of
+ * struct vfio_device_feature_dma_logging_range.
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
+ * Bits will be updated in bitmap using atomic or to allow userspace to
+ * combine bitmaps from multiple trackers together. Therefore userspace must
+ * zero the bitmap before doing any reports.
+ *
+ * If any error is returned userspace should assume that the dirty log is
+ * corrupted and restart.
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

