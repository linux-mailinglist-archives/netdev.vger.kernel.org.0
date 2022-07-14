Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA21574672
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 10:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbiGNIOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 04:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbiGNIO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 04:14:28 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2068.outbound.protection.outlook.com [40.107.244.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0610217589;
        Thu, 14 Jul 2022 01:14:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k12clFBmbUqazt0DvJkk6glv9FUX+e4dTeyLRniHOnygzbwWozDIGIh3tsQP90T/etjq/bruh5dEzmnPt0nbm7A2w30d58TSi2/ciSH/wREa5A2rHz779Qq88kE8pVfqx7NEZ1pzyVCK/H+tZs/rdRlobrqUziRFF1kzR60Zlgknj0eJQKaP31lJYYbo2PLbq89rZ0ZkBzu6y5BDybRxHydzqwFIu3FJNcJxFuMBb053WtGv7smmGXJySEjM/4His1B/0QabXyXAuu/0dUAwZ3tQurbOge05XNepoB/+U03Yokc6Fs1DcrpSEBBkeHHhfDfCpcjGq4sAV4ZtaJHERA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5EqIIRI1FyOZ8HM4UPb1WkhAWy887FklMrDRGyedfgY=;
 b=gWEXAKhbF2FrFlzpnMq3eeI90bzOGGU77xk599E6J1jFTlTEKWcGNTxS7bc/CA6iMfUJNc7QyKHHTr/3mppDNeklxENmJNLZzSll5IGrvcxHpz+QkGgjCE2MMv9rhXi6+crBRmTLQRnwSOCEdp8z3ThHuOBYq5oJH6rJ/vvZzIMSRiSA3SUg2i+pa0AdT8ht9dZ1l8tnJTewf1gDkuwvyEofEi6jNBmT/UPY2s+PmB36JrpjJbDelkfSSf5wX6iyo+RrFSFJlCFbTamEfIiTurWn1hj0sFylj7FbdKaWmlwjHZGTjTlYnRsFsqiC5ix3P25Ome7pp5qNxcrPCmnI4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5EqIIRI1FyOZ8HM4UPb1WkhAWy887FklMrDRGyedfgY=;
 b=nIiTNygmsYXkl9sSaCJbL6cifYyqpjdZ8wntO5DTf6qmw6ryKRVmuzegQAxcWn73NBRe7t9jrQX3jnzvC3F9Krj6U584sXu1+TaGpSGS5MvOnEkqGAMW2ifwmUELysKvs4ybFMxftObVYJDHYSNvDvMolSDfVg+VVbyVF42pe66/7BIcS02cK4OXm/0zuygtFKYxEfIDkHttzi8CLBMXJ2XwvmSuICYYhOWyziEet0QlJwRXU54UfsePqn6INQLeC+ecqwGXoU9QQq1H2IdaX9+hFW7F2xywUKSO683KAwU7X1sm5GYuRk/dJvGbBC2gALLPVVItNlFcft3NXWfZHw==
Received: from MW4PR04CA0252.namprd04.prod.outlook.com (2603:10b6:303:88::17)
 by MN2PR12MB4175.namprd12.prod.outlook.com (2603:10b6:208:1d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Thu, 14 Jul
 2022 08:14:25 +0000
Received: from CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::67) by MW4PR04CA0252.outlook.office365.com
 (2603:10b6:303:88::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26 via Frontend
 Transport; Thu, 14 Jul 2022 08:14:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT013.mail.protection.outlook.com (10.13.174.227) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Thu, 14 Jul 2022 08:14:24 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 14 Jul 2022 08:14:23 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 14 Jul 2022 01:14:21 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 14 Jul 2022 01:14:18 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V2 vfio 03/11] vfio: Introduce DMA logging uAPIs
Date:   Thu, 14 Jul 2022 11:12:43 +0300
Message-ID: <20220714081251.240584-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220714081251.240584-1-yishaih@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33234f92-14c2-43f6-d3d0-08da6570dd02
X-MS-TrafficTypeDiagnostic: MN2PR12MB4175:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tgV6FwwtHVRXX4E02OeVMKYr1y5B8yKa2tsQdbZJWDY5EWY0QSzuk78PqqTYXK00ecvl7NER8R852dqsHuPdLMvgjVXlpE5H6Fuu58YggZlUclFMDe4DQGyoERgc+rWwCIIqmF2cRjbaL4hITD9U4VRhnFkzZf55BWxLiXcLnTBct0Sj8AaRFih67XNaBaguwxmoClu/T1sUcamqplKv2aXUmTGqh+dFhEGsjiJ4foN5Ae9yXKWH2SXGQO0RlG00YD707s1IqfRO5hbPE71j9PoJ4vdNa0YqRLJ9LjkPOejnzX91HvWluvbcRtbyYhLMXh/+BdpcfTJq7XAW285QurqdRrZ2QnQD2LFwuhI6ZptmcxpEE1zceYoGs1Wa/QHeRtmudbSS0JKZ7TY2gzbZF0lZix4q/5pGm9VohwLJE4Lt4upTvJ5cmuJGkH+7T/dvViGa9+5bDcB6Fr1cKozWCZfe43kxNXG3bk64KZ4mnIKblp6MDOfkL57RojwgyvKvRwrHz+CP3xZfKNy8iB345U92n5ra5wvIfzxflj/f6+tz0iyqvaur5dctDvOQqKbzs/D0QyFNhcr2XmQVll1b3mKewxy9W5w0UdzOf9qNKEqQDf9mhbGGL112QoJ46vZK1CLTiPplPkYVllm4g60NG1eR13abM11m7UfmP9DUCHwxNXb0UIIt6j7ItdYw3mX9C7p2rnsRdkW8ukvEVIumsUDiwzkS5z+WsVNMD2bFJ8t87d/Gt5qzUM9p+NHuhmd1+UWoHzSfH8w4I/D5FXfcXrj1vBsckKZXqz9Un8zNcuY88yr0wA92tW06f/HE+m0jOwvnIM9cf++zef5tL+pwtpSi/95eUMQQ5RwrWBLtqgw=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(396003)(346002)(39860400002)(46966006)(40470700004)(36840700001)(356005)(86362001)(40480700001)(82740400003)(5660300002)(81166007)(8676002)(70206006)(47076005)(4326008)(426003)(336012)(70586007)(7696005)(478600001)(41300700001)(83380400001)(6666004)(8936002)(2906002)(186003)(110136005)(54906003)(36756003)(316002)(6636002)(2616005)(1076003)(26005)(36860700001)(40460700003)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 08:14:24.3945
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33234f92-14c2-43f6-d3d0-08da6570dd02
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4175
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

