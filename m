Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37B313CF15C
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 03:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350620AbhGTAqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 20:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349782AbhGTAof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 20:44:35 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A218AC061767
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 18:25:13 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id g19so30556117ybe.11
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 18:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YLvWvlKerKN/PpfL9EIgNV4785R1sfDRbOdMox+npUU=;
        b=DwsUCOwekW3fza3KbT7lxe8XqDEF7C/f9vPMvi+MUTBECImNHDM1eLjZsSsMjs3lHY
         vO8FeMaD8XFWUf+x+MEJUqnL6KMYNEQ3KAYFeGjhx6wYrsh4xmUV4og848LDUDv68Sg0
         EKYOuJ19TS7SeOeC+Owu/rdxkEIdEnD6GFbSKAHzEOUV7EOf9W9LHZMLTo6IchCOKN9b
         YtvnOleGt2M7jEjxkZTJHk79WCmexnhvciE7KemF1B1PIsppy903bwA9o5cP48dDybxK
         dxvUYN2GjgOEMDW5pFCp5T8KlOLgBjeKYi7B4Wwk37hR7reqis9TEdvvZICkrscziZn0
         spwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YLvWvlKerKN/PpfL9EIgNV4785R1sfDRbOdMox+npUU=;
        b=Cl1ynS3EI8bVPWyx9PqMeplcw4+FKkIUzn+NjokKtoU1suivr8G03cC3aHMQVGndbm
         Tqo9B2haBY8JcXCjPhD5FpcQIjfNKbSSSBxa3sPMfybHT9RR0wfh0cDbvVe/st87JK9f
         k2JhP88eB60q4TKT0/dAGOrFyXMJ+x+H6RJwtPmXVjUsmsi+bYzSyvVfLeZ20/03BCkH
         ku/5M8Y7QjZltt/oXoSHjRPqTsL/OsniLetGL1LbpZLSo2IfOPIeIUNztZp4ZyQXIYCV
         dgtoPuQh7jY7PIAneJBWqJon4d1V1HuAW2jBHGfGwmvFUcEZg52cPzVngUCzqdolPamr
         ZAbA==
X-Gm-Message-State: AOAM532Q0oZDn8TdG/XmUqs7FoDf5Al5xmFcnfAK43tAUEc1zisQBNF9
        RcbVh3H+DbHxHrCIQCOksZC9FWEaQueMYmpC8lqwzA==
X-Google-Smtp-Source: ABdhPJzdI2ew3B4feRkdm3Kq318MpXiNBhw1kRz499Q2dOsn9U4ydh4yZ79kwQWZsb4BCBwlzspzyfPPdXjF8W0LI+c=
X-Received: by 2002:a25:dc4d:: with SMTP id y74mr37638308ybe.289.1626744312348;
 Mon, 19 Jul 2021 18:25:12 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1625970383.git.Tony.Ambardar@gmail.com>
In-Reply-To: <cover.1625970383.git.Tony.Ambardar@gmail.com>
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
Date:   Tue, 20 Jul 2021 03:25:01 +0200
Message-ID: <CAM1=_QR-siQtH_qE1uj4J_xw-jWwcRZrLL2hxK462HOwDV1f8A@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next v1 00/14] MIPS: eBPF: refactor code, add
 MIPS32 JIT
To:     Tony Ambardar <tony.ambardar@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Burton <paulburton@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-mips@vger.kernel.org,
        Hassan Naveed <hnaveed@wavecomp.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tony,

I am glad that there are more people interested in having a JIT for
MIPS32. We seem to have been working in parallel on the same thing
though. I sent a summary on the state of the MIPS32 JIT on the
linux-mips list a couple of months ago, asking for feedback on the
best way to complete it. When I received no response, I started to
work on a MIPS32 JIT implementation myself. I'll be glad to share what
I have got so we can work together on this.

When I dug deeper into the 64-bit JIT code, I realised that a lot of
fundamental things such as 32-bit register mappings were completely
missing. Most of 32-bit operations were unimplemented. The code is
also quite complex already, so adding full 32-bit hardware support
into the mix did not seem like a good idea. I am sure there is some
common code that can be factored out and re-used, but I do think the
64-bit and 32-bit JITs would be better off as two different
implementations.

My 32-bit implementation is now complete and I am currently testing
it. Test suite output below. What remains to be tested is tail calls.

