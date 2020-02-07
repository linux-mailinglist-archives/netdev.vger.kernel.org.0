Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB2D156161
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 23:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgBGW4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 17:56:15 -0500
Received: from www62.your-server.de ([213.133.104.62]:60546 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727048AbgBGW4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 17:56:15 -0500
Received: from 192.42.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.42.192] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j0CXe-0002dv-DW; Fri, 07 Feb 2020 23:56:06 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2020-02-07
Date:   Fri,  7 Feb 2020 23:56:05 +0100
Message-Id: <20200207225605.19411-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25717/Fri Feb  7 12:45:15 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 15 non-merge commits during the last 10 day(s) which contain
a total of 12 files changed, 114 insertions(+), 31 deletions(-).

The main changes are:

1) Various BPF sockmap fixes related to RCU handling in the map's tear-
   down code, from Jakub Sitnicki.

2) Fix macro state explosion in BPF sk_storage map when calculating its
   bucket_log on allocation, from Martin KaFai Lau.

3) Fix potential BPF sockmap update race by rechecking socket's established
   state under lock, from Lorenz Bauer.

4) Fix crash in bpftool on missing xlated instructions when kptr_restrict
   sysctl is set, from Toke Høiland-Jørgensen.

5) Fix i40e's XSK wakeup code to return proper error in busy state and
   various misc fixes in xdpsock BPF sample code, from Maciej Fijalkowski.

6) Fix the way modifiers are skipped in BTF in the verifier while walking
   pointers to avoid program rejection, from Alexei Starovoitov.

7) Fix Makefile for runqslower BPF tool to i) rebuild on libbpf changes and
   ii) to fix undefined reference linker errors for older gcc version due to
   order of passed gcc parameters, from Yulia Kartseva and Song Liu.

8) Fix a trampoline_count BPF kselftest warning about missing braces around
   initializer, from Andrii Nakryiko.

9) Fix up redundant "HAVE" prefix from large INSN limit kernel probe in
   bpftool, from Michal Rostecki.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, Björn Töpel, Cameron Elliott, Jakub 
Sitnicki, John Fastabend, Luc Van Oostenryck, Quentin Monnet, Randy 
Dunlap, Yonghong Song

----------------------------------------------------------------

The following changes since commit 44efc78d0e464ce70b45b165c005f8bedc17952e:

  net: mvneta: fix XDP support if sw bm is used as fallback (2020-01-29 13:57:59 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 88d6f130e5632bbf419a2e184ec7adcbe241260b:

  bpf: Improve bucket_log calculation logic (2020-02-07 23:01:41 +0100)

----------------------------------------------------------------
Alexei Starovoitov (1):
      bpf: Fix modifier skipping logic

Andrii Nakryiko (1):
      selftests/bpf: Fix trampoline_count.c selftest compilation warning

Daniel Borkmann (1):
      Merge branch 'bpf-xsk-fixes'

Jakub Sitnicki (3):
      bpf, sockmap: Don't sleep while holding RCU lock on tear-down
      bpf, sockhash: Synchronize_rcu before free'ing map
      selftests/bpf: Test freeing sockmap/sockhash with a socket in it

Lorenz Bauer (1):
      bpf, sockmap: Check update requirements after locking

Maciej Fijalkowski (3):
      i40e: Relax i40e_xsk_wakeup's return value when PF is busy
      samples: bpf: Drop doubled variable declaration in xdpsock
      samples: bpf: Allow for -ENETDOWN in xdpsock

Martin KaFai Lau (2):
      bpf: Reuse log from btf_prase_vmlinux() in btf_struct_ops_init()
      bpf: Improve bucket_log calculation logic

Michal Rostecki (1):
      bpftool: Remove redundant "HAVE" prefix from the large INSN limit check

Song Liu (1):
      tools/bpf/runqslower: Rebuild libbpf.a on libbpf source change

Toke Høiland-Jørgensen (1):
      bpftool: Don't crash on missing xlated program instructions

Yulia Kartseva (1):
      runqslower: Fix Makefile

 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |  2 +-
 include/linux/bpf.h                                |  7 +-
 kernel/bpf/bpf_struct_ops.c                        |  5 +-
 kernel/bpf/btf.c                                   | 10 ++-
 net/core/bpf_sk_storage.c                          |  5 +-
 net/core/sock_map.c                                | 28 +++++---
 samples/bpf/xdpsock_user.c                         |  4 +-
 tools/bpf/bpftool/feature.c                        |  2 +-
 tools/bpf/bpftool/prog.c                           |  2 +-
 tools/bpf/runqslower/Makefile                      |  4 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c       | 74 ++++++++++++++++++++++
 .../selftests/bpf/prog_tests/trampoline_count.c    |  2 +-
 12 files changed, 114 insertions(+), 31 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
