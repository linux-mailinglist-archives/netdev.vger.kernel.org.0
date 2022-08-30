Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C275A5967
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 04:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiH3C1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 22:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiH3C1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 22:27:12 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8030D9E685
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 19:27:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VH9Ecym5O/sRwqY4Ndsc/C6a4sb1tRP9jgwhJlssbj6nPkGz7vmcjB2KBae508kvVKlauYEoqvse3erHBNKbEuRhEVhiAw57GzyPbwsf76OeQDZMdzOwhjjO+yL0KizsW9MKsVLlf83inhOa+ZOAIUiSzSlfyEzpbv43lT9Smqxn4qdAltMnOkUNSsWMFWRq2Uh8oB958d2gFTvP09p+eJ42WLjSdUNTDa9ioHJF+aOIbtxmXRAU/Wt7jWkEfNgJaX9kWO5mMwIkaLR3ev0zV0G5u3Q15bQz4t7Ecq6fBsoK9Ye0Fu7F+xUuteJez27urxfuwFePyxllrkHorpXOgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7siczqoToJkiAU6xdwJzcdOwPPt76BanQbjZXV35ET0=;
 b=hRws6vtPACdO0LvHZ3i00kTcTyZqDZ9NbyT/y9N6HS+wVOeDR7iuT3vfSCSV2wbe0lLDyMYH0Nzipz0KJxqhBudgZdYQ7QTjGLSY3+s4bFEPfEfWKKx+fhR6fpuMAq3HjpTy7JBRN5eljR23O2Tt+RMixiLvD8unwmfDNziJYU0Gz1gbIEvzFUzZQoFSOaFl9iDHYBOcmMPoV7Dpbr1fLyRhu+/StE+5ZKjAT1HnX2Nb1oWcXJLGKjah3ZYQD4xlyH/lry5t/IotO0wm+MQdN2fxBBSbokx/Yv5GrdyqlbEcn3K2etEPUlJFwYe47C5lujqP/c09awnFb9K24q/uqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7siczqoToJkiAU6xdwJzcdOwPPt76BanQbjZXV35ET0=;
 b=Rw8Pts9pOH/nFI2GMtydXD9q8gLKlHYqfkF6X6UQUtS8coasrtj7OUesIgokmZhBwWyZ5R9hSNelykJRGTYgvEkGBq2SSQAsrHC2F63xTsrQgW0reufaUpfXBfUohly28o8xi44W3EteZShlbBBgGRTNaNFMEFXtxwoQAfi3f52EVViZ3D9HyeFS2Y5TIqURjwZaM7JzOr5YLGeBKSuZUyZcTxdkYEO7do1j4KX/PnMwAyoQKH/Bc5y9Mm9qk+7FyWakD+AeQ5nxqx6/zY/qiimjP+XWRqd2MSkEPCREvktHCWsw3wHXmjKHmtn4fKg7rH/SU432AlbUjoC2GpmiIA==