test_bpf: Summary: 676 PASSED, 0 FAILED, [664/664 JIT'ed]
Tested with kernel 5.14 on MIPS32r2 big-endian and little-endian under QEMU.
Also tested with kernel 5.4 on MIPS 24KEc (MT7628) physical hardware.
(I have added a lot of new tests in the eBPF test suite during the JIT
development, which explains the higher count)

The implementation supports both 32-bit and 64-bit eBPF instructions,
including all atomic operations. 64-bit atomics and div/mod are
implemented as function calls to atomic64 functions, while 32-bit
variants are implemented natively by the JIT.

Register mapping
=================
My 32-bit implementation maps all 64-bit eBPF registers to native
32-bit MIPS registers. In addition, there are four temporary 32-bit
registers available, which is precisely what is needed for doing the
more complex ALU64 operations. This means that the JIT does not use
any stack scratch space for registers. It should be a good thing from
a performance perspective. The register mapping is as follows.

R0: v0,v1 (return)
R1-R2: a0-a3 (args passed in registers)
R3-R5: t0-t5 (args passed on stack)
R6-R9: s0-s7 (callee-saved)
R10: r0,fp (frame pointer)
AX: gp,at (constant blinding)
Temp: t6-t9

To squeeze out enough MIPS registers for the eBPF mapping I had to
make a few unusual choices. First,  I use the at (assembler temporary)
register, which should be fine because the JIT is the assembler. I
also use use the gp (global pointer) register. It is callee-saved, so
I save it on stack and restore it in the epilogue. The eBPF frame
pointer R10 is mapped to fp, also callee-saved, and r0. The latter is
always zero, but on a 32-bit architecture it will also be used to
"store" zeros, so it should be perfectly fine for the 32-bit JIT.
According to the ISA documentation r0 is valid both as a source and a
destination operand.

The complete register mapping simplifies the code since we get rid of
all the swapping to/from the stack scratch space.

I have been focusing on the code the last couple of weeks so I didn't
see your email until now. I am sure that this comes as much of a
surprise to you as it did to me. Anyway, can send a patch with my JIT
implementation tomorrow.

Cheers,
Johan














On Mon, Jul 12, 2021 at 2:35 AM Tony Ambardar <tony.ambardar@gmail.com> wrote:
>
> Greetings!
>
> This patch series adds an eBPF JIT for MIPS32. The approach taken first
> updates existing code to support MIPS64/MIPS32 systems, then refactors
> source into a common core and dependent MIPS64 JIT, and finally adds a
> MIPS32 eBPF JIT implementation using the common framework.
>
> Compared to writing a standalone MIPS32 JIT, this approach has benefits
> for long-term maintainability, but has taken much longer than expected.
> This RFC posting is intended to share progress, gather feedback, and
> raise some questions with BPF and MIPS experts (which I'll cover later).
>
>
> Code Overview
> =============
>
> The initial code updates and refactoring exposed a number of problems in
> the existing MIPS64 JIT, which the first several patches fix. Patch #11
> updates common code to support MIPS64/MIPS32 operation. Patch #12
> separates the common core from the MIPS64 JIT code. Patch #13 adds a
> needed MIPS32 uasm opcode, while patch #14 adds the MIPS32 eBPF JIT.
>
> On MIPS32, 64-bit BPF registers are mapped to 32-bit register pairs, and
> all 64-bit operations are built on 32-bit subregister ops. The MIPS32
> tailcall counter is stored on the stack however. Notable changes from the
> MIPS64 JIT include:
>
>   * BPF_JMP32: implement all conditionals
>   * BPF_JMP | JSET | BPF_K: drop bbit insns only usable on MIPS64 Octeon
>
> Since MIPS32 does not include 64-bit div/mod or atomic opcodes, these BPF
> insns are implemented by directly calling the built-in kernel functions:
> (with thanks to Luke Nelson for posting similar code online)
>
>   * BPF_STX   | BPF_DW  | BPF_XADD
>   * BPF_ALU64 | BPF_DIV | BPF_X
>   * BPF_ALU64 | BPF_DIV | BPF_K
>   * BPF_ALU64 | BPF_MOD | BPF_X
>   * BPF_ALU64 | BPF_MOD | BPF_K
>
>
> Testing
> =======
>
> Testing used LTS kernel 5.10.x and stable 5.13.x running under QEMU.
> The test suite included the 'test_bpf' module and 'test_verifier' from
> kselftests. Using 'test_progs' from kselftests is too difficult in general
> since cross-compilation depends on libbpf/bpftool, which does not support
> cross-endian builds.
>
> The matrix of test configurations executed for this series covered the
> expected register sizes, MIPS ISA releases, and JIT settings:
>
>   WORDSIZE={64-bit,32-bit} x ISA={R2,R6} x JIT={off,on,hardened}
>
> On MIPS32BE and MIPS32LE there was general parity between the results of
> interpreter vs. JIT-backed tests with respect to the numbers of PASSED,
> SKIPPED, and FAILED tests. The same was also true of MIPS64 retesting.
>
> For example, the results below on MIPS32 are typical. Note that skipped
> tests 854 and 855 are "scale" tests which result in OOM on the QEMU malta
> MIPS32 test systems.
>
>   root@OpenWrt:~# sysctl net.core.bpf_jit_enable=1
>   root@OpenWrt:~# modprobe test_bpf
>   ...
>   test_bpf: Summary: 378 PASSED, 0 FAILED, [366/366 JIT'ed]
>   root@OpenWrt:~# ./test_verifier 0 853
>   ...
>   Summary: 1127 PASSED, 0 SKIPPED, 89 FAILED
>   root@OpenWrt:~# ./test_verifier 855 1149
>   ...
>   Summary: 408 PASSED, 7 SKIPPED, 53 FAILED
>
>
> Open Questions
> ==============
>
> 1. As seen in the patch series, the static analysis used by the MIPS64 JIT
> tends to be fragile in the face of verifier, insn and patching changes.
> After tracking down and fixing several related bugs, I wonder if it were
> better to remove the static analysis and leave things more robust and
> maintainable going forward.
>
> Paul, Thomas, David, what are your views? Do you have thoughts on how best
> to do this?
>
> Would it be possible to replace the static analysis by accessing verifier
> analysis results from a JIT? Daniel, Alexei, or Andrii?
>
>
> 2. The series tries to correctly handle tailcall counter across bpf2bpf
> and tailcalls, and it would be nice to properly support mixing these,
> but this is still a WIP for me. Much of what I've read seems very specific
> to the x86_64 JIT. Is there a good summary of the required changes for a
> JIT in general?
>
> Note: I built a MIPS32LE 'test_progs' after some horrible, ugly hacking,
> and the 'tailcall' tests pass but the 'tailcall_bpf2bpf' tests fail
> cryptically. I can send a log and strace if someone helpful could kindly
> take a look. Is there an alternative, good standalone test available?
>
>
>
> Possible Next Steps
> ===================
>
> 1. Implementing the new BPF_ATOMIC insns *should* be straightforward
> on MIPS32. I'm less certain of MIPS64 given the static analysis and
> related zext/sext logic.
>
> 2. The BPF_JMP32 class is another big gap on MIPS64. Has anyone looked at
> this before? It also ties to the static analysis, but on first glance
> appears feasible.
>
>
>
> Thanks in advance for any feedback or suggestions!
>
>
> Tony Ambardar (14):
>   MIPS: eBPF: support BPF_TAIL_CALL in JIT static analysis
>   MIPS: eBPF: mask 32-bit index for tail calls
>   MIPS: eBPF: fix BPF_ALU|ARSH handling in JIT static analysis
>   MIPS: eBPF: support BPF_JMP32 in JIT static analysis
>   MIPS: eBPF: fix system hang with verifier dead-code patching
>   MIPS: eBPF: fix JIT static analysis hang with bounded loops
>   MIPS: eBPF: fix MOD64 insn on R6 ISA
>   MIPS: eBPF: support long jump for BPF_JMP|EXIT
>   MIPS: eBPF: drop src_reg restriction in BPF_LD|BPF_DW|BPF_IMM
>   MIPS: eBPF: improve and clarify enum 'which_ebpf_reg'
>   MIPS: eBPF: add core support for 32/64-bit systems
>   MIPS: eBPF: refactor common MIPS64/MIPS32 functions and headers
>   MIPS: uasm: Enable muhu opcode for MIPS R6
>   MIPS: eBPF: add MIPS32 JIT
>
>  Documentation/admin-guide/sysctl/net.rst |    6 +-
>  Documentation/networking/filter.rst      |    6 +-
>  arch/mips/Kconfig                        |    4 +-
>  arch/mips/include/asm/uasm.h             |    1 +
>  arch/mips/mm/uasm-mips.c                 |    4 +-
>  arch/mips/mm/uasm.c                      |    3 +-
>  arch/mips/net/Makefile                   |    8 +-
>  arch/mips/net/ebpf_jit.c                 | 1935 ----------------------
>  arch/mips/net/ebpf_jit.h                 |  295 ++++
>  arch/mips/net/ebpf_jit_comp32.c          | 1241 ++++++++++++++
>  arch/mips/net/ebpf_jit_comp64.c          |  987 +++++++++++
>  arch/mips/net/ebpf_jit_core.c            | 1118 +++++++++++++
>  12 files changed, 3663 insertions(+), 1945 deletions(-)
>  delete mode 100644 arch/mips/net/ebpf_jit.c
>  create mode 100644 arch/mips/net/ebpf_jit.h
>  create mode 100644 arch/mips/net/ebpf_jit_comp32.c
>  create mode 100644 arch/mips/net/ebpf_jit_comp64.c
>  create mode 100644 arch/mips/net/ebpf_jit_core.c
>
> --
> 2.25.1
>
