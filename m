Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF693A86BA
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 18:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhFOQoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 12:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhFOQod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 12:44:33 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49F0C061574;
        Tue, 15 Jun 2021 09:42:28 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id v9so2771815wrx.6;
        Tue, 15 Jun 2021 09:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5HqZgwKlnzHk7eYEZtH1CaDCUYRbqEaAMkPzJHvXqS0=;
        b=mybjY4le4ctEWGm4xYu2iOggsKW4q3/OyS+MxcoV+4sj4lWFwwnQNlmhPG+4ab8x1U
         eGsvSWvravHxwru85zseEObBLKnmFFAKleEjMXqFeo/AAKK7F6vHUQiMTj+LkjBYl9CB
         ElZy+6UTOxwulqLE/1DJtATQRhuNKzyaBTKdMu9bO2tSvsq/EwMG3Qcbm1oHHuWPvkoc
         JEwU2r3TJyNZ81FlgaipOWrPVgZNpCEz8C5Xr5Id0F15hRR3wGRIexVErFKRcAmYHupS
         u/NOU4f1YPVY6dlllL4AvnoSJ3H1Xo7QDnLZpOjoPAAN2Fe5nt0pyXyroPiQVTWwjCoM
         lLjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5HqZgwKlnzHk7eYEZtH1CaDCUYRbqEaAMkPzJHvXqS0=;
        b=Y1tk3VUNubP4YNdlYYnZN3/+Ol9Z0q3iG8ZOuIrO4Zm8AoGO1bKppmh4i4N0TROIN+
         QxWtyvDOcJOkYDuFOrYfk9TcO4Y7m/YFsgotABqlAIBFyW8VR0i2ogkSs+gx/blIpDRl
         gtHJ3KmMoVp3DIH4rxLeG9szbBQz/fceOoSs94N+So/zZh+xrUNMTK8xuYMEUwnwHKZy
         tEoFi5ceUXMSzgrT2xmmzSP16JmVBA2Zw8oJjyUWoNY/jp+LiS64UO1AQIrwHcpQCXyq
         Zjrl5oStY1ZOBirMyRbalXet+t/FNltm42slgmZ5rR1d+xfFGNWwVlt/hYyd16z+BqZT
         ll7Q==
X-Gm-Message-State: AOAM533RpFDp/ZiyHj6S3ElIgy3t8eku6XaMW6SmGeJTur51mXnZj0X2
        enBnCfl7Zho6zQa9cVLq2CY=
X-Google-Smtp-Source: ABdhPJwp84+Gas8I1iFxMF+l7Gvuia2vMA5qr7ms18jAFHC17zcr6iYbk+siFXsqqCOGOhy2a2vdPw==
X-Received: by 2002:a05:6000:110e:: with SMTP id z14mr26964792wrw.235.1623775347448;
        Tue, 15 Jun 2021 09:42:27 -0700 (PDT)
Received: from localhost.localdomain ([185.199.80.151])
        by smtp.gmail.com with ESMTPSA id t11sm7387549wrz.7.2021.06.15.09.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 09:42:26 -0700 (PDT)
From:   Kurt Manucredo <fuzzybritches0@gmail.com>
To:     ebiggers@kernel.org,
        syzbot+bed360704c521841c85d@syzkaller.appspotmail.com
Cc:     Kurt Manucredo <fuzzybritches0@gmail.com>, keescook@chromium.org,
        yhs@fb.com, dvyukov@google.com, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, nathan@kernel.org,
        ndesaulniers@google.com, clang-built-linux@googlegroups.com,
        kernel-hardening@lists.openwall.com, kasan-dev@googlegroups.com
Subject: [PATCH v5] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
Date:   Tue, 15 Jun 2021 16:42:10 +0000
Message-Id: <85536-177443-curtm@phaethon>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <YMJvbGEz0xu9JU9D@gmail.com>
References: <87609-531187-curtm@phaethon> <6a392b66-6f26-4532-d25f-6b09770ce366@fb.com> <CAADnVQKexxZQw0yK_7rmFOdaYabaFpi2EmF6RGs5bXvFHtUQaA@mail.gmail.com> <CACT4Y+b=si6NCx=nRHKm_pziXnVMmLo-eSuRajsxmx5+Hy_ycg@mail.gmail.com> <202106091119.84A88B6FE7@keescook> <752cb1ad-a0b1-92b7-4c49-bbb42fdecdbe@fb.com> <CACT4Y+a592rxFmNgJgk2zwqBE8EqW1ey9SjF_-U3z6gt3Yc=oA@mail.gmail.com> <1aaa2408-94b9-a1e6-beff-7523b66fe73d@fb.com> <202106101002.DF8C7EF@keescook> <CAADnVQKMwKYgthoQV4RmGpZm9Hm-=wH3DoaNqs=UZRmJKefwGw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot detects a shift-out-of-bounds in ___bpf_prog_run()
kernel/bpf/core.c:1414:2.

The shift-out-of-bounds happens when we have BPF_X. This means we have
to go the same way we go when we want to avoid a divide-by-zero. We do
it in do_misc_fixups().

