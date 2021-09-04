Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C7A400C2F
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 19:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237110AbhIDQrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 12:47:39 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:37660 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237011AbhIDQrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Sep 2021 12:47:36 -0400
Received: by mail-io1-f70.google.com with SMTP id h3-20020a056602008300b005b7c0e23e11so1735604iob.4
        for <netdev@vger.kernel.org>; Sat, 04 Sep 2021 09:46:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=huiWn6OJf1Z8+HD+VinaZl059PYkj4x1r8j41/BduPQ=;
        b=LUNb8HaFhpmvuYAismlrz+rE2T2N7GDHUw4IFP9JxckuHkQrd1N1tm86ls1V6yYSX9
         1MtN9IFj7tpyHPAXVar+fwWMMZuUAWjEewrG+5rrhRzVfFxVYkmB7JgyqC9t95mJGfiI
         sRxHlZF1nb4pPS4qrZ61Z7Ic4FXUg1Bzn30LfeVsTpFrc9yI7F5GrSH7HPb0OzMEaEh5
         AS7Ayad7sS2cpFishTzmRcq8r9Pqq0AfP7aqheABWFDmU1VNs+fcSG5balRNuH7ZmJdP
         oX/75J5ap+2Dpc+t50RlAjhhW99fWQvx/4TLoFbfkt1K9B420oMPo5GqsC68A/spwQfU
         TDpg==
X-Gm-Message-State: AOAM5303lYpvU/Gwfrg7Ie1N5zHlfoVzMBSy7XG4SBzA75J+mkFBhYyx
        0q+iH8znKGlSKasqXd0QCwc+LeJJEOTX+ZXld8dAOjtB/JDw
X-Google-Smtp-Source: ABdhPJyPhigVO5GV0BU/1v96Ow36EPc+LvIoS+8KBaRJKi9LdPSrCwI7fri9E836e9/mbKvq0ye8EOR0LQVxLDwSDEA2/kvJP6EY
MIME-Version: 1.0
X-Received: by 2002:a92:c5aa:: with SMTP id r10mr3083929ilt.274.1630773994893;
 Sat, 04 Sep 2021 09:46:34 -0700 (PDT)
Date:   Sat, 04 Sep 2021 09:46:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000acb87205cb2e283c@google.com>
Subject: [syzbot] WARNING: kmalloc bug in hash_ipportnet_create
From:   syzbot <syzbot+0e73f839b35d0973fb97@syzkaller.appspotmail.com>
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

HEAD commit:    7cca308cfdc0 Merge tag 'powerpc-5.15-1' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1238fbbd300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8aa56a640db99eb1
dashboard link: https://syzkaller.appspot.com/bug?extid=0e73f839b35d0973fb97
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10ef4e0b300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1302e115300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0e73f839b35d0973fb97@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 8442 at mm/util.c:597 kvmalloc_node+0x111/0x120 mm/util.c:597
Modules linked in:
CPU: 0 PID: 8442 Comm: syz-executor543 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
Code: 01 00 00 00 4c 89 e7 e8 4d 17 0d 00 49 89 c5 e9 69 ff ff ff e8 30 3e d1 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 1f 3e d1 ff <0f> 0b e9 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 06
RSP: 0018:ffffc900019f7288 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffc900019f73a0 RCX: 0000000000000000
RDX: ffff888018236140 RSI: ffffffff81a41371 RDI: 0000000000000003
RBP: 0000000000400dc0 R08: 000000007fffffff R09: 000000000000001c
R10: ffffffff81a4132e R11: 000000000000001f R12: 0000000080000018
R13: 0000000000000000 R14: 00000000ffffffff R15: ffff8880171e1000
FS:  00000000020ae300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000246 CR3: 0000000013999000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 hash_ipportnet_create+0x3dd/0x1220 net/netfilter/ipset/ip_set_hash_gen.h:1524
 ip_set_create+0x782/0x15a0 net/netfilter/ipset/ip_set_core.c:1100
 nfnetlink_rcv_msg+0xbc9/0x13f0 net/netfilter/nfnetlink.c:296
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 nfnetlink_rcv+0x1ac/0x420 net/netfilter/nfnetlink.c:654
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43f039
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe5f928db8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f039
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 0000000000403020 R08: 0000000000000005 R09: 0000000000400488
R10: 0000000000000004 R11: 0000000000000246 R12: 00000000004030b0
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
