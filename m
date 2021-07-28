Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5AC3D93A7
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 18:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhG1Q4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 12:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbhG1Q4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 12:56:47 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBDBC061757;
        Wed, 28 Jul 2021 09:56:44 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a4-20020a17090aa504b0290176a0d2b67aso11035208pjq.2;
        Wed, 28 Jul 2021 09:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nkSlvfqxLr2/TQg3hh9D+cecrQIBpsHzsmW6GmfTkAg=;
        b=H/H/nQFyqPuxiDIjXgNHbZRKyvk6Unv2I9BlYYoaZf1GAIi7my2az8IgdJF81m0TRj
         989BdUhCioYP2679/VoKTStmacZkP3dCsRe0lZqNyJoQ95/kwNBO5sWrm77KpaUCprCE
         3SoeV4pXKVqSLuvx3en6IEl2OSOe5yYknkUc1ntQtKw68kecP1IrrJFOmsiR/zbDk7BZ
         jwnTg/sSSgFCeWK+fSa4pWXyEQL7DIW0JVIjgd5kRLrzn33opQLdjp7FEpuJsVFublGT
         8xHURTqVOCzbcb8oLORQ1Mzl42lc6epo5ntWv6uBP+cJ0C3yMAMK8uzghJ9+ooeednrx
         avxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nkSlvfqxLr2/TQg3hh9D+cecrQIBpsHzsmW6GmfTkAg=;
        b=OVwyXrswQiqJiQMAjGk1/A6M3v1kY0TOCTkGJfknEMPe1Lq5sG44+ltLGjeMclvMPm
         3cVp4MYVR1C/p9CepmsywhPow89m2OzKjRtWrdS0bUzJMjIaisLsyD3tVLUzmPXThiOT
         SELhe8ycto2ZDILcvwrf93k9Vr1jofcV7Ojlov9OHj9hC0KLMDCTEiE9w/t71nTVEV4a
         E4kzh2nIfCjNfwjGargkC7ANcKebsXZB/tO7MJrJc87RBumX36DUWQGcuAnUEITc1lXQ
         COjmckZSHBGEXGZOuggBqgp29zdseTXR2PL5wxuYGSEVZfbBFulnkR36njwzPWKh82vb
         Z6WQ==
X-Gm-Message-State: AOAM530HV4JJl44oQE48uZIRRL/rMVC03YKOsq2LNSqAD9L8ZAkKWwz/
        aRzpj/AXeCb1hsmoOwXozkO+qNF+zpHmGQ==
X-Google-Smtp-Source: ABdhPJzBaVsnncO5CL2uLorhEViL7bKeqKZELDDM/hO/YEY5FUss7IhiGnK4kydupo35k1dOiPS+zA==
X-Received: by 2002:a17:90b:4b8d:: with SMTP id lr13mr10648773pjb.141.1627491403623;
        Wed, 28 Jul 2021 09:56:43 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0bb:dc30:f309:2f53:5818])
        by smtp.gmail.com with ESMTPSA id o3sm6346771pjr.49.2021.07.28.09.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 09:56:43 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 0/8] Improve XDP samples usability and output
Date:   Wed, 28 Jul 2021 22:25:44 +0530
Message-Id: <20210728165552.435050-1-memxor@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set revamps XDP samples related to redirection to show better output and
implement missing features consolidating all their differences and giving them a
consistent look and feel, by implementing common features and command line
options.  Some of the TODO items like reporting redirect error numbers
(ENETDOWN, EINVAL, ENOSPC, etc.) have also been implemented.

Some of the features are:
* Received packet statistics
* xdp_redirect/xdp_redirect_map tracepoint statistics
* xdp_redirect_err/xdp_redirect_map_err tracepoint statistics (with support for
  showing exact errno)
* xdp_cpumap_enqueue/xdp_cpumap_kthread tracepoint statistics
* xdp_devmap_xmit tracepoint statistics
* xdp_exception tracepoint statistics
* Per ifindex pair devmap_xmit stats shown dynamically (for xdp_monitor) to
  decompose the total.
* Use of BPF skeleton and BPF static linking to share BPF programs.
* Use of vmlinux.h and tp_btf for raw_tracepoint support.
* Removal of redundant -N/--native-mode option (enforced by default now)
* ... and massive cleanups all over the place.

All tracepoints also use raw_tp now, and tracepoints like xdp_redirect
are only enabled when requested explicitly to capture successful redirection
statistics.

The set of programs converted as part of this series are:
 * xdp_redirect_cpu
 * xdp_redirect_map_multi
 * xdp_redirect_map
 * xdp_redirect
 * xdp_monitor

 Explanation of the output:

