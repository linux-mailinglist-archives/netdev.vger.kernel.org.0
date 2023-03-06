Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76A816AD0F2
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjCFV7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:59:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjCFV7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:59:50 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD1830B11;
        Mon,  6 Mar 2023 13:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References;
        bh=9krJC+d6KdtSVhw+S+bARJ3dT9lSipd8wVgn1fqdZmM=; b=Syn95mgaWpOsNKknHfZTzzv0c5
        JhyUArhFrv8OEa0TW3E6B3p9aRYfwNo9/YTD4gbReoVjYSs6KREZmFCXmiAPan4vWpI25AqdvnYXt
        GuEtjW0aR8frV8/1dNSv+HKVw96sANU4cTZ4zrU6g3KAvaChxvqOiPQ2lQ5DrIS7oYLLKGcueCFko
        vETnyj/L+6GaJqXt3TLs+6MW4a2pazAVvjbaGIUPFhQxZg8m2ruteBVwN1BBOZxCj/cR0t7AkcPLX
        9TlwSguQYFEgNQTMtrpBgQWiKkvJxvJQlna7Ekjw+jsZzPkpvlTCeDVb5uTNcpIBitWDKjysxdG/j
        RHt82Q7w==;
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pZIrx-0009Ij-5A; Mon, 06 Mar 2023 22:59:45 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2023-03-06
Date:   Mon,  6 Mar 2023 22:59:44 +0100
Message-Id: <20230306215944.11981-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26833/Mon Mar  6 09:22:59 2023)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net* tree.

We've added 8 non-merge commits during the last 7 day(s) which contain
a total of 9 files changed, 64 insertions(+), 18 deletions(-).

The main changes are:

1) Fix BTF resolver for DATASEC sections when a VAR points at a modifier, that
   is, keep resolving such instances instead of bailing out, from Lorenz Bauer.

2) Fix BPF test framework with regards to xdp_frame info misplacement in the
   "live packet" code, from Alexander Lobakin.

3) Fix an infinite loop in BPF sockmap code for TCP/UDP/AF_UNIX, from Liu Jian.

4) Fix a build error for riscv BPF JIT under PERF_EVENTS=n, from Randy Dunlap.

5) Several BPF doc fixes with either broken links or external instead of internal
   doc links, from Bagas Sanjaya.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Björn Töpel, John Fastabend, kernel test robot, Pu Lehui, Ross Zwisler, 
Toke Høiland-Jørgensen

----------------------------------------------------------------

The following changes since commit 580f98cc33a260bb8c6a39ae2921b29586b84fdf:

  tcp: tcp_check_req() can be called from process context (2023-02-27 11:59:29 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

for you to fetch changes up to 32dfc59e43019e43deab7afbfff37a2f9f17a222:

  Merge branch 'fix resolving VAR after DATASEC' (2023-03-06 11:44:14 -0800)

----------------------------------------------------------------
bpf-for-netdev

----------------------------------------------------------------
Alexander Lobakin (1):
      bpf, test_run: fix &xdp_frame misplacement for LIVE_FRAMES

Bagas Sanjaya (3):
      bpf, docs: Fix link to BTF doc
      bpf, doc: Do not link to docs.kernel.org for kselftest link
      bpf, doc: Link to submitting-patches.rst for general patch submission info

Liu Jian (1):
      bpf, sockmap: Fix an infinite loop error when len is 0 in tcp_bpf_recvmsg_parser()

Lorenz Bauer (2):
      btf: fix resolving BTF_KIND_VAR after ARRAY, STRUCT, UNION, PTR
      selftests/bpf: check that modifier resolves after pointer

Martin KaFai Lau (1):
      Merge branch 'fix resolving VAR after DATASEC'

Randy Dunlap (1):
      riscv, bpf: Fix patch_text implicit declaration

 Documentation/bpf/bpf_devel_QA.rst                 | 14 ++++-------
 arch/riscv/net/bpf_jit_comp64.c                    |  1 +
 kernel/bpf/btf.c                                   |  1 +
 net/bpf/test_run.c                                 | 19 ++++++++++-----
 net/ipv4/tcp_bpf.c                                 |  6 +++++
 net/ipv4/udp_bpf.c                                 |  3 +++
 net/unix/unix_bpf.c                                |  3 +++
 tools/testing/selftests/bpf/prog_tests/btf.c       | 28 ++++++++++++++++++++++
 .../selftests/bpf/prog_tests/xdp_do_redirect.c     |  7 +++---
 9 files changed, 64 insertions(+), 18 deletions(-)
