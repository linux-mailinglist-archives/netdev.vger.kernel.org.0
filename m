Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793522FFDA0
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 08:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbhAVHuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 02:50:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbhAVHso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 02:48:44 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70EBC06178C;
        Thu, 21 Jan 2021 23:47:58 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id w18so3179316pfu.9;
        Thu, 21 Jan 2021 23:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7qVZEvRxHoyf9VwkkeNWRzQsvKD+I71mMookeyBCMN4=;
        b=Sbo6rQCfruKazQGnpRxQNI2xtm4CrgxeVoO+pMxlc2AJm9zQuEL+fkBpjPGNQHsubf
         VsQSUcXcF2YiD55JQGOgotP5yV15INkqJfwJ5UPAIqtHmaf4aWPYi3Y3jL6umCHnHqvG
         N2SnTisu+qQcogs3h9qIqaxtJGCYXX8OejNeG5jjbfhqqRdKwnrv+YlqeT3PmEaUEign
         c/9GKlLhL/ICjVWDDAiMAWi+xask7wjF/A1u806UuiyVtnAfxIZwiJ5kWpVFH5v0Au/a
         m4Wska0ETT5fcAC4ehZwsSU/343jWcBZHSPyM8CKozxqUwOfQ9Ou3V6day5DQZZUKMC1
         vr4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7qVZEvRxHoyf9VwkkeNWRzQsvKD+I71mMookeyBCMN4=;
        b=OzjtIFCrXWXnL0i2BdyJijpnXGeM0Gony6/UERrVJV/HxMCzJXNEekE4yfas0qOx/z
         eOzUMoUfexDJ8gDtQNWBSM7Uv7lyKt6GLLSfhj6zFpSFJm9YlBWw7LbIBNWC5/HDLbY0
         RUCtcRZ+/WzZRfH6DmVDriFKnsXzz7QtT7Sj8JS5aRvUSWX0wjtFTF76j7NoI4cOZ0Og
         /TkpD768S/f21FIODzklO86yLFcn460sMfiysYgwIGlRAKZQ22XQ4ud+XgRYAU/D8OmH
         55+UsBO4USfU6Tbfu7rM7Uk84sHk73Oq8Br5ZbezfeGa+acG/tiXZQ+XgJrGrVdRsJ/W
         Rh/g==
X-Gm-Message-State: AOAM533daLKIa/rXy7DKUOHeR4Umyo81Ztez1A8cFHqZZwU3Lk69WMwo
        LdDvZY6u3iMN6Jq62lG9uuSO9qF4mNpg3g==
X-Google-Smtp-Source: ABdhPJzkX4Hs7C8zW8luGUyLF+ocN6aM6byw25ENISYz1rIhzX2NmRHzmGf69HBQ28r9OmA7mpTtAQ==
X-Received: by 2002:a62:ee0c:0:b029:1a8:db14:927e with SMTP id e12-20020a62ee0c0000b02901a8db14927emr3598929pfi.14.1611301677975;
        Thu, 21 Jan 2021 23:47:57 -0800 (PST)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 145sm8081384pge.88.2021.01.21.23.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 23:47:57 -0800 (PST)
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
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv16 bpf-next 6/6] selftests/bpf: add xdp_redirect_multi test
Date:   Fri, 22 Jan 2021 15:46:52 +0800
Message-Id: <20210122074652.2981711-7-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122074652.2981711-1-liuhangbin@gmail.com>
References: <20210120022514.2862872-1-liuhangbin@gmail.com>
 <20210122074652.2981711-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a bpf selftest for new helper xdp_redirect_map_multi(). In this
test we have 3 forward groups and 1 exclude group. The test will
redirect each interface's packets to all the interfaces in the forward
group, and exclude the interface in exclude map. We will also test both
DEVMAP and DEVMAP_HASH with xdp generic and drv.

