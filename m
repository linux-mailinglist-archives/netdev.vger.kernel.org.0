Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023775A1CE4
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 01:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237834AbiHYXAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 19:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiHYXAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 19:00:38 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE0B13CE5;
        Thu, 25 Aug 2022 16:00:36 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1oRLpx-000EQm-SZ; Fri, 26 Aug 2022 01:00:33 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2022-08-26
Date:   Fri, 26 Aug 2022 01:00:33 +0200
Message-Id: <20220825230033.3051-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26638/Thu Aug 25 09:54:06 2022)
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

We've added 11 non-merge commits during the last 14 day(s) which contain
a total of 13 files changed, 61 insertions(+), 24 deletions(-).

The main changes are:

1) Fix BPF verifier's precision tracking around BPF ring buffer, from Kumar Kartikeya Dwivedi.

2) Fix regression in tunnel key infra when passing FLOWI_FLAG_ANYSRC, from Eyal Birger.

3) Fix insufficient permissions for bpf_sys_bpf() helper, from YiFei Zhu.

4) Fix splat from hitting BUG when purging effective cgroup programs, from Pu Lehui.

5) Fix range tracking for array poke descriptors, from Daniel Borkmann.

6) Fix corrupted packets for XDP_SHARED_UMEM in aligned mode, from Magnus Karlsson.

7) Fix NULL pointer splat in BPF sockmap sk_msg_recvmsg(), from Liu Jian.

8) Add READ_ONCE() to bpf_jit_limit when reading from sysctl, from Kuniyuki Iwashima.

9) Add BPF selftest lru_bug check to s390x deny list, from Daniel Müller.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alasdair McWilliam, Alexei Starovoitov, Andrii Nakryiko, Dave 
Marchevsky, Hsin-Wei Hung, Intrusion Shield Team, Jakub Sitnicki, John 
Fastabend, Maciej Fijalkowski, Mykola Lysenko, Paul Chaignon

----------------------------------------------------------------

The following changes since commit 40b4ac880e21d917da7f3752332fa57564a4c202:

  net: lan966x: fix checking for return value of platform_get_irq_byname() (2022-08-12 11:29:46 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to a657182a5c5150cdfacb6640aad1d2712571a409:

  bpf: Don't use tnum_range on array range checking for poke descriptors (2022-08-25 14:58:30 -0700)

----------------------------------------------------------------
Alexei Starovoitov (1):
      Merge branch 'Fix incorrect pruning for ARG_CONST_ALLOC_SIZE_OR_ZERO'

Daniel Borkmann (2):
      bpf: Partially revert flexible-array member replacement
      bpf: Don't use tnum_range on array range checking for poke descriptors

Daniel Müller (1):
      selftests/bpf: Add lru_bug to s390x deny list

Eyal Birger (1):
      ip_tunnel: Respect tunnel key's "flow_flags" in IP tunnels

Kumar Kartikeya Dwivedi (2):
      bpf: Do mark_chain_precision for ARG_CONST_ALLOC_SIZE_OR_ZERO
      selftests/bpf: Add regression test for pruning fix

Kuniyuki Iwashima (1):
      bpf: Fix a data-race around bpf_jit_limit.

Liu Jian (1):
      skmsg: Fix wrong last sg check in sk_msg_recvmsg()

Magnus Karlsson (1):
      xsk: Fix corrupted packets for XDP_SHARED_UMEM

Pu Lehui (1):
      bpf, cgroup: Fix kernel BUG in purge_effective_progs

YiFei Zhu (1):
      bpf: Restrict bpf_sys_bpf to CAP_PERFMON

 .../net/ethernet/mellanox/mlxsw/spectrum_span.c    |  3 ++-
 include/net/ip_tunnels.h                           |  4 +++-
 include/uapi/linux/bpf.h                           |  2 +-
 kernel/bpf/cgroup.c                                |  4 +++-
 kernel/bpf/core.c                                  |  2 +-
 kernel/bpf/syscall.c                               |  2 +-
 kernel/bpf/verifier.c                              | 13 +++++------
 net/core/skmsg.c                                   |  4 ++--
 net/ipv4/ip_gre.c                                  |  2 +-
 net/ipv4/ip_tunnel.c                               |  7 +++---
 net/xdp/xsk_buff_pool.c                            | 16 ++++++++------
 tools/testing/selftests/bpf/DENYLIST.s390x         |  1 +
 tools/testing/selftests/bpf/verifier/precise.c     | 25 ++++++++++++++++++++++
 13 files changed, 61 insertions(+), 24 deletions(-)
