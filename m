Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C03279FC9
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 10:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgI0I5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 04:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbgI0I5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 04:57:37 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2BDC0613D4
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 01:57:37 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id j10so3864213qvk.11
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 01:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qGn1znisUnQaOcvKuKdrFs/iTj+m9zmBodDIddpjCfw=;
        b=vs1966vq013SRPr0Hgk7yGzx0yts+RipUxVm6IqXLjcwGyYRtA7RhJfLDPcxk5gaYE
         01Ef+/cvPEUFNri7eJxX94ktHnRqavG4MC0Z4kJkPgIhBJbIaIdCtDhvKnRWIdO2cyBT
         eakr3mOao76cHymdZvX2OUq8zwW8wGsyysbhfeoC6pZhGuxj05T/kL2is3tR5uihsPgu
         StYIM/z3joOwbTeX3KbLAuktP0BO2K3olA7SNI5POJK4SYpBdJKH7kBzJnoIn4G7TtAJ
         RVzN+DcdKE1gkLHzYAt/ho4PjY+zMqAzbCLMLzNUzOZUGZQXJIwoYiJ1rvi597Li5IGy
         vJpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qGn1znisUnQaOcvKuKdrFs/iTj+m9zmBodDIddpjCfw=;
        b=pVT2sVK6cVoX2lUQpuCbeuB3AqBiZIpuEknrMPbNp9FCpDDqceBGEyFyGFQA0ErqaD
         8+1fEpRQpcXsaRrWHPG11VJZdYOHvfjPK79SDohFvsTs5/tIF8YC60D8hVzHgLoioO1Y
         NSkBO+BD0iOSdqJLd+UD7NqUGpMYeJlCBOyZv8qFEgupHm2yCgwAlfcC1Xfezw+M2e97
         L+77SYQOwPVzo/wPI4RP7qiW3sH2Ep5IsrgWLzsxIoZG7/2WkjLStbWK8cD53+ExYcLJ
         EPJzyhQPH8OwTrZlctOPTM0pZC5HLn+F44YB6P3DR8VS7e52v5pqQqDgjalzPLw1xQ+V
         ToRQ==
X-Gm-Message-State: AOAM5308YrwwVQqNmCALCeSPHbPnNndjB2vNnetHe8K2jCZ8I29T/UOE
        nTYPxa7Lsf0yVJystI871X1ugAmcQnK9UmAPSO3jxA==
X-Google-Smtp-Source: ABdhPJxLk2rOri39tWKc/FSzT1zrx+EU2LkCq2QTGnSElSfcG/H2solzIVL3FU+wncsd5aHCcuB6JrMnDGOK6WkBiE0=
X-Received: by 2002:a05:6214:222:: with SMTP id j2mr7011001qvt.32.1601197055665;
 Sun, 27 Sep 2020 01:57:35 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000d73b12059608812b@google.com> <000000000000568a9105963ad7ac@google.com>
In-Reply-To: <000000000000568a9105963ad7ac@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sun, 27 Sep 2020 10:57:24 +0200
Message-ID: <CACT4Y+YBi=5Q0tpND7FKU1j1YNy1Pe+Xkgc+c_Xtf_L_pyAcqg@mail.gmail.com>
Subject: Re: WARNING in print_bfs_bug
To:     syzbot <syzbot+62ebe501c1ce9a91f68c@syzkaller.appspotmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, hawk@kernel.org,
        Ido Schimmel <idosch@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Johannes Berg <johannes.berg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        netdev <netdev@vger.kernel.org>, petrm@mellanox.com,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 9:39 PM syzbot
<syzbot+62ebe501c1ce9a91f68c@syzkaller.appspotmail.com> wrote:
>
> syzbot has found a reproducer for the following crash on:
>
> HEAD commit:    49afce6d Add linux-next specific files for 20191031
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=11eea36ce00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3c5f119b33031056
> dashboard link: https://syzkaller.appspot.com/bug?extid=62ebe501c1ce9a91f68c
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14c162f4e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=131b5eb8e00000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+62ebe501c1ce9a91f68c@syzkaller.appspotmail.com

This is another LOCKDEP-related top crasher. syzkaller finds just this
one (see below).
I think we need to disable LOCKDEP temporary until this and other
LOCKDEP issues are resolved. I've filed
https://github.com/google/syzkaller/issues/2140 to track
disabling/enabling.

