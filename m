Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E753C405F
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 02:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhGLAiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 20:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhGLAiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 20:38:17 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6FBC0613DD;
        Sun, 11 Jul 2021 17:35:28 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id n11so9135768pjo.1;
        Sun, 11 Jul 2021 17:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vfgi8rSUdhyhOK+TTG6OcDruFXlt3xOVYmVmmsxO3OY=;
        b=VMHcyNWhdWyJEyRjEoXABEXH1og6tNvxLu84t9qbomaG48qn7vgQ2av6nwKn+qxPI5
         kSVUmXqsyt7QxzpNKWtGy2svo05WI0JKrxHPhTYP/nb5bR7YBPJ7GULUpiq1liEs7jXV
         tqs04nj/A+3T4Y/1ILi1cF6EkELhR828aXlY8Y4t+0/wJS94ceojIv2V4nChmoX9KAOe
         JPk8PS7TEBkUP7KApO6GJO+UpS/hcr2PVk1SeAgpKSeilbrVDdi/dce8iZnR9jq0evNH
         uYB+8VKgsJ2vl6haDotokgZZb+NB+A96EsYizgyGru/hn5A3U701+z/OAXZk21CnIzuj
         aejg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vfgi8rSUdhyhOK+TTG6OcDruFXlt3xOVYmVmmsxO3OY=;
        b=D98ymaFpSTOR3zOlrdgys7apqFGh9qBHHWtqy1lPpjppSyqEpxrodXhvU0IwHu8Hiq
         m6GZnaTRsb3V17AV4TZbIp6TiI+kBKt2hed8cQ4LCHpVWBKSC9fTQbGV5ThwkGa72JqB
         mC6op0WibSdBl54rxDpLS6EalIh6QZhBYsUOXh9NrQG+O5ers9UQn5XXtIL5Ifeu8HVT
         8sNIOcQs9k+zwzQJ0+RAbyGOSHUQWMTjKPjfmjlxczQ+mMTUzntfdRMa9iJJ6tVHHgrL
         9egZbg8kLixaGvdEml7eb8eOWbVueQ3+DajfoZsYJevbaz2LOteHPzT/el0Ma4NfhGj0
         OprA==
X-Gm-Message-State: AOAM531qipINxJqe1ySJKsgsWxN+DgEor14ntdBa1tr8nbb1OJkWNCRU
        XxK875nUohfJ+wkVMrDZcbM=
X-Google-Smtp-Source: ABdhPJxOhaWBhv0i+ISUeOqU2Ho9jiY/LUGAer9OhLDKcWEH7/gMQMQf1FVXrQltJHU94GmBwzQ0Sg==
X-Received: by 2002:a17:902:f243:b029:129:5706:3c4b with SMTP id j3-20020a170902f243b029012957063c4bmr41150209plc.83.1626050128226;
        Sun, 11 Jul 2021 17:35:28 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:4039:6c0e:1168:cc74])
        by smtp.gmail.com with ESMTPSA id c24sm15588447pgj.11.2021.07.11.17.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 17:35:27 -0700 (PDT)
From:   Tony Ambardar <tony.ambardar@gmail.com>
X-Google-Original-From: Tony Ambardar <Tony.Ambardar@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Burton <paulburton@kernel.org>
Cc:     Tony Ambardar <Tony.Ambardar@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-mips@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Hassan Naveed <hnaveed@wavecomp.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [RFC PATCH bpf-next v1 00/14] MIPS: eBPF: refactor code, add MIPS32 JIT
Date:   Sun, 11 Jul 2021 17:34:46 -0700
Message-Id: <cover.1625970383.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings!

This patch series adds an eBPF JIT for MIPS32. The approach taken first
updates existing code to support MIPS64/MIPS32 systems, then refactors
source into a common core and dependent MIPS64 JIT, and finally adds a
MIPS32 eBPF JIT implementation using the common framework.

