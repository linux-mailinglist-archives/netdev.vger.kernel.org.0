Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4A5352AA1
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 14:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbhDBMUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 08:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235449AbhDBMUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 08:20:44 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8964AC06178A;
        Fri,  2 Apr 2021 05:20:36 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id f10so3462381pgl.9;
        Fri, 02 Apr 2021 05:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=58J+EUTyGL3Us4x13yazJGEPZrC9YAgAKyizeHjf+pU=;
        b=HCJiYfcWXnuQshq6H2WKeXnL67qX7JtDSwkom1oLjdSvrto6oA9L5/BujI5S4rgZE7
         RgxtwW+b+5CQWqMcn8vFnvhgkfMm6fsxi+piqrzgRWJpw6Cug6XsGyQyCV0TqGgybkBt
         afU99O7ix8JJ/Prkc1hA9+YPp8d+U8SvEf9V2MMbxckFyVcQo1yC+Se2MAMXukYZ498p
         4kBMSMQqT6gSU0Dcgw7D/ITR5x6paESvs+wW19IvF33Exi3MEaOrViyca7Ejnw96g3m5
         gugMA4/T+rBz6gQkEIEWr3VvX4//eNthuuTyIyMkrTLENjFAXb5y8GuJ91cAbcqOe4Dy
         mECA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=58J+EUTyGL3Us4x13yazJGEPZrC9YAgAKyizeHjf+pU=;
        b=fzv/15LXUbYqKoYr5TUyraO6xTUF9n5QbTKkZMQPvXD4BpABGPkSbSBKl27oqAWNIG
         3ZH/G1g49vgmMpZeirxG2a/3z9KC3vocdvVzBx2jTsERn5fPpbPnH6lBBnAilzSwgA+w
         NDS8NNeEKq1xQHw/BTuJHDOkknEisvjccLjSkExVCPxSJqCKi8QKCotPjY2ymK68tgCz
         TA1AvSVeyMbz6jK/+yX351VqnjD5KzWxWoN+2yFDKX9cUkFYK9mkk3mYRM32cdlzGAp8
         4FfA2PPSj5jkKHOEH+eio+FK2ssM2NhzerVeyTQ7ryBWxZ8A+yGVnDmdEbe2RwpfouDG
         Reiw==
X-Gm-Message-State: AOAM532ti3UExYEPII9G//ZWtdQG/IavX+DcqrrZFsmav2+NwunjCB+l
        bs/9eGsj3NxrIA6ncOaSH+NSw186pnlSsg==
X-Google-Smtp-Source: ABdhPJzrlwo//q0DNKFmLvRWBateriPxXoxMZ+nJ6AmAPg+vMBy2jzDbyr4C+KTA/D6LJKebBRhmiA==
X-Received: by 2002:a63:d449:: with SMTP id i9mr11349604pgj.227.1617366035587;
        Fri, 02 Apr 2021 05:20:35 -0700 (PDT)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g15sm8760913pfk.36.2021.04.02.05.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 05:20:35 -0700 (PDT)
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
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv4 bpf-next 4/4] selftests/bpf: add xdp_redirect_multi test
Date:   Fri,  2 Apr 2021 20:19:54 +0800
Message-Id: <20210402121954.3568992-5-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210402121954.3568992-1-liuhangbin@gmail.com>
References: <20210402121954.3568992-1-liuhangbin@gmail.com>
MIME-Version: 1.0
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
]# ./test_xdp_redirect_multi.sh
Pass: xdpgeneric arp ns1-2
Pass: xdpgeneric arp ns1-3
Pass: xdpgeneric arp ns1-4
Pass: xdpgeneric ping ns1-2
Pass: xdpgeneric ping ns1-3
Pass: xdpgeneric ping ns1-4
Pass: xdpgeneric ping6 ns1-2
Pass: xdpgeneric ping6 ns1-1 number
Pass: xdpgeneric ping6 ns1-2 number
Pass: xdpdrv arp ns1-2
Pass: xdpdrv arp ns1-3
Pass: xdpdrv arp ns1-4
Pass: xdpdrv ping ns1-2
Pass: xdpdrv ping ns1-3
Pass: xdpdrv ping ns1-4
Pass: xdpdrv ping6 ns1-2
Pass: xdpdrv ping6 ns1-1 number
Pass: xdpdrv ping6 ns1-2 number
Pass: xdpegress mac ns1-2
Pass: xdpegress mac ns1-3
Pass: xdpegress mac ns1-4
Summary: PASS 21, FAIL 0

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

---
v4: add a IPv6 test to validates that single redirect still works
    after multicast redirect.
v2-v3: no update
---
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../bpf/progs/xdp_redirect_multi_kern.c       |  99 ++++++++
 .../selftests/bpf/test_xdp_redirect_multi.sh  | 205 +++++++++++++++
 .../selftests/bpf/xdp_redirect_multi.c        | 236 ++++++++++++++++++
 4 files changed, 542 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_redirect_multi.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 6448c626498f..0c08b662a64e 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -49,6 +49,7 @@ TEST_FILES = xsk_prereqs.sh \
 # Order correspond to 'make run_tests' order
 TEST_PROGS := test_kmod.sh \
 	test_xdp_redirect.sh \
