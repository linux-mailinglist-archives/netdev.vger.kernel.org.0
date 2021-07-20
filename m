Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B99A3D050E
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 01:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233801AbhGTWbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 18:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233543AbhGTWat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 18:30:49 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E8CC0613E0
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 16:11:15 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id nd37so439461ejc.3
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 16:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0J4Kjzrympnf9Wt7ZCuovmlD6MDwpBP3vMPXhqXkxvw=;
        b=eqd+dnBT8WYqDFmI4jRUZp3mFVwGp/fP2kh0p0aaQ9ZiokbqGMpHJJbN5z5kZCTqAf
         1zLLMBslGqON9D6jU1fLmnolXXmwuXlayGKdL0ShtUqym1qzwkIzXJ3F7ayTP/qLvfBf
         GIw1poysuQH/2GIPelOQS+QP9FJ5iRJVFN685/S8InLRsIfE3oe3n7Al7ySpLIO/biNp
         QJZRbDAn+cuPlu/B7uA4oL+5FRIoDvi5NvE606R3DOxiEMOotytOiwMrOGr5mOyy2529
         215zpYxeYxjBsnl7eZ8MEgR/7XVoCijrN9bmac4SuigWc/fMaClmEmvWf+nQyJJkp3gE
         pbjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0J4Kjzrympnf9Wt7ZCuovmlD6MDwpBP3vMPXhqXkxvw=;
        b=R1r2pXW7qrQECyjIsumYN5UCg1AEPy9sGh8Kmc6NiWnh/rauoqbdKrnY6VtPGNWgBB
         xjLtXM+aPBj4szZpd+YUER0Ao1nq172lLcgICLkVdTDb85Np7cKmJsjfQkOiN+XmMaGK
         p3gwBjDBwgASTaXr7wSyhFuAglaW3qqTzHGQTwLGlniixFbNELjSEgA0RY4uue+ahr7O
         M0gDypPaFQ6ym6j/tgluVFTHDq0IbAD+Tp02iSLmRXQnseE2fT1ygVCyUGTMMtMUYKRi
         g7YFpziLABa/Il9n9SrBYBGtr6pjfPDV+iH3g61v4FD/4UdzuDdWD2037vbXA/TII2nK
         +NTQ==
X-Gm-Message-State: AOAM531mbzDvCWklfgTSsEgIq5r6VSgbBqVOWPX61bYnEyGrfs3rOKAk
        4THkXxQSnQOJ+OXAqxbU5OcTaw==
X-Google-Smtp-Source: ABdhPJx6AUAHwvdF+gGk4HFgGaqNKgSH2AfedcPduYs2qxmlOe/W+sDBexvtsAImHk9B7+nZlhVIgQ==
X-Received: by 2002:a17:906:4551:: with SMTP id s17mr34310633ejq.26.1626822673724;
        Tue, 20 Jul 2021 16:11:13 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id d10sm9778303edh.62.2021.07.20.16.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 16:11:13 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     Tony.Ambardar@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, tsbogend@alpha.franken.de, paulburton@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-mips@vger.kernel.org, ddaney@caviumnetworks.com,
        luke.r.nels@gmail.com, fancer.lancer@gmail.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [RFC PATCH 0/2] mips: bpf: An eBPF JIT implementation for 32-bit MIPS
Date:   Wed, 21 Jul 2021 01:10:34 +0200
Message-Id: <20210720231036.3740924-1-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

