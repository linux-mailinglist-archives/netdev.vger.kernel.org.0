Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C155362B21
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 00:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbhDPWh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 18:37:28 -0400
Received: from www62.your-server.de ([213.133.104.62]:56632 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbhDPWh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 18:37:27 -0400
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lXX5A-0007nb-Jx; Sat, 17 Apr 2021 00:37:00 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2021-04-17
Date:   Sat, 17 Apr 2021 00:37:00 +0200
Message-Id: <20210416223700.15611-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26142/Fri Apr 16 13:14:04 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 10 non-merge commits during the last 9 day(s) which contain
a total of 8 files changed, 175 insertions(+), 111 deletions(-).

The main changes are:

1) Fix a potential NULL pointer dereference in libbpf's xsk
   umem handling, from Ciara Loftus.

2) Mitigate a speculative oob read of up to map value size by
   tightening the masking window, from Daniel Borkmann.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Benedict Schlueter, John Fastabend, Piotr Krysiuk

----------------------------------------------------------------

The following changes since commit 1ffbc7ea91606e4abd10eb60de5367f1c86daf5e:

  net: sched: sch_teql: fix null-pointer dereference (2021-04-08 14:14:42 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to d7a5091351756d0ae8e63134313c455624e36a13:

  bpf: Update selftests to reflect new error states (2021-04-16 23:52:15 +0200)

----------------------------------------------------------------
Ciara Loftus (1):
      libbpf: Fix potential NULL pointer dereference

Daniel Borkmann (9):
      bpf: Use correct permission flag for mixed signed bounds arithmetic
      bpf: Move off_reg into sanitize_ptr_alu
      bpf: Ensure off_reg has no mixed signed bounds for all types
      bpf: Rework ptr_limit into alu_limit and add common error path
      bpf: Improve verifier error messages for users
      bpf: Refactor and streamline bounds check into helper
      bpf: Move sanitize_val_alu out of op switch
      bpf: Tighten speculative pointer arithmetic mask
      bpf: Update selftests to reflect new error states

 kernel/bpf/verifier.c                              | 230 ++++++++++++++-------
 tools/lib/bpf/xsk.c                                |   5 +-
 tools/testing/selftests/bpf/verifier/bounds.c      |   5 -
 .../selftests/bpf/verifier/bounds_deduction.c      |  21 +-
 .../bpf/verifier/bounds_mix_sign_unsign.c          |  13 --
 tools/testing/selftests/bpf/verifier/map_ptr.c     |   4 +-
 tools/testing/selftests/bpf/verifier/unpriv.c      |   2 +-
 .../selftests/bpf/verifier/value_ptr_arith.c       |   6 +-
 8 files changed, 175 insertions(+), 111 deletions(-)
