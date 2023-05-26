Return-Path: <netdev+bounces-5825-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 132A871300C
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 00:28:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCD972817B2
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 22:27:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BF312D244;
	Fri, 26 May 2023 22:27:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5A12911B;
	Fri, 26 May 2023 22:27:53 +0000 (UTC)
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0EA10A;
	Fri, 26 May 2023 15:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References;
	bh=OvrG82RRo0Haifq0l0+UiztHqJOoL4gKgDoEi/9LQE4=; b=K5u/oNt5kT/f19LTFd6KfnuN2g
	qQKK9ZiLKpE9GLFE2gTWvZarDCCS83TuV6pVjjaSVgSPAsX1nN8w9r4+ULVStQvb3UkFNKAE7/cxg
	o3j+CJehc56Pbb4o7tqzC8f6R2MWr122mNHSUDOylDLKk7jodh2MC+bs+t1jnIUPvySlfkiMScxz2
	1dw8mP3P/nEyCob5rGptiVtCBhPHaYZ9Z1JjEt6ZeD7u2NgpqdgM9Z5VzfDKYghFVuqOoen+odQM6
	+i8ctJd6rTqRK6mHl+CSmfs/eddO3M0ee4ksihuRv7cjecRWCRXDiKiWGnJw/NUlpJyPnm27ohYq6
	Ht3TBmOQ==;
Received: from 44.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.44] helo=localhost)
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1q2fuW-0002Cp-Cu; Sat, 27 May 2023 00:27:48 +0200
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
Subject: pull-request: bpf-next 2023-05-26
Date: Sat, 27 May 2023 00:27:47 +0200
Message-Id: <20230526222747.17775-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26919/Fri May 26 09:23:54 2023)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 54 non-merge commits during the last 10 day(s) which contain
a total of 76 files changed, 2729 insertions(+), 1003 deletions(-).

The main changes are:

1) Add the capability to destroy sockets in BPF through a new kfunc, from Aditi Ghag.

2) Support O_PATH fds in BPF_OBJ_PIN and BPF_OBJ_GET commands, from Andrii Nakryiko.

3) Add capability for libbpf to resize datasec maps when backed via mmap, from JP Kobryn.

4) Move all the test kfuncs for CI out of the kernel and into bpf_testmod, from Jiri Olsa.

5) Big batch of xsk selftest improvements to prep for multi-buffer testing, from Magnus Karlsson.

6) Show the target_{obj,btf}_id in tracing link's fdinfo and dump it via bpftool, from Yafang Shao.

7) Various misc BPF selftest improvements to work with upcoming LLVM 17, from Yonghong Song.

8) Extend bpftool to specify netdevice for resolving XDP hints, from Larysa Zaremba.

9) Document masking in shift operations for the insn set document, from Dave Thaler.

10) Extend BPF selftests to check xdp_feature support for bond driver, from Lorenzo Bianconi.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Christian Brauner, David Vernet, Ilya Leoshkevich, Jussi Maki, Quentin 
Monnet, Roberto Sassu, Song Liu, Stanislav Fomichev, Yonghong Song

----------------------------------------------------------------

