Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552F15B8B04
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 16:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiINOum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 10:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiINOu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 10:50:28 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450D32FFE8
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 07:50:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FgQhfDqsiBBby4CEtBmpsrWNdM1XcVwsgRXnLpZMxdWpvAkXR72pMIjfBBpDZEbbQVZStRu3P1Fg49pLMH0j8WQN4Pqx2ISwy7zID8z9adRiGwgerYWlqIR7kX2wwSCrqijHggh/RXlGv+ANAzB9C2CXKaqcVCA+5eEnq6BknJvuCbZO9MCyv7mBnmvFWfsqanZtLn/Mebg2Zf7QQNlV4CvMXQyM9Nj1Z4qQ8igLNFlanz9m7Of4IdlzN9/P+fELQdDdgZTMT9IYjjGm7Rk5E9FyK8b8U8goaq3wzrmIG7+oMEOAASmleXFN9nB8Ze2ruqT670Y5VD3ZmvUjmRWs0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VLjAJ90B7wppwIdAtWQuAWcYaTTFHv2R8XuizSFYeAs=;
 b=aYrK0/Q9//MKn9H9a6yY5W4OFNEiCwBV3scDGdZ8poCjjoOy/ky8GWQ2a7FgIM6N/wdeAAc/ORd8QaEmD0BNFBWa5KYw0/rnouHtXcFYxkb6o7NLVV5MMWJdz+HgAxPyB6xYCoxubfxU5yIv23NXlzfuElplFK0K687A7wAo+f2MPfz4VfGv6fsqvgZPf27IDEaBczlF5O0hs2wuUdnWUtZphI8YZZ0aK0BNP1fooBDIyezo8qDKIP2L/ItDYoHRBTvwJ3SiZI5qNICaYSZKfNMhq3CNYZEiPsrL5QZDYmK03teyAKgwkhn74YW91xk+0PblVrMGSueo98pdV2ZnlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VLjAJ90B7wppwIdAtWQuAWcYaTTFHv2R8XuizSFYeAs=;
 b=U2H3zPsrisW/2aRSdhJ4eRgE3JMfV0PZMDSOFL1foEeUTCiRuTtidY2d7JnGV/qTvz+5ejSOkB2d4lfejSLjDdrQbRHyu4o0SEFL5BAkyZ9iKafv1WvXgTbn10hWoTmHgfWsgEwkrgN3VoTF8WGmPgLLqSWrXTuQx8zLH2HWorY6eaq6Uh1UDV0okVaNPZG8iVJb66E8QvtiUn5rJ6Nqs7MmLmTB1VDiRcGUyqob49XkLcOFN1idkoTauShY3VVnLW44N/tAGjXA09ZWnasnJKChT/CC+DXW5tA8NEn8dZs9Ji593medStETYQTAyYtu8r0ilJS9fXx0kMSLYD0U0Q==
