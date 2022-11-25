Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26112638EA6
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 17:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiKYQ42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 11:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiKYQ4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 11:56:21 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D202D1C7;
        Fri, 25 Nov 2022 08:56:18 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669395376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nHn+krM5zkqrj8eTzbiYYf9V3Ti8/2Hp14OPp+k9Zxs=;
        b=V5BFmn+peox5bSPvDeTnqHZLgfjhmzcLYsK63VuTo+RpWPzNVdgR12zDysitfqZwbGNr+0
        8WUnONv6NaUPzAvzatYdUSXk7i1I77uqKagKqd6G/8FIju/MASmeRLEZGYnr4uYoOilxJi
        DqQsduSFUBrrJoaec8bqUeSBi1WxYEC1JgWVLYv3VcvCktc1CMmTB1IjbOnjYMP1EoQ461
        M7ZaxcQ+g5Sz+xgdObU2Y2LpOjIj505O4e9WfLQrxJrHMh29nyjB+QF0Vvd24diEiGvjmq
        seykhXVCa3QTJGlyO3EalKrRxg5EpqyvR/CAJKBmouJe9eNhgkT0hJoo5mchvA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669395376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nHn+krM5zkqrj8eTzbiYYf9V3Ti8/2Hp14OPp+k9Zxs=;
        b=V4DI8XqkoF+otsTJMGygfdDPhHurt88CKvmSfYlNMTZPuAki1nN+8Ngi+ktJlHTWBB0eWl
        BvuIgO8U9i3F88Aw==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: [PATCH v4 net-next 8/8] selftests: Add a basic HSR test.
Date:   Fri, 25 Nov 2022 17:56:10 +0100
Message-Id: <20221125165610.3802446-9-bigeasy@linutronix.de>
In-Reply-To: <20221125165610.3802446-1-bigeasy@linutronix.de>
References: <20221125165610.3802446-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test adds a basic HSRv0 network with 3 nodes. In its current shape
it sends and forwards packets, announcements and so merges nodes based
on MAC A/B information.
It is able to detect duplicate packets and packetloss should any occur.

Cc: Shuah Khan <shuah@kernel.org>
Cc: linux-kselftest@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 tools/testing/selftests/Makefile            |   1 +
 tools/testing/selftests/net/hsr/Makefile    |   7 +
 tools/testing/selftests/net/hsr/config      |   4 +
 tools/testing/selftests/net/hsr/hsr_ping.sh | 256 ++++++++++++++++++++
 4 files changed, 268 insertions(+)
 create mode 100644 tools/testing/selftests/net/hsr/Makefile
 create mode 100644 tools/testing/selftests/net/hsr/config
 create mode 100755 tools/testing/selftests/net/hsr/hsr_ping.sh

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Mak=
efile
index f07aef7c592c2..b57b091d80268 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -48,6 +48,7 @@ TARGETS +=3D nci
 TARGETS +=3D net
 TARGETS +=3D net/af_unix
 TARGETS +=3D net/forwarding
+TARGETS +=3D net/hsr
 TARGETS +=3D net/mptcp
 TARGETS +=3D net/openvswitch
 TARGETS +=3D netfilter
diff --git a/tools/testing/selftests/net/hsr/Makefile b/tools/testing/selft=
ests/net/hsr/Makefile
new file mode 100644
index 0000000000000..92c1d9d080cd5
--- /dev/null
+++ b/tools/testing/selftests/net/hsr/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0
+
+top_srcdir =3D ../../../../..
+
+TEST_PROGS :=3D hsr_ping.sh
+
+include ../../lib.mk
diff --git a/tools/testing/selftests/net/hsr/config b/tools/testing/selftes=
ts/net/hsr/config
new file mode 100644
index 0000000000000..22061204fb691
--- /dev/null
+++ b/tools/testing/selftests/net/hsr/config
@@ -0,0 +1,4 @@
+CONFIG_IPV6=3Dy
+CONFIG_NET_SCH_NETEM=3Dm
+CONFIG_HSR=3Dy
+CONFIG_VETH=3Dy
diff --git a/tools/testing/selftests/net/hsr/hsr_ping.sh b/tools/testing/se=
lftests/net/hsr/hsr_ping.sh
new file mode 100755
index 0000000000000..df91435387086
--- /dev/null
+++ b/tools/testing/selftests/net/hsr/hsr_ping.sh
@@ -0,0 +1,256 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ret=3D0
+ksft_skip=3D4
+ipv6=3Dtrue
+
+optstring=3D"h4"
+usage() {
+	echo "Usage: $0 [OPTION]"
+	echo -e "\t-4: IPv4 only: disable IPv6 tests (default: test both IPv4 and=
 IPv6)"
