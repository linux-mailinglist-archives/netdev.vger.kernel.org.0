Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93562BA8E7
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 12:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgKTLWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 06:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgKTLWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 06:22:31 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5BCC0613CF
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 03:22:30 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id c9so10020084wml.5
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 03:22:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=BL3VFQ6Rlyw6xKgutRurTH+pUFWUhjWT8248JWBktNA=;
        b=fDVVoSsXGVbcIdXpCWkS9TuBUgAABvWw7oIws1xua+ub1JY3mRe5TwOvwsKW1ekKbf
         eXdR76IdEnq2bS60Tf3NwVgfEU1sT8NYIvl5rvT5A1e5enND+LTkilCQ+PvGs6hUBajn
         RNglIsFMY0x1fRhTPJrAXB3zTV9Tx1HleTofWDAbQpit00XVVM7RnsUhdwEv6mvKVqiU
         q9iLT/oIhrINS62+G2xtfMvGUqpAWGPDMXZJPQcLV1VKDHB8RnUL4xadRjqmuAxc9GB2
         3haX1NNz1xpt6QPgxC9mjFTLodOWg4neLKTBDAKIbkHT/aUZjphDqASDjh2MkObZ9XKh
         ZEtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=BL3VFQ6Rlyw6xKgutRurTH+pUFWUhjWT8248JWBktNA=;
        b=S60tGVXV+/BpnIo9Uh69H2r6d0HxB7hk41Qf/BK+o30spVGNk2ML1vsUVfS4/yJomN
         BwLD3XbLh7wHoASfsnuu66XL7g2z3HGS1EjWPhOx6S6ZokJ3+p7WZjNBQ5F0Rg+U7RHe
         4zJ3D0gy7OlEcVrC9hlodWHrR/HfusbSUOocYTuhluVfHFKcwhvT4nHGF7Su6D6+QtNS
         jUwibMRBsuTe0gQ6MJ3lSHNTgFsRrMDd5N/lCi6nFh9jBkAHB9zHqxcvbGbyh6xkoAAo
         haFpOA5kbv+3IaYZkvmJV7maw0zrkypTo0fSBwqgRe8v0sdIWzVZXjm02qxr/weeZbHQ
         orSQ==
X-Gm-Message-State: AOAM533lMajCVl+DljQpn05SVSLmHGosBfbkWI11IjpxI6aigxFnEnOY
        RnuAV+fm7el1+s7/2mz9bFZAb/s/SQUGIw==
X-Google-Smtp-Source: ABdhPJyS3LMRIrl9WKrP1IEWJaEWpYIf1aEyegBifj7vPyh1hNgemdKKqb+j/zbpTSB0h4vluvczkQ==
X-Received: by 2002:a1c:6405:: with SMTP id y5mr9332492wmb.150.1605871349452;
        Fri, 20 Nov 2020 03:22:29 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:f11f:867:e625:eb7a? (p200300ea8f232800f11f0867e625eb7a.dip0.t-ipconnect.de. [2003:ea:8f23:2800:f11f:867:e625:eb7a])
        by smtp.googlemail.com with ESMTPSA id h17sm5902068wrp.54.2020.11.20.03.22.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 03:22:28 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: bridge: switch to net core statistics counters
 handling
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     bridge@lists.linux-foundation.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <9bad2be2-fd84-7c6e-912f-cee433787018@gmail.com>
Date:   Fri, 20 Nov 2020 12:22:23 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev->tstats instead of a member of net_bridge for storing
a pointer to the per-cpu counters. This allows us to use core
functionality for statistics handling.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 net/bridge/br_device.c  | 31 +++++++++----------------------
 net/bridge/br_input.c   |  6 +-----
 net/bridge/br_private.h |  1 -
 3 files changed, 10 insertions(+), 28 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 77bcc8487..adb674a86 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -30,7 +30,6 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct net_bridge *br = netdev_priv(dev);
 	struct net_bridge_fdb_entry *dst;
 	struct net_bridge_mdb_entry *mdst;
-	struct pcpu_sw_netstats *brstats = this_cpu_ptr(br->stats);
 	const struct nf_br_ops *nf_ops;
 	u8 state = BR_STATE_FORWARDING;
 	const unsigned char *dest;
@@ -45,10 +44,7 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_OK;
 	}
 
