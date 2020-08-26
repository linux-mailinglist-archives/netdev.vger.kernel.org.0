Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4F2252F90
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 15:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730262AbgHZNUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 09:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730252AbgHZNUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 09:20:39 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCEE4C061756;
        Wed, 26 Aug 2020 06:20:39 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id s2so266215pjr.4;
        Wed, 26 Aug 2020 06:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YsZt/qgPuo31p7ki4/qp/orJWLUccxrYtZtCufXmmGM=;
        b=nd8crma76C9c+OzNQNWF/Hs0ItGfua4eRi6vBbJEFYLPOZaWXz0RVNtzLJrXIxLo6n
         ydvhtlvcFVD5/GiFQjVG/AR+d7vbhTP1/TzP4/dwt8OknNwbAtv2ah/kR3ts/F2TCTA1
         limRyoqEnqYtQPs0vdK2IKeS56w2p2EiA+4m6SebFSktgLiJ/Rmu6xJ2xRTr4dlJT0ne
         913nj5yza2gMJqxD6jUshu7QJLQAL09LIES3UvmEs+6TQMxSLmNDMJQ42mv3nPT/GsO6
         x97aaGu0IiwJ0fNiWt/Cmk1kpw3Ziw0s+Z/5uh10q4Fz1TtdbvknUeM9OM0oxeTMCbZS
         pWwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YsZt/qgPuo31p7ki4/qp/orJWLUccxrYtZtCufXmmGM=;
        b=KVYrFQ00zNEELhMQuEZB8gWLeEBHSJs5mq6+p3LvD6+a3lu2xJnI6ry6xIinCD23Ol
         RJNtzTDPvhT6RzgjNNlrZpScNiiVbEiOUQsXvYbYWcdBC/tWw04MBpdOmuIj71vsDq3U
         siOCpjtB7CSkqk7+z0Ftz3CzUYbQsCi8+EZ3rqhR9mhKDPW+2TMGeXzk46ojQDnGQUp9
         Sgsq8u2OJgV3SgDhBp8I7fE8gUvXISLIe/3OaKl3DbfQevAuQe8+iPk7FYKJFDhAsXKI
         cQ59hMZ9Cw6S1ai5WFXLmDj5F7vPxpgnO225KUdws55CP5rWVWNDmeVPX9PrsovClguO
         +utw==
X-Gm-Message-State: AOAM531ojplYf+gkph6vyqj9/n6yggP3hCN87Ufu8ykytF2nIxCeYwfu
        7ikoQIRFrLtY7aoBoqhsyy1OoEPHihHQQs/B
X-Google-Smtp-Source: ABdhPJwIsEA/FKpvulKJkH73nYf91yvmAqW8UKzAPuJo1PKB14zmEcg+LBES1+YYJIlP2XinPTzsYw==
X-Received: by 2002:a17:90a:c791:: with SMTP id gn17mr5784051pjb.44.1598448039168;
        Wed, 26 Aug 2020 06:20:39 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s129sm3131794pfb.39.2020.08.26.06.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 06:20:38 -0700 (PDT)
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
Subject: [PATCHv9 bpf-next 5/5] selftests/bpf: Add verifier tests for bpf arg ARG_CONST_MAP_PTR_OR_NULL
Date:   Wed, 26 Aug 2020 21:20:02 +0800
Message-Id: <20200826132002.2808380-6-liuhangbin@gmail.com>
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

Use helper bpf_redirect_map() and bpf_redirect_map_multi() to test bpf
arg ARG_CONST_MAP_PTR and ARG_CONST_MAP_PTR_OR_NULL. Make sure the
map arg could be verified correctly when it is NULL or valid map
pointer.

Add devmap and devmap_hash in struct bpf_test due to bpf_redirect_{map,
map_multi} limit.

Test result:
 ]# ./test_verifier 702 705
 #702/p ARG_CONST_MAP_PTR: null pointer OK
 #703/p ARG_CONST_MAP_PTR: valid map pointer OK
 #704/p ARG_CONST_MAP_PTR_OR_NULL: null pointer for ex_map OK
 #705/p ARG_CONST_MAP_PTR_OR_NULL: valid map pointer for ex_map OK
 Summary: 4 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---

v1-v9: no update, new added

---
 tools/testing/selftests/bpf/test_verifier.c   | 22 +++++-
 .../testing/selftests/bpf/verifier/map_ptr.c  | 70 +++++++++++++++++++
 2 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 9be395d9dc64..f89a13e60692 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -50,7 +50,7 @@
 #define MAX_INSNS	BPF_MAXINSNS
 #define MAX_TEST_INSNS	1000000
 #define MAX_FIXUPS	8
-#define MAX_NR_MAPS	20
+#define MAX_NR_MAPS	22
 #define MAX_TEST_RUNS	8
 #define POINTER_VALUE	0xcafe4all
 #define TEST_DATA_LEN	64
