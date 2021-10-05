Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6905422E75
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 18:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236596AbhJEQ4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 12:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235045AbhJEQ4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 12:56:14 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5A7C06174E
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 09:54:23 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id l7so1347413edq.3
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 09:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AThnfolXuZ529NtB5LKihF2wmMfRdDNyNSiSwp98fs8=;
        b=4+X9ouq5HXNPyoHRUqthn6uVP65T9QZB6aYRLDNhJ7n9nv2BR0Drt2gxlPS0X5v1Y1
         XOENziChQb++J4catuF6JRJObQsmupCfCIIdegfvre1UZDWVq4cBnUclxuj6BtyRtF2E
         dnIOOZxZwmWgUDnb15Den090RYV43kIB3y9K/pHoXI1DngOQo6KdXRBAZBzcl8fXZjZZ
         5DHBm1kxGVH9mA7I76qdl8J6u2Lz60v3nNuVO/BhjAoWF1WV9W2gVudsoS57BBLV/2eg
         tu9EgsCsBcUPDPUkpN73ZqPW7+8fe7WcDJzLE28Bpk2lgqhLg+Zku5jM+s7jBSVfis6V
         uOXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AThnfolXuZ529NtB5LKihF2wmMfRdDNyNSiSwp98fs8=;
        b=xLyRGTDGeOHVtD6EaJCiuR20k1xWI0ZQWddyPkgX1iyk9V06EgeBC1f8Qg9UrHPmO0
         FUEcuP3uXSsaXqAbtmVXfBKTNBsY7QBwwT/HYCcsk3oTjLOtFIzLXSvEH4jZfROb93yV
         VpvdoRQXLcqp77nHRav+dZHZLHhZ4OVM9hlbzuB9SDtRKEgUru4sHB58HysuOm98CXTv
         HfUGnj68adauezUuUaMDQTlc2k9R9xFWNqIxZbwvGk7rCXO8heHtk8kCI0F48KHIyDjq
         gg2G+zyVvHqMDMbjsnjP9YAmjXsYVDKdaj7b+8H9qCkGWfdmh2uZuAIqBApLbzAaQ50h
         oVQA==
X-Gm-Message-State: AOAM533d4g9hL3mDtyh0c550TZnkce2u3lyHD/0v5Azh05Y6CL3f9G7q
        b7IR//g934sniRekd5BCS+1DzA==
X-Google-Smtp-Source: ABdhPJwhlkxDR5I30YBtmBfdnuOV5VwESSc5loETkUvMCrFe+b8zm67oRSkkUrt2CJt3y8s1JubAag==
X-Received: by 2002:a50:bf48:: with SMTP id g8mr27156806edk.10.1633452861628;
        Tue, 05 Oct 2021 09:54:21 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id x16sm3447818ejj.8.2021.10.05.09.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 09:54:21 -0700 (PDT)
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
Subject: [PATCH 0/7] A new eBPF JIT implementation for MIPS
Date:   Tue,  5 Oct 2021 18:54:01 +0200
Message-Id: <20211005165408.2305108-1-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an implementation of an eBPF JIT for MIPS I-V and MIPS32/64 r1-r6.
The new JIT is written from scratch, but uses the same overall structure
as other eBPF JITs.

Before, the MIPS JIT situation looked like this.

  - 32-bit: MIPS32, cBPF-only, tests fail
  - 64-bit: MIPS64r2-r6, eBPF, tests fail, incomplete eBPF ISA support

The new JIT implementation raises the bar to the following level.

  - 32/64-bit: all MIPS ISA, eBPF, all tests pass, full eBPF ISA support

Overview
========
The implementation supports all 32-bit and 64-bit eBPF instructions
defined as of this writing, including the recently-added atomics. It is
intended to provide good performance for native word size operations,
while also being complete so the JIT never has to fall back to the
interpreter. The new JIT replaces the current cBPF and eBPF JITs for MIPS.

