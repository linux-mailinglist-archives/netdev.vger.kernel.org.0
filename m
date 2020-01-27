Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD2D514A482
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgA0NGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:06:30 -0500
Received: from www62.your-server.de ([213.133.104.62]:38164 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728843AbgA0NG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:06:27 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iw45r-0003XN-FD; Mon, 27 Jan 2020 14:06:19 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     jakub.kicinski@netronome.com, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2020-01-27
Date:   Mon, 27 Jan 2020 14:06:18 +0100
Message-Id: <20200127130618.24926-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25708/Mon Jan 27 12:37:29 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 20 non-merge commits during the last 5 day(s) which contain
a total of 24 files changed, 433 insertions(+), 104 deletions(-).

The main changes are:

1) Make BPF trampolines and dispatcher aware for the stack unwinder, from Jiri Olsa.

2) Improve handling of failed CO-RE relocations in libbpf, from Andrii Nakryiko.

3) Several fixes to BPF sockmap and reuseport selftests, from Lorenz Bauer.

4) Various cleanups in BPF devmap's XDP flush code, from John Fastabend.

5) Fix BPF flow dissector when used with port ranges, from Yoshiki Komachi.

6) Fix bpffs' map_seq_next callback to always inc position index, from Vasily Averin.

7) Allow overriding LLVM tooling for runqslower utility, from Andrey Ignatov.

8) Silence false-positive lockdep splats in devmap hash lookup, from Amol Grover.

9) Fix fentry/fexit selftests to initialize a variable before use, from John Sperbeck.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Björn Töpel, Jakub Sitnicki, Jesper Dangaard Brouer, 
John Fastabend, Martin KaFai Lau, Petar Penkov, Song Liu, Toke 
Høiland-Jørgensen, William Smith, Yonghong Song

----------------------------------------------------------------

The following changes since commit fd786fb1d2cad70b9aaba8c73872cbf63262bd58:

  net: convert suitable drivers to use phy_do_ioctl_running (2020-01-23 10:49:30 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 82650dab9a5a2928c8d982cce5e3c687f14f8716:

  Merge branch 'bpf-flow-dissector-fix-port-ranges' (2020-01-27 11:25:12 +0100)

----------------------------------------------------------------
Alexei Starovoitov (1):
      Merge branch 'trampoline-fixes'

Amol Grover (1):
      bpf, devmap: Pass lockdep expression to RCU lists

Andrey Ignatov (1):
      tools/bpf: Allow overriding llvm tools for runqslower

Andrii Nakryiko (4):
      selftests/bpf: Improve bpftool changes detection
      bpftool: Print function linkage in BTF dump
      libbpf: Improve handling of failed CO-RE relocations
      libbpf: Fix realloc usage in bpf_core_find_cands

Daniel Borkmann (1):
      Merge branch 'bpf-flow-dissector-fix-port-ranges'

Jiri Olsa (3):
      bpf: Allow BTF ctx access for string pointers
      bpf: Allow to resolve bpf trampoline and dispatcher in unwind
      selftest/bpf: Add test for allowed trampolines count

John Fastabend (3):
      bpf, xdp: Update devmap comments to reflect napi/rcu usage
      bpf, xdp: virtio_net use access ptr macro for xdp enable check
      bpf, xdp: Remove no longer required rcu_read_{un}lock()

John Sperbeck (1):
      selftests/bpf: Initialize duration variable before using

Lorenz Bauer (4):
      selftests: bpf: Use a temporary file in test_sockmap
      selftests: bpf: Ignore FIN packets for reuseport tests
      selftests: bpf: Make reuseport test output more legible
      selftests: bpf: Reset global state between reuseport test runs

Vasily Averin (1):
      bpf: map_seq_next should always increase position index

Yoshiki Komachi (2):
      flow_dissector: Fix to use new variables for port ranges in bpf hook
      selftests/bpf: Add test based on port range for BPF flow dissector

 drivers/net/veth.c                                 |   6 +-
 drivers/net/virtio_net.c                           |   2 +-
 include/linux/bpf.h                                |  12 ++-
 kernel/bpf/btf.c                                   |  16 +++
 kernel/bpf/devmap.c                                |  29 +++---
 kernel/bpf/dispatcher.c                            |   4 +-
 kernel/bpf/inode.c                                 |   3 +-
 kernel/bpf/trampoline.c                            |  80 +++++++++++++--
 kernel/extable.c                                   |   7 +-
 net/core/flow_dissector.c                          |  11 +-
 tools/bpf/bpftool/btf.c                            |  27 ++++-
 tools/bpf/runqslower/Makefile                      |   6 +-
 tools/lib/bpf/libbpf.c                             |  99 ++++++++++--------
 tools/lib/bpf/libbpf.h                             |   6 +-
 tools/testing/selftests/bpf/Makefile               |  11 +-
 .../testing/selftests/bpf/prog_tests/fentry_test.c |   2 +-
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |   2 +-
 .../testing/selftests/bpf/prog_tests/fexit_test.c  |   2 +-
 .../selftests/bpf/prog_tests/select_reuseport.c    |  44 ++++++--
 .../selftests/bpf/prog_tests/trampoline_count.c    | 112 +++++++++++++++++++++
 .../bpf/progs/test_select_reuseport_kern.c         |   6 ++
 .../selftests/bpf/progs/test_trampoline_count.c    |  21 ++++
 tools/testing/selftests/bpf/test_flow_dissector.sh |  14 +++
 tools/testing/selftests/bpf/test_sockmap.c         |  15 +--
 24 files changed, 433 insertions(+), 104 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trampoline_count.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trampoline_count.c
