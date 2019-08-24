Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89D2A9B961
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 02:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfHXAMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 20:12:01 -0400
Received: from www62.your-server.de ([213.133.104.62]:59106 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfHXAMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 20:12:01 -0400
Received: from [178.197.249.40] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i1Jev-0003w1-QB; Sat, 24 Aug 2019 02:11:57 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     daniel@iogearbox.net, ast@kernel.org, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2019-08-24
Date:   Sat, 24 Aug 2019 02:11:57 +0200
Message-Id: <20190824001157.16043-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25550/Fri Aug 23 10:25:33 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

The main changes are:

1) Fix verifier precision tracking with BPF-to-BPF calls, from Alexei.

2) Fix a use-after-free in prog symbol exposure, from Daniel.

3) Several s390x JIT fixes plus BE related fixes in BPF kselftests, from Ilya.

4) Fix memory leak by unpinning XDP umem pages in error path, from Ivan.

5) Fix a potential use-after-free on flow dissector detach, from Jakub.

6) Fix bpftool to close prog fd after showing metadata, from Quentin.

7) BPF kselftest config and TEST_PROGS_EXTENDED fixes, from Anders.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

----------------------------------------------------------------

The following changes since commit 125b7e0949d4e72b15c2b1a1590f8cece985a918:

  net: tc35815: Explicitly check NET_IP_ALIGN is not zero in tc35815_rx (2019-08-11 21:41:48 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 2c238177bd7f4b14bdf7447cc1cd9bb791f147e6:

  bpf: allow narrow loads of some sk_reuseport_md fields with offset > 0 (2019-08-24 01:25:41 +0200)

----------------------------------------------------------------
Alexei Starovoitov (1):
      bpf: fix precision tracking in presence of bpf2bpf calls

Anders Roxell (2):
      selftests/bpf: add config fragment BPF_JIT
      selftests/bpf: install files test_xdp_vlan.sh

Daniel Borkmann (1):
      bpf: fix use after free in prog symbol exposure

Ilya Leoshkevich (6):
      s390/bpf: fix lcgr instruction encoding
      s390/bpf: use 32-bit index for tail calls
      selftests/bpf: fix "bind{4, 6} deny specific IP & port" on s390
      selftests/bpf: fix test_cgroup_storage on s390
      selftests/bpf: fix test_btf_dump with O=
      bpf: allow narrow loads of some sk_reuseport_md fields with offset > 0

Ivan Khoronzhuk (1):
      xdp: unpin xdp umem pages in error path

Jakub Sitnicki (1):
      flow_dissector: Fix potential use-after-free on BPF_PROG_DETACH

Quentin Monnet (1):
      tools: bpftool: close prog FD before exit on showing a single program

 arch/s390/net/bpf_jit_comp.c                      | 12 +++++----
 kernel/bpf/syscall.c                              | 30 ++++++++++++++---------
 kernel/bpf/verifier.c                             |  9 ++++---
 net/core/filter.c                                 |  8 +++---
 net/core/flow_dissector.c                         |  2 +-
 net/xdp/xdp_umem.c                                |  4 ++-
 tools/bpf/bpftool/prog.c                          |  4 ++-
 tools/testing/selftests/bpf/Makefile              |  6 ++++-
 tools/testing/selftests/bpf/config                |  1 +
 tools/testing/selftests/bpf/test_btf_dump.c       |  7 ++++++
 tools/testing/selftests/bpf/test_cgroup_storage.c |  6 ++---
 tools/testing/selftests/bpf/test_sock.c           |  7 ++++--
 12 files changed, 62 insertions(+), 34 deletions(-)
