Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C363F37B1
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 02:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241189AbhHUAWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 20:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241158AbhHUAV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 20:21:57 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6874C061760;
        Fri, 20 Aug 2021 17:21:18 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id t13so10011932pfl.6;
        Fri, 20 Aug 2021 17:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NPcMoXx35C77Fl0I9mg8X174MgdnhBjWkDgZIiJ5TkI=;
        b=eM/wDbQMQPqwW4UMJw2DU2z4yZAO4oXRmHpI1gGFxS/xwZ9WSG79FulNMEqCHxG0+A
         yjzcfUuk8BdKGY4NvKoPoYZD3C9I+3dDHRa4mQ9rYAepFp3XiOfgZYGVLfx8J3e89SCA
         Vz9IMt7UuzgBHPd9sYUGpzabi7qx/hIVNfreX6ePZhXzusHa+cK+8Pn+/Luhv9yKM9Lb
         1WdwR6rzG5OKF/pOqN6Sv6+KWqqFphwfeeCmPfyt5wDFZt7Bzd+KSS59eS8Iyv45XBZb
         +8d3OWL5rHhvxjdvPx2MxkghvfphRZCq3GjuH+KKh2dk3NpoNYx1047kb33W4xwNjUGn
         gQcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NPcMoXx35C77Fl0I9mg8X174MgdnhBjWkDgZIiJ5TkI=;
        b=lsmXYtyri52Rnw3mjdnkzyZKS0iL1MzZT+9L9NYQ2AgotIMvyDxHEoDuKttAhDOijg
         TUsbBVQCOm1wKobNtaS6B6/mJjHhICrCUvV5C+4UF6q86PLU6wK+L/oQ3plObxBCgb5s
         93ghfw3X+0ZpFHRiwfkQ7JhWjyJzWBd1hG+VBZjle/xPZnoJoiOWZMKrFxUWUvKX+xro
         PNDHhB6TAFGOs9BbJYq4k5iEIjLxkjLnMCvtWf7mj2yOt5HokmB5HFCK+eUISQYsX/Mp
         oAtPo04SbtBg7fawNVSno6dUot0ShgrLRLStrsmBwY7wqfsF3cKnw5VRhOMihCNgnBmF
         /9lg==
X-Gm-Message-State: AOAM531Vc6XNqhNEmXwAXfgbQyv+Q+5jB7RfT8qdY231lBQmEeqcpR9B
        ket9ATPGTdXn69QIAR5B92dduY8tO4c=
X-Google-Smtp-Source: ABdhPJy5Bufb3Z/e/Li2RiwnwHxyAJayyiRP9ypjZ1ZWu+qV94z8xXD+MOWkHjG9EkcrxUsu+DWiaw==
X-Received: by 2002:a63:2fc3:: with SMTP id v186mr20900864pgv.358.1629505278312;
        Fri, 20 Aug 2021 17:21:18 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id a2sm9554398pgb.19.2021.08.20.17.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 17:21:18 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 21/22] samples: bpf: Convert xdp_redirect_map_multi_kern.o to XDP samples helper
Date:   Sat, 21 Aug 2021 05:50:09 +0530
Message-Id: <20210821002010.845777-22-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210821002010.845777-1-memxor@gmail.com>
References: <20210821002010.845777-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One of the notable changes is using a BPF_MAP_TYPE_HASH instead of array
map to store mac addresses of devices, as the resizing behavior was
based on max_ifindex, which unecessarily maximized the capacity of map
beyond what was needed.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/Makefile                          |  7 +--
 ...ti_kern.c => xdp_redirect_map_multi.bpf.c} | 50 ++++++++-----------
 2 files changed, 26 insertions(+), 31 deletions(-)
 rename samples/bpf/{xdp_redirect_map_multi_kern.c => xdp_redirect_map_multi.bpf.c} (64%)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 6decc8f9bcc2..2b3d9e39c4f3 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -163,7 +163,6 @@ always-y += tcp_clamp_kern.o
 always-y += tcp_basertt_kern.o
 always-y += tcp_tos_reflect_kern.o
 always-y += tcp_dumpstats_kern.o
-always-y += xdp_redirect_map_multi_kern.o
 always-y += xdp_rxq_info_kern.o
 always-y += xdp2skb_meta_kern.o
 always-y += syscall_tp_kern.o
@@ -357,6 +356,7 @@ endef
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
 
 $(obj)/xdp_redirect_cpu.bpf.o: $(obj)/xdp_sample.bpf.o
+$(obj)/xdp_redirect_map_multi.bpf.o: $(obj)/xdp_sample.bpf.o
 $(obj)/xdp_redirect_map.bpf.o: $(obj)/xdp_sample.bpf.o
 $(obj)/xdp_redirect.bpf.o: $(obj)/xdp_sample.bpf.o
 $(obj)/xdp_monitor.bpf.o: $(obj)/xdp_sample.bpf.o
