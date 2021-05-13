Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D47E37F362
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 09:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhEMHHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 03:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbhEMHGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 03:06:35 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1880EC061761;
        Thu, 13 May 2021 00:05:26 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id j12so14405349pgh.7;
        Thu, 13 May 2021 00:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kA2WZUy2ShCCkpVm8p/YxgZvUSvfhhyxVCbfaUUU40Y=;
        b=qPO5BfkB1EbuQHstrP8zy7NRLfxqqI52QLEskU1SieM4VUNcLMXypqRvTKC+ZgSZfU
         Txg5APal9vqH5OyfsnPx65Ohq6Ohp9rMnViSom6TlUdPIo6HuJpiXKnOHt4AFkq/g0ql
         LmPZb9GbDczhhommczYWKTsvnoCXfdPrQmWQg2TEMhQxNk07LnZzf7z0cP3JjOlK2VQQ
         6rHRnxkacr88R6oW1aprN/Rj1DCULufcZiVTwOjon/T6PTOHxwTB0uTQ+IV19keDKZ+i
         jaZ3UxMHs5RatF8x8SgA/08dXz3soTdJHjCW5urJfxBqjCUrQxf8UHKIv85y/eJiZSqF
         f4pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kA2WZUy2ShCCkpVm8p/YxgZvUSvfhhyxVCbfaUUU40Y=;
        b=CPveXlT/q+rPi4UefkEWm3zqgCowpMpC65fN/nOAgZpkAv/p14/h/Wni1638JBtanj
         WreZxRf/8gDKvbAYPBrcLW3yagUlWEg8nkKtPI5IrXQ2JkkoA3IKAKmlcwaiaxpv4xjL
         P7JLa8cRJ6XimyI6VNZGrbGVll7XaJiJzg03Vs9tOGaVlN9gmiDpB2sSJqpxJKsiG+1l
         +GT2jtNSeBWSUQ54EldH+AkK2jwxBJNlLsEzqyITkTlT+vUF+7Ug6l7Dl/FeJg6SXDt4
         x6uy0HurwHzSBKP4I3vo+gSRKga+D19K3Mb19SP3bO2K62DXMTiioTL6S7W7Q0NU0rNV
         jr6A==
X-Gm-Message-State: AOAM530eHBRTJTFTvx2IGyM1vnIg3WyN7CsqzjWOujBlmGJMRwJBEcuY
        elugjCsDvrIHWVTu7DLJjCDFh0RbgnSszg==
X-Google-Smtp-Source: ABdhPJwrCnoFd5PCaSv4Xp66gqYbS55a2CiSfLwYNYokhy2YQQJeLyou1dB/3wypU4URW48WYSi5KQ==
X-Received: by 2002:a63:5448:: with SMTP id e8mr39818481pgm.170.1620889525259;
        Thu, 13 May 2021 00:05:25 -0700 (PDT)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n11sm1355227pfu.121.2021.05.13.00.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 00:05:24 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH RESEND v11 4/4] selftests/bpf: add xdp_redirect_multi test
Date:   Thu, 13 May 2021 15:04:47 +0800
Message-Id: <20210513070447.1878448-5-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210513070447.1878448-1-liuhangbin@gmail.com>
References: <20210513070447.1878448-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a bpf selftest for new helper xdp_redirect_map_multi(). In this
test there are 3 forward groups and 1 exclude group. The test will
redirect each interface's packets to all the interfaces in the forward
group, and exclude the interface in exclude map.

Two maps (DEVMAP, DEVMAP_HASH) and two xdp modes (generic, drive) will
be tested. XDP egress program will also be tested by setting pkt src MAC
to egress interface's MAC address.

