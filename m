Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9147483E95
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 09:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiADI6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 03:58:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiADI6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 03:58:43 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205BBC061761;
        Tue,  4 Jan 2022 00:58:42 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id e202so63397452ybf.4;
        Tue, 04 Jan 2022 00:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ey+xFkooJp9+GeUZ+RsCUSLd7QSZ0BJyawhvjZPHjNM=;
        b=ODg2ad0OPGcnqnkStzZGaKwatUL/316MTC23ilne1J3XscHX9osfVUM+74RCEL2AX+
         P3hlJbDX+Drd7BR7OGb0AYNV8R7Us3MTZXpL9meDNenXoKfWm8mx81o/tuyXFXFJLOYz
         dbh1GmcXf5PNwcqibrk+3OnVuLzc0jBePGFUqC2MxeV1CiL//oj/30zbS3Ui7KE0V1tF
         Y4dhbjiD5kw8WEugf9v+td2NpkDnuOYES7IJJZ1Id5uFZFnW5P0QLgpa4IyZ3JMBszdh
         1DK/y2eRfF69iGRX0zEx33ldoSfcxRSMWkBGzimqjPp9sRcicKRhu29RaQNKVrm6izvr
         XEEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ey+xFkooJp9+GeUZ+RsCUSLd7QSZ0BJyawhvjZPHjNM=;
        b=Hl14lGuydlPnZIBse2RXc7QXqvCeEUb4dzDkVQNojld9E6s++KRMj02C/Fy+SnBOm8
         Aq+7+sCyDKG7YvbIppLWv9i8xebnTWd3AVVYvxA/9dyht9zh6aQJ496mdgHbMQRFnHQC
         FRVtjHyQuMmSoY6bA+hGw1NskvEFr8Ctbfl15f0wUFOkJv21kgbaodZG4gk+mHt4yJ1J
         b0UN5Na8WPA0iqMmAxSg986Yumgcq0JsHQV+yiMhzPg9BuaZKzU5LWKfOVu6WeWJ/yJ3
         34k9cGiXOB/cTmDo73i9NtyJjKd57WJgo3Q4FyV/JSOppSH9b59u4ePi4EFdzuq7KB2Y
         fc5Q==
X-Gm-Message-State: AOAM530tEt+eFPWacSeO7b1ti6f5J5VfmHKltz01yg/Thvamghau0bN/
        1MbS6XSvbiirKJvO/utVN25x6KjmhrUQjcGb1t8=
X-Google-Smtp-Source: ABdhPJz0gwRZV14Jois4S/6e7ydav2r51eB95xMlK0y+D9g7WLvngilpee4Ki5/3trSotwjoue9nARG17X1Dci9WeaA=
X-Received: by 2002:a25:3006:: with SMTP id w6mr65271123ybw.691.1641286720363;
 Tue, 04 Jan 2022 00:58:40 -0800 (PST)
MIME-Version: 1.0
From:   kvartet <xyru1999@gmail.com>
Date:   Tue, 4 Jan 2022 16:58:29 +0800
Message-ID: <CAFkrUshGjc80_XdUoRhe8DfoVsyff-Gx+fHoc8pccj_qimHHjA@mail.gmail.com>
Subject: INFO: task hung in connmark_exit_net
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     sunhao.th@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

When using Syzkaller to fuzz the latest Linux kernel, the following
crash was triggered.

HEAD commit: a7904a538933 Linux 5.16-rc6
git tree: upstream
console output: https://paste.ubuntu.com/p/8NMnbjRXhQ/plain/
kernel config: https://paste.ubuntu.com/p/FDDNHDxtwz/plain/

Sorry, I don't have a reproducer for this crash, hope the symbolized
report can help.
If you fix this issue, please add the following tag to the commit:
Reported-by: Yiru Xu <xyru1999@gmail.com>


INFO: task kworker/u8:1:10 blocked for more than 143 seconds.
      Not tainted 5.16.0-rc6 #9
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u8:1    state:D stack:26360 pid:   10 ppid:     2 flags:0x00004000
Workqueue: netns cleanup_net

Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xcd9/0x2530 kernel/sched/core.c:6253
 schedule+0xd2/0x260 kernel/sched/core.c:6326
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6385
 __mutex_lock_common kernel/locking/mutex.c:680 [inline]
 __mutex_lock+0xc48/0x1610 kernel/locking/mutex.c:740
 tc_action_net_exit include/net/act_api.h:155 [inline]
 connmark_exit_net+0x22/0x370 net/sched/act_connmark.c:241
 ops_exit_list.isra.0+0x103/0x150 net/core/net_namespace.c:171
 cleanup_net+0x511/0xa90 net/core/net_namespace.c:593
 process_one_work+0x9df/0x16d0 kernel/workqueue.c:2298
 worker_thread+0x90/0xed0 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
INFO: task syz-executor.2:13676 blocked for more than 143 seconds.
      Not tainted 5.16.0-rc6 #9
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D
 stack:26160 pid:13676 ppid:  6800 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xcd9/0x2530 kernel/sched/core.c:6253
 schedule+0xd2/0x260 kernel/sched/core.c:6326
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6385
 __mutex_lock_common kernel/locking/mutex.c:680 [inline]
 __mutex_lock+0xc48/0x1610 kernel/locking/mutex.c:740
 ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
 ops_init+0xaf/0x420 net/core/net_namespace.c:140
 setup_net+0x415/0xa40 net/core/net_namespace.c:326
 copy_net_ns+0x2d9/0x660 net/core/net_namespace.c:470
 create_new_namespaces.isra.0+0x3cb/0xae0 kernel/nsproxy.c:110
 copy_namespaces+0x391/0x450 kernel/nsproxy.c:178
 copy_process+0x2d37/0x73e0 kernel/fork.c:2194
 kernel_clone+0xe7/0x10c0 kernel/fork.c:2582
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2699
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fbc817ac89d
RSP: 002b:00007fbc800bac28 EFLAGS: 00000246
 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007fbc818cc1d0 RCX: 00007fbc817ac89d
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000c4008480
RBP: 00007fbc8181900d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff44580d0f R14: 00007fbc818cc1d0 R15: 00007fbc800badc0
 </TASK>
