Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90DD91749FF
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 00:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbgB2XLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 18:11:32 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26386 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727508AbgB2XLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 18:11:30 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 01TN8dMm029489
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 15:11:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=c3tBeqkhqMA4CnmxPwVSKiw7Hu1JEfs75GX3yfH7BAE=;
 b=oHXVonj9Flutnpj7RGDy0zIrqK1OQ+gHN9qfhdmCtWUbXHtTPVRdmpCYw0kypWFzAACw
 ewZhd4ELBFIidOh8VgSk4ZjWPmjAOdUkps+OqKFfTzTEOTC4KhY7rD9NV9saJmUxzzZP
 dHHTD0vnDXLyBCzGhc9jdZzFB3ODMXEBqJE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2yfmguj7h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 15:11:28 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sat, 29 Feb 2020 15:11:27 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 703372EC2C66; Sat, 29 Feb 2020 15:11:23 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 4/4] libbpf: merge selftests' bpf_trace_helpers.h into libbpf's bpf_tracing.h
Date:   Sat, 29 Feb 2020 15:11:12 -0800
Message-ID: <20200229231112.1240137-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200229231112.1240137-1-andriin@fb.com>
References: <20200229231112.1240137-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-29_09:2020-02-28,2020-02-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 clxscore=1015 malwarescore=0 suspectscore=8 impostorscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002290180
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move BPF_PROG, BPF_KPROBE, and BPF_KRETPROBE macro into libbpf's bpf_tracing.h
header to make it available for non-selftests users.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf_tracing.h                   | 118 +++++++++++++++++
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |   2 +-
 .../testing/selftests/bpf/bpf_trace_helpers.h | 121 ------------------
 tools/testing/selftests/bpf/progs/bpf_dctcp.c |   2 +-
 .../testing/selftests/bpf/progs/fentry_test.c |   2 +-
 .../selftests/bpf/progs/fexit_bpf2bpf.c       |   2 +-
 .../bpf/progs/fexit_bpf2bpf_simple.c          |   2 +-
 .../testing/selftests/bpf/progs/fexit_test.c  |   2 +-
 tools/testing/selftests/bpf/progs/kfree_skb.c |   2 +-
 .../selftests/bpf/progs/test_attach_probe.c   |   2 +-
 .../selftests/bpf/progs/test_overhead.c       |   1 -
 .../selftests/bpf/progs/test_perf_branches.c  |   2 +-
 .../selftests/bpf/progs/test_perf_buffer.c    |   2 +-
 .../selftests/bpf/progs/test_probe_user.c     |   1 -
 .../bpf/progs/test_trampoline_count.c         |   3 +-
 .../selftests/bpf/progs/test_xdp_bpf2bpf.c    |   2 +-
 16 files changed, 131 insertions(+), 135 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/bpf_trace_helpers.h

diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index 8376f22b0e36..379d03b211ea 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -192,4 +192,122 @@ struct pt_regs;
 			  (void *)(PT_REGS_FP(ctx) + sizeof(ip))); })
 #endif
 
