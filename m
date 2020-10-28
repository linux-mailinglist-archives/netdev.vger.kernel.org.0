Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A9E29DFD6
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 02:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730982AbgJ2BFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 21:05:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36748 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730007AbgJ1WFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:05:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603922749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=+RSa9d9zoAlQ44pT2yRInefVrIVJrMvky2H7yynL/3M=;
        b=iXQ1QQwJwpFhtsp60o/UeZs0MSAhWa3oX6YKm2QJiXsu7zCuAXFjW/gH9KtoQa+tInmVHD
        L8IRgkhNErJv1iYvrY69bRHnoFMhNTYJIlmLYRZZXZlcBEngxLQb1bcw31LKjCC10l+KLK
        oxjRqiu6pOb5idVlKRpC1mi45Tg/gs4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-Yld_pzgtPUi5ikpOSwExZQ-1; Wed, 28 Oct 2020 14:05:19 -0400
X-MC-Unique: Yld_pzgtPUi5ikpOSwExZQ-1
Received: by mail-wr1-f72.google.com with SMTP id b6so138161wrn.17
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 11:05:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=+RSa9d9zoAlQ44pT2yRInefVrIVJrMvky2H7yynL/3M=;
        b=BTy3rkL2LKzOXEBTop5UjK/+W80UvsPLwYqqBWTB8nglVOjOJiSLah+oQJxNCL5D7b
         2ZT2xUnkjBxWPRl4DI+dJgK/VnUppS8n5Mk3gypWmg+evMoxHhn48MsulJH52i5GfIHg
         zkrIUeacLrzKV3ndOdIGDfoKNnNwPA/v+sR+f13iEEASdm5k2hG7SiBg3OoueMrJSw5d
         DoLcHnUujJ7OrcPwTijcosetzOaKAZoh1s5vSwl8Iz+TKPBOBfjIfO5YzHz9QEuYf/33
         RAc/Tb1WPK54uMvz121AdbHW4LCnqK9w6D/vs6eW2Mkt03gAR+qEUYGA9M8MMW5w22ij
         bBFw==
X-Gm-Message-State: AOAM533YK7g9oHNKdCQyT64+fb4Fj8J+weqo+HPfVlcJi+A+1hdhvbwp
        Z5sjlJhZ3cgax2Xyk1jit56OL5YR6t1LV84ZmQUBzXwYrTXRy9cF4armuDB9gQFXi3yOYhf2U+o
        nKjjc/7baY8FLhiS5
X-Received: by 2002:adf:bc0f:: with SMTP id s15mr589411wrg.83.1603908317607;
        Wed, 28 Oct 2020 11:05:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0fl/8ekVVqrUkALEv64ubrtTIGvRW4SfJ+0NoilTie+ZbDHWgPvmJ+4sr9wRhZwh7+8r3pQ==
X-Received: by 2002:adf:bc0f:: with SMTP id s15mr589351wrg.83.1603908317041;
        Wed, 28 Oct 2020 11:05:17 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id x22sm256181wmj.25.2020.10.28.11.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 11:05:16 -0700 (PDT)
Date:   Wed, 28 Oct 2020 19:05:14 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCH net] selftests: add test script for bareudp tunnels
Message-ID: <72671f94d25e91903f68fa8f00678eb678855b35.1603907878.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test different encapsulation modes of the bareudp module:
  * Unicast MPLS,
  * IPv4 only,
  * IPv4 in multiproto mode (that is, IPv4 and IPv6),
  * IPv6.

Each mode is tested with both an IPv4 and an IPv6 underlay.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 tools/testing/selftests/net/Makefile   |   1 +
 tools/testing/selftests/net/bareudp.sh | 523 +++++++++++++++++++++++++
 2 files changed, 524 insertions(+)
 create mode 100755 tools/testing/selftests/net/bareudp.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index ef352477cac6..fa5fa425d148 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -21,6 +21,7 @@ TEST_PROGS += rxtimestamp.sh
 TEST_PROGS += devlink_port_split.py
 TEST_PROGS += drop_monitor_tests.sh
 TEST_PROGS += vrf_route_leaking.sh
