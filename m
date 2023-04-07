Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D086DB6A7
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 00:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjDGWqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 18:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjDGWqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 18:46:48 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817C15594;
        Fri,  7 Apr 2023 15:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References;
        bh=01xCP2CTTDste1h5LyPhN95Z2+Nr+MZPOa+ogV6/F7U=; b=Q1cDslzgDOojo0eNo9JxJwb4GK
        YkpeFjsNcacts5zoqJgEYYR8DRRwoj/O0yX8Nq0yAROfT2q4L9urrwq7NXHV1RiBw2a29Y9n6pGeC
        //HFB2LOrHPvBQtbUUjTegQ+iZNWhC+hHXz0z9WlDqgRMwYEP3P5tNpKTRSPCwR64pyKlXWrULOtc
        gDb0+dTt7uZsnHhl+eMDsfm94GRWNcan7DVoQzrI3x4aKNMRnkoKQtyrvBfH3QGwRnAZkBOiJN6tB
        HSNW2oEI8GT5bh9f/kvo0+Ue1TAY6xDxKPHmZefHKyp3J4AqnpikjwVL/MZbmavimEBQm2KheXw4N
        6UND1V+A==;
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pkuqw-0007JA-PT; Sat, 08 Apr 2023 00:46:42 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2023-04-08
Date:   Sat,  8 Apr 2023 00:46:42 +0200
Message-Id: <20230407224642.30906-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26868/Fri Apr  7 09:23:08 2023)
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net* tree.

We've added 4 non-merge commits during the last 11 day(s) which contain
a total of 5 files changed, 39 insertions(+), 6 deletions(-).

The main changes are:

1) Fix BPF TCP socket iterator to use correct helper for dropping socket's refcount,
   that is, sock_gen_put instead of sock_put, from Martin KaFai Lau.

2) Fix a BTI exception splat in BPF trampoline-generated code on arm64, from Xu Kuohai.

3) Fix a LongArch JIT error from missing BPF_NOSPEC no-op, from George Guo.

4) Fix dynamic XDP feature detection of veth in xdp_redirect selftest, from Lorenzo Bianconi.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Florent Revest, WANG Xuerui

----------------------------------------------------------------

The following changes since commit 45977e58ce65ed0459edc9a0466d9dfea09463f5:

  net: dsa: b53: mmap: add phy ops (2023-03-27 08:31:34 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

for you to fetch changes up to 919e659ed12568b5b8ba6c2ffdd82d8d31fc28af:

  selftests/bpf: fix xdp_redirect xdp-features selftest for veth driver (2023-04-06 09:35:09 -0700)

----------------------------------------------------------------
bpf-for-netdev

----------------------------------------------------------------
George Guo (1):
      LoongArch, bpf: Fix jit to skip speculation barrier opcode

Lorenzo Bianconi (1):
      selftests/bpf: fix xdp_redirect xdp-features selftest for veth driver

Martin KaFai Lau (1):
      bpf: tcp: Use sock_gen_put instead of sock_put in bpf_iter_tcp

Xu Kuohai (1):
      bpf, arm64: Fixed a BTI error on returning to patched function

 arch/arm64/net/bpf_jit.h                           |  4 +++
 arch/arm64/net/bpf_jit_comp.c                      |  3 ++-
 arch/loongarch/net/bpf_jit.c                       |  4 +++
 net/ipv4/tcp_ipv4.c                                |  4 +--
 .../selftests/bpf/prog_tests/xdp_do_redirect.c     | 30 +++++++++++++++++++---
 5 files changed, 39 insertions(+), 6 deletions(-)
