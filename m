Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9E46554FE
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 23:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiLWWTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 17:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiLWWTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 17:19:12 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA53A10B49;
        Fri, 23 Dec 2022 14:19:10 -0800 (PST)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1p8qNg-0007sF-49; Fri, 23 Dec 2022 23:19:08 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2022-12-23
Date:   Fri, 23 Dec 2022 23:19:07 +0100
Message-Id: <20221223221907.10465-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26759/Fri Dec 23 10:30:57 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net* tree.

We've added 7 non-merge commits during the last 5 day(s) which contain
a total of 11 files changed, 231 insertions(+), 3 deletions(-).

The main changes are:

1) Fix a splat in bpf_skb_generic_pop() under CHECKSUM_PARTIAL due to
   misuse of skb_postpull_rcsum(), from Jakub Kicinski with test case
   from Martin Lau.

2) Fix BPF verifier's nullness propagation when registers are of
   type PTR_TO_BTF_ID, from Hao Sun.

3) Fix bpftool build for JIT disassembler under statically built
   libllvm, from Anton Protopopov.

4) Fix warnings reported by resolve_btfids when building vmlinux
   with CONFIG_SECURITY_NETWORK disabled, from Hou Tao.

5) Minor fix up for BPF selftest gitignore, from Stanislav Fomichev.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

Thanks a lot and merry Xmas everyone!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Anand Parthasarathy, John Sperbeck, Stanislav Fomichev, Yonghong Song

----------------------------------------------------------------

The following changes since commit 2856a62762c8409e360d4fd452194c8e57ba1058:

  mctp: serial: Fix starting value for frame check sequence (2022-12-19 12:38:45 +0000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

for you to fetch changes up to fcbb408a1aaf426f88d8fb3b4c14e3625745b02f:

  selftests/bpf: Add host-tools to gitignore (2022-12-23 22:49:19 +0100)

----------------------------------------------------------------
bpf-for-netdev

----------------------------------------------------------------
Anton Protopopov (1):
      bpftool: Fix linkage with statically built libllvm

Hao Sun (2):
      bpf: fix nullness propagation for reg to reg comparisons
      selftests/bpf: check null propagation only neither reg is PTR_TO_BTF_ID

Hou Tao (1):
      bpf: Define sock security related BTF IDs under CONFIG_SECURITY_NETWORK

Jakub Kicinski (1):
      bpf: pull before calling skb_postpull_rcsum()

Martin KaFai Lau (1):
      selftests/bpf: Test bpf_skb_adjust_room on CHECKSUM_PARTIAL

Stanislav Fomichev (1):
      selftests/bpf: Add host-tools to gitignore

 kernel/bpf/bpf_lsm.c                               |  2 +
 kernel/bpf/verifier.c                              |  9 ++-
 net/core/filter.c                                  |  7 +-
 tools/bpf/bpftool/Makefile                         |  4 +
 tools/testing/selftests/bpf/.gitignore             |  1 +
 tools/testing/selftests/bpf/DENYLIST.s390x         |  1 +
 .../selftests/bpf/prog_tests/decap_sanity.c        | 85 ++++++++++++++++++++++
 .../selftests/bpf/prog_tests/jeq_infer_not_null.c  |  9 +++
 .../testing/selftests/bpf/progs/bpf_tracing_net.h  |  6 ++
 tools/testing/selftests/bpf/progs/decap_sanity.c   | 68 +++++++++++++++++
 .../selftests/bpf/progs/jeq_infer_not_null_fail.c  | 42 +++++++++++
 11 files changed, 231 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/decap_sanity.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/jeq_infer_not_null.c
 create mode 100644 tools/testing/selftests/bpf/progs/decap_sanity.c
 create mode 100644 tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c
