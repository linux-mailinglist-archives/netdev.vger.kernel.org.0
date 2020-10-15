Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8A228F618
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 17:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389749AbgJOPrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 11:47:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50984 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389746AbgJOPq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 11:46:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602776816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WPpn/eXZenODwZxYvP9a20o768zvVVpLw71z6dbl6Wg=;
        b=VteV/eIlvjFpW8s1OysELXBTMJPoteI9ArEtWlsRbWOkpeu7SNIOnLEunoKFbLg9fHwPEh
        eJQGPVyGzFxn5l4VrObg48aLb4Xuq9EaBuZIvckNuEyOUOiqR89W3nVqEMEWFZ0F0dvyro
        k7jw/T+E7ihFOVisHAbdw/AT67d3yBg=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-CAb3dzlROSiAH6wkHfcAww-1; Thu, 15 Oct 2020 11:46:54 -0400
X-MC-Unique: CAb3dzlROSiAH6wkHfcAww-1
Received: by mail-qk1-f199.google.com with SMTP id d124so2372240qke.4
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 08:46:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=WPpn/eXZenODwZxYvP9a20o768zvVVpLw71z6dbl6Wg=;
        b=I2trtzNFsEprwSTbtHNMez0Trtwf16eIKk9mJ1AYjoKyL2slfimdmOGDQiDTugfMvx
         G7rarS0Q27+74FHBjAFD9BcBzRzJfA7fPGjfH346GDFchsEkaOjR7qFP7gz2NtDJT0/p
         HJ3Qxlna8+z2srjcA5iG5UE1c/h7XAgzWUixMok0YQEbRxKlUA3EfMo/+oUWzAyGir5u
         yj7k24meNQltZgjvvqmoJW6Ip8iyqzOXQl6tA0+F/5oJbGc10GBTTkA5AUgHItASiWWB
         DQrJiHmLiknIPKp47Cebm9FTUQpQehOKXSsgHPpGlwKlNJWYJY3p0dUk1KI215sbL2dv
         k2yA==
X-Gm-Message-State: AOAM530oRZS/JIHTIYG05jw7sDfcEtJ8Q+7EOYO9YZNwBP5kg8tiElKL
        702xF4YkWkTEvmDtAR8h3LlFRLXbxn8y8lp5EXJML/z5bXPiU9sURnocEGBFJKZc9+AJkWYC75q
        kQ+Sr8wthPFhF+14l
X-Received: by 2002:ac8:e8c:: with SMTP id v12mr4536495qti.329.1602776813493;
        Thu, 15 Oct 2020 08:46:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxUJAHA6XHi+2SXzqBZgUbAqvfAwXlbFLyuoUR7m8qOm0fbL1jRNa+ufuN994/9vgukSB1aHg==
X-Received: by 2002:ac8:e8c:: with SMTP id v12mr4536411qti.329.1602776812451;
        Thu, 15 Oct 2020 08:46:52 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id z37sm1337626qtz.67.2020.10.15.08.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 08:46:51 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C40DC1838E5; Thu, 15 Oct 2020 17:46:49 +0200 (CEST)
Subject: [PATCH RFC bpf-next 2/2] selftests: Update test_tc_neigh to use the
 modified bpf_redirect_neigh()
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Thu, 15 Oct 2020 17:46:49 +0200
Message-ID: <160277680973.157904.15451524562795164056.stgit@toke.dk>
In-Reply-To: <160277680746.157904.8726318184090980429.stgit@toke.dk>
References: <160277680746.157904.8726318184090980429.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This updates the test_tc_neigh selftest to use the new syntax of
bpf_redirect_neigh(). To exercise the helper both with and without the
optional parameter, one forwarding direction is changed to do a
bpf_fib_lookup() followed by a call to bpf_redirect_neigh(), while the
other direction is using the map-based ifindex lookup letting the redirect
helper resolve the nexthop from the FIB.

This also fixes the test_tc_redirect.sh script to work on systems that have
a consolidated dual-stack 'ping' binary instead of separate ping/ping6
versions.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/testing/selftests/bpf/progs/test_tc_neigh.c |   83 ++++++++++++++++++---
 tools/testing/selftests/bpf/test_tc_redirect.sh   |    8 +-
 2 files changed, 78 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_tc_neigh.c b/tools/testing/selftests/bpf/progs/test_tc_neigh.c
index fe182616b112..ba03e603ba9b 100644
--- a/tools/testing/selftests/bpf/progs/test_tc_neigh.c
+++ b/tools/testing/selftests/bpf/progs/test_tc_neigh.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <stdint.h>
 #include <stdbool.h>
