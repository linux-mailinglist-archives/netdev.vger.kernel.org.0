Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836683B58D6
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 07:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbhF1F7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 01:59:52 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:38443 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbhF1F7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 01:59:40 -0400
Received: by mail-io1-f72.google.com with SMTP id q7-20020a5d87c70000b02904eff8ce1ea0so8163052ios.5
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 22:57:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=NZiHOP66CN3/d3r09QWR20u5KTe63dZhDT9GX98ADZE=;
        b=PFfjCL7GqpPO0yGatMyby7PiUjO0zU2ClMC9/wcrD/NmgKuga13ohXNOH6BH8YMA0v
         k9t7AVTuZaWapzJxuDsDr9Pq4p+TaQXi7BLsDSaneCq41qi3o/1f9IuyfvCEhkxKNlEa
         kb5Rt2yuF/mVq2ldfvIIYQ2GJKG7VFr2mReQeC3I4y16MWTA7t+DJQ8IeznhsXhMaE6e
         bDWxSmyS2BRDGyZPPpmSSdMOzJA/DTPSEIgg4MIqLzv+7LMRLtivsZv/DOU7tg0NBw6g
         OrjguP3G8nBscb3OkU7Y1RNQQkJ4H6Na17j4g9hpFQyo8WML97vmqgzd2I14n2Z1IR2M
         pr+Q==
X-Gm-Message-State: AOAM530sc7WeeN63va0CcaatxXDzykp4dFFbMYVmGavO9oM3VOM3Y5KP
        FlNUVebAvucR2GxvOWvGHaqCrt8pEAeiLku7zIbR6Va7Pufi
X-Google-Smtp-Source: ABdhPJyVpCwX1N8AuMDdD5DBKGlQWtCf2XKmIlAljvfGYQzEV66j1fnci6D6i9DyvzjYqPhyRYwdvaPHdX0++rYkrNEepIueusfi
MIME-Version: 1.0
X-Received: by 2002:a6b:5c0a:: with SMTP id z10mr19934094ioh.122.1624859834952;
 Sun, 27 Jun 2021 22:57:14 -0700 (PDT)
Date:   Sun, 27 Jun 2021 22:57:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000045ad9705c5cd29ab@google.com>
Subject: [syzbot] INFO: task can't die in p9_client_rpc (3)
From:   syzbot <syzbot+716aab0e63b2895e1811@syzkaller.appspotmail.com>
To:     asmadeus@codewreck.org, davem@davemloft.net, ericvh@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a1f92694 Add linux-next specific files for 20210518
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10805a64300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d612e75ffd53a6d3
dashboard link: https://syzkaller.appspot.com/bug?extid=716aab0e63b2895e1811

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+716aab0e63b2895e1811@syzkaller.appspotmail.com

INFO: task syz-executor.2:17696 can't die for more than 143 seconds.
task:syz-executor.2  state:D stack:27376 pid:17696 ppid:  8468 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4688 [inline]
 __schedule+0xb38/0x58c0 kernel/sched/core.c:5945
 schedule+0xcf/0x270 kernel/sched/core.c:6024
 p9_client_rpc+0x405/0x1240 net/9p/client.c:759
 p9_client_flush+0x1f9/0x430 net/9p/client.c:667
 p9_client_rpc+0xfe3/0x1240 net/9p/client.c:784
 p9_client_version net/9p/client.c:955 [inline]
 p9_client_create+0xae1/0x1110 net/9p/client.c:1055
 v9fs_session_init+0x1dd/0x17b0 fs/9p/v9fs.c:406
 v9fs_mount+0x79/0x9c0 fs/9p/vfs_super.c:126
 legacy_get_tree+0x105/0x220 fs/fs_context.c:592
 vfs_get_tree+0x89/0x2f0 fs/super.c:1498
 do_new_mount fs/namespace.c:2905 [inline]
 path_mount+0x132a/0x1fa0 fs/namespace.c:3235
 do_mount fs/namespace.c:3248 [inline]
 __do_sys_mount fs/namespace.c:3456 [inline]
 __se_sys_mount fs/namespace.c:3433 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3433
 do_syscall_64+0x31/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
RSP: 002b:00007f42a9fe9188 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665d9
RDX: 0000000020000200 RSI: 0000000020000000 RDI: 0000000000000000
RBP: 00000000004bfcb9 R08: 0000000020000440 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffdec5a8f0f R14: 00007f42a9fe9300 R15: 0000000000022000

Showing all locks held in the system:
1 lock held by khungtaskd/1641:
 #0: ffffffff8c17afe0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6333
1 lock held by in:imklog/8364:
 #0: ffff888025c12370 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:990
4 locks held by rs:main Q:Reg/8365:
 #0: ffff8880b9c35718 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2b/0x120 kernel/sched/core.c:460
 #1: ffff8880b9c1f988 (&per_cpu_ptr(group->pcpu, cpu)->seq){-.-.}-{0:0}, at: psi_task_switch+0x24c/0x670 kernel/sched/psi.c:872
 #2: ffff88802e7cf230 (&sb->s_type->i_mutex_key#10){++++}-{3:3}, at: inode_lock include/linux/fs.h:774 [inline]
 #2: ffff88802e7cf230 (&sb->s_type->i_mutex_key#10){++++}-{3:3}, at: ext4_buffered_write_iter+0xb6/0x4d0 fs/ext4/file.c:263
 #3: ffff88802e7cf4f8 (&ei->i_raw_lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:359 [inline]
 #3: ffff88802e7cf4f8 (&ei->i_raw_lock){+.+.}-{2:2}, at: ext4_do_update_inode fs/ext4/inode.c:5033 [inline]
 #3: ffff88802e7cf4f8 (&ei->i_raw_lock){+.+.}-{2:2}, at: ext4_mark_iloc_dirty+0x213/0x38d0 fs/ext4/inode.c:5724
2 locks held by agetty/8383:
 #0: ffff888015b94098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:253
 #1: ffffc90000fdc2e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xcf0/0x1230 drivers/tty/n_tty.c:2113

=============================================



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
