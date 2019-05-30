Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE4A22E9AD
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 02:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbfE3ASG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 20:18:06 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42111 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727178AbfE3ASF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 20:18:05 -0400
Received: by mail-pg1-f194.google.com with SMTP id 33so853121pgv.9;
        Wed, 29 May 2019 17:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RIiaBC/VcP02Q7tykBxXsHfExag5p6DFud+tOMCf6lY=;
        b=Fs/Hy3GZwVHztsF6NTzDGMqwKgjK9njGk3JaNnxDBizPvPOEAdeSylP92vXum4MwEn
         87m/PdHajZvAuVB19M/dia67icJbI7xe6sh8pcLC7S/zZ1yVhwImpaiwc0wPcsUeURie
         WQzH1LOdeCLYysw0VepERkLOQQMQmA3uI2G7n5lJAxW9IAaa/twhuBivPLclJx0n2Yvo
         QrxRWg5gaUg72/sa1TsUh6K1Fc4UmMaNWYxPDqIZu3bSwoENqW6RzgvkvdbI00KvjJnM
         pxmw2LLwV1ClWSC4IuAB2zj8Y3/Bkg7hzCFNj0Aw51qlzAT2qo6/A+Xx4Uy4Tg/zDhU7
         uq/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RIiaBC/VcP02Q7tykBxXsHfExag5p6DFud+tOMCf6lY=;
        b=uc+Ws6RkLfzO1Ldxzz+o9kHfrAui/WqFnY/St/D3E4l3q/dSJWOmszgVVxvdpcQvdE
         iETw6iQzlrAmiZIgFUl0b9zwI0XYpcIZ/jX4TIzYUIVzLzilmubH99EICs7lX0daR36V
         TdMeVsejoFBgf64oboH3YT+psu5SscIogPs7XHb4Vp3eXHQGGW4kTbZNLRgOo3UXwNGl
         4KQ/uABFr/5JL85MzqZ6XFHzRAmBGLfSUkL94DoGmTZ1vZXc/Y7X9kXSodrN9dUgWx4r
         Ol4NepWvu1YpOuOWvNVLgAp2iEX40r5Rpha1rMnvIzCTMA1HG50e1L1hpuF8MRgs2B98
         GO8A==
X-Gm-Message-State: APjAAAUH9esTrONA05UmKUuLP++JW4hdTDjqqesBSTmjjPne71EVeJNF
        YaeMbsrgvaovif6zuiSdOw==
X-Google-Smtp-Source: APXvYqzUjiOxRmRSL58kqhlqIcG0bKjp15RH+BXZWeLf9fXfE2Dwimgj2LZagThG+0oNXiiyKP89Ow==
X-Received: by 2002:a17:90a:2e87:: with SMTP id r7mr451572pjd.121.1559175484576;
        Wed, 29 May 2019 17:18:04 -0700 (PDT)
Received: from localhost (2.172.220.35.bc.googleusercontent.com. [35.220.172.2])
        by smtp.gmail.com with ESMTPSA id s101sm640828pjb.10.2019.05.29.17.18.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 May 2019 17:18:03 -0700 (PDT)
From:   Jacky Hu <hengqing.hu@gmail.com>
To:     hengqing.hu@gmail.com
Cc:     jacky.hu@walmart.com, jason.niesz@walmart.com,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH v4] ipvs: add checksum support for gue encapsulation
Date:   Thu, 30 May 2019 08:16:40 +0800
Message-Id: <20190530001641.504-1-hengqing.hu@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add checksum support for gue encapsulation with the tun_flags parameter,
which could be one of the values below:
IP_VS_TUNNEL_ENCAP_FLAG_NOCSUM
IP_VS_TUNNEL_ENCAP_FLAG_CSUM
IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM

Signed-off-by: Jacky Hu <hengqing.hu@gmail.com>
---
v4->v3:
  1) defer pd assignment after data += GUE_LEN_PRIV

