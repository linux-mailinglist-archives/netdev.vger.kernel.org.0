Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E53253EC35
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238974AbiFFN2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 09:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238969AbiFFN2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 09:28:13 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3BE27FF4;
        Mon,  6 Jun 2022 06:28:12 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id d6so1108422ilm.4;
        Mon, 06 Jun 2022 06:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vMzKJ/pAxxp57ZRIpF3s0dQuSBrLlmQcoV9kqSPPIIg=;
        b=Xi/hphIpGKx+QJ1uQpR1Ctr88s4lQXNdKZ9YsAXjAfkaj/fW943LTMDSNgT2AztgRR
         +N/fk+7VyuyyomkXaOxk9bh/0+KNCLNTnordoCgehaA0q4qMnyhhE/vGqUsDybjQWDEQ
         tqhwOiTHKzDyFo7gJJwyCmzpXgSJfOuHuuj2ZNntusX63GLuoVtvtQrYBVTpT2C1ZciX
         4XUHpy2sJVQEFCSP9ceTKuINYth23q7Tu/pFCtVi1Tt9dxw6VUDcrKx7NmI4KvZjrxDe
         FA5oBFwV8rgaRl5g9O8BMz7R4VxBVqJpPErZeMLoaGdDjrE8+xVdeRvnP4/U4wo5KEMA
         OXtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vMzKJ/pAxxp57ZRIpF3s0dQuSBrLlmQcoV9kqSPPIIg=;
        b=rjbF3FbsWpHhnqbfT3JHYflID1A0ol4ahZISYA0VlfENVsxKkBmKpM54gJ8xST6UVy
         51roazrqcQhCErhVgBoiDSg9cUTYsHwzduHWo3Or5+LlSzPt9aBzKWfZSgzDgegFT56F
         ihAIlOSHZNHbmf0MOnt5tmbCULKvNfzb2PHXxdU3prfGqg+ypxCN/QGyLUdDMMokKQwm
         k+ebiatuT1JK8CJ95VopKinEkM9mJxhAS46Rb92UyyxdJc0CUGpHOttngokbIEuTexYg
         PkxEl0hH95Vo2JONw++s9F5TyDlcNxGpRYkRGcDm20/H4R5T2JvUdv6xP8LWCpgTzR08
         WjbA==
X-Gm-Message-State: AOAM531zbBkfSYtAZ+nnZP7woP0ZwovAJb99ZwlPqzRY56FqF3LmRdSp
        107NZhIw5ZWgAPMhd4qVFucLXW2vFapJIg==
X-Google-Smtp-Source: ABdhPJx+oYqz3OZuyeQCK75PBjZdLqSzMEYQSkMj/aBcYrp8SQMdD7oDbd+GePN91U14HIzadY0Tqw==
X-Received: by 2002:a05:6e02:15ca:b0:2d1:9146:c79a with SMTP id q10-20020a056e0215ca00b002d19146c79amr14022665ilu.97.1654522091303;
        Mon, 06 Jun 2022 06:28:11 -0700 (PDT)
Received: from james-x399.localdomain (71-218-113-86.hlrn.qwest.net. [71.218.113.86])
        by smtp.gmail.com with ESMTPSA id q2-20020a056e020c2200b002d546bec2f6sm479474ilg.67.2022.06.06.06.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 06:28:10 -0700 (PDT)
From:   James Hilliard <james.hilliard1@gmail.com>
To:     bpf@vger.kernel.org
Cc:     James Hilliard <james.hilliard1@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        netdev@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/1] libbpf: fix broken gcc pragma macros in bpf_helpers.h/bpf_tracing.h
Date:   Mon,  6 Jun 2022 07:27:40 -0600
Message-Id: <20220606132741.3462925-1-james.hilliard1@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems the gcc preprocessor breaks unless pragmas are wrapped
individually inside macros.

Fixes errors like:
error: expected identifier or '(' before '#pragma'
  106 | SEC("cgroup/bind6")
      | ^~~

error: expected '=', ',', ';', 'asm' or '__attribute__' before '#pragma'
  114 | char _license[] SEC("license") = "GPL";
      | ^~~

Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
---
 tools/lib/bpf/bpf_helpers.h | 26 ++++++++++++++------------
 tools/lib/bpf/bpf_tracing.h | 26 ++++++++++++++------------
 2 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index fb04eaf367f1..6d159082727d 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -22,11 +22,13 @@
  * To allow use of SEC() with externs (e.g., for extern .maps declarations),
  * make sure __attribute__((unused)) doesn't trigger compilation warning.
  */
+#define __gcc_helpers_pragma(x) _Pragma(#x)
+#define __gcc_helpers_diag_pragma(x) __gcc_helpers_pragma("GCC diagnostic " #x)
 #define SEC(name) \
-	_Pragma("GCC diagnostic push")					    \
-	_Pragma("GCC diagnostic ignored \"-Wignored-attributes\"")	    \
+	__gcc_helpers_diag_pragma(push)					    \
+	__gcc_helpers_diag_pragma(ignored "-Wignored-attributes")	    \
 	__attribute__((section(name), used))				    \
-	_Pragma("GCC diagnostic pop")					    \
+	__gcc_helpers_diag_pragma(pop)
 
 /* Avoid 'linux/stddef.h' definition of '__always_inline'. */
 #undef __always_inline
