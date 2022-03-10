Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80BFE4D3E1B
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 01:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239000AbiCJAaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 19:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239005AbiCJAaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 19:30:07 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1941124C34
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 16:29:04 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id z12-20020a17090ad78c00b001bf022b69d6so3778092pju.2
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 16:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Eo3id4mltdS6nMy0F8ZyU5fXOpJVIISYbsPHwatxSno=;
        b=MbbEg1q+vAkw7hpOpMccpEIO447jSgDC2+Bts+ga0Y4Q64dA4G/RGFibcb8/12HFzl
         ShYutYUsq/CtKOV6msCUdUXQBbrSjj2WcUKTKrkDeXq+DswykINL3UJD3a+QoQRiwhiN
         xAwS2oOxMdGmHUfTZf/6DOX5mdHOtF85V0wzx2kpXAAxBBsvsQDlcA2Oygj3cGeEITVi
         2Zlv3t3wi2Bl5wePSYqlchaBnWyIiSLcltTMA0aLrDv6LAoQBbmGdgeCSvcOj27UUmYG
         ELGpENIKMJAZJAQIwbZuk1bB9I1OiSU6/GKvgOw/Wb+lS1Hw3JsgJedd2GwgvbxV1v2p
         CZHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Eo3id4mltdS6nMy0F8ZyU5fXOpJVIISYbsPHwatxSno=;
        b=01dX6hUQQ4cOX2/R+odxDUkxZb/Sy8M/XN3nWIXazFws0KdnrVMEv+x5tHr+zWLp0D
         3TqILAafWpuvlqdf0+Tt81a/0oRMso+lfOQ8imuHXx1I1o3B4bEq10cfIRNHwFyQnCG2
         3/NKtC42H2BL6LXMLzZk67P/IwlRh51Xtx9YNVV99q/+MrkvQXAW5PWwKIWZlZ/dP35X
         ZZRfaveSAVoKg70sbZ9V3doGNizlRCE6lFb6qOhUYciCN4x/OqkMNDBySqcS6hQRsMr3
         iezmKtqqxFXMILMy8i/hRrHzrtsLaTj+rERtB2aKtt5nOUvDEbLEG3aru8sLfEtfADo0
         w6hg==
X-Gm-Message-State: AOAM530tIKJ6p/aObXe3iema9APGSbz7jtuBfGWkfkmDi/U1iw8O7gbe
        NEcq7SvMEH3Qt75Tf2rlA9o=
X-Google-Smtp-Source: ABdhPJyMbEqj/YFHH2XvZqnI6A24f31GWdHjtpafIlafHvhCn+T14UO261Fvx0+LwtbQdhgmx7Khjw==
X-Received: by 2002:a17:902:7b8d:b0:14b:8884:b4ad with SMTP id w13-20020a1709027b8d00b0014b8884b4admr2307202pll.120.1646872144209;
        Wed, 09 Mar 2022 16:29:04 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c7:6f77:9634:183c])
        by smtp.gmail.com with ESMTPSA id nv4-20020a17090b1b4400b001bf64a39579sm7557660pjb.4.2022.03.09.16.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 16:29:03 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v3 net-next 07/14] ipv6: add GRO_IPV6_MAX_SIZE
Date:   Wed,  9 Mar 2022 16:28:39 -0800
Message-Id: <20220310002846.460907-8-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
In-Reply-To: <20220310002846.460907-1-eric.dumazet@gmail.com>
References: <20220310002846.460907-1-eric.dumazet@gmail.com>
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

Enable GRO to have IPv6 specific limit for max packet size.

This patch introduces new dev->gro_ipv6_max_size
that is modifiable through ip link.

ip link set dev eth0 gro_ipv6_max_size 185000

Note that this value is only considered if bigger than
gro_max_size, and for non encapsulated TCP/ipv6 packets.

