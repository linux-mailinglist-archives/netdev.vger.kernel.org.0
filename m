Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328914220B0
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 10:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbhJEIbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 04:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbhJEIbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 04:31:11 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23924C061745;
        Tue,  5 Oct 2021 01:29:21 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id s11so19085606pgr.11;
        Tue, 05 Oct 2021 01:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UWnkJg0QEkj6xABw2NUUpLpPCfmxz/9Lqn9/mlj5AV0=;
        b=Y9M96YwEE9tKIi7rMyxBDdwU0uQMiIjT36ru1grpiF3tDRmp6yCCcc3c3rF3LpebVL
         o5ZwMrWhXurwmpMuiG7WlpUAb5bj8eUCtPE/9+9YQibK1itBZLG+FCSkEkZa2Pux7pGn
         NIZI8vUb2Gu9RmTv2C4y4Q29CeYIwj9HGZj6LAH10WjycfeeIVUFporMT72P2+tJsD0D
         9Pi6B8hJYe1htHe5jaYnjrWDJ701Ai2r0PPOAXyR3GL73O0UG5yvAhhjEplnOeSjl6qF
         Oj1x3s+P4JsjfxCHZO4WlASk9F51B1n0cXqYxzBjHrcCyDIXULM5UqXD0Bw4DFGhJmBX
         7vjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UWnkJg0QEkj6xABw2NUUpLpPCfmxz/9Lqn9/mlj5AV0=;
        b=YgdHGzi9c03CO0xqFdaGpq7F7jnuimD9AniXkX5NzULAh14+nzDlAVlOdbKwPdPNtZ
         q5mn4Hw1ytOpRt2982u/97N5e13IaupJu8FDWhumO+7BOOgfOzyDfVAoK6BeVge53EVN
         /Zk3+zPyE8qaMnIzqzE8ERFJlriOyJcC7MajhAPYP7fupMWEkLDEEMYOTV7IAejakrQI
         OHYLt0U/ALcnfjWDyfDxlxk9oKM+B4e08h5TuEgHmrTyOOXDG+yBRTEel2eNGeaNMNmk
         zdIP3oomGdJF/UaHx3ldAWTfSrODB9rTHm8hS8TY7jJ3UfwZDkNWChYBnVZLyts4ZkeS
         FvVg==
X-Gm-Message-State: AOAM530XtImyJZJvdmit1XRC5d6ezVEnl0Xe1zw7trU8LR6Sy1rI2f23
        UYfG2syadtJonA44fCnv51UPRPS/oea3KQ==
X-Google-Smtp-Source: ABdhPJwX0ynDZ2dLM82GAmlvjr38rFZTEJj87HnkWmbi/+DDPbllxmC8gaN33kGYb/5aCpioLEo7Qw==
X-Received: by 2002:aa7:942e:0:b0:44b:e096:67bf with SMTP id y14-20020aa7942e000000b0044be09667bfmr29259825pfo.60.1633422560432;
        Tue, 05 Oct 2021 01:29:20 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:78ba:4bcc:a59a:2284])
        by smtp.gmail.com with ESMTPSA id a15sm4941257pfg.53.2021.10.05.01.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 01:29:19 -0700 (PDT)
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
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Hassan Naveed <hnaveed@wavecomp.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [RFC PATCH bpf-next v2 00/16] MIPS: eBPF: refactor code, add MIPS32 JIT
Date:   Tue,  5 Oct 2021 01:26:44 -0700
Message-Id: <cover.1633392335.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625970383.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds an eBPF JIT for MIPS32. The approach taken fixes and
updates existing code to support MIPS64/MIPS32 systems, then refactors
source into a common core and dependent MIPS64 JIT, and finally adds a
MIPS32 eBPF JIT implementation using the common framework. This approach of
developing MIPS64 and MIPS32 JITs in tandem has desirable benefits for
consistency and long-term maintainability, and the iterative refactoring
has helped identify several problems.


Overview
========

