Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D341DDEDC
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 16:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfJTOZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 10:25:54 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41235 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbfJTOZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 10:25:53 -0400
Received: by mail-pl1-f195.google.com with SMTP id t10so5231049plr.8
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 07:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MElpsO/w0CMC18ENM0FuwjmkPD1POMAk4zAzwHz/PPo=;
        b=EF+D9CpN3K+duAfvYGj0I1ghG2qpkBthaAjW/B6JP00Phr1ecStitz4Lf2lzhw8pBo
         z2NJc4ct3F6vgP+sQKuBtBYSRcgh3JQCfu0eyUWXbb8pZB9T752kciCwwEAC0EqRPu6E
         dmXZyJIu0g/BvKTVvAudtWuYn96/RKRu6R9pJlsC6zRfFIATyDInsMDvPr4u//wk+YDC
         G48NV5t4wt2jjg7Zs33U4rYN38JNRS2HRsEm83ucLYCm01pONORv0dA42b9UyB5PGmhl
         oqJ2lJ5tkWolQtiJKLtotk/yJkBA7lq/eevcBoQnIu6EF36jWcM7ZFMUkRgI1Bei23dU
         mq+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MElpsO/w0CMC18ENM0FuwjmkPD1POMAk4zAzwHz/PPo=;
        b=IJ7oGPFl16CgYIo3/iQX4bcd5Alu/lGpk3YMtgGV7KNR+HL6Nmpp/PFbcnaF5MCoeI
         JXaiFOyeOgm70O3g3xSXH5DmpSlgg6U/Ncr7hjmHWwx5lPhPnv1qlSi9hor9ftuit/Hf
         0gTKMTV29fs4UKDdYPnAvguNCi+Bw7JfzUWpRG7XPp0Kn2p1/4rf1EQnPnepAeLsm1eg
         AN0QdBHPJTSMxQwLsjERna1u9BD8zupi5n81gM9pKefcSG2ZID8pOQN0MsNyClfFxEj4
         4I/MLkNjjVd6wR5Ut2L/GPtBuZroEChV++A2uWg3X1t7yE8xyL0xwnsRfqGqWqRIEMAX
         0MhA==
X-Gm-Message-State: APjAAAUcgyC90S3mzU+Lr0cTVWoKXMiRz6pm+X94/aTjQqzjtCraGk8M
        kV4NGZYbEDxnsPDAu6ybaRnANjTx
X-Google-Smtp-Source: APXvYqzFyxUzdMuYDxveG7GGNtvIj0QK4MvgD6Y9UVVikc5UeHMLZCRjqMgqtQLS/1gHb3Hoqqsqyw==
X-Received: by 2002:a17:902:8bc4:: with SMTP id r4mr19000481plo.341.1571581551149;
        Sun, 20 Oct 2019 07:25:51 -0700 (PDT)
Received: from localhost.localdomain ([223.226.47.180])
        by smtp.gmail.com with ESMTPSA id x10sm11200464pgl.53.2019.10.20.07.25.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 20 Oct 2019 07:25:50 -0700 (PDT)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     dev@openvswitch.org, netdev@vger.kernel.org, pshelar@ovn.org
Cc:     Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCH] Change in openvswitch kernel module to support MPLS label depth of 3 in ingress direction.
Date:   Sun, 20 Oct 2019 19:55:32 +0530
Message-Id: <1571581532-18581-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

The openvswitch kernel module was supporting a MPLS label depth of 1
in the ingress direction though the userspace OVS supports a max depth
of 3 labels. This change enables openvswitch module to support a max
depth of 3 labels in the ingress.

Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
---
 datapath/actions.c      |  2 +-
 datapath/flow.c         | 22 ++++++++++++------
 datapath/flow.h         |  8 ++++---
 datapath/flow_netlink.c | 61 +++++++++++++++++++++++++++++++++++++------------
 tests/system-traffic.at | 39 +++++++++++++++++++++++++++++++
 5 files changed, 107 insertions(+), 25 deletions(-)

diff --git a/datapath/actions.c b/datapath/actions.c
index a44e804..fbf4457 100644
--- a/datapath/actions.c
+++ b/datapath/actions.c
@@ -276,7 +276,7 @@ static int set_mpls(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	}
 
 	stack->label_stack_entry = lse;
