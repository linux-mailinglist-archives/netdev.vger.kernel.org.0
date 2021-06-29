Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B123B78AB
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 21:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234180AbhF2Tcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 15:32:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27033 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235073AbhF2Tc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 15:32:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624995001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7POGsUdxxXzK+4ImUmkSrNYlLw4tFmtrg6J6zcZB3co=;
        b=VWHN6NLXLo1ctRkXnfDOOxBXQ4kA2fXSx9qPEzthMBpb7nkbn17CRqG6XfVisfRCYGZ76j
        /QVeysnahYLsdwi4aAHtwjb0d4F18vmkOHOkcHP/Vk5pTisHg95G2Wgi+0vN0cvm5vnpUB
        ldsjfsWnyXJ/L8+7cYVOqv8xgvvonfU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-5hfHdJ1xM16LVkgSsneS5Q-1; Tue, 29 Jun 2021 15:29:56 -0400
X-MC-Unique: 5hfHdJ1xM16LVkgSsneS5Q-1
Received: by mail-ej1-f69.google.com with SMTP id lb20-20020a1709077854b02904c5f93c0124so1973402ejc.14
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 12:29:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7POGsUdxxXzK+4ImUmkSrNYlLw4tFmtrg6J6zcZB3co=;
        b=eZCAmhPxRzw/GedmtfSSTdRfsyE8yAwBUakqDJUltHFavjXOTWUiN4kBsZ6c/dXCro
         bz2Ow6ZpOfwcT+0L1j/LbGdw7f2l12I7Zye9+d39KH8ckBKHipDDG8SBhNeYIhbxpdnn
         hcfqo7bCl53bnIp/o152A1Ptm5hgnx81+zzZ7jzKnoVGQw2SojhCM5oAeUHlQ/aW6IRT
         y2KBak15GIUJZAX05BZ6ppwldnVHnu30G4ZodJcCwZSWb3/qlUHhdwEMQcLZAmac/Rpo
         bg0vlWzbuBBn+r1LAtYj6OkNmiQXH/EFCBtKjgywQZ6nGN53D64ekX/gv0ub3FTNFM4U
         SSNw==
X-Gm-Message-State: AOAM530YVklbJYW9mYpUIIRRTEaSYYtqALaY0NXI8elfShgU+FojBoMH
        4DJ4NM22R0SzFL0VRHywGTCjz4zzQP136k5XbZ2jWB3T+bLoci3LoOQnZf9blcMFKcYzT9VbEle
        0wEUCIJecHgB24xDg
X-Received: by 2002:a17:906:3d3:: with SMTP id c19mr30851647eja.202.1624994995075;
        Tue, 29 Jun 2021 12:29:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw23NIpSXqFpaqDGHPNVNZiDYiZzRVkvF/Ui1ls7XbzLlUZgCjf3IWzZlcShrGYuCb8MruN3Q==
X-Received: by 2002:a17:906:3d3:: with SMTP id c19mr30851628eja.202.1624994994878;
        Tue, 29 Jun 2021 12:29:54 -0700 (PDT)
Received: from krava.redhat.com ([185.153.78.55])
        by smtp.gmail.com with ESMTPSA id n22sm472559eje.3.2021.06.29.12.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 12:29:54 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: [PATCH bpf-next 3/5] bpf: Add bpf_get_func_ip helper for tracing programs
Date:   Tue, 29 Jun 2021 21:29:43 +0200
Message-Id: <20210629192945.1071862-4-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210629192945.1071862-1-jolsa@kernel.org>
References: <20210629192945.1071862-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding bpf_get_func_ip helper for BPF_PROG_TYPE_TRACING programs,
specifically for all trampoline attach types.

