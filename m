Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9EA02DFBF2
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 13:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgLUMgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 07:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbgLUMgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 07:36:44 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BFAC061248;
        Mon, 21 Dec 2020 04:35:46 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id f14so6100169pju.4;
        Mon, 21 Dec 2020 04:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OXVrjajjuTQUexu3XOfHEJa2VxcqHLEGUo6MBIg1jO4=;
        b=qZBKhI1IAsnRnr702yQQNG3CrYyuz0D1DBhMA9qn5jmS1jku4L4ZEgERzef3uUHlDy
         N4QirLAAbIO7OQVicg/ty22eA1YkYS1u+gnXUNVnBqSlYr7M/OG8eyr3essNL6nuK9In
         iQKkywJQQ0kTOth25kNN4TmMHgYA3u/bnLuxvhMpNs8ZNiwnkA+lUmbdOlMvretkEZUB
         1Zhy2X6hvxtoPBmvsHX3k2Jn/zOFWnLThN0JvGJrPBCJIsEQxrXE8RJ3frDIgUuZsZiA
         XD7ZmNnWVOfZgLmJfr9G+WPh9DHEff3iWYUMqHm4OJqork5fFNJdwMdjKE8dxIK5yVK0
         2WtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OXVrjajjuTQUexu3XOfHEJa2VxcqHLEGUo6MBIg1jO4=;
        b=O0Dat74lgQvBMCwUx1/zv5fY776J9JEAcrgDGqyhSdHN2LmISqKbZNvbMqDZuccLwX
         FpUM5hS0cxEgpl2xeUq16J3y3pD3ic7om4jFHE5MLd/99q9z8VTFBbh8VUbtxnJ/vqQ7
         P8Y3T22cWDqm3z/IiBPTRbmFnqLCn0fXcpTr3SUM55+8Y8m48nmDc/tsrqLI6mV4+Pyj
         17m/MK8r25TeBBBSV6/mtCQStstwVfVa/v2MdShxNAnopAY2X0WV/7jtdLCLiBKPW/h3
         e+EVCkBbbvo1jlGlhVLTy2Vn7uvghb2oWPnVzPMgFhoDq3Q4rb5YYOl+o08UFehPDNrS
         ytsw==
X-Gm-Message-State: AOAM530ezG7euaM9VgPw1mOxzNn7Wpp3yXr3Z0uQNS8KDfsTk6vU+VKR
        ojl96/89wxYdqSIsemsgkFxNZMCWJKNgMfea
X-Google-Smtp-Source: ABdhPJyiKV2/hE9WIbbLXUFY3rJYm7hmUxUMcEhqMYqyGbkU16jgGUmLrZ6GzHSZ+sQePsvVnnbSSg==
X-Received: by 2002:a17:902:c215:b029:da:b079:b9a3 with SMTP id 21-20020a170902c215b02900dab079b9a3mr16101534pll.67.1608554145771;
        Mon, 21 Dec 2020 04:35:45 -0800 (PST)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a26sm15382204pgd.64.2020.12.21.04.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 04:35:45 -0800 (PST)
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
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv13 bpf-next 5/6] selftests/bpf: Add verifier tests for bpf arg ARG_CONST_MAP_PTR_OR_NULL
Date:   Mon, 21 Dec 2020 20:35:04 +0800
Message-Id: <20201221123505.1962185-6-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201221123505.1962185-1-liuhangbin@gmail.com>
References: <20201216143036.2296568-1-liuhangbin@gmail.com>
 <20201221123505.1962185-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 ]# ./test_verifier 713 716
 #713/p ARG_CONST_MAP_PTR: null pointer OK
 #714/p ARG_CONST_MAP_PTR: valid map pointer OK
 #715/p ARG_CONST_MAP_PTR_OR_NULL: null pointer for ex_map OK
 #716/p ARG_CONST_MAP_PTR_OR_NULL: valid map pointer for ex_map OK
 Summary: 4 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/bpf/test_verifier.c   | 22 +++++-
 .../testing/selftests/bpf/verifier/map_ptr.c  | 70 +++++++++++++++++++
 2 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 777a81404fdb..17eb3958ce6d 100644
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
index b117bdd3806d..1a532198c9c1 100644
--- a/tools/testing/selftests/bpf/verifier/map_ptr.c
+++ b/tools/testing/selftests/bpf/verifier/map_ptr.c
@@ -93,3 +93,73 @@
 	.fixup_map_hash_16b = { 4 },
 	.result = ACCEPT,
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
2.26.2

