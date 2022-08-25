Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD3A5A10B5
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 14:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241936AbiHYMjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 08:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241937AbiHYMjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 08:39:12 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC203B441D
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 05:39:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ldxJcAa8rbsGOdFHkpiP3Rg/qygxLt1mrq4hxCg5Tj0AGfwV4YGt6p4K/LtNR+3vNyMyEBUidV3FcQC3LYJGEz2L/76RDkaaGtW8R6hu9PCNmo/usjNZcko+8rdsYOKcSIHH9pEBkAJyt3MR5EKrmNptPHtKfDG+1MpY/wJSJyPKJZ7QFsBTQYr1GA/BD6ObtHcWTyIb9QHdCj0dhIXD6FEztqHF/WtWOdOPG7OAJDvpm0L7VKPkM5wMkrU+vduX17b3MfsZnSnwccS4G0+oDRfstvvPd3sP6iNNF98tU7lOUteE3C0x/heAzDm3yxsNprYEh0cPm5cEAyQYAuQLiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SsqkOPrCxr1s+aJVHq6NJBqbcquzGkwiBC72PAq+kbE=;
 b=fxJ/Qmo5OMBjJKmrHhznijsHQFoWjCcXlo0KOvi7IcQGsaXz/ofq19ffmBMPBhJlj8d1pf0tA3Ei/G5DXb3DNI9STWKl7InRwVGgx4h0LEZ4shqAsfOwTnBpv22ciDttTiS3Ez0CKKajP54XpDUu6mJFEcJBsXmPGsQ7QGBH49TZJfyeYUwnXgzokmamBHi8lIwCVtSOshE1p8gNL1PKh3q5qBlobnm3CJvgAq4EbjlVKJrLQQFPYU+7f0mYgMmq2PkiMN5njCGwYf+ZVDUclHJVJPl30vS1FpH97m7pJOwyxU9E+estrDWCqoOjLEHGsGE5aCfil9G8c9DeR/p8Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SsqkOPrCxr1s+aJVHq6NJBqbcquzGkwiBC72PAq+kbE=;
 b=rZv98DU3PC2X/Utjd9OuKUF3l0n8Kz8pCgYcuIWrWPU6o0tOEpb7doPmFpcXfNMZ0IrUqPTFSwxv8LowhEQG0AAjUDPlPG/PNk+XRxYmkgr3s0M5MHjYt2JyhTJPARD/37GvakFzkcZe2RzdCfLEARjv7aoyEZN0ztQtrPOSOm79oGJDs1BV1KiGbhbSXd5PQpDGRMg/TsXATy8TDpdTduSbAe53trAmC1xgKsmXHz9LyYfxdTDu+sG9w43RcufElcMGdZ7tOdopDXAcsp0Vic7u0ClF8HrvKM8dd2nGvZ+SgKPaM1HcZ0Em7bawkEsxcVXRVGlHIl3lxD8eviOLhg==
