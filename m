Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E772202CF
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 05:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgGODMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 23:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726624AbgGODMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 23:12:50 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25812C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 20:12:50 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g67so1644853pgc.8
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 20:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=x/+HiArYtwr4DK4sxwPOF6cdsTrAaEdwDesOkCVpyj4=;
        b=dkrRA4exwZ81gBxJfoKm1b6PnwAIKOHLU0xkUZsZicbZDdTQjbRleXr0qpbPnJk6BO
         sQ0nOPl2NEyLPB/IBLHnUhug7w8eErpxDoI2Ki2b1SgW8HKxZoKdBbl87EZZ8+CvI2Uo
         JDzk/kjE+JmNmXO4i+Nm1VrFh4VxnsR2NPpRye4Le09QcECnJNiNgmKij2c1NqcH4/Q7
         UfAl8hDybWUaRA0kiIEppaaTy23LkPrgAZFMkKazJ3x+ZxifQYfvA5uqN75Vy/v3m/Ht
         5z1R9l2QD/6dlTaJTWzr8xgy+DGuOeTZb8ZOs7mXyjTcGF5hEi73yU1kCCSAzFj+ryR4
         lRfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=x/+HiArYtwr4DK4sxwPOF6cdsTrAaEdwDesOkCVpyj4=;
        b=mV2wqx/73e7K9U8yqnTQY9aBNlkHnw+pfdkFyJodxTixelrWsoWpPfqMhfCvUDmmUE
         fdLHIhKRSOLn3xQ4GoyqJo55sLjqr19o3+etV5NVCc3c/tAiNtJk/BkaaZrB20ELS259
         rKtJDg/ZqjGl9WsAogDFGN22050zW6q82UXvB1YcKhFd2HH1ZhBZ2GnqbSn42dmcH2Jc
         iFib2ndW1qJdAlEX0R5EmR5P3qjfKxWoW+DLwGwzGmB0GXTyAPz6s407p+hGNf+jANJw
         Jth5+Pxpne7OIHonzgIV0C6FywW+cwvW4LhnewIfQIMMbqBrrFzTHPOPNomB5uSUHF6r
         qK0Q==
X-Gm-Message-State: AOAM532/aAWnEB2jcfF8++cWmMqSDXVc4cS167E/KZ9xiCvw0sDNcMoV
        O2PIwnd9b62FiJPKLsxXP72vNhK7
X-Google-Smtp-Source: ABdhPJz21HyDp/o9cS2Oy0NyPd8tLWOlgMXbKny2Io+bD6mLibPhpPc+3PAWu+3MznTiKUJjMQaAgQ==
X-Received: by 2002:a65:64c5:: with SMTP id t5mr6126051pgv.28.1594782768900;
        Tue, 14 Jul 2020 20:12:48 -0700 (PDT)
Received: from localhost.localdomain ([137.97.119.224])
        by smtp.gmail.com with ESMTPSA id 204sm466753pfx.3.2020.07.14.20.12.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jul 2020 20:12:48 -0700 (PDT)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, gnault@redhat.com
Cc:     Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCH net-next] bareudp: Reverted support to enable & disable rx metadata collection
Date:   Wed, 15 Jul 2020 08:42:40 +0530
Message-Id: <1594782760-5245-1-git-send-email-martinvarghesenokia@gmail.com>
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
 drivers/net/bareudp.c        | 21 +++++----------------
 include/uapi/linux/if_link.h |  1 -
 2 files changed, 5 insertions(+), 17 deletions(-)

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

