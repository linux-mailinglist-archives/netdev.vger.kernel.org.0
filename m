Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2ABC390C57
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 00:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhEYWlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 18:41:13 -0400
Received: from www62.your-server.de ([213.133.104.62]:50492 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbhEYWlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 18:41:13 -0400
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1llfi7-0004lJ-Q7; Wed, 26 May 2021 00:39:39 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf 2021-05-26
Date:   Wed, 26 May 2021 00:39:39 +0200
Message-Id: <20210525223939.3537-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26181/Tue May 25 13:17:38 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 14 non-merge commits during the last 14 day(s) which contain
a total of 17 files changed, 513 insertions(+), 231 deletions(-).

The main changes are:

1) Fix bpf_skb_change_head() helper to reset mac_len, from Jussi Maki.

2) Fix masking direction swap upon off-reg sign change, from Daniel Borkmann.

3) Fix BPF offloads in verifier by reordering driver callback, from Yinjun Zhang.

4) BPF selftest for ringbuf mmap ro/rw restrictions, from Andrii Nakryiko.

5) Follow-up fixes to nested bprintf per-cpu buffers, from Florent Revest.

6) Fix bpftool sock_release attach point help info, from Liu Jian.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, kernel test robot, Piotr Krysiuk, Quentin Monnet, 
Randy Dunlap, Song Liu

----------------------------------------------------------------

The following changes since commit 440c3247cba3d9433ac435d371dd7927d68772a7:

  net: ipa: memory region array is variable size (2021-05-11 16:22:37 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 1bad6fd52be4ce12d207e2820ceb0f29ab31fc53:

  bpf, selftests: Adjust few selftest result_unpriv outcomes (2021-05-25 22:08:53 +0200)

----------------------------------------------------------------
Andrii Nakryiko (1):
      selftests/bpf: Test ringbuf mmap read-only and read-write restrictions

Daniel Borkmann (6):
      bpf: Fix BPF_JIT kconfig symbol dependency
      bpf: Fix BPF_LSM kconfig symbol dependency
      bpf: Wrap aux data inside bpf_sanitize_info container
      bpf: Fix mask direction swap upon off reg sign change
      bpf: No need to simulate speculative domain for immediates
      bpf, selftests: Adjust few selftest result_unpriv outcomes

Florent Revest (2):
      bpf: Clarify a bpf_bprintf_prepare macro
      bpf: Avoid using ARRAY_SIZE on an uninitialized pointer

Jussi Maki (2):
      bpf: Set mac_len in bpf_skb_change_head
      selftests/bpf: Add test for l3 use of bpf_redirect_peer

Liu Jian (1):
      bpftool: Add sock_release help info for cgroup attach/prog load command

Stanislav Fomichev (1):
      selftests/bpf: Convert static to global in tc_redirect progs

Yinjun Zhang (1):
      bpf, offload: Reorder offload callback 'prepare' in verifier

 arch/arm64/Kbuild                                  |   3 +-
 kernel/bpf/Kconfig                                 |   1 +
 kernel/bpf/bpf_lsm.c                               |   2 +
 kernel/bpf/helpers.c                               |  12 +-
 kernel/bpf/verifier.c                              |  58 ++-
 net/core/filter.c                                  |   1 +
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |   4 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |   2 +-
 tools/bpf/bpftool/bash-completion/bpftool          |   6 +-
 tools/bpf/bpftool/cgroup.c                         |   3 +-
 tools/bpf/bpftool/prog.c                           |   2 +-
 tools/testing/selftests/bpf/prog_tests/ringbuf.c   |  49 +-
 .../testing/selftests/bpf/prog_tests/tc_redirect.c | 552 ++++++++++++++-------
 tools/testing/selftests/bpf/progs/test_tc_neigh.c  |   4 +-
 tools/testing/selftests/bpf/progs/test_tc_peer.c   |  35 +-
 tools/testing/selftests/bpf/verifier/stack_ptr.c   |   2 -
 .../selftests/bpf/verifier/value_ptr_arith.c       |   8 -
 17 files changed, 513 insertions(+), 231 deletions(-)
