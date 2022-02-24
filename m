Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBBB4C3789
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234687AbiBXVYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234661AbiBXVYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:24:13 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56AF8199E26;
        Thu, 24 Feb 2022 13:23:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GC6vtxZg7KaqPki4lbz+z4EPGv4DSH2CvjeiB3/Qax94wOxR6biAs50sEOi5x6RGc8bFhRvqdHf9Hc7PIgnOaKQtbHeqmf0DRxALxQV0mOBhSj/9ht4clzRU/wTwb1OohQswxGOPR5p9JMk1dQC00AVGt8EeRj9aBWpSeoE3gFtovAqxirZ7hQMamkqZ8TbihtWGvjrN3LEk2ubp+rxjQ3F9wezug2QLuv8RkAbPVT6BStqsKmrjUCu0T5q5GGq5SizuutDi7Fn+DkGLDabaiCU6H6Nnd8qEGu0qQ1oP4vXD4p3gg7AYfNdX6LnXVcb38MmgFbGgXNUO2PV2xHK7oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MrP/sb71w7FsTtptDQPu5syiA7OiYWzzUM1QutLuIdk=;
 b=exTPRjj4szVw55fBSSTMUyXVt8GLYL6gmlHFNPUAxcuQf5J89hQI7Cn6Bgvb1r0m/b0F0L2+lnfBT2FISDufhFzZNi2YU8MW/fY84/atBnHjjiDAWJIMYYCvXsD3h7UeF2CT5R2wdJt0tMuruzdgDc7qV9tmWI1L5kSxBGZmY4xvOii0k6ChG0F3q36c9jXt0O3/CEiQfHbv7zoi9QfTwfStcHLuhbIDFfir4w8V2x3XCScO5/dCqikcS+DW7vpL9uyFV8lG4Y53M89/WDfrpZmn4+wg3SRpumG+g/t0V9LhPnQavVvTqozFzflq8Vx2FqR5pqilGl+9SgkhHuF5UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MrP/sb71w7FsTtptDQPu5syiA7OiYWzzUM1QutLuIdk=;
 b=nCSx9kOuK5QzpxWV5Q0k/x3V4gOSVxczifAfrwz47Xmj5CMF+tMLU7tniKBtH66yOhU3Zbct+O7x47Ifj7KV8qz1i4AFC8l+05OHis4gyVc2L3WcSD6yW5ZL6gWbG5RfwKwzt1Elznf5renyemW8/2ow2wPkMdBa/zffld5mZeY=