The implementation is divided into separate files as follows. The source
files contains comments describing internal mechanisms and details on
things like eBPF-to-CPU register mappings, so I won't repeat that here.

  - jit_comp.[ch]    code shared between 32-bit and 64-bit JITs
  - jit_comp32.c     32-bit JIT implementation
  - jit_comp64.c     64-bit JIT implementation

Both the 32-bit and 64-bit versions map all eBPF registers to native MIPS
CPU registers. There are also enough unmapped CPU registers available to
allow all eBPF operations implemented natively by the JIT to use only CPU
registers without having to resort to stack scratch space.

Some operations are deemed too complex to implement natively in the JIT.
Those are instead implemented as a function call to a helper that performs
the operation. This is done in the following cases.

  - 64-bit div and mod on a 32-bit CPU
  - 64-bit atomics on a 32-bit CPU
  - 32-bit atomics on a 32-bit CPU that lacks ll/sc instructions

CPU errata workarounds
======================
The JIT implements workarounds for R10000, Loongson-2F and Loongson-3 CPU
errata. For the Loongson workarounds, I have used the public information
available on the matter.

Link: https://sourceware.org/legacy-ml/binutils/2009-11/msg00387.html

Loongson people: could you please check if my understanding is correct,
                 especially for the Loongson-2F jump errata?

Testing
=======
During the development of the JIT, I have added a number of new test cases
to the test_bpf.ko test suite to be able to verify correctness of JIT
implementations in a more systematic way. The new additions increase the
test suite roughly three-fold, with many of the new tests being very
extensive and even exhaustive when feasible.

Link: https://lore.kernel.org/bpf/20211001130348.3670534-1-johan.almbladh@anyfinetworks.com/
Link: https://lore.kernel.org/bpf/20210914091842.4186267-1-johan.almbladh@anyfinetworks.com/
Link: https://lore.kernel.org/bpf/20210809091829.810076-1-johan.almbladh@anyfinetworks.com/

The JIT has been tested by running the test_bpf.ko test suite in QEMU with
the following MIPS ISAs, in both big and little endian mode, with and
without JIT hardening enabled.

  MIPS32r2, MIPS32r6, MIPS64r2, MIPS64r6

For the QEMU r2 targets, the correctness of pre-r2 code emitted has been
tested by manually overriding each of the following macros with 0.

  cpu_has_llsc, cpu_has_mips_2, cpu_has_mips_r1, cpu_has_mips_r2

Similarly, CPU errata workaround code has been tested by enabling the
each of the following configurations for the MIPS64r2 targets.

  CONFIG_WAR_R10000
  CONFIG_CPU_LOONGSON3_WORKAROUNDS
  CONFIG_CPU_NOP_WORKAROUNDS
  CONFIG_CPU_JUMP_WORKAROUNDS

