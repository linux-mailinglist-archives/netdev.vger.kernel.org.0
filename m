Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17600116E3A
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 14:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfLINzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 08:55:36 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:34398 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727268AbfLINzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 08:55:36 -0500
Received: by mail-pj1-f66.google.com with SMTP id j11so4820714pjs.1;
        Mon, 09 Dec 2019 05:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W9Mst/9eaBU2H4T3h7n8CD9mFgr8BuXr0zyEJzhbpts=;
        b=uGEJOHcqgAQdXrghobvAtR/5St7h68nKwpLhBSjAiwySEBNmQumxjN1qk1h7/RAAFZ
         SjWaRE45G7tDl15Nsrupx8HDQ3gGqE0mhZj/uwSrpqTV58Q8PdCM0G9FGxHYokqejz+l
         MGaqVCt0680wYpTfUsnemFsLFXMcZd2I7re4w2nFzeaNUfXvaqarzw9rfyavmN+CcRwu
         MAV5/ESeMMQqEBK/Ao1cvF/oYtx6rKHvGFkKW1Gm/an8tmWe/PZtoFgDwcGZfvtTa+TE
         qbSG0tmvDbKdUcX14MlNaOKbSH6/ZjbFZHNc9BhQy0nTXumKWzezBpWLFwYebkY4wWNY
         HbSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W9Mst/9eaBU2H4T3h7n8CD9mFgr8BuXr0zyEJzhbpts=;
        b=m/QWQVMEVTvyO6uCxuyyL+yd4biawsRCP7jjOz6kef8Iyclrsm4gcIhO+SyIrIPabD
         xXMRiq5bTq0xwsY+xwhL23+N19hyYMB/EP+02LPjH16U1CLvzfQl6MUv2MOoXw9Cux3u
         yznkfz6MgVk5NkYWBB3NS+5+RxbacXPMiWcLxM9EzdtrNCA4xQIM1whsbLVw7RIalh9s
         FMuCOLPqFdZyDufNlsMrLrIfCrVucPTiJTw8ndL2ARiffg8OEf5y5FFidB28jXw/UD+2
         QPn7aXRK4a/xymy48zDpBxEUZPFpGkGI/mphWS6GgzrASnJ59p3rrrmZpVzLdjhCxlGU
         cCdQ==
X-Gm-Message-State: APjAAAXbZUbYII0b10YC/qIahrOV3dG4FfHnikkV7Zr++5uOKOJFGg3p
        PbYPn6WMJuRBQyk4GmF/GAfV9ZsXJuA=
X-Google-Smtp-Source: APXvYqzeEAPyqpnLo5J1QsKBm+GNpbwTGm2UvqUQaGr23s9atkfEOhiNlfbzEcLzlS29fS8dXPktZw==
X-Received: by 2002:a17:90a:3702:: with SMTP id u2mr31001898pjb.112.1575899734799;
        Mon, 09 Dec 2019 05:55:34 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id h26sm19543403pfr.9.2019.12.09.05.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 05:55:34 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH bpf-next v3 0/6] Introduce the BPF dispatcher
Date:   Mon,  9 Dec 2019 14:55:16 +0100
Message-Id: <20191209135522.16576-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Overview
========

This is the 4th iteration of the series that introduces the BPF
dispatcher, which is a mechanism to avoid indirect calls.

The BPF dispatcher is a multi-way branch code generator, targeted for
BPF programs. E.g. when an XDP program is executed via the
bpf_prog_run_xdp(), it is invoked via an indirect call. With
retpolines enabled, the indirect call has a substantial performance
impact. The dispatcher is a mechanism that transform indirect calls to
direct calls, and therefore avoids the retpoline. The dispatcher is
generated using the BPF JIT, and relies on text poking provided by
bpf_arch_text_poke().

The dispatcher hijacks a trampoline function it via the __fentry__ nop
of the trampoline. One dispatcher instance currently supports up to 48
dispatch points. This can be extended in the future.

In this series, only one dispatcher instance is supported, and the
only user is XDP. The dispatcher is updated when an XDP program is
attached/detached to/from a netdev. An alternative to this could have
been to update the dispatcher at program load point, but as there are
usually more XDP programs loaded than attached, so the latter was
picked.

