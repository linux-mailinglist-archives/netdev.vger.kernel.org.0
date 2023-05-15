Return-Path: <netdev+bounces-2811-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6533570412F
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 00:56:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B2D42812EF
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 22:56:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2117119E52;
	Mon, 15 May 2023 22:56:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDFC2FB2;
	Mon, 15 May 2023 22:56:09 +0000 (UTC)
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3220BD851;
	Mon, 15 May 2023 15:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:MIME-Version:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References;
	bh=IzcVsn39gsKNVZSgpgOHcIuFnJ6qu33LSrpO0SQTIo0=; b=LMo13zJnUonYoBcusvmCrI0UaF
	YrsUT/nVvkrC1mES2wXjOiM4ZH0bY7MiRHYrYdPsf0apejYh2spMXvMRTxzTu/ZJty2WVQ0mzo+wv
	eGyMtjY2v3u55Phr0SqGREn8OZM3Xm19WAWbh33Z826hu3lwpz9enuWFCqOk+25vOqDEHwI//Tc8L
	TI1oW93Zm4Ogcm5ZJNLtunqoAZnI5d8PMstaEYBUGQnsj2Cldz/AzY9t1I8Dfc175GFruL0j+LwfU
	87yFFMVKgBMTvoOWaarG38k1lM4DuzbIYmDg7Kl9/TLByJWoRrYhStfKBzWdkl4MAgxRjaXBGsSR4
	ORivL7og==;
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1pyh6q-000KeJ-Ql; Tue, 16 May 2023 00:56:04 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
To: davem@davemloft.net
Cc: kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	daniel@iogearbox.net,
	ast@kernel.org,
	andrii@kernel.org,
	martin.lau@linux.dev,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org
Subject: pull-request: bpf-next 2023-05-16
Date: Tue, 16 May 2023 00:56:03 +0200
Message-Id: <20230515225603.27027-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26907/Mon May 15 09:25:12 2023)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 57 non-merge commits during the last 19 day(s) which contain
a total of 63 files changed, 3293 insertions(+), 690 deletions(-).

The main changes are:

1) Add precision propagation to verifier for subprogs and callbacks, from Andrii Nakryiko.

2) Improve BPF's {g,s}setsockopt() handling with wrong option lengths, from Stanislav Fomichev.

3) Utilize pahole v1.25 for the kernel's BTF generation to filter out inconsistent
   function prototypes, from Alan Maguire.

4) Various dyn-pointer verifier improvements to relax restrictions, from Daniel Rosenberg.

5) Add a new bpf_task_under_cgroup() kfunc for designated task, from Feng Zhou.

6) Unblock tests for arm64 BPF CI after ftrace supporting direct call, from Florent Revest.

7) Add XDP hint kfunc metadata for RX hash/timestamp for igc, from Jesper Dangaard Brouer.

8) Add several new dyn-pointer kfuncs to ease their usability, from Joanne Koong.

9) Add in-depth LRU internals description and dot function graph, from Joe Stringer.

10) Fix KCSAN report on bpf_lru_list when accessing node->ref, from Martin KaFai Lau.

11) Only dump unprivileged_bpf_disabled log warning upon write, from Kui-Feng Lee.

12) Extend test_progs to directly passing allow/denylist file, from Stephen Veiss.

13) Fix BPF trampoline memleak upon failure attaching to fentry, from Yafang Shao.

14) Fix emitting struct bpf_tcp_sock type in vmlinux BTF, from Yonghong Song.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, Bagas Sanjaya, Jiri Olsa, John 
Fastabend, Lennart Poettering, Magnus Karlsson, Manu Bretelle, Nicky 
Veitch, Quentin Monnet, Song Liu, Song Yoong Siang, Stanislav Fomichev, 
Xuan Zhuo, Xu Kuohai, Yonghong Song

----------------------------------------------------------------

The following changes since commit 6e98b09da931a00bf4e0477d0fa52748bf28fcce:

  Merge tag 'net-next-6.4' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2023-04-26 16:07:23 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

for you to fetch changes up to 108598c39eefbedc9882273ac0df96127a629220:

  bpf: Fix memleak due to fentry attach failure (2023-05-15 23:41:59 +0200)

----------------------------------------------------------------
bpf-next-for-netdev

----------------------------------------------------------------
Alan Maguire (2):
      bpf: Add --skip_encoding_btf_inconsistent_proto, --btf_gen_optimized to pahole flags for v1.25
      bpftool: JIT limited misreported as negative value on aarch64

Alexei Starovoitov (3):
      Merge branch 'Add precision propagation for subprogs and callbacks'
      Merge branch 'Introduce a new kfunc of bpf_task_under_cgroup'
      Merge branch 'Dynptr Verifier Adjustments'

