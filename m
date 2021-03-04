Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A379632CD0A
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 07:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235528AbhCDGnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 01:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235522AbhCDGnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 01:43:04 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBFAC061574;
        Wed,  3 Mar 2021 22:42:24 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id y67so346010pfb.2;
        Wed, 03 Mar 2021 22:42:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6M6ApE/0+QbU/nK0IfHtVgl3XfPUvglfLxcfZWaMiDs=;
        b=hGCebz3G7KbKVG90rs8QGIsqLWJTL53O6tUUOF1g5uBjJ33Q+tkdc58TZsR0ur4Zg7
         x2qOtwyUHZGcYyCX7A1T//rkR7jmE/coXLPuse2Zt/Vtcz8e+VNHuwnKBCmoYeDdO5Ti
         ftdoVYxJ5KbIf6cT0PWZWs8gj4HUVtfwYkNMsImmY5JNQADqIOHcn8GqoiBOYpnHh/nt
         /FYgKcKMsQr3AgiEKYnM6K07wmFcZOodY4u1kvG9+mrncdeXj33DUwFG8ExhQ2BLB9n/
         HeOYZQlC17y/kXxDWahXYo+4vMnNJnXwXjwF5AEZ0y+oPCP/mw/D1RZjgQcrR6MCmEQ0
         ox/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6M6ApE/0+QbU/nK0IfHtVgl3XfPUvglfLxcfZWaMiDs=;
        b=GYSq5vo9Qysj1AqtZRN2Cd6mG/H51VL+WABlHstOXPysiqYLRK2OJghNGfgVoK8Xu+
         VR3qrdkrt1kk8VldFpPR/BTTPgyrzieMCZwK1Sj0zhF5lG3/OPfzGE6MfWS4Blt3pCSo
         aS4O84t0NJ06Qu1gJdff+RsZR2VKu3Czt8siyv8xOlcWJCLXiVc3ngQYTH3cER3M5IHT
         T3C4y9PuZYgWaNEh8SFTMfrQj7NA/cx9zhIY6unf963pjOJ++NqCkOwhp9e24Iel5gpg
         1n8HWwPvEZRfCV5rYrIJKPOUt/+SjwpCGjaSkrRvw46KZEQylwX4BsyEWGH+r8V+ujsv
         X/Iw==
X-Gm-Message-State: AOAM530LSk1ybfzPzgMoaP8UiyzYaGQrvYNkZPJPWyiOuVe5AL33LrQP
        zkSzuASmd1BFVA0cyEDCpgo=
X-Google-Smtp-Source: ABdhPJwKHLYSUbka/hwauMA/bZ6NvjrzRU0kzpTBOoewZMNLm7LrcFaR7AhkBFw9ZRsXAZu2cL1CcQ==
X-Received: by 2002:a62:7e01:0:b029:1ed:8173:40a1 with SMTP id z1-20020a627e010000b02901ed817340a1mr2520716pfc.6.1614840143894;
        Wed, 03 Mar 2021 22:42:23 -0800 (PST)
Received: from localhost.localdomain ([154.48.252.65])
        by smtp.gmail.com with ESMTPSA id k27sm928916pfg.95.2021.03.03.22.42.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Mar 2021 22:42:23 -0800 (PST)
From:   Xuesen Huang <hxseverything@gmail.com>
To:     daniel@iogearbox.net
Cc:     davem@davemloft.net, bpf@vger.kernel.org,
        willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
        Xuesen Huang <huangxuesen@kuaishou.com>,
        Li Wang <wangli09@kuaishou.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH] selftests_bpf: extend test_tc_tunnel test with vxlan
Date:   Thu,  4 Mar 2021 14:42:12 +0800
Message-Id: <20210304064212.6513-1-hxseverything@gmail.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xuesen Huang <huangxuesen@kuaishou.com>

Add BPF_F_ADJ_ROOM_ENCAP_L2_ETH flag to the existing tests which
encapsulates the ethernet as the inner l2 header.

Update a vxlan encapsulation test case.

Signed-off-by: Xuesen Huang <huangxuesen@kuaishou.com>
Signed-off-by: Li Wang <wangli09@kuaishou.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/bpf/progs/test_tc_tunnel.c | 113 ++++++++++++++++++---
 tools/testing/selftests/bpf/test_tc_tunnel.sh      |  15 ++-
 2 files changed, 111 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_tc_tunnel.c b/tools/testing/selftests/bpf/progs/test_tc_tunnel.c
