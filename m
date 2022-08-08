Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C6658C40E
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 09:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236193AbiHHHfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 03:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236725AbiHHHfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 03:35:25 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B67327F
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 00:35:23 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id v5-20020a5d9405000000b0067c98e0011dso4142815ion.1
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 00:35:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc;
        bh=/xpnSNBx6YcejWp6D7piTFVv5HNYrOIvM8dSmc0S6BA=;
        b=RZfcS1HVhKUgyPkKCLY5f34mJvXkXjOw/tF018r/Nyr3gn68JQbKMydKmBq4A9/DrP
         wVzVq6osTX8vUK6OyoMDLkSWp4uwoHgYkbo3J+7e9tnV3BD5KSpkXDuqeyr218yAsVtt
         QzHf/mBScy8N1XeaGRSZZPyR4WKlJenSmPpQmnZ8i/bWbCr3m512jYtg44sWtII1fd37
         x5X8HLI8sYipEmNrhl6xZKoK6D3zvstESqqQbk4sx0mapyzsmK7cKftMw78sy5Do3Gxu
         Dt+VZnoO3Hg0wWZkDuWgYQ+qry8IRXYenxGOASvGkpL+Hz1yV3NeZVjdTdidNV6j0EVL
         80sQ==
X-Gm-Message-State: ACgBeo3MrC0UUI13CeWdO2njstnIZ5mK9skpth98UaJCGEEQi6ZHmCIR
        M0ooVgGiBnQX/rcPvX+GOjWksSDEkbbn1Fxk5aYn3l/jyhWQ
X-Google-Smtp-Source: AA6agR5fu4lsLaBnQwWnoY06kfc+nwWMuw3HtpNnYavBhsec2hJvZv+x5XgXZSwZ84Ay5BoU/RIN6dj4CGs+gJsvHwuPTYeXYlgT
MIME-Version: 1.0
X-Received: by 2002:a02:664a:0:b0:33f:5310:35e1 with SMTP id
 l10-20020a02664a000000b0033f531035e1mr7630284jaf.214.1659944122896; Mon, 08
 Aug 2022 00:35:22 -0700 (PDT)
Date:   Mon, 08 Aug 2022 00:35:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cad57405e5b5dbb7@google.com>
Subject: [syzbot] possible deadlock in p9_req_put
From:   syzbot <syzbot+50f7e8d06c3768dd97f3@syzkaller.appspotmail.com>
To:     asmadeus@codewreck.org, davem@davemloft.net, edumazet@google.com,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux_oss@crudebyte.com, lucho@ionkov.net, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
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

HEAD commit:    ca688bff68bc Add linux-next specific files for 20220808
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=104c8666080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4c20e006003cdecb
dashboard link: https://syzkaller.appspot.com/bug?extid=50f7e8d06c3768dd97f3
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+50f7e8d06c3768dd97f3@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
5.19.0-next-20220808-syzkaller #0 Not tainted
--------------------------------------------
kworker/0:5/3683 is trying to acquire lock:
ffff888026be2c18 (&clnt->lock){+.+.}-{2:2}, at: p9_tag_remove net/9p/client.c:367 [inline]
ffff888026be2c18 (&clnt->lock){+.+.}-{2:2}, at: p9_req_put net/9p/client.c:375 [inline]
ffff888026be2c18 (&clnt->lock){+.+.}-{2:2}, at: p9_req_put+0xc6/0x250 net/9p/client.c:372

but task is already holding lock:
ffff888026be2c18 (&clnt->lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:349 [inline]
ffff888026be2c18 (&clnt->lock){+.+.}-{2:2}, at: p9_conn_cancel+0xaa/0x970 net/9p/trans_fd.c:192

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&clnt->lock);
  lock(&clnt->lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by kworker/0:5/3683:
 #0: ffff888011864d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888011864d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888011864d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff888011864d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:636 [inline]
 #0: ffff888011864d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:663 [inline]
 #0: ffff888011864d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x87a/0x1610 kernel/workqueue.c:2260
 #1: ffffc90005167da8 ((work_completion)(&m->rq)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x1610 kernel/workqueue.c:2264
 #2: ffff888026be2c18 (&clnt->lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:349 [inline]
 #2: ffff888026be2c18 (&clnt->lock){+.+.}-{2:2}, at: p9_conn_cancel+0xaa/0x970 net/9p/trans_fd.c:192

stack backtrace:
CPU: 0 PID: 3683 Comm: kworker/0:5 Not tainted 5.19.0-next-20220808-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
Workqueue: events p9_read_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_deadlock_bug kernel/locking/lockdep.c:2988 [inline]
 check_deadlock kernel/locking/lockdep.c:3031 [inline]
 validate_chain kernel/locking/lockdep.c:3816 [inline]
 __lock_acquire.cold+0x116/0x3a7 kernel/locking/lockdep.c:5053
 lock_acquire kernel/locking/lockdep.c:5666 [inline]
 lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5631
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
 p9_tag_remove net/9p/client.c:367 [inline]
 p9_req_put net/9p/client.c:375 [inline]
 p9_req_put+0xc6/0x250 net/9p/client.c:372
 p9_conn_cancel+0x640/0x970 net/9p/trans_fd.c:213
 p9_read_work+0x514/0x10c0 net/9p/trans_fd.c:403
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
