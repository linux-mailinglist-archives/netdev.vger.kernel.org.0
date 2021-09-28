Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCFE41AF5F
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240826AbhI1MvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:51:02 -0400
Received: from www62.your-server.de ([213.133.104.62]:48178 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240829AbhI1MvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 08:51:00 -0400
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mVCXu-000169-LA; Tue, 28 Sep 2021 14:49:18 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2021-09-28
Date:   Tue, 28 Sep 2021 14:49:18 +0200
Message-Id: <20210928124918.19126-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26306/Tue Sep 28 11:05:37 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 10 non-merge commits during the last 14 day(s) which contain
a total of 11 files changed, 139 insertions(+), 53 deletions(-).

The main changes are:

1) Fix MIPS JIT jump code emission for too large offsets, from Piotr Krysiuk.

2) Fix x86 JIT atomic/fetch emission when dst reg maps to rax, from Johan Almbladh.

3) Fix cgroup_sk_alloc corner case when called from interrupt, from Daniel Borkmann.

4) Fix segfault in libbpf's linker for objects without BTF, from Kumar Kartikeya Dwivedi.

5) Fix bpf_jit_charge_modmem for applications with CAP_BPF, from Lorenz Bauer.

6) Fix return value handling for struct_ops BPF programs, from Hou Tao.

7) Various fixes to BPF selftests, from Jiri Benc.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Brendan Jackman, Johan Almbladh, Martin KaFai Lau, 
Tejun Heo

----------------------------------------------------------------

The following changes since commit d198b27762644c71362e43a7533f89c92b115bcf:

  Revert "Revert "ipv4: fix memory leaks in ip_cmsg_send() callers"" (2021-09-14 14:24:31 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to ced185824c89b60e65b5a2606954c098320cdfb8:

  bpf, x86: Fix bpf mapping of atomic fetch implementation (2021-09-28 12:10:29 +0200)

----------------------------------------------------------------
Daniel Borkmann (2):
      bpf, cgroup: Assign cgroup in cgroup_sk_alloc when called from interrupt
      bpf, test, cgroup: Use sk_{alloc,free} for test cases

Dave Marchevsky (1):
      MAINTAINERS: Add btf headers to BPF

Hou Tao (1):
      bpf: Handle return value of BPF_PROG_TYPE_STRUCT_OPS prog

Jiri Benc (2):
      selftests, bpf: Fix makefile dependencies on libbpf
      selftests, bpf: test_lwt_ip_encap: Really disable rp_filter

Johan Almbladh (1):
      bpf, x86: Fix bpf mapping of atomic fetch implementation

Kumar Kartikeya Dwivedi (1):
      libbpf: Fix segfault in static linker for objects without BTF

Lorenz Bauer (1):
      bpf: Exempt CAP_BPF from checks against bpf_jit_limit

Piotr Krysiuk (1):
      bpf, mips: Validate conditional branch offsets

 MAINTAINERS                                      |  2 +
 arch/mips/net/bpf_jit.c                          | 57 +++++++++++++++-----
 arch/x86/net/bpf_jit_comp.c                      | 66 +++++++++++++++++-------
 include/linux/bpf.h                              |  3 +-
 kernel/bpf/bpf_struct_ops.c                      |  7 ++-
 kernel/bpf/core.c                                |  2 +-
 kernel/cgroup/cgroup.c                           | 17 ++++--
 net/bpf/test_run.c                               | 14 +++--
 tools/lib/bpf/linker.c                           |  8 ++-
 tools/testing/selftests/bpf/Makefile             |  3 +-
 tools/testing/selftests/bpf/test_lwt_ip_encap.sh | 13 +++--
 11 files changed, 139 insertions(+), 53 deletions(-)
