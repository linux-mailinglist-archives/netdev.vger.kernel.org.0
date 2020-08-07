Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBD023F50A
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 00:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgHGWy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 18:54:57 -0400
Received: from www62.your-server.de ([213.133.104.62]:54772 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgHGWy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 18:54:57 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k4BG9-0004Ko-57; Sat, 08 Aug 2020 00:54:45 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2020-08-08
Date:   Sat,  8 Aug 2020 00:54:44 +0200
Message-Id: <20200807225444.6302-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25897/Fri Aug  7 14:45:59 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 11 non-merge commits during the last 2 day(s) which contain
a total of 24 files changed, 216 insertions(+), 135 deletions(-).

The main changes are:

1) Fix UAPI for BPF map iterator before it gets frozen to allow for more
   extensions/customization in future, from Yonghong Song.

2) Fix selftests build to undo verbose build output, from Andrii Nakryiko.

3) Fix inlining compilation error on bpf_do_trace_printk() due to variable
   argument lists, from Stanislav Fomichev.

4) Fix an uninitialized pointer warning at btf__parse_raw() in libbpf,
   from Daniel T. Lee.

5) Fix several compilation warnings in selftests with regards to ignoring
   return value, from Jianlin Lv.

6) Fix interruptions by switching off timeout for BPF tests, from Jiri Benc.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, John Fastabend

----------------------------------------------------------------

The following changes since commit 8912fd6a61d7474ea9b43be93f136034d28868d5:

  net: hns3: fix spelling mistake "could'nt" -> "couldn't" (2020-08-06 12:05:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to b8c1a3090741f349322ad855d2b66d6e9752a60d:

  bpf: Delete repeated words in comments (2020-08-07 18:57:24 +0200)

----------------------------------------------------------------
Alan Maguire (1):
      bpf, doc: Remove references to warning message when using bpf_trace_printk()

Alexei Starovoitov (1):
      Merge branch 'bpf_iter-uapi-fix'

Andrii Nakryiko (2):
      selftests/bpf: Prevent runqslower from racing on building bpftool
      selftests/bpf: Fix silent Makefile output

Daniel T. Lee (1):
      libbf: Fix uninitialized pointer at btf__parse_raw()

Jianlin Lv (1):
      bpf: Fix compilation warning of selftests

Jiri Benc (1):
      selftests: bpf: Switch off timeout

Randy Dunlap (1):
      bpf: Delete repeated words in comments

Stanislav Fomichev (2):
      bpf: Add missing return to resolve_btfids
      bpf: Remove inline from bpf_do_trace_printk

Yonghong Song (2):
      bpf: Change uapi for bpf iterator map elements
      tools/bpf: Support new uapi for map element bpf iterator

 Documentation/bpf/bpf_design_QA.rst                | 11 ----
 include/linux/bpf.h                                | 10 ++--
 include/uapi/linux/bpf.h                           | 15 +++---
 kernel/bpf/bpf_iter.c                              | 58 +++++++++++-----------
 kernel/bpf/core.c                                  |  2 +-
 kernel/bpf/map_iter.c                              | 37 +++++++++++---
 kernel/bpf/syscall.c                               |  2 +-
 kernel/bpf/verifier.c                              |  2 +-
 kernel/trace/bpf_trace.c                           |  2 +-
 net/core/bpf_sk_storage.c                          | 37 +++++++++++---
 tools/bpf/bpftool/iter.c                           |  9 ++--
 tools/bpf/resolve_btfids/main.c                    |  1 +
 tools/include/uapi/linux/bpf.h                     | 15 +++---
 tools/lib/bpf/bpf.c                                |  3 ++
 tools/lib/bpf/bpf.h                                |  5 +-
 tools/lib/bpf/btf.c                                |  2 +-
 tools/lib/bpf/libbpf.c                             |  6 +--
 tools/lib/bpf/libbpf.h                             |  5 +-
 tools/testing/selftests/bpf/Makefile               | 53 +++++++++++---------
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  | 40 ++++++++++++---
 .../testing/selftests/bpf/prog_tests/send_signal.c | 18 +++----
 .../bpf/prog_tests/stacktrace_build_id_nmi.c       |  4 +-
 tools/testing/selftests/bpf/settings               |  1 +
 tools/testing/selftests/bpf/test_tcpnotify_user.c  | 13 +++--
 24 files changed, 216 insertions(+), 135 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/settings
