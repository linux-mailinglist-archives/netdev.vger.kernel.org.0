Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3331445D9
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 21:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbgAUUWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 15:22:47 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38742 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727383AbgAUUWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 15:22:47 -0500
Received: by mail-ot1-f67.google.com with SMTP id z9so4196303oth.5;
        Tue, 21 Jan 2020 12:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=T8Xur6qqCtnBykcJTa+ysumESp+avbgNbYl7ls55uQs=;
        b=JJ6RbdUFCvqmK35XRUlEzA7y0e4ke3xb7l9mPGxndekHZeGOzocYIdvy5l0M9I2x8a
         LS+PRX5y6Lm3XsxYVt7RHYQ0nFBo2NMN5uFt2fvIgmYkag9cy+E7e2cMZHbVzNpwYeoo
         oUjocd1nZAnqyTaUpVDciZUKbo6yrPbEzM4HficIQDmy5RW56INs1fQ4vNubF5pl0rUr
         L35F2l4qlV/xwodEtMRUTohfKREZ/6DT6hZZhoiH6k3oyYM/aeJEnI7ZaGReBw0DIj+C
         gSpHCN8KfLpkU+rPxU5om8nQOyUSjjJu07clq9xzlSBmNsiPAvvASrED8ETb8GY1Zq8m
         Ox8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=T8Xur6qqCtnBykcJTa+ysumESp+avbgNbYl7ls55uQs=;
        b=g2jqK51KLiiwlQGdtW8T1r6t0ongif8TDtk43uKO3VWbrRjFbLiic9qn1NEWGIrnIa
         ttOkmM/Eapdt2QPp0TUHUS6xhmtucUKpp2kzmuXr12CUucjJam7Tuxm6eQK1PAVZdZo5
         9+EEe2+GfcK8uIoK6AiuFi3N5YH/ATZ9HCf3zVwOSnYwtniDspwCSuPBXVVo51I8sPN4
         nCtOcP0xeXpnWviK0sl+0irGzVdGzUcxHMe5Lgc5hQmIqNBxGFlTsbXOkk87zOdgi5Q4
         bP3w09Gbw5acmfa6O/Qm2EHM5biVEJwSJlYOLaPTA+mBXcDggY270B65KHRqhr5UhKEC
         SRGA==
X-Gm-Message-State: APjAAAXZMBOOkKKs4TRQTQUbGK1tt6TP48kLNMgssGvUbhYdp6YFiyXm
        /uq5wDhlY03MrFxxZGgqVwQ=
X-Google-Smtp-Source: APXvYqxOJFVAzDFUdZgDAPWj9sfeSHFWXVn2Auf6+QXRPnSPFFUS0SL6v7w1pdwCb0jRj38fVx0IrQ==
X-Received: by 2002:a9d:7d81:: with SMTP id j1mr4921311otn.267.1579638165778;
        Tue, 21 Jan 2020 12:22:45 -0800 (PST)
Received: from localhost.localdomain (ip24-56-44-135.ph.ph.cox.net. [24.56.44.135])
        by smtp.gmail.com with ESMTPSA id j20sm13870325otp.24.2020.01.21.12.22.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jan 2020 12:22:45 -0800 (PST)
From:   Matthew Cover <werekraken@gmail.com>
X-Google-Original-From: Matthew Cover <matthew.cover@stackpath.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Matthew Cover <matthew.cover@stackpath.com>,
        Stanislav Fomichev <sdf@google.com>,
        Andrey Ignatov <rdna@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v2 2/2] selftests/bpf: test references to nf_conn
Date:   Tue, 21 Jan 2020 13:22:33 -0700
Message-Id: <20200121202233.26583-1-matthew.cover@stackpath.com>
X-Mailer: git-send-email 2.15.2 (Apple Git-101.1)
In-Reply-To: <20200121202038.26490-1-matthew.cover@stackpath.com>
References: <20200121202038.26490-1-matthew.cover@stackpath.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure that returning a struct nf_conn * reference invokes
the reference tracking machinery in the verifier.

