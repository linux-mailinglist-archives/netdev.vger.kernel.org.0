Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A56433663
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 14:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbhJSM4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 08:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhJSM4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 08:56:39 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5E5C06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 05:54:25 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 5so12153864edw.7
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 05:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=kHRyb3T+qamddAp9cLynID5NLJ6FfaF3XyicNPvPyEI=;
        b=kloAA//XaI2scnZmIHxbPch8wyZX1ANlByyqPT+1BHf/GhwIMJHR7/N+/uN0gQK/0g
         KsSHlstZvEpI5TqCh3U7aRhBaEDwKIntCiiv4Oz+zXr675vfT1Ixs5Bj3eaw52BfSuX1
         qRjcbCyAg0QwhoeTX5M1BIVuUPABDBKjLVlt3KsHhWRPbQERgaLBZv2MV68ih/7XoP2/
         HlXlavaCKiGgEfS9cDVk+G/+eA1XE9ybUBZbJb8aK1inx6Lcq1cuCqb+CpVp0THXH1wq
         RO530m2/x9cNy9ZTmzMyZE7X8mDDmsHfeOpMX2vmx7yrTSbDcC5qHXHY/TPrzKUBh0vP
         1dPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=kHRyb3T+qamddAp9cLynID5NLJ6FfaF3XyicNPvPyEI=;
        b=D5+UvCApfXBb0tbHfN6N+XUKZm4kex+4UQi0uQAeB2nJnRrps26HPIU40T9vd+uzeV
         0cTwOKVUUqFb/eYPuMY39A2ICT5np/N4iPPvxakeOiJxLK53u6BuIkFFh8iXggynN1Wd
         wE7yvYwHx3OIozMo5cyJUMFVLub1nES698ewIHuyfVCK+gO5k0g6dBuMKM5fR0DGbmyo
         fet0XzIj2nQ5aOoRvhUQuvTJ+lh2t2YqbUaRNaW3eBFWHFrmTEtRPIeT9R+FDuYf+9X3
         L3VhXDQCz2Ik/oVqXkoh7NWnJqYbkNjUY5NUsbI61MUD/9OlmsFBeImZ1Pr2qGzowjl/
         Dcig==
X-Gm-Message-State: AOAM533RgUXwk5s+QXrgPNOnHCzG+pPpyLOzyR4R61Nd/H+0DhnbMpy3
        Pls2MLRzHGYNsFLOSCKhmuUjwHo8LwxjGPKb7ccamQ==
X-Google-Smtp-Source: ABdhPJxEw0ShxbPahbMOQkBJ4LTtwgUGU1HhWjzbq9TYIqT2JLuOrMhnR2uoHfH+SG6RXr7JdATbZsArRrubcRI5u4Q=
X-Received: by 2002:a50:9993:: with SMTP id m19mr52700855edb.357.1634648061101;
 Tue, 19 Oct 2021 05:54:21 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 19 Oct 2021 18:24:09 +0530
Message-ID: <CA+G9fYuY3BJ9osvhwg0-YG=L+etgCBfCq0koC9BEkvK8-GR3ew@mail.gmail.com>
Subject: [next] BUG: kernel NULL pointer dereference, address:: selinux_ip_postroute_compat
To:     open list <linux-kernel@vger.kernel.org>, selinux@vger.kernel.org,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org
Cc:     Florian Westphal <fw@strlen.de>, Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following kernel crash noticed on linux next 20211019 tag.
on x86, i386 and other architectures.

