Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F99466A8FE
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 04:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbjANDcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 22:32:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbjANDcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 22:32:13 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FC08F8C7
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:31:50 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id j15so15210014qtv.4
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pceTx6YjdeO5XmqQ2hzuXWH5UEF819hY/vaBFICoTs8=;
        b=MK/dH5QsryvW8YEVPsA78lzcfMpTdEuLzTHdsDNoPNhkMHC1TNAHotf3a6RH+T6Uvs
         uuRTMq1kj3r/MiHEkBphyPDuohdSewoMwJT7qu76ZZxtiSIAqIVuNzqoumSrbHA7L7qD
         sNRtTCLHHY6ZV3Tt5ra2p+Ty8NxkXm1tFU961XVsPyD6OeilyKRYcSxASpEcIwaeFI0x
         MvkKfj/1UXLJMOovyOKV3JMhvPzE+uZG89hB08Lbbu5qrLejJc/ciI1c/efShIt2QzzY
         0jku/T85oH/D9PbqkmQoWk93L8uQ10JLT/d3s7sIIWmyjqEngDjBNbjbtFDvWzLSaHKl
         uc6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pceTx6YjdeO5XmqQ2hzuXWH5UEF819hY/vaBFICoTs8=;
        b=O/UEgXa3U/o1o9pmWr5WZ7gVGnO/UFqQ1ss6dmZzLJntNBcQaDh7Ox5BNwV3mind3Y
         MRwqAn0XVkNbaz1c+PNp2fSlTyuTen2B7wwHcDQODDWqrKKblGfo1Pd9Q4qru0238dmP
         hJhb9fn0FMtusqeIJaCQPik6P++X4Qow5h+E3D/1WDGNvqzmpeQ9Uh4sS/aKsEkZiSXw
         jj0r4NUfMox6AoV92nYl6X0HvRtG9d2JM/qJO/+YFAMXqnCBBIgiqvWJRLRrDcGYiirJ
         fqS393w1M2iym/d/o3+VAv2xCSnmhzcvxX0R31O3mvyr6/Pbjsw8As01VHAaRbOuo05V
         YNLg==
X-Gm-Message-State: AFqh2kqSFCH/IU9TKQiDBXmcLioYMPfHP19qv9LfFDD3UUVeUbSSg9Du
        5Ljg4eYlv1W8FRoV0qJCOoFXadjqC+SEcA==
X-Google-Smtp-Source: AMrXdXucdJBmLwkRKzgQavphXTtbBW/AJRPglsWGbqrpsPxa3W8Gy0ts/Hxv5QbHAJ9Nm+9VQubnNA==
X-Received: by 2002:ac8:794d:0:b0:3ab:72ec:de9c with SMTP id r13-20020ac8794d000000b003ab72ecde9cmr105066520qtt.62.1673667109827;
        Fri, 13 Jan 2023 19:31:49 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id jt14-20020a05622aa00e00b003adc7f652a0sm7878846qtb.66.2023.01.13.19.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 19:31:49 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
Subject: [PATCH net-next 10/10] selftests: add a selftest for big tcp
Date:   Fri, 13 Jan 2023 22:31:34 -0500
Message-Id: <70913b5f4087c8ab7675093ce9a04c4e53325c96.1673666803.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1673666803.git.lucien.xin@gmail.com>
References: <cover.1673666803.git.lucien.xin@gmail.com>
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

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 tools/testing/selftests/net/Makefile   |   1 +
 tools/testing/selftests/net/big_tcp.sh | 157 +++++++++++++++++++++++++
 2 files changed, 158 insertions(+)
 create mode 100755 tools/testing/selftests/net/big_tcp.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 3007e98a6d64..e7ff63df5fcc 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -75,6 +75,7 @@ TEST_GEN_PROGS += so_incoming_cpu
 TEST_PROGS += sctp_vrf.sh
 TEST_GEN_FILES += sctp_hello
 TEST_GEN_FILES += csum
+TEST_PROGS += big_tcp.sh
 
 TEST_FILES := settings
 
diff --git a/tools/testing/selftests/net/big_tcp.sh b/tools/testing/selftests/net/big_tcp.sh
new file mode 100755
index 000000000000..7d0f0549ce59
--- /dev/null
+++ b/tools/testing/selftests/net/big_tcp.sh
@@ -0,0 +1,157 @@
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
+SERVER_NS=$(mktemp -u client-XXXXXXXX)
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
+	ip -net $CLIENT_NS link set dev link0 gro_max_size $MAX_SIZE gso_max_size $MAX_SIZE
+	ip net exec $CLIENT_NS sysctl -wq net.ipv4.tcp_window_scaling=10
+
+	ip -net $ROUTER_NS link set link1 up
+	ip -net $ROUTER_NS link set link2 up
+	ip -net $ROUTER_NS addr add $CLIENT_GW4/24 dev link1
+	ip -net $ROUTER_NS addr add $CLIENT_GW6/64 dev link1 nodad
+	ip -net $ROUTER_NS addr add $SERVER_GW4/24 dev link2
+	ip -net $ROUTER_NS addr add $SERVER_GW6/64 dev link2 nodad
+	ip -net $ROUTER_NS link set dev link1 gro_max_size $MAX_SIZE gso_max_size $MAX_SIZE
+	ip -net $ROUTER_NS link set dev link2 gro_max_size $MAX_SIZE gso_max_size $MAX_SIZE
+	ip net exec $ROUTER_NS sysctl -wq net.ipv4.ip_forward=1
+	ip net exec $ROUTER_NS sysctl -wq net.ipv6.conf.all.forwarding=1
+
+	ip -net $SERVER_NS link set link3 up
+	ip -net $SERVER_NS addr add $SERVER_IP4/24 dev link3
+	ip -net $SERVER_NS addr add $SERVER_IP6/64 dev link3 nodad
+	ip -net $SERVER_NS route add $CLIENT_IP4 dev link3 via $SERVER_GW4
+	ip -net $SERVER_NS route add $CLIENT_IP6 dev link3 via $SERVER_GW6
+	ip -net $SERVER_NS link set dev link3 gro_max_size $MAX_SIZE gso_max_size $MAX_SIZE
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
+trap cleanup EXIT
+setup && echo "Testing for BIG TCP:" && \
+NF=4 testup && echo "***v4 Tests Done***" && \
+NF=6 testup && echo "***v6 Tests Done***"
+exit $?
-- 
2.31.1