+#include <stddef.h>
 
 #include <linux/bpf.h>
 #include <linux/stddef.h>
@@ -32,6 +33,9 @@
 				 a.s6_addr32[3] == b.s6_addr32[3])
 #endif
 
+#define AF_INET 2
+#define AF_INET6 10
+
 enum {
 	dev_src,
 	dev_dst,
@@ -45,7 +49,8 @@ struct bpf_map_def SEC("maps") ifindex_map = {
 };
 
 static __always_inline bool is_remote_ep_v4(struct __sk_buff *skb,
-					    __be32 addr)
+					    __be32 addr,
+					    struct bpf_fib_lookup *fib_params)
 {
 	void *data_end = ctx_ptr(skb->data_end);
 	void *data = ctx_ptr(skb->data);
@@ -58,11 +63,26 @@ static __always_inline bool is_remote_ep_v4(struct __sk_buff *skb,
 	if ((void *)(ip4h + 1) > data_end)
 		return false;
 
-	return ip4h->daddr == addr;
+	if (ip4h->daddr != addr)
+		return false;
+
+	if (fib_params) {
+		fib_params->family = AF_INET;
+		fib_params->tos = ip4h->tos;
+		fib_params->l4_protocol = ip4h->protocol;
+		fib_params->sport = 0;
+		fib_params->dport = 0;
+		fib_params->tot_len = bpf_ntohs(ip4h->tot_len);
+		fib_params->ipv4_src = ip4h->saddr;
+		fib_params->ipv4_dst = ip4h->daddr;
+	}
+
+	return true;
 }
 
 static __always_inline bool is_remote_ep_v6(struct __sk_buff *skb,
-					    struct in6_addr addr)
+					    struct in6_addr addr,
+					    struct bpf_fib_lookup *fib_params)
 {
 	void *data_end = ctx_ptr(skb->data_end);
 	void *data = ctx_ptr(skb->data);
@@ -75,7 +95,24 @@ static __always_inline bool is_remote_ep_v6(struct __sk_buff *skb,
 	if ((void *)(ip6h + 1) > data_end)
 		return false;
 
-	return v6_equal(ip6h->daddr, addr);
+	if (!v6_equal(ip6h->daddr, addr))
+		return false;
+
+	if (fib_params) {
+		struct in6_addr *src = (struct in6_addr *)fib_params->ipv6_src;
+		struct in6_addr *dst = (struct in6_addr *)fib_params->ipv6_dst;
+
+		fib_params->family = AF_INET6;
+		fib_params->flowinfo = 0;
+		fib_params->l4_protocol = ip6h->nexthdr;
+		fib_params->sport = 0;
+		fib_params->dport = 0;
+		fib_params->tot_len = bpf_ntohs(ip6h->payload_len);
+		*src = ip6h->saddr;
+		*dst = ip6h->daddr;
+	}
+
+	return true;
 }
 
 static __always_inline int get_dev_ifindex(int which)
@@ -99,15 +136,17 @@ SEC("chk_egress") int tc_chk(struct __sk_buff *skb)
 
 SEC("dst_ingress") int tc_dst(struct __sk_buff *skb)
 {
+	struct bpf_fib_lookup fib_params = { .ifindex = skb->ingress_ifindex };
 	__u8 zero[ETH_ALEN * 2];
 	bool redirect = false;
+	int ret;
 
 	switch (skb->protocol) {
 	case __bpf_constant_htons(ETH_P_IP):
-		redirect = is_remote_ep_v4(skb, __bpf_constant_htonl(ip4_src));
+		redirect = is_remote_ep_v4(skb, __bpf_constant_htonl(ip4_src), &fib_params);
 		break;
 	case __bpf_constant_htons(ETH_P_IPV6):
-		redirect = is_remote_ep_v6(skb, (struct in6_addr)ip6_src);
+		redirect = is_remote_ep_v6(skb, (struct in6_addr)ip6_src, &fib_params);
 		break;
 	}
 
@@ -118,7 +157,31 @@ SEC("dst_ingress") int tc_dst(struct __sk_buff *skb)
 	if (bpf_skb_store_bytes(skb, 0, &zero, sizeof(zero), 0) < 0)
 		return TC_ACT_SHOT;
 
-	return bpf_redirect_neigh(get_dev_ifindex(dev_src), 0);
+	ret = bpf_fib_lookup(skb, &fib_params, sizeof(fib_params), 0);
+	bpf_printk("bpf_fib_lookup() ret: %d\n", ret);
+	if (ret == BPF_FIB_LKUP_RET_SUCCESS) {
+		void *data_end = ctx_ptr(skb->data_end);
+		struct ethhdr *eth = ctx_ptr(skb->data);
+
+		if (eth + 1 > data_end)
+			return TC_ACT_SHOT;
+
+		__builtin_memcpy(eth->h_dest, fib_params.dmac, ETH_ALEN);
+		__builtin_memcpy(eth->h_source, fib_params.smac, ETH_ALEN);
+
+		return bpf_redirect(fib_params.ifindex, 0);
+
+	} else if (ret == BPF_FIB_LKUP_RET_NO_NEIGH) {
+		struct bpf_redir_neigh nh_params = {};
+
+		nh_params.nh_family = fib_params.family;
+		__builtin_memcpy(&nh_params.ipv6_nh, &fib_params.ipv6_dst,
+				 sizeof(nh_params.ipv6_nh));
+
+		return bpf_redirect_neigh(fib_params.ifindex, &nh_params,
+					  sizeof(nh_params), 0);
+	}
+	return TC_ACT_SHOT;
 }
 
 SEC("src_ingress") int tc_src(struct __sk_buff *skb)
@@ -128,10 +191,10 @@ SEC("src_ingress") int tc_src(struct __sk_buff *skb)
 
 	switch (skb->protocol) {
 	case __bpf_constant_htons(ETH_P_IP):
-		redirect = is_remote_ep_v4(skb, __bpf_constant_htonl(ip4_dst));
+		redirect = is_remote_ep_v4(skb, __bpf_constant_htonl(ip4_dst), NULL);
 		break;
 	case __bpf_constant_htons(ETH_P_IPV6):
-		redirect = is_remote_ep_v6(skb, (struct in6_addr)ip6_dst);
+		redirect = is_remote_ep_v6(skb, (struct in6_addr)ip6_dst, NULL);
 		break;
 	}
 
@@ -142,7 +205,7 @@ SEC("src_ingress") int tc_src(struct __sk_buff *skb)
 	if (bpf_skb_store_bytes(skb, 0, &zero, sizeof(zero), 0) < 0)
 		return TC_ACT_SHOT;
 
-	return bpf_redirect_neigh(get_dev_ifindex(dev_dst), 0);
+	return bpf_redirect_neigh(get_dev_ifindex(dev_dst), NULL, 0, 0);
 }
 
 char __license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_tc_redirect.sh b/tools/testing/selftests/bpf/test_tc_redirect.sh
