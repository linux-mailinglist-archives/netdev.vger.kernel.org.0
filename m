Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9760420C962
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 19:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgF1Rsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 13:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgF1Rse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 13:48:34 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF23C03E979
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 10:48:34 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k1so6197957pls.2
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 10:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=v0YoGZ2fbCj1r/PiIDmqEHvjT61GUJbCeiW4syEnQ6g=;
        b=gSyXZPLeAm+IPL7bVDssaVxVARLJVXXgfYsL2wboqPnXuGhj5yshGZZB4RVx05FrVV
         WjIceGRzWCSprFTHT4OfIcsohyRAv58l/pqkmTUFCPAqbMCf7PcTI0HOD+nq+Yglchvc
         /OsC8k431Q1yApVNCHgMXYwYjWx03MBZGluF7s3Wcterjf20p7pihRe/szRnbOedPgPl
         GqRoc9CNX2ol/EL6waqd76ggVKhdcPgE47y4Ct5osRSNZ+A8n6+dYfHVkNC0BSoENKRa
         kOZnWPEYOYgcuSW8u842pVNsG7Sn6NN47Rjkp2PpwZ1GJmxKZR//Rr4W4qUk7g5jlLGP
         kC5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=v0YoGZ2fbCj1r/PiIDmqEHvjT61GUJbCeiW4syEnQ6g=;
        b=iT80FHKWXnGTYg1CyoNoADqd+WTxFxwTAkfuY5FvLjv+ildifhSqxCSHlN3KCH8cdT
         RMKqtA1j0n99BkNmGwVrd7TXKcpscQ6eE+UEhyi77xUNLoZXk+qHYcHe02AhVGgiR2R8
         P3O/yupC55DqFZQ71Au2OyRuzVlGWaZiFpqMxCXBI5h6OAJh7xJlm0KX2+t8h/1jESZ8
         hyS5J+1ULN94mMnK4NLEkTXh+2Bhn9JL23ZTpMOhnw0jASzROYU3nwvn0K+W/hIo2vlM
         zLRW7ZRX+QtibLIgSdi6LnzBKJASUos1RO8GFRr8eZfUe/oUlu+6Esa/oux7wjCTRcZ/
         HRug==
X-Gm-Message-State: AOAM531h1J39qqfTiDwG02rhgCL5xmywAb/hgeQvrTwutbhaHcE2oJzm
        CiQdp9/7royV3CQVAf3l1QQA4M2Z
X-Google-Smtp-Source: ABdhPJy4p5Z5/RC/hlBd4zrsQeAmiLtfqMsCj9qdKs84hy/C2OpeqhoGSF1GE5eFj76x7uDFYv1byg==
X-Received: by 2002:a17:90a:ee14:: with SMTP id e20mr14620809pjy.55.1593366513818;
        Sun, 28 Jun 2020 10:48:33 -0700 (PDT)
Received: from martin-VirtualBox.vpn.alcatel-lucent.com ([137.97.117.181])
        by smtp.gmail.com with ESMTPSA id cu9sm16740715pjb.28.2020.06.28.10.48.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jun 2020 10:48:33 -0700 (PDT)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Martin <martin.varghese@nokia.com>
Subject: [PATCH net-next] bareudp: Added attribute to enable & disable rx metadata collection
Date:   Sun, 28 Jun 2020 23:18:23 +0530
Message-Id: <1593366503-2831-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin <martin.varghese@nokia.com>

Metadata need not be collected in receive if the packet from bareudp
device is not targeted to openvswitch.

Signed-off-by: Martin <martin.varghese@nokia.com>
---
 Documentation/networking/bareudp.rst |  6 ++++--
 drivers/net/bareudp.c                | 23 +++++++++++++++++------
 include/net/bareudp.h                |  1 +
 include/uapi/linux/if_link.h         |  1 +
 4 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/Documentation/networking/bareudp.rst b/Documentation/networking/bareudp.rst
index 465a8b2..0e00636 100644
--- a/Documentation/networking/bareudp.rst
+++ b/Documentation/networking/bareudp.rst
@@ -48,5 +48,7 @@ enabled.
 The bareudp device could be used along with OVS or flower filter in TC.
 The OVS or TC flower layer must set the tunnel information in SKB dst field before
 sending packet buffer to the bareudp device for transmission. On reception the
