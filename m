Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B8F51DC31
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 17:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348091AbiEFPf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 11:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442977AbiEFPfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 11:35:30 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D1BCD4
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 08:31:25 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n18so7776403plg.5
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 08:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WgRfS5eb2UyF5K8/N83Xr3Ox3vMkX6iH80CNtDNa3dI=;
        b=EuMvEYS38IW/YIBdqIat08G8QJ27R6CLGyn3o3qQEnfzhcAh+X5MXSy2pnQAaOULFE
         5YGjxXSjtpK0J/n8eo8fjZaxhn4m/gF25w4a5n7s33bzi0ikbL2HL3oQnSBNku4m9g0r
         vuNVGqZ27r2CXj7rRAPWB/Y/8HhUkw6iwC8Jk/iuo72psYzH0zxMx2x0y77JRfvSIPP0
         cA4BLjpq+oFbjwvU3A3cQMmnwzEvF4FLNIoCIsu4Nk6DRG3Z/2zaHEygFvHUWBYIc651
         HEoUKf7h7b/0dG/+hPFVOSd4OOawYthbg7cmcR9arFu1luEzEPwBcZJRkMTXT4KCSpgN
         VzOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WgRfS5eb2UyF5K8/N83Xr3Ox3vMkX6iH80CNtDNa3dI=;
        b=IW55TgeLJibPzfoRHXA+LetiuWo6x/ndnSn8h85q8Olg3UyjkR44fEhqOTrao0erSb
         idbsETIVeTV90K6Z8QoO+kg5P9mtLemDl7iKoX/cwhc59CK4QhhntOZ/5tWmVP+FAZi1
         7JOAqMf9ltDjQOFSafnyJ4UReJeNcHWI1V/i+c826Uarj2siJ3UlmtPmOZQfmJZ/pggn
         bHdhkuVliG05af8YKwFr6yJqQjA3QWzod6obqB6G8/wQrj8PeikXo2S+Ek2OmII0SPKS
         M2rbPGBoMzc/J2OpPzwBXPJEY89cp/qouhyT2lWvaJ0Um2YTpJmJGPWj2z1ujwUFYIuR
         rqlg==
X-Gm-Message-State: AOAM533Km7HpyIJXazGMNvYVwgt6sdbo+7del3xw3Mjaa3HUzNPRvEsg
        o1Jj1BonDzCG2D+pp1OauGU=
X-Google-Smtp-Source: ABdhPJyMO5kr7iAqKL64ezpyODgCplGhGtbVIkE5jMEtzOQGbgdVYDP5yuJXWY4NQtEJ5lnqi0olDg==
X-Received: by 2002:a17:902:c947:b0:15e:b73a:63d1 with SMTP id i7-20020a170902c94700b0015eb73a63d1mr4285122pla.67.1651851085064;
        Fri, 06 May 2022 08:31:25 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:709e:d3d8:321b:df52])
        by smtp.gmail.com with ESMTPSA id w4-20020a170902d70400b0015e8d4eb1bfsm1918612ply.9.2022.05.06.08.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 08:31:24 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH v4 net-next 11/12] mlx4: support BIG TCP packets
Date:   Fri,  6 May 2022 08:30:47 -0700
Message-Id: <20220506153048.3695721-12-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220506153048.3695721-1-eric.dumazet@gmail.com>
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
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
index c61dc7ae0c056a4dbcf24297549f6b1b5cc25d92..e9b854c563ab7cf7a5f037b65d7f734577369f52 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -3417,6 +3417,9 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 	dev->min_mtu = ETH_MIN_MTU;
 	dev->max_mtu = priv->max_mtu;
 
+	/* supports LSOv2 packets, 512KB limit has been tested. */
+	netif_set_tso_max_size(dev, 512 * 1024);
+
 	mdev->pndev[port] = dev;
 	mdev->upper[port] = NULL;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index f777151d226fb601f52366850f8c86358e214032..af3b2b59a2a6940a2839b277815ec7c3b4af1008 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -43,6 +43,7 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/indirect_call_wrapper.h>
+#include <net/ipv6.h>
 
 #include "mlx4_en.h"
 
@@ -634,19 +635,28 @@ static int get_real_size(const struct sk_buff *skb,
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
@@ -873,6 +883,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 	int desc_size;
 	int real_size;
 	u32 index, bf_index;
+	struct ipv6hdr *h6;
 	__be32 op_own;
 	int lso_header_size;
 	void *fragptr = NULL;
@@ -881,6 +892,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 	bool stop_queue;
 	bool inline_ok;
 	u8 data_offset;
+	int hopbyhop;
 	bool bf_ok;
 
 	tx_ind = skb_get_queue_mapping(skb);
@@ -890,7 +902,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto tx_drop;
 
 	real_size = get_real_size(skb, shinfo, dev, &lso_header_size,
-				  &inline_ok, &fragptr);
+				  &inline_ok, &fragptr, &hopbyhop);
 	if (unlikely(!real_size))
 		goto tx_drop_count;
 
@@ -943,7 +955,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 		data = &tx_desc->data;
 		data_offset = offsetof(struct mlx4_en_tx_desc, data);
 	} else {
-		int lso_align = ALIGN(lso_header_size + 4, DS_SIZE);
+		int lso_align = ALIGN(lso_header_size - hopbyhop + 4, DS_SIZE);
 
 		data = (void *)&tx_desc->lso + lso_align;
 		data_offset = offsetof(struct mlx4_en_tx_desc, lso) + lso_align;
@@ -1008,14 +1020,31 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
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
2.36.0.512.ge40c2bad7a-goog

