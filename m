Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15694300238
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 12:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbhAVL6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 06:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727724AbhAVK5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 05:57:02 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC015C061793;
        Fri, 22 Jan 2021 02:54:02 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id o13so6945158lfr.3;
        Fri, 22 Jan 2021 02:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Dvl6nZooWLAwBGhT8ta9ggmv3K+yrSjtoMwqodirQJ0=;
        b=R9HzGvvZESvsn6JfbBWvjmTH623bem2hYyB388ERMFw2gFjbra2GUSd8BH3qyBabN0
         eW9FN2qfEFE7tZzkAf5nIiHWVkodYErn2MGlg2GcF0WSw2i/ZrDfMtMy0r4l3HjzJTE8
         McxLWxHtTwKKNXuH/z6/Lb5ElXul5qmB/wg1ndHPCca0NFI9+FByJWBXRzx8V/dpkgt2
         0v3A3pVrFNjn4q8TaiU9LAsbShqBH0t+Y/udGHVdsMYMut/vsO/m57Dcrm7F+SHJROS3
         KSvEOz5THWgfFTI1rDnVi12F6thF9mKBgIcD2tvWmNKCrjT5sQxK8dyBCOjgeg0/myiK
         n0iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dvl6nZooWLAwBGhT8ta9ggmv3K+yrSjtoMwqodirQJ0=;
        b=X7R8Q6GLuWwPtH6pHucRseDHyoTeECCnXkQxnWK7csOrrvhGOtwWrXdxoMKz6uFfxa
         ugFD8izWflx9Tsg4y8ZdnqaZJgzobYRUIMjhpf8w+aYzdOAlBo4KUmTaNTAh0ogzYuUL
         3UzMxf3IqbYZ+wrRvF+4/aKpthSpy2swin88IAbXJ1yaKoTah+AExbfbZPBzvM2t/gjN
         E/3zVH6WlkPLVK7w3TMlG4LmCPVNO5ywTMhVifS29AbPne6OHv7Y1TCJdxsqhEHW8+N2
         DhBbUQHQdMGTHS2sBgKTUdCGodSBv+OXKI08NMEEycuUHJv9G+2M5r+TTG6eJIfCzIlJ
         FijA==
X-Gm-Message-State: AOAM531ex9R7cx0bhzoZp9vlOTnTAcYZZp1wXPjA0yyLChfAZTURV1wu
        hyAf+xizNzJhBAYYK+QN7ec=
X-Google-Smtp-Source: ABdhPJwwefbxC2ns0ZGBtL/2096CW5QEUQ4ympc/q562C2lMn80GvMLESbXVDtKSubKzyXMlWD3XcQ==
X-Received: by 2002:a05:6512:6f:: with SMTP id i15mr548843lfo.426.1611312841251;
        Fri, 22 Jan 2021 02:54:01 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id g14sm409580lja.120.2021.01.22.02.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 02:54:00 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com,
        andrii@kernel.org, Marek Majtyka <alardam@gmail.com>
Subject: [PATCH bpf-next 3/3] libbpf, xsk: select AF_XDP BPF program based on kernel version
Date:   Fri, 22 Jan 2021 11:53:51 +0100
Message-Id: <20210122105351.11751-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210122105351.11751-1-bjorn.topel@gmail.com>
References: <20210122105351.11751-1-bjorn.topel@gmail.com>
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
 tools/lib/bpf/xsk.c | 82 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 79 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index e3e41ceeb1bc..1df8c133a5bc 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -46,6 +46,11 @@
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
@@ -351,6 +356,55 @@ int xsk_umem__create_v0_0_2(struct xsk_umem **umem_ptr, void *umem_area,
 COMPAT_VERSION(xsk_umem__create_v0_0_2, xsk_umem__create, LIBBPF_0.0.2)
 DEFAULT_VERSION(xsk_umem__create_v0_0_4, xsk_umem__create, LIBBPF_0.0.4)
 
+
+static enum xsk_prog get_xsk_prog(void)
+{
+	enum xsk_prog detected = XSK_PROG_FALLBACK;
+	struct bpf_load_program_attr prog_attr;
+	struct bpf_create_map_attr map_attr;
+	__u32 size_out, retval, duration;
+	char data_in = 0, data_out;
+	struct bpf_insn insns[] = {
+		BPF_LD_MAP_FD(BPF_REG_1, 0),
+		BPF_MOV64_IMM(BPF_REG_2, 0),
+		BPF_MOV64_IMM(BPF_REG_3, XDP_PASS),
+		BPF_EMIT_CALL(BPF_FUNC_redirect_map),
+		BPF_EXIT_INSN(),
+	};
+	int prog_fd, map_fd, ret;
+
+	memset(&map_attr, 0, sizeof(map_attr));
+	map_attr.map_type = BPF_MAP_TYPE_XSKMAP;
+	map_attr.key_size = sizeof(int);
+	map_attr.value_size = sizeof(int);
+	map_attr.max_entries = 1;
+
+	map_fd = bpf_create_map_xattr(&map_attr);
+	if (map_fd < 0)
+		return detected;
+
+	insns[0].imm = map_fd;
+
+	memset(&prog_attr, 0, sizeof(prog_attr));
+	prog_attr.prog_type = BPF_PROG_TYPE_XDP;
+	prog_attr.insns = insns;
+	prog_attr.insns_cnt = ARRAY_SIZE(insns);
+	prog_attr.license = "GPL";
+
+	prog_fd = bpf_load_program_xattr(&prog_attr, NULL, 0);
+	if (prog_fd < 0) {
+		close(map_fd);
+		return detected;
+	}
+
+	ret = bpf_prog_test_run(prog_fd, 0, &data_in, 1, &data_out, &size_out, &retval, &duration);
+	if (!ret && retval == XDP_PASS)
+		detected = XSK_PROG_REDIRECT_FLAGS;
+	close(prog_fd);
+	close(map_fd);
+	return detected;
+}
+
 static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 {
 	static const int log_buf_size = 16 * 1024;
@@ -358,7 +412,7 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 	char log_buf[log_buf_size];
 	int err, prog_fd;
 
-	/* This is the C-program:
+	/* This is the fallback C-program:
 	 * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
 	 * {
 	 *     int ret, index = ctx->rx_queue_index;
@@ -414,9 +468,31 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
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

