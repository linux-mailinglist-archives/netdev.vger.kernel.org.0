Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A09044CB39B
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 01:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbiCCAb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 19:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiCCAb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 19:31:26 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC7C887B7;
        Wed,  2 Mar 2022 16:30:40 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id mr24-20020a17090b239800b001bf0a375440so906558pjb.4;
        Wed, 02 Mar 2022 16:30:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TufDDGyoEGt9EY9DB5LHuZDJFxHU1L6lF561oF+pA9I=;
        b=alA/+1sHANIZdsAalvkJRrUEEd+j45Ydc60/ZHZVP7eFfs2QKe12vLdJQp6m/Nt7Ip
         IR6r7mdPStld60p/X32oJbNWJ43Y8HwiZzxWZciir0ctbX8RxGypi1UPxl+9Tzju8NkH
         kPCpKao5vZszOncd8Hp8S6J85kSZdNmrM2xsFuGlrTDM/xjHpyzp8WCpofsPeoMAogDe
         zaTdYa9WeVKSnQth7vKsGIu2TNXl+RLSvRo/tMNyVkrh3ximSKmCfJtOtTeSiMx7Ihro
         ITuMXAZ1LEbLCO9b5aCidl2uFd+iWkqg5ABg7bEYFHJZEv6SvtFUPs5PVxm5CG8DjJHM
         la3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TufDDGyoEGt9EY9DB5LHuZDJFxHU1L6lF561oF+pA9I=;
        b=sR+Sw2WBn0sTdzcvfdH2mCYBZ4Op0LrZ59xu+gxWIogY62kZpwtT9njQyCMbKqB+3U
         JHk9zccelks5pmDb/Tslb3xMhfnNgYHr8kFPgji7gg42qU9R3iBE/tc9C8aC13uCRT7w
         tJxQo+rw8xWsTJo1O/uHMS/Kq1WY9R7RM2f6AkeBiHG5r6OnkrD6Gpcdv5Qp1E2JGJTA
         6ee1sdu6nOVPgKWIsB3tNPfw+bdrgdM2M3UOeTV+JYXK2EQ4GVCASMLgdXhGiNHXvW8R
         0tKNYfbtmSJoVHkOJeo9X73ipeyjKraVxuvx7m1tR3An2Tm+81WoPlUsy3l6i/o//yY8
         QTQg==
X-Gm-Message-State: AOAM532k5/+EwO5kR+JH/iyGgRPadgeH7nQePrgqlOZJqQzngIA5yYvv
        BRCN4eZGLYpIgB85loVZZ7Q=
X-Google-Smtp-Source: ABdhPJy/JxOVyPt8UB3HRfwKitIGFCigp0jkcWJGgjbGoToIRptUOzdI8V2jL2SoRPKvNORHRkvDwQ==
X-Received: by 2002:a17:902:ed93:b0:14f:c84d:2448 with SMTP id e19-20020a170902ed9300b0014fc84d2448mr33917909plj.64.1646267439696;
        Wed, 02 Mar 2022 16:30:39 -0800 (PST)
Received: from jeffreyji1.c.googlers.com.com (180.145.227.35.bc.googleusercontent.com. [35.227.145.180])
        by smtp.gmail.com with ESMTPSA id e11-20020a63e00b000000b0037341d979b8sm267013pgh.94.2022.03.02.16.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 16:30:39 -0800 (PST)
From:   Jeffrey Ji <jeffreyjilinux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Brian Vazquez <brianvv@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffreyji <jeffreyji@google.com>
Subject: [PATCH v2 net-next] net-core: add rx_otherhost_dropped counter
Date:   Thu,  3 Mar 2022 00:30:34 +0000
Message-Id: <20220303003034.1906898-1-jeffreyjilinux@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
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

changelog:

v2: add kdoc comment

Signed-off-by: jeffreyji <jeffreyji@google.com>
---
 include/linux/netdevice.h    | 3 +++
 include/uapi/linux/if_link.h | 5 +++++
 net/core/dev.c               | 2 ++
 net/ipv4/ip_input.c          | 1 +
 net/ipv6/ip6_input.c         | 1 +
 5 files changed, 12 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c79ee2296296..e4073c38bd77 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1741,6 +1741,8 @@ enum netdev_ml_priv_type {
  *			do not use this in drivers
  *	@rx_nohandler:	nohandler dropped packets by core network on
  *			inactive devices, do not use this in drivers
+ *	@rx_otherhost_dropped:	Dropped packets due to mismatch in packet dest
+ *				MAC address
  *	@carrier_up_count:	Number of times the carrier has been up
  *	@carrier_down_count:	Number of times the carrier has been down
  *
@@ -2025,6 +2027,7 @@ struct net_device {
 	atomic_long_t		rx_dropped;
 	atomic_long_t		tx_dropped;
 	atomic_long_t		rx_nohandler;
+	atomic_long_t		rx_otherhost_dropped;
 
 	/* Stats to monitor link on/off, flapping */
 	atomic_t		carrier_up_count;
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index e315e53125f4..17e74385fca8 100644
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
2.35.1.616.g0bdcbb4464-goog