For more test details, you can find it in the test script. Here is
the test result.
]# time ./test_xdp_redirect_multi.sh
Pass: xdpgeneric arp(F_BROADCAST) ns1-1
Pass: xdpgeneric arp(F_BROADCAST) ns1-2
Pass: xdpgeneric arp(F_BROADCAST) ns1-3
Pass: xdpgeneric IPv4 (F_BROADCAST|F_EXCLUDE_INGRESS) ns1-1
Pass: xdpgeneric IPv4 (F_BROADCAST|F_EXCLUDE_INGRESS) ns1-2
Pass: xdpgeneric IPv4 (F_BROADCAST|F_EXCLUDE_INGRESS) ns1-3
Pass: xdpgeneric IPv6 (no flags) ns1-1
Pass: xdpgeneric IPv6 (no flags) ns1-2
Pass: xdpdrv arp(F_BROADCAST) ns1-1
Pass: xdpdrv arp(F_BROADCAST) ns1-2
Pass: xdpdrv arp(F_BROADCAST) ns1-3
Pass: xdpdrv IPv4 (F_BROADCAST|F_EXCLUDE_INGRESS) ns1-1
Pass: xdpdrv IPv4 (F_BROADCAST|F_EXCLUDE_INGRESS) ns1-2
Pass: xdpdrv IPv4 (F_BROADCAST|F_EXCLUDE_INGRESS) ns1-3
Pass: xdpdrv IPv6 (no flags) ns1-1
Pass: xdpdrv IPv6 (no flags) ns1-2
Pass: xdpegress mac ns1-2
Pass: xdpegress mac ns1-3
Summary: PASS 18, FAIL 0

real    1m18.321s
user    0m0.123s
sys     0m0.350s

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

---
v11: remove some sleeps to reduce the testing time. Re-struct the test
     and make clear what flags we are testing.
v2-v10: no update
v2: add a IPv6 test to validates that single redirect still works
after multicast redirect.
---
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../bpf/progs/xdp_redirect_multi_kern.c       |  94 ++++++++
 .../selftests/bpf/test_xdp_redirect_multi.sh  | 204 ++++++++++++++++
 .../selftests/bpf/xdp_redirect_multi.c        | 226 ++++++++++++++++++
 4 files changed, 526 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_redirect_multi.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 511259c2c6c5..17a2c14c8459 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -54,6 +54,7 @@ TEST_FILES = xsk_prereqs.sh \
 # Order correspond to 'make run_tests' order
 TEST_PROGS := test_kmod.sh \
 	test_xdp_redirect.sh \
+	test_xdp_redirect_multi.sh \
 	test_xdp_meta.sh \
 	test_xdp_veth.sh \
 	test_offload.py \
@@ -84,7 +85,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
 TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
 	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
 	test_lirc_mode2_user xdping test_cpp runqslower bench bpf_testmod.ko \
-	xdpxceiver
+	xdpxceiver xdp_redirect_multi
 
 TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read
 
