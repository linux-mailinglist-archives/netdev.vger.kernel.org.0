Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03BD4283275
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 10:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbgJEIs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 04:48:29 -0400
Received: from mail-io1-f78.google.com ([209.85.166.78]:42077 "EHLO
        mail-io1-f78.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgJEIs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 04:48:26 -0400
Received: by mail-io1-f78.google.com with SMTP id w3so4330221iou.9
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 01:48:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=G6GsEG0RkZVPyjNqFfG3gKAiPzYx/YvR1ErOT0J12wk=;
        b=P44PLIaz2EmHfhcazwPVfQa+NLupQsdNyrY49aIbA4exFI+TK/h+xa+sck5WRqUszL
         3WhGryikQsI03dKWt7QKpUbyg9KJMWb3cVDWW4ZZnlUyBR6qcYVbXuZ97YqxqvIi4Xzo
         e0m1GWrIrNzzrhEHPOmCQQHz5olNi1mN5l+y68bkoyB8L/gkrn307bplynnchqVl0m0F
         kqpdhuf9V0lORF0pgl5C1wPKE/EsFBMO3ldjezmEM1NShmBw87lc/grGi1Dlj6ebtIEn
         Bd+WEBViPlh4S9yIEdaBpUNRgUpW60DSStIUzIQJDX0JL6t5VDzz6wzCHABRGHrOsevl
         P6KQ==
X-Gm-Message-State: AOAM532oc5jK4og4d+4Hcf7P9ty4edKFbQytwCKvXy1kMLHTa0May/ef
        ikAGVLJja3PH+ppZjZraPxHWUnBiyxzoedxwaDUGnL488rLx
X-Google-Smtp-Source: ABdhPJxw2ZHnZrRMBSuA1WY+gur9HBw2dHlqtd6vUguLvgBjUDr/uw/WblqcEjpQDK1G6HYqIVz6onKMWuISYP6z3YVBcHt47jO4
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:130e:: with SMTP id g14mr5716639ilr.205.1601887705328;
 Mon, 05 Oct 2020 01:48:25 -0700 (PDT)
Date:   Mon, 05 Oct 2020 01:48:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a5738205b0e88b7d@google.com>
Subject: WARNING in __ib_unregister_device
From:   syzbot <syzbot+8f167a5e27d042b88f5e@syzkaller.appspotmail.com>
To:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f5083d0c drivers/net/wan/hdlc_fr: Improvements to the code..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11546beb900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1e6c5266df853ae
dashboard link: https://syzkaller.appspot.com/bug?extid=8f167a5e27d042b88f5e
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8f167a5e27d042b88f5e@syzkaller.appspotmail.com

smc: removing ib device syz1
------------[ cut here ]------------
sysfs group 'power' not found for kobject 'syz1'
WARNING: CPU: 1 PID: 30473 at fs/sysfs/group.c:279 sysfs_remove_group+0x126/0x170 fs/sysfs/group.c:279
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 30473 Comm: kworker/u4:0 Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_unbound ib_unregister_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 panic+0x382/0x7fb kernel/panic.c:231
 __warn.cold+0x20/0x4b kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:sysfs_remove_group+0x126/0x170 fs/sysfs/group.c:279
Code: 48 89 d9 49 8b 14 24 48 b8 00 00 00 00 00 fc ff df 48 c1 e9 03 80 3c 01 00 75 37 48 8b 33 48 c7 c7 c0 31 9b 88 e8 8c ae 58 ff <0f> 0b eb 98 e8 a1 69 ca ff e9 01 ff ff ff 48 89 df e8 94 69 ca ff
RSP: 0018:ffffc9001599fbd8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffffffff88fa00e0 RCX: 0000000000000000
RDX: ffff888065092380 RSI: ffffffff815f7935 RDI: fffff52002b33f6d
RBP: 0000000000000000 R08: 0000000000000001 R09: ffff8880ae531927
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8880666c46d8
R13: ffffffff88fa0680 R14: ffff8880a6adb100 R15: ffff8880aa071800
 dpm_sysfs_remove+0x97/0xb0 drivers/base/power/sysfs.c:801
 device_del+0x18b/0xd90 drivers/base/core.c:3080
 __ib_unregister_device+0xb5/0x1a0 drivers/infiniband/core/device.c:1464
 ib_unregister_work+0x15/0x30 drivers/infiniband/core/device.c:1569
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
