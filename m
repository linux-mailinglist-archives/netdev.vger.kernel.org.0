Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB9B810954
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 16:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfEAOoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 10:44:32 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40161 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbfEAOo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 10:44:28 -0400
Received: by mail-wr1-f67.google.com with SMTP id h4so24826307wre.7
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 07:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4PhqNPiSqjy6RvT1L5F3ZJfcVXgolepWydbYAX8a/TA=;
        b=v7lhsvmWcpdzEU6MC/fSnCTt1ZoCB5axIdPdKmnGhBZ1SPyQclDshrc/g6dMzHb5sC
         /RUU2lfGFtqpEfR2LQujN9xf5LHS7NH6iH4/xkAeo8fTO5VJt5JJ7XwRnnyFPOrdItLd
         x1xVt2lV3igF3y0KLxLk45A6QPS/BQZT2UVq1rUvOixNEzruNzmWZ86vIo3haiLlcK/T
         3PhJ9Ap7kEQej6C5M6JgkBQO8BHJ133Q/HawL90bDMe8HJYA3fkylA4Difbmsm4BcUI5
         3BKzRfoMHJri8rIVubwRWTydlmYygqSJ+bi9reJBNJG5Sz6glg0StFjzdhGDm1CrWikF
         6BSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4PhqNPiSqjy6RvT1L5F3ZJfcVXgolepWydbYAX8a/TA=;
        b=Hv7NCtVQSRCPBG6U91QLn/puUinvP/pnpzAPhQuj7ELExm1haf0WBcBsWf4mCrp7xa
         B+cR/QSW9Y7TrfPpQXOCACAkHKCdKenZuXSqI1oWX8v/jfTKewPa+CEs6pXUdKJzKE+6
         XyZ7eCN9r62rLYw5BxzYA8hTtHx3mk/E3uT4L0tafg+C0NlVKKRhV+zX3/0+y+2vnlYk
         IzcI9a7kFwNY8S6e4MLOi3d3RYTrBKdQyApkRDsais5pJ5h2npmYtJw0JuKEeTO96uBS
         2c/pp+577jhovpOUqI0hu+GXnWvZBKvayODo2xiipvnIQDG2PoigopiKOfhh/w7Fu2d4
         MWNw==
X-Gm-Message-State: APjAAAXpG9gLTfyCMdlnYU9mqqddohKfqCFk9Gdc6p55VjzmDtOk67fV
        7lTKaXRhM31VMVRkRGO99i06Iw==
X-Google-Smtp-Source: APXvYqx9E0yFYVjTY/nx8TK1UYmZJdN1rjcAB1HH4Dcnw7hqf0xTX59OxhRcze7jS5iI77j1bn4uOA==
X-Received: by 2002:a5d:4b8f:: with SMTP id b15mr3645427wrt.191.1556721865850;
        Wed, 01 May 2019 07:44:25 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id g10sm36164976wrq.2.2019.05.01.07.44.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 01 May 2019 07:44:25 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>,
        Wang YanQing <udknight@gmail.com>