@@ -369,11 +369,12 @@ $(obj)/%.bpf.o: $(src)/%.bpf.c $(obj)/vmlinux.h $(src)/xdp_sample.bpf.h $(src)/x
 		-I$(srctree)/tools/lib $(CLANG_SYS_INCLUDES) \
 		-c $(filter %.bpf.c,$^) -o $@
 
-LINKED_SKELS := xdp_redirect_cpu.skel.h xdp_redirect_map.skel.h \
-		 xdp_redirect.skel.h xdp_monitor.skel.h
+LINKED_SKELS := xdp_redirect_cpu.skel.h xdp_redirect_map_multi.skel.h \
+		xdp_redirect_map.skel.h xdp_redirect.skel.h xdp_monitor.skel.h
 clean-files += $(LINKED_SKELS)
 
 xdp_redirect_cpu.skel.h-deps := xdp_redirect_cpu.bpf.o xdp_sample.bpf.o
+xdp_redirect_map_multi.skel.h-deps := xdp_redirect_map_multi.bpf.o xdp_sample.bpf.o
 xdp_redirect_map.skel.h-deps := xdp_redirect_map.bpf.o xdp_sample.bpf.o
 xdp_redirect.skel.h-deps := xdp_redirect.bpf.o xdp_sample.bpf.o
 xdp_monitor.skel.h-deps := xdp_monitor.bpf.o xdp_sample.bpf.o
diff --git a/samples/bpf/xdp_redirect_map_multi_kern.c b/samples/bpf/xdp_redirect_map_multi.bpf.c
similarity index 64%
rename from samples/bpf/xdp_redirect_map_multi_kern.c
rename to samples/bpf/xdp_redirect_map_multi.bpf.c
index 71aa23d1cb2b..8f59d430cb64 100644
--- a/samples/bpf/xdp_redirect_map_multi_kern.c
+++ b/samples/bpf/xdp_redirect_map_multi.bpf.c
@@ -1,11 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0
 #define KBUILD_MODNAME "foo"
-#include <uapi/linux/bpf.h>
-#include <linux/in.h>
-#include <linux/if_ether.h>
-#include <linux/ip.h>
-#include <linux/ipv6.h>
-#include <bpf/bpf_helpers.h>
+
+#include "vmlinux.h"
+#include "xdp_sample.bpf.h"
+#include "xdp_sample_shared.h"
+
+enum {
+	BPF_F_BROADCAST		= (1ULL << 3),
+	BPF_F_EXCLUDE_INGRESS	= (1ULL << 4),
+};
 
 struct {
 	__uint(type, BPF_MAP_TYPE_DEVMAP_HASH);
@@ -21,50 +24,41 @@ struct {
 	__uint(max_entries, 32);
 } forward_map_native SEC(".maps");
 
+/* map to store egress interfaces mac addresses */
 struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, long);
-	__uint(max_entries, 1);
-} rxcnt SEC(".maps");
-
-/* map to store egress interfaces mac addresses, set the
- * max_entries to 1 and extend it in user sapce prog.
- */
-struct {
-	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(type, BPF_MAP_TYPE_HASH);
 	__type(key, u32);
 	__type(value, __be64);
-	__uint(max_entries, 1);
+	__uint(max_entries, 32);
 } mac_map SEC(".maps");
 
 static int xdp_redirect_map(struct xdp_md *ctx, void *forward_map)
 {
-	long *value;
-	u32 key = 0;
+	u32 key = bpf_get_smp_processor_id();
+	struct datarec *rec;
 
-	/* count packet in global counter */
-	value = bpf_map_lookup_elem(&rxcnt, &key);
-	if (value)
-		*value += 1;
+	rec = bpf_map_lookup_elem(&rx_cnt, &key);
+	if (!rec)
+		return XDP_PASS;
+	NO_TEAR_INC(rec->processed);
 
-	return bpf_redirect_map(forward_map, key,
+	return bpf_redirect_map(forward_map, 0,
 				BPF_F_BROADCAST | BPF_F_EXCLUDE_INGRESS);
 }
 
-SEC("xdp_redirect_general")
+SEC("xdp")
 int xdp_redirect_map_general(struct xdp_md *ctx)
 {
 	return xdp_redirect_map(ctx, &forward_map_general);
 }
 
-SEC("xdp_redirect_native")
+SEC("xdp")
 int xdp_redirect_map_native(struct xdp_md *ctx)
 {
 	return xdp_redirect_map(ctx, &forward_map_native);
 }
 
-SEC("xdp_devmap/map_prog")
+SEC("xdp_devmap/egress")
 int xdp_devmap_prog(struct xdp_md *ctx)
 {
 	void *data_end = (void *)(long)ctx->data_end;
-- 
2.33.0

