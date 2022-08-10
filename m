Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393F858F2B8
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 21:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbiHJTGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 15:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbiHJTG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 15:06:28 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECF91056A;
        Wed, 10 Aug 2022 12:06:27 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1oLr28-000D8B-Vy; Wed, 10 Aug 2022 21:06:25 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2022-08-10
Date:   Wed, 10 Aug 2022 21:06:24 +0200
Message-Id: <20220810190624.10748-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26623/Wed Aug 10 09:55:07 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net* tree.

We've added 23 non-merge commits during the last 7 day(s) which contain
a total of 19 files changed, 424 insertions(+), 35 deletions(-).

The main changes are:

1) Several fixes for BPF map iterator such as UAFs along with selftests, from Hou Tao.

2) Fix BPF syscall program's {copy,strncpy}_from_bpfptr() to not fault, from Jinghao Jia.

3) Reject BPF syscall programs calling BPF_PROG_RUN, from Alexei Starovoitov and YiFei Zhu.

4) Fix attach_btf_obj_id info to pick proper target BTF, from Stanislav Fomichev.

5) BPF design Q/A doc update to clarify what is not stable ABI, from Paul E. McKenney.

6) Fix BPF map's prealloc_lru_pop to not reinitialize, from Kumar Kartikeya Dwivedi.

7) Fix bpf_trampoline_put to avoid leaking ftrace hash, from Jiri Olsa.

8) Fix arm64 JIT to address sparse errors around BPF trampoline, from Xu Kuohai.

9) Fix arm64 JIT to use kvcalloc instead of kcalloc for internal program address
   offset buffer, from Aijun Sun.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Hao Luo, Jean-Philippe Brucker, kernel test robot, Martin KaFai Lau, Mat 
Martineau, Song Liu, YiFei Zhu, Yonghong Song

----------------------------------------------------------------

The following changes since commit 4ae97cae07e15d41e5c0ebabba64c6eefdeb0bbe:

  nfp: ethtool: fix the display error of `ethtool -m DEVNAME` (2022-08-03 19:20:54 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to e7c677bdd03d54e9a1bafcaf1faf5c573a506bba:

  Merge branch 'fixes for bpf map iterator' (2022-08-10 10:12:49 -0700)

----------------------------------------------------------------
Aijun Sun (1):
      bpf, arm64: Allocate program buffer using kvcalloc instead of kcalloc

Alexei Starovoitov (3):
      Merge branch 'Don't reinit map value in prealloc_lru_pop'
      bpf: Disallow bpf programs call prog_run command.
      Merge branch 'fixes for bpf map iterator'

Hou Tao (9):
      bpf: Acquire map uref in .init_seq_private for array map iterator
      bpf: Acquire map uref in .init_seq_private for hash map iterator
      bpf: Acquire map uref in .init_seq_private for sock local storage map iterator
      bpf: Acquire map uref in .init_seq_private for sock{map,hash} iterator
      bpf: Check the validity of max_rdwr_access for sock local storage map iterator
      bpf: Only allow sleepable program for resched-able iterator
      selftests/bpf: Add tests for reading a dangling map iter fd
      selftests/bpf: Add write tests for sk local storage map iterator
      selftests/bpf: Ensure sleepable program is rejected by hash map iter

Jinghao Jia (1):
      BPF: Fix potential bad pointer dereference in bpf_sys_bpf()

Jiri Olsa (2):
      bpf: Cleanup ftrace hash in bpf_trampoline_put
      mptcp, btf: Add struct mptcp_sock definition when CONFIG_MPTCP is disabled

Kumar Kartikeya Dwivedi (3):
      bpf: Allow calling bpf_prog_test kfuncs in tracing programs
      bpf: Don't reinit map value in prealloc_lru_pop
      selftests/bpf: Add test for prealloc_lru_pop bug

Paul E. McKenney (3):
      bpf: Update bpf_design_QA.rst to clarify that kprobes is not ABI
      bpf: Update bpf_design_QA.rst to clarify that attaching to functions is not ABI
      bpf: Update bpf_design_QA.rst to clarify that BTF_ID does not ABIify a function

Stanislav Fomichev (2):
      bpf: Use proper target btf when exporting attach_btf_obj_id
      selftests/bpf: Excercise bpf_obj_get_info_by_fd for bpf2bpf

Xu Kuohai (1):
      bpf, arm64: Fix bpf trampoline instruction endianness

 Documentation/bpf/bpf_design_QA.rst                |  25 +++++
 arch/arm64/net/bpf_jit_comp.c                      |  16 +--
 include/linux/bpfptr.h                             |   8 +-
 include/net/mptcp.h                                |   4 +
 kernel/bpf/arraymap.c                              |   6 ++
 kernel/bpf/bpf_iter.c                              |  11 +-
 kernel/bpf/hashtab.c                               |   8 +-
 kernel/bpf/syscall.c                               |  27 +++--
 kernel/bpf/trampoline.c                            |   5 +-
 net/bpf/test_run.c                                 |   1 +
 net/core/bpf_sk_storage.c                          |  12 ++-
 net/core/sock_map.c                                |  20 +++-
 tools/lib/bpf/skel_internal.h                      |   4 +-
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  | 116 ++++++++++++++++++++-
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |  95 +++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/lru_bug.c   |  21 ++++
 .../selftests/bpf/progs/bpf_iter_bpf_hash_map.c    |   9 ++
 .../bpf/progs/bpf_iter_bpf_sk_storage_map.c        |  22 +++-
 tools/testing/selftests/bpf/progs/lru_bug.c        |  49 +++++++++
 19 files changed, 424 insertions(+), 35 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/lru_bug.c
 create mode 100644 tools/testing/selftests/bpf/progs/lru_bug.c
