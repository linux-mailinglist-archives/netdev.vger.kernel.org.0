Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7954C7F04
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 01:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbiCAAMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 19:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiCAAMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 19:12:39 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C39C5FCB;
        Mon, 28 Feb 2022 16:11:59 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id z4so12943923pgh.12;
        Mon, 28 Feb 2022 16:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=09XsN4rfExAkHZg+2PwVtQHNLMj+my6oCIEBztgsuQc=;
        b=bDxspPCSBq60SZnxPCH/OaVus+ISJmj0AmpyvobPCh6OSsdou5s1DHcPAXIus7Ahbb
         I7MjQ2gUp9H8op/kCOw/KzfcAb8KUW1fOQZQcARiGX3ZzY6vgUCh9zq7otgYzfhwQBO1
         PXgS8b8baVLF6ZuOq4fFVqIoi+kwzK6fIeCCSZri13u9F8D16XQqGbRcjnLz42EcDGu/
         V7ZQhTnphDF0sWrbGuQLXevCV04Qobu1ESShTP3dy59mkhq6QO3iwiwUZEMsdgF8jI60
         KgxnM49oQUdIn4e0oym5rFNFsaybLDSa0FeiS7Vfwf9HME+oSX+0i1J8OxQu7Ncua/U9
         y94w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=09XsN4rfExAkHZg+2PwVtQHNLMj+my6oCIEBztgsuQc=;
        b=BvgshvCgizKKT4ICPU3YuCpQAgZ51qJBjhUCX1VFo5JZw9aYrcYOO5Qslhva5SLlR3
         98udE3k2a/WZkCFAz0PvQlNTyGbNKmDEKbT2eW9oGcX3mP/9NqRHm3qEm974XU4Oh4wW
         mXTZYTHRAThjUcYA+XyvCNje2C7r+5BJrkTepRiaHG5ZrB6SXhPjJas6d+pw1bRx5XV3
         QQurcYpAp0ETIqdmmsEkwcuCzdnkzAWHwD/xYjrXk4UhbOgz6teLhVLlo2zBl3Tfu4le
         QxsszD+Ybx+EzaUImR6gzlcYiQbvjjRIMxlCcIKWQooUnBfchk1lQfpfxu7aHR7p/7ZF
         ZuPA==
X-Gm-Message-State: AOAM5323woG/9IykElC1oVpgwvWDgg+M13/pINtAEesPot5RUryFInzG
        dP7LNmP/a0cNjbOg0A/kSoq5XDAeQIM=
X-Google-Smtp-Source: ABdhPJxepuwWp3gfRENA+xCkyfiYF/0GGQMDcrZ5cZjtt9mFbFl1VB/ezy7gnhVQL8lZB43aDcb1yA==
X-Received: by 2002:a62:8f87:0:b0:4cc:3f6:ca52 with SMTP id n129-20020a628f87000000b004cc03f6ca52mr24333518pfd.79.1646093518516;
        Mon, 28 Feb 2022 16:11:58 -0800 (PST)
Received: from jeffreyji1.c.googlers.com.com (180.145.227.35.bc.googleusercontent.com. [35.227.145.180])
        by smtp.gmail.com with ESMTPSA id w16-20020a056a0014d000b004e12fd48047sm15866915pfu.35.2022.02.28.16.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 16:11:57 -0800 (PST)
From:   Jeffrey Ji <jeffreyjilinux@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Brian Vazquez <brianvv@google.com>,
        jeffreyji <jeffreyji@google.com>
Subject: [PATCH net-next] net-core: add rx_otherhost_dropped counter
Date:   Tue,  1 Mar 2022 00:11:53 +0000
Message-Id: <20220301001153.1608374-1-jeffreyjilinux@gmail.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
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

From: jeffreyji <jeffreyji@google.com>

Increment rx_otherhost_dropped counter when packet dropped due to
mismatched dest MAC addr.

An example when this drop can occur is when manually crafting raw
packets that will be consumed by a user space application via a tap
device. For testing purposes local traffic was generated using trafgen
for the client and netcat to start a server

Tested: Created 2 netns, sent 1 packet using trafgen from 1 to the other
with "{eth(daddr=$INCORRECT_MAC...}", verified that iproute2 showed the
counter was incremented. (Also had to modify iproute2 to show the stat,
additional patch for that coming next.)

Signed-off-by: jeffreyji <jeffreyji@google.com>
---
 include/linux/netdevice.h    | 1 +
 include/uapi/linux/if_link.h | 5 +++++
 net/core/dev.c               | 2 ++
 net/ipv4/ip_input.c          | 1 +
 net/ipv6/ip6_input.c         | 1 +
 5 files changed, 10 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c79ee2296296..96c2030f4c1f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2025,6 +2025,7 @@ struct net_device {
 	atomic_long_t		rx_dropped;
 	atomic_long_t		tx_dropped;
 	atomic_long_t		rx_nohandler;
+	atomic_long_t		rx_otherhost_dropped;
 
 	/* Stats to monitor link on/off, flapping */
 	atomic_t		carrier_up_count;
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index be09d2ad4b5d..834382317889 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -211,6 +211,9 @@ struct rtnl_link_stats {
  * @rx_nohandler: Number of packets received on the interface
  *   but dropped by the networking stack because the device is
  *   not designated to receive packets (e.g. backup link in a bond).
+ *
+ * @rx_otherhost_dropped: Number of packets dropped due to mismatch in
+ * packet's destination MAC address.
  */
 struct rtnl_link_stats64 {
 	__u64	rx_packets;
@@ -243,6 +246,8 @@ struct rtnl_link_stats64 {
 	__u64	rx_compressed;
 	__u64	tx_compressed;
 	__u64	rx_nohandler;
+
+	__u64	rx_otherhost_dropped;
 };
 
 /* The struct should be in sync with struct ifmap */
diff --git a/net/core/dev.c b/net/core/dev.c
index 2d6771075720..d039d8fdc16a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10037,6 +10037,8 @@ struct rtnl_link_stats64 *dev_get_stats(struct net_device *dev,
 	storage->rx_dropped += (unsigned long)atomic_long_read(&dev->rx_dropped);
 	storage->tx_dropped += (unsigned long)atomic_long_read(&dev->tx_dropped);
 	storage->rx_nohandler += (unsigned long)atomic_long_read(&dev->rx_nohandler);
+	storage->rx_otherhost_dropped +=
+		(unsigned long)atomic_long_read(&dev->rx_otherhost_dropped);
 	return storage;
 }
 EXPORT_SYMBOL(dev_get_stats);
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index d94f9f7e60c3..ef97b0a4c77f 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -450,6 +450,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 	 * that it receives, do not try to analyse it.
 	 */
 	if (skb->pkt_type == PACKET_OTHERHOST) {
+		atomic_long_inc(&skb->dev->rx_otherhost_dropped);
 		drop_reason = SKB_DROP_REASON_OTHERHOST;
 		goto drop;
 	}
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index d4b1e2c5aa76..3f0cbe126d82 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -150,6 +150,7 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
 	struct inet6_dev *idev;
 
 	if (skb->pkt_type == PACKET_OTHERHOST) {
+		atomic_long_inc(&skb->dev->rx_otherhost_dropped);
 		kfree_skb(skb);
 		return NULL;
 	}
-- 
2.35.1.574.g5d30c73bfb-goog

