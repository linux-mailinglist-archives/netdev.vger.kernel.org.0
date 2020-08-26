Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3209252F8C
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 15:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730253AbgHZNUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 09:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730248AbgHZNUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 09:20:32 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83F8C061574;
        Wed, 26 Aug 2020 06:20:32 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id w186so1013074pgb.8;
        Wed, 26 Aug 2020 06:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uhBqgyl2R4ybVhAEljTLnh8gFHPl7M0Dc/ZnWPWBd14=;
        b=KAR4IBKBC6HqfcdozsZw0TclW67y3+Dmm+TX6QasG3ZeA4jaq8LpvYQh8aT67jlAa8
         6a/dEXqGPSAKl25Rja+JaBTDH8zian8RAVoucYRq4eXMKAqLpphgRTPkAlI4yF89DZCK
         K5ptPbBTUuXACD+a060MkneK0IY3+CllPE0wpKAFu15A+W9j7PVXhZDb4pbxzinHxOsG
         yYDWUlnw+0/raTOYxk6RBp8t/ZgP02pS2SMMIZ5tRdgj9rlVb7cScoGVhHdjs4jgx0cX
         Dy5ux6Lr2y2TPKn4Y14nOkHa3hy+v2h/QwM6ZUXxgotKLaSFT46N+vONjTkdFLr1t/NT
         4l1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uhBqgyl2R4ybVhAEljTLnh8gFHPl7M0Dc/ZnWPWBd14=;
        b=flRdL5iJhTmveuR0naU48o0o2fUCaxIKvmp6T49xc3dBJzdCdHx3cdeTa9+PBhE95/
         p4yVGZ/CYirQjft4CIhabUkquD2ZgZ4ltO3Lrgcu3h2tWXUb330P4UX20cFxfO56cmUy
         wfsisEmftc+QIIs+1DuNVZdAKEOxTgjWiCaD3RBRo2XK9qJXIk1SUoNnH9MlliFZn2j7
         a687MtB3HvP3Yv/D55UlFUrfTPKLTYZFDpMCSy1OPem6JKSpLcb3Obv7SZzT7W/h7Yxa
         B4iJdDgSi1kY2KxucBDlaJQrIOjnWQbwwJyyl6D+XqEd7F2og/f7h6sw9YNjhRhQrH8T
         07Sg==
X-Gm-Message-State: AOAM530ZtS4nN06phI2VLKIEiI3v/sIlOPkpV/nre8ObgrQayphHT6Sm
        DjpRlC4iENWeWNYYNI36nwB5UR3GpEERJ1Xu
X-Google-Smtp-Source: ABdhPJzfyuxYnm/GdhSBgrXuFL4bimXcfyJRXat3yjxl1DULJxaYCOKxg5V+QVHh2nVN0Iwhs/AK2Q==
X-Received: by 2002:aa7:83cf:: with SMTP id j15mr11991940pfn.251.1598448030541;
        Wed, 26 Aug 2020 06:20:30 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s129sm3131794pfb.39.2020.08.26.06.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 06:20:30 -0700 (PDT)
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
        Andrii Nakryiko B <andrii.nakryiko@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv9 bpf-next 3/5] sample/bpf: add xdp_redirect_map_multicast test
Date:   Wed, 26 Aug 2020 21:20:00 +0800
Message-Id: <20200826132002.2808380-4-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200826132002.2808380-1-liuhangbin@gmail.com>
References: <20200715130816.2124232-1-liuhangbin@gmail.com>
 <20200826132002.2808380-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a sample for xdp multicast. In the sample we could forward all
packets between given interfaces.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---

v9: use NULL directly for arg2 and redefine the maps with btf format
v6-v8: no update
v5: add a null_map as we have strict the arg2 to ARG_CONST_MAP_PTR.
    Move the testing part to bpf selftest in next patch.
v4: no update.
v3: add rxcnt map to show the packet transmit speed.
v2: no update.

