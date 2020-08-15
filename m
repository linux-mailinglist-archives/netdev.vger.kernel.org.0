Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421F1245037
	for <lists+netdev@lfdr.de>; Sat, 15 Aug 2020 02:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgHOAF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 20:05:58 -0400
Received: from www62.your-server.de ([213.133.104.62]:58496 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgHOAF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 20:05:58 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k6jhg-0000vO-Hd; Sat, 15 Aug 2020 02:05:44 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2020-08-15
Date:   Sat, 15 Aug 2020 02:05:44 +0200
Message-Id: <20200815000544.25793-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25901/Thu Aug 13 09:01:24 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 23 non-merge commits during the last 4 day(s) which contain
a total of 32 files changed, 421 insertions(+), 141 deletions(-).

The main changes are:

1) Fix sock_ops ctx access splat due to register override, from John Fastabend.

2) Batch of various fixes to libbpf, bpftool, and selftests when testing build
   in 32-bit mode, from Andrii Nakryiko.

3) Fix vmlinux.h generation on ARM by mapping GCC built-in types (__Poly*_t)
   to equivalent ones clang can work with, from Jean-Philippe Brucker.

4) Fix build_id lookup in bpf_get_stackid() helper by walking all NOTE ELF
   sections instead of just first, from Jiri Olsa.

5) Avoid use of __builtin_offsetof() in libbpf for CO-RE, from Yonghong Song.

6) Fix segfault in test_mmap due to inconsistent length params, from Jianlin Lv.

7) Don't override errno in libbpf when logging errors, from Toke Høiland-Jørgensen.

8) Fix v4_to_v6 sockaddr conversion in sk_lookup test, from Stanislav Fomichev.

9) Add link to bpf-helpers(7) man page to BPF doc, from Joe Stringer.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Ian Rogers, Jakov Petrina, Jakub Sitnicki, Martin KaFai 
Lau, Song Liu, Stanislav Fomichev, Toke Høiland-Jørgensen

----------------------------------------------------------------

The following changes since commit 444da3f52407d74c9aa12187ac6b01f76ee47d62:

  bitfield.h: don't compile-time validate _val in FIELD_FIT (2020-08-10 12:16:51 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 4fccd2ff74fbad222c69c7604307e0773a37ab8d:

  selftests/bpf: Make test_varlen work with 32-bit user-space arch (2020-08-13 16:45:41 -0700)

----------------------------------------------------------------
Andrii Nakryiko (11):
      bpf: Fix XDP FD-based attach/detach logic around XDP_FLAGS_UPDATE_IF_NOEXIST
      tools/bpftool: Make skeleton code C++17-friendly by dropping typeof()
      tools/bpftool: Fix compilation warnings in 32-bit mode
      selftest/bpf: Fix compilation warnings in 32-bit mode
      libbpf: Fix BTF-defined map-in-map initialization on 32-bit host arches
      libbpf: Handle BTF pointer sizes more carefully
      selftests/bpf: Fix btf_dump test cases on 32-bit arches
      libbpf: Enforce 64-bitness of BTF for BPF object files
      selftests/bpf: Correct various core_reloc 64-bit assumptions
      tools/bpftool: Generate data section struct with conservative alignment
      selftests/bpf: Make test_varlen work with 32-bit user-space arch

Jean-Philippe Brucker (1):
      libbpf: Handle GCC built-in types for Arm NEON

Jianlin Lv (1):
      selftests/bpf: Fix segmentation fault in test_progs

Jiri Olsa (1):
      bpf: Iterate through all PT_NOTE sections when looking for build id

Joe Stringer (1):
      doc: Add link to bpf helpers man page

John Fastabend (5):
      bpf: sock_ops ctx access may stomp registers in corner case
      bpf: sock_ops sk access may stomp registers when dst_reg = src_reg
      bpf, selftests: Add tests for ctx access in sock_ops with single register
      bpf, selftests: Add tests for sock_ops load with r9, r8.r7 registers
      bpf, selftests: Add tests to sock_ops for loading sk

Stanislav Fomichev (1):
      selftests/bpf: Fix v4_to_v6 in sk_lookup

Toke Høiland-Jørgensen (1):
      libbpf: Prevent overriding errno when logging errors

Yonghong Song (1):
      libbpf: Do not use __builtin_offsetof for offsetof

 Documentation/bpf/index.rst                        |  7 ++
 kernel/bpf/stackmap.c                              | 24 ++++---
 net/core/dev.c                                     |  8 +--
 net/core/filter.c                                  | 75 +++++++++++++++----
 tools/bpf/bpftool/btf_dumper.c                     |  2 +-
 tools/bpf/bpftool/gen.c                            | 22 ++++--
 tools/bpf/bpftool/link.c                           |  4 +-
 tools/bpf/bpftool/main.h                           | 10 ++-
 tools/bpf/bpftool/prog.c                           | 16 ++---
 tools/lib/bpf/bpf_helpers.h                        |  2 +-
 tools/lib/bpf/btf.c                                | 83 +++++++++++++++++++++-
 tools/lib/bpf/btf.h                                |  2 +
 tools/lib/bpf/btf_dump.c                           | 39 +++++++++-
 tools/lib/bpf/libbpf.c                             | 32 ++++++---
 tools/lib/bpf/libbpf.map                           |  2 +
 .../testing/selftests/bpf/prog_tests/bpf_obj_id.c  |  8 +--
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  | 27 +++++--
 .../testing/selftests/bpf/prog_tests/core_extern.c |  4 +-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  | 20 +++---
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |  6 +-
 .../selftests/bpf/prog_tests/flow_dissector.c      |  2 +-
 .../testing/selftests/bpf/prog_tests/global_data.c |  6 +-
 tools/testing/selftests/bpf/prog_tests/mmap.c      | 19 +++--
 .../selftests/bpf/prog_tests/prog_run_xattr.c      |  2 +-
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c |  1 +
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c   |  2 +-
 tools/testing/selftests/bpf/prog_tests/varlen.c    |  8 +--
 .../testing/selftests/bpf/progs/core_reloc_types.h | 69 +++++++++---------
 .../testing/selftests/bpf/progs/test_tcpbpf_kern.c | 41 +++++++++++
 tools/testing/selftests/bpf/progs/test_varlen.c    |  6 +-
 tools/testing/selftests/bpf/test_btf.c             |  8 +--
 tools/testing/selftests/bpf/test_progs.h           |  5 ++
 32 files changed, 421 insertions(+), 141 deletions(-)
