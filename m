Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F334C37CD
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbiBXV3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:29:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbiBXV3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:29:48 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2051.outbound.protection.outlook.com [40.107.95.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B6D1A8054;
        Thu, 24 Feb 2022 13:29:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BebUuaRHxd4EeADd6QI8HIpxEDA5NMbpw/HVgE5QbOR1pfI1Mwl5oSDnYfl7TICDo9s22NYKuwpCwFe9mUqmj82V7pljhnPOa+XhkFfqno956ZPn4c24t73hObAbd5FPNIXdP0WQNyBcjsy8f35/3ZnhjuNDHZxKWhk8R+YnXHUwANCMD3WZFWHpdVqiJvD+CuBopddA0yXaGtOo4sB8hjTnYxgZpwb0A1ukmarAVBVqZ5xvLUSlDNvgGey+y+b96yQKK4opZCJy/Jf5JPpckOiIZ/kX2zBcwAzANohcLS+Cg+uRZTvFzEeL+/ZxbV3MEud5pPwHVZykaUwGLleyrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZG5lz7A209qwT9pKY34E8+DEFd4STbJrexWdlQRfO/8=;
 b=NCreAmai5suiT6mEsy2/u0laF+ogCF2h4SDooY12uEJgE+zIXuAJqexcSaOat+MG0Xo/STBow1pUop2Yv4+gdeALuOfkrIHD4kZB+pjEFZrfT6vlvQDn7g+Z9kqiEf8W6yeRXWJ11Ko+R9SWsgW81jcE9Kpe8nqLSt6qWtTh+60dB/xH6xXxUNBWL9B7ons1w7hJmSS8uSk48/nZdQgpNaVQveZ0JzaFyoI1HvKZC57Fo6LrN/snB4xVIboPIUqg4sZKPRNeB0zrKS1gnu0vENVIaKh2CAy1Y1GFmbya/9wFoOK5CIj0MR4FZujdCrFgLF94voFgHrlvxoQZg6oq3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZG5lz7A209qwT9pKY34E8+DEFd4STbJrexWdlQRfO/8=;
 b=fcLKEgy9tBsF4aZt/d9YqrxDc+6l7C8DGMsQBnnJ4VO0ZHUYRv8GQHBc42RpibNsx0zvDisFHJv60qGqctuawUj1oGKfkyzo/BmxGsQhIfPVB7/yIm+Q8c2gwYuq+A+3h0kYx5AV6+bi/M6hcqYp4NwLnyg0kWtXri1kxos9XLo=
Received: from DS7PR05CA0038.namprd05.prod.outlook.com (2603:10b6:8:2f::23) by
 BN7PR02MB4146.namprd02.prod.outlook.com (2603:10b6:406:f2::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.21; Thu, 24 Feb 2022 21:29:01 +0000
Received: from DM3NAM02FT050.eop-nam02.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::9c) by DS7PR05CA0038.outlook.office365.com
 (2603:10b6:8:2f::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.9 via Frontend
 Transport; Thu, 24 Feb 2022 21:29:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT050.mail.protection.outlook.com (10.13.5.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 21:29:01 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 24 Feb 2022 13:28:45 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 24 Feb 2022 13:28:45 -0800
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
        id 1nNLfJ-00095B-C9; Thu, 24 Feb 2022 13:28:45 -0800
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
Subject: [RFC PATCH v2 17/19] vdpa_sim: factor out buffer completion logic
Date:   Fri, 25 Feb 2022 02:52:57 +0530
Message-ID: <20220224212314.1326-18-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220224212314.1326-1-gdawar@xilinx.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20220224212314.1326-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 504567af-61d0-457c-b15a-08d9f7dcacb7
X-MS-TrafficTypeDiagnostic: BN7PR02MB4146:EE_
X-Microsoft-Antispam-PRVS: <BN7PR02MB4146177B68D2C0537EE40BE9B13D9@BN7PR02MB4146.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hkRym34rLuRB1TSNNLoBw/CoHyfYEPnBekGcrMDgEiANxsa7cPGeHQh73hhqSZ6NRIVBMupdlKmRBNra5QsYn4lWfva2jiOqDf+nFHP75FQCwppCCCgUcEbLI9e09Un7gS8umCq2ph8MOHhMWG6vI5dj7wtUS9pcxcIkqgiWOTyG7a8VehvGe/b8ldzTerjmDab2G3AkkfVegjvI/dp5NUUUydx1W6vlXQbRtCzf2c0L+M6hAIAyNOqkuKFz+Rsz1U3tlOOw92R376vblgYGr4xS7VxeNmzfByIXkCZH2+fD2Dv3IC3xv5ZrOTd8gX2PsefGTpOmOUoNzAiw3/E06UiXzSK7GgABWMdDQ/uaACdPNP5pkroVQaf8QnhUT9FlRZSqDdfsGvkuU3wYe/NMdEXXOOOeDgJdP1xtv+Q64oBtJQ8DfRq5RFIAs//MRNJt0NB3911I/b0A1Z35tdIxhYBMV5F530hVYi9qpru0EiTQB+aDzb4BkmNOiQ3cFP8X3QdBI8w+Bd6j8FKnezOlw1Z2E/fpsWjx+mVL9RvVqz4bua/q9n8z0svThWP0CsQDRfu7futy0HIv15jCEKkeUbjFx7+SLhfrT2psvYDJXMMf/5YEV/JE+uzVyTJHbwoQJN2X9que7VHyAmT6dylZpP1uSEcjkG2udlk87pXTu7okpxH46X0br1W7BcR+n5nyH42gWc5g2SPAriYGBwVwJw==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(7416002)(47076005)(4326008)(8676002)(82310400004)(8936002)(5660300002)(508600001)(7636003)(54906003)(356005)(1076003)(2616005)(9786002)(70586007)(36756003)(70206006)(7696005)(316002)(26005)(186003)(6666004)(83380400001)(2906002)(36860700001)(336012)(426003)(44832011)(109986005)(102446001)(266003);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 21:29:01.1283
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 504567af-61d0-457c-b15a-08d9f7dcacb7
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT050.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB4146
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wrap up common buffer completion logic in to vdpasim_net_complete

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 33 +++++++++++++++-------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
index ff22cc56f40b..05d552cb7f94 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
@@ -31,6 +31,22 @@
 
 #define VDPASIM_NET_VQ_NUM	2
 
+static void vdpasim_net_complete(struct vdpasim_virtqueue *vq, size_t len)
+{
+	/* Make sure data is wrote before advancing index */
+	smp_wmb();
+
+	vringh_complete_iotlb(&vq->vring, vq->head, len);
+
+	/* Make sure used is visible before rasing the interrupt. */
+	smp_wmb();
+
+	local_bh_disable();
+	if (vringh_need_notify_iotlb(&vq->vring) > 0)
+		vringh_notify(&vq->vring);
+	local_bh_enable();
+}
+
 static void vdpasim_net_work(struct work_struct *work)
 {
 	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
@@ -78,21 +94,8 @@ static void vdpasim_net_work(struct work_struct *work)
 			total_write += write;
 		}
 
-		/* Make sure data is wrote before advancing index */
-		smp_wmb();
-
-		vringh_complete_iotlb(&txq->vring, txq->head, 0);
-		vringh_complete_iotlb(&rxq->vring, rxq->head, total_write);
-
-		/* Make sure used is visible before rasing the interrupt. */
-		smp_wmb();
-
-		local_bh_disable();
-		if (vringh_need_notify_iotlb(&txq->vring) > 0)
-			vringh_notify(&txq->vring);
-		if (vringh_need_notify_iotlb(&rxq->vring) > 0)
-			vringh_notify(&rxq->vring);
-		local_bh_enable();
+		vdpasim_net_complete(txq, 0);
+		vdpasim_net_complete(rxq, total_write);
 
 		if (++pkts > 4) {
 			schedule_work(&vdpasim->work);
-- 
2.25.0

