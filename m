Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91BBE4C216F
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 03:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiBXB7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 20:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiBXB7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 20:59:13 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46D7369E1;
        Wed, 23 Feb 2022 17:58:43 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id d28so710217wra.4;
        Wed, 23 Feb 2022 17:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5rO8/LEXc8vM3CDmgvs8mKLJED1noP9X5+MoNpw+Ok0=;
        b=Uyjxgeh5FujIzp/Qs7XcrKOgPspWCmm3j4YwHcybjMdQpVCpXvODLfh8eeC6egAAPm
         lO4jgQLPk7eMQDpnEgdFwqJUIDun+TPNErJ/Nn0g1VihOrGH7emgQO2RSOcnogjFYHqu
         OFMMqFyxGF9pO3pfNJWmBHPmGOwGsDCtQoNbJ5WigSgk4d8K67UIurgQCJEMBThVsrZE
         zBxgGiBPoTe3jbBUpt6dGipoYhk2ONLsE+OiwPzC4djvP/00e/eZTxgg/j+mBclJ2UxN
         80NX4srtuMgVuibN0dpPj4dXnpEaCZGw+jnwDGzSL/+X/sa77g6zxnVvhgUEELz2zxgV
         YdOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5rO8/LEXc8vM3CDmgvs8mKLJED1noP9X5+MoNpw+Ok0=;
        b=d0C6rzRZCPYeSWJGWH0qcFiI8MHvtxq+aVp19+hRkbZgTUOMxWy4NnlwsQgcgt1xue
         X9D5o0w6JAOntSJGNMn+q2wb2cqUykyn64773knH6dbKLWjrWPj1KDvHxuqjJKcW5hPl
         PGbPol+SxMqYK9mYUYchuvJquO69XM2RGIHBkTY4nhFAzg9iFTPI1fAS2D6feyWtRrlk
         /gnTS6lcByquS01BLPpvZLGa3f+CqiibvokbZ1coU7LnRYqniobEYQ75dE86tRBwfkBj
         3rc/RpFAWTAhasZ1+bRfi7ZSCZC5R3lTa6VGAs51jVeWKH81Heg4qdGxrCWlP++cMzQ9
         mgRQ==
X-Gm-Message-State: AOAM532hK0y6b/i4iQN7xf8i3zQgaKekquf3pYcJL/3dmV68JQVT5P4V
        eLy3OXaDaldVsEEw748fQGxC0cH3i1cWFA==
X-Google-Smtp-Source: ABdhPJxKcByP/UB49bHSwwyNWSEaiKbkz1n8otZcIpxCd7fVBiEQvA6l9+FZj7lO+q0FDoGW/Hpbpw==
X-Received: by 2002:adf:f6c3:0:b0:1e4:9b8f:8f72 with SMTP id y3-20020adff6c3000000b001e49b8f8f72mr185345wrp.287.1645664053805;
        Wed, 23 Feb 2022 16:54:13 -0800 (PST)
Received: from ubuntu.localdomain ([80.89.73.160])
        by smtp.googlemail.com with ESMTPSA id j27sm1024334wrd.32.2022.02.23.16.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 16:54:13 -0800 (PST)
