Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45ECE28F953
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 21:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389848AbgJOTQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 15:16:03 -0400
Received: from www62.your-server.de ([213.133.104.62]:47514 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389812AbgJOTQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 15:16:03 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kT8jA-0002CN-MN; Thu, 15 Oct 2020 21:15:52 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2020-10-15
Date:   Thu, 15 Oct 2020 21:15:52 +0200
Message-Id: <20201015191552.12435-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25958/Thu Oct 15 15:56:23 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF *fixes* for your *net-next* tree.

We've added 4 non-merge commits during the last 3 day(s) which contain
a total of 5 files changed, 70 insertions(+), 46 deletions(-).

The main changes are:

1) Fix register equivalence tracking in verifier, from Alexei Starovoitov.

2) Fix sockmap error path to not call bpf_prog_put() with NULL, from Alex Dewar.

3) Fix sockmap to add locking annotations to iterator, from Lorenz Bauer.

4) Fix tcp_hdr_options test to use loopback address, from Martin KaFai Lau.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Jakub Sitnicki, John Fastabend, kernel test robot, 
Yonghong Song

----------------------------------------------------------------

The following changes since commit ccdf7fae3afaeaf0e5dd03311b86ffa56adf85ae:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next (2020-10-12 16:16:50 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 83c11c17553c0fca217105c17444c4ef5ab2403f:

  net, sockmap: Don't call bpf_prog_put() on NULL pointer (2020-10-15 21:05:23 +0200)

----------------------------------------------------------------
Alex Dewar (1):
      net, sockmap: Don't call bpf_prog_put() on NULL pointer

Alexei Starovoitov (1):
      bpf: Fix register equivalence tracking.

Lorenz Bauer (1):
      bpf, sockmap: Add locking annotations to iterator

Martin KaFai Lau (1):
      bpf, selftest: Fix flaky tcp_hdr_options test when adding addr to lo

 kernel/bpf/verifier.c                              | 38 ++++++++++++++--------
 net/core/sock_map.c                                | 24 ++++++++++----
 .../selftests/bpf/prog_tests/tcp_hdr_options.c     | 26 +--------------
 .../bpf/progs/test_misc_tcp_hdr_options.c          |  2 +-
 tools/testing/selftests/bpf/verifier/regalloc.c    | 26 +++++++++++++++
 5 files changed, 70 insertions(+), 46 deletions(-)
