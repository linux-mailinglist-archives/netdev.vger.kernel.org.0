Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9A72ACAB1
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 02:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730305AbgKJBug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 20:50:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgKJBue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 20:50:34 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD44C0613CF;
        Mon,  9 Nov 2020 17:50:34 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id t18so5670723plo.0;
        Mon, 09 Nov 2020 17:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M7rzHsCS1yIJcA/qqX6UnG9mp9ur0EUWcj8bwhqBdIg=;
        b=Q2fdXmCjhBXHEX/X2QT7yGJCzrpisN8qAV2shSGkL42gF6r1gxOykjZ4sVpXW6IxTd
         9n1PjJMK1nlhWHRHjrMfdlq/s+9BBMwqG8OqP250NarfSXAFUSaPXGq1cN/RwicNzCXe
         8xGyroLBgQ9oqZ6Xf8g3sh6Lj6L0BC1oDi73rXCaya+rAVhqBPg/YhSmcD6SNBdi53zc
         csSGhh9yFxzd8pTQFhGRckSgOq+LukyRLrEKvE/GLJgRpZ1CMJxfV4BIWfmV6OHxq/Ld
         p6mLiXMMd93G5z8Zr4mGeYKV8Iy9i3kPyq2zOGZVWTYgS0tOJ97oVTcRi35CPC8w/hXW
         bmFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M7rzHsCS1yIJcA/qqX6UnG9mp9ur0EUWcj8bwhqBdIg=;
        b=lYaL1eiqCnhK/ZmaTPao9KuhjoVJMQvJijGHYuLYarmo36WRdA+xT8Mhy2VmPnlaDi
         9QXWmLfSAtzwU7VIyuApxf0AW+tWtVIKfSGQwM7DZiBpyXKi1wV8KUhpHhM0tEFBUMqa
         NFBBTDr1sZvcfoe0N0ENDoFvg5kfbz12au/svDxRJ0PZsDp7OOAPiVEMOE5YUJjBCi5U
         j+e+Neoy3rREHaVZiG/eSSPkYMpGwI1SPGS+xpBh1ANAalwYbTMJPLMUL6I4P6D5trMq
         UlysJYRk19wvZIzcoe6xXu5alYbtLc1zqpuAXcCvgHJZl9mGNDXCvc9I2oMtix+rHWzJ
         4x8A==
X-Gm-Message-State: AOAM532dNOOmBRl9960DiqAkJ5GG+u57bFX7reiwGNgCIPqRudA+MN4S
        P4L2uNGdtATGIkXgbfi3H6EK1FcgwN2xWA==
X-Google-Smtp-Source: ABdhPJyuz/KYHuwGJWaFpAc6aPdyhz+uaRiR4ghVNwqXs8zZMvBr7YGwUX5dZluLtfddHxDcw/EoCA==
X-Received: by 2002:a17:902:a518:b029:d6:8da3:970b with SMTP id s24-20020a170902a518b02900d68da3970bmr14558297plq.7.1604973033663;
        Mon, 09 Nov 2020 17:50:33 -0800 (PST)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z13sm7956783pff.167.2020.11.09.17.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 17:50:33 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 bpf 1/2] selftest/bpf: add missed ip6ip6 test back