From:   Toms Atteka <cpp.code.lv@gmail.com>
To:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        kuba@kernel.org, dev@openvswitch.org, linux-kernel@vger.kernel.org
Cc:     Toms Atteka <cpp.code.lv@gmail.com>
Subject: [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6 extension header support
Date:   Wed, 23 Feb 2022 16:54:09 -0800
Message-Id: <20220224005409.411626-1-cpp.code.lv@gmail.com>
X-Mailer: git-send-email 2.25.1
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

This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
packets can be filtered using ipv6_ext flag.

Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>
Acked-by: Pravin B Shelar <pshelar@ovn.org>
---
 include/uapi/linux/openvswitch.h |   6 ++
 net/openvswitch/flow.c           | 140 +++++++++++++++++++++++++++++++
 net/openvswitch/flow.h           |  14 ++++
 net/openvswitch/flow_netlink.c   |  26 +++++-
 4 files changed, 184 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index 150bcff49b1c..9d1710f20505 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -351,6 +351,7 @@ enum ovs_key_attr {
 	OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV4,   /* struct ovs_key_ct_tuple_ipv4 */
 	OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV6,   /* struct ovs_key_ct_tuple_ipv6 */
 	OVS_KEY_ATTR_NSH,       /* Nested set of ovs_nsh_key_* */
+	OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
 
 #ifdef __KERNEL__
 	OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info */
@@ -430,6 +431,11 @@ struct ovs_key_ipv6 {
 	__u8   ipv6_frag;	/* One of OVS_FRAG_TYPE_*. */
 };
 
+/* separate structure to support backward compatibility with older user space */
+struct ovs_key_ipv6_exthdrs {
+	__u16  hdrs;
+};
+
 struct ovs_key_tcp {
 	__be16 tcp_src;
 	__be16 tcp_dst;
diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index f6cd24fd530c..8df73d86b968 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -241,6 +241,144 @@ static bool icmphdr_ok(struct sk_buff *skb)
 				  sizeof(struct icmphdr));
 }
 
+/**
+ * get_ipv6_ext_hdrs() - Parses packet and sets IPv6 extension header flags.
+ *
+ * @skb: buffer where extension header data starts in packet
+ * @nh: ipv6 header
+ * @ext_hdrs: flags are stored here
+ *
+ * OFPIEH12_UNREP is set if more than one of a given IPv6 extension header
+ * is unexpectedly encountered. (Two destination options headers may be
+ * expected and would not cause this bit to be set.)
+ *
+ * OFPIEH12_UNSEQ is set if IPv6 extension headers were not in the order
+ * preferred (but not required) by RFC 2460:
+ *
+ * When more than one extension header is used in the same packet, it is
+ * recommended that those headers appear in the following order:
+ *      IPv6 header
+ *      Hop-by-Hop Options header
+ *      Destination Options header
+ *      Routing header
+ *      Fragment header
+ *      Authentication header
+ *      Encapsulating Security Payload header
+ *      Destination Options header
+ *      upper-layer header
+ */
+static void get_ipv6_ext_hdrs(struct sk_buff *skb, struct ipv6hdr *nh,
+			      u16 *ext_hdrs)
+{
+	u8 next_type = nh->nexthdr;
+	unsigned int start = skb_network_offset(skb) + sizeof(struct ipv6hdr);
+	int dest_options_header_count = 0;
+
+	*ext_hdrs = 0;
+
+	while (ipv6_ext_hdr(next_type)) {
+		struct ipv6_opt_hdr _hdr, *hp;
+
+		switch (next_type) {
+		case IPPROTO_NONE:
+			*ext_hdrs |= OFPIEH12_NONEXT;
+			/* stop parsing */
+			return;
+
+		case IPPROTO_ESP:
+			if (*ext_hdrs & OFPIEH12_ESP)
+				*ext_hdrs |= OFPIEH12_UNREP;
+			if ((*ext_hdrs & ~(OFPIEH12_HOP | OFPIEH12_DEST |
+					   OFPIEH12_ROUTER | IPPROTO_FRAGMENT |
+					   OFPIEH12_AUTH | OFPIEH12_UNREP)) ||
+			    dest_options_header_count >= 2) {
+				*ext_hdrs |= OFPIEH12_UNSEQ;
+			}
+			*ext_hdrs |= OFPIEH12_ESP;
+			break;
+
+		case IPPROTO_AH:
+			if (*ext_hdrs & OFPIEH12_AUTH)
+				*ext_hdrs |= OFPIEH12_UNREP;
+			if ((*ext_hdrs &
+			     ~(OFPIEH12_HOP | OFPIEH12_DEST | OFPIEH12_ROUTER |
+			       IPPROTO_FRAGMENT | OFPIEH12_UNREP)) ||
+			    dest_options_header_count >= 2) {
+				*ext_hdrs |= OFPIEH12_UNSEQ;
+			}
+			*ext_hdrs |= OFPIEH12_AUTH;
+			break;
+
+		case IPPROTO_DSTOPTS:
+			if (dest_options_header_count == 0) {
+				if (*ext_hdrs &
+				    ~(OFPIEH12_HOP | OFPIEH12_UNREP))
+					*ext_hdrs |= OFPIEH12_UNSEQ;
+				*ext_hdrs |= OFPIEH12_DEST;
+			} else if (dest_options_header_count == 1) {
+				if (*ext_hdrs &
+				    ~(OFPIEH12_HOP | OFPIEH12_DEST |
+				      OFPIEH12_ROUTER | OFPIEH12_FRAG |
+				      OFPIEH12_AUTH | OFPIEH12_ESP |
+				      OFPIEH12_UNREP)) {
+					*ext_hdrs |= OFPIEH12_UNSEQ;
+				}
+			} else {
+				*ext_hdrs |= OFPIEH12_UNREP;
+			}
+			dest_options_header_count++;
+			break;
+
+		case IPPROTO_FRAGMENT:
+			if (*ext_hdrs & OFPIEH12_FRAG)
+				*ext_hdrs |= OFPIEH12_UNREP;
+			if ((*ext_hdrs & ~(OFPIEH12_HOP |
+					   OFPIEH12_DEST |
+					   OFPIEH12_ROUTER |
+					   OFPIEH12_UNREP)) ||
+			    dest_options_header_count >= 2) {
+				*ext_hdrs |= OFPIEH12_UNSEQ;
+			}
+			*ext_hdrs |= OFPIEH12_FRAG;
+			break;
+
+		case IPPROTO_ROUTING:
+			if (*ext_hdrs & OFPIEH12_ROUTER)
+				*ext_hdrs |= OFPIEH12_UNREP;
+			if ((*ext_hdrs & ~(OFPIEH12_HOP |
+					   OFPIEH12_DEST |
+					   OFPIEH12_UNREP)) ||
+			    dest_options_header_count >= 2) {
+				*ext_hdrs |= OFPIEH12_UNSEQ;
+			}
+			*ext_hdrs |= OFPIEH12_ROUTER;
+			break;
+
+		case IPPROTO_HOPOPTS:
+			if (*ext_hdrs & OFPIEH12_HOP)
+				*ext_hdrs |= OFPIEH12_UNREP;
+			/* OFPIEH12_HOP is set to 1 if a hop-by-hop IPv6
+			 * extension header is present as the first
+			 * extension header in the packet.
+			 */
+			if (*ext_hdrs == 0)
+				*ext_hdrs |= OFPIEH12_HOP;
+			else
+				*ext_hdrs |= OFPIEH12_UNSEQ;
+			break;
+
+		default:
+			return;
+		}
+
+		hp = skb_header_pointer(skb, start, sizeof(_hdr), &_hdr);
+		if (!hp)
+			break;
+		next_type = hp->nexthdr;
+		start += ipv6_optlen(hp);
+	};
+}
+
 static int parse_ipv6hdr(struct sk_buff *skb, struct sw_flow_key *key)
 {
 	unsigned short frag_off;
@@ -256,6 +394,8 @@ static int parse_ipv6hdr(struct sk_buff *skb, struct sw_flow_key *key)
 
 	nh = ipv6_hdr(skb);
 
+	get_ipv6_ext_hdrs(skb, nh, &key->ipv6.exthdrs);
+
 	key->ip.proto = NEXTHDR_NONE;
 	key->ip.tos = ipv6_get_dsfield(nh);
 	key->ip.ttl = nh->hop_limit;
diff --git a/net/openvswitch/flow.h b/net/openvswitch/flow.h
index 758a8c77f736..073ab73ffeaa 100644
--- a/net/openvswitch/flow.h
+++ b/net/openvswitch/flow.h
@@ -32,6 +32,19 @@ enum sw_flow_mac_proto {
 #define SW_FLOW_KEY_INVALID	0x80
 #define MPLS_LABEL_DEPTH       3
 
+/* Bit definitions for IPv6 Extension Header pseudo-field. */
+enum ofp12_ipv6exthdr_flags {
+	OFPIEH12_NONEXT = 1 << 0,   /* "No next header" encountered. */
+	OFPIEH12_ESP    = 1 << 1,   /* Encrypted Sec Payload header present. */
+	OFPIEH12_AUTH   = 1 << 2,   /* Authentication header present. */
+	OFPIEH12_DEST   = 1 << 3,   /* 1 or 2 dest headers present. */
+	OFPIEH12_FRAG   = 1 << 4,   /* Fragment header present. */
+	OFPIEH12_ROUTER = 1 << 5,   /* Router header present. */
+	OFPIEH12_HOP    = 1 << 6,   /* Hop-by-hop header present. */
+	OFPIEH12_UNREP  = 1 << 7,   /* Unexpected repeats encountered. */
+	OFPIEH12_UNSEQ  = 1 << 8    /* Unexpected sequencing encountered. */
+};
+
 /* Store options at the end of the array if they are less than the
  * maximum size. This allows us to get the benefits of variable length
  * matching for small options.
@@ -121,6 +134,7 @@ struct sw_flow_key {
 				struct in6_addr dst;	/* IPv6 destination address. */
 			} addr;
 			__be32 label;			/* IPv6 flow label. */
+			u16 exthdrs;	/* IPv6 extension header flags */
 			union {
 				struct {
 					struct in6_addr src;
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index fd1f809e9bc1..8b4124820f7d 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -346,7 +346,7 @@ size_t ovs_key_attr_size(void)
 	/* Whenever adding new OVS_KEY_ FIELDS, we should consider
 	 * updating this function.
 	 */
-	BUILD_BUG_ON(OVS_KEY_ATTR_TUNNEL_INFO != 29);
+	BUILD_BUG_ON(OVS_KEY_ATTR_TUNNEL_INFO != 30);
 
 	return    nla_total_size(4)   /* OVS_KEY_ATTR_PRIORITY */
 		+ nla_total_size(0)   /* OVS_KEY_ATTR_TUNNEL */
@@ -369,7 +369,8 @@ size_t ovs_key_attr_size(void)
 		+ nla_total_size(2)   /* OVS_KEY_ATTR_ETHERTYPE */
 		+ nla_total_size(40)  /* OVS_KEY_ATTR_IPV6 */
 		+ nla_total_size(2)   /* OVS_KEY_ATTR_ICMPV6 */
-		+ nla_total_size(28); /* OVS_KEY_ATTR_ND */
+		+ nla_total_size(28)  /* OVS_KEY_ATTR_ND */
+		+ nla_total_size(2);  /* OVS_KEY_ATTR_IPV6_EXTHDRS */
 }
 
 static const struct ovs_len_tbl ovs_vxlan_ext_key_lens[OVS_VXLAN_EXT_MAX + 1] = {
@@ -437,6 +438,8 @@ static const struct ovs_len_tbl ovs_key_lens[OVS_KEY_ATTR_MAX + 1] = {
 		.len = sizeof(struct ovs_key_ct_tuple_ipv6) },
 	[OVS_KEY_ATTR_NSH]       = { .len = OVS_ATTR_NESTED,
 				     .next = ovs_nsh_key_attr_lens, },
+	[OVS_KEY_ATTR_IPV6_EXTHDRS] = {
+		.len = sizeof(struct ovs_key_ipv6_exthdrs) },
 };
 
 static bool check_attr_len(unsigned int attr_len, unsigned int expected_len)
@@ -1597,6 +1600,17 @@ static int ovs_key_from_nlattrs(struct net *net, struct sw_flow_match *match,
 		attrs &= ~(1 << OVS_KEY_ATTR_IPV6);
 	}
 
+	if (attrs & (1ULL << OVS_KEY_ATTR_IPV6_EXTHDRS)) {
+		const struct ovs_key_ipv6_exthdrs *ipv6_exthdrs_key;
+
+		ipv6_exthdrs_key = nla_data(a[OVS_KEY_ATTR_IPV6_EXTHDRS]);
+
+		SW_FLOW_KEY_PUT(match, ipv6.exthdrs,
+				ipv6_exthdrs_key->hdrs, is_mask);
+
+		attrs &= ~(1ULL << OVS_KEY_ATTR_IPV6_EXTHDRS);
+	}
+
 	if (attrs & (1 << OVS_KEY_ATTR_ARP)) {
 		const struct ovs_key_arp *arp_key;
 
@@ -2099,6 +2113,7 @@ static int __ovs_nla_put_key(const struct sw_flow_key *swkey,
 		ipv4_key->ipv4_frag = output->ip.frag;
 	} else if (swkey->eth.type == htons(ETH_P_IPV6)) {
 		struct ovs_key_ipv6 *ipv6_key;
+		struct ovs_key_ipv6_exthdrs *ipv6_exthdrs_key;
 
 		nla = nla_reserve(skb, OVS_KEY_ATTR_IPV6, sizeof(*ipv6_key));
 		if (!nla)
@@ -2113,6 +2128,13 @@ static int __ovs_nla_put_key(const struct sw_flow_key *swkey,
 		ipv6_key->ipv6_tclass = output->ip.tos;
 		ipv6_key->ipv6_hlimit = output->ip.ttl;
 		ipv6_key->ipv6_frag = output->ip.frag;
+
+		nla = nla_reserve(skb, OVS_KEY_ATTR_IPV6_EXTHDRS,
+				  sizeof(*ipv6_exthdrs_key));
+		if (!nla)
+			goto nla_put_failure;
+		ipv6_exthdrs_key = nla_data(nla);
+		ipv6_exthdrs_key->hdrs = output->ipv6.exthdrs;
 	} else if (swkey->eth.type == htons(ETH_P_NSH)) {
 		if (nsh_key_to_nlattr(&output->nsh, is_mask, skb))
 			goto nla_put_failure;
-- 
2.25.1

