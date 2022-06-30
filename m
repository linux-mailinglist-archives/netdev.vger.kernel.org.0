Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07AC5617E2
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbiF3K1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbiF3K0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:26:55 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2075.outbound.protection.outlook.com [40.107.220.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952CF64EB;
        Thu, 30 Jun 2022 03:26:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OAFN1Q3MOt+B9mSugEQe9ehP8EIFp4GVNY9rj2RCxvuXMPFJwZ1sE3oJWTm+0QW6ZErLPrgANvqhIC5V0Sk3hYpcVpWUc2CQMjc0WCqQjlhN/TZgh5T00IO0G8cTm/zvXKq4xv2pAXkH5EnuJFkuDsIXVWWZg8bGjVRVHO9Jw0GKSk/ECukpHvZVoRPSCfZG64oeKP3muHAqE4HUf1u+YL6D+VOUQf9DL/RNai/Lmcl9Od4bQGbhqY7JCorefofaZDowcerWaKyK4xgl4iYv04fR+WOo7KJox5aZEvgiBTah+m5/2oeBLcYRv377wVJrDwG5SO5tGxkkzaTnTga7OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5EqIIRI1FyOZ8HM4UPb1WkhAWy887FklMrDRGyedfgY=;
 b=aI1iT0jqksJmNF2TTRF4acTp5E+QhsJwh5UnrQkeCp7GXGa+rzdyGR7w9cZD9vbD5/rvMMq5NVVjKws/KlLf5XC12jvVHrnmdAeDPR8PFZR7Qar9VogcLKQTrq3AQ6dn/Jhed8WcBIZOFtzInNjblcKo1EeobLclheZV0o9hB3yqRsSeVwaFibNoj+1rT26R2r1/AnKcJVjQKOAnwFq1TeulpdiqXyD/HOO8w9ixnHiGKPhaItwEnJKpLWb2NPvnsSjISHEs1Sq3rgh1nK9/aO0ckAnufvsH5FuXozbHxd7IooytSsg2EWxDARx3dMAwv7D0gW6tSyNm65B1KvxdbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5EqIIRI1FyOZ8HM4UPb1WkhAWy887FklMrDRGyedfgY=;
 b=BFYsfTCjW5GRcvGC2ALZ/OdVd8iM8v6XDFlLI+38ZpohAXr6Uv95o8kKYpBPGTkOxMYi54F8l56IX/h+Y3A3IlJgSwb71qrEqDPv2faDrfFaandf5r7nn7kW0siSXLEPphM2WSsvxjVX/3nfZachiUVcWCfzB2zFHvAEXszVXzsihoKN+C0+LX0iK2WCjWj/juoJI7QDinu/eWEmK0s0xyiIbVij42A0g+yn9R6b6Sx6cia9OiH9RE2KDJaGfHTTmcJaESwQQI7dx932ITNkMPEjaclLuKCTqF4hfjmGps8chsFjkOjr9+/dZLJYbW2qisJF6G9uu964EdjvgEUubQ==
Received: from DS7PR06CA0006.namprd06.prod.outlook.com (2603:10b6:8:2a::7) by
 MN2PR12MB3167.namprd12.prod.outlook.com (2603:10b6:208:a9::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.16; Thu, 30 Jun 2022 10:26:45 +0000
Received: from DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::89) by DS7PR06CA0006.outlook.office365.com
 (2603:10b6:8:2a::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Thu, 30 Jun 2022 10:26:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT053.mail.protection.outlook.com (10.13.173.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Thu, 30 Jun 2022 10:26:44 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 30 Jun 2022 10:26:44 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 30 Jun 2022 03:26:43 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 30 Jun 2022 03:26:40 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH vfio 05/13] vfio: Introduce DMA logging uAPIs
Date:   Thu, 30 Jun 2022 13:25:37 +0300
Message-ID: <20220630102545.18005-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220630102545.18005-1-yishaih@nvidia.com>
References: <20220630102545.18005-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f077296-fbf4-441c-8db2-08da5a830825
X-MS-TrafficTypeDiagnostic: MN2PR12MB3167:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 727AR4puT0+1DWURH4eQVODp42lrtp2W6H3+k8wziSbx5DOTLsxNe9xE7pqnyFQcPECjAgZkNw6OENlnDzOYk3RB5FdOp7GM8SZS+oMXklMurLq0SfDV0bQnK/7Ysjb2aFKJRLzAkPDif70pAzZO7eR0Qi0RbGbqDVChHpedAMxwRfMCuQbmk4nxBDRD96g/c4iwP/EiTbxgDWYhk6OonTrQmibcHTdRbytAdjeqBmyAfd0yPl7Pv91Ixyj4Yw3UXSNglhwIg0IqcX5JNRFoSeTBPFTVZoVFMBW4OMxn3kZP2q5OD2d1KTB8HaPG6tW+FxC8FmIDSLtfif3T1REwSiHHvGO/Z2DB0gWYWo0w1cDdzkLK0dFRh/H8fth77/PYgY+9cwnjSCRbIvTMb2SQr/me5RTjflcC+DiIstDLMVMWMjoxqVMXq9t3AqFEGpw4hO4gWuR9bJUS55st8O+nrLwt0sfFvBl+EDCJVnD0+hyWn0B2EsXWgLbMZGU8gKUKvbi0QnYB3gEY0eLHrcYS1AVPqx+kG9lke3ovKdSOhyMjTsOu8j9D7tHb4+UvSL1XIg3KFw9owg3jNq5SNBvRe6mmT9rvFti2YTOmQqbuuMVUX4oqNQlNs8Tt5ANa758V7aQOvVIlYj+pOPpgwv0wXFLdN7R3ifhiTs03efVb5LXl3TkSXMJCkRKtbBl76iaE6JPIy9wlqZjpXKUk0GhzZOLl/l8rtS54WFkb6vpYmjFf3qSlZCYbaOgjINJSjBPpntsGYosYjJ6U7PzyPd0JoMLqmDxsZJ4A3OGfu3C7tzlkLFvzjpIAfO7zjeD6HPcTHn7ET9WoxxqgsTG/jWQ1QKyase+OCP+XudCd2VyG6w8=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(376002)(39860400002)(396003)(46966006)(36840700001)(40470700004)(70586007)(26005)(110136005)(36756003)(8676002)(82740400003)(40460700003)(54906003)(41300700001)(40480700001)(70206006)(82310400005)(2906002)(8936002)(5660300002)(83380400001)(316002)(6636002)(47076005)(81166007)(356005)(186003)(1076003)(7696005)(2616005)(478600001)(86362001)(36860700001)(336012)(6666004)(426003)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 10:26:44.8834
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f077296-fbf4-441c-8db2-08da5a830825
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3167
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

