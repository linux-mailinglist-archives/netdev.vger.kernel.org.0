Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA48CE5FF2
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 00:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfJZWkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 18:40:19 -0400
Received: from www62.your-server.de ([213.133.104.62]:43546 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbfJZWkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 18:40:19 -0400
Received: from 33.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.33] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iOUj9-0008Jp-Dk; Sun, 27 Oct 2019 00:40:07 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     jakub.kicinski@netronome.com, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2019-10-27
Date:   Sun, 27 Oct 2019 00:40:06 +0200
Message-Id: <20191026224006.18149-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25614/Sat Oct 26 11:04:41 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 7 non-merge commits during the last 11 day(s) which contain
a total of 7 files changed, 66 insertions(+), 16 deletions(-).

The main changes are:

1) Fix two use-after-free bugs in relation to RCU in jited symbol exposure to
   kallsyms, from Daniel Borkmann.

2) Fix NULL pointer dereference in AF_XDP rx-only sockets, from Magnus Karlsson.

3) Fix hang in netdev unregister for hash based devmap as well as another overflow
   bug on 32 bit archs in memlock cost calculation, from Toke Høiland-Jørgensen.

4) Fix wrong memory access in LWT BPF programs on reroute due to invalid dst.
   Also fix BPF selftests to use more compatible nc options, from Jiri Benc.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Jonathan Lemon, Kal Cutter Conley, Martin KaFai Lau, Peter Oskolkov, 
Tetsuo Handa, Yonghong Song

----------------------------------------------------------------

The following changes since commit 33902b4a4227877896dd9368ac10f4ca0d100de5:

  netdevsim: Fix error handling in nsim_fib_init and nsim_fib_exit (2019-10-13 11:30:14 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 2afd23f78f39da84937006ecd24aa664a4ab052b:

  xsk: Fix registration of Rx-only sockets (2019-10-23 20:22:11 -0700)

----------------------------------------------------------------
Daniel Borkmann (2):
      bpf: Fix use after free in subprog's jited symbol removal
      bpf: Fix use after free in bpf_get_prog_name

Jiri Benc (2):
      bpf: lwtunnel: Fix reroute supplying invalid dst
      selftests/bpf: More compatible nc options in test_tc_edt

Magnus Karlsson (1):
      xsk: Fix registration of Rx-only sockets

Toke Høiland-Jørgensen (2):
      xdp: Prevent overflow in devmap_hash cost calculation for 32-bit builds
      xdp: Handle device unregister for devmap_hash map type

 include/linux/filter.h                     |  1 -
 kernel/bpf/core.c                          |  2 +-
 kernel/bpf/devmap.c                        | 33 +++++++++++++++++++++++++++++-
 kernel/bpf/syscall.c                       | 31 ++++++++++++++++++----------
 net/core/lwt_bpf.c                         |  7 ++++++-
 net/xdp/xdp_umem.c                         |  6 ++++++
 tools/testing/selftests/bpf/test_tc_edt.sh |  2 +-
 7 files changed, 66 insertions(+), 16 deletions(-)
