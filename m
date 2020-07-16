Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 910DE2227EB
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbgGPP7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728845AbgGPP7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 11:59:04 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA5BC061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 08:59:04 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id x8so4049021plm.10
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 08:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7eFfDkcgiHvnUDeapBbqZZ4SJ1JbNNAlmyH9Kb3T3as=;
        b=FEec7vsXYisMaBZ6elKeom0Z9JMzv0t6g1SaKyRgc9C52x7r8BFis3LHUjBHBkwQXV
         qz2IqN18SceMd9gnrxobnKKD30lRCWIxdPPfL6JMiXJBThW8dYyWU1cJGocQsUspCurG
         eeQco87cKxIOJPoprVJSkzbjJBp8qnW1r7YFrqCnIv7zRW2JWeyP0o1VFmWv4UqbF3uO
         uYtyrZ9hU1YyW5gwrikadilqg2Y8dfPzd0Kx7R9JUbeKRfEEUJEt4h5VN7Qnug3w+o5M
         DCOrCgydETYBRB2HX4lNBuQMeU0YbA649WGPeGCui2t5lcGH942wbri1Uo1svry7M3Nf
         q7Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7eFfDkcgiHvnUDeapBbqZZ4SJ1JbNNAlmyH9Kb3T3as=;
        b=KFQmzNeRUWmTUWPGtuDcNd16PvU08EJ0N77NSUR2pxJoH7foeTDtNOq+eDCBG4MRDN
         xqZLolr22Sh3k9HKuAyLbQGjJ9tKMOzrm5nKGHeIPSEorxk+hUxr0x9A2UnsR6Qv25K0
         JJ4GOplMw5g+RyM0DLfvCs27pz47uGZdwH865ouV6IF2PTpNa+DfBuNOboG+carEmr73
         4AZjyYhMe0oO1l6U8Xue90M0zxEts3DH6a+QSkeQ8FOGzKD5qveSqnQqxZlORHBdIq28
         Bm+QQCR0Gk0ycB4AT4pQqGchBWeC6y5NFpmAjtOKaDcjeLZgRVYTABIoyzl/JBfNK3NL
         rb4Q==
X-Gm-Message-State: AOAM5335T9k26aEm3DOO/APjFnz/7U/9HvUed5ze2NnOck1IuYopZAaS
        peW6tNed864f31ufqCJaSCONsOGz
X-Google-Smtp-Source: ABdhPJywCv8Hw3UqdcNMRN1sA/sghTEXGwyAVNKsYiFbdd1/WOHnly8byD19CzWM02zhmYcciJw+2w==
X-Received: by 2002:a17:90a:3770:: with SMTP id u103mr6036275pjb.102.1594915143367;
        Thu, 16 Jul 2020 08:59:03 -0700 (PDT)
Received: from localhost.localdomain ([42.109.144.241])
        by smtp.gmail.com with ESMTPSA id 2sm5573519pfa.110.2020.07.16.08.59.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jul 2020 08:59:02 -0700 (PDT)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, gnault@redhat.com
Cc:     Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCH net-next v2] bareudp: Reverted support to enable & disable rx metadata collection
Date:   Thu, 16 Jul 2020 21:28:54 +0530
Message-Id: <1594915134-3530-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

