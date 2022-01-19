Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F374C493237
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 02:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350598AbiASBS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 20:18:28 -0500
Received: from www62.your-server.de ([213.133.104.62]:51228 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238605AbiASBS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 20:18:28 -0500
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1n9zcH-0001wV-Tb; Wed, 19 Jan 2022 02:18:26 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2022-01-19
Date:   Wed, 19 Jan 2022 02:18:25 +0100
Message-Id: <20220119011825.9082-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26426/Tue Jan 18 10:32:09 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 12 non-merge commits during the last 8 day(s) which contain
a total of 12 files changed, 262 insertions(+), 64 deletions(-).

The main changes are:

1) Various verifier fixes mainly around register offset handling when passed
   to helper functions, from Daniel Borkmann.

2) Fix XDP BPF link handling to assert program type, from Toke Høiland-Jørgensen.

3) Fix regression in mount parameter handling for BPF fs, from Yafang Shao.

4) Fix incorrect integer literal when marking scratched stack slots in
   verifier, from Christy Lee.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, Christian Brauner, Dan Carpenter, 
John Fastabend, kernel test robot, Song Liu

----------------------------------------------------------------

The following changes since commit 7d6019b602de660bfc6a542a68630006ace83b90:

  Revert "net: vertexcom: default to disabled on kbuild" (2022-01-10 21:11:07 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 37c8d4807d1b8b521b30310dce97f6695dc2c2c6:

  bpf, selftests: Add ringbuf memory type confusion test (2022-01-19 01:27:03 +0100)

----------------------------------------------------------------
Christy Lee (1):
      bpf: Fix incorrect integer literal used for marking scratched stack.

Daniel Borkmann (7):
      bpf: Generalize check_ctx_reg for reuse with other types
      bpf: Mark PTR_TO_FUNC register initially with zero offset
      bpf: Generally fix helper register offset check
      bpf: Fix out of bounds access for ringbuf helpers
      bpf: Fix ringbuf memory type confusion when passing to helpers
      bpf, selftests: Add various ringbuf tests with invalid offset
      bpf, selftests: Add ringbuf memory type confusion test

Toke Høiland-Jørgensen (3):
      xdp: check prog type before updating BPF link
      bpf/selftests: convert xdp_link test to ASSERT_* macros
      bpf/selftests: Add check for updating XDP bpf_link with wrong program type

Yafang Shao (1):
      bpf: Fix mount source show for bpffs

 include/linux/bpf.h                                |  9 +-
 include/linux/bpf_verifier.h                       |  4 +-
 kernel/bpf/btf.c                                   |  2 +-
 kernel/bpf/inode.c                                 | 14 +++-
 kernel/bpf/verifier.c                              | 81 ++++++++++++------
 net/core/dev.c                                     |  6 ++
 tools/testing/selftests/bpf/prog_tests/d_path.c    | 14 ++++
 tools/testing/selftests/bpf/prog_tests/xdp_link.c  | 61 +++++++-------
 .../selftests/bpf/progs/test_d_path_check_types.c  | 32 ++++++++
 tools/testing/selftests/bpf/progs/test_xdp_link.c  |  6 ++
 tools/testing/selftests/bpf/verifier/ringbuf.c     | 95 ++++++++++++++++++++++
 tools/testing/selftests/bpf/verifier/spill_fill.c  |  2 +-
 12 files changed, 262 insertions(+), 64 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_d_path_check_types.c
 create mode 100644 tools/testing/selftests/bpf/verifier/ringbuf.c
