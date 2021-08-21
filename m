Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78AB73F3786
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 02:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234488AbhHUAUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 20:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhHUAUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 20:20:53 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D65DC061575;
        Fri, 20 Aug 2021 17:20:14 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 18so10020417pfh.9;
        Fri, 20 Aug 2021 17:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9b6iWlJE1wvPXgJ7Dbu0sivqz1byP795RZ0yn2uOLxg=;
        b=MW03QgaKqVEvJerBxOQhhW2tSgrx+55nRfWdOMwRheQxrwpNBMJVtOdP7ds4YyxlBS
         qbzX7zGYaWvqUm2ATlT2nnOaqGErjaSJukruabxvvdMTVB+3yHSd0cCopKyNjxwisz2e
         +QSWiSNBGWq5Rr2g/9O9+X76bOtuz3UUu9c0HII2b0teAblq2xeuKATzwp/VuOEPHln/
         81pfx4kEKrQlKyBcJKLsSjuvMrKrBVVZb7wJ/PzMHLY7MCV+JymsPZdHy20Bszys5Rt2
         8UL8enzxeIAjHOASDGIhtH0rE55I4xbfux3nAXvLATUDREMVL/aKgXNP0qe1PzV7rnzP
         CjhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9b6iWlJE1wvPXgJ7Dbu0sivqz1byP795RZ0yn2uOLxg=;
        b=o+1dCCO7vs6hcYq92t1ebIyKqBilarlHGhuLqHXXuq0ceDEh9Qs2nKqE+W9lWVeBpV
         Xg8iLRIQgwovMZl9/RK2b4kYpkCrVuu3P2laVD2K7loI+WiQRIGT5t8XMQyopOOGA/+D
         Eul6icu8Ycg40VP9g+h2ARLFV4MK9bB7MXKy5eOSSCfVx8QNyjAzaTvg6GBd1vWiO14v
         0XJW6+q90JqmRU2ERN2OWoCN+tbnk9C/rXoz3gha1DXYbYq/bVNLbtyKmZqDgviRL5T7
         zdSMEX8FckkcyCkrKSp2gMsg31B2cmDYZZcBa/x4U1nugtXViqAItbAUXIS32jrZ4Yoa
         iZeA==
X-Gm-Message-State: AOAM533HgCld31sJAsEv28u+DP1wiPTmDPuQr/BP7vcl/yScKZqfnzmw
        7TBRhRDXaC8gd7is89gV78sUzWljN+w=
X-Google-Smtp-Source: ABdhPJxJYPXLN4JJnaDzVHNKg+A15ni2SrvD9Wxke0upPIsa/A0C+HsrEHEd7DvVTBVtdRkC7b7jEw==
X-Received: by 2002:aa7:9dce:0:b0:3e1:3c5d:640d with SMTP id g14-20020aa79dce000000b003e13c5d640dmr21851138pfq.25.1629505214067;
        Fri, 20 Aug 2021 17:20:14 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id i8sm8402030pfo.117.2021.08.20.17.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 17:20:13 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 00/22] Improve XDP samples usability and output
Date:   Sat, 21 Aug 2021 05:49:48 +0530
Message-Id: <20210821002010.845777-1-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
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
v3 -> v4:
v3: https://lore.kernel.org/bpf/20210728165552.435050-1-memxor@gmail.com

 * Address all feedback from Daniel
  * Use READ_ONCE/WRITE_ONCE from linux/compiler.h (cannot directly include
    due to conflicts with vmlinux.h)
  * Fix MAX_CPUS hardcoding by switching to mmapable array maps, that are
    resized based on the value of libbpf_num_possible_cpus
  * s/ELEMENTS_OF/ARRAY_SIZE/g
  * Use tools/include/linux/hashtable.h
  * Coding style fixes
  * Remove hyperlinks for tracepoints
  * Split into smaller reviewable changes
 * Restore support for specifying custom xdp_redirect_cpu cpumap prog with some
   enhancements, including built-in programs for common actions (pass, drop,
   redirect). By default, cpumap prog is now disabled.
 * Misc bug fixes all over the place

  The printing stuff is a lot more basic without hyperlink support, hence it
  has not been exported into a more general facility.

v2 -> v3
v2: https://lore.kernel.org/bpf/20210721212833.701342-1-memxor@gmail.com

 * Address all feedback from Andrii
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

