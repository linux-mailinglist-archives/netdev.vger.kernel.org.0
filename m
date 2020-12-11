Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB512D7599
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 13:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405952AbgLKM3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 07:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405464AbgLKM1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 07:27:40 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE7DC061282
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:25 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id a8so13082624lfb.3
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dM12+Q/bakrS1tkrkdKbft7ySXKZKzkcL4AuLlZcx7o=;
        b=svHECUKDhhbfHcRJ5ys5kJ8uINtvptz1g7jOX3D9gxJisvLRcUUwc14TgpTYTthorX
         dp4vz0EEFDfvp9xyOWupe4rWrwA4eQ2WVduNc3a8QFrVNtX1CQFuiq/4QRgOHVPzD1Jb
         D33P7HSz5n2IZdSfxVLXzJ6RUILvlss5p7qMgLVbYZ1G0Zj/RDfOFLW1uYRlKSgUvnLf
         n/9ljyuEixF8CPIgYEUU4DLEwUQug7A3uPY3ofccKG5qO4qmOnMlPXYZz0m8CqOh/vpO
         We5Q8IZO942B2LpN3wHPFVjVeuVaEX8o25Pc3+DkvnVjzWAatNEPeduBsi/nTgH8NTHI
         s6VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dM12+Q/bakrS1tkrkdKbft7ySXKZKzkcL4AuLlZcx7o=;
        b=ro1CmK/1iPNQwik4K5rPK2fdAzi38HVzoVVOX21iF8duV+6yffO8cTz6IA+w0MC+C1
         eudKtMNZiuFOgb9kXOfeq2WY9e/832Up3zJXRAMXqSWXsvwSSPp/wV9+mxf8ptZJNaFe
         HQQxKZ1nmDjzSuGvTvkJyuvMcL5WelfCyBhyHGdflv4USgJFOn+LfS03aLEgZEyYbVXe
         MSFW6oy+nzQI6X+hEQDmSYhhZfxt60fm73q3GAzYO5ccbrs/Qt8pW2b/z5HUA2cSrjC6
         RhI7jpady0QEz7PTSjWkTPAjTwf1weJTo3XFqsx8fUZug06A88WaxfePz+YKSnOSvzMU
         ZeNw==
X-Gm-Message-State: AOAM530Vhsf6zgqSgVf6WVAPt85UBmEyT1kOiivKb7rb7l4OXqrtDKyP
        oHBd85qpbX3dzJHVhKdVSWTM5cGlQdJ1mw==
X-Google-Smtp-Source: ABdhPJwXotUp6myNv1HC8YIfXNQp+h/St7VzGop3mK6xpyrpcswqT6m8EQyVKISrEpgfJ1opfyyD5A==
X-Received: by 2002:ac2:48a5:: with SMTP id u5mr2319522lfg.97.1607689583051;
        Fri, 11 Dec 2020 04:26:23 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id s8sm335818lfi.21.2020.12.11.04.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 04:26:22 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, laforge@gnumonks.org,
        Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next v2 10/12] gtp: add IPv6 support
Date:   Fri, 11 Dec 2020 13:26:10 +0100
Message-Id: <20201211122612.869225-11-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201211122612.869225-1-jonas@norrbonn.se>
References: <20201211122612.869225-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for handling IPv6.  Both the GTP tunnel and the
tunneled packets may be IPv6; as they constitute independent streams,
both v4-over-v6 and v6-over-v4 are supported, as well.

This patch includes only the driver functionality for IPv6 support.  A
follow-on patch will add support for configuring the tunnels with IPv6
addresses.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 drivers/net/gtp.c | 330 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 269 insertions(+), 61 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 86639fae8d45..4c902bffefa3 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -3,6 +3,7 @@
  *
  * (C) 2012-2014 by sysmocom - s.f.m.c. GmbH
  * (C) 2016 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2020 by Jonas Bonn <jonas@norrbonn.se>
  *
  * Author: Harald Welte <hwelte@sysmocom.de>
  *	   Pablo Neira Ayuso <pablo@netfilter.org>
@@ -20,6 +21,7 @@
 #include <linux/net.h>
 #include <linux/file.h>
 #include <linux/gtp.h>
+#include <linux/ipv6.h>
 
 #include <net/net_namespace.h>
 #include <net/protocol.h>
