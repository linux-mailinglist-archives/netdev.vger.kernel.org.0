Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9839B422E87
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 18:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236737AbhJEQ43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 12:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236598AbhJEQ4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 12:56:20 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E921EC061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 09:54:29 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id f9so1340733edx.4
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 09:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jZCUs6oz7uxuE4qpQlLwb6/vYygWhEpO6czCit9ehLM=;
        b=x2XTO9o8XUh8aPibb/iAxiyqH19Jte0iwcptS0QfG1f01B/NJFOgxsNF5w3y8VfOP+
         zehxDErShCl1/ohrxCamU4yuXU3VwGI/F1icl+XAZErqZDYC4HKI09ickHRY0beX1Voa
         l+y1sQoLt/vc1h+aHm+rRtIj/5boQ5pwn20E07RzXroH27765bL+MLXIPzu1DgyXAASY
         +0X5gpvj4jIYM14T2XFfyrj/sQKqoRF//ddzvCbGhWpKe+vqkydJUqqI6Tzv07/Fv8OE
         A7MU0MG078qo2SgaEG2sdE2lYyCCrBbhlYS0mYKdwpk7jaFiARZRVyJSgmfgGS0KRlXb
         nT2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jZCUs6oz7uxuE4qpQlLwb6/vYygWhEpO6czCit9ehLM=;
        b=hcXjkzIv9eyrwE+SCBJzmU3l7FopHsz6NeLSeMoXVxg9dNGciW1vJDtIOKba2B+Odu
         auOmd4BifAYIHQ1c7GuAygJF5ax7OdU2DCDy8QdqQx3j+9rn8ij7nsxNt/UX1bNqs9pv
         op8OMxFBgC1eCZzRchdc7uTVtiMTq+7TpaKtNkE7C6xQ/hnwZBrbocqCngOASM+AKhEo
         6d2gsoep10FSqNEcGMTi/0hETF9/jmc4byF2ZAND8xa2f+rYnKNAec5XWS60F/f+/j/q
         wu0gwcyJEvXOLsIy3zv1u2GAXIYlyzVR+ELapcCFlZrPSbMtEm8G/u6qQW6Ol9EbU/hK
         hZjA==
X-Gm-Message-State: AOAM531WklhlmNiUuaj4K5/GD+Z6jIgo0u2zrKxZ+uE/iRr/ei8rOpBX
        paLP0eHR7eBo8BbZK22t4KFV1w==
X-Google-Smtp-Source: ABdhPJw0lZh1jAjTAMy1L1DDIcVnOOvcPqa9FhYwTfwPI31NcVe6ac2w7cdOMcqCuD2kXLJJMZOdrA==
X-Received: by 2002:a17:906:7c4:: with SMTP id m4mr26232268ejc.553.1633452868479;
        Tue, 05 Oct 2021 09:54:28 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id x16sm3447818ejj.8.2021.10.05.09.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 09:54:28 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        paulburton@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        tsbogend@alpha.franken.de, chenhuacai@kernel.org,
        jiaxun.yang@flygoat.com, yangtiezhu@loongson.cn,
        tony.ambardar@gmail.com, bpf@vger.kernel.org,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH 5/7] mips: bpf: Add JIT workarounds for CPU errata
Date:   Tue,  5 Oct 2021 18:54:06 +0200
Message-Id: <20211005165408.2305108-6-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211005165408.2305108-1-johan.almbladh@anyfinetworks.com>
References: <20211005165408.2305108-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds workarounds for the following CPU errata to the MIPS
eBPF JIT, if enabled in the kernel configuration.

  - R10000 ll/sc weak ordering
  - Loongson-3 ll/sc weak ordering
  - Loongson-2F jump hang

The Loongson-2F nop errata is implemented in uasm, which the JIT uses,
so no additional mitigations are needed for that.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 arch/mips/net/bpf_jit_comp.c   |  6 ++++--
 arch/mips/net/bpf_jit_comp.h   | 26 +++++++++++++++++++++++++-
 arch/mips/net/bpf_jit_comp64.c | 10 ++++++----
 3 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/arch/mips/net/bpf_jit_comp.c b/arch/mips/net/bpf_jit_comp.c
