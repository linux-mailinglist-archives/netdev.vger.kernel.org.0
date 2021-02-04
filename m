Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82AF30F499
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 15:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236644AbhBDOHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 09:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236457AbhBDOFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 09:05:40 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4BDAC06178A;
        Thu,  4 Feb 2021 06:04:29 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id s15so1808983plr.9;
        Thu, 04 Feb 2021 06:04:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r3brtnq+PNKE/grJyOzhs6QEmBg42KjXW9y/gHQmtYg=;
        b=Jz7ef14fgzgVPhXROU84XTKlaTOHByW11LaRaVVy3SpJowQitY3wC5lMqEoap7YqL7
         AWhjxujp2bHs/5XqokzOraGsiBt3b/mterJMyB4TwGbhK0wsw2Kt6du6QAeG0UxZjHEo
         ULFYScEzGrbmZePavAOnyQt3/qHOughEYSuHTW1ukQ0lRE4L2RCfPLXb5+E1cGG6dKri
         y+V8sFoJMslWQd8XSaQ0endqAbFKBwhT3ySrlGLLWiivjR/2cMZwcpILL/8Au/rfD+y6
         aHt9nFU5wIlUja6oJUunkvL6RqkZFzIrEOOiwXjh/I17zvF8+DlLrGe2xQbxxhLgt+4n
         POjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r3brtnq+PNKE/grJyOzhs6QEmBg42KjXW9y/gHQmtYg=;
        b=pq1dOdolC4TEqNX5soic3eVcvz5UNIbigJpAlEkQL3sFd5RQ4kphTvqwgb8I1Kj6Ae
         STnKEiRRtpQQ5pEi6XSiiO2EhmKnSN+B9NDQzMTzUZ5XBMOw37CnNnuxgFeGDbr4ZLzz
         nhrt/V1O8r1pyAZ+FjoKL4afuZrLLfWIO8VDyV2F4YHDOcfcY1HavhM5txVeKuL4QPaV
         MaergATyq1V57WT7PUZr4R56rIw24xQZ64rsdP66xncUf6YlrqIIA04iM70P7qB4OL0M
         yyVGMVy/E/3dGvqZwxS3X5J0cKcYaUK/KXb7U4/TThjNeLsOVJ/vcsyjQEbYcNSsUwxg
         pWLQ==
X-Gm-Message-State: AOAM533y5qesqcs2S7/CO25DvPzowBAcCyolmRIpvkKYAxoHrIbHkJz4
        fJZpOvxokTQ8fwVUf+BOo2Ruxzip+ber0shm
X-Google-Smtp-Source: ABdhPJwtnjMzfg3dyRrPj52p4U49Nwe2ckmp1583cV2H3BdxlRMjiikB6whdB7cUrIAkql+6fyek4w==
X-Received: by 2002:a17:90a:9ac:: with SMTP id 41mr8734430pjo.136.1612447468970;
        Thu, 04 Feb 2021 06:04:28 -0800 (PST)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 21sm5889394pfh.56.2021.02.04.06.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 06:04:28 -0800 (PST)
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
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv18 bpf-next 5/6] selftests/bpf: Add verifier tests for bpf arg ARG_CONST_MAP_PTR_OR_NULL
Date:   Thu,  4 Feb 2021 22:03:16 +0800
Message-Id: <20210204140317.384296-6-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210204140317.384296-1-liuhangbin@gmail.com>
References: <20210125124516.3098129-1-liuhangbin@gmail.com>
 <20210204140317.384296-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/bpf/test_verifier.c   | 22 +++++-
 .../testing/selftests/bpf/verifier/map_ptr.c  | 70 +++++++++++++++++++
 2 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 58b5a349d3ba..8b474177dab0 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -50,7 +50,7 @@
 #define MAX_INSNS	BPF_MAXINSNS
 #define MAX_TEST_INSNS	1000000
 #define MAX_FIXUPS	8
-#define MAX_NR_MAPS	21
+#define MAX_NR_MAPS	23
 #define MAX_TEST_RUNS	8
 #define POINTER_VALUE	0xcafe4all
 #define TEST_DATA_LEN	64
@@ -88,6 +88,8 @@ struct bpf_test {
 	int fixup_map_event_output[MAX_FIXUPS];
 	int fixup_map_reuseport_array[MAX_FIXUPS];
 	int fixup_map_ringbuf[MAX_FIXUPS];
+	int fixup_map_devmap[MAX_FIXUPS];
+	int fixup_map_devmap_hash[MAX_FIXUPS];
 	/* Expected verifier log output for result REJECT or VERBOSE_ACCEPT.
 	 * Can be a tab-separated sequence of expected strings. An empty string
 	 * means no log verification.
@@ -718,6 +720,8 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	int *fixup_map_event_output = test->fixup_map_event_output;
 	int *fixup_map_reuseport_array = test->fixup_map_reuseport_array;
 	int *fixup_map_ringbuf = test->fixup_map_ringbuf;
+	int *fixup_map_devmap = test->fixup_map_devmap;
+	int *fixup_map_devmap_hash = test->fixup_map_devmap_hash;
 
 	if (test->fill_helper) {
 		test->fill_insns = calloc(MAX_TEST_INSNS, sizeof(struct bpf_insn));
@@ -903,6 +907,22 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 			fixup_map_ringbuf++;
 		} while (*fixup_map_ringbuf);
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

