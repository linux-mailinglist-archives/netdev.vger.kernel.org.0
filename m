Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5CB6AA629
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 01:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjCDANA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 19:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjCDAM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 19:12:57 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4729268E;
        Fri,  3 Mar 2023 16:12:51 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id r5so4857087qtp.4;
        Fri, 03 Mar 2023 16:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677888770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i4u4zN80f7tcAvVyt7THDAii+UFiTWyh0CLCh3yTArU=;
        b=qMmhH316fm2+9EjhIhUEhayKGHDU4ZwLtGO4FH17fr3y+y9d5wiCOgCjv/xd8VDHBk
         YMkw+dFX308it5+CRIkZwlkZi45xN94H6Uv2YNVgG5KceCvVKAl6SDKAASEAVV4Uuur/
         jUFTsTnHhYsPw8v7AbZ80gqBelDrPLtZyDuwRY+kklPiQxpvh/3sG8J269NhTAkOCSYo
         M6o2gSnOTr/wYJ9fMa9bK+Wpg9BFV+eYYMxPtTwf8teRuOO1lSpGebQU4Yg9gNWmZF7W
         1mP9d5wCmh6yZ8cKgDuzGhcBHNbJfDztJWGkZuhSJVy65zt3Bqa0CGjJ08NtIVZiZqol
         mtWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677888770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i4u4zN80f7tcAvVyt7THDAii+UFiTWyh0CLCh3yTArU=;
        b=X/aQ6OTYPDTgIKqyXUthtMA77iFIF06ww4LifzYIopqtyv5JG2injRQdzPVMatJfZf
         UAw/ScijE6+oF0AQkOXMWmmY5C2CtZAQJgoYoO1ITX880CuIF/bVtzqPCW+reNIFjsOj
         AWdLJEO+o/6qvuxQMaPiM7H4Gs3cc5DuQyCjRF8BG9YAqWUJS/vss34OaQYY4WEIzsA7
         wg+5x16P7CeTUZY2Sj/Moay/DEz3oUwe8sIIrsm1be56HlVRAaSwcKfUe4A/fy+kO36W
         Et0INmX1yIVmO+TEeswzA1KouxevhrLwkK4Fv02nikxa/d4A1/J4MXTdN52zxHfFOX23
         zO2Q==
X-Gm-Message-State: AO0yUKUThinEHk1GGHQBLR90djQO8gSGq4jHu+IkiHhRBnsKibv9/iml
        40/0vKYZWntdTDnL0MeJd7DOeVTwNxLfww==
X-Google-Smtp-Source: AK7set+vkfXgY5drvynmvbq6Q4KSNK3cXR3fV6Q/++aEF54U1b6ACiedKIJM+Vq8qBeoWl45BSVPOQ==
X-Received: by 2002:ac8:5fd0:0:b0:3bf:d51e:b14 with SMTP id k16-20020ac85fd0000000b003bfd51e0b14mr5443837qta.46.1677888770137;
        Fri, 03 Mar 2023 16:12:50 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id d79-20020ae9ef52000000b007296805f607sm2749242qkg.17.2023.03.03.16.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:12:49 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Aaron Conole <aconole@redhat.com>
Subject: [PATCH nf-next 6/6] selftests: add a selftest for big tcp
Date:   Fri,  3 Mar 2023 19:12:42 -0500
Message-Id: <05ccf9eec0b79e62d52ae65a096126546d84bea6.1677888566.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1677888566.git.lucien.xin@gmail.com>
References: <cover.1677888566.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test runs on the client-router-server topo, and monitors the traffic
on the RX devices of router and server while sending BIG TCP packets with
netperf from client to server. Meanwhile, it changes 'tso' on the TX devs
and 'gro' on the RX devs. Then it checks if any BIG TCP packets appears
on the RX devs with 'ip/ip6tables -m length ! --length 0:65535' for each
case.

Note that we also add tc action ct in link1 ingress to cover the ipv6
jumbo packets process in nf_ct_skb_network_trim() of nf_conntrack_ovs.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 tools/testing/selftests/net/Makefile   |   1 +
 tools/testing/selftests/net/big_tcp.sh | 180 +++++++++++++++++++++++++
 2 files changed, 181 insertions(+)
 create mode 100755 tools/testing/selftests/net/big_tcp.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 6cd8993454d7..099741290184 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -48,6 +48,7 @@ TEST_PROGS += l2_tos_ttl_inherit.sh
 TEST_PROGS += bind_bhash.sh
 TEST_PROGS += ip_local_port_range.sh
 TEST_PROGS += rps_default_mask.sh
