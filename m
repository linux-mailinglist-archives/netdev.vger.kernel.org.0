Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8BCA233E78
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 06:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbgGaEp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 00:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbgGaEpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 00:45:25 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E47C061574;
        Thu, 30 Jul 2020 21:45:25 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id kr4so4283460pjb.2;
        Thu, 30 Jul 2020 21:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U6Iy5mejGiHq/x5N+bTQ+MH8P/renFqH7MtqkvQz7hg=;
        b=H1brED2wfv4NtiwGieGzk6sAq3yxdHX58SWeS5e5tX+CS+NCUe62Dba1HAAhxsBxXF
         JYQB/OtUJQ+hTlnl40t3r1u/d0E2Z5MgfDBF5j2M4REs/VAhTvPxqpoVaWy2Q1GUuwz3
         9Ov3GzhzOt83x044KBNwV9l8hWmBMFfxVxoKfc/4+tzqn004/y3UMB7tmKfQWpPFS0BJ
         GzV01oyGjfkAZxyrRH+D1sG6Cal/KEJdQmbp7IuW4gACEk7d8cBoEm0VwZE9DV063hml
         um38tK94Uh2x2kJhDIa/mLY4eO+DbqYt+VylyzLTb0WDKo+3tejiF/XbtPRVKA9ZidvL
         RQag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U6Iy5mejGiHq/x5N+bTQ+MH8P/renFqH7MtqkvQz7hg=;
        b=ec6yQG26ns4Ir+8Xy96jYJ/6OJfuZT0pbcT7Osci11h8WyGuxIwbV3KcfvMgSNXJyo
         lYM6LDa+cCHu/comHuL1ZV3G9rfRNDXaAm/t+MXDoLqhbrNe0Q6oDdWEvBzuCUDVgfIx
         JQdt4cTYAZIxEJfR1qcbfhSniBmM/HvLJVg6A0zG1hZg/Sj82aeXJwhTAC0cao4MDZ4Q
         I6iGvv7AIJv2n6lczFaMJ3Q1Soc6aJwuabHAWU2n77je44c6KJPEf0IbNKAwXbOZ5UU3
         AILCKw+/T5sNc15TowFR6Y/PyYBWc4hsE/A2kgPGdZkUW8JGBOvh5Ia8zpGlUiokdHiQ
         0RoQ==
X-Gm-Message-State: AOAM533+MzZFMJHAAoDAY1BzHmO6E2jjCPFK6nlzhkjdeKJQIVsRpC1O
        A8B3bCbX/luAg1zZLnm/Gvs=
X-Google-Smtp-Source: ABdhPJzTkp/ph31pACVINY2T1cr3eR1ZZxZYAxfiRYhy/7iPbKuxyrLMuHunx7Rc7nfrZBWXMck8jg==
X-Received: by 2002:a17:90a:d304:: with SMTP id p4mr2430400pju.153.1596170724396;
        Thu, 30 Jul 2020 21:45:24 -0700 (PDT)
Received: from dali.ht.sfc.keio.ac.jp (dali.ht.sfc.keio.ac.jp. [133.27.170.2])
        by smtp.gmail.com with ESMTPSA id x6sm2329573pfd.53.2020.07.30.21.45.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jul 2020 21:45:23 -0700 (PDT)
From:   Yoshiki Komachi <komachi.yoshiki@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>
Cc:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        bpf@vger.kernel.org
Subject: [RFC PATCH bpf-next 3/3] samples/bpf: Add a simple bridge example accelerated with XDP
Date:   Fri, 31 Jul 2020 13:44:20 +0900
Message-Id: <1596170660-5582-4-git-send-email-komachi.yoshiki@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1596170660-5582-1-git-send-email-komachi.yoshiki@gmail.com>
References: <1596170660-5582-1-git-send-email-komachi.yoshiki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a simple example of XDP-based bridge with the new
bpf_fdb_lookup helper. This program simply forwards packets based
on the destination port given by FDB in the kernel. Note that both
vlan filtering and learning features are currently unsupported in
this example.

There is another plan to recreate a userspace application
(xdp_bridge_user.c) as a daemon process, which helps to automate
not only detection of status changes in bridge port but also
handling vlan protocol updates.