Received: from MW2PR2101CA0020.namprd21.prod.outlook.com (2603:10b6:302:1::33)
 by BN6PR12MB1140.namprd12.prod.outlook.com (2603:10b6:404:19::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Tue, 30 Aug
 2022 02:27:08 +0000
Received: from CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::3e) by MW2PR2101CA0020.outlook.office365.com
 (2603:10b6:302:1::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.3 via Frontend
 Transport; Tue, 30 Aug 2022 02:27:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT023.mail.protection.outlook.com (10.13.175.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Tue, 30 Aug 2022 02:27:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Tue, 30 Aug
 2022 02:27:05 +0000
Received: from nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 29 Aug
 2022 19:27:01 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <stephen@networkplumber.org>, <davem@davemloft.net>,
        <jesse.brandeburg@intel.com>, <alexander.h.duyck@intel.com>,
        <kuba@kernel.org>, <sridhar.samudrala@intel.com>,
        <jasowang@redhat.com>, <loseweigh@gmail.com>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <virtio-dev@lists.oasis-open.org>, <mst@redhat.com>
CC:     <gavi@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH v3 2/2] virtio-net: use mtu size as buffer length for big packets
Date:   Tue, 30 Aug 2022 05:26:34 +0300
Message-ID: <20220830022634.69686-3-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220830022634.69686-1-gavinl@nvidia.com>
References: <20220830022634.69686-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee765dd9-ce9c-41a0-c4ea-08da8a2f22e1
X-MS-TrafficTypeDiagnostic: BN6PR12MB1140:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8KK3Neadr7vW0VRWNUSqz/MSFL+HymDWu19mpgzKVOmAGusIB3s4Lb1aBLBCk2+upDwuCA1Q08/cEABnPKOLU6Lc6jVdh6/HWzVINqycsegaRI9P02nbFGa/fuk/Da20Y3ufBehcXmi8Uq8iWEEawiqeLwhnanrP3h1BoAUN/wVWCI0trSVcqR8S8FzMTbX9Hxa0gBs0ac5+ZX/UYfLpZK1XDfoQEoJxvBvTJ4Avm24GcP5gFUiqWWKFkT2qp+rpJXGPRLrBFvqEL8+Wz+IQ1u8PiJ6M1PPycK+1CSaPTKpM+dcbQSjtV/euYltsLAQ+z4WwKGZ0gdhRUipc9JeHFcuhVHkM8h2T02aB1SZyLS7ghtvLD+3NcPMANBu/jIuIpQaapAU92nPPD3EaJSPCRgOmcwdaMMNw1dlK/nfD2Mc7jF02QRJTXibhK9pFhdMVoivcC/yxtN9dpZ40uWispzRKkdArnHDxFB+GgTH1Hec+xRFaASxXng1hK1Vc4g2KFXv20/jP3gG70XTo+ke5xGE7cGKpTwHdRxiWJ5zvoPSIlhQEikfuL+q11VTrMQ/p+aP3KaHPe67UCF7a6rJYGbH60iKRen1CxX0A/ymm3q6d18hLNy22KkAClgIafUJH2gQj1EIQw596GOnftVIfi5Z8EbSPbmYVNz0ARz1RND0O7ucY21QM38zta/gcvupJTbWaVECmch5822iHT0oJfhLGupck3OMV0jzQGSUF8iJVvv1foEqL2mSLbg5PrlTloWnk3UGq9J1ZJmjtZyQWJ1kcRqFK8sqk53O0LyZ4RLO1aGst66xUDbzRJMRlMk07
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(136003)(376002)(36840700001)(46966006)(40470700004)(5660300002)(4326008)(2906002)(70206006)(70586007)(316002)(40460700003)(82310400005)(40480700001)(55016003)(86362001)(8936002)(36756003)(7416002)(36860700001)(83380400001)(81166007)(356005)(82740400003)(41300700001)(478600001)(921005)(8676002)(26005)(110136005)(54906003)(1076003)(2616005)(186003)(47076005)(336012)(426003)(7696005)(107886003)(6286002)(6666004)(16526019)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 02:27:07.8570
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee765dd9-ce9c-41a0-c4ea-08da8a2f22e1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1140
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
index e1904877d461..d2721e71af18 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -225,6 +225,9 @@ struct virtnet_info {
 	/* I like... big packets and I cannot lie! */
 	bool big_packets;
 
+	/* number of sg entries allocated for big packets */
+	unsigned int big_packets_sg_num;
+
 	/* Host will merge rx buffers for big packets (shake it! shake it!) */
 	bool mergeable_rx_bufs;
 
@@ -1331,10 +1334,10 @@ static int add_recvbuf_big(struct virtnet_info *vi, struct receive_queue *rq,
 	char *p;
 	int i, err, offset;
 
-	sg_init_table(rq->sg, MAX_SKB_FRAGS + 2);
+	sg_init_table(rq->sg, vi->big_packets_sg_num + 2);
 
-	/* page in rq->sg[MAX_SKB_FRAGS + 1] is list tail */
-	for (i = MAX_SKB_FRAGS + 1; i > 1; --i) {
+	/* page in rq->sg[vi->big_packets_sg_num + 1] is list tail */
+	for (i = vi->big_packets_sg_num + 1; i > 1; --i) {
 		first = get_a_page(rq, gfp);
 		if (!first) {
 			if (list)
@@ -1365,7 +1368,7 @@ static int add_recvbuf_big(struct virtnet_info *vi, struct receive_queue *rq,
 
 	/* chain first in list head */
 	first->private = (unsigned long)list;
-	err = virtqueue_add_inbuf(rq->vq, rq->sg, MAX_SKB_FRAGS + 2,
+	err = virtqueue_add_inbuf(rq->vq, rq->sg, vi->big_packets_sg_num + 2,
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
+		vi->big_packets_sg_num = guest_gso ? MAX_SKB_FRAGS : DIV_ROUND_UP(mtu, PAGE_SIZE);
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