The initial code updates and refactoring exposed a number of problems in
the existing MIPS64 JIT, which are fixed in patches #1 to #9. Patch #10
updates common code to support MIPS64/MIPS32 operation. Patch #12 separates
the common core from the MIPS64 JIT code. Patches #13 and #14 add MIPS64
support for BPF_ATOMIC and BPF_JMP32 insns. Patch #15 adds a needed MIPS32
uasm opcode, while patch #16 adds the MIPS32 eBPF JIT.

Updates to the common core notably include support for bpf2bpf calls and
making tailcalls from BPF subprograms (e.g. patch #11). Some lower priority
features such as MIPS R1 ISA support, direct kernel calls (e.g. for TCP
congestion control experiments) and PROBE_MEM support have been omitted.

On MIPS32, 64-bit BPF registers are mapped to 32-bit register pairs, and
all 64-bit operations are built on 32-bit subregister ops. A few
differences from the MIPS64 JIT include:

  * BPF TAILCALL: counter stored on stack due to register pressure. 
  * BPF_JMP | JSET | BPF_K: drop bbit insns only usable on MIPS64 Octeon

Since MIPS32 does not include 64-bit div/mod or atomic opcodes, these BPF
insns are implemented by directly calling the built-in kernel functions:
(with thanks to Luke Nelson for posting similar code online)

  * BPF_ATOMIC | BPF_DW | BPF_ADD (+BPF_FETCH)
  * BPF_ATOMIC | BPF_DW | BPF_AND (+BPF_FETCH)
  * BPF_ATOMIC | BPF_DW | BPF_XOR (+BPF_FETCH)
  * BPF_ATOMIC | BPF_DW | BPF_OR  (+BPF_FETCH)
  * BPF_ATOMIC | BPF_DW | BPF_XCHG
  * BPF_ATOMIC | BPF_DW | BPF_CMPXCHG
  * BPF_ALU64  | BPF_DIV | BPF_X
  * BPF_ALU64  | BPF_DIV | BPF_K
  * BPF_ALU64  | BPF_MOD | BPF_X
  * BPF_ALU64  | BPF_MOD | BPF_K


Testing
=======

Testing used LTS kernel 5.10.x and stable 5.13.x running on QEMU/OpenWRT.
The test suite included the 'test_bpf' module, and 'test_verifier' and
'test_progs' from kselftests.

Using 'test_progs' from kselftests proved to be difficult in general
since cross-compilation depends on libbpf/bpftool, which does not support
cross-endian builds. A very hacked build was used, primarily for testing
bpf2bpf calls and tailcalls.

The matrix of test configurations executed for this series covered the
expected register sizes, MIPS ISA releases, and JIT settings:

  WORDSIZE={64-bit,32-bit} x ISA={R2,R6} x JIT={off,on,hardened}

On MIPS32BE and MIPS32LE there was general parity between the results of
interpreter vs. JIT-backed tests with respect to the numbers of PASSED,
SKIPPED, and FAILED tests. The same was also true of MIPS64 retesting.

For example, the results below on MIPS32 are typical. Note that skipped
test 885 is a "scale" test which results in OOM on the QEMU malta MIPS32
test systems used.

  root@OpenWrt:~# sysctl net.core.bpf_jit_enable=1
  root@OpenWrt:~# modprobe test_bpf
  ...
  test_bpf: Summary: 378 PASSED, 0 FAILED, [366/366 JIT'ed]
  root@OpenWrt:~# ./test_verifier 0 884
  ...
  Summary: 1231 PASSED, 0 SKIPPED, 20 FAILED
  root@OpenWrt:~# ./test_verifier 886 1184
  ...
  Summary: 459 PASSED, 1 SKIPPED, 2 FAILED
  root@OpenWrt:~# ./test_progs -n 105,106
  ...
  105 subprogs:OK
  106/1 tailcall_1:OK
  106/2 tailcall_2:OK
  106/3 tailcall_3:OK
  106/4 tailcall_4:OK
  106/5 tailcall_5:OK
  106/6 tailcall_bpf2bpf_1:OK
  106/7 tailcall_bpf2bpf_2:OK
  106/8 tailcall_bpf2bpf_3:OK
  106/9 tailcall_bpf2bpf_4:OK
  106 tailcalls:OK
  Summary: 2/9 PASSED, 0 SKIPPED, 0 FAILED


All feedback and suggestions are much appreciated!

---
Change History:

rfc v2:
* Implement all BPF_ATOMIC ops. For MIPS32 BPF_DW insns, call built-in
  64-bit kernel functions.
* Add MIPS64 support for BPF_JMP32 conditionals.
* Support making tailcalls from bpf2bpf functions.
* Support bpf2bpf calls with an extra JIT pass to patch call addresses.
* Add JIT support for bpf_line_info via bpf_prog_fill_jited_linfo().
* Further code optimizations, cleanup and simplification.
* Update kernel docs.

rfc v1:
* Initial code proposal, focused on consistency and maintainability for
  both MIPS32/MIPS64.
* Several MIPS64 bugfixes and factoring out common shareable code.
* Addition of MIPS32 JIT, roughly matching MIPS64 capabilities.

---
Tony Ambardar (16):
  MIPS: eBPF: support BPF_TAIL_CALL in JIT static analysis
  MIPS: eBPF: mask 32-bit index for tail calls
  MIPS: eBPF: fix BPF_ALU|ARSH handling in JIT static analysis
  MIPS: eBPF: support BPF_JMP32 in JIT static analysis
  MIPS: eBPF: fix system hang with verifier dead-code patching
  MIPS: eBPF: fix JIT static analysis hang with bounded loops
  MIPS: eBPF: fix MOD64 insn on R6 ISA
  MIPS: eBPF: support long jump for BPF_JMP|EXIT
  MIPS: eBPF: drop src_reg restriction in BPF_LD|BPF_DW|BPF_IMM
  MIPS: eBPF: add core support for 32/64-bit systems
  bpf: allow tailcalls in subprograms for MIPS64/MIPS32
  MIPS: eBPF: refactor common 32/64-bit functions and headers
  MIPS: eBPF64: support BPF_JMP32 conditionals
  MIPS: eBPF64: implement all BPF_ATOMIC ops
  MIPS: uasm: Enable muhu opcode for MIPS R6
  MIPS: eBPF: add MIPS32 JIT

 Documentation/admin-guide/sysctl/net.rst |    6 +-
 Documentation/networking/filter.rst      |    6 +-
 arch/mips/Kconfig                        |    4 +-
 arch/mips/include/asm/uasm.h             |    1 +
 arch/mips/mm/uasm-mips.c                 |    4 +-
 arch/mips/mm/uasm.c                      |    3 +-
 arch/mips/net/Makefile                   |    8 +-
 arch/mips/net/ebpf_jit.c                 | 1938 ----------------------
 arch/mips/net/ebpf_jit.h                 |  297 ++++
 arch/mips/net/ebpf_jit_comp32.c          | 1398 ++++++++++++++++
 arch/mips/net/ebpf_jit_comp64.c          | 1085 ++++++++++++
 arch/mips/net/ebpf_jit_core.c            | 1193 +++++++++++++
 arch/x86/net/bpf_jit_comp.c              |    6 +
 include/linux/filter.h                   |    1 +
 kernel/bpf/core.c                        |    6 +
 kernel/bpf/verifier.c                    |    3 +-
 16 files changed, 4010 insertions(+), 1949 deletions(-)
 delete mode 100644 arch/mips/net/ebpf_jit.c
 create mode 100644 arch/mips/net/ebpf_jit.h
 create mode 100644 arch/mips/net/ebpf_jit_comp32.c
 create mode 100644 arch/mips/net/ebpf_jit_comp64.c
 create mode 100644 arch/mips/net/ebpf_jit_core.c

-- 
2.25.1

