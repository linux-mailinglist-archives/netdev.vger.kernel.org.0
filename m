Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF58B4F5421
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239637AbiDFE0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1577692AbiDEXMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 19:12:40 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AAE6FDE00
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 14:44:23 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id h16-20020a056902009000b00628a70584b2so311396ybs.6
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 14:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JhNemOUOrymks7RERvE8pNaJu7DReEYY62Mw+xcnKPo=;
        b=gHh533D5CkyLYBLoGE8vqxMV6fdOA+m9hga+8BCKtay6qJr/J252NrifwUW60FqvRp
         z/1+5LrlZh84qZntEoWcfm4JFoXEqa2ZczJzIo6q5f5+tJ6PLlApYA2JxcKoYf6iZjyI
         VBCE4bEV5ue8zgogxjC/gbuArWSzYMDaYiT8i5/WQSknufh6trIDL2Y1+zwF8osisi2t
         dtK4Sa5AI2DFOG5TR+mVOZ5JWX5LShWM9ysxz7P88CBYJaUiw8EjiIJ9a+Gf8ErhTBDi
         xDy2UrBrNFXIvsP2ZWdtdVc9WVUC2pLgLFCMDPN52zy/VHyJvEf9odggV58U/5p4kmnX
         S+dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JhNemOUOrymks7RERvE8pNaJu7DReEYY62Mw+xcnKPo=;
        b=asu2lfT/AznGnJQPqRt7YlwCdOBgP3PKDxzGp3jUh3H74bjJD5IEKUUEaRdtmVsQmz
         hyMmobT4RHnLzl+71on0Eejl5HKJ9YWtLCyHR0XKiMwN6+vJ2oO5zpkdRWBK2xMUXEhn
         N7F96a7As95rX+JuYtlGu4Rqv9s8bdsWF3ARid3RwYYMeepZKdBl4boMRkKJutrN/KLu
         9XKakdMCC6Lw0UBlJQPLqx8AQU0W0aKzSNkH8xrvFMNdBS2cQscJ3sop4hVjNmH+dImE
         x+lOOH3Vu908sSJfD8Y7C5/E4w+xTsdef7PO+X8DmJyVcfs1WQkXGRWp9UvgVxGSAS2q
         h4QA==
X-Gm-Message-State: AOAM53301O/McDaWTQ+hcq3pPQKG7zhU7z010X2jpL7NuzAfQOn2sTzF
        FteeslMJlm4Hf18q0+7KxVxpAkJd3asaZZAu7A+ru9KT171Phk/9mKxk3RP8p7PcbZLUe23XyhQ
        UfNrz9mFu7UCb65zMiETgqqdF6dRnhXfYkIu73kKNsAAXclaVcgwRGQ==
X-Google-Smtp-Source: ABdhPJzv3m0mM6W+rVyd/m2tX4ZLYQv5AreJRWkfJ2wuVq6PEX9cu0HvpJBdbWtwfjqbCrAL5jlCTKU=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:73b5:ffab:2024:2901])
 (user=sdf job=sendgmr) by 2002:a25:4884:0:b0:628:c114:eb34 with SMTP id
 v126-20020a254884000000b00628c114eb34mr4300272yba.602.1649195042278; Tue, 05
 Apr 2022 14:44:02 -0700 (PDT)
Date:   Tue,  5 Apr 2022 14:43:42 -0700
In-Reply-To: <20220405214342.1968262-1-sdf@google.com>
Message-Id: <20220405214342.1968262-8-sdf@google.com>
Mime-Version: 1.0
References: <20220405214342.1968262-1-sdf@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH bpf-next v2 7/7] selftests/bpf: verify lsm_cgroup struct sock access
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,TVD_PH_SUBJ_META,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk_priority & sk_mark are writable, the rest is readonly.

Add new ldx_offset fixups to lookup the offset of struct field.
Allow using test.kfunc regardless of prog_type.

One interesting thing here is that the verifier doesn't
really force me to add NULL checks anywhere :-/

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/test_verifier.c   | 54 ++++++++++++++++++-
 .../selftests/bpf/verifier/lsm_cgroup.c       | 34 ++++++++++++
 2 files changed, 87 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/verifier/lsm_cgroup.c

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index a2cd236c32eb..d6bc55c54aaa 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -75,6 +75,12 @@ struct kfunc_btf_id_pair {
 	int insn_idx;
 };
 
