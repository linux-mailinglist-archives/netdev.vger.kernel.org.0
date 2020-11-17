Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC862B5AF4
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 09:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgKQI1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 03:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbgKQI1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 03:27:10 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A646C0613CF;
        Tue, 17 Nov 2020 00:27:10 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id oc3so43505pjb.4;
        Tue, 17 Nov 2020 00:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0w+Bq27/X0GIM1BI/NmY3YCnW8k8aSVxxtLiS5VSHa4=;
        b=Vl4FdewX3/qjsY+5i8oCei0lR1IhFvHmLxRKBQdOvYK/A1LBq73lxnEW0aMdhSRyhQ
         ZJXTzWbPyGQAu5e7eb9LyiymBuZ5rFVqzyH5FGaW7M/3YWhcbR+QmseDLrmtqkKA+MAf
         jbzI7OIews82d9lXzcAlpOLksHU2A1qs8twFVSwmnVNDjHYtfN1cb2kAiuDKYgGjDRMg
         aDulsNkjtPjIPtNN0dhcd2A+91OlcbWcQqgjTUxeJvN5GdyLSG4uXiCK1k3YLYDHiYTo
         x+MCXum3b/tKQhXSxF/0EMuy9j0joq0dbI5ramufU7hNvD1NGgaUqUP8kBu5oGM5KpnA
         EDFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0w+Bq27/X0GIM1BI/NmY3YCnW8k8aSVxxtLiS5VSHa4=;
        b=AW6eIh77HoCqScfG9lNhgSOMqbdpVR3ihJxlpLeMVYe1/0wS2S/uCTT/dPhcQWQxNS
         ipxsFERTJaAJI3vltNmbjs/DfS6JYrTs47KaAl8T65IuntZc+PocSQ9m+/UwD1C+OQaR
         SAvCRKrA2TLq5KBsANe21JN20/FIJ9Qp/3KfItdyC1QVNo7zSFdO49WrPXEouT8EVfsc
         l/ZpjLzKBCdkysbt5IlSqthYgM5xghPw8WvMIyQ3oOZp+xkjj0YyPgfoWOQDQRT3253V
         sgXbJxd+TZ8mOmtqxVf08oE1/PCy/n52deVf/U8Ccxd0MhSWyXLAmvgP+gepC/MZZGpX
         r48A==
X-Gm-Message-State: AOAM531mh17jCi3QMadDXCaDRYclCUqWwQ2GkewBzFJ2hVWV5vSdiktP
        hIKhFCIEryARyTgzYEtnTes=
X-Google-Smtp-Source: ABdhPJyfa0OkA1HWcJiLXPFp5EdZ5ns95AOY+lu07uAWijQqDgGlmiHAiCac0tIGDqtfSe7yIGujKQ==
X-Received: by 2002:a17:90b:3506:: with SMTP id ls6mr3424114pjb.202.1605601629510;
        Tue, 17 Nov 2020 00:27:09 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id c12sm2251671pjs.8.2020.11.17.00.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 00:27:08 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        xi.wang@gmail.com, luke.r.nels@gmail.com,
        linux-riscv@lists.infradead.org
Subject: [PATCH bpf-next 3/3] selftests/bpf: Mark tests that require unaligned memory access
Date:   Tue, 17 Nov 2020 09:26:38 +0100
Message-Id: <20201117082638.43675-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117082638.43675-1-bjorn.topel@gmail.com>
References: <20201117082638.43675-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A lot of tests require unaligned memory access to work. Mark the tests
as such, so that they can be avoided on unsupported architectures such
as RISC-V.

Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
---
 .../selftests/bpf/verifier/ctx_sk_lookup.c    |  7 +++
 .../bpf/verifier/direct_value_access.c        |  3 ++
 .../testing/selftests/bpf/verifier/map_ptr.c  |  1 +
 .../selftests/bpf/verifier/raw_tp_writable.c  |  1 +
 .../selftests/bpf/verifier/ref_tracking.c     |  4 ++
 .../testing/selftests/bpf/verifier/regalloc.c |  8 ++++
 .../selftests/bpf/verifier/wide_access.c      | 46 +++++++++++--------
 7 files changed, 52 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c b/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c
