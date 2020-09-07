Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699EC25F52A
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 10:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgIGI2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 04:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728165AbgIGI2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 04:28:03 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC72C061575;
        Mon,  7 Sep 2020 01:28:03 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id b16so6381719pjp.0;
        Mon, 07 Sep 2020 01:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YLGvO/+4eEJ9UtM5N+e5p6B/6lir86qnFUrck89IjxI=;
        b=D6FLI5Fy3oLSHeVdgfEx8gB0QI2KKfPr/UzvGyE47hPqATTRXkEUdbOmhlHNTeRfxm
         gtWD6P/T4diqxRsl66Ym26Xvbn9eOWHmMBddCPIv48hnTEgCWRIo9npbXCHQhcWragNB
         RKqIOrCXH6YHAFMNDjn2AMnku0cz4l/JVJMGZL69u28ltFrL9917Z3G1TXhMRF5aNnsE
         aHZ3984LU0/BYTsKW4+UQwykayWSsLuVDbGWReeQBVV+3MBpwZmf8KnWfqmhXEPKwAf/
         3YQymLGT8dY0ghpkHyQ93k9CCSObSrmibWZsxeUZWlXWeoH/Sa2N/At7XNZhGdzvCjw7
         P9Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YLGvO/+4eEJ9UtM5N+e5p6B/6lir86qnFUrck89IjxI=;
        b=JWmKGju78Bzmq569L1FdpKWajwGUwC3m+2IiCbok+u+sCV4aDJCfKTBmelSkCiCUzY
         TL3DkXrL4FaiWq4uR2zVxaNx3vLBE5KoFUa1vgvDQfnX5AipaxCyleUMgOpbCBvFzPGm
         ulYobIKX5cRKbAgEHJ17NIb112Ma64h/i1os+Y5QMMrp/1LN4vzyihULyAKSk3YluCI/
         rPdGMg2Xc6BFnkqE81Et63RRt17m/IWBLfkV1Q1I63DUy2VThZ7t8GNfsTotVGJbSgFH
         qbxIgNCObjmB7iXzGzw8TkpHpZPOY4CEqmq4l2mSmeeIADKHPMEkIDIUVoK7y0SKukQ8
         tIyg==
X-Gm-Message-State: AOAM532UlrZJ/4oPkJolQ1G61+vjkj4G4uGDLnR8mm7wcxYTq7qpklA1
        MstoY1ppmIRUjdVzDvPfIudO1HN1V+3ONQ==
X-Google-Smtp-Source: ABdhPJycRwgFCFLVSOyY8WzQtgf8wxT+hwuGLDngIzPRKybS3KNo0N+YEcSNJ6IvNoCKotJ8yobFCA==
X-Received: by 2002:a17:90b:a44:: with SMTP id gw4mr18625812pjb.26.1599467282713;
        Mon, 07 Sep 2020 01:28:02 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i20sm11756311pgk.77.2020.09.07.01.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 01:28:02 -0700 (PDT)
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
Subject: [PATCHv11 bpf-next 5/5] selftests/bpf: Add verifier tests for bpf arg ARG_CONST_MAP_PTR_OR_NULL
Date:   Mon,  7 Sep 2020 16:27:24 +0800
Message-Id: <20200907082724.1721685-6-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200907082724.1721685-1-liuhangbin@gmail.com>
References: <20200903102701.3913258-1-liuhangbin@gmail.com>
 <20200907082724.1721685-1-liuhangbin@gmail.com>
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

v2-v11: no update

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

