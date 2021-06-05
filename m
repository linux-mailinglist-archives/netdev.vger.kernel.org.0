Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB9C539C94B
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 17:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhFEPEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 11:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbhFEPEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 11:04:07 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A38C061766;
        Sat,  5 Jun 2021 08:02:06 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id t4-20020a1c77040000b029019d22d84ebdso9603361wmi.3;
        Sat, 05 Jun 2021 08:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kfu2ptD2ITo1yADGY8rjCJADPHQPd4t7J8UfxydCp7M=;
        b=ry54s2oAYBkXBGGXQ70Mn4BmDExiJmHZ35MkCXDypFXAPrTs/9WZYvg+W/RCPz7ufz
         Zqkhl79sGc13ylXy7fUD9ZX4cU3dMunz3sUvTU8tA+2Uqy+2DwUvuJwJBZ+A46fzVXYm
         MNxgwYSa90MuGM5TN/838Z5CpYKvDdb1G/oIX/wqtfKFSyAluLMj6IGUx2njS1GHyEeu
         7Kmh8O+3tsq766GvnKh+SHgjzqs7gmBBnIDmByYrDkwzNh59XwBmtml74QGe8r6KOQs6
         z8MSCgQ8AEb6UEjXM+OnSkadhBrLazZ2+ffK6HMAGyQIqi4M7QVI1eO6tEEZoYd/7Fa6
         3AUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kfu2ptD2ITo1yADGY8rjCJADPHQPd4t7J8UfxydCp7M=;
        b=WDuGa6GCR7zBcZyMG7J/hLL4PbH+4ap32nyingLOan5yXYWabPuLE1ZpHcjRsJMy2l
         EyfnqefhCkoFKzrKgbuajpwUK6KwIFNz4RUwvsU6nLPaDFvcQ6UvEzKidgwa3+KAFzcb
         1bPL3chgjVmK2OUHpq8BL+F0kGYw3x+UEm86RQXW/FtKPel/A8kUS/3kkk3/HU/blX+e
         i0udutoMcEU/7wvrmi9FG4D5/K5nT4TqjC3LKalXpjfQWWm/Iv0uYoea4byEAXda7O9n
         Wa9S6mGdVCUot3somT/JOTUR/dHrGl9/X1TtBPfxfenuSyo9drqWTFOaAUpYuAKFRCji
         J/wA==
X-Gm-Message-State: AOAM533nAwhGtIsNu/2/1hd0Yn7rUn8/jnOVdExfgDWH2anD7wSSH8H4
        AFRpIx/VJiX+gD/ZhgQgFtE=
X-Google-Smtp-Source: ABdhPJwAAAyC+wSe2y/n4iQCBYMSmsvtjkPPMvSlSCLxfHAg3UHa1eZY2av8EQlMhd/N99YUdarnHg==
X-Received: by 2002:a7b:c417:: with SMTP id k23mr8301705wmi.71.1622905323250;
        Sat, 05 Jun 2021 08:02:03 -0700 (PDT)
Received: from localhost.localdomain ([185.199.80.151])
        by smtp.gmail.com with ESMTPSA id n13sm11202523wrg.75.2021.06.05.08.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jun 2021 08:02:02 -0700 (PDT)
From:   Kurt Manucredo <fuzzybritches0@gmail.com>
To:     syzbot+bed360704c521841c85d@syzkaller.appspotmail.com
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com, nathan@kernel.org,
        ndesaulniers@google.com, clang-built-linux@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org, gregkh@linuxfoundation.org,
        Kurt Manucredo <fuzzybritches0@gmail.com>
Subject: [PATCH v4] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
Date:   Sat,  5 Jun 2021 15:01:57 +0000
Message-Id: <87609-531187-curtm@phaethon>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <YLhd8BL3HGItbXmx@kroah.com>
References: <000000000000c2987605be907e41@google.com> <20210602212726.7-1-fuzzybritches0@gmail.com> <YLhd8BL3HGItbXmx@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot detects a shift-out-of-bounds in ___bpf_prog_run()
kernel/bpf/core.c:1414:2.

I propose: In adjust_scalar_min_max_vals() move boundary check up to avoid
missing them and return with error when detected.

Reported-and-tested-by: syzbot+bed360704c521841c85d@syzkaller.appspotmail.com
Signed-off-by: Kurt Manucredo <fuzzybritches0@gmail.com>
---

https://syzkaller.appspot.com/bug?id=edb51be4c9a320186328893287bb30d5eed09231

Changelog:
----------
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

 kernel/bpf/verifier.c | 30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 94ba5163d4c5..ed0eecf20de5 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7510,6 +7510,15 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 	u32_min_val = src_reg.u32_min_value;
 	u32_max_val = src_reg.u32_max_value;
 
+	if ((opcode == BPF_LSH || opcode == BPF_RSH || opcode == BPF_ARSH) &&
+			umax_val >= insn_bitness) {
+		/* Shifts greater than 31 or 63 are undefined.
+		 * This includes shifts by a negative number.
+		 */
+		verbose(env, "invalid shift %lld\n", umax_val);
+		return -EINVAL;
+	}
+
 	if (alu32) {
 		src_known = tnum_subreg_is_const(src_reg.var_off);
 		if ((src_known &&
@@ -7592,39 +7601,18 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
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
-- 
2.30.2

