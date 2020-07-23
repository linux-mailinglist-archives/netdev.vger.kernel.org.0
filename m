Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A611322B1FC
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 16:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgGWO6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 10:58:19 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:54271 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbgGWO6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 10:58:19 -0400
Received: by mail-io1-f70.google.com with SMTP id g11so4195246ioc.20
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 07:58:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2ajYJta7gPomPQ3ggHDnk19Nes9XzOskd/Ob0MXDn1Q=;
        b=AwIIUE03dF5eWCiXGrzzjc3l4S19/occ3+Mz8czTrTJSCaxTKmrEvjZXi9TsvzXESE
         TlnJYBJIHTNDjfyq56Tq+GDnw/UpYzCnodU12eJjDFZCXJhuqSoqUKotyHc69FMuj/Jb
         5BqMhNw2jNvaz5ZZuOFfYofrlEWfY4B5xucmNMT6F+8MH8IV3u3CJYp7Qd0SRwdwKcEN
         urLnIQ1Eh5tNHZzEU7bfTzlUy1UyyLjjY3542Hw3ZqrwfEAS7JD45bdD/bQq+qqYEMN6
         628pL6AP9zmXlzBrCgVpdI0jiWppnjoDZCaY3rdCCT6ikeXh/kokvmZ3LYm8HLonuaQB
         0scg==
X-Gm-Message-State: AOAM533qCGCvpM9GKbWjScdorXGComp0onhVYbQD+jP9ZgarM48O6cMZ
        Er8rLUuj/tNeXSCzB3HlEprSLT5lP+ug/Deb3WrTUNIRXAaO
X-Google-Smtp-Source: ABdhPJxLPDPDJRModLlh6+FmiV2EJvPa918pxVPpQoJibFragVrEp0RB2Fxbt3WIi/1jUJ23r9Z4DlX6231HTfFDUZrEo1SL9Iu0
MIME-Version: 1.0
X-Received: by 2002:a5e:dc03:: with SMTP id b3mr5032711iok.97.1595516298141;
 Thu, 23 Jul 2020 07:58:18 -0700 (PDT)
Date:   Thu, 23 Jul 2020 07:58:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002f24fc05ab1d1669@google.com>
Subject: WARNING: locking bug in sock_def_write_space
From:   syzbot <syzbot+cc67536ed6798a962957@syzkaller.appspotmail.com>
To:     christophe.jaillet@wanadoo.fr, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        navid.emamdoost@gmail.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d15be546 Merge tag 'media/v5.8-3' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1356c130900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f87a5e4232fdb267
dashboard link: https://syzkaller.appspot.com/bug?extid=cc67536ed6798a962957
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cc67536ed6798a962957@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 0 PID: 15816 at kernel/locking/lockdep.c:183 hlock_class kernel/locking/lockdep.c:183 [inline]
WARNING: CPU: 0 PID: 15816 at kernel/locking/lockdep.c:183 hlock_class kernel/locking/lockdep.c:172 [inline]
WARNING: CPU: 0 PID: 15816 at kernel/locking/lockdep.c:183 check_wait_context kernel/locking/lockdep.c:4054 [inline]
WARNING: CPU: 0 PID: 15816 at kernel/locking/lockdep.c:183 __lock_acquire+0x1629/0x56e0 kernel/locking/lockdep.c:4330
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 15816 Comm: syz-executor.5 Not tainted 5.8.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:231
 __warn.cold+0x20/0x45 kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:235
 exc_invalid_op+0x13/0x40 arch/x86/kernel/traps.c:255
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:540
RIP: 0010:hlock_class kernel/locking/lockdep.c:183 [inline]
RIP: 0010:hlock_class kernel/locking/lockdep.c:172 [inline]
RIP: 0010:check_wait_context kernel/locking/lockdep.c:4054 [inline]
RIP: 0010:__lock_acquire+0x1629/0x56e0 kernel/locking/lockdep.c:4330
Code: 08 84 d2 0f 85 bd 35 00 00 8b 35 e2 4e 55 09 85 f6 0f 85 cc fa ff ff 48 c7 c6 20 b0 4b 88 48 c7 c7 20 ab 4b 88 e8 b9 44 eb ff <0f> 0b e9 b2 fa ff ff e8 7b 20 8c 06 85 c0 0f 84 ed fa ff ff 48 c7
RSP: 0018:ffffc900174df6a0 EFLAGS: 00010082
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff888084610400 RSI: ffffffff815d4eb7 RDI: fffff52002e9bec6
RBP: ffff888084610cf8 R08: 0000000000000000 R09: ffffffff89bb5c23
R10: 0000000000001626 R11: 0000000000000001 R12: ffff888084610400
R13: 0000000000001924 R14: ffff888059583598 R15: 0000000000040000
 lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:4959
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x8c/0xc0 kernel/locking/spinlock.c:159
 __wake_up_common_lock+0xb4/0x130 kernel/sched/wait.c:122
 sock_def_write_space+0x1fd/0x630 net/core/sock.c:2927
 sock_wfree+0x1cc/0x240 net/core/sock.c:2060
 skb_release_head_state+0x9f/0x250 net/core/skbuff.c:651
 skb_release_all net/core/skbuff.c:662 [inline]
 __kfree_skb net/core/skbuff.c:678 [inline]
 kfree_skb.part.0+0x89/0x350 net/core/skbuff.c:696
 kfree_skb+0x7d/0x100 include/linux/refcount.h:270
 skb_queue_purge+0x14/0x30 net/core/skbuff.c:3077
 qrtr_tun_release+0x40/0x60 net/qrtr/tun.c:118
 __fput+0x33c/0x880 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:135
 exit_task_work include/linux/task_work.h:25 [inline]
 do_exit+0xb72/0x2a40 kernel/exit.c:805
 do_group_exit+0x125/0x310 kernel/exit.c:903
 get_signal+0x40b/0x1ee0 kernel/signal.c:2743
 do_signal+0x82/0x2520 arch/x86/kernel/signal.c:810
 exit_to_usermode_loop arch/x86/entry/common.c:235 [inline]
 __prepare_exit_to_usermode+0x156/0x1f0 arch/x86/entry/common.c:269
 do_syscall_64+0x6c/0xe0 arch/x86/entry/common.c:393
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c1f9
Code: Bad RIP value.
RSP: 002b:00007f5c22616cf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 000000000078bf08 RCX: 000000000045c1f9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000078bf08
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bf0c
R13: 00007ffd6b37c0ff R14: 00007f5c226179c0 R15: 000000000078bf0c
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