---
 samples/bpf/Makefile                      |   3 +
 samples/bpf/xdp_redirect_map_multi_kern.c |  43 ++++++
 samples/bpf/xdp_redirect_map_multi_user.c | 166 ++++++++++++++++++++++
 3 files changed, 212 insertions(+)
 create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
 create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index a6d3646b3818..177cab805768 100644
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
@@ -97,6 +98,7 @@ test_map_in_map-objs := test_map_in_map_user.o
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
diff --git a/samples/bpf/xdp_redirect_map_multi_kern.c b/samples/bpf/xdp_redirect_map_multi_kern.c
new file mode 100644
index 000000000000..db58d56cef89
--- /dev/null
+++ b/samples/bpf/xdp_redirect_map_multi_kern.c
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
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
+#include <bpf/bpf_helpers.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_DEVMAP_HASH);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+	__uint(max_entries, 256);
+} forward_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, long);
+	__uint(max_entries, 1);
+} rxcnt SEC(".maps");
+
+SEC("xdp_redirect_map_multi")
+int xdp_redirect_map_multi_prog(struct xdp_md *ctx)
+{
+	long *value;
+	u32 key = 0;
+
+	/* count packet in global counter */
+	value = bpf_map_lookup_elem(&rxcnt, &key);
+	if (value)
+		*value += 1;
+
+	return bpf_redirect_map_multi(&forward_map, NULL, BPF_F_EXCLUDE_INGRESS);
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/samples/bpf/xdp_redirect_map_multi_user.c b/samples/bpf/xdp_redirect_map_multi_user.c
new file mode 100644
index 000000000000..49f44c91b672
--- /dev/null
+++ b/samples/bpf/xdp_redirect_map_multi_user.c
@@ -0,0 +1,166 @@
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
+
+#include "bpf_util.h"
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#define MAX_IFACE_NUM 32
+
+static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
+static int ifaces[MAX_IFACE_NUM] = {};
+static int rxcnt;
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
+static void poll_stats(int interval)
+{
+	unsigned int nr_cpus = bpf_num_possible_cpus();
+	__u64 values[nr_cpus], prev[nr_cpus];
+
+	memset(prev, 0, sizeof(prev));
+
+	while (1) {
+		__u64 sum = 0;
+		__u32 key = 0;
+		int i;
+
+		sleep(interval);
+		assert(bpf_map_lookup_elem(rxcnt, &key, values) == 0);
+		for (i = 0; i < nr_cpus; i++)
+			sum += (values[i] - prev[i]);
+		if (sum)
+			printf("Forwarding %10llu pkt/s\n", sum / interval);
+		memcpy(prev, values, sizeof(values));
+	}
+}
+
+static void usage(const char *prog)
+{
+	fprintf(stderr,
+		"usage: %s [OPTS] <IFNAME|IFINDEX> <IFNAME|IFINDEX> ...\n"
+		"OPTS:\n"
+		"    -S    use skb-mode\n"
+		"    -N    enforce native mode\n"
+		"    -F    force loading prog\n",
+		prog);
+}
+
+int main(int argc, char **argv)
+{
+	struct bpf_prog_load_attr prog_load_attr = {
+		.prog_type      = BPF_PROG_TYPE_XDP,
+	};
+	int prog_fd, forward_map;
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
+	for (i = 0; i < MAX_IFACE_NUM && argv[optind + i]; i++) {
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
+	forward_map = bpf_object__find_map_fd_by_name(obj, "forward_map");
+	rxcnt = bpf_object__find_map_fd_by_name(obj, "rxcnt");
+
+	if (forward_map < 0 || rxcnt < 0) {
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
+		ret = bpf_map_update_elem(forward_map, &ifindex, &ifindex, 0);
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
+
+	}
+
+	poll_stats(2);
+
+	return 0;
+
+err_out:
+	return 1;
+}
-- 
2.25.4