index 6d7482562140..09b20f24d018 100755
--- a/tools/testing/selftests/bpf/test_tc_redirect.sh
+++ b/tools/testing/selftests/bpf/test_tc_redirect.sh
@@ -24,8 +24,7 @@ command -v timeout >/dev/null 2>&1 || \
 	{ echo >&2 "timeout is not available"; exit 1; }
 command -v ping >/dev/null 2>&1 || \
 	{ echo >&2 "ping is not available"; exit 1; }
-command -v ping6 >/dev/null 2>&1 || \
-	{ echo >&2 "ping6 is not available"; exit 1; }
+if command -v ping6 >/dev/null 2>&1; then PING6=ping6; else PING6=ping; fi
 command -v perl >/dev/null 2>&1 || \
 	{ echo >&2 "perl is not available"; exit 1; }
 command -v jq >/dev/null 2>&1 || \
@@ -152,7 +151,7 @@ netns_test_connectivity()
 	echo -e "${TEST}: ${GREEN}PASS${NC}"
 
 	TEST="ICMPv6 connectivity test"
-	ip netns exec ${NS_SRC} ping6 $PING_ARG ${IP6_DST}
+	ip netns exec ${NS_SRC} $PING6 $PING_ARG ${IP6_DST}
 	if [ $? -ne 0 ]; then
 		echo -e "${TEST}: ${RED}FAIL${NC}"
 		exit 1
@@ -179,6 +178,9 @@ netns_setup_bpf()
 	ip netns exec ${NS_FWD} tc filter add dev veth_dst_fwd ingress bpf da obj $obj sec dst_ingress
 	ip netns exec ${NS_FWD} tc filter add dev veth_dst_fwd egress  bpf da obj $obj sec chk_egress
 
+	# bpf_fib_lookup() checks if forwarding is enabled
+	ip netns exec ${NS_FWD} sysctl -w net.ipv4.ip_forward=1 net.ipv6.conf.veth_dst_fwd.forwarding=1
+
 	veth_src=$(ip netns exec ${NS_FWD} cat /sys/class/net/veth_src_fwd/ifindex)
 	veth_dst=$(ip netns exec ${NS_FWD} cat /sys/class/net/veth_dst_fwd/ifindex)
 