-bareudp device extracts and stores the tunnel information in SKB dst field before
-passing the packet buffer to the network stack.
+bareudp device decapsulates the udp header and passes the inner packet to the
+network stack. If RX_COLLECT_METADATA flag is enabled in the device the tunnel
+information will be stored in the SKB dst field before the packet buffer is
+passed to the network stack.
diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 3dd46cd..108a8ca 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -46,6 +46,7 @@ struct bareudp_dev {
 	__be16             port;
 	u16	           sport_min;
 	bool               multi_proto_mode;
+	bool               rx_collect_metadata;
 	struct socket      __rcu *sock;
 	struct list_head   next;        /* bareudp node  on namespace list */
 	struct gro_cells   gro_cells;
@@ -125,13 +126,14 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 		bareudp->dev->stats.rx_dropped++;
 		goto drop;
 	}
-
-	tun_dst = udp_tun_rx_dst(skb, family, TUNNEL_KEY, 0, 0);
-	if (!tun_dst) {
-		bareudp->dev->stats.rx_dropped++;
-		goto drop;
+	if (bareudp->rx_collect_metadata) {
+		tun_dst = udp_tun_rx_dst(skb, family, TUNNEL_KEY, 0, 0);
+		if (!tun_dst) {
+			bareudp->dev->stats.rx_dropped++;
+			goto drop;
+		}
+		skb_dst_set(skb, &tun_dst->dst);
 	}
-	skb_dst_set(skb, &tun_dst->dst);
 	skb->dev = bareudp->dev;
 	oiph = skb_network_header(skb);
 	skb_reset_network_header(skb);
@@ -575,6 +577,9 @@ static int bareudp2info(struct nlattr *data[], struct bareudp_conf *conf,
 	if (data[IFLA_BAREUDP_MULTIPROTO_MODE])
 		conf->multi_proto_mode = true;
 
+	if (data[IFLA_BAREUDP_RX_COLLECT_METADATA])
+		conf->rx_collect_metadata = true;
+
 	return 0;
 }
 
@@ -612,6 +617,8 @@ static int bareudp_configure(struct net *net, struct net_device *dev,
 	bareudp->ethertype = conf->ethertype;
 	bareudp->sport_min = conf->sport_min;
 	bareudp->multi_proto_mode = conf->multi_proto_mode;
+	bareudp->rx_collect_metadata = conf->rx_collect_metadata;
+
 	err = register_netdevice(dev);
 	if (err)
 		return err;
@@ -669,6 +676,7 @@ static size_t bareudp_get_size(const struct net_device *dev)
 		nla_total_size(sizeof(__be16)) +  /* IFLA_BAREUDP_ETHERTYPE */
 		nla_total_size(sizeof(__u16))  +  /* IFLA_BAREUDP_SRCPORT_MIN */
 		nla_total_size(0)              +  /* IFLA_BAREUDP_MULTIPROTO_MODE */
+		nla_total_size(0)              +  /* IFLA_BAREUDP_RX_COLLECT_METADATA */
 		0;
 }
 
@@ -685,6 +693,9 @@ static int bareudp_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	if (bareudp->multi_proto_mode &&
 	    nla_put_flag(skb, IFLA_BAREUDP_MULTIPROTO_MODE))
 		goto nla_put_failure;
+	if (bareudp->rx_collect_metadata &&
+	    nla_put_flag(skb, IFLA_BAREUDP_RX_COLLECT_METADATA))
+		goto nla_put_failure;
 
 	return 0;
 
diff --git a/include/net/bareudp.h b/include/net/bareudp.h
index dc65a0d..3dd5f9a 100644
--- a/include/net/bareudp.h
+++ b/include/net/bareudp.h
@@ -12,6 +12,7 @@ struct bareudp_conf {
 	__be16 port;
 	u16 sport_min;
 	bool multi_proto_mode;
+	bool rx_collect_metadata;
 };
 
 struct net_device *bareudp_dev_create(struct net *net, const char *name,
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index a009365..cc185a0 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -600,6 +600,7 @@ enum {
 	IFLA_BAREUDP_ETHERTYPE,
 	IFLA_BAREUDP_SRCPORT_MIN,
 	IFLA_BAREUDP_MULTIPROTO_MODE,
+	IFLA_BAREUDP_RX_COLLECT_METADATA,
 	__IFLA_BAREUDP_MAX
 };
 
-- 
1.8.3.1