Date:   Tue, 10 Nov 2020 09:50:12 +0800
Message-Id: <20201110015013.1570716-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201110015013.1570716-1-liuhangbin@gmail.com>
References: <20201106090117.3755588-1-liuhangbin@gmail.com>
 <20201110015013.1570716-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In comment 173ca26e9b51 ("samples/bpf: add comprehensive ipip, ipip6,
ip6ip6 test") we added ip6ip6 test for bpf tunnel testing. But in commit
933a741e3b82 ("selftests/bpf: bpf tunnel test.") when we moved it to
the current folder, we didn't add it.

This patch add the ip6ip6 test back to bpf tunnel test. Update the ipip6's
topology for both IPv4 and IPv6 testing. Since iperf test is removed as
currect framework simplified it in purpose, I also removed unused tcp
checkings in test_tunnel_kern.c.

Fixes: 933a741e3b82 ("selftests/bpf: bpf tunnel test.")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---

v3:
Add back ICMP check as Martin suggested.

v2:
update add_ipip6tnl_tunnel() to add_ip6tnl_tunnel()
keep the _ip6ip6_set_tunnel() section.
---
 .../selftests/bpf/progs/test_tunnel_kern.c    | 42 +++---------------
 tools/testing/selftests/bpf/test_tunnel.sh    | 43 +++++++++++++++++--
 2 files changed, 46 insertions(+), 39 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
index f48dbfe24ddc..a621b58ab079 100644
--- a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
@@ -15,7 +15,6 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/types.h>
-#include <linux/tcp.h>
 #include <linux/socket.h>
 #include <linux/pkt_cls.h>
 #include <linux/erspan.h>
@@ -528,12 +527,11 @@ int _ipip_set_tunnel(struct __sk_buff *skb)
 	struct bpf_tunnel_key key = {};
 	void *data = (void *)(long)skb->data;
 	struct iphdr *iph = data;
-	struct tcphdr *tcp = data + sizeof(*iph);
 	void *data_end = (void *)(long)skb->data_end;
 	int ret;
 
 	/* single length check */
-	if (data + sizeof(*iph) + sizeof(*tcp) > data_end) {
+	if (data + sizeof(*iph) > data_end) {
 		ERROR(1);
 		return TC_ACT_SHOT;
 	}
@@ -541,16 +539,6 @@ int _ipip_set_tunnel(struct __sk_buff *skb)
 	key.tunnel_ttl = 64;
 	if (iph->protocol == IPPROTO_ICMP) {
 		key.remote_ipv4 = 0xac100164; /* 172.16.1.100 */
-	} else {
-		if (iph->protocol != IPPROTO_TCP || iph->ihl != 5)
-			return TC_ACT_SHOT;
-
-		if (tcp->dest == bpf_htons(5200))
-			key.remote_ipv4 = 0xac100164; /* 172.16.1.100 */
-		else if (tcp->dest == bpf_htons(5201))
-			key.remote_ipv4 = 0xac100165; /* 172.16.1.101 */
-		else
-			return TC_ACT_SHOT;
 	}
 
 	ret = bpf_skb_set_tunnel_key(skb, &key, sizeof(key), 0);
@@ -585,19 +573,20 @@ int _ipip6_set_tunnel(struct __sk_buff *skb)
 	struct bpf_tunnel_key key = {};
 	void *data = (void *)(long)skb->data;
 	struct iphdr *iph = data;
-	struct tcphdr *tcp = data + sizeof(*iph);
 	void *data_end = (void *)(long)skb->data_end;
 	int ret;
 
 	/* single length check */
-	if (data + sizeof(*iph) + sizeof(*tcp) > data_end) {
+	if (data + sizeof(*iph) > data_end) {
 		ERROR(1);
 		return TC_ACT_SHOT;
 	}
 
 	__builtin_memset(&key, 0x0, sizeof(key));
-	key.remote_ipv6[3] = bpf_htonl(0x11); /* ::11 */
 	key.tunnel_ttl = 64;
+	if (iph->protocol == IPPROTO_ICMP) {
+		key.remote_ipv6[3] = bpf_htonl(0x11); /* ::11 */
+	}
 
 	ret = bpf_skb_set_tunnel_key(skb, &key, sizeof(key),
 				     BPF_F_TUNINFO_IPV6);
@@ -634,35 +623,18 @@ int _ip6ip6_set_tunnel(struct __sk_buff *skb)
 	struct bpf_tunnel_key key = {};
 	void *data = (void *)(long)skb->data;
 	struct ipv6hdr *iph = data;
-	struct tcphdr *tcp = data + sizeof(*iph);
 	void *data_end = (void *)(long)skb->data_end;
 	int ret;
 
 	/* single length check */
-	if (data + sizeof(*iph) + sizeof(*tcp) > data_end) {
+	if (data + sizeof(*iph) > data_end) {
 		ERROR(1);
 		return TC_ACT_SHOT;
 	}
 
-	key.remote_ipv6[0] = bpf_htonl(0x2401db00);
 	key.tunnel_ttl = 64;
-
 	if (iph->nexthdr == 58 /* NEXTHDR_ICMP */) {
-		key.remote_ipv6[3] = bpf_htonl(1);
-	} else {
-		if (iph->nexthdr != 6 /* NEXTHDR_TCP */) {
-			ERROR(iph->nexthdr);
-			return TC_ACT_SHOT;
-		}
-
-		if (tcp->dest == bpf_htons(5200)) {
-			key.remote_ipv6[3] = bpf_htonl(1);
-		} else if (tcp->dest == bpf_htons(5201)) {
-			key.remote_ipv6[3] = bpf_htonl(2);
-		} else {
-			ERROR(tcp->dest);
-			return TC_ACT_SHOT;
-		}
+		key.remote_ipv6[3] = bpf_htonl(0x11); /* ::11 */
 	}
 
 	ret = bpf_skb_set_tunnel_key(skb, &key, sizeof(key),
diff --git a/tools/testing/selftests/bpf/test_tunnel.sh b/tools/testing/selftests/bpf/test_tunnel.sh
index bd12ec97a44d..1ccbe804e8e1 100755
--- a/tools/testing/selftests/bpf/test_tunnel.sh
+++ b/tools/testing/selftests/bpf/test_tunnel.sh
@@ -24,12 +24,12 @@
 # Root namespace with metadata-mode tunnel + BPF
 # Device names and addresses:
 # 	veth1 IP: 172.16.1.200, IPv6: 00::22 (underlay)
-# 	tunnel dev <type>11, ex: gre11, IPv4: 10.1.1.200 (overlay)
+# 	tunnel dev <type>11, ex: gre11, IPv4: 10.1.1.200, IPv6: 1::22 (overlay)
 #
 # Namespace at_ns0 with native tunnel
 # Device names and addresses:
 # 	veth0 IPv4: 172.16.1.100, IPv6: 00::11 (underlay)
-# 	tunnel dev <type>00, ex: gre00, IPv4: 10.1.1.100 (overlay)
+# 	tunnel dev <type>00, ex: gre00, IPv4: 10.1.1.100, IPv6: 1::11 (overlay)
 #
 #
 # End-to-end ping packet flow
@@ -250,7 +250,7 @@ add_ipip_tunnel()
 	ip addr add dev $DEV 10.1.1.200/24
 }
 
-add_ipip6tnl_tunnel()
+add_ip6tnl_tunnel()
 {
 	ip netns exec at_ns0 ip addr add ::11/96 dev veth0
 	ip netns exec at_ns0 ip link set dev veth0 up
@@ -262,11 +262,13 @@ add_ipip6tnl_tunnel()
 		ip link add dev $DEV_NS type $TYPE \
 		local ::11 remote ::22
 	ip netns exec at_ns0 ip addr add dev $DEV_NS 10.1.1.100/24
+	ip netns exec at_ns0 ip addr add dev $DEV_NS 1::11/96
 	ip netns exec at_ns0 ip link set dev $DEV_NS up
 
 	# root namespace
 	ip link add dev $DEV type $TYPE external
 	ip addr add dev $DEV 10.1.1.200/24
+	ip addr add dev $DEV 1::22/96
 	ip link set dev $DEV up
 }
 
@@ -534,7 +536,7 @@ test_ipip6()
 
 	check $TYPE
 	config_device
-	add_ipip6tnl_tunnel
+	add_ip6tnl_tunnel
 	ip link set dev veth1 mtu 1500
 	attach_bpf $DEV ipip6_set_tunnel ipip6_get_tunnel
 	# underlay
@@ -553,6 +555,34 @@ test_ipip6()
         echo -e ${GREEN}"PASS: $TYPE"${NC}
 }
 
+test_ip6ip6()
+{
+	TYPE=ip6tnl
+	DEV_NS=ip6ip6tnl00
+	DEV=ip6ip6tnl11
+	ret=0
+
+	check $TYPE
+	config_device
+	add_ip6tnl_tunnel
+	ip link set dev veth1 mtu 1500
+	attach_bpf $DEV ip6ip6_set_tunnel ip6ip6_get_tunnel
+	# underlay
+	ping6 $PING_ARG ::11
+	# ip6 over ip6
+	ping6 $PING_ARG 1::11
+	check_err $?
+	ip netns exec at_ns0 ping6 $PING_ARG 1::22
+	check_err $?
+	cleanup
+
+	if [ $ret -ne 0 ]; then
+                echo -e ${RED}"FAIL: ip6$TYPE"${NC}
+                return 1
+        fi
+        echo -e ${GREEN}"PASS: ip6$TYPE"${NC}
+}
+
 setup_xfrm_tunnel()
 {
 	auth=0x$(printf '1%.0s' {1..40})
@@ -646,6 +676,7 @@ cleanup()
 	ip link del veth1 2> /dev/null
 	ip link del ipip11 2> /dev/null
 	ip link del ipip6tnl11 2> /dev/null
+	ip link del ip6ip6tnl11 2> /dev/null
 	ip link del gretap11 2> /dev/null
 	ip link del ip6gre11 2> /dev/null
 	ip link del ip6gretap11 2> /dev/null
@@ -742,6 +773,10 @@ bpf_tunnel_test()
 	test_ipip6
 	errors=$(( $errors + $? ))
 
+	echo "Testing IP6IP6 tunnel..."
+	test_ip6ip6
+	errors=$(( $errors + $? ))
+
 	echo "Testing IPSec tunnel..."
 	test_xfrm_tunnel
 	errors=$(( $errors + $? ))
-- 
2.25.4