INFO: task syz-executor.2:13689 blocked for more than 143 seconds.
      Not tainted 5.16.0-rc6 #9
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D stack:25856 pid:13689 ppid:  6800 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xcd9/0x2530 kernel/sched/core.c:6253
 schedule+0xd2/0x260 kernel/sched/core.c:6326
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6385
 __mutex_lock_common kernel/locking/mutex.c:680 [inline]
 __mutex_lock+0xc48/0x1610 kernel/locking/mutex.c:740
 ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
 ops_init+0xaf/0x420 net/core/net_namespace.c:140
 setup_net+0x415/0xa40 net/core/net_namespace.c:326
 copy_net_ns+0x2d9/0x660 net/core/net_namespace.c:470
 create_new_namespaces.isra.0+0x3cb/0xae0 kernel/nsproxy.c:110
 copy_namespaces+0x391/0x450 kernel/nsproxy.c:178
 copy_process+0x2d37/0x73e0 kernel/fork.c:2194
 kernel_clone+0xe7/0x10c0 kernel/fork.c:2582
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2699
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fbc817ac89d
RSP: 002b:00007fbc800bac28 EFLAGS: 00000246
 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007fbc818cc1d0 RCX: 00007fbc817ac89d
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000c4008480
RBP: 00007fbc8181900d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff44580d0f R14: 00007fbc818cc1d0 R15: 00007fbc800badc0
 </TASK>
INFO: task syz-executor.2:13690 blocked for more than 143 seconds.
      Not tainted 5.16.0-rc6 #9
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D stack:24880 pid:13690 ppid:  6800 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xcd9/0x2530 kernel/sched/core.c:6253
 schedule+0xd2/0x260 kernel/sched/core.c:6326
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6385
 __mutex_lock_common kernel/locking/mutex.c:680 [inline]
 __mutex_lock+0xc48/0x1610 kernel/locking/mutex.c:740
 smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
 ops_init+0xaf/0x420 net/core/net_namespace.c:140
 setup_net+0x415/0xa40 net/core/net_namespace.c:326
 copy_net_ns+0x2d9/0x660 net/core/net_namespace.c:470
 create_new_namespaces.isra.0+0x3cb/0xae0 kernel/nsproxy.c:110
 copy_namespaces+0x391/0x450 kernel/nsproxy.c:178
 copy_process+0x2d37/0x73e0 kernel/fork.c:2194
 kernel_clone+0xe7/0x10c0 kernel/fork.c:2582
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2699
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fbc817ac89d
RSP: 002b:00007fbc800bac28 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007fbc818cc1d0 RCX: 00007fbc817ac89d
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000c4008480
RBP: 00007fbc8181900d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff44580d0f R14: 00007fbc818cc1d0 R15: 00007fbc800badc0
 </TASK>
INFO: task syz-executor.2:13707 blocked for more than 144 seconds.
      Not tainted 5.16.0-rc6 #9
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D stack:26000 pid:13707 ppid:  6800 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xcd9/0x2530 kernel/sched/core.c:6253
 schedule+0xd2/0x260 kernel/sched/core.c:6326
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6385
 __mutex_lock_common kernel/locking/mutex.c:680 [inline]
 __mutex_lock+0xc48/0x1610 kernel/locking/mutex.c:740
 register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
 ops_init+0xaf/0x420 net/core/net_namespace.c:140
 setup_net+0x415/0xa40 net/core/net_namespace.c:326
 copy_net_ns+0x2d9/0x660 net/core/net_namespace.c:470
 create_new_namespaces.isra.0+0x3cb/0xae0 kernel/nsproxy.c:110
 copy_namespaces+0x391/0x450 kernel/nsproxy.c:178
 copy_process+0x2d37/0x73e0 kernel/fork.c:2194
 kernel_clone+0xe7/0x10c0 kernel/fork.c:2582
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2699
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fbc817ac89d
RSP: 002b:00007fbc800bac28 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007fbc818cc1d0 RCX: 00007fbc817ac89d
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000c4008480
RBP: 00007fbc8181900d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff44580d0f R14: 00007fbc818cc1d0 R15: 00007fbc800badc0
 </TASK>
INFO: task syz-executor.2:13815 blocked for more than 144 seconds.
      Not tainted 5.16.0-rc6 #9
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D stack:26112 pid:13815 ppid:  6800 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xcd9/0x2530 kernel/sched/core.c:6253
 schedule+0xd2/0x260 kernel/sched/core.c:6326
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6385
 __mutex_lock_common kernel/locking/mutex.c:680 [inline]
 __mutex_lock+0xc48/0x1610 kernel/locking/mutex.c:740
 ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
 ops_init+0xaf/0x420 net/core/net_namespace.c:140
 setup_net+0x415/0xa40 net/core/net_namespace.c:326
 copy_net_ns+0x2d9/0x660 net/core/net_namespace.c:470
 create_new_namespaces.isra.0+0x3cb/0xae0 kernel/nsproxy.c:110
 copy_namespaces+0x391/0x450 kernel/nsproxy.c:178
 copy_process+0x2d37/0x73e0 kernel/fork.c:2194
 kernel_clone+0xe7/0x10c0 kernel/fork.c:2582
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2699
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fbc817ac89d
RSP: 002b:00007fbc800bac28 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007fbc818cc1d0 RCX: 00007fbc817ac89d
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000c4008480
RBP: 00007fbc8181900d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff44580d0f R14: 00007fbc818cc1d0 R15: 00007fbc800badc0
 </TASK>
INFO: task syz-executor.2:13841 blocked for more than 144 seconds.
      Not tainted 5.16.0-rc6 #9
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D stack:25888 pid:13841 ppid:  6800 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xcd9/0x2530 kernel/sched/core.c:6253
 schedule+0xd2/0x260 kernel/sched/core.c:6326
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6385
 __mutex_lock_common kernel/locking/mutex.c:680 [inline]
 __mutex_lock+0xc48/0x1610 kernel/locking/mutex.c:740
 smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
 ops_init+0xaf/0x420 net/core/net_namespace.c:140
 setup_net+0x415/0xa40 net/core/net_namespace.c:326
 copy_net_ns+0x2d9/0x660 net/core/net_namespace.c:470
 create_new_namespaces.isra.0+0x3cb/0xae0 kernel/nsproxy.c:110
 copy_namespaces+0x391/0x450 kernel/nsproxy.c:178
 copy_process+0x2d37/0x73e0 kernel/fork.c:2194
 kernel_clone+0xe7/0x10c0 kernel/fork.c:2582
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2699
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fbc817ac89d
RSP: 002b:00007fbc800bac28 EFLAGS: 00000246
 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007fbc818cc1d0 RCX: 00007fbc817ac89d
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000c4008480
RBP: 00007fbc8181900d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff44580d0f R14: 00007fbc818cc1d0 R15: 00007fbc800badc0
 </TASK>
