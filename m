Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1104D3E2B
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 01:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239028AbiCJAai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 19:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239025AbiCJAaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 19:30:20 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8AA125509
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 16:29:16 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id mv5-20020a17090b198500b001bf2a039831so6764405pjb.5
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 16:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2qkUWOSjFuJ3SYVMEm+07IQm8DqN/HrdudaxPS5fN9M=;
        b=T1LVZlfVjU35QqyrSPt5TqgLxJ+ztdR0NK2JfwJebB7URQ0gilQA6k+F0MyEsS71tg
         OCrYLHzPK/B79DX7ozjq5/VrmOmULAmemtmGOfpCeSQ/SaBX9tEtmZ4u/EBAarJdwlky
         F7FjwqBZF36wvV680fYn/5ediKJBvHWc2Mo2eFyASGissiX7h/Q8Vs9udWG1OX8GyMcm
         xouQNGR1HqRzsMWiFD0t+75M9y4jWJtR1ijsIjLhaFHRBwajc5lcM4DElfAOBdPHbidh
         AB5qxX+KLTkjieDzJMTPcRr9Xhx/P0MdAjcP/pAyKk5DfK90+ZMtcsZSIFoA7qdJhLPx
         wSaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2qkUWOSjFuJ3SYVMEm+07IQm8DqN/HrdudaxPS5fN9M=;
        b=TvBSJ2Ms2PuLBZ7ArpDwTF4pkUmbcpXzSSqyjia9vYgIOO7FQo6RcEo3y2OjJkmV/D
         DtCZGdkAnWuD2msGvkeinP1o9Vyce5l1O7beK6mknUz3v1Pyv0C9ilWTYnS8Kfojf/o5
         /OOqduVle/fxTb8xYgpa8po/QY6GffHbB0HRRoWe9LIIiKk2qunGPgx71oh9bHbTn2YN
         RgK7gfoBfu1hdox8Y/LYqJpAD+pJJgM9m9oenAHvDe8weaoXaPFg4KVMsw//HyWFAWRt
         QT0Q4BY0Gk9mE97c6IbsYDGwiCuifVouAgGbdqMo2pXNH9EvTg5RGNds3caw2ko/rQRI
         nP5Q==
X-Gm-Message-State: AOAM531is7EWyXGE3oLen959OlGr/wfEIImMWZuAlMm4xdCGadtfPWcZ
        TKAuunjOE7yo/iv2SAojOzYW/U+dS4o=
X-Google-Smtp-Source: ABdhPJzJZ81rjUtlj6ByviGV5uOk149gCwPZ9UG4GFDQQYSY3UYCQMLHalvYS5XCxenvRHwMJuo9VA==
X-Received: by 2002:a17:902:f082:b0:14f:88e6:8040 with SMTP id p2-20020a170902f08200b0014f88e68040mr1653728pla.13.1646872156295;
        Wed, 09 Mar 2022 16:29:16 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c7:6f77:9634:183c])
        by smtp.gmail.com with ESMTPSA id nv4-20020a17090b1b4400b001bf64a39579sm7557660pjb.4.2022.03.09.16.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 16:29:16 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH v3 net-next 13/14] mlx4: support BIG TCP packets
Date:   Wed,  9 Mar 2022 16:28:45 -0800
Message-Id: <20220310002846.460907-14-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
In-Reply-To: <20220310002846.460907-1-eric.dumazet@gmail.com>
References: <20220310002846.460907-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

mlx4 supports LSOv2 just fine.

IPv6 stack inserts a temporary Hop-by-Hop header
with JUMBO TLV for big packets.

We need to ignore the HBH header when populating TX descriptor.

Tested:

Before: (not enabling bigger TSO/GRO packets)

ip link set dev eth0 gso_ipv6_max_size 65536 gro_ipv6_max_size 65536

netperf -H lpaa18 -t TCP_RR -T2,2 -l 10 -Cc -- -r 70000,70000
MIGRATED TCP REQUEST/RESPONSE TEST from ::0 (::) port 0 AF_INET6 to lpaa18.prod.google.com () port 0 AF_INET6 : first burst 0 : cpu bind
Local /Remote
Socket Size   Request Resp.  Elapsed Trans.   CPU    CPU    S.dem   S.dem
Send   Recv   Size    Size   Time    Rate     local  remote local   remote
bytes  bytes  bytes   bytes  secs.   per sec  % S    % S    us/Tr   us/Tr

262144 540000 70000   70000  10.00   6591.45  0.86   1.34   62.490  97.446
262144 540000

After: (enabling bigger TSO/GRO packets)

ip link set dev eth0 gso_ipv6_max_size 185000 gro_ipv6_max_size 185000

netperf -H lpaa18 -t TCP_RR -T2,2 -l 10 -Cc -- -r 70000,70000
MIGRATED TCP REQUEST/RESPONSE TEST from ::0 (::) port 0 AF_INET6 to lpaa18.prod.google.com () port 0 AF_INET6 : first burst 0 : cpu bind
Local /Remote
Socket Size   Request Resp.  Elapsed Trans.   CPU    CPU    S.dem   S.dem
Send   Recv   Size    Size   Time    Rate     local  remote local   remote
bytes  bytes  bytes   bytes  secs.   per sec  % S    % S    us/Tr   us/Tr