The JIT passes all tests in all configurations. Below is the summary for
MIPS32r2 in little endian mode.

  test_bpf: Summary: 1006 PASSED, 0 FAILED, [994/994 JIT'ed]
  test_bpf: test_tail_calls: Summary: 8 PASSED, 0 FAILED, [8/8 JIT'ed]
  test_bpf: test_skb_segment: Summary: 2 PASSED, 0 FAILED

According to MIPS ISA reference documentation, the result of a 32-bit ALU
arithmetic operation on a 64-bit CPU is unpredictable if an operand
register value is not properly sign-extended to 64 bits. To verify the
code emitted by the JIT, the code generation engine in QEMU was modifed to
flip all low 32 bits if the above condition was not met. With this
trip-wire installed, the kernel booted properly in qemu-system-mips64el
and all test_bpf.ko tests passed.

Remaining features
==================
While the JIT is complete is terms of eBPF ISA support, this series does
not include support for BPF-to-BPF calls and BPF trampolines. Those
features are planned to be added in another patch series.

The BPF_ST | BPF_NOSPEC instruction currently emits nothing. This is
consistent with the behavior if the MIPS interpreter and the existing
eBPF JIT.

Why not build on the existing eBPF JIT?
=======================================
The existing eBPF JIT was originally written for MIPS64. An effort was
made to add MIPS32 support to it in commit 716850ab104d ("MIPS: eBPF:
Initial eBPF support for MIPS32 architecture."). That turned out to
contain a number of flaws, so eBPF support for MIPS32 was disabled in
commit 36366e367ee9 ("MIPS: BPF: Restore MIPS32 cBPF JIT").

Link: https://lore.kernel.org/bpf/5deaa994.1c69fb81.97561.647e@mx.google.com/

The current eBPF JIT for MIPS64 lacks a lot of functionality regarding
ALU32, JMP32 and atomic operations. It also lacks 32-bit CPU support on a
fundamental level, for example 32-bit CPU register mappings and o32 ABI
calling conventions. For optimization purposes, it tracks register usage
through the program control flow in order to do zero-extension and sign-
extension only when necessary, a static analysis of sorts. In my opinion,
having this kind of complexity in JITs, and for which there is not
adequate test coverage, is a problem. Such analysis should be done by the
verifier, if needed at all. Finally, when I run the BPF test suite
test_bpf.ko on the current JIT, there are errors and warnings.

I believe that an eBPF JIT should strive to be correct, complete and
optimized, and in that order. The JIT runs after the verifer has audited
the program and given its approval. If the JIT then emits code that does
something else, it will undermine the eBPF security model. A simple
implementation is easier to get correct than a complex one. Furthermore,
the real performance hit is not an extra CPU instruction here and there,
but when the JIT bails on an unimplemented eBPF instruction and cause the
whole program to fall back to the interpreter. My reasoning here boils
down to the following.

* The JIT should not contain a static analyzer that tracks branches.

* It is acceptable to emit possibly superfluous sign-/zero-extensions for
  ALU32 and JMP32 operations on a 64-bit MIPS to guarantee correctness.

* The JIT should handle all eBPF instructions on all MIPS CPUs.

I conclude that the current eBPF MIPS JIT is complex, incomplete and
incorrect. For the reasons stated above, I decided to not use the existing
JIT implementation.

Johan

Tony Ambardar (1):
  MIPS: uasm: Enable muhu opcode for MIPS R6

Johan Almbladh (6):
  mips: uasm: Add workaround for Loongson-2F nop CPU errata
  mips: bpf: Add eBPF JIT for 32-bit MIPS
  mips: bpf: Add new eBPF JIT for 64-bit MIPS
  mips: bpf: Add JIT workarounds for CPU errata
  mips: bpf: Enable eBPF JITs
  mips: bpf: Remove old BPF JIT implementations

 MAINTAINERS                    |    1 +
 arch/mips/Kconfig              |    6 +-
 arch/mips/include/asm/uasm.h   |    5 +
 arch/mips/mm/uasm-mips.c       |    4 +-
 arch/mips/mm/uasm.c            |    3 +-
 arch/mips/net/Makefile         |    8 +-
 arch/mips/net/bpf_jit.c        | 1299 ---------------------
 arch/mips/net/bpf_jit.h        |   81 --
 arch/mips/net/bpf_jit_asm.S    |  285 -----
 arch/mips/net/bpf_jit_comp.c   | 1034 +++++++++++++++++
 arch/mips/net/bpf_jit_comp.h   |  235 ++++
 arch/mips/net/bpf_jit_comp32.c | 1899 +++++++++++++++++++++++++++++++
 arch/mips/net/bpf_jit_comp64.c | 1054 +++++++++++++++++
 arch/mips/net/ebpf_jit.c       | 1938 --------------------------------
 14 files changed, 4244 insertions(+), 3608 deletions(-)
 delete mode 100644 arch/mips/net/bpf_jit.c
 delete mode 100644 arch/mips/net/bpf_jit.h
 delete mode 100644 arch/mips/net/bpf_jit_asm.S
 create mode 100644 arch/mips/net/bpf_jit_comp.c
 create mode 100644 arch/mips/net/bpf_jit_comp.h
 create mode 100644 arch/mips/net/bpf_jit_comp32.c
 create mode 100644 arch/mips/net/bpf_jit_comp64.c
 delete mode 100644 arch/mips/net/ebpf_jit.c

-- 
2.30.2

