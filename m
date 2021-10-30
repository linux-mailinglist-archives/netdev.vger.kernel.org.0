Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0954408CB
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 14:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbhJ3Mmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 08:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbhJ3Mme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 08:42:34 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6356C061570
        for <netdev@vger.kernel.org>; Sat, 30 Oct 2021 05:40:04 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id t7so12536607pgl.9
        for <netdev@vger.kernel.org>; Sat, 30 Oct 2021 05:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AZAFMnX5SlRW/jnyckkkWZVH/PgDnzL7PZfIaL9pmEQ=;
        b=YLkEpNJPq96zugFDU3gCw6sIXpCOXEEiu7i2gFkQn2eB3xGA7Rz/RtBD/Q7Fi9jh6L
         MVyIWTmOw15TGgwX/iM7VjvIRo3A9qsHHpIPX+x39AAXrU5g6lhGvqDOYqGPGE3CQlbs
         2mCnKEnJmlOy2Qp5kNCtPN+HrSrHGjJk9XiSw74IZucGoPDhFfg/JFRXeVeaqAGgvUiT
         4v+2xE1wOl+f41hhX9ONPI19UEg/Mr4fno53P9KbtWz7qk5QUWv5AUI9lxQd6lwV8tbK
         fdeMbRnpr9JdDA28BQkge6X1zZvvJ3S7mjP9Rpl1LZVTbdbgZ388RrVd/s/BkyIeACym
         3Dow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AZAFMnX5SlRW/jnyckkkWZVH/PgDnzL7PZfIaL9pmEQ=;
        b=nz1u6SdM983JthLJ8h04q1ND1+aPjgT4eCQcqmUzQPJpA+6iyYKNRHSk42z2pbjjGY
         QURjEoDu/HUBjpiVny8AwSU0UKWq5GfK65gDnxYR8wsrrXh9upgNalsSYqdBR+YlctBY
         Mxh1MFmKjYLYC0Ov/p+ie2URoN3Ny6WH+1YVZIo9kb47fdMOrFG0qkG72/uBAuC/zb0m
         AppdTxUuxwduHf0DDd9dzKmL6/qvRsS2EIUe9Zp/Bci2t2X7a5vFl0WAK7L33TKIHQg4
         upieNOhgBC31Aq3X9/w0r8IXM5Zvn/8hvMmAxtduQvymxfcc1yaB/idZ9KKKk3EIJdsf
         5i0g==
X-Gm-Message-State: AOAM533o2Q6fl1uFuz6i3VsOLSjHJYOKWCpYwSP1uLqnNAtMQDlOQc55
        9QZzLuFhCzUVbRtHGhtOGxw=
X-Google-Smtp-Source: ABdhPJzH/Bwoi7tkwYtZ2sfR4xNHvXFtvNpC+GCP//uptNK8U+UbH35LGnqT3J/TXQwaXBGtcuQ+Uw==
X-Received: by 2002:a62:3103:0:b0:47b:ecf2:8b9 with SMTP id x3-20020a623103000000b0047becf208b9mr16931629pfx.42.1635597604375;
        Sat, 30 Oct 2021 05:40:04 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id k73sm7312664pgc.63.2021.10.30.05.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 05:40:03 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org
Cc:     dkirjanov@suse.de, ap420073@gmail.com
Subject: [PATCH net-next v5 5/5] selftests: add amt interface selftest script
Date:   Sat, 30 Oct 2021 12:39:21 +0000
Message-Id: <20211030123921.29672-6-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211030123921.29672-1-ap420073@gmail.com>
References: <20211030123921.29672-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is selftest script for amt interface.
This script includes basic forwarding scenarion and torture scenario.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
v5:
 - Initial patch.

 tools/testing/selftests/net/Makefile |   1 +
 tools/testing/selftests/net/amt.sh   | 284 +++++++++++++++++++++++++++
 tools/testing/selftests/net/config   |   1 +
 3 files changed, 286 insertions(+)
 create mode 100644 tools/testing/selftests/net/amt.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 492b273743b4..d27c98a32244 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -22,6 +22,7 @@ TEST_PROGS += devlink_port_split.py
 TEST_PROGS += drop_monitor_tests.sh
 TEST_PROGS += vrf_route_leaking.sh
 TEST_PROGS += bareudp.sh