@@ -33,6 +35,11 @@
 #include <net/netns/generic.h>
 #include <net/gtp.h>
 
+#define PDP_F_PEER_V6 (1 << 0)
+#define PDP_F_MS_V6   (1 << 1)
+
+#define ipv4(in6addr) ((in6addr)->s6_addr32[3])
+
 /* An active session for the subscriber. */
 struct pdp_ctx {
 	struct hlist_node	hlist_tid;
@@ -49,10 +56,10 @@ struct pdp_ctx {
 		} v1;
 	} u;
 	u8			gtp_version;
-	u16			af;
+	u16			flags;
 
-	struct in_addr		ms_addr_ip4;
-	struct in_addr		peer_addr_ip4;
+	struct in6_addr		ms_addr;
+	struct in6_addr		peer_addr;
 
 	struct sock		*sk;
 	struct net_device       *dev;
@@ -97,9 +104,23 @@ static inline u32 gtp1u_hashfn(u32 tid)
 	return jhash_1word(tid, gtp_h_initval);
 }
 
+static inline u32 ip_hashfn(struct in6_addr *ip)
+{
+	return __ipv6_addr_jhash(ip, gtp_h_initval);
+}
+
+static inline u32 ipv6_hashfn(struct in6_addr *ip)
+{
+	return ip_hashfn(ip);
+}
+
 static inline u32 ipv4_hashfn(__be32 ip)
 {
-	return jhash_1word((__force u32)ip, gtp_h_initval);
+	struct in6_addr addr;
+
+	ipv6_addr_set_v4mapped(ip, &addr);
+
+	return ipv6_hashfn(&addr);
 }
 
 /* Resolve a PDP context structure based on the 64bit TID. */
@@ -134,23 +155,42 @@ static struct pdp_ctx *gtp1_pdp_find(struct gtp_dev *gtp, u32 tid)
 	return NULL;
 }
 
-/* Resolve a PDP context based on IPv4 address of MS. */
-static struct pdp_ctx *ipv4_pdp_find(struct gtp_dev *gtp, __be32 ms_addr)
+static struct pdp_ctx *ip_pdp_find(struct gtp_dev *gtp,
+					struct in6_addr *ms_addr)
 {
 	struct hlist_head *head;
 	struct pdp_ctx *pdp;
 
-	head = &gtp->addr_hash[ipv4_hashfn(ms_addr) % gtp->hash_size];
+	head = &gtp->addr_hash[ipv6_hashfn(ms_addr) % gtp->hash_size];
 
 	hlist_for_each_entry_rcu(pdp, head, hlist_addr) {
-		if (pdp->af == AF_INET &&
-		    pdp->ms_addr_ip4.s_addr == ms_addr)
+		if (ipv6_addr_equal(&pdp->ms_addr, ms_addr))
 			return pdp;
 	}
 
 	return NULL;
 }
 