index 7eb95fc57710..b17130d510d4 100644
--- a/arch/mips/net/bpf_jit_comp.c
+++ b/arch/mips/net/bpf_jit_comp.c
@@ -404,6 +404,7 @@ void emit_alu_r(struct jit_context *ctx, u8 dst, u8 src, u8 op)
 /* Atomic read-modify-write (32-bit) */
 void emit_atomic_r(struct jit_context *ctx, u8 dst, u8 src, s16 off, u8 code)
 {
+	LLSC_sync(ctx);
 	emit(ctx, ll, MIPS_R_T9, off, dst);
 	switch (code) {
 	case BPF_ADD:
@@ -427,7 +428,7 @@ void emit_atomic_r(struct jit_context *ctx, u8 dst, u8 src, s16 off, u8 code)
 		break;
 	}
 	emit(ctx, sc, MIPS_R_T8, off, dst);
-	emit(ctx, beqz, MIPS_R_T8, -16);
+	emit(ctx, LLSC_beqz, MIPS_R_T8, -16 - LLSC_offset);
 	emit(ctx, nop); /* Delay slot */
 
 	if (code & BPF_FETCH) {
@@ -439,11 +440,12 @@ void emit_atomic_r(struct jit_context *ctx, u8 dst, u8 src, s16 off, u8 code)
 /* Atomic compare-and-exchange (32-bit) */
 void emit_cmpxchg_r(struct jit_context *ctx, u8 dst, u8 src, u8 res, s16 off)
 {
+	LLSC_sync(ctx);
 	emit(ctx, ll, MIPS_R_T9, off, dst);
 	emit(ctx, bne, MIPS_R_T9, res, 12);
 	emit(ctx, move, MIPS_R_T8, src);     /* Delay slot */
 	emit(ctx, sc, MIPS_R_T8, off, dst);
-	emit(ctx, beqz, MIPS_R_T8, -20);
+	emit(ctx, LLSC_beqz, MIPS_R_T8, -20 - LLSC_offset);
 	emit(ctx, move, res, MIPS_R_T9);     /* Delay slot */
 	clobber_reg(ctx, res);
 }
diff --git a/arch/mips/net/bpf_jit_comp.h b/arch/mips/net/bpf_jit_comp.h
index 44787cf377dd..6f3a7b07294b 100644
--- a/arch/mips/net/bpf_jit_comp.h
+++ b/arch/mips/net/bpf_jit_comp.h
@@ -87,7 +87,7 @@ struct jit_context {
 };
 
 /* Emit the instruction if the JIT memory space has been allocated */
-#define emit(ctx, func, ...)					\
+#define __emit(ctx, func, ...)					\
 do {								\
 	if ((ctx)->target != NULL) {				\
 		u32 *p = &(ctx)->target[ctx->jit_index];	\
@@ -95,6 +95,30 @@ do {								\
 	}							\
 	(ctx)->jit_index++;					\
 } while (0)
+#define emit(...) __emit(__VA_ARGS__)
+
+/* Workaround for R10000 ll/sc errata */
+#ifdef CONFIG_WAR_R10000
+#define LLSC_beqz	beqzl
+#else
+#define LLSC_beqz	beqz
+#endif
+
+/* Workaround for Loongson-3 ll/sc errata */
+#ifdef CONFIG_CPU_LOONGSON3_WORKAROUNDS
+#define LLSC_sync(ctx)	emit(ctx, sync, 0)
+#define LLSC_offset	4
+#else
+#define LLSC_sync(ctx)
+#define LLSC_offset	0
+#endif
+
+/* Workaround for Loongson-2F jump errata */
+#ifdef CONFIG_CPU_JUMP_WORKAROUNDS
+#define JALR_MASK	0xffffffffcfffffffULL
+#else
+#define JALR_MASK	(~0ULL)
+#endif
 
 /*
  * Mark a BPF register as accessed, it needs to be
diff --git a/arch/mips/net/bpf_jit_comp64.c b/arch/mips/net/bpf_jit_comp64.c
index ca49d3ef7ff4..1f1f7b87f213 100644
--- a/arch/mips/net/bpf_jit_comp64.c
+++ b/arch/mips/net/bpf_jit_comp64.c
@@ -375,6 +375,7 @@ static void emit_atomic_r64(struct jit_context *ctx,
 	u8 t1 = MIPS_R_T6;
 	u8 t2 = MIPS_R_T7;
 
+	LLSC_sync(ctx);
 	emit(ctx, lld, t1, off, dst);
 	switch (code) {
 	case BPF_ADD:
@@ -398,7 +399,7 @@ static void emit_atomic_r64(struct jit_context *ctx,
 		break;
 	}
 	emit(ctx, scd, t2, off, dst);
-	emit(ctx, beqz, t2, -16);
+	emit(ctx, LLSC_beqz, t2, -16 - LLSC_offset);
 	emit(ctx, nop); /* Delay slot */
 
 	if (code & BPF_FETCH) {
@@ -414,12 +415,13 @@ static void emit_cmpxchg_r64(struct jit_context *ctx, u8 dst, u8 src, s16 off)
 	u8 t1 = MIPS_R_T6;
 	u8 t2 = MIPS_R_T7;
 
+	LLSC_sync(ctx);
 	emit(ctx, lld, t1, off, dst);
 	emit(ctx, bne, t1, r0, 12);
 	emit(ctx, move, t2, src);      /* Delay slot */
 	emit(ctx, scd, t2, off, dst);
-	emit(ctx, beqz, t2, -20);
-	emit(ctx, move, r0, t1);      /* Delay slot */
+	emit(ctx, LLSC_beqz, t2, -20 - LLSC_offset);
+	emit(ctx, move, r0, t1);       /* Delay slot */
 
 	clobber_reg(ctx, r0);
 }
@@ -443,7 +445,7 @@ static int emit_call(struct jit_context *ctx, const struct bpf_insn *insn)
 	push_regs(ctx, ctx->clobbered & JIT_CALLER_REGS, 0, 0);
 
 	/* Emit function call */
-	emit_mov_i64(ctx, tmp, addr);
+	emit_mov_i64(ctx, tmp, addr & JALR_MASK);
 	emit(ctx, jalr, MIPS_R_RA, tmp);
 	emit(ctx, nop); /* Delay slot */
 
-- 
2.30.2

