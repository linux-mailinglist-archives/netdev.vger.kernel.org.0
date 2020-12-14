Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7FF2DA2B0
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 22:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438808AbgLNVoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 16:44:09 -0500
Received: from www62.your-server.de ([213.133.104.62]:48274 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbgLNVoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 16:44:01 -0500
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kovcj-000ECb-60; Mon, 14 Dec 2020 22:43:17 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2020-12-14
Date:   Mon, 14 Dec 2020 22:43:16 +0100
Message-Id: <20201214214316.20642-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26017/Mon Dec 14 15:33:39 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 31 non-merge commits during the last 11 day(s) which contain
a total of 40 files changed, 2063 insertions(+), 114 deletions(-).

The main changes are:

1) Expose bpf_sk_storage_*() helpers to iterator programs, from Florent Revest.

2) Add AF_XDP selftests based on veth devs to BPF selftests, from Weqaar Janjua.

3) Support for finding BTF based kernel attach targets through libbpf's
   bpf_program__set_attach_target() API, from Andrii Nakryiko.

4) Permit pointers on stack for helper calls in the verifier, from Yonghong Song.

5) Fix overflows in hash map elem size after rlimit removal, from Eric Dumazet.

6) Get rid of direct invocation of llc in BPF selftests, from Andrew Delgadillo.

7) Fix xsk_recvmsg() to reorder socket state check before access, from Björn Töpel.

8) Add new libbpf API helper to retrieve ring buffer epoll fd, from Brendan Jackman.

9) Batch of minor BPF selftest improvements all over the place, from Florian Lehner,
   KP Singh, Jiri Olsa and various others.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, Björn Töpel, kernel test robot, KP 
Singh, Magnus Karlsson, Martin KaFai Lau, Randy Dunlap, Roman Gushchin, 
Song Liu, syzbot, Yonghong Song

----------------------------------------------------------------

