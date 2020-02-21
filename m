Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 831CD1689F0
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 23:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgBUW3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 17:29:16 -0500
Received: from www62.your-server.de ([213.133.104.62]:58052 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgBUW3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 17:29:16 -0500
Received: from 192.42.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.42.192] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j5GnC-0006If-8E; Fri, 21 Feb 2020 23:29:06 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     jakub.kicinski@netronome.com, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2020-02-21
Date:   Fri, 21 Feb 2020 23:29:05 +0100
Message-Id: <20200221222905.1663-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.1/25730/Fri Feb 21 13:08:06 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 25 non-merge commits during the last 4 day(s) which contain
a total of 33 files changed, 2433 insertions(+), 161 deletions(-).

The main changes are:

1) Allow for adding TCP listen sockets into sock_map/hash so they can be used
   with reuseport BPF programs, from Jakub Sitnicki.

2) Add a new bpf_program__set_attach_target() helper for adding libbpf support
   to specify the tracepoint/function dynamically, from Eelco Chaudron.

3) Add bpf_read_branch_records() BPF helper which helps use cases like profile
   guided optimizations, from Daniel Xu.

4) Enable bpf_perf_event_read_value() in all tracing programs, from Song Liu.

5) Relax BTF mandatory check if only used for libbpf itself e.g. to process
   BTF defined maps, from Andrii Nakryiko.

6) Move BPF selftests -mcpu compilation attribute from 'probe' to 'v3' as it has
   been observed that former fails in envs with low memlock, from Yonghong Song.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, John Fastabend, Julia Kartseva, Martin KaFai Lau, Song 
Liu, Toke Høiland-Jørgensen

----------------------------------------------------------------

The following changes since commit b182a66792feb706c62e50c31db8546ca4ff168e:

  net: ena: remove set but not used variable 'hash_key' (2020-02-17 22:32:50 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to eb1e1478b6f4e70d99fee3f49bb7f7143c8c871d:

  Merge branch 'bpf-sockmap-listen' (2020-02-21 22:31:41 +0100)

----------------------------------------------------------------
Alexei Starovoitov (3):
      Merge branch 'bpf_read_branch_records'
      selftests/bpf: Fix build of sockmap_ktls.c
      Merge branch 'set_attach_target'

Andrii Nakryiko (2):
      libbpf: Relax check whether BTF is mandatory
      selftests/bpf: Fix trampoline_count clean up logic

Daniel Borkmann (2):
      Merge branch 'bpf-skmsg-simplify-restore'
      Merge branch 'bpf-sockmap-listen'

Daniel Xu (2):
      bpf: Add bpf_read_branch_records() helper
      selftests/bpf: Add bpf_read_branch_records() selftest

Eelco Chaudron (3):
      libbpf: Bump libpf current version to v0.0.8
      libbpf: Add support for dynamic program attach target
      selftests/bpf: Update xdp_bpf2bpf test to use new set_attach_target API

Jakub Sitnicki (14):
      bpf, sk_msg: Let ULP restore sk_proto and write_space callback
      bpf, sk_msg: Don't clear saved sock proto on restore
      selftests/bpf: Test unhashing kTLS socket after removing from map
      net, sk_msg: Annotate lockless access to sk_prot on clone
      net, sk_msg: Clear sk_user_data pointer on clone if tagged
      tcp_bpf: Don't let child socket inherit parent protocol ops on copy
      bpf, sockmap: Allow inserting listening TCP sockets into sockmap
      bpf, sockmap: Don't set up upcalls and progs for listening sockets
      bpf, sockmap: Return socket cookie on lookup from syscall
      bpf, sockmap: Let all kernel-land lookup values in SOCKMAP/SOCKHASH
      bpf: Allow selecting reuseport socket from a SOCKMAP/SOCKHASH
      net: Generate reuseport group ID on group creation
      selftests/bpf: Extend SK_REUSEPORT tests to cover SOCKMAP/SOCKHASH
      selftests/bpf: Tests for sockmap/sockhash holding listening sockets

Song Liu (1):
      bpf: Allow bpf_perf_event_read_value in all BPF programs

Yonghong Song (2):
      selftests/bpf: Change llvm flag -mcpu=probe to -mcpu=v3
      docs/bpf: Update bpf development Q/A file

 Documentation/bpf/bpf_devel_QA.rst                 |   29 +-
 include/linux/skmsg.h                              |   20 +-
 include/net/sock.h                                 |   37 +-
 include/net/sock_reuseport.h                       |    2 -
 include/net/tcp.h                                  |    7 +
 include/uapi/linux/bpf.h                           |   25 +-
 kernel/bpf/reuseport_array.c                       |    5 -
 kernel/bpf/verifier.c                              |   10 +-
 kernel/trace/bpf_trace.c                           |   45 +-
 net/core/filter.c                                  |   27 +-
 net/core/skmsg.c                                   |    2 +-
 net/core/sock.c                                    |   14 +-
 net/core/sock_map.c                                |  167 ++-
 net/core/sock_reuseport.c                          |   50 +-
 net/ipv4/tcp_bpf.c                                 |   18 +-
 net/ipv4/tcp_minisocks.c                           |    2 +
 net/ipv4/tcp_ulp.c                                 |    3 +-
 net/tls/tls_main.c                                 |    3 +-
 tools/include/uapi/linux/bpf.h                     |   25 +-
 tools/lib/bpf/libbpf.c                             |   38 +-
 tools/lib/bpf/libbpf.h                             |    4 +
 tools/lib/bpf/libbpf.map                           |    5 +
 tools/testing/selftests/bpf/Makefile               |    4 +-
 .../selftests/bpf/prog_tests/perf_branches.c       |  170 +++
 .../selftests/bpf/prog_tests/select_reuseport.c    |   63 +-
 .../selftests/bpf/prog_tests/sockmap_ktls.c        |  124 ++
 .../selftests/bpf/prog_tests/sockmap_listen.c      | 1496 ++++++++++++++++++++
 .../selftests/bpf/prog_tests/trampoline_count.c    |   25 +-
 .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |   16 +-
 .../selftests/bpf/progs/test_perf_branches.c       |   50 +
 .../selftests/bpf/progs/test_sockmap_listen.c      |   98 ++
 .../testing/selftests/bpf/progs/test_xdp_bpf2bpf.c |    4 +-
 tools/testing/selftests/bpf/test_maps.c            |    6 +-
 33 files changed, 2433 insertions(+), 161 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/perf_branches.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_perf_branches.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_listen.c
