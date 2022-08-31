Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A985A79B4
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 11:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbiHaJD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 05:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbiHaJDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 05:03:42 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0B8C00C6
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 02:03:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ca7VR8cnFqbomvEQVuE5LZf4UP/oKmEzm9ljUMv9oKy3oeecFvHIbq468ITL+AmOShTiN1r0ksvtvOB0Ub9Q91rQUBoDwj7oJw1VTO1nXXokQDkLH8T0fbXxNjKmVLhU5YPX3l2DMo9x+iqe9tOh7V24/5Ds9yOJ/n1W0fquCKxEfXgw492Vc6X4vUqT2TDDjWvskGUeNTAMrEXmQajM+ydvivEExFHiOA+l0xFrMiCeINbLiiEXc5sGZy8MyUiVmJlgoiMZ/eKeMNiXw0lP2HwS7AgXNWQIqYfAlZGeHq41xZJeBlHt2GZgyUQTG2nsOZ5wnbqnuf6FLWHv926yVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F3zd5mL5JnViM5ht5xvo5Kl9XrKYNDCyPegdrlOt9u0=;
 b=nuBsBD/jnFjqOP95ZzuISatQqyVfO2joDXDm17vcUvSQqHx/pWUjzckNyI098cRZCTXKm4Ii+YBxItCzM3WOkYYOB/knI9pWXuYCtcJUqXede1dWxBuII6e0oYkn7WCzwSEvzMO/rsH5UCT0rMWSE3fu1gS3PT5fZvKjjV5EeeBW1hgZ5+A4Pn/gykBbvUPSU5oYUF+lFnjbipdD4RCWWsaw+xgvFMmHQy9jKbBc6Yx5W6rrswgN+iQbXdbLpnVYlL9n7ETI+lgKvaLrjr5r5mPNOwUAgVX1XYSsHddKBQXN3hmITHvckw93ZyCfUHd9wcLZGD4b1MsFBQXZyhfQmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3zd5mL5JnViM5ht5xvo5Kl9XrKYNDCyPegdrlOt9u0=;
 b=dCelTeYfgZHDQZ6kioSx90/OI4eh6uaHk4nBvByFNADJ/12dFmXZ8+CGo6A021nEmV5gfy9u4GmMZGX0R5zkko80ulPu6StW37KYqm/JkqDWcAcHgLFXryHkua8DvSfcw1K5aG0CPZSi4GK5NhlEbVVE6q1069/+nP0q9KsxVcMXAWSkjMt5ZxSB/0THtaUmMFzGopJTl2AzKmlmJrkwGJhIAOx+jZrMYQvTsqcKgDwhkC7Ksmc456/dwCD0nN+bmkod+PQAdcpVnbWFu5ypULeQbFyuzC/cOBk39V9YP9wOjjA6gogCrnQOR9wRM7NQkK3590fGs+nHJc6zC6DJKg==
Received: from MW4PR03CA0231.namprd03.prod.outlook.com (2603:10b6:303:b9::26)
 by SA0PR12MB4352.namprd12.prod.outlook.com (2603:10b6:806:9c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 09:03:39 +0000
Received: from CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::32) by MW4PR03CA0231.outlook.office365.com
 (2603:10b6:303:b9::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10 via Frontend
 Transport; Wed, 31 Aug 2022 09:03:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT061.mail.protection.outlook.com (10.13.175.200) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Wed, 31 Aug 2022 09:03:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 31 Aug
 2022 09:03:38 +0000
Received: from nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 31 Aug
 2022 02:03:34 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <stephen@networkplumber.org>, <davem@davemloft.net>,
        <jesse.brandeburg@intel.com>, <alexander.h.duyck@intel.com>,
        <kuba@kernel.org>, <sridhar.samudrala@intel.com>,
        <jasowang@redhat.com>, <loseweigh@gmail.com>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <virtio-dev@lists.oasis-open.org>, <mst@redhat.com>
CC:     <gavi@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH v4 2/2] virtio-net: use mtu size as buffer length for big packets
Date:   Wed, 31 Aug 2022 12:03:05 +0300
Message-ID: <20220831090305.63510-3-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220831090305.63510-1-gavinl@nvidia.com>
References: <20220831090305.63510-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d571e5ac-fc4c-4105-86cf-08da8b2fb215
X-MS-TrafficTypeDiagnostic: SA0PR12MB4352:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SoEdyByD5HBX95SK9HCsMesfDZM/nlJjJ9YlsShfRkYwqA2JxtIevjMFSfWhN+Ssb29sr1ssXLd+S8HsFGsc0Nl719oHVVYmmXJA1GUAUfu5DdDlc4GVphwJAMUx3TmAnkwPdUjJ5Uq8FlQ1Q6n5hl6pix84q+0sZCW+zvKNA+RFgKg+q+fJ0KA55RNXRyuZnSFPcOd//qWC17duWmiGftysYucZI2w5QrLOFUBApk9KiTG7QeMwKOMpZxXshKzGe5WxMiEUYkGECgb0ugEQXd5WT4dhaJcg8rddVL5y39JmO3FYYVdSxgwt4PcXlvpibC/4huHPRQIrd9wIqeO0bWHt/3g5EGtXraiSt1djWug11zhbp00EJMTpIeTkhUNBoM2TCw+qpbIqa5hFfiI8ho5z+Y4sP+3piU1ODWgnw7mItPRC7452FN+0YhRLOimRf8O4LP7ZhoObHmGrvXqbRym7wW4vy9LFYTUaVrM9+g13HXD0vHi01PZ/+KKR9+cqM3aONQZUS+LdVTBrUsMEsAGf4lw8BgFCxuLPsLRlDGMAu9IWcPJVEWXdjwQwL0Ek5XcYWr4/zGei/AeQ3NYgSfFtN/qFiUFIVu2dorUuOumNDoA13ZvF40pfoASIlPi7IUjp4YFEZfiWRv3Q5umnWl2KkUmFfdfccLChnQxYo8wWD38udkBfbz6UwjZmST4prbdF6YGiWoX3819P9PL7J82IZC05bD4tharzvYWSC1BlxJmVoq6TQ/Jm8aIV3nUj68F3IXtQZ59KPHdOgf7j6Awv9NyF9liSEwVKo4eVmU7Yd75rCd3XDCGLYWNoGouV
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(376002)(39860400002)(36840700001)(40470700004)(46966006)(2616005)(1076003)(186003)(36756003)(83380400001)(82740400003)(2906002)(16526019)(7416002)(336012)(5660300002)(82310400005)(426003)(47076005)(8936002)(26005)(6286002)(316002)(36860700001)(7696005)(70206006)(70586007)(4326008)(8676002)(6666004)(107886003)(81166007)(110136005)(86362001)(41300700001)(54906003)(921005)(356005)(55016003)(478600001)(40460700003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 09:03:39.2731
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d571e5ac-fc4c-4105-86cf-08da8b2fb215
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4352
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