Compared to writing a standalone MIPS32 JIT, this approach has benefits
for long-term maintainability, but has taken much longer than expected.
This RFC posting is intended to share progress, gather feedback, and
raise some questions with BPF and MIPS experts (which I'll cover later).


Code Overview
=============

The initial code updates and refactoring exposed a number of problems in
the existing MIPS64 JIT, which the first several patches fix. Patch #11
updates common code to support MIPS64/MIPS32 operation. Patch #12
separates the common core from the MIPS64 JIT code. Patch #13 adds a
needed MIPS32 uasm opcode, while patch #14 adds the MIPS32 eBPF JIT.

On MIPS32, 64-bit BPF registers are mapped to 32-bit register pairs, and
all 64-bit operations are built on 32-bit subregister ops. The MIPS32
tailcall counter is stored on the stack however. Notable changes from the
MIPS64 JIT include:

  * BPF_JMP32: implement all conditionals
  * BPF_JMP | JSET | BPF_K: drop bbit insns only usable on MIPS64 Octeon

Since MIPS32 does not include 64-bit div/mod or atomic opcodes, these BPF
insns are implemented by directly calling the built-in kernel functions:
(with thanks to Luke Nelson for posting similar code online)

  * BPF_STX   | BPF_DW  | BPF_XADD
  * BPF_ALU64 | BPF_DIV | BPF_X
  * BPF_ALU64 | BPF_DIV | BPF_K
  * BPF_ALU64 | BPF_MOD | BPF_X
  * BPF_ALU64 | BPF_MOD | BPF_K


Testing
=======

Testing used LTS kernel 5.10.x and stable 5.13.x running under QEMU.
The test suite included the 'test_bpf' module and 'test_verifier' from
kselftests. Using 'test_progs' from kselftests is too difficult in general
since cross-compilation depends on libbpf/bpftool, which does not support
cross-endian builds.

The matrix of test configurations executed for this series covered the
expected register sizes, MIPS ISA releases, and JIT settings:

  WORDSIZE={64-bit,32-bit} x ISA={R2,R6} x JIT={off,on,hardened}

On MIPS32BE and MIPS32LE there was general parity between the results of
interpreter vs. JIT-backed tests with respect to the numbers of PASSED,
SKIPPED, and FAILED tests. The same was also true of MIPS64 retesting.

For example, the results below on MIPS32 are typical. Note that skipped
tests 854 and 855 are "scale" tests which result in OOM on the QEMU malta
MIPS32 test systems.

  root@OpenWrt:~# sysctl net.core.bpf_jit_enable=1
  root@OpenWrt:~# modprobe test_bpf
  ...
  test_bpf: Summary: 378 PASSED, 0 FAILED, [366/366 JIT'ed]
  root@OpenWrt:~# ./test_verifier 0 853
  ...
  Summary: 1127 PASSED, 0 SKIPPED, 89 FAILED
  root@OpenWrt:~# ./test_verifier 855 1149
  ...
  Summary: 408 PASSED, 7 SKIPPED, 53 FAILED


Open Questions
==============

1. As seen in the patch series, the static analysis used by the MIPS64 JIT
tends to be fragile in the face of verifier, insn and patching changes.
After tracking down and fixing several related bugs, I wonder if it were
better to remove the static analysis and leave things more robust and
maintainable going forward.

Paul, Thomas, David, what are your views? Do you have thoughts on how best
to do this?

Would it be possible to replace the static analysis by accessing verifier
analysis results from a JIT? Daniel, Alexei, or Andrii?


2. The series tries to correctly handle tailcall counter across bpf2bpf
and tailcalls, and it would be nice to properly support mixing these,
but this is still a WIP for me. Much of what I've read seems very specific
to the x86_64 JIT. Is there a good summary of the required changes for a
JIT in general?

Note: I built a MIPS32LE 'test_progs' after some horrible, ugly hacking,
and the 'tailcall' tests pass but the 'tailcall_bpf2bpf' tests fail
cryptically. I can send a log and strace if someone helpful could kindly
take a look. Is there an alternative, good standalone test available?



Possible Next Steps
===================

1. Implementing the new BPF_ATOMIC insns *should* be straightforward
on MIPS32. I'm less certain of MIPS64 given the static analysis and
related zext/sext logic.

2. The BPF_JMP32 class is another big gap on MIPS64. Has anyone looked at
this before? It also ties to the static analysis, but on first glance
appears feasible.



Thanks in advance for any feedback or suggestions!


Tony Ambardar (14):
  MIPS: eBPF: support BPF_TAIL_CALL in JIT static analysis
  MIPS: eBPF: mask 32-bit index for tail calls
  MIPS: eBPF: fix BPF_ALU|ARSH handling in JIT static analysis
  MIPS: eBPF: support BPF_JMP32 in JIT static analysis
  MIPS: eBPF: fix system hang with verifier dead-code patching
  MIPS: eBPF: fix JIT static analysis hang with bounded loops
  MIPS: eBPF: fix MOD64 insn on R6 ISA
  MIPS: eBPF: support long jump for BPF_JMP|EXIT
  MIPS: eBPF: drop src_reg restriction in BPF_LD|BPF_DW|BPF_IMM
  MIPS: eBPF: improve and clarify enum 'which_ebpf_reg'
  MIPS: eBPF: add core support for 32/64-bit systems
  MIPS: eBPF: refactor common MIPS64/MIPS32 functions and headers
  MIPS: uasm: Enable muhu opcode for MIPS R6
  MIPS: eBPF: add MIPS32 JIT

 Documentation/admin-guide/sysctl/net.rst |    6 +-
 Documentation/networking/filter.rst      |    6 +-
 arch/mips/Kconfig                        |    4 +-
 arch/mips/include/asm/uasm.h             |    1 +
 arch/mips/mm/uasm-mips.c                 |    4 +-
 arch/mips/mm/uasm.c                      |    3 +-
 arch/mips/net/Makefile                   |    8 +-
 arch/mips/net/ebpf_jit.c                 | 1935 ----------------------
 arch/mips/net/ebpf_jit.h                 |  295 ++++
 arch/mips/net/ebpf_jit_comp32.c          | 1241 ++++++++++++++
 arch/mips/net/ebpf_jit_comp64.c          |  987 +++++++++++
 arch/mips/net/ebpf_jit_core.c            | 1118 +++++++++++++
 12 files changed, 3663 insertions(+), 1945 deletions(-)
 delete mode 100644 arch/mips/net/ebpf_jit.c
 create mode 100644 arch/mips/net/ebpf_jit.h
 create mode 100644 arch/mips/net/ebpf_jit_comp32.c
 create mode 100644 arch/mips/net/ebpf_jit_comp64.c
 create mode 100644 arch/mips/net/ebpf_jit_core.c

-- 
2.25.1