Received: from BN9PR03CA0309.namprd03.prod.outlook.com (2603:10b6:408:112::14)
 by LV2PR12MB5989.namprd12.prod.outlook.com (2603:10b6:408:171::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 14:50:20 +0000
Received: from BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::45) by BN9PR03CA0309.outlook.office365.com
 (2603:10b6:408:112::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14 via Frontend
 Transport; Wed, 14 Sep 2022 14:50:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT062.mail.protection.outlook.com (10.13.177.34) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Wed, 14 Sep 2022 14:50:19 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 14 Sep
 2022 07:50:02 -0700
Received: from nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 14 Sep
 2022 07:49:57 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <mst@redhat.com>, <stephen@networkplumber.org>,
        <davem@davemloft.net>, <jesse.brandeburg@intel.com>,
        <kuba@kernel.org>, <sridhar.samudrala@intel.com>,
        <jasowang@redhat.com>, <loseweigh@gmail.com>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <virtio-dev@lists.oasis-open.org>
CC:     Gavi Teitz <gavi@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
Subject: [PATCH v6 2/2] virtio-net: use mtu size as buffer length for big packets
Date:   Wed, 14 Sep 2022 17:49:11 +0300
Message-ID: <20220914144911.56422-3-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220914144911.56422-1-gavinl@nvidia.com>
References: <20220914144911.56422-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT062:EE_|LV2PR12MB5989:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c1e4403-7a9c-4bcf-4c13-08da96607218
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MBubT/ObVMRcq3AaI3sfK02IQhAHImhHOs5fQWAfehk4CTMpBOjGZY/7TgTQwLRH313u2sN0BwISldFlvd3nSsVZe20pCN2JZjz2wjacfK59enwm+qr1aJKjQMPMGTJPpn9sD+Vf7nalJmWFTLDVVThrwSmBg+3L98jBxlPvg6ZyVcxux0Rmyw5F9hQj1iVBfwLGI77/TlO8IxnQMQK0cv5h8fmk5jcx4bPwiOK3tuUIK1hCQjdy5M6+2mlmGPUNEn41xco1mFsTTHzpCsVvzCTwT4ofwOsxjTayxotlTgllqb9meYXAYn4j86bnBrz1RKRjhRe9BNJsNEmpBYQDy/xZoq5thT5SfuVyh5hKNMpNdOmPGnI12MyuK5NBuMq1xk5lFpPmIvEniZ8lyx3zVBOWIPlqS40ZFSgTIgt3uVEPGx8g6U+2aSlB5KCixnsqyTlsfWu/sM/CCoZIwqJ9uJkF5kFhQcX1ud/KJSVLZsAE7MzIueFGHm3usxu/iQYE1JTLu/oBbon9hxwbGGcq6z4e5aKPJaJlxCsTybhX2rk2/yM+UHe8PnHIpZECGgxJpkdQOcOBO853m/+9gIHTjAiZe3td+ChGenL66mCiLQcdraTJ7BtkD4yDNWi3+3WjVd0u724pn0aeTuVmmMmbi0ECiZ5AoQfBLv1Y1pIxMk0EhpOWXxhMJxg+tBYvV9Yu4AlNt7PAPzKTouk+IcQgwPrd1BQd37ptgrrZRBJhY9Z+FA5ZsGNhRSmkwjTh5zAvmrSCQuHAB/G2mRgrY6pntVHqWBxHSLtHHQgj0ef2eiM=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(136003)(39860400002)(346002)(451199015)(46966006)(40470700004)(36840700001)(7636003)(40480700001)(70586007)(26005)(36860700001)(356005)(921005)(82310400005)(1076003)(6666004)(55016003)(47076005)(41300700001)(40460700003)(5660300002)(426003)(2906002)(70206006)(36756003)(336012)(316002)(82740400003)(110136005)(7416002)(8676002)(478600001)(6286002)(83380400001)(8936002)(54906003)(86362001)(4326008)(16526019)(7696005)(2616005)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 14:50:19.9380
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c1e4403-7a9c-4bcf-4c13-08da96607218
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5989
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently add_recvbuf_big() allocates MAX_SKB_FRAGS segments for big
packets even when GUEST_* offloads are not present on the device.
However, if guest GSO is not supported, it would be sufficient to
allocate segments to cover just up the MTU size and no further.
Allocating the maximum amount of segments results in a large waste of
buffer space in the queue, which limits the number of packets that can
be buffered and can result in reduced performance.

Therefore, if guest GSO is not supported, use the MTU to calculate the
optimal amount of segments required.

Below is the iperf TCP test results over a Mellanox NIC, using vDPA for
1 VQ, queue size 1024, before and after the change, with the iperf
server running over the virtio-net interface.

MTU(Bytes)/Bandwidth (Gbit/s)
             Before   After
  1500        22.5     22.4
  9000        12.8     25.9

And result of queue size 256.
MTU(Bytes)/Bandwidth (Gbit/s)
             Before   After
  9000        2.15     11.9

With this patch no degradation is observed with multiple below tests and
feature bit combinations. Results are summarized below for q depth of
1024. Interface MTU is 1500 if MTU feature is disabled. MTU is set to 9000
in other tests.

Features/              Bandwidth (Gbit/s)
                         Before   After
mtu off                   20.1     20.2
mtu/indirect on           17.4     17.3
mtu/indirect/packed on    17.2     17.2

Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Gavi Teitz <gavi@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
---
changelog:
v5->v6
- Addressed comments from Jason and Michael S. Tsirkin
- Remove wrong commit log description
- Rename virtnet_set_big_packets_fields with virtnet_set_big_packets
- Add more test results for different feature combinations
v4->v5
- Addressed comments from Michael S. Tsirkin
- Improve commit message
v3->v4
- Addressed comments from Si-Wei
- Rename big_packets_sg_num with big_packets_num_skbfrags
v2->v3
- Addressed comments from Si-Wei
- Simplify the condition check to enable the optimization
v1->v2
- Addressed comments from Jason, Michael, Si-Wei.
- Remove the flag of guest GSO support, set sg_num for big packets and
  use it directly
- Recalculate sg_num for big packets in virtnet_set_guest_offloads
- Replace the round up algorithm with DIV_ROUND_UP
---
 drivers/net/virtio_net.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index f54c7182758f..7106932c6f88 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -225,6 +225,9 @@ struct virtnet_info {
 	/* I like... big packets and I cannot lie! */
 	bool big_packets;
 
+	/* number of sg entries allocated for big packets */
+	unsigned int big_packets_num_skbfrags;
+
 	/* Host will merge rx buffers for big packets (shake it! shake it!) */
 	bool mergeable_rx_bufs;
 
@@ -1331,10 +1334,10 @@ static int add_recvbuf_big(struct virtnet_info *vi, struct receive_queue *rq,
 	char *p;
 	int i, err, offset;
 
-	sg_init_table(rq->sg, MAX_SKB_FRAGS + 2);
+	sg_init_table(rq->sg, vi->big_packets_num_skbfrags + 2);
 
-	/* page in rq->sg[MAX_SKB_FRAGS + 1] is list tail */
-	for (i = MAX_SKB_FRAGS + 1; i > 1; --i) {
+	/* page in rq->sg[vi->big_packets_num_skbfrags + 1] is list tail */
+	for (i = vi->big_packets_num_skbfrags + 1; i > 1; --i) {
 		first = get_a_page(rq, gfp);
 		if (!first) {
 			if (list)
@@ -1365,7 +1368,7 @@ static int add_recvbuf_big(struct virtnet_info *vi, struct receive_queue *rq,
 
 	/* chain first in list head */
 	first->private = (unsigned long)list;
-	err = virtqueue_add_inbuf(rq->vq, rq->sg, MAX_SKB_FRAGS + 2,
+	err = virtqueue_add_inbuf(rq->vq, rq->sg, vi->big_packets_num_skbfrags + 2,
 				  first, gfp);
 	if (err < 0)
 		give_pages(rq, first);
@@ -3690,13 +3693,27 @@ static bool virtnet_check_guest_gso(const struct virtnet_info *vi)
 		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO);
 }
 
+static void virtnet_set_big_packets(struct virtnet_info *vi, const int mtu)
+{
+	bool guest_gso = virtnet_check_guest_gso(vi);
+
+	/* If device can receive ANY guest GSO packets, regardless of mtu,
+	 * allocate packets of maximum size, otherwise limit it to only
+	 * mtu size worth only.
+	 */
+	if (mtu > ETH_DATA_LEN || guest_gso) {
+		vi->big_packets = true;
+		vi->big_packets_num_skbfrags = guest_gso ? MAX_SKB_FRAGS : DIV_ROUND_UP(mtu, PAGE_SIZE);
+	}
+}
+
 static int virtnet_probe(struct virtio_device *vdev)
 {
 	int i, err = -ENOMEM;
 	struct net_device *dev;
 	struct virtnet_info *vi;
 	u16 max_queue_pairs;
-	int mtu;
+	int mtu = 0;
 
 	/* Find if host supports multiqueue/rss virtio_net device */
 	max_queue_pairs = 1;
@@ -3784,10 +3801,6 @@ static int virtnet_probe(struct virtio_device *vdev)
 	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
 	spin_lock_init(&vi->refill_lock);
 
-	/* If we can receive ANY GSO packets, we must allocate large ones. */
-	if (virtnet_check_guest_gso(vi))
-		vi->big_packets = true;
-
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
 		vi->mergeable_rx_bufs = true;
 
@@ -3853,12 +3866,10 @@ static int virtnet_probe(struct virtio_device *vdev)
 
 		dev->mtu = mtu;
 		dev->max_mtu = mtu;
-
-		/* TODO: size buffers correctly in this case. */
-		if (dev->mtu > ETH_DATA_LEN)
-			vi->big_packets = true;
 	}
 
+	virtnet_set_big_packets(vi, mtu);
+
 	if (vi->any_header_sg)
 		dev->needed_headroom = vi->hdr_len;
 
-- 
2.31.1

