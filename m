Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117595A7E3D
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 15:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbiHaNGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 09:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbiHaNGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 09:06:14 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2044.outbound.protection.outlook.com [40.107.95.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D13BBA79
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 06:06:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oOVuDGNdiQrBzQjHGgcdDqdkDYVFPucK3xAIeDsH1GnjJxEVHz73jIb5smxmbcf7AniDmDtKki7LKX3mVO2TBkwphhk4jX4DboDEAYYq9PSXniHoTJrAZ/mUOyTjDe/Uyce+iUhC2QsJKnYEl1YcOE7Cj93nvzyNw/+246Dg4RcoYgX+qcjkTChhNrGdOnflCA0ReRg6eRStefYgr7vPmGxJEBaUL7CwW2QxH5GqjvAmEeUYETH03Mz5aEXgETEW76tbEkwWulUmm/f3/Wcuyw0dBUCGtIW/e+6ysocJlPW45fBjjkc7xQzTTFJjq8GjxuWX/LopUo1/CtPyJzGmBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gm9sNQNctz6Oj82UPjwhOF2q/NGHBfdD8uFc8SjsrGc=;
 b=jMROOmJkRMi/rifZPnwMV0MFUXcmvBrfpuJJs/h/bb2Y9g2nnFFhldX/W8v+Q2Yd/iZjSYWV34wJxDWYmm//cMwEHu6dQqVx4ZinPMK/sFPVVr2T61LmssZCNyBp10XjwWydS/dG4fp9ytzB52Nuwd83n20WDdaqVglpN0icDDwrcBZVkMe2qjZ645nkMw8t3p70AIqB6l0yMvMbVl0j3Fw3Jr2S373tc0r0llk57JWqXf46YtvXNN4kTRXQrmC+43eX1rhjxSqAh+ihNON7fAB9ofhm6NR0JQdyCfBdlHkrpPC+PfBu2aktXHk2u6F3WUUm5FwZNwAgvTkGPoo53A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gm9sNQNctz6Oj82UPjwhOF2q/NGHBfdD8uFc8SjsrGc=;
 b=KJtU1WEXxvE4SSXg3DKFaX0R156woa3hsls97AiNDfXxLL3hqvkHLXwhNt5Uk5SDGOiOYCHkfIiX5Z3glBErSzSwe9Y+VjTI2ON1Qwr8k3SzaakQaYLXOrl6dUJ7HrmjLKCFVeOSG/CWohYvOPPkxpZEKmKHoOvTE0DD+3cX6b8sp5oTckT9GDh3G6c4O3+AtCX5s/kdOLWG0SaAYMtpYyKG95ZGJs3g7+OzxJNW5ZKJKtRs3eS9G5iRQw48KhCnPlS6XeZiZYMsGD/rQLl2p2FTIv7sIod+DDzg8nVvgigIBhj6mbKFu5drpDDcGLk0pcpaLc9ohz+xwLIPm7tOoQ==
Received: from DM6PR08CA0008.namprd08.prod.outlook.com (2603:10b6:5:80::21) by
 SA1PR12MB6727.namprd12.prod.outlook.com (2603:10b6:806:256::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 31 Aug
 2022 13:06:10 +0000
Received: from DM6NAM11FT074.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:80:cafe::8e) by DM6PR08CA0008.outlook.office365.com
 (2603:10b6:5:80::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21 via Frontend
 Transport; Wed, 31 Aug 2022 13:06:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT074.mail.protection.outlook.com (10.13.173.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Wed, 31 Aug 2022 13:06:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 31 Aug
 2022 13:06:08 +0000
Received: from nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 31 Aug
 2022 06:06:04 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <stephen@networkplumber.org>, <davem@davemloft.net>,
        <jesse.brandeburg@intel.com>, <alexander.h.duyck@intel.com>,
        <kuba@kernel.org>, <sridhar.samudrala@intel.com>,
        <jasowang@redhat.com>, <loseweigh@gmail.com>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <virtio-dev@lists.oasis-open.org>, <mst@redhat.com>
CC:     <gavi@nvidia.com>, <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
Subject: [PATCH RESEND v4 2/2] virtio-net: use mtu size as buffer length for big packets
Date:   Wed, 31 Aug 2022 16:05:41 +0300
Message-ID: <20220831130541.81217-3-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220831130541.81217-1-gavinl@nvidia.com>
References: <20220831130541.81217-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53e9d7c8-e09f-4153-87b7-08da8b519293
X-MS-TrafficTypeDiagnostic: SA1PR12MB6727:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I+9xPPbknC0rJMW+RCEEn7OuDJBm6p1Me8dVFYMVRD6CU/4Ts1ePehH0tsWRKFazyrw3RttdpYLs/yLsIY0MD10AtJkg1DkWe/2PQVureh2kzrSaQZS7QQpPyVEze3eyt/xkQSh061vIys8QH5xbEr8EUI8ONeMSLcy7TJielBweXYCm+AHuT2Y2iUcj+BFK8yxQCgLpj0z8g1FbEYarMqxLuD7ck8OkbTfQ3tqhmPRuBfBmWCF10aP4pylUpJT8Ax5/B4dulW1nae1IwnvT/t5IAwLtS1SpBzLj9tHiJWo+vDpxg1TSpjINpKSxFG6vcDYDuJ4OSsIAsSJAynKynFP1lObOD9I/lKMzYkFCq0s7azVhFHqomGH+DAgY/4+qgnt5c0eYBI3+vD9y+RbBj3QQF4V4w7RhVvS6xMNJhAwZOvtIFMoXZ/zhg8l8C36X5WEMzLzN2hAHuZ/QOcPECFeAvXrEKbug5Ex6dU5rBCqtPN2taNX7W2/ROUxcSwEPsVyFhcsNeJv9FdWT4Rb+oTNeDm/c5V/7N1XGONK3It5kCuP0A5yfJcBH/QdQP1UUNENQ/LfizEATt98qcC4OxZ62UijcWkLNWPyRtdN0lBqNSH+d10K4zDqKaQ70Cq5088DOhyhbHF1eEV7uLMaCXs+RMmUzZoTOvnWfF4W8PsmwOI0xo1igpH0pbV+hl8+sFkrBbBFnGsez6nq803jUmYkWN/J0TLMAqHpJapA3yHA5XbjAsHrWg+gomoEZ+hbqUQB59LoJ+bOc6tsF7Z7ZGyoi152rqb253BCQoxwHCMYrR0wT4b+D0ZJcRDNTBI8K
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(396003)(39860400002)(36840700001)(40470700004)(46966006)(82310400005)(336012)(6666004)(2616005)(7696005)(6286002)(26005)(82740400003)(426003)(47076005)(2906002)(16526019)(55016003)(1076003)(186003)(40460700003)(36860700001)(40480700001)(83380400001)(4326008)(8676002)(316002)(110136005)(70206006)(70586007)(5660300002)(7416002)(356005)(81166007)(36756003)(921005)(54906003)(41300700001)(478600001)(8936002)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 13:06:09.3006
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53e9d7c8-e09f-4153-87b7-08da8b519293
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT074.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6727
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

When guest offload is enabled at runtime, RQ already has packets of bytes
less than 64K. So when packet of 64KB arrives, all the packets of such
size will be dropped. and RQ is now not usable.

So this means that during set_guest_offloads() phase, RQs have to be
destroyed and recreated, which requires almost driver reload.

If VIRTIO_NET_F_CTRL_GUEST_OFFLOADS has been negotiated, then it should
always treat them as GSO enabled.

Below is the iperf TCP test results over a Mellanox NIC, using vDPA for
1 VQ, queue size 1024, before and after the change, with the iperf
server running over the virtio-net interface.

MTU(Bytes)/Bandwidth (Gbit/s)
             Before   After
  1500        22.5     22.4
  9000        12.8     25.9

Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Gavi Teitz <gavi@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
---
changelog:
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
index e1904877d461..ba2852b41795 100644
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
 		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO));
 }
 
+static void virtnet_set_big_packets_fields(struct virtnet_info *vi, const int mtu)
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
 
+	virtnet_set_big_packets_fields(vi, mtu);
+
 	if (vi->any_header_sg)
 		dev->needed_headroom = vi->hdr_len;
 
-- 
2.31.1

