Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FED25EC0D7
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 13:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbiI0LPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 07:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbiI0LPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 07:15:02 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4714BD08;
        Tue, 27 Sep 2022 04:14:58 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4McH3j4wnDzlX4d;
        Tue, 27 Sep 2022 19:10:41 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 19:14:56 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 19:14:56 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <shenjian15@huawei.com>,
        <lanhao@huawei.com>
Subject: [PATCH net-next 3/4] net: hns3: replace magic numbers with macro for IPv4/v6
Date:   Tue, 27 Sep 2022 19:12:04 +0800
Message-ID: <20220927111205.18060-4-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220927111205.18060-1-huangguangbin2@huawei.com>
References: <20220927111205.18060-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao418@huawei.com>

Replace 4/6 with IP_VERSION_V4/6 to improve code readability.

Signed-off-by: Hao Chen <chenhao418@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 12 ++++++------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h |  3 +++
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 39b75b68474c..bf573e0c0670 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1180,7 +1180,7 @@ static int hns3_set_tso(struct sk_buff *skb, u32 *paylen_fdop_ol4cs,
 	/* Software should clear the IPv4's checksum field when tso is
 	 * needed.
 	 */
-	if (l3.v4->version == 4)
+	if (l3.v4->version == IP_VERSION_IPV4)
 		l3.v4->check = 0;
 
 	/* tunnel packet */
@@ -1195,7 +1195,7 @@ static int hns3_set_tso(struct sk_buff *skb, u32 *paylen_fdop_ol4cs,
 		/* Software should clear the IPv4's checksum field when
 		 * tso is needed.
 		 */
-		if (l3.v4->version == 4)
+		if (l3.v4->version == IP_VERSION_IPV4)
 			l3.v4->check = 0;
 	}
 
@@ -1270,13 +1270,13 @@ static int hns3_get_l4_protocol(struct sk_buff *skb, u8 *ol4_proto,
 	l3.hdr = skb_inner_network_header(skb);
 	l4_hdr = skb_inner_transport_header(skb);
 
-	if (l3.v6->version == 6) {
+	if (l3.v6->version == IP_VERSION_IPV6) {
 		exthdr = l3.hdr + sizeof(*l3.v6);
 		l4_proto_tmp = l3.v6->nexthdr;
 		if (l4_hdr != exthdr)
 			ipv6_skip_exthdr(skb, exthdr - skb->data,
 					 &l4_proto_tmp, &frag_off);
-	} else if (l3.v4->version == 4) {
+	} else if (l3.v4->version == IP_VERSION_IPV4) {
 		l4_proto_tmp = l3.v4->protocol;
 	}
 
@@ -1364,7 +1364,7 @@ static void hns3_set_outer_l2l3l4(struct sk_buff *skb, u8 ol4_proto,
 static void hns3_set_l3_type(struct sk_buff *skb, union l3_hdr_info l3,
 			     u32 *type_cs_vlan_tso)
 {
-	if (l3.v4->version == 4) {
+	if (l3.v4->version == IP_VERSION_IPV4) {
 		hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L3T_S,
 			       HNS3_L3T_IPV4);
 
@@ -1373,7 +1373,7 @@ static void hns3_set_l3_type(struct sk_buff *skb, union l3_hdr_info l3,
 		 */
 		if (skb_is_gso(skb))
 			hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L3CS_B, 1);
-	} else if (l3.v6->version == 6) {
+	} else if (l3.v6->version == IP_VERSION_IPV6) {
 		hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L3T_S,
 			       HNS3_L3T_IPV6);
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 557a5fa70d0a..93041352ef19 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -217,6 +217,9 @@ enum hns3_nic_state {
 #define HNS3_CQ_MODE_EQE			1U
 #define HNS3_CQ_MODE_CQE			0U
 
+#define IP_VERSION_IPV4				0x4
+#define IP_VERSION_IPV6				0x6
+
 enum hns3_pkt_l2t_type {
 	HNS3_L2_TYPE_UNICAST,
 	HNS3_L2_TYPE_MULTICAST,
-- 
2.33.0

