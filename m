Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACB4A4BCEBA
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 14:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243921AbiBTNtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 08:49:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243948AbiBTNtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 08:49:41 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0D55373E;
        Sun, 20 Feb 2022 05:49:03 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id gl14-20020a17090b120e00b001bc2182c3d5so868828pjb.1;
        Sun, 20 Feb 2022 05:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rn1ercMMJUMyOEbe0u0Ak+J0xPsv9d5mep6WrWJN6GQ=;
        b=nWXVPC+bZ1dRY1l6CPRhHH6Y8GrKl4tzel0VgAmCBCEucF1oADeqWeUZ/eK/im+yLq
         HA1g+bL3m5IV7oHQ0Rwiecif9NX3b1Q629PM6GerAcQG+h9j/nnAFMhRCeaz8zNaEQPd
         OStzzleDwtXss6t+NZZB2kftt2bhzhrGf3JQiGkWgX9eFJHgSNOTjderYjlXJQ+JmFSf
         ihU2ZjKCWPvPpQDYLA3i7e7kEsLLLVmrzyy9PqjZ3s/enkdX9JLzJQyioap7KqxWuX14
         /aMSq9AphbTfPfx4+dpHCb33qqbg6NOSvc/vVfaDp2VyuqT9F9QmmFmtqYA2eo+EPu0C
         vR7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rn1ercMMJUMyOEbe0u0Ak+J0xPsv9d5mep6WrWJN6GQ=;
        b=R66BPqSUXTO0nEmteraZ5pfEEBarg5Mya6RkAJATJLU562qwthibjfDVEEl3s59vqZ
         P56nbn9cTZ7TEZCekYfJhb2r8S3eicHjZa1PnqcyRztBKnha6+Dqllow8EsMl45Bpxz1
         7H4PvbDwnNvdZG+2s/qNOh9EKvW4EdSqLSgKMHfxTzYarn478FN7ivk9QexWMlqySIxT
         T9WArNzozqZ2eDrprLAqtmTKEU9hfXr1cifczYQ2SDtRSzQf0SbagLVUMInT+WUoOVtx
         OGIl6BjVGltSloH7VLlStJWGmmiyc84/ZkWj9kgAJP8ErpUgwyNqk1XKfzFENmusnSpC
         Amyg==
X-Gm-Message-State: AOAM533ftAHifuWuuB7ifHgcJ2vbkmuGdtrhfhzhmmEe47jYj1QMtPex
        1kaI67J1fyYyd6eaGSTFE2vOAlQLM/U=
X-Google-Smtp-Source: ABdhPJw3d+Y4pWKqabXJSSt2EW67GdBYwUFT8JHXl2qRYTS9L51qRXkU/wcYDBa0xq5cHT38RV7hxA==
X-Received: by 2002:a17:90b:4aca:b0:1b9:ed62:b917 with SMTP id mh10-20020a17090b4aca00b001b9ed62b917mr21309060pjb.237.1645364942555;
        Sun, 20 Feb 2022 05:49:02 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id s40sm9914049pfg.145.2022.02.20.05.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 05:49:02 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 15/15] selftests/bpf: Add verifier tests for PTR_TO_BTF_ID in map