The trampoline's caller IP address is stored in (ctx - 8) address.
so there's no reason to actually call the helper, but rather fixup
the call instruction and return [ctx - 8] value directly (suggested
by Alexei).

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/uapi/linux/bpf.h       |  7 +++++
 kernel/bpf/verifier.c          | 53 ++++++++++++++++++++++++++++++++++
 kernel/trace/bpf_trace.c       | 15 ++++++++++
 tools/include/uapi/linux/bpf.h |  7 +++++
 4 files changed, 82 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index bf9252c7381e..83e87ffdbb6e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4780,6 +4780,12 @@ union bpf_attr {
  * 		Execute close syscall for given FD.
  * 	Return
  * 		A syscall result.
+ *
+ * u64 bpf_get_func_ip(void *ctx)
+ * 	Description
+ * 		Get address of the traced function (for tracing programs).
+ * 	Return
+ * 		Address of the traced function.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -4951,6 +4957,7 @@ union bpf_attr {
 	FN(sys_bpf),			\
 	FN(btf_find_by_name_kind),	\
 	FN(sys_close),			\
+	FN(get_func_ip),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e04e33893cff..701ff7384fa7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5149,6 +5149,11 @@ static bool allow_tail_call_in_subprogs(struct bpf_verifier_env *env)
 	return env->prog->jit_requested && IS_ENABLED(CONFIG_X86_64);
 }
 
+static bool allow_get_func_ip_tracing(struct bpf_verifier_env *env)
+{
+	return env->prog->jit_requested && IS_ENABLED(CONFIG_X86_64);
+}
+
 static int check_map_func_compatibility(struct bpf_verifier_env *env,
 					struct bpf_map *map, int func_id)
 {
@@ -5955,6 +5960,32 @@ static int check_bpf_snprintf_call(struct bpf_verifier_env *env,
 	return err;
 }
 
+static bool has_get_func_ip(struct bpf_verifier_env *env)
+{
+	enum bpf_attach_type eatype = env->prog->expected_attach_type;
+	enum bpf_prog_type type = resolve_prog_type(env->prog);
+	int func_id = BPF_FUNC_get_func_ip;
+
+	if (type == BPF_PROG_TYPE_TRACING) {
+		if (eatype != BPF_TRACE_FENTRY && eatype != BPF_TRACE_FEXIT &&
+		    eatype != BPF_MODIFY_RETURN) {
+			verbose(env, "func %s#%d supported only for fentry/fexit/fmod_ret programs\n",
+				func_id_name(func_id), func_id);
+			return -ENOTSUPP;
+		}
+		if (!allow_get_func_ip_tracing(env)) {
+			verbose(env, "func %s#%d for tracing programs supported only for JITed x86_64\n",
+				func_id_name(func_id), func_id);
+			return -ENOTSUPP;
+		}
+		return 0;
+	}
+
+	verbose(env, "func %s#%d not supported for program type %d\n",
+		func_id_name(func_id), func_id, type);
+	return -ENOTSUPP;
+}
+
 static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 			     int *insn_idx_p)
 {
@@ -6225,6 +6256,12 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 	if (func_id == BPF_FUNC_get_stackid || func_id == BPF_FUNC_get_stack)
 		env->prog->call_get_stack = true;
 
+	if (func_id == BPF_FUNC_get_func_ip) {
+		if (has_get_func_ip(env))
+			return -ENOTSUPP;
+		env->prog->call_get_func_ip = true;
+	}
+
 	if (changes_data)
 		clear_all_pkt_pointers(env);
 	return 0;
@@ -12367,6 +12404,7 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 {
 	struct bpf_prog *prog = env->prog;
 	bool expect_blinding = bpf_jit_blinding_enabled(prog);
+	enum bpf_prog_type prog_type = resolve_prog_type(prog);
 	struct bpf_insn *insn = prog->insnsi;
 	const struct bpf_func_proto *fn;
 	const int insn_cnt = prog->len;
@@ -12700,6 +12738,21 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			continue;
 		}
 
+		/* Implement bpf_get_func_ip inline. */
+		if (prog_type == BPF_PROG_TYPE_TRACING &&
+		    insn->imm == BPF_FUNC_get_func_ip) {
+			/* Load IP address from ctx - 8 */
+			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
+
+			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 1);
+			if (!new_prog)
+				return -ENOMEM;
+
+			env->prog = prog = new_prog;
+			insn      = new_prog->insnsi + i + delta;
+			continue;
+		}
+
 patch_call_imm:
 		fn = env->ops->get_func_proto(insn->imm, env->prog);
 		/* all functions that have prototype and verifier allowed
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 64bd2d84367f..9edd3b1a00ad 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -948,6 +948,19 @@ const struct bpf_func_proto bpf_snprintf_btf_proto = {
 	.arg5_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_1(bpf_get_func_ip_tracing, void *, ctx)
+{
+	/* Stub, the helper call is inlined in the program. */
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_get_func_ip_proto_tracing = {
+	.func		= bpf_get_func_ip_tracing,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+};
+
 const struct bpf_func_proto *
 bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -1058,6 +1071,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_for_each_map_elem_proto;
 	case BPF_FUNC_snprintf:
 		return &bpf_snprintf_proto;
+	case BPF_FUNC_get_func_ip:
+		return &bpf_get_func_ip_proto_tracing;
 	default:
 		return NULL;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index bf9252c7381e..83e87ffdbb6e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4780,6 +4780,12 @@ union bpf_attr {
  * 		Execute close syscall for given FD.
  * 	Return
  * 		A syscall result.
+ *
+ * u64 bpf_get_func_ip(void *ctx)
+ * 	Description
+ * 		Get address of the traced function (for tracing programs).
+ * 	Return
+ * 		Address of the traced function.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -4951,6 +4957,7 @@ union bpf_attr {
 	FN(sys_bpf),			\
 	FN(btf_find_by_name_kind),	\
 	FN(sys_close),			\
+	FN(get_func_ip),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.31.1

