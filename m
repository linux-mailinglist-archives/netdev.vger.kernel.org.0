Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C00EEBBB42
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 20:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732985AbfIWS0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 14:26:12 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:39867 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732962AbfIWS0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 14:26:12 -0400
Received: by mail-io1-f69.google.com with SMTP id f9so11385951ioh.6
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 11:26:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Wp+WOxmIS7xEA02hFIkA48OyPRBkMcKVWO+Q59/ep3w=;
        b=BbvhVTuJd8wW6Wij1wgftNxEKtuilO6LD8P9dQwQZ7tuCRGN4B0XjIo/kPSi8PSmSL
         FQaIPrTqDNllNrpqaM8duJ6XFNOoENPx+f1lzmdhCc5BX62TNXwj4d6QnYyObw+02hdi
         g/UZh4rO8dA9llgZX+Jeo3AaKWeI7Lyyy8ZWOaMdUOmToCSFHKbSaURpC2v686PMalbI
         yRBqEluXzobURrZuDtcPFWeuLWRBf2hoNz7zdGrZT0zwp7UYeq0Nti89D3HH3NpYaqtY
         j8fjET/jSmzAI3zuN3oUgQljhpD+WwDbNuO6IZiZ9X52oSbFff6bZNrkQt6eVFvLaEM3
         6r2w==
X-Gm-Message-State: APjAAAXLpMLa3zIf5eVU+JQg3Lbt4OJRTNHS6BAxfcOpDl3kV4UuX5XT
        /akHIwU6yMGzI9MobyAtnpCDt6mweQcVo/3UrmAOShqZbWbm
X-Google-Smtp-Source: APXvYqxXKvyI6gkF2fxEbgVSBMSnm/K5sNn1xNC4xSjPHJP1Zu+7ehuPVelloZn8PCtalDMPhbxYLmpW2im/PNrqrRraa3dXqS0B
MIME-Version: 1.0
X-Received: by 2002:a5e:8c17:: with SMTP id n23mr818164ioj.46.1569263171386;
 Mon, 23 Sep 2019 11:26:11 -0700 (PDT)
Date:   Mon, 23 Sep 2019 11:26:11 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e3c7de05933c8d39@google.com>
Subject: general protection fault in finish_writeback_work
From:   syzbot <syzbot+828abc56e48ada4b0195@syzkaller.appspotmail.com>
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

HEAD commit:    24ccb0ab qede: qede_fp: simplify a bit 'qede_rx_build_skb()'
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=11a5b229600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dfcf592db22b9132
dashboard link: https://syzkaller.appspot.com/bug?extid=828abc56e48ada4b0195
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+828abc56e48ada4b0195@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8777 Comm: kworker/u4:5 Not tainted 5.3.0+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: writeback wb_workfn (flush-8:0)
RIP: 0010:__lock_acquire+0x1265/0x4e70 kernel/locking/lockdep.c:3828
Code: 00 0f 85 0e 26 00 00 48 81 c4 e8 00 00 00 5b 41 5c 41 5d 41 5e 41 5f  
5d c3 48 b8 00 00 00 00 00 fc ff df 4c 89 f2 48 c1 ea 03 <80> 3c 02 00 0f  
85 dd 2a 00 00 49 81 3e a0 25 06 8a 0f 84 4e ee ff
RSP: 0018:ffff88806930f938 EFLAGS: 00010007
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 03fffe22022b47e2 RSI: 0000000000000000 RDI: 0000000000000001
RBP: ffff88806930fa48 R08: 0000000000000001 R09: 0000000000000001
R10: fffffbfff138cf90 R11: ffff8880693002c0 R12: 1ffff110115a3f15
R13: 0000000000000000 R14: 1ffff110115a3f15 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2136820ea0 CR3: 000000008ab86000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
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
Modules linked in:
---[ end trace b7a1091622454beb ]---
RIP: 0010:__lock_acquire+0x1265/0x4e70 kernel/locking/lockdep.c:3828
Code: 00 0f 85 0e 26 00 00 48 81 c4 e8 00 00 00 5b 41 5c 41 5d 41 5e 41 5f  
5d c3 48 b8 00 00 00 00 00 fc ff df 4c 89 f2 48 c1 ea 03 <80> 3c 02 00 0f  
85 dd 2a 00 00 49 81 3e a0 25 06 8a 0f 84 4e ee ff
RSP: 0018:ffff88806930f938 EFLAGS: 00010007
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 03fffe22022b47e2 RSI: 0000000000000000 RDI: 0000000000000001
RBP: ffff88806930fa48 R08: 0000000000000001 R09: 0000000000000001
R10: fffffbfff138cf90 R11: ffff8880693002c0 R12: 1ffff110115a3f15
R13: 0000000000000000 R14: 1ffff110115a3f15 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2136820ea0 CR3: 000000008ab86000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
