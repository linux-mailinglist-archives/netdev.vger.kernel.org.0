Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699C7440F43
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 17:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbhJaQDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 12:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhJaQC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 12:02:58 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F7FC061764
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 09:00:26 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id s136so14946710pgs.4
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 09:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PjP5t+ug8aGyE6GKbeIv41lnjqyFYDQjMBn4CvV6jaA=;
        b=PqyITiCbR/8rdfrkk7uQVNWr42WWvOcE5CtILAvO4aAPoki62sQ7ZlpGeUTf3bwdGV
         70S2dyYjNGNX0VzqyXyaUD4N1hozdteS3TpwcpBcYth2N1jwCCQVLF6BZx+LI22/kuyU
         VcyQIoR4svNOQDIVcDi54qn/BDn/b9cAUknRYyRoi75mzJDlFIJqpQbu20bvwbqK/X0F
         NYZpLWhKEME6NKfkY9qy7GmDraJMMu3hdHY2vi5CEfXizv0erRTOBsJ9ARoWXlKNuZWc
         ezZIVD4yrhx8vbuqYZSUxDeiqY3OzRhPKBZ0Ru2KXhpIolk4vztPCGX8+ktQQpJsH6V2
         /I4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PjP5t+ug8aGyE6GKbeIv41lnjqyFYDQjMBn4CvV6jaA=;
        b=vmyQEf7V4kFg9RZkbPRM4A3v5RSm++jwo8eQImU99E2BA41Yqd6aygiQeD9Tmjila2
         AqfrAdwI1mamPOwWUKdkMML9uo9f7zmg3KRiIQNRuTDzRdRS0UuYELRvAbRi6ocrQeAL
         P4BshhzXDqDo0+VALU9jl/svCGI6PYXdlnpXA64qRT15V5dsp+YrDL2lkgUHSXIp31Et
         pmjEP5f53sK+XtLvNzByIeDHHVhrn5hmJE/7/ZbVeO+yPY9x36kPJ/t7wDcHvMynxm8g
         ko70YezIYUxUxns4J8371kTv07Sl8YvmJilgS/5x35yvttMauxMWC1VsHUmunQMs9SaP
         TzBg==
X-Gm-Message-State: AOAM5331FAGPUw6UqCcuFdD/rP9Ow79gT4qMd0xtiIhCte8lEzdQ6vTJ
        7uOEpqJiz15qlG8KFV8BiKo=
X-Google-Smtp-Source: ABdhPJxB3bOQAfvHzIDXjWIkSPq03IvJiap9UCi1NaafA/SoDgJCQv4PTUhaBByBnvN4O7LPAxqyEg==
X-Received: by 2002:a65:6643:: with SMTP id z3mr17934110pgv.16.1635696025646;
        Sun, 31 Oct 2021 09:00:25 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id 1sm12297943pfl.133.2021.10.31.09.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 09:00:25 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org
Cc:     dkirjanov@suse.de, ap420073@gmail.com
Subject: [PATCH net-next v7 5/5] selftests: add amt interface selftest script
Date:   Sun, 31 Oct 2021 16:00:06 +0000
Message-Id: <20211031160006.3367-6-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211031160006.3367-1-ap420073@gmail.com>
References: <20211031160006.3367-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is selftest script for amt interface.
This script includes basic forwarding scenarion and torture scenario.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
v5:
 - Initial patch.

v5 -> v6:
 - No change.

v6 -> v7:
 - No change.

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