Note: David Ahern suggested a new bpf helper [1] to get master
vlan/bonding devices in XDP programs attached to their slaves
when the master vlan/bonding devices are bridge ports. If this
idea is accepted and the helper is introduced in the future, we
can handle interfaces slaved to vlan/bonding devices in this
sample by calling the suggested bpf helper (I guess it can get
vlan/bonding ifindex from their slave ifindex). Notice that we
don't need to change bpf_fdb_lookup() API to use such a feature,
but we just need to modify bpf programs like this sample.

[1]: http://vger.kernel.org/lpc-networking2018.html#session-1

Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>
---
 samples/bpf/Makefile          |   3 +
 samples/bpf/xdp_bridge_kern.c | 129 ++++++++++++++++++
 samples/bpf/xdp_bridge_user.c | 239 ++++++++++++++++++++++++++++++++++
 3 files changed, 371 insertions(+)
 create mode 100644 samples/bpf/xdp_bridge_kern.c
 create mode 100644 samples/bpf/xdp_bridge_user.c

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index f87ee02073ba..d470368fe8de 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -53,6 +53,7 @@ tprogs-y += task_fd_query
 tprogs-y += xdp_sample_pkts
 tprogs-y += ibumad
 tprogs-y += hbm
+tprogs-y += xdp_bridge
 
 # Libbpf dependencies
 LIBBPF = $(TOOLS_PATH)/lib/bpf/libbpf.a
@@ -109,6 +110,7 @@ task_fd_query-objs := bpf_load.o task_fd_query_user.o $(TRACE_HELPERS)
 xdp_sample_pkts-objs := xdp_sample_pkts_user.o $(TRACE_HELPERS)
 ibumad-objs := bpf_load.o ibumad_user.o $(TRACE_HELPERS)
 hbm-objs := bpf_load.o hbm.o $(CGROUP_HELPERS)
+xdp_bridge-objs := xdp_bridge_user.o
 
 # Tell kbuild to always build the programs
 always-y := $(tprogs-y)
@@ -170,6 +172,7 @@ always-y += ibumad_kern.o
 always-y += hbm_out_kern.o
 always-y += hbm_edt_kern.o
 always-y += xdpsock_kern.o
+always-y += xdp_bridge_kern.o
 
 ifeq ($(ARCH), arm)
 # Strip all except -D__LINUX_ARM_ARCH__ option needed to handle linux
