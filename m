Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61B53D190A
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 23:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhGUUsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 16:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbhGUUsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 16:48:04 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2AAC061575;
        Wed, 21 Jul 2021 14:28:40 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gx2so3207603pjb.5;
        Wed, 21 Jul 2021 14:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5YY/u+AQb8K/7QBjhwWLlk7I9/C0QmO8P58ESvRpHis=;
        b=O/MASW9PZ0WzE5Ngcmk7tpBDrSU7Qs8rgfSQwKZMWBnGWN1P5g3rgnfPPzlOssRco3
         HAa7EX76D1kWvNAbM1117HgAY8aBCYAsNBk6D/pwWX2DrAYcpwNCivXltjr8DsjIBUEN
         PAoPmUbS8om7dWElcdI4j+xfMoPWVncKk38+pUSog/3GM2RwrgGfkA3lK/nIrDm5aJn7
         16q0Jw7RW+aapFknaZoCg5g4ccHOpFDZXZK5phJ44w7CE6RMWnc2XwcBFyf+/k+++3Tm
         dI/CAQxOtBZsY3yhy0BU07RhHJzXZWV4IqdAnFa33Gc7yGq44rk1wSE6bMG/YADLTDcb
         9B3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5YY/u+AQb8K/7QBjhwWLlk7I9/C0QmO8P58ESvRpHis=;
        b=TU4KJ8jeUeTjm2LRmHda0zlZei9gnGeSuoDimCiSN9iIsRfemM8nqKYpIcuU6CwDNQ
         bp01WwFovidOCEMw4nunsrgnzg9z0tAN+TX/TcHAKk4gabTmMxLkQrl/zwUqMHJe0d8e
         bfNo5jf2IWy/tbitVmWPy9lY7vJ3Evoc6V7cMh4CxTlfJhyx85AsZ74ewv8bOmo4s4mA
         a6NSWXwuzT3N5ysZGV+kZA9W2bL8O2Qn0k8GLmcdkZKQ7qZyGSxLx8xzeLVuD1MEK62p
         8SpA1p0xYj9Wv3ANRY/36dXzfrq9l0lNANF36cIboCgRA9CPvySc5K26bU71kzXU9leR
         z69w==
X-Gm-Message-State: AOAM5330jyxiZ232LgY4NQ0RnBSy2OD6nN6SAzD0Hltd7L3uPJibDJtw
        I15KlZTzQfUsjz6dcqrt7BQsUcQhWWpo2w==
X-Google-Smtp-Source: ABdhPJwImGjgNNA2PbKa3mO+8dDGxjOP/xGzKMTKHwm1q+pGnYGwuxBJOJlVm8zStZ2xlP4HuDebwg==
X-Received: by 2002:a05:6a00:1582:b029:333:a366:fe47 with SMTP id u2-20020a056a001582b0290333a366fe47mr34639673pfk.0.1626902919983;
        Wed, 21 Jul 2021 14:28:39 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0bb:dc30:f309:2f53:5818])
        by smtp.gmail.com with ESMTPSA id w2sm22670956pjq.5.2021.07.21.14.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 14:28:39 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 0/8] Improve XDP samples usability and output
Date:   Thu, 22 Jul 2021 02:58:25 +0530
Message-Id: <20210721212833.701342-1-memxor@gmail.com>
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

 ; sudo ./xdp_redirect_map veth0 veth1 -s
Redirecting from veth0 (ifindex 5; driver veth) to veth1 (ifindex 4; driver veth)
veth0->veth1           10,557,813 rx/s         10,557,810 redir/s               0 err,drop/s   10,557,810 xmit/s
veth0->veth1           11,556,537 rx/s         11,556,536 redir/s               0 err,drop/s   11,556,535 xmit/s
^\
veth0->veth1           11,565,356 rx/s         11,565,358 redir/s               0 err,drop/s   11,565,367 xmit/s
  receive total        11,565,356 pkt/s                 0 drop/s                0 error/s
    cpu:0              11,565,356 pkt/s                 0 drop/s                0 error/s
  redirect total       11,565,358 redir/s
    cpu:6              11,565,358 redir/s
  redirect_err                  0 error/s
  xdp_exception                 0 hit/s
  devmap_xmit total    11,565,367 xmit/s                0 drop/s                0 drv_err/s          2.00 bulk_avg
     cpu:6             11,565,367 xmit/s                0 drop/s                0 drv_err/s          2.00 bulk_avg

