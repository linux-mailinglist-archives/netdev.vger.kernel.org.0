Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7FF30D3E1
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 08:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhBCHI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 02:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbhBCHIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 02:08:51 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF984C06174A
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 23:08:10 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id h7so31809259lfc.6
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 23:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g1SB2FtrlmzNDA9rqmhIQqmpt3slQ/X5MLqAKGKD8V8=;
        b=OFihNwBgxTKQ+5gO3S7NV5AzF19vrwYLJszqylBYv+vLGiCnwCH7h62cGdfEWoMlEn
         1+i1o4b4+BsOUlx/5feitu75nWCTVVieDq4Ji74UqiF0vHuEDfuiNnbL1qlD7o0+YqWO
         JXpyGROjdhC5jqaAjOckRr3of8zGsBycI6TyYFH2GLeXodOfje5ZPeYaEG1+SS/ecHHT
         Rpb5Bp13D5azc1pn4OHuytPWL0NJxU9fd5KB1RUr3MUvI01/KngzVvC8/d/55gMqttdq
         oWFzfMaW1ph6qPkm3wSpBvg/5u6Wu9WFG+M4HOTr/2G+lePI7wXiUKGHopf3q6eti4ca
         7TSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g1SB2FtrlmzNDA9rqmhIQqmpt3slQ/X5MLqAKGKD8V8=;
        b=c70Ebu5LB/Ut5FiIvth8Erown5LQbD1VFlmB/mJGJoYtbWEtbcc61X10XBK0xE52UW
         0b9kkIcvZN+2I7i8DGMhi+HljO5WlbQMb/P91G1fDSzl1HFkNZcWbmgFPTDJQsDoIiAm
         qK4RO4v8xH9H965c3XKr40UjidudqVHtgFmANb0r/0P4HpzP0YI8rtWbacvQZHnVlu0h
         w7SfgsUHw85y0HfZ7xq0Iqa0G05MT23p91L+nLD9BtpzD2VY+/xeMrm7H1qqSHoXUg/T
         d/9sz5VqBlfF9Fauz+dGTphX7Hz6pf0XmCV007Rqa5qLZodez3E63d7VYfqSTEQrIoS4
         hMLg==
X-Gm-Message-State: AOAM5307nqlC2UCUwL5hePJpI+8+6sEkbNHUAsYoEwgagUmVQLgCYaN1
        0DY0hse7UrvWK0R48GI2INQV/g==
X-Google-Smtp-Source: ABdhPJyX4NY9FbRNI9vcoI9Nc5WaFy0BVQI5Va5KGwsnrEXhcRNDD8KgiaEIJA60/D5fCxZWbtYrwg==
X-Received: by 2002:a05:6512:1311:: with SMTP id x17mr977712lfu.307.1612336089077;
        Tue, 02 Feb 2021 23:08:09 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id d3sm147367lfg.122.2021.02.02.23.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 23:08:08 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, kuba@kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org
Cc:     Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next v2 1/7] Revert "GTP: add support for flow based tunneling API"
Date:   Wed,  3 Feb 2021 08:07:59 +0100
Message-Id: <20210203070805.281321-2-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210203070805.281321-1-jonas@norrbonn.se>
References: <20210202065159.227049-1-jonas@norrbonn.se>
 <20210203070805.281321-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 9ab7e76aefc97a9aa664accb59d6e8dc5e52514a.

This patch was committed without maintainer approval and despite a number
of unaddressed concerns from review.  There are several issues that
impede the acceptance of this patch and that make a reversion of this
particular instance of these changes the best way forward:

i)  the patch contains several logically separate changes that would be
better served as smaller patches (for review purposes)
ii) functionality like the handling of end markers has been introduced
without further explanation
iii) symmetry between the handling of GTPv0 and GTPv1 has been
unnecessarily broken
iv) the patchset produces 'broken' packets when extension headers are
included
v) there are no available userspace tools to allow for testing this
functionality
vi) there is an unaddressed Coverity report against the patch concering
memory leakage
vii) most importantly, the patch contains a large amount of superfluous
churn that impedes other ongoing work with this driver

This patch will be reworked into a series that aligns with other
ongoing work and facilitates review.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
Acked-by: Harald Welte <laforge@gnumonks.org>
---
 drivers/net/gtp.c                  | 527 ++++++++---------------------
 include/uapi/linux/gtp.h           |  12 -
 include/uapi/linux/if_link.h       |   1 -
 include/uapi/linux/if_tunnel.h     |   1 -
 tools/include/uapi/linux/if_link.h |   1 -
 5 files changed, 144 insertions(+), 398 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 851364314ecc..4c04e271f184 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -21,7 +21,6 @@
 #include <linux/file.h>
 #include <linux/gtp.h>
 
-#include <net/dst_metadata.h>
 #include <net/net_namespace.h>
 #include <net/protocol.h>
 #include <net/ip.h>
@@ -74,9 +73,6 @@ struct gtp_dev {
 	unsigned int		hash_size;
 	struct hlist_head	*tid_hash;
 	struct hlist_head	*addr_hash;
-	/* Used by LWT tunnel. */
-	bool			collect_md;
-	struct socket		*collect_md_sock;
 };
 
 static unsigned int gtp_net_id __read_mostly;