2020/09/27 10:37:03 vm-12: crash: WARNING in print_bfs_bug
2020/09/27 10:37:04 VMs 33, executed 179314, corpus cover 286148,
corpus signal 641880, max signal 648495, crashes 81, repro 0
2020/09/27 10:37:13 vm-19: crash: WARNING in print_bfs_bug
2020/09/27 10:37:14 VMs 34, executed 180675, corpus cover 286544,
corpus signal 643551, max signal 650103, crashes 82, repro 0
2020/09/27 10:37:18 vm-0: crash: WARNING in print_bfs_bug
2020/09/27 10:37:19 vm-15: crash: WARNING in print_bfs_bug
2020/09/27 10:37:21 vm-10: crash: WARNING in print_bfs_bug
2020/09/27 10:37:23 vm-35: crash: WARNING in print_bfs_bug
2020/09/27 10:37:24 VMs 30, executed 181609, corpus cover 286707,
corpus signal 644444, max signal 651199, crashes 86, repro 0
2020/09/27 10:37:27 vm-21: crash: WARNING in print_bfs_bug
2020/09/27 10:37:34 VMs 29, executed 182783, corpus cover 286926,
corpus signal 645948, max signal 652593, crashes 88, repro 0
2020/09/27 10:37:44 VMs 29, executed 184015, corpus cover 287197,
corpus signal 647205, max signal 653953, crashes 88, repro 0
2020/09/27 10:37:54 VMs 29, executed 185065, corpus cover 287474,
corpus signal 648346, max signal 655028, crashes 88, repro 0
2020/09/27 10:38:06 VMs 30, executed 185678, corpus cover 287600,
corpus signal 648876, max signal 655519, crashes 88, repro 0
2020/09/27 10:38:16 VMs 35, executed 187635, corpus cover 288154,
corpus signal 652110, max signal 659120, crashes 88, repro 0
2020/09/27 10:38:19 vm-14: crash: WARNING in print_bfs_bug
2020/09/27 10:38:26 VMs 35, executed 189507, corpus cover 288492,
corpus signal 654412, max signal 661260, crashes 89, repro 0
2020/09/27 10:38:36 VMs 35, executed 190825, corpus cover 288828,
corpus signal 655751, max signal 662985, crashes 89, repro 0
2020/09/27 10:38:46 VMs 35, executed 191924, corpus cover 289050,
corpus signal 657265, max signal 664188, crashes 89, repro 0
2020/09/27 10:38:50 vm-20: crash: WARNING in print_bfs_bug
2020/09/27 10:38:52 vm-26: crash: WARNING in print_bfs_bug
2020/09/27 10:38:53 vm-22: crash: WARNING in print_bfs_bug



