Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7475964F090
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 18:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbiLPRps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 12:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbiLPRpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 12:45:46 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647D0FCD0;
        Fri, 16 Dec 2022 09:45:44 -0800 (PST)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1p6EmD-000Pne-2a; Fri, 16 Dec 2022 18:45:41 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2022-12-16
Date:   Fri, 16 Dec 2022 18:45:40 +0100
Message-Id: <20221216174540.16598-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26752/Fri Dec 16 09:25:27 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net* tree.

We've added 7 non-merge commits during the last 2 day(s) which contain
a total of 9 files changed, 119 insertions(+), 36 deletions(-).

The main changes are:

1) Fix for recent syzkaller XDP dispatcher update splat, from Jiri Olsa.

2) Fix BPF program refcount leak in LSM attachment failure path, from Milan Landaverde.

3) Fix BPF program type in map compatibility check for fext, from Toke Høiland-Jørgensen.

4) Fix a BPF selftest compilation error under !CONFIG_SMP config, from Yonghong Song.

5) Fix CI to enable CONFIG_FUNCTION_ERROR_INJECTION after it got changed to a prompt, from Song Liu.

6) Various BPF documentation fixes for socket local storage, from Donald Hunter.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Daniel Müller, David Vernet, Hao Sun, kernel test 
robot, Martin KaFai Lau, Paul E. McKenney, Stanislav Fomichev, Yonghong 
Song

----------------------------------------------------------------

The following changes since commit 7ae9888d6e1ce4062d27367a28e46a26270a3e52:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf (2022-12-13 19:32:53 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

for you to fetch changes up to f506439ec3dee11e0e77b0a1f3fb3eec22c97873:

  selftests/bpf: Add a test for using a cpumap from an freplace-to-XDP program (2022-12-14 21:30:40 -0800)

----------------------------------------------------------------
bpf-for-netdev

----------------------------------------------------------------
Donald Hunter (1):
      docs/bpf: Reword docs for BPF_MAP_TYPE_SK_STORAGE

Jiri Olsa (1):
      bpf: Synchronize dispatcher update with bpf_dispatcher_xdp_func

Milan Landaverde (1):
      bpf: prevent leak of lsm program after failed attach

Song Liu (1):
      selftests/bpf: Select CONFIG_FUNCTION_ERROR_INJECTION

Toke Høiland-Jørgensen (2):
      bpf: Resolve fext program type when checking map compatibility
      selftests/bpf: Add a test for using a cpumap from an freplace-to-XDP program

Yonghong Song (1):
      selftests/bpf: Fix a selftest compilation error with CONFIG_SMP=n

 Documentation/bpf/map_sk_storage.rst               | 56 ++++++++++++----------
 kernel/bpf/core.c                                  |  5 +-
 kernel/bpf/dispatcher.c                            |  5 ++
 kernel/bpf/syscall.c                               |  6 +--
 tools/testing/selftests/bpf/config                 |  1 +
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       | 48 +++++++++++++++++++
 .../testing/selftests/bpf/progs/freplace_progmap.c | 24 ++++++++++
 tools/testing/selftests/bpf/progs/rcu_read_lock.c  |  8 ++--
 .../selftests/bpf/progs/task_kfunc_failure.c       |  2 +-
 9 files changed, 119 insertions(+), 36 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_progmap.c