+}
+
+while getopts "$optstring" option;do
+	case "$option" in
+	"h")
+		usage $0
+		exit 0
+		;;
+	"4")
+		ipv6=3Dfalse
+		;;
+	"?")
+		usage $0
+		exit 1
+		;;
+esac
+done
+
+sec=3D$(date +%s)
+rndh=3D$(printf %x $sec)-$(mktemp -u XXXXXX)
+ns1=3D"ns1-$rndh"
+ns2=3D"ns2-$rndh"
+ns3=3D"ns3-$rndh"
+
+cleanup()
+{
+	local netns
+	for netns in "$ns1" "$ns2" "$ns3" ;do
+		ip netns del $netns
+	done
+}
+
+ip -Version > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without ip tool"
+	exit $ksft_skip
+fi
+
+trap cleanup EXIT
+
+for i in "$ns1" "$ns2" "$ns3" ;do
+	ip netns add $i || exit $ksft_skip
+	ip -net $i link set lo up
+done
+
+echo "INFO: preparing interfaces."
+# Three HSR nodes. Each node has one link to each of its neighbour, two li=
nks in total.
+#
+#    ns1eth1 ----- ns2eth1
+#      hsr1         hsr2
+#    ns1eth2       ns2eth2
+#       |            |
+#    ns3eth1      ns3eth2
+#           \    /
+#            hsr3
+#
+# Interfaces
+ip link add ns1eth1 netns "$ns1" type veth peer name ns2eth1 netns "$ns2"
+ip link add ns1eth2 netns "$ns1" type veth peer name ns3eth1 netns "$ns3"
+ip link add ns3eth2 netns "$ns3" type veth peer name ns2eth2 netns "$ns2"
+
+# HSRv0.
+ip -net "$ns1" link add name hsr1 type hsr slave1 ns1eth1 slave2 ns1eth2 s=
upervision 45 version 0 proto 0
+ip -net "$ns2" link add name hsr2 type hsr slave1 ns2eth1 slave2 ns2eth2 s=
upervision 45 version 0 proto 0
+ip -net "$ns3" link add name hsr3 type hsr slave1 ns3eth1 slave2 ns3eth2 s=
upervision 45 version 0 proto 0
+
+# IP for HSR
+ip -net "$ns1" addr add 100.64.0.1/24 dev hsr1
+ip -net "$ns1" addr add dead:beef:1::1/64 dev hsr1 nodad
+ip -net "$ns2" addr add 100.64.0.2/24 dev hsr2
+ip -net "$ns2" addr add dead:beef:1::2/64 dev hsr2 nodad
+ip -net "$ns3" addr add 100.64.0.3/24 dev hsr3
+ip -net "$ns3" addr add dead:beef:1::3/64 dev hsr3 nodad
+
+# All Links up
+ip -net "$ns1" link set ns1eth1 up
+ip -net "$ns1" link set ns1eth2 up
+ip -net "$ns1" link set hsr1 up
+
+ip -net "$ns2" link set ns2eth1 up
+ip -net "$ns2" link set ns2eth2 up
+ip -net "$ns2" link set hsr2 up
+
+ip -net "$ns3" link set ns3eth1 up
+ip -net "$ns3" link set ns3eth2 up
+ip -net "$ns3" link set hsr3 up
+
+# $1: IP address
+is_v6()
+{
+	[ -z "${1##*:*}" ]
+}
+
+do_ping()
+{
+	local netns=3D"$1"
+	local connect_addr=3D"$2"
+	local ping_args=3D"-q -c 2"
+
+	if is_v6 "${connect_addr}"; then
+		$ipv6 || return 0
+		ping_args=3D"${ping_args} -6"
+	fi
+
+	ip netns exec ${netns} ping ${ping_args} $connect_addr >/dev/null
+	if [ $? -ne 0 ] ; then
+		echo "$netns -> $connect_addr connectivity [ FAIL ]" 1>&2
+		ret=3D1
+		return 1
+	fi
+
+	return 0
+}
+
+do_ping_long()
+{
+	local netns=3D"$1"
+	local connect_addr=3D"$2"
+	local ping_args=3D"-q -c 10"
+
+	if is_v6 "${connect_addr}"; then
+		$ipv6 || return 0
+		ping_args=3D"${ping_args} -6"
+	fi
+
+	OUT=3D"$(LANG=3DC ip netns exec ${netns} ping ${ping_args} $connect_addr =
| grep received)"
+	if [ $? -ne 0 ] ; then
+		echo "$netns -> $connect_addr ping [ FAIL ]" 1>&2
+		ret=3D1
+		return 1
+	fi
+
+	VAL=3D"$(echo $OUT | cut -d' ' -f1-8)"
+	if [ "$VAL" !=3D "10 packets transmitted, 10 received, 0% packet loss," ]
+	then
+		echo "$netns -> $connect_addr ping TEST [ FAIL ]"
+		echo "Expect to send and receive 10 packets and no duplicates."
+		echo "Full message: ${OUT}."
+		ret=3D1
+		return 1
+	fi
+
+	return 0
+}
+
+stop_if_error()
+{
+	local msg=3D"$1"
+
+	if [ ${ret} -ne 0 ]; then
+		echo "FAIL: ${msg}" 1>&2
+		exit ${ret}
+	fi
+}
+
+
+echo "INFO: Initial validation ping."
+# Each node has to be able each one.
+do_ping "$ns1" 100.64.0.2
+do_ping "$ns2" 100.64.0.1
+do_ping "$ns3" 100.64.0.1
+stop_if_error "Initial validation failed."
+
+do_ping "$ns1" 100.64.0.3
+do_ping "$ns2" 100.64.0.3
+do_ping "$ns3" 100.64.0.2
+
+do_ping "$ns1" dead:beef:1::2
+do_ping "$ns1" dead:beef:1::3
+do_ping "$ns2" dead:beef:1::1
+do_ping "$ns2" dead:beef:1::2
+do_ping "$ns3" dead:beef:1::1
+do_ping "$ns3" dead:beef:1::2
+
+stop_if_error "Initial validation failed."
+
+# Wait until supervisor all supervision frames have been processed and the=
 node
