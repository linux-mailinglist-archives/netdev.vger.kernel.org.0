Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB91E1917DC
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 18:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgCXRkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 13:40:33 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46017 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727266AbgCXRkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 13:40:33 -0400
Received: by mail-pl1-f195.google.com with SMTP id b9so7678724pls.12;
        Tue, 24 Mar 2020 10:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Ck0AiSEShsYY51eI4io64RTsZCIc8FycLmmK1k8i8KY=;
        b=TNQWoRo/BKO/Kglo/IjI6b2BnIK2akAajJsWExL68j9JCfaAS8+AQ0hEoDnnH0iKlm
         GTbug+Eh6SKH7/MAWz1/SvreeMVdly+sFqES+z2yI9iLW7ng6s4KLT3MTGB3UW+uVwbR
         2Psmt6mgna3b8HUd29BwPjx/J894hl4rUvZyzFC77sPwEvriBXCyEPBgJ9+/xd3I9SqP
         L85aIGvarRMYQxs4quyLcmF7wWBM6X1vz37kG8JpCGmxtsb+ubxxsGfragU7Kc8HxnWR
         vqs6RAYWkdZV2sbyNnVwhOi87WMYEVpRHmyublgT7H389VdvLd42i12DX4s18W4iR3Rp
         vZ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Ck0AiSEShsYY51eI4io64RTsZCIc8FycLmmK1k8i8KY=;
        b=nwecEYweuJ/shTrKoLBddMezfGvvafxUUqksUajZqbdridY+JCUUPTgkAbYPGpQiEQ
         viTSQ8db+B6wqlLKVTOwx1kBeePmbGi6KMbEllXyzRWse4FL4SVPaPRHweOS1Uyd157+
         AwoiSC2OG2ytW4qQch1Qi/1Vo34Ldg1sz/ESAiU3TblrnYkEEUTv1wXHGVvvQjvFOGMK
         fStQ8O/rB8oLH0AN3ee2Dq1HMZsqBORjR8yzd/CIz2O6bhLUYj1b4ySzdwLXMH2L5ron
         IR5Uc6I2y+tMUUDMCrAZugjfiaM3rYwBTCw/uLvEu6Bj9h0cFm46R4nvInlCCnHZBu1p
         GB3g==
X-Gm-Message-State: ANhLgQ2G9J9hqUvIgOumSAmw4gyN6TBxgQeisTVnLEE9T/TQWbQOesxn
        aphyg+E+5liJKEsGvgWFl5k=
X-Google-Smtp-Source: ADFU+vsTZFTltyjY5DCZeZcZmfJQJ8B6HIfW1dsKrXi1g4EbmbGK2bvVKdLok2BhzOi0qWMQoWyvMQ==
X-Received: by 2002:a17:90a:1946:: with SMTP id 6mr6927190pjh.42.1585071629957;
        Tue, 24 Mar 2020 10:40:29 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id e10sm16586773pfm.121.2020.03.24.10.40.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Mar 2020 10:40:29 -0700 (PDT)
Subject: [bpf-next PATCH 08/10] bpf: test_verifier,
 #70 error message updates for 32-bit right shift
From:   John Fastabend <john.fastabend@gmail.com>
To:     ecree@solarflare.com, yhs@fb.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Tue, 24 Mar 2020 10:40:14 -0700
Message-ID: <158507161475.15666.3061518385241144063.stgit@john-Precision-5820-Tower>
In-Reply-To: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
References: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After changes to add update_reg_bounds after ALU ops and adding ALU32
bounds tracking the error message is changed in the 32-bit right shift
tests.

Test "#70/u bounds check after 32-bit right shift with 64-bit input FAIL"
now fails with,

Unexpected error message!
	EXP: R0 invalid mem access
	RES: func#0 @0

7: (b7) r1 = 2
8: R0_w=map_value(id=0,off=0,ks=8,vs=8,imm=0) R1_w=invP2 R10=fp0 fp-8_w=mmmmmmmm
8: (67) r1 <<= 31
9: R0_w=map_value(id=0,off=0,ks=8,vs=8,imm=0) R1_w=invP4294967296 R10=fp0 fp-8_w=mmmmmmmm
9: (74) w1 >>= 31
10: R0_w=map_value(id=0,off=0,ks=8,vs=8,imm=0) R1_w=invP0 R10=fp0 fp-8_w=mmmmmmmm
10: (14) w1 -= 2
11: R0_w=map_value(id=0,off=0,ks=8,vs=8,imm=0) R1_w=invP4294967294 R10=fp0 fp-8_w=mmmmmmmm
11: (0f) r0 += r1
math between map_value pointer and 4294967294 is not allowed

And test "#70/p bounds check after 32-bit right shift with 64-bit input
FAIL" now fails with,

Unexpected error message!
	EXP: R0 invalid mem access
	RES: func#0 @0

