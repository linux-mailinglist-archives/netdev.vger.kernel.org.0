Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C5F4C37E8
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234710AbiBXVfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:35:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234641AbiBXVfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:35:45 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426DC1E694B;
        Thu, 24 Feb 2022 13:35:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e0GMNZ5KzYHuorsSfglvkySGLEu9XNzezK3pmG+qYLA9+I+VI4KMwdbG0Fe9jwjyFIuvqLpyRBR0Na8sEWu7Nx80Yj8CJiSGTTYVpVWX8ShvXv4f6Mlm+EAMk0rDf1ynRapOEeZ5UevRw9uGFtdNvOg8VQcSeH+sTw1I+oH5MkC9V08HLHHYzU7Lm8DlrP5sVCB8j8VqPuDg8IBI+cspNoE1AF3CeHHux8TuvXlu5YHnNwGCvkPQj5uRpTZHYDxBD2uj/C/e1y69X8OX/ENwFjoimX7BEhMwsSuwlF3e2YzNqyi5ITXmfex8dXLeOUrDygyxT7EeAmHHbEKyqLHzTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MrP/sb71w7FsTtptDQPu5syiA7OiYWzzUM1QutLuIdk=;
 b=EpzryNZMsOV1NpiqkRJ95pD5u3FWlaqbCxOknVOEJo/ac1GtWrq+TtxU2da10uW+qk+DKjfcczj5ORQpkGClPLT74w9/i+bUGFlGKjnpjv8RI6MDbxs691ztGIvDQFHhxF4ilYYuBSvubMKmU/LUQ/jp3mFfLktYnJhY6Gvvwk52IWqLywqzSoSjIQ97no6jbvJgcVKo8KsSm2Ql38aNh6/dvikgh/c7j8I+wrb5Kv3xuNAROQjWVFJAW1AAQ+8aFPuM3gFDbeAgznEy43Xq4JViDJYyoSHwYmkHM3hwBBBXS7U/wPHmHBFAlRvYM643UK4ieCNe9hMWCuUG5Tc/Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MrP/sb71w7FsTtptDQPu5syiA7OiYWzzUM1QutLuIdk=;
 b=MSBc782cSj6x4w4ju5QsmO0Lqb9l6YEgCXDoBqv95RYJpHA/mcoYXHKYGoY+mQ9xm5jEE9C6PPOaDt3KQMUalCRnXy899wc7VeCFQx1rmKcR/a1LTlJr8eQKGP8u7c0JsLuketv1MidJ+1W/pdm18yKy/hzh/UF2KIYMouUHy5g=
Received: from SN6PR16CA0067.namprd16.prod.outlook.com (2603:10b6:805:ca::44)
 by BN7PR02MB5140.namprd02.prod.outlook.com (2603:10b6:408:2a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Thu, 24 Feb
 2022 21:35:11 +0000
Received: from SN1NAM02FT0003.eop-nam02.prod.protection.outlook.com
 (2603:10b6:805:ca:cafe::c0) by SN6PR16CA0067.outlook.office365.com
 (2603:10b6:805:ca::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24 via Frontend
 Transport; Thu, 24 Feb 2022 21:35:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0003.mail.protection.outlook.com (10.97.4.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 21:35:11 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 24 Feb 2022 13:35:07 -0800
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 24 Feb 2022 13:35:07 -0800
Envelope-to: eperezma@redhat.com,
 jasowang@redhat.com,
 mst@redhat.com,
 kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Received: from [10.170.66.102] (port=59626 helo=xndengvm004102.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <gautam.dawar@xilinx.com>)
        id 1nNLl7-000Ct8-J4; Thu, 24 Feb 2022 13:34:46 -0800
From:   Gautam Dawar <gautam.dawar@xilinx.com>
CC:     <gdawar@xilinx.com>, <martinh@xilinx.com>, <hanand@xilinx.com>,
        <tanujk@xilinx.com>, <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v2 01/19] vhost: move the backend feature bits to vhost_types.h
Date:   Fri, 25 Feb 2022 03:04:35 +0530
Message-ID: <20220224213438.2705-1-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 802aee4f-3191-4f02-4afc-08d9f7dd893a
X-MS-TrafficTypeDiagnostic: BN7PR02MB5140:EE_
X-Microsoft-Antispam-PRVS: <BN7PR02MB51400CA019E012254A453C64B13D9@BN7PR02MB5140.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bgYqnoqK0wnNt+GRGOid9FSlY/lSuktGZ99Ig6Au30AZam4Evrx4IIDjoECjz1rHJzeD72mwNH1zDeaSLD4wcM8Tvnt+0JuBIvMX1T+n1eqd9V3ldQRIHlnbsZS2R13JfmT7ozVIdC0zMFNKxcjAqlDjjhTih9l3j8YpTgpCGGQl02aAs1N3KNVpWjTE+fx1aHNlZnlw6lt2XK6izqYreW1jHyCHks1qfQUEagZIuSYGZQcabf87YS214OKPTgaIl6hXbgnprs96wS97yY1p55uciYYwKIfFyEZwMhBblqoSY6TM3slwuLvx+FIk53tEv278kQglyTGvEW74Mxxg4QsAn9rgEcfhJDj7ODPkBpfJDmlqgF4Pwt/gsJkb82bKltQYoeXaaikW3b5AWp0iwiRtEgkT47Dl+amirX/82NKD6aaPXxwbD+76zqDOqxD9OFaIIQv/oqzgiX/bRDvzZcfSEIl18ucQb2cYXgapxF6T6sSdclWeWqW/tJyZuTJZm3G7xOjiFN+hfnLB8eBWx9sfSErYhs8Nv/NdCFeJhC27+ecSb2zHP+pA3Pc8dsCpbiGWjoxf8SHV7hnOzKK6722ItkpixsEa8U1Qy8RRCXLt1Oel1zx3ALOVYuXDrybWpAsglI7Xtk7+Ok2/H59V3HdNos/OYz+AGFsXw/Z84Jme00TnooNIh67URdqTD6WEPnW6wV6/3AKICmeTe3sHLA==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(2616005)(83380400001)(426003)(36860700001)(508600001)(44832011)(336012)(1076003)(47076005)(186003)(6666004)(109986005)(26005)(7696005)(316002)(8676002)(70206006)(70586007)(4326008)(54906003)(82310400004)(8936002)(36756003)(9786002)(5660300002)(356005)(7636003)(2906002)(102446001)(266003);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 21:35:11.0986
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 802aee4f-3191-4f02-4afc-08d9f7dd893a
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0003.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB5140
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

