Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC95616130
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 11:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbfEGJkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 05:40:10 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:54418 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726511AbfEGJkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 05:40:09 -0400
Received: by mail-io1-f70.google.com with SMTP id t7so2900842iof.21
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 02:40:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Uypp6ieG5xvoC6Zp2hwEemoE2ROs7ap0zeGJoNwhgoI=;
        b=Ll+SnKUGjxVaJJM2WJHqZYZtjuJ1ZUIkPMStICV5T5vNqyA+o7IUDHZOa6WEAgB2YY
         gELpZdQUXGvIAtZIO/ClgfrBgr832G/+/UNPWtWxnMqhmratIxRTmEvNw97/iABkptDU
         yPoxSuxQ/2qYRh9jDG6Nw1o6NgV+F640b5po2toyJdBEZuSO5q9B23ZmaGQ16YeBynL3
         DQSIeaGrv3cR/4rjtAEhFtn+Fsfk+KmhMWUWc8fq5j8SUaIz4wL5hRZPS3C2sQFp/l//
         wFI+FFIo71jimvzmLycXC7jlBbGQogrVPB4yCAtY8N0RKmOZeh9/8zJ1EV8Pr7DKgTft
         fEHw==
X-Gm-Message-State: APjAAAUWiRTzz7poAbP7yc1vWmlBLbWb1rZDOhPvv915gknuu3tZ/Jpd
        rJ/KUkAF8g/9fWpTzK6MPZ1GcizTckUgk2agaDHM8sTWw9gF
X-Google-Smtp-Source: APXvYqyX7bBGbgzgjisOPvRfugSvioOCkjt/965wR3GWcPoApxD8qv0M02JW46oNd6ajbJgDNRbJuVpaIElRgyvno6ArQu6ZwX8k
MIME-Version: 1.0
X-Received: by 2002:a24:db8a:: with SMTP id c132mr23093680itg.46.1557222007798;
 Tue, 07 May 2019 02:40:07 -0700 (PDT)
Date:   Tue, 07 May 2019 02:40:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009c83b005884900cf@google.com>
Subject: general protection fault in rfcomm_dlc_exists
From:   syzbot <syzbot+362be51217ce29d215bc@syzkaller.appspotmail.com>
To:     davem@davemloft.net, gustavo@embeddedor.com,
        johan.hedberg@gmail.com, keescook@chromium.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tiny.windzz@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    26f146ed net: ll_temac: Fix typo bug for 32-bit
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1481e350a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=70f5b9827d8c73d8
dashboard link: https://syzkaller.appspot.com/bug?extid=362be51217ce29d215bc
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+362be51217ce29d215bc@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 29087 Comm: syz-executor.2 Not tainted 5.1.0-rc6+ #164
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:rfcomm_dlc_get net/bluetooth/rfcomm/core.c:360 [inline]
RIP: 0010:rfcomm_dlc_exists+0x12e/0x1a0 net/bluetooth/rfcomm/core.c:550
Code: 42 80 3c 28 00 75 74 4d 8b 24 24 4d 39 f4 74 55 e8 37 99 16 fb 49 8d  
bc 24 44 01 00 00 48 89 f8 48 89 fa 48 c1 e8 03 83 e2 07 <42> 0f b6 04 28  
38 d0 7f 04 84 c0 75 3d 45 0f b6 bc 24 44 01 00 00
RSP: 0018:ffff88809e9f79c0 EFLAGS: 00010202
RAX: 0ecc2d8e6bee4e95 RBX: 000000000000000d RCX: ffffc90005ffc000
RDX: 0000000000000004 RSI: ffffffff8659f3e9 RDI: 76616c735f7274ac
RBP: ffff88809e9f79e8 R08: ffff888093d44580 R09: fffffbfff1289895
R10: ffff88809e9f79b0 R11: ffffffff8944c4a7 R12: 76616c735f727368
R13: dffffc0000000000 R14: ffff88809b2d3980 R15: 0000000000000000
FS:  00007faf4b6fc700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f90c3150000 CR3: 0000000097c73000 CR4: 00000000001406f0
Call Trace:
  __rfcomm_create_dev net/bluetooth/rfcomm/tty.c:413 [inline]
  rfcomm_create_dev net/bluetooth/rfcomm/tty.c:486 [inline]
  rfcomm_dev_ioctl+0x591/0x1b60 net/bluetooth/rfcomm/tty.c:588
  rfcomm_sock_ioctl+0x90/0xb0 net/bluetooth/rfcomm/sock.c:902
  sock_do_ioctl+0xde/0x300 net/socket.c:1037
  sock_ioctl+0x3f3/0x790 net/socket.c:1188
  vfs_ioctl fs/ioctl.c:46 [inline]
  file_ioctl fs/ioctl.c:509 [inline]
  do_vfs_ioctl+0xd6e/0x1390 fs/ioctl.c:696
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x458da9
Code: ad b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007faf4b6fbc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000458da9
RDX: 0000000020000100 RSI: 00000000400452c8 RDI: 0000000000000004
RBP: 000000000073bfa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007faf4b6fc6d4
R13: 00000000004c133a R14: 00000000004d3920 R15: 00000000ffffffff
Modules linked in:
---[ end trace 6a47bc10d7ab5e63 ]---
RIP: 0010:rfcomm_dlc_get net/bluetooth/rfcomm/core.c:360 [inline]
RIP: 0010:rfcomm_dlc_exists+0x12e/0x1a0 net/bluetooth/rfcomm/core.c:550
Code: 42 80 3c 28 00 75 74 4d 8b 24 24 4d 39 f4 74 55 e8 37 99 16 fb 49 8d  
bc 24 44 01 00 00 48 89 f8 48 89 fa 48 c1 e8 03 83 e2 07 <42> 0f b6 04 28  
38 d0 7f 04 84 c0 75 3d 45 0f b6 bc 24 44 01 00 00
RSP: 0018:ffff88809e9f79c0 EFLAGS: 00010202
RAX: 0ecc2d8e6bee4e95 RBX: 000000000000000d RCX: ffffc90005ffc000
RDX: 0000000000000004 RSI: ffffffff8659f3e9 RDI: 76616c735f7274ac
RBP: ffff88809e9f79e8 R08: ffff888093d44580 R09: fffffbfff1289895
R10: ffff88809e9f79b0 R11: ffffffff8944c4a7 R12: 76616c735f727368
R13: dffffc0000000000 R14: ffff88809b2d3980 R15: 0000000000000000
FS:  00007faf4b6fc700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000097c73000 CR4: 00000000001406f0


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