-	flow_key->mpls.top_lse = lse;
+	flow_key->mpls.lse[0] = lse;
 	return 0;
 }
 
diff --git a/datapath/flow.c b/datapath/flow.c
index 46e2bac..436b7a4 100644
--- a/datapath/flow.c
+++ b/datapath/flow.c
@@ -659,27 +659,35 @@ static int key_extract_l3l4(struct sk_buff *skb, struct sw_flow_key *key)
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
-
-			stack_len += MPLS_HLEN;
+			
+			label_count++;
 		}
+		if (label_count > MPLS_LABEL_DEPTH)
+			label_count = MPLS_LABEL_DEPTH;
+
+		key->mpls.num_labels_mask = GENMASK(label_count - 1, 0);
 	} else if (key->eth.type == htons(ETH_P_IPV6)) {
 		int nh_len;             /* IPv6 Header + Extensions */
 
diff --git a/datapath/flow.h b/datapath/flow.h
index 1a5df38..9b7dcaf 100644
--- a/datapath/flow.h
+++ b/datapath/flow.h
@@ -43,6 +43,7 @@ enum sw_flow_mac_proto {
 	MAC_PROTO_ETHERNET,
 };
 #define SW_FLOW_KEY_INVALID	0x80
+#define MPLS_LABEL_DEPTH       3
 
 /* Store options at the end of the array if they are less than the
  * maximum size. This allows us to get the benefits of variable length
@@ -98,9 +99,6 @@ struct sw_flow_key {
 					 */
 	union {
 		struct {
-			__be32 top_lse;	/* top label stack entry */
-		} mpls;
-		struct {
 			u8     proto;	/* IP protocol or lower 8 bits of ARP opcode. */
 			u8     tos;	    /* IP ToS. */
 			u8     ttl;	    /* IP TTL/hop limit. */
@@ -148,6 +146,10 @@ struct sw_flow_key {
 				} nd;
 			};
 		} ipv6;
+		struct {
+			u32 num_labels_mask;    /* labels present bitmap of effective length MPLS_LABEL_DEPTH */
+			__be32 lse[MPLS_LABEL_DEPTH];     /* label stack entry  */
+		} mpls;
 		struct ovs_key_nsh nsh;         /* network service header */
 	};
 	struct {
diff --git a/datapath/flow_netlink.c b/datapath/flow_netlink.c
index 0f7ab53..9c30d85 100644
--- a/datapath/flow_netlink.c
+++ b/datapath/flow_netlink.c
@@ -438,7 +438,7 @@ static const struct ovs_len_tbl ovs_key_lens[OVS_KEY_ATTR_MAX + 1] = {
 	[OVS_KEY_ATTR_DP_HASH]	 = { .len = sizeof(u32) },
 	[OVS_KEY_ATTR_TUNNEL]	 = { .len = OVS_ATTR_NESTED,
 				     .next = ovs_tunnel_key_lens, },
-	[OVS_KEY_ATTR_MPLS]	 = { .len = sizeof(struct ovs_key_mpls) },
+	[OVS_KEY_ATTR_MPLS]	 = { .len = OVS_ATTR_VARIABLE },
 	[OVS_KEY_ATTR_CT_STATE]	 = { .len = sizeof(u32) },
 	[OVS_KEY_ATTR_CT_ZONE]	 = { .len = sizeof(u16) },
 	[OVS_KEY_ATTR_CT_MARK]	 = { .len = sizeof(u32) },
@@ -1619,10 +1619,27 @@ static int ovs_key_from_nlattrs(struct net *net, struct sw_flow_match *match,
 
 	if (attrs & (1ULL << OVS_KEY_ATTR_MPLS)) {
 		const struct ovs_key_mpls *mpls_key;
+		u32 hdr_len;
+		u32 label_count, label_count_mask, i;
+		
 
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
+		
 
 		attrs &= ~(1ULL << OVS_KEY_ATTR_MPLS);
 	}
@@ -2103,13 +2120,18 @@ static int __ovs_nla_put_key(const struct sw_flow_key *swkey,
 		ether_addr_copy(arp_key->arp_sha, output->ipv4.arp.sha);
 		ether_addr_copy(arp_key->arp_tha, output->ipv4.arp.tha);
 	} else if (eth_p_mpls(swkey->eth.type)) {
+		u8 num_labels, i;
 		struct ovs_key_mpls *mpls_key;
-
-		nla = nla_reserve(skb, OVS_KEY_ATTR_MPLS, sizeof(*mpls_key));
+		
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
@@ -2950,6 +2972,10 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 	u8 mac_proto = ovs_key_mac_proto(key);
 	const struct nlattr *a;
 	int rem, err;
+	u32 mpls_label_count = 0;
+	
+	if (eth_p_mpls(eth_type))
+		mpls_label_count = hweight_long(key->mpls.num_labels_mask);
 
 	nla_for_each_nested(a, attr, rem) {
 		/* Expected argument lengths, (u32)-1 for variable length. */
@@ -3058,26 +3084,33 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
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
+			 * no check here to ensure that the new eth_type is
+			 * valid and thus set actions could write off the
+			 * end of the packet or otherwise  corrupt it.
 			 *
 			 * Support for these actions is planned using packet
 			 * recirculation.
 			 */
-			eth_type = htons(0);
-			break;
+			proto = nla_get_be16(a);
+			mpls_label_count--;
 
+			if (!eth_p_mpls(proto) || !mpls_label_count)
+				eth_type = htons(0);
+			else
+				eth_type =  proto;
+			break;
+		}
 		case OVS_ACTION_ATTR_SET:
 			err = validate_set(a, key, sfa,
 					   &skip_copy, mac_proto, eth_type,
diff --git a/tests/system-traffic.at b/tests/system-traffic.at
index 870a05e..cde7429 100644
--- a/tests/system-traffic.at
+++ b/tests/system-traffic.at
@@ -992,6 +992,45 @@ NS_CHECK_EXEC([at_ns1], [ping -q -c 3 -i 0.3 -w 2 10.1.1.1 | FORMAT_PING], [0],
 
 OVS_TRAFFIC_VSWITCHD_STOP
 AT_CLEANUP
+
+AT_SETUP([datapath - multiple mpls label pop])
+OVS_TRAFFIC_VSWITCHD_START([_ADD_BR([br1])])
+
+ADD_NAMESPACES(at_ns0, at_ns1)
+
+ADD_VETH(p0, at_ns0, br0, "10.1.1.1/24")
+ADD_VETH(p1, at_ns1, br1, "10.1.1.2/24")
+
+AT_CHECK([ip link add patch0 type veth peer name patch1])
+on_exit 'ip link del patch0'
+
+AT_CHECK([ip link set dev patch0 up])
+AT_CHECK([ip link set dev patch1 up])
+AT_CHECK([ovs-vsctl add-port br0 patch0])
+AT_CHECK([ovs-vsctl add-port br1 patch1])
+
+AT_DATA([flows.txt], [dnl
+table=0,priority=100,dl_type=0x0800 actions=push_mpls:0x8847,set_mpls_label:3,push_mpls:0x8847,set_mpls_label:2,push_mpls:0x8847,set_mpls_label:1,resubmit(,3)
+table=0,priority=100,dl_type=0x8847,mpls_label=1 actions=pop_mpls:0x8847,resubmit(,1)
+table=1,priority=100,dl_type=0x8847,mpls_label=2 actions=pop_mpls:0x8847,resubmit(,2)
+table=2,priority=100,dl_type=0x8847,mpls_label=3 actions=pop_mpls:0x0800,resubmit(,3)
+table=0,priority=10 actions=resubmit(,3)
+table=3,priority=10 actions=normal
+])
+
+AT_CHECK([ovs-ofctl add-flows br0 flows.txt])
+AT_CHECK([ovs-ofctl add-flows br1 flows.txt])
+
+NS_CHECK_EXEC([at_ns0], [ping -q -c 3 -i 0.3 -w 2 10.1.1.2 | FORMAT_PING], [0], [dnl
+3 packets transmitted, 3 received, 0% packet loss, time 0ms
+])
+
+NS_CHECK_EXEC([at_ns1], [ping -q -c 3 -i 0.3 -w 2 10.1.1.1 | FORMAT_PING], [0], [dnl
+3 packets transmitted, 3 received, 0% packet loss, time 0ms
+])
+OVS_TRAFFIC_VSWITCHD_STOP
+AT_CLEANUP
+
 AT_SETUP([datapath - basic truncate action])
 AT_SKIP_IF([test $HAVE_NC = no])
 OVS_TRAFFIC_VSWITCHD_START()
-- 
1.8.3.1

