Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE9E3BF191
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 23:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbhGGVvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 17:51:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21517 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232065AbhGGVvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 17:51:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625694507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FQtsSphgnYl9qFWBMJGlJNrhM3rcnyrmEFUQ3XZzsHM=;
        b=H+8DEv4Tgf4o1wOnSTMF3pGxPfT/nMkGNJ9vWRj76NEZStIKrPdTQlBIOz1wEBTzm7+/hu
        kAw0zAmi9TrCThPSUUp87QQbDxCRVp/qO72jY8bw5il0Mu6uchAsQjIa58TVY0D83Fiogx
        2hPBDorzBaYe4XK5zvlItFHXyGQapdE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-tj4gC-KdNFORnT-vXjTOkw-1; Wed, 07 Jul 2021 17:48:26 -0400
X-MC-Unique: tj4gC-KdNFORnT-vXjTOkw-1
Received: by mail-wr1-f69.google.com with SMTP id j1-20020adfb3010000b02901232ed22e14so1185964wrd.5
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 14:48:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FQtsSphgnYl9qFWBMJGlJNrhM3rcnyrmEFUQ3XZzsHM=;
        b=refS7D4M4R33LA6VG8r1I+FFsl/ziI/Q0Jwjg7hBaMRAQxhshLBlzngUvWY6cZlWu1
         Z1ejD1rKjKkF7GcgoqCbGWGlkOIUY7qgMCXVKRrmbYEJwAWRO+hf/F+BL8g80apz4bZU
         zp7RDAiAnnD8/cVb14QToa13/857s4OyQy+WHKGOuDoHkJvBWJwxsDzn5VypkYJXvWau
         wTUisNu44Ii43mFo+ko0oyKxdl20JWQeHXdzSNK9kPGyfTWP45yQd0vWNeHY3tYBXqbx
         wBmru7+SFpMDetnKRgXh46EgAqWf3wLHMfrX8gX46Ni49vJsu8HCb38CsYLhwbbBD2ML
         Qgqw==
X-Gm-Message-State: AOAM53032JmSJp0heD4V6GZFgbhF1c+AtbAuuN5967loWSs94br6ILsZ
        jdGTzoubK17gdN5kcGGhhjpfTCwhC0HcJK/rQMxVx7OjiRxWRcHoONjVBSsFUux7H/ZsKtAgDHl
        yC2BVN1SsSDJF+wyj
X-Received: by 2002:a7b:c40d:: with SMTP id k13mr29429803wmi.97.1625694505314;
        Wed, 07 Jul 2021 14:48:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx5550/Ol6QmHMH+/kX6iFJFZwn2w34mju8EOtgfB02HXSUyWqItABbxMNPOlFsZM17sDsXGw==
X-Received: by 2002:a7b:c40d:: with SMTP id k13mr29429780wmi.97.1625694505151;
        Wed, 07 Jul 2021 14:48:25 -0700 (PDT)
Received: from krava.redhat.com ([185.153.78.55])
        by smtp.gmail.com with ESMTPSA id u15sm7534378wmq.48.2021.07.07.14.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 14:48:24 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCHv3 bpf-next 3/7] bpf: Add bpf_get_func_ip helper for tracing programs
Date:   Wed,  7 Jul 2021 23:47:47 +0200
Message-Id: <20210707214751.159713-4-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210707214751.159713-1-jolsa@kernel.org>
References: <20210707214751.159713-1-jolsa@kernel.org>
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

[fixed has_get_func_ip wrong return type]
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
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
index be38bb930bf1..f975a3aa9368 100644
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
 
+static int has_get_func_ip(struct bpf_verifier_env *env)
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
@@ -12369,6 +12406,7 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 {
 	struct bpf_prog *prog = env->prog;
 	bool expect_blinding = bpf_jit_blinding_enabled(prog);
+	enum bpf_prog_type prog_type = resolve_prog_type(prog);
 	struct bpf_insn *insn = prog->insnsi;
 	const struct bpf_func_proto *fn;
 	const int insn_cnt = prog->len;
@@ -12702,6 +12740,21 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
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