Received: from DM5PR21CA0025.namprd21.prod.outlook.com (2603:10b6:3:ed::11) by
 BN8PR02MB5858.namprd02.prod.outlook.com (2603:10b6:408:bc::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.22; Thu, 24 Feb 2022 21:23:40 +0000
Received: from DM3NAM02FT023.eop-nam02.prod.protection.outlook.com
 (2603:10b6:3:ed:cafe::b6) by DM5PR21CA0025.outlook.office365.com
 (2603:10b6:3:ed::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.9 via Frontend
 Transport; Thu, 24 Feb 2022 21:23:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT023.mail.protection.outlook.com (10.13.5.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 21:23:40 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 24 Feb 2022 13:23:39 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 24 Feb 2022 13:23:39 -0800
Envelope-to: eperezma@redhat.com,
 jasowang@redhat.com,
 mst@redhat.com,
 lingshan.zhu@intel.com,
 sgarzare@redhat.com,
 xieyongji@bytedance.com,
 elic@nvidia.com,
 si-wei.liu@oracle.com,
 parav@nvidia.com,
 longpeng2@huawei.com,
 virtualization@lists.linux-foundation.org,
 linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [10.170.66.102] (port=59620 helo=xndengvm004102.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <gautam.dawar@xilinx.com>)
        id 1nNLaN-00095B-9q; Thu, 24 Feb 2022 13:23:39 -0800
From:   Gautam Dawar <gautam.dawar@xilinx.com>
CC:     <gdawar@xilinx.com>, <martinh@xilinx.com>, <hanand@xilinx.com>,
        <tanujk@xilinx.com>, <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Eli Cohen <elic@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [RFC PATCH v2 01/19] vhost: move the backend feature bits to vhost_types.h
Date:   Fri, 25 Feb 2022 02:52:41 +0530
Message-ID: <20220224212314.1326-2-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220224212314.1326-1-gdawar@xilinx.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20220224212314.1326-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58cbde5b-8e7a-4754-b5ea-08d9f7dbed8c
X-MS-TrafficTypeDiagnostic: BN8PR02MB5858:EE_
X-Microsoft-Antispam-PRVS: <BN8PR02MB58587722F6FE0D2C57E79CEAB13D9@BN8PR02MB5858.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yVWhzG+z/gxCel4nSSiuZs+eHnlPiSWv/IVjNy7Thq6IqDzglaA68VwenrhzHWYyfG6nWqfJQzZ2dKEtShr/k0BEr4uumKf0DODObEJuxzGw/DTpD90AjWUGx+IpY820SIsBMI/HyhzR613SeoietuAKTGfgsmG2ffmbbT556pboOqdLImlvvr7IlsoQRZkVlZGGskjP8EQTi72akWzh8JMXS8eoEV0G66jCUIYx1cE3uWw+/UbnM6fA45xS9LIDS1HY7BukexSntcDu+V6TEjKlIMnOxfrscSXWm3nXgUHQKg3AGM1+wcdkKOkAjn0mg6DHKrt2nnaEhOkEy3QXBBy4CW8BehD3YoaMhoL1Nh0lKuaiPjTafOzmxjMi6bv8VobsPdRQc1YU8SAb+P3tnnhDMgtL4XfIbjDOHKD0F4QZ6s0QGWoO4buEcn1bxp64wJtRpqpV4+73VbERFZjj4aIPCHxOUweBcZofIjG7JLc5KDKgDy0C2OFprDZE8bIRw5YlNSXXx3GRouCDV/g5Tnjg/SxSujFzluUxOT3DYeAmDgI0MQA/+H9tvgYg9RY3p5tg9BcGCe7vu0bOBhNM7KfIDHNF053LLazqAbxT+UpS7N8r9MD4+mPNIU25Xjczh1OPGVXseKA2Ckx5X8h4VvjzJXAOOYzpo/uDu6W8IKdz8eKKSHQmwdRwnfcBDSZD7hs4msLMGc30hUxk29dFwQ==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(36756003)(2616005)(26005)(186003)(82310400004)(70206006)(70586007)(356005)(7636003)(109986005)(1076003)(4326008)(8676002)(2906002)(336012)(426003)(54906003)(316002)(47076005)(83380400001)(9786002)(8936002)(7696005)(7416002)(36860700001)(44832011)(508600001)(6666004)(5660300002)(102446001)(266003);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 21:23:40.4018
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 58cbde5b-8e7a-4754-b5ea-08d9f7dbed8c
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT023.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR02MB5858
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should store feature bits in vhost_types.h as what has been done
for e.g VHOST_F_LOG_ALL.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 include/uapi/linux/vhost.h       | 5 -----
 include/uapi/linux/vhost_types.h | 5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index c998860d7bbc..59c6c0fbaba1 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -89,11 +89,6 @@
 
 /* Set or get vhost backend capability */
 
-/* Use message type V2 */
-#define VHOST_BACKEND_F_IOTLB_MSG_V2 0x1
-/* IOTLB can accept batching hints */
-#define VHOST_BACKEND_F_IOTLB_BATCH  0x2
-
 #define VHOST_SET_BACKEND_FEATURES _IOW(VHOST_VIRTIO, 0x25, __u64)
 #define VHOST_GET_BACKEND_FEATURES _IOR(VHOST_VIRTIO, 0x26, __u64)
 
diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
index f7f6a3a28977..76ee7016c501 100644
--- a/include/uapi/linux/vhost_types.h
+++ b/include/uapi/linux/vhost_types.h
@@ -153,4 +153,9 @@ struct vhost_vdpa_iova_range {
 /* vhost-net should add virtio_net_hdr for RX, and strip for TX packets. */
 #define VHOST_NET_F_VIRTIO_NET_HDR 27
 
+/* Use message type V2 */
+#define VHOST_BACKEND_F_IOTLB_MSG_V2 0x1
+/* IOTLB can accept batching hints */
+#define VHOST_BACKEND_F_IOTLB_BATCH  0x2
+
 #endif
-- 
2.25.0