When we have BPF_K we find divide-by-zero and shift-out-of-bounds guards
next each other in check_alu_op(). It seems only logical to me that the
same should be true for BPF_X in do_misc_fixups() since it is there where
I found the divide-by-zero guard. Or is there a reason I'm not aware of,
that dictates that the checks should be in adjust_scalar_min_max_vals(),
as they are now?

This patch was tested by syzbot.

Reported-and-tested-by: syzbot+bed360704c521841c85d@syzkaller.appspotmail.com
Signed-off-by: Kurt Manucredo <fuzzybritches0@gmail.com>
---

https://syzkaller.appspot.com/bug?id=edb51be4c9a320186328893287bb30d5eed09231

Changelog:
----------
v5 - Fix shift-out-of-bounds in do_misc_fixups().
v4 - Fix shift-out-of-bounds in adjust_scalar_min_max_vals.
     Fix commit message.
v3 - Make it clearer what the fix is for.
v2 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
     check in check_alu_op() in verifier.c.
v1 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
     check in ___bpf_prog_run().

thanks

kind regards

Kurt

 kernel/bpf/verifier.c | 53 +++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 94ba5163d4c5..83c7c1ccaf26 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7496,7 +7496,6 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 	u64 umin_val, umax_val;
 	s32 s32_min_val, s32_max_val;
 	u32 u32_min_val, u32_max_val;
-	u64 insn_bitness = (BPF_CLASS(insn->code) == BPF_ALU64) ? 64 : 32;
 	bool alu32 = (BPF_CLASS(insn->code) != BPF_ALU64);
 	int ret;
 
@@ -7592,39 +7591,18 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 		scalar_min_max_xor(dst_reg, &src_reg);
 		break;
 	case BPF_LSH:
-		if (umax_val >= insn_bitness) {
-			/* Shifts greater than 31 or 63 are undefined.
-			 * This includes shifts by a negative number.
-			 */
-			mark_reg_unknown(env, regs, insn->dst_reg);
-			break;
-		}
 		if (alu32)
 			scalar32_min_max_lsh(dst_reg, &src_reg);
 		else
 			scalar_min_max_lsh(dst_reg, &src_reg);
 		break;
 	case BPF_RSH:
-		if (umax_val >= insn_bitness) {
-			/* Shifts greater than 31 or 63 are undefined.
-			 * This includes shifts by a negative number.
-			 */
-			mark_reg_unknown(env, regs, insn->dst_reg);
-			break;
-		}
 		if (alu32)
 			scalar32_min_max_rsh(dst_reg, &src_reg);
 		else
 			scalar_min_max_rsh(dst_reg, &src_reg);
 		break;
 	case BPF_ARSH:
-		if (umax_val >= insn_bitness) {
-			/* Shifts greater than 31 or 63 are undefined.
-			 * This includes shifts by a negative number.
-			 */
-			mark_reg_unknown(env, regs, insn->dst_reg);
-			break;
-		}
 		if (alu32)
 			scalar32_min_max_arsh(dst_reg, &src_reg);
 		else
@@ -12353,6 +12331,37 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			continue;
 		}
 
+		/* Make shift-out-of-bounds exceptions impossible. */
+		if (insn->code == (BPF_ALU64 | BPF_LSH | BPF_X) ||
+		    insn->code == (BPF_ALU64 | BPF_RSH | BPF_X) ||
+		    insn->code == (BPF_ALU64 | BPF_ARSH | BPF_X) ||
+		    insn->code == (BPF_ALU | BPF_LSH | BPF_X) ||
+		    insn->code == (BPF_ALU | BPF_RSH | BPF_X) ||
+		    insn->code == (BPF_ALU | BPF_ARSH | BPF_X)) {
+			bool is64 = BPF_CLASS(insn->code) == BPF_ALU64;
+			u8 insn_bitness = is64 ? 64 : 32;
+			struct bpf_insn chk_and_shift[] = {
+				/* [R,W]x shift >= 32||64 -> 0 */
+				BPF_RAW_INSN((is64 ? BPF_JMP : BPF_JMP32) |
+					     BPF_JLT | BPF_K, insn->src_reg,
+					     insn_bitness, 2, 0),
+				BPF_ALU32_REG(BPF_XOR, insn->dst_reg, insn->dst_reg),
+				BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+				*insn,
+			};
+
+			cnt = ARRAY_SIZE(chk_and_shift);
+
+			new_prog = bpf_patch_insn_data(env, i + delta, chk_and_shift, cnt);
+			if (!new_prog)
+				return -ENOMEM;
+
+			delta    += cnt - 1;
+			env->prog = prog = new_prog;
+			insn      = new_prog->insnsi + i + delta;
+			continue;
+		}
+
 		/* Implement LD_ABS and LD_IND with a rewrite, if supported by the program type. */
 		if (BPF_CLASS(insn->code) == BPF_LD &&
 		    (BPF_MODE(insn->code) == BPF_ABS ||
-- 
2.30.2