Signed-off-by: Matthew Cover <matthew.cover@stackpath.com>
---
 tools/testing/selftests/bpf/test_verifier.c        | 18 ++++++++
 .../testing/selftests/bpf/verifier/ref_tracking.c  | 48 ++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 87eaa49..7569db2 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -294,6 +294,24 @@ static void bpf_fill_scale(struct bpf_test *self)
 	}
 }
 
+/* BPF_CT_LOOKUP contains 13 instructions, if you need to fix up maps */
+#define BPF_CT_LOOKUP(func)						\
+	/* struct bpf_nf_conntrack_tuple tuple = {} */			\
+	BPF_MOV64_IMM(BPF_REG_2, 0),					\
+	BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_2, -8),			\
+	BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -16),		\
+	BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -24),		\
+	BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -32),		\
+	BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -40),		\
+	BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -48),		\
+	/* ct = func(ctx, &tuple, sizeof tuple, 0, 0) */		\
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),				\
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -48),				\
+	BPF_MOV64_IMM(BPF_REG_3, sizeof(struct bpf_nf_conntrack_tuple)),\
+	BPF_MOV64_IMM(BPF_REG_4, 0),					\
+	BPF_MOV64_IMM(BPF_REG_5, 0),					\
+	BPF_EMIT_CALL(BPF_FUNC_ ## func)
+
 /* BPF_SK_LOOKUP contains 13 instructions, if you need to fix up maps */
 #define BPF_SK_LOOKUP(func)						\
 	/* struct bpf_sock_tuple tuple = {} */				\
diff --git a/tools/testing/selftests/bpf/verifier/ref_tracking.c b/tools/testing/selftests/bpf/verifier/ref_tracking.c
index 604b461..de5c550a 100644
--- a/tools/testing/selftests/bpf/verifier/ref_tracking.c
+++ b/tools/testing/selftests/bpf/verifier/ref_tracking.c
@@ -21,6 +21,17 @@
 	.result = REJECT,
 },
 {
+	"reference tracking: leak potential reference to nf_conn",
+	.insns = {
+	BPF_CT_LOOKUP(ct_lookup_tcp),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0), /* leak reference */
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.errstr = "Unreleased reference",
+	.result = REJECT,
+},
+{
 	"reference tracking: leak potential reference on stack",
 	.insns = {
 	BPF_SK_LOOKUP(sk_lookup_tcp),
@@ -72,6 +83,17 @@
 	.result = REJECT,
 },
 {
+	"reference tracking: zero potential reference to nf_conn",
+	.insns = {
+	BPF_CT_LOOKUP(ct_lookup_tcp),
+	BPF_MOV64_IMM(BPF_REG_0, 0), /* leak reference */
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.errstr = "Unreleased reference",
+	.result = REJECT,
+},
+{
 	"reference tracking: copy and zero potential references",
 	.insns = {
 	BPF_SK_LOOKUP(sk_lookup_tcp),
@@ -113,6 +135,20 @@
 	.result = REJECT,
 },
 {
+	"reference tracking: release reference to nf_conn without check",
+	.insns = {
+	BPF_CT_LOOKUP(ct_lookup_tcp),
+	/* reference in r0 may be NULL */
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_MOV64_IMM(BPF_REG_2, 0),
+	BPF_EMIT_CALL(BPF_FUNC_ct_release),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.errstr = "type=nf_conn_or_null expected=nf_conn",
+	.result = REJECT,
+},
+{
 	"reference tracking: release reference",
 	.insns = {
 	BPF_SK_LOOKUP(sk_lookup_tcp),
@@ -137,6 +173,18 @@
 	.result = ACCEPT,
 },
 {
+	"reference tracking: release reference to nf_conn",
+	.insns = {
+	BPF_CT_LOOKUP(ct_lookup_tcp),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 1),
+	BPF_EMIT_CALL(BPF_FUNC_ct_release),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.result = ACCEPT,
+},
+{
 	"reference tracking: release reference 2",
 	.insns = {
 	BPF_SK_LOOKUP(sk_lookup_tcp),
-- 
1.8.3.1