@@ -215,10 +217,10 @@ enum libbpf_tristate {
 	static const char ___fmt[] = fmt;			\
 	unsigned long long ___param[___bpf_narg(args)];		\
 								\
-	_Pragma("GCC diagnostic push")				\
-	_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")	\
+	__gcc_helpers_diag_pragma(push)				\
+	__gcc_helpers_diag_pragma(ignored "-Wint-conversion")	\
 	___bpf_fill(___param, args);				\
-	_Pragma("GCC diagnostic pop")				\
+	__gcc_helpers_diag_pragma(pop)				\
 								\
 	bpf_seq_printf(seq, ___fmt, sizeof(___fmt),		\
 		       ___param, sizeof(___param));		\
@@ -233,10 +235,10 @@ enum libbpf_tristate {
 	static const char ___fmt[] = fmt;			\
 	unsigned long long ___param[___bpf_narg(args)];		\
 								\
-	_Pragma("GCC diagnostic push")				\
-	_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")	\
+	__gcc_helpers_diag_pragma(push)				\
+	__gcc_helpers_diag_pragma(ignored "-Wint-conversion")	\
 	___bpf_fill(___param, args);				\
-	_Pragma("GCC diagnostic pop")				\
+	__gcc_helpers_diag_pragma(pop)				\
 								\
 	bpf_snprintf(out, out_size, ___fmt,			\
 		     ___param, sizeof(___param));		\
@@ -264,10 +266,10 @@ enum libbpf_tristate {
 	static const char ___fmt[] = fmt;			\
 	unsigned long long ___param[___bpf_narg(args)];		\
 								\
-	_Pragma("GCC diagnostic push")				\
-	_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")	\
+	__gcc_helpers_diag_pragma(push)				\
+	__gcc_helpers_diag_pragma(ignored "-Wint-conversion")	\
 	___bpf_fill(___param, args);				\
-	_Pragma("GCC diagnostic pop")				\
+	__gcc_helpers_diag_pragma(pop)				\
 								\
 	bpf_trace_vprintk(___fmt, sizeof(___fmt),		\
 			  ___param, sizeof(___param));		\
diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index 01ce121c302d..e08ffc290b3e 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -422,16 +422,18 @@ struct pt_regs;
  * This is useful when using BPF helpers that expect original context
  * as one of the parameters (e.g., for bpf_perf_event_output()).
  */
+#define __gcc_tracing_pragma(x) _Pragma(#x)
+#define __gcc_tracing_diag_pragma(x) __gcc_tracing_pragma("GCC diagnostic " #x)
 #define BPF_PROG(name, args...)						    \
 name(unsigned long long *ctx);						    \
 static __attribute__((always_inline)) typeof(name(0))			    \
 ____##name(unsigned long long *ctx, ##args);				    \
 typeof(name(0)) name(unsigned long long *ctx)				    \
 {									    \
-	_Pragma("GCC diagnostic push")					    \
-	_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")		    \
+	__gcc_tracing_diag_pragma(push)					    \
+	__gcc_tracing_diag_pragma(ignored "-Wint-conversion")		    \
 	return ____##name(___bpf_ctx_cast(args));			    \
-	_Pragma("GCC diagnostic pop")					    \
+	__gcc_tracing_diag_pragma(pop)					    \
 }									    \
 static __attribute__((always_inline)) typeof(name(0))			    \
 ____##name(unsigned long long *ctx, ##args)
@@ -462,10 +464,10 @@ static __attribute__((always_inline)) typeof(name(0))			    \
 ____##name(struct pt_regs *ctx, ##args);				    \
 typeof(name(0)) name(struct pt_regs *ctx)				    \
 {									    \
-	_Pragma("GCC diagnostic push")					    \
-	_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")		    \
+	__gcc_tracing_diag_pragma(push)					    \
+	__gcc_tracing_diag_pragma(ignored "-Wint-conversion")		    \
 	return ____##name(___bpf_kprobe_args(args));			    \
-	_Pragma("GCC diagnostic pop")					    \
+	__gcc_tracing_diag_pragma(pop)					    \
 }									    \
 static __attribute__((always_inline)) typeof(name(0))			    \
 ____##name(struct pt_regs *ctx, ##args)
@@ -486,10 +488,10 @@ static __attribute__((always_inline)) typeof(name(0))			    \
 ____##name(struct pt_regs *ctx, ##args);				    \
 typeof(name(0)) name(struct pt_regs *ctx)				    \
 {									    \
-	_Pragma("GCC diagnostic push")					    \
-	_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")		    \
+	__gcc_tracing_diag_pragma(push)					    \
+	__gcc_tracing_diag_pragma(ignored "-Wint-conversion")		    \
 	return ____##name(___bpf_kretprobe_args(args));			    \
-	_Pragma("GCC diagnostic pop")					    \
+	__gcc_tracing_diag_pragma(pop)					    \
 }									    \
 static __always_inline typeof(name(0)) ____##name(struct pt_regs *ctx, ##args)
 
@@ -520,10 +522,10 @@ ____##name(struct pt_regs *ctx, ##args);				    \
 typeof(name(0)) name(struct pt_regs *ctx)				    \
 {									    \
 	struct pt_regs *regs = PT_REGS_SYSCALL_REGS(ctx);		    \
-	_Pragma("GCC diagnostic push")					    \
-	_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")		    \
+	__gcc_tracing_diag_pragma(push)		    \
+	__gcc_tracing_diag_pragma(ignored "-Wint-conversion")		    \
 	return ____##name(___bpf_syscall_args(args));			    \
-	_Pragma("GCC diagnostic pop")					    \
+	__gcc_tracing_diag_pragma(pop)					    \
 }									    \
 static __attribute__((always_inline)) typeof(name(0))			    \
 ____##name(struct pt_regs *ctx, ##args)
-- 
2.25.1

