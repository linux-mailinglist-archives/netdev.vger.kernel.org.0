Return-Path: <netdev+bounces-8632-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA4A3724EFA
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 23:44:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7241D281100
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 21:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3168830B87;
	Tue,  6 Jun 2023 21:43:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F222D247;
	Tue,  6 Jun 2023 21:43:16 +0000 (UTC)
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D362A7;
	Tue,  6 Jun 2023 14:43:14 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1b02497f4cfso35047515ad.3;
        Tue, 06 Jun 2023 14:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686087793; x=1688679793;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5MMO0TnXSE1/BWLsLd/D7WLh4FdYRdFBDc2FwYF+MRQ=;
        b=rpKiA35NXaeO1qzzL5PjF8bHM7B0RDMIht6YKgnVk81RTEBzg0f8I0ZvGr2PFcwoEg
         mFZwErjy3FUOulh1g3yF41/oBcxvzQGBI7YpmjekiGcn+OyY9guACdnWtudETnwCPRQC
         93NdZUypLXakAiSKLrsm+uFu5RpucpuKKrEi+Yk2JNsUBUe8SF9jtcndTGovHYO/3C13
         VLjJqEl3kbEzDwTCLNcFsx5Z0j6QUv32CFQryKaKdF7b06Hc2SxuEmgI4HBFEW+m+plC
         QC2DeSSYyppf3mkPitVZNLQvw4COmNZu6SVKKjmd6GRvrHztPAHnWkuYu5B8dFn3zKG3
         f4BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686087793; x=1688679793;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5MMO0TnXSE1/BWLsLd/D7WLh4FdYRdFBDc2FwYF+MRQ=;
        b=XUwG7V2dbkS0URgvlQT3Sht+mIl6ChduiRM6eW25KEDWnlSdyTT632plH6xDr/gvcK
         Ta4nVcgHdsBYXjbT8EBJNpJyL8Bm4d8y0w+JKYY3A+nP640ddQXTKk8BQ8uIQK5t5KtL
         i3n23y3+Xu6YFGIBv0lmx2fKC2/iaXXAoMGm0XAeEhMW/Km+hP7IwSMy489zLLUj0IeO
         lQzvROghOCa0L0JAaNEw6vdd/dyiTWjNni6z7cN5sxldLNYJdNL9kQcLe6ji/JgYHk3p
         mYH0iKANb8H5URSeaacfHJaiwqkbaIq8GDA4F33qAZGpYvGkrV5pAY2n37zUXOVbhDxJ
         f7Wg==
X-Gm-Message-State: AC+VfDzdvj3lbvjWRQlu6XVkEeCgJXWxQGWrYhh/BcHxs0GgUEHqA7P1
	yEjE/4Fx+CkDXJUHyKjVENA1nx7IKKE3nQ+G
X-Google-Smtp-Source: ACHHUZ75JvnKyNPowykam0LclpYCBpD+nMETJsUw9f6LPFTg0aqDGCwMBXCpEhEdQ0vny5b5P7nV5g==
X-Received: by 2002:a17:903:41cf:b0:1b1:76c2:296a with SMTP id u15-20020a17090341cf00b001b176c2296amr2071193ple.60.1686087793333;
        Tue, 06 Jun 2023 14:43:13 -0700 (PDT)
Received: from localhost ([87.118.116.103])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902c24c00b001aafdf8063dsm8965254plg.157.2023.06.06.14.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 14:43:12 -0700 (PDT)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Maxim Mikityanskiy <maxim@isovalent.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yhs@fb.com>,
	KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@google.com>,
	Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mykola Lysenko <mykolal@fb.com>,
	Shuah Khan <shuah@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>
Subject: [PATCH bpf v3 2/2] selftests/bpf: Add test cases to assert proper ID tracking on spill
Date: Wed,  7 Jun 2023 00:42:46 +0300
Message-Id: <20230606214246.403579-3-maxtram95@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230606214246.403579-1-maxtram95@gmail.com>
References: <20230606214246.403579-1-maxtram95@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,
	RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Maxim Mikityanskiy <maxim@isovalent.com>

The previous commit fixed a verifier bypass by ensuring that ID is not
preserved on narrowing spills. Add the test cases to check the
problematic patterns.

Signed-off-by: Maxim Mikityanskiy <maxim@isovalent.com>
---
 .../selftests/bpf/progs/verifier_spill_fill.c | 198 ++++++++++++++++++
 1 file changed, 198 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/verifier_spill_fill.c b/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
