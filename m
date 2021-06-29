Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCD73B78AC
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 21:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235153AbhF2Tcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 15:32:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29481 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235069AbhF2Tca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 15:32:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624995002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OGsWiBOuAVqf4btUf4cftMKBn0bF9gV/Gnv0HJUJGi8=;
        b=PnveN+0jl4IKAbcAY7ClWpxtFdBCgT+JsAZPi2WKWX1soVPJp2dE7UtlRg7p2fsBRXG+CQ
        XMFDzVr1wYbq/UQXLte3i5beUZF2fzwxAnFXn/R6Ix57BaNC6ET8BLgMASIvkKyHDTU9qD
        QM4cirCPW2MBMKP6KgdIZxcMcP59oEY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-PmI-xmFGNl6dmWpSNugVag-1; Tue, 29 Jun 2021 15:30:01 -0400
X-MC-Unique: PmI-xmFGNl6dmWpSNugVag-1
Received: by mail-ed1-f71.google.com with SMTP id dy23-20020a05640231f7b0290394996f1452so12090319edb.18
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 12:29:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OGsWiBOuAVqf4btUf4cftMKBn0bF9gV/Gnv0HJUJGi8=;
        b=VE74LYgXko1pC2G7NiuVoV4Fc3Ua2YdDOjgRI4jxqryJA3pkiDN12+1foB/Y7pWFlL
         HKOIu7LBTe/9BvlDKkL92v7wmcuqQoDeVN1zZlt4yk60F8aI8NBm9CxeajZmYJbKyxYe
         OzzqZO8VcwmUCTGhgL8WaXrFq2Dlkw126fMi5/eVKc1CesUtaaw4Wl93yLLu0U6RqfSI
         dIxuptOg7Dna2mJAXCOhap/ruLcnZnYhrgIEpt96b/pIyIFNSQmSXcdp2V+YWban9pb+
         OkiStiGEoPPJdcly54zMMWpRXznCTqVDK+bNQw/mI754xfV6tbmV6qZZEezmDhlTy/YI
         eLMg==
X-Gm-Message-State: AOAM532zEK5kDFsoFj1DJMht7Kv+hfbz2XnzOk2L5ySYfEImgSYVpt71
        okeVP2OMrxBgCcZxeaKGWXw9bhwjwvHm7AIpQEQLSpIyTuGj3Ft6WuLVsliU93Mz7N5WFSHPfAJ
        Fpzj6AB4Gpr2cFKsH
X-Received: by 2002:a17:906:4d99:: with SMTP id s25mr28229222eju.349.1624994996597;
        Tue, 29 Jun 2021 12:29:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWtTBoRXPMKCr1KyV2AoM6ZTq/GwiLioCcV0nux5msmh3rBiUzFuwNQgLyVEVrtLD951GCgg==
X-Received: by 2002:a17:906:4d99:: with SMTP id s25mr28229209eju.349.1624994996411;
        Tue, 29 Jun 2021 12:29:56 -0700 (PDT)
Received: from krava.redhat.com ([185.153.78.55])
        by smtp.gmail.com with ESMTPSA id n22sm472559eje.3.2021.06.29.12.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 12:29:56 -0700 (PDT)
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
Subject: [PATCH bpf-next 4/5] bpf: Add bpf_get_func_ip helper for kprobe programs
Date:   Tue, 29 Jun 2021 21:29:44 +0200
Message-Id: <20210629192945.1071862-5-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210629192945.1071862-1-jolsa@kernel.org>
References: <20210629192945.1071862-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding bpf_get_func_ip helper for BPF_PROG_TYPE_KPROBE programs,
so it's now possible to call bpf_get_func_ip from both kprobe and
kretprobe programs.

Taking the caller's address from 'struct kprobe::addr', which is
defined for both kprobe and kretprobe.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/uapi/linux/bpf.h       |  2 +-
 kernel/bpf/verifier.c          |  2 ++
 kernel/trace/bpf_trace.c       | 14 ++++++++++++++
 kernel/trace/trace_kprobe.c    | 20 ++++++++++++++++++--
 kernel/trace/trace_probe.h     |  5 +++++
 tools/include/uapi/linux/bpf.h |  2 +-
 6 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 83e87ffdbb6e..4894f99a1993 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4783,7 +4783,7 @@ union bpf_attr {
  *
  * u64 bpf_get_func_ip(void *ctx)
  * 	Description
- * 		Get address of the traced function (for tracing programs).
+ * 		Get address of the traced function (for tracing and kprobe programs).
  * 	Return
  * 		Address of the traced function.
  */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 701ff7384fa7..b66e0a7104f8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5979,6 +5979,8 @@ static bool has_get_func_ip(struct bpf_verifier_env *env)
 			return -ENOTSUPP;
 		}
 		return 0;