Kumar Kartikeya Dwivedi (22):
  samples: bpf: fix a couple of warnings
  tools: include: add ethtool_drvinfo definition to UAPI header
  samples: bpf: Add basic infrastructure for XDP samples
  samples: bpf: Add BPF support for redirect tracepoint
  samples: bpf: Add redirect tracepoint statistics support
  samples: bpf: Add BPF support for xdp_exception tracepoint
  samples: bpf: Add xdp_exception tracepoint statistics support
  samples: bpf: Add BPF support for cpumap tracepoints
  samples: bpf: Add cpumap tracepoint statistics support
  samples: bpf: Add BPF support for devmap_xmit tracepoint
  samples: bpf: Add devmap_xmit tracepoint statistics support
  samples: bpf: add vmlinux.h generation support
  samples: bpf: Convert xdp_monitor_kern.o to XDP samples helper
  samples: bpf: Convert xdp_monitor to XDP samples helper
  samples: bpf: Convert xdp_redirect_kern.o to XDP samples helper
  samples: bpf: Convert xdp_redirect to XDP samples helper
  samples: bpf: Convert xdp_redirect_cpu_kern.o to XDP samples helper
  samples: bpf: Convert xdp_redirect_cpu to XDP samples helper
  samples: bpf: Convert xdp_redirect_map_kern.o to XDP samples helper
  samples: bpf: Convert xdp_redirect_map to XDP samples helper
  samples: bpf: Convert xdp_redirect_map_multi_kern.o to XDP samples
    helper
  samples: bpf: Convert xdp_redirect_map_multi to XDP samples helper

 samples/bpf/Makefile                          |  109 +-
 samples/bpf/Makefile.target                   |   11 +
 samples/bpf/cookie_uid_helper_example.c       |   11 +-
 samples/bpf/tracex4_user.c                    |    2 +-
 samples/bpf/xdp_monitor.bpf.c                 |    8 +
 samples/bpf/xdp_monitor_kern.c                |  257 ---
 samples/bpf/xdp_monitor_user.c                |  798 +-------
 samples/bpf/xdp_redirect.bpf.c                |   49 +
 ...rect_cpu_kern.c => xdp_redirect_cpu.bpf.c} |  393 +---
 samples/bpf/xdp_redirect_cpu_user.c           | 1105 ++++-------
 samples/bpf/xdp_redirect_kern.c               |   90 -
 ...rect_map_kern.c => xdp_redirect_map.bpf.c} |   89 +-
 ...ti_kern.c => xdp_redirect_map_multi.bpf.c} |   50 +-
 samples/bpf/xdp_redirect_map_multi_user.c     |  345 ++--
 samples/bpf/xdp_redirect_map_user.c           |  385 ++--
 samples/bpf/xdp_redirect_user.c               |  270 ++-
 samples/bpf/xdp_sample.bpf.c                  |  266 +++
 samples/bpf/xdp_sample.bpf.h                  |  141 ++
 samples/bpf/xdp_sample_shared.h               |   17 +
 samples/bpf/xdp_sample_user.c                 | 1673 +++++++++++++++++
 samples/bpf/xdp_sample_user.h                 |  108 ++
 tools/include/uapi/linux/ethtool.h            |   53 +
 22 files changed, 3388 insertions(+), 2842 deletions(-)
 create mode 100644 samples/bpf/xdp_monitor.bpf.c
 delete mode 100644 samples/bpf/xdp_monitor_kern.c
 create mode 100644 samples/bpf/xdp_redirect.bpf.c
 rename samples/bpf/{xdp_redirect_cpu_kern.c => xdp_redirect_cpu.bpf.c} (52%)
 delete mode 100644 samples/bpf/xdp_redirect_kern.c
 rename samples/bpf/{xdp_redirect_map_kern.c => xdp_redirect_map.bpf.c} (57%)
 rename samples/bpf/{xdp_redirect_map_multi_kern.c => xdp_redirect_map_multi.bpf.c} (64%)
 create mode 100644 samples/bpf/xdp_sample.bpf.c
 create mode 100644 samples/bpf/xdp_sample.bpf.h
 create mode 100644 samples/bpf/xdp_sample_shared.h
 create mode 100644 samples/bpf/xdp_sample_user.c
 create mode 100644 samples/bpf/xdp_sample_user.h

-- 
2.33.0

