Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765F13C2B45
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 00:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbhGIWTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 18:19:36 -0400
Received: from www62.your-server.de ([213.133.104.62]:33938 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhGIWTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 18:19:35 -0400
Received: from 65.47.5.85.dynamic.wline.res.cust.swisscom.ch ([85.5.47.65] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1m1ynh-000BAR-Ey; Sat, 10 Jul 2021 00:16:49 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf 2021-07-09
Date:   Sat, 10 Jul 2021 00:16:49 +0200
Message-Id: <20210709221649.30124-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26226/Fri Jul  9 13:16:15 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 9 non-merge commits during the last 9 day(s) which contain
a total of 13 files changed, 118 insertions(+), 62 deletions(-).

The main changes are:

1) Fix runqslower task->state access from BPF, from SanjayKumar Jeyakumar.

2) Fix subprog poke descriptor tracking use-after-free, from John Fastabend.

3) Fix sparse complaint from prior devmap RCU conversion, from Toke Høiland-Jørgensen.

4) Fix missing va_end in bpftool JIT json dump's error path, from Gu Shengxian.

5) Fix tools/bpf install target from missing runqslower install, from Wei Li.

6) Fix xdpsock BPF sample to unload program on shared umem option, from Wang Hai.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

kernel test robot, Magnus Karlsson, Martin KaFai Lau, Paul E. McKenney, 
Yonghong Song

----------------------------------------------------------------

The following changes since commit dbe69e43372212527abf48609aba7fc39a6daa27:

  Merge tag 'net-next-5.14' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2021-06-30 15:51:09 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 1fb5ba29ad0835c5cbfc69a27f9c2733cb65726e:

  bpf: Selftest to verify mixing bpf2bpf calls and tailcalls with insn patch (2021-07-09 12:08:40 +0200)

----------------------------------------------------------------
Gu Shengxian (1):
      bpftool: Properly close va_list 'ap' by va_end() on error

John Fastabend (2):
      bpf: Track subprog poke descriptors correctly and fix use-after-free
      bpf: Selftest to verify mixing bpf2bpf calls and tailcalls with insn patch

SanjayKumar Jeyakumar (1):
      tools/runqslower: Use __state instead of state

Toke Høiland-Jørgensen (3):
      bpf, devmap: Convert remaining READ_ONCE() to rcu_dereference_check()
      bpf, samples: Add -fno-asynchronous-unwind-tables to BPF Clang invocation
      libbpf: Restore errno return for functions that were already returning it

Wang Hai (1):
      bpf, samples: Fix xdpsock with '-M' parameter missing unload process

Wei Li (1):
      tools: bpf: Fix error in 'make -C tools/ bpf_install'

 arch/x86/net/bpf_jit_comp.c                        |  3 ++
 include/linux/bpf.h                                |  1 +
 kernel/bpf/core.c                                  |  8 ++-
 kernel/bpf/devmap.c                                |  6 ++-
 kernel/bpf/verifier.c                              | 60 ++++++++--------------
 samples/bpf/Makefile                               |  1 +
 samples/bpf/xdpsock_user.c                         | 28 ++++++++++
 tools/bpf/Makefile                                 |  7 +--
 tools/bpf/bpftool/jit_disasm.c                     |  6 ++-
 tools/bpf/runqslower/runqslower.bpf.c              |  2 +-
 tools/lib/bpf/libbpf.c                             |  4 +-
 tools/testing/selftests/bpf/prog_tests/tailcalls.c | 36 +++++++++----
 .../selftests/bpf/progs/tailcall_bpf2bpf4.c        | 18 +++++++
 13 files changed, 118 insertions(+), 62 deletions(-)
