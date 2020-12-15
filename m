Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA212DA62C
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 03:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgLOCVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 21:21:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgLOCVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 21:21:24 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0688C061793
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 18:20:43 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id 6so10806428ejz.5
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 18:20:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=oMx/l1TWqLqZ87BIv8Db4rdtLPwWK2RH0Vdx3gdzwC4=;
        b=gsEdjSs8ZdW0UOmW7MRRgqq5TZ7+FCQ+umrKB5cfQEr9l2RLAV8jozVgPHmqi0cbHE
         MZ3gRaxd5Iqycq1rdyIhUXT5/xiK2M7zpC3R+yH8Z2VI4xQ0cOfKNnEnfaC9O4KfM8yV
         9+QHff8lRJVZNm51Avdwol9WNcYE0yZGIwcyaPxMJbOym2GKTTAGI3hYMslQ8SthoFnK
         azXT1P8cH1uOJ6zOXD3M/LEbFAX8VFbFYNpgj23Gn0aFnp3NrtcZRNckED1Yta9+8/eo
         QI05nPGdsxppf38OYg1d3icqfN4QLnA4XPC0Op0jAq8OeEn/VVg/epq3xEEfy68bwEja
         2WjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=oMx/l1TWqLqZ87BIv8Db4rdtLPwWK2RH0Vdx3gdzwC4=;
        b=YyaW0hYpM4tSjOUtfcdH6sJ4nGrbN9pLpBp9mGjqjybnkm1jVGrUHBfyhg9/d3si41
         2vIGUGDsHv21xzX1xOhcRCcYvGSIdi52ZmHITZ4INH1aaj8hsXr4gLqomc0fJysQg3dC
         I1/TIWGN09noJpAFo4a8sZLoWyvzhrEljRsZfJk+/q6B6aOC6g7EqmTAoMVOgKcMuh8D
         fPTjIIPHbYC3NHuj803k8I2XQciXZgAgpdmI0cbgqrPYORPdApsdSDHZ1i1db0hTX4D8
         jCVWY0Paz4xa4Gh0QOwSfLvZOx7oTUcBpk6c722oVdAvhSiI6W/RIfgHeA7QY0LjLrSC
         CuQQ==
X-Gm-Message-State: AOAM530XLW5psvnLI1XYIPt8pRNVHF7d4xj+74/3w9MZ1K2UEPYCxkXB
        ex7ueol5HZ6MNPXwEszLdZUcQs+VaIqNTUdSXx1Z0Q==
X-Google-Smtp-Source: ABdhPJz9NO/Whj0QD2Y/oUA31StdDEGmpCwP6JNJ5pbO7Ty43A3K8NF3WHn28WsS20EZKQFQBeO2yZEgCXoRx7mftcI=
X-Received: by 2002:a17:906:2ec3:: with SMTP id s3mr24180480eji.133.1607998842290;
 Mon, 14 Dec 2020 18:20:42 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Dec 2020 07:50:31 +0530
Message-ID: <CA+G9fYtu1zOz8ErUzftNG4Dc9=cv1grsagBojJraGhm4arqXyw@mail.gmail.com>
Subject: [stabe-rc 5.9 ] sched: core.c:7270 Illegal context switch in RCU-bh
 read-side critical section!
To:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>, rcu@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        lkft-triage@lists.linaro.org, Netdev <netdev@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two warnings "WARNING: suspicious RCU usage" noticed on arm64 juno-r2
device while running selftest bpf test_tc_edt.sh and net: udpgro_bench.sh.
These warnings are occurring intermittently.

metadata:
  git branch: linux-5.9.y
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git describe: v5.9.14-106-g609d95a95925
  make_kernelversion: 5.9.15-rc1
  kernel-config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/juno/lkft/linux-stable-rc-5.9/58/config


Steps to reproduce:
------------------
Not easy to reproduce.