There is now a concise output mode by default that shows primarily four fields:
  rx/s        Number of packets received per second
  redir/s     Number of packets successfully redirected per second
  err,drop/s  Aggregated count of errors per second (including dropped packets)
  xmit/s      Number of packets transmitted on the output device per second

Some examples:
 ; sudo ./xdp_redirect_map veth0 veth1 -s
Redirecting from veth0 (ifindex 15; driver veth) to veth1 (ifindex 14; driver veth)
veth0->veth1                    0 rx/s                  0 redir/s		0 err,drop/s               0 xmit/s
veth0->veth1            9,998,660 rx/s          9,998,658 redir/s		0 err,drop/s       9,998,654 xmit/s
...

There is also a verbose mode, that can also be enabled by default using -v (--verbose).
The output mode can be switched dynamically at runtime using Ctrl + \ (SIGQUIT).

To make the concise output more useful, the errors that occur are expanded inline
(as if verbose mode was enabled) to let the user pin down the source of the
problem without having to clutter output (or possibly miss it) or always use verbose mode.

For instance, let's consider a case where the output device link state is set to
down while redirection is happening:

[...]
veth0->veth1           24,503,376 rx/s                  0 err,drop/s      24,503,372 xmit/s
veth0->veth1           25,044,775 rx/s                  0 err,drop/s      25,044,783 xmit/s
veth0->veth1           25,263,046 rx/s                  4 err,drop/s      25,263,028 xmit/s
  redirect_err                  4 error/s
    ENETDOWN                    4 error/s
[...]

The same holds for xdp_exception actions.

An example of how a complete xdp_redirect_map session would look:

 ; sudo ./xdp_redirect_map veth0 veth1
Redirecting from veth0 (ifindex 5; driver veth) to veth1 (ifindex 4; driver veth)
veth0->veth1            7,411,506 rx/s                  0 err,drop/s    7,411,470 xmit/s
veth0->veth1            8,931,770 rx/s                  0 err,drop/s    8,931,771 xmit/s
^\
veth0->veth1            8,787,295 rx/s                  0 err,drop/s    8,787,325 xmit/s
  receive total         8,787,295 pkt/s                 0 drop/s                0 error/s
    cpu:7               8,787,295 pkt/s                 0 drop/s                0 error/s
  redirect_err                  0 error/s
  xdp_exception                 0 hit/s
  xmit veth0->veth1     8,787,325 xmit/s                0 drop/s                0 drv_err/s          2.00 bulk-avg
     cpu:7              8,787,325 xmit/s                0 drop/s                0 drv_err/s          2.00 bulk-avg

veth0->veth1            8,842,610 rx/s                  0 err,drop/s    8,842,606 xmit/s
  receive total         8,842,610 pkt/s                 0 drop/s                0 error/s
    cpu:7               8,842,610 pkt/s                 0 drop/s                0 error/s
  redirect_err                  0 error/s
  xdp_exception                 0 hit/s
  xmit veth0->veth1     8,842,606 xmit/s                0 drop/s                0 drv_err/s          2.00 bulk-avg
     cpu:7              8,842,606 xmit/s                0 drop/s                0 drv_err/s          2.00 bulk-avg

^C
  Packets received    : 33,973,181
  Average packets/s   : 4,246,648
  Packets transmitted : 33,973,172
  Average transmit/s  : 4,246,647

The xdp_redirect tracepoint (for success stats) needs to be enabled explicitly
using --stats/-s. Documentation for entire output and options is provided when
user specifies --help/-h with a sample.

Changelog:
----------
v2 -> v3
v2: https://lore.kernel.org/bpf/20210721212833.701342-1-memxor@gmail.com

* Adress all feedback from Andrii
  * Replace usage of libbpf hashmap (internal API) with custom one
  * Rename ATOMIC_* macros to NO_TEAR_* to better reflect their use
  * Use size_t as a portable word sized data type
  * Set libbpf_set_strict_mode
  * Invert conditions in BPF programs to exit early and reduce nesting
  * Use canonical SEC("xdp") naming for all XDP BPF progams
 * Add missing help description for cpumap enqueue and kthread tracepoints
 * Move private struct declarations from xdp_sample_user.h to .c file
 * Improve help output for cpumap enqueue and cpumap kthread tracepoints
 * Fix a bug where keys array for BPF_MAP_LOOKUP_BATCH is overallocated
 * Fix some conditions for printing stats (earlier only checked pps, now pps,
   drop, err and print if any is greater than zero)
 * Fix alloc_stats_record to properly return and cleanup allocated memory on
   allocation failure instead of calling exit(3)
 * Bump bpf_map_lookup_batch count to 32 to reduce lookup time with multiple
   devices in map
 * Fix a bug where devmap_xmit_multi stats are not printed when previous record
   is missing (i.e. when the first time stats are printed), by simply using a
   dummy record that is zeroed out
 * Also print per-CPU counts for devmap_xmit_multi which we collect already
 * Change mac_map to be BPF_MAP_TYPE_HASH instead of array to prevent resizing
   to a large size when max_ifindex is high, in xdp_redirect_map_multi
 * Fix instance of strerror(errno) in sample_install_xdp to use saved errno
 * Provide a usage function from samples helper
 * Provide a fix where incorrect stats are shown for parallel sessions of
   xdp_redirect_* samples by introducing matching support for input device(s),
   output device(s) and cpumap map id for enqueue and kthread stats.
   Only xdp_monitor doesn't filter stats, all others do.

