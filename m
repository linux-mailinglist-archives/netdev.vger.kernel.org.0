Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52BCF1B7021
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 10:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgDXI4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 04:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbgDXI4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 04:56:35 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CB3C09B045;
        Fri, 24 Apr 2020 01:56:34 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id c63so9466401qke.2;
        Fri, 24 Apr 2020 01:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LpyM978HZ4cFkZ+uJr3XLeWS1XN6gMA3JsC5cZ+XA1Q=;
        b=PvqpXBCeB0DD2Q15hGeGtWg7AKXqpXTYAIde+fv6FqkbsahrE1kiYwRwnEhLADOjyX
         XOiQsmtHT+uOeYjtn05MbhFXx15rsXPfaKsdfIJURtntsx3WgQ60yPudx0c/Q3hg6OTX
         5IPp6C/ooK5sGnPf3Su+Rbv8MBvu1wjyBPfZgWkJtFkJ+AaYLBSWzl7MK7RAlvJPqaAm
         CIShvRWYEW6kHo9b4D24apH0f7z4Gu/DoARA6H+oyQXL38PjG9wC2wBiP+ZQp1ZZWax2
         AIR8P2jSF0d9ygDMo3+5GyiD40jAyR6UBJXbLa0eV5CH4RkIAPBeUb1Nsoq77cFmqHc/
         YBKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LpyM978HZ4cFkZ+uJr3XLeWS1XN6gMA3JsC5cZ+XA1Q=;
        b=pU4NqjfE8Xb2h65GNExorWMdG4AW16susX/ue4TdsldImnRn8l8sxCfZXO1W9WvHSv
         raXy3wco8B6c65qfDs1/LLF7izYLoELhC8M+oD5U6UGF+MCSw9+XKlbnAUKl0HfKKH2b
         eakAJTYzNEXfiijm38+NkoNX/f84jVFGBAlr6TAwFUIxe9+al5/YX1IDw7Jr6lnwYomw
         X5asd1NZcV/CW5MU0fG4qC8H2phsNzb6QZ0B0Eo+UL0KcjRsmcp/IS3v2CvscgsYftxM
         xx5iAGUhF82TNqeh4phuFGvieEQBFu5+YZr5yUFT8O5S8GWfvG20YEug+JjCq8na20k5
         B2/A==
X-Gm-Message-State: AGi0PubLN9/Kc/g2CTSjNlGZ99PSNUTmAMRx5ZKwIVHO1wl4Y59pbnzP
        e6fzoCEMp2nw9Ttrm+fg1tGi6Ejspyc=
X-Google-Smtp-Source: APiQypKbd1tvQDhHpnEcTP+1K3tJbVHae9yL4suYt0MSwIosxiAdA+qqh1xNWjODDsLjx3fRZNmQYA==
X-Received: by 2002:a37:66d0:: with SMTP id a199mr5283536qkc.245.1587718592639;
        Fri, 24 Apr 2020 01:56:32 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z18sm3390842qti.47.2020.04.24.01.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 01:56:32 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [RFC PATCHv2 bpf-next 2/2] sample/bpf: add xdp_redirect_map_multicast test
Date:   Fri, 24 Apr 2020 16:56:10 +0800
Message-Id: <20200424085610.10047-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200424085610.10047-1-liuhangbin@gmail.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
 <20200424085610.10047-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a sample for xdp multicast. In the sample we have 3 forward
groups and 1 exclude group. It will redirect each interface's
packets to all the interfaces in the forward group, and exclude
the interface in exclude map.

