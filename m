Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54AE5B25E7
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 20:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbiIHSfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 14:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbiIHSfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 14:35:32 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2068.outbound.protection.outlook.com [40.107.244.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4C9E72FF;
        Thu,  8 Sep 2022 11:35:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AqCFkLUuhIpX1+iN6XHXQ5uEQNMimIhBFS54AHzPKN2dBmTazLlrKIg3fuycT2gpzr/iP2sOe/iOlq1TkaJt9eX6kep44V36KApJVkmt0sdVT2gqtWlnlciciCQZMtnT6V7um/XDnBvlIixCm1UJeAl3j1S3JfKBlpXz7np/BtQCZJKH/T8jdnqBrprYxlwhBIb5xlA/9xTeLMt2Rkv5HC4zPukrSrf3YnsQRmVfkEI2h+iugV2I5JvjA+6RYM86K5kVlpKdeGQ2YaT1/oCTR410lxZpJF9v7co5JY+MMfYFC3Mahe3SuSaB9xdge3GWVHYEOa3I8M9I6Lh6ueeH+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1JGCx88CIG8mePg4BMFmBURFbej+fYal6iwvLEDpxts=;
 b=MqclLxEfd4jMWkdrzlQn0TNhFRue1WWB58aFj0FEqCHHBwjP3a8mJTov5WhziO99Oo29q/j+5h2SPecY4TiqC5X3xcIYgguJeAT7i0u/tlcK/yxDLivDTAjBSChvOqgX0Bvcex25k9cTPjZSWvskRcQurJtO+i51FcfHABw2amz7o0ggaG9qSOsduuL0M8B9Wj2+7FsbeH6yoni7FXaiRnpfaO+rg1eu09qaCNkV5U1TJ61HmrmmHozNDR7l0shgrR0c0lwkK3CNNx6bV6J28mPbzqgcUUYPLsURgCCdO/LP97KrgThfsNuNOG4fufsDy6KyncExskQb8tQK2KxfIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JGCx88CIG8mePg4BMFmBURFbej+fYal6iwvLEDpxts=;
 b=I1gvVXuujvELd2OA6O4t/ZJQ5Ev4OYiAFJWIw82Hnagh7sbLDU9UfcCQdGFL4pJCodTJGFOMO36Go7aRldeZgTKSC3+WwLE7iJVg7/pM5UCtsQoj8XgRyRXlgInm/AHlK3sNYyD6vCj8CcDGz7PyQLOqrccfdKzrzLlFAVbZalmaI4+75bt3fw8rTNORLz4vPMuZsPzNpUGDnL5IOARTj4Rrq4qvZkCpouma6qjWCxNM/3aaKxu0ZVeELgRWv8xhd2f33Y3VjLomZX3D10R4ER6IJDVvxwgAKBeoFEPJnxTnoAi4+qkp3st31PomMHVDfwA3ciUbe0stxNWJ90AkRA==
Received: from MW4PR04CA0374.namprd04.prod.outlook.com (2603:10b6:303:81::19)
 by MN0PR12MB6366.namprd12.prod.outlook.com (2603:10b6:208:3c1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Thu, 8 Sep
 2022 18:35:22 +0000
Received: from CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::4c) by MW4PR04CA0374.outlook.office365.com
 (2603:10b6:303:81::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14 via Frontend
 Transport; Thu, 8 Sep 2022 18:35:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT003.mail.protection.outlook.com (10.13.175.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.13 via Frontend Transport; Thu, 8 Sep 2022 18:35:22 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 8 Sep
 2022 18:35:21 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 8 Sep 2022
 11:35:20 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Thu, 8 Sep
 2022 11:35:17 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V7 vfio 03/10] vfio: Introduce DMA logging uAPIs
Date:   Thu, 8 Sep 2022 21:34:41 +0300
Message-ID: <20220908183448.195262-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220908183448.195262-1-yishaih@nvidia.com>
References: <20220908183448.195262-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT003:EE_|MN0PR12MB6366:EE_
X-MS-Office365-Filtering-Correlation-Id: 47676dfb-2ddc-4662-ccbd-08da91c8e36b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I2C5hKav5r88GJRFxcM7ws5XMAmlobcYxnS9ajivXnJtei/Ad6RfQ06RffBLkjGlYkSRswKRVbWfjYr0ykoVSKBL4ClSxFTXFantZWDVWzEFonl0K4PjCkA4FCTuhgwvxPK3OZf7yFK7bQM88SqTa1MN5Zla7DcUYvq7VHO2S8OtmaV5z5vxufVXlPU1PR09Ndrcz/Zo7u9iRQzZ+kmVyWKpGPURBS3NtAqGp00GFhxuunNefEoH2Aj187//ndVCn8wXV/AISQXIUhXa9v6NyO4YXK76mL8MbR5GDrbnIZU99O00ZHjOe76MRuuL7Wl/+TEcPUAnrdSkfg3Sqt3loaL/8n/WbnfcOOieNhxdGm1g0FfHeupT8UgZrr9zgTNMUFJt7xZj7L1EkdL8eNBU3A/iKfZD+Ij/cAbkWzybOnOPO9RwVfsmWV8XsmHWfoEB2Q0bszKxIY2R2z4k0v9EgYpdVWlSgJnrLi07CXuQRd5yRZHGl1pfb7HvLZcErjWZakP5sJd8AY5zzHJJOCsRgVwuCP/Gpn0rj/W6nAopuBLtP29ShquT0awEqqMZcTBFxzWtiodSiKEB0B++3GQqMAZGY4qv5XtNwZYvU+IxwFip+6Lsr04SKtUMYP+ekbOrO48ZgcxENvVnMItAgFyxgBWdfaFwB6OTz+/3hPyK8yRDzXkWIAkXaGTPuffa81J1apptZryagCfYzesCWNzV/SECRWfgq8/4Kx7vJcVPF1Iezfch+Y17tT/DzkTvHLUm3MAp4ZolQl7SpljSxxr8mmtaw5D/z9f2ZZ0ogJaHNx6qpwNJat8tY+TSUKr9KlRX
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(346002)(136003)(376002)(36840700001)(46966006)(40470700004)(6636002)(2616005)(110136005)(40460700003)(336012)(54906003)(81166007)(40480700001)(356005)(82740400003)(36860700001)(8936002)(26005)(5660300002)(1076003)(186003)(82310400005)(2906002)(36756003)(86362001)(7696005)(426003)(47076005)(70206006)(4326008)(8676002)(316002)(41300700001)(6666004)(70586007)(83380400001)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 18:35:22.0232
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 47676dfb-2ddc-4662-ccbd-08da91c8e36b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6366
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