> ------------[ cut here ]------------
> lockdep bfs error:-1
> WARNING: CPU: 0 PID: 12077 at kernel/locking/lockdep.c:1696
> print_bfs_bug+0x5c/0x80 kernel/locking/lockdep.c:1696
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 0 PID: 12077 Comm: syz-executor941 Not tainted 5.4.0-rc5-next-20191031
> #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x172/0x1f0 lib/dump_stack.c:113
>   panic+0x2e3/0x75c kernel/panic.c:221
>   __warn.cold+0x2f/0x35 kernel/panic.c:582
>   report_bug+0x289/0x300 lib/bug.c:195
>   fixup_bug arch/x86/kernel/traps.c:174 [inline]
>   fixup_bug arch/x86/kernel/traps.c:169 [inline]
>   do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
>   do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
>   invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
> RIP: 0010:print_bfs_bug+0x5c/0x80 kernel/locking/lockdep.c:1696
> Code: 07 00 74 2d 48 c7 c7 00 5f ac 8a c6 07 00 0f 1f 40 00 85 db 75 05 5b
> 41 5c 5d c3 44 89 e6 48 c7 c7 60 1e ac 87 e8 fc ba eb ff <0f> 0b 5b 41 5c
> 5d c3 0f 0b 48 c7 c7 58 23 f3 88 e8 1f 95 56 00 eb
> RSP: 0018:ffff88813c747288 EFLAGS: 00010082
> RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff815d0816 RDI: ffffed10278e8e43
> RBP: ffff88813c747298 R08: ffff8880935244c0 R09: fffffbfff11f41ed
> R10: fffffbfff11f41ec R11: ffffffff88fa0f63 R12: 00000000ffffffff
> R13: ffff888093524d88 R14: ffff88813c747310 R15: 00000000000000de
>   check_path+0x36/0x40 kernel/locking/lockdep.c:1772
>   check_noncircular+0x16d/0x3e0 kernel/locking/lockdep.c:1797
>   check_prev_add kernel/locking/lockdep.c:2476 [inline]
>   check_prevs_add kernel/locking/lockdep.c:2581 [inline]
>   validate_chain kernel/locking/lockdep.c:2971 [inline]
>   __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3955
>   lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4487
>   __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
>   _raw_spin_lock_bh+0x33/0x50 kernel/locking/spinlock.c:175
>   spin_lock_bh include/linux/spinlock.h:343 [inline]
>   igmp6_group_dropped+0x15b/0x8c0 net/ipv6/mcast.c:704
>   ipv6_mc_down+0x64/0xf0 net/ipv6/mcast.c:2541
>   ipv6_mc_destroy_dev+0x21/0x180 net/ipv6/mcast.c:2603
>   addrconf_ifdown+0xca2/0x1220 net/ipv6/addrconf.c:3842
>   addrconf_notify+0x5db/0x23b0 net/ipv6/addrconf.c:3633
>   notifier_call_chain+0xc2/0x230 kernel/notifier.c:83
>   __raw_notifier_call_chain kernel/notifier.c:361 [inline]
>   raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:368
>   call_netdevice_notifiers_info net/core/dev.c:1893 [inline]
>   call_netdevice_notifiers_info+0xba/0x130 net/core/dev.c:1878
>   call_netdevice_notifiers_extack net/core/dev.c:1905 [inline]
>   call_netdevice_notifiers net/core/dev.c:1919 [inline]
>   rollback_registered_many+0x850/0x10d0 net/core/dev.c:8743
>   rollback_registered+0x109/0x1d0 net/core/dev.c:8788
>   register_netdevice+0xbac/0x1020 net/core/dev.c:9347
>   register_netdev+0x30/0x50 net/core/dev.c:9437
>   ip6gre_init_net+0x3ac/0x5f0 net/ipv6/ip6_gre.c:1582
>   ops_init+0xb3/0x420 net/core/net_namespace.c:137
>   setup_net+0x2d5/0x8b0 net/core/net_namespace.c:335
>   copy_net_ns+0x29e/0x520 net/core/net_namespace.c:476
>   create_new_namespaces+0x400/0x7b0 kernel/nsproxy.c:103
>   unshare_nsproxy_namespaces+0xc2/0x200 kernel/nsproxy.c:202
>   ksys_unshare+0x444/0x980 kernel/fork.c:2889
>   __do_sys_unshare kernel/fork.c:2957 [inline]
>   __se_sys_unshare kernel/fork.c:2955 [inline]
>   __x64_sys_unshare+0x31/0x40 kernel/fork.c:2955
>   do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x4439c9
> Code: Bad RIP value.
> RSP: 002b:00007ffc2b2cd878 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004439c9
> RDX: 00000000004439c9 RSI: 0000000000000000 RDI: 000000006c060000
> RBP: 0000000000000000 R08: 00000000004aaeff R09: 00000000004aaeff
> R10: 00000000004aaeff R11: 0000000000000246 R12: 0000000000000b5b
> R13: 00000000004047d0 R14: 0000000000000000 R15: 0000000000000000
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 12077 at kernel/locking/mutex.c:1419
> mutex_trylock+0x279/0x2f0 kernel/locking/mutex.c:1427
> Modules linked in:
> CPU: 0 PID: 12077 Comm: syz-executor941 Not tainted 5.4.0-rc5-next-20191031
> #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:mutex_trylock+0x279/0x2f0 kernel/locking/mutex.c:1419
> Code: c9 41 b8 01 00 00 00 31 c9 ba 01 00 00 00 31 f6 e8 3c b8 03 fa 58 48
> 8d 65 d8 b8 01 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 <0f> 0b e9 0c fe
> ff ff 48 c7 c7 a0 a1 b0 8a 48 89 4d d0 e8 f0 78 59
> RSP: 0018:ffff88813c746e48 EFLAGS: 00010006
> RAX: 0000000080000403 RBX: 1ffff110278e8dd1 RCX: 0000000000000004
> RDX: 0000000000000000 RSI: ffffffff816a6cf5 RDI: ffffffff88fc9fa0
> RBP: ffff88813c746e78 R08: 0000000000000001 R09: fffffbfff11f4751
> R10: fffffbfff11f4750 R11: ffffffff88fa3a83 R12: ffffffff8ab0a1a0
> R13: 0000000000000000 R14: ffffffff8158bb00 R15: ffffffff88fc9fa0
> FS:  00000000013d6940(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000044399f CR3: 000000013c5bf000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   __crash_kexec+0x91/0x200 kernel/kexec_core.c:948
>   panic+0x308/0x75c kernel/panic.c:241
>   __warn.cold+0x2f/0x35 kernel/panic.c:582
>   report_bug+0x289/0x300 lib/bug.c:195
>   fixup_bug arch/x86/kernel/traps.c:174 [inline]
>   fixup_bug arch/x86/kernel/traps.c:169 [inline]
>   do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
>   do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
>   invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
> RIP: 0010:print_bfs_bug+0x5c/0x80 kernel/locking/lockdep.c:1696
> Code: 07 00 74 2d 48 c7 c7 00 5f ac 8a c6 07 00 0f 1f 40 00 85 db 75 05 5b
> 41 5c 5d c3 44 89 e6 48 c7 c7 60 1e ac 87 e8 fc ba eb ff <0f> 0b 5b 41 5c
> 5d c3 0f 0b 48 c7 c7 58 23 f3 88 e8 1f 95 56 00 eb
> RSP: 0018:ffff88813c747288 EFLAGS: 00010082
> RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff815d0816 RDI: ffffed10278e8e43
> RBP: ffff88813c747298 R08: ffff8880935244c0 R09: fffffbfff11f41ed
> R10: fffffbfff11f41ec R11: ffffffff88fa0f63 R12: 00000000ffffffff
> R13: ffff888093524d88 R14: ffff88813c747310 R15: 00000000000000de
>   check_path+0x36/0x40 kernel/locking/lockdep.c:1772
>   check_noncircular+0x16d/0x3e0 kernel/locking/lockdep.c:1797
>   check_prev_add kernel/locking/lockdep.c:2476 [inline]
>   check_prevs_add kernel/locking/lockdep.c:2581 [inline]
>   validate_chain kernel/locking/lockdep.c:2971 [inline]
>   __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3955
>   lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4487
>   __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
>   _raw_spin_lock_bh+0x33/0x50 kernel/locking/spinlock.c:175
>   spin_lock_bh include/linux/spinlock.h:343 [inline]
>   igmp6_group_dropped+0x15b/0x8c0 net/ipv6/mcast.c:704
>   ipv6_mc_down+0x64/0xf0 net/ipv6/mcast.c:2541
>   ipv6_mc_destroy_dev+0x21/0x180 net/ipv6/mcast.c:2603
>   addrconf_ifdown+0xca2/0x1220 net/ipv6/addrconf.c:3842
>   addrconf_notify+0x5db/0x23b0 net/ipv6/addrconf.c:3633
>   notifier_call_chain+0xc2/0x230 kernel/notifier.c:83
>   __raw_notifier_call_chain kernel/notifier.c:361 [inline]
>   raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:368
>   call_netdevice_notifiers_info net/core/dev.c:1893 [inline]
>   call_netdevice_notifiers_info+0xba/0x130 net/core/dev.c:1878
>   call_netdevice_notifiers_extack net/core/dev.c:1905 [inline]
>   call_netdevice_notifiers net/core/dev.c:1919 [inline]
>   rollback_registered_many+0x850/0x10d0 net/core/dev.c:8743
>   rollback_registered+0x109/0x1d0 net/core/dev.c:8788
>   register_netdevice+0xbac/0x1020 net/core/dev.c:9347
>   register_netdev+0x30/0x50 net/core/dev.c:9437
>   ip6gre_init_net+0x3ac/0x5f0 net/ipv6/ip6_gre.c:1582
>   ops_init+0xb3/0x420 net/core/net_namespace.c:137
>   setup_net+0x2d5/0x8b0 net/core/net_namespace.c:335
>   copy_net_ns+0x29e/0x520 net/core/net_namespace.c:476
>   create_new_namespaces+0x400/0x7b0 kernel/nsproxy.c:103
>   unshare_nsproxy_namespaces+0xc2/0x200 kernel/nsproxy.c:202
>   ksys_unshare+0x444/0x980 kernel/fork.c:2889
>   __do_sys_unshare kernel/fork.c:2957 [inline]
>   __se_sys_unshare kernel/fork.c:2955 [inline]
>   __x64_sys_unshare+0x31/0x40 kernel/fork.c:2955
>   do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x4439c9
> Code: Bad RIP value.
> RSP: 002b:00007ffc2b2cd878 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004439c9
> RDX: 00000000004439c9 RSI: 0000000000000000 RDI: 000000006c060000
> RBP: 0000000000000000 R08: 00000000004aaeff R09: 00000000004aaeff
> R10: 00000000004aaeff R11: 0000000000000246 R12: 0000000000000b5b
> R13: 00000000004047d0 R14: 0000000000000000 R15: 0000000000000000
> irq event stamp: 149354
> hardirqs last  enabled at (149353): [<ffffffff8146110a>]
> __local_bh_enable_ip+0x15a/0x270 kernel/softirq.c:194
> hardirqs last disabled at (149351): [<ffffffff814610ca>]
> __local_bh_enable_ip+0x11a/0x270 kernel/softirq.c:171
> softirqs last  enabled at (149352): [<ffffffff864ee3d4>]
> ipv6_ac_destroy_dev+0x144/0x1b0 net/ipv6/anycast.c:402
> softirqs last disabled at (149354): [<ffffffff865cbc13>]
> ipv6_mc_down+0x23/0xf0 net/ipv6/mcast.c:2538
> ---[ end trace c8d5cabde4ea777a ]---
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 12077 at kernel/locking/mutex.c:737
> mutex_unlock+0x1d/0x30 kernel/locking/mutex.c:744
> Modules linked in:
> CPU: 0 PID: 12077 Comm: syz-executor941 Tainted: G        W
> 5.4.0-rc5-next-20191031 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:mutex_unlock+0x1d/0x30 kernel/locking/mutex.c:737
> Code: 4c 89 ff e8 45 84 59 fa e9 8c fb ff ff 55 65 8b 05 80 31 ac 78 a9 00
> ff 1f 00 48 89 e5 75 0b 48 8b 75 08 e8 45 f9 ff ff 5d c3 <0f> 0b 48 8b 75
> 08 e8 38 f9 ff ff 5d c3 66 0f 1f 44 00 00 48 b8 00
> RSP: 0018:ffff88813c746e78 EFLAGS: 00010006
> RAX: 0000000080000403 RBX: 1ffff110278e8dd1 RCX: ffffffff816a6d0d
> RDX: 0000000000000000 RSI: ffffffff816a6d6f RDI: ffffffff88fc9fa0
> RBP: ffff88813c746e78 R08: ffff8880935244c0 R09: 0000000000000000
> R10: fffffbfff11f93f4 R11: ffffffff88fc9fa7 R12: 0000000000000001
> R13: 0000000000000000 R14: ffffffff8158bb00 R15: 00000000000006a0
> FS:  00000000013d6940(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000044399f CR3: 000000013c5bf000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   __crash_kexec+0x10b/0x200 kernel/kexec_core.c:957
>   panic+0x308/0x75c kernel/panic.c:241
>   __warn.cold+0x2f/0x35 kernel/panic.c:582
>   report_bug+0x289/0x300 lib/bug.c:195
>   fixup_bug arch/x86/kernel/traps.c:174 [inline]
>   fixup_bug arch/x86/kernel/traps.c:169 [inline]
>   do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
>   do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
>   invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
> RIP: 0010:print_bfs_bug+0x5c/0x80 kernel/locking/lockdep.c:1696
> Code: 07 00 74 2d 48 c7 c7 00 5f ac 8a c6 07 00 0f 1f 40 00 85 db 75 05 5b
> 41 5c 5d c3 44 89 e6 48 c7 c7 60 1e ac 87 e8 fc ba eb ff <0f> 0b 5b 41 5c
> 5d c3 0f 0b 48 c7 c7 58 23 f3 88 e8 1f 95 56 00 eb
> RSP: 0018:ffff88813c747288 EFLAGS: 00010082
> RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff815d0816 RDI: ffffed10278e8e43
> RBP: ffff88813c747298 R08: ffff8880935244c0 R09: fffffbfff11f41ed
> R10: fffffbfff11f41ec R11: ffffffff88fa0f63 R12: 00000000ffffffff
> R13: ffff888093524d88 R14: ffff88813c747310 R15: 00000000000000de
>   check_path+0x36/0x40 kernel/locking/lockdep.c:1772
>   check_noncircular+0x16d/0x3e0 kernel/locking/lockdep.c:1797
>   check_prev_add kernel/locking/lockdep.c:2476 [inline]
>   check_prevs_add kernel/locking/lockdep.c:2581 [inline]
>   validate_chain kernel/locking/lockdep.c:2971 [inline]
>   __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3955
>   lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4487
>   __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
>   _raw_spin_lock_bh+0x33/0x50 kernel/locking/spinlock.c:175
>   spin_lock_bh include/linux/spinlock.h:343 [inline]
>   igmp6_group_dropped+0x15b/0x8c0 net/ipv6/mcast.c:704
>   ipv6_mc_down+0x64/0xf0 net/ipv6/mcast.c:2541
>   ipv6_mc_destroy_dev+0x21/0x180 net/ipv6/mcast.c:2603
>   addrconf_ifdown+0xca2/0x1220 net/ipv6/addrconf.c:3842
>   addrconf_notify+0x5db/0x23b0 net/ipv6/addrconf.c:3633
>   notifier_call_chain+0xc2/0x230 kernel/notifier.c:83
>   __raw_notifier_call_chain kernel/notifier.c:361 [inline]
>   raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:368
>   call_netdevice_notifiers_info net/core/dev.c:1893 [inline]
>   call_netdevice_notifiers_info+0xba/0x130 net/core/dev.c:1878
>   call_netdevice_notifiers_extack net/core/dev.c:1905 [inline]
>   call_netdevice_notifiers net/core/dev.c:1919 [inline]
>   rollback_registered_many+0x850/0x10d0 net/core/dev.c:8743
>   rollback_registered+0x109/0x1d0 net/core/dev.c:8788
>   register_netdevice+0xbac/0x1020 net/core/dev.c:9347
>   register_netdev+0x30/0x50 net/core/dev.c:9437
>   ip6gre_init_net+0x3ac/0x5f0 net/ipv6/ip6_gre.c:1582
>   ops_init+0xb3/0x420 net/core/net_namespace.c:137
>   setup_net+0x2d5/0x8b0 net/core/net_namespace.c:335
>   copy_net_ns+0x29e/0x520 net/core/net_namespace.c:476
>   create_new_namespaces+0x400/0x7b0 kernel/nsproxy.c:103
>   unshare_nsproxy_namespaces+0xc2/0x200 kernel/nsproxy.c:202
>   ksys_unshare+0x444/0x980 kernel/fork.c:2889
>   __do_sys_unshare kernel/fork.c:2957 [inline]
>   __se_sys_unshare kernel/fork.c:2955 [inline]
>   __x64_sys_unshare+0x31/0x40 kernel/fork.c:2955
>   do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x4439c9
> Code: Bad RIP value.
> RSP: 002b:00007ffc2b2cd878 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004439c9
> RDX: 00000000004439c9 RSI: 0000000000000000 RDI: 000000006c060000
> RBP: 0000000000000000 R08: 00000000004aaeff R09: 00000000004aaeff
> R10: 00000000004aaeff R11: 0000000000000246 R12: 0000000000000b5b
> R13: 00000000004047d0 R14: 0000000000000000 R15: 0000000000000000
> irq event stamp: 149354
> hardirqs last  enabled at (149353): [<ffffffff8146110a>]
> __local_bh_enable_ip+0x15a/0x270 kernel/softirq.c:194
> hardirqs last disabled at (149351): [<ffffffff814610ca>]
> __local_bh_enable_ip+0x11a/0x270 kernel/softirq.c:171
> softirqs last  enabled at (149352): [<ffffffff864ee3d4>]
> ipv6_ac_destroy_dev+0x144/0x1b0 net/ipv6/anycast.c:402
> softirqs last disabled at (149354): [<ffffffff865cbc13>]
> ipv6_mc_down+0x23/0xf0 net/ipv6/mcast.c:2538
> ---[ end trace c8d5cabde4ea777b ]---
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000568a9105963ad7ac%40google.com.
