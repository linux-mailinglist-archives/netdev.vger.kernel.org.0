Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C40223133
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 04:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgGQCf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 22:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgGQCf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 22:35:26 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C311C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 19:35:26 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id g67so5938358pgc.8
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 19:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=K3+Ykidw3PL0VHLPxQ7EEjxqPL9LuaQWIefcKWZrgts=;
        b=NYO7L32nwpRzrxghL443QxOMk5tRlac38OJKvMV7adyYdX03kGnhCzim/fPuajZUmv
         ED2phNN2yFSi0h/zTuoaoxSJXqxmrJuHDgydkYxZyEsSv+9kIFSAyu9rNlkj+Zb1MA5v
         b6u5SwypN/tiS45tWdIhM2SJIza1uRae8Vv7hDWJMKY/jXzGl7+auYO0Pps5bps2PcHn
         seJzrq8eCugUdnz8PuSwmubXVFXZEzdfW8FDrMAAl4EqjSzjoeoZYO5LiW+4ippYe30D
         YNo1FYaK4SrIdn5Jf+83TyP5L/EUCGO5ZUv4zA9pMB68Yc4uA/4DUYc43/Y0kLavgsRm
         ORDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=K3+Ykidw3PL0VHLPxQ7EEjxqPL9LuaQWIefcKWZrgts=;
        b=B3W12TplYmAJsbLC+TAKhnxyZUW37tXXazg1icfwiEN0heTPYaUkCIdiB+FXsE/3FA
         h+8tCYsGDIfKBAOFYLxenemmd1OgBqQHjh/uRy6cNNYdaNc2A8tHbfKy1UbH/E/D0c3L
         sO/bttoH5pK0FDPX1GB2tTHeKZY408bgeskVPYFY+SE8jRphuUeunCJl+IUsDw0C5JYb
         uqEW/AJIUfWWx9PsLXVorlfWFYhY1DrOKeJCo/fhpeKJ1sJCSoqKIYK0zQ3IJUH+Jb3q
         dIpTQae7k+J81Qqdy/7WXu27whSXeVlxA1WkW7uQkckoX8g7vk0kYQOcJ4v0+CZnn08b
         smgw==
X-Gm-Message-State: AOAM531Tx7eQoDb966TwC6RL2HflI3E3brFnyBiJ7TTEv9xqOJ724Tw5
        vfgH5pXdVrt3MQP9tL/BdUvTdjk1Uxg=
X-Google-Smtp-Source: ABdhPJxvaMlADprYyul+hswy9S6CP2aQG8HyVg32u2DG/YNxM5cgBmbgMfBBOaszo6CK8RwyGFHlLg==
X-Received: by 2002:a63:b18:: with SMTP id 24mr7162897pgl.406.1594953325542;
        Thu, 16 Jul 2020 19:35:25 -0700 (PDT)
Received: from martin-VirtualBox.apac.nsn-net.net ([137.97.161.222])
        by smtp.gmail.com with ESMTPSA id z9sm6096727pgh.94.2020.07.16.19.35.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jul 2020 19:35:24 -0700 (PDT)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, gnault@redhat.com
Cc:     Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCH net-next v3] bareudp: Reverted support to enable & disable rx metadata collection
Date:   Fri, 17 Jul 2020 08:05:12 +0530
Message-Id: <1594953312-4580-1-git-send-email-martinvarghesenokia@gmail.com>
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

Changes in v3
    - Removed rx_collect_metadata from bareudp_conf.

 Documentation/networking/bareudp.rst |  6 ++----
 drivers/net/bareudp.c                | 21 +++++----------------
 include/net/bareudp.h                |  1 -
 include/uapi/linux/if_link.h         |  1 -
 4 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/Documentation/networking/bareudp.rst b/Documentation/networking/bareudp.rst
index 0e00636d8d74..465a8b251bfe 100644
--- a/Documentation/networking/bareudp.rst
+++ b/Documentation/networking/bareudp.rst
@@ -48,7 +48,5 @@ enabled.
 The bareudp device could be used along with OVS or flower filter in TC.
 The OVS or TC flower layer must set the tunnel information in SKB dst field before
 sending packet buffer to the bareudp device for transmission. On reception the
-bareudp device decapsulates the udp header and passes the inner packet to the
-network stack. If RX_COLLECT_METADATA flag is enabled in the device the tunnel
-information will be stored in the SKB dst field before the packet buffer is
-passed to the network stack.
+bareudp device extracts and stores the tunnel information in SKB dst field before
+passing the packet buffer to the network stack.
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
 
diff --git a/include/net/bareudp.h b/include/net/bareudp.h
index 3dd5f9a8d01c..dc65a0d71d9b 100644
--- a/include/net/bareudp.h
+++ b/include/net/bareudp.h
@@ -12,7 +12,6 @@ struct bareudp_conf {
 	__be16 port;
 	u16 sport_min;
 	bool multi_proto_mode;
-	bool rx_collect_metadata;
 };
 
 struct net_device *bareudp_dev_create(struct net *net, const char *name,
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

