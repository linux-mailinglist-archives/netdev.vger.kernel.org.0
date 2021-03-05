Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C6F32E9BB
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 13:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhCEMee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 07:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbhCEMeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 07:34:01 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D14C061574;
        Fri,  5 Mar 2021 04:34:00 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id z7so1346608plk.7;
        Fri, 05 Mar 2021 04:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cDHYQDViqzbpPf+x8O2nWKo0ig3l2N7a3nIJaBpZ9Y4=;
        b=TPDsyCvA4Y5/27S4/O2jroS7o6q5W+ZE6+YngV5+9PwpMJF18OBkcRaZGmVFx6QGau
         f6EGIpF72OaZ8/oTieSW/cLyluS8zYp4S1WsougUXH9gAABLsVVpAh3ffG33PbjvWkAl
         4ljrDCEkawsGECTlzpLzgUTzI0z2WBMEpnuxyGNOjDURf6//1tBQfyp/GCw7S1wRT2+A
         UHNAwFBzNRiHVYdWil/CSo5KzlKyTQSQuAAb+0EfnDvi2HU1J3vrwlbejXK69/l1RHuX
         8EuTBK/Aj8szFvBRhD6cxZKHZvJLOc9gWYvSO8xxthOs+zipvtdXv01w9uwMGlPfzfHy
         2Jxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cDHYQDViqzbpPf+x8O2nWKo0ig3l2N7a3nIJaBpZ9Y4=;
        b=h63ttDeooce9txBtzyTPX1mmvJsYXOH50z27WnoraSkqMASOqHW2gh/iZE9TkwFeGg
         qO4VsVA2adI8E8xus1LmH7RSB6k/tyYVRj0u2LAqw+HoAgCvp49Ert6JNRmZBFW0A1FT
         tFWoj88KpvXay6vB/03tdYWAkD7co3iIO6IILS0AAbvZ2UG1ykuBpGbMozuXVbHkhPqz
         cEQ0JkQ36LePFrOjEsDDcPy+TP2gU4PW76+AiHaEJEWA7sROBy9cf9ngMczXGk3q8px0
         QDbhcNAO4m9aP55syFM49s2OsDTZko5mrfAHMy/NcJc6fmB4Gu7KB1TpIyL60a+GQlk2
         GWKw==
X-Gm-Message-State: AOAM532mKecQTvbAL7sZIsw08gGBxwW7f0EpREeH/I/mEEk5lXqP90m8
        IGsqgBqDfGm/NeLbjoQC5eU=
X-Google-Smtp-Source: ABdhPJxPpx1JFMRYtztDeHi3aTdktu921hWamTM9h+cXWZYblG2XlGj7mPALotaW8ZD2LjUMsMz56g==
X-Received: by 2002:a17:90a:9f48:: with SMTP id q8mr10215203pjv.53.1614947640441;
        Fri, 05 Mar 2021 04:34:00 -0800 (PST)
Received: from localhost.localdomain ([103.112.79.202])
        by smtp.gmail.com with ESMTPSA id r2sm2388898pgv.50.2021.03.05.04.33.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Mar 2021 04:33:59 -0800 (PST)
From:   Xuesen Huang <hxseverything@gmail.com>
To:     daniel@iogearbox.net
Cc:     davem@davemloft.net, bpf@vger.kernel.org,
        willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xuesen Huang <huangxuesen@kuaishou.com>,
        Li Wang <wangli09@kuaishou.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH bpf-next] selftests_bpf: extend test_tc_tunnel test with vxlan
Date:   Fri,  5 Mar 2021 20:33:47 +0800
Message-Id: <20210305123347.15311-1-hxseverything@gmail.com>
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
index 37bce7a..84cd632 100644
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
+				    ETH_P_TEB,
+				    EXTPROTO_VXLAN);
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
+				    ETH_P_TEB,
+				    EXTPROTO_VXLAN);
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