Date:   Sun, 20 Feb 2022 19:18:13 +0530
Message-Id: <20220220134813.3411982-16-memxor@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220134813.3411982-1-memxor@gmail.com>
References: <20220220134813.3411982-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=27272; h=from:subject; bh=YKF7x2OTXg6vHQsh24VXYPJ7XmPuz1q4g1niFGl3JyQ=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBiEkZYoEI9MXffYxMtqNByf4pbjg2UjrHRRHnC5FMr RRh04NeJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYhJGWAAKCRBM4MiGSL8RyteGEA CKRX77DFgv6TD15qKvkjb8r5T1arK+cDpgOuFMPI7CcWEcEOubztHl6KI4VjpCVUBHdAtbVaCwDA6e qBDitfV3Z3/mKdIOwi6qposZRksyIcw8hnvu0HlwCAmMiKbwtF4qH39xC0WWGRpLvJfXJQHgEP3xl0 d6zFWXcUyQBmH0UeHmH3uqp+SlXGI5Z0amtEAdL6kuvnJKS+GmoK8/iVdynAYJWx46KQUbAxANiK6/ AxltKMRVn4eX6wFTjMbkfQJcuOID7W/+augiqbM6VA4R0YjsO1ESLFD6yDSQeyvZISt3cmPgbcKByn +naIp+xerOaMoY5olYL6xDUH1Wc/RojS29OgyV09JvzCHONeU3YNr5Oy1tXnM1NvcmjVepLL0Ewa2D wZvpQgn/wZ2i3pq6ahLZ4g4le+ZC4dsfvmoUNWN+IAX36u8S67GU3Im/DVP7GXpB2estnSlzgeP/EG i0D5VHpL/nOQXiKR4pWVfkr4PtqbrODUnd2wSurRYqj5vnqv2qeElhMiuR654/bZNKasDHofFrn9/v ylG6EzNJwEsSu11gNwijPHENMMcxN6Tb8oxlkg5/obETQ6TE8Y1iRer5hjI8L3x10B81xjUaJSuPT4 kpxM71y1tRNW48rMRQah//fx6CX2s7URd0e53lESHIEz/GOJtTJrH7ZiSZuQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reuse bpf_prog_test functions to test the support for PTR_TO_BTF_ID in
BPF map case, including some tests that verify implementation sanity and
corner cases.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 net/bpf/test_run.c                            |  17 +-
 tools/testing/selftests/bpf/test_verifier.c   |  57 +-
 .../selftests/bpf/verifier/map_btf_ptr.c      | 624 ++++++++++++++++++
 3 files changed, 695 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/verifier/map_btf_ptr.c

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index f08034500813..caa289f63849 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1263,8 +1263,23 @@ static const struct btf_kfunc_id_set bpf_prog_test_kfunc_set = {
 	.ret_null_set = &test_sk_ret_null_kfunc_ids,
 };
 
+BTF_ID_LIST(bpf_prog_test_dtor_kfunc_ids)
+BTF_ID(struct, prog_test_ref_kfunc)
+BTF_ID(func, bpf_kfunc_call_test_release)
+
 static int __init bpf_prog_test_run_init(void)
 {
-	return register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_prog_test_kfunc_set);
+	const struct btf_id_dtor_kfunc bpf_prog_test_dtor_kfunc[] = {
+		{
+		  .btf_id       = bpf_prog_test_dtor_kfunc_ids[0],
+		  .kfunc_btf_id = bpf_prog_test_dtor_kfunc_ids[1]
+		},
+	};
+	int ret;
+
+	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_prog_test_kfunc_set);
+	return ret ?: register_btf_id_dtor_kfuncs(bpf_prog_test_dtor_kfunc,
+						  ARRAY_SIZE(bpf_prog_test_dtor_kfunc),
+						  THIS_MODULE);
 }
 late_initcall(bpf_prog_test_run_init);
diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 92e3465fbae8..9ec0c4457396 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -54,7 +54,7 @@
 #define MAX_INSNS	BPF_MAXINSNS
 #define MAX_TEST_INSNS	1000000
 #define MAX_FIXUPS	8
-#define MAX_NR_MAPS	22
+#define MAX_NR_MAPS	23
 #define MAX_TEST_RUNS	8
 #define POINTER_VALUE	0xcafe4all
 #define TEST_DATA_LEN	64