For more test details, you can find it in the test script. Here is
the test result.
]# ./test_xdp_redirect_multi.sh
Pass: xdpgeneric arp ns1-2
Pass: xdpgeneric arp ns1-3
Pass: xdpgeneric arp ns1-4
Pass: xdpgeneric ping ns1-2
Pass: xdpgeneric ping ns1-3
Pass: xdpgeneric ping ns1-4
Pass: xdpgeneric ping6 ns2-1
Pass: xdpgeneric ping6 ns2-3
Pass: xdpgeneric ping6 ns2-4
Pass: xdpdrv arp ns1-2
Pass: xdpdrv arp ns1-3
Pass: xdpdrv arp ns1-4
Pass: xdpdrv ping ns1-2
Pass: xdpdrv ping ns1-3
Pass: xdpdrv ping ns1-4
Pass: xdpdrv ping6 ns2-1
Pass: xdpdrv ping6 ns2-3
Pass: xdpdrv ping6 ns2-4
Pass: xdpegress mac ns1-2
Pass: xdpegress mac ns1-3
Pass: xdpegress mac ns1-4
Pass: xdpegress ping ns1-2
Pass: xdpegress ping ns1-3
Pass: xdpegress ping ns1-4
Summary: PASS 24, FAIL 0

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

---
v15: use bpf_object__find_program_by_name instead of
     bpf_object__find_program_by_title
v14: no update, only rebase the code
v13: remove setrlimit
v12: add devmap prog test on egress
v9: use NULL directly for arg2 and redefine the maps with btf format
---
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../bpf/progs/xdp_redirect_multi_kern.c       | 111 ++++++++
 .../selftests/bpf/test_xdp_redirect_multi.sh  | 208 +++++++++++++++
 .../selftests/bpf/xdp_redirect_multi.c        | 252 ++++++++++++++++++
 4 files changed, 573 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_redirect_multi.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 63d6288e419c..621dceddb249 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -51,6 +51,7 @@ TEST_FILES = xsk_prereqs.sh \
 # Order correspond to 'make run_tests' order
 TEST_PROGS := test_kmod.sh \
 	test_xdp_redirect.sh \
+	test_xdp_redirect_multi.sh \
 	test_xdp_meta.sh \
 	test_xdp_veth.sh \
 	test_offload.py \
@@ -80,7 +81,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
 TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
 	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
 	test_lirc_mode2_user xdping test_cpp runqslower bench bpf_testmod.ko \
-	xdpxceiver
+	xdpxceiver xdp_redirect_multi
 
 TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read
 