+	test_xdp_redirect_multi.sh \
 	test_xdp_meta.sh \
 	test_xdp_veth.sh \
 	test_offload.py \
@@ -79,7 +80,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
 TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
 	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
 	test_lirc_mode2_user xdping test_cpp runqslower bench bpf_testmod.ko \
-	xdpxceiver
+	xdpxceiver xdp_redirect_multi
 
 TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read
 
diff --git a/tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c b/tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
new file mode 100644
index 000000000000..099bf444acab
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
@@ -0,0 +1,99 @@
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
+/* It would be easier to use a key:if_index, value:if_index map, but it
+ * will need a very large entries as the if_index number may get very large,
+ * this would affect the performace. So the DEVMAP here is just for testing.
+ */
+struct {
+	__uint(type, BPF_MAP_TYPE_DEVMAP);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+	__uint(max_entries, 1024);
+} map_v4 SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_DEVMAP_HASH);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+	__uint(max_entries, 128);
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
+	if (h_proto == bpf_htons(ETH_P_IP))
+		return bpf_redirect_map(&map_v4, 0, BPF_F_REDIR_MASK);
+	else if (h_proto == bpf_htons(ETH_P_IPV6))
+		return bpf_redirect_map(&map_all, if_index, 0);
+	else
+		return bpf_redirect_map(&map_all, 0, BPF_F_REDIR_MASK);
+}
+
+/* The following 2 progs are for 2nd devmap prog testing */
+SEC("xdp_redirect_map_ingress")
+int xdp_redirect_map_all_prog(struct xdp_md *ctx)
+{
+	return bpf_redirect_map(&map_egress, 0, BPF_F_REDIR_MASK);
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
index 000000000000..414f331823d2
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
@@ -0,0 +1,205 @@
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
+#     map_all has interfaces: veth1, veth2, veth3, veth4, ... (All traffic except IPv4)
+#     map_v4 has interfaces: veth1, veth3, veth4, ... (For IPv4 traffic only)
+#     map_egress has all interfaces and redirect all pkts
+# Map type:
+#     map_v4 use DEVMAP, others use DEVMAP_HASH
+#
+# Test modules:
+# XDP modes: generic, native, native + egress_prog
+#
+# Test cases:
+#     ARP:
+#        ns1 -> gw: ns2, ns3, ns4 should receive the arp request
+#     IPv4:
+#        ping test: ns1 -> ns2 (block), ns1 -> ns3 (pass), ns1 -> ns4 (pass)
+#     IPv6:
+#        ping test: ns1 -> ns2 (block), echo requests will be redirect back
+#     egress_prog:
+#        all src mac should be egress interface's mac
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
+		test_pass "$mode ping ns1-3" || test_fail "$mode ping ns1-3"
+	ip netns exec ns1 ping 192.0.2.4 -c 4 &> /dev/null && \
+		test_pass "$mode ping ns1-4" || test_fail "$mode ping ns1-4"
+
+	# ping6 test: echo request should be redirect back to itself, not others
+	ip netns exec ns1 ip neigh add 2001:db8::2 dev veth0 lladdr 00:00:00:00:00:02
+	ip netns exec ns1 tcpdump -i veth0 -nn -l &> ping6_ns1_${mode}.log &
+	ip netns exec ns2 tcpdump -i veth0 -nn -l &> ping6_ns2_${mode}.log &
+	sleep 2
+	ip netns exec ns1 ping6 2001:db8::2 -c 2 &> /dev/null && \
+		test_fail "$mode ping6 ns1-2" || test_pass "$mode ping6 ns1-2"
+	sleep 2
+	pkill -9 tcpdump
+	ns1_echo_num=$(grep "ICMP6, echo request" ping6_ns1_${mode}.log | wc -l)
+	[ $ns1_echo_num -eq 4 ] && test_pass "$mode ping6 ns1-1 number" || \
+		test_fail "$mode ping6 ns1-1 number"
+	ns2_echo_num=$(grep "ICMP6, echo request" ping6_ns2_${mode}.log | wc -l)
+	[ $ns2_echo_num -eq 0 ] && test_pass "$mode ping6 ns1-2 number" || \
+		test_fail "$mode ping6 ns1-2 number"
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
+rm -f xdp_redirect_*.log arp_ns*.log ping6_ns*.log mac_ns*.log
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
index 000000000000..6a282dde90bd
--- /dev/null
+++ b/tools/testing/selftests/bpf/xdp_redirect_multi.c
@@ -0,0 +1,236 @@
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
+	int prog_fd, group_all, group_v4, mac_map;
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
+	group_v4 = bpf_object__find_map_fd_by_name(obj, "map_v4");
+	mac_map = bpf_object__find_map_fd_by_name(obj, "mac_map");
+
+	if (group_all < 0 || group_v4 < 0 || mac_map < 0) {
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
+		/* For testing: skip adding the 2nd interfaces to group v4 */
+		if (i != 1) {
+			ret = bpf_map_update_elem(group_v4, &ifindex, &ifindex, 0);
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
2.26.3

