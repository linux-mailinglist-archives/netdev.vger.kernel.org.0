Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD8344C37CE
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234565AbiBXV3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234920AbiBXV1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:27:45 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F87D42A32;
        Thu, 24 Feb 2022 13:27:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DynVAkMo0ZzcfwZSLeNuyMd0uetY5RDtVwNc8E4uCMDPiFD+PFd9p/DATum0MEw3Hm7XEyt9L3zWeT+MiW/oBeDfWoGEa8UV0A6CRGSHLIIMDzK7Lbppzy3pTQeDdATuR7BJHlA1CrzwjWvN0upK8Pjk0Lm2Z6UZzk8zy8FzBxMMu/bSX0In9VilAUpP2J5iygAG+05kD1F/ooBuiPCEpzUrbAa0RZigumjm0GGWJxF+aB1PNwbRoTpAOZc3MM4KQpVw6qXhiFR1W8Rkq7FP/XB0fK0YnMGJoqLl+htcagfSjbOas255ZwXhxxwa69Dg/xQ44YllGl5PWfExe19HXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gl32lLRv/mq2hUkWPlS0apg8KdiMyMf28wYtzAvqtB0=;
 b=HqVEwYtt5qymSuSjIrGR6ZneRvD95nSxdAPTXrCIGrk8CabdXqLeCIOTA453Vlw7A0JjLhXmGrqMMFwGbCGT/kP0PvBWZ6gjBgLN5JVne+IQtmBEMkAgnhe98gAvbbCRBvw44UslvAEgVeRnmHRwo6IQEJdBpUYRzt0IJ2scnfKen8OH75EwCwdk5azJsRAHdpANNnzJOFWULSG0YQGhg953DNfsMaXZtsrpCp9OHIqS0DhxLbKeaWQT9tn26Pq5Ko20rpSHaoT3+Vx/KLFOfPmCD4a7cCLejmFr7v+euyEWSH4fBbjmfvYyeO64qWL73IbrXtUZpjRSyHsbJmr2nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gl32lLRv/mq2hUkWPlS0apg8KdiMyMf28wYtzAvqtB0=;
 b=V+8Y3x3hq3z/rUvi5p8siwE5vBqQbxWGSTLYIRej+n89ThAuI8KO9RBg6MLfk4YihX0IOE3gDKaw1I+GksxTUG1uANOywO4d7jYKHGBRYTiCcgrte4NihXEjp/bn0laQ2W3rLIx6Vrl/YXdq3z8janaZj3teGQ/TzlLW7sUFHcE=
Received: from DS7PR03CA0272.namprd03.prod.outlook.com (2603:10b6:5:3ad::7) by
 SN6PR02MB5615.namprd02.prod.outlook.com (2603:10b6:805:ea::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.22; Thu, 24 Feb 2022 21:27:11 +0000
Received: from DM3NAM02FT055.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::12) by DS7PR03CA0272.outlook.office365.com
 (2603:10b6:5:3ad::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24 via Frontend
 Transport; Thu, 24 Feb 2022 21:27:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT055.mail.protection.outlook.com (10.13.5.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 21:27:11 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 24 Feb 2022 13:27:10 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 24 Feb 2022 13:27:10 -0800
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
        id 1nNLdl-00095B-VN; Thu, 24 Feb 2022 13:27:10 -0800
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
Subject: [RFC PATCH v2 12/19] vhost-vdpa: introduce uAPI to get the number of address spaces
Date:   Fri, 25 Feb 2022 02:52:52 +0530
Message-ID: <20220224212314.1326-13-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220224212314.1326-1-gdawar@xilinx.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20220224212314.1326-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bfa6b4a-5ce4-4083-57bc-08d9f7dc6b35
X-MS-TrafficTypeDiagnostic: SN6PR02MB5615:EE_
X-Microsoft-Antispam-PRVS: <SN6PR02MB56152D4354ACB56CEAB97998B13D9@SN6PR02MB5615.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xsBoia07YRfPOTHFEU8aeEQVPHPVrvm4R1Bf7m5UKAoRNqVBrSnPvnLfsi+ekKVT6XSpaSwEaiuVVqkneYP+KmNMZ9PgHgmRQzFH/x/1KwFgIx7+pKXOW8M6ZgG0wKpq6fUmERjZLjHB3wgHQyQ5PXF/j34zg8SDc63Yy9A9u2nxZyOIz5MeP4Avkl+LxiREEov+NdGal/WoqCnBC5z9ALzmzZLv1ycUYPmuDx9INsblrIHewI6+/vAoNWnmMDUMpmhW7E7PMh+WxDRPjXOb5RqUaBqOzIFcE5ZYxqmxLFA3rt2hYqmAY0Y4HKIIXXrnLDrKe3Qy7XB7Mhvgwr4tOKUwmDR0CWD/2tqNj4eLA3foZBLZOjMfUX/N6RRbez09E3seBObY9mltc2h1OvHHt/wjOPBbC4SPsZZ1xtCFmfilkIIIXf8RL//klPXW0Q8lurZ0uWiJUNrg2P5qN3icDijh9Aec1q7fa9K96aLuWVQ7DQ88SmF9FXmtTEQ2N/3BNI4TqPZRJn+gRnK3K7dnA30i8zEMGOnfF7uOUL9470B84pTbjfjpDfN8Y3p5uSUZbRg3Y34XHHXQ4k8/uQ0bU/+cbB+HWzzfSjXKyk0P+UiNgC9qgKCwVd010qU+tfXJA9gccofSDID06ibzlu+m5jghXPP2WhRWhhkV+SR8uC0puNcm6PyjT4jf1+wpM6cUDpsrwjfFfeY9U7zKpPDUQHsXVsxZaTtSQnq89LDGzZcFwvUaIMHa3FvENR0iGSOc
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(82310400004)(2616005)(47076005)(4326008)(1076003)(8676002)(109986005)(5660300002)(70586007)(36860700001)(70206006)(7416002)(356005)(7636003)(6666004)(83380400001)(8936002)(426003)(2906002)(26005)(44832011)(7696005)(316002)(9786002)(40460700003)(186003)(508600001)(36756003)(54906003)(336012)(102446001)(266003)(15583001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 21:27:11.2222
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bfa6b4a-5ce4-4083-57bc-08d9f7dc6b35
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT055.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB5615
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces the uAPI for getting the number of address
spaces supported by this vDPA device.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vhost/vdpa.c       | 3 +++
 include/uapi/linux/vhost.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 7a8a99cef8a4..733b305c5029 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -542,6 +542,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 		r = copy_to_user(argp, &v->vdpa->ngroups,
 				 sizeof(v->vdpa->ngroups));
 		break;
+	case VHOST_VDPA_GET_AS_NUM:
+		r = copy_to_user(argp, &v->vdpa->nas, sizeof(v->vdpa->nas));
+		break;
 	case VHOST_SET_LOG_BASE:
 	case VHOST_SET_LOG_FD:
 		r = -ENOIOCTLCMD;
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 8a4e6e426bbf..8762911a3cb8 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -148,4 +148,6 @@
 /* Get the number of virtqueue groups. */
 #define VHOST_VDPA_GET_GROUP_NUM	_IOR(VHOST_VIRTIO, 0x79, unsigned int)
 
+/* Get the number of address spaces. */
+#define VHOST_VDPA_GET_AS_NUM		_IOR(VHOST_VIRTIO, 0x7A, unsigned int)
 #endif
-- 
2.25.0

