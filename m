Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAC54254B3
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbhJGNwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:52:11 -0400
Received: from www62.your-server.de ([213.133.104.62]:33982 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241654AbhJGNwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 09:52:08 -0400
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mYTml-00089o-0E; Thu, 07 Oct 2021 15:50:11 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2021-10-07
Date:   Thu,  7 Oct 2021 15:50:10 +0200
Message-Id: <20211007135010.21143-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26315/Thu Oct  7 11:09:01 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 7 non-merge commits during the last 8 day(s) which contain
a total of 8 files changed, 38 insertions(+), 21 deletions(-).

The main changes are:

1) Fix ARM BPF JIT to preserve caller-saved regs for DIV/MOD JIT-internal
   helper call, from Johan Almbladh.

2) Fix integer overflow in BPF stack map element size calculation when
   used with preallocation, from Tatsuhiko Yasumatsu.

3) Fix an AF_UNIX regression due to added BPF sockmap support related
   to shutdown handling, from Jiang Wang.

4) Fix a segfault in libbpf when generating light skeletons from objects
   without BTF, from Kumar Kartikeya Dwivedi.

5) Fix a libbpf memory leak in strset to free the actual struct strset
   itself, from Andrii Nakryiko.

6) Dual-license bpf_insn.h similarly as we did for libbpf and bpftool,
   with ACKs from all contributors, from Luca Boccassi.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Björn Töpel, Brendan Jackman, Casey Schaufler, 
Chenbo Feng, Daniel Borkmann, Daniel Mack, Joe Stringer, Josef Bacik, 
Magnus Karlsson, Martin KaFai Lau, Simon Horman, Song Liu, Toke 
Høiland-Jørgensen

----------------------------------------------------------------

The following changes since commit 4ccb9f03fee7b20484187ba7e25a7b9b79fe63d5:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2021-09-28 13:52:46 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to d0c6416bd7091647f6041599f396bfa19ae30368:

  unix: Fix an issue in unix_shutdown causing the other end read/write failures (2021-10-06 14:40:21 +0200)

----------------------------------------------------------------
Andrii Nakryiko (1):
      libbpf: Fix memory leak in strset

Jiang Wang (1):
      unix: Fix an issue in unix_shutdown causing the other end read/write failures

Johan Almbladh (1):
      bpf, arm: Fix register clobbering in div/mod implementation

Kumar Kartikeya Dwivedi (2):
      samples: bpf: Fix vmlinux.h generation for XDP samples
      libbpf: Fix segfault in light skeleton for objects without BTF

Luca Boccassi (1):
      samples/bpf: Relicense bpf_insn.h as GPL-2.0-only OR BSD-2-Clause

Tatsuhiko Yasumatsu (1):
      bpf: Fix integer overflow in prealloc_elems_and_freelist()

 arch/arm/net/bpf_jit_32.c                | 19 +++++++++++++++++++
 kernel/bpf/stackmap.c                    |  3 ++-
 net/unix/af_unix.c                       |  9 +++++----
 samples/bpf/Makefile                     | 17 ++++++++---------
 samples/bpf/bpf_insn.h                   |  2 +-
 samples/bpf/xdp_redirect_map_multi.bpf.c |  5 -----
 tools/lib/bpf/libbpf.c                   |  3 ++-
 tools/lib/bpf/strset.c                   |  1 +
 8 files changed, 38 insertions(+), 21 deletions(-)
