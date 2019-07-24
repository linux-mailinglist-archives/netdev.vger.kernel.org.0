Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E538A737AA
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 21:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfGXTS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 15:18:27 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:52103 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728972AbfGXTSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 15:18:09 -0400
Received: by mail-io1-f71.google.com with SMTP id c5so51750290iom.18
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 12:18:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=+12BGyfj5tbWX5WuoPOq9y3PhelyQ+8mPqbDPnhEVzo=;
        b=OkgJ9i/fspKybpuWul9VTvRrU/9BfsrzD7TiwAfjuiye0mRb5Dxrk8+8zNvf5AHVbo
         3aQNMIsQQBsiW22AAnB2n4Iug2BzQEe0VnMJIbD5WjopV9EI3vbtXeoR/RxLSBhmoUew
         oL8YCDx2DDiESOOuAXyp21NcsxOuw21bNqdCUkfCREkycHK4Vu8yBKKGyGaaPGr8xybP
         9HIH5xSZAnX+PMKQKTBjEpXSY7ueT/vf2E1NqzKFQCscvqofYXcAVRehHgBl7GTw0qAL
         SI6kG9au69h3EyyGDjGLLFao4mllGfVc6wO6D/sDY1RUz95ArWMnxGR43dQmSYqNa7TH
         S/Pg==
X-Gm-Message-State: APjAAAVniMzPA14CTrYGafvFIIXDaaF71kRhBC/xZNNtGyVo81/bjWHw
        a2v2eTeThjqgBkqXW7XZU0GdiV69CitNFzK6287fTU79SEbm
X-Google-Smtp-Source: APXvYqzrveDnVjWnhpRCtNoBbE6aQKt12eCs95S1sUGbzWHPCDnySGIySR0fc/DvrPbVKh2/fY3zZXKGAAKFP9BkQi2Ea14TJJKw
MIME-Version: 1.0
X-Received: by 2002:a6b:b497:: with SMTP id d145mr54785605iof.17.1563995888091;
 Wed, 24 Jul 2019 12:18:08 -0700 (PDT)
Date:   Wed, 24 Jul 2019 12:18:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000057102e058e722bba@google.com>
Subject: INFO: task hung in perf_event_free_task
From:   syzbot <syzbot+7692cea7450c97fa2a0a@syzkaller.appspotmail.com>
To:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        jolsa@redhat.com, kafai@fb.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
        peterz@infradead.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    c6dd78fc Merge branch 'x86-urgent-for-linus' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10b33b58600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7937b718ddac333b
dashboard link: https://syzkaller.appspot.com/bug?extid=7692cea7450c97fa2a0a
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17e888cc600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+7692cea7450c97fa2a0a@syzkaller.appspotmail.com

INFO: task syz-executor.0:9658 blocked for more than 143 seconds.
       Not tainted 5.2.0+ #37
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.0  D25992  9658   7837 0x00004006
Call Trace:
  context_switch kernel/sched/core.c:3254 [inline]
  __schedule+0x8b7/0xcd0 kernel/sched/core.c:3880
  schedule+0x12f/0x1d0 kernel/sched/core.c:3944
  perf_event_free_task+0x52a/0x630 kernel/events/core.c:11606
  copy_process+0x39bb/0x5a00 kernel/fork.c:2283
  _do_fork+0x179/0x630 kernel/fork.c:2369
  __do_sys_clone kernel/fork.c:2524 [inline]
  __se_sys_clone kernel/fork.c:2505 [inline]
  __x64_sys_clone+0x247/0x2b0 kernel/fork.c:2505
  do_syscall_64+0xfe/0x140 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459829
Code: dd fe ff ff cc cc cc cc cc cc cc cc cc cc cc cc cc 64 48 8b 0c 25 f8  
ff ff ff 48 3b 61 10 76 68 48 83 ec 28 48 89 6c 24 20 48 <8d> 6c 24 20 48  
8b 44 24 30 48 89 04 24 48 8b 4c 24 38 48 89 4c 24
RSP: 002b:00007f2b371d8c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 0000000000459829
RDX: 9999999999999999 RSI: 0000000000000000 RDI: 0000002102001ffe
RBP: 000000000075bf20 R08: ffffffffffffffff R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f2b371d96d4
R13: 00000000004bfce6 R14: 00000000004d17f8 R15: 00000000ffffffff

Showing all locks held in the system:
1 lock held by khungtaskd/1056:
  #0: 000000004ef21d86 (rcu_read_lock){....}, at: rcu_lock_acquire+0x4/0x30  
include/linux/rcupdate.h:207
1 lock held by rsyslogd/7708:
  #0: 000000001dbc8cee (&f->f_pos_lock){+.+.}, at: __fdget_pos+0x243/0x2e0  
fs/file.c:801
2 locks held by getty/7798:
  #0: 00000000ad2eb6b3 (&tty->ldisc_sem){++++}, at:  
tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:272
  #1: 0000000067bda1b9 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x2ee/0x1c80 drivers/tty/n_tty.c:2156
2 locks held by getty/7799:
  #0: 00000000e86f0102 (&tty->ldisc_sem){++++}, at:  
tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:272
  #1: 00000000f10c3522 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x2ee/0x1c80 drivers/tty/n_tty.c:2156
2 locks held by getty/7800:
  #0: 00000000f4a9ed02 (&tty->ldisc_sem){++++}, at:  
tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:272
  #1: 00000000759669da (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x2ee/0x1c80 drivers/tty/n_tty.c:2156
2 locks held by getty/7801:
  #0: 00000000c998e0d2 (&tty->ldisc_sem){++++}, at:  
tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:272
  #1: 000000007c9ea7de (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x2ee/0x1c80 drivers/tty/n_tty.c:2156
2 locks held by getty/7802:
  #0: 00000000398be820 (&tty->ldisc_sem){++++}, at:  
tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:272
  #1: 00000000deef3632 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x2ee/0x1c80 drivers/tty/n_tty.c:2156
2 locks held by getty/7803:
  #0: 00000000fa979d44 (&tty->ldisc_sem){++++}, at:  
tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:272
  #1: 000000003715a25d (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x2ee/0x1c80 drivers/tty/n_tty.c:2156
2 locks held by getty/7804:
  #0: 000000009d01c162 (&tty->ldisc_sem){++++}, at:  
tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:272
  #1: 0000000010022d29 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x2ee/0x1c80 drivers/tty/n_tty.c:2156

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1056 Comm: khungtaskd Not tainted 5.2.0+ #37
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1d8/0x2f8 lib/dump_stack.c:113
  nmi_cpu_backtrace+0xb0/0x1a0 lib/nmi_backtrace.c:101
  nmi_trigger_cpumask_backtrace+0x14c/0x240 lib/nmi_backtrace.c:62
  arch_trigger_cpumask_backtrace+0x10/0x20 arch/x86/kernel/apic/hw_nmi.c:38
  trigger_all_cpu_backtrace+0x17/0x20 include/linux/nmi.h:146
  check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
  watchdog+0xbcc/0xbe0 kernel/hung_task.c:289
  kthread+0x332/0x350 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1 skipped: idling at native_safe_halt+0xe/0x10  
arch/x86/include/asm/irqflags.h:60


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
