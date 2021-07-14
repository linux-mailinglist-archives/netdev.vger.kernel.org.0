Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F55C3C81F1
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 11:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238960AbhGNJrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 05:47:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26848 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238840AbhGNJrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 05:47:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626255870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pq7O3qLWv1NvU3TCdeEA06tLOllu2YQ+xJvUQBt7sDQ=;
        b=WX/7lBQAkmJc30Ow3+WgGQR+3f1R3fiml4GLoW8/YqrdTFqJMRuHMhNW2rtZT0mJJCGmm2
        EpdWP8pEyUoQxxnD4ZaFBHzTn1c7Z/Gaq5St2PafN7IGdcaDA5aqkSaytPEcVjz5HY7q2T
        8rvlpKfnzHNS0tmovOfYTn9scK+nBLg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-VBAaEF_HNj2a-MI739vNDw-1; Wed, 14 Jul 2021 05:44:29 -0400
X-MC-Unique: VBAaEF_HNj2a-MI739vNDw-1
Received: by mail-wm1-f69.google.com with SMTP id m40-20020a05600c3b28b02901f42375a73fso567515wms.5
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 02:44:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pq7O3qLWv1NvU3TCdeEA06tLOllu2YQ+xJvUQBt7sDQ=;
        b=oEw2SyTkrNWCLUBuzNrvYDXpU5wLQuHCT/qdOQEVz2eVh+Fuwm8Vf5gcR66B3mYPoc
         waesMzN8M0f8SHbIDHU7Lrqw4xcTyQ/K2eL52i+KD0ihgQmBJCg6Kudnna/AkbjhIoNz
         G5zi7xHrAxf2Lb1FqUYIYAYCSxbGP1LeMI5LUqJl3zGW+jd6Q75TOl2wynXTvsZAHJIJ
         les4CGXh5dc9R/SqB1tm+duGtsq5zJl8yxgnWFWEiG/h1vpTSnxy9wwzYTS2aQY1qxhv
         NUOZN5CEGHXSUn28vCTQCCUUEikLNHOPt1cGHvsAyhJtqsL/UVcwRPKLeTLs1w25XNFk
         /Jiw==
X-Gm-Message-State: AOAM5306HvpWByMnz9CNoJ/JlTcmojo2zNNr/F0bIs9Vq9Ek48RjC98T
        oyqEwCjVK1NzwjHyTPAqldVZBsfjeAMQd5mftQ4UYhcNa5ursuRu/qcx8ZW6EeY0LsAnW1nG7Gd
        JqM2iLzFqw4ViovPj
X-Received: by 2002:adf:8061:: with SMTP id 88mr11646712wrk.233.1626255868078;
        Wed, 14 Jul 2021 02:44:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxeG4DFtzNV4k4TT3JKbi+8jlcLFEkDDmoKnXC4YNGqchGBzeXmFlL25HZ/PKSnoVcVpOGN/g==
X-Received: by 2002:adf:8061:: with SMTP id 88mr11646678wrk.233.1626255867907;
        Wed, 14 Jul 2021 02:44:27 -0700 (PDT)
Received: from krava.redhat.com ([5.171.203.6])
        by smtp.gmail.com with ESMTPSA id v30sm2083621wrv.85.2021.07.14.02.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 02:44:27 -0700 (PDT)
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
Subject: [PATCHv4 bpf-next 3/8] bpf: Add bpf_get_func_ip helper for tracing programs
Date:   Wed, 14 Jul 2021 11:43:55 +0200
Message-Id: <20210714094400.396467-4-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210714094400.396467-1-jolsa@kernel.org>
References: <20210714094400.396467-1-jolsa@kernel.org>
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
 include/uapi/linux/bpf.h       |  7 ++++++
 kernel/bpf/verifier.c          | 43 ++++++++++++++++++++++++++++++++++
 kernel/trace/bpf_trace.c       | 15 ++++++++++++
 tools/include/uapi/linux/bpf.h |  7 ++++++
 4 files changed, 72 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b46a383e8db7..31dd386b64ec 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4777,6 +4777,12 @@ union bpf_attr {
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
@@ -4948,6 +4954,7 @@ union bpf_attr {
 	FN(sys_bpf),			\
 	FN(btf_find_by_name_kind),	\
 	FN(sys_close),			\
+	FN(get_func_ip),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index be38bb930bf1..d27aa23fb572 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5955,6 +5955,27 @@ static int check_bpf_snprintf_call(struct bpf_verifier_env *env,
 	return err;
 }
 
+static int check_get_func_ip(struct bpf_verifier_env *env)
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
@@ -6225,6 +6246,12 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 	if (func_id == BPF_FUNC_get_stackid || func_id == BPF_FUNC_get_stack)
 		env->prog->call_get_stack = true;
 
+	if (func_id == BPF_FUNC_get_func_ip) {
+		if (check_get_func_ip(env))
+			return -ENOTSUPP;
+		env->prog->call_get_func_ip = true;
+	}
+
 	if (changes_data)
 		clear_all_pkt_pointers(env);
 	return 0;
@@ -12369,6 +12396,7 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 {
 	struct bpf_prog *prog = env->prog;
 	bool expect_blinding = bpf_jit_blinding_enabled(prog);
+	enum bpf_prog_type prog_type = resolve_prog_type(prog);
 	struct bpf_insn *insn = prog->insnsi;
 	const struct bpf_func_proto *fn;
 	const int insn_cnt = prog->len;
@@ -12702,6 +12730,21 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
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
index 64bd2d84367f..022cbe42ac57 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -948,6 +948,19 @@ const struct bpf_func_proto bpf_snprintf_btf_proto = {
 	.arg5_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_1(bpf_get_func_ip_tracing, void *, ctx)
+{
+	/* This helper call is inlined by verifier. */
+	return ((u64 *)ctx)[-1];
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

