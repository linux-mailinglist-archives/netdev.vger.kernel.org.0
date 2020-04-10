Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 280131A3D5D
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 02:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgDJAaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 20:30:00 -0400
Received: from www62.your-server.de ([213.133.104.62]:56282 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbgDJAaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 20:30:00 -0400
Received: from 98.186.195.178.dynamic.wline.res.cust.swisscom.ch ([178.195.186.98] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jMhYJ-0004xl-Lc; Fri, 10 Apr 2020 02:29:47 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2020-04-10
Date:   Fri, 10 Apr 2020 02:29:47 +0200
Message-Id: <20200410002947.30827-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25777/Thu Apr  9 13:52:18 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 13 non-merge commits during the last 7 day(s) which contain
a total of 13 files changed, 137 insertions(+), 43 deletions(-).

The main changes are:

1) JIT code emission fixes for riscv and arm32, from Luke Nelson and Xi Wang.

2) Disable vmlinux BTF info if GCC_PLUGIN_RANDSTRUCT is used, from Slava Bacherikov.

3) Fix oob write in AF_XDP when meta data is used, from Li RongQing.

4) Fix bpf_get_link_xdp_id() handling on single prog when flags are specified,
   from Andrey Ignatov.

5) Fix sk_assign() BPF helper for request sockets that can have sk_reuseport
   field uninitialized, from Joe Stringer.

6) Fix mprotect() test case for the BPF LSM, from KP Singh.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, Björn Töpel, Jann Horn, Jonathan 
Lemon, kbuild test robot, Kees Cook, KP Singh, Liu Yiding, Luke Nelson, 
Martin KaFai Lau, Toke Høiland-Jørgensen

----------------------------------------------------------------

The following changes since commit 21f64e72e7073199a6f8d7d8efe52cd814d7d665:

  net: stmmac: xgmac: Fix VLAN register handling (2020-04-02 07:04:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to bb9562cf5c67813034c96afb50bd21130a504441:

  arm, bpf: Fix bugs with ALU64 {RSH, ARSH} BPF_K shift by 0 (2020-04-09 01:05:53 +0200)

----------------------------------------------------------------
Andrey Ignatov (2):
      libbpf: Fix bpf_get_link_xdp_id flags handling
      selftests/bpf: Add test for bpf_get_link_xdp_id

Björn Töpel (1):
      riscv, bpf: Remove BPF JIT for nommu builds

Colin Ian King (1):
      bpf: Fix spelling mistake "arithmatic" -> "arithmetic" in test_verifier

Jakub Sitnicki (1):
      net, sk_msg: Don't use RCU_INIT_POINTER on sk_user_data

Jeremy Cline (1):
      libbpf: Initialize *nl_pid so gcc 10 is happy

Joe Stringer (1):
      bpf: Fix use of sk->sk_reuseport from sk_assign

KP Singh (1):
      bpf, lsm: Fix the file_mprotect LSM test.

Li RongQing (1):
      xsk: Fix out of boundary write in __xsk_rcv_memcpy

Luke Nelson (2):
      riscv, bpf: Fix offset range checking for auipc+jalr on RV64
      arm, bpf: Fix bugs with ALU64 {RSH, ARSH} BPF_K shift by 0

Qiujun Huang (1):
      bpf: Fix a typo "inacitve" -> "inactive"

Slava Bacherikov (1):
      kbuild, btf: Fix dependencies for DEBUG_INFO_BTF

 arch/arm/net/bpf_jit_32.c                         | 12 +++-
 arch/riscv/Kconfig                                |  2 +-
 arch/riscv/net/bpf_jit_comp64.c                   | 49 ++++++++++------
 kernel/bpf/bpf_lru_list.h                         |  2 +-
 lib/Kconfig.debug                                 |  2 +
 net/core/filter.c                                 |  2 +-
 net/core/sock.c                                   |  2 +-
 net/xdp/xsk.c                                     |  5 +-
 tools/lib/bpf/netlink.c                           |  6 +-
 tools/testing/selftests/bpf/prog_tests/test_lsm.c | 18 +++---
 tools/testing/selftests/bpf/prog_tests/xdp_info.c | 68 +++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/lsm.c           |  8 +--
 tools/testing/selftests/bpf/verifier/bounds.c     |  4 +-
 13 files changed, 137 insertions(+), 43 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_info.c
