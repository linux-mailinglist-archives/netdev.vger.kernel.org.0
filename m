Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6763400890
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 02:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350759AbhIDACf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 20:02:35 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:57007 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350665AbhIDACa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 20:02:30 -0400
Received: by mail-il1-f199.google.com with SMTP id v9-20020a92c6c9000000b00226d10082a6so490747ilm.23
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 17:01:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Rf+Aadz5iRO5qie0dUotzcRjJJJXbwinCKbAxiq5OPI=;
        b=Wf5xNmiQjs0AkkLWS6Me27ZaDkv+HvfGbE6kqiRQpwkd4D/32cSqNuBbdNgBl+hBvA
         IushSJeGiRpq9g8PatluhaltwNSF/YLIVP7mW/2RbUGmjNCzg1KZLRAImlHVFw57Ph5R
         47HusnzK4Bh2byOCcth6lrA0ev0POfyxnFtOdDwsMlOck3YfqeKv2UGzVtd3IYqW/vkM
         aVoRdJbmFX+SHDRHqWSIYJVrgPY/DRl9hVfWY4Q31Ms7I6/Assm7PSGlw1B+O9JueZtj
         EPqtWZD1rDtZEAx7VQ38Gsn3DJJvh0VF620CCN4nMk5lHbrq+HZ70O1WNugaif0kSjEY
         Nalw==
X-Gm-Message-State: AOAM532EwJY1rWRF+/rWvQDKts6SGJrn5gfSDcjod7EGJxanZrOLVk54
        oLjmc0DL/Ag7ahZEALhjwSpoTrcGuwPwKXlkdcMflxPYE0kX
X-Google-Smtp-Source: ABdhPJzv7o7rtitlBj85h8rgtN7nv7rHThSNS7OpFx5jCVPu39b9CC2YpMrHv4OH1npYpXVM59+FBCndMFib4IPywkvGjWiHc4BO
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2297:: with SMTP id y23mr1293391jas.105.1630713689497;
 Fri, 03 Sep 2021 17:01:29 -0700 (PDT)
Date:   Fri, 03 Sep 2021 17:01:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003166f105cb201ea6@google.com>
Subject: [syzbot] WARNING: kmalloc bug in hash_netport_create
From:   syzbot <syzbot+3f5904753c2388727c6c@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a9c9a6f741cd Merge tag 'scsi-misc' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12a90fb1300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1ac29107aeb2a552
dashboard link: https://syzkaller.appspot.com/bug?extid=3f5904753c2388727c6c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14581b33300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13579a69300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3f5904753c2388727c6c@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 8430 at mm/util.c:597 kvmalloc_node+0x111/0x120 mm/util.c:597
Modules linked in:
CPU: 1 PID: 8430 Comm: syz-executor891 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
Code: 01 00 00 00 4c 89 e7 e8 ed 11 0d 00 49 89 c5 e9 69 ff ff ff e8 90 55 d1 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 7f 55 d1 ff <0f> 0b e9 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 66
RSP: 0018:ffffc900010a7078 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffc900010a7190 RCX: 0000000000000000
RDX: ffff88801d93e300 RSI: ffffffff81a3f651 RDI: 0000000000000003
RBP: 0000000000400dc0 R08: 000000007fffffff R09: 000000000000001f
R10: ffffffff81a3f60e R11: 000000000000001f R12: 0000000400000018
R13: 0000000000000000 R14: 00000000ffffffff R15: ffff88803040e000
FS:  0000000002161300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000080 CR3: 000000003ea95000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 hash_netport_create+0x3dd/0x1220 net/netfilter/ipset/ip_set_hash_gen.h:1524
 ip_set_create+0x782/0x15a0 net/netfilter/ipset/ip_set_core.c:1100
 nfnetlink_rcv_msg+0xbc9/0x13f0 net/netfilter/nfnetlink.c:296
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 nfnetlink_rcv+0x1ac/0x420 net/netfilter/nfnetlink.c:654
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 sock_no_sendpage+0xf3/0x130 net/core/sock.c:2980
 kernel_sendpage.part.0+0x1a0/0x340 net/socket.c:3504
 kernel_sendpage net/socket.c:3501 [inline]
 sock_sendpage+0xe5/0x140 net/socket.c:1003
 pipe_to_sendpage+0x2ad/0x380 fs/splice.c:364
 splice_from_pipe_feed fs/splice.c:418 [inline]
 __splice_from_pipe+0x43e/0x8a0 fs/splice.c:562
 splice_from_pipe fs/splice.c:597 [inline]
 generic_splice_sendpage+0xd4/0x140 fs/splice.c:746
 do_splice_from fs/splice.c:767 [inline]
 do_splice+0xb7e/0x1960 fs/splice.c:1079
 __do_splice+0x134/0x250 fs/splice.c:1144
 __do_sys_splice fs/splice.c:1350 [inline]
 __se_sys_splice fs/splice.c:1332 [inline]
 __x64_sys_splice+0x198/0x250 fs/splice.c:1332
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43efb9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd3f03c028 EFLAGS: 00000246 ORIG_RAX: 0000000000000113
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043efb9
RDX: 0000000000000004 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000402fa0 R08: 0000000100000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000403030
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