Crash log:
--------------
# selftests: bpf: test_tc_edt.sh
[  503.796362]
[  503.797960] =============================
[  503.802131] WARNING: suspicious RCU usage
[  503.806232] 5.9.15-rc1 #1 Tainted: G        W
[  503.811358] -----------------------------
[  503.815444] /usr/src/kernel/kernel/sched/core.c:7270 Illegal
context switch in RCU-bh read-side critical section!
[  503.825858]
[  503.825858] other info that might help us debug this:
[  503.825858]
[  503.833998]
[  503.833998] rcu_scheduler_active = 2, debug_locks = 1
[  503.840981] 3 locks held by kworker/u12:1/157:
[  503.845514]  #0: ffff0009754ed538
((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x208/0x768
[  503.855048]  #1: ffff800013e63df0 (net_cleanup_work){+.+.}-{0:0},
at: process_one_work+0x208/0x768
[  503.864201]  #2: ffff8000129fe3f0 (pernet_ops_rwsem){++++}-{3:3},
at: cleanup_net+0x64/0x3b8
[  503.872786]
[  503.872786] stack backtrace:
[  503.877229] CPU: 1 PID: 157 Comm: kworker/u12:1 Tainted: G        W
        5.9.15-rc1 #1
[  503.885433] Hardware name: ARM Juno development board (r2) (DT)
[  503.891382] Workqueue: netns cleanup_net
[  503.895324] Call trace:
[  503.897786]  dump_backtrace+0x0/0x1f8
[  503.901464]  show_stack+0x2c/0x38
[  503.904796]  dump_stack+0xec/0x158
[  503.908215]  lockdep_rcu_suspicious+0xd4/0xf8
[  503.912591]  ___might_sleep+0x1e4/0x208
[  503.916444]  inet_twsk_purge+0x144/0x378
[  503.920384]  tcpv6_net_exit_batch+0x20/0x28
[  503.924585]  ops_exit_list.isra.10+0x78/0x88
[  503.928872]  cleanup_net+0x248/0x3b8
[  503.932462]  process_one_work+0x2b0/0x768
[  503.936487]  worker_thread+0x48/0x498
[  503.940166]  kthread+0x158/0x168
[  503.943409]  ret_from_fork+0x10/0x1c
[  504.165891] IPv6: ADDRCONF(NETDEV_CHANGE): veth_src: link becomes ready
[  504.459624] audit: type=1334 audit(1607978673.070:40866):
prog-id=20436 op=LOAD
<>
[  879.304684]
[  879.306200] =============================
[  879.310314] WARNING: suspicious RCU usage
[  879.314420] 5.9.15-rc1 #1 Tainted: G        W
[  879.319554] -----------------------------
[  879.323644] /usr/src/kernel/kernel/sched/core.c:7270 Illegal
context switch in RCU-sched read-side critical section!
[  879.334259]
[  879.334259] other info that might help us debug this:
[  879.334259]
[  879.342345]
[  879.342345] rcu_scheduler_active = 2, debug_locks = 1
[  879.348958] 3 locks held by kworker/u12:8/248:
[  879.353483]  #0: ffff0009754ed538
((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x208/0x768
[  879.362910]  #1: ffff800013bc3df0 (net_cleanup_work){+.+.}-{0:0},
at: process_one_work+0x208/0x768
[  879.371984]  #2: ffff8000129fe3f0 (pernet_ops_rwsem){++++}-{3:3},
at: cleanup_net+0x64/0x3b8
[  879.380540]
[  879.380540] stack backtrace:
[  879.384998] CPU: 1 PID: 248 Comm: kworker/u12:8 Tainted: G        W
        5.9.15-rc1 #1
[  879.393201] Hardware name: ARM Juno development board (r2) (DT)
[  879.399147] Workqueue: netns cleanup_net
[  879.403089] Call trace:
[  879.405550]  dump_backtrace+0x0/0x1f8
[  879.409228]  show_stack+0x2c/0x38
[  879.412561]  dump_stack+0xec/0x158
# ud[  879.415980]  lockdep_rcu_suspicious+0xd4/0xf8
[  879.420691]  ___might_sleep+0x1ac/0x208
p tx:     32 MB/s      546 calls/[  879.424570]
nf_ct_iterate_cleanup+0x1b8/0x2d8 [nf_conntrack]
s    546 msg/s[  879.433190]  nf_conntrack_cleanup_net_list+0x58/0x100
[nf_conntrack]

[  879.440765]  nf_conntrack_pernet_exit+0xa8/0xb8 [nf_conntrack]
[  879.446755]  ops_exit_list.isra.10+0x78/0x88
[  879.451043]  cleanup_net+0x248/0x3b8
[  879.454635]  process_one_work+0x2b0/0x768
[  879.458661]  worker_thread+0x48/0x498
[  879.462340]  kthread+0x158/0x168
[  879.465584]  ret_from_fork+0x10/0x1c


Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Full test log link,
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.9.y/build/v5.9.14-106-g609d95a95925/testrun/3586574/suite/linux-log-parser/test/check-kernel-warning-2049484/log


-- 
Linaro LKFT
https://lkft.linaro.org
