Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 405BB156739
	for <lists+netdev@lfdr.de>; Sat,  8 Feb 2020 19:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgBHS6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Feb 2020 13:58:13 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:55937 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727442AbgBHS6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Feb 2020 13:58:12 -0500
Received: by mail-io1-f70.google.com with SMTP id z21so1959402iob.22
        for <netdev@vger.kernel.org>; Sat, 08 Feb 2020 10:58:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=3QNUWzGFT2HuTCKJpDzCHQEdbSo8FRg4vF1vVLvHcvI=;
        b=kdtOBMEn0RjGIpvxQppoCN1vZ/ZxQLZPtoW1iR8hMq3e/q1LAHGlxaByIKstaecJz8
         xZkvK9pDHlQ0/74Rms3r63u5rXIJVzT7/n6oRWdhSPvmxu73f4lBL3XMJpra6nrUX+s3
         sHmaWzjFxDD0o/0FaBjqFV3NNIPRlncR0jfW8YfvL9jeZ7Nlpr3UVnDhHr7w26JKK2+J
         l9p5NccJl/bLTD4qmNzjBdn1MrcUCodzOgiCDS9fXvl9X1bAWbjRoian76wrEo2XRCcC
         kc72QQjJ0K5CFzumYhiXbVuck+pCz1Ip1QIp+pST7rif94LUpYVmvQl7qaovgrbCTMZe
         KlaA==
X-Gm-Message-State: APjAAAUtn/kBL/OI/H436Wl3ov/XvKjvFbIxW69XMm/f+6pLlzYZ+uQD
        uHGIJh66D1nZA4pDvIQNkZvmpjY2YtRDQTnH2wp1bmhMgRIE
X-Google-Smtp-Source: APXvYqxrn896/Y9JBPR+an+UMChgcVMohGS0DsURyWZP6/T9PkTSgkMfFBbrevYRnZPHe11AG0Whm4LLlHxnQh70cn7FLrIj+Zna
MIME-Version: 1.0
X-Received: by 2002:a92:c986:: with SMTP id y6mr5313781iln.186.1581188291971;
 Sat, 08 Feb 2020 10:58:11 -0800 (PST)
Date:   Sat, 08 Feb 2020 10:58:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000774f00059e15168f@google.com>
Subject: general protection fault in batadv_iv_ogm_schedule
From:   syzbot <syzbot+ac36b6a33c28a491e929@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f7571657 Merge tag 'fuse-fixes-5.6-rc1' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12dddbbee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7f1d914a74bd6ddc
dashboard link: https://syzkaller.appspot.com/bug?extid=ac36b6a33c28a491e929
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+ac36b6a33c28a491e929@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 0 PID: 465 Comm: kworker/u4:5 Not tainted 5.5.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_iv_send_outstanding_bat_ogm_packet
RIP: 0010:batadv_iv_ogm_schedule_buff net/batman-adv/bat_iv_ogm.c:814 [inline]
RIP: 0010:batadv_iv_ogm_schedule+0x220/0xf00 net/batman-adv/bat_iv_ogm.c:865
Code: e8 35 ef bf f9 4c 89 ad 60 ff ff ff 4d 8b 75 00 66 41 c1 c7 08 49 8d 5e 16 48 89 d8 48 c1 e8 03 49 bd 00 00 00 00 00 fc ff df <42> 8a 04 28 84 c0 0f 85 e0 0b 00 00 66 44 89 3b 4c 89 a5 78 ff ff
RSP: 0018:ffffc90002887b78 EFLAGS: 00010203
RAX: 0000000000000002 RBX: 0000000000000016 RCX: 1ffff11012580611
RDX: 0000000000000000 RSI: ffff8880a80449b0 RDI: 0000000000000282
RBP: ffffc90002887c38 R08: dffffc0000000000 R09: fffffbfff12d3605
R10: fffffbfff12d3605 R11: 0000000000000000 R12: ffff888092c03000
R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000075bfd4 CR3: 0000000090ab0000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 batadv_iv_send_outstanding_bat_ogm_packet+0x664/0x770 net/batman-adv/bat_iv_ogm.c:1718
 process_one_work+0x7f5/0x10f0 kernel/workqueue.c:2264
 worker_thread+0xbbc/0x1630 kernel/workqueue.c:2410
 kthread+0x332/0x350 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace eddf69e5e4c9f596 ]---
RIP: 0010:batadv_iv_ogm_schedule_buff net/batman-adv/bat_iv_ogm.c:814 [inline]
RIP: 0010:batadv_iv_ogm_schedule+0x220/0xf00 net/batman-adv/bat_iv_ogm.c:865
Code: e8 35 ef bf f9 4c 89 ad 60 ff ff ff 4d 8b 75 00 66 41 c1 c7 08 49 8d 5e 16 48 89 d8 48 c1 e8 03 49 bd 00 00 00 00 00 fc ff df <42> 8a 04 28 84 c0 0f 85 e0 0b 00 00 66 44 89 3b 4c 89 a5 78 ff ff
RSP: 0018:ffffc90002887b78 EFLAGS: 00010203
RAX: 0000000000000002 RBX: 0000000000000016 RCX: 1ffff11012580611
RDX: 0000000000000000 RSI: ffff8880a80449b0 RDI: 0000000000000282
RBP: ffffc90002887c38 R08: dffffc0000000000 R09: fffffbfff12d3605
R10: fffffbfff12d3605 R11: 0000000000000000 R12: ffff888092c03000
R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000075bfd4 CR3: 000000009c67b000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