diff --git a/tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c b/tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
new file mode 100644
index 000000000000..dce4df40d9de
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
@@ -0,0 +1,111 @@
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
+struct {
+	__uint(type, BPF_MAP_TYPE_DEVMAP);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+	__uint(max_entries, 128);
+} forward_map_v4 SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_DEVMAP_HASH);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+	__uint(max_entries, 128);
+} forward_map_v6 SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_DEVMAP_HASH);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+	__uint(max_entries, 128);
+} forward_map_all SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_DEVMAP_HASH);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(struct bpf_devmap_val));
+	__uint(max_entries, 128);
+} forward_map_egress SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_DEVMAP_HASH);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+	__uint(max_entries, 128);
+} exclude_map SEC(".maps");
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
+	if (h_proto == bpf_htons(ETH_P_IP))
+		return bpf_redirect_map_multi(&forward_map_v4, &exclude_map,
+					      BPF_F_EXCLUDE_INGRESS);
+	else if (h_proto == bpf_htons(ETH_P_IPV6))
+		return bpf_redirect_map_multi(&forward_map_v6, &exclude_map,
+					      BPF_F_EXCLUDE_INGRESS);
+	else
+		return bpf_redirect_map_multi(&forward_map_all, NULL,
+					      BPF_F_EXCLUDE_INGRESS);
+}
+
+/* The following 2 progs are for 2nd devmap prog testing */
+SEC("xdp_redirect_map_ingress")
+int xdp_redirect_map_all_prog(struct xdp_md *ctx)
+{
+	return bpf_redirect_map_multi(&forward_map_egress, NULL, BPF_F_EXCLUDE_INGRESS);
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
index 000000000000..6503751fdca5
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
@@ -0,0 +1,208 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test topology:
+#     - - - - - - - - - - - - - - - - - - - - - - - - -
+#    | veth1         veth2         veth3         veth4 |  ... init net
+#     - -| - - - - - - | - - - - - - | - - - - - - | - -
+#    ---------     ---------     ---------     ---------
+#    | veth0 |     | veth0 |     | veth0 |     | veth0 |  ...
+#    ---------     ---------     ---------     ---------
+#       ns1           ns2           ns3           ns4
+#
+# Forward maps:
+#     Forward map_all has interfaces: veth1, veth2, veth3, veth4, ... (All traffic except IPv4, IPv6)
+#     Forward map_v4 has interfaces: veth1, veth3, veth4, ... (For IPv4 traffic only)
+#     Forward map_v6 has interfaces: veth2, veth3, veth4, ... (For IPv6 traffic only)
+#     Forward map_egress has all interfaces and redirect all pkts
+# Exclude Groups:
+#     Exclude map: veth3 (assume ns3 is in black list)
+# Map type:
+#     map_v4 use DEVMAP, others use DEVMAP_HASH
+#
+# Test modules:
+# XDP modes: generic, native, native + egress_prog
+#
+# Test cases:
+#     ARP(we didn't block ARP for ns3):
+#        ns1 -> gw: ns2, ns3, ns4 should receive the arp request
+#     IPv4:
+#        ns1 -> ns2 (block), ns1 -> ns3 (block), ns1 -> ns4 (pass)
+#     IPv6
+#        ns2 -> ns1 (block), ns2 -> ns3 (block), ns2 -> ns4 (pass)
+#     egress_prog:
+#        all ping test should pass, the src mac should be egress interface's mac
+#
+
+
+# netns numbers
+NUM=4
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
+	ip netns exec ns4 tcpdump -e -i veth0 -nn -l -e &> mac_ns1-4_${mode}.log &
+	ip netns exec ns1 ping 192.0.2.254 -c 4 &> /dev/null
+	sleep 2
+	pkill -9 tcpdump
+
+	# mac check
+	grep -q "${veth_mac[2]} > ff:ff:ff:ff:ff:ff" mac_ns1-2_${mode}.log && \
+	       test_pass "$mode mac ns1-2" || test_fail "$mode mac ns1-2"
+	grep -q "${veth_mac[3]} > ff:ff:ff:ff:ff:ff" mac_ns1-3_${mode}.log && \
+		test_pass "$mode mac ns1-3" || test_fail "$mode mac ns1-3"
+	grep -q "${veth_mac[4]} > ff:ff:ff:ff:ff:ff" mac_ns1-4_${mode}.log && \
+		test_pass "$mode mac ns1-4" || test_fail "$mode mac ns1-4"
+
+	# ping test
+	ip netns exec ns1 ping 192.0.2.2 -c 4 &> /dev/null && \
+		test_pass "$mode ping ns1-2" || test_fail "$mode ping ns1-2"
+	ip netns exec ns1 ping 192.0.2.3 -c 4 &> /dev/null && \
+		test_pass "$mode ping ns1-3" || test_fail "$mode ping ns1-3"
+	ip netns exec ns1 ping 192.0.2.4 -c 4 &> /dev/null && \
+		test_pass "$mode ping ns1-4" || test_fail "$mode ping ns1-4"
+}
+
+do_ping_tests()
+{
+	local mode=$1
+
+	# arp test
+	ip netns exec ns2 tcpdump -i veth0 -nn -l -e &> arp_ns1-2_${mode}.log &
+	ip netns exec ns3 tcpdump -i veth0 -nn -l -e &> arp_ns1-3_${mode}.log &
+	ip netns exec ns4 tcpdump -i veth0 -nn -l -e &> arp_ns1-4_${mode}.log &
+	ip netns exec ns1 ping 192.0.2.254 -c 4 &> /dev/null
+	sleep 2
+	pkill -9 tcpdump
+	grep -q "Request who-has 192.0.2.254 tell 192.0.2.1" arp_ns1-2_${mode}.log && \
+		test_pass "$mode arp ns1-2" || test_fail "$mode arp ns1-2"
+	grep -q "Request who-has 192.0.2.254 tell 192.0.2.1" arp_ns1-3_${mode}.log && \
+		test_pass "$mode arp ns1-3" || test_fail "$mode arp ns1-3"
+	grep -q "Request who-has 192.0.2.254 tell 192.0.2.1" arp_ns1-4_${mode}.log && \
+		test_pass "$mode arp ns1-4" || test_fail "$mode arp ns1-4"
+
+	# ping test
+	ip netns exec ns1 ping 192.0.2.2 -c 4 &> /dev/null && \
+		test_fail "$mode ping ns1-2" || test_pass "$mode ping ns1-2"
+	ip netns exec ns1 ping 192.0.2.3 -c 4 &> /dev/null && \
+		test_fail "$mode ping ns1-3" || test_pass "$mode ping ns1-3"
+	ip netns exec ns1 ping 192.0.2.4 -c 4 &> /dev/null && \
+		test_pass "$mode ping ns1-4" || test_fail "$mode ping ns1-4"
+
+	# ping6 test
+	ip netns exec ns2 ping6 2001:db8::1 -c 4 &> /dev/null && \
+		test_fail "$mode ping6 ns2-1" || test_pass "$mode ping6 ns2-1"
+	ip netns exec ns2 ping6 2001:db8::3 -c 4 &> /dev/null && \
+		test_fail "$mode ping6 ns2-3" || test_pass "$mode ping6 ns2-3"
+	ip netns exec ns2 ping6 2001:db8::4 -c 4 &> /dev/null && \
+		test_pass "$mode ping6 ns2-4" || test_fail "$mode ping6 ns2-4"
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
+	sleep 10
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
+rm -f xdp_redirect_*.log arp_ns*.log mac_ns*.log
+
+for mode in ${DRV_MODE}; do
+	setup_ns $mode
+	do_tests $mode
+	sleep 10
+	clean_up
+	sleep 5
+done
+
+echo "Summary: PASS $PASS, FAIL $FAIL"
+[ $FAIL -eq 0 ] && exit 0 || exit 1
diff --git a/tools/testing/selftests/bpf/xdp_redirect_multi.c b/tools/testing/selftests/bpf/xdp_redirect_multi.c
new file mode 100644
index 000000000000..b43cd3c9eefd
--- /dev/null
+++ b/tools/testing/selftests/bpf/xdp_redirect_multi.c
@@ -0,0 +1,252 @@
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
+	int prog_fd, group_all, group_v4, group_v6, exclude, mac_map;
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
+		group_all = bpf_object__find_map_fd_by_name(obj, "forward_map_egress");
+	else
+		group_all = bpf_object__find_map_fd_by_name(obj, "forward_map_all");
+	group_v4 = bpf_object__find_map_fd_by_name(obj, "forward_map_v4");
+	group_v6 = bpf_object__find_map_fd_by_name(obj, "forward_map_v6");
+	exclude = bpf_object__find_map_fd_by_name(obj, "exclude_map");
+	mac_map = bpf_object__find_map_fd_by_name(obj, "mac_map");
+
+	if (group_all < 0 || group_v4 < 0 || group_v6 < 0 || exclude < 0 ||
+	    mac_map < 0) {
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
+		/* For testing: remove the 1st interfaces from group v6 */
+		if (i != 0) {
+			ret = bpf_map_update_elem(group_v6, &ifindex, &ifindex, 0);
+			if (ret) {
+				perror("bpf_map_update_elem");
+				goto err_out;
+			}
+		}
+
+		/* For testing: remove the 2nd interfaces from group v4 */
+		if (i != 1) {
+			ret = bpf_map_update_elem(group_v4, &ifindex, &ifindex, 0);
+			if (ret) {
+				perror("bpf_map_update_elem");
+				goto err_out;
+			}
+		}
+
+		/* For testing: add the 3rd interfaces to exclude map */
+		if (i == 2) {
+			ret = bpf_map_update_elem(exclude, &ifindex, &ifindex, 0);
+			if (ret) {
+				perror("bpf_map_update_elem");
+				goto err_out;
+			}
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
2.26.2

