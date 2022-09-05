Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 697365AD102
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 13:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238002AbiIEK7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 06:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237290AbiIEK7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 06:59:31 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8531E3883;
        Mon,  5 Sep 2022 03:59:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kf7XkFSs/QALKeMQXhUQz+Ct7ONU+qUUEbCjNsDlewuSb6tdsI4GujeyNDc38z5ZjuJcbs688d5WCWonF8ffyR4VpXDQJFzEIV5K7XLdY2YO2K48xGNk5QrFP+WdnTDwnsXzozPNU2liTXXrnm4YD7roZ85J9klVoihu2MjTBuf/LJsmQmKYwn1Nm/YhZBijE7BySN24OYaQqyF4Eo3/3T/DxmpfM58IGTnAhUBonKP7wM6t2BH6Llb1i+hXJ8mrTf6nmiY+ttT4opX355nQWEv0WkGPddFrQWmvO4F+HnCBbT3e33MDAPvssUg0c1LLMrJAk0PxHXs7aj+rEyKE0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1JGCx88CIG8mePg4BMFmBURFbej+fYal6iwvLEDpxts=;
 b=NP5oG10ED6JuzIztnRcNmtzoYU+Y/6du0h9n67Zpsz4IbzuaDQIHgTsWjW7lf0Jbhb4hnDd2KF2pHrqbS7WOH2Bii9WzwiB5jT2ODEnl/GpSrH7aBpWcDvOPpCl9MDw4CCKkWMawuFy7ypOj+aS8lBTHBYc4cimQyzxMw9j9VUhwey7ZDMUi36Sbs0NOOcmULd5kxbC075ymAVKdlDG/6U6ZR/g3MXFN/y+8f19r5LKjVvyWlQXCGhENoPGPI87zlKjoxMbvSSOFwBJCwEBOToH0kzMKZqhGAVOh5hEUsXJS+Fvbzt4hm/Gd/Phte0ZdimXCAOiS8ACoobXDCg2nyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JGCx88CIG8mePg4BMFmBURFbej+fYal6iwvLEDpxts=;
 b=TrvA0025Ns40I+wy8DTVm0+SY0v9teGlh/IxVUOUlKcLhp6v4L3F7FDSZW1gfvnGH9TUr/p5MnaJBSGHiz0SxFC4+vaLgSyhDrQ6QwlmZa1oZTV3EyLLfue/kHlXa3M3z10TkM4QPXGmcOh7XxthsX33YFa2kcvjknJdgeNoitw4k4/3pyE7mwzVUvku1qRPnhcGOk2WH8W+UOre7gkI2BKJgWTOJYXOC3afsU4iXBUC8GfaJc5j4mPd8FmDr5ps/WdTQ8Wrya4G9cw6DlnageUCM/REYotahVtCHVua7uOoDyqEjthjCLNp8GAWJtLQqDEgGFT1ZvJH6ribDZhiXQ==
Received: from DM6PR02CA0123.namprd02.prod.outlook.com (2603:10b6:5:1b4::25)
 by BL3PR12MB6641.namprd12.prod.outlook.com (2603:10b6:208:38d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Mon, 5 Sep
 2022 10:59:26 +0000
Received: from DM6NAM11FT072.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::e1) by DM6PR02CA0123.outlook.office365.com
 (2603:10b6:5:1b4::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10 via Frontend
 Transport; Mon, 5 Sep 2022 10:59:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT072.mail.protection.outlook.com (10.13.173.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Mon, 5 Sep 2022 10:59:25 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Mon, 5 Sep 2022 10:59:25 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 5 Sep 2022 03:59:24 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Mon, 5 Sep 2022 03:59:21 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V6 vfio 03/10] vfio: Introduce DMA logging uAPIs
Date:   Mon, 5 Sep 2022 13:58:45 +0300
Message-ID: <20220905105852.26398-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220905105852.26398-1-yishaih@nvidia.com>
References: <20220905105852.26398-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7262da2-21b0-4566-4953-08da8f2db293
X-MS-TrafficTypeDiagnostic: BL3PR12MB6641:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jPofayb9uxfQ0dQyWdUzOoew56O7ltTRD8TQFXLX1QA7NUVycAw5fW24s5ZfJ8LdE0CE2dTdUM9SdXEEzLitrG8LZM8BnRNXwU5H1ZrKV5wyDtdb2ZleIkLSqZS84aq8rFPUAunlzsYfoFcshxoGjxO/ocM4s92nz6lorIgpqmTN3xbWuQX6bpZ6zRUQrRk1R5an+tzpLDPyiIlEb/4tz8EzMwP60F50i8Cft/q3ImCJZyj11yxYIKgbY+x4Ufwb26oHfUK83s2WI2kSD0SISkgM379mwGP0qHUqJW5XLvtCVh2OWHTP+jutctNePDd20d3Yz798EhbWTYjXFiAMvUDHiqspdd2HocrfIiGjVRsQ2Ioc3Rp1NnAiH4FMo6tAW+JQlPLt8sYpPZQiqAz9FV8olpgeDGx0ZZyciMKkgL9mvbVB+bCciKoLCiTZRFlNUc4iHG5wAs2yzDfOcnoN0yShYuPcup4c6seak2PVyOfFjrWpvCRW+3UybDBkK+0/4H5tQVxyPo6d2iRqYZleqtJqb/I9V3fBrtHZnBIUiZ2j1W8lJ81k4i1p5P+8Twn4mb93t/Ibh8No1W+5VfoyTVURycu0gTu68ZqiOJb33wMkgPSSIw0yQYgbynNBD/NzWqF3WyByF0fn12o3WoB4CSNdaf01JZoic49hzbdU+5yd8S3c5ySHAOE8Mwj7QnQ6mmKdFGcdrLK1rUPYrlmAyYZYyc+bAr9vtb1uaG8/xCAVEYcwtkNMLUmKUUnA9b5sea5R2I+OAfusqrUITsT+ELHNrBCdqGaKBEGRLM6AKPCRsV7VPuR8cPa0y3Q9CGf4
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(376002)(39860400002)(346002)(36840700001)(46966006)(40470700004)(40460700003)(83380400001)(356005)(36860700001)(2906002)(81166007)(54906003)(70586007)(70206006)(8676002)(4326008)(40480700001)(82740400003)(316002)(6636002)(110136005)(82310400005)(1076003)(8936002)(5660300002)(7696005)(426003)(336012)(47076005)(186003)(2616005)(26005)(86362001)(41300700001)(6666004)(478600001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 10:59:25.7393
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d7262da2-21b0-4566-4953-08da8f2db293
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT072.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6641
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
index 76a173f973de..d7d8e0922376 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1042,6 +1042,92 @@ struct vfio_device_low_power_entry_with_wakeup {
  */
 #define VFIO_DEVICE_FEATURE_LOW_POWER_EXIT 5
 
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
+#define VFIO_DEVICE_FEATURE_DMA_LOGGING_START 6
+
+/*
+ * Upon VFIO_DEVICE_FEATURE_SET stop device DMA logging that was started
+ * by VFIO_DEVICE_FEATURE_DMA_LOGGING_START
+ */
+#define VFIO_DEVICE_FEATURE_DMA_LOGGING_STOP 7
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
+#define VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT 8
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.18.1