+# entries have been merged. Otherwise duplicate frames will be observed wh=
ich is
+# valid at this stage.
+WAIT=3D5
+while [ ${WAIT} -gt 0 ]
+do
+	grep 00:00:00:00:00:00 /sys/kernel/debug/hsr/hsr*/node_table
+	if [ $? -ne 0 ]
+	then
+		break
+	fi
+	sleep 1
+	let WAIT =3D WAIT - 1
+done
+
+# Just a safety delay in case the above check didn't handle it.
+sleep 1
+
+echo "INFO: Longer ping test."
+do_ping_long "$ns1" 100.64.0.2
+do_ping_long "$ns1" dead:beef:1::2
+do_ping_long "$ns1" 100.64.0.3
+do_ping_long "$ns1" dead:beef:1::3
+
+stop_if_error "Longer ping test failed."
+
+do_ping_long "$ns2" 100.64.0.1
+do_ping_long "$ns2" dead:beef:1::1
+do_ping_long "$ns2" 100.64.0.3
+do_ping_long "$ns2" dead:beef:1::2
+stop_if_error "Longer ping test failed."
+
+do_ping_long "$ns3" 100.64.0.1
+do_ping_long "$ns3" dead:beef:1::1
+do_ping_long "$ns3" 100.64.0.2
+do_ping_long "$ns3" dead:beef:1::2
+stop_if_error "Longer ping test failed."
+
+echo "INFO: Cutting one link."
+do_ping_long "$ns1" 100.64.0.3 &
+
+sleep 3
+ip -net "$ns3" link set ns3eth1 down
+wait
+
+ip -net "$ns3" link set ns3eth1 up
+
+stop_if_error "Failed with one link down."
+
+echo "INFO: Delay the link and drop a few packages."
+tc -net "$ns3" qdisc add dev ns3eth1 root netem delay 50ms
+tc -net "$ns2" qdisc add dev ns2eth1 root netem delay 5ms loss 25%
+
+do_ping_long "$ns1" 100.64.0.2
+do_ping_long "$ns1" 100.64.0.3
+
+stop_if_error "Failed with delay and packetloss."
+
+do_ping_long "$ns2" 100.64.0.1
+do_ping_long "$ns2" 100.64.0.3
+
+stop_if_error "Failed with delay and packetloss."
+
+do_ping_long "$ns3" 100.64.0.1
+do_ping_long "$ns3" 100.64.0.2
+stop_if_error "Failed with delay and packetloss."
+
+echo "INFO: All good."
+exit $ret
--=20
2.38.1