+	} else if (type == BPF_PROG_TYPE_KPROBE) {
+		return 0;
 	}
 
 	verbose(env, "func %s#%d not supported for program type %d\n",
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 9edd3b1a00ad..1a5bddce9abd 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -961,6 +961,18 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_tracing = {
 	.arg1_type	= ARG_PTR_TO_CTX,
 };
 
+BPF_CALL_1(bpf_get_func_ip_kprobe, struct pt_regs *, regs)
+{
+	return trace_current_kprobe_addr();
+}
+
+static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
+	.func		= bpf_get_func_ip_kprobe,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+};
+
 const struct bpf_func_proto *
 bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -1092,6 +1104,8 @@ kprobe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_override_return:
 		return &bpf_override_return_proto;
 #endif
+	case BPF_FUNC_get_func_ip:
+		return &bpf_get_func_ip_proto_kprobe;
 	default:
 		return bpf_tracing_func_proto(func_id, prog);
 	}
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index ea6178cb5e33..b07d5888db14 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1570,6 +1570,18 @@ static int kretprobe_event_define_fields(struct trace_event_call *event_call)
 }
 
 #ifdef CONFIG_PERF_EVENTS
+/* Used by bpf get_func_ip helper */
+DEFINE_PER_CPU(u64, current_kprobe_addr) = 0;
+
+u64 trace_current_kprobe_addr(void)
+{
+	return *this_cpu_ptr(&current_kprobe_addr);
+}
+
+static void trace_current_kprobe_set(struct trace_kprobe *tk)
+{
+	__this_cpu_write(current_kprobe_addr, (u64) tk->rp.kp.addr);
+}
 
 /* Kprobe profile handler */
 static int
@@ -1585,6 +1597,7 @@ kprobe_perf_func(struct trace_kprobe *tk, struct pt_regs *regs)
 		unsigned long orig_ip = instruction_pointer(regs);
 		int ret;
 
+		trace_current_kprobe_set(tk);
 		ret = trace_call_bpf(call, regs);
 
 		/*
@@ -1631,8 +1644,11 @@ kretprobe_perf_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
 	int size, __size, dsize;
 	int rctx;
 
-	if (bpf_prog_array_valid(call) && !trace_call_bpf(call, regs))
-		return;
+	if (bpf_prog_array_valid(call)) {
+		trace_current_kprobe_set(tk);
+		if (!trace_call_bpf(call, regs))
+			return;
+	}
 
 	head = this_cpu_ptr(call->perf_events);
 	if (hlist_empty(head))
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 227d518e5ba5..19c979834916 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -199,6 +199,7 @@ DECLARE_BASIC_PRINT_TYPE_FUNC(symbol);
 #ifdef CONFIG_KPROBE_EVENTS
 bool trace_kprobe_on_func_entry(struct trace_event_call *call);
 bool trace_kprobe_error_injectable(struct trace_event_call *call);
+u64 trace_current_kprobe_addr(void);
 #else
 static inline bool trace_kprobe_on_func_entry(struct trace_event_call *call)
 {
@@ -209,6 +210,10 @@ static inline bool trace_kprobe_error_injectable(struct trace_event_call *call)
 {
 	return false;
 }
+static inline u64 trace_current_kprobe_addr(void)
+{
+	return 0;
+}
 #endif /* CONFIG_KPROBE_EVENTS */
 
 struct probe_arg {
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 83e87ffdbb6e..4894f99a1993 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4783,7 +4783,7 @@ union bpf_attr {
  *
  * u64 bpf_get_func_ip(void *ctx)
  * 	Description
- * 		Get address of the traced function (for tracing programs).
+ * 		Get address of the traced function (for tracing and kprobe programs).
  * 	Return
  * 		Address of the traced function.
  */
-- 
2.31.1