For more testing details, please see the test description in
xdp_redirect_map_multi.sh.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 samples/bpf/Makefile                      |   3 +
 samples/bpf/xdp_redirect_map_multi.sh     | 124 ++++++++++++++++
 samples/bpf/xdp_redirect_map_multi_kern.c | 100 +++++++++++++
 samples/bpf/xdp_redirect_map_multi_user.c | 170 ++++++++++++++++++++++
 4 files changed, 397 insertions(+)
 create mode 100755 samples/bpf/xdp_redirect_map_multi.sh
 create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
 create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 424f6fe7ce38..eb7306efe85e 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -41,6 +41,7 @@ tprogs-y += test_map_in_map
 tprogs-y += per_socket_stats_example
 tprogs-y += xdp_redirect
 tprogs-y += xdp_redirect_map
+tprogs-y += xdp_redirect_map_multi
 tprogs-y += xdp_redirect_cpu
 tprogs-y += xdp_monitor
 tprogs-y += xdp_rxq_info
@@ -97,6 +98,7 @@ test_map_in_map-objs := bpf_load.o test_map_in_map_user.o
 per_socket_stats_example-objs := cookie_uid_helper_example.o
 xdp_redirect-objs := xdp_redirect_user.o
 xdp_redirect_map-objs := xdp_redirect_map_user.o
+xdp_redirect_map_multi-objs := xdp_redirect_map_multi_user.o
 xdp_redirect_cpu-objs := bpf_load.o xdp_redirect_cpu_user.o
 xdp_monitor-objs := bpf_load.o xdp_monitor_user.o
 xdp_rxq_info-objs := xdp_rxq_info_user.o
@@ -156,6 +158,7 @@ always-y += tcp_tos_reflect_kern.o
 always-y += tcp_dumpstats_kern.o
 always-y += xdp_redirect_kern.o
 always-y += xdp_redirect_map_kern.o
+always-y += xdp_redirect_map_multi_kern.o
 always-y += xdp_redirect_cpu_kern.o
 always-y += xdp_monitor_kern.o
 always-y += xdp_rxq_info_kern.o