+struct ldx_offset {
+	const char *strct;
+	const char *field;
+	int insn_idx;
+};
+
 struct bpf_test {
 	const char *descr;
 	struct bpf_insn	insns[MAX_INSNS];
@@ -102,6 +108,7 @@ struct bpf_test {
 	int fixup_map_ringbuf[MAX_FIXUPS];
 	int fixup_map_timer[MAX_FIXUPS];
 	struct kfunc_btf_id_pair fixup_kfunc_btf_id[MAX_FIXUPS];
+	struct ldx_offset fixup_ldx[MAX_FIXUPS];
 	/* Expected verifier log output for result REJECT or VERBOSE_ACCEPT.
 	 * Can be a tab-separated sequence of expected strings. An empty string
 	 * means no log verification.
@@ -755,6 +762,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	int *fixup_map_ringbuf = test->fixup_map_ringbuf;
 	int *fixup_map_timer = test->fixup_map_timer;
 	struct kfunc_btf_id_pair *fixup_kfunc_btf_id = test->fixup_kfunc_btf_id;
+	struct ldx_offset *fixup_ldx = test->fixup_ldx;
 
 	if (test->fill_helper) {
 		test->fill_insns = calloc(MAX_TEST_INSNS, sizeof(struct bpf_insn));
@@ -967,6 +975,50 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 			fixup_kfunc_btf_id++;
 		} while (fixup_kfunc_btf_id->kfunc);
 	}
+
+	if (fixup_ldx->strct) {
+		const struct btf_member *memb;
+		const struct btf_type *tp;
+		const char *name;
+		struct btf *btf;
+		int btf_id;
+		int off;
+		int i;
+
+		btf = btf__load_vmlinux_btf();
+
+		do {
+			off = -1;
+			if (!btf)
+				goto next_ldx;
+
+			btf_id = btf__find_by_name_kind(btf,
+							fixup_ldx->strct,
+							BTF_KIND_STRUCT);
+			if (btf_id < 0)
+				goto next_ldx;
+
+			tp = btf__type_by_id(btf, btf_id);
+			memb = btf_members(tp);
+
+			for (i = 0; i < btf_vlen(tp); i++) {
+				name = btf__name_by_offset(btf,
+							   memb->name_off);
+				if (strcmp(fixup_ldx->field, name) == 0) {
+					off = memb->offset / 8;
+					break;
+				}
+				memb++;
+			}
+
+next_ldx:
+			prog[fixup_ldx->insn_idx].off = off;
+			fixup_ldx++;
+
+		} while (fixup_ldx->strct);
+
+		btf__free(btf);
+	}
 }
 
 struct libcap {
@@ -1131,7 +1183,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 		opts.log_level = 4;
 	opts.prog_flags = pflags;
 
-	if (prog_type == BPF_PROG_TYPE_TRACING && test->kfunc) {
+	if (test->kfunc) {
 		int attach_btf_id;
 
 		attach_btf_id = libbpf_find_vmlinux_btf_id(test->kfunc,
diff --git a/tools/testing/selftests/bpf/verifier/lsm_cgroup.c b/tools/testing/selftests/bpf/verifier/lsm_cgroup.c
new file mode 100644
index 000000000000..af0efe783511
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/lsm_cgroup.c
@@ -0,0 +1,34 @@
+#define SK_WRITABLE_FIELD(tp, field, size, res) \
+{ \
+	.descr = field, \
+	.insns = { \
+		/* r1 = *(u64 *)(r1 + 0) */ \
+		BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, 0), \
+		/* r1 = *(u64 *)(r1 + offsetof(struct socket, sk)) */ \
+		BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, 0), \
+		/* r2 = *(u64 *)(r1 + offsetof(struct sock, <field>)) */ \
+		BPF_LDX_MEM(size, BPF_REG_2, BPF_REG_1, 0), \
+		/* *(u64 *)(r1 + offsetof(struct sock, <field>)) = r2 */ \
+		BPF_STX_MEM(size, BPF_REG_1, BPF_REG_2, 0), \
+		BPF_MOV64_IMM(BPF_REG_0, 1), \
+		BPF_EXIT_INSN(), \
+	}, \
+	.result = res, \
+	.errstr = res ? "no write support to 'struct sock' at off" : "", \
+	.prog_type = BPF_PROG_TYPE_LSM, \
+	.expected_attach_type = BPF_LSM_CGROUP, \
+	.kfunc = "socket_post_create", \
+	.fixup_ldx = { \
+		{ "socket", "sk", 1 }, \
+		{ tp, field, 2 }, \
+		{ tp, field, 3 }, \
+	}, \
+}
+
+SK_WRITABLE_FIELD("sock_common", "skc_family", BPF_H, REJECT),
+SK_WRITABLE_FIELD("sock", "sk_sndtimeo", BPF_DW, REJECT),
+SK_WRITABLE_FIELD("sock", "sk_priority", BPF_W, ACCEPT),
+SK_WRITABLE_FIELD("sock", "sk_mark", BPF_W, ACCEPT),
+SK_WRITABLE_FIELD("sock", "sk_pacing_rate", BPF_DW, REJECT),
+
+#undef SK_WRITABLE_FIELD
-- 
2.35.1.1094.g7c7d902a7c-goog