@@ -183,121 +179,33 @@ static bool gtp_check_ms(struct sk_buff *skb, struct pdp_ctx *pctx,
 	return false;
 }
 
-static int gtp_set_tun_dst(struct gtp_dev *gtp, struct sk_buff *skb,
-			   unsigned int hdrlen, u8 gtp_version,
-			   __be64 tid, u8 flags)
+static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
+			unsigned int hdrlen, unsigned int role)
 {
-	struct metadata_dst *tun_dst;
-	int opts_len = 0;
-
-	if (unlikely(flags & GTP1_F_MASK))
-		opts_len = sizeof(struct gtpu_metadata);
-
-	tun_dst = udp_tun_rx_dst(skb, gtp->sk1u->sk_family, TUNNEL_KEY, tid, opts_len);
-	if (!tun_dst) {
-		netdev_dbg(gtp->dev, "Failed to allocate tun_dst");
-		goto err;
+	if (!gtp_check_ms(skb, pctx, hdrlen, role)) {
+		netdev_dbg(pctx->dev, "No PDP ctx for this MS\n");
+		return 1;
 	}
 
-	netdev_dbg(gtp->dev, "attaching metadata_dst to skb, gtp ver %d hdrlen %d\n",
-		   gtp_version, hdrlen);
-	if (unlikely(opts_len)) {
-		struct gtpu_metadata *opts;
-		struct gtp1_header *gtp1;
-
-		opts = ip_tunnel_info_opts(&tun_dst->u.tun_info);
-		gtp1 = (struct gtp1_header *)(skb->data + sizeof(struct udphdr));
-		opts->ver = GTP_METADATA_V1;
-		opts->flags = gtp1->flags;
-		opts->type = gtp1->type;
-		netdev_dbg(gtp->dev, "recved control pkt: flag %x type: %d\n",
-			   opts->flags, opts->type);
-		tun_dst->u.tun_info.key.tun_flags |= TUNNEL_GTPU_OPT;
-		tun_dst->u.tun_info.options_len = opts_len;
-		skb->protocol = htons(0xffff);         /* Unknown */
-	}
 	/* Get rid of the GTP + UDP headers. */
 	if (iptunnel_pull_header(skb, hdrlen, skb->protocol,
-				 !net_eq(sock_net(gtp->sk1u), dev_net(gtp->dev)))) {
-		gtp->dev->stats.rx_length_errors++;
-		goto err;
-	}
-
-	skb_dst_set(skb, &tun_dst->dst);
-	return 0;
-err:
-	return -1;
-}
-
-static int gtp_rx(struct gtp_dev *gtp, struct sk_buff *skb,
-		  unsigned int hdrlen, u8 gtp_version, unsigned int role,
-		  __be64 tid, u8 flags, u8 type)
-{
-	if (ip_tunnel_collect_metadata() || gtp->collect_md) {
-		int err;
-
-		err = gtp_set_tun_dst(gtp, skb, hdrlen, gtp_version, tid, flags);
-		if (err)
-			goto err;
-	} else {
-		struct pdp_ctx *pctx;
-
-		if (flags & GTP1_F_MASK)
-			hdrlen += 4;
-
-		if (type != GTP_TPDU)
-			return 1;
+				 !net_eq(sock_net(pctx->sk), dev_net(pctx->dev))))
+		return -1;
 
-		if (gtp_version == GTP_V0)
-			pctx = gtp0_pdp_find(gtp, be64_to_cpu(tid));
-		else
-			pctx = gtp1_pdp_find(gtp, be64_to_cpu(tid));
-		if (!pctx) {
-			netdev_dbg(gtp->dev, "No PDP ctx to decap skb=%p\n", skb);
-			return 1;
-		}
-
-		if (!gtp_check_ms(skb, pctx, hdrlen, role)) {
-			netdev_dbg(pctx->dev, "No PDP ctx for this MS\n");
-			return 1;
-		}
-		/* Get rid of the GTP + UDP headers. */
-		if (iptunnel_pull_header(skb, hdrlen, skb->protocol,
-					 !net_eq(sock_net(pctx->sk), dev_net(gtp->dev)))) {
-			gtp->dev->stats.rx_length_errors++;
-			goto err;
-		}
-	}
-	netdev_dbg(gtp->dev, "forwarding packet from GGSN to uplink\n");
+	netdev_dbg(pctx->dev, "forwarding packet from GGSN to uplink\n");
 
 	/* Now that the UDP and the GTP header have been removed, set up the
 	 * new network header. This is required by the upper layer to
 	 * calculate the transport header.
 	 */
 	skb_reset_network_header(skb);
-	if (pskb_may_pull(skb, sizeof(struct iphdr))) {
-		struct iphdr *iph;
-
-		iph = ip_hdr(skb);
-		if (iph->version == 4) {
-			netdev_dbg(gtp->dev, "inner pkt: ipv4");
-			skb->protocol = htons(ETH_P_IP);
-		} else if (iph->version == 6) {
-			netdev_dbg(gtp->dev, "inner pkt: ipv6");
-			skb->protocol = htons(ETH_P_IPV6);
-		} else {
-			netdev_dbg(gtp->dev, "inner pkt error: Unknown type");
-		}
-	}
 