The commit fe80536acf83 ("bareudp: Added attribute to enable & disable
rx metadata collection") breaks the the original(5.7) default behavior of
bareudp module to collect RX metadadata at the receive. It was added to
avoid the crash at the kernel neighbour subsytem when packet with metadata
from bareudp is processed. But it is no more needed as the
commit 394de110a733 ("net: Added pointer check for
dst->ops->neigh_lookup in dst_neigh_lookup_skb") solves this crash.

Fixes: fe80536acf83 ("bareudp: Added attribute to enable & disable rx metadata collection")
Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
---
Changes in v2
    - Fixed Documentation.

 Documentation/networking/bareudp.rst |  5 ++---
 drivers/net/bareudp.c                | 21 +++++----------------
 include/uapi/linux/if_link.h         |  1 -
 3 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/Documentation/networking/bareudp.rst b/Documentation/networking/bareudp.rst
index 0e00636d8d74..f2cab0ba116b 100644
--- a/Documentation/networking/bareudp.rst
+++ b/Documentation/networking/bareudp.rst
@@ -49,6 +49,5 @@ The bareudp device could be used along with OVS or flower filter in TC.
 The OVS or TC flower layer must set the tunnel information in SKB dst field before
 sending packet buffer to the bareudp device for transmission. On reception the
 bareudp device decapsulates the udp header and passes the inner packet to the
-network stack. If RX_COLLECT_METADATA flag is enabled in the device the tunnel
-information will be stored in the SKB dst field before the packet buffer is
-passed to the network stack.
+network stack. The tunnel information will be stored in the SKB dst field before
+the packet buffer is passed to the network stack.
diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 108a8cafc4f8..44eb2b1d0416 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -46,7 +46,6 @@ struct bareudp_dev {
 	__be16             port;
 	u16	           sport_min;
 	bool               multi_proto_mode;
-	bool               rx_collect_metadata;
 	struct socket      __rcu *sock;
 	struct list_head   next;        /* bareudp node  on namespace list */
 	struct gro_cells   gro_cells;
@@ -126,14 +125,12 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 		bareudp->dev->stats.rx_dropped++;
 		goto drop;
 	}
-	if (bareudp->rx_collect_metadata) {
-		tun_dst = udp_tun_rx_dst(skb, family, TUNNEL_KEY, 0, 0);
-		if (!tun_dst) {
-			bareudp->dev->stats.rx_dropped++;
-			goto drop;
-		}
-		skb_dst_set(skb, &tun_dst->dst);
+	tun_dst = udp_tun_rx_dst(skb, family, TUNNEL_KEY, 0, 0);
+	if (!tun_dst) {
+		bareudp->dev->stats.rx_dropped++;
+		goto drop;
 	}
+	skb_dst_set(skb, &tun_dst->dst);
 	skb->dev = bareudp->dev;
 	oiph = skb_network_header(skb);
 	skb_reset_network_header(skb);
@@ -577,9 +574,6 @@ static int bareudp2info(struct nlattr *data[], struct bareudp_conf *conf,
 	if (data[IFLA_BAREUDP_MULTIPROTO_MODE])
 		conf->multi_proto_mode = true;
 
-	if (data[IFLA_BAREUDP_RX_COLLECT_METADATA])
-		conf->rx_collect_metadata = true;
-
 	return 0;
 }
 
@@ -617,7 +611,6 @@ static int bareudp_configure(struct net *net, struct net_device *dev,
 	bareudp->ethertype = conf->ethertype;
 	bareudp->sport_min = conf->sport_min;
 	bareudp->multi_proto_mode = conf->multi_proto_mode;
-	bareudp->rx_collect_metadata = conf->rx_collect_metadata;
 
 	err = register_netdevice(dev);
 	if (err)
@@ -676,7 +669,6 @@ static size_t bareudp_get_size(const struct net_device *dev)
 		nla_total_size(sizeof(__be16)) +  /* IFLA_BAREUDP_ETHERTYPE */
 		nla_total_size(sizeof(__u16))  +  /* IFLA_BAREUDP_SRCPORT_MIN */
 		nla_total_size(0)              +  /* IFLA_BAREUDP_MULTIPROTO_MODE */
-		nla_total_size(0)              +  /* IFLA_BAREUDP_RX_COLLECT_METADATA */
 		0;
 }
 
@@ -693,9 +685,6 @@ static int bareudp_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	if (bareudp->multi_proto_mode &&
 	    nla_put_flag(skb, IFLA_BAREUDP_MULTIPROTO_MODE))
 		goto nla_put_failure;
-	if (bareudp->rx_collect_metadata &&
-	    nla_put_flag(skb, IFLA_BAREUDP_RX_COLLECT_METADATA))
-		goto nla_put_failure;
 
 	return 0;
 
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index cc185a007ade..a009365ad67b 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -600,7 +600,6 @@ enum {
 	IFLA_BAREUDP_ETHERTYPE,
 	IFLA_BAREUDP_SRCPORT_MIN,
 	IFLA_BAREUDP_MULTIPROTO_MODE,
-	IFLA_BAREUDP_RX_COLLECT_METADATA,
 	__IFLA_BAREUDP_MAX
 };
 
-- 
2.18.4

