Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9EC2C7E3B
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 07:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgK3Ga6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 01:30:58 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:49929 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbgK3Ga6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 01:30:58 -0500
Received: by mail-il1-f198.google.com with SMTP id m14so9277059ila.16
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 22:30:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=SsdBbZBVHy6xJ9WVayx5nina7iNWnHndy2OV1R2nZ5U=;
        b=UU+PCnpoZ55Y+/eA57/viEtNWcU5Px9w4EyiYXxmjZwST9mgsig5iQjTtX3cnDPiBm
         lYBmEzWw8BK6Uesg4rNpTbY08hb5ENWhAcn1AyNPNOXIe62l7m4TI/XOxvNTIZdgsWSL
         HjSaw00H1OV3S3qwbi1jNX0lT1R+rnIPgjGPY9Wn9ersWbG5Cqtmxf6/ucsO971CaU8Y
         hdyQ2jZ2YmvFZzgYmLYa/rR8qgQbz1Jjs3sb7kdfutpXE74nwmY8Lua6R7AIzZ63eGjv
         BKv4Ro7u/vmpgL8dCWgJPnpt1bxvCGDNYSXPc0PkgfrLOszcby+90Z02sNDh+MlzYPFg
         N92A==
X-Gm-Message-State: AOAM530AqMJBozZQQlr/Qghcfq9sEbaywRNTCcg+qrwgwFiyxnWgXIJq
        TNey9z4CEBaYRrzxezjJNIQ0PeqjDVZTAx9WPMEFpBxQXgtq
X-Google-Smtp-Source: ABdhPJwcn4tsvmDvq8LHtAHc1nbF04dn839mNQU6ZCzx3edV8QoxeguzHEyKM5IGA6WpXY+LQj4Eh0jzxhovR9FMTVIq+VYFnsq8
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1207:: with SMTP id a7mr17560369ilq.29.1606717817336;
 Sun, 29 Nov 2020 22:30:17 -0800 (PST)
Date:   Sun, 29 Nov 2020 22:30:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c1b9d105b54d2429@google.com>
Subject: general protection fault in l2cap_chan_timeout
From:   syzbot <syzbot+e7edf1d784c283324076@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    fa02fcd9 Merge tag 'media/v5.10-2' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14a36fa5500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7be70951fca93701
dashboard link: https://syzkaller.appspot.com/bug?extid=e7edf1d784c283324076
compiler:       clang version 11.0.0 (https://github.com/llvm/llvm-project.git ca2dcbd030eadbf0aa9b660efe864ff08af6e18b)

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e7edf1d784c283324076@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc000000005a: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000002d0-0x00000000000002d7]
CPU: 1 PID: 16756 Comm: kworker/1:8 Not tainted 5.10.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events l2cap_chan_timeout
RIP: 0010:__mutex_lock_common+0x9b/0x2f20 kernel/locking/mutex.c:938
Code: 8a bc 24 28 01 00 00 83 3d 01 69 0f 06 00 75 34 48 8b 44 24 08 48 8d 78 60 48 89 f8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 05 e8 ba 7f 77 f8 48 8b 44 24 08 48 39 40 60 0f 85
RSP: 0018:ffffc9000245fb78 EFLAGS: 00010206
RAX: 000000000000005a RBX: ffff8880708d8110 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000002d0
RBP: 0000000000000000 R08: ffffffff8876a063 R09: 0000000000000000
R10: fffffbfff1a1c3ee R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000000 R15: ffff8880b9d33c00
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffde459fd3c CR3: 00000000186a5000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __mutex_lock kernel/locking/mutex.c:1103 [inline]
 mutex_lock_nested+0x1a/0x20 kernel/locking/mutex.c:1118
 l2cap_chan_timeout+0x53/0x280 net/bluetooth/l2cap_core.c:422
 process_one_work+0x789/0xfc0 kernel/workqueue.c:2272
 worker_thread+0xaa4/0x1460 kernel/workqueue.c:2418
 kthread+0x39a/0x3c0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
Modules linked in:
---[ end trace c01f537d4b85904a ]---
RIP: 0010:__mutex_lock_common+0x9b/0x2f20 kernel/locking/mutex.c:938
Code: 8a bc 24 28 01 00 00 83 3d 01 69 0f 06 00 75 34 48 8b 44 24 08 48 8d 78 60 48 89 f8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 05 e8 ba 7f 77 f8 48 8b 44 24 08 48 39 40 60 0f 85
RSP: 0018:ffffc9000245fb78 EFLAGS: 00010206
RAX: 000000000000005a RBX: ffff8880708d8110 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000002d0
RBP: 0000000000000000 R08: ffffffff8876a063 R09: 0000000000000000
R10: fffffbfff1a1c3ee R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000000 R15: ffff8880b9d33c00
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbbcfa32740 CR3: 000000006d47f000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
