Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEB840F377
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 09:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239213AbhIQHqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 03:46:50 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:42538 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbhIQHqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 03:46:50 -0400
Received: by mail-io1-f72.google.com with SMTP id i78-20020a6b3b51000000b005b8dd0f9e76so18853145ioa.9
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 00:45:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=qhsP2+cq+V34wONR8zohN2S7Vy1bYXDChrogQdy+HvA=;
        b=O6FW4DyILdcEZIAfyYq3C3lVDrn0QJP3zCUzSmqfZfvZt1l9fmU5Ck40Mzjp5nJi2y
         11QVPNM/LkqV4PTCpaWcou0QrdtIoZUavU0LppEw0XNggtAo/nQkgkK4ix1pEPAYW9wR
         29WM3gM182rkEkeUdpjAanzDRF4UQzp5CjZSI6WGXeHYRuigkVphqAvwRam+gSn/aGx8
         3EHJmdOP2EYuWMHqinmC+pquTdogBKd3K8+hriPmm8ZmVXBAhjvW0JPawVfKDRraA3et
         mCaVvCWMQJ5Nk+eXxFitvUrkJ2i1Bs0i/a/3tcPIiPEOUzPTOqwj9FRCNh+ROPhvLAfT
         AGuQ==
X-Gm-Message-State: AOAM5326Ebc/8JlGEBwClXTTsDB3aQ510hdVgr8H4xF205bhqOEbObva
        oAuShji72BeHJpE065qbjghQiY4s6vfDGYPfReX0CWuYeoX1
X-Google-Smtp-Source: ABdhPJywQVM7bxgbMCGlFyaonYOt0+ZCdP7tNTOdXECGnpyCU0GwOMHdIoVIDu3qUEC0nK51gAqa/tgUBlfFad8m/JpmqbuGYIqf
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2c05:: with SMTP id w5mr7752796iov.160.1631864728261;
 Fri, 17 Sep 2021 00:45:28 -0700 (PDT)
Date:   Fri, 17 Sep 2021 00:45:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000073194a05cc2c1db6@google.com>
Subject: [syzbot] WARNING: refcount bug in nr_release (2)
From:   syzbot <syzbot+053c8d94c7f45da6e6c8@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ralf@linux-mips.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c1b13fe76e95 Add linux-next specific files for 20210901
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1564c986300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e2afff7bc32736e5
dashboard link: https://syzkaller.appspot.com/bug?extid=053c8d94c7f45da6e6c8
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+053c8d94c7f45da6e6c8@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: saturated; leaking memory.
WARNING: CPU: 0 PID: 2068 at lib/refcount.c:22 refcount_warn_saturate+0x12d/0x1e0 lib/refcount.c:22
Modules linked in:
CPU: 0 PID: 2068 Comm: syz-executor.3 Not tainted 5.14.0-next-20210901-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:refcount_warn_saturate+0x12d/0x1e0 lib/refcount.c:22
Code: 09 31 ff 89 de e8 f3 98 9e fd 84 db 0f 85 72 ff ff ff e8 a6 92 9e fd 48 c7 c7 60 00 e4 89 c6 05 62 76 82 09 01 e8 60 89 18 05 <0f> 0b e9 53 ff ff ff e8 87 92 9e fd 0f b6 1d 49 76 82 09 31 ff 89
RSP: 0018:ffffc9000dd9fa78 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888095d91c80 RSI: ffffffff815dba38 RDI: fffff52001bb3f41
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815d581e R11: 0000000000000000 R12: ffff88803f939200
R13: ffff8880a961a080 R14: ffff88803f939218 R15: ffff888011eccaa0
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f66614c8070 CR3: 00000000198d8000 CR4: 00000000001526f0
Call Trace:
 __refcount_add include/linux/refcount.h:201 [inline]
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 sock_hold include/net/sock.h:702 [inline]
 nr_release+0x3ba/0x450 net/netrom/af_netrom.c:520
 __sock_release+0xcd/0x280 net/socket.c:649
 sock_close+0x18/0x20 net/socket.c:1314
 __fput+0x288/0x9f0 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xbae/0x2a30 kernel/exit.c:825
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x47f/0x2160 kernel/signal.c:2868
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:865
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: Unable to access opcode bytes at RIP 0x4665cf.
RSP: 002b:00007f1282a60218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 000000000056bf88 RCX: 00000000004665f9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000056bf88
RBP: 000000000056bf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf8c
R13: 00007fffbb91b31f R14: 00007f1282a60300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