+TEST_PROGS += big_tcp.sh
 TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_PROGS_EXTENDED += toeplitz_client.sh toeplitz.sh
 TEST_GEN_FILES =  socket nettest
diff --git a/tools/testing/selftests/net/big_tcp.sh b/tools/testing/selftests/net/big_tcp.sh
new file mode 100755
index 000000000000..cde9a91c4797
--- /dev/null
+++ b/tools/testing/selftests/net/big_tcp.sh
@@ -0,0 +1,180 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Testing For IPv4 and IPv6 BIG TCP.
+# TOPO: CLIENT_NS (link0)<--->(link1) ROUTER_NS (link2)<--->(link3) SERVER_NS
+
+CLIENT_NS=$(mktemp -u client-XXXXXXXX)
+CLIENT_IP4="198.51.100.1"
+CLIENT_IP6="2001:db8:1::1"
+
+SERVER_NS=$(mktemp -u server-XXXXXXXX)
+SERVER_IP4="203.0.113.1"
+SERVER_IP6="2001:db8:2::1"
+
+ROUTER_NS=$(mktemp -u router-XXXXXXXX)
+SERVER_GW4="203.0.113.2"
+CLIENT_GW4="198.51.100.2"
+SERVER_GW6="2001:db8:2::2"
+CLIENT_GW6="2001:db8:1::2"
+
+MAX_SIZE=128000
+CHK_SIZE=65535
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+setup() {
+	ip netns add $CLIENT_NS
+	ip netns add $SERVER_NS
+	ip netns add $ROUTER_NS
+	ip -net $ROUTER_NS link add link1 type veth peer name link0 netns $CLIENT_NS
+	ip -net $ROUTER_NS link add link2 type veth peer name link3 netns $SERVER_NS
+
+	ip -net $CLIENT_NS link set link0 up
+	ip -net $CLIENT_NS link set link0 mtu 1442
+	ip -net $CLIENT_NS addr add $CLIENT_IP4/24 dev link0
+	ip -net $CLIENT_NS addr add $CLIENT_IP6/64 dev link0 nodad
+	ip -net $CLIENT_NS route add $SERVER_IP4 dev link0 via $CLIENT_GW4
+	ip -net $CLIENT_NS route add $SERVER_IP6 dev link0 via $CLIENT_GW6
+	ip -net $CLIENT_NS link set dev link0 \
+		gro_ipv4_max_size $MAX_SIZE gso_ipv4_max_size $MAX_SIZE
+	ip -net $CLIENT_NS link set dev link0 \
+		gro_max_size $MAX_SIZE gso_max_size $MAX_SIZE
+	ip net exec $CLIENT_NS sysctl -wq net.ipv4.tcp_window_scaling=10
+
+	ip -net $ROUTER_NS link set link1 up
+	ip -net $ROUTER_NS link set link2 up
+	ip -net $ROUTER_NS addr add $CLIENT_GW4/24 dev link1
+	ip -net $ROUTER_NS addr add $CLIENT_GW6/64 dev link1 nodad
+	ip -net $ROUTER_NS addr add $SERVER_GW4/24 dev link2
+	ip -net $ROUTER_NS addr add $SERVER_GW6/64 dev link2 nodad
+	ip -net $ROUTER_NS link set dev link1 \
+		gro_ipv4_max_size $MAX_SIZE gso_ipv4_max_size $MAX_SIZE
+	ip -net $ROUTER_NS link set dev link2 \
+		gro_ipv4_max_size $MAX_SIZE gso_ipv4_max_size $MAX_SIZE
+	ip -net $ROUTER_NS link set dev link1 \
+		gro_max_size $MAX_SIZE gso_max_size $MAX_SIZE
+	ip -net $ROUTER_NS link set dev link2 \
+		gro_max_size $MAX_SIZE gso_max_size $MAX_SIZE
+	# test for nf_ct_skb_network_trim in nf_conntrack_ovs used by TC ct action.
+	ip net exec $ROUTER_NS tc qdisc add dev link1 ingress
+	ip net exec $ROUTER_NS tc filter add dev link1 ingress \
+		proto ip flower ip_proto tcp action ct
+	ip net exec $ROUTER_NS tc filter add dev link1 ingress \
+		proto ipv6 flower ip_proto tcp action ct
+	ip net exec $ROUTER_NS sysctl -wq net.ipv4.ip_forward=1
+	ip net exec $ROUTER_NS sysctl -wq net.ipv6.conf.all.forwarding=1
+
+	ip -net $SERVER_NS link set link3 up
+	ip -net $SERVER_NS addr add $SERVER_IP4/24 dev link3
+	ip -net $SERVER_NS addr add $SERVER_IP6/64 dev link3 nodad
+	ip -net $SERVER_NS route add $CLIENT_IP4 dev link3 via $SERVER_GW4
+	ip -net $SERVER_NS route add $CLIENT_IP6 dev link3 via $SERVER_GW6
+	ip -net $SERVER_NS link set dev link3 \
+		gro_ipv4_max_size $MAX_SIZE gso_ipv4_max_size $MAX_SIZE
+	ip -net $SERVER_NS link set dev link3 \
+		gro_max_size $MAX_SIZE gso_max_size $MAX_SIZE
+	ip net exec $SERVER_NS sysctl -wq net.ipv4.tcp_window_scaling=10
+	ip net exec $SERVER_NS netserver 2>&1 >/dev/null
+}
+
+cleanup() {
+	ip net exec $SERVER_NS pkill netserver
+	ip -net $ROUTER_NS link del link1
+	ip -net $ROUTER_NS link del link2
+	ip netns del "$CLIENT_NS"
+	ip netns del "$SERVER_NS"
+	ip netns del "$ROUTER_NS"
+}
+
+start_counter() {
+	local ipt="iptables"
+	local iface=$1
+	local netns=$2
+
+	[ "$NF" = "6" ] && ipt="ip6tables"
+	ip net exec $netns $ipt -t raw -A PREROUTING -i $iface \
+		-m length ! --length 0:$CHK_SIZE -j ACCEPT
+}
+
+check_counter() {
+	local ipt="iptables"
+	local iface=$1
+	local netns=$2
+
+	[ "$NF" = "6" ] && ipt="ip6tables"
+	test `ip net exec $netns $ipt -t raw -L -v |grep $iface | awk '{print $1}'` != "0"
+}
+
+stop_counter() {
+	local ipt="iptables"
+	local iface=$1
+	local netns=$2
+
+	[ "$NF" = "6" ] && ipt="ip6tables"
+	ip net exec $netns $ipt -t raw -D PREROUTING -i $iface \
+		-m length ! --length 0:$CHK_SIZE -j ACCEPT
+}
+
+do_netperf() {
+	local serip=$SERVER_IP4
+	local netns=$1
+
+	[ "$NF" = "6" ] && serip=$SERVER_IP6
+	ip net exec $netns netperf -$NF -t TCP_STREAM -H $serip 2>&1 >/dev/null
+}
+
+do_test() {
+	local cli_tso=$1
+	local gw_gro=$2
+	local gw_tso=$3
+	local ser_gro=$4
+	local ret="PASS"
+
+	ip net exec $CLIENT_NS ethtool -K link0 tso $cli_tso
+	ip net exec $ROUTER_NS ethtool -K link1 gro $gw_gro
+	ip net exec $ROUTER_NS ethtool -K link2 tso $gw_tso
+	ip net exec $SERVER_NS ethtool -K link3 gro $ser_gro
+
+	start_counter link1 $ROUTER_NS
+	start_counter link3 $SERVER_NS
+	do_netperf $CLIENT_NS
+
+	if check_counter link1 $ROUTER_NS; then
+		check_counter link3 $SERVER_NS || ret="FAIL_on_link3"
+	else
+		ret="FAIL_on_link1"
+	fi
+
+	stop_counter link1 $ROUTER_NS
+	stop_counter link3 $SERVER_NS
+	printf "%-9s %-8s %-8s %-8s: [%s]\n" \
+		$cli_tso $gw_gro $gw_tso $ser_gro $ret
+	test $ret = "PASS"
+}
+
+testup() {
+	echo "CLI GSO | GW GRO | GW GSO | SER GRO" && \
+	do_test "on"  "on"  "on"  "on"  && \
+	do_test "on"  "off" "on"  "off" && \
+	do_test "off" "on"  "on"  "on"  && \
+	do_test "on"  "on"  "off" "on"  && \
+	do_test "off" "on"  "off" "on"
+}
+
+if ! netperf -V &> /dev/null; then
+	echo "SKIP: Could not run test without netperf tool"
+	exit $ksft_skip
+fi
+
+if ! ip link help 2>&1 | grep gso_ipv4_max_size &> /dev/null; then
+	echo "SKIP: Could not run test without gso/gro_ipv4_max_size supported in ip-link"
+	exit $ksft_skip
+fi
+
+trap cleanup EXIT
+setup && echo "Testing for BIG TCP:" && \
+NF=4 testup && echo "***v4 Tests Done***" && \
+NF=6 testup && echo "***v6 Tests Done***"
+exit $?
-- 
2.39.1

