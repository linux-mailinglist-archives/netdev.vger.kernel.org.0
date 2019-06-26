Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB9D256F88
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 19:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfFZRc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 13:32:56 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:50305 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbfFZRcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 13:32:55 -0400
Received: by mail-io1-f71.google.com with SMTP id m26so3344204ioh.17
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 10:32:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=nMT5FioGFdyvzIgPbIYCsZ5hPNKhgIXY/QNeLPVyeZY=;
        b=aA6qFlL5pje49kx267WHkjiVVshd99kDkynE6oiivIJMKgLlfq2qrpo4bRcxKrtmh1
         NpKmw/RdCXEzZKpCWhUYQ/SyKpTek/6H6/uAXHqb03RzGwupu62YawLmlMFa+gqwni8P
         LMAk9/PkdAL6MrkOHUdPm9WOyDkbaebsmR8x/nz1zieqNZ4x1sIlgxXTklP2FSKz6AsH
         9xss1VMw+Q1N8vY0HPHBMV6Aip5+kYZpbwpy10zqq+vqoi0SgXX1oLZnvbX7pMR1+rrg
         7+e4y+9k6dpudoU0HO5WW4JkeGKtWOqFHMb1kgeK3DWzT7ofs0pNCVZEJmtCb6kIOUu5
         FDXQ==
X-Gm-Message-State: APjAAAUFlp/57QrzRRdrsXIOBU+jGo8RB9PpjEG8TpxIm7kdb+tdMkPQ
        WZAWVXTOMVMRF6aaKEJiUObPH+h4ng9BqIrmNdPOzNymuPKS
X-Google-Smtp-Source: APXvYqwoqbpevi0oNIrYo99AxXhfPlFNWFTySK9Skhyl6+h7eI5rXg1AW5lI8CCkZq75G9V7i8fNEde0WHAryBYgZSdxm5rwYGVE
MIME-Version: 1.0
X-Received: by 2002:a6b:b7d5:: with SMTP id h204mr6164466iof.188.1561570028284;
 Wed, 26 Jun 2019 10:27:08 -0700 (PDT)
Date:   Wed, 26 Jun 2019 10:27:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d3f34b058c3d5a4f@google.com>
Subject: INFO: rcu detected stall in ext4_write_checks
From:   syzbot <syzbot+4bfbbf28a2e50ab07368@syzkaller.appspotmail.com>
To:     adilger.kernel@dilger.ca, davem@davemloft.net, eladr@mellanox.com,
        idosch@mellanox.com, jiri@mellanox.com, john.stultz@linaro.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    abf02e29 Merge tag 'pm-5.2-rc6' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1435aaf6a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e5c77f8090a3b96b
dashboard link: https://syzkaller.appspot.com/bug?extid=4bfbbf28a2e50ab07368
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11234c41a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15d7f026a00000

The bug was bisected to:

commit 0c81ea5db25986fb2a704105db454a790c59709c
Author: Elad Raz <eladr@mellanox.com>
Date:   Fri Oct 28 19:35:58 2016 +0000

     mlxsw: core: Add port type (Eth/IB) set API

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10393a89a00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12393a89a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14393a89a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4bfbbf28a2e50ab07368@syzkaller.appspotmail.com
Fixes: 0c81ea5db259 ("mlxsw: core: Add port type (Eth/IB) set API")

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
	(detected by 0, t=10502 jiffies, g=8969, q=26)