262144 540000 70000   70000  10.00   8383.95  0.95   1.01   54.432  57.584
262144 540000

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  3 ++
 drivers/net/ethernet/mellanox/mlx4/en_tx.c    | 47 +++++++++++++++----
 2 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index c61dc7ae0c056a4dbcf24297549f6b1b5cc25d92..76cb93f5e5240c54f6f4c57e39739376206b4f34 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -3417,6 +3417,9 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 	dev->min_mtu = ETH_MIN_MTU;
 	dev->max_mtu = priv->max_mtu;
 
+	/* supports LSOv2 packets, 512KB limit has been tested. */
+	netif_set_tso_ipv6_max_size(dev, 512 * 1024);
+
 	mdev->pndev[port] = dev;
 	mdev->upper[port] = NULL;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 817f4154b86d599cd593876ec83529051d95fe2f..c89b3e8094e7d8cfb11aaa6cc4ad63bf3ad5934e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -44,6 +44,7 @@
 #include <linux/ipv6.h>
 #include <linux/moduleparam.h>
 #include <linux/indirect_call_wrapper.h>
+#include <net/ipv6.h>
 
 #include "mlx4_en.h"
 
@@ -635,19 +636,28 @@ static int get_real_size(const struct sk_buff *skb,
 			 struct net_device *dev,
 			 int *lso_header_size,
 			 bool *inline_ok,
-			 void **pfrag)
+			 void **pfrag,
+			 int *hopbyhop)
 {
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 	int real_size;
 
 	if (shinfo->gso_size) {
 		*inline_ok = false;
-		if (skb->encapsulation)
+		*hopbyhop = 0;
+		if (skb->encapsulation) {
 			*lso_header_size = (skb_inner_transport_header(skb) - skb->data) + inner_tcp_hdrlen(skb);
-		else
+		} else {
+			/* Detects large IPV6 TCP packets and prepares for removal of
+			 * HBH header that has been pushed by ip6_xmit(),
+			 * mainly so that tcpdump can dissect them.
+			 */
+			if (ipv6_has_hopopt_jumbo(skb))
+				*hopbyhop = sizeof(struct hop_jumbo_hdr);
 			*lso_header_size = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		}
 		real_size = CTRL_SIZE + shinfo->nr_frags * DS_SIZE +
-			ALIGN(*lso_header_size + 4, DS_SIZE);
+			ALIGN(*lso_header_size - *hopbyhop + 4, DS_SIZE);
 		if (unlikely(*lso_header_size != skb_headlen(skb))) {
 			/* We add a segment for the skb linear buffer only if
 			 * it contains data */
@@ -874,6 +884,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 	int desc_size;
 	int real_size;
 	u32 index, bf_index;
+	struct ipv6hdr *h6;
 	__be32 op_own;
 	int lso_header_size;
 	void *fragptr = NULL;
@@ -882,6 +893,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 	bool stop_queue;
 	bool inline_ok;
 	u8 data_offset;
+	int hopbyhop;
 	bool bf_ok;
 
 	tx_ind = skb_get_queue_mapping(skb);
@@ -891,7 +903,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto tx_drop;
 
 	real_size = get_real_size(skb, shinfo, dev, &lso_header_size,
-				  &inline_ok, &fragptr);
+				  &inline_ok, &fragptr, &hopbyhop);
 	if (unlikely(!real_size))
 		goto tx_drop_count;
 
@@ -944,7 +956,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 		data = &tx_desc->data;
 		data_offset = offsetof(struct mlx4_en_tx_desc, data);
 	} else {
-		int lso_align = ALIGN(lso_header_size + 4, DS_SIZE);
+		int lso_align = ALIGN(lso_header_size - hopbyhop + 4, DS_SIZE);
 
 		data = (void *)&tx_desc->lso + lso_align;
 		data_offset = offsetof(struct mlx4_en_tx_desc, lso) + lso_align;
@@ -1009,14 +1021,31 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 			((ring->prod & ring->size) ?
 				cpu_to_be32(MLX4_EN_BIT_DESC_OWN) : 0);
 
+		lso_header_size -= hopbyhop;
 		/* Fill in the LSO prefix */
 		tx_desc->lso.mss_hdr_size = cpu_to_be32(
 			shinfo->gso_size << 16 | lso_header_size);
 
-		/* Copy headers;
-		 * note that we already verified that it is linear */
-		memcpy(tx_desc->lso.header, skb->data, lso_header_size);
 
+		if (unlikely(hopbyhop)) {
+			/* remove the HBH header.
+			 * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
+			 */
+			memcpy(tx_desc->lso.header, skb->data, ETH_HLEN + sizeof(*h6));
+			h6 = (struct ipv6hdr *)((char *)tx_desc->lso.header + ETH_HLEN);
+			h6->nexthdr = IPPROTO_TCP;
+			/* Copy the TCP header after the IPv6 one */
+			memcpy(h6 + 1,
+			       skb->data + ETH_HLEN + sizeof(*h6) +
+					sizeof(struct hop_jumbo_hdr),
+			       tcp_hdrlen(skb));
+			/* Leave ipv6 payload_len set to 0, as LSO v2 specs request. */
+		} else {
+			/* Copy headers;
+			 * note that we already verified that it is linear
+			 */
+			memcpy(tx_desc->lso.header, skb->data, lso_header_size);
+		}
 		ring->tso_packets++;
 
 		i = shinfo->gso_segs;
-- 
2.35.1.616.g0bdcbb4464-goog

