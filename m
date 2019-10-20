Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFDA4DDECB
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 16:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfJTOMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 10:12:00 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37432 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfJTOL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 10:11:59 -0400
Received: by mail-pg1-f195.google.com with SMTP id p1so6040737pgi.4
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 07:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=AH2ZO2QNejQ5RuIe9blxysxo1e89K85TGMIof+0f4qU=;
        b=EX9+lJrcPqaey5sbLtKOApdlxRlJLdPbCa7lgqo2i6pdHNbNGlDJ3Yo885TQhh5Ibt
         gm6L5w8iRWAZbV/XVevXTcYm+MZ4QYhTbxE23ICGlFETQW2dnVssN/ScXXrb19+iV4VR
         GggmTYLM2kCUpDHVs+x4Z2tmOQFZajbpMOr7WZQOckBWLGwYcZ+kCTgfwm6e93ZYCQlR
         KPBB6FCK95k9vK9ymoN/lh8FgW8LY/7oXRHs4AwScWB4SLI4i5CNRdaYk/js5PzZlF9j
         Sl3r5eFZyQbe26Wfr4jKWvB+aGCDsyHzqFTpvtTgfgRQrZ9gRbWpOboVSMp/eszLDnFQ
         S40w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=AH2ZO2QNejQ5RuIe9blxysxo1e89K85TGMIof+0f4qU=;
        b=gQZ3YzxGIOBplit0dcC8U+0U7c+ufBhYHZLBrTCBGsrWHjJ/XJ2xBbxhM15Yd9T2ne
         MgXpzd8zVgpud47tiUcjBllHrrxC6HYrNqN5+1vdv6FI4s2Q0S51zRrF318r1lX0L3qP
         R8i1in0gbwF+3QZpS4B6jF5ow/z066JgIxf/zQsVdW/otjCzrBVbJ1Wld5LmrED9GkIg
         9zicJOipIchFkCR1uru8XfZwywXiqnSjGkZQaZuFQQJRyUbqRRzcQC8bNqRCceEmbNL9
         O7Afv9HYTvi74XA51CrkbJAWLN1e4Rnf+gMIRuFBx9Kd/mh+4/gXJKyMVJt4LcXwdUfY
         D0Wg==
X-Gm-Message-State: APjAAAUDtb2TNvnK0tqkb8M4BfP0JYTGUD+9VWetWBN21eFUxcaXv+AC
        uGChuT6NKlatCJSjxigWzCNUKdZp
X-Google-Smtp-Source: APXvYqwgfqJDhEBhnuedwmJVjEW3R/W4Mj6nTNHj0gtDds75FM5+Xb8+aii/NJqeTsVAONJY34IV3w==
X-Received: by 2002:a63:4b06:: with SMTP id y6mr10833201pga.409.1571580718501;
        Sun, 20 Oct 2019 07:11:58 -0700 (PDT)
Received: from localhost.localdomain ([223.226.47.180])
        by smtp.gmail.com with ESMTPSA id j25sm13535797pfi.113.2019.10.20.07.11.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 20 Oct 2019 07:11:58 -0700 (PDT)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH v2] Change in Openvswitch to support MPLS label depth of 3 in ingress direction
Date:   Sun, 20 Oct 2019 19:41:42 +0530
Message-Id: <1571580702-18476-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