diff --git a/samples/bpf/xdp_bridge_kern.c b/samples/bpf/xdp_bridge_kern.c
new file mode 100644
index 000000000000..00f802503199
--- /dev/null
+++ b/samples/bpf/xdp_bridge_kern.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 NTT Corp. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
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
+#include <linux/if_vlan.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+
+#include <bpf/bpf_helpers.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_DEVMAP_HASH);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+	__uint(max_entries, 64);
+} xdp_tx_ports SEC(".maps");
+
+static __always_inline int xdp_bridge_proto(struct xdp_md *ctx, u16 br_vlan_proto)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	struct bpf_fdb_lookup fdb_lookup_params;
+	struct vlan_hdr *vlan_hdr = NULL;
+	struct ethhdr *eth = data;
+	u16 h_proto;
+	u64 nh_off;
+	int rc;
+
+	nh_off = sizeof(*eth);
+	if (data + nh_off > data_end)
+		return XDP_DROP;
+
+	__builtin_memset(&fdb_lookup_params, 0, sizeof(fdb_lookup_params));
+
+	h_proto = eth->h_proto;
+
+	if (unlikely(ntohs(h_proto) < ETH_P_802_3_MIN))
+		return XDP_PASS;
+
+	/* Handle VLAN tagged packet */
+	if (h_proto == br_vlan_proto) {
+		vlan_hdr = (void *)eth + nh_off;
+		nh_off += sizeof(*vlan_hdr);
+		if ((void *)eth + nh_off > data_end)
+			return XDP_PASS;
+
+		fdb_lookup_params.vlan_id = ntohs(vlan_hdr->h_vlan_TCI) &
+					VLAN_VID_MASK;
+	}
+
+	/* FIXME: Although Linux bridge provides us with vlan filtering (contains
+	 * PVID) at ingress, the feature is currently unsupported in this XDP program.
+	 *
+	 * Two ideas to realize the vlan filtering are below:
+	 *   1. usespace daemon monitors bridge vlan events and notifies XDP programs
+	 *      of them through BPF maps
+	 *   2. introduce another bpf helper to retrieve bridge vlan information
+	 *
+	 *
+	 * FIXME: After the vlan filtering, learning feature is required here, but
+	 * it is currently unsupported as well. If another bpf helper for learning
+	 * is accepted, the processing could be implemented in the future.
+	 */
+
+	memcpy(&fdb_lookup_params.addr, eth->h_dest, ETH_ALEN);
+
+	/* Note: This program definitely takes ifindex of ingress interface as
+	 * a bridge port. Linux networking devices can be stacked and physical
+	 * interfaces are not necessarily slaves of bridges (e.g., bonding or
+	 * vlan devices can be slaves of bridges), but stacked bridge ports are
+	 * currently unsupported in this program. In such cases, XDP programs
+	 * should be attached to a lower device in order to process packets with
+	 * higher speed. Then, a new bpf helper to find upper devices will be
+	 * required here in the future because they will be registered on FDB
+	 * in the kernel.
+	 */
+	fdb_lookup_params.ifindex = ctx->ingress_ifindex;
+
+	rc = bpf_fdb_lookup(ctx, &fdb_lookup_params, sizeof(fdb_lookup_params), 0);
+	if (rc != BPF_FDB_LKUP_RET_SUCCESS) {
+		/* In cases of flooding, XDP_PASS will be returned here */
+		return XDP_PASS;
+	}
+
+	/* FIXME: Although Linux bridge provides us with vlan filtering (contains
+	 * untagged policy) at egress as well, the feature is currently unsupported
+	 * in this XDP program.
+	 *
+	 * Two ideas to realize the vlan filtering are below:
+	 *   1. usespace daemon monitors bridge vlan events and notifies XDP programs
+	 *      of them through BPF maps
+	 *   2. introduce another bpf helper to retrieve bridge vlan information
+	 */
+
+	return bpf_redirect_map(&xdp_tx_ports, fdb_lookup_params.ifindex, XDP_PASS);
+}
+
+SEC("xdp_bridge")
+int xdp_bridge_prog(struct xdp_md *ctx)
+{
+	return xdp_bridge_proto(ctx, 0);
+}
+
+SEC("xdp_8021q_bridge")
+int xdp_8021q_bridge_prog(struct xdp_md *ctx)
+{
+	return xdp_bridge_proto(ctx, htons(ETH_P_8021Q));
+}
+
+SEC("xdp_8021ad_bridge")
+int xdp_8021ad_bridge_prog(struct xdp_md *ctx)
+{
+	return xdp_bridge_proto(ctx, htons(ETH_P_8021AD));
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/samples/bpf/xdp_bridge_user.c b/samples/bpf/xdp_bridge_user.c
new file mode 100644
index 000000000000..6ed0a2ece6f4
--- /dev/null
+++ b/samples/bpf/xdp_bridge_user.c
@@ -0,0 +1,239 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 NTT Corp. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/bpf.h>
+#include <linux/if_link.h>
+#include <linux/limits.h>
+#include <net/if.h>
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <libgen.h>
+
+#include <bpf/libbpf.h>
+#include <bpf/bpf.h>
+
+#define STRERR_BUFSIZE  128
+
+static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
+
+static int do_attach(int idx, int prog_fd, int map_fd, const char *name)
+{
+	int err;
+
+	err = bpf_set_link_xdp_fd(idx, prog_fd, xdp_flags);
+	if (err < 0) {
+		printf("ERROR: failed to attach program to %s\n", name);
+		return err;
+	}
+
+	/* Adding ifindex as a possible egress TX port */
+	err = bpf_map_update_elem(map_fd, &idx, &idx, 0);
+	if (err)
+		printf("ERROR: failed using device %s as TX-port\n", name);
+
+	return err;
+}
+
+static int do_detach(int idx, const char *name)
+{
+	int err;
+
+	err = bpf_set_link_xdp_fd(idx, -1, xdp_flags);
+	if (err < 0)
+		printf("ERROR: failed to detach program from %s\n", name);
+
+	/* FIXME: Need to delete the corresponding entry in shared devmap
+	 * with bpf_map_delete_elem((map_fd, &idx);
+	 */
+	return err;
+}
+
+static int do_reuse_map(struct bpf_map *map, char *pin_path, bool *pinned)
+{
+	const char *path = "/sys/fs/bpf/xdp_bridge";
+	char errmsg[STRERR_BUFSIZE];
+	int err, len, pin_fd;
+
+	len = snprintf(pin_path, PATH_MAX, "%s/%s", path, bpf_map__name(map));
+	if (len < 0)
+		return -EINVAL;
+	else if (len >= PATH_MAX)
+		return -ENAMETOOLONG;
+
+	pin_fd = bpf_obj_get(pin_path);
+	if (pin_fd < 0) {
+		err = -errno;
+		if (err == -ENOENT) {
+			*pinned = false;
+			return 0;
+		}
+
+		libbpf_strerror(-err, errmsg, sizeof(errmsg));
+		printf("couldn't retrieve pinned map: %s\n", errmsg);
+		return err;
+	}
+
+	err = bpf_map__reuse_fd(map, pin_fd);
+	if (err) {
+		printf("failed to reuse map: %s\n", strerror(errno));
+		close(pin_fd);
+	}
+
+	return err;
+}
+
+static void usage(const char *prog)
+{
+	fprintf(stderr,
+		"usage: %s [OPTS] interface-list\n"
+		"\nOPTS:\n"
+		"    -Q    enable vlan filtering (802.1Q)\n"
+		"    -A    enable vlan filtering (802.1ad)\n"
+		"    -d    detach program\n",
+		prog);
+}
+
+int main(int argc, char **argv)
+{
+	struct bpf_object_open_attr attr = {
+		.prog_type = BPF_PROG_TYPE_XDP,
+	};
+	char filename[PATH_MAX], pin_path[PATH_MAX];
+	const char *prog_name = "xdp_bridge";
+	int prog_fd = -1, map_fd = -1;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	int opt, i, idx, err;
+	struct bpf_map *map;
+	bool pinned = true;
+	int attach = 1;
+	int ret = 0;
+
+	while ((opt = getopt(argc, argv, ":dQASF")) != -1) {
+		switch (opt) {
+		case 'd':
+			attach = 0;
+			break;
+		case 'S':
+			xdp_flags |= XDP_FLAGS_SKB_MODE;
+			break;
+		case 'F':
+			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
+			break;
+		case 'Q':
+			prog_name = "xdp_8021q_bridge";
+			break;
+		case 'A':
+			prog_name = "xdp_8021ad_bridge";
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
+		usage(basename(argv[0]));
+		return 1;
+	}
+
+	if (attach) {
+		snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+		attr.file = filename;
+
+		if (access(filename, O_RDONLY) < 0) {
+			printf("error accessing file %s: %s\n",
+				filename, strerror(errno));
+			return 1;
+		}
+
+		obj = bpf_object__open_xattr(&attr);
+		if (libbpf_get_error(obj)) {
+			printf("cannot open xdp program: %s\n", strerror(errno));
+			return 1;
+		}
+
+		map = bpf_object__find_map_by_name(obj, "xdp_tx_ports");
+		if (libbpf_get_error(map)) {
+			printf("map not found: %s\n", strerror(errno));
+			goto err;
+		}
+
+		err = do_reuse_map(map, pin_path, &pinned);
+		if (err) {
+			printf("error reusing map %s: %s\n",
+				bpf_map__name(map), strerror(errno));
+			goto err;
+		}
+
+		err = bpf_object__load(obj);
+		if (err) {
+			printf("cannot load xdp program: %s\n", strerror(errno));
+			goto err;
+		}
+
+		prog = bpf_object__find_program_by_title(obj, prog_name);
+		prog_fd = bpf_program__fd(prog);
+		if (prog_fd < 0) {
+			printf("program not found: %s\n", strerror(prog_fd));
+			goto err;
+		}
+
+		map_fd = bpf_map__fd(map);
+		if (map_fd < 0) {
+			printf("map not found: %s\n", strerror(map_fd));
+			goto err;
+		}
+
+		if (!pinned) {
+			err = bpf_map__pin(map, pin_path);
+			if (err) {
+				printf("failed to pin map: %s\n", strerror(errno));
+				goto err;
+			}
+		}
+	}
+
+	for (i = optind; i < argc; ++i) {
+		idx = if_nametoindex(argv[i]);
+		if (!idx)
+			idx = strtoul(argv[i], NULL, 0);
+
+		if (!idx) {
+			fprintf(stderr, "Invalid arg\n");
+			return 1;
+		}
+		if (attach) {
+			err = do_attach(idx, prog_fd, map_fd, argv[i]);
+			if (err)
+				ret = err;
+		} else {
+			err = do_detach(idx, argv[i]);
+			if (err)
+				ret = err;
+		}
+	}
+
+	return ret;
+err:
+    bpf_object__close(obj);
+    return 1;
+}
-- 
2.20.1 (Apple Git-117)

