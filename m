Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E58E7ED760
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 02:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbfKDB6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 20:58:10 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40593 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728432AbfKDB6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 20:58:10 -0500
Received: by mail-pg1-f196.google.com with SMTP id 15so10233540pgt.7
        for <netdev@vger.kernel.org>; Sun, 03 Nov 2019 17:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=VTio/BYbCQkSmecFMFns+vqiKXJKQ5RhebtaVjUhEQI=;
        b=NbqkgLSrR3vyRMdyQEpV7adljHt2V67Fh3GzyBneOsRgjqKoybUQJ1DHXQMqv3XrvQ
         FG2xO1KSjaz9L1tcxuqwgPLgDNKxvtGky/4csRRjRkJiK8u9bkpeQ/1c4X0jUvmZA4uJ
         RImSY3fU4WyRAt6Qua6Jhnebo/MRhGbpe4oLElhKRh5guCnNZY2p6WA4c6+cw+47RCrE
         jV/833PySnMwlVmURR4cg9eaUheXEUDQsMA3IUDhsXO3mcu5H2fQgmiGjjhcc8gzA6YP
         /teby7oaYCmRlk/HSIVU3PbUP9hyPHAv2zkJsGFlWktBwavi5JvTDs6M3RtXSOD5sT5l
         2v4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=VTio/BYbCQkSmecFMFns+vqiKXJKQ5RhebtaVjUhEQI=;
        b=WxrER07S4joGcDYdxPedWWu4Omm6AMUp1LzZ/apxFDx+8tElYchLYlJJDOzXw2yQYx
         KkuEi83sgOPc7BHKxmRQuB6ZCpzHbquWSBnQ3taMjBvnxNzq7pixCemOE7b6rqfPtMuT
         NUvaBRTedKaDm5RGFqs4SNPjuBKFWy2851qxEXT3RUbY2CoSZebKLw9p10Tal23uOGd4
         IcPqgv2DB2nljTG0sgIry2TdzMhcya3LFqYMlgtAkFmWULg14WsSDcUvzbNp1dR3ejUK
         jb6lQNu1qrDZkoD+Nx2eqxCg56AguBuIy4Zy50e1NbsGK/pnxTLrMXKCnBk3WAg/RHbH
         bjPA==
X-Gm-Message-State: APjAAAWR56Ia3tfQD6L10v2AsYWP/KFvcvL3aQeQzQX9TMWFKOdClxyp
        I7aQHZzVUq/YvkHz045YJ8/b1FPS
X-Google-Smtp-Source: APXvYqzEoGwMiBNFzv43Jo4iZIpoFg4IcPbTb45NxcDlT02/rXuktIqB/bYitxE2nLYmbT+GQri8dg==
X-Received: by 2002:aa7:8a97:: with SMTP id a23mr28009026pfc.76.1572832689151;
        Sun, 03 Nov 2019 17:58:09 -0800 (PST)
Received: from localhost.localdomain ([106.201.53.22])
        by smtp.gmail.com with ESMTPSA id d139sm21446089pfd.162.2019.11.03.17.58.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 03 Nov 2019 17:58:08 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, pshelar@ovn.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH v4 net-next] Change in Openvswitch to support MPLS label depth of 3 in ingress direction
Date:   Mon,  4 Nov 2019 07:27:44 +0530
Message-Id: <1572832664-3048-1-git-send-email-martinvarghesenokia@gmail.com>
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
Acked-by: Pravin B Shelar <pshelar@ovn.org>
---
Changes in v2:
    - Moved MPLS count validation from datapath to configuration.
    - Fixed set mpls function.

Changes in v3:
    - Updated the comments section of POP_MPLS action configuration.
    - Moved mpls_label_count variable initialization to ovs_nla_copy_actions.
      The current value of the mpls_label_count variable in the function
      __ovs_nla_copy_actions  will be passed to the functions processing
      nested actions (Eg- validate_and_copy_clone) for validations of the
      nested actions on the cloned packet.

