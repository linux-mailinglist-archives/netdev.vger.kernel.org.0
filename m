Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867F421E464
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgGNARu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgGNARt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 20:17:49 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5DBC061755;
        Mon, 13 Jul 2020 17:17:49 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id b9so6252120plx.6;
        Mon, 13 Jul 2020 17:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=W5Yo48XifREcrPU/LdubCq4rKIKlFxNMZuxvX/PX0JA=;
        b=nHQ42a9Q+lvSWY+G9YRV5Cjsi+FLrfk5iep8MvnOulh6l6XSiL9S6vvGWOdjE6VLSW
         nlN9fC6DZluKbRSroD3pYCCJwlK9BHy76O01ezmWQWIUUA7PT5zDf9MeCsaSHDXWnvZ7
         XDAf+tCOK18d6sEu6bEcBFN/qW+DFbOCXNAkUAtRhG3FIsbW7MpHZb0klOqy32hV7cVv
         7nYtxaN/rwjVGhku7PwcwU/D9IwcazDkxI0sXJPgGuXgYCMz5ID6W2CrGTRGpX6pXrG4
         YINzSwCtfp+eEu+s+vmpQs0yNeiC6QTiQrp/4+RW4cpugob+UYCPGG+zt9/g/if8RTyy
         0EPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=W5Yo48XifREcrPU/LdubCq4rKIKlFxNMZuxvX/PX0JA=;
        b=rso/SYN5H7xhYTNVrLToD8bfsXULOA9vbSYcL11j+4hii1HMImh1LP0Jo9pfVaOoWZ
         PbjEK6DmfOns0L5ViVhqlXIDiL0HahtHNM2tOqdAN4WVdUOqsIwO/oHMJ3Q2ICT9x4++
         6yqlCdFEjscT/tz4DXikkD6vAwfAk71R+gqSlJJLZT4hrSKBGc5+LU61pddNsmcnPb3C
         gYgEj6O72QWo2yygQwCNSfjwi7drgTsQfqm2hkVjb8mlPr9XyHPbN++/OCbpBWGobJNh
         nBnENTsucQnlgGeTqXZQrN/ft9Asitd+PHHaj6TiETcrsCVKcwo43r2erBAQpsmc1y9/
         AlUg==
X-Gm-Message-State: AOAM532DOWOKnLM+GEJYTDuNlg5rNisWJDK9YU8Hu37buUVHWBAzVfG0
        z0/6roFmt0hME4l7cCti0L2c+V6T
X-Google-Smtp-Source: ABdhPJzTC7+bne9apsibfkqSRI8klUP56FcQYoVbsLCFcLX04Q/cuYSvi9I+7BNq34tN8AOf9/6qdQ==
X-Received: by 2002:a17:90a:ee95:: with SMTP id i21mr1940921pjz.77.1594685869193;
        Mon, 13 Jul 2020 17:17:49 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id 4sm14156375pgk.68.2020.07.13.17.17.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Jul 2020 17:17:48 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: pull-request: bpf-next 2020-07-13
Date:   Mon, 13 Jul 2020 17:17:46 -0700
Message-Id: <20200714001746.33952-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 36 non-merge commits during the last 7 day(s) which contain
a total of 62 files changed, 2242 insertions(+), 468 deletions(-).

The main changes are:

1) Avoid trace_printk warning banner by switching bpf_trace_printk to use
   its own tracing event, from Alan.

2) Better libbpf support on older kernels, from Andrii.

3) Additional AF_XDP stats, from Ciara.

4) build time resolution of BTF IDs, from Jiri.

5) BPF_CGROUP_INET_SOCK_RELEASE hook, from Stanislav.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrey Ignatov, Andrii Nakryiko, Anton Protopopov, Quentin Monnet, Simon 
Horman, Yonghong Song

----------------------------------------------------------------

