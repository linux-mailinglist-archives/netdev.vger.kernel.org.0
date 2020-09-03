Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B3925BF13
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 12:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgICK2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 06:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbgICK1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 06:27:42 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358F3C061244;
        Thu,  3 Sep 2020 03:27:42 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id n3so3540237pjq.1;
        Thu, 03 Sep 2020 03:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hjsKn7TZY1QAKQsoU4IyoAsbbOIFOcj2yQmJLQure8o=;
        b=e/biNCIlFDfcfbCSCCf6wO1WR/aC3mIU5Mq67PH/HDabhDOlRmn0Dj7u7XcspmXCvR
         JzYsY4O2IZ3y1U2vdx7oEyA/HsjstGKj6+UtbvBSGYaQqTgRgBBqYzBRirg3E1PNO6Ry
         UkPMZbrFe0Rj31QQcCIZFpWIE3LS7+knvyepjZLmyj7P6T/7SHRzc9hxb3DYCSgyt1Hl
         aoocMGICRqFaFHtmF467gtdg4GHiJ52li4AgoMrcuMHC+td/ka7slTXNzing6WtmLwPH
         gzCFrLHsf+Qu6ps92/OZEjbRzT0kL6tHd3yqC85xYT60nS4qXR8ex7sPYjqgkJ7cDt5o
         0nKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hjsKn7TZY1QAKQsoU4IyoAsbbOIFOcj2yQmJLQure8o=;
        b=Vac9nnDKNKvfDed2tqnp4/UEp1+zBk1gugZ3RXQpZL3B9M8hOsguQx1IHnkiarVio5
         Pro1CkeFJ9D7m+g5lns30eH+MYTjNmi095CbSzKr+HSGphKdqA8Ko3CSwAuyIQZaK9Aj
         0W1yk8eucKQP/0VDWCApJN9PizOID4kVsBHE7VYj7z3h+3+of6JZENqoDA7cWZP6kftN
         71LNFfLTSZg/0G7CHDAtaepbV/xK8INO6BbOTrwMrIBdCVk8G+MxCaJRkUe2qU7spvOE
         CaMFZpQDEPti+gn99vCJk6rWsNW/CSEyYaoJW6uWGoZkesqErdJne9kkTc1rApUvyOCb
         ZDcw==
X-Gm-Message-State: AOAM530JhzxfWnCRJLd8LYA5pbHEkWWA95WsuN92QEAhVumYsI2pjLUN
        Tg2LNwNKyFU+rqRfSbdNf4cVTkutFOm8B9+k
X-Google-Smtp-Source: ABdhPJySj2I4SPKVjg+erX12tZnpPkMFomLTsKR0+5Pzj7k1Xq5sBrhcDAJzqHaYYW9Rf9Rwt7/LXQ==
X-Received: by 2002:a17:90a:644b:: with SMTP id y11mr2725736pjm.13.1599128861395;
        Thu, 03 Sep 2020 03:27:41 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x3sm2131929pgg.54.2020.09.03.03.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 03:27:40 -0700 (PDT)
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
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv10 bpf-next 3/5] sample/bpf: add xdp_redirect_map_multicast test
Date:   Thu,  3 Sep 2020 18:26:59 +0800
Message-Id: <20200903102701.3913258-4-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200903102701.3913258-1-liuhangbin@gmail.com>
References: <20200826132002.2808380-1-liuhangbin@gmail.com>
 <20200903102701.3913258-1-liuhangbin@gmail.com>
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

v10: no update
v9: use NULL directly for arg2 and redefine the maps with btf format
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
index 4f1ed0e3cf9f..cad63d4ea164 100644
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
@@ -98,6 +99,7 @@ test_map_in_map-objs := test_map_in_map_user.o
 per_socket_stats_example-objs := cookie_uid_helper_example.o
 xdp_redirect-objs := xdp_redirect_user.o
 xdp_redirect_map-objs := xdp_redirect_map_user.o
+xdp_redirect_map_multi-objs := xdp_redirect_map_multi_user.o
 xdp_redirect_cpu-objs := bpf_load.o xdp_redirect_cpu_user.o
 xdp_monitor-objs := bpf_load.o xdp_monitor_user.o
 xdp_rxq_info-objs := xdp_rxq_info_user.o
@@ -158,6 +160,7 @@ always-y += tcp_tos_reflect_kern.o
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

