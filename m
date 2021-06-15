Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 854F33A8B43
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 23:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhFOVlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 17:41:35 -0400
Received: from www62.your-server.de ([213.133.104.62]:55598 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbhFOVle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 17:41:34 -0400
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ltGmO-00091N-0X; Tue, 15 Jun 2021 23:39:28 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2021-06-15
Date:   Tue, 15 Jun 2021 23:39:27 +0200
Message-Id: <20210615213927.27713-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26202/Tue Jun 15 13:21:24 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 5 non-merge commits during the last 11 day(s) which contain
a total of 10 files changed, 115 insertions(+), 16 deletions(-).

The main changes are:

1) Fix marking incorrect umem ring as done in libbpf's
   xsk_socket__create_shared() helper, from Kev Jackson.

2) Fix oob leakage under a spectre v1 type confusion
   attack, from Daniel Borkmann.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Adam Morrison, Alexei Starovoitov, Benedict Schlueter, John Fastabend, 
Ofek Kirzner, Piotr Krysiuk, Yonghong Song

----------------------------------------------------------------

The following changes since commit 1a8024239dacf53fcf39c0f07fbf2712af22864f:

  virtio-net: fix for skb_over_panic inside big mode (2021-06-03 15:29:04 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 973377ffe8148180b2651825b92ae91988141b05:

  bpf, selftests: Adjust few selftest outcomes wrt unreachable code (2021-06-14 23:06:38 +0200)

----------------------------------------------------------------
Daniel Borkmann (4):
      bpf: Inherit expanded/patched seen count from old aux data
      bpf: Do not mark insn as seen under speculative path verification
      bpf: Fix leakage under speculation on mispredicted branches
      bpf, selftests: Adjust few selftest outcomes wrt unreachable code

Kev Jackson (1):
      libbpf: Fixes incorrect rx_ring_setup_done

 kernel/bpf/verifier.c                              | 68 +++++++++++++++++++---
 tools/lib/bpf/xsk.c                                |  2 +-
 tools/testing/selftests/bpf/test_verifier.c        |  2 +-
 tools/testing/selftests/bpf/verifier/and.c         |  2 +
 tools/testing/selftests/bpf/verifier/bounds.c      | 14 +++++
 tools/testing/selftests/bpf/verifier/dead_code.c   |  2 +
 tools/testing/selftests/bpf/verifier/jmp32.c       | 22 +++++++
 tools/testing/selftests/bpf/verifier/jset.c        | 10 ++--
 tools/testing/selftests/bpf/verifier/unpriv.c      |  2 +
 .../selftests/bpf/verifier/value_ptr_arith.c       |  7 ++-
 10 files changed, 115 insertions(+), 16 deletions(-)