Signed-off-by: Coco Li <lixiaoyan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h          | 10 ++++++++++
 include/uapi/linux/if_link.h       |  1 +
 net/core/dev.c                     |  1 +
 net/core/gro.c                     | 20 ++++++++++++++++++--
 net/core/rtnetlink.c               | 15 +++++++++++++++
 tools/include/uapi/linux/if_link.h |  1 +
 6 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9ed348d8b6f1195514c3b5f85fbe2c45b3fa997f..771440f6f8a8fa6cdadd398be8f2bacb4841138c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1944,6 +1944,8 @@ enum netdev_ml_priv_type {
  *			keep a list of interfaces to be deleted.
  *	@gro_max_size:	Maximum size of aggregated packet in generic
  *			receive offload (GRO)
+ *	@gro_ipv6_max_size:	Maximum size of aggregated packet in generic
+ *				receive offload (GRO), for IPv6
  *
  *	@dev_addr_shadow:	Copy of @dev_addr to catch direct writes.
  *	@linkwatch_dev_tracker:	refcount tracker used by linkwatch.
@@ -2140,6 +2142,7 @@ struct net_device {
 	int			napi_defer_hard_irqs;
 #define GRO_MAX_SIZE		65536
 	unsigned int		gro_max_size;
+	unsigned int		gro_ipv6_max_size;
 	rx_handler_func_t __rcu	*rx_handler;
 	void __rcu		*rx_handler_data;
 
@@ -4910,6 +4913,13 @@ static inline void netif_set_gso_ipv6_max_size(struct net_device *dev,
 	WRITE_ONCE(dev->gso_ipv6_max_size, size);
 }
 
+static inline void netif_set_gro_ipv6_max_size(struct net_device *dev,
+					       unsigned int size)
+{
+	/* This pairs with the READ_ONCE() in skb_gro_receive() */
+	WRITE_ONCE(dev->gro_ipv6_max_size, size);
+}
+
 static inline void skb_gso_error_unwind(struct sk_buff *skb, __be16 protocol,
 					int pulled_hlen, u16 mac_offset,
 					int mac_len)
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 048a9c848a3a39596b6c3135553fdfb9a1fe37d2..9baa084fe2c6762b05029c4692cfd9c4646bb916 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -365,6 +365,7 @@ enum {
 	IFLA_GRO_MAX_SIZE,
 	IFLA_TSO_IPV6_MAX_SIZE,
 	IFLA_GSO_IPV6_MAX_SIZE,
+	IFLA_GRO_IPV6_MAX_SIZE,
 
 	__IFLA_MAX
 };
diff --git a/net/core/dev.c b/net/core/dev.c
index 87f8b8cb39a61c8f5a444e3b341a97ba0a4c06d9..9921cee9c20d2bc396ef1f4d783ac01604b1e8be 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10469,6 +10469,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev->gro_max_size = GRO_MAX_SIZE;
 	dev->tso_ipv6_max_size = GSO_MAX_SIZE;
 	dev->gso_ipv6_max_size = GSO_MAX_SIZE;
+	dev->gro_ipv6_max_size = GRO_MAX_SIZE;
 
 	dev->upper_level = 1;
 	dev->lower_level = 1;
diff --git a/net/core/gro.c b/net/core/gro.c
index ee5e7e889d8bdd8db18715afc7bb6c1c759c9c23..f795393a883b08d71bfcfbd2d897e1ddcddf6fce 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -136,11 +136,27 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 	unsigned int new_truesize;
 	struct sk_buff *lp;
 
+	if (unlikely(NAPI_GRO_CB(skb)->flush))
+		return -E2BIG;
+
 	/* pairs with WRITE_ONCE() in netif_set_gro_max_size() */
 	gro_max_size = READ_ONCE(p->dev->gro_max_size);
 
-	if (unlikely(p->len + len >= gro_max_size || NAPI_GRO_CB(skb)->flush))
-		return -E2BIG;
+	if (unlikely(p->len + len >= gro_max_size)) {
+		/* pairs with WRITE_ONCE() in netif_set_gro_ipv6_max_size() */
+		unsigned int gro6_max_size = READ_ONCE(p->dev->gro_ipv6_max_size);
+
+		if (gro6_max_size > gro_max_size &&
+		    p->protocol == htons(ETH_P_IPV6) &&
+		    skb_headroom(p) >= sizeof(struct hop_jumbo_hdr) &&
+		    ipv6_hdr(p)->nexthdr == IPPROTO_TCP &&
+		    !p->encapsulation)
+			gro_max_size = gro6_max_size;
+
+		if (p->len + len >= gro_max_size)
+			return -E2BIG;
+	}
+
 
 	lp = NAPI_GRO_CB(p)->last;
 	pinfo = skb_shinfo(lp);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 172de404c595c89e30651a091242a75be8f786b7..39c5a9fb792df3992b4e7177f4dfeba2553eaa08 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1029,6 +1029,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(4) /* IFLA_GRO_MAX_SIZE */
 	       + nla_total_size(4) /* IFLA_TSO_IPV6_MAX_SIZE */
 	       + nla_total_size(4) /* IFLA_GSO_IPV6_MAX_SIZE */
+	       + nla_total_size(4) /* IFLA_GRO_IPV6_MAX_SIZE */
 	       + nla_total_size(1) /* IFLA_OPERSTATE */
 	       + nla_total_size(1) /* IFLA_LINKMODE */
 	       + nla_total_size(4) /* IFLA_CARRIER_CHANGES */
@@ -1736,6 +1737,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	    nla_put_u32(skb, IFLA_GRO_MAX_SIZE, dev->gro_max_size) ||
 	    nla_put_u32(skb, IFLA_TSO_IPV6_MAX_SIZE, dev->tso_ipv6_max_size) ||
 	    nla_put_u32(skb, IFLA_GSO_IPV6_MAX_SIZE, dev->gso_ipv6_max_size) ||
+	    nla_put_u32(skb, IFLA_GRO_IPV6_MAX_SIZE, dev->gro_ipv6_max_size) ||
 #ifdef CONFIG_RPS
 	    nla_put_u32(skb, IFLA_NUM_RX_QUEUES, dev->num_rx_queues) ||
 #endif
@@ -1891,6 +1893,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_GRO_MAX_SIZE]	= { .type = NLA_U32 },
 	[IFLA_TSO_IPV6_MAX_SIZE]	= { .type = NLA_U32 },
 	[IFLA_GSO_IPV6_MAX_SIZE]	= { .type = NLA_U32 },
+	[IFLA_GRO_IPV6_MAX_SIZE]	= { .type = NLA_U32 },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -2786,6 +2789,15 @@ static int do_setlink(const struct sk_buff *skb,
 		}
 	}
 