Andrii Nakryiko (13):
      Merge branch 'selftests/bpf: test_progs can read test lists from file'
      veristat: add -t flag for adding BPF_F_TEST_STATE_FREQ program flag
      bpf: mark relevant stack slots scratched for register read instructions
      bpf: encapsulate precision backtracking bookkeeping
      bpf: improve precision backtrack logging
      bpf: maintain bitmasks across all active frames in __mark_chain_precision
      bpf: fix propagate_precision() logic for inner frames
      bpf: fix mark_all_scalars_precise use in mark_chain_precision
      bpf: support precision propagation in the presence of subprogs
      selftests/bpf: add precision propagation tests in the presence of subprogs
      selftests/bpf: revert iter test subprog precision workaround
      libbpf: fix offsetof() and container_of() to work with CO-RE
      bpf: fix calculation of subseq_idx during precision backtracking

Daniel Borkmann (1):
      selftests/bpf: Add test case to assert precise scalar path pruning

Daniel Rosenberg (5):
      bpf: Allow NULL buffers in bpf_dynptr_slice(_rw)
      selftests/bpf: Test allowing NULL buffer in dynptr slice
      selftests/bpf: Check overflow in optional buffer
      bpf: verifier: Accept dynptr mem as mem in helpers
      selftests/bpf: Accept mem from dynptr in helper funcs

Dave Marchevsky (1):
      bpf: Remove anonymous union in bpf_kfunc_call_arg_meta

Feng Zhou (2):
      bpf: Add bpf_task_under_cgroup() kfunc
      selftests/bpf: Add testcase for bpf_task_under_cgroup

Florent Revest (2):
      selftests/bpf: Update the aarch64 tests deny list
      bpf, arm64: Support struct arguments in the BPF trampoline

Jesper Dangaard Brouer (5):
      igc: Enable and fix RX hash usage by netstack
      igc: Add igc_xdp_buff wrapper for xdp_buff in driver
      igc: Add XDP hints kfuncs for RX hash
      igc: Add XDP hints kfuncs for RX timestamp
      selftests/bpf: xdp_hw_metadata track more timestamps

Joanne Koong (5):
      bpf: Add bpf_dynptr_adjust
      bpf: Add bpf_dynptr_is_null and bpf_dynptr_is_rdonly
      bpf: Add bpf_dynptr_size
      bpf: Add bpf_dynptr_clone
      selftests/bpf: Add tests for dynptr convenience helpers

Joe Stringer (2):
      docs/bpf: Add table to describe LRU properties
      docs/bpf: Add LRU internals description and graph

Kal Conley (1):
      xsk: Use pool->dma_pages to check for DMA

Kenjiro Nakayama (1):
      libbpf: Fix comment about arc and riscv arch in bpf_tracing.h

Kui-Feng Lee (2):
      bpftool: Show map IDs along with struct_ops links.
      bpf: Print a warning only if writing to unprivileged_bpf_disabled.

Martin KaFai Lau (4):
      selftests/bpf: Add fexit_sleep to DENYLIST.aarch64
      libbpf: btf_dump_type_data_check_overflow needs to consider BTF_MEMBER_BITFIELD_SIZE
      bpf: Address KCSAN report on bpf_lru_list
      Merge branch 'bpf: Don't EFAULT for {g,s}setsockopt with wrong optlen'

Pengcheng Yang (1):
      samples/bpf: Fix buffer overflow in tcp_basertt

Stanislav Fomichev (4):
      bpf: Don't EFAULT for {g,s}setsockopt with wrong optlen
      selftests/bpf: Update EFAULT {g,s}etsockopt selftests
      selftests/bpf: Correctly handle optlen > 4096
      bpf: Document EFAULT changes for sockopt

Stephen Veiss (2):
      selftests/bpf: Extract insert_test from parse_test_list
      selftests/bpf: Test_progs can read test lists from file

Will Hawkins (1):
      bpf, docs: Update llvm_relocs.rst with typo fixes

Xueming Feng (1):
      bpftool: Dump map id instead of value for map_of_maps types

Yafang Shao (2):
      bpf: Remove bpf trampoline selector
      bpf: Fix memleak due to fentry attach failure

