Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2043735D5
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 09:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbhEEHwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 03:52:22 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:53094 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbhEEHwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 03:52:21 -0400
Received: by mail-il1-f200.google.com with SMTP id s2-20020a056e0210c2b0290196bac26c2cso872207ilj.19
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 00:51:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Gx9YBfhAApSMSPzOqe5EH8EB6gM0L8yCq0gPlS464UU=;
        b=CUZMgBke2HxIZpHHJ4msD+AFV0YGIHw6sIjNE39taQnZSMo7z4foc3AZJwXTf42wXn
         Su+Ze22rK/3bS8wjnkgRPIXmiBLGd44NyeErzTPuDJTnnRkR+zI5YwgjxTkPVat72AkN
         kP4Wk9MOovxVXrHvRjTArd0IiC7DNJgqFnqLG6RWvKgF3Q6wZ7Kiu93ROcwh64zzV/5Q
         Ag0Gir4ck2PbdwIhir9Ml7CeKmKX0xqGd9zxtk0kHK3Vzs/v7LZRdkyd0NNCMtqToGca
         S6FLPbgNipggnDXRCpItjlU5oUfi2iklgb07hBANp8dKlv9MOnZMvIE5uuu9+GncIOuL
         ajXQ==
X-Gm-Message-State: AOAM533BWcAa+hCCoNtnwjy/WbfEaD/McKEs4gYpisBRuxDD/umjByik
        AJKelXiI0TPmZW9RpospsGLri7BNZpDGx7unzBJgNa88N0hN
X-Google-Smtp-Source: ABdhPJzdPNhHyMYBHXL0JYjztH6zmVszihIm7f31Ad1OxlScuoLTx+WgrjzQGen0TAtJceQS5ifexN+o1oId6QQk5R66/IpAVim5
MIME-Version: 1.0
X-Received: by 2002:a92:a301:: with SMTP id a1mr23649432ili.41.1620201084819;
 Wed, 05 May 2021 00:51:24 -0700 (PDT)
Date:   Wed, 05 May 2021 00:51:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000201e3405c19076a4@google.com>
Subject: [syzbot] WARNING: suspicious RCU usage in nf_ct_iterate_cleanup (2)
From:   syzbot <syzbot+86efe6206c1373c8a7cc@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, christian.brauner@ubuntu.com,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        gnault@redhat.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, serge@hallyn.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d2b6f8a1 Merge tag 'xfs-5.13-merge-3' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=120f2da3d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=65c207250bba4efe
dashboard link: https://syzkaller.appspot.com/bug?extid=86efe6206c1373c8a7cc

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+86efe6206c1373c8a7cc@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
5.12.0-syzkaller #0 Not tainted
-----------------------------
kernel/sched/core.c:8304 Illegal context switch in RCU-bh read-side critical section!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 0
3 locks held by kworker/u4:7/11790:
 #0: 
ffff888011e93138
 (
(wq_completion)netns
){+.+.}-{0:0}
, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
, at: set_work_data kernel/workqueue.c:616 [inline]
, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: 
ffffc90002377da8
 (
net_cleanup_work
){+.+.}-{0:0}
, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
 #2: 
ffffffff8d672190
 (
pernet_ops_rwsem
){++++}-{3:3}
, at: cleanup_net+0x9b/0xb10 net/core/net_namespace.c:557

stack backtrace:
CPU: 1 PID: 11790 Comm: kworker/u4:7 Not tainted 5.12.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 ___might_sleep+0x229/0x2c0 kernel/sched/core.c:8304
 get_next_corpse net/netfilter/nf_conntrack_core.c:2223 [inline]
 nf_ct_iterate_cleanup+0x16d/0x450 net/netfilter/nf_conntrack_core.c:2245
 nf_conntrack_cleanup_net_list+0x81/0x250 net/netfilter/nf_conntrack_core.c:2432
 ops_exit_list+0x10d/0x160 net/core/net_namespace.c:178
 cleanup_net+0x4ea/0xb10 net/core/net_namespace.c:595
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