The following changes since commit 4e48978cd28ce51945c08650e5c5502ca41e1fcc:

  mvpp2: fix pointer check (2020-07-07 13:03:21 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 8afb259a9840fa953efb9a7835356a083ac8ec74:

  Merge branch 'strip-mods-from-global-vars' (2020-07-13 17:08:44 -0700)

----------------------------------------------------------------
Alan Maguire (2):
      bpf: Use dedicated bpf_trace_printk event instead of trace_printk()
      selftests/bpf: Add selftests verifying bpf_trace_printk() behaviour

Alexei Starovoitov (4):
      Merge branch 'resolve_btfids'
      Merge branch 'af_xdp-stats'
      Merge branch 'trace_printk-banner-remove'
      Merge branch 'strip-mods-from-global-vars'

Andrii Nakryiko (10):
      libbpf: Make BTF finalization strict
      libbpf: Add btf__set_fd() for more control over loaded BTF FD
      libbpf: Improve BTF sanitization handling
      selftests/bpf: Add test relying only on CO-RE and no recent kernel features
      libbpf: Handle missing BPF_OBJ_GET_INFO_BY_FD gracefully in perf_buffer
      selftests/bpf: Switch perf_buffer test to tracepoint and skeleton
      libbpf: Fix memory leak and optimize BTF sanitization
      tools/bpftool: Remove warning about PID iterator support
      libbpf: Support stripping modifiers for btf_dump
      tools/bpftool: Strip away modifiers from global variables

Ciara Loftus (3):
      xsk: Add new statistics
      samples: bpf: Add an option for printing extra statistics in xdpsock
      xsk: Add xdp statistics to xsk_diag

Daniel Borkmann (1):
      Merge branch 'bpf-libbpf-old-kernel'

Daniel T. Lee (4):
      samples: bpf: Fix bpf programs with kprobe/sys_connect event
      samples: bpf: Refactor BPF map in map test with libbpf
      samples: bpf: Refactor BPF map performance test with libbpf
      selftests: bpf: Remove unused bpf_map_def_legacy struct

Jesper Dangaard Brouer (2):
      selftests/bpf: test_progs use another shell exit on non-actions
      selftests/bpf: test_progs avoid minus shell exit codes

Jiri Olsa (9):
      bpf: Add resolve_btfids tool to resolve BTF IDs in ELF object
      bpf: Compile resolve_btfids tool at kernel compilation start
      bpf: Add BTF_ID_LIST/BTF_ID/BTF_ID_UNUSED macros
      bpf: Resolve BTF IDs in vmlinux image
      bpf: Remove btf_id helpers resolving
      bpf: Use BTF_ID to resolve bpf_ctx_convert struct
      bpf: Add info about .BTF_ids section to btf.rst
      tools headers: Adopt verbatim copy of btf_ids.h from kernel sources
      selftests/bpf: Add test for resolve_btfids

Louis Peens (1):
      bpf: Fix another bpftool segfault without skeleton code enabled

Stanislav Fomichev (4):
      bpf: Add BPF_CGROUP_INET_SOCK_RELEASE hook
      libbpf: Add support for BPF_CGROUP_INET_SOCK_RELEASE
      bpftool: Add support for BPF_CGROUP_INET_SOCK_RELEASE
      selftests/bpf: Test BPF_CGROUP_INET_SOCK_RELEASE

Wenbo Zhang (1):
      bpf: Fix fds_example SIGSEGV error

 Documentation/bpf/btf.rst                          |  36 +
 Makefile                                           |  25 +-
 include/asm-generic/vmlinux.lds.h                  |   4 +
 include/linux/bpf-cgroup.h                         |   4 +
 include/linux/btf_ids.h                            |  87 +++
 include/net/xdp_sock.h                             |   4 +
 include/uapi/linux/bpf.h                           |   1 +
 include/uapi/linux/if_xdp.h                        |   5 +-
 include/uapi/linux/xdp_diag.h                      |  11 +
 kernel/bpf/btf.c                                   | 103 +--
 kernel/bpf/stackmap.c                              |   5 +-
 kernel/bpf/syscall.c                               |   3 +
 kernel/trace/Makefile                              |   2 +
 kernel/trace/bpf_trace.c                           |  51 +-
 kernel/trace/bpf_trace.h                           |  34 +
 net/core/filter.c                                  |  10 +-
 net/ipv4/af_inet.c                                 |   3 +
 net/xdp/xsk.c                                      |  36 +-
 net/xdp/xsk_buff_pool.c                            |   1 +
 net/xdp/xsk_diag.c                                 |  17 +
 net/xdp/xsk_queue.h                                |   6 +
 samples/bpf/Makefile                               |   2 +-
 samples/bpf/fds_example.c                          |   3 +-
 samples/bpf/map_perf_test_kern.c                   | 188 +++---
 samples/bpf/map_perf_test_user.c                   | 164 +++--
 samples/bpf/test_map_in_map_kern.c                 |  94 +--
 samples/bpf/test_map_in_map_user.c                 |  53 +-
 samples/bpf/test_probe_write_user_kern.c           |   9 +-
 samples/bpf/xdpsock_user.c                         |  87 ++-
 scripts/link-vmlinux.sh                            |   6 +
 tools/Makefile                                     |   3 +
 tools/bpf/Makefile                                 |   9 +-
 tools/bpf/bpftool/common.c                         |   1 +
 tools/bpf/bpftool/gen.c                            |  23 +-
 tools/bpf/bpftool/pids.c                           |   2 +-
 tools/bpf/resolve_btfids/Build                     |  10 +
 tools/bpf/resolve_btfids/Makefile                  |  77 +++
 tools/bpf/resolve_btfids/main.c                    | 721 +++++++++++++++++++++
 tools/include/linux/btf_ids.h                      |  87 +++
 tools/include/linux/compiler.h                     |   4 +
 tools/include/uapi/linux/bpf.h                     |   1 +
 tools/include/uapi/linux/if_xdp.h                  |   5 +-
 tools/lib/bpf/btf.c                                |   9 +-
 tools/lib/bpf/btf.h                                |   7 +-
 tools/lib/bpf/btf_dump.c                           |  10 +-
 tools/lib/bpf/libbpf.c                             | 149 +++--
 tools/lib/bpf/libbpf.map                           |   1 +
 tools/testing/selftests/bpf/Makefile               |  15 +-
 tools/testing/selftests/bpf/bpf_legacy.h           |  14 -
 .../testing/selftests/bpf/prog_tests/core_retro.c  |  33 +
 .../testing/selftests/bpf/prog_tests/perf_buffer.c |  42 +-
 .../selftests/bpf/prog_tests/resolve_btfids.c      | 111 ++++
 tools/testing/selftests/bpf/prog_tests/skeleton.c  |   6 +-
 .../selftests/bpf/prog_tests/trace_printk.c        |  75 +++
 tools/testing/selftests/bpf/prog_tests/udp_limit.c |  75 +++
 tools/testing/selftests/bpf/progs/btf_data.c       |  50 ++
 .../testing/selftests/bpf/progs/test_core_retro.c  |  30 +
 .../testing/selftests/bpf/progs/test_perf_buffer.c |   4 +-
 tools/testing/selftests/bpf/progs/test_skeleton.c  |   6 +-
 tools/testing/selftests/bpf/progs/trace_printk.c   |  21 +
 tools/testing/selftests/bpf/progs/udp_limit.c      |  42 ++
 tools/testing/selftests/bpf/test_progs.c           |  13 +-
 62 files changed, 2242 insertions(+), 468 deletions(-)
 create mode 100644 include/linux/btf_ids.h
 create mode 100644 kernel/trace/bpf_trace.h
 create mode 100644 tools/bpf/resolve_btfids/Build
 create mode 100644 tools/bpf/resolve_btfids/Makefile
 create mode 100644 tools/bpf/resolve_btfids/main.c
 create mode 100644 tools/include/linux/btf_ids.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/core_retro.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_printk.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/udp_limit.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_data.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_retro.c
 create mode 100644 tools/testing/selftests/bpf/progs/trace_printk.c
 create mode 100644 tools/testing/selftests/bpf/progs/udp_limit.c
