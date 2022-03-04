Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2507F4CD2A2
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 11:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237412AbiCDKmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 05:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237255AbiCDKmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 05:42:09 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BE21AAA6C
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 02:41:22 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id m17-20020a923f11000000b002c10e8f4c44so5304187ila.1
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 02:41:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=6SuusqU261l0YZRBubHgkzmZFekkg3laoBBQucPRrgA=;
        b=46iS/gYUEJzHfy8qvug35/ArIxcK4F9Q7Ir9mYi8ciS+Kw0HyPV5hZsF/Yz4yTKkew
         cAYVcnSKKbMR2gCe1IuEm0ziDwGBEXAmumNfMf+DuQkv6I4SvsmgcwaiAYgVxPDbZDGW
         gnTKIkGbQM758IRk6LhezVAsPPGCo6NklbCbaLqpdC7OYpiBz5/J65W11mlcy02b8Wiy
         7BIwT47DkTAdVun/xfMswaWjPgWm1aurZ78ypgtrc/ZQ7b0VUIOUVVEo0LLZ9t+c+o7d
         BJ9DE0hztJ1GF1wYDSkdgF82Hf1OIjZSYCG9TiceHl07W+LHCAA20sIOHYkGbNQefd1F
         HqQA==
X-Gm-Message-State: AOAM533M49Rn1O+W6Cx9uE9rKNPIODnv/RTzj6lqgtE3icdqj6SHG7zk
        6mfSYI2NQfX60Ea3fe0yEoIeVft8DunE0qpvwhruBa6cFBAN
X-Google-Smtp-Source: ABdhPJwKCMl3GU2i9vbnDTeANVWYScaZeMCV2tSwF1TW5fUve4h9UUDcIrdH6VmCvdsJafXL55JBIVWVo0pCWJHPquGCcHchQG9J
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:178f:b0:2c4:b692:a8ec with SMTP id
 y15-20020a056e02178f00b002c4b692a8ecmr13307761ilu.296.1646390481472; Fri, 04
 Mar 2022 02:41:21 -0800 (PST)
Date:   Fri, 04 Mar 2022 02:41:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cf53e605d96227cd@google.com>
Subject: [syzbot] linux-next boot error: WARNING: suspicious RCU usage in cpuacct_charge
From:   syzbot <syzbot+16e3f2c77e7c5a0113f9@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        brauner@kernel.org, cgroups@vger.kernel.org, daniel@iogearbox.net,
        hannes@cmpxchg.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, lizefan.x@bytedance.com,
        netdev@vger.kernel.org, sfr@canb.auug.org.au,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        tj@kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6d284ba80c0c Add linux-next specific files for 20220304
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15c283d1700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=26714bde6b3ad08b
dashboard link: https://syzkaller.appspot.com/bug?extid=16e3f2c77e7c5a0113f9
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+16e3f2c77e7c5a0113f9@syzkaller.appspotmail.com


=============================
WARNING: suspicious RCU usage
5.17.0-rc6-next-20220304-syzkaller #0 Not tainted
-----------------------------
include/linux/cgroup.h:494 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 1
2 locks held by kthreadd/2:
 #0: ffff8881401726e0 (&p->pi_lock){....}-{2:2}, at: task_rq_lock+0x63/0x360 kernel/sched/core.c:578
 #1: ffff8880b9c39f98 (&rq->__lock){-...}-{2:2}, at: raw_spin_rq_lock_nested+0x2b/0x120 kernel/sched/core.c:478

stack backtrace:
CPU: 0 PID: 2 Comm: kthreadd Not tainted 5.17.0-rc6-next-20220304-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 task_css include/linux/cgroup.h:494 [inline]
 task_ca kernel/sched/cpuacct.c:40 [inline]
 cpuacct_charge+0x2af/0x3c0 kernel/sched/cpuacct.c:342
 cgroup_account_cputime include/linux/cgroup.h:792 [inline]
 update_curr+0x37b/0x830 kernel/sched/fair.c:907
 dequeue_entity+0x23/0xfd0 kernel/sched/fair.c:4422
 dequeue_task_fair+0x238/0xea0 kernel/sched/fair.c:5771
 dequeue_task kernel/sched/core.c:2019 [inline]
 __do_set_cpus_allowed+0x186/0x960 kernel/sched/core.c:2508
 __set_cpus_allowed_ptr_locked+0x2ba/0x4e0 kernel/sched/core.c:2841
 __set_cpus_allowed_ptr kernel/sched/core.c:2874 [inline]
 set_cpus_allowed_ptr+0x78/0xa0 kernel/sched/core.c:2879
 kthreadd+0x44/0x750 kernel/kthread.c:724
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

=============================
WARNING: suspicious RCU usage
5.17.0-rc6-next-20220304-syzkaller #0 Not tainted
-----------------------------
include/linux/cgroup.h:481 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 1
2 locks held by kthreadd/2:
 #0: ffff8881401726e0 (&p->pi_lock){....}-{2:2}, at: task_rq_lock+0x63/0x360 kernel/sched/core.c:578
 #1: ffff8880b9c39f98 (&rq->__lock){-...}-{2:2}, at: raw_spin_rq_lock_nested+0x2b/0x120 kernel/sched/core.c:478

stack backtrace:
CPU: 0 PID: 2 Comm: kthreadd Not tainted 5.17.0-rc6-next-20220304-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 task_css_set include/linux/cgroup.h:481 [inline]
 task_dfl_cgroup include/linux/cgroup.h:550 [inline]
 cgroup_account_cputime include/linux/cgroup.h:794 [inline]
 update_curr+0x671/0x830 kernel/sched/fair.c:907
 dequeue_entity+0x23/0xfd0 kernel/sched/fair.c:4422
 dequeue_task_fair+0x238/0xea0 kernel/sched/fair.c:5771
 dequeue_task kernel/sched/core.c:2019 [inline]
 __do_set_cpus_allowed+0x186/0x960 kernel/sched/core.c:2508
 __set_cpus_allowed_ptr_locked+0x2ba/0x4e0 kernel/sched/core.c:2841
 __set_cpus_allowed_ptr kernel/sched/core.c:2874 [inline]
 set_cpus_allowed_ptr+0x78/0xa0 kernel/sched/core.c:2879
 kthreadd+0x44/0x750 kernel/kthread.c:724
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
