Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B342FBB77
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391689AbhASPmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390660AbhASPhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 10:37:33 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BBAC0613ED;
        Tue, 19 Jan 2021 07:37:16 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id o13so29680110lfr.3;
        Tue, 19 Jan 2021 07:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/A8qSxg6mjQyW3rVEfH/72JcIK5m3UMA6EDeCF6zH2o=;
        b=a9+sJbO58jlhdcDYj/6WhFSwdgMZw3d1bu4Z5IOzn7x+hxlcTdKtkTshuYr4YR0sQB
         Y0bO9g8Ju88kT2ChMvkYC8SKrAFbmzFeN73cGFCM8S9Mt1GN8SIgQhxC0dATQ8wu1J5m
         Y2GhAc04bjp+Rb0Trlir4Jwr/bIbyPZHNlux7eze2zyehBJvX4bFk40zN7fgJYL/+cZh
         mQ45OS9rTQzQEwfeZbesVdMb4gPGn/K/yj1ojbJRF/26YtCFIg6biSFkP3/BTNHi4GlR
         kjiPy+WNl9Li95YlKL+mYmolOyvoJfo9yeP9QoWjRyUTfL6zjliVeIYKqU0WJzHFmh+T
         +J/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/A8qSxg6mjQyW3rVEfH/72JcIK5m3UMA6EDeCF6zH2o=;
        b=VRYszSGojOhGmJIKuJBmy/kJbYNKjXj8rmkKZnIkC99G1X8uqjud3L0JcAyNTAJt5r
         KqGtUXrGQr37qXvMiu/2s9/5nBGEZTy/O02+Ei5+aEPZ3g8uNhjx6JhwqkSLCcMjt2X9
         4p5cz/09D36xDgow+dKRf6ANOMjb4TG6J1XR5wGOnSCykrYk/LB5ctDzFcAze2VFuCp6
         AQluG5dRBx15KKf6jnxY3/tWU5fBQYGgqKVypWnCkWScbocja/55lM0rjcUiHEwFpy6l
         BKxis82L0pQLEPBNN3kPI01vE1mbujNi/CMeU9yIiW3XoX8aRit/dYzioSz1d6QjKBrf
         s4bA==
X-Gm-Message-State: AOAM530anAlU4pN4a/FhuVNjKnquCxRLez6qs+95W7jgFuh7Q/xZuWB+
        Or/jf/X8ODUgYPmuHUxzd/E=
X-Google-Smtp-Source: ABdhPJwM+lS45bj5hNo9KN/pO4S49aGEz+iBRNP0Bm74IFSe1KWkkw9ryeD4y3ySS+UCcJQJT4KazA==
X-Received: by 2002:a19:6d0b:: with SMTP id i11mr1599898lfc.332.1611070635075;
        Tue, 19 Jan 2021 07:37:15 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id z2sm2309075lfd.142.2021.01.19.07.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 07:37:14 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com,
        Marek Majtyka <alardam@gmail.com>
Subject: [PATCH bpf-next 5/8] libbpf, xsk: select AF_XDP BPF program based on kernel version
Date:   Tue, 19 Jan 2021 16:36:52 +0100
Message-Id: <20210119153655.153999-6-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210119153655.153999-1-bjorn.topel@gmail.com>
References: <20210119153655.153999-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Add detection for kernel version, and adapt the BPF program based on
kernel support. This way, users will get the best possible performance
from the BPF program.

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Marek Majtyka  <alardam@gmail.com>
---
 tools/lib/bpf/libbpf.c          |  2 +-
 tools/lib/bpf/libbpf_internal.h |  2 ++
 tools/lib/bpf/libbpf_probes.c   | 16 -------------
 tools/lib/bpf/xsk.c             | 41 ++++++++++++++++++++++++++++++---
 4 files changed, 41 insertions(+), 20 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 2abbc3800568..6a53adf14a9c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -693,7 +693,7 @@ bpf_object__add_programs(struct bpf_object *obj, Elf_Data *sec_data,
 	return 0;
 }
 