The XDP dispatcher is always enabled, if available, because it helps
even when retpolines are disabled. Please refer to the "Performance"
section below.

The first patch refactors the image allocation from the BPF trampoline
code. Patch two introduces the dispatcher, and patch three wires up
the XDP control-/ fast-path. Patch four adds the dispatcher to
BPF_TEST_RUN. Patch five adds a simple selftest, and the last adds
alignment to jump targets.

I have rebased the series on commit e7096c131e51 ("net: WireGuard
secure network tunnel").

Discussion/feedback
===================

My measurements did not show any improvements for the jump target 16 B
alignments. Maybe it would make sense to leave alignment out?

As the performance results show, when the dispatch table is full/48
entries, there are performance degradations for the micro-benchmarks
(XDP_DRV and xdp-perf). The dispatcher does log(n) compares/jumps, if
we assume linear scaling, this means that having more than 16 entries
in the dispatch table will degrade performance for the
"mitigations=off" case, but more for the "mitigations=auto" cases.

Generated code, x86-64
======================

The dispatcher currently has a maximum of 48 entries, where one entry
is a unique BPF program. Multiple users of a dispatcher instance using
the same BPF program will share that entry.

The program/slot lookup is performed by a binary search, O(log
n). Let's have a look at the generated code.

The trampoline function has the following signature:

  unsigned int tramp(const void *xdp_ctx,
                     const struct bpf_insn *insnsi,
                     unsigned int (*bpf_func)(const void *,
                                              const struct bpf_insn *))

On Intel x86-64 this means that rdx will contain the bpf_func. To,
make it easier to read, I've let the BPF programs have the following
range: 0xffffffffffffffff (-1) to 0xfffffffffffffff0
(-16). 0xffffffff81c00f10 is the retpoline thunk, in this case
__x86_indirect_thunk_rdx. If retpolines are disabled the thunk will be
a regular indirect call.

The minimal dispatcher will then look like this:

ffffffffc0002000: cmp    rdx,0xffffffffffffffff
ffffffffc0002007: je     0xffffffffffffffff ; -1
ffffffffc000200d: jmp    0xffffffff81c00f10

A 16 entry dispatcher looks like this:

ffffffffc0020000: cmp    rdx,0xfffffffffffffff7 ; -9
ffffffffc0020007: jg     0xffffffffc0020130
ffffffffc002000d: cmp    rdx,0xfffffffffffffff3 ; -13
ffffffffc0020014: jg     0xffffffffc00200a0
ffffffffc002001a: cmp    rdx,0xfffffffffffffff1 ; -15
ffffffffc0020021: jg     0xffffffffc0020060
ffffffffc0020023: cmp    rdx,0xfffffffffffffff0 ; -16
ffffffffc002002a: jg     0xffffffffc0020040
ffffffffc002002c: cmp    rdx,0xfffffffffffffff0 ; -16
ffffffffc0020033: je     0xfffffffffffffff0 ; -16
ffffffffc0020039: jmp    0xffffffff81c00f10
ffffffffc002003e: xchg   ax,ax
ffffffffc0020040: cmp    rdx,0xfffffffffffffff1 ; -15
ffffffffc0020047: je     0xfffffffffffffff1 ; -15
ffffffffc002004d: jmp    0xffffffff81c00f10
ffffffffc0020052: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc002005a: nop    WORD PTR [rax+rax*1+0x0]
ffffffffc0020060: cmp    rdx,0xfffffffffffffff2 ; -14
ffffffffc0020067: jg     0xffffffffc0020080
ffffffffc0020069: cmp    rdx,0xfffffffffffffff2 ; -14
ffffffffc0020070: je     0xfffffffffffffff2 ; -14
ffffffffc0020076: jmp    0xffffffff81c00f10
ffffffffc002007b: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc0020080: cmp    rdx,0xfffffffffffffff3 ; -13
ffffffffc0020087: je     0xfffffffffffffff3 ; -13
ffffffffc002008d: jmp    0xffffffff81c00f10
ffffffffc0020092: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc002009a: nop    WORD PTR [rax+rax*1+0x0]
ffffffffc00200a0: cmp    rdx,0xfffffffffffffff5 ; -11
ffffffffc00200a7: jg     0xffffffffc00200f0
ffffffffc00200a9: cmp    rdx,0xfffffffffffffff4 ; -12
ffffffffc00200b0: jg     0xffffffffc00200d0
ffffffffc00200b2: cmp    rdx,0xfffffffffffffff4 ; -12
ffffffffc00200b9: je     0xfffffffffffffff4 ; -12
ffffffffc00200bf: jmp    0xffffffff81c00f10
ffffffffc00200c4: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc00200cc: nop    DWORD PTR [rax+0x0]
ffffffffc00200d0: cmp    rdx,0xfffffffffffffff5 ; -11
ffffffffc00200d7: je     0xfffffffffffffff5 ; -11
ffffffffc00200dd: jmp    0xffffffff81c00f10
ffffffffc00200e2: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc00200ea: nop    WORD PTR [rax+rax*1+0x0]
ffffffffc00200f0: cmp    rdx,0xfffffffffffffff6 ; -10
ffffffffc00200f7: jg     0xffffffffc0020110
ffffffffc00200f9: cmp    rdx,0xfffffffffffffff6 ; -10
ffffffffc0020100: je     0xfffffffffffffff6 ; -10
ffffffffc0020106: jmp    0xffffffff81c00f10
ffffffffc002010b: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc0020110: cmp    rdx,0xfffffffffffffff7 ; -9
ffffffffc0020117: je     0xfffffffffffffff7 ; -9
ffffffffc002011d: jmp    0xffffffff81c00f10
ffffffffc0020122: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc002012a: nop    WORD PTR [rax+rax*1+0x0]
ffffffffc0020130: cmp    rdx,0xfffffffffffffffb ; -5
ffffffffc0020137: jg     0xffffffffc00201d0
ffffffffc002013d: cmp    rdx,0xfffffffffffffff9 ; -7
ffffffffc0020144: jg     0xffffffffc0020190
ffffffffc0020146: cmp    rdx,0xfffffffffffffff8 ; -8
ffffffffc002014d: jg     0xffffffffc0020170
ffffffffc002014f: cmp    rdx,0xfffffffffffffff8 ; -8
ffffffffc0020156: je     0xfffffffffffffff8 ; -8
ffffffffc002015c: jmp    0xffffffff81c00f10
ffffffffc0020161: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc0020169: nop    DWORD PTR [rax+0x0]
ffffffffc0020170: cmp    rdx,0xfffffffffffffff9 ; -7
ffffffffc0020177: je     0xfffffffffffffff9 ; -7
ffffffffc002017d: jmp    0xffffffff81c00f10
ffffffffc0020182: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc002018a: nop    WORD PTR [rax+rax*1+0x0]
ffffffffc0020190: cmp    rdx,0xfffffffffffffffa ; -6
ffffffffc0020197: jg     0xffffffffc00201b0
ffffffffc0020199: cmp    rdx,0xfffffffffffffffa ; -6
ffffffffc00201a0: je     0xfffffffffffffffa ; -6
ffffffffc00201a6: jmp    0xffffffff81c00f10
ffffffffc00201ab: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc00201b0: cmp    rdx,0xfffffffffffffffb ; -5
ffffffffc00201b7: je     0xfffffffffffffffb ; -5
ffffffffc00201bd: jmp    0xffffffff81c00f10
ffffffffc00201c2: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc00201ca: nop    WORD PTR [rax+rax*1+0x0]
ffffffffc00201d0: cmp    rdx,0xfffffffffffffffd ; -3
ffffffffc00201d7: jg     0xffffffffc0020220
ffffffffc00201d9: cmp    rdx,0xfffffffffffffffc ; -4
ffffffffc00201e0: jg     0xffffffffc0020200
ffffffffc00201e2: cmp    rdx,0xfffffffffffffffc ; -4
ffffffffc00201e9: je     0xfffffffffffffffc ; -4
ffffffffc00201ef: jmp    0xffffffff81c00f10
ffffffffc00201f4: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc00201fc: nop    DWORD PTR [rax+0x0]
ffffffffc0020200: cmp    rdx,0xfffffffffffffffd ; -3
ffffffffc0020207: je     0xfffffffffffffffd ; -3
ffffffffc002020d: jmp    0xffffffff81c00f10
ffffffffc0020212: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc002021a: nop    WORD PTR [rax+rax*1+0x0]
ffffffffc0020220: cmp    rdx,0xfffffffffffffffe ; -2
ffffffffc0020227: jg     0xffffffffc0020240
ffffffffc0020229: cmp    rdx,0xfffffffffffffffe ; -2
ffffffffc0020230: je     0xfffffffffffffffe ; -2
ffffffffc0020236: jmp    0xffffffff81c00f10
ffffffffc002023b: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc0020240: cmp    rdx,0xffffffffffffffff ; -1
ffffffffc0020247: je     0xffffffffffffffff ; -1
ffffffffc002024d: jmp    0xffffffff81c00f10

The nops are there to align jump targets to 16 B.

Performance
===========

The tests were performed using the xdp_rxq_info sample program with
the following command-line:

1. XDP_DRV:
  # xdp_rxq_info --dev eth0 --action XDP_DROP
2. XDP_SKB:
  # xdp_rxq_info --dev eth0 -S --action XDP_DROP
3. xdp-perf, from selftests/bpf:
  # test_progs -v -t xdp_perf


Run with mitigations=auto
-------------------------

Baseline:
1. 22.0 Mpps
2. 3.8 Mpps
3. 15 ns

Dispatcher:
1. 29.4 Mpps (+34%)
2. 4.0 Mpps  (+5%)
3. 5 ns      (+66%)

Dispatcher (full; walk all entries, and fallback):
1. 20.4 Mpps (-7%)
2. 3.8 Mpps  
3. 18 ns     (-20%)

Run with mitigations=off
------------------------

Baseline:
1. 29.6 Mpps
2. 4.1 Mpps
3. 5 ns

Dispatcher:
1. 30.7 Mpps (+4%)
2. 4.1 Mpps
1. 5 ns

Dispatcher (full; walk all entries, and fallback):
1. 27.2 Mpps (-8%)
2. 4.1 Mpps
3. 7 ns      (-40%)

Multiple xdp-perf baseline with mitigations=auto
------------------------------------------------

 Performance counter stats for './test_progs -v -t xdp_perf' (1024 runs):

             16.69 msec task-clock                #    0.984 CPUs utilized            ( +-  0.08% )
                 2      context-switches          #    0.123 K/sec                    ( +-  1.11% )
                 0      cpu-migrations            #    0.000 K/sec                    ( +- 70.68% )
                97      page-faults               #    0.006 M/sec                    ( +-  0.05% )
        49,254,635      cycles                    #    2.951 GHz                      ( +-  0.09% )  (12.28%)
        42,138,558      instructions              #    0.86  insn per cycle           ( +-  0.02% )  (36.15%)
         7,315,291      branches                  #  438.300 M/sec                    ( +-  0.01% )  (59.43%)
         1,011,201      branch-misses             #   13.82% of all branches          ( +-  0.01% )  (83.31%)
        15,440,788      L1-dcache-loads           #  925.143 M/sec                    ( +-  0.00% )  (99.40%)
            39,067      L1-dcache-load-misses     #    0.25% of all L1-dcache hits    ( +-  0.04% )
             6,531      LLC-loads                 #    0.391 M/sec                    ( +-  0.05% )
               442      LLC-load-misses           #    6.76% of all LL-cache hits     ( +-  0.77% )
   <not supported>      L1-icache-loads                                             
            57,964      L1-icache-load-misses                                         ( +-  0.06% )
        15,442,496      dTLB-loads                #  925.246 M/sec                    ( +-  0.00% )
               514      dTLB-load-misses          #    0.00% of all dTLB cache hits   ( +-  0.73% )  (40.57%)
               130      iTLB-loads                #    0.008 M/sec                    ( +-  2.75% )  (16.69%)
     <not counted>      iTLB-load-misses                                              ( +-  8.71% )  (0.60%)
   <not supported>      L1-dcache-prefetches                                        
   <not supported>      L1-dcache-prefetch-misses                                   

         0.0169558 +- 0.0000127 seconds time elapsed  ( +-  0.07% )

Multiple xdp-perf dispatcher with mitigations=auto
--------------------------------------------------

Note that this includes generating the dispatcher.

 Performance counter stats for './test_progs -v -t xdp_perf' (1024 runs):

              4.80 msec task-clock                #    0.953 CPUs utilized            ( +-  0.06% )
                 1      context-switches          #    0.258 K/sec                    ( +-  1.57% )
                 0      cpu-migrations            #    0.000 K/sec                  
                97      page-faults               #    0.020 M/sec                    ( +-  0.05% )
        14,185,861      cycles                    #    2.955 GHz                      ( +-  0.17% )  (50.49%)
        45,691,935      instructions              #    3.22  insn per cycle           ( +-  0.01% )  (99.19%)
         8,346,008      branches                  # 1738.709 M/sec                    ( +-  0.00% )
            13,046      branch-misses             #    0.16% of all branches          ( +-  0.10% )
        15,443,735      L1-dcache-loads           # 3217.365 M/sec                    ( +-  0.00% )
            39,585      L1-dcache-load-misses     #    0.26% of all L1-dcache hits    ( +-  0.05% )
             7,138      LLC-loads                 #    1.487 M/sec                    ( +-  0.06% )
               671      LLC-load-misses           #    9.40% of all LL-cache hits     ( +-  0.73% )
   <not supported>      L1-icache-loads                                             
            56,213      L1-icache-load-misses                                         ( +-  0.08% )
        15,443,735      dTLB-loads                # 3217.365 M/sec                    ( +-  0.00% )
     <not counted>      dTLB-load-misses                                              (0.00%)
     <not counted>      iTLB-loads                                                    (0.00%)
     <not counted>      iTLB-load-misses                                              (0.00%)
   <not supported>      L1-dcache-prefetches                                        
   <not supported>      L1-dcache-prefetch-misses                                   

        0.00503705 +- 0.00000546 seconds time elapsed  ( +-  0.11% )


Revisions
=========

v2->v3: [1]
  * Removed xdp_call, and instead make the dispatcher available to all
    XDP users via bpf_prog_run_xdp() and dev_xdp_install(). (Toke)
  * Always enable the dispatcher, if available (Alexei)
  * Reuse BPF trampoline image allocator (Alexei)
  * Make sure the dispatcher is exercised in selftests (Alexei)
  * Only allow one dispatcher, and wire it to XDP

v1->v2: [2]
  * Fixed i386 build warning (kbuild robot)
  * Made bpf_dispatcher_lookup() static (kbuild robot)
  * Make sure xdp_call.h is only enabled for builtins
  * Add xdp_call() to ixgbe, mlx4, and mlx5

RFC->v1: [3]
  * Improved error handling (Edward and Andrii)
  * Explicit cleanup (Andrii)
  * Use 32B with sext cmp (Alexei)
  * Align jump targets to 16B (Alexei)
  * 4 to 16 entries (Toke)
  * Added stats to xdp_call_run()

[1] https://lore.kernel.org/bpf/20191123071226.6501-1-bjorn.topel@gmail.com/
[2] https://lore.kernel.org/bpf/20191119160757.27714-1-bjorn.topel@gmail.com/
[3] https://lore.kernel.org/bpf/20191113204737.31623-1-bjorn.topel@gmail.com/

Björn Töpel (6):
  bpf: move trampoline JIT image allocation to a function
  bpf: introduce BPF dispatcher
  bpf, xdp: start using the BPF dispatcher for XDP
  bpf: start using the BPF dispatcher in BPF_TEST_RUN
  selftests: bpf: add xdp_perf test
  bpf, x86: align dispatcher branch targets to 16B

 arch/x86/net/bpf_jit_comp.c                   | 150 +++++++++++++
 include/linux/bpf.h                           |   8 +
 include/linux/filter.h                        |  56 +++--
 kernel/bpf/Makefile                           |   1 +
 kernel/bpf/dispatcher.c                       | 207 ++++++++++++++++++
 kernel/bpf/syscall.c                          |  26 ++-
 kernel/bpf/trampoline.c                       |  24 +-
 net/bpf/test_run.c                            |  15 +-
 net/core/dev.c                                |  19 +-
 net/core/filter.c                             |  22 ++
 .../selftests/bpf/prog_tests/xdp_perf.c       |  25 +++
 11 files changed, 516 insertions(+), 37 deletions(-)
 create mode 100644 kernel/bpf/dispatcher.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_perf.c

-- 
2.20.1