7: (b7) r1 = 2
8: R0_w=map_value(id=0,off=0,ks=8,vs=8,imm=0) R1_w=inv2 R10=fp0 fp-8_w=mmmmmmmm
8: (67) r1 <<= 31
9: R0_w=map_value(id=0,off=0,ks=8,vs=8,imm=0) R1_w=inv4294967296 R10=fp0 fp-8_w=mmmmmmmm
9: (74) w1 >>= 31
10: R0_w=map_value(id=0,off=0,ks=8,vs=8,imm=0) R1_w=inv0 R10=fp0 fp-8_w=mmmmmmmm
10: (14) w1 -= 2
11: R0_w=map_value(id=0,off=0,ks=8,vs=8,imm=0) R1_w=inv4294967294 R10=fp0 fp-8_w=mmmmmmmm
11: (0f) r0 += r1
last_idx 11 first_idx 0
regs=2 stack=0 before 10: (14) w1 -= 2
regs=2 stack=0 before 9: (74) w1 >>= 31
regs=2 stack=0 before 8: (67) r1 <<= 31
regs=2 stack=0 before 7: (b7) r1 = 2
math between map_value pointer and 4294967294 is not allowed

Before this series we did not trip the "math between map_value pointer..."
error because check_reg_sane_offset is never called in
adjust_ptr_min_max_vals(). Instead we have a register state that looks
like this at line 11*,

11: R0_w=map_value(id=0,off=0,ks=8,vs=8,
                   smin_value=0,smax_value=0,
                   umin_value=0,umax_value=0,
                   var_off=(0x0; 0x0))
    R1_w=invP(id=0,
              smin_value=0,smax_value=4294967295,
              umin_value=0,umax_value=4294967295,
              var_off=(0xfffffffe; 0x0))
    R10=fp(id=0,off=0,
           smin_value=0,smax_value=0,
           umin_value=0,umax_value=0,
           var_off=(0x0; 0x0)) fp-8_w=mmmmmmmm
11: (0f) r0 += r1

In R1 'smin_val != smax_val' yet we have a tnum_const as seen
by 'var_off(0xfffffffe; 0x0))' with a 0x0 mask. So we hit this check
in adjust_ptr_min_max_vals()

 if ((known && (smin_val != smax_val || umin_val != umax_val)) ||
      smin_val > smax_val || umin_val > umax_val) {
       /* Taint dst register if offset had invalid bounds derived from
        * e.g. dead branches.
        */
       __mark_reg_unknown(env, dst_reg);
       return 0;
 }

So we don't throw an error here and instead only throw an error
later in the verification when the memory access is made.

The root cause in verifier without alu32 bounds tracking is having
'umin_value = 0' and 'umax_value = U64_MAX' from BPF_SUB which we set
when 'umin_value < umax_val' here,

 if (dst_reg->umin_value < umax_val) {
    /* Overflow possible, we know nothing */
    dst_reg->umin_value = 0;
    dst_reg->umax_value = U64_MAX;
 } else { ...}

Later in adjust_calar_min_max_vals we previously did a
coerce_reg_to_size() which will clamp the U64_MAX to U32_MAX by
truncating to 32bits. But either way without a call to update_reg_bounds
the less precise bounds tracking will fall out of the alu op
verification.

After latest changes we now exit adjust_scalar_min_max_vals with the
more precise umin value, due to zero extension propogating bounds from
alu32 bounds into alu64 bounds and then calling update_reg_bounds.
This then causes the verifier to trigger an earlier error and we get
the error in the output above.

This patch updates tests to reflect new error message.

* I have a local patch to print entire verifier state regardless if we
 believe it is a constant so we can get a full picture of the state.
 Usually if tnum_is_const() then bounds are also smin=smax, etc. but
 this is not always true and is a bit subtle. Being able to see these
 states helps understand dataflow imo. Let me know if we want something
 similar upstream.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/verifier/bounds.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/bounds.c b/tools/testing/selftests/bpf/verifier/bounds.c
index d55f476..7c9b659 100644
--- a/tools/testing/selftests/bpf/verifier/bounds.c
+++ b/tools/testing/selftests/bpf/verifier/bounds.c
@@ -411,16 +411,14 @@
 	BPF_ALU32_IMM(BPF_RSH, BPF_REG_1, 31),
 	/* r1 = 0xffff'fffe (NOT 0!) */
 	BPF_ALU32_IMM(BPF_SUB, BPF_REG_1, 2),
-	/* computes OOB pointer */
+	/* error on computing OOB pointer */
 	BPF_ALU64_REG(BPF_ADD, BPF_REG_0, BPF_REG_1),
-	/* OOB access */
-	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, 0),
 	/* exit */
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_hash_8b = { 3 },
-	.errstr = "R0 invalid mem access",
+	.errstr = "math between map_value pointer and 4294967294 is not allowed",
 	.result = REJECT,
 },
 {