+TEST_PROGS += amt.sh
 TEST_PROGS += unicast_extensions.sh
 TEST_PROGS += udpgro_fwd.sh
 TEST_PROGS += veth.sh
diff --git a/tools/testing/selftests/net/amt.sh b/tools/testing/selftests/net/amt.sh
new file mode 100644
index 000000000000..75528788cb95
--- /dev/null
+++ b/tools/testing/selftests/net/amt.sh
@@ -0,0 +1,284 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+# Author: Taehee Yoo <ap420073@gmail.com>
+#
+# This script evaluates the AMT driver.
+# There are four network-namespaces, LISTENER, SOURCE, GATEWAY, RELAY.
+# The role of LISTENER is to listen multicast traffic.
+# In order to do that, it send IGMP group join message.
+# The role of SOURCE is to send multicast traffic to listener.
+# The role of GATEWAY is to work Gateway role of AMT interface.
+# The role of RELAY is to work Relay role of AMT interface.
+#
+#
+#       +------------------------+
+#       |    LISTENER netns      |
+#       |                        |
+#       |  +------------------+  |
+#       |  |       l_gw       |  |
+#       |  |  192.168.0.2/24  |  |
+#       |  |  2001:db8::2/64  |  |
+#       |  +------------------+  |
+#       |            .           |
+#       +------------------------+
+#                    .
+#                    .
+#       +-----------------------------------------------------+
+#       |            .         GATEWAY netns                  |
+#       |            .                                        |
+#       |+---------------------------------------------------+|
+#       ||           .          br0                          ||
+#       || +------------------+       +------------------+   ||
+#       || |       gw_l       |       |       amtg       |   ||
+#       || |  192.168.0.1/24  |       +--------+---------+   ||
+#       || |  2001:db8::1/64  |                |             ||
+#       || +------------------+                |             ||
+#       |+-------------------------------------|-------------+|
+#       |                                      |              |
+#       |                             +--------+---------+    |
+#       |                             |     gw_relay     |    |
+#       |                             |    10.0.0.1/24   |    |
+#       |                             +------------------+    |
+#       |                                      .              |
+#       +-----------------------------------------------------+
+#                                              .
+#                                              .
+#       +-----------------------------------------------------+
+#       |                       RELAY netns    .              |
+#       |                             +------------------+    |
+#       |                             |     relay_gw     |    |
+#       |                             |    10.0.0.2/24   |    |
+#       |                             +--------+---------+    |
+#       |                                      |              |
+#       |                                      |              |
+#       |  +------------------+       +--------+---------+    |
+#       |  |     relay_src    |       |       amtr       |    |
+#       |  |   172.17.0.1/24  |       +------------------+    |
+#       |  | 2001:db8:3::1/64 |                               |
+#       |  +------------------+                               |
+#       |            .                                        |
+#       |            .                                        |
+#       +-----------------------------------------------------+
+#                    .
+#                    .
+#       +------------------------+
+#       |            .           |
+#       |  +------------------+  |
+#       |  |     src_relay    |  |
+#       |  |   172.17.0.2/24  |  |
+#       |  | 2001:db8:3::2/64 |  |
+#       |  +------------------+  |
+#       |      SOURCE netns      |
+#       +------------------------+
+#==============================================================================
+
+readonly LISTENER=$(mktemp -u listener-XXXXXXXX)
+readonly GATEWAY=$(mktemp -u gateway-XXXXXXXX)
+readonly RELAY=$(mktemp -u relay-XXXXXXXX)
+readonly SOURCE=$(mktemp -u source-XXXXXXXX)
+ERR=4
+err=0
+
+exit_cleanup()
+{
+	for ns in "$@"; do
+		ip netns delete "${ns}" 2>/dev/null || true
+	done
+
+	exit $ERR
+}
+
+create_namespaces()
+{
+	ip netns add "${LISTENER}" || exit_cleanup
+	ip netns add "${GATEWAY}" || exit_cleanup "${LISTENER}"
+	ip netns add "${RELAY}" || exit_cleanup "${LISTENER}" "${GATEWAY}"
+	ip netns add "${SOURCE}" || exit_cleanup "${LISTENER}" "${GATEWAY}" \
+		"${RELAY}"
+}
+
+# The trap function handler
+#
+exit_cleanup_all()
+{
+	exit_cleanup "${LISTENER}" "${GATEWAY}" "${RELAY}" "${SOURCE}"
+}
+
+setup_interface()
+{
+	for ns in "${LISTENER}" "${GATEWAY}" "${RELAY}" "${SOURCE}"; do
+		ip -netns "${ns}" link set dev lo up
+	done;
+
+	ip link add l_gw type veth peer name gw_l
+	ip link add gw_relay type veth peer name relay_gw
+	ip link add relay_src type veth peer name src_relay
+
+	ip link set l_gw netns "${LISTENER}" up
+	ip link set gw_l netns "${GATEWAY}" up
+	ip link set gw_relay netns "${GATEWAY}" up
+	ip link set relay_gw netns "${RELAY}" up
+	ip link set relay_src netns "${RELAY}" up
+	ip link set src_relay netns "${SOURCE}" up mtu 1400
+
+	ip netns exec "${LISTENER}" ip a a 192.168.0.2/24 dev l_gw
+	ip netns exec "${LISTENER}" ip r a default via 192.168.0.1 dev l_gw
+	ip netns exec "${LISTENER}" ip a a 2001:db8::2/64 dev l_gw
+	ip netns exec "${LISTENER}" ip r a default via 2001:db8::1 dev l_gw
+	ip netns exec "${LISTENER}" ip a a 239.0.0.1/32 dev l_gw autojoin
+	ip netns exec "${LISTENER}" ip a a ff0e::5:6/128 dev l_gw autojoin
+
+	ip netns exec "${GATEWAY}" ip a a 192.168.0.1/24 dev gw_l
+	ip netns exec "${GATEWAY}" ip a a 2001:db8::1/64 dev gw_l
+	ip netns exec "${GATEWAY}" ip a a 10.0.0.1/24 dev gw_relay
+	ip netns exec "${GATEWAY}" ip link add br0 type bridge
+	ip netns exec "${GATEWAY}" ip link set br0 up
+	ip netns exec "${GATEWAY}" ip link set gw_l master br0
+	ip netns exec "${GATEWAY}" ip link set gw_l up
+	ip netns exec "${GATEWAY}" ip link add amtg master br0 type amt \
+		mode gateway local 10.0.0.1 discovery 10.0.0.2 dev gw_relay \
+		gateway_port 2268 relay_port 2268
+	ip netns exec "${RELAY}" ip a a 10.0.0.2/24 dev relay_gw
+	ip netns exec "${RELAY}" ip link add amtr type amt mode relay \
+		local 10.0.0.2 dev relay_gw relay_port 2268 max_tunnels 4
+	ip netns exec "${RELAY}" ip a a 172.17.0.1/24 dev relay_src
+	ip netns exec "${RELAY}" ip a a 2001:db8:3::1/64 dev relay_src
+	ip netns exec "${SOURCE}" ip a a 172.17.0.2/24 dev src_relay
+	ip netns exec "${SOURCE}" ip a a 2001:db8:3::2/64 dev src_relay
+	ip netns exec "${SOURCE}" ip r a default via 172.17.0.1 dev src_relay
+	ip netns exec "${SOURCE}" ip r a default via 2001:db8:3::1 dev src_relay
+	ip netns exec "${RELAY}" ip link set amtr up
+	ip netns exec "${GATEWAY}" ip link set amtg up
+}
+
+setup_sysctl()
+{
+	ip netns exec "${RELAY}" sysctl net.ipv4.ip_forward=1 -w -q
+}
+
+setup_iptables()
+{
+	ip netns exec "${RELAY}" iptables -t mangle -I PREROUTING \
+		-d 239.0.0.1 -j TTL --ttl-set 2
+	ip netns exec "${RELAY}" ip6tables -t mangle -I PREROUTING \
+		-j HL --hl-set 2
+}
+
+setup_mcast_routing()
+{
+	ip netns exec "${RELAY}" smcrouted
+	ip netns exec "${RELAY}" smcroutectl a relay_src \
+		172.17.0.2 239.0.0.1 amtr
+	ip netns exec "${RELAY}" smcroutectl a relay_src \
+		2001:db8:3::2 ff0e::5:6 amtr
+}
+
+test_remote_ip()
+{
+	REMOTE=$(ip netns exec "${GATEWAY}" \
+		ip -d -j link show amtg | jq .[0].linkinfo.info_data.remote)
+	if [ $REMOTE == "\"10.0.0.2\"" ]; then
+		printf "TEST: %-60s  [ OK ]\n" "amt discovery"
+	else
+		printf "TEST: %-60s  [FAIL]\n" "amt discovery"
+		ERR=1
+	fi
+}
+
+send_mcast_torture4()
+{
+	ip netns exec "${SOURCE}" bash -c \
+		'cat /dev/urandom | head -c 1G | nc -w 1 -u 239.0.0.1 4001'
+}
+
+
+send_mcast_torture6()
+{
+	ip netns exec "${SOURCE}" bash -c \
+		'cat /dev/urandom | head -c 1G | nc -w 1 -u ff0e::5:6 6001'
+}
+
+check_features()
+{
+        ip link help 2>&1 | grep -q amt
+        if [ $? -ne 0 ]; then
+                echo "Missing amt support in iproute2" >&2
+                exit_cleanup
+        fi
+}
+
+test_ipv4_forward()
+{
+	RESULT4=$(ip netns exec "${LISTENER}" nc -w 1 -l -u 239.0.0.1 4000)
+	if [ "$RESULT4" == "172.17.0.2" ]; then
+		printf "TEST: %-60s  [ OK ]\n" "IPv4 amt multicast forwarding"
+		exit 0
+	else
+		printf "TEST: %-60s  [FAIL]\n" "IPv4 amt multicast forwarding"
+		exit 1
+	fi
+}
+
+test_ipv6_forward()
+{
+	RESULT6=$(ip netns exec "${LISTENER}" nc -w 1 -l -u ff0e::5:6 6000)
+	if [ "$RESULT6" == "2001:db8:3::2" ]; then
+		printf "TEST: %-60s  [ OK ]\n" "IPv6 amt multicast forwarding"
+		exit 0
+	else
+		printf "TEST: %-60s  [FAIL]\n" "IPv6 amt multicast forwarding"
+		exit 1
+	fi
+}
+
+send_mcast4()
+{
+	sleep 2
+	ip netns exec "${SOURCE}" bash -c \
+		'echo 172.17.0.2 | nc -w 1 -u 239.0.0.1 4000' &
+}
+
+send_mcast6()
+{
+	sleep 2
+	ip netns exec "${SOURCE}" bash -c \
+		'echo 2001:db8:3::2 | nc -w 1 -u ff0e::5:6 6000' &
+}
+
+check_features
+
+create_namespaces
+
+set -e
+trap exit_cleanup_all EXIT
+
+setup_interface
+setup_sysctl
+setup_iptables
+setup_mcast_routing
+test_remote_ip
+test_ipv4_forward &
+pid=$!
+send_mcast4
+wait $pid || err=$?
+if [ $err -eq 1 ]; then
+	ERR=1
+fi
+test_ipv6_forward &
+pid=$!
+send_mcast6
+wait $pid || err=$?
+if [ $err -eq 1 ]; then
+	ERR=1
+fi
+send_mcast_torture4
+printf "TEST: %-60s  [ OK ]\n" "IPv4 amt traffic forwarding torture"
+send_mcast_torture6
+printf "TEST: %-60s  [ OK ]\n" "IPv6 amt traffic forwarding torture"
+sleep 5
+if [ "${ERR}" -eq 1 ]; then
+        echo "Some tests failed." >&2
+else
+        ERR=0
+fi
diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 86ab429fe7f3..ead7963b9bf0 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -44,3 +44,4 @@ CONFIG_NET_ACT_MIRRED=m
 CONFIG_BAREUDP=m
 CONFIG_IPV6_IOAM6_LWTUNNEL=y
 CONFIG_CRYPTO_SM4=y
+CONFIG_AMT=m
-- 
2.17.1

