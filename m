Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6AC4CC4E2
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 19:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235657AbiCCSRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 13:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235660AbiCCSRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 13:17:17 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E671A3617
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 10:16:29 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id p17so5317829plo.9
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 10:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IX+M6tDVbg8jUl5LHYUbr6tm03uFa1bXyWjazq7LLo8=;
        b=GixwPq3e5UxljxBIjeQmahGwQWxkJrR7lbk0K+ivYAV256Px7DNVebSp46zDO0eCjz
         6dLGc7ojMAwgAKCEU1XMn1v5A4oCk1eDNt0Vh/AcoD1AMILdSAPaKCPwTTf1tzQ7Hu7Z
         8N9ts3cHGUsEOOLc7Fpb5xwZCnQVNSQMpOvWFI5uveHsHuombLHrZXyOL08ljw/NMyW0
         WOrFa3eCqmK//+9njIMb8YDjRKpPwSR9xiyFJhRTVYqCc6URkqED7qrRDYM2IG9bI8nH
         xT9rxDEGCrvWko2PDDl1dqhlocZVlFYy0vl95cnjUtxwsoXJLy+kZS71VYT15eBx2Tl3
         tSqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IX+M6tDVbg8jUl5LHYUbr6tm03uFa1bXyWjazq7LLo8=;
        b=UH9T5Iw0zV1MJa6SuSgvOkEObnJj9+pV5BltCMHJVnSDs4XMRNdw7TGg6GcYVKR3gv
         NLC2b6I/FC4XxvbXjjoZVlFWaHWsEI7uLMZBrwWWzEgHHkG7GIW6XnLTq3B6d1Sgja04
         cjS9uxcwyxEEWxxCR2x+mOIvKnCUMzHyNDg7cF3iLHUnWa/Me1xVNDbs2XnzT4qbOfYa
         lmSM3s4gdvtLlJNOW7eiWIBqH8kXOHVp/1Jmr4Mr9jEOSeNwf69iCU1dLJqgwCSLyxDE
         +GybmnZavjZZtWEUmYZZ09m10IV20szzv3gcwH1hrIRnc0eVBiDkzB8sVEWk4CvVOaMS
         jExw==
X-Gm-Message-State: AOAM533lahSuUIWb+nb6nTUrcKeSjXCmRmvdDmgXcKfciEO8Tn7xFl0i
        e3tYOk1He0DGp7Cd/8oyMVI=
X-Google-Smtp-Source: ABdhPJwpdMYk0oNpt0JChS2BYjLZrGvAdS1ZxIc5yss6VBw5ppt19cB19tWXbMiE2EAYOUvtZK8pzw==
X-Received: by 2002:a17:902:cf0e:b0:14f:8a60:475c with SMTP id i14-20020a170902cf0e00b0014f8a60475cmr37130912plg.146.1646331388555;
        Thu, 03 Mar 2022 10:16:28 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5388:c313:5e37:a261])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090adb4e00b001bee5dd39basm7611016pjx.1.2022.03.03.10.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 10:16:28 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        David Ahern <dsahern@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 02/14] ipv6: add dev->gso_ipv6_max_size
Date:   Thu,  3 Mar 2022 10:15:55 -0800
Message-Id: <20220303181607.1094358-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
In-Reply-To: <20220303181607.1094358-1-eric.dumazet@gmail.com>
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
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

From: Coco Li <lixiaoyan@google.com>

This enable TCP stack to build TSO packets bigger than
64KB if the driver is LSOv2 compatible.

This patch introduces new variable gso_ipv6_max_size
that is modifiable through ip link.

ip link set dev eth0 gso_ipv6_max_size 185000

User input is capped by driver limit (tso_ipv6_max_size)
added in previous patch.