+/* Resolve a PDP context based on IPv6 address of MS. */
+static struct pdp_ctx *ipv6_pdp_find(struct gtp_dev *gtp,
+					struct in6_addr *ms_addr)
+{
+	return ip_pdp_find(gtp, ms_addr);
+}
+
+/* Resolve a PDP context based on IPv4 address of MS. */
+static struct pdp_ctx *ipv4_pdp_find(struct gtp_dev *gtp, __be32 ms_addr)
+{
+	struct in6_addr addr;
+
+	ipv6_addr_set_v4mapped(ms_addr, &addr);
+
+	return ip_pdp_find(gtp, &addr);
+}
+
+/* Check if the inner IP address in this packet is assigned to any
+ * existing mobile subscriber.
+ */
 static bool gtp_check_ms_ipv4(struct sk_buff *skb, struct pdp_ctx *pctx,
 				  unsigned int hdrlen, unsigned int role)
 {
@@ -162,28 +202,51 @@ static bool gtp_check_ms_ipv4(struct sk_buff *skb, struct pdp_ctx *pctx,
 	iph = (struct iphdr *)(skb->data + hdrlen);
 
 	if (role == GTP_ROLE_SGSN)
-		return iph->daddr == pctx->ms_addr_ip4.s_addr;
+		return iph->daddr == ipv4(&pctx->ms_addr);
 	else
-		return iph->saddr == pctx->ms_addr_ip4.s_addr;
+		return iph->saddr == ipv4(&pctx->ms_addr);
 }
 
-/* Check if the inner IP address in this packet is assigned to any
- * existing mobile subscriber.
- */
-static bool gtp_check_ms(struct sk_buff *skb, struct pdp_ctx *pctx,
-			     unsigned int hdrlen, unsigned int role)
+static bool gtp_check_ms_ipv6(struct sk_buff *skb, struct pdp_ctx *pctx,
+				  unsigned int hdrlen, unsigned int role)
 {
-	switch (ntohs(skb->protocol)) {
-	case ETH_P_IP:
-		return gtp_check_ms_ipv4(skb, pctx, hdrlen, role);
-	}
-	return false;
+	struct ipv6hdr *iph;
+
+	if (!pskb_may_pull(skb, hdrlen + sizeof(struct ipv6hdr)))
+		return false;
+
+	iph = (struct ipv6hdr *)(skb->data + hdrlen);
+
+	if (role == GTP_ROLE_SGSN)
+		return ipv6_addr_equal(&iph->daddr, &pctx->ms_addr);
+	else
+		return ipv6_addr_equal(&iph->saddr, &pctx->ms_addr);
 }
 
 static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
 			unsigned int hdrlen, unsigned int role)
 {
-	if (!gtp_check_ms(skb, pctx, hdrlen, role)) {
+	uint8_t ipver;
+	int r;
+
+	if (!pskb_may_pull(skb, hdrlen + 1))
+		return false;
+
+	/* Get IP version of _inner_ packet */
+	ipver = inner_ip_hdr(skb)->version;
+
+	switch (ipver) {
+	case 4:
+		skb_set_inner_protocol(skb, cpu_to_be16(ETH_P_IP));
+		r = gtp_check_ms_ipv4(skb, pctx, hdrlen, role);
+		break;
+	case 6:
+		skb_set_inner_protocol(skb, cpu_to_be16(ETH_P_IPV6));
+		r = gtp_check_ms_ipv6(skb, pctx, hdrlen, role);
+		break;
+	}
+
+	if (!r) {
 		netdev_dbg(pctx->dev, "No PDP ctx for this MS\n");
 		return 1;
 	}
@@ -193,6 +256,8 @@ static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
 				 !net_eq(sock_net(pctx->sk), dev_net(pctx->dev))))
 		return -1;
 
+	skb->protocol = skb->inner_protocol;
+
 	netdev_dbg(pctx->dev, "forwarding packet from GGSN to uplink\n");
 
 	/* Now that the UDP and the GTP header have been removed, set up the
@@ -201,7 +266,7 @@ static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
 	 */
 	skb_reset_network_header(skb);
 
-	skb->dev = pctx->dev;
+	__skb_tunnel_rx(skb, pctx->dev, sock_net(pctx->sk));
 
 	dev_sw_netstats_rx_add(pctx->dev, skb->len);
 
@@ -220,7 +285,9 @@ static int gtp0_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 	if (!pskb_may_pull(skb, hdrlen))
 		return -1;
 
-	gtp0 = (struct gtp0_header *)(skb->data + sizeof(struct udphdr));
+	skb_set_inner_network_header(skb, skb_transport_offset(skb) + hdrlen);
+
+	gtp0 = (struct gtp0_header *)&udp_hdr(skb)[1];
 
 	if ((gtp0->flags >> 5) != GTP_V0)
 		return 1;
@@ -247,7 +314,9 @@ static int gtp1u_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 	if (!pskb_may_pull(skb, hdrlen))
 		return -1;
 
-	gtp1 = (struct gtp1_header *)(skb->data + sizeof(struct udphdr));
+	skb_set_inner_network_header(skb, skb_transport_offset(skb) + hdrlen);
+
+	gtp1 = (struct gtp1_header *)&udp_hdr(skb)[1];
 
 	if ((gtp1->flags >> 5) != GTP_V1)
 		return 1;
@@ -264,12 +333,10 @@ static int gtp1u_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 	if (gtp1->flags & GTP1_F_MASK)
 		hdrlen += 4;
 
-	/* Make sure the header is larger enough, including extensions. */
+	/* Make sure the header is large enough, including extensions. */
 	if (!pskb_may_pull(skb, hdrlen))
 		return -1;
 
