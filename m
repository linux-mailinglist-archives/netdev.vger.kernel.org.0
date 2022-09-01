Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89AF65A9356
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 11:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbiIAJkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 05:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbiIAJkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 05:40:51 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CFE122380;
        Thu,  1 Sep 2022 02:40:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQzyLu+/YjHaUrinImDhStz8jOPU2Vsi191d3SZs2KMvXORRkcP7xG/bydgSe/tc7XhNO3CK2bs3ajYV5NKfbQOPBsS3MVozflNPFyjBjzLUrwVUSlvP6SnvASJ42Ac1AhjtUdmLDktQ9J0Pq/9BhHc9lH1m+CyHB7fuLVNLPliaKBK+cPPfDHcSdgddGtBLQwAQCADi2xaoXactIW9uMEqSd2td7QDshEM2QV4q4rjt4yl/PewpnLhnz+Hm96ux/+o6zQ+5skY5yT+AZX6vLGHMx1xbvjKn13mclz95K9NbM0HmXQPUt+029j1UON/0yvALzBZr+QPTqXFbtPH8HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bGO3TkiTw2iOXlUmxtzzhx3ffvb85wgCEX2VrsXq2pE=;
 b=CnTR8YrP2mEeso2zCo0LEp/XWMDSawGf5Omv9wt9u1p/+P9OSXj71k6zGIHtC7nDOU34lep19WRVfoD/D/ZwHWUHU/Q279KexkNO/dLAyHghdBVYcoMP6EKmWWgGdZjNkoYUIkBIAsVfN8RCFi5/B17nefdUaOAaStF5zAKoiQ65uVInSf0ZBSXMRQ7ideCpvs6TzuCKD9nFQ1TN2EfF2u69+EdFyTAsew8bHRl02oDm3KtD8sHf5Z1N84trLsIxl//+0yaLR4GlV2jqItOXqbO8NR3CQxJRQ4zQIv5tgSZjMQUBlJmt4BRW+IWszEomBgwD8Xvz8lRwXPO1sf9Dgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bGO3TkiTw2iOXlUmxtzzhx3ffvb85wgCEX2VrsXq2pE=;
 b=PVs8edooZQOXP3rQWjiBlvdKHkF7nn33YA0tmKuA5a27FGqNhbq7ZDbfDS2rRzE+x92TZMM6hsttP67MVEbSX3OglBdjWxJur7ooJ47euI232C7LbOxmIZVBstFhvZftLo615pthpenFUvD3a0JbJXnzGwxyLY/KE9GJuwJLxlk029N2lbuNrA0fwkDcGgJx6EuImDtKxA3+lyoOEp+XYeCo9lxb/0hmM7sUwXSgIW1g37f7KnasN2opRE6B+B/+9aMRP+xHwKgE0ZpijM5TdAJwtsrdZxPZQbTWWzPQNPq1lfHLNxK0CKQTkAhHdFRBiWPQns5ZAlZd4C4bgsGjkw==
Received: from DM6PR02CA0116.namprd02.prod.outlook.com (2603:10b6:5:1b4::18)
 by CH2PR12MB4117.namprd12.prod.outlook.com (2603:10b6:610:ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 09:40:40 +0000
Received: from DM6NAM11FT111.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::87) by DM6PR02CA0116.outlook.office365.com
 (2603:10b6:5:1b4::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10 via Frontend
 Transport; Thu, 1 Sep 2022 09:40:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT111.mail.protection.outlook.com (10.13.173.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Thu, 1 Sep 2022 09:40:40 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Thu, 1 Sep 2022 09:40:39 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Thu, 1 Sep 2022 02:40:39 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Thu, 1 Sep 2022 02:40:36 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V5 vfio 03/10] vfio: Introduce DMA logging uAPIs
Date:   Thu, 1 Sep 2022 12:38:46 +0300
Message-ID: <20220901093853.60194-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220901093853.60194-1-yishaih@nvidia.com>
References: <20220901093853.60194-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9619180-de60-42b9-a0cf-08da8bfe0833
X-MS-TrafficTypeDiagnostic: CH2PR12MB4117:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uN96FKYiWFLmXbitP8TzPXjHjpeb34MSbzcEbJmn531b1+4WqQ0mX4pf4ZIHfd0Lnn9lsUW5v+HPUUWvsoL3vfuddZnKCVZklJHXkNTbqksogd4Hq/j1PEzuez0D4XQ0J3s6/EmjvAIeR+GhOkrHTVOJzxlY1wMuYn7/kNUkMbQUPljkUbCCboVAcrWOHx/BeJMkghnYQJXDSaZEqzDJ8SjlhR4heXz3ZijDABNfZ0jDhCEIvKzZ45pVZP2rlTpvfQ8yzHqRv72hJQUxGSsoUp8yFMLgoktPJwaiRha6Tk1nlPUpDv86gJLxSpw+/E470RvIs+TEmKWAmJTf0uFGXyvgAu+svKmWgkwlf8gFtF4loLuUy/2YqFtwe4a5KNAfJje0wCx0M/LPTA+989gPZ623DBLcTwuuQSQmntnwRDK4yxyOPwlyNbIGpHOAhUANzxqTLmrdHI47MFJTbR5FmKQqT6Pc6cJngACgFA4gQuESU46uXdEvWZtY2+T4mSPGJlmFMAXp2dFUnEhXMxXKPQf0zAFxw5J1oCmjnKFZBgKkYqwbyWlmkoaGGNsg5YHig1+eQ8MZkuj1Ihd/RG+IuorsIjG8MU7XVfLOsJegkauKObDvmBmCy1RoMJPssOFsLngd1HiddB2BC6TbtkKRTTcbTnJZY3g8YnIa3NAf3CXXjLn6mfc9aQyapilTA4voegZb2VHRtIlb3d4Y7hhll1IVRlVOpxhqfIhQkZsm1Q59iPDrJyM+vbTpYYioEn8xjvRnaYnHNR4fA45/hZZk+rLzIB4VCOMapZMCiegG46JbDnuCtWtrk114OnF7+w9m
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(396003)(376002)(36840700001)(40470700004)(46966006)(82310400005)(40480700001)(36860700001)(82740400003)(356005)(86362001)(81166007)(70206006)(70586007)(478600001)(4326008)(8676002)(41300700001)(5660300002)(8936002)(110136005)(40460700003)(316002)(54906003)(6636002)(47076005)(426003)(336012)(2616005)(186003)(1076003)(83380400001)(2906002)(26005)(6666004)(7696005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 09:40:40.0651
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9619180-de60-42b9-a0cf-08da8bfe0833
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT111.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4117
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
 include/uapi/linux/vfio.h | 86 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 733a1cddde30..aa63effc38e8 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -986,6 +986,92 @@ enum vfio_device_mig_state {
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