index 136e5530b72c..999677acc8ae 100644
--- a/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
+++ b/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
@@ -371,4 +371,202 @@ __naked void and_then_at_fp_8(void)
 "	::: __clobber_all);
 }
 
+SEC("xdp")
+__description("32-bit spill of 64-bit reg should clear ID")
+__failure __msg("math between ctx pointer and 4294967295 is not allowed")
+__naked void spill_32bit_of_64bit_fail(void)
+{
+	asm volatile ("					\
+	r6 = r1;					\
+	/* Roll one bit to force the verifier to track both branches. */\
+	call %[bpf_get_prandom_u32];			\
+	r0 &= 0x8;					\
+	/* Put a large number into r1. */		\
+	r1 = 0xffffffff;				\
+	r1 <<= 32;					\
+	r1 += r0;					\
+	/* Assign an ID to r1. */			\
+	r2 = r1;					\
+	/* 32-bit spill r1 to stack - should clear the ID! */\
+	*(u32*)(r10 - 8) = r1;				\
+	/* 32-bit fill r2 from stack. */		\
+	r2 = *(u32*)(r10 - 8);				\
+	/* Compare r2 with another register to trigger find_equal_scalars.\
+	 * Having one random bit is important here, otherwise the verifier cuts\
+	 * the corners. If the ID was mistakenly preserved on spill, this would\
+	 * cause the verifier to think that r1 is also equal to zero in one of\
+	 * the branches, and equal to eight on the other branch.\
+	 */						\
+	r3 = 0;						\
+	if r2 != r3 goto l0_%=;				\
+l0_%=:	r1 >>= 32;					\
+	/* At this point, if the verifier thinks that r1 is 0, an out-of-bounds\
+	 * read will happen, because it actually contains 0xffffffff.\
+	 */						\
+	r6 += r1;					\
+	r0 = *(u32*)(r6 + 0);				\
+	exit;						\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
+SEC("xdp")
+__description("16-bit spill of 64-bit reg should clear ID")
+__failure __msg("math between ctx pointer and 4294967295 is not allowed")
+__naked void spill_16bit_of_64bit_fail(void)
+{
+	asm volatile ("					\
+	r6 = r1;					\
+	/* Roll one bit to force the verifier to track both branches. */\
+	call %[bpf_get_prandom_u32];			\
+	r0 &= 0x8;					\
+	/* Put a large number into r1. */		\
+	r1 = 0xffffffff;				\
+	r1 <<= 32;					\
+	r1 += r0;					\
+	/* Assign an ID to r1. */			\
+	r2 = r1;					\
+	/* 16-bit spill r1 to stack - should clear the ID! */\
+	*(u16*)(r10 - 8) = r1;				\
+	/* 16-bit fill r2 from stack. */		\
+	r2 = *(u16*)(r10 - 8);				\
+	/* Compare r2 with another register to trigger find_equal_scalars.\
+	 * Having one random bit is important here, otherwise the verifier cuts\
+	 * the corners. If the ID was mistakenly preserved on spill, this would\
+	 * cause the verifier to think that r1 is also equal to zero in one of\
+	 * the branches, and equal to eight on the other branch.\
+	 */						\
+	r3 = 0;						\
+	if r2 != r3 goto l0_%=;				\
+l0_%=:	r1 >>= 32;					\
+	/* At this point, if the verifier thinks that r1 is 0, an out-of-bounds\
+	 * read will happen, because it actually contains 0xffffffff.\
+	 */						\
+	r6 += r1;					\
+	r0 = *(u32*)(r6 + 0);				\
+	exit;						\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
+SEC("xdp")
+__description("8-bit spill of 64-bit reg should clear ID")
+__failure __msg("math between ctx pointer and 4294967295 is not allowed")
+__naked void spill_8bit_of_64bit_fail(void)
+{
+	asm volatile ("					\
+	r6 = r1;					\
+	/* Roll one bit to force the verifier to track both branches. */\
+	call %[bpf_get_prandom_u32];			\
+	r0 &= 0x8;					\
+	/* Put a large number into r1. */		\
+	r1 = 0xffffffff;				\
+	r1 <<= 32;					\
+	r1 += r0;					\
+	/* Assign an ID to r1. */			\
+	r2 = r1;					\
+	/* 8-bit spill r1 to stack - should clear the ID! */\
+	*(u8*)(r10 - 8) = r1;				\
+	/* 8-bit fill r2 from stack. */		\
+	r2 = *(u8*)(r10 - 8);				\
+	/* Compare r2 with another register to trigger find_equal_scalars.\
+	 * Having one random bit is important here, otherwise the verifier cuts\
+	 * the corners. If the ID was mistakenly preserved on spill, this would\
+	 * cause the verifier to think that r1 is also equal to zero in one of\
+	 * the branches, and equal to eight on the other branch.\
+	 */						\
+	r3 = 0;						\
+	if r2 != r3 goto l0_%=;				\
+l0_%=:	r1 >>= 32;					\
+	/* At this point, if the verifier thinks that r1 is 0, an out-of-bounds\
+	 * read will happen, because it actually contains 0xffffffff.\
+	 */						\
+	r6 += r1;					\
+	r0 = *(u32*)(r6 + 0);				\
+	exit;						\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
+SEC("xdp")
+__description("16-bit spill of 32-bit reg should clear ID")
+__failure __msg("dereference of modified ctx ptr R6 off=65535 disallowed")
+__naked void spill_16bit_of_32bit_fail(void)
+{
+	asm volatile ("					\
+	r6 = r1;					\
+	/* Roll one bit to force the verifier to track both branches. */\
+	call %[bpf_get_prandom_u32];			\
+	r0 &= 0x8;					\
+	/* Put a large number into r1. */		\
+	w1 = 0xffff0000;				\
+	r1 += r0;					\
+	/* Assign an ID to r1. */			\
+	r2 = r1;					\
+	/* 16-bit spill r1 to stack - should clear the ID! */\
+	*(u16*)(r10 - 8) = r1;				\
+	/* 16-bit fill r2 from stack. */		\
+	r2 = *(u16*)(r10 - 8);				\
+	/* Compare r2 with another register to trigger find_equal_scalars.\
+	 * Having one random bit is important here, otherwise the verifier cuts\
+	 * the corners. If the ID was mistakenly preserved on spill, this would\
+	 * cause the verifier to think that r1 is also equal to zero in one of\
+	 * the branches, and equal to eight on the other branch.\
+	 */						\
+	r3 = 0;						\
+	if r2 != r3 goto l0_%=;				\
+l0_%=:	r1 >>= 16;					\
+	/* At this point, if the verifier thinks that r1 is 0, an out-of-bounds\
+	 * read will happen, because it actually contains 0xffff.\
+	 */						\
+	r6 += r1;					\
+	r0 = *(u32*)(r6 + 0);				\
+	exit;						\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
+SEC("xdp")
+__description("8-bit spill of 32-bit reg should clear ID")
+__failure __msg("dereference of modified ctx ptr R6 off=65535 disallowed")
+__naked void spill_8bit_of_32bit_fail(void)
+{
+	asm volatile ("					\
+	r6 = r1;					\
+	/* Roll one bit to force the verifier to track both branches. */\
+	call %[bpf_get_prandom_u32];			\
+	r0 &= 0x8;					\
+	/* Put a large number into r1. */		\
+	w1 = 0xffff0000;				\
+	r1 += r0;					\
+	/* Assign an ID to r1. */			\
+	r2 = r1;					\
+	/* 8-bit spill r1 to stack - should clear the ID! */\
+	*(u8*)(r10 - 8) = r1;				\
+	/* 8-bit fill r2 from stack. */			\
+	r2 = *(u8*)(r10 - 8);				\
+	/* Compare r2 with another register to trigger find_equal_scalars.\
+	 * Having one random bit is important here, otherwise the verifier cuts\
+	 * the corners. If the ID was mistakenly preserved on spill, this would\
+	 * cause the verifier to think that r1 is also equal to zero in one of\
+	 * the branches, and equal to eight on the other branch.\
+	 */						\
+	r3 = 0;						\
+	if r2 != r3 goto l0_%=;				\
+l0_%=:	r1 >>= 16;					\
+	/* At this point, if the verifier thinks that r1 is 0, an out-of-bounds\
+	 * read will happen, because it actually contains 0xffff.\
+	 */						\
+	r6 += r1;					\
+	r0 = *(u32*)(r6 + 0);				\
+	exit;						\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
 char _license[] SEC("license") = "GPL";
-- 
2.40.1