-	skb->dev = gtp->dev;
-	dev_sw_netstats_rx_add(gtp->dev, skb->len);
+	skb->dev = pctx->dev;
+
+	dev_sw_netstats_rx_add(pctx->dev, skb->len);
+
 	netif_rx(skb);
 	return 0;
-
-err:
-	gtp->dev->stats.rx_dropped++;
-	return -1;
 }
 
 /* 1 means pass up to the stack, -1 means drop and 0 means decapsulated. */
@@ -306,6 +214,7 @@ static int gtp0_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 	unsigned int hdrlen = sizeof(struct udphdr) +
 			      sizeof(struct gtp0_header);
 	struct gtp0_header *gtp0;
+	struct pdp_ctx *pctx;
 
 	if (!pskb_may_pull(skb, hdrlen))
 		return -1;
@@ -315,7 +224,16 @@ static int gtp0_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 	if ((gtp0->flags >> 5) != GTP_V0)
 		return 1;
 
-	return gtp_rx(gtp, skb, hdrlen, GTP_V0, gtp->role, gtp0->tid, gtp0->flags, gtp0->type);
+	if (gtp0->type != GTP_TPDU)
+		return 1;
+
+	pctx = gtp0_pdp_find(gtp, be64_to_cpu(gtp0->tid));
+	if (!pctx) {
+		netdev_dbg(gtp->dev, "No PDP ctx to decap skb=%p\n", skb);
+		return 1;
+	}
+
+	return gtp_rx(pctx, skb, hdrlen, gtp->role);
 }
 
 static int gtp1u_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
@@ -323,30 +241,41 @@ static int gtp1u_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 	unsigned int hdrlen = sizeof(struct udphdr) +
 			      sizeof(struct gtp1_header);
 	struct gtp1_header *gtp1;
+	struct pdp_ctx *pctx;
 
 	if (!pskb_may_pull(skb, hdrlen))
 		return -1;
 
 	gtp1 = (struct gtp1_header *)(skb->data + sizeof(struct udphdr));
 
-	netdev_dbg(gtp->dev, "GTPv1 recv: flags %x\n", gtp1->flags);
 	if ((gtp1->flags >> 5) != GTP_V1)
 		return 1;
 
+	if (gtp1->type != GTP_TPDU)
+		return 1;
+
 	/* From 29.060: "This field shall be present if and only if any one or
 	 * more of the S, PN and E flags are set.".
 	 *
 	 * If any of the bit is set, then the remaining ones also have to be
 	 * set.
 	 */
+	if (gtp1->flags & GTP1_F_MASK)
+		hdrlen += 4;
+
 	/* Make sure the header is larger enough, including extensions. */
 	if (!pskb_may_pull(skb, hdrlen))
 		return -1;
 
 	gtp1 = (struct gtp1_header *)(skb->data + sizeof(struct udphdr));
 
-	return gtp_rx(gtp, skb, hdrlen, GTP_V1, gtp->role,
-		      key32_to_tunnel_id(gtp1->tid), gtp1->flags, gtp1->type);
+	pctx = gtp1_pdp_find(gtp, ntohl(gtp1->tid));
+	if (!pctx) {
+		netdev_dbg(gtp->dev, "No PDP ctx to decap skb=%p\n", skb);
+		return 1;
+	}
+
+	return gtp_rx(pctx, skb, hdrlen, gtp->role);
 }
 
 static void __gtp_encap_destroy(struct sock *sk)
@@ -386,11 +315,6 @@ static void gtp_encap_disable(struct gtp_dev *gtp)
 {
 	gtp_encap_disable_sock(gtp->sk0);
 	gtp_encap_disable_sock(gtp->sk1u);
-	if (gtp->collect_md_sock) {
-		udp_tunnel_sock_release(gtp->collect_md_sock);
-		gtp->collect_md_sock = NULL;
-		netdev_dbg(gtp->dev, "GTP socket released.\n");
-	}
 }
 
 /* UDP encapsulation receive handler. See net/ipv4/udp.c.
@@ -405,8 +329,7 @@ static int gtp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	if (!gtp)
 		return 1;
 
-	netdev_dbg(gtp->dev, "encap_recv sk=%p type %d\n",
-		   sk, udp_sk(sk)->encap_type);
+	netdev_dbg(gtp->dev, "encap_recv sk=%p\n", sk);
 
 	switch (udp_sk(sk)->encap_type) {
 	case UDP_ENCAP_GTP0:
@@ -460,13 +383,12 @@ static void gtp_dev_uninit(struct net_device *dev)
 
 static struct rtable *ip4_route_output_gtp(struct flowi4 *fl4,
 					   const struct sock *sk,
-					   __be32 daddr,
-					   __be32 saddr)
+					   __be32 daddr)
 {
 	memset(fl4, 0, sizeof(*fl4));
 	fl4->flowi4_oif		= sk->sk_bound_dev_if;
 	fl4->daddr		= daddr;
-	fl4->saddr		= saddr;
+	fl4->saddr		= inet_sk(sk)->inet_saddr;
 	fl4->flowi4_tos		= RT_CONN_FLAGS(sk);
 	fl4->flowi4_proto	= sk->sk_protocol;
 
@@ -490,7 +412,7 @@ static inline void gtp0_push_header(struct sk_buff *skb, struct pdp_ctx *pctx)
 	gtp0->tid	= cpu_to_be64(pctx->u.v0.tid);
 }
 
-static inline void gtp1_push_header(struct sk_buff *skb, __be32 tid)
+static inline void gtp1_push_header(struct sk_buff *skb, struct pdp_ctx *pctx)
 {
 	int payload_len = skb->len;
 	struct gtp1_header *gtp1;
@@ -506,63 +428,46 @@ static inline void gtp1_push_header(struct sk_buff *skb, __be32 tid)
 	gtp1->flags	= 0x30; /* v1, GTP-non-prime. */
 	gtp1->type	= GTP_TPDU;
 	gtp1->length	= htons(payload_len);