Subject: [PATCH v5 bpf-next 15/17] x32: bpf: eliminate zero extension code-gen
Date:   Wed,  1 May 2019 15:44:00 +0100
Message-Id: <1556721842-29836-16-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556721842-29836-1-git-send-email-jiong.wang@netronome.com>
References: <1556721842-29836-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cc: Wang YanQing <udknight@gmail.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 arch/x86/net/bpf_jit_comp32.c | 39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
index 0d9cdff..8b2576e 100644
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -567,7 +567,7 @@ static inline void emit_ia32_alu_r(const bool is64, const bool hi, const u8 op,
 static inline void emit_ia32_alu_r64(const bool is64, const u8 op,
 				     const u8 dst[], const u8 src[],
 				     bool dstk,  bool sstk,
-				     u8 **pprog)
+				     u8 **pprog, const struct bpf_prog_aux *aux)
 {
 	u8 *prog = *pprog;
 
@@ -575,7 +575,7 @@ static inline void emit_ia32_alu_r64(const bool is64, const u8 op,
 	if (is64)
 		emit_ia32_alu_r(is64, true, op, dst_hi, src_hi, dstk, sstk,
 				&prog);
-	else
+	else if (!aux->verifier_zext)
 		emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
 	*pprog = prog;
 }
@@ -666,7 +666,8 @@ static inline void emit_ia32_alu_i(const bool is64, const bool hi, const u8 op,
 /* ALU operation (64 bit) */
 static inline void emit_ia32_alu_i64(const bool is64, const u8 op,
 				     const u8 dst[], const u32 val,
-				     bool dstk, u8 **pprog)
+				     bool dstk, u8 **pprog,
+				     const struct bpf_prog_aux *aux)
 {
 	u8 *prog = *pprog;
 	u32 hi = 0;
@@ -677,7 +678,7 @@ static inline void emit_ia32_alu_i64(const bool is64, const u8 op,
 	emit_ia32_alu_i(is64, false, op, dst_lo, val, dstk, &prog);
 	if (is64)
 		emit_ia32_alu_i(is64, true, op, dst_hi, hi, dstk, &prog);
-	else
+	else if (!aux->verifier_zext)
 		emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
 
 	*pprog = prog;
@@ -1642,6 +1643,10 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 
 		switch (code) {
 		/* ALU operations */
+		/* Explicit zero extension */
+		case BPF_ALU | BPF_ZEXT:
+			emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
+			break;
 		/* dst = src */
 		case BPF_ALU | BPF_MOV | BPF_K:
 		case BPF_ALU | BPF_MOV | BPF_X:
@@ -1690,11 +1695,13 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 			switch (BPF_SRC(code)) {
 			case BPF_X:
 				emit_ia32_alu_r64(is64, BPF_OP(code), dst,
-						  src, dstk, sstk, &prog);
+						  src, dstk, sstk, &prog,
+						  bpf_prog->aux);
 				break;
 			case BPF_K:
 				emit_ia32_alu_i64(is64, BPF_OP(code), dst,
-						  imm32, dstk, &prog);
+						  imm32, dstk, &prog,
+						  bpf_prog->aux);
 				break;
 			}
 			break;
@@ -1713,7 +1720,8 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 						false, &prog);
 				break;
 			}
-			emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
+			if (!bpf_prog->aux->verifier_zext)
+				emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
 			break;
 		case BPF_ALU | BPF_LSH | BPF_X:
 		case BPF_ALU | BPF_RSH | BPF_X:
@@ -1733,7 +1741,8 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 						  &prog);
 				break;
 			}
-			emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
+			if (!bpf_prog->aux->verifier_zext)
+				emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
 			break;
 		/* dst = dst / src(imm) */
 		/* dst = dst % src(imm) */
@@ -1755,7 +1764,8 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 						    &prog);
 				break;
 			}
-			emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
+			if (!bpf_prog->aux->verifier_zext)
+				emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
 			break;
 		case BPF_ALU64 | BPF_DIV | BPF_K:
 		case BPF_ALU64 | BPF_DIV | BPF_X:
@@ -1772,7 +1782,8 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 			EMIT2_off32(0xC7, add_1reg(0xC0, IA32_ECX), imm32);
 			emit_ia32_shift_r(BPF_OP(code), dst_lo, IA32_ECX, dstk,
 					  false, &prog);
-			emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
+			if (!bpf_prog->aux->verifier_zext)
+				emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
 			break;
 		/* dst = dst << imm */
 		case BPF_ALU64 | BPF_LSH | BPF_K:
@@ -1808,7 +1819,8 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 		case BPF_ALU | BPF_NEG:
 			emit_ia32_alu_i(is64, false, BPF_OP(code),
 					dst_lo, 0, dstk, &prog);
-			emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
+			if (!bpf_prog->aux->verifier_zext)
+				emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
 			break;
 		/* dst = ~dst (64 bit) */
 		case BPF_ALU64 | BPF_NEG:
@@ -2367,6 +2379,11 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 	return proglen;
 }
 
+bool bpf_jit_hardware_zext(void)
+{
+	return false;
+}
+
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 {
 	struct bpf_binary_header *header = NULL;
-- 
2.7.4