-static __u32 get_kernel_version(void)
+__u32 get_kernel_version(void)
 {
 	__u32 major, minor, patch;
 	struct utsname info;
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 969d0ac592ba..dafb780e2dd2 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -349,4 +349,6 @@ struct bpf_core_relo {
 	enum bpf_core_relo_kind kind;
 };
 
+__u32 get_kernel_version(void);
+
 #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index ecaae2927ab8..aae0231371d0 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -48,22 +48,6 @@ static int get_vendor_id(int ifindex)
 	return strtol(buf, NULL, 0);
 }
 
-static int get_kernel_version(void)
-{
-	int version, subversion, patchlevel;
-	struct utsname utsn;
-
-	/* Return 0 on failure, and attempt to probe with empty kversion */
-	if (uname(&utsn))
-		return 0;
-
-	if (sscanf(utsn.release, "%d.%d.%d",
-		   &version, &subversion, &patchlevel) != 3)
-		return 0;
-
-	return (version << 16) + (subversion << 8) + patchlevel;
-}
-
 static void
 probe_load(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
 	   size_t insns_cnt, char *buf, size_t buf_len, __u32 ifindex)
diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index e3e41ceeb1bc..c8642c6cb5d6 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -23,6 +23,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/sockios.h>
+#include <linux/version.h>
 #include <net/if.h>
 #include <sys/ioctl.h>
 #include <sys/mman.h>
@@ -46,6 +47,11 @@
  #define PF_XDP AF_XDP
 #endif
 
+enum xsk_prog {
+	XSK_PROG_FALLBACK,
+	XSK_PROG_REDIRECT_FLAGS,
+};
+
 struct xsk_umem {
 	struct xsk_ring_prod *fill_save;
 	struct xsk_ring_cons *comp_save;
@@ -351,6 +357,13 @@ int xsk_umem__create_v0_0_2(struct xsk_umem **umem_ptr, void *umem_area,
 COMPAT_VERSION(xsk_umem__create_v0_0_2, xsk_umem__create, LIBBPF_0.0.2)
 DEFAULT_VERSION(xsk_umem__create_v0_0_4, xsk_umem__create, LIBBPF_0.0.4)
 
+static enum xsk_prog get_xsk_prog(void)
+{
+	__u32 kver = get_kernel_version();
+
+	return kver < KERNEL_VERSION(5, 3, 0) ? XSK_PROG_FALLBACK : XSK_PROG_REDIRECT_FLAGS;
+}
+
 static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 {
 	static const int log_buf_size = 16 * 1024;
@@ -358,7 +371,7 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 	char log_buf[log_buf_size];
 	int err, prog_fd;
 
-	/* This is the C-program:
+	/* This is the fallback C-program:
 	 * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
 	 * {
 	 *     int ret, index = ctx->rx_queue_index;
@@ -414,9 +427,31 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 		/* The jumps are to this instruction */
 		BPF_EXIT_INSN(),
 	};
-	size_t insns_cnt = sizeof(prog) / sizeof(struct bpf_insn);
 
-	prog_fd = bpf_load_program(BPF_PROG_TYPE_XDP, prog, insns_cnt,
+	/* This is the post-5.3 kernel C-program:
+	 * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
+	 * {
+	 *     return bpf_redirect_map(&xsks_map, ctx->rx_queue_index, XDP_PASS);
+	 * }
+	 */
+	struct bpf_insn prog_redirect_flags[] = {
+		/* r2 = *(u32 *)(r1 + 16) */
+		BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 16),
+		/* r1 = xskmap[] */
+		BPF_LD_MAP_FD(BPF_REG_1, ctx->xsks_map_fd),
+		/* r3 = XDP_PASS */
+		BPF_MOV64_IMM(BPF_REG_3, 2),
+		/* call bpf_redirect_map */
+		BPF_EMIT_CALL(BPF_FUNC_redirect_map),
+		BPF_EXIT_INSN(),
+	};
+	size_t insns_cnt[] = {sizeof(prog) / sizeof(struct bpf_insn),
+			      sizeof(prog_redirect_flags) / sizeof(struct bpf_insn),
+	};
+	struct bpf_insn *progs[] = {prog, prog_redirect_flags};
+	enum xsk_prog option = get_xsk_prog();
+
+	prog_fd = bpf_load_program(BPF_PROG_TYPE_XDP, progs[option], insns_cnt[option],
 				   "LGPL-2.1 or BSD-2-Clause", 0, log_buf,
 				   log_buf_size);
 	if (prog_fd < 0) {
-- 
2.27.0

