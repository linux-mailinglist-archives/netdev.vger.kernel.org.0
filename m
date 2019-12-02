Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 580B510E844
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 11:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbfLBKM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 05:12:28 -0500
Received: from www62.your-server.de ([213.133.104.62]:43450 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfLBKM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 05:12:28 -0500
Received: from [194.230.159.159] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ibigj-0006vI-2Z; Mon, 02 Dec 2019 11:12:17 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     jakub.kicinski@netronome.com, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2019-12-02
Date:   Mon,  2 Dec 2019 11:12:16 +0100
Message-Id: <20191202101216.9511-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25650/Sun Dec  1 11:04:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 10 non-merge commits during the last 6 day(s) which contain
a total of 10 files changed, 60 insertions(+), 51 deletions(-).

The main changes are:

1) Fix vmlinux BTF generation for binutils pre v2.25, from Stanislav Fomichev.

2) Fix libbpf global variable relocation to take symbol's st_value offset
   into account, from Andrii Nakryiko.

3) Fix libbpf build on powerpc where check_abi target fails due to different
   readelf output format, from Aurelien Jarno.

4) Don't set BPF insns RO for the case when they are JITed in order to avoid
   fragmenting the direct map, from Daniel Borkmann.

5) Fix static checker warning in btf_distill_func_proto() as well as a build
   error due to empty enum when BPF is compiled out, from Alexei Starovoitov.

6) Fix up generation of bpf_helper_defs.h for perf, from Arnaldo Carvalho de Melo.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Arnaldo Carvalho de Melo, Dan Carpenter, John 
Fastabend, Michael Ellerman, Randy Dunlap, Yonghong Song

----------------------------------------------------------------

The following changes since commit a95069ecb7092d03b2ea1c39ee04514fe9627540:

  gve: Fix the queue page list allocated pages count (2019-11-26 15:52:34 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 3464afdf11f9a1e031e7858a05351ceca1792fea:

  libbpf: Fix readelf output parsing on powerpc with recent binutils (2019-12-02 10:31:54 +0100)

----------------------------------------------------------------
Alexei Starovoitov (3):
      bpf: Fix static checker warning
      libbpf: Fix sym->st_value print on 32-bit arches
      bpf: Fix build in minimal configurations

Andrii Nakryiko (2):
      libbpf: Fix Makefile' libbpf symbol mismatch diagnostic
      libbpf: Fix global variable relocation

Arnaldo Carvalho de Melo (1):
      libbpf: Fix up generation of bpf_helper_defs.h

Aurelien Jarno (1):
      libbpf: Fix readelf output parsing on powerpc with recent binutils

Daniel Borkmann (1):
      bpf: Avoid setting bpf insns pages read-only when prog is jited

Stanislav Fomichev (2):
      bpf: Support pre-2.25-binutils objcopy for vmlinux BTF
      bpf: Force .BTF section start to zero when dumping from vmlinux

 include/linux/filter.h                            |  8 +++-
 kernel/bpf/btf.c                                  |  5 ++-
 scripts/link-vmlinux.sh                           |  8 +++-
 tools/lib/bpf/Makefile                            | 10 ++---
 tools/lib/bpf/libbpf.c                            | 45 ++++++++++-------------
 tools/perf/MANIFEST                               |  1 +
 tools/testing/selftests/bpf/progs/fentry_test.c   | 12 +++---
 tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c |  6 +--
 tools/testing/selftests/bpf/progs/fexit_test.c    | 12 +++---
 tools/testing/selftests/bpf/progs/test_mmap.c     |  4 +-
 10 files changed, 60 insertions(+), 51 deletions(-)
