Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847A64A7248
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 14:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344556AbiBBNxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 08:53:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24964 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344585AbiBBNxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 08:53:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643810029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rU7PA92V+49dsAGPuIeIV/v8wUH1DOur5mrpoKB+KuE=;
        b=cgTxAVNu0LLLKKOb9cjJx4NK9B5frmjjS1H/jdtHijQfEgTbhFyUOr0ZTx8Qoy9mBQlDx0
        ZIj+P3NlPa9nampVnLrh3aBVzzwOEOEoqpvn5FsR+tnJLktuuKkYYYGyyyQlET3JRFCgwq
        aEptarO9NIbs/hSa8E/rciNYY4EPfhY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-482-ncnZ5SREN_GLuFwXqpIJYQ-1; Wed, 02 Feb 2022 08:53:48 -0500
X-MC-Unique: ncnZ5SREN_GLuFwXqpIJYQ-1
Received: by mail-ed1-f69.google.com with SMTP id p17-20020aa7c891000000b004052d1936a5so10443568eds.7
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 05:53:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rU7PA92V+49dsAGPuIeIV/v8wUH1DOur5mrpoKB+KuE=;
        b=scA9UXzNGaQWwPK9hPNEOhrVETOYL6YrFZWO6dSGeFwrkCLMVgLJRZOM7l0Hd1XTM5
         PUfdkW8s+fmfyFdLX1uSBMMg2+eQJsgwuYg2VWBWl1H0qnqfJ5iu/+XBT2VNY35/xu7s
         xDJxzHn4BOU2dNJaAcfCjWxCnBlnk9zbOL3cEXZOVntc5DGaXGgORU479cqqn/YvleT7
         ger6pes+tqjGaiqbceKboyeO/1BJ1CqwCxShXjMHxxp1w2w3gPkewob1xqrRjSb1YPUR
         EAMkJBGMtPVns4Q0XVbD+62pWD261tVrnzMMY3WX+Myz6PsqAmRvA9T9i+hw9P7rLFL6
         qQtQ==
X-Gm-Message-State: AOAM531iMzje1Xp6i91nWCqjJv5FsxeaFm4lY6cHFR/Ch/I7Xs18DdQX
        L+n9b7vtITTv4oB1CgwGthcxslczc5kGvEEemYdPtv1jHT0hX7bdb38S3rQUnZhqPllkWq/RP9h
        Js289qpoCeJd/AERc
X-Received: by 2002:a17:907:2ce1:: with SMTP id hz1mr19339598ejc.681.1643810027517;
        Wed, 02 Feb 2022 05:53:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwwQirmhCLHvQ2UdBTeDbmq1tdFdGGrZl5m4jins0KciHUjrD9AYG1LHNgFrDoNGbtQI+UUJg==
X-Received: by 2002:a17:907:2ce1:: with SMTP id hz1mr19339588ejc.681.1643810027285;
        Wed, 02 Feb 2022 05:53:47 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id by4sm2868404edb.107.2022.02.02.05.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 05:53:46 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <olsajiri@gmail.com>
Subject: [PATCH 2/8] bpf: Add bpf_get_func_ip kprobe helper for fprobe link
Date:   Wed,  2 Feb 2022 14:53:27 +0100
Message-Id: <20220202135333.190761-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202135333.190761-1-jolsa@kernel.org>
References: <20220202135333.190761-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to call get_func_ip_fprobe helper from kprobe
programs attached by fprobe link.

Also adding support to inline it, because it's single load
instruction.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/verifier.c    | 19 ++++++++++++++++++-
 kernel/trace/bpf_trace.c | 16 +++++++++++++++-
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1ae41d0cf96c..a745ded00635 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13625,7 +13625,7 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			continue;
 		}
 
-		/* Implement bpf_get_func_ip inline. */
+		/* Implement tracing bpf_get_func_ip inline. */
 		if (prog_type == BPF_PROG_TYPE_TRACING &&
 		    insn->imm == BPF_FUNC_get_func_ip) {
 			/* Load IP address from ctx - 16 */
@@ -13640,6 +13640,23 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			continue;
 		}
 
+		/* Implement kprobe/fprobe bpf_get_func_ip inline. */
+		if (prog_type == BPF_PROG_TYPE_KPROBE &&
+		    eatype == BPF_TRACE_FPROBE &&
+		    insn->imm == BPF_FUNC_get_func_ip) {
+			/* Load IP address from ctx (struct pt_regs) ip */
+			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
+						  offsetof(struct pt_regs, ip));
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
index a2024ba32a20..28e59e31e3db 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1036,6 +1036,19 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
 	.arg1_type	= ARG_PTR_TO_CTX,
 };
 
+BPF_CALL_1(bpf_get_func_ip_fprobe, struct pt_regs *, regs)
+{
+	/* This helper call is inlined by verifier. */
+	return regs->ip;
+}
+
+static const struct bpf_func_proto bpf_get_func_ip_proto_fprobe = {
+	.func		= bpf_get_func_ip_fprobe,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+};
+
 BPF_CALL_1(bpf_get_attach_cookie_trace, void *, ctx)
 {
 	struct bpf_trace_run_ctx *run_ctx;
@@ -1279,7 +1292,8 @@ kprobe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_override_return_proto;
 #endif
 	case BPF_FUNC_get_func_ip:
-		return &bpf_get_func_ip_proto_kprobe;
+		return prog->expected_attach_type == BPF_TRACE_FPROBE ?
+			&bpf_get_func_ip_proto_fprobe : &bpf_get_func_ip_proto_kprobe;
 	case BPF_FUNC_get_attach_cookie:
 		return &bpf_get_attach_cookie_proto_trace;
 	default:
-- 
2.34.1