index 2ad5f974451c..fb13ca2d5606 100644
--- a/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c
+++ b/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c
@@ -266,6 +266,7 @@
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
 	.expected_attach_type = BPF_SK_LOOKUP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"invalid 8-byte read from bpf_sk_lookup remote_ip4 field",
@@ -292,6 +293,7 @@
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
 	.expected_attach_type = BPF_SK_LOOKUP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"invalid 8-byte read from bpf_sk_lookup remote_port field",
@@ -305,6 +307,7 @@
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
 	.expected_attach_type = BPF_SK_LOOKUP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"invalid 8-byte read from bpf_sk_lookup local_ip4 field",
@@ -331,6 +334,7 @@
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
 	.expected_attach_type = BPF_SK_LOOKUP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"invalid 8-byte read from bpf_sk_lookup local_port field",
@@ -344,6 +348,7 @@
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
 	.expected_attach_type = BPF_SK_LOOKUP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 /* invalid 1,2,4-byte reads from 8-byte fields in bpf_sk_lookup */
 {
@@ -410,6 +415,7 @@
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
 	.expected_attach_type = BPF_SK_LOOKUP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"invalid 4-byte unaligned read from bpf_sk_lookup at even offset",
@@ -422,6 +428,7 @@
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
 	.expected_attach_type = BPF_SK_LOOKUP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 /* in-bound and out-of-bound writes to bpf_sk_lookup */
 {
diff --git a/tools/testing/selftests/bpf/verifier/direct_value_access.c b/tools/testing/selftests/bpf/verifier/direct_value_access.c
index 988f46a1a4c7..c0648dc009b5 100644
--- a/tools/testing/selftests/bpf/verifier/direct_value_access.c
+++ b/tools/testing/selftests/bpf/verifier/direct_value_access.c
@@ -69,6 +69,7 @@
 	.fixup_map_array_48b = { 1 },
 	.result = REJECT,
 	.errstr = "R1 min value is outside of the allowed memory range",
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"direct map access, write test 7",
@@ -195,6 +196,7 @@
 	.fixup_map_array_48b = { 1, 3 },
 	.result = REJECT,
 	.errstr = "invalid access to map value, value_size=48 off=47 size=2",
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"direct map access, write test 17",
@@ -209,6 +211,7 @@
 	.fixup_map_array_48b = { 1, 3 },
 	.result = REJECT,
 	.errstr = "invalid access to map value, value_size=48 off=47 size=2",
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"direct map access, write test 18",
diff --git a/tools/testing/selftests/bpf/verifier/map_ptr.c b/tools/testing/selftests/bpf/verifier/map_ptr.c
index 637f9293bda8..b117bdd3806d 100644
--- a/tools/testing/selftests/bpf/verifier/map_ptr.c
+++ b/tools/testing/selftests/bpf/verifier/map_ptr.c
@@ -44,6 +44,7 @@
 	.errstr_unpriv = "bpf_array access is allowed only to CAP_PERFMON and CAP_SYS_ADMIN",
 	.result = REJECT,
 	.errstr = "cannot access ptr member ops with moff 0 in struct bpf_map with off 1 size 4",
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"bpf_map_ptr: read ops field accepted",
diff --git a/tools/testing/selftests/bpf/verifier/raw_tp_writable.c b/tools/testing/selftests/bpf/verifier/raw_tp_writable.c
index 95b5d70a1dc1..2978fb5a769d 100644
--- a/tools/testing/selftests/bpf/verifier/raw_tp_writable.c
+++ b/tools/testing/selftests/bpf/verifier/raw_tp_writable.c
@@ -31,4 +31,5 @@
 	.fixup_map_hash_8b = { 1, },
 	.prog_type = BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
 	.errstr = "R6 invalid variable buffer offset: off=0, var_off=(0x0; 0xffffffff)",
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
diff --git a/tools/testing/selftests/bpf/verifier/ref_tracking.c b/tools/testing/selftests/bpf/verifier/ref_tracking.c
index 006b5bd99c08..3b6ee009c00b 100644
--- a/tools/testing/selftests/bpf/verifier/ref_tracking.c
+++ b/tools/testing/selftests/bpf/verifier/ref_tracking.c
@@ -675,6 +675,7 @@
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.result = REJECT,
 	.errstr = "invalid mem access",
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"reference tracking: use ptr from bpf_sk_fullsock() after release",
@@ -698,6 +699,7 @@
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.result = REJECT,
 	.errstr = "invalid mem access",
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"reference tracking: use ptr from bpf_sk_fullsock(tp) after release",
@@ -725,6 +727,7 @@
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.result = REJECT,
 	.errstr = "invalid mem access",
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"reference tracking: use sk after bpf_sk_release(tp)",
@@ -747,6 +750,7 @@
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.result = REJECT,
 	.errstr = "invalid mem access",
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"reference tracking: use ptr from bpf_get_listener_sock() after bpf_sk_release(sk)",
diff --git a/tools/testing/selftests/bpf/verifier/regalloc.c b/tools/testing/selftests/bpf/verifier/regalloc.c
index 4ad7e05de706..bb0dd89dd212 100644
--- a/tools/testing/selftests/bpf/verifier/regalloc.c
+++ b/tools/testing/selftests/bpf/verifier/regalloc.c
@@ -21,6 +21,7 @@
 	.fixup_map_hash_48b = { 4 },
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"regalloc negative",
@@ -71,6 +72,7 @@
 	.fixup_map_hash_48b = { 4 },
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"regalloc src_reg negative",
@@ -97,6 +99,7 @@
 	.result = REJECT,
 	.errstr = "invalid access to map value, value_size=48 off=44 size=8",
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"regalloc and spill",
@@ -126,6 +129,7 @@
 	.fixup_map_hash_48b = { 4 },
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"regalloc and spill negative",
@@ -156,6 +160,7 @@
 	.result = REJECT,
 	.errstr = "invalid access to map value, value_size=48 off=48 size=8",
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"regalloc three regs",
@@ -182,6 +187,7 @@
 	.fixup_map_hash_48b = { 4 },
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"regalloc after call",
@@ -210,6 +216,7 @@
 	.fixup_map_hash_48b = { 4 },
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"regalloc in callee",
@@ -240,6 +247,7 @@
 	.fixup_map_hash_48b = { 4 },
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"regalloc, spill, JEQ",
diff --git a/tools/testing/selftests/bpf/verifier/wide_access.c b/tools/testing/selftests/bpf/verifier/wide_access.c
index ccade9312d21..55af248efa93 100644
--- a/tools/testing/selftests/bpf/verifier/wide_access.c
+++ b/tools/testing/selftests/bpf/verifier/wide_access.c
@@ -1,4 +1,4 @@
-#define BPF_SOCK_ADDR_STORE(field, off, res, err) \
+#define BPF_SOCK_ADDR_STORE(field, off, res, err, flgs)	\
 { \
 	"wide store to bpf_sock_addr." #field "[" #off "]", \
 	.insns = { \
@@ -11,31 +11,36 @@
 	.prog_type = BPF_PROG_TYPE_CGROUP_SOCK_ADDR, \
 	.expected_attach_type = BPF_CGROUP_UDP6_SENDMSG, \
 	.errstr = err, \
+	.flags = flgs, \
 }
 
 /* user_ip6[0] is u64 aligned */
 BPF_SOCK_ADDR_STORE(user_ip6, 0, ACCEPT,
-		    NULL),
+		    NULL, 0),
 BPF_SOCK_ADDR_STORE(user_ip6, 1, REJECT,
-		    "invalid bpf_context access off=12 size=8"),
+		    "invalid bpf_context access off=12 size=8",
+		    F_NEEDS_EFFICIENT_UNALIGNED_ACCESS),
 BPF_SOCK_ADDR_STORE(user_ip6, 2, ACCEPT,
-		    NULL),
+		    NULL, 0),
 BPF_SOCK_ADDR_STORE(user_ip6, 3, REJECT,
-		    "invalid bpf_context access off=20 size=8"),
+		    "invalid bpf_context access off=20 size=8",
+		    F_NEEDS_EFFICIENT_UNALIGNED_ACCESS),
 
 /* msg_src_ip6[0] is _not_ u64 aligned */
 BPF_SOCK_ADDR_STORE(msg_src_ip6, 0, REJECT,
-		    "invalid bpf_context access off=44 size=8"),
+		    "invalid bpf_context access off=44 size=8",
+		    F_NEEDS_EFFICIENT_UNALIGNED_ACCESS),
 BPF_SOCK_ADDR_STORE(msg_src_ip6, 1, ACCEPT,
-		    NULL),
+		    NULL, 0),
 BPF_SOCK_ADDR_STORE(msg_src_ip6, 2, REJECT,
-		    "invalid bpf_context access off=52 size=8"),
+		    "invalid bpf_context access off=52 size=8",
+		    F_NEEDS_EFFICIENT_UNALIGNED_ACCESS),
 BPF_SOCK_ADDR_STORE(msg_src_ip6, 3, REJECT,
-		    "invalid bpf_context access off=56 size=8"),
+		    "invalid bpf_context access off=56 size=8", 0),
 
 #undef BPF_SOCK_ADDR_STORE
 