@@ -87,6 +87,8 @@ struct bpf_test {
 	int fixup_sk_storage_map[MAX_FIXUPS];
 	int fixup_map_event_output[MAX_FIXUPS];
 	int fixup_map_reuseport_array[MAX_FIXUPS];
+	int fixup_map_devmap[MAX_FIXUPS];
+	int fixup_map_devmap_hash[MAX_FIXUPS];
 	const char *errstr;
 	const char *errstr_unpriv;
 	uint32_t insn_processed;
@@ -640,6 +642,8 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	int *fixup_sk_storage_map = test->fixup_sk_storage_map;
 	int *fixup_map_event_output = test->fixup_map_event_output;
 	int *fixup_map_reuseport_array = test->fixup_map_reuseport_array;
+	int *fixup_map_devmap = test->fixup_map_devmap;
+	int *fixup_map_devmap_hash = test->fixup_map_devmap_hash;
 
 	if (test->fill_helper) {
 		test->fill_insns = calloc(MAX_TEST_INSNS, sizeof(struct bpf_insn));
@@ -817,6 +821,22 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 			fixup_map_reuseport_array++;
 		} while (*fixup_map_reuseport_array);
 	}
+	if (*fixup_map_devmap) {
+		map_fds[20] = __create_map(BPF_MAP_TYPE_DEVMAP,
+					   sizeof(u32), sizeof(u32), 1, 0);
+		do {
+			prog[*fixup_map_devmap].imm = map_fds[20];
+			fixup_map_devmap++;
+		} while (*fixup_map_devmap);
+	}
+	if (*fixup_map_devmap_hash) {
+		map_fds[21] = __create_map(BPF_MAP_TYPE_DEVMAP_HASH,
+					   sizeof(u32), sizeof(u32), 1, 0);
+		do {
+			prog[*fixup_map_devmap_hash].imm = map_fds[21];
+			fixup_map_devmap_hash++;
+		} while (*fixup_map_devmap_hash);
+	}
 }
 
 struct libcap {
diff --git a/tools/testing/selftests/bpf/verifier/map_ptr.c b/tools/testing/selftests/bpf/verifier/map_ptr.c
index b52209db8250..51df7d8784dc 100644
--- a/tools/testing/selftests/bpf/verifier/map_ptr.c
+++ b/tools/testing/selftests/bpf/verifier/map_ptr.c
@@ -60,3 +60,73 @@
 	.result = ACCEPT,
 	.retval = 1,
 },
+{
+	"ARG_CONST_MAP_PTR: null pointer",
+	.insns = {
+		/* bpf_redirect_map arg1 (map) */
+		BPF_MOV64_IMM(BPF_REG_1, 0),
+		/* bpf_redirect_map arg2 (ifindex) */
+		BPF_MOV64_IMM(BPF_REG_2, 0),
+		/* bpf_redirect_map arg3 (flags) */
+		BPF_MOV64_IMM(BPF_REG_3, 0),
+		BPF_EMIT_CALL(BPF_FUNC_redirect_map),
+		BPF_EXIT_INSN(),
+	},
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.errstr = "R1 type=inv expected=map_ptr",
+},
+{
+	"ARG_CONST_MAP_PTR: valid map pointer",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_1, 0),
+		/* bpf_redirect_map arg1 (map) */
+		BPF_LD_MAP_FD(BPF_REG_1, 0),
+		/* bpf_redirect_map arg2 (ifindex) */
+		BPF_MOV64_IMM(BPF_REG_2, 0),
+		/* bpf_redirect_map arg3 (flags) */
+		BPF_MOV64_IMM(BPF_REG_3, 0),
+		BPF_EMIT_CALL(BPF_FUNC_redirect_map),
+		BPF_EXIT_INSN(),
+	},
+	.fixup_map_devmap = { 1 },
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+},
+{
+	"ARG_CONST_MAP_PTR_OR_NULL: null pointer for ex_map",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_1, 0),
+		/* bpf_redirect_map_multi arg1 (in_map) */
+		BPF_LD_MAP_FD(BPF_REG_1, 0),
+		/* bpf_redirect_map_multi arg2 (ex_map) */
+		BPF_MOV64_IMM(BPF_REG_2, 0),
+		/* bpf_redirect_map_multi arg3 (flags) */
+		BPF_MOV64_IMM(BPF_REG_3, 0),
+		BPF_EMIT_CALL(BPF_FUNC_redirect_map_multi),
+		BPF_EXIT_INSN(),
+	},
+	.fixup_map_devmap = { 1 },
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.retval = 4,
+},
+{
+	"ARG_CONST_MAP_PTR_OR_NULL: valid map pointer for ex_map",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_1, 0),
+		/* bpf_redirect_map_multi arg1 (in_map) */
+		BPF_LD_MAP_FD(BPF_REG_1, 0),
+		/* bpf_redirect_map_multi arg2 (ex_map) */
+		BPF_LD_MAP_FD(BPF_REG_2, 1),
+		/* bpf_redirect_map_multi arg3 (flags) */
+		BPF_MOV64_IMM(BPF_REG_3, 0),
+		BPF_EMIT_CALL(BPF_FUNC_redirect_map_multi),
+		BPF_EXIT_INSN(),
+	},
+	.fixup_map_devmap = { 1 },
+	.fixup_map_devmap_hash = { 3 },
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.retval = 4,
+},
-- 
2.25.4

