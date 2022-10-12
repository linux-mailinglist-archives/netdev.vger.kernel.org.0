Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F34CD5FC6F3
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 16:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiJLODq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 10:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiJLODn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 10:03:43 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19312C8230
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 07:03:41 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id b12-20020a5d804c000000b006b723722d4eso11272006ior.17
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 07:03:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LWdHKT9leiqvoEOdN/2hOOqnqF5BTDepurZraEYGZ/E=;
        b=vd4ucckJEhw+cDWhuPjfoe1s3ExJuPMOYje2MLYB0TLrKS1kxnZ9sucR0wWMBgBlAF
         x36EM+rLxTggajgQu9G/j3GG5gRHAeLnZhflDCUKY+lXz8y6sFbAsaJYsxmacXquTa0s
         5lq155cXYNPL36Jmz8cUBzDaJcj2jbkZkQwCpzIbGV2ve4slOFjk5juZ2EKBDY8+R767
         VSmBX4NBYrryG3PxsvcJ1eEuMXNWEv7iKKjdHGBwwNjmkxb0hg6wkplaqacIpaD/SOkS
         Blq6ELVpLoejueFxVIbVuO4CMYlzZtWaZRjCR/catFMiKJK1r7fCo5iP2alxlrcNOlwG
         ufaA==
X-Gm-Message-State: ACrzQf3NKximZRoi52Ppqtj9CPvPIYsz7/FYRjCvp1HxEVN4Ud6f6AdP
        9SDZpcw10FL+z7+yi7lnQccyjC0ScDXaG6Njej0NQMgVZyWV
X-Google-Smtp-Source: AMsMyM6+mci7CiMGFOSoPKpcBGvBPlA2ZzygnkM7KvsXzaUCMSOUy7LNa9tykfS4y7djtZgVf/wYxy4Hi+PVSdXEoWlGqnXdOpQW
MIME-Version: 1.0
X-Received: by 2002:a02:94ab:0:b0:35a:d1b9:c71c with SMTP id
 x40-20020a0294ab000000b0035ad1b9c71cmr15224587jah.310.1665583419955; Wed, 12
 Oct 2022 07:03:39 -0700 (PDT)
Date:   Wed, 12 Oct 2022 07:03:39 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000017227f05ead6dc15@google.com>
Subject: [syzbot] possible deadlock in tcp_sock_set_cork
From:   syzbot <syzbot+c4b21407c3b1dc66ee65@syzkaller.appspotmail.com>
To:     bpf@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, nathan@kernel.org, ndesaulniers@google.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, trix@redhat.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a5088ee7251e Merge tag 'thermal-6.1-rc1' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17c929b8880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=201ae572239e648
dashboard link: https://syzkaller.appspot.com/bug?extid=c4b21407c3b1dc66ee65
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/26341f70ccb8/disk-a5088ee7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ca8a6f6b0303/vmlinux-a5088ee7.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c4b21407c3b1dc66ee65@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.0.0-syzkaller-00372-ga5088ee7251e #0 Not tainted
------------------------------------------------------
kworker/u4:27/14295 is trying to acquire lock:
ffff888022948fb0 (k-sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1712 [inline]
ffff888022948fb0 (k-sk_lock-AF_INET6){+.+.}-{0:0}, at: tcp_sock_set_cork+0x16/0x90 net/ipv4/tcp.c:3337

but task is already holding lock:
ffffc90004a4fda8 ((work_completion)(&(&cp->cp_send_w)->work)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x1610 kernel/workqueue.c:2264

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 ((work_completion)(&(&cp->cp_send_w)->work)){+.+.}-{0:0}:
       __flush_work+0x105/0xae0 kernel/workqueue.c:3069
       __cancel_work_timer+0x3f9/0x570 kernel/workqueue.c:3160
       rds_tcp_reset_callbacks+0x1cb/0x4d0 net/rds/tcp.c:171
       rds_tcp_accept_one+0x9d5/0xd10 net/rds/tcp_listen.c:203
       rds_tcp_accept_worker+0x55/0x80 net/rds/tcp.c:529
       process_one_work+0x991/0x1610 kernel/workqueue.c:2289
       worker_thread+0x665/0x1080 kernel/workqueue.c:2436
       kthread+0x2e4/0x3a0 kernel/kthread.c:376
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

-> #0 (k-sk_lock-AF_INET6){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3095 [inline]
       check_prevs_add kernel/locking/lockdep.c:3214 [inline]
       validate_chain kernel/locking/lockdep.c:3829 [inline]
       __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5053
       lock_acquire kernel/locking/lockdep.c:5666 [inline]
       lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5631
       lock_sock_nested+0x36/0xf0 net/core/sock.c:3393
       lock_sock include/net/sock.h:1712 [inline]
       tcp_sock_set_cork+0x16/0x90 net/ipv4/tcp.c:3337
       rds_send_xmit+0x386/0x2540 net/rds/send.c:194
       rds_send_worker+0x92/0x2e0 net/rds/threads.c:200
       process_one_work+0x991/0x1610 kernel/workqueue.c:2289
       worker_thread+0x665/0x1080 kernel/workqueue.c:2436
       kthread+0x2e4/0x3a0 kernel/kthread.c:376
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock((work_completion)(&(&cp->cp_send_w)->work));
                               lock(k-sk_lock-AF_INET6);
                               lock((work_completion)(&(&cp->cp_send_w)->work));
  lock(k-sk_lock-AF_INET6);

 *** DEADLOCK ***

2 locks held by kworker/u4:27/14295:
 #0: ffff888027f19938 ((wq_completion)krdsd){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888027f19938 ((wq_completion)krdsd){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888027f19938 ((wq_completion)krdsd){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff888027f19938 ((wq_completion)krdsd){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:636 [inline]
 #0: ffff888027f19938 ((wq_completion)krdsd){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:663 [inline]
 #0: ffff888027f19938 ((wq_completion)krdsd){+.+.}-{0:0}, at: process_one_work+0x87a/0x1610 kernel/workqueue.c:2260
 #1: ffffc90004a4fda8 ((work_completion)(&(&cp->cp_send_w)->work)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x1610 kernel/workqueue.c:2264

stack backtrace:
CPU: 0 PID: 14295 Comm: kworker/u4:27 Not tainted 6.0.0-syzkaller-00372-ga5088ee7251e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
Workqueue: krdsd rds_send_worker
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3095 [inline]
 check_prevs_add kernel/locking/lockdep.c:3214 [inline]
 validate_chain kernel/locking/lockdep.c:3829 [inline]
 __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5053
 lock_acquire kernel/locking/lockdep.c:5666 [inline]
 lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5631
 lock_sock_nested+0x36/0xf0 net/core/sock.c:3393
 lock_sock include/net/sock.h:1712 [inline]
 tcp_sock_set_cork+0x16/0x90 net/ipv4/tcp.c:3337
 rds_send_xmit+0x386/0x2540 net/rds/send.c:194
 rds_send_worker+0x92/0x2e0 net/rds/threads.c:200
 process_one_work+0x991/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
