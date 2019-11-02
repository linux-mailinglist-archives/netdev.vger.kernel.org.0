Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6428ECCD4
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 02:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbfKBB1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 21:27:15 -0400
Received: from www62.your-server.de ([213.133.104.62]:43516 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbfKBB1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 21:27:15 -0400
Received: from 38.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.38] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iQiC2-0003PL-RR; Sat, 02 Nov 2019 02:27:06 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     jakub.kicinski@netronome.com, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2019-11-02
Date:   Sat,  2 Nov 2019 02:27:06 +0100
Message-Id: <20191102012706.31533-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25620/Fri Nov  1 10:04:15 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 6 non-merge commits during the last 6 day(s) which contain
a total of 8 files changed, 35 insertions(+), 9 deletions(-).

The main changes are:

1) Fix ppc BPF JIT's tail call implementation by performing a second pass
   to gather a stable JIT context before opcode emission, from Eric Dumazet.

2) Fix build of BPF samples sys_perf_event_open() usage to compiled out
   unavailable test_attr__{enabled,open} checks. Also fix potential overflows
   in bpf_map_{area_alloc,charge_init} on 32 bit archs, from Björn Töpel.

3) Fix narrow loads of bpf_sysctl context fields with offset > 0 on big endian
   archs like s390x and also improve the test coverage, from Ilya Leoshkevich.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrey Ignatov, Andrii Nakryiko, Jakub Kicinski, KP 
Singh, Song Liu

----------------------------------------------------------------

The following changes since commit fc11078dd3514c65eabce166b8431a56d8a667cb:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf (2019-10-27 12:13:16 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 7de086909365cd60a5619a45af3f4152516fd75c:

  powerpc/bpf: Fix tail call implementation (2019-11-02 00:32:26 +0100)

----------------------------------------------------------------
Björn Töpel (3):
      perf tools: Make usage of test_attr__* optional for perf-sys.h
      samples/bpf: fix build by setting HAVE_ATTR_TEST to zero
      bpf: Change size to u64 for bpf_map_{area_alloc, charge_init}()

Daniel Borkmann (1):
      bpf, doc: Add Andrii as official reviewer to BPF subsystem

Eric Dumazet (1):
      powerpc/bpf: Fix tail call implementation

Ilya Leoshkevich (1):
      bpf: Allow narrow loads of bpf_sysctl fields with offset > 0

 MAINTAINERS                               |  1 +
 arch/powerpc/net/bpf_jit_comp64.c         | 13 +++++++++++++
 include/linux/bpf.h                       |  4 ++--
 kernel/bpf/cgroup.c                       |  4 ++--
 kernel/bpf/syscall.c                      |  7 +++++--
 samples/bpf/Makefile                      |  1 +
 tools/perf/perf-sys.h                     |  6 ++++--
 tools/testing/selftests/bpf/test_sysctl.c |  8 +++++++-
 8 files changed, 35 insertions(+), 9 deletions(-)