veth0->veth1           11,554,701 rx/s         11,554,702 redir/s               0 err,drop/s   11,554,701 xmit/s
  receive total        11,554,701 pkt/s                 0 drop/s                0 error/s
    cpu:0              11,554,701 pkt/s                 0 drop/s                0 error/s
  redirect total       11,554,702 redir/s
    cpu:6              11,554,702 redir/s
  redirect_err                  0 error/s
  xdp_exception                 0 hit/s
  devmap_xmit total    11,554,701 xmit/s                0 drop/s                0 drv_err/s          2.00 bulk_avg
     cpu:6             11,554,701 xmit/s                0 drop/s                0 drv_err/s          2.00 bulk_avg

^C
Totals
  Packets received    : 45,234,407
  Average packets/s   : 5,654,301
  Packets redirected  : 45,234,406
  Average redir/s     : 5,654,301
  Rx dropped          : 0
  Tx dropped          : 0
  Errors recorded     : 0
  Packets transmitted : 45,234,413
  Average transmit/s  : 5,654,302

The xdp_redirect tracepoint (for success stats) needs to be enabled explicitly using --stats/-s.

Changelog:
----------
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

 samples/bpf/Makefile                          |  113 +-
 samples/bpf/cookie_uid_helper_example.c       |   12 +-
 samples/bpf/tracex4_user.c                    |    2 +-
 samples/bpf/xdp_monitor.bpf.c                 |    8 +
 samples/bpf/xdp_monitor_kern.c                |  257 ---
 samples/bpf/xdp_monitor_user.c                |  768 +--------
 samples/bpf/xdp_redirect.bpf.c                |   52 +
 samples/bpf/xdp_redirect_cpu.bpf.c            |  561 +++++++
 samples/bpf/xdp_redirect_cpu_kern.c           |  730 ---------
 samples/bpf/xdp_redirect_cpu_user.c           |  916 ++---------
 samples/bpf/xdp_redirect_kern.c               |   90 --
 ...rect_map_kern.c => xdp_redirect_map.bpf.c} |   75 +-
 ...ti_kern.c => xdp_redirect_map_multi.bpf.c} |   40 +-
 samples/bpf/xdp_redirect_map_multi_user.c     |  316 ++--
 samples/bpf/xdp_redirect_map_user.c           |  385 ++---
 samples/bpf/xdp_redirect_user.c               |  262 ++--
 samples/bpf/xdp_sample.bpf.c                  |  215 +++
 samples/bpf/xdp_sample.bpf.h                  |   57 +
 samples/bpf/xdp_sample_shared.h               |   53 +
 samples/bpf/xdp_sample_user.c                 | 1380 +++++++++++++++++
 samples/bpf/xdp_sample_user.h                 |  202 +++
 21 files changed, 3277 insertions(+), 3217 deletions(-)
 create mode 100644 samples/bpf/xdp_monitor.bpf.c
 delete mode 100644 samples/bpf/xdp_monitor_kern.c
 create mode 100644 samples/bpf/xdp_redirect.bpf.c
 create mode 100644 samples/bpf/xdp_redirect_cpu.bpf.c
 delete mode 100644 samples/bpf/xdp_redirect_cpu_kern.c
 delete mode 100644 samples/bpf/xdp_redirect_kern.c
 rename samples/bpf/{xdp_redirect_map_kern.c => xdp_redirect_map.bpf.c} (62%)
 rename samples/bpf/{xdp_redirect_map_multi_kern.c => xdp_redirect_map_multi.bpf.c} (74%)
 create mode 100644 samples/bpf/xdp_sample.bpf.c
 create mode 100644 samples/bpf/xdp_sample.bpf.h
 create mode 100644 samples/bpf/xdp_sample_shared.h
 create mode 100644 samples/bpf/xdp_sample_user.c
 create mode 100644 samples/bpf/xdp_sample_user.h

-- 
2.32.0