Changes in v4:
    - Added Acked-by: Pravin B Shelar <pshelar@ovn.org> in commit message.

 net/openvswitch/actions.c      |  2 +-
 net/openvswitch/flow.c         | 20 +++++++---
 net/openvswitch/flow.h         |  9 +++--
 net/openvswitch/flow_netlink.c | 87 +++++++++++++++++++++++++++++++-----------
 4 files changed, 85 insertions(+), 33 deletions(-)

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
index d7559c6..65c2e34 100644
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
@@ -2406,13 +2426,14 @@ static inline void add_nested_action_end(struct sw_flow_actions *sfa,
 static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 				  const struct sw_flow_key *key,
 				  struct sw_flow_actions **sfa,
-				  __be16 eth_type, __be16 vlan_tci, bool log);
+				  __be16 eth_type, __be16 vlan_tci,
+				  u32 mpls_label_count, bool log);
 
 static int validate_and_copy_sample(struct net *net, const struct nlattr *attr,
 				    const struct sw_flow_key *key,
 				    struct sw_flow_actions **sfa,
 				    __be16 eth_type, __be16 vlan_tci,
-				    bool log, bool last)
+				    u32 mpls_label_count, bool log, bool last)
 {
 	const struct nlattr *attrs[OVS_SAMPLE_ATTR_MAX + 1];
 	const struct nlattr *probability, *actions;
@@ -2463,7 +2484,7 @@ static int validate_and_copy_sample(struct net *net, const struct nlattr *attr,
 		return err;
 
 	err = __ovs_nla_copy_actions(net, actions, key, sfa,
-				     eth_type, vlan_tci, log);
+				     eth_type, vlan_tci, mpls_label_count, log);
 
 	if (err)
 		return err;
@@ -2478,7 +2499,7 @@ static int validate_and_copy_clone(struct net *net,
 				   const struct sw_flow_key *key,
 				   struct sw_flow_actions **sfa,
 				   __be16 eth_type, __be16 vlan_tci,
-				   bool log, bool last)
+				   u32 mpls_label_count, bool log, bool last)
 {
 	int start, err;
 	u32 exec;
@@ -2498,7 +2519,7 @@ static int validate_and_copy_clone(struct net *net,
 		return err;
 
 	err = __ovs_nla_copy_actions(net, attr, key, sfa,
-				     eth_type, vlan_tci, log);
+				     eth_type, vlan_tci, mpls_label_count, log);
 	if (err)
 		return err;
 
@@ -2864,6 +2885,7 @@ static int validate_and_copy_check_pkt_len(struct net *net,
 					   const struct sw_flow_key *key,
 					   struct sw_flow_actions **sfa,
 					   __be16 eth_type, __be16 vlan_tci,
+					   u32 mpls_label_count,
 					   bool log, bool last)
 {
 	const struct nlattr *acts_if_greater, *acts_if_lesser_eq;
@@ -2912,7 +2934,7 @@ static int validate_and_copy_check_pkt_len(struct net *net,
 		return nested_acts_start;
 
 	err = __ovs_nla_copy_actions(net, acts_if_lesser_eq, key, sfa,
-				     eth_type, vlan_tci, log);
+				     eth_type, vlan_tci, mpls_label_count, log);
 
 	if (err)
 		return err;
@@ -2925,7 +2947,7 @@ static int validate_and_copy_check_pkt_len(struct net *net,
 		return nested_acts_start;
 
 	err = __ovs_nla_copy_actions(net, acts_if_greater, key, sfa,
-				     eth_type, vlan_tci, log);
+				     eth_type, vlan_tci, mpls_label_count, log);
 
 	if (err)
 		return err;
@@ -2952,7 +2974,8 @@ static int copy_action(const struct nlattr *from,
 static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 				  const struct sw_flow_key *key,
 				  struct sw_flow_actions **sfa,
-				  __be16 eth_type, __be16 vlan_tci, bool log)
+				  __be16 eth_type, __be16 vlan_tci,
+				  u32 mpls_label_count, bool log)
 {
 	u8 mac_proto = ovs_key_mac_proto(key);
 	const struct nlattr *a;
@@ -3065,25 +3088,36 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
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
+			/* Disallow subsequent L2.5+ set actions and mpls_pop
+			 * actions once the last MPLS label in the packet is
+			 * is popped as there is no check here to ensure that
+			 * the new eth type is valid and thus set actions could
+			 * write off the end of the packet or otherwise corrupt
+			 * it.
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
@@ -3106,6 +3140,7 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 
 			err = validate_and_copy_sample(net, a, key, sfa,
 						       eth_type, vlan_tci,
+						       mpls_label_count,
 						       log, last);
 			if (err)
 				return err;
@@ -3176,6 +3211,7 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 
 			err = validate_and_copy_clone(net, a, key, sfa,
 						      eth_type, vlan_tci,
+						      mpls_label_count,
 						      log, last);
 			if (err)
 				return err;
@@ -3188,8 +3224,9 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 
 			err = validate_and_copy_check_pkt_len(net, a, key, sfa,
 							      eth_type,
-							      vlan_tci, log,
-							      last);
+							      vlan_tci,
+							      mpls_label_count,
+							      log, last);
 			if (err)
 				return err;
 			skip_copy = true;
@@ -3219,14 +3256,18 @@ int ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 			 struct sw_flow_actions **sfa, bool log)
 {
 	int err;
+	u32 mpls_label_count = 0;
 
 	*sfa = nla_alloc_flow_actions(min(nla_len(attr), MAX_ACTIONS_BUFSIZE));
 	if (IS_ERR(*sfa))
 		return PTR_ERR(*sfa);
 
+	if (eth_p_mpls(key->eth.type))
+		mpls_label_count = hweight_long(key->mpls.num_labels_mask);
+
 	(*sfa)->orig_len = nla_len(attr);
 	err = __ovs_nla_copy_actions(net, attr, key, sfa, key->eth.type,
-				     key->eth.vlan.tci, log);
+				     key->eth.vlan.tci, mpls_label_count, log);
 	if (err)
 		ovs_nla_free_flow_actions(*sfa);
 
-- 
1.8.3.1