The openvswitch was supporting a MPLS label depth of 1 in the ingress
direction though the userspace OVS supports a max depth of 3 labels.
This change enables openvswitch module to support a max depth of
3 labels in the ingress.

Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
---
Changes in v2
   - Moved MPLS count validation from datapath to configuration.
   - Fixed set mpls function.

 net/openvswitch/actions.c      |  2 +-
 net/openvswitch/flow.c         | 20 ++++++++++-----
 net/openvswitch/flow.h         |  9 ++++---
 net/openvswitch/flow_netlink.c | 57 +++++++++++++++++++++++++++++++++---------
 4 files changed, 66 insertions(+), 22 deletions(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 3572e11..f3125d7 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -199,7 +199,7 @@ static int set_mpls(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	if (err)
 		return err;
 
-	flow_key->mpls.top_lse = lse;
+	flow_key->mpls.lse[0] = lse;
 	return 0;
 }
 
diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index dca3b1e..c101355 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -699,27 +699,35 @@ static int key_extract(struct sk_buff *skb, struct sw_flow_key *key)
 			memset(&key->ipv4, 0, sizeof(key->ipv4));
 		}
 	} else if (eth_p_mpls(key->eth.type)) {
-		size_t stack_len = MPLS_HLEN;
+		u8 label_count = 1;
 
+		memset(&key->mpls, 0, sizeof(key->mpls));
 		skb_set_inner_network_header(skb, skb->mac_len);
 		while (1) {
 			__be32 lse;
 
-			error = check_header(skb, skb->mac_len + stack_len);
+			error = check_header(skb, skb->mac_len +
+					     label_count * MPLS_HLEN);
 			if (unlikely(error))
 				return 0;
 
 			memcpy(&lse, skb_inner_network_header(skb), MPLS_HLEN);
 
-			if (stack_len == MPLS_HLEN)
-				memcpy(&key->mpls.top_lse, &lse, MPLS_HLEN);
+			if (label_count <= MPLS_LABEL_DEPTH)
+				memcpy(&key->mpls.lse[label_count - 1], &lse,
+				       MPLS_HLEN);
 
-			skb_set_inner_network_header(skb, skb->mac_len + stack_len);
+			skb_set_inner_network_header(skb, skb->mac_len +
+						     label_count * MPLS_HLEN);
 			if (lse & htonl(MPLS_LS_S_MASK))
 				break;
 
-			stack_len += MPLS_HLEN;
+			label_count++;
 		}
+		if (label_count > MPLS_LABEL_DEPTH)
+			label_count = MPLS_LABEL_DEPTH;
+
+		key->mpls.num_labels_mask = GENMASK(label_count - 1, 0);
 	} else if (key->eth.type == htons(ETH_P_IPV6)) {
 		int nh_len;             /* IPv6 Header + Extensions */
 
diff --git a/net/openvswitch/flow.h b/net/openvswitch/flow.h
index 3e2cc22..d9eccbe 100644
--- a/net/openvswitch/flow.h
+++ b/net/openvswitch/flow.h
@@ -30,6 +30,7 @@ enum sw_flow_mac_proto {
 	MAC_PROTO_ETHERNET,
 };
 #define SW_FLOW_KEY_INVALID	0x80
+#define MPLS_LABEL_DEPTH       3
 
 /* Store options at the end of the array if they are less than the
  * maximum size. This allows us to get the benefits of variable length
@@ -85,9 +86,6 @@ struct sw_flow_key {
 					 */
 	union {
 		struct {
-			__be32 top_lse;	/* top label stack entry */
-		} mpls;
-		struct {
 			u8     proto;	/* IP protocol or lower 8 bits of ARP opcode. */
 			u8     tos;	    /* IP ToS. */
 			u8     ttl;	    /* IP TTL/hop limit. */
@@ -135,6 +133,11 @@ struct sw_flow_key {
 				} nd;
 			};
 		} ipv6;
+		struct {
+			u32 num_labels_mask;    /* labels present bitmap of effective length MPLS_LABEL_DEPTH */
+			__be32 lse[MPLS_LABEL_DEPTH];     /* label stack entry  */
+		} mpls;
+
 		struct ovs_key_nsh nsh;         /* network service header */
 	};
 	struct {
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index d7559c6..21de061 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -424,7 +424,7 @@ size_t ovs_key_attr_size(void)
 	[OVS_KEY_ATTR_DP_HASH]	 = { .len = sizeof(u32) },
 	[OVS_KEY_ATTR_TUNNEL]	 = { .len = OVS_ATTR_NESTED,
 				     .next = ovs_tunnel_key_lens, },
-	[OVS_KEY_ATTR_MPLS]	 = { .len = sizeof(struct ovs_key_mpls) },
+	[OVS_KEY_ATTR_MPLS]	 = { .len = OVS_ATTR_VARIABLE },
 	[OVS_KEY_ATTR_CT_STATE]	 = { .len = sizeof(u32) },
 	[OVS_KEY_ATTR_CT_ZONE]	 = { .len = sizeof(u16) },
 	[OVS_KEY_ATTR_CT_MARK]	 = { .len = sizeof(u32) },
@@ -1628,10 +1628,25 @@ static int ovs_key_from_nlattrs(struct net *net, struct sw_flow_match *match,
 
 	if (attrs & (1 << OVS_KEY_ATTR_MPLS)) {
 		const struct ovs_key_mpls *mpls_key;
+		u32 hdr_len;
+		u32 label_count, label_count_mask, i;
 
 		mpls_key = nla_data(a[OVS_KEY_ATTR_MPLS]);
-		SW_FLOW_KEY_PUT(match, mpls.top_lse,
-				mpls_key->mpls_lse, is_mask);
+		hdr_len = nla_len(a[OVS_KEY_ATTR_MPLS]);
+		label_count = hdr_len / sizeof(struct ovs_key_mpls);
+
+		if (label_count == 0 || label_count > MPLS_LABEL_DEPTH ||
+		    hdr_len % sizeof(struct ovs_key_mpls))
+			return -EINVAL;
+
+		label_count_mask =  GENMASK(label_count - 1, 0);
+
+		for (i = 0 ; i < label_count; i++)
+			SW_FLOW_KEY_PUT(match, mpls.lse[i],
+					mpls_key[i].mpls_lse, is_mask);
+
+		SW_FLOW_KEY_PUT(match, mpls.num_labels_mask,
+				label_count_mask, is_mask);
 
 		attrs &= ~(1 << OVS_KEY_ATTR_MPLS);
 	 }
@@ -2114,13 +2129,18 @@ static int __ovs_nla_put_key(const struct sw_flow_key *swkey,
 		ether_addr_copy(arp_key->arp_sha, output->ipv4.arp.sha);
 		ether_addr_copy(arp_key->arp_tha, output->ipv4.arp.tha);
 	} else if (eth_p_mpls(swkey->eth.type)) {
+		u8 i, num_labels;
 		struct ovs_key_mpls *mpls_key;
 
-		nla = nla_reserve(skb, OVS_KEY_ATTR_MPLS, sizeof(*mpls_key));
+		num_labels = hweight_long(output->mpls.num_labels_mask);
+		nla = nla_reserve(skb, OVS_KEY_ATTR_MPLS,
+				  num_labels * sizeof(*mpls_key));
 		if (!nla)
 			goto nla_put_failure;
+
 		mpls_key = nla_data(nla);
-		mpls_key->mpls_lse = output->mpls.top_lse;
+		for (i = 0; i < num_labels; i++)
+			mpls_key[i].mpls_lse = output->mpls.lse[i];
 	}
 
 	if ((swkey->eth.type == htons(ETH_P_IP) ||
@@ -2957,6 +2977,10 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 	u8 mac_proto = ovs_key_mac_proto(key);
 	const struct nlattr *a;
 	int rem, err;
+	u32 mpls_label_count = 0;
+
+	if (eth_p_mpls(eth_type))
+		mpls_label_count = hweight_long(key->mpls.num_labels_mask);
 
 	nla_for_each_nested(a, attr, rem) {
 		/* Expected argument lengths, (u32)-1 for variable length. */
@@ -3065,25 +3089,34 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 			     !eth_p_mpls(eth_type)))
 				return -EINVAL;
 			eth_type = mpls->mpls_ethertype;
+			mpls_label_count++;
 			break;
 		}
 
-		case OVS_ACTION_ATTR_POP_MPLS:
+		case OVS_ACTION_ATTR_POP_MPLS: {
+			__be16  proto;
 			if (vlan_tci & htons(VLAN_CFI_MASK) ||
 			    !eth_p_mpls(eth_type))
 				return -EINVAL;
 
-			/* Disallow subsequent L2.5+ set and mpls_pop actions
-			 * as there is no check here to ensure that the new
-			 * eth_type is valid and thus set actions could
-			 * write off the end of the packet or otherwise
-			 * corrupt it.
+			/* Disallow subsequent L2.5+ set actions as there is
+			 * no check here to ensure that the new eth type is
+			 * valid and thus set actions could write off the
+			 * end of the packet or otherwise corrupt it.
 			 *
 			 * Support for these actions is planned using packet
 			 * recirculation.
 			 */
-			eth_type = htons(0);
+			proto = nla_get_be16(a);
+			mpls_label_count--;
+
+			if (!eth_p_mpls(proto) || !mpls_label_count)
+				eth_type = htons(0);
+			else
+				eth_type =  proto;
+
 			break;
+		}
 
 		case OVS_ACTION_ATTR_SET:
 			err = validate_set(a, key, sfa,
-- 
1.8.3.1

