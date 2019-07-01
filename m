Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 345095B6CC
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 10:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbfGAI1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 04:27:06 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:37940 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727242AbfGAI1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 04:27:05 -0400
Received: by mail-io1-f72.google.com with SMTP id h4so14467485iol.5
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 01:27:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=GC+x39g8IYbrwQLY2vbqdImonYYsq5udUTs88YPbw4c=;
        b=sCJElZjLnA6+WWI2WSq7CVfERQpSNJiSiA2R1ufVXlUd1QD39n0ZXtpfiK9zQmSGA4
         IKG6kOgrBWpSYgBByl0/tG/f0uXyqWcFpJSqVedz0zHCwFPiGmDdYfvXOeRQhqkGuV6l
         q1ZG/XRyUSirXGbwdwIEelmm8G4ElzG2eElHa0K78QZbhZc5/p20QetpHdXJ9R3bBnKC
         F8p45/9oso2pFoTTxWJD1svHeHH1WkaF8nfbz6yY+AM3Oi80BpTw9CvvDHXYlw0mcF+I
         XymmmKx0PpiH1UrdEWiDhKj5rel6DawWCTdMaIbBUuumnMGHU1erJW23xvAlMNo1MmC/
         4gXQ==
X-Gm-Message-State: APjAAAWJmagadCPj14i5UT+C5yBCNVc3MfD11Jou5gJ7K5czn6ocFNq6
        w2PPcDUryyIx/kPZmShPReo0nf/indG6IJsN3uKe/F9LtDbq
X-Google-Smtp-Source: APXvYqzXk16c6JPKZk5Bi6NHsGlxPqYqwOLITlQ/xP5jq0+WNDdT9E5QYirBgLcGdfA7650FRi5Q8lkOPCoGC4bgX5mQkGfnsHjy
MIME-Version: 1.0
X-Received: by 2002:a5d:8890:: with SMTP id d16mr8303258ioo.274.1561969624992;
 Mon, 01 Jul 2019 01:27:04 -0700 (PDT)
Date:   Mon, 01 Jul 2019 01:27:04 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a5d3cb058c9a64f0@google.com>
Subject: kernel panic: corrupted stack end in dput
From:   syzbot <syzbot+d88a977731a9888db7ba@syzkaller.appspotmail.com>
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

HEAD commit:    7b75e49d net: dsa: mv88e6xxx: wait after reset deactivation
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=10f51b13a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e7c31a94f66cc0aa
dashboard link: https://syzkaller.appspot.com/bug?extid=d88a977731a9888db7ba
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=130f49bda00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d88a977731a9888db7ba@syzkaller.appspotmail.com

Kernel panic - not syncing: corrupted stack end detected inside scheduler
CPU: 1 PID: 8936 Comm: syz-executor.3 Not tainted 5.2.0-rc6+ #69
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2cb/0x744 kernel/panic.c:219
  schedule_debug kernel/sched/core.c:3272 [inline]
  __schedule+0x155d/0x1560 kernel/sched/core.c:3381
  preempt_schedule_notrace kernel/sched/core.c:3664 [inline]
  preempt_schedule_notrace+0xa0/0x130 kernel/sched/core.c:3635
  ___preempt_schedule_notrace+0x16/0x2f
  rcu_is_watching+0x23/0x30 kernel/rcu/tree.c:873
  rcu_read_lock include/linux/rcupdate.h:594 [inline]
  dput+0x41e/0x690 fs/dcache.c:845
  __fput+0x424/0x890 fs/file_table.c:293
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:185 [inline]
  exit_to_usermode_loop+0x273/0x2c0 arch/x86/entry/common.c:168
  prepare_exit_to_usermode arch/x86/entry/common.c:199 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
  do_syscall_64+0x58e/0x680 arch/x86/entry/common.c:304
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x413201
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48  
83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffcee6f8e20 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000006 RCX: 0000000000413201
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 0000000000000001 R08: ffffffffffffffff R09: ffffffffffffffff
R10: 00007ffcee6f8f00 R11: 0000000000000293 R12: 000000000075c9a0
R13: 000000000075c9a0 R14: 00000000000127ed R15: ffffffffffffffff
Shutting down cpus with NMI
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