Signed-off-by: Coco Li <lixiaoyan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h          | 12 ++++++++++++
 include/uapi/linux/if_link.h       |  1 +
 net/core/dev.c                     |  1 +
 net/core/rtnetlink.c               | 15 +++++++++++++++
 net/core/sock.c                    |  6 ++++++
 tools/include/uapi/linux/if_link.h |  1 +
 6 files changed, 36 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3b59359b5e4d35f40fb90d594e78cb88befbbcbf..6d559a0c4abd7cd1f5ee90e0c303fe9331a27841 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1952,6 +1952,7 @@ enum netdev_ml_priv_type {
  *					registered
  *	@offload_xstats_l3:	L3 HW stats for this netdevice.
  *	@tso_ipv6_max_size:	Maximum size of IPv6 TSO packets (driver/NIC limit)
+ *	@gso_ipv6_max_size:	Maximum size of IPv6 GSO packets (user/admin limit)
  *
  *	FIXME: cleanup struct net_device such that network protocol info
  *	moves out.
@@ -2291,6 +2292,7 @@ struct net_device {
 	netdevice_tracker	dev_registered_tracker;
 	struct rtnl_hw_stats64	*offload_xstats_l3;
 	unsigned int		tso_ipv6_max_size;
+	unsigned int		gso_ipv6_max_size;
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
@@ -4884,6 +4886,10 @@ static inline void netif_set_gso_max_size(struct net_device *dev,
 {
 	/* dev->gso_max_size is read locklessly from sk_setup_caps() */
 	WRITE_ONCE(dev->gso_max_size, size);
+
+	/* legacy drivers want to lower gso_max_size, regardless of family. */
+	size = min(size, dev->gso_ipv6_max_size);
+	WRITE_ONCE(dev->gso_ipv6_max_size, size);
 }
 
 static inline void netif_set_gso_max_segs(struct net_device *dev,
@@ -4907,6 +4913,12 @@ static inline void netif_set_tso_ipv6_max_size(struct net_device *dev,
 	dev->tso_ipv6_max_size = size;
 }
 
+static inline void netif_set_gso_ipv6_max_size(struct net_device *dev,
+					       unsigned int size)
+{
+	size = min(size, dev->tso_ipv6_max_size);
+	WRITE_ONCE(dev->gso_ipv6_max_size, size);
+}
 
 static inline void skb_gso_error_unwind(struct sk_buff *skb, __be16 protocol,
 					int pulled_hlen, u16 mac_offset,
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index c8af031b692e52690a2760e9d79c9462185e2fc9..048a9c848a3a39596b6c3135553fdfb9a1fe37d2 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -364,6 +364,7 @@ enum {
 	IFLA_PARENT_DEV_BUS_NAME,
 	IFLA_GRO_MAX_SIZE,
 	IFLA_TSO_IPV6_MAX_SIZE,
+	IFLA_GSO_IPV6_MAX_SIZE,
 
 	__IFLA_MAX
 };
diff --git a/net/core/dev.c b/net/core/dev.c
index aa37d3f2ca1afe53b05b7d71be1dbdccaeca4f6b..7dbedec0903279ece0cb1199969f732a4dc35cd2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10462,6 +10462,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev->gso_max_segs = GSO_MAX_SEGS;
 	dev->gro_max_size = GRO_MAX_SIZE;
 	dev->tso_ipv6_max_size = GSO_MAX_SIZE;
+	dev->gso_ipv6_max_size = GSO_MAX_SIZE;
 
 	dev->upper_level = 1;
 	dev->lower_level = 1;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 864c411c124040e2076289f8714f8b043563408c..a60efa6d0fac1b9ce209126bad946a3d2bd24ac3 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1028,6 +1028,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(4) /* IFLA_GSO_MAX_SIZE */
 	       + nla_total_size(4) /* IFLA_GRO_MAX_SIZE */
 	       + nla_total_size(4) /* IFLA_TSO_IPV6_MAX_SIZE */
+	       + nla_total_size(4) /* IFLA_GSO_IPV6_MAX_SIZE */
 	       + nla_total_size(1) /* IFLA_OPERSTATE */
 	       + nla_total_size(1) /* IFLA_LINKMODE */
 	       + nla_total_size(4) /* IFLA_CARRIER_CHANGES */
@@ -1734,6 +1735,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	    nla_put_u32(skb, IFLA_GSO_MAX_SIZE, dev->gso_max_size) ||
 	    nla_put_u32(skb, IFLA_GRO_MAX_SIZE, dev->gro_max_size) ||
 	    nla_put_u32(skb, IFLA_TSO_IPV6_MAX_SIZE, dev->tso_ipv6_max_size) ||
+	    nla_put_u32(skb, IFLA_GSO_IPV6_MAX_SIZE, dev->gso_ipv6_max_size) ||
 #ifdef CONFIG_RPS
 	    nla_put_u32(skb, IFLA_NUM_RX_QUEUES, dev->num_rx_queues) ||
 #endif
@@ -1888,6 +1890,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_PARENT_DEV_NAME]	= { .type = NLA_NUL_STRING },
 	[IFLA_GRO_MAX_SIZE]	= { .type = NLA_U32 },
 	[IFLA_TSO_IPV6_MAX_SIZE]	= { .type = NLA_U32 },
+	[IFLA_GSO_IPV6_MAX_SIZE]	= { .type = NLA_U32 },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -2774,6 +2777,15 @@ static int do_setlink(const struct sk_buff *skb,
 		}
 	}
 
+	if (tb[IFLA_GSO_IPV6_MAX_SIZE]) {
+		u32 max_size = nla_get_u32(tb[IFLA_GSO_IPV6_MAX_SIZE]);
+
+		if (dev->gso_ipv6_max_size ^ max_size) {
+			netif_set_gso_ipv6_max_size(dev, max_size);
+			status |= DO_SETLINK_MODIFIED;
+		}
+	}
+
 	if (tb[IFLA_GSO_MAX_SEGS]) {
 		u32 max_segs = nla_get_u32(tb[IFLA_GSO_MAX_SEGS]);
 
@@ -3249,6 +3261,9 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 		netif_set_gso_max_segs(dev, nla_get_u32(tb[IFLA_GSO_MAX_SEGS]));
 	if (tb[IFLA_GRO_MAX_SIZE])
 		netif_set_gro_max_size(dev, nla_get_u32(tb[IFLA_GRO_MAX_SIZE]));
+	if (tb[IFLA_GSO_IPV6_MAX_SIZE])
+		netif_set_gso_ipv6_max_size(dev,
+			nla_get_u32(tb[IFLA_GSO_IPV6_MAX_SIZE]));
 
 	return dev;
 }
diff --git a/net/core/sock.c b/net/core/sock.c
index 784c92eaded89fdb55be0ad11dd2dadc8548814b..7cd83bea205849ba7c3ee420d5a5e54ceff9979a 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2279,6 +2279,12 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 			sk->sk_route_caps |= NETIF_F_SG | NETIF_F_HW_CSUM;
 			/* pairs with the WRITE_ONCE() in netif_set_gso_max_size() */
 			sk->sk_gso_max_size = READ_ONCE(dst->dev->gso_max_size);
+#if IS_ENABLED(CONFIG_IPV6)
+			if (sk->sk_family == AF_INET6 &&
+			    sk_is_tcp(sk) &&
+			    !ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr))
+				sk->sk_gso_max_size = READ_ONCE(dst->dev->gso_ipv6_max_size);
+#endif
 			sk->sk_gso_max_size -= (MAX_TCP_HEADER + 1);
 			/* pairs with the WRITE_ONCE() in netif_set_gso_max_segs() */
 			max_segs = max_t(u32, READ_ONCE(dst->dev->gso_max_segs), 1);
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 441615c39f0a24eeeb6e27b4ca88031bcc234cf8..e40cd575607872d3bff3bc1971df8c6426290562 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -349,6 +349,7 @@ enum {
 	IFLA_PARENT_DEV_BUS_NAME,
 	IFLA_GRO_MAX_SIZE,
 	IFLA_TSO_IPV6_MAX_SIZE,
+	IFLA_GSO_IPV6_MAX_SIZE,
 
 	__IFLA_MAX
 };
-- 
2.35.1.616.g0bdcbb4464-goog

