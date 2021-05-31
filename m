Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818023955E8
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 09:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhEaHVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 03:21:04 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:35609 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbhEaHU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 03:20:56 -0400
Received: by mail-il1-f197.google.com with SMTP id n7-20020a056e021487b02901d29983f028so7562199ilk.2
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 00:19:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ArOpMdbFDDmKZECmacnd2/wE83IcJjiqARCZQPnaa3A=;
        b=PHDFaj7pmEewJiK1F19zhHmGOtkBK4buA5YIxHYOVuKT98aBF/kz1VTH3D/qUZDvnl
         QhFLSfQcZ97x153QHK+pI9AsA+xybHW5W5FtdWfE34qtLW8jkxyBHPWQl8ak9MVRfeuw
         5oSTb0dIRMLXa9pAKmkDt7RmqrAXC50oZv2iMnKtqwK0Svo/AzYriWnZS7XJ5YLVYxgH
         pxTSeOHX/Ebpy8a/vthJgJcMlhx2D3Ai6Fdp9cP1h1mMZGUAKUQRB7eLGGVx3jNTIGEP
         fodlokd2hoTrBlLiYKBciyF/U23U1QZLBjvq8osBvma5p9JEK49Ji4oLbgt7xR3FRvhp
         eANw==
X-Gm-Message-State: AOAM531m6nE69JUfJfXqSnMYRsffQmfGIvQa4VmovkHXZFIRwm/UFAh2
        isesi7uVv5i04tWEZN5fx7nv9EX15k+1Ul+GSrx2Aj/kA8Sb
X-Google-Smtp-Source: ABdhPJzEztdJ0o/G3hEuPu3fGtsj6Vswr0Ea06NfZCEV1dhAjKIhKjuRFPOkORDHPIMrp2/d/6pxBrq3IQ63xtm26c+MvOs0S4fg
MIME-Version: 1.0
X-Received: by 2002:a05:6602:29cf:: with SMTP id z15mr16147286ioq.176.1622445557367;
 Mon, 31 May 2021 00:19:17 -0700 (PDT)
Date:   Mon, 31 May 2021 00:19:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001d4a3005c39b0b40@google.com>
Subject: [syzbot] general protection fault in l2cap_chan_timeout (2)
From:   syzbot <syzbot+008cdbf7a9044c2c2f99@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ad9f25d3 Merge tag 'netfs-lib-fixes-20200525' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=173d383dd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=266cda122a0b56c
dashboard link: https://syzkaller.appspot.com/bug?extid=008cdbf7a9044c2c2f99

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+008cdbf7a9044c2c2f99@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc000000005a: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000002d0-0x00000000000002d7]
CPU: 0 PID: 8 Comm: kworker/0:2 Not tainted 5.13.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events l2cap_chan_timeout
RIP: 0010:__mutex_lock_common kernel/locking/mutex.c:941 [inline]
RIP: 0010:__mutex_lock+0xf6/0x10c0 kernel/locking/mutex.c:1104
Code: d0 7c 08 84 d2 0f 85 cc 0c 00 00 8b 15 e3 55 5f 07 85 d2 75 29 48 8d 7d 60 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 db 0e 00 00 48 3b 6d 60 0f 85 5a 0a 00 00 bf 01
RSP: 0018:ffffc90000cd7b78 EFLAGS: 00010216
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000001
RDX: 000000000000005a RSI: 0000000000000000 RDI: 00000000000002d0
RBP: 0000000000000270 R08: ffffffff880a40d9 R09: 0000000000000000
R10: ffffffff814b4be0 R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: ffff888072e47020 R15: ffff8880b9c34a40
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fcac15f1d58 CR3: 00000000628fa000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Call Trace:
 l2cap_chan_timeout+0x69/0x2f0 net/bluetooth/l2cap_core.c:422
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2276
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2422
 kthread+0x3b1/0x4a0 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Modules linked in:
---[ end trace d3dc393d48928266 ]---
RIP: 0010:__mutex_lock_common kernel/locking/mutex.c:941 [inline]
RIP: 0010:__mutex_lock+0xf6/0x10c0 kernel/locking/mutex.c:1104
Code: d0 7c 08 84 d2 0f 85 cc 0c 00 00 8b 15 e3 55 5f 07 85 d2 75 29 48 8d 7d 60 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 db 0e 00 00 48 3b 6d 60 0f 85 5a 0a 00 00 bf 01
RSP: 0018:ffffc90000cd7b78 EFLAGS: 00010216
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000001
RDX: 000000000000005a RSI: 0000000000000000 RDI: 00000000000002d0
RBP: 0000000000000270 R08: ffffffff880a40d9 R09: 0000000000000000
R10: ffffffff814b4be0 R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: ffff888072e47020 R15: ffff8880b9c34a40
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b33621000 CR3: 00000000628fa000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