-	gtp1 = (struct gtp1_header *)(skb->data + sizeof(struct udphdr));
-
 	pctx = gtp1_pdp_find(gtp, ntohl(gtp1->tid));
 	if (!pctx) {
 		netdev_dbg(gtp->dev, "No PDP ctx to decap skb=%p\n", skb);
@@ -515,7 +582,7 @@ static struct rtable *gtp_get_v4_rt(struct sk_buff *skb,
 
 	memset(&fl4, 0, sizeof(fl4));
 	fl4.flowi4_oif		= sk->sk_bound_dev_if;
-	fl4.daddr		= pctx->peer_addr_ip4.s_addr;
+	fl4.daddr		= ipv4(&pctx->peer_addr);
 	fl4.saddr		= inet_sk(sk)->inet_saddr;
 	fl4.flowi4_tos		= RT_CONN_FLAGS(sk);
 	fl4.flowi4_proto	= sk->sk_protocol;
@@ -536,6 +603,36 @@ static struct rtable *gtp_get_v4_rt(struct sk_buff *skb,
 	return rt;
 }
 
+static struct dst_entry *gtp_get_v6_dst(struct sk_buff *skb,
+					struct net_device *dev,
+					struct pdp_ctx *pctx,
+					struct in6_addr *saddr)
+{
+	const struct sock *sk = pctx->sk;
+	struct dst_entry *dst = NULL;
+	struct flowi6 fl6;
+
+	memset(&fl6, 0, sizeof(fl6));
+	fl6.flowi6_mark = skb->mark;
+	fl6.flowi6_proto = IPPROTO_UDP;
+	fl6.daddr = pctx->peer_addr;
+
+	dst = ipv6_stub->ipv6_dst_lookup_flow(sock_net(sk), sk, &fl6, NULL);
+	if (IS_ERR(dst)) {
+		netdev_dbg(pctx->dev, "no route to %pI6\n", &fl6.daddr);
+		return ERR_PTR(-ENETUNREACH);
+	}
+	if (dst->dev == pctx->dev) {
+		netdev_dbg(pctx->dev, "circular route to %pI6\n", &fl6.daddr);
+		dst_release(dst);
+		return ERR_PTR(-ELOOP);
+	}
+
+	*saddr = fl6.saddr;
+
+	return dst;
+}
+
 static inline void gtp0_push_header(struct sk_buff *skb, struct pdp_ctx *pctx)
 {
 	int payload_len = skb->len;
@@ -591,10 +688,9 @@ static void gtp_push_header(struct sk_buff *skb, struct pdp_ctx *pctx,
 	}
 }
 
-static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
+static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev,
+			struct pdp_ctx* pctx)
 {
-	struct gtp_dev *gtp = netdev_priv(dev);
-	struct pdp_ctx *pctx;
 	struct rtable *rt;
 	__be32 saddr;
 	struct iphdr *iph;
@@ -602,22 +698,6 @@ static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
 	__be16 sport, port;
 	int r;
 
-	/* Read the IP destination address and resolve the PDP context.
-	 * Prepend PDP header with TEI/TID from PDP ctx.
-	 */
-	iph = ip_hdr(skb);
-	if (gtp->role == GTP_ROLE_SGSN)
-		pctx = ipv4_pdp_find(gtp, iph->saddr);
-	else
-		pctx = ipv4_pdp_find(gtp, iph->daddr);
-
-	if (!pctx) {
-		netdev_dbg(dev, "no PDP ctx found for %pI4, skip\n",
-			   &iph->daddr);
-		return -ENOENT;
-	}
-	netdev_dbg(dev, "found PDP context %p\n", pctx);
-
 	rt = gtp_get_v4_rt(skb, dev, pctx, &saddr);
 	if (IS_ERR(rt)) {
 		if (PTR_ERR(rt) == -ENETUNREACH)
@@ -671,7 +751,7 @@ static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
 		   &iph->saddr, &iph->daddr);
 
 	udp_tunnel_xmit_skb(rt, pctx->sk, skb,
-			    saddr, pctx->peer_addr_ip4.s_addr,
+			    saddr, ipv4(&pctx->peer_addr),
 			    iph->tos,
 			    ip4_dst_hoplimit(&rt->dst),
 			    0,
@@ -686,9 +766,130 @@ static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
 	return -EBADMSG;
 }
 
+static int gtp_xmit_ip6(struct sk_buff *skb, struct net_device *dev,
+			struct pdp_ctx* pctx)
+{
+	struct dst_entry *dst;
+	struct in6_addr saddr;
+	struct ipv6hdr *iph;
+	int headroom;
+	__be16 sport, port;
+	int r;
+
+	dst = gtp_get_v6_dst(skb, dev, pctx, &saddr);
+	if (IS_ERR(dst)) {
+		if (PTR_ERR(dst) == -ENETUNREACH)
+			dev->stats.tx_carrier_errors++;
+		else if (PTR_ERR(dst) == -ELOOP)
+			dev->stats.collisions++;
+		return PTR_ERR(dst);
+	}
+
+	headroom = sizeof(struct ipv6hdr) + sizeof(struct udphdr);
+
+	switch (pctx->gtp_version) {
+	case GTP_V0:
+		headroom += sizeof(struct gtp0_header);
+		break;
+	case GTP_V1:
+		headroom += sizeof(struct gtp1_header);
+		break;
+	}
+
+	sport = udp_flow_src_port(sock_net(pctx->sk), skb,
+			0, USHRT_MAX,
+			true);
+
+	r = skb_tunnel_check_pmtu(skb, dst, headroom,
+					netif_is_any_bridge_port(dev));
+	if (r < 0) {
+		dst_release(dst);
+		return r;
+	} else if (r) {
+		netif_rx(skb);
+		dst_release(dst);
+		return -EMSGSIZE;
+	}
+
+	skb_scrub_packet(skb, !net_eq(sock_net(pctx->sk), dev_net(pctx->dev)));
+
+	/* Ensure there is sufficient headroom. */
+	r = skb_cow_head(skb, dev->needed_headroom);
+	if (unlikely(r))
+		goto free_dst;
+
+	r = udp_tunnel_handle_offloads(skb, true);
+	if (unlikely(r))
+		goto free_dst;
+
+	skb_set_inner_protocol(skb, skb->protocol);
+
+	gtp_push_header(skb, pctx, &port);
+
+	iph = ipv6_hdr(skb);
+	netdev_dbg(dev, "gtp -> IP src: %pI6 dst: %pI6\n",
+		   &iph->saddr, &iph->daddr);
+
+	udp_tunnel6_xmit_skb(dst, pctx->sk, skb,
+			    skb->dev,
+			    &saddr, &pctx->peer_addr,
+			    0,
+			    ip6_dst_hoplimit(dst),
+			    0,
+			    sport, port,
+			    false);
+
+	return 0;
+
+free_dst:
+	dst_release(dst);
+	return -EBADMSG;
+}
+
+static struct pdp_ctx *pdp_find(struct sk_buff *skb, struct net_device *dev)
+{
+	struct gtp_dev *gtp = netdev_priv(dev);
+	unsigned int proto = ntohs(skb->protocol);
+	struct pdp_ctx* pctx = NULL;
+
+	switch (proto) {
+	case ETH_P_IP: {
+		__be32 addr;
+		struct iphdr *iph = ip_hdr(skb);
+		addr = (gtp->role == GTP_ROLE_SGSN) ? iph->saddr : iph->daddr;
+		pctx = ipv4_pdp_find(gtp, addr);
+
+		if (!pctx) {
+			netdev_dbg(dev, "no PDP ctx found for %pI4, skip\n",
+				   &addr);
+		}
+
+		break;
+	}
+	case ETH_P_IPV6: {
+		struct in6_addr* addr;
+		struct ipv6hdr *iph = ipv6_hdr(skb);
+		addr = (gtp->role == GTP_ROLE_SGSN) ? &iph->saddr : &iph->daddr;
+		pctx = ipv6_pdp_find(gtp, addr);
+
+		if (!pctx) {
+			netdev_dbg(dev, "no PDP ctx found for %pI6, skip\n",
+				   addr);
+		}
+
+		break;
+	}
+	default:
+		break;
+	}
+
+	return pctx;
+}
+
 static netdev_tx_t gtp_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	unsigned int proto = ntohs(skb->protocol);
+	struct pdp_ctx *pctx;
 	int err;
 
 	if (proto != ETH_P_IP && proto != ETH_P_IPV6) {
@@ -699,7 +900,17 @@ static netdev_tx_t gtp_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* PDP context lookups in gtp_build_skb_*() need rcu read-side lock. */
 	rcu_read_lock();
 
-	err = gtp_xmit_ip4(skb, dev);
+	pctx = pdp_find(skb, dev);
+	if (!pctx) {
+		err = -ENOENT;
+		rcu_read_unlock();
+		goto tx_err;
+	}
+
+	if (pctx->flags & PDP_F_PEER_V6)
+		err = gtp_xmit_ip6(skb, dev, pctx);
+	else
+		err = gtp_xmit_ip4(skb, dev, pctx);
 
 	rcu_read_unlock();
 
@@ -726,7 +937,7 @@ static const struct device_type gtp_type = {
 
 static void gtp_link_setup(struct net_device *dev)
 {
-	unsigned int max_gtp_header_len = sizeof(struct iphdr) +
+	unsigned int max_gtp_header_len = sizeof(struct ipv6hdr) +
 					  sizeof(struct udphdr) +
 					  sizeof(struct gtp0_header);
 
@@ -1023,11 +1234,8 @@ static struct gtp_dev *gtp_find_dev(struct net *src_net, struct nlattr *nla[])
 static void ipv4_pdp_fill(struct pdp_ctx *pctx, struct genl_info *info)
 {
 	pctx->gtp_version = nla_get_u32(info->attrs[GTPA_VERSION]);
-	pctx->af = AF_INET;
-	pctx->peer_addr_ip4.s_addr =
-		nla_get_be32(info->attrs[GTPA_PEER_ADDRESS]);
-	pctx->ms_addr_ip4.s_addr =
-		nla_get_be32(info->attrs[GTPA_MS_ADDRESS]);
+	ipv4(&pctx->peer_addr) = nla_get_be32(info->attrs[GTPA_PEER_ADDRESS]);
+	ipv4(&pctx->ms_addr) = nla_get_be32(info->attrs[GTPA_MS_ADDRESS]);
 
 	switch (pctx->gtp_version) {
 	case GTP_V0:
@@ -1127,13 +1335,13 @@ static struct pdp_ctx *gtp_pdp_add(struct gtp_dev *gtp, struct sock *sk,
 	switch (pctx->gtp_version) {
 	case GTP_V0:
 		netdev_dbg(dev, "GTPv0-U: new PDP ctx id=%llx ssgn=%pI4 ms=%pI4 (pdp=%p)\n",
-			   pctx->u.v0.tid, &pctx->peer_addr_ip4,
-			   &pctx->ms_addr_ip4, pctx);
+			   pctx->u.v0.tid, &ipv4(&pctx->peer_addr),
+			   &ipv4(&pctx->ms_addr), pctx);
 		break;
 	case GTP_V1:
 		netdev_dbg(dev, "GTPv1-U: new PDP ctx id=%x/%x ssgn=%pI4 ms=%pI4 (pdp=%p)\n",
 			   pctx->u.v1.i_tei, pctx->u.v1.o_tei,
-			   &pctx->peer_addr_ip4, &pctx->ms_addr_ip4, pctx);
+			   &ipv4(&pctx->peer_addr), &ipv4(&pctx->ms_addr), pctx);
 		break;
 	}
 
@@ -1315,8 +1523,8 @@ static int gtp_genl_fill_info(struct sk_buff *skb, u32 snd_portid, u32 snd_seq,
 
 	if (nla_put_u32(skb, GTPA_VERSION, pctx->gtp_version) ||
 	    nla_put_u32(skb, GTPA_LINK, pctx->dev->ifindex) ||
-	    nla_put_be32(skb, GTPA_PEER_ADDRESS, pctx->peer_addr_ip4.s_addr) ||
-	    nla_put_be32(skb, GTPA_MS_ADDRESS, pctx->ms_addr_ip4.s_addr))
+	    nla_put_be32(skb, GTPA_PEER_ADDRESS, ipv4(&pctx->peer_addr)) ||
+	    nla_put_be32(skb, GTPA_MS_ADDRESS, ipv4(&pctx->ms_addr)))
 		goto nla_put_failure;
 
 	switch (pctx->gtp_version) {
-- 
2.27.0