RFC (v1) -> v2
RFC (v1): https://lore.kernel.org/bpf/20210528235250.2635167-1-memxor@gmail.com

 * Address all feedback from Andrii
   * Use BPF static linking
   * Use vmlinux.h
   * Use BPF_PROG macro
   * Use global variables instead of maps
 * Use of tp_btf for raw_tracepoint progs
 * Switch to timerfd for polling
 * Use libbpf hashmap for maintaing device sets for per ifindex pair
   devmap_xmit stats
 * Fix Makefile to specify object dependencies properly
 * Use in-tree bpftool
 * ... misc fixes and cleanups all over the place

Kumar Kartikeya Dwivedi (8):
  samples: bpf: fix a couple of warnings
  samples: bpf: Add common infrastructure for XDP samples
  samples: bpf: Add BPF support for XDP samples helper
  samples: bpf: Convert xdp_monitor to use XDP samples helper
  samples: bpf: Convert xdp_redirect to use XDP samples helper
  samples: bpf: Convert xdp_redirect_map to use XDP samples helpers
  samples: bpf: Convert xdp_redirect_map_multi to use XDP samples
    helpers
  samples: bpf: Convert xdp_redirect_cpu to use XDP samples helpers

 samples/bpf/Makefile                          |  111 +-
 samples/bpf/cookie_uid_helper_example.c       |   12 +-
 samples/bpf/tracex4_user.c                    |    2 +-
 samples/bpf/xdp_monitor.bpf.c                 |    8 +
 samples/bpf/xdp_monitor_kern.c                |  257 ---
 samples/bpf/xdp_monitor_user.c                |  792 +-------
 samples/bpf/xdp_redirect.bpf.c                |   51 +
 ...rect_cpu_kern.c => xdp_redirect_cpu.bpf.c} |  407 +---
 samples/bpf/xdp_redirect_cpu_user.c           |  992 ++--------
 samples/bpf/xdp_redirect_kern.c               |   90 -
 ...rect_map_kern.c => xdp_redirect_map.bpf.c} |   87 +-
 ...ti_kern.c => xdp_redirect_map_multi.bpf.c} |   51 +-
 samples/bpf/xdp_redirect_map_multi_user.c     |  338 ++--
 samples/bpf/xdp_redirect_map_user.c           |  380 ++--
 samples/bpf/xdp_redirect_user.c               |  265 +--
 samples/bpf/xdp_sample.bpf.c                  |  267 +++
 samples/bpf/xdp_sample.bpf.h                  |   62 +
 samples/bpf/xdp_sample_shared.h               |   47 +
 samples/bpf/xdp_sample_user.c                 | 1732 +++++++++++++++++
 samples/bpf/xdp_sample_user.h                 |   94 +
 20 files changed, 3170 insertions(+), 2875 deletions(-)
 create mode 100644 samples/bpf/xdp_monitor.bpf.c
 delete mode 100644 samples/bpf/xdp_monitor_kern.c
 create mode 100644 samples/bpf/xdp_redirect.bpf.c
 rename samples/bpf/{xdp_redirect_cpu_kern.c => xdp_redirect_cpu.bpf.c} (52%)
 delete mode 100644 samples/bpf/xdp_redirect_kern.c
 rename samples/bpf/{xdp_redirect_map_kern.c => xdp_redirect_map.bpf.c} (58%)
 rename samples/bpf/{xdp_redirect_map_multi_kern.c => xdp_redirect_map_multi.bpf.c} (64%)
 create mode 100644 samples/bpf/xdp_sample.bpf.c
 create mode 100644 samples/bpf/xdp_sample.bpf.h
 create mode 100644 samples/bpf/xdp_sample_shared.h
 create mode 100644 samples/bpf/xdp_sample_user.c
 create mode 100644 samples/bpf/xdp_sample_user.h

-- 
2.32.0

