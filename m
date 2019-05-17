Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B108F220B2
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 01:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729033AbfEQXOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 19:14:07 -0400
Received: from www62.your-server.de ([213.133.104.62]:59392 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbfEQXOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 19:14:07 -0400
Received: from [178.199.41.31] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hRm36-00086z-Dm; Sat, 18 May 2019 01:14:01 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf 2019-05-18
Date:   Sat, 18 May 2019 01:14:00 +0200
Message-Id: <20190517231400.9315-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.9.5
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25452/Fri May 17 09:57:24 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

The main changes are:

1) Fix bpftool's raw BTF dump in relation to forward declarations of union/
   structs, and another fix to unexport logging helpers, from Andrii.

2) Fix inode permission check for retrieving bpf programs, from Chenbo.

3) Fix bpftool to raise rlimit earlier as otherwise libbpf's feature probing
   can fail and subsequently it refuses to load an object, from Yonghong.

4) Fix declaration of bpf_get_current_task() in kselftests, from Alexei.

5) Fix up BPF kselftest .gitignore to add generated files, from Stanislav.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

----------------------------------------------------------------

The following changes since commit 2407a88a13a2d03ea9b8c86bbdedb3eff80c4b9e:

  Merge branch 'rhashtable-Fix-sparse-warnings' (2019-05-16 09:45:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 9c3ddee1246411a3c9c39bfa5457e49579027f0c:

  bpftool: fix BTF raw dump of FWD's fwd_kind (2019-05-17 14:21:29 +0200)

----------------------------------------------------------------
Alexei Starovoitov (1):
      selftests/bpf: fix bpf_get_current_task

Andrii Nakryiko (2):
      libbpf: move logging helpers into libbpf_internal.h
      bpftool: fix BTF raw dump of FWD's fwd_kind

Chenbo Feng (1):
      bpf: relax inode permission check for retrieving bpf program

Stanislav Fomichev (1):
      selftests/bpf: add test_sysctl and map_tests/tests.h to .gitignore

Yonghong Song (1):
      tools/bpftool: move set_max_rlimit() before __bpf_object__open_xattr()

 kernel/bpf/inode.c                               |  2 +-
 tools/bpf/bpftool/btf.c                          |  4 ++--
 tools/bpf/bpftool/prog.c                         |  4 ++--
 tools/lib/bpf/btf.c                              |  2 +-
 tools/lib/bpf/libbpf.c                           |  1 -
 tools/lib/bpf/libbpf_internal.h                  | 13 +++++++++++++
 tools/lib/bpf/libbpf_util.h                      | 13 -------------
 tools/lib/bpf/xsk.c                              |  2 +-
 tools/testing/selftests/bpf/.gitignore           |  1 +
 tools/testing/selftests/bpf/bpf_helpers.h        |  2 +-
 tools/testing/selftests/bpf/map_tests/.gitignore |  1 +
 11 files changed, 23 insertions(+), 22 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/map_tests/.gitignore