+TEST_PROGS += bareudp.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
diff --git a/tools/testing/selftests/net/bareudp.sh b/tools/testing/selftests/net/bareudp.sh
new file mode 100755
index 000000000000..e565900789c0
--- /dev/null
+++ b/tools/testing/selftests/net/bareudp.sh
@@ -0,0 +1,523 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+# Test various bareudp tunnel configurations.
+#
+# The bareudp module allows to tunnel network protocols like IP or MPLS over
+# UDP, without adding any intermediate header. This scripts tests several
+# configurations of bareudp (using IPv4 or IPv6 as underlay and transporting
+# IPv4, IPv6 or MPLS packets on the overlay).
+#
+# Network topology:
+#
+#   * A chain of 4 network namespaces, connected with veth pairs. Each veth
+#     is assigned an IPv4 and an IPv6 address. A host-route allows a veth to
+#     join its peer.
+#
+#   * NS0 and NS3 are at the extremities of the chain. They have an additional
+#     IPv4 and IPv6 address on their loopback device. A route is added to NS0
+#     and NS3, so that they can communicate using these "overlay" IP addresses.
+#     For IPv4 and IPv6 reachability tests, the route simply sets the peer's
+#     veth address as gateway. For MPLS reachability tests, an MPLS header is
+#     also pushed before the IP header.
+#
+#   * NS1 and NS2 are the intermediate namespaces. They use a bareudp device to
+#     encapsulate the traffic between NS0 and NS3 into UDP.
+#
+# +-----------------------------------------------------------------------+
+# |                                  NS0                                  |
+# |                                                                       |
+# |   lo:                                                                 |
+# |      * IPv4 address: 192.0.2.100/32                                   |
+# |      * IPv6 address: 2001:db8::100/128                                |
+# |      * IPv4 route: 192.0.2.103/32 reachable via 192.0.2.11            |
+# |      * IPv6 route: 2001:db8::103/128 reachable via 2001:db8::11       |
+# |                    (optionally MPLS encapsulated, depending on test)  |
+# |                                                                       |
+# |   veth01:                                                             |
+# |   ^  * IPv4 address: 192.0.2.10, peer 192.0.2.11/32                   |
+# |   |  * IPv6 address: 2001:db8::10, peer 2001:db8::11/128              |
+# |   |                                                                   |
+# +---+-------------------------------------------------------------------+
+#     |
+#     | Traffic type: IP or MPLS (depending on test)
+#     |
+# +---+-------------------------------------------------------------------+
+# |   |                              NS1                                  |
+# |   |                                                                   |
+# |   v                                                                   |
+# |   veth10:                                                             |
+# |      * IPv4 address: 192.0.2.11, peer 192.0.2.10/32                   |
+# |      * IPv6 address: 2001:db8::11, peer 2001:db8::10/128              |
+# |                                                                       |
+# |   bareudp_ns1:                                                        |
+# |      * Encapsulate IP or MPLS packets received on veth10 into UDP     |
+# |        and send the resulting packets through veth12.                 |
+# |      * Decapsulate bareudp packets (either IP or MPLS, over UDP)      |
+# |        received on veth12 and send the inner packets through veth10.  |
+# |                                                                       |
+# |   veth12:                                                             |
+# |   ^  * IPv4 address: 192.0.2.21, peer 192.0.2.22/32                   |
+# |   |  * IPv6 address: 2001:db8::21, peer 2001:db8::22/128              |
+# |   |                                                                   |
+# +---+-------------------------------------------------------------------+
+#     |
+#     | Traffic type: IP or MPLS (depending on test), over UDP
+#     |
+# +---+-------------------------------------------------------------------+
+# |   |                              NS2                                  |
+# |   |                                                                   |
+# |   v                                                                   |
+# |   veth21:                                                             |
+# |      * IPv4 address: 192.0.2.22, peer 192.0.2.21/32                   |
+# |      * IPv6 address: 2001:db8::22, peer 2001:db8::21/128              |
+# |                                                                       |
+# |   bareudp_ns2:                                                        |
+# |      * Decapsulate bareudp packets (either IP or MPLS, over UDP)      |
+# |        received on veth21 and send the inner packets through veth23.  |
+# |      * Encapsulate IP or MPLS packets received on veth23 into UDP     |
+# |        and send the resulting packets through veth21.                 |
+# |                                                                       |
+# |   veth23:                                                             |
+# |   ^  * IPv4 address: 192.0.2.32, peer 192.0.2.33/32                   |
+# |   |  * IPv6 address: 2001:db8::32, peer 2001:db8::33/128              |
+# |   |                                                                   |
+# +---+-------------------------------------------------------------------+
+#     |
+#     | Traffic type: IP or MPLS (depending on test)
+#     |
+# +---+-------------------------------------------------------------------+
+# |   |                              NS3                                  |
+# |   v                                                                   |
+# |   veth32:                                                             |
+# |      * IPv4 address: 192.0.2.33, peer 192.0.2.32/32                   |
+# |      * IPv6 address: 2001:db8::33, peer 2001:db8::32/128              |
+# |                                                                       |
+# |   lo:                                                                 |
+# |      * IPv4 address: 192.0.2.103/32                                   |
+# |      * IPv6 address: 2001:db8::103/128                                |
+# |      * IPv4 route: 192.0.2.100/32 reachable via 192.0.2.32            |
+# |      * IPv6 route: 2001:db8::100/128 reachable via 2001:db8::32       |
+# |                    (optionally MPLS encapsulated, depending on test)  |
+# |                                                                       |
+# +-----------------------------------------------------------------------+
+
+ERR=4 # Return 4 by default, which is the SKIP code for kselftest
+PAUSE_ON_FAIL="no"
+
+readonly NS0=$(mktemp -u ns0-XXXXXXXX)
+readonly NS1=$(mktemp -u ns1-XXXXXXXX)
+readonly NS2=$(mktemp -u ns2-XXXXXXXX)
+readonly NS3=$(mktemp -u ns3-XXXXXXXX)
+
+# Check if ping is usable for IPv6. Use ping6 if it isn't.
+ping -w 1 -c 1 ::1 > /dev/null 2>&1 && PING6="ping" || PING6="ping6"
+
+# Exit the script after having removed the network namespaces it created
+#
+# Parameters:
+#
+#   * The list of network namespaces to delete before exiting.
+#
+exit_cleanup()
+{
+	for ns in "$@"; do
+		ip netns delete "${ns}" 2>/dev/null || true
+	done
+
+	if [ "${ERR}" -eq 4 ]; then
+		printf "Error: Setting up the testing environment failed.\n" >&2
+	fi
+
+	exit "${ERR}"
+}
+
+# Create the four network namespaces used by the script (NS0, NS1, NS2 and NS3)
+#
+# New namespaces are cleaned up manually in case of error, to ensure that we're
+# not going to delete pre-existing namespaces.
+create_namespaces()
+{
+	ip netns add "${NS0}" || exit_cleanup
+	ip netns add "${NS1}" || exit_cleanup "${NS0}"
+	ip netns add "${NS2}" || exit_cleanup "${NS0}" "${NS1}"
+	ip netns add "${NS3}" || exit_cleanup "${NS0}" "${NS1}" "${NS2}"
+}
+
+# The trap function handler
+#
+exit_cleanup_all()
+{
+	exit_cleanup "${NS0}" "${NS1}" "${NS2}" "${NS3}"
+}
+
+# Configure a network interface using a host route
+#
+# Parameters
+#
+#   * $1: the netns the network interface resides in,
+#   * $2: the network interface name,
+#   * $3: the local IPv4 address to assign to this interface,
+#   * $4: the IPv4 address of the remote network interface,
+#   * $5: the local IPv6 address to assign to this interface,
+#   * $6: the IPv6 address of the remote network interface.
+#
+iface_config()
+{
+	local NS="${1}"; readonly NS
+	local DEV="${2}"; readonly DEV
+	local LOCAL_IP4="${3}"; readonly LOCAL_IP4
+	local PEER_IP4="${4}"; readonly PEER_IP4
+	local LOCAL_IP6="${5}"; readonly LOCAL_IP6
+	local PEER_IP6="${6}"; readonly PEER_IP6
+
+	ip -netns "${NS}" link set dev "${DEV}" up
+	ip -netns "${NS}" address add dev "${DEV}" "${LOCAL_IP4}" peer "${PEER_IP4}"
+	ip -netns "${NS}" address add dev "${DEV}" "${LOCAL_IP6}" peer "${PEER_IP6}" nodad
+}
+
+# Create base networking topology:
+#
+#   * set up the loopback device in all network namespaces (NS0..NS3),
+#   * set up a veth pair to connect each netns in sequence (NS0 with NS1,
+#     NS1 with NS2, etc.),
+#   * add and IPv4 and an IPv6 address on each veth interface.
+#
+setup_underlay()
+{
+	for ns in "${NS0}" "${NS1}" "${NS2}" "${NS3}"; do
+		ip -netns "${ns}" link set dev lo up
+	done;
+
+	ip link add name veth01 netns "${NS0}" type veth peer name veth10 netns "${NS1}"
+	ip link add name veth12 netns "${NS1}" type veth peer name veth21 netns "${NS2}"
+	ip link add name veth23 netns "${NS2}" type veth peer name veth32 netns "${NS3}"
+	iface_config "${NS0}" veth01 192.0.2.10 192.0.2.11/32 2001:db8::10 2001:db8::11/128
+	iface_config "${NS1}" veth10 192.0.2.11 192.0.2.10/32 2001:db8::11 2001:db8::10/128
+	iface_config "${NS1}" veth12 192.0.2.21 192.0.2.22/32 2001:db8::21 2001:db8::22/128
+	iface_config "${NS2}" veth21 192.0.2.22 192.0.2.21/32 2001:db8::22 2001:db8::21/128
+	iface_config "${NS2}" veth23 192.0.2.32 192.0.2.33/32 2001:db8::32 2001:db8::33/128
+	iface_config "${NS3}" veth32 192.0.2.33 192.0.2.32/32 2001:db8::33 2001:db8::32/128
+}
+
+# Set up the parts of the overlay network that are common to all tests:
+#
+#   * add an IPv4 and an IPv6 overlay network address on the loopback device of
+#     the edge namespaces,
+#   * enable IP forwarding in the intermediate namespaces.
+#
+# We can't configure the MPLS syctls yet as the mpls_router module may not be
+# loaded at this point.
+#
+setup_overlay_common()
+{
+	ip -netns "${NS0}" address add 192.0.2.100/32 dev lo
+	ip -netns "${NS3}" address add 192.0.2.103/32 dev lo
+	ip -netns "${NS0}" address add 2001:db8::100/128 dev lo
+	ip -netns "${NS3}" address add 2001:db8::103/128 dev lo
+
+	ip netns exec "${NS1}" sysctl -qw net.ipv6.conf.all.forwarding=1
+	ip netns exec "${NS2}" sysctl -qw net.ipv6.conf.all.forwarding=1
+	ip netns exec "${NS1}" sysctl -qw net.ipv4.ip_forward=1
+	ip netns exec "${NS2}" sysctl -qw net.ipv4.ip_forward=1
+}
+
+# Run "ping" from NS0 and print the result
+#
+# Parameters:
+#
+#   * $1: the variant of ping to use (normally either "ping" or "ping6"),
+#   * $2: the IP address to ping,
+#   * $3: a human readable description of the purpose of the test.
+#
+# If the test fails and PAUSE_ON_FAIL is active, the user is given the
+# possibility to continue with the next test or to quit immediately.
+#
+ping_test_one()
+{
+	local PING="$1"; readonly PING
+	local IP="$2"; readonly IP
+	local MSG="$3"; readonly MSG
+	local RET
+
+	printf "TEST: %-60s  " "${MSG}"
+
+	set +e
+	ip netns exec "${NS0}" "${PING}" -w 5 -c 1 "${IP}" > /dev/null 2>&1
+	RET=$?
+	set -e
+
+	if [ "${RET}" -eq 0 ]; then
+		printf "[ OK ]\n"
+	else
+		ERR=1
+		printf "[FAIL]\n"
+		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
+			printf "\nHit enter to continue, 'q' to quit\n"
+			read a
+			if [ "$a" = "q" ]; then
+				exit 1
+			fi
+		fi
+	fi
+}
+
+# Run reachability tests
+#
+# Parameters:
+#
+#   * $1: human readable string describing the underlay protocol.
+#
+# $IPV4, $IPV6, $MPLS_UC and $MULTIPROTO are inherited from the calling
+# function.
+#
+ping_test()
+{
+	local UNDERLAY="$1"; readonly UNDERLAY
+	local MODE
+	local MSG
+
+	if [ "${MULTIPROTO}" = "multiproto" ]; then
+		MODE=" (multiproto mode)"
+	else
+		MODE=""
+	fi
+
+	if [ $IPV4 ]; then
+		ping_test_one "ping" "192.0.2.103" "IPv4 packets over ${UNDERLAY}${MODE}"
+	fi
+	if [ $IPV6 ]; then
+		ping_test_one "${PING6}" "2001:db8::103" "IPv6 packets over ${UNDERLAY}${MODE}"
+	fi
+	if [ $MPLS_UC ]; then
+		ping_test_one "${PING6}" "2001:db8::103" "Unicast MPLS packets over ${UNDERLAY}${MODE}"
+	fi
+}
+
+# Set up a bareudp overlay and run reachability tests over IPv4 and IPv6
+#
+# Parameters:
+#
+#   * $1: the packet type (protocol) to be handled by bareudp,
+#   * $2: a flag to activate or deactivate bareudp's "multiproto" mode.
+#
+test_overlay()
+{
+	local ETHERTYPE="$1"; readonly ETHERTYPE
+	local MULTIPROTO="$2"; readonly MULTIPROTO
+	local IPV4
+	local IPV6
+	local MPLS_UC
+
+	case "${ETHERTYPE}" in
+		"ipv4")
+			IPV4="ipv4"
+			if [ "${MULTIPROTO}" = "multiproto" ]; then
+				IPV6="ipv6"
+			else
+				IPV6=""
+			fi
+			MPLS_UC=""
+			;;
+		"ipv6")
+			IPV6="ipv6"
+			IPV4=""
+			MPLS_UC=""
+			;;
+		"mpls_uc")
+			MPLS_UC="mpls_uc"
+			IPV4=""
+			IPV6=""
+			;;
+		*)
+			exit 1
+			;;
+	esac
+	readonly IPV4
+	readonly IPV6
+	readonly MPLS_UC
+
+	# Create the bareudp devices in the intermediate namespaces
+	ip -netns "${NS1}" link add name bareudp_ns1 up type bareudp dstport 6635 ethertype "${ETHERTYPE}" "${MULTIPROTO}"
+	ip -netns "${NS2}" link add name bareudp_ns2 up type bareudp dstport 6635 ethertype "${ETHERTYPE}" "${MULTIPROTO}"
+
+	# Prepare the ingress qdisc in the intermediate namespaces
+	tc -netns "${NS1}" qdisc add dev veth10 ingress
+	tc -netns "${NS2}" qdisc add dev veth23 ingress
+
+	# IPv4 over UDPv4
+	if [ $IPV4 ]; then
+		# Route the overlay addresses in the edge namespaces
+		ip -netns "${NS0}" route add 192.0.2.103/32 src 192.0.2.100 via 192.0.2.11
+		ip -netns "${NS3}" route add 192.0.2.100/32 src 192.0.2.103 via 192.0.2.32
+
+		# Route the overlay addresses in the intermediate namespaces
+		# (used after bareudp decapsulation)
+		ip -netns "${NS1}" route add 192.0.2.100/32 via 192.0.2.10
+		ip -netns "${NS2}" route add 192.0.2.103/32 via 192.0.2.33
+
+		# Encapsulation instructions for bareudp over IPv4
+		tc -netns "${NS1}" filter add dev veth10 ingress protocol ipv4         \
+			flower dst_ip 192.0.2.103/32                                   \
+			action tunnel_key set src_ip 192.0.2.21 dst_ip 192.0.2.22 id 0 \
+			action mirred egress redirect dev bareudp_ns1
+		tc -netns "${NS2}" filter add dev veth23 ingress protocol ipv4         \
+			flower dst_ip 192.0.2.100/32                                   \
+			action tunnel_key set src_ip 192.0.2.22 dst_ip 192.0.2.21 id 0 \
+			action mirred egress redirect dev bareudp_ns2
+	fi
+
+	# IPv6 over UDPv4
+	if [ $IPV6 ]; then
+		# Route the overlay addresses in the edge namespaces
+		ip -netns "${NS0}" route add 2001:db8::103/128 src 2001:db8::100 via 2001:db8::11
+		ip -netns "${NS3}" route add 2001:db8::100/128 src 2001:db8::103 via 2001:db8::32
+
+		# Route the overlay addresses in the intermediate namespaces
+		# (used after bareudp decapsulation)
+		ip -netns "${NS1}" route add 2001:db8::100/128 via 2001:db8::10
+		ip -netns "${NS2}" route add 2001:db8::103/128 via 2001:db8::33
+
+		# Encapsulation instructions for bareudp over IPv4
+		tc -netns "${NS1}" filter add dev veth10 ingress protocol ipv6         \
+			flower dst_ip 2001:db8::103/128                                \
+			action tunnel_key set src_ip 192.0.2.21 dst_ip 192.0.2.22 id 0 \
+			action mirred egress redirect dev bareudp_ns1
+		tc -netns "${NS2}" filter add dev veth23 ingress protocol ipv6         \
+			flower dst_ip 2001:db8::100/128                                \
+			action tunnel_key set src_ip 192.0.2.22 dst_ip 192.0.2.21 id 0 \
+			action mirred egress redirect dev bareudp_ns2
+	fi
+
+	# MPLS (unicast) over UDPv4
+	if [ $MPLS_UC ]; then
+		# Route the overlay addresses in the edge namespaces
+		ip -netns "${NS0}" route add 2001:db8::103/128 src 2001:db8::100 encap mpls 103 via 2001:db8::11
+		ip -netns "${NS3}" route add 2001:db8::100/128 src 2001:db8::103 encap mpls 100 via 2001:db8::32
+
+		# Accept incoming MPLS packets in the intermediate namespaces
+		ip netns exec "${NS1}" sysctl -qw net.mpls.platform_labels=1000
+		ip netns exec "${NS2}" sysctl -qw net.mpls.platform_labels=1000
+		ip netns exec "${NS1}" sysctl -qw net.mpls.conf.bareudp_ns1.input=1
+		ip netns exec "${NS2}" sysctl -qw net.mpls.conf.bareudp_ns2.input=1
+
+		# Route the MPLS packets in the intermediate namespaces
+		# (used after bareudp decapsulation)
+		ip -netns "${NS1}" -family mpls route add 100 via inet6 2001:db8::10
+		ip -netns "${NS2}" -family mpls route add 103 via inet6 2001:db8::33
+
+		# Encapsulation instructions for bareudp over IPv4
+		tc -netns "${NS1}" filter add dev veth10 ingress protocol mpls_uc      \
+			flower mpls_label 103                                          \
+			action tunnel_key set src_ip 192.0.2.21 dst_ip 192.0.2.22 id 0 \
+			action mirred egress redirect dev bareudp_ns1
+		tc -netns "${NS2}" filter add dev veth23 ingress protocol mpls_uc      \
+			flower mpls_label 100                                          \
+			action tunnel_key set src_ip 192.0.2.22 dst_ip 192.0.2.21 id 0 \
+			action mirred egress redirect dev bareudp_ns2
+	fi
+
+	# Test IPv4 underlay
+	ping_test "UDPv4"
+
+	# Cleanup bareudp encapsulation instructions, as they were specific to
+	# the IPv4 underlay, before setting up and testing the IPv6 underlay
+	tc -netns "${NS1}" filter delete dev veth10 ingress
+	tc -netns "${NS2}" filter delete dev veth23 ingress
+
+	# IPv4 over UDPv6
+	if [ $IPV4 ]; then
+		# New encapsulation instructions for bareudp over IPv6
+		tc -netns "${NS1}" filter add dev veth10 ingress protocol ipv4             \
+			flower dst_ip 192.0.2.103/32                                       \
+			action tunnel_key set src_ip 2001:db8::21 dst_ip 2001:db8::22 id 0 \
+			action mirred egress redirect dev bareudp_ns1
+		tc -netns "${NS2}" filter add dev veth23 ingress protocol ipv4             \
+			flower dst_ip 192.0.2.100/32                                       \
+			action tunnel_key set src_ip 2001:db8::22 dst_ip 2001:db8::21 id 0 \
+			action mirred egress redirect dev bareudp_ns2
+	fi
+
+	# IPv6 over UDPv6
+	if [ $IPV6 ]; then
+		# New encapsulation instructions for bareudp over IPv6
+		tc -netns "${NS1}" filter add dev veth10 ingress protocol ipv6             \
+			flower dst_ip 2001:db8::103/128                                    \
+			action tunnel_key set src_ip 2001:db8::21 dst_ip 2001:db8::22 id 0 \
+			action mirred egress redirect dev bareudp_ns1
+		tc -netns "${NS2}" filter add dev veth23 ingress protocol ipv6             \
+			flower dst_ip 2001:db8::100/128                                    \
+			action tunnel_key set src_ip 2001:db8::22 dst_ip 2001:db8::21 id 0 \
+			action mirred egress redirect dev bareudp_ns2
+	fi
+
+	# MPLS (unicast) over UDPv6
+	if [ $MPLS_UC ]; then
+		# New encapsulation instructions for bareudp over IPv6
+		tc -netns "${NS1}" filter add dev veth10 ingress protocol mpls_uc          \
+			flower mpls_label 103                                              \
+			action tunnel_key set src_ip 2001:db8::21 dst_ip 2001:db8::22 id 0 \
+			action mirred egress redirect dev bareudp_ns1
+		tc -netns "${NS2}" filter add dev veth23 ingress protocol mpls_uc          \
+			flower mpls_label 100                                              \
+			action tunnel_key set src_ip 2001:db8::22 dst_ip 2001:db8::21 id 0 \
+			action mirred egress redirect dev bareudp_ns2
+	fi
+
+	# Test IPv6 underlay
+	ping_test "UDPv6"
+
+	# Cleanup
+	if [ $IPV4 ]; then
+		ip -netns "${NS0}" route delete 192.0.2.103/32
+		ip -netns "${NS1}" route delete 192.0.2.100/32
+		ip -netns "${NS2}" route delete 192.0.2.103/32
+		ip -netns "${NS3}" route delete 192.0.2.100/32
+	fi
+	if [ $IPV6 ]; then
+		ip -netns "${NS0}" route delete 2001:db8::103/128
+		ip -netns "${NS1}" route delete 2001:db8::100/128
+		ip -netns "${NS2}" route delete 2001:db8::103/128
+		ip -netns "${NS3}" route delete 2001:db8::100/128
+	fi
+	if [ $MPLS_UC ]; then
+		ip -netns "${NS0}" route delete 2001:db8::103/128
+		ip -netns "${NS1}" -family mpls route delete 100
+		ip -netns "${NS2}" -family mpls route delete 103
+		ip -netns "${NS3}" route delete 2001:db8::100/128
+	fi
+	tc -netns "${NS1}" qdisc delete dev veth10 ingress
+	tc -netns "${NS2}" qdisc delete dev veth23 ingress
+	ip -netns "${NS1}" link delete bareudp_ns1
+	ip -netns "${NS2}" link delete bareudp_ns2
+}
+
+while getopts :p o
+do
+	case $o in
+		p) PAUSE_ON_FAIL="yes";;
+		*) exit 1;;
+	esac
+done
+
+# Create namespaces before setting up the exit trap.
+# Otherwise, exit_cleanup_all() could delete namespaces that were not created
+# by this script.
+create_namespaces
+
+set -e
+trap exit_cleanup_all EXIT
+
+setup_underlay
+setup_overlay_common
+
+test_overlay mpls_uc nomultiproto
+test_overlay ipv4 nomultiproto
+test_overlay ipv6 nomultiproto
+test_overlay ipv4 multiproto
+
+if [ "${ERR}" -eq 1 ]; then
+	echo "Some tests failed." >&2
+else
+	ERR=0
+fi
-- 
2.21.3

