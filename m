Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D713BD79B
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 07:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633825AbfIYFJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 01:09:10 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:48860 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392206AbfIYFJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 01:09:09 -0400
Received: by mail-io1-f69.google.com with SMTP id w16so7223210ioc.15
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 22:09:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=BIbTCCCavfBu7vSAONti3XrFYv20buWCS4jbSRUec3o=;
        b=s8/Xvfvb9bLKCE1S7KaviuXSsREEDL8bR7Fz4h5J4z7TLFEO4e3iCx5tM9jfdIiPza
         B4MsTwQJ5qwjJq4ASZXYfFg4GvL75gwRqn0Bgl3S3yRZQrgLwz5JUdlYA/cdeKSktWrg
         owPJHWkwaIRIDdKz0rZ/JSB+4XiHCCBkbXwUTurFKtqfQAaRMSzZ3X40Tipt3LlSoT2/
         iCUCvzqNXh0qRPlPEDp0dJh2DDpoUT+T31L7QwB2gVfSBbXwx+TW0jun7YOilKDP8Eer
         ndG35jij4i1lB7pBOIsaRtZmZ1V7ddHtBObsP1l3EUCVYLsBFZ7KYVoP3OGmFN4KAJTt
         7Pnw==
X-Gm-Message-State: APjAAAWRhm3GZX3+OKubdsggGjBolF6ZKJh8rySYwVE6iJ3ZGwl4iz12
        FISgtp35CQN/9uvGxDt8DUizVJuSy0oB6DEEzY6hm+f/kFpX
X-Google-Smtp-Source: APXvYqyzEWR89LxNgxDoF47i1h/7OJTIpGxPi8I2h9ZqeeslrJ/DgF3mMDQXP9CPOgEjdSccRU2WxAuIOtsv9bM4SM9zUTMPZd9M
MIME-Version: 1.0
X-Received: by 2002:a6b:8e57:: with SMTP id q84mr7080450iod.41.1569388147132;
 Tue, 24 Sep 2019 22:09:07 -0700 (PDT)
Date:   Tue, 24 Sep 2019 22:09:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000067302059359a78e@google.com>
Subject: INFO: trying to register non-static key in finish_writeback_work
From:   syzbot <syzbot+21875b598ddcdc309b28@syzkaller.appspotmail.com>
To:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b41dae06 Merge tag 'xfs-5.4-merge-7' of git://git.kernel.o..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17d19a7e600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dfcf592db22b9132
dashboard link: https://syzkaller.appspot.com/bug?extid=21875b598ddcdc309b28
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15fcf1a1600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+21875b598ddcdc309b28@syzkaller.appspotmail.com

INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 0 PID: 2603 Comm: kworker/u4:4 Not tainted 5.3.0+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: writeback wb_workfn (flush-8:0)
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  assign_lock_key kernel/locking/lockdep.c:881 [inline]
  register_lock_class+0x179e/0x1850 kernel/locking/lockdep.c:1190
  __lock_acquire+0xf4/0x4e70 kernel/locking/lockdep.c:3837
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4487
  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
  _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:159
  __wake_up_common_lock+0xc8/0x150 kernel/sched/wait.c:122
  __wake_up+0xe/0x10 kernel/sched/wait.c:142
  finish_writeback_work.isra.0+0xf6/0x120 fs/fs-writeback.c:168
  wb_do_writeback fs/fs-writeback.c:2030 [inline]
  wb_workfn+0x34f/0x11e0 fs/fs-writeback.c:2070
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 2603 Comm: kworker/u4:4 Not tainted 5.3.0+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: writeback wb_workfn (flush-8:0)
RIP: 0010:__wake_up_common+0xdf/0x610 kernel/sched/wait.c:86
Code: 05 00 00 4c 8b 43 38 49 83 e8 18 49 8d 78 18 48 39 7d d0 0f 84 64 02  
00 00 48 b8 00 00 00 00 00 fc ff df 48 89 f9 48 c1 e9 03 <80> 3c 01 00 0f  
85 0b 05 00 00 49 8b 40 18 89 55 b0 31 db 49 bc 00
RSP: 0018:ffff8880a1dc7a90 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: ffff888079642000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 1ffffffff138d60e RDI: 0000000000000000
RBP: ffff8880a1dc7ae8 R08: ffffffffffffffe8 R09: ffff8880a1dc7b38
R10: ffffed10143b8f4b R11: 0000000000000003 R12: 0000000000000000
R13: 0000000000000286 R14: 0000000000000000 R15: 0000000000000003
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2e620020 CR3: 00000000a3f3e000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  __wake_up_common_lock+0xea/0x150 kernel/sched/wait.c:123
  __wake_up+0xe/0x10 kernel/sched/wait.c:142
  finish_writeback_work.isra.0+0xf6/0x120 fs/fs-writeback.c:168
  wb_do_writeback fs/fs-writeback.c:2030 [inline]
  wb_workfn+0x34f/0x11e0 fs/fs-writeback.c:2070
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace a54dff274d7cf269 ]---
RIP: 0010:__wake_up_common+0xdf/0x610 kernel/sched/wait.c:86
Code: 05 00 00 4c 8b 43 38 49 83 e8 18 49 8d 78 18 48 39 7d d0 0f 84 64 02  
00 00 48 b8 00 00 00 00 00 fc ff df 48 89 f9 48 c1 e9 03 <80> 3c 01 00 0f  
85 0b 05 00 00 49 8b 40 18 89 55 b0 31 db 49 bc 00
RSP: 0018:ffff8880a1dc7a90 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: ffff888079642000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 1ffffffff138d60e RDI: 0000000000000000
RBP: ffff8880a1dc7ae8 R08: ffffffffffffffe8 R09: ffff8880a1dc7b38
R10: ffffed10143b8f4b R11: 0000000000000003 R12: 0000000000000000
R13: 0000000000000286 R14: 0000000000000000 R15: 0000000000000003
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2e620020 CR3: 00000000a3f3e000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