index 37bce7a..dbd18d0 100644
--- a/tools/testing/selftests/bpf/progs/test_tc_tunnel.c
+++ b/tools/testing/selftests/bpf/progs/test_tc_tunnel.c
@@ -24,14 +24,29 @@
 
 static const int cfg_udp_src = 20000;
 
+#define	L2_PAD_SZ	(sizeof(struct vxlanhdr) + ETH_HLEN)
+
 #define	UDP_PORT		5555
 #define	MPLS_OVER_UDP_PORT	6635
 #define	ETH_OVER_UDP_PORT	7777
+#define	VXLAN_UDP_PORT		8472
+
+#define	EXTPROTO_VXLAN	0x1
+
+#define	VXLAN_N_VID     (1u << 24)
+#define	VXLAN_VNI_MASK	bpf_htonl((VXLAN_N_VID - 1) << 8)
+#define	VXLAN_FLAGS     0x8
+#define	VXLAN_VNI       1
 
 /* MPLS label 1000 with S bit (last label) set and ttl of 255. */
 static const __u32 mpls_label = __bpf_constant_htonl(1000 << 12 |
 						     MPLS_LS_S_MASK | 0xff);
 
+struct vxlanhdr {
+	__be32 vx_flags;
+	__be32 vx_vni;
+} __attribute__((packed));
+
 struct gre_hdr {
 	__be16 flags;
 	__be16 protocol;
@@ -45,13 +60,13 @@ struct gre_hdr {
 struct v4hdr {
 	struct iphdr ip;
 	union l4hdr l4hdr;
-	__u8 pad[16];			/* enough space for L2 header */
+	__u8 pad[L2_PAD_SZ];		/* space for L2 header / vxlan header ... */
 } __attribute__((packed));
 
 struct v6hdr {
 	struct ipv6hdr ip;
 	union l4hdr l4hdr;
-	__u8 pad[16];			/* enough space for L2 header */
+	__u8 pad[L2_PAD_SZ];		/* space for L2 header / vxlan header ... */
 } __attribute__((packed));
 
 static __always_inline void set_ipv4_csum(struct iphdr *iph)
@@ -69,14 +84,15 @@ static __always_inline void set_ipv4_csum(struct iphdr *iph)
 	iph->check = ~((csum & 0xffff) + (csum >> 16));
 }
 
-static __always_inline int encap_ipv4(struct __sk_buff *skb, __u8 encap_proto,
-				      __u16 l2_proto)
+static __always_inline int __encap_ipv4(struct __sk_buff *skb, __u8 encap_proto,
+					__u16 l2_proto, __u16 ext_proto)
 {
 	__u16 udp_dst = UDP_PORT;
 	struct iphdr iph_inner;
 	struct v4hdr h_outer;
 	struct tcphdr tcph;
 	int olen, l2_len;
+	__u8 *l2_hdr = NULL;
 	int tcp_off;
 	__u64 flags;
 
@@ -141,7 +157,11 @@ static __always_inline int encap_ipv4(struct __sk_buff *skb, __u8 encap_proto,
 		break;
 	case ETH_P_TEB:
 		l2_len = ETH_HLEN;
-		udp_dst = ETH_OVER_UDP_PORT;
+		if (ext_proto & EXTPROTO_VXLAN) {
+			udp_dst = VXLAN_UDP_PORT;
+			l2_len += sizeof(struct vxlanhdr);
+		} else
+			udp_dst = ETH_OVER_UDP_PORT;
 		break;
 	}
 	flags |= BPF_F_ADJ_ROOM_ENCAP_L2(l2_len);
@@ -171,14 +191,26 @@ static __always_inline int encap_ipv4(struct __sk_buff *skb, __u8 encap_proto,
 	}
 
 	/* add L2 encap (if specified) */
+	l2_hdr = (__u8 *)&h_outer + olen;
 	switch (l2_proto) {
 	case ETH_P_MPLS_UC:
-		*((__u32 *)((__u8 *)&h_outer + olen)) = mpls_label;
+		*(__u32 *)l2_hdr = mpls_label;
 		break;
 	case ETH_P_TEB:
-		if (bpf_skb_load_bytes(skb, 0, (__u8 *)&h_outer + olen,
-				       ETH_HLEN))
+		flags |= BPF_F_ADJ_ROOM_ENCAP_L2_ETH;
+
+		if (ext_proto & EXTPROTO_VXLAN) {
+			struct vxlanhdr *vxlan_hdr = (struct vxlanhdr *)l2_hdr;
+
+			vxlan_hdr->vx_flags = VXLAN_FLAGS;
+			vxlan_hdr->vx_vni = bpf_htonl((VXLAN_VNI & VXLAN_VNI_MASK) << 8);
+
+			l2_hdr += sizeof(struct vxlanhdr);
+		}
+
+		if (bpf_skb_load_bytes(skb, 0, l2_hdr, ETH_HLEN))
 			return TC_ACT_SHOT;
+
 		break;
 	}
 	olen += l2_len;
@@ -214,14 +246,21 @@ static __always_inline int encap_ipv4(struct __sk_buff *skb, __u8 encap_proto,
 	return TC_ACT_OK;
 }
 
-static __always_inline int encap_ipv6(struct __sk_buff *skb, __u8 encap_proto,
+static __always_inline int encap_ipv4(struct __sk_buff *skb, __u8 encap_proto,
 				      __u16 l2_proto)
 {
+	return __encap_ipv4(skb, encap_proto, l2_proto, 0);
+}
+
+static __always_inline int __encap_ipv6(struct __sk_buff *skb, __u8 encap_proto,
+					__u16 l2_proto, __u16 ext_proto)
+{
 	__u16 udp_dst = UDP_PORT;
 	struct ipv6hdr iph_inner;
 	struct v6hdr h_outer;
 	struct tcphdr tcph;
 	int olen, l2_len;
+	__u8 *l2_hdr = NULL;
 	__u16 tot_len;
 	__u64 flags;
 
@@ -249,7 +288,11 @@ static __always_inline int encap_ipv6(struct __sk_buff *skb, __u8 encap_proto,
 		break;
 	case ETH_P_TEB:
 		l2_len = ETH_HLEN;
-		udp_dst = ETH_OVER_UDP_PORT;
+		if (ext_proto & EXTPROTO_VXLAN) {
+			udp_dst = VXLAN_UDP_PORT;
+			l2_len += sizeof(struct vxlanhdr);
+		} else
+			udp_dst = ETH_OVER_UDP_PORT;
 		break;
 	}
 	flags |= BPF_F_ADJ_ROOM_ENCAP_L2(l2_len);
@@ -267,7 +310,7 @@ static __always_inline int encap_ipv6(struct __sk_buff *skb, __u8 encap_proto,
 		h_outer.l4hdr.udp.source = __bpf_constant_htons(cfg_udp_src);
 		h_outer.l4hdr.udp.dest = bpf_htons(udp_dst);
 		tot_len = bpf_ntohs(iph_inner.payload_len) + sizeof(iph_inner) +
-			  sizeof(h_outer.l4hdr.udp);
+			  sizeof(h_outer.l4hdr.udp) + l2_len;
 		h_outer.l4hdr.udp.check = 0;
 		h_outer.l4hdr.udp.len = bpf_htons(tot_len);
 		break;
@@ -278,13 +321,24 @@ static __always_inline int encap_ipv6(struct __sk_buff *skb, __u8 encap_proto,
 	}
 
 	/* add L2 encap (if specified) */
+	l2_hdr = (__u8 *)&h_outer + olen;
 	switch (l2_proto) {
 	case ETH_P_MPLS_UC:
-		*((__u32 *)((__u8 *)&h_outer + olen)) = mpls_label;
+		*(__u32 *)l2_hdr = mpls_label;
 		break;
 	case ETH_P_TEB:
-		if (bpf_skb_load_bytes(skb, 0, (__u8 *)&h_outer + olen,
-				       ETH_HLEN))
+		flags |= BPF_F_ADJ_ROOM_ENCAP_L2_ETH;
+
+		if (ext_proto & EXTPROTO_VXLAN) {
+			struct vxlanhdr *vxlan_hdr = (struct vxlanhdr *)l2_hdr;
+
+			vxlan_hdr->vx_flags = VXLAN_FLAGS;
+			vxlan_hdr->vx_vni = bpf_htonl((VXLAN_VNI & VXLAN_VNI_MASK) << 8);
+
+			l2_hdr += sizeof(struct vxlanhdr);
+		}
+
+		if (bpf_skb_load_bytes(skb, 0, l2_hdr, ETH_HLEN))
 			return TC_ACT_SHOT;
 		break;
 	}
@@ -309,6 +363,12 @@ static __always_inline int encap_ipv6(struct __sk_buff *skb, __u8 encap_proto,
 	return TC_ACT_OK;
 }
 
+static __always_inline int encap_ipv6(struct __sk_buff *skb, __u8 encap_proto,
+				      __u16 l2_proto)
+{
+	return __encap_ipv6(skb, encap_proto, l2_proto, 0);
+}
+
 SEC("encap_ipip_none")
 int __encap_ipip_none(struct __sk_buff *skb)
 {
@@ -372,6 +432,17 @@ int __encap_udp_eth(struct __sk_buff *skb)
 		return TC_ACT_OK;
 }
 
+SEC("encap_vxlan_eth")
+int __encap_vxlan_eth(struct __sk_buff *skb)
+{
+	if (skb->protocol == __bpf_constant_htons(ETH_P_IP))
+		return __encap_ipv4(skb, IPPROTO_UDP,
+				ETH_P_TEB,
+				EXTPROTO_VXLAN);
+	else
+		return TC_ACT_OK;
+}
+
 SEC("encap_sit_none")
 int __encap_sit_none(struct __sk_buff *skb)
 {
@@ -444,6 +515,17 @@ int __encap_ip6udp_eth(struct __sk_buff *skb)
 		return TC_ACT_OK;
 }
 
+SEC("encap_ip6vxlan_eth")
+int __encap_ip6vxlan_eth(struct __sk_buff *skb)
+{
+	if (skb->protocol == __bpf_constant_htons(ETH_P_IPV6))
+		return __encap_ipv6(skb, IPPROTO_UDP,
+				ETH_P_TEB,
+				EXTPROTO_VXLAN);
+	else
+		return TC_ACT_OK;
+}
+
 static int decap_internal(struct __sk_buff *skb, int off, int len, char proto)
 {
 	char buf[sizeof(struct v6hdr)];
@@ -479,6 +561,9 @@ static int decap_internal(struct __sk_buff *skb, int off, int len, char proto)
 		case ETH_OVER_UDP_PORT:
 			olen += ETH_HLEN;
 			break;
+		case VXLAN_UDP_PORT:
+			olen += ETH_HLEN + sizeof(struct vxlanhdr);
+			break;
 		}
 		break;
 	default:
diff --git a/tools/testing/selftests/bpf/test_tc_tunnel.sh b/tools/testing/selftests/bpf/test_tc_tunnel.sh
index 7c76b84..c9dde9b 100755
--- a/tools/testing/selftests/bpf/test_tc_tunnel.sh
+++ b/tools/testing/selftests/bpf/test_tc_tunnel.sh
@@ -44,8 +44,8 @@ setup() {
 	# clamp route to reserve room for tunnel headers
 	ip -netns "${ns1}" -4 route flush table main
 	ip -netns "${ns1}" -6 route flush table main
-	ip -netns "${ns1}" -4 route add "${ns2_v4}" mtu 1458 dev veth1
-	ip -netns "${ns1}" -6 route add "${ns2_v6}" mtu 1438 dev veth1
+	ip -netns "${ns1}" -4 route add "${ns2_v4}" mtu 1450 dev veth1
+	ip -netns "${ns1}" -6 route add "${ns2_v6}" mtu 1430 dev veth1
 
 	sleep 1
 
@@ -105,6 +105,12 @@ if [[ "$#" -eq "0" ]]; then
 	echo "sit"
 	$0 ipv6 sit none 100
 
+	echo "ip4 vxlan"
+	$0 ipv4 vxlan eth 2000
+
+	echo "ip6 vxlan"
+	$0 ipv6 ip6vxlan eth 2000
+
 	for mac in none mpls eth ; do
 		echo "ip gre $mac"
 		$0 ipv4 gre $mac 100
@@ -214,6 +220,9 @@ if [[ "$tuntype" =~ "udp" ]]; then
 	targs="encap fou encap-sport auto encap-dport $dport"
 elif [[ "$tuntype" =~ "gre" && "$mac" == "eth" ]]; then
 	ttype=$gretaptype
+elif [[ "$tuntype" =~ "vxlan" && "$mac" == "eth" ]]; then
+	ttype="vxlan"
+	targs="id 1 dstport 8472 udp6zerocsumrx"
 else
 	ttype=$tuntype
 	targs=""
@@ -242,7 +251,7 @@ if [[ "$tuntype" == "ip6udp" && "$mac" == "mpls" ]]; then
 elif [[ "$tuntype" =~ "udp" && "$mac" == "eth" ]]; then
 	# No support for TEB fou tunnel; expect failure.
 	expect_tun_fail=1
-elif [[ "$tuntype" =~ "gre" && "$mac" == "eth" ]]; then
+elif [[ "$tuntype" =~ (gre|vxlan) && "$mac" == "eth" ]]; then
 	# Share ethernet address between tunnel/veth2 so L2 decap works.
 	ethaddr=$(ip netns exec "${ns2}" ip link show veth2 | \
 		  awk '/ether/ { print $2 }')
-- 
1.8.3.1

