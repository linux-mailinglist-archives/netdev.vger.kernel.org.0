Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBE65A8B44
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 04:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232800AbiIACLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 22:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbiIACLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 22:11:17 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E8DEC4CE
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 19:11:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPF/pzs4dvvKft6n7GizK7ma/1ED+mfjKZkH8LHzrfj/73XjQeFmqKxsiDYFG6RCR3DvKVbmFbkB/KtOne9ADNY3tOjhGzVrlC7qRY0VnM7ZxkUPxASd7ygJ0JUjXLe6UoNgzpAxc0ZEJM3invKK6P2VweW5VuMH5r3nb070wm1gfrnJcS4BBKBOtP3Ng10BSAdK/hZsno6RbOTdUgL/vx0wh7IRNVC+zQeYC7e3PHV3QIIfwkWLk57DrblbZuXPxny9r1OJ9uYPgMCPu1znbGA6G0TlEcBeVNFOyVploQvf+WwauNAAXcxbDJZvjMtF2basJh6WDB+DlyjkrgK2+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8sicBn7HVP0Zl6I4m/kz0gvdn6LMvuSNWXq2SKIs2qI=;
 b=ZQRQ+s5WchtkBfKP0mOkGVrPMJS95zozeakQapOpEiV74P+kCLlxcYakBTBdk73BUTmwNJx8cezoYP1s1lJ2aDPjKPQrpPH/l0mXRqw9zkA950dpUAbYvGFyoz+7yrwntgzC7yQT0QgLsnglDzrj0WgPpHSusl3IUBcGQQcwP3+kIFQqO2WiLp2kdStQxw1yGhN8Wf+brWxlsz0dwJbkF37RlWH512WCCs56H84qApK5g++Kl1+utxNwTjTjx1kCbsfESFzH1C1RVXlcnfsV8CEkmXoyn7SURpxRabxEOywWvUexva6B/g89OLUxj64NgV9B8BgnZcz5ZzA1LtxcgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8sicBn7HVP0Zl6I4m/kz0gvdn6LMvuSNWXq2SKIs2qI=;
 b=uSFChjTR3i8xLJXlB+fjngETA3Wt1Q5MYDHsekEeuqhcZU0swddLKummpWSbwVLR3GvjNZquy/eMvleXjgY4xvCCEeaK07i7yLUyfQjt3YBspyhdDJYl2egzzcMs7vriTR+iA4GBGRv3uCmVYUrDiSurOKSMdgRWvZ669krZ14ejX2kEYwhgZ6RQVF+J04eHjeCu2XW+jVT+uke0/Ai+NwBfXutaCnASHwms0jvqHAqJzV+RiNOpsXknWKX9nv8X9/w0pV1Qyy2joKGJJz9Q2NUL57xgtR6Jq3/ngpPzPB6O4EHCxjD3QUh7cIiBBtm/wsAhsMhsDla3Ur+9Of7OcA==
Received: from MW4PR02CA0003.namprd02.prod.outlook.com (2603:10b6:303:16d::30)
 by CH2PR12MB4230.namprd12.prod.outlook.com (2603:10b6:610:aa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 1 Sep
 2022 02:11:13 +0000
Received: from CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:16d:cafe::d8) by MW4PR02CA0003.outlook.office365.com
 (2603:10b6:303:16d::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10 via Frontend
 Transport; Thu, 1 Sep 2022 02:11:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT022.mail.protection.outlook.com (10.13.175.199) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Thu, 1 Sep 2022 02:11:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 1 Sep
 2022 02:11:08 +0000
Received: from nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 31 Aug
 2022 19:11:03 -0700
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
Subject: [PATCH v5 2/2] virtio-net: use mtu size as buffer length for big packets
Date:   Thu, 1 Sep 2022 05:10:38 +0300
Message-ID: <20220901021038.84751-3-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220901021038.84751-1-gavinl@nvidia.com>
References: <20220901021038.84751-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d3c1690-a485-4164-27b5-08da8bbf3e81
X-MS-TrafficTypeDiagnostic: CH2PR12MB4230:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 79GIS1xqV2o5U06+T5ioXrkY5Rq6r/uA0QgMldqTuPv/sDOCaETvI+aYtLZ8UGYvcgTMzkY2bfpem15VS+MvVx0BhmY9+Oj2CPmd8zoQxf/wBvzBgz8yFiBJiyD1ygNJv2H0jYvhGyYUtaGi8K/cmDcAMhTEasM63FbypWTGVPY+fmSISbGECNIzlS97I65H8XsKQl0Y3/VuwPuF6THLJs+KtPqrragRONFY0+/bgg6UYSfFUDYQyeIKtau3V9miAVvphTZyfgoN0DL+f0+EwZiBmdhL0j1pVudemTL9ZmI5E7E/7xosrxr1zHKNu68mpqQiQDKJ5teX+fgfRdAZjHutk5t8CfGLi3wAv8kQ8YD8ZqeyVrNDb8ycvsgnpE63FLjlLc+ngnvXFeLz2ccSEQLgNx9pArZibrnkwjB/NkR/D1cy8IIi8PBNLrM52YlTgkUJfZAHN+mARPGK1SEmlB1LHzj58oItrQtbydeXsSB8FDjmUbXK9XTsWHNo+Lx9oKe80BrEhtMu/hOpiDeVIPuxjlfUHViWY7LXlQXBlPTUiaw7wgxFusLAvTVOnuSMCVzFbiEeSaNgX0ZUrQp1mMybUbMbQMf2tPE7hXGIOQdRN372X403S1Da7H9cBVBw42QjUIXw3gRDZXMUjxtftLJtw/XKN1n0wsha71ThNToDfx6G1yK9Nxsw2qLXUlz6MneEEvcXiXnr+Fad+y3Jd7oeMITCvwnyr7todN+5/3O9qKK9Bo8B+u2mI33Lrz/3CaqZufFVVFSaylMyYp/LRoBYHmr5sR/Wkw2WeVQYn6FLVH+POUGjFGmDngVUcxbf
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(396003)(346002)(36840700001)(40470700004)(46966006)(110136005)(8676002)(316002)(54906003)(4326008)(70586007)(70206006)(86362001)(7416002)(36756003)(478600001)(5660300002)(8936002)(921005)(356005)(81166007)(41300700001)(82310400005)(2616005)(7696005)(6286002)(2906002)(426003)(6666004)(26005)(82740400003)(36860700001)(83380400001)(16526019)(40460700003)(336012)(55016003)(40480700001)(47076005)(186003)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 02:11:12.8918
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d3c1690-a485-4164-27b5-08da8bbf3e81
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4230
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

Accordingly, for now the assumption is that if guest GSO has been
negotiated then it has been enabled, even if it's actually been disabled
at runtime through VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.

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
index f831a0290998..dbffd5f56fb8 100644
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