diff --git a/samples/bpf/xdp_redirect_map_multi.sh b/samples/bpf/xdp_redirect_map_multi.sh
new file mode 100755
index 000000000000..1999f261a1e8
--- /dev/null
+++ b/samples/bpf/xdp_redirect_map_multi.sh
@@ -0,0 +1,124 @@
+#!/bin/bash
+# Test topology:
+#     - - - - - - - - - - - - - - - - - - - - - - - - -
+#    | veth1         veth2         veth3         veth4 |  init net
+#     - -| - - - - - - | - - - - - - | - - - - - - | - -
+#    ---------     ---------     ---------     ---------
+#    | veth0 |     | veth0 |     | veth0 |     | veth0 |
+#    ---------     ---------     ---------     ---------
+#       ns1           ns2           ns3           ns4
+#
+# Forward multicast groups:
+#     Forward group all has interfaces: veth1, veth2, veth3, veth4 (All traffic except IPv4, IPv6)
+#     Forward group v4 has interfaces: veth1, veth3, veth4 (For IPv4 traffic only)
+#     Forward group v6 has interfaces: veth2, veth3, veth4 (For IPv6 traffic only)
+# Exclude Groups:
+#     Exclude group: veth3 (assume ns3 is in black list)
+#
+# Test modules:
+# XDP modes: generic, native
+# map types: group v4 use DEVMAP, others use DEVMAP_HASH
+#
+# Test cases:
+#     ARP(we didn't exclude ns3 in kern.c for ARP):
+#        ns1 -> gw: ns2, ns3, ns4 should receive the arp request
+#     IPv4:
+#        ns1 -> ns2 (fail), ns1 -> ns3 (fail), ns1 -> ns4 (pass)
+#     IPv6
+#        ns2 -> ns1 (fail), ns2 -> ns3 (fail), ns2 -> ns4 (pass)
+#
+
+
+# netns numbers
+NUM=4
+IFACES=""
+DRV_MODE="drv generic"
+
+test_pass()
+{
+	echo "Pass: $@"
+}
+
+test_fail()
+{
+	echo "fail: $@"
+}
+
+clean_up()
+{
+	for i in $(seq $NUM); do
+		ip netns del ns$i
+	done
+}
+
+setup_ns()
+{
+	local mode=$1
+
+	for i in $(seq $NUM); do
+	        ip netns add ns$i
+	        ip link add veth0 type veth peer name veth$i
+	        ip link set veth0 netns ns$i
+		ip netns exec ns$i ip link set veth0 up
+		ip link set veth$i up
+
+		ip netns exec ns$i ip addr add 192.0.2.$i/24 dev veth0
+		ip netns exec ns$i ip addr add 2001:db8::$i/24 dev veth0
+		ip netns exec ns$i ip link set veth0 xdp$mode obj \
+			xdp_redirect_map_multi_kern.o sec xdp_redirect_dummy &> /dev/null || \
+			{ test_fail "Unable to load dummy xdp" && exit 1; }
+		IFACES="$IFACES veth$i"
+	done
+}
+
+do_tests()
+{
+	local drv_mode=$1
+	local drv_p
+
+	[ ${drv_mode} == "drv" ] && drv_p="-N" || drv_p="-S"
+
+	./xdp_redirect_map_multi $drv_p $IFACES &> xdp_${drv_mode}.log &
+	xdp_pid=$!
+	sleep 10
+
+	# arp test
+	ip netns exec ns2 tcpdump -i veth0 -nn -l -e &> arp_ns1-2_${drv_mode}.log &
+	ip netns exec ns3 tcpdump -i veth0 -nn -l -e &> arp_ns1-3_${drv_mode}.log &
+	ip netns exec ns4 tcpdump -i veth0 -nn -l -e &> arp_ns1-4_${drv_mode}.log &
+	ip netns exec ns1 ping 192.0.2.254 -c 4 &> /dev/null
+	sleep 2
+	pkill -9 tcpdump
+	grep -q "Request who-has 192.0.2.254 tell 192.0.2.1" arp_ns1-2_${drv_mode}.log && \
+		test_pass "$drv_mode arp ns1-2" || test_fail "$drv_mode arp ns1-2"
+	grep -q "Request who-has 192.0.2.254 tell 192.0.2.1" arp_ns1-3_${drv_mode}.log && \
+		test_pass "$drv_mode arp ns1-3" || test_fail "$drv_mode arp ns1-3"
+	grep -q "Request who-has 192.0.2.254 tell 192.0.2.1" arp_ns1-4_${drv_mode}.log && \
+		test_pass "$drv_mode arp ns1-4" || test_fail "$drv_mode arp ns1-4"
+
+	# ping test
+	ip netns exec ns1 ping 192.0.2.2 -c 4 &> /dev/null && \
+		test_fail "$drv_mode ping ns1-2" || test_pass "$drv_mode ping ns1-2"
+	ip netns exec ns1 ping 192.0.2.3 -c 4 &> /dev/null && \
+		test_fail "$drv_mode ping ns1-3" || test_pass "$drv_mode ping ns1-3"
+	ip netns exec ns1 ping 192.0.2.4 -c 4 &> /dev/null && \
+		test_pass "$drv_mode ping ns1-4" || test_fail "$drv_mode ping ns1-4"
+
+	# ping6 test
+	ip netns exec ns2 ping6 2001:db8::1 -c 4 &> /dev/null && \
+		test_fail "$drv_mode ping6 ns2-1" || test_pass "$drv_mode ping6 ns2-1"
+	ip netns exec ns2 ping6 2001:db8::3 -c 4 &> /dev/null && \
+		test_fail "$drv_mode ping6 ns2-3" || test_pass "$drv_mode ping6 ns2-3"
+	ip netns exec ns2 ping6 2001:db8::4 -c 4 &> /dev/null && \
+		test_pass "$drv_mode ping6 ns2-4" || test_fail "$drv_mode ping6 ns2-4"
+
+	kill $xdp_pid
+}
+
+for mode in ${DRV_MODE}; do
+	sleep 2
+	setup_ns $mode
+	do_tests $mode
+	sleep 20
+	clean_up
+done
diff --git a/samples/bpf/xdp_redirect_map_multi_kern.c b/samples/bpf/xdp_redirect_map_multi_kern.c
new file mode 100644
index 000000000000..c98985683ba2
--- /dev/null
+++ b/samples/bpf/xdp_redirect_map_multi_kern.c
@@ -0,0 +1,100 @@
+/*
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ */
+#define KBUILD_MODNAME "foo"
+#include <uapi/linux/bpf.h>
+#include <linux/in.h>
+#include <linux/if_ether.h>
+#include <linux/if_packet.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <bpf/bpf_helpers.h>
+
+/* In this sample we will use 3 forward maps and 1 exclude map to
+ * show how to use the helper bpf_redirect_map_multi().
+ *
+ * In real world, there may have multi forward maps and exclude map. You can
+ * use map-in-map type to store the forward and exlude maps. e.g.
+ * forward_map_in_map[group_a_index] = forward_group_a_map
+ * forward_map_in_map[group_b_index] = forward_group_b_map
+ * exclude_map_in_map[iface_1_index] = iface_1_exclude_map
+ * exclude_map_in_map[iface_2_index] = iface_2_exclude_map
+ * Then store the forward group indexes based on IP/MAC policy in another
+ * hash map, e.g.:
+ * mcast_route_map[hash(subnet_a)] = group_a_index
+ * mcast_route_map[hash(subnet_b)] = group_b_index
+ *
+ * You can init the maps in user.c, and find the forward group index from
+ * mcast_route_map bye key hash(subnet) in kern.c, Then you could find
+ * the forward group by the group index. You can also get the exclude map
+ * simply by iface index in exclude_map_in_map.
+ */
+struct bpf_map_def SEC("maps") forward_map_v4 = {
+	.type = BPF_MAP_TYPE_DEVMAP,
+	.key_size = sizeof(u32),
+	.value_size = sizeof(int),
+	.max_entries = 128,
+};
+
+struct bpf_map_def SEC("maps") forward_map_v6 = {
+	.type = BPF_MAP_TYPE_DEVMAP_HASH,
+	.key_size = sizeof(u32),
+	.value_size = sizeof(int),
+	.max_entries = 128,
+};
+
+struct bpf_map_def SEC("maps") forward_map_all = {
+	.type = BPF_MAP_TYPE_DEVMAP_HASH,
+	.key_size = sizeof(u32),
+	.value_size = sizeof(int),
+	.max_entries = 128,
+};
+
+struct bpf_map_def SEC("maps") exclude_map = {
+	.type = BPF_MAP_TYPE_DEVMAP_HASH,
+	.key_size = sizeof(u32),
+	.value_size = sizeof(int),
+	.max_entries = 128,
+};
+
+SEC("xdp_redirect_map_multi")
+int xdp_redirect_map_multi_prog(struct xdp_md *ctx)
+{
+	u32 key, mcast_group_id, exclude_group_id;
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	struct ethhdr *eth = data;
+	int *inmap_id;
+	u16 h_proto;
+	u64 nh_off;
+
+	nh_off = sizeof(*eth);
+	if (data + nh_off > data_end)
+		return XDP_DROP;
+
+	h_proto = eth->h_proto;
+
+	if (h_proto == htons(ETH_P_IP))
+		return bpf_redirect_map_multi(&forward_map_v4, &exclude_map,
+					      BPF_F_EXCLUDE_INGRESS);
+	else if (h_proto == htons(ETH_P_IPV6))
+		return bpf_redirect_map_multi(&forward_map_v6, &exclude_map,
+					      BPF_F_EXCLUDE_INGRESS);
+	else
+		return bpf_redirect_map_multi(&forward_map_all, NULL,
+					      BPF_F_EXCLUDE_INGRESS);
+}
+
+SEC("xdp_redirect_dummy")
+int xdp_redirect_dummy_prog(struct xdp_md *ctx)
+{
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/samples/bpf/xdp_redirect_map_multi_user.c b/samples/bpf/xdp_redirect_map_multi_user.c
new file mode 100644
index 000000000000..2fcd15322201
--- /dev/null
+++ b/samples/bpf/xdp_redirect_map_multi_user.c
@@ -0,0 +1,170 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ */
+#include <linux/bpf.h>
+#include <linux/if_link.h>
+#include <errno.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <net/if.h>
+#include <unistd.h>
+#include <libgen.h>
+
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#define MAX_IFACE_NUM 32
+
+static int ifaces[MAX_IFACE_NUM] = {};
+static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
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
+static void usage(const char *prog)
+{
+	fprintf(stderr,
+		"usage: %s [OPTS] <IFNAME|IFINDEX> <IFNAME|IFINDEX> ... \n"
+		"OPTS:\n"
+		"    -S    use skb-mode\n"
+		"    -N    enforce native mode\n"
+		"    -F    force loading prog\n",
+		prog);
+}
+
+int main(int argc, char **argv)
+{
+	int prog_fd, group_all, group_v4, group_v6, exclude;
+	struct bpf_prog_load_attr prog_load_attr = {
+		.prog_type      = BPF_PROG_TYPE_XDP,
+	};
+	int i, ret, opt, ifindex;
+	char ifname[IF_NAMESIZE];
+	struct bpf_object *obj;
+	char filename[256];
+
+	while ((opt = getopt(argc, argv, "SNF")) != -1) {
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
+		default:
+			usage(basename(argv[0]));
+			return 1;
+		}
+	}
+
+	if (!(xdp_flags & XDP_FLAGS_SKB_MODE))
+		xdp_flags |= XDP_FLAGS_DRV_MODE;
+
+	if (optind == argc) {
+		printf("usage: %s <IFNAME|IFINDEX> <IFNAME|IFINDEX> ...\n", argv[0]);
+		return 1;
+	}
+
+	printf("Get interfaces");
+	for (i = 0; i < MAX_IFACE_NUM && argv[optind + i]; i ++) {
+		ifaces[i] = if_nametoindex(argv[optind + i]);
+		if (!ifaces[i])
+			ifaces[i] = strtoul(argv[optind + i], NULL, 0);
+		if (!if_indextoname(ifaces[i], ifname)) {
+			perror("Invalid interface name or i");
+			return 1;
+		}
+		printf(" %d", ifaces[i]);
+	}
+	printf("\n");
+
+	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	prog_load_attr.file = filename;
+
+	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
+		return 1;
+
+	group_all = bpf_object__find_map_fd_by_name(obj, "forward_map_all");
+	group_v4 = bpf_object__find_map_fd_by_name(obj, "forward_map_v4");
+	group_v6 = bpf_object__find_map_fd_by_name(obj, "forward_map_v6");
+	exclude = bpf_object__find_map_fd_by_name(obj, "exclude_map");
+
+	if (group_all < 0 || group_v4 < 0 || group_v6 < 0 || exclude < 0) {
+		printf("bpf_object__find_map_fd_by_name failed\n");
+		return 1;
+	}
+
+	signal(SIGINT, int_exit);
+	signal(SIGTERM, int_exit);
+
+	/* Init forward multicast groups and exclude group */
+	for (i = 0; ifaces[i] > 0; i++) {
+		ifindex = ifaces[i];
+
+		/* Add all the interfaces to group all */
+		ret = bpf_map_update_elem(group_all, &ifindex, &ifindex, 0);
+		if (ret) {
+			perror("bpf_map_update_elem");
+			goto err_out;
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
+		/* For testing: remove the 1st interfaces from group v6 */
+		if (i != 0) {
+			ret = bpf_map_update_elem(group_v6, &ifindex, &ifindex, 0);
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
+
+	}
+
+	sleep(600);
+	return 0;
+
+err_out:
+	return 1;
+}
-- 
2.19.2