-	u64_stats_update_begin(&brstats->syncp);
-	brstats->tx_packets++;
-	brstats->tx_bytes += skb->len;
-	u64_stats_update_end(&brstats->syncp);
+	dev_sw_netstats_tx_add(dev, 1, skb->len);
 
 	br_switchdev_frame_unmark(skb);
 	BR_INPUT_SKB_CB(skb)->brdev = dev;
@@ -119,26 +115,26 @@ static int br_dev_init(struct net_device *dev)
 	struct net_bridge *br = netdev_priv(dev);
 	int err;
 
-	br->stats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
-	if (!br->stats)
+	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
+	if (!dev->tstats)
 		return -ENOMEM;
 
 	err = br_fdb_hash_init(br);
 	if (err) {
-		free_percpu(br->stats);
+		free_percpu(dev->tstats);
 		return err;
 	}
 
 	err = br_mdb_hash_init(br);
 	if (err) {
-		free_percpu(br->stats);
+		free_percpu(dev->tstats);
 		br_fdb_hash_fini(br);
 		return err;
 	}
 
 	err = br_vlan_init(br);
 	if (err) {
-		free_percpu(br->stats);
+		free_percpu(dev->tstats);
 		br_mdb_hash_fini(br);
 		br_fdb_hash_fini(br);
 		return err;
@@ -146,7 +142,7 @@ static int br_dev_init(struct net_device *dev)
 
 	err = br_multicast_init_stats(br);
 	if (err) {
-		free_percpu(br->stats);
+		free_percpu(dev->tstats);
 		br_vlan_flush(br);
 		br_mdb_hash_fini(br);
 		br_fdb_hash_fini(br);
@@ -165,7 +161,7 @@ static void br_dev_uninit(struct net_device *dev)
 	br_vlan_flush(br);
 	br_mdb_hash_fini(br);
 	br_fdb_hash_fini(br);
-	free_percpu(br->stats);
+	free_percpu(dev->tstats);
 }
 
 static int br_dev_open(struct net_device *dev)
@@ -202,15 +198,6 @@ static int br_dev_stop(struct net_device *dev)
 	return 0;
 }
 
-static void br_get_stats64(struct net_device *dev,
-			   struct rtnl_link_stats64 *stats)
-{
-	struct net_bridge *br = netdev_priv(dev);
-
-	netdev_stats_to_stats64(stats, &dev->stats);
-	dev_fetch_sw_netstats(stats, br->stats);
-}
-
 static int br_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct net_bridge *br = netdev_priv(dev);
@@ -404,7 +391,7 @@ static const struct net_device_ops br_netdev_ops = {
 	.ndo_init		 = br_dev_init,
 	.ndo_uninit		 = br_dev_uninit,
 	.ndo_start_xmit		 = br_dev_xmit,
-	.ndo_get_stats64	 = br_get_stats64,
+	.ndo_get_stats64	 = dev_get_tstats64,
 	.ndo_set_mac_address	 = br_set_mac_address,
 	.ndo_set_rx_mode	 = br_dev_set_multicast_list,
 	.ndo_change_rx_flags	 = br_dev_change_rx_flags,
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 21808985f..8ca1f1bc6 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -35,12 +35,8 @@ static int br_pass_frame_up(struct sk_buff *skb)
 	struct net_device *indev, *brdev = BR_INPUT_SKB_CB(skb)->brdev;
 	struct net_bridge *br = netdev_priv(brdev);
 	struct net_bridge_vlan_group *vg;
-	struct pcpu_sw_netstats *brstats = this_cpu_ptr(br->stats);
 
-	u64_stats_update_begin(&brstats->syncp);
-	brstats->rx_packets++;
-	brstats->rx_bytes += skb->len;
-	u64_stats_update_end(&brstats->syncp);
+	dev_sw_netstats_rx_add(brdev, skb->len);
 
 	vg = br_vlan_group_rcu(br);
 	/* Bridge is just like any other port.  Make sure the
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 6f2818cb2..9a99af59b 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -385,7 +385,6 @@ struct net_bridge {
 	spinlock_t			hash_lock;
 	struct hlist_head		frame_type_list;
 	struct net_device		*dev;
-	struct pcpu_sw_netstats		__percpu *stats;
 	unsigned long			options;
 	/* These fields are accessed on each packet */
 #ifdef CONFIG_BRIDGE_VLAN_FILTERING
-- 
2.29.2


