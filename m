Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09C251508F
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 17:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbfEFPp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 11:45:29 -0400
Received: from www62.your-server.de ([213.133.104.62]:35698 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfEFPp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 11:45:29 -0400
Received: from [2a02:120b:c3fc:feb0:dda7:bd28:a848:50e2] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hNfNm-0007gy-PX; Mon, 06 May 2019 17:18:22 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf-next 2019-05-06
Date:   Mon,  6 May 2019 17:18:22 +0200
Message-Id: <20190506151822.19628-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25441/Mon May  6 10:04:24 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

The main changes are:

1) Two AF_XDP libbpf fixes for socket teardown; first one an invalid
   munmap and the other one an invalid skmap cleanup, both from Björn.

2) More graceful CONFIG_DEBUG_INFO_BTF handling when pahole is not
   present in the system to generate vmlinux btf info, from Andrii.

3) Fix libbpf and thus fix perf build error with uClibc on arc
   architecture, from Vineet.

4) Fix missing libbpf_util.h header install in libbpf, from William.

5) Exclude bash-completion/bpftool from .gitignore pattern, from Masahiro.

6) Fix up rlimit in test_libbpf_open kselftest test case, from Yonghong.

7) Minor misc cleanups.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

----------------------------------------------------------------

The following changes since commit a734d1f4c2fc962ef4daa179e216df84a8ec5f84:

  net: openvswitch: return an error instead of doing BUG_ON() (2019-05-04 01:36:36 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to d24ed99b3b270c6de8f47c25d709b5f6ef7d3807:

  libbpf: remove unnecessary cast-to-void (2019-05-06 11:35:17 +0200)

----------------------------------------------------------------
Alexei Starovoitov (1):
      Merge branch 'af_xdp-fixes'

Andrii Nakryiko (1):
      kbuild: tolerate missing pahole when generating BTF

Björn Töpel (3):
      libbpf: fix invalid munmap call
      libbpf: proper XSKMAP cleanup
      libbpf: remove unnecessary cast-to-void

Masahiro Yamada (1):
      bpftool: exclude bash-completion/bpftool from .gitignore pattern

Vineet Gupta (1):
      tools/bpf: fix perf build error with uClibc (seen on ARC)

William Tu (1):
      libbpf: add libbpf_util.h to header install.

Yonghong Song (1):
      selftests/bpf: set RLIMIT_MEMLOCK properly for test_libbpf_open.c

YueHaibing (1):
      bpf: Use PTR_ERR_OR_ZERO in bpf_fd_sk_storage_update_elem()

 net/core/bpf_sk_storage.c                      |   2 +-
 scripts/link-vmlinux.sh                        |   5 +
 tools/bpf/bpftool/.gitignore                   |   2 +-
 tools/lib/bpf/Makefile                         |   1 +
 tools/lib/bpf/bpf.c                            |   2 +
 tools/lib/bpf/xsk.c                            | 184 +++++++++++++------------
 tools/testing/selftests/bpf/test_libbpf_open.c |   2 +
 7 files changed, 106 insertions(+), 92 deletions(-)