+#define ___bpf_concat(a, b) a ## b
+#define ___bpf_apply(fn, n) ___bpf_concat(fn, n)
+#define ___bpf_nth(_, _1, _2, _3, _4, _5, _6, _7, _8, _9, _a, _b, _c, N, ...) N
+#define ___bpf_narg(...) \
+	___bpf_nth(_, ##__VA_ARGS__, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0)
+#define ___bpf_empty(...) \
+	___bpf_nth(_, ##__VA_ARGS__, N, N, N, N, N, N, N, N, N, N, 0)
+
+#define ___bpf_ctx_cast0() ctx
+#define ___bpf_ctx_cast1(x) ___bpf_ctx_cast0(), (void *)ctx[0]
+#define ___bpf_ctx_cast2(x, args...) ___bpf_ctx_cast1(args), (void *)ctx[1]
+#define ___bpf_ctx_cast3(x, args...) ___bpf_ctx_cast2(args), (void *)ctx[2]
+#define ___bpf_ctx_cast4(x, args...) ___bpf_ctx_cast3(args), (void *)ctx[3]
+#define ___bpf_ctx_cast5(x, args...) ___bpf_ctx_cast4(args), (void *)ctx[4]
+#define ___bpf_ctx_cast6(x, args...) ___bpf_ctx_cast5(args), (void *)ctx[5]
+#define ___bpf_ctx_cast7(x, args...) ___bpf_ctx_cast6(args), (void *)ctx[6]
+#define ___bpf_ctx_cast8(x, args...) ___bpf_ctx_cast7(args), (void *)ctx[7]
+#define ___bpf_ctx_cast9(x, args...) ___bpf_ctx_cast8(args), (void *)ctx[8]
+#define ___bpf_ctx_cast10(x, args...) ___bpf_ctx_cast9(args), (void *)ctx[9]
+#define ___bpf_ctx_cast11(x, args...) ___bpf_ctx_cast10(args), (void *)ctx[10]
+#define ___bpf_ctx_cast12(x, args...) ___bpf_ctx_cast11(args), (void *)ctx[11]
+#define ___bpf_ctx_cast(args...) \
+	___bpf_apply(___bpf_ctx_cast, ___bpf_narg(args))(args)
+
+/*
+ * BPF_PROG is a convenience wrapper for generic tp_btf/fentry/fexit and
+ * similar kinds of BPF programs, that accept input arguments as a single
+ * pointer to untyped u64 array, where each u64 can actually be a typed
+ * pointer or integer of different size. Instead of requring user to write
+ * manual casts and work with array elements by index, BPF_PROG macro
+ * allows user to declare a list of named and typed input arguments in the
+ * same syntax as for normal C function. All the casting is hidden and
+ * performed transparently, while user code can just assume working with
+ * function arguments of specified type and name.
+ *
+ * Original raw context argument is preserved as well as 'ctx' argument.
+ * This is useful when using BPF helpers that expect original context
+ * as one of the parameters (e.g., for bpf_perf_event_output()).
+ */
+#define BPF_PROG(name, args...)						    \
+name(unsigned long long *ctx);						    \
+static __attribute__((always_inline)) typeof(name(0))			    \
+____##name(unsigned long long *ctx, ##args);				    \
+typeof(name(0)) name(unsigned long long *ctx)				    \
+{									    \
+	_Pragma("GCC diagnostic push")					    \
+	_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")		    \
+	return ____##name(___bpf_ctx_cast(args));			    \
+	_Pragma("GCC diagnostic pop")					    \
+}									    \
+static __attribute__((always_inline)) typeof(name(0))			    \
+____##name(unsigned long long *ctx, ##args)
+
+struct pt_regs;
+
+#define ___bpf_kprobe_args0() ctx
+#define ___bpf_kprobe_args1(x) \
+	___bpf_kprobe_args0(), (void *)PT_REGS_PARM1(ctx)
+#define ___bpf_kprobe_args2(x, args...) \
+	___bpf_kprobe_args1(args), (void *)PT_REGS_PARM2(ctx)
+#define ___bpf_kprobe_args3(x, args...) \
+	___bpf_kprobe_args2(args), (void *)PT_REGS_PARM3(ctx)
+#define ___bpf_kprobe_args4(x, args...) \
+	___bpf_kprobe_args3(args), (void *)PT_REGS_PARM4(ctx)
+#define ___bpf_kprobe_args5(x, args...) \
+	___bpf_kprobe_args4(args), (void *)PT_REGS_PARM5(ctx)
+#define ___bpf_kprobe_args(args...) \
+	___bpf_apply(___bpf_kprobe_args, ___bpf_narg(args))(args)
+
+/*
+ * BPF_KPROBE serves the same purpose for kprobes as BPF_PROG for
+ * tp_btf/fentry/fexit BPF programs. It hides the underlying platform-specific
+ * low-level way of getting kprobe input arguments from struct pt_regs, and
+ * provides a familiar typed and named function arguments syntax and
+ * semantics of accessing kprobe input paremeters.
+ *
+ * Original struct pt_regs* context is preserved as 'ctx' argument. This might
+ * be necessary when using BPF helpers like bpf_perf_event_output().
+ */
+#define BPF_KPROBE(name, args...)					    \
+name(struct pt_regs *ctx);						    \
+static __attribute__((always_inline)) typeof(name(0))			    \
+____##name(struct pt_regs *ctx, ##args);				    \
+typeof(name(0)) name(struct pt_regs *ctx)				    \
+{									    \
+	_Pragma("GCC diagnostic push")					    \
+	_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")		    \
+	return ____##name(___bpf_kprobe_args(args));			    \
+	_Pragma("GCC diagnostic pop")					    \
+}									    \
+static __attribute__((always_inline)) typeof(name(0))			    \
+____##name(struct pt_regs *ctx, ##args)
+
+#define ___bpf_kretprobe_args0() ctx
+#define ___bpf_kretprobe_args1(x) \
+	___bpf_kretprobe_args0(), (void *)PT_REGS_RET(ctx)
+#define ___bpf_kretprobe_args(args...) \
+	___bpf_apply(___bpf_kretprobe_args, ___bpf_narg(args))(args)
+
+/*
+ * BPF_KRETPROBE is similar to BPF_KPROBE, except, it only provides optional
+ * return value (in addition to `struct pt_regs *ctx`), but no input
+ * arguments, because they will be clobbered by the time probed function
+ * returns.
+ */
+#define BPF_KRETPROBE(name, args...)					    \
+name(struct pt_regs *ctx);						    \
+static __attribute__((always_inline)) typeof(name(0))			    \
+____##name(struct pt_regs *ctx, ##args);				    \
+typeof(name(0)) name(struct pt_regs *ctx)				    \
+{									    \
+	_Pragma("GCC diagnostic push")					    \
+	_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")		    \
+	return ____##name(___bpf_kretprobe_args(args));			    \
+	_Pragma("GCC diagnostic pop")					    \
+}									    \
+static __always_inline typeof(name(0)) ____##name(struct pt_regs *ctx, ##args)
+
 #endif
diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
index 8f21965ffc6c..5bf2fe9b1efa 100644
--- a/tools/testing/selftests/bpf/bpf_tcp_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
@@ -6,7 +6,7 @@
 #include <linux/types.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_core_read.h>
-#include "bpf_trace_helpers.h"
+#include <bpf/bpf_tracing.h>
 
 #define BPF_STRUCT_OPS(name, args...) \
 SEC("struct_ops/"#name) \
diff --git a/tools/testing/selftests/bpf/bpf_trace_helpers.h b/tools/testing/selftests/bpf/bpf_trace_helpers.h
deleted file mode 100644
index 83b8e02f5ee9..000000000000
--- a/tools/testing/selftests/bpf/bpf_trace_helpers.h
+++ /dev/null
@@ -1,121 +0,0 @@
-/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
-#ifndef __BPF_TRACE_HELPERS_H
-#define __BPF_TRACE_HELPERS_H
-
-#include <bpf/bpf_helpers.h>
-
-#define ___bpf_concat(a, b) a ## b
-#define ___bpf_apply(fn, n) ___bpf_concat(fn, n)
-#define ___bpf_nth(_, _1, _2, _3, _4, _5, _6, _7, _8, _9, _a, _b, _c, N, ...) N
-#define ___bpf_narg(...) \
-	___bpf_nth(_, ##__VA_ARGS__, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0)
-#define ___bpf_empty(...) \
-	___bpf_nth(_, ##__VA_ARGS__, N, N, N, N, N, N, N, N, N, N, 0)
-
-#define ___bpf_ctx_cast0() ctx
-#define ___bpf_ctx_cast1(x) ___bpf_ctx_cast0(), (void *)ctx[0]
-#define ___bpf_ctx_cast2(x, args...) ___bpf_ctx_cast1(args), (void *)ctx[1]
-#define ___bpf_ctx_cast3(x, args...) ___bpf_ctx_cast2(args), (void *)ctx[2]
-#define ___bpf_ctx_cast4(x, args...) ___bpf_ctx_cast3(args), (void *)ctx[3]
-#define ___bpf_ctx_cast5(x, args...) ___bpf_ctx_cast4(args), (void *)ctx[4]
-#define ___bpf_ctx_cast6(x, args...) ___bpf_ctx_cast5(args), (void *)ctx[5]
-#define ___bpf_ctx_cast7(x, args...) ___bpf_ctx_cast6(args), (void *)ctx[6]
-#define ___bpf_ctx_cast8(x, args...) ___bpf_ctx_cast7(args), (void *)ctx[7]
-#define ___bpf_ctx_cast9(x, args...) ___bpf_ctx_cast8(args), (void *)ctx[8]
-#define ___bpf_ctx_cast10(x, args...) ___bpf_ctx_cast9(args), (void *)ctx[9]
-#define ___bpf_ctx_cast11(x, args...) ___bpf_ctx_cast10(args), (void *)ctx[10]
-#define ___bpf_ctx_cast12(x, args...) ___bpf_ctx_cast11(args), (void *)ctx[11]
-#define ___bpf_ctx_cast(args...) \
-	___bpf_apply(___bpf_ctx_cast, ___bpf_narg(args))(args)
-
-/*
- * BPF_PROG is a convenience wrapper for generic tp_btf/fentry/fexit and
- * similar kinds of BPF programs, that accept input arguments as a single
- * pointer to untyped u64 array, where each u64 can actually be a typed
- * pointer or integer of different size. Instead of requring user to write
- * manual casts and work with array elements by index, BPF_PROG macro
- * allows user to declare a list of named and typed input arguments in the
- * same syntax as for normal C function. All the casting is hidden and
- * performed transparently, while user code can just assume working with
- * function arguments of specified type and name.
- *
- * Original raw context argument is preserved as well as 'ctx' argument.
- * This is useful when using BPF helpers that expect original context
- * as one of the parameters (e.g., for bpf_perf_event_output()).
- */
-#define BPF_PROG(name, args...)						    \
-name(unsigned long long *ctx);						    \
-static __always_inline typeof(name(0))					    \
-____##name(unsigned long long *ctx, ##args);				    \
-typeof(name(0)) name(unsigned long long *ctx)				    \
-{									    \
-	_Pragma("GCC diagnostic push")					    \
-	_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")		    \
-	return ____##name(___bpf_ctx_cast(args));			    \
-	_Pragma("GCC diagnostic pop")					    \
-}									    \
-static __always_inline typeof(name(0))					    \
-____##name(unsigned long long *ctx, ##args)
-
-struct pt_regs;
-
-#define ___bpf_kprobe_args0() ctx
-#define ___bpf_kprobe_args1(x) \
-	___bpf_kprobe_args0(), (void *)PT_REGS_PARM1(ctx)
-#define ___bpf_kprobe_args2(x, args...) \
-	___bpf_kprobe_args1(args), (void *)PT_REGS_PARM2(ctx)
-#define ___bpf_kprobe_args3(x, args...) \
-	___bpf_kprobe_args2(args), (void *)PT_REGS_PARM3(ctx)
-#define ___bpf_kprobe_args4(x, args...) \
-	___bpf_kprobe_args3(args), (void *)PT_REGS_PARM4(ctx)
-#define ___bpf_kprobe_args5(x, args...) \
-	___bpf_kprobe_args4(args), (void *)PT_REGS_PARM5(ctx)
-#define ___bpf_kprobe_args(args...) \
-	___bpf_apply(___bpf_kprobe_args, ___bpf_narg(args))(args)
-
-/*
- * BPF_KPROBE serves the same purpose for kprobes as BPF_PROG for
- * tp_btf/fentry/fexit BPF programs. It hides the underlying platform-specific
- * low-level way of getting kprobe input arguments from struct pt_regs, and
- * provides a familiar typed and named function arguments syntax and
- * semantics of accessing kprobe input paremeters.
- *
- * Original struct pt_regs* context is preserved as 'ctx' argument. This might
- * be necessary when using BPF helpers like bpf_perf_event_output().
- */
-#define BPF_KPROBE(name, args...)					    \
-name(struct pt_regs *ctx);						    \
-static __always_inline typeof(name(0)) ____##name(struct pt_regs *ctx, ##args);\
-typeof(name(0)) name(struct pt_regs *ctx)				    \
-{									    \
-	_Pragma("GCC diagnostic push")					    \
-	_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")		    \
-	return ____##name(___bpf_kprobe_args(args));			    \
-	_Pragma("GCC diagnostic pop")					    \
-}									    \
-static __always_inline typeof(name(0)) ____##name(struct pt_regs *ctx, ##args)
-
-#define ___bpf_kretprobe_args0() ctx
-#define ___bpf_kretprobe_args1(x) \
-	___bpf_kretprobe_args0(), (void *)PT_REGS_RET(ctx)
-#define ___bpf_kretprobe_args(args...) \
-	___bpf_apply(___bpf_kretprobe_args, ___bpf_narg(args))(args)
-
-/*
- * BPF_KRETPROBE is similar to BPF_KPROBE, except, it only provides optional
- * return value (in addition to `struct pt_regs *ctx`), but no input
- * arguments, because they will be clobbered by the time probed function
- * returns.
- */
-#define BPF_KRETPROBE(name, args...)					    \
-name(struct pt_regs *ctx);						    \
-static __always_inline typeof(name(0)) ____##name(struct pt_regs *ctx, ##args);\
-typeof(name(0)) name(struct pt_regs *ctx)				    \
-{									    \
-	_Pragma("GCC diagnostic push")					    \
-	_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")		    \
-	return ____##name(___bpf_kretprobe_args(args));			    \
-	_Pragma("GCC diagnostic pop")					    \
-}									    \
-static __always_inline typeof(name(0)) ____##name(struct pt_regs *ctx, ##args)
-#endif
diff --git a/tools/testing/selftests/bpf/progs/bpf_dctcp.c b/tools/testing/selftests/bpf/progs/bpf_dctcp.c
index b631fb5032d2..127ea762a062 100644
--- a/tools/testing/selftests/bpf/progs/bpf_dctcp.c
+++ b/tools/testing/selftests/bpf/progs/bpf_dctcp.c
@@ -9,7 +9,7 @@
 #include <linux/bpf.h>
 #include <linux/types.h>
 #include <bpf/bpf_helpers.h>
-#include "bpf_trace_helpers.h"
+#include <bpf/bpf_tracing.h>
 #include "bpf_tcp_helpers.h"
 
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/fentry_test.c b/tools/testing/selftests/bpf/progs/fentry_test.c
index 38d3a82144ca..9365b686f84b 100644
--- a/tools/testing/selftests/bpf/progs/fentry_test.c
+++ b/tools/testing/selftests/bpf/progs/fentry_test.c
@@ -2,7 +2,7 @@
 /* Copyright (c) 2019 Facebook */
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
-#include "bpf_trace_helpers.h"
+#include <bpf/bpf_tracing.h>
 
 char _license[] SEC("license") = "GPL";
 
diff --git a/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
index c329fccf9842..98e1efe14549 100644
--- a/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
@@ -5,7 +5,7 @@
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_endian.h>
-#include "bpf_trace_helpers.h"
+#include <bpf/bpf_tracing.h>
 
 struct sk_buff {
 	unsigned int len;
diff --git a/tools/testing/selftests/bpf/progs/fexit_bpf2bpf_simple.c b/tools/testing/selftests/bpf/progs/fexit_bpf2bpf_simple.c
index 92f3fa47cf40..85c0b516d6ee 100644
--- a/tools/testing/selftests/bpf/progs/fexit_bpf2bpf_simple.c
+++ b/tools/testing/selftests/bpf/progs/fexit_bpf2bpf_simple.c
@@ -2,7 +2,7 @@
 /* Copyright (c) 2019 Facebook */
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
-#include "bpf_trace_helpers.h"
+#include <bpf/bpf_tracing.h>
 
 struct sk_buff {
 	unsigned int len;
diff --git a/tools/testing/selftests/bpf/progs/fexit_test.c b/tools/testing/selftests/bpf/progs/fexit_test.c
index 348109b9ea07..bd1e17d8024c 100644
--- a/tools/testing/selftests/bpf/progs/fexit_test.c
+++ b/tools/testing/selftests/bpf/progs/fexit_test.c
@@ -2,7 +2,7 @@
 /* Copyright (c) 2019 Facebook */
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
-#include "bpf_trace_helpers.h"
+#include <bpf/bpf_tracing.h>
 
 char _license[] SEC("license") = "GPL";
 
diff --git a/tools/testing/selftests/bpf/progs/kfree_skb.c b/tools/testing/selftests/bpf/progs/kfree_skb.c
index 8f48a909f079..a46a264ce24e 100644
--- a/tools/testing/selftests/bpf/progs/kfree_skb.c
+++ b/tools/testing/selftests/bpf/progs/kfree_skb.c
@@ -4,7 +4,7 @@
 #include <stdbool.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_endian.h>
-#include "bpf_trace_helpers.h"
+#include <bpf/bpf_tracing.h>
 
 char _license[] SEC("license") = "GPL";
 struct {
diff --git a/tools/testing/selftests/bpf/progs/test_attach_probe.c b/tools/testing/selftests/bpf/progs/test_attach_probe.c
index 38ed8c3bf922..8056a4c6d918 100644
--- a/tools/testing/selftests/bpf/progs/test_attach_probe.c
+++ b/tools/testing/selftests/bpf/progs/test_attach_probe.c
@@ -4,7 +4,7 @@
 #include <linux/ptrace.h>
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
-#include "bpf_trace_helpers.h"
+#include <bpf/bpf_tracing.h>
 
 int kprobe_res = 0;
 int kretprobe_res = 0;
diff --git a/tools/testing/selftests/bpf/progs/test_overhead.c b/tools/testing/selftests/bpf/progs/test_overhead.c
index f43714c69cc8..56a50b25cd33 100644
--- a/tools/testing/selftests/bpf/progs/test_overhead.c
+++ b/tools/testing/selftests/bpf/progs/test_overhead.c
@@ -6,7 +6,6 @@
 #include <linux/ptrace.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
-#include "bpf_trace_helpers.h"
 
 struct task_struct;
 
diff --git a/tools/testing/selftests/bpf/progs/test_perf_branches.c b/tools/testing/selftests/bpf/progs/test_perf_branches.c
index 0f7e27d97567..a1ccc831c882 100644
--- a/tools/testing/selftests/bpf/progs/test_perf_branches.c
+++ b/tools/testing/selftests/bpf/progs/test_perf_branches.c
@@ -5,7 +5,7 @@
 #include <linux/ptrace.h>
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
-#include "bpf_trace_helpers.h"
+#include <bpf/bpf_tracing.h>
 
 int valid = 0;
 int required_size_out = 0;
diff --git a/tools/testing/selftests/bpf/progs/test_perf_buffer.c b/tools/testing/selftests/bpf/progs/test_perf_buffer.c
index ebfcc9f50c35..ad59c4c9aba8 100644
--- a/tools/testing/selftests/bpf/progs/test_perf_buffer.c
+++ b/tools/testing/selftests/bpf/progs/test_perf_buffer.c
@@ -4,7 +4,7 @@
 #include <linux/ptrace.h>
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
-#include "bpf_trace_helpers.h"
+#include <bpf/bpf_tracing.h>
 
 struct {
 	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
diff --git a/tools/testing/selftests/bpf/progs/test_probe_user.c b/tools/testing/selftests/bpf/progs/test_probe_user.c
index d556b1572cc6..89b3532ccc75 100644
--- a/tools/testing/selftests/bpf/progs/test_probe_user.c
+++ b/tools/testing/selftests/bpf/progs/test_probe_user.c
@@ -7,7 +7,6 @@
 
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
-#include "bpf_trace_helpers.h"
 
 static struct sockaddr_in old;
 
diff --git a/tools/testing/selftests/bpf/progs/test_trampoline_count.c b/tools/testing/selftests/bpf/progs/test_trampoline_count.c
index e51e6e3a81c2..f030e469d05b 100644
--- a/tools/testing/selftests/bpf/progs/test_trampoline_count.c
+++ b/tools/testing/selftests/bpf/progs/test_trampoline_count.c
@@ -2,7 +2,8 @@
 #include <stdbool.h>
 #include <stddef.h>
 #include <linux/bpf.h>
-#include "bpf_trace_helpers.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
 
 struct task_struct;
 
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c b/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
index b840fc9e3ed5..42dd2fedd588 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/bpf.h>
+#include <bpf/bpf_tracing.h>
 #include <bpf/bpf_helpers.h>
-#include "bpf_trace_helpers.h"
 
 struct net_device {
 	/* Structure does not need to contain all entries,
-- 
2.17.1