[   15.197596] BUG: kernel NULL pointer dereference, address: 0000000000000290
[   15.204577] #PF: supervisor read access in kernel mode
[   15.204581] #PF: error_code(0x0000) - not-present page
[   15.204585] PGD 0 P4D 0
[   15.204592] Oops: 0000 [#1] PREEMPT SMP PTI
[   15.204597] CPU: 2 PID: 352 Comm: systemd-resolve Not tainted
5.15.0-rc6-next-20211019 #1
[   15.204604] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.2 05/23/2018
[   15.204607] RIP: 0010:selinux_ip_postroute_compat+0x55/0x110
[   15.242847] Code: 48 89 45 e8 31 c0 48 83 7a 18 00 f3 48 ab 0f 84
96 00 00 00 48 8b 43 18 48 85 c0 74 0d 0f b6 48 12 80 f9 0c 0f 84 a9
00 00 00 <4c> 8b a0 90 02 00 00 48 8b 42 10 31 c9 48 89 df 48 89 75 98
4c 8d
[   15.261592] RSP: 0018:ffffb8fc0077f890 EFLAGS: 00010246
[   15.266810] RAX: 0000000000000000 RBX: ffffa31a82ee7200 RCX: 0000000000000000
[   15.273933] RDX: ffffb8fc0077fa18 RSI: ffffb8fc0077f8b8 RDI: ffffb8fc0077f8f0
[   15.281059] RBP: ffffb8fc0077f908 R08: ffffb8fc0077f960 R09: 0000000000000000
[   15.288180] R10: 0000000000000000 R11: ffffb8fc0077fb70 R12: ffffa31a82ee7200
[   15.295305] R13: ffffb8fc0077fa18 R14: ffffa31a82ee7200 R15: ffffb8fc0077fa18
[   15.302428] FS:  00007fc366df0840(0000) GS:ffffa31befb00000(0000)
knlGS:0000000000000000
[   15.310507] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   15.316242] CR2: 0000000000000290 CR3: 0000000107660002 CR4: 00000000003706e0
[   15.323367] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   15.330492] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   15.337615] Call Trace:
[   15.340061]  <TASK>
[   15.342157]  ? alloc_skb_with_frags+0x4e/0x1b0
[   15.346603]  ? _copy_from_iter+0xcd/0x5f0
[   15.350614]  selinux_ip_postroute+0x18f/0x4a0
[   15.354964]  ? ip_generic_getfrag+0x53/0xe0
[   15.359145]  nf_hook_slow+0x44/0xb0
[   15.362635]  ip_mc_output+0x184/0x310
[   15.366292]  ? ip_frag_next+0x184/0x190
[   15.370123]  ? ip_fraglist_init+0xb0/0xb0
[   15.374128]  ip_send_skb+0x8b/0x90
[   15.377533]  udp_send_skb+0x166/0x390
[   15.381192]  udp_sendmsg+0x9a6/0xb80
[   15.384769]  ? ip_frag_init+0x60/0x60
[   15.388427]  ? sock_def_readable+0x50/0x90
[   15.392517]  ? unix_stream_sendmsg+0x5a3/0x640
[   15.396956]  ? __switch_to+0x12e/0x490
[   15.400708]  ? _copy_from_user+0x2e/0x60
[   15.404633]  inet_sendmsg+0x65/0x70
[   15.408116]  ? inet_sendmsg+0x65/0x70
[   15.411776]  sock_sendmsg+0x5e/0x70
[   15.415267]  ____sys_sendmsg+0x22d/0x280
[   15.419192]  ___sys_sendmsg+0x81/0xc0
[   15.422851]  ? preempt_count_sub+0xba/0x100
[   15.427062]  ? debug_smp_processor_id+0x17/0x20
[   15.431595]  ? get_nohz_timer_target+0x1b/0x1b0
[   15.436128]  ? timerqueue_add+0x6e/0xc0
[   15.439968]  ? _raw_spin_unlock_irqrestore+0x24/0x40
[   15.444932]  ? __fdget+0x13/0x20
[   15.448156]  ? do_epoll_wait+0x84/0x750
[   15.451987]  __sys_sendmsg+0x62/0xb0
[   15.455557]  ? syscall_trace_enter.constprop.0+0x14c/0x1e0
[   15.461037]  __x64_sys_sendmsg+0x1d/0x20
[   15.464960]  do_syscall_64+0x3b/0x90
[   15.468531]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   15.473576] RIP: 0033:0x7fc36620b711
[   15.477153] Code: b5 78 20 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff
eb b6 0f 1f 80 00 00 00 00 8b 05 da bc 20 00 85 c0 75 16 b8 2e 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 57 c3 66 0f 1f 44 00 00 41 54 41 89 d4
55 48
[   15.495890] RSP: 002b:00007fff5eab9cd8 EFLAGS: 00000246 ORIG_RAX:
000000000000002e
[   15.503476] RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007fc36620b711
[   15.510598] RDX: 0000000000000000 RSI: 00007fff5eab9d20 RDI: 000000000000000b
[   15.517721] RBP: 00007fff5eab9d20 R08: 00007fff5eab9e80 R09: 00000000000014eb
[   15.524845] R10: 0000000000003d34 R11: 0000000000000246 R12: 00007fff5eab9e80
[   15.531971] R13: 0000000000000002 R14: 0000000000000002 R15: 000000000000000b
[   15.539096]  </TASK>
[   15.541278] Modules linked in: x86_pkg_temp_thermal
[   15.546148] CR2: 0000000000000290
[   15.549460] ---[ end trace 2e081564e8f528df ]---
[   15.554069] RIP: 0010:selinux_ip_postroute_compat+0x55/0x110


Full log,
https://qa-reports.linaro.org/lkft/linux-next-master-sanity/build/next-20211019/testrun/6166857/suite/linux-log-parser/test/check-kernel-bug-3781895/log

Build config:
https://builds.tuxbuild.com/1ziJHznpBT84rIGZ2HgbY9CVlQ1/config

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


steps to reproduce:
https://builds.tuxbuild.com/1ziJHznpBT84rIGZ2HgbY9CVlQ1/tuxmake_reproducer.sh

--
Linaro LKFT
https://lkft.linaro.org