I have been working on this JIT during last couple of weeks, following
my initial questions and thoughs around this in April ("Completing eBPF
JIT support for MIPS32"). Perhaps I should have been clearer that I
intended to add the missing functionality, but when I received no response,
no activity on the subject since 2019, and with MIPS the company switching
to RISC-V, I frankly did not think anyone else was interested. I was not
aware that Tony was working on the same thing. Anyway, here it goes.

This is an implementation of an eBPF JIT for MIPS I-V and MIPS32. The
implementation supports all 32-bit and 64-bit ALU and JMP operations,
including the recently-added atomics. 64-bit div/mod and 64-bit atomics
are implemented using function calls to math64 and atomic64 functions,
respectively. All 32-bit operations are implemented natively by the JIT.

The implemention is intended to provide good ALU32 performance, and
completeness for ALU64 instructions so it never has to fall back to the
interpreter. Care has also been taken to make the code as simple and
clean as possible. Complex and input-sensitive logic that is hard to
test has intentionally been avoided, especially for ALU64 operations.
The JIT relies on the verifier to do more complex analysis such as
explicit zero-extension.

Relation to the MIPS64 JIT
==========================
The decision to not extend the existing MIPS64 JIT with 32-bit support
was made for the following reasons.

First, the 64-bit JIT is already very complex. It contains its own static
analyzer for doing zero- and sign-extensions on 32-bit values. That is
complexity not needed for the 32-bit JIT.

Second, the 32-bit JIT has more in common with other 32-bit JITs, say, ARM,
than MIPS64. The register mapping will be different. ALU32 operations are
different. ALU64 operations are different. JMP/JMP32 operations are different.
What is native word size and easy on one is emulated and difficult on the
other, and vice-versa.

There may of course be utility code that can be shared between the two
JITs, but as a whole the 32-bit and 64-bit JITs are likely easier to
test and maintain as separate, dedicated implementations rather than as
one big JIT that needs to handle a super-set of the combined omplexity.

Register mapping
================
All 64-bit eBPF registers are mapped to native 32-bit MIPS register pairs,
and does not use any stack scratch space for register swapping. This means
that all eBPF register data is kept in CPU registers all the time, which
is good for performance of course. It also simplifies the register management
a lot and reduces the hunger for temporary registers since we do not have
to move data around.

Native register pairs are ordered according to CPU endianness, following the
O32 calling convention for passing 64-bit arguments and return values. The
eBPF return value, arguments and callee-saved registers are mapped to their
native MIPS equivalents.

Since the 32 highest bits in the eBPF FP (frame pointer) register are
always zero, only one general-purpose register is actually needed for the
mapping. The MIPS fp register is used for this purpose. The high bits are
mapped to MIPS register r0. This saves us one CPU register, which is much
needed for temporaries, while still allowing us to treat the R10 (FP)
register just like any other eBPF register in the JIT.

The MIPS gp (global pointer) and at (assembler temporary) registers are
used as internal temporary registers for constant blinding. CPU registers
t6-t9 are used internally by the JIT when constructing more complex 64-bit
operations. This is precisely what is needed - two registers to store an
immediate operand value, and two more as scratch registers to perform the
operation.

The register mapping is shown below.

    R0 - $v1, $v0   return value
    R1 - $a1, $a0   argument 1, passed in registers
    R2 - $a3, $a2   argument 2, passed in registers
    R3 - $t1, $t0   argument 3, passed on stack
    R4 - $t3, $t2   argument 4, passed on stack
    R5 - $t4, $t3   argument 5, passed on stack
    R6 - $s1, $s0   callee-saved
    R7 - $s3, $s2   callee-saved
    R8 - $s5, $s4   callee-saved
    R9 - $s7, $s6   callee-saved
    FP - $r0, $fp   32-bit frame pointer
    AX - $gp, $at   constant-blinding
         $t6 - $t9  unallocated, JIT temporaries

Jump offsets
============
The JIT tries to map all conditional JMP operations to MIPS conditional
PC-relative branches. The MIPS branch offset field is 18 bits, in bytes,
which is equivalent to the eBPF 16-bit instruction offset. However, since
the JIT may emit more than one CPU instruction per eBPF instruction, the
value may overflow the field width. If that happens, the JIT converts the
long conditional jump to a short PC-relative branch with the condition
inverted, jumping over a long unconditional absolute jmp (ja).

This conversion will change the instruction offset mapping used for jumps,
and may in turn result in more branch offset overflows. The JIT therefore
dry-runs the translation until no more branches are converted and the
offsets do not change anymore. There is an upper bound on this of course,
and if the JIT hits that limit, the last two iterations are run with all
branches being converted.

Testing
=======
The implementation has been verified with the BPF test suite on QEMU,
emulating MIPS32r2 in big and little endian configurations. It has also
been verified on a MIPS 24Kc CPU (MT7628 SoC, little endian). The MIPS
I-V variants that exist for some operations has been verified "manually"
by forcing fallback to pre-r1 instructions only. As of this writing, the
BPF test suite JITs all tests successfully.

    test_bpf: Summary: 378 PASSED, 0 FAILED, [366/366 JIT'ed]

During the development of this JIT, several new tests were added to the
test suite in order to test corner cases inherent to 32-bit JITs, tail
calls and also to actually trigger the branch conversion handling. That
is another patch set, though.

Cheers,
Johan

Johan Almbladh (2):
  mips: bpf: add eBPF JIT for 32-bit MIPS
  mips: bpf: enable 32-bit eBPF JIT

 arch/mips/Kconfig           |    5 +-
 arch/mips/net/Makefile      |    7 +-
 arch/mips/net/ebpf_jit_32.c | 2207 +++++++++++++++++++++++++++++++++++
 3 files changed, 2216 insertions(+), 3 deletions(-)
 create mode 100644 arch/mips/net/ebpf_jit_32.c

-- 
2.25.1