-	gtp1->tid	= tid;
+	gtp1->tid	= htonl(pctx->u.v1.o_tei);
 
 	/* TODO: Suppport for extension header, sequence number and N-PDU.
 	 *	 Update the length field if any of them is available.
 	 */
 }
 
-static inline int gtp1_push_control_header(struct sk_buff *skb,
-					   __be32 tid,
-					   struct gtpu_metadata *opts,
-					   struct net_device *dev)
-{
-	struct gtp1_header *gtp1c;
-	int payload_len;
-
-	if (opts->ver != GTP_METADATA_V1)
-		return -ENOENT;
+struct gtp_pktinfo {
+	struct sock		*sk;
+	struct iphdr		*iph;
+	struct flowi4		fl4;
+	struct rtable		*rt;
+	struct pdp_ctx		*pctx;
+	struct net_device	*dev;
+	__be16			gtph_port;
+};
 
-	if (opts->type == 0xFE) {
-		/* for end marker ignore skb data. */
-		netdev_dbg(dev, "xmit pkt with null data");
-		pskb_trim(skb, 0);
+static void gtp_push_header(struct sk_buff *skb, struct gtp_pktinfo *pktinfo)
+{
+	switch (pktinfo->pctx->gtp_version) {
+	case GTP_V0:
+		pktinfo->gtph_port = htons(GTP0_PORT);
+		gtp0_push_header(skb, pktinfo->pctx);
+		break;
+	case GTP_V1:
+		pktinfo->gtph_port = htons(GTP1U_PORT);
+		gtp1_push_header(skb, pktinfo->pctx);
+		break;
 	}
-	if (skb_cow_head(skb, sizeof(*gtp1c)) < 0)
-		return -ENOMEM;
-
-	payload_len = skb->len;
-
-	gtp1c = skb_push(skb, sizeof(*gtp1c));
-
-	gtp1c->flags	= opts->flags;
-	gtp1c->type	= opts->type;
-	gtp1c->length	= htons(payload_len);
-	gtp1c->tid	= tid;
-	netdev_dbg(dev, "xmit control pkt: ver %d flags %x type %x pkt len %d tid %x",
-		   opts->ver, opts->flags, opts->type, skb->len, tid);
-	return 0;
 }
 
-struct gtp_pktinfo {
-	struct sock             *sk;
-	__u8                    tos;
-	struct flowi4           fl4;
-	struct rtable           *rt;
-	struct net_device       *dev;
-	__be16                  gtph_port;
-};
-
 static inline void gtp_set_pktinfo_ipv4(struct gtp_pktinfo *pktinfo,
-					struct sock *sk,
-					__u8 tos,
-					struct rtable *rt,
+					struct sock *sk, struct iphdr *iph,
+					struct pdp_ctx *pctx, struct rtable *rt,
 					struct flowi4 *fl4,
 					struct net_device *dev)
 {
 	pktinfo->sk	= sk;
-	pktinfo->tos    = tos;
+	pktinfo->iph	= iph;
+	pktinfo->pctx	= pctx;
 	pktinfo->rt	= rt;
 	pktinfo->fl4	= *fl4;
 	pktinfo->dev	= dev;
@@ -572,99 +477,40 @@ static int gtp_build_skb_ip4(struct sk_buff *skb, struct net_device *dev,
 			     struct gtp_pktinfo *pktinfo)
 {
 	struct gtp_dev *gtp = netdev_priv(dev);
-	struct gtpu_metadata *opts = NULL;
-	struct sock *sk = NULL;
 	struct pdp_ctx *pctx;
 	struct rtable *rt;
 	struct flowi4 fl4;
-	u8 gtp_version;
-	__be16 df = 0;
-	__be32 tun_id;
-	__be32 daddr;
-	__be32 saddr;
-	__u8 tos;
+	struct iphdr *iph;
+	__be16 df;
 	int mtu;
 
-	if (gtp->collect_md) {
-		/* LWT GTP1U encap */
-		struct ip_tunnel_info *info = NULL;
-
-		info = skb_tunnel_info(skb);
-		if (!info) {
-			netdev_dbg(dev, "missing tunnel info");
-			return -ENOENT;
-		}
-		if (info->key.tp_dst && ntohs(info->key.tp_dst) != GTP1U_PORT) {
-			netdev_dbg(dev, "unexpected GTP dst port: %d", ntohs(info->key.tp_dst));
-			return -EOPNOTSUPP;
-		}
-		pctx = NULL;
-		gtp_version = GTP_V1;
-		tun_id = tunnel_id_to_key32(info->key.tun_id);
-		daddr = info->key.u.ipv4.dst;
-		saddr = info->key.u.ipv4.src;
-		sk = gtp->sk1u;
-		if (!sk) {
-			netdev_dbg(dev, "missing tunnel sock");
-			return -EOPNOTSUPP;
-		}
-		tos = info->key.tos;
-		if (info->key.tun_flags & TUNNEL_DONT_FRAGMENT)
-			df = htons(IP_DF);
-
-		if (info->options_len != 0) {
-			if (info->key.tun_flags & TUNNEL_GTPU_OPT) {
-				opts = ip_tunnel_info_opts(info);
-			} else {
-				netdev_dbg(dev, "missing tunnel metadata for control pkt");
-				return -EOPNOTSUPP;
-			}
-		}
-		netdev_dbg(dev, "flow-based GTP1U encap: tunnel id %d\n",
-			   be32_to_cpu(tun_id));
-	} else {
-		struct iphdr *iph;
-
-		if (ntohs(skb->protocol) != ETH_P_IP)
-			return -EOPNOTSUPP;
-
-		iph = ip_hdr(skb);
-
-		/* Read the IP destination address and resolve the PDP context.
-		 * Prepend PDP header with TEI/TID from PDP ctx.
-		 */
-		if (gtp->role == GTP_ROLE_SGSN)
-			pctx = ipv4_pdp_find(gtp, iph->saddr);
-		else
-			pctx = ipv4_pdp_find(gtp, iph->daddr);
+	/* Read the IP destination address and resolve the PDP context.
+	 * Prepend PDP header with TEI/TID from PDP ctx.
+	 */
+	iph = ip_hdr(skb);
+	if (gtp->role == GTP_ROLE_SGSN)
+		pctx = ipv4_pdp_find(gtp, iph->saddr);
+	else
+		pctx = ipv4_pdp_find(gtp, iph->daddr);
 
-		if (!pctx) {
-			netdev_dbg(dev, "no PDP ctx found for %pI4, skip\n",
-				   &iph->daddr);
-			return -ENOENT;
-		}
-		sk = pctx->sk;
-		netdev_dbg(dev, "found PDP context %p\n", pctx);
-
-		gtp_version = pctx->gtp_version;
-		tun_id  = htonl(pctx->u.v1.o_tei);
-		daddr = pctx->peer_addr_ip4.s_addr;
-		saddr = inet_sk(sk)->inet_saddr;
-		tos = iph->tos;
-		df = iph->frag_off;
-		netdev_dbg(dev, "gtp -> IP src: %pI4 dst: %pI4\n",
-			   &iph->saddr, &iph->daddr);
+	if (!pctx) {
+		netdev_dbg(dev, "no PDP ctx found for %pI4, skip\n",
+			   &iph->daddr);
+		return -ENOENT;
 	}
+	netdev_dbg(dev, "found PDP context %p\n", pctx);
 
-	rt = ip4_route_output_gtp(&fl4, sk, daddr, saddr);
+	rt = ip4_route_output_gtp(&fl4, pctx->sk, pctx->peer_addr_ip4.s_addr);
 	if (IS_ERR(rt)) {
-		netdev_dbg(dev, "no route to SSGN %pI4\n", &daddr);
+		netdev_dbg(dev, "no route to SSGN %pI4\n",
+			   &pctx->peer_addr_ip4.s_addr);
 		dev->stats.tx_carrier_errors++;
 		goto err;
 	}
 
 	if (rt->dst.dev == dev) {
-		netdev_dbg(dev, "circular route to SSGN %pI4\n", &daddr);
+		netdev_dbg(dev, "circular route to SSGN %pI4\n",
+			   &pctx->peer_addr_ip4.s_addr);
 		dev->stats.collisions++;
 		goto err_rt;
 	}
@@ -672,10 +518,11 @@ static int gtp_build_skb_ip4(struct sk_buff *skb, struct net_device *dev,
 	skb_dst_drop(skb);
 
 	/* This is similar to tnl_update_pmtu(). */
+	df = iph->frag_off;
 	if (df) {
 		mtu = dst_mtu(&rt->dst) - dev->hard_header_len -
 			sizeof(struct iphdr) - sizeof(struct udphdr);
-		switch (gtp_version) {
+		switch (pctx->gtp_version) {
 		case GTP_V0:
 			mtu -= sizeof(struct gtp0_header);
 			break;
@@ -689,38 +536,17 @@ static int gtp_build_skb_ip4(struct sk_buff *skb, struct net_device *dev,
 
 	rt->dst.ops->update_pmtu(&rt->dst, NULL, skb, mtu, false);
 
-	if (!skb_is_gso(skb) && (df & htons(IP_DF)) && mtu < skb->len) {
-		netdev_dbg(dev, "packet too big, fragmentation needed");
+	if (!skb_is_gso(skb) && (iph->frag_off & htons(IP_DF)) &&
+	    mtu < ntohs(iph->tot_len)) {
+		netdev_dbg(dev, "packet too big, fragmentation needed\n");
 		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
 		icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 			      htonl(mtu));
 		goto err_rt;
 	}
 
-	gtp_set_pktinfo_ipv4(pktinfo, sk, tos, rt, &fl4, dev);
-
-	if (unlikely(opts)) {
-		int err;
-
-		pktinfo->gtph_port = htons(GTP1U_PORT);
-		err = gtp1_push_control_header(skb, tun_id, opts, dev);
-		if (err) {
-			netdev_info(dev, "cntr pkt error %d", err);
-			goto err_rt;
-		}
-		return 0;
-	}
-
-	switch (gtp_version) {
-	case GTP_V0:
-		pktinfo->gtph_port = htons(GTP0_PORT);
-		gtp0_push_header(skb, pctx);
-		break;
-	case GTP_V1:
-		pktinfo->gtph_port = htons(GTP1U_PORT);
-		gtp1_push_header(skb, tun_id);
-		break;
-	}
+	gtp_set_pktinfo_ipv4(pktinfo, pctx->sk, iph, pctx, rt, &fl4, dev);
+	gtp_push_header(skb, pktinfo);
 
 	return 0;
 err_rt:
@@ -731,6 +557,7 @@ static int gtp_build_skb_ip4(struct sk_buff *skb, struct net_device *dev,
 
 static netdev_tx_t gtp_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 {
+	unsigned int proto = ntohs(skb->protocol);
 	struct gtp_pktinfo pktinfo;
 	int err;
 
@@ -742,22 +569,32 @@ static netdev_tx_t gtp_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	/* PDP context lookups in gtp_build_skb_*() need rcu read-side lock. */
 	rcu_read_lock();
-	err = gtp_build_skb_ip4(skb, dev, &pktinfo);
+	switch (proto) {
+	case ETH_P_IP:
+		err = gtp_build_skb_ip4(skb, dev, &pktinfo);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
 	rcu_read_unlock();
 
 	if (err < 0)
 		goto tx_err;
 
-	udp_tunnel_xmit_skb(pktinfo.rt, pktinfo.sk, skb,
-			    pktinfo.fl4.saddr,
-			    pktinfo.fl4.daddr,
-			    pktinfo.tos,
-			    ip4_dst_hoplimit(&pktinfo.rt->dst),
-			    0,
-			    pktinfo.gtph_port,
-			    pktinfo.gtph_port,
-			    true,
-			    false);
+	switch (proto) {
+	case ETH_P_IP:
+		netdev_dbg(pktinfo.dev, "gtp -> IP src: %pI4 dst: %pI4\n",
+			   &pktinfo.iph->saddr, &pktinfo.iph->daddr);
+		udp_tunnel_xmit_skb(pktinfo.rt, pktinfo.sk, skb,
+				    pktinfo.fl4.saddr, pktinfo.fl4.daddr,
+				    pktinfo.iph->tos,
+				    ip4_dst_hoplimit(&pktinfo.rt->dst),
+				    0,
+				    pktinfo.gtph_port, pktinfo.gtph_port,
+				    true, false);
+		break;
+	}
 
 	return NETDEV_TX_OK;
 tx_err:
@@ -773,19 +610,6 @@ static const struct net_device_ops gtp_netdev_ops = {
 	.ndo_get_stats64	= dev_get_tstats64,
 };
 
-static struct gtp_dev *gtp_find_flow_based_dev(struct net *net)
-{
-	struct gtp_net *gn = net_generic(net, gtp_net_id);
-	struct gtp_dev *gtp;
-
-	list_for_each_entry(gtp, &gn->gtp_dev_list, list) {
-		if (gtp->collect_md)
-			return gtp;
-	}
-
-	return NULL;
-}
-
 static void gtp_link_setup(struct net_device *dev)
 {
 	dev->netdev_ops		= &gtp_netdev_ops;
@@ -810,7 +634,7 @@ static void gtp_link_setup(struct net_device *dev)
 }
 
 static int gtp_hashtable_new(struct gtp_dev *gtp, int hsize);
-static int gtp_encap_enable(struct gtp_dev *gtp, struct net_device *dev, struct nlattr *data[]);
+static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[]);
 
 static void gtp_destructor(struct net_device *dev)
 {
@@ -828,24 +652,11 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
 	struct gtp_net *gn;
 	int hashsize, err;
 
-	if (!data[IFLA_GTP_FD0] && !data[IFLA_GTP_FD1] &&
-	    !data[IFLA_GTP_COLLECT_METADATA])
+	if (!data[IFLA_GTP_FD0] && !data[IFLA_GTP_FD1])
 		return -EINVAL;
 
 	gtp = netdev_priv(dev);
 
-	if (data[IFLA_GTP_COLLECT_METADATA]) {
-		if (data[IFLA_GTP_FD0]) {
-			netdev_dbg(dev, "LWT device does not support setting v0 socket");
-			return -EINVAL;
-		}
-		if (gtp_find_flow_based_dev(src_net)) {
-			netdev_dbg(dev, "LWT device already exist");
-			return -EBUSY;
-		}
-		gtp->collect_md = true;
-	}
-
 	if (!data[IFLA_GTP_PDP_HASHSIZE]) {
 		hashsize = 1024;
 	} else {
@@ -858,7 +669,7 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
 	if (err < 0)
 		return err;
 
-	err = gtp_encap_enable(gtp, dev, data);
+	err = gtp_encap_enable(gtp, data);
 	if (err < 0)
 		goto out_hashtable;
 
@@ -872,7 +683,7 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
 	list_add_rcu(&gtp->list, &gn->gtp_dev_list);
 	dev->priv_destructor = gtp_destructor;
 
-	netdev_dbg(dev, "registered new GTP interface %s\n", dev->name);
+	netdev_dbg(dev, "registered new GTP interface\n");
 
 	return 0;
 
@@ -903,7 +714,6 @@ static const struct nla_policy gtp_policy[IFLA_GTP_MAX + 1] = {
 	[IFLA_GTP_FD1]			= { .type = NLA_U32 },
 	[IFLA_GTP_PDP_HASHSIZE]		= { .type = NLA_U32 },
 	[IFLA_GTP_ROLE]			= { .type = NLA_U32 },
-	[IFLA_GTP_COLLECT_METADATA]	= { .type = NLA_FLAG },
 };
 
 static int gtp_validate(struct nlattr *tb[], struct nlattr *data[],
@@ -927,9 +737,6 @@ static int gtp_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	if (nla_put_u32(skb, IFLA_GTP_PDP_HASHSIZE, gtp->hash_size))
 		goto nla_put_failure;
 
-	if (gtp->collect_md && nla_put_flag(skb, IFLA_GTP_COLLECT_METADATA))
-		goto nla_put_failure;
-
 	return 0;
 
 nla_put_failure:
@@ -975,24 +782,35 @@ static int gtp_hashtable_new(struct gtp_dev *gtp, int hsize)
 	return -ENOMEM;
 }
 
-static int __gtp_encap_enable_socket(struct socket *sock, int type,
-				     struct gtp_dev *gtp)
+static struct sock *gtp_encap_enable_socket(int fd, int type,
+					    struct gtp_dev *gtp)
 {
 	struct udp_tunnel_sock_cfg tuncfg = {NULL};
+	struct socket *sock;
 	struct sock *sk;
+	int err;
+
+	pr_debug("enable gtp on %d, %d\n", fd, type);
+
+	sock = sockfd_lookup(fd, &err);
+	if (!sock) {
+		pr_debug("gtp socket fd=%d not found\n", fd);
+		return NULL;
+	}
 
 	sk = sock->sk;
 	if (sk->sk_protocol != IPPROTO_UDP ||
 	    sk->sk_type != SOCK_DGRAM ||
 	    (sk->sk_family != AF_INET && sk->sk_family != AF_INET6)) {
-		pr_debug("socket not UDP\n");
-		return -EINVAL;
+		pr_debug("socket fd=%d not UDP\n", fd);
+		sk = ERR_PTR(-EINVAL);
+		goto out_sock;
 	}
 
 	lock_sock(sk);
 	if (sk->sk_user_data) {
-		release_sock(sock->sk);
-		return -EBUSY;
+		sk = ERR_PTR(-EBUSY);
+		goto out_rel_sock;
 	}
 
 	sock_hold(sk);
@@ -1003,58 +821,15 @@ static int __gtp_encap_enable_socket(struct socket *sock, int type,
 	tuncfg.encap_destroy = gtp_encap_destroy;
 
 	setup_udp_tunnel_sock(sock_net(sock->sk), sock, &tuncfg);
-	release_sock(sock->sk);
-	return 0;
-}
 
-static struct sock *gtp_encap_enable_socket(int fd, int type,
-					    struct gtp_dev *gtp)
-{
-	struct socket *sock;
-	int err;
-
-	pr_debug("enable gtp on %d, %d\n", fd, type);
-
-	sock = sockfd_lookup(fd, &err);
-	if (!sock) {
-		pr_debug("gtp socket fd=%d not found\n", fd);
-		return NULL;
-	}
-	err =  __gtp_encap_enable_socket(sock, type, gtp);
+out_rel_sock:
+	release_sock(sock->sk);
+out_sock:
 	sockfd_put(sock);
-	if (err)
-		return ERR_PTR(err);
-
-	return sock->sk;
+	return sk;
 }
 
-static struct socket *gtp_create_gtp_socket(struct gtp_dev *gtp, struct net_device *dev)
-{
-	struct udp_port_cfg udp_conf;
-	struct socket *sock;
-	int err;
-
-	memset(&udp_conf, 0, sizeof(udp_conf));
-	udp_conf.family = AF_INET;
-	udp_conf.local_ip.s_addr = htonl(INADDR_ANY);
-	udp_conf.local_udp_port = htons(GTP1U_PORT);
-
-	err = udp_sock_create(dev_net(dev), &udp_conf, &sock);
-	if (err < 0) {
-		pr_debug("create gtp sock failed: %d\n", err);
-		return ERR_PTR(err);
-	}
-	err = __gtp_encap_enable_socket(sock, UDP_ENCAP_GTP1U, gtp);
-	if (err) {
-		pr_debug("enable gtp sock encap failed: %d\n", err);
-		udp_tunnel_sock_release(sock);
-		return ERR_PTR(err);
-	}
-	pr_debug("create gtp sock done\n");
-	return sock;
-}
-
-static int gtp_encap_enable(struct gtp_dev *gtp, struct net_device *dev, struct nlattr *data[])
+static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[])
 {
 	struct sock *sk1u = NULL;
 	struct sock *sk0 = NULL;
@@ -1078,25 +853,11 @@ static int gtp_encap_enable(struct gtp_dev *gtp, struct net_device *dev, struct
 		}
 	}
 
-	if (data[IFLA_GTP_COLLECT_METADATA]) {
-		struct socket *sock;
-
-		if (!sk1u) {
-			sock = gtp_create_gtp_socket(gtp, dev);
-			if (IS_ERR(sock))
-				return PTR_ERR(sock);
-
-			gtp->collect_md_sock = sock;
-			sk1u = sock->sk;
-		} else {
-			gtp->collect_md_sock = NULL;
-		}
-	}
-
 	if (data[IFLA_GTP_ROLE]) {
 		role = nla_get_u32(data[IFLA_GTP_ROLE]);
 		if (role > GTP_ROLE_SGSN) {
-			gtp_encap_disable(gtp);
+			gtp_encap_disable_sock(sk0);
+			gtp_encap_disable_sock(sk1u);
 			return -EINVAL;
 		}
 	}
@@ -1655,7 +1416,7 @@ static int __init gtp_init(void)
 	if (err < 0)
 		goto unreg_genl_family;
 
-	pr_info("GTP module loaded (pdp ctx size %zd bytes) with tnl-md support\n",
+	pr_info("GTP module loaded (pdp ctx size %zd bytes)\n",
 		sizeof(struct pdp_ctx));
 	return 0;
 
diff --git a/include/uapi/linux/gtp.h b/include/uapi/linux/gtp.h
index 62aff78b7c56..79f9191bbb24 100644
--- a/include/uapi/linux/gtp.h
+++ b/include/uapi/linux/gtp.h
@@ -2,8 +2,6 @@
 #ifndef _UAPI_LINUX_GTP_H_
 #define _UAPI_LINUX_GTP_H_
 
-#include <linux/types.h>
-
 #define GTP_GENL_MCGRP_NAME	"gtp"
 
 enum gtp_genl_cmds {
@@ -36,14 +34,4 @@ enum gtp_attrs {
 };
 #define GTPA_MAX (__GTPA_MAX + 1)
 
-enum {
-	GTP_METADATA_V1
-};
-
-struct gtpu_metadata {
-	__u8    ver;
-	__u8    flags;
-	__u8    type;
-};
-
 #endif /* _UAPI_LINUX_GTP_H_ */
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index eb8018c3a737..91c8dda6d95d 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -811,7 +811,6 @@ enum {
 	IFLA_GTP_FD1,
 	IFLA_GTP_PDP_HASHSIZE,
 	IFLA_GTP_ROLE,
-	IFLA_GTP_COLLECT_METADATA,
 	__IFLA_GTP_MAX,
 };
 #define IFLA_GTP_MAX (__IFLA_GTP_MAX - 1)
diff --git a/include/uapi/linux/if_tunnel.h b/include/uapi/linux/if_tunnel.h
index 802da679fab1..7d9105533c7b 100644
--- a/include/uapi/linux/if_tunnel.h
+++ b/include/uapi/linux/if_tunnel.h
@@ -176,7 +176,6 @@ enum {
 #define TUNNEL_VXLAN_OPT	__cpu_to_be16(0x1000)
 #define TUNNEL_NOCACHE		__cpu_to_be16(0x2000)
 #define TUNNEL_ERSPAN_OPT	__cpu_to_be16(0x4000)
-#define TUNNEL_GTPU_OPT		__cpu_to_be16(0x8000)
 
 #define TUNNEL_OPTIONS_PRESENT \
 		(TUNNEL_GENEVE_OPT | TUNNEL_VXLAN_OPT | TUNNEL_ERSPAN_OPT)
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 28d649bda686..d208b2af697f 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -617,7 +617,6 @@ enum {
 	IFLA_GTP_FD1,
 	IFLA_GTP_PDP_HASHSIZE,
 	IFLA_GTP_ROLE,
-	IFLA_GTP_COLLECT_METADATA,
 	__IFLA_GTP_MAX,
 };
 #define IFLA_GTP_MAX (__IFLA_GTP_MAX - 1)
-- 
2.27.0