v3->v2:
  1) fixed CHECK: spaces preferred around that '<<' (ctx:VxV)

v2->v1:
  1) removed unnecessary changes to ip_vs_core.c
  2) use correct nla_get/put function for tun_flags
  3) use correct gue hdrlen for skb_push in ipvs_gue_encap
  4) moved declaration of gue_hdrlen and gue_optlen

 include/net/ip_vs.h             |   2 +
 include/uapi/linux/ip_vs.h      |   7 ++
 net/netfilter/ipvs/ip_vs_ctl.c  |  11 ++-
 net/netfilter/ipvs/ip_vs_xmit.c | 143 ++++++++++++++++++++++++++++----
 4 files changed, 146 insertions(+), 17 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index b01a94ebfc0e..cb1ad0cc5c7b 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -603,6 +603,7 @@ struct ip_vs_dest_user_kern {
 
 	u16			tun_type;	/* tunnel type */
 	__be16			tun_port;	/* tunnel port */
+	u16			tun_flags;	/* tunnel flags */
 };
 
 
@@ -665,6 +666,7 @@ struct ip_vs_dest {
 	atomic_t		last_weight;	/* server latest weight */
 	__u16			tun_type;	/* tunnel type */
 	__be16			tun_port;	/* tunnel port */
+	__u16			tun_flags;	/* tunnel flags */
 
 	refcount_t		refcnt;		/* reference counter */
 	struct ip_vs_stats      stats;          /* statistics */
diff --git a/include/uapi/linux/ip_vs.h b/include/uapi/linux/ip_vs.h
index e34f436fc79d..e4f18061a4fd 100644
--- a/include/uapi/linux/ip_vs.h
+++ b/include/uapi/linux/ip_vs.h
@@ -131,6 +131,11 @@ enum {
 	IP_VS_CONN_F_TUNNEL_TYPE_MAX,
 };
 
+/* Tunnel encapsulation flags */
+#define IP_VS_TUNNEL_ENCAP_FLAG_NOCSUM		(0)
+#define IP_VS_TUNNEL_ENCAP_FLAG_CSUM		(1 << 0)
+#define IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM		(1 << 1)
+
 /*
  *	The struct ip_vs_service_user and struct ip_vs_dest_user are
  *	used to set IPVS rules through setsockopt.
@@ -403,6 +408,8 @@ enum {
 
 	IPVS_DEST_ATTR_TUN_PORT,	/* tunnel port */
 
+	IPVS_DEST_ATTR_TUN_FLAGS,	/* tunnel flags */
+
 	__IPVS_DEST_ATTR_MAX,
 };
 
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index d5847e06350f..ad19ac08622f 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -893,6 +893,7 @@ __ip_vs_update_dest(struct ip_vs_service *svc, struct ip_vs_dest *dest,
 	/* set the tunnel info */
 	dest->tun_type = udest->tun_type;
 	dest->tun_port = udest->tun_port;
+	dest->tun_flags = udest->tun_flags;
 
 	/* set the IP_VS_CONN_F_NOOUTPUT flag if not masquerading/NAT */
 	if ((conn_flags & IP_VS_CONN_F_FWD_MASK) != IP_VS_CONN_F_MASQ) {
@@ -2967,6 +2968,7 @@ static const struct nla_policy ip_vs_dest_policy[IPVS_DEST_ATTR_MAX + 1] = {
 	[IPVS_DEST_ATTR_ADDR_FAMILY]	= { .type = NLA_U16 },
 	[IPVS_DEST_ATTR_TUN_TYPE]	= { .type = NLA_U8 },
 	[IPVS_DEST_ATTR_TUN_PORT]	= { .type = NLA_U16 },
+	[IPVS_DEST_ATTR_TUN_FLAGS]	= { .type = NLA_U16 },
 };
 
 static int ip_vs_genl_fill_stats(struct sk_buff *skb, int container_type,
@@ -3273,6 +3275,8 @@ static int ip_vs_genl_fill_dest(struct sk_buff *skb, struct ip_vs_dest *dest)
 		       dest->tun_type) ||
 	    nla_put_be16(skb, IPVS_DEST_ATTR_TUN_PORT,
 			 dest->tun_port) ||
+	    nla_put_u16(skb, IPVS_DEST_ATTR_TUN_FLAGS,
+			dest->tun_flags) ||
 	    nla_put_u32(skb, IPVS_DEST_ATTR_U_THRESH, dest->u_threshold) ||
 	    nla_put_u32(skb, IPVS_DEST_ATTR_L_THRESH, dest->l_threshold) ||
 	    nla_put_u32(skb, IPVS_DEST_ATTR_ACTIVE_CONNS,
@@ -3393,7 +3397,8 @@ static int ip_vs_genl_parse_dest(struct ip_vs_dest_user_kern *udest,
 	/* If a full entry was requested, check for the additional fields */
 	if (full_entry) {
 		struct nlattr *nla_fwd, *nla_weight, *nla_u_thresh,
-			      *nla_l_thresh, *nla_tun_type, *nla_tun_port;
+			      *nla_l_thresh, *nla_tun_type, *nla_tun_port,
+			      *nla_tun_flags;
 
 		nla_fwd		= attrs[IPVS_DEST_ATTR_FWD_METHOD];
 		nla_weight	= attrs[IPVS_DEST_ATTR_WEIGHT];
@@ -3401,6 +3406,7 @@ static int ip_vs_genl_parse_dest(struct ip_vs_dest_user_kern *udest,
 		nla_l_thresh	= attrs[IPVS_DEST_ATTR_L_THRESH];
 		nla_tun_type	= attrs[IPVS_DEST_ATTR_TUN_TYPE];
 		nla_tun_port	= attrs[IPVS_DEST_ATTR_TUN_PORT];
+		nla_tun_flags	= attrs[IPVS_DEST_ATTR_TUN_FLAGS];
 
 		if (!(nla_fwd && nla_weight && nla_u_thresh && nla_l_thresh))
 			return -EINVAL;
@@ -3416,6 +3422,9 @@ static int ip_vs_genl_parse_dest(struct ip_vs_dest_user_kern *udest,
 
 		if (nla_tun_port)
 			udest->tun_port = nla_get_be16(nla_tun_port);
+
+		if (nla_tun_flags)
+			udest->tun_flags = nla_get_u16(nla_tun_flags);
 	}
 
 	return 0;
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 8d6f94b67772..4b76557ab4ad 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -40,6 +40,7 @@
 #include <net/ipv6.h>
 #include <net/ip6_route.h>
 #include <net/ip_tunnels.h>
+#include <net/ip6_checksum.h>
 #include <net/addrconf.h>
 #include <linux/icmpv6.h>
 #include <linux/netfilter.h>
@@ -385,8 +386,13 @@ __ip_vs_get_out_rt(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
 		mtu = dst_mtu(&rt->dst) - sizeof(struct iphdr);
 		if (!dest)
 			goto err_put;
-		if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE)
+		if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
 			mtu -= sizeof(struct udphdr) + sizeof(struct guehdr);
+			if ((dest->tun_flags &
+			     IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM) &&
+			    skb->ip_summed == CHECKSUM_PARTIAL)
+				mtu -= GUE_PLEN_REMCSUM + GUE_LEN_PRIV;
+		}
 		if (mtu < 68) {
 			IP_VS_DBG_RL("%s(): mtu less than 68\n", __func__);
 			goto err_put;
@@ -540,8 +546,13 @@ __ip_vs_get_out_rt_v6(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
 		mtu = dst_mtu(&rt->dst) - sizeof(struct ipv6hdr);
 		if (!dest)
 			goto err_put;
-		if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE)
+		if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
 			mtu -= sizeof(struct udphdr) + sizeof(struct guehdr);
+			if ((dest->tun_flags &
+			     IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM) &&
+			    skb->ip_summed == CHECKSUM_PARTIAL)
+				mtu -= GUE_PLEN_REMCSUM + GUE_LEN_PRIV;
+		}
 		if (mtu < IPV6_MIN_MTU) {
 			IP_VS_DBG_RL("%s(): mtu less than %d\n", __func__,
 				     IPV6_MIN_MTU);
@@ -1006,17 +1017,56 @@ ipvs_gue_encap(struct net *net, struct sk_buff *skb,
 	__be16 sport = udp_flow_src_port(net, skb, 0, 0, false);
 	struct udphdr  *udph;	/* Our new UDP header */
 	struct guehdr  *gueh;	/* Our new GUE header */
+	size_t hdrlen, optlen = 0;
+	void *data;
+	bool need_priv = false;
+
+	if ((cp->dest->tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM) &&
+	    skb->ip_summed == CHECKSUM_PARTIAL) {
+		optlen += GUE_PLEN_REMCSUM + GUE_LEN_PRIV;
+		need_priv = true;
+	}
 
-	skb_push(skb, sizeof(struct guehdr));
+	hdrlen = sizeof(struct guehdr) + optlen;
+
+	skb_push(skb, hdrlen);
 
 	gueh = (struct guehdr *)skb->data;
 
 	gueh->control = 0;
 	gueh->version = 0;
-	gueh->hlen = 0;
+	gueh->hlen = optlen >> 2;
 	gueh->flags = 0;
 	gueh->proto_ctype = *next_protocol;
 
+	data = &gueh[1];
+
+	if (need_priv) {
+		__be32 *flags = data;
+		u16 csum_start = skb_checksum_start_offset(skb);
+		__be16 *pd;
+
+		gueh->flags |= GUE_FLAG_PRIV;
+		*flags = 0;
+		data += GUE_LEN_PRIV;
+
+		if (csum_start < hdrlen)
+			return -EINVAL;
+
+		csum_start -= hdrlen;
+		pd = data;
+		pd[0] = htons(csum_start);
+		pd[1] = htons(csum_start + skb->csum_offset);
+
+		if (!skb_is_gso(skb)) {
+			skb->ip_summed = CHECKSUM_NONE;
+			skb->encapsulation = 0;
+		}
+
+		*flags |= GUE_PFLAG_REMCSUM;
+		data += GUE_PLEN_REMCSUM;
+	}
+
 	skb_push(skb, sizeof(struct udphdr));
 	skb_reset_transport_header(skb);
 
@@ -1070,6 +1120,7 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	unsigned int max_headroom;		/* The extra header space needed */
 	int ret, local;
 	int tun_type, gso_type;
+	int tun_flags;
 
 	EnterFunction(10);
 
@@ -1092,9 +1143,19 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	max_headroom = LL_RESERVED_SPACE(tdev) + sizeof(struct iphdr);
 
 	tun_type = cp->dest->tun_type;
+	tun_flags = cp->dest->tun_flags;
 
-	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE)
-		max_headroom += sizeof(struct udphdr) + sizeof(struct guehdr);
+	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
+		size_t gue_hdrlen, gue_optlen = 0;
+
+		if ((tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM) &&
+		    skb->ip_summed == CHECKSUM_PARTIAL) {
+			gue_optlen += GUE_PLEN_REMCSUM + GUE_LEN_PRIV;
+		}
+		gue_hdrlen = sizeof(struct guehdr) + gue_optlen;
+
+		max_headroom += sizeof(struct udphdr) + gue_hdrlen;
+	}
 
 	/* We only care about the df field if sysctl_pmtu_disc(ipvs) is set */
 	dfp = sysctl_pmtu_disc(ipvs) ? &df : NULL;
@@ -1105,8 +1166,17 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 		goto tx_error;
 
 	gso_type = __tun_gso_type_mask(AF_INET, cp->af);
-	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE)
-		gso_type |= SKB_GSO_UDP_TUNNEL;
+	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
+		if ((tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM) ||
+		    (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM))
+			gso_type |= SKB_GSO_UDP_TUNNEL_CSUM;
+		else
+			gso_type |= SKB_GSO_UDP_TUNNEL;
+		if ((tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM) &&
+		    skb->ip_summed == CHECKSUM_PARTIAL) {
+			gso_type |= SKB_GSO_TUNNEL_REMCSUM;
+		}
+	}
 
 	if (iptunnel_handle_offloads(skb, gso_type))
 		goto tx_error;
@@ -1115,8 +1185,19 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 
 	skb_set_inner_ipproto(skb, next_protocol);
 
-	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE)
-		ipvs_gue_encap(net, skb, cp, &next_protocol);
+	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
+		bool check = false;
+
+		if (ipvs_gue_encap(net, skb, cp, &next_protocol))
+			goto tx_error;
+
+		if ((tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM) ||
+		    (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM))
+			check = true;
+
+		udp_set_csum(!check, skb, saddr, cp->daddr.ip, skb->len);
+	}
+
 
 	skb_push(skb, sizeof(struct iphdr));
 	skb_reset_network_header(skb);
@@ -1174,6 +1255,7 @@ ip_vs_tunnel_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 	unsigned int max_headroom;	/* The extra header space needed */
 	int ret, local;
 	int tun_type, gso_type;
+	int tun_flags;
 
 	EnterFunction(10);
 
@@ -1197,9 +1279,19 @@ ip_vs_tunnel_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 	max_headroom = LL_RESERVED_SPACE(tdev) + sizeof(struct ipv6hdr);
 
 	tun_type = cp->dest->tun_type;
+	tun_flags = cp->dest->tun_flags;
 
-	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE)
-		max_headroom += sizeof(struct udphdr) + sizeof(struct guehdr);
+	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
+		size_t gue_hdrlen, gue_optlen = 0;
+
+		if ((tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM) &&
+		    skb->ip_summed == CHECKSUM_PARTIAL) {
+			gue_optlen += GUE_PLEN_REMCSUM + GUE_LEN_PRIV;
+		}
+		gue_hdrlen = sizeof(struct guehdr) + gue_optlen;
+
+		max_headroom += sizeof(struct udphdr) + gue_hdrlen;
+	}
 
 	skb = ip_vs_prepare_tunneled_skb(skb, cp->af, max_headroom,
 					 &next_protocol, &payload_len,
@@ -1208,8 +1300,17 @@ ip_vs_tunnel_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 		goto tx_error;
 
 	gso_type = __tun_gso_type_mask(AF_INET6, cp->af);
-	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE)
-		gso_type |= SKB_GSO_UDP_TUNNEL;
+	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
+		if ((tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM) ||
+		    (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM))
+			gso_type |= SKB_GSO_UDP_TUNNEL_CSUM;
+		else
+			gso_type |= SKB_GSO_UDP_TUNNEL;
+		if ((tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM) &&
+		    skb->ip_summed == CHECKSUM_PARTIAL) {
+			gso_type |= SKB_GSO_TUNNEL_REMCSUM;
+		}
+	}
 
 	if (iptunnel_handle_offloads(skb, gso_type))
 		goto tx_error;
@@ -1218,8 +1319,18 @@ ip_vs_tunnel_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 
 	skb_set_inner_ipproto(skb, next_protocol);
 
-	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE)
-		ipvs_gue_encap(net, skb, cp, &next_protocol);
+	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
+		bool check = false;
+
+		if (ipvs_gue_encap(net, skb, cp, &next_protocol))
+			goto tx_error;
+
+		if ((tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM) ||
+		    (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM))
+			check = true;
+
+		udp6_set_csum(!check, skb, &saddr, &cp->daddr.in6, skb->len);
+	}
 
 	skb_push(skb, sizeof(struct ipv6hdr));
 	skb_reset_network_header(skb);
-- 
2.21.0