-#define BPF_SOCK_ADDR_LOAD(field, off, res, err) \
+#define BPF_SOCK_ADDR_LOAD(field, off, res, err, flgs)	\
 { \
 	"wide load from bpf_sock_addr." #field "[" #off "]", \
 	.insns = { \
@@ -48,26 +53,31 @@ BPF_SOCK_ADDR_STORE(msg_src_ip6, 3, REJECT,
 	.prog_type = BPF_PROG_TYPE_CGROUP_SOCK_ADDR, \
 	.expected_attach_type = BPF_CGROUP_UDP6_SENDMSG, \
 	.errstr = err, \
+	.flags = flgs, \
 }
 
 /* user_ip6[0] is u64 aligned */
 BPF_SOCK_ADDR_LOAD(user_ip6, 0, ACCEPT,
-		   NULL),
+		   NULL, 0),
 BPF_SOCK_ADDR_LOAD(user_ip6, 1, REJECT,
-		   "invalid bpf_context access off=12 size=8"),
+		   "invalid bpf_context access off=12 size=8",
+		    F_NEEDS_EFFICIENT_UNALIGNED_ACCESS),
 BPF_SOCK_ADDR_LOAD(user_ip6, 2, ACCEPT,
-		   NULL),
+		   NULL, 0),
 BPF_SOCK_ADDR_LOAD(user_ip6, 3, REJECT,
-		   "invalid bpf_context access off=20 size=8"),
+		   "invalid bpf_context access off=20 size=8",
+		    F_NEEDS_EFFICIENT_UNALIGNED_ACCESS),
 
 /* msg_src_ip6[0] is _not_ u64 aligned */
 BPF_SOCK_ADDR_LOAD(msg_src_ip6, 0, REJECT,
-		   "invalid bpf_context access off=44 size=8"),
+		   "invalid bpf_context access off=44 size=8",
+		    F_NEEDS_EFFICIENT_UNALIGNED_ACCESS),
 BPF_SOCK_ADDR_LOAD(msg_src_ip6, 1, ACCEPT,
-		   NULL),
+		   NULL, 0),
 BPF_SOCK_ADDR_LOAD(msg_src_ip6, 2, REJECT,
-		   "invalid bpf_context access off=52 size=8"),
+		   "invalid bpf_context access off=52 size=8",
+		    F_NEEDS_EFFICIENT_UNALIGNED_ACCESS),
 BPF_SOCK_ADDR_LOAD(msg_src_ip6, 3, REJECT,
-		   "invalid bpf_context access off=56 size=8"),
+		   "invalid bpf_context access off=56 size=8", 0),
 
 #undef BPF_SOCK_ADDR_LOAD
-- 
2.27.0