INFO: task syz-executor.2:13844 blocked for more than 144 seconds.
      Not tainted 5.16.0-rc6 #9
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D stack:25888 pid:13844 ppid:  6800 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xcd9/0x2530 kernel/sched/core.c:6253
 schedule+0xd2/0x260 kernel/sched/core.c:6326
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6385
 __mutex_lock_common kernel/locking/mutex.c:680 [inline]
 __mutex_lock+0xc48/0x1610 kernel/locking/mutex.c:740
 ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
 ops_init+0xaf/0x420 net/core/net_namespace.c:140
 setup_net+0x415/0xa40 net/core/net_namespace.c:326
 copy_net_ns+0x2d9/0x660 net/core/net_namespace.c:470
 create_new_namespaces.isra.0+0x3cb/0xae0 kernel/nsproxy.c:110
 copy_namespaces+0x391/0x450 kernel/nsproxy.c:178
 copy_process+0x2d37/0x73e0 kernel/fork.c:2194
 kernel_clone+0xe7/0x10c0 kernel/fork.c:2582
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2699
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fbc817ac89d
RSP: 002b:00007fbc800bac28 EFLAGS: 00000246
 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007fbc818cc1d0 RCX: 00007fbc817ac89d
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000c4008480
RBP: 00007fbc8181900d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff44580d0f R14: 00007fbc818cc1d0 R15: 00007fbc800badc0
 </TASK>
INFO: task syz-executor.2:13864 blocked for more than 144 seconds.
      Not tainted 5.16.0-rc6 #9
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D
 stack:25888 pid:13864 ppid:  6800 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xcd9/0x2530 kernel/sched/core.c:6253
 schedule+0xd2/0x260 kernel/sched/core.c:6326
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6385
 __mutex_lock_common kernel/locking/mutex.c:680 [inline]
 __mutex_lock+0xc48/0x1610 kernel/locking/mutex.c:740
 ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
 ops_init+0xaf/0x420 net/core/net_namespace.c:140
 setup_net+0x415/0xa40 net/core/net_namespace.c:326
 copy_net_ns+0x2d9/0x660 net/core/net_namespace.c:470
 create_new_namespaces.isra.0+0x3cb/0xae0 kernel/nsproxy.c:110
 copy_namespaces+0x391/0x450 kernel/nsproxy.c:178
 copy_process+0x2d37/0x73e0 kernel/fork.c:2194
 kernel_clone+0xe7/0x10c0 kernel/fork.c:2582
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2699
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fbc817ac89d
RSP: 002b:00007fbc800bac28 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007fbc818cc1d0 RCX: 00007fbc817ac89d
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000c4008480
RBP: 00007fbc8181900d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff44580d0f R14: 00007fbc818cc1d0 R15: 00007fbc800badc0
 </TASK>
INFO: task syz-executor.2:13881 blocked for more than 144 seconds.
      Not tainted 5.16.0-rc6 #9
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D
 stack:25776 pid:13881 ppid:  6800 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xcd9/0x2530 kernel/sched/core.c:6253
 schedule+0xd2/0x260 kernel/sched/core.c:6326
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6385
 __mutex_lock_common kernel/locking/mutex.c:680 [inline]
 __mutex_lock+0xc48/0x1610 kernel/locking/mutex.c:740
 ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
 ops_init+0xaf/0x420 net/core/net_namespace.c:140
 setup_net+0x415/0xa40 net/core/net_namespace.c:326
 copy_net_ns+0x2d9/0x660 net/core/net_namespace.c:470
 create_new_namespaces.isra.0+0x3cb/0xae0 kernel/nsproxy.c:110
 copy_namespaces+0x391/0x450 kernel/nsproxy.c:178
 copy_process+0x2d37/0x73e0 kernel/fork.c:2194
 kernel_clone+0xe7/0x10c0 kernel/fork.c:2582
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2699
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fbc817ac89d
RSP: 002b:00007fbc800bac28 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007fbc818cc1d0 RCX: 00007fbc817ac89d
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000c4008480
RBP: 00007fbc8181900d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff44580d0f R14: 00007fbc818cc1d0 R15: 00007fbc800badc0
 </TASK>

Showing all locks held in the system:
2 locks held by systemd/1:
 #0: ffff888015146940 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
 #0: ffff888015146940 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by kworker/u8:1/10:
 #0: ffff8881000ad938 ((wq_completion)netns){+.+.}-{0:0}, at:
arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8881000ad938 ((wq_completion)netns){+.+.}-{0:0}, at:
arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff8881000ad938 ((wq_completion)netns){+.+.}-{0:0}, at:
atomic_long_set include/linux/atomic/atomic-instrumented.h:1198
[inline]
 #0: ffff8881000ad938 ((wq_completion)netns){+.+.}-{0:0}, at:
set_work_data kernel/workqueue.c:635 [inline]
 #0: ffff8881000ad938 ((wq_completion)netns){+.+.}-{0:0}, at:
set_work_pool_and_clear_pending kernel/workqueue.c:662 [inline]
 #0: ffff8881000ad938 ((wq_completion)netns){+.+.}-{0:0}, at:
process_one_work+0x8c3/0x16d0 kernel/workqueue.c:2269
 #1: ffffc900006d7dc8 (net_cleanup_work){+.+.}-{0:0}, at:
process_one_work+0x8f7/0x16d0 kernel/workqueue.c:2273
 #2:
ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}, at: cleanup_net+0x9b/0xa90 net/core/net_namespace.c:555
 #3: ffffffff8d302968 (
rtnl_mutex){+.+.}-{3:3}, at: tc_action_net_exit
include/net/act_api.h:155 [inline]
rtnl_mutex){+.+.}-{3:3}, at: connmark_exit_net+0x22/0x370
net/sched/act_connmark.c:241
1 lock held by khungtaskd/39:
 #0: ffffffff8bb80e20 (rcu_read_lock){....}-{1:2}, at:
debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6458
3 locks held by kworker/u10:3/1043:
2 locks held by kworker/2:2/1201:
 #0: ffff888010c66138
((wq_completion)events_freezable_power_){+.+.}-{0:0}, at:
arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010c66138
((wq_completion)events_freezable_power_){+.+.}-{0:0}, at:
arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888010c66138
((wq_completion)events_freezable_power_){+.+.}-{0:0}, at:
atomic_long_set include/linux/atomic/atomic-instrumented.h:1198
[inline]
 #0: ffff888010c66138
((wq_completion)events_freezable_power_){+.+.}-{0:0}, at:
set_work_data kernel/workqueue.c:635 [inline]
 #0: ffff888010c66138
((wq_completion)events_freezable_power_){+.+.}-{0:0}, at:
set_work_pool_and_clear_pending kernel/workqueue.c:662 [inline]
 #0: ffff888010c66138
((wq_completion)events_freezable_power_){+.+.}-{0:0}, at:
process_one_work+0x8c3/0x16d0 kernel/workqueue.c:2269
 #1: ffffc9000777fdc8
((work_completion)(&(&ev->dwork)->work)){+.+.}-{0:0}, at:
process_one_work+0x8f7/0x16d0 kernel/workqueue.c:2273
3 locks held by ipv6_addrconf/2688:
 #0: ffff88801f94a138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}
, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1198 [inline]
, at: set_work_data kernel/workqueue.c:635 [inline]
, at: set_work_pool_and_clear_pending kernel/workqueue.c:662 [inline]
, at: process_one_work+0x8c3/0x16d0 kernel/workqueue.c:2269
 #1: ffffc9000dd67d50 ((addr_chk_work).work){+.+.}-{0:0}
, at: process_one_work+0x8f7/0x16d0 kernel/workqueue.c:2273
 #2:
ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
addrconf_verify_work+0xa/0x20 net/ipv6/addrconf.c:4595
2 locks held by systemd-journal/3064:
 #0: ffff888015146940
 (mapping.invalidate_lock
){++++}-{3:3}, at: filemap_invalidate_lock_shared
include/linux/fs.h:838 [inline]
){++++}-{3:3}, at: filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
1 lock held by cron/6297:
 #0: ffff88810db553b0 (&type->i_mutex_dir_key
#4){++++}-{3:3}, at: inode_lock_shared include/linux/fs.h:793 [inline]
#4){++++}-{3:3}, at: lookup_slow fs/namei.c:1673 [inline]
#4){++++}-{3:3}, at: walk_component+0x400/0x6a0 fs/namei.c:1970
2 locks held by in:imklog/6742:
 #0: ffff888015146940 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
 #0: ffff888015146940 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by syz-fuzzer/6695:
 #0: ffff888027317338 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
 #0: ffff888027317338 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by syz-fuzzer/6697:
 #0: ffff888027317338 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
 #0: ffff888027317338 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by syz-fuzzer/6709:
 #0: ffff888027317338 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
 #0: ffff888027317338 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140 (fs_reclaim
){+.+.}-{0:0}, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x760/0x21b0
mm/page_alloc.c:5007
2 locks held by syz-fuzzer/6773:
 #0:
ffff888027317338 (
mapping.invalidate_lock
){++++}-{3:3}, at: filemap_invalidate_lock_shared
include/linux/fs.h:838 [inline]
){++++}-{3:3}, at: filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140
 (fs_reclaim
){+.+.}-{0:0}, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x760/0x21b0
mm/page_alloc.c:5007
2 locks held by syz-fuzzer/6788:
 #0: ffff888027317338 (mapping.invalidate_lock
){++++}-{3:3}, at: filemap_invalidate_lock_shared
include/linux/fs.h:838 [inline]
){++++}-{3:3}, at: filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140
 (
fs_reclaim
){+.+.}-{0:0}
, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
, at: __alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
, at: __alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by syz-executor.2/13570:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_netdev+0x11/0x50 net/core/dev.c:10458
2 locks held by syz-executor.2/13608:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}
, at: register_netdev+0x11/0x50 net/core/dev.c:10458
2 locks held by syz-executor.2/13614:
 #0:
ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660
net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_netdev+0x11/0x50 net/core/dev.c:10458
2 locks held by syz-executor.2/13676:
 #0: ffffffff8d2eeb90 (
pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/13689:
 #0: ffffffff8d2eeb90
 (
pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (
rtnl_mutex
){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/13690:
 #0:
ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/13707:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/13815:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (
rtnl_mutex
){+.+.}-{3:3}, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/13841:
 #0:
ffffffff8d2eeb90
 (
pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (rtnl_mutex){+.+.}-{3:3}, at: smc_pnet_create_pnetids_list
net/smc/smc_pnet.c:798 [inline]
 (rtnl_mutex){+.+.}-{3:3}, at: smc_pnet_net_init+0x1fa/0x420
net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/13844:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/13853:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex){+.+.}-{3:3}
, at: register_netdev+0x11/0x50 net/core/dev.c:10458
2 locks held by syz-executor.2/13864:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/13881:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/13896:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_netdev+0x11/0x50 net/core/dev.c:10458
2 locks held by syz-executor.2/13937:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/13992:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_netdev+0x11/0x50 net/core/dev.c:10458
2 locks held by syz-executor.2/14096:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/14105:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/14158:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/14159:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_netdev+0x11/0x50 net/core/dev.c:10458
2 locks held by syz-executor.2/14170:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_netdev+0x11/0x50 net/core/dev.c:10458
2 locks held by syz-executor.2/14171:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/14180:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_netdev+0x11/0x50 net/core/dev.c:10458
2 locks held by syz-executor.2/14213:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/14227:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/14247:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_netdev+0x11/0x50 net/core/dev.c:10458
2 locks held by syz-executor.2/14249:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/14264:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968 (
rtnl_mutex
){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/14302:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660
net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_netdev+0x11/0x50 net/core/dev.c:10458
2 locks held by syz-executor.2/14340:
 #0: ffffffff8d2eeb90
 (
pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/14360:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (
rtnl_mutex){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/14374:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660
net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/14545:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/14609:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/14641:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/14667:
 #0:
ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/14686:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/14696:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/14707:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/14710:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/14781:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/14792:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/14821:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/14844:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/14853:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/14857:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/14861:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/14862:
 #0:
ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
, at: smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/14881:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/14896:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex){+.+.}-{3:3}, at: ip_tunnel_init_net+0x310/0xa20
net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/14909:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/14918:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/14943:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/14992:
 #0:
ffffffff8d2eeb90 (
pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex){+.+.}-{3:3}, at: wg_netns_pre_exit+0x17/0x210
drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/15045:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/15056:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/15081:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex
){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/15134:
 #0: ffffffff8d2eeb90 (
pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (
rtnl_mutex){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/15153:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/15160:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/15223:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/15264:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.7/15326:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip6mr_sk_done+0xe9/0x370 net/ipv6/ip6mr.c:1582
2 locks held by syz-executor.2/15312:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/15362:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/15412:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/15454:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/15575:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/15580:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/15593:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/15622:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/15671:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/15738:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/15751:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/15763:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/15773:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/15800:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/15821:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/15830:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (
rtnl_mutex
){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/15910:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/15918:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (
rtnl_mutex
){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/15930:
 #0:
ffffffff8d2eeb90 (
pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/15935:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/15966:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/16049:
 #0:
ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (
rtnl_mutex
){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/16084:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/16118:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/16126:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (
rtnl_mutex
){+.+.}-{3:3}, at: wg_netns_pre_exit+0x17/0x210
drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/16129:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/16174:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/16185:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/16194:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/16201:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/16212:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/16253:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/16254:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (
rtnl_mutex
){+.+.}-{3:3}
, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
, at: smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/16289:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660
net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/16311:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/16357:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/16360:
 #0:
ffffffff8d2eeb90
 (
pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/16397:
 #0:
ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/16402:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (
rtnl_mutex
){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/16475:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
, at: smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/16488:
 #0:
ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (
rtnl_mutex){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/16563:
 #0:
ffffffff8d2eeb90 (
pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}, at: gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/16570:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/16591:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/16648:
 #0: ffffffff8d2eeb90
 (
pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/16663:
 #0:
ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (
rtnl_mutex
){+.+.}-{3:3}, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
){+.+.}-{3:3}, at: smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/16664:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968 (
rtnl_mutex){+.+.}-{3:3}, at: wg_netns_pre_exit+0x17/0x210
drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/16679:
 #0:
ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660
net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/16688:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968 (
rtnl_mutex
){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
3 locks held by syz-executor.2/16735:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_netdev+0x11/0x50 net/core/dev.c:10458
 #2: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #2: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #2: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by syz-executor.2/16768:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/16819:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/16870:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/16881:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/16894:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/16905:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/16908:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/16909:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/16956:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/16959:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/17008:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968 (
rtnl_mutex
){+.+.}-{3:3}
, at: gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/17009:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/17046:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/17084:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/17107:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/17138:
 #0: ffffffff8d2eeb90
 (
pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex
){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/17212:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
, at: smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/17290:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}, at: wg_netns_pre_exit+0x17/0x210
drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/17317:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/17322:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (
rtnl_mutex){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/17334:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/17435:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/17459:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/17462:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
, at: smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/17484:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660
net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/17492:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/17499:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/17537:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/17552:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/17572:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/17593:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/17599:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/17602:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/17604:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/17609:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/17633:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/17669:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/17682:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/17706:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/17736:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/17747:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/17816:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/17847:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/17880:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/17893:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/17932:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/17945:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/17970:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/17972:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/17996:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/18023:
 #0:
ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (
rtnl_mutex
){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/18028:
 #0:
ffffffff8d2eeb90
 (
pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660
net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (
rtnl_mutex){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/18075:
 #0:
ffffffff8d2eeb90 (
pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/18084:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968 (
rtnl_mutex
){+.+.}-{3:3}, at: wg_netns_pre_exit+0x17/0x210
drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/18089:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/18092:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (
rtnl_mutex){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/18175:
 #0:
ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660
net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
){+.+.}-{3:3}, at: smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/18183:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660
net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/18246:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (
rtnl_mutex){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/18268:
 #0: ffffffff8d2eeb90
 (
pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/18288:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/18294:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/18313:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}
, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
, at: smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/18326:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/18401:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (
rtnl_mutex
){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/18428:
 #0:
ffffffff8d2eeb90 (
pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/18471:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/18476:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/18487:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/18596:
 #0: ffffffff8d2eeb90
 (
pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660
net/core/net_namespace.c:466
 #1: ffffffff8d302968 (
rtnl_mutex
){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/18623:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660
net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/18658:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/18690:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/18724:
 #0: ffffffff8d2eeb90
 (
pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/18747:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/18810:
 #0:
ffffffff8d2eeb90 (
pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/18853:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/18860:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/18867:
 #0:
ffffffff8d2eeb90 (
pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/18914:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/18933:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/18936:
 #0:
ffffffff8d2eeb90 (
pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (
rtnl_mutex
){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/18950:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (
rtnl_mutex
){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/18971:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/18979:
 #0:
ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/19064:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/19122:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/19224:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/19253:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (
rtnl_mutex
){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/19262:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/19305:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/19343:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}, at: wg_netns_pre_exit+0x17/0x210
drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/19349:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}
, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
, at: smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/19370:
 #0:
ffffffff8d2eeb90 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/19371:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/19378:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/19395:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/19439:
 #0:
ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/19471:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660
net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/19506:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (
rtnl_mutex){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/19531:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968 (
rtnl_mutex){+.+.}-{3:3}
, at: register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/19532:
 #0:
ffffffff8d2eeb90 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/19601:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/19662:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/19717:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/19736:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/19763:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/19828:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/19849:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (
rtnl_mutex
){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/19890:
 #0:
ffffffff8d2eeb90
 (
pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/19957:
 #0:
ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/19962:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/19998:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/20016:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/20033:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/20060:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (
rtnl_mutex){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/20067:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660
net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex
){+.+.}-{3:3}
, at: gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/20074:
 #0:
ffffffff8d2eeb90 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (
rtnl_mutex){+.+.}-{3:3}, at: ip_tunnel_init_net+0x310/0xa20
net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/20163:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/20182:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/20282:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/20301:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (
rtnl_mutex){+.+.}-{3:3}
, at: gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/20317:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/20349:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex){+.+.}-{3:3}
, at: gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/20367:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/20450:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/20461:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (
rtnl_mutex){+.+.}-{3:3}, at: register_nexthop_notifier+0x17/0x70
net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/20471:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex
){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/20477:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968 (
rtnl_mutex){+.+.}-{3:3}, at: ip_tunnel_init_net+0x310/0xa20
net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/20484:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/20523:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/20549:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968 (
rtnl_mutex){+.+.}-{3:3}, at: wg_netns_pre_exit+0x17/0x210
drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/20574:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/20597:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (
rtnl_mutex){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/20615:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660
net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/20657:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/20682:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/20699:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (
rtnl_mutex){+.+.}-{3:3}
, at: gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/20757:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/20768:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/20837:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/20860:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/20863:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/20877:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/20911:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/21006:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/21027:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/21046:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (
rtnl_mutex
){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/21080:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex){+.+.}-{3:3}, at: wg_netns_pre_exit+0x17/0x210
drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/21149:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/21152:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/21169:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/21170:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/21228:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/21229:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/21236:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/21246:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex){+.+.}-{3:3}, at: wg_netns_pre_exit+0x17/0x210
drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/21307:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/21383:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/21384:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (
rtnl_mutex){+.+.}-{3:3}
, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
, at: smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/21401:
 #0:
ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/21408:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (
rtnl_mutex){+.+.}-{3:3}
, at: register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/21435:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660
net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/21442:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex){+.+.}-{3:3}, at: register_nexthop_notifier+0x17/0x70
net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/21525:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/21642:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/21649:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/21662:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/21695:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/21755:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/21760:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/21799:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/21814:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex){+.+.}-{3:3}
, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
, at: smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/21821:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/21828:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/21849:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/21868:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex
){+.+.}-{3:3}, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
){+.+.}-{3:3}, at: smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/21873:
 #0: ffffffff8d2eeb90 (
pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (
rtnl_mutex
){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/21886:
 #0:
ffffffff8d2eeb90
 (
pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/21905:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (
rtnl_mutex){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/21927:
 #0:
ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (
rtnl_mutex){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/21953:
 #0:
ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660
net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/21968:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/22019:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22066:
 #0:
ffffffff8d2eeb90 (
pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22089:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/22090:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22096:
 #0:
ffffffff8d2eeb90 (
pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (
rtnl_mutex){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22118:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968 (
rtnl_mutex
){+.+.}-{3:3}, at: wg_netns_pre_exit+0x17/0x210
drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22135:
 #0:
ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/22162:
 #0:
ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968 (
rtnl_mutex){+.+.}-{3:3}, at: smc_pnet_create_pnetids_list
net/smc/smc_pnet.c:798 [inline]
rtnl_mutex){+.+.}-{3:3}, at: smc_pnet_net_init+0x1fa/0x420
net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/22170:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/22176:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/22195:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22198:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (
rtnl_mutex){+.+.}-{3:3}
, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
, at: smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/22281:
 #0:
ffffffff8d2eeb90 (
pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (
rtnl_mutex
){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22298:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/22316:
 #0:
ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660
net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/22400:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22423:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22428:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/22433:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22450:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/22483:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22526:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22561:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22564:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22609:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22617:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22629:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22662:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22667:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22694:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22747:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22756:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22772:
 #0:
ffffffff8d2eeb90 (
pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22854:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (
rtnl_mutex){+.+.}-{3:3}, at: ip_tunnel_init_net+0x310/0xa20
net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/22873:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22882:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22891:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22916:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660
net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22947:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22950:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22957:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/22970:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23014:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23016:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23053:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/23086:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23093:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23102:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23121:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/23126:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex){+.+.}-{3:3}, at: wg_netns_pre_exit+0x17/0x210
drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23161:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23184:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23235:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23288:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660
net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/23344:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23361:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/23365:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/23405:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex
){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23425:
 #0:
ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23426:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23429:
 #0:
ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/23486:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23491:
 #0: ffffffff8d2eeb90 (
pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23508:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23517:
 #0: ffffffff8d2eeb90 (
pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/23522:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23533:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23547:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23570:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23610:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/23617:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/23623:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23631:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23680:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23703:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/23706:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23759:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23770:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23843:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (rtnl_mutex){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/23916:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/23925:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/23964:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/23999:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/24018:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/24051:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/24074:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/24115:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/24138:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/24151:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/24178:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/24229:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/24230:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/24239:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/24256:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/24257:
 #0: ffffffff8d2eeb90 (
pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/24268:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/24277:
 #0:
ffffffff8d2eeb90
 (
pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (
rtnl_mutex
){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/24280:
 #0:
ffffffff8d2eeb90
 (
pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660
net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/24283:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/24294:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/24319:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/24360:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/24369:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/24406:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/24413:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/24424:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/24433:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/24472:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/24515:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/24532:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/24541:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
xfrmi_exit_batch_net+0x82/0x4c0 net/xfrm/xfrm_interface.c:739
2 locks held by syz-executor.2/24552:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/24569:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/24605:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/24613:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/24614:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/24627:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/24706:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/24757:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/24762:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/24809:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/24891:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (
rtnl_mutex){+.+.}-{3:3}, at: ip_tunnel_init_net+0x310/0xa20
net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/25083:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660
net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/25092:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/25111:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/25130:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/25255:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/25264:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/25277:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/25292:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/25323:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/25356:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/25367:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/25372:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/25411:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/25430:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (
rtnl_mutex
){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/25439:
 #0:
ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (
rtnl_mutex){+.+.}-{3:3}, at: wg_netns_pre_exit+0x17/0x210
drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/25504:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/25601:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/25644:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (
rtnl_mutex){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/25649:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
wg_netns_pre_exit+0x17/0x210 drivers/net/wireguard/device.c:403
2 locks held by syz-executor.2/25862:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/25877:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/25896:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex){+.+.}-{3:3}, at: ip_tunnel_init_net+0x310/0xa20
net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/25925:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/25940:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/25991:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (
rtnl_mutex){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26048:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26051:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/26078:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26105:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26116:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26117:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26192:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26223:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26224:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26295:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26314:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26385:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/26406:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26433:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26444:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26457:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26464:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26477:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (
rtnl_mutex){+.+.}-{3:3}, at: ip_tunnel_init_net+0x310/0xa20
net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26516:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26535:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (
rtnl_mutex){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26572:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26589:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26604:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26621:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26634:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26663:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/26682:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26743:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/26798:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (
rtnl_mutex
){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26867:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/26884:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/26891:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/26926:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (
rtnl_mutex){+.+.}-{3:3}, at: caif_exit_net+0x226/0x800 net/caif/caif_dev.c:527
2 locks held by syz-executor.2/27033:
 #0: ffffffff8d2eeb90 (
pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex){+.+.}-{3:3}, at: register_nexthop_notifier+0x17/0x70
net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/27080:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/27083:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/27102:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (
rtnl_mutex
){+.+.}-{3:3}
, at: gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/27141:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/27258:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/27269:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/27304:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/27315:
 #0: ffffffff8d2eeb90 (
pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968 (
rtnl_mutex){+.+.}-{3:3}
, at: gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/27318:
 #0:
ffffffff8d2eeb90
 (
pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/27335:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/27338:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660
net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/27345:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (
rtnl_mutex){+.+.}-{3:3}
, at: register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/27374:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}, at: register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/27393:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/27412:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/27435:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/27454:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/27475:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/27488:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968 (rtnl_mutex
){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/27507:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/27512:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/27525:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}, at: register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/27588:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/27607:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/27609:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/27629:
 #0: ffffffff8d2eeb90
 (
pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660
net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/27639:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/27649:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/27674:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/27687:
 #0:
ffffffff8d2eeb90
 (
pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/27698:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/27801:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}, at: gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/27897:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/27901:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/27918:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/27939:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/27972:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/28055:
 #0:
ffffffff8d2eeb90 (
pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968 (
rtnl_mutex){+.+.}-{3:3}, at: gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/28120:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/28137:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/28174:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/28176:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/28218:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/28291:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968 (
rtnl_mutex){+.+.}-{3:3}
, at: register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/28318:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (
rtnl_mutex
){+.+.}-{3:3}
, at: gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/28371:
 #0:
ffffffff8d2eeb90
 (
pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/28380:
 #0: ffffffff8d2eeb90
 (
pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (
rtnl_mutex
){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/28432:
 #0:
ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (
rtnl_mutex
){+.+.}-{3:3}
, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
, at: smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/28448:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (
rtnl_mutex){+.+.}-{3:3}
, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
, at: smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/28459:
 #0:
ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex){+.+.}-{3:3}
, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
, at: smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/28496:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (
rtnl_mutex){+.+.}-{3:3}
, at: gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/28523:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
gtp_net_exit+0x166/0x390 drivers/net/gtp.c:1401
2 locks held by syz-executor.2/28538:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/28571:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/28584:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/28599:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/28604:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/28637:
 #0: ffffffff8d2eeb90
 (
pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
, at: smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/28654:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968 (
rtnl_mutex
){+.+.}-{3:3}
, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
, at: smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/28719:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/28744:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/28763:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/28790:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/28807:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/28822:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/28829:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/28898:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/28937:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660
net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/28942:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/28967:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29002:
 #0: ffffffff8d2eeb90 (
pernet_ops_rwsem
){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (
rtnl_mutex){+.+.}-{3:3}
, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
, at: smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29003:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660
net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29152:
 #0:
ffffffff8d2eeb90 (
pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (
rtnl_mutex){+.+.}-{3:3}
, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
, at: smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29165:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968 (rtnl_mutex
){+.+.}-{3:3}
, at: register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/29180:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29185:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29208:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/29219:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29232:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29247:
 #0: ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29250:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
register_nexthop_notifier+0x17/0x70 net/ipv4/nexthop.c:3619
2 locks held by syz-executor.2/29265:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
, at: smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29327:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29366:
 #0:
ffffffff8d2eeb90 (
pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968 (
rtnl_mutex){+.+.}-{3:3}
, at: ip_tunnel_init_net+0x310/0xa20 net/ipv4/ip_tunnel.c:1069
2 locks held by syz-executor.2/29390:
 #0:
ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29401:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex
){+.+.}-{3:3}, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
){+.+.}-{3:3}, at: smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29419:
 #0:
ffffffff8d2eeb90 (
pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29467:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29556:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29593:
 #0:
ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex){+.+.}-{3:3}, at: smc_pnet_create_pnetids_list
net/smc/smc_pnet.c:798 [inline]
 (rtnl_mutex){+.+.}-{3:3}, at: smc_pnet_net_init+0x1fa/0x420
net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29608:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29629:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29632:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29645:
 #0:
ffffffff8d2eeb90 (
pernet_ops_rwsem){++++}-{3:3}
, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968
 (rtnl_mutex
){+.+.}-{3:3}
, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
, at: smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29672:
 #0:
ffffffff8d2eeb90
 (pernet_ops_rwsem
){++++}-{3:3}, at: copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1:
ffffffff8d302968
 (rtnl_mutex){+.+.}-{3:3}
, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
, at: smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29687:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29714:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29733:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29734:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
2 locks held by syz-executor.2/29744:
 #0: ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
copy_net_ns+0x2b6/0x660 net/core/net_namespace.c:466
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d302968 (rtnl_mutex){+.+.}-{3:3}, at:
smc_pnet_net_init+0x1fa/0x420 net/smc/smc_pnet.c:867
1 lock held by systemd-cgroups/29851:
 #0: ffff888015287198 (&type->i_mutex_dir_key#4){++++}-{3:3}, at:
inode_lock_shared include/linux/fs.h:793 [inline]
 #0: ffff888015287198 (&type->i_mutex_dir_key#4){++++}-{3:3}, at:
open_last_lookups fs/namei.c:3349 [inline]
 #0: ffff888015287198 (&type->i_mutex_dir_key#4){++++}-{3:3}, at:
path_openat+0x1661/0x26c0 fs/namei.c:3556
2 locks held by kworker/u9:1/29854:
5 locks held by kworker/u10:6/29867:
2 locks held by kworker/u10:6/29895:
8 locks held by kworker/u10:0/29896:

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 39 Comm: khungtaskd Not tainted 5.16.0-rc6 #9
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x1a1/0x1e0 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
 watchdog+0xcc8/0x1010 kernel/hung_task.c:295
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
Sending NMI from CPU 0 to CPUs 1-3:
NMI backtrace for cpu 1
CPU: 1 PID: 29896 Comm: kworker/u10:0 Not tainted 5.16.0-rc6 #9
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:check_kcov_mode+0x2c/0x40 kernel/kcov.c:177
Code: 05 f9 02 8b 7e 89 c2 81 e2 00 01 00 00 a9 00 01 ff 00 74 10 31
c0 85 d2 74 15 8b 96 64 15 00 00 85 d2 74 0b 8b 86 40 15 00 00 <39> f8
0f 94 c0 c3 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 31 c0
RSP: 0018:ffffc9000600f158 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 00000000fffffffe RCX: ffff88805bf13980
RDX: 0000000000000000 RSI: ffff88805bf13980 RDI: 0000000000000002
RBP: 0000000000000002 R08: ffffffff8409b4be R09: 0000000000000000
R10: 0000000000000005 R11: fffff52000c01eae R12: ffffc9000600f573
R13: 0000000000000003 R14: ffffc9008600f56f R15: ffffc9000600f573
FS:  0000000000000000(0000) GS:ffff888135c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbc817ac873 CR3: 0000000019496000 CR4: 0000000000350ee0
Call Trace:
 <TASK>
 __sanitizer_cov_trace_pc+0x1a/0x40 kernel/kcov.c:200
 number+0xa1e/0xb50 lib/vsprintf.c:474
 vsnprintf+0x218/0x14f0 lib/vsprintf.c:2871
 sprintf+0xc0/0x100 lib/vsprintf.c:3007
 print_time kernel/printk/printk.c:1261 [inline]
 info_print_prefix+0x24b/0x340 kernel/printk/printk.c:1287
 record_print_text+0x14f/0x3d0 kernel/printk/printk.c:1336
 console_unlock+0x2d8/0xb40 kernel/printk/printk.c:2692
 vprintk_emit+0x2e4/0x4a0 kernel/printk/printk.c:2245
 vprintk+0x80/0x90 kernel/printk/printk_safe.c:50
 _printk+0xba/0xed kernel/printk/printk.c:2266
 dump_unreclaimable_slab.cold+0xb3/0xb5 mm/slab_common.c:1119
 dump_header+0x22d/0x666 mm/oom_kill.c:469
 oom_kill_process.cold+0x10/0x15 mm/oom_kill.c:982
 out_of_memory+0x353/0x1430 mm/oom_kill.c:1119
 __alloc_pages_may_oom mm/page_alloc.c:4314 [inline]
 __alloc_pages_slowpath.constprop.0+0x1b59/0x21b0 mm/page_alloc.c:5051
 __alloc_pages+0x5ab/0x6e0 mm/page_alloc.c:5382
 alloc_pages+0x115/0x240 mm/mempolicy.c:2191
 __get_free_pages+0x8/0x40 mm/page_alloc.c:5418
 _pgd_alloc arch/x86/mm/pgtable.c:414 [inline]
 pgd_alloc+0x81/0x360 arch/x86/mm/pgtable.c:430
 mm_alloc_pgd kernel/fork.c:639 [inline]
 mm_init+0x60a/0xab0 kernel/fork.c:1074
 mm_alloc+0x99/0xc0 kernel/fork.c:1102
 bprm_mm_init fs/exec.c:368 [inline]
 alloc_bprm+0x1c3/0x8f0 fs/exec.c:1523
 kernel_execve+0x55/0x460 fs/exec.c:1943
 call_usermodehelper_exec_async+0x2e3/0x580 kernel/umh.c:112
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
NMI backtrace for cpu 3
CPU: 3 PID: 29897 Comm: kworker/u10:6 Not tainted 5.16.0-rc6 #9
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:mark_lock.part.0+0x1d/0x27c0 kernel/locking/lockdep.c:4564
Code: c3 66 66 2e 0f 1f 84 00 00 00 00 00 90 55 48 89 e5 41 57 41 56
41 89 d6 48 ba 00 00 00 00 00 fc ff df 41 55 41 54 49 89 f4 53 <48> 83
e4 f0 48 81 ec 40 01 00 00 48 8d 5c 24 40 48 89 7c 24 30 48
RSP: 0018:ffffc9000608f290 EFLAGS: 00000002
RAX: 0000000000000001 RBX: 0000000000000a4e RCX: 1ffffffff1ffd906
RDX: dffffc0000000000 RSI: ffff8880a9950a70 RDI: ffff8880a9950000
RBP: ffffc9000608f2b8 R08: 1ffff1101532a14d R09: fffffbfff1fee152
R10: 0000000000000001 R11: fffffbfff1fee151 R12: ffff8880a9950a70
R13: ffff8880a9950000 R14: 0000000000000008 R15: 000000000000000a
FS:  0000000000000000(0000) GS:ffff888135d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4d1a347ae6 CR3: 000000001859a000 CR4: 0000000000350ee0
Call Trace:
 <TASK>
 mark_lock kernel/locking/lockdep.c:4569 [inline]
 mark_usage kernel/locking/lockdep.c:4526 [inline]
 __lock_acquire+0x8e1/0x57e0 kernel/locking/lockdep.c:4981
 lock_acquire kernel/locking/lockdep.c:5637 [inline]
 lock_acquire+0x1ab/0x520 kernel/locking/lockdep.c:5602
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:349 [inline]
 f2fs_shrink_count+0x1e/0x240 fs/f2fs/shrinker.c:44
 do_shrink_slab+0x7e/0xbe0 mm/vmscan.c:720
 shrink_slab mm/vmscan.c:933 [inline]
 shrink_slab+0x17c/0x6f0 mm/vmscan.c:906
 shrink_node_memcgs mm/vmscan.c:3131 [inline]
 shrink_node+0x883/0x1df0 mm/vmscan.c:3252
 shrink_zones mm/vmscan.c:3485 [inline]
 do_try_to_free_pages+0x4f6/0x1440 mm/vmscan.c:3541
 try_to_free_pages+0x2a6/0x760 mm/vmscan.c:3776
 __perform_reclaim mm/page_alloc.c:4588 [inline]
 __alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 __alloc_pages_slowpath.constprop.0+0x807/0x21b0 mm/page_alloc.c:5007
 __alloc_pages+0x5ab/0x6e0 mm/page_alloc.c:5382
 alloc_pages+0x115/0x240 mm/mempolicy.c:2191
 __get_free_pages+0x8/0x40 mm/page_alloc.c:5418
 _pgd_alloc arch/x86/mm/pgtable.c:414 [inline]
 pgd_alloc+0x81/0x360 arch/x86/mm/pgtable.c:430
 mm_alloc_pgd kernel/fork.c:639 [inline]
 mm_init+0x60a/0xab0 kernel/fork.c:1074
 mm_alloc+0x99/0xc0 kernel/fork.c:1102
 bprm_mm_init fs/exec.c:368 [inline]
 alloc_bprm+0x1c3/0x8f0 fs/exec.c:1523
 kernel_execve+0x55/0x460 fs/exec.c:1943
 call_usermodehelper_exec_async+0x2e3/0x580 kernel/umh.c:112
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
NMI backtrace for cpu 2
CPU: 2 PID: 8 Comm: kworker/u8:0 Not tainted 5.16.0-rc6 #9
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Workqueue: bat_events batadv_nc_worker
RIP: 0010:arch_irqs_disabled_flags arch/x86/include/asm/irqflags.h:127 [inline]
RIP: 0010:check_preemption_disabled+0x4d/0x170 lib/smp_processor_id.c:19
Code: e3 ff ff ff 7f 31 ff 89 de 0f 1f 44 00 00 85 db 74 11 0f 1f 44
00 00 44 89 e0 5b 5d 41 5c 41 5d 41 5e c3 0f 1f 44 00 00 9c 5b <81> e3
00 02 00 00 31 ff 48 89 de 0f 1f 44 00 00 48 85 db 74 d3 0f
RSP: 0018:ffffc900006b7c08 EFLAGS: 00000046
RAX: d38165a365746623 RBX: 0000000000000046 RCX: 1ffffffff1ff8c3e
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffffff8a051f60 R08: 0000000000000001 R09: fffffbfff1fee145
R10: 0000000000000001 R11: fffffbfff1fee144 R12: 0000000000000002
R13: ffffffff89ac0e40 R14: dffffc0000000000 R15: ffffffff88df9b30
FS:  0000000000000000(0000) GS:ffff888063f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0890b2e000 CR3: 000000010730f000 CR4: 0000000000350ee0
Call Trace:
 <TASK>
 lockdep_hardirqs_on+0x79/0x100 kernel/locking/lockdep.c:4354
 __local_bh_enable_ip+0xa0/0x110 kernel/softirq.c:388
 spin_unlock_bh include/linux/spinlock.h:394 [inline]
 batadv_nc_purge_paths+0x2d1/0x400 net/batman-adv/network-coding.c:475
 batadv_nc_worker+0x255/0x770 net/batman-adv/network-coding.c:724
 process_one_work+0x9df/0x16d0 kernel/workqueue.c:2298
 worker_thread+0x90/0xed0 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
----------------
Code disassembly (best guess):
   0: 05 f9 02 8b 7e        add    $0x7e8b02f9,%eax
   5: 89 c2                mov    %eax,%edx
   7: 81 e2 00 01 00 00    and    $0x100,%edx
   d: a9 00 01 ff 00        test   $0xff0100,%eax
  12: 74 10                je     0x24
  14: 31 c0                xor    %eax,%eax
  16: 85 d2                test   %edx,%edx
  18: 74 15                je     0x2f
  1a: 8b 96 64 15 00 00    mov    0x1564(%rsi),%edx
  20: 85 d2                test   %edx,%edx
  22: 74 0b                je     0x2f
  24: 8b 86 40 15 00 00    mov    0x1540(%rsi),%eax
* 2a: 39 f8                cmp    %edi,%eax <-- trapping instruction
  2c: 0f 94 c0              sete   %al
  2f: c3                    retq
  30: 66 66 2e 0f 1f 84 00 data16 nopw %cs:0x0(%rax,%rax,1)
  37: 00 00 00 00
  3b: 0f 1f 00              nopl   (%rax)
  3e: 31 c0                xor    %eax,%eax