@@ -98,6 +98,7 @@ struct bpf_test {
 	int fixup_map_reuseport_array[MAX_FIXUPS];
 	int fixup_map_ringbuf[MAX_FIXUPS];
 	int fixup_map_timer[MAX_FIXUPS];
+	int fixup_map_btf_ptr[MAX_FIXUPS];
 	struct kfunc_btf_id_pair fixup_kfunc_btf_id[MAX_FIXUPS];
 	/* Expected verifier log output for result REJECT or VERBOSE_ACCEPT.
 	 * Can be a tab-separated sequence of expected strings. An empty string
@@ -618,8 +619,13 @@ static int create_cgroup_storage(bool percpu)
  * struct timer {
  *   struct bpf_timer t;
  * };
+ * struct btf_ptr {
+ *   struct prog_test_ref_kfunc __btf_id *ptr;
+ * }
  */
-static const char btf_str_sec[] = "\0bpf_spin_lock\0val\0cnt\0l\0bpf_timer\0timer\0t";
+static const char btf_str_sec[] = "\0bpf_spin_lock\0val\0cnt\0l\0bpf_timer\0timer\0t"
+				  "\0btf_ptr\0prog_test_ref_kfunc\0ptr\0kernel.bpf.btf_id"
+				  "\0kernel.bpf.ref\0kernel.bpf.percpu\0kernel.bpf.user";
 static __u32 btf_raw_types[] = {
 	/* int */
 	BTF_TYPE_INT_ENC(0, BTF_INT_SIGNED, 0, 32, 4),  /* [1] */
@@ -635,6 +641,26 @@ static __u32 btf_raw_types[] = {
 	/* struct timer */                              /* [5] */
 	BTF_TYPE_ENC(35, BTF_INFO_ENC(BTF_KIND_STRUCT, 0, 1), 16),
 	BTF_MEMBER_ENC(41, 4, 0), /* struct bpf_timer t; */
+	/* struct prog_test_ref_kfunc */		/* [6] */
+	BTF_STRUCT_ENC(51, 0, 0),
+	/* type tag "kernel.bpf.btf_id" */
+	BTF_TYPE_TAG_ENC(75, 6),			/* [7] */
+	/* type tag "kernel.bpf.ref" */
+	BTF_TYPE_TAG_ENC(93, 7),			/* [8] */
+	/* type tag "kernel.bpf.percpu" */
+	BTF_TYPE_TAG_ENC(108, 7),			/* [9] */
+	/* type tag "kernel.bpf.user" */
+	BTF_TYPE_TAG_ENC(126, 7),			/* [10] */
+	BTF_PTR_ENC(7),					/* [11] */
+	BTF_PTR_ENC(8),					/* [12] */
+	BTF_PTR_ENC(9),					/* [13] */
+	BTF_PTR_ENC(10),				/* [14] */
+	/* struct btf_ptr */				/* [15] */
+	BTF_STRUCT_ENC(43, 4, 32),
+	BTF_MEMBER_ENC(71, 11, 0), /* struct prog_test_ref_kfunc __kptr *ptr; */
+	BTF_MEMBER_ENC(71, 12, 64), /* struct prog_test_ref_kfunc __kptr_ref *ptr; */
+	BTF_MEMBER_ENC(71, 13, 128), /* struct prog_test_ref_kfunc __kptr_percpu *ptr; */
+	BTF_MEMBER_ENC(71, 14, 192), /* struct prog_test_ref_kfunc __kptr_user *ptr; */
 };
 
 static int load_btf(void)
@@ -724,6 +750,25 @@ static int create_map_timer(void)
 	return fd;
 }
 
+static int create_map_btf_ptr(void)
+{
+	LIBBPF_OPTS(bpf_map_create_opts, opts,
+		.btf_key_type_id = 1,
+		.btf_value_type_id = 15,
+	);
+	int fd, btf_fd;
+
+	btf_fd = load_btf();
+	if (btf_fd < 0)
+		return -1;
+
+	opts.btf_fd = btf_fd;
+	fd = bpf_map_create(BPF_MAP_TYPE_ARRAY, "test_map", 4, 32, 1, &opts);
+	if (fd < 0)
+		printf("Failed to create map with btf_id pointer\n");
+	return fd;
+}
+
 static char bpf_vlog[UINT_MAX >> 8];
 
 static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
@@ -751,6 +796,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	int *fixup_map_reuseport_array = test->fixup_map_reuseport_array;
 	int *fixup_map_ringbuf = test->fixup_map_ringbuf;
 	int *fixup_map_timer = test->fixup_map_timer;
+	int *fixup_map_btf_ptr = test->fixup_map_btf_ptr;
 	struct kfunc_btf_id_pair *fixup_kfunc_btf_id = test->fixup_kfunc_btf_id;
 
 	if (test->fill_helper) {
@@ -944,6 +990,13 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 			fixup_map_timer++;
 		} while (*fixup_map_timer);
 	}
