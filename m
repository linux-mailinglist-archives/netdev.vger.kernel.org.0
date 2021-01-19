Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A092FC38F
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 23:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbhASRnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 12:43:50 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:36406 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391323AbhASRkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 12:40:01 -0500
Received: by mail-io1-f70.google.com with SMTP id f7so3358624ioz.3
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 09:39:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=RvRcnXzmh80CmPwNJc6C/dVPmHxxvZ98wqHvifc9g5g=;
        b=koa4JlSCkW7ZZaQCv020I1t7uZ+6Qys9FCT+b+MG+5lJO3roteqAHuht+qhnt9WdBj
         TwwyhnNad+/tIFv3/XMdScPsixPv2DUYq95Up5IE0fBy1Zq1xwUwcBnGiKCBB4pOCK4I
         HPlPUmvxpOVAkVRAaNW6AOPfLKM1ZqFFotgPo4WQJ+OnSm0FBaSjD1WykiKFL1h55lq1
         p2X5f15NkRa3OAtWNSrqE0JpiAYVlU9hGzOrwRIjhHul4nlDokdT79J5QigLmuhu62yy
         K/hF4gXh5ogHNbqKdFqUxPKvGHo67qIGblL3IjH3UdYA1obuw9UsKywi9dl0qfYxoNYk
         2/Yg==
X-Gm-Message-State: AOAM53148ocBGpSUuLZhZNICeaEETGbQByiVa0xy2E7H7WvQSEmedLVi
        myv8Kxd1gGcEX7UILXZeDMu5ky2wkM0HZqaElLpRstZgr5wP
X-Google-Smtp-Source: ABdhPJwYONYODzuDw1xHz7CSUoC2704iRqonKVHiCwF3SNls2pRq0v3FvHqr9XRpKmAN7bpfAXO6pPgRV5DlppV8jEjjiRf67p/9
MIME-Version: 1.0
X-Received: by 2002:a92:c5d0:: with SMTP id s16mr4079618ilt.223.1611077960353;
 Tue, 19 Jan 2021 09:39:20 -0800 (PST)
Date:   Tue, 19 Jan 2021 09:39:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000885c1d05b94451f0@google.com>
Subject: WARNING in kmalloc_array
From:   syzbot <syzbot+5d578be9b4bfe1b6bbd6@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    0da0a8a0 Merge tag 'scsi-fixes' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1293e1f7500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ee2266946ed36986
dashboard link: https://syzkaller.appspot.com/bug?extid=5d578be9b4bfe1b6bbd6
compiler:       clang version 11.0.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5d578be9b4bfe1b6bbd6@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 15540 at mm/page_alloc.c:4977 __alloc_pages_nodemask+0x4e5/0x5a0 mm/page_alloc.c:5021
Modules linked in:
CPU: 1 PID: 15540 Comm: syz-executor.2 Not tainted 5.11.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__alloc_pages_nodemask+0x4e5/0x5a0 mm/page_alloc.c:5021
Code: ab 09 00 e9 dd fd ff ff 44 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c eb fd ff ff 4c 89 ef e8 f4 aa 09 00 8b 74 24 18 e9 da fd ff ff <0f> 0b e9 f3 fd ff ff a9 00 00 08 00 75 16 8b 4c 24 1c 89 cb 81 e3
RSP: 0018:ffffc90016bff620 EFLAGS: 00010246
RAX: ffffc90016bff6a0 RBX: ffffc90016bff6a0 RCX: 0000000000000000
RDX: 0000000000000028 RSI: 0000000000000000 RDI: ffffc90016bff6c8
RBP: ffffc90016bff758 R08: dffffc0000000000 R09: ffffc90016bff6a0
R10: fffff52002d7fed9 R11: 0000000000000000 R12: dffffc0000000000
R13: 0000000000000018 R14: 1ffff92002d7fed0 R15: 0000000000040dc0
FS:  00007fc7102ae700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000749138 CR3: 0000000025dd7000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Call Trace:
 alloc_pages include/linux/gfp.h:547 [inline]
 kmalloc_order+0x40/0x130 mm/slab_common.c:837
 kmalloc_order_trace+0x15/0x70 mm/slab_common.c:853
 kmalloc_large include/linux/slab.h:481 [inline]
 __kmalloc+0x257/0x330 mm/slub.c:3959
 kmalloc_array+0x2d/0x40 include/linux/slab.h:593
 kcalloc include/linux/slab.h:621 [inline]
 rds_rdma_extra_size+0x84/0x300 net/rds/rdma.c:568
 rds_rm_size net/rds/send.c:928 [inline]
 rds_sendmsg+0xfad/0x3210 net/rds/send.c:1265
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x5a2/0x900 net/socket.c:2345
 ___sys_sendmsg net/socket.c:2399 [inline]
 __sys_sendmsg+0x319/0x400 net/socket.c:2432
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e219
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fc7102adc68 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045e219
RDX: 0000000000000000 RSI: 0000000020001600 RDI: 0000000000000003
RBP: 000000000119bfc0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bf8c
R13: 00007ffd4cf1c0cf R14: 00007fc7102ae9c0 R15: 000000000119bf8c


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