rcu: All QSes seen, last rcu_preempt kthread activity 10503  
(4295056736-4295046233), jiffies_till_next_fqs=1, root ->qsmask 0x0
syz-executor778 R  running task    26464  9577   9576 0x00004000
Call Trace:
  <IRQ>
  sched_show_task kernel/sched/core.c:5286 [inline]
  sched_show_task.cold+0x291/0x2fc kernel/sched/core.c:5261
  print_other_cpu_stall kernel/rcu/tree_stall.h:410 [inline]
  check_cpu_stall kernel/rcu/tree_stall.h:536 [inline]
  rcu_pending kernel/rcu/tree.c:2625 [inline]
  rcu_sched_clock_irq.cold+0xaaf/0xbfd kernel/rcu/tree.c:2161
  update_process_times+0x32/0x80 kernel/time/timer.c:1639
  tick_sched_handle+0xa2/0x190 kernel/time/tick-sched.c:167
  tick_sched_timer+0x47/0x130 kernel/time/tick-sched.c:1298
  __run_hrtimer kernel/time/hrtimer.c:1389 [inline]
  __hrtimer_run_queues+0x33b/0xdd0 kernel/time/hrtimer.c:1451
  hrtimer_interrupt+0x314/0x770 kernel/time/hrtimer.c:1509
  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1041 [inline]
  smp_apic_timer_interrupt+0x111/0x550 arch/x86/kernel/apic/apic.c:1066
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:806
  </IRQ>
RIP: 0010:ext4_write_checks+0x1/0x260 fs/ext4/file.c:161
Code: 61 fa ff ff e8 e0 3c 53 ff 55 48 89 e5 41 54 49 89 fc e8 f2 0a 81 ff  
4c 89 e7 31 f6 e8 98 f9 ff ff 41 5c 5d c3 0f 1f 40 00 55 <48> 89 e5 41 56  
41 55 49 89 f5 41 54 53 48 89 fb e8 ca 0a 81 ff 48
RSP: 0018:ffff888093a97640 EFLAGS: 00000293 ORIG_RAX: ffffffffffffff13
RAX: ffff88809901c100 RBX: ffff888093a977d8 RCX: ffffffff81efcb42
RDX: 0000000000000000 RSI: ffff888093a97a08 RDI: ffff888093a977d8
RBP: ffff888093a97768 R08: ffff88809901c100 R09: ffff88809901c9c8
R10: ffff88809901c9a8 R11: ffff88809901c100 R12: 0000000000000001
R13: ffff8880995df4f0 R14: ffff888093a97740 R15: 0000000000000000
  call_write_iter include/linux/fs.h:1872 [inline]
  do_iter_readv_writev+0x5f8/0x8f0 fs/read_write.c:693
  do_iter_write fs/read_write.c:970 [inline]
  do_iter_write+0x184/0x610 fs/read_write.c:951
  vfs_iter_write+0x77/0xb0 fs/read_write.c:983
  iter_file_splice_write+0x65c/0xbd0 fs/splice.c:746
  do_splice_from fs/splice.c:848 [inline]
  direct_splice_actor+0x123/0x190 fs/splice.c:1020
  splice_direct_to_actor+0x366/0x970 fs/splice.c:975
  do_splice_direct+0x1da/0x2a0 fs/splice.c:1063
  do_sendfile+0x597/0xd00 fs/read_write.c:1464
  __do_sys_sendfile64 fs/read_write.c:1519 [inline]
  __se_sys_sendfile64 fs/read_write.c:1511 [inline]
  __x64_sys_sendfile64+0x15a/0x220 fs/read_write.c:1511
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4417c9
Code: e8 7c e7 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 bb 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffce5c38198 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007ffce5c38340 RCX: 00000000004417c9
RDX: 0000000020000000 RSI: 0000000000000003 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 00008080fffffffe R11: 0000000000000246 R12: 0000000000000000
R13: 00000000004024a0 R14: 0000000000000000 R15: 0000000000000000
rcu: rcu_preempt kthread starved for 10549 jiffies! g8969 f0x2  
RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: RCU grace-period kthread stack dump:
rcu_preempt     R  running task    29056    10      2 0x80004000
Call Trace:
  context_switch kernel/sched/core.c:2818 [inline]
  __schedule+0x7cb/0x1560 kernel/sched/core.c:3445
  schedule+0xa8/0x260 kernel/sched/core.c:3509
  schedule_timeout+0x486/0xc50 kernel/time/timer.c:1807
  rcu_gp_fqs_loop kernel/rcu/tree.c:1589 [inline]
  rcu_gp_kthread+0x9b2/0x18b0 kernel/rcu/tree.c:1746
  kthread+0x354/0x420 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