The following changes since commit e7480a44d7c4ce4691fa6bcdb0318f0d81fe4b12:

  Revert "net: Remove low_thresh in ip defrag" (2023-05-16 20:46:30 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

for you to fetch changes up to 4266f41feaeee2521749ce2cfb52eafd4e2947c5:

  bpf: Fix bad unlock balance on freeze_mutex (2023-05-26 12:16:12 +0200)

----------------------------------------------------------------
bpf-next-for-netdev

----------------------------------------------------------------
Aditi Ghag (9):
      bpf: tcp: Avoid taking fast sock lock in iterator
      udp: seq_file: Helper function to match socket attributes
      bpf: udp: Encapsulate logic to get udp table
      udp: seq_file: Remove bpf_seq_afinfo from udp_iter_state
      bpf: udp: Implement batching for sockets iterator
      bpf: Add kfunc filter function to 'struct btf_kfunc_id_set'
      bpf: Add bpf_sock_destroy kfunc
      selftests/bpf: Add helper to get port using getsockname
      selftests/bpf: Test bpf_sock_destroy

Alexei Starovoitov (3):
      Merge branch 'bpf: Move kernel test kfuncs into bpf_testmod'
      Merge branch 'seltests/xsk: prepare for AF_XDP multi-buffer testing'
      Merge branch 'bpf: Show target_{obj,btf}_id for tracing link'

Alexey Gladkov (1):
      selftests/bpf: Do not use sign-file as testcase

Andrii Nakryiko (11):
      selftests/bpf: improve netcnt test robustness
      bpf: drop unnecessary user-triggerable WARN_ONCE in verifierl log
      bpf: Validate BPF object in BPF_OBJ_PIN before calling LSM
      libbpf: Start v1.3 development cycle
      bpf: Support O_PATH FDs in BPF_OBJ_PIN and BPF_OBJ_GET commands
      libbpf: Add opts-based bpf_obj_pin() API and add support for path_fd
      selftests/bpf: Add path_fd-based BPF_OBJ_PIN and BPF_OBJ_GET tests
      Merge branch 'libbpf: capability for resizing datasec maps'
      bpf: drop unnecessary bpf_capable() check in BPF_MAP_FREEZE command
      libbpf: Ensure libbpf always opens files with O_CLOEXEC
      libbpf: Ensure FD >= 3 during bpf_map__reuse_fd()

Daniel Borkmann (1):
      bpf: Fix bad unlock balance on freeze_mutex

Daniel Müller (1):
      selftests/bpf: Check whether to run selftest

Dave Thaler (1):
      bpf, docs: Shift operations are defined to use a mask

JP Kobryn (3):
      libbpf: Add capability for resizing datasec maps
      libbpf: Selftests for resizing datasec maps
      libbpf: Change var type in datasec resize func

Jiri Olsa (10):
      libbpf: Store zero fd to fd_array for loader kfunc relocation
      selftests/bpf: Move kfunc exports to bpf_testmod/bpf_testmod_kfunc.h
      selftests/bpf: Move test_progs helpers to testing_helpers object
      selftests/bpf: Use only stdout in un/load_bpf_testmod functions
      selftests/bpf: Do not unload bpf_testmod in load_bpf_testmod
      selftests/bpf: Use un/load_bpf_testmod functions in tests
      selftests/bpf: Load bpf_testmod for verifier test
      selftests/bpf: Allow to use kfunc from testmod.ko in test_verifier
      selftests/bpf: Remove extern from kfuncs declarations
      bpf: Move kernel test kfuncs to bpf_testmod

Larysa Zaremba (1):
      bpftool: Specify XDP Hints ifname when loading program

Lorenzo Bianconi (1):
      selftests/bpf: Add xdp_feature selftest for bond device

Magnus Karlsson (10):
      selftests/xsk: do not change XDP program when not necessary
      selftests/xsk: generate simpler packets with variable length
      selftests/xsk: add varying payload pattern within packet
      selftests/xsk: dump packet at error
      selftests/xsk: add packet iterator for tx to packet stream
      selftests/xsk: store offset in pkt instead of addr
      selftests/xsx: test for huge pages only once
      selftests/xsk: populate fill ring based on frags needed
      selftests/xsk: generate data for multi-buffer packets
      selftests/xsk: adjust packet pacing for multi-buffer support

Martin KaFai Lau (1):
      Merge branch 'bpf: Add socket destroy capability'

Pengcheng Yang (1):
      bpftool: Support bpffs mountpoint as pin path for prog loadall

Yafang Shao (2):
      bpf: Show target_{obj,btf}_id in tracing link fdinfo
      bpftool: Show target_{obj,btf}_id in tracing link info

Yonghong Song (3):
      selftests/bpf: Fix s390 sock_field test failure
      selftests/bpf: Fix dynptr/test_dynptr_is_null
      selftests/bpf: Make bpf_dynptr_is_rdonly() prototyype consistent with kernel

 Documentation/bpf/instruction-set.rst              |   9 +-
 include/linux/bpf.h                                |   4 +-
 include/linux/btf.h                                |  18 +-
 include/net/udp.h                                  |   1 -
 include/uapi/linux/bpf.h                           |  10 +
 kernel/bpf/btf.c                                   |  65 +-
 kernel/bpf/inode.c                                 |  27 +-
 kernel/bpf/log.c                                   |   3 -
 kernel/bpf/syscall.c                               |  45 +-
 kernel/bpf/verifier.c                              |   7 +-
 net/bpf/test_run.c                                 | 201 ------
 net/core/filter.c                                  |  63 ++
 net/ipv4/tcp.c                                     |   9 +-
 net/ipv4/tcp_ipv4.c                                |   7 +-
 net/ipv4/udp.c                                     | 291 ++++++--
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |   8 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |  11 +-
 tools/bpf/bpftool/bash-completion/bpftool          |   7 +-
 tools/bpf/bpftool/common.c                         |   9 +-
 tools/bpf/bpftool/iter.c                           |   2 +-
 tools/bpf/bpftool/link.c                           |   6 +
 tools/bpf/bpftool/main.h                           |   2 +-
 tools/bpf/bpftool/map.c                            |   7 +-
 tools/bpf/bpftool/prog.c                           |  53 +-
 tools/bpf/bpftool/struct_ops.c                     |   2 +-
 tools/include/uapi/linux/bpf.h                     |  10 +
 tools/lib/bpf/bpf.c                                |  17 +-
 tools/lib/bpf/bpf.h                                |  18 +-
 tools/lib/bpf/btf.c                                |   2 +-
 tools/lib/bpf/gen_loader.c                         |  14 +-
 tools/lib/bpf/libbpf.c                             | 154 +++-
 tools/lib/bpf/libbpf.h                             |  18 +-
 tools/lib/bpf/libbpf.map                           |   5 +
 tools/lib/bpf/libbpf_probes.c                      |   2 +-
 tools/lib/bpf/libbpf_version.h                     |   2 +-
 tools/lib/bpf/usdt.c                               |   5 +-
 tools/testing/selftests/bpf/Makefile               |   3 +-
 tools/testing/selftests/bpf/bpf_kfuncs.h           |   4 +-
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        | 166 +++++
 .../selftests/bpf/bpf_testmod/bpf_testmod_kfunc.h  | 100 +++
 tools/testing/selftests/bpf/network_helpers.c      |  23 +
 tools/testing/selftests/bpf/network_helpers.h      |   1 +
 .../selftests/bpf/prog_tests/bpf_mod_race.c        |  34 +-
 .../selftests/bpf/prog_tests/bpf_obj_pinning.c     | 268 +++++++
 .../selftests/bpf/prog_tests/global_map_resize.c   | 227 ++++++
 .../selftests/bpf/prog_tests/module_attach.c       |  12 +-
 tools/testing/selftests/bpf/prog_tests/netcnt.c    |   4 +-
 .../selftests/bpf/prog_tests/sock_destroy.c        | 221 ++++++
 tools/testing/selftests/bpf/prog_tests/sockopt.c   |   4 +-
 .../testing/selftests/bpf/prog_tests/xdp_bonding.c | 121 ++++
 tools/testing/selftests/bpf/progs/cb_refs.c        |   4 +-
 tools/testing/selftests/bpf/progs/dynptr_fail.c    |   1 +
 tools/testing/selftests/bpf/progs/dynptr_success.c |   1 +
 tools/testing/selftests/bpf/progs/jit_probe_mem.c  |   4 +-
 .../selftests/bpf/progs/kfunc_call_destructive.c   |   3 +-
 .../testing/selftests/bpf/progs/kfunc_call_fail.c  |   9 +-
 .../testing/selftests/bpf/progs/kfunc_call_race.c  |   3 +-
 .../testing/selftests/bpf/progs/kfunc_call_test.c  |  17 +-
 .../selftests/bpf/progs/kfunc_call_test_subprog.c  |   9 +-
 .../testing/selftests/bpf/progs/local_kptr_stash.c |   5 +-
 tools/testing/selftests/bpf/progs/map_kptr.c       |   5 +-
 tools/testing/selftests/bpf/progs/map_kptr_fail.c  |   4 +-
 .../selftests/bpf/progs/sock_destroy_prog.c        | 145 ++++
 .../selftests/bpf/progs/sock_destroy_prog_fail.c   |  22 +
 .../selftests/bpf/progs/test_global_map_resize.c   |  58 ++
 .../testing/selftests/bpf/progs/test_sock_fields.c |   5 +-
 .../testing/selftests/bpf/progs/test_xdp_dynptr.c  |   1 +
 tools/testing/selftests/bpf/test_progs.c           |  76 +-
 tools/testing/selftests/bpf/test_progs.h           |   1 -
 tools/testing/selftests/bpf/test_verifier.c        | 170 ++++-
 tools/testing/selftests/bpf/test_xsk.sh            |  10 +-
 tools/testing/selftests/bpf/testing_helpers.c      |  61 ++
 tools/testing/selftests/bpf/testing_helpers.h      |   9 +
 tools/testing/selftests/bpf/xsk.h                  |   5 +
 tools/testing/selftests/bpf/xskxceiver.c           | 771 ++++++++++-----------
 tools/testing/selftests/bpf/xskxceiver.h           |  31 +-
 76 files changed, 2729 insertions(+), 1003 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/bpf_testmod/bpf_testmod_kfunc.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_obj_pinning.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/global_map_resize.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sock_destroy.c
 create mode 100644 tools/testing/selftests/bpf/progs/sock_destroy_prog.c
 create mode 100644 tools/testing/selftests/bpf/progs/sock_destroy_prog_fail.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_map_resize.c