Yonghong Song (2):
      selftests/bpf: Fix selftest test_global_funcs/global_func1 failure with latest clang
      bpf: Emit struct bpf_tcp_sock type in vmlinux BTF

 Documentation/bpf/kfuncs.rst                       |  23 +-
 Documentation/bpf/llvm_reloc.rst                   |  18 +-
 Documentation/bpf/map_hash.rst                     |  53 +-
 Documentation/bpf/map_lru_hash_update.dot          | 172 +++++
 Documentation/bpf/prog_cgroup_sockopt.rst          |  57 +-
 arch/arm64/net/bpf_jit_comp.c                      |  55 +-
 drivers/net/ethernet/intel/igc/igc.h               |  35 +
 drivers/net/ethernet/intel/igc/igc_main.c          | 116 ++-
 include/linux/bpf.h                                |   3 +-
 include/linux/bpf_verifier.h                       |  27 +-
 include/linux/skbuff.h                             |   2 +-
 include/net/xsk_buff_pool.h                        |   2 +-
 kernel/bpf/bpf_lru_list.c                          |  21 +-
 kernel/bpf/bpf_lru_list.h                          |   7 +-
 kernel/bpf/cgroup.c                                |  15 +
 kernel/bpf/helpers.c                               | 123 +++-
 kernel/bpf/syscall.c                               |   3 +-
 kernel/bpf/trampoline.c                            |  32 +-
 kernel/bpf/verifier.c                              | 787 ++++++++++++++++-----
 kernel/trace/bpf_trace.c                           |   4 +-
 net/core/filter.c                                  |   2 +
 net/xdp/xsk_buff_pool.c                            |   7 +-
 samples/bpf/tcp_basertt_kern.c                     |   2 +-
 scripts/pahole-flags.sh                            |   3 +
 tools/bpf/bpftool/feature.c                        |  24 +-
 tools/bpf/bpftool/link.c                           |  10 +-
 tools/bpf/bpftool/map.c                            |  12 +-
 tools/lib/bpf/bpf_helpers.h                        |  15 +-
 tools/lib/bpf/bpf_tracing.h                        |   3 +-
 tools/lib/bpf/btf_dump.c                           |  22 +-
 tools/testing/selftests/bpf/DENYLIST.aarch64       |  83 +--
 tools/testing/selftests/bpf/DENYLIST.s390x         |   1 +
 tools/testing/selftests/bpf/bpf_kfuncs.h           |   6 +
 .../testing/selftests/bpf/prog_tests/arg_parsing.c |  68 ++
 .../bpf/prog_tests/cgroup_getset_retval.c          |  20 +
 tools/testing/selftests/bpf/prog_tests/dynptr.c    |   8 +
 tools/testing/selftests/bpf/prog_tests/sockopt.c   |  96 ++-
 .../selftests/bpf/prog_tests/sockopt_inherit.c     |  59 +-
 .../selftests/bpf/prog_tests/sockopt_multi.c       | 108 +--
 .../selftests/bpf/prog_tests/sockopt_qos_to_cc.c   |   2 +
 .../selftests/bpf/prog_tests/task_under_cgroup.c   |  53 ++
 tools/testing/selftests/bpf/prog_tests/verifier.c  |   2 +
 tools/testing/selftests/bpf/progs/bpf_misc.h       |   4 +
 .../bpf/progs/cgroup_getset_retval_getsockopt.c    |  13 +
 .../bpf/progs/cgroup_getset_retval_setsockopt.c    |  17 +
 tools/testing/selftests/bpf/progs/dynptr_fail.c    | 307 ++++++++
 tools/testing/selftests/bpf/progs/dynptr_success.c | 336 +++++++++
 tools/testing/selftests/bpf/progs/iters.c          |  26 +-
 .../testing/selftests/bpf/progs/sockopt_inherit.c  |  18 +-
 tools/testing/selftests/bpf/progs/sockopt_multi.c  |  26 +-
 .../selftests/bpf/progs/sockopt_qos_to_cc.c        |  10 +-
 tools/testing/selftests/bpf/progs/sockopt_sk.c     |  25 +-
 .../selftests/bpf/progs/test_global_func1.c        |   2 +
 .../selftests/bpf/progs/test_task_under_cgroup.c   |  51 ++
 .../bpf/progs/verifier_subprog_precision.c         | 536 ++++++++++++++
 .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |   4 +-
 tools/testing/selftests/bpf/test_progs.c           |  37 +-
 tools/testing/selftests/bpf/testing_helpers.c      | 207 ++++--
 tools/testing/selftests/bpf/testing_helpers.h      |   3 +
 tools/testing/selftests/bpf/verifier/precise.c     | 143 ++--
 tools/testing/selftests/bpf/veristat.c             |   9 +
 tools/testing/selftests/bpf/xdp_hw_metadata.c      |  47 +-
 tools/testing/selftests/bpf/xdp_metadata.h         |   1 +
 63 files changed, 3293 insertions(+), 690 deletions(-)
 create mode 100644 Documentation/bpf/map_lru_hash_update.dot
 create mode 100644 tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_task_under_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_subprog_precision.c