The following changes since commit 846c3c9cfe8a74021b246bc77a848507be225719:

  Merge tag 'wireless-drivers-next-2020-12-03' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next (2020-12-04 10:56:37 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to b4b638c36b7e7acd847b9c4b9c80f268e45ea30c:

  selftests/bpf: Add a test for ptr_to_map_value on stack for helper access (2020-12-14 21:50:10 +0100)

----------------------------------------------------------------
Andrew Delgadillo (1):
      selftests/bpf: Drop the need for LLVM's llc

Andrii Nakryiko (5):
      Merge branch 'Improve error handling of verifier tests'
      bpf: Return -ENOTSUPP when attaching to non-kernel BTF
      selftests/bpf: fix bpf_testmod.ko recompilation logic
      libbpf: Support modules in bpf_program__set_attach_target() API
      selftests/bpf: Add set_attach_target() API selftest for module target

Björn Töpel (1):
      xsk: Validate socket state in xsk_recvmsg, prior touching socket members

Brendan Jackman (1):
      libbpf: Expose libbpf ring_buffer epoll_fd

Daniel Borkmann (1):
      Merge branch 'bpf-xsk-selftests'

Eric Dumazet (1):
      bpf: Avoid overflows involving hash elem_size

Florent Revest (7):
      net: Remove the err argument from sock_from_file
      bpf: Add a bpf_sock_from_file helper
      bpf: Expose bpf_sk_storage_* to iterator programs
      selftests/bpf: Add an iterator selftest for bpf_sk_storage_delete
      selftests/bpf: Add an iterator selftest for bpf_sk_storage_get
      selftests/bpf: Test bpf_sk_storage_get in tcp iterators
      bpf: Only provide bpf_sock_from_file with CONFIG_NET

Florian Lehner (2):
      selftests/bpf: Print reason when a tester could not run a program
      selftests/bpf: Avoid errno clobbering

Jiri Olsa (1):
      selftests/bpf: Make selftest compilation work on clang 11

KP Singh (1):
      selftests/bpf: Silence ima_setup.sh when not running in verbose mode.

Lukas Bulwahn (1):
      bpf: Propagate __user annotations properly

Magnus Karlsson (1):
      samples/bpf: Fix possible hang in xdpsock with multiple threads

Tom Rix (1):
      bpf: Remove trailing semicolon in macro definition

Veronika Kabatova (1):
      selftests/bpf: Drop tcp-{client,server}.py from Makefile

Weqaar Janjua (6):
      selftests/bpf: Xsk selftests framework
      selftests/bpf: Xsk selftests - SKB POLL, NOPOLL
      selftests/bpf: Xsk selftests - DRV POLL, NOPOLL
      selftests/bpf: Xsk selftests - Socket Teardown - SKB, DRV
      selftests/bpf: Xsk selftests - Bi-directional Sockets - SKB, DRV
      selftests/bpf: Xsk selftests - adding xdpxceiver to .gitignore

Yonghong Song (2):
      bpf: Permits pointers on stack for helper calls
      selftests/bpf: Add a test for ptr_to_map_value on stack for helper access

 fs/eventpoll.c                                     |    3 +-
 fs/io_uring.c                                      |   16 +-
 include/linux/bpf.h                                |    1 +
 include/linux/net.h                                |    2 +-
 include/trace/events/xdp.h                         |   12 +-
 include/uapi/linux/bpf.h                           |    9 +
 kernel/bpf/hashtab.c                               |    6 +-
 kernel/bpf/syscall.c                               |    5 +-
 kernel/bpf/verifier.c                              |    3 +-
 kernel/trace/bpf_trace.c                           |    2 +
 net/core/bpf_sk_storage.c                          |    1 +
 net/core/filter.c                                  |   18 +
 net/core/netclassid_cgroup.c                       |    3 +-
 net/core/netprio_cgroup.c                          |    3 +-
 net/core/sock.c                                    |    8 +-
 net/socket.c                                       |   27 +-
 net/xdp/xsk.c                                      |    4 +-
 samples/bpf/xdpsock_user.c                         |    2 +
 scripts/bpf_helpers_doc.py                         |    4 +
 tools/include/uapi/linux/bpf.h                     |    9 +
 tools/lib/bpf/libbpf.c                             |   64 +-
 tools/lib/bpf/libbpf.h                             |    1 +
 tools/lib/bpf/libbpf.map                           |    1 +
 tools/lib/bpf/ringbuf.c                            |    6 +
 tools/testing/selftests/bpf/.gitignore             |    1 +
 tools/testing/selftests/bpf/Makefile               |   52 +-
 tools/testing/selftests/bpf/ima_setup.sh           |   24 +
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |  118 +++
 .../selftests/bpf/prog_tests/module_attach.c       |   11 +-
 .../bpf/progs/bpf_iter_bpf_sk_storage_helpers.c    |   65 ++
 tools/testing/selftests/bpf/progs/bpf_iter_task.c  |    3 +-
 .../selftests/bpf/progs/test_core_reloc_module.c   |    8 +
 .../selftests/bpf/progs/test_module_attach.c       |   11 +
 tools/testing/selftests/bpf/test_progs.c           |   10 +
 tools/testing/selftests/bpf/test_verifier.c        |   31 +-
 tools/testing/selftests/bpf/test_xsk.sh            |  259 +++++
 tools/testing/selftests/bpf/verifier/unpriv.c      |    5 +-
 tools/testing/selftests/bpf/xdpxceiver.c           | 1074 ++++++++++++++++++++
 tools/testing/selftests/bpf/xdpxceiver.h           |  160 +++
 tools/testing/selftests/bpf/xsk_prereqs.sh         |  135 +++
 40 files changed, 2063 insertions(+), 114 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
 create mode 100755 tools/testing/selftests/bpf/test_xsk.sh
 create mode 100644 tools/testing/selftests/bpf/xdpxceiver.c
 create mode 100644 tools/testing/selftests/bpf/xdpxceiver.h
 create mode 100755 tools/testing/selftests/bpf/xsk_prereqs.sh