+	if (tb[IFLA_GRO_IPV6_MAX_SIZE]) {
+		u32 max_size = nla_get_u32(tb[IFLA_GRO_IPV6_MAX_SIZE]);
+
+		if (dev->gro_ipv6_max_size ^ max_size) {
+			netif_set_gro_ipv6_max_size(dev, max_size);
+			status |= DO_SETLINK_MODIFIED;
+		}
+	}
+
 	if (tb[IFLA_GSO_MAX_SEGS]) {
 		u32 max_segs = nla_get_u32(tb[IFLA_GSO_MAX_SEGS]);
 
@@ -3264,6 +3276,9 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 	if (tb[IFLA_GSO_IPV6_MAX_SIZE])
 		netif_set_gso_ipv6_max_size(dev,
 			nla_get_u32(tb[IFLA_GSO_IPV6_MAX_SIZE]));
+	if (tb[IFLA_GRO_IPV6_MAX_SIZE])
+		netif_set_gro_ipv6_max_size(dev,
+			nla_get_u32(tb[IFLA_GRO_IPV6_MAX_SIZE]));
 
 	return dev;
 }
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index e40cd575607872d3bff3bc1971df8c6426290562..567008925a8be6900aa048c7ebb12684b2eebb4b 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -350,6 +350,7 @@ enum {
 	IFLA_GRO_MAX_SIZE,
 	IFLA_TSO_IPV6_MAX_SIZE,
 	IFLA_GSO_IPV6_MAX_SIZE,
+	IFLA_GRO_IPV6_MAX_SIZE,
 
 	__IFLA_MAX
 };
-- 
2.35.1.616.g0bdcbb4464-goog

