Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5B7B544004
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 01:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbiFHXmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 19:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235378AbiFHXl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 19:41:58 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F185C1BD7EA;
        Wed,  8 Jun 2022 16:41:36 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nz5Is-000FJP-5n; Thu, 09 Jun 2022 01:41:34 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2022-06-09
Date:   Thu,  9 Jun 2022 01:41:33 +0200
Message-Id: <20220608234133.32265-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26566/Wed Jun  8 10:05:45 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net* tree.

We've added 6 non-merge commits during the last 2 day(s) which contain
a total of 8 files changed, 49 insertions(+), 15 deletions(-).

The main changes are:

1) Fix an illegal copy_to_user() attempt seen by syzkaller through arm64
   BPF JIT compiler, from Eric Dumazet.

2) Fix calling global functions from BPF_PROG_TYPE_EXT programs by using
   the correct program context type, from Toke Høiland-Jørgensen.

3) Fix XSK TX batching invalid descriptor handling, from Maciej Fijalkowski.

4) Fix potential integer overflows in multi-kprobe link code by using safer
   kvmalloc_array() allocation helpers, from Dan Carpenter.

5) Add Quentin as bpftool maintainer, from Quentin Monnet.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Jakub Kicinski, KP Singh, Magnus Karlsson, Simon 
Sundberg, Song Liu, syzbot

----------------------------------------------------------------

The following changes since commit cf67838c4422eab826679b076dad99f96152b4de:

  selftests net: fix bpf build error (2022-06-07 13:19:51 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 7c217aca85dd31dd2c8f45f6a7520767c9fae766:

  MAINTAINERS: Add a maintainer for bpftool (2022-06-08 17:16:34 +0200)

----------------------------------------------------------------
Dan Carpenter (1):
      bpf: Use safer kvmalloc_array() where possible

Eric Dumazet (1):
      bpf, arm64: Clear prog->jited_len along prog->jited

Maciej Fijalkowski (1):
      xsk: Fix handling of invalid descriptors in XSK TX batching API

Quentin Monnet (1):
      MAINTAINERS: Add a maintainer for bpftool

Toke Høiland-Jørgensen (2):
      bpf: Fix calling global functions from BPF_PROG_TYPE_EXT programs
      selftests/bpf: Add selftest for calling global functions from freplace

 MAINTAINERS                                            |  7 +++++++
 arch/arm64/net/bpf_jit_comp.c                          |  1 +
 kernel/bpf/btf.c                                       |  3 ++-
 kernel/trace/bpf_trace.c                               |  8 ++++----
 net/xdp/xsk.c                                          |  5 +++--
 net/xdp/xsk_queue.h                                    |  8 --------
 tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c | 14 ++++++++++++++
 .../testing/selftests/bpf/progs/freplace_global_func.c | 18 ++++++++++++++++++
 8 files changed, 49 insertions(+), 15 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_global_func.c
