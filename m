Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09B934C3791
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234701AbiBXVYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234704AbiBXVYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:24:34 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F31428D39C;
        Thu, 24 Feb 2022 13:24:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=asjasaJnOD4hoBGXX4hDepP1e/8fY4LcREcSCDCiT4wwnaj8YbBLw4v3A2ymB8a0z//b1jehsUbbclWyaKUzQrkH7Pjq2Saxs/cKMGOxokekDLKLnbqUdGY5k93h1NK+jOUzxftSHRdww7B2XANOR9boWI3f7Lj+rrMeBYwjcbGOtzLq5mP34V8YddF8peomwOplrFH3EU9HjfMzBHTTD4su577lpN+QmZY7HqsQZT2UJImm9s+wxInjf/Kup2JQHc2s1sVUx0WdP4jLS0Gbo8pwwCAU9wVFv1huFGPqBGSrXgN+lOOVHmJ+hZX/6JPffj9eppFc7ohN6qvdgxKViA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fayfmbkixtZKWYN9V7C0LB9cq4o4jjIrmGTXP0klWjM=;
 b=hYe1Yskgmh+iccbNtUiPKpTpywgNZVMaD+N1OlX5Jon8Ck1WqDAX8vlV7MuRlXHvhTdqa6vft9h6/K+24/sLB0RDo7b1NBjl79ZRYuLVlHPOhmajGWyEv8vyARnsTZLbwOOXYVhp+7KII3VeRfwRzvnNUfK3dknvYodcIvSLedbYcYYQaGf1lW1O1G9xApzMwi6L5yqzh4aEaj1a/rtrrtofewB5obTYwg+aco6LGfumFVVaGhaPCjdgWVQTNXVrv1fr5AWNl7ILkV8DXezGrDd9188SeWo999TXzK+yqQOW7zGF+t0jB9MdA2qcmqFpILJUbLaR2amB4LTAhIG/Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fayfmbkixtZKWYN9V7C0LB9cq4o4jjIrmGTXP0klWjM=;
 b=QV3Obu1hDmmIY6yxReVhggH4bd3grzpryDvwupHLDd5foNIHzyKJaar6JS2In/tnnu6AyLdR4yB4UXL37uZ0UN9vBgMEQGGAmDqnqYplNr2ofUbV9udTQ6Voc1yhZPhikbPQbIAHCqaGoli9cuIhRWOcpr70lfNDsaVFYrUNq3s=
Received: from DM5PR19CA0008.namprd19.prod.outlook.com (2603:10b6:3:151::18)
 by CH2PR02MB6325.namprd02.prod.outlook.com (2603:10b6:610:1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Thu, 24 Feb
 2022 21:23:59 +0000
Received: from DM3NAM02FT017.eop-nam02.prod.protection.outlook.com
 (2603:10b6:3:151:cafe::98) by DM5PR19CA0008.outlook.office365.com
 (2603:10b6:3:151::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19 via Frontend
 Transport; Thu, 24 Feb 2022 21:23:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT017.mail.protection.outlook.com (10.13.5.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 21:23:59 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 24 Feb 2022 13:23:58 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 24 Feb 2022 13:23:58 -0800
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
        id 1nNLag-00095B-1T; Thu, 24 Feb 2022 13:23:58 -0800
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
Subject: [RFC PATCH v2 02/19] virtio-vdpa: don't set callback if virtio doesn't need it
Date:   Fri, 25 Feb 2022 02:52:42 +0530
Message-ID: <20220224212314.1326-3-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220224212314.1326-1-gdawar@xilinx.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20220224212314.1326-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5bd0fbb9-d48f-44df-2373-08d9f7dbf8c1
X-MS-TrafficTypeDiagnostic: CH2PR02MB6325:EE_
X-Microsoft-Antispam-PRVS: <CH2PR02MB6325DC0F2D7EAFB8EF03DCF6B13D9@CH2PR02MB6325.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H3udrbFCGmIMv9ULcvARZdT/taccJu3kV8Wz+sUfpindovajGLlZQRcpaFymCNpB0ODSWHIgrrhmU5FLoYaiCh9wMM6wxz8Ggqlc5xA9hT8GzvJ/Q/RCsNE1frHTt0asGj8MnFxLEfYnnMdf3jYhITbQBBPfOeYF5XwhAUt10wy6i/M54WZr2O+nLqTTOTEKvpal46r6VgfJoA7chqiVrYPLHQFpuPChjGItf1b4dKaQgy3CSu0tl6YKXOnCXPXY0q865Mpr0n6ihhJKVBRHdJzVt4stx2OQRwv/vMJ63siCGol1xMj1x8L69S1Mu+JK7G02OBJhZknUV0T6UzyTCfvoDRW7Lj1xYTMhMSV+DJUUBYFvRJGVPHAcavxsLGMxGaIBvuJrXoD2nzk6pKBu3JoaRrG2fbLjUsgC/VQNgRT2LmxU/BNCdl2czWibY0UVmI9cAYM7emBIcONMgVQL/h7e9lM5kr3467hE2S/DY+JOxBFa+Z/LvZGEQ2EILrWZy79LLmcftih7+igz7omMbW/pM8QNUPm689mtaJXeMTcmGXEDDdbD3vXJw83X5roL31Pz8FUj+woLW+hUb+py+B/X53nMupx6lpu7el4zmEP8HEgGffSBNNG4ZGDX6c9BPip9nMh+OE8pHcQVmv1F78UcfRxv63D685Mt1U2b94BP3FeS7KcTkaEU+tKodw2LZoIwgW6Pn61epjxJKhObW1mDAXYGO6tClB2b/fZdFOw=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(82310400004)(47076005)(7416002)(8936002)(83380400001)(508600001)(2906002)(6666004)(5660300002)(1076003)(9786002)(8676002)(316002)(36860700001)(4326008)(356005)(54906003)(109986005)(2616005)(7636003)(7696005)(44832011)(70586007)(26005)(70206006)(426003)(40460700003)(36756003)(336012)(4744005)(186003)(102446001)(266003);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 21:23:59.2004
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bd0fbb9-d48f-44df-2373-08d9f7dbf8c1
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT017.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6325
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no need for setting callbacks for the driver that doesn't care
about that.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/virtio/virtio_vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index 7767a7f0119b..bc74ba5fa717 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -184,7 +184,7 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
 	}
 
 	/* Setup virtqueue callback */
-	cb.callback = virtio_vdpa_virtqueue_cb;
+	cb.callback = callback ? virtio_vdpa_virtqueue_cb : NULL;
 	cb.private = info;
 	ops->set_vq_cb(vdpa, index, &cb);
 	ops->set_vq_num(vdpa, index, virtqueue_get_vring_size(vq));
-- 
2.25.0

