Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3428FCF1CE
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 06:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730045AbfJHElc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 00:41:32 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36170 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729656AbfJHEl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 00:41:29 -0400
Received: by mail-pg1-f194.google.com with SMTP id 23so9581824pgk.3
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 21:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=hdacB/xcYLGlOtsHJxm/C1/ssCga+9XVQUBZIpt1e1o=;
        b=AWcgcJ8SVtTa4LY7oOoSulcFLKOg90VKam++RmDCRO10JQN1g33T4Ue37i8B2ZYV+2
         EM7W4kA0U4ug95SzpUv/pAy+cXFbqzoTgyfUjEMe65tOhS5v+921jR5Eq/tVKdOpqVM9
         uBTU6E2Ihriznlf++wCyjDZgSPNIkPwi56sGOR+OYmisZq/Q/BHQTn7gGAn+IRgVSloX
         2NDvgVi4fWPfvMIoML025wqH1Ef0JEs4SR1z8w045bnsJChg1yZ4h24ZdKVxHyowQqdR
         y8YkJxANVcYIAAPQBsbSQXiaLLdsrV9kCW2S0KzTZSgBB9M5gBDkFJJOMS1rDkZz9zWm
         bA3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hdacB/xcYLGlOtsHJxm/C1/ssCga+9XVQUBZIpt1e1o=;
        b=CyvHVBxKlqoQSEOzbUdWi49EimRExUDPQZbwWPE95L6ay7jY6vH7uIZX7YJTl0SCvN
         HMVOHTf4n6vr5oxkbcN7ihAWTO2neLsbhyMjq/0DLWQW5QRPsj8howVw+a92UWZmTHIr
         s3+fxyWTzERhqQE3be8Hg+rxXs2lk/dstG4gFBvX6BgCZJHwCJpgzqtylZkUhidZjxXX
         sLYHlK7952z8ENRbq64mTmqwIL3HQvGdsm3ag0INKkulpHOapCxanODGYj2eMfJRsUW0
         ZQPv7SNZDceHuQwyKnwLvdtw+Awdj8eGVvPO8Xarn+ldCan0R4/yicYVR+kwTnk95bKm
         X3YA==
X-Gm-Message-State: APjAAAUnt5XMzH2CLry42+kEb+4gTv5+BlbVaHhhdfTK0kH5oPpM4+1U
        Y+T+L5uQf+CLU2CxM9VWfxL4Y66v
X-Google-Smtp-Source: APXvYqyG4jbPlySL4xH1JJUQPAjZvIsJJSj9Qr4KTK/jbAIvSsE/PGwhy8ikc/jPK8t8Cr8HLlXqVQ==
X-Received: by 2002:aa7:97b0:: with SMTP id d16mr37491479pfq.54.1570509686870;
        Mon, 07 Oct 2019 21:41:26 -0700 (PDT)
Received: from martin-VirtualBox.dlink.router ([122.178.241.240])
        by smtp.gmail.com with ESMTPSA id 127sm21778581pfy.56.2019.10.07.21.41.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 07 Oct 2019 21:41:26 -0700 (PDT)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, pshelar@ovn.org,
        jbenc@redhat.com, scott.drennan@nokia.com,
        martin.varghese@nokia.com
Cc:     Martin Varghese <martinvarghesenokia@gmail.com>
Subject: [PATCH net-next] Change in Openvswitch to support MPLS label depth of 3 in ingress direction
Date:   Tue,  8 Oct 2019 10:10:31 +0530
Message-Id: <1570509631-13008-1-git-send-email-martinvarghesenokia@gmail.com>
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

Signed-off-by: Martin Varghese <martinvarghesenokia@gmail.com>
---
 net/openvswitch/actions.c      | 10 +++++++-
 net/openvswitch/flow.c         | 20 ++++++++++-----
 net/openvswitch/flow.h         |  9 ++++---
 net/openvswitch/flow_netlink.c | 55 +++++++++++++++++++++++++++++++++---------
 4 files changed, 72 insertions(+), 22 deletions(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 3572e11..eb5bed5 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -178,10 +178,14 @@ static int pop_mpls(struct sk_buff *skb, struct sw_flow_key *key,
 {
 	int err;
 
+	if (!key->mpls.num_labels_mask)
+		return -EINVAL;
+
 	err = skb_mpls_pop(skb, ethertype);
 	if (err)
 		return err;
 
+	key->mpls.num_labels_mask >>= 1;
 	invalidate_flow_key(key);
 	return 0;
 }
@@ -192,6 +196,7 @@ static int set_mpls(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	struct mpls_shim_hdr *stack;
 	__be32 lse;
 	int err;
+	u32 i = 0;
 
 	stack = mpls_hdr(skb);
 	lse = OVS_MASKED(stack->label_stack_entry, *mpls_lse, *mask);
@@ -199,7 +204,10 @@ static int set_mpls(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	if (err)
 		return err;
 
-	flow_key->mpls.top_lse = lse;
+	for (i = MPLS_LABEL_DEPTH - 1; i > 0; i--)
+		flow_key->mpls.lse[i] = flow_key->mpls.lse[i - 1];
+
+	flow_key->mpls.lse[i] = *mpls_lse;
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
index d7559c6..4eb04e9 100644
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
@@ -1628,10 +1628,26 @@ static int ovs_key_from_nlattrs(struct net *net, struct sw_flow_match *match,
 
 	if (attrs & (1 << OVS_KEY_ATTR_MPLS)) {
 		const struct ovs_key_mpls *mpls_key;
+		u32 hdr_len = 0;
+		u32 label_count = 0, i = 0;
+		u32 label_count_mask = 0;
 
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
@@ -2114,13 +2130,22 @@ static int __ovs_nla_put_key(const struct sw_flow_key *swkey,
 		ether_addr_copy(arp_key->arp_sha, output->ipv4.arp.sha);
 		ether_addr_copy(arp_key->arp_tha, output->ipv4.arp.tha);
 	} else if (eth_p_mpls(swkey->eth.type)) {
+		u8 i = 0;
+		u8 num_labels;
 		struct ovs_key_mpls *mpls_key;
 
-		nla = nla_reserve(skb, OVS_KEY_ATTR_MPLS, sizeof(*mpls_key));
+		num_labels = hweight_long(output->mpls.num_labels_mask);
+		if (num_labels >= MPLS_LABEL_DEPTH)
+			num_labels = MPLS_LABEL_DEPTH;
+
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
@@ -3068,22 +3093,28 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
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
+
+			proto = nla_get_be16(a);
+			if (!eth_p_mpls(proto))
+				eth_type = htons(0);
+			else
+				eth_type =  proto;
 			break;
+		}
 
 		case OVS_ACTION_ATTR_SET:
 			err = validate_set(a, key, sfa,
-- 
1.8.3.1

