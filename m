Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C413E5A99
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241059AbhHJNBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:01:08 -0400
Received: from www62.your-server.de ([213.133.104.62]:40162 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237490AbhHJNBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 09:01:04 -0400
Received: from 65.47.5.85.dynamic.wline.res.cust.swisscom.ch ([85.5.47.65] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mDRN1-0009eP-Bd; Tue, 10 Aug 2021 15:00:39 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2021-08-10
Date:   Tue, 10 Aug 2021 15:00:38 +0200
Message-Id: <20210810130038.16927-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26259/Tue Aug 10 10:19:56 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 31 non-merge commits during the last 8 day(s) which contain
a total of 28 files changed, 3644 insertions(+), 519 deletions(-).

The main changes are:

1) Native XDP support for bonding driver & related BPF selftests, from Jussi Maki.

2) Large batch of new BPF JIT tests for test_bpf.ko that came out as a result from
   32-bit MIPS JIT development, from Johan Almbladh.

3) Rewrite of netcnt BPF selftest and merge into test_progs, from Stanislav Fomichev.

4) Fix XDP bpf_prog_test_run infra after net to net-next merge, from Andrii Nakryiko.

5) Follow-up fix in unix_bpf_update_proto() to enforce socket type, from Cong Wang.

6) Fix bpf-iter-tcp4 selftest to print the correct dest IP, from Jose Blanquicet.

7) Various misc BPF XDP sample improvements, from Niklas Söderlund, Matthew Cover,
   and Muhammad Falak R Wani.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Daniel Borkmann, Jakub Sitnicki, Louis Peens, Yonghong 
Song

----------------------------------------------------------------

The following changes since commit 7cdd0a89ec70ce6a720171f1f7817ee9502b134c:

  net/mlx4: make the array states static const, makes object smaller (2021-08-02 15:02:13 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 874be05f525e87768daf0f47b494dc83b9537243:

  bpf, tests: Add tail call test suite (2021-08-10 11:33:37 +0200)

----------------------------------------------------------------
Andrii Nakryiko (3):
      bpf: Fix bpf_prog_test_run_xdp logic after incorrect merge resolution
      selftests/bpf: Rename reference_tracking BPF programs
      Merge branch 'samples/bpf: xdpsock: Minor enhancements'

Cong Wang (1):
      bpf, unix: Check socket type in unix_bpf_update_proto()

Johan Almbladh (15):
      bpf: Fix off-by-one in tail call count limiting
      bpf, tests: Add BPF_JMP32 test cases
      bpf, tests: Add BPF_MOV tests for zero and sign extension
      bpf, tests: Fix typos in test case descriptions
      bpf, tests: Add more tests of ALU32 and ALU64 bitwise operations
      bpf, tests: Add more ALU32 tests for BPF_LSH/RSH/ARSH
      bpf, tests: Add more BPF_LSH/RSH/ARSH tests for ALU64
      bpf, tests: Add more ALU64 BPF_MUL tests
      bpf, tests: Add tests for ALU operations implemented with function calls
      bpf, tests: Add word-order tests for load/store of double words
      bpf, tests: Add branch conversion JIT test
      bpf, tests: Add test for 32-bit context pointer argument passing
      bpf, tests: Add tests for atomic operations
      bpf, tests: Add tests for BPF_CMPXCHG
      bpf, tests: Add tail call test suite

Jose Blanquicet (1):
      selftests/bpf: Fix bpf-iter-tcp4 test to print correctly the dest IP

Jussi Maki (7):
      net, bonding: Refactor bond_xmit_hash for use with xdp_buff
      net, core: Add support for XDP redirection to slave device
      net, bonding: Add XDP support to the bonding driver
      bpf, devmap: Exclude XDP broadcast to master device
      net, core: Allow netdev_lower_get_next_private_rcu in bh context
      selftests/bpf: Fix xdp_tx.c prog section name
      selftests/bpf: Add tests for XDP bonding

Matthew Cover (1):
      bpf, samples: Add missing mprog-disable to xdp_redirect_cpu's optstring

Muhammad Falak R Wani (1):
      samples, bpf: Add an explict comment to handle nested vlan tagging.

Niklas Söderlund (2):
      samples/bpf: xdpsock: Make the sample more useful outside the tree
      samples/bpf: xdpsock: Remove forward declaration of ip_fast_csum()

Stanislav Fomichev (1):
      selftests/bpf: Move netcnt test under test_progs

 drivers/net/bonding/bond_main.c                    |  454 +++-
 include/linux/filter.h                             |   13 +-
 include/linux/netdevice.h                          |    6 +
 include/net/bonding.h                              |    1 +
 kernel/bpf/core.c                                  |    2 +-
 kernel/bpf/devmap.c                                |   69 +-
 lib/test_bpf.c                                     | 2743 ++++++++++++++++++--
 net/bpf/test_run.c                                 |    3 +-
 net/core/dev.c                                     |   15 +-
 net/core/filter.c                                  |   25 +
 net/unix/unix_bpf.c                                |    3 +
 samples/bpf/xdp1_kern.c                            |    2 +
 samples/bpf/xdp2_kern.c                            |    2 +
 samples/bpf/xdp_redirect_cpu_user.c                |    2 +-
 samples/bpf/xdpsock_user.c                         |   20 +-
 tools/testing/selftests/bpf/.gitignore             |    1 -
 tools/testing/selftests/bpf/Makefile               |    3 +-
 tools/testing/selftests/bpf/network_helpers.c      |   12 +
 tools/testing/selftests/bpf/network_helpers.h      |    1 +
 tools/testing/selftests/bpf/prog_tests/netcnt.c    |   82 +
 .../selftests/bpf/prog_tests/reference_tracking.c  |    4 +-
 .../testing/selftests/bpf/prog_tests/tc_redirect.c |   12 -
 .../testing/selftests/bpf/prog_tests/xdp_bonding.c |  520 ++++
 tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c  |    2 +-
 .../selftests/bpf/progs/test_sk_lookup_kern.c      |   14 +-
 tools/testing/selftests/bpf/progs/xdp_tx.c         |    2 +-
 tools/testing/selftests/bpf/test_netcnt.c          |  148 --
 tools/testing/selftests/bpf/test_xdp_veth.sh       |    2 +-
 28 files changed, 3644 insertions(+), 519 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/netcnt.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
 delete mode 100644 tools/testing/selftests/bpf/test_netcnt.c