+	if (*fixup_map_btf_ptr) {
+		map_fds[22] = create_map_btf_ptr();
+		do {
+			prog[*fixup_map_btf_ptr].imm = map_fds[22];
+			fixup_map_btf_ptr++;
+		} while (*fixup_map_btf_ptr);
+	}
 
 	/* Patch in kfunc BTF IDs */
 	if (fixup_kfunc_btf_id->kfunc) {
diff --git a/tools/testing/selftests/bpf/verifier/map_btf_ptr.c b/tools/testing/selftests/bpf/verifier/map_btf_ptr.c
new file mode 100644
index 000000000000..89d854ce90eb
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/map_btf_ptr.c
@@ -0,0 +1,624 @@
+/* Common tests */
+{
+	"map_btf_ptr: BPF_ST imm != 0",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_ST_MEM(BPF_DW, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "BPF_ST imm must be 0 when writing to btf_id pointer at off=0",
+},
+{
+	"map_btf_ptr: size != bpf_size_to_bytes(BPF_DW)",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_ST_MEM(BPF_W, BPF_REG_0, 0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "btf_id pointer load/store size must be 8",
+},
+{
+	"map_btf_ptr: map_value non-const var_off",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_REG(BPF_REG_3, BPF_REG_0),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_0, 0),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_2, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_2, 0),
+	BPF_JMP_IMM(BPF_JLE, BPF_REG_2, 4, 1),
+	BPF_EXIT_INSN(),
+	BPF_JMP_IMM(BPF_JGE, BPF_REG_2, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_3, BPF_REG_2),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_3, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "btf_id pointer cannot be accessed by variable offset load/store",
+},
+{
+	"map_btf_ptr: unaligned boundary load/store",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, 7),
+	BPF_ST_MEM(BPF_DW, BPF_REG_0, 0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "btf_id pointer offset incorrect",
+},
+{
+	"map_btf_ptr: reject var_off != 0",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 0),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 0),
+	BPF_JMP_IMM(BPF_JLE, BPF_REG_2, 4, 1),
+	BPF_EXIT_INSN(),
+	BPF_JMP_IMM(BPF_JGE, BPF_REG_2, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_1, BPF_REG_2),
+	BPF_STX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "R1 is ptr_prog_test_ref_kfunc invalid variable offset: off=0, var_off=(0x0; 0x7)",
+},
+/* Tests for unreferened PTR_TO_BTF_ID */
+{
+	"map_btf_ptr: unref: reject btf_struct_ids_match == false",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 0),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 4),
+	BPF_STX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "invalid btf_id pointer access, R1 type=untrusted_ptr_prog_test_ref_kfunc expected=ptr_or_null_prog_test",
+},
+{
+	"map_btf_ptr: unref: loaded pointer marked as untrusted",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "R0 invalid mem access 'untrusted_ptr_or_null_'",
+},
+{
+	"map_btf_ptr: unref: correct in kernel type size",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 16),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "access beyond struct prog_test_ref_kfunc at off 16 size 8",
+},
+{
+	"map_btf_ptr: unref: inherit PTR_UNTRUSTED on struct walk",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 8),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_this_cpu_ptr),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "R1 type=untrusted_ptr_ expected=percpu_ptr_",
+},
+{
+	"map_btf_ptr: unref: no reference state created",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = ACCEPT,
+},
+{
+	"map_btf_ptr: unref: xchg no reference state created",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_IMM(BPF_REG_1, 0),
+	BPF_ATOMIC_OP(BPF_DW, BPF_XCHG, BPF_REG_0, BPF_REG_1, 0),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = ACCEPT,
+},
+/* Tests for referenced PTR_TO_BTF_ID */
+{
+	"map_btf_ptr: ref: loaded pointer marked as untrusted",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_IMM(BPF_REG_1, 0),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 8),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_this_cpu_ptr),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "R1 type=untrusted_ptr_or_null_ expected=percpu_ptr_",
+},
+{
+	"map_btf_ptr: ref: reject off != 0",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_IMM(BPF_REG_1, 0),
+	BPF_ATOMIC_OP(BPF_DW, BPF_XCHG, BPF_REG_0, BPF_REG_1, 8),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 4),
+	BPF_ATOMIC_OP(BPF_DW, BPF_XCHG, BPF_REG_0, BPF_REG_1, 8),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "R1 stored to referenced btf_id pointer cannot have non-zero offset",
+},
+{
+	"map_btf_ptr: ref: reference state created on xchg",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -8),
+	BPF_ST_MEM(BPF_DW, BPF_REG_1, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_ATOMIC_OP(BPF_DW, BPF_XCHG, BPF_REG_7, BPF_REG_0, 8),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "Unreleased reference id=4 alloc_insn=17",
+	.fixup_kfunc_btf_id = {
+		{ "bpf_kfunc_call_test_acquire", 14 },
+	}
+},
+{
+	"map_btf_ptr: ref: reference state cleared for src_reg",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -8),
+	BPF_ST_MEM(BPF_DW, BPF_REG_1, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_ATOMIC_OP(BPF_DW, BPF_XCHG, BPF_REG_7, BPF_REG_0, 8),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = ACCEPT,
+	.fixup_kfunc_btf_id = {
+		{ "bpf_kfunc_call_test_acquire", 14 },
+		{ "bpf_kfunc_call_test_release", 21 },
+	}
+},
+{
+	"map_btf_ptr: ref: reject STX",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_REG(BPF_REG_1, 0),
+	BPF_STX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, 8),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "referenced btf_id pointer can only be accessed using BPF_XCHG",
+},
+{
+	"map_btf_ptr: ref: reject ST",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_ST_MEM(BPF_DW, BPF_REG_0, 8, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "referenced btf_id pointer can only be accessed using BPF_XCHG",
+},
+/* Tests for PTR_TO_PERCPU_BTF_ID */
+{
+	"map_btf_ptr: percpu: loaded pointer marked as percpu",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 16),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_this_cpu_ptr),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "R1 type=percpu_ptr_or_null_ expected=percpu_ptr_",
+},
+{
+	"map_btf_ptr: percpu: reject store of untrusted_ptr_",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 8),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_STX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, 16),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "invalid btf_id pointer access, R1 type=untrusted_ptr_ expected=percpu_ptr_or_null_",
+},
+{
+	"map_btf_ptr: percpu: reject store of ptr_",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_IMM(BPF_REG_1, 0),
+	BPF_ATOMIC_OP(BPF_DW, BPF_XCHG, BPF_REG_0, BPF_REG_1, 8),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_STX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, 16),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "invalid btf_id pointer access, R1 type=ptr_ expected=percpu_ptr_or_null_",
+},
+{
+	"map_btf_ptr: percpu: reject store of user_ptr_",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 24),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_STX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, 16),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "invalid btf_id pointer access, R1 type=user_ptr_ expected=percpu_ptr_or_null_",
+},
+/* Tests for PTR_TO_BTF_ID | MEM_USR */
+{
+	"map_btf_ptr: user: loaded pointer marked as user",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 24),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_this_cpu_ptr),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "R1 type=user_ptr_or_null_ expected=percpu_ptr_",
+},
+{
+	"map_btf_ptr: user: reject user pointer deref",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 24),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_1, 8),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "R1 invalid mem access 'user_ptr_'",
+},
+{
+	"map_btf_ptr: user: reject store of untrusted_ptr_",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 8),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_STX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, 24),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "invalid btf_id pointer access, R1 type=untrusted_ptr_ expected=user_ptr_or_null_",
+},
+{
+	"map_btf_ptr: user: reject store of ptr_",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_IMM(BPF_REG_1, 0),
+	BPF_ATOMIC_OP(BPF_DW, BPF_XCHG, BPF_REG_0, BPF_REG_1, 8),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_STX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, 24),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "invalid btf_id pointer access, R1 type=ptr_ expected=user_ptr_or_null_",
+},
+{
+	"map_btf_ptr: user: reject store of percpu_ptr_",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_LD_MAP_FD(BPF_REG_6, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 16),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_STX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, 24),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_btf_ptr = { 1 },
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "invalid btf_id pointer access, R1 type=percpu_ptr_ expected=user_ptr_or_null_",
+},
-- 
2.35.1

