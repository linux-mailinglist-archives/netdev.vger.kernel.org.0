Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BABD4F6ABC
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 22:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbiDFUD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 16:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234313AbiDFUDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 16:03:02 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3290140F0;
        Wed,  6 Apr 2022 10:26:06 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id s11so2546434pla.8;
        Wed, 06 Apr 2022 10:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OpRrPrj0hVGfYMwxf5Njm8JCzZaHH6cAIbe6DteGsDY=;
        b=Q3noOigSRWCUt3Sn1T0KaLFQwubfl/RXMDlGut9K9uWvUKnJScaPQpDT1pXWG8Acx4
         tgOMUYEAR74LvDAEQ4TBM2J1H0bZxRRRf7fCwKGIsotvdFY9bgnhNxNMLCfSjchBRbaY
         USb+sAB3TH0IbNWDLT/kHeL9cACLbRiTItaxbwfMc+HyPL7EruitIeDqSmddGm0i6aAy
         tcnZ6q07F5DXkFdoRS2sTgAXloOreXd67Y1l6XyEwBYQzwdDZKlDx1BewqATmxiZtPdr
         Gczr4obOne+6XFVgP7HnNUqwzsJdzo/6JXpfQ9J6AhVOS9jPcbxYLibu8nFRuKo1vMk7
         uSPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OpRrPrj0hVGfYMwxf5Njm8JCzZaHH6cAIbe6DteGsDY=;
        b=HX051TabEmTzVUenAaXwZEDDPwLqCdBKZVhMgc7+/rzIavEpDciKcKYzw9JaG5Fpaz
         /8OUQMTDBZFUfEXyWR/CnbwS7Y+4WjnxTbSyKesLr4RavHg0yeLnIMngqwZMl3KD1U5l
         ys0C6KAhY3hCzSIO7dsDzqTUyOKRJKJcaDWobq/7VM7i08NVOgtQXQBCKDMO/nyMYVo/
         RDXRU3hoY437Wprp1O7LoAZINmY6UsKgv/dxHeq+ypxWtCaAJqdTmNQaYvLWugIWvSwX
         CI/6a15iyv62Eo/AKj7IRxB7Cc1bhPn15P3dvoKxiGx8/eWxRl0faKSAdy0lg2jhGHtr
         uy8g==
X-Gm-Message-State: AOAM532WCr3N6MNLwW1rCdSeA2O6M7kq7HXjUuv7+r7Py9Y8+RKWfM74
        2npGY8BeqssG7aGhX6ce7mU=
X-Google-Smtp-Source: ABdhPJyuAn1ofLtL6gk+Bn7fzyGJkS9OnhmFYuQZlGUMIJSqFCazgZgRNODa8zyTv+hQDvikQKK/Vw==
X-Received: by 2002:a17:902:ea52:b0:153:fd04:c158 with SMTP id r18-20020a170902ea5200b00153fd04c158mr9387286plg.83.1649265966314;
        Wed, 06 Apr 2022 10:26:06 -0700 (PDT)
Received: from jeffreyji1.c.googlers.com.com (180.145.227.35.bc.googleusercontent.com. [35.227.145.180])
        by smtp.gmail.com with ESMTPSA id 132-20020a62168a000000b004f40e8b3133sm20222468pfw.188.2022.04.06.10.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 10:26:05 -0700 (PDT)
From:   Jeffrey Ji <jeffreyjilinux@gmail.com>
To:     Brian Vazquez <brianvv@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Menglong Dong <imagedong@tencent.com>,
        Petr Machata <petrm@nvidia.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeffrey Ji <jeffreyji@google.com>
Subject: [PATCH net-next] net-core: rx_otherhost_dropped to core_stats
Date:   Wed,  6 Apr 2022 17:26:00 +0000
Message-Id: <20220406172600.1141083-1-jeffreyjilinux@gmail.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
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

From: Jeffrey Ji <jeffreyji@google.com>

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

Signed-off-by: Jeffrey Ji <jeffreyji@google.com>
---
 include/linux/netdevice.h    | 2 ++
 include/uapi/linux/if_link.h | 5 +++++
 net/core/dev.c               | 1 +
 net/ipv4/ip_input.c          | 1 +
 net/ipv6/ip6_input.c         | 1 +
 5 files changed, 10 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7b2a0b739684..9b2b9457e70f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -202,6 +202,7 @@ struct net_device_core_stats {
 	local_t		rx_dropped;
 	local_t		tx_dropped;
 	local_t		rx_nohandler;
+	local_t		rx_otherhost_dropped;
 } __aligned(4 * sizeof(local_t));
 
 #include <linux/cache.h>
@@ -3878,6 +3879,7 @@ static inline void dev_core_stats_##FIELD##_inc(struct net_device *dev)		\
 DEV_CORE_STATS_INC(rx_dropped)
 DEV_CORE_STATS_INC(tx_dropped)
 DEV_CORE_STATS_INC(rx_nohandler)
+DEV_CORE_STATS_INC(rx_otherhost_dropped)
 
 static __always_inline int ____dev_forward_skb(struct net_device *dev,
 					       struct sk_buff *skb,
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index cc284c048e69..d1e600816b82 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -211,6 +211,9 @@ struct rtnl_link_stats {
  * @rx_nohandler: Number of packets received on the interface
  *   but dropped by the networking stack because the device is
  *   not designated to receive packets (e.g. backup link in a bond).
+ *
+ * @rx_otherhost_dropped: Number of packets dropped due to mismatch
+ *   in destination MAC address.
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
 
 /* Subset of link stats useful for in-HW collection. Meaning of the fields is as
diff --git a/net/core/dev.c b/net/core/dev.c
index d5a362d53b34..68680d8474c7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10363,6 +10363,7 @@ struct rtnl_link_stats64 *dev_get_stats(struct net_device *dev,
 			storage->rx_dropped += local_read(&core_stats->rx_dropped);
 			storage->tx_dropped += local_read(&core_stats->tx_dropped);
 			storage->rx_nohandler += local_read(&core_stats->rx_nohandler);
+			storage->rx_otherhost_dropped += local_read(&core_stats->rx_otherhost_dropped);
 		}
 	}
 	return storage;
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 95f7bb052784..b1165f717cd1 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -451,6 +451,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 	 * that it receives, do not try to analyse it.
 	 */
 	if (skb->pkt_type == PACKET_OTHERHOST) {
+		dev_core_stats_rx_otherhost_dropped_inc(skb->dev);
 		drop_reason = SKB_DROP_REASON_OTHERHOST;
 		goto drop;
 	}
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 5b5ea35635f9..b4880c7c84eb 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -150,6 +150,7 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
 	struct inet6_dev *idev;
 
 	if (skb->pkt_type == PACKET_OTHERHOST) {
+		dev_core_stats_rx_otherhost_dropped_inc(skb->dev);
 		kfree_skb(skb);
 		return NULL;
 	}
-- 
2.35.1.1094.g7c7d902a7c-goog