Received: from DS7PR03CA0049.namprd03.prod.outlook.com (2603:10b6:5:3b5::24)
 by BY5PR12MB4178.namprd12.prod.outlook.com (2603:10b6:a03:20e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 12:39:09 +0000
Received: from DM6NAM11FT115.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::c5) by DS7PR03CA0049.outlook.office365.com
 (2603:10b6:5:3b5::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.19 via Frontend
 Transport; Thu, 25 Aug 2022 12:39:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT115.mail.protection.outlook.com (10.13.173.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Thu, 25 Aug 2022 12:39:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 25 Aug
 2022 12:39:08 +0000
Received: from nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 25 Aug
 2022 05:39:04 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <stephen@networkplumber.org>, <davem@davemloft.net>,
        <jesse.brandeburg@intel.com>, <alexander.h.duyck@intel.com>,
        <kuba@kernel.org>, <sridhar.samudrala@intel.com>,
        <jasowang@redhat.com>, <loseweigh@gmail.com>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <virtio-dev@lists.oasis-open.org>, <mst@redhat.com>
CC:     <gavi@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH RESEND v2 2/2] virtio-net: use mtu size as buffer length for big packets
Date:   Thu, 25 Aug 2022 15:38:40 +0300
Message-ID: <20220825123840.20239-3-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220825123840.20239-1-gavinl@nvidia.com>
References: <20220825123840.20239-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1042ebd7-2f5e-446c-8713-08da8696ce66
X-MS-TrafficTypeDiagnostic: BY5PR12MB4178:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dwpcNw9QEnuqOUW+WeE24P1UCHB5AWmZWjt95Bmoo/VCQx1DxGd3EYwsxXaz23LkVvvUl2gkTbY70iHnX/JJ/vW4gPi+bKFwMm0nUZQCk4S4u56Or20UlT6LwnRJ2H52qjB9tR4yfl/iwxmdoKwqfh3DivDMl8YvNjbLMFCbtVd1J530NpmYSP20iVPAUlCV/ViECsB/wXZM1JEguMcn50j88I4buxUJjKJJYfiR8MulxOFAFFCq535A7UiXlodwoXgqi2Z2jilUB3WNqexUMeZvwDMY9wyn4cjVvB1HB/Fm2DhM+y44fCz6aa+Civu6z3OYt5PWZ8yeTYRgWvf1nR83IpSzKIL+mJNeEisWA/VvJUg8i8pvMeeKcNZ5ETPwLYBtPeDtaOIEEkH8LbNCgVGZznmlZvf/shx4n7yDg48GaN6w8OETU+rDNxl158KCE/ldXDLPyIwrjRbjbrjc/iYS6pY+39FKtRBtzoIVKcQqB5dmC99N9sQavWbBTFfHwOOdXY40wUOAk3Nq9iTIZ0Koh372rZVDZ7WwSOYia0A5g6BSckR7Z2LH8lzEvydWb2+UOZXwBMJFla21xfO31TdEKQ3QemvpTfliv0aENmPcuyndfMQvFCdBEJyT1Sa9jw2VEP6TIqHmOZxk3X+CQqFGt5adDvIcZ5Yt3BXjVse12gVGggzIK+mYOUZ25SaHEDnkA3dpJP4tb1UvkEqo2ACC42PEVltwPRlUPArK5eAfG4Go8diZB8ho25UqFURP55kX7bfwdPBA8APNpvtS66eRaWu2Wu9Kb02BEJTFY4HRu9bBKE+uhiMD1He+yjed7okwLrofcieiSZz+ZMXjAOJJRhZ415Xf4LDrFSKz7Sk49gjQmqxzkNQ33nZQ+yNW
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(39860400002)(346002)(396003)(46966006)(40470700004)(36840700001)(8936002)(478600001)(5660300002)(41300700001)(7416002)(40460700003)(26005)(6666004)(107886003)(2906002)(86362001)(55016003)(7696005)(6286002)(82740400003)(81166007)(40480700001)(82310400005)(921005)(356005)(16526019)(186003)(36860700001)(336012)(47076005)(426003)(83380400001)(2616005)(1076003)(54906003)(8676002)(110136005)(4326008)(70206006)(70586007)(36756003)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 12:39:09.0982
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1042ebd7-2f5e-446c-8713-08da8696ce66
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT115.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4178
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
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
v1->v2
- Addressed comments from Jason, Michael, Si-Wei.
- Remove the flag of guest GSO support, set sg_num for big packets and
  use it directly
- Recalculate sg_num for big packets in virtnet_set_guest_offloads
- Replace the round up algorithm with DIV_ROUND_UP
---
 drivers/net/virtio_net.c | 41 +++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index e1904877d461..ec8c135a26d6 100644
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
@@ -3690,13 +3693,31 @@ static bool virtnet_check_guest_gso(const struct virtnet_info *vi)
 		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO));
 }
 
+static void virtnet_set_big_packets_fields(struct virtnet_info *vi, const int mtu)
+{
+	bool guest_gso = virtnet_check_guest_gso(vi);
+
+	/* If we can receive ANY GSO packets, we must allocate large ones. */
+	if (mtu > ETH_DATA_LEN || guest_gso) {
+		vi->big_packets = true;
+		/* if the guest offload is offered by the device, user can modify
+		 * offload capability. In such posted buffers may short fall of size.
+		 * Hence allocate for max size.
+		 */
+		if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
+			vi->big_packets_sg_num = MAX_SKB_FRAGS;
+		else
+			vi->big_packets_sg_num = DIV_ROUND_UP(mtu, PAGE_SIZE);
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
@@ -3784,10 +3805,6 @@ static int virtnet_probe(struct virtio_device *vdev)
 	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
 	spin_lock_init(&vi->refill_lock);
 
-	/* If we can receive ANY GSO packets, we must allocate large ones. */
-	if (virtnet_check_guest_gso(vi))
-		vi->big_packets = true;
-
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
 		vi->mergeable_rx_bufs = true;
 
@@ -3853,12 +3870,10 @@ static int virtnet_probe(struct virtio_device *vdev)
 
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