diff --git a/tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c b/tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
new file mode 100644
index 000000000000..880debcbcd65
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: GPL-2.0
+#define KBUILD_MODNAME "foo"
+#include <string.h>
+#include <linux/in.h>
+#include <linux/if_ether.h>
+#include <linux/if_packet.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+/* One map use devmap, another one use devmap_hash for testing */
+struct {
+	__uint(type, BPF_MAP_TYPE_DEVMAP);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+	__uint(max_entries, 1024);
+} map_all SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_DEVMAP_HASH);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(struct bpf_devmap_val));
+	__uint(max_entries, 128);
+} map_egress SEC(".maps");
+
+/* map to store egress interfaces mac addresses */
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, __u32);
+	__type(value, __be64);
+	__uint(max_entries, 128);
+} mac_map SEC(".maps");
+
+SEC("xdp_redirect_map_multi")
+int xdp_redirect_map_multi_prog(struct xdp_md *ctx)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	int if_index = ctx->ingress_ifindex;
+	struct ethhdr *eth = data;
+	__u16 h_proto;
+	__u64 nh_off;
+
+	nh_off = sizeof(*eth);
+	if (data + nh_off > data_end)
+		return XDP_DROP;
+
+	h_proto = eth->h_proto;
+
+	/* Using IPv4 for (BPF_F_BROADCAST | BPF_F_EXCLUDE_INGRESS) testing */
+	if (h_proto == bpf_htons(ETH_P_IP))
+		return bpf_redirect_map(&map_all, 0,
+					BPF_F_BROADCAST | BPF_F_EXCLUDE_INGRESS);
+	/* Using IPv6 for none flag testing */
+	else if (h_proto == bpf_htons(ETH_P_IPV6))
+		return bpf_redirect_map(&map_all, if_index, 0);
+	/* All others for BPF_F_BROADCAST testing */
+	else
+		return bpf_redirect_map(&map_all, 0, BPF_F_BROADCAST);
+}
+
+/* The following 2 progs are for 2nd devmap prog testing */
+SEC("xdp_redirect_map_ingress")
+int xdp_redirect_map_all_prog(struct xdp_md *ctx)
+{
+	return bpf_redirect_map(&map_egress, 0,
+				BPF_F_BROADCAST | BPF_F_EXCLUDE_INGRESS);
+}
+
+SEC("xdp_devmap/map_prog")
+int xdp_devmap_prog(struct xdp_md *ctx)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	__u32 key = ctx->egress_ifindex;
+	struct ethhdr *eth = data;
+	__u64 nh_off;
+	__be64 *mac;
+
+	nh_off = sizeof(*eth);
+	if (data + nh_off > data_end)
+		return XDP_DROP;
+
+	mac = bpf_map_lookup_elem(&mac_map, &key);
+	if (mac)
+		__builtin_memcpy(eth->h_source, mac, ETH_ALEN);
+
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
new file mode 100755
index 000000000000..1538373157e3
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
@@ -0,0 +1,204 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test topology:
+#     - - - - - - - - - - - - - - - - - - - - - - - - -
+#    | veth1         veth2         veth3 |  ... init net
+#     - -| - - - - - - | - - - - - - | - -
+#    ---------     ---------     ---------
+#    | veth0 |     | veth0 |     | veth0 |  ...
+#    ---------     ---------     ---------
+#       ns1           ns2           ns3
+#
+# Test modules:
+# XDP modes: generic, native, native + egress_prog
+#
+# Test cases:
+#   ARP: Testing BPF_F_BROADCAST, the ingress interface also should receive
+#   the redirects.
+#      ns1 -> gw: ns1, ns2, ns3, should receive the arp request
+#   IPv4: Testing BPF_F_BROADCAST | BPF_F_EXCLUDE_INGRESS, the ingress
+#   interface should not receive the redirects.
+#      ns1 -> gw: ns1 should not receive, ns2, ns3 should receive redirects.
+#   IPv6: Testing none flag, all the pkts should be redirected back
+#      ping test: ns1 -> ns2 (block), echo requests will be redirect back
+#   egress_prog:
+#      all src mac should be egress interface's mac
+
+# netns numbers
+NUM=3
+IFACES=""
+DRV_MODE="xdpgeneric xdpdrv xdpegress"
+PASS=0
+FAIL=0
+
+test_pass()
+{
+	echo "Pass: $@"
+	PASS=$((PASS + 1))
+}
+
+test_fail()
+{
+	echo "fail: $@"
+	FAIL=$((FAIL + 1))
+}
+
+clean_up()
+{
+	for i in $(seq $NUM); do
+		ip link del veth$i 2> /dev/null
+		ip netns del ns$i 2> /dev/null
+	done
+}
+
+# Kselftest framework requirement - SKIP code is 4.
+check_env()
+{
+	ip link set dev lo xdpgeneric off &>/dev/null
+	if [ $? -ne 0 ];then
+		echo "selftests: [SKIP] Could not run test without the ip xdpgeneric support"
+		exit 4
+	fi
+
+	which tcpdump &>/dev/null
+	if [ $? -ne 0 ];then
+		echo "selftests: [SKIP] Could not run test without tcpdump"
+		exit 4
+	fi
+}
+
+setup_ns()
+{
+	local mode=$1
+	IFACES=""
+
+	if [ "$mode" = "xdpegress" ]; then
+		mode="xdpdrv"
+	fi
+
+	for i in $(seq $NUM); do
+	        ip netns add ns$i
+	        ip link add veth$i type veth peer name veth0 netns ns$i
+		ip link set veth$i up
+		ip -n ns$i link set veth0 up
+
+		ip -n ns$i addr add 192.0.2.$i/24 dev veth0
+		ip -n ns$i addr add 2001:db8::$i/64 dev veth0
+		# Add a neigh entry for IPv4 ping test
+		ip -n ns$i neigh add 192.0.2.253 lladdr 00:00:00:00:00:01 dev veth0
+		ip -n ns$i link set veth0 $mode obj \
+			xdp_dummy.o sec xdp_dummy &> /dev/null || \
+			{ test_fail "Unable to load dummy xdp" && exit 1; }
+		IFACES="$IFACES veth$i"
+		veth_mac[$i]=$(ip link show veth$i | awk '/link\/ether/ {print $2}')
+	done
+}
+
+do_egress_tests()
+{
+	local mode=$1
+
+	# mac test
+	ip netns exec ns2 tcpdump -e -i veth0 -nn -l -e &> mac_ns1-2_${mode}.log &
+	ip netns exec ns3 tcpdump -e -i veth0 -nn -l -e &> mac_ns1-3_${mode}.log &
+	sleep 0.5
+	ip netns exec ns1 ping 192.0.2.254 -i 0.1 -c 4 &> /dev/null
+	sleep 0.5
+	pkill -9 tcpdump
+
+	# mac check
+	grep -q "${veth_mac[2]} > ff:ff:ff:ff:ff:ff" mac_ns1-2_${mode}.log && \
+	       test_pass "$mode mac ns1-2" || test_fail "$mode mac ns1-2"
+	grep -q "${veth_mac[3]} > ff:ff:ff:ff:ff:ff" mac_ns1-3_${mode}.log && \
+		test_pass "$mode mac ns1-3" || test_fail "$mode mac ns1-3"
+}
+
+do_ping_tests()
+{
+	local mode=$1
+
+	# ping6 test: echo request should be redirect back to itself, not others
+	ip netns exec ns1 ip neigh add 2001:db8::2 dev veth0 lladdr 00:00:00:00:00:02
+
+	ip netns exec ns1 tcpdump -i veth0 -nn -l -e &> ns1-1_${mode}.log &
+	ip netns exec ns2 tcpdump -i veth0 -nn -l -e &> ns1-2_${mode}.log &
+	ip netns exec ns3 tcpdump -i veth0 -nn -l -e &> ns1-3_${mode}.log &
+	sleep 0.5
+	# ARP test
+	ip netns exec ns1 ping 192.0.2.254 -i 0.1 -c 4 &> /dev/null
+	# IPv4 test
+	ip netns exec ns1 ping 192.0.2.253 -i 0.1 -c 4 &> /dev/null
+	# IPv6 test
+	ip netns exec ns1 ping6 2001:db8::2 -i 0.1 -c 2 &> /dev/null
+	sleep 0.5
+	pkill -9 tcpdump
+
+	# All netns should receive the redirect arp requests
+	[ $(grep -c "who-has 192.0.2.254" ns1-1_${mode}.log) -gt 4 ] && \
+		test_pass "$mode arp(F_BROADCAST) ns1-1" || \
+		test_fail "$mode arp(F_BROADCAST) ns1-1"
+	[ $(grep -c "who-has 192.0.2.254" ns1-2_${mode}.log) -le 4 ] && \
+		test_pass "$mode arp(F_BROADCAST) ns1-2" || \
+		test_fail "$mode arp(F_BROADCAST) ns1-2"
+	[ $(grep -c "who-has 192.0.2.254" ns1-3_${mode}.log) -le 4 ] && \
+		test_pass "$mode arp(F_BROADCAST) ns1-3" || \
+		test_fail "$mode arp(F_BROADCAST) ns1-3"
+
+	# ns1 should not receive the redirect echo request, others should
+	[ $(grep -c "ICMP echo request" ns1-1_${mode}.log) -eq 4 ] && \
+		test_pass "$mode IPv4 (F_BROADCAST|F_EXCLUDE_INGRESS) ns1-1" || \
+		test_fail "$mode IPv4 (F_BROADCAST|F_EXCLUDE_INGRESS) ns1-1"
+	[ $(grep -c "ICMP echo request" ns1-2_${mode}.log) -eq 4 ] && \
+		test_pass "$mode IPv4 (F_BROADCAST|F_EXCLUDE_INGRESS) ns1-2" || \
+		test_fail "$mode IPv4 (F_BROADCAST|F_EXCLUDE_INGRESS) ns1-2"
+	[ $(grep -c "ICMP echo request" ns1-3_${mode}.log) -eq 4 ] && \
+		test_pass "$mode IPv4 (F_BROADCAST|F_EXCLUDE_INGRESS) ns1-3" || \
+		test_fail "$mode IPv4 (F_BROADCAST|F_EXCLUDE_INGRESS) ns1-3"
+
+	# ns1 should receive the echo request, ns2 should not
+	[ $(grep -c "ICMP6, echo request" ns1-1_${mode}.log) -eq 4 ] && \
+		test_pass "$mode IPv6 (no flags) ns1-1" || \
+		test_fail "$mode IPv6 (no flags) ns1-1"
+	[ $(grep -c "ICMP6, echo request" ns1-2_${mode}.log) -eq 0 ] && \
+		test_pass "$mode IPv6 (no flags) ns1-2" || \
+		test_fail "$mode IPv6 (no flags) ns1-2"
+}
+
+do_tests()
+{
+	local mode=$1
+	local drv_p
+
+	case ${mode} in
+		xdpdrv)  drv_p="-N";;
+		xdpegress) drv_p="-X";;
+		xdpgeneric) drv_p="-S";;
+	esac
+
+	./xdp_redirect_multi $drv_p $IFACES &> xdp_redirect_${mode}.log &
+	xdp_pid=$!
+	sleep 1
+
+	if [ "$mode" = "xdpegress" ]; then
+		do_egress_tests $mode
+	else
+		do_ping_tests $mode
+	fi
+
+	kill $xdp_pid
+}
+
+trap clean_up 0 2 3 6 9
+
+check_env
+rm -f xdp_redirect_*.log ns*.log mac_ns*.log
+
+for mode in ${DRV_MODE}; do
+	setup_ns $mode
+	do_tests $mode
+	clean_up
+done
+
+echo "Summary: PASS $PASS, FAIL $FAIL"
+[ $FAIL -eq 0 ] && exit 0 || exit 1
diff --git a/tools/testing/selftests/bpf/xdp_redirect_multi.c b/tools/testing/selftests/bpf/xdp_redirect_multi.c
new file mode 100644
index 000000000000..3696a8f32c23
--- /dev/null
+++ b/tools/testing/selftests/bpf/xdp_redirect_multi.c
@@ -0,0 +1,226 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <linux/if_link.h>
+#include <assert.h>
+#include <errno.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <net/if.h>
+#include <unistd.h>
+#include <libgen.h>
+#include <sys/resource.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <netinet/in.h>
+
+#include "bpf_util.h"
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#define MAX_IFACE_NUM 32
+#define MAX_INDEX_NUM 1024
+
+static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
+static int ifaces[MAX_IFACE_NUM] = {};
+
+static void int_exit(int sig)
+{
+	__u32 prog_id = 0;
+	int i;
+
+	for (i = 0; ifaces[i] > 0; i++) {
+		if (bpf_get_link_xdp_id(ifaces[i], &prog_id, xdp_flags)) {
+			printf("bpf_get_link_xdp_id failed\n");
+			exit(1);
+		}
+		if (prog_id)
+			bpf_set_link_xdp_fd(ifaces[i], -1, xdp_flags);
+	}
+
+	exit(0);
+}
+
+static int get_mac_addr(unsigned int ifindex, void *mac_addr)
+{
+	char ifname[IF_NAMESIZE];
+	struct ifreq ifr;
+	int fd, ret = -1;
+
+	fd = socket(AF_INET, SOCK_DGRAM, 0);
+	if (fd < 0)
+		return ret;
+
+	if (!if_indextoname(ifindex, ifname))
+		goto err_out;
+
+	strcpy(ifr.ifr_name, ifname);
+
+	if (ioctl(fd, SIOCGIFHWADDR, &ifr) != 0)
+		goto err_out;
+
+	memcpy(mac_addr, ifr.ifr_hwaddr.sa_data, 6 * sizeof(char));
+	ret = 0;
+
+err_out:
+	close(fd);
+	return ret;
+}
+
+static void usage(const char *prog)
+{
+	fprintf(stderr,
+		"usage: %s [OPTS] <IFNAME|IFINDEX> <IFNAME|IFINDEX> ...\n"
+		"OPTS:\n"
+		"    -S    use skb-mode\n"
+		"    -N    enforce native mode\n"
+		"    -F    force loading prog\n"
+		"    -X    load xdp program on egress\n",
+		prog);
+}
+
+int main(int argc, char **argv)
+{
+	int prog_fd, group_all, mac_map;
+	struct bpf_program *ingress_prog, *egress_prog;
+	struct bpf_prog_load_attr prog_load_attr = {
+		.prog_type = BPF_PROG_TYPE_UNSPEC,
+	};
+	int i, ret, opt, egress_prog_fd = 0;
+	struct bpf_devmap_val devmap_val;
+	bool attach_egress_prog = false;
+	unsigned char mac_addr[6];
+	char ifname[IF_NAMESIZE];
+	struct bpf_object *obj;
+	unsigned int ifindex;
+	char filename[256];
+
+	while ((opt = getopt(argc, argv, "SNFX")) != -1) {
+		switch (opt) {
+		case 'S':
+			xdp_flags |= XDP_FLAGS_SKB_MODE;
+			break;
+		case 'N':
+			/* default, set below */
+			break;
+		case 'F':
+			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
+			break;
+		case 'X':
+			attach_egress_prog = true;
+			break;
+		default:
+			usage(basename(argv[0]));
+			return 1;
+		}
+	}
+
+	if (!(xdp_flags & XDP_FLAGS_SKB_MODE)) {
+		xdp_flags |= XDP_FLAGS_DRV_MODE;
+	} else if (attach_egress_prog) {
+		printf("Load xdp program on egress with SKB mode not supported yet\n");
+		goto err_out;
+	}
+
+	if (optind == argc) {
+		printf("usage: %s <IFNAME|IFINDEX> <IFNAME|IFINDEX> ...\n", argv[0]);
+		goto err_out;
+	}
+
+	printf("Get interfaces");
+	for (i = 0; i < MAX_IFACE_NUM && argv[optind + i]; i++) {
+		ifaces[i] = if_nametoindex(argv[optind + i]);
+		if (!ifaces[i])
+			ifaces[i] = strtoul(argv[optind + i], NULL, 0);
+		if (!if_indextoname(ifaces[i], ifname)) {
+			perror("Invalid interface name or i");
+			goto err_out;
+		}
+		if (ifaces[i] > MAX_INDEX_NUM) {
+			printf("Interface index to large\n");
+			goto err_out;
+		}
+		printf(" %d", ifaces[i]);
+	}
+	printf("\n");
+
+	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	prog_load_attr.file = filename;
+
+	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
+		goto err_out;
+
+	if (attach_egress_prog)
+		group_all = bpf_object__find_map_fd_by_name(obj, "map_egress");
+	else
+		group_all = bpf_object__find_map_fd_by_name(obj, "map_all");
+	mac_map = bpf_object__find_map_fd_by_name(obj, "mac_map");
+
+	if (group_all < 0 || mac_map < 0) {
+		printf("bpf_object__find_map_fd_by_name failed\n");
+		goto err_out;
+	}
+
+	if (attach_egress_prog) {
+		/* Find ingress/egress prog for 2nd xdp prog */
+		ingress_prog = bpf_object__find_program_by_name(obj, "xdp_redirect_map_all_prog");
+		egress_prog = bpf_object__find_program_by_name(obj, "xdp_devmap_prog");
+		if (!ingress_prog || !egress_prog) {
+			printf("finding ingress/egress_prog in obj file failed\n");
+			goto err_out;
+		}
+		prog_fd = bpf_program__fd(ingress_prog);
+		egress_prog_fd = bpf_program__fd(egress_prog);
+		if (prog_fd < 0 || egress_prog_fd < 0) {
+			printf("find egress_prog fd failed\n");
+			goto err_out;
+		}
+	}
+
+	signal(SIGINT, int_exit);
+	signal(SIGTERM, int_exit);
+
+	/* Init forward multicast groups and exclude group */
+	for (i = 0; ifaces[i] > 0; i++) {
+		ifindex = ifaces[i];
+
+		if (attach_egress_prog) {
+			ret = get_mac_addr(ifindex, mac_addr);
+			if (ret < 0) {
+				printf("get interface %d mac failed\n", ifindex);
+				goto err_out;
+			}
+			ret = bpf_map_update_elem(mac_map, &ifindex, mac_addr, 0);
+			if (ret) {
+				perror("bpf_update_elem mac_map failed\n");
+				goto err_out;
+			}
+		}
+
+		/* Add all the interfaces to group all */
+		devmap_val.ifindex = ifindex;
+		devmap_val.bpf_prog.fd = egress_prog_fd;
+		ret = bpf_map_update_elem(group_all, &ifindex, &devmap_val, 0);
+		if (ret) {
+			perror("bpf_map_update_elem");
+			goto err_out;
+		}
+
+		/* bind prog_fd to each interface */
+		ret = bpf_set_link_xdp_fd(ifindex, prog_fd, xdp_flags);
+		if (ret) {
+			printf("Set xdp fd failed on %d\n", ifindex);
+			goto err_out;
+		}
+	}
+
+	/* sleep some time for testing */
+	sleep(999);
+
+	return 0;
+
+err_out:
+	return 1;
+}
-- 
2.26.3

