Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8D42E1BBA
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 12:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgLWLN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 06:13:58 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:56828 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728249AbgLWLN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 06:13:57 -0500
Received: by mail-io1-f69.google.com with SMTP id e14so9221773iow.23
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 03:13:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ms/ZOYDFKayMY7pJ4cwiOOATwf8SFvl/AGcvDodOii8=;
        b=D2nGKKzvEApqjB+vCdy8HlO0ppDD50ftHngmx+aHXGqOvPD6rjGN59634cbCoZ5ohL
         PCjDNkTihu2KaQEN1x+0sY08n4KKwT2TGhiWr98yK+jjf4ExM3t5qRD5jSm4RtOPj9og
         4NGGWix/Ut7c5PW3Ph81Lg2y7JaFURN7eINTxQ0ccXxdL2PMPfbCaG5RN7pphSkynhnL
         YRM5wxncUXEHqBg5JY5a7IyYlHEX++Kv4gZkew8M7wE9Dvx26Vp3117nCnxLbsrMmxv0
         nwUOTAXS73gmxSPryTOM1hXFNEVKsPR0Hgsjydtjs7ckgi7D+/ZBT1YRpMi1ZkgQSPhD
         W+8g==
X-Gm-Message-State: AOAM533V3Se+bU6IGCJxfeS5TO9ojijlh4tjpZBju9+c9r9JfJtkaF5Y
        wb5btL54WWWjXT59MlRgQR/TODiJXBuXB55+v4MxXbb5vr3l
X-Google-Smtp-Source: ABdhPJxBNDQjNENCbM+It/qq4sl9wEhzqw1neLZOVMbVQPBPaH1+gcXzResLlwdLED5ncrrPiJgoQze+eeduRItouDIDJx6uPbL9
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:f0f:: with SMTP id x15mr24551579ilj.12.1608721996209;
 Wed, 23 Dec 2020 03:13:16 -0800 (PST)
Date:   Wed, 23 Dec 2020 03:13:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000020641905b71fc7dd@google.com>
Subject: general protection fault in tipc_crypto_key_distr
From:   syzbot <syzbot+fff41d21ca02315bd004@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jmaloy@redhat.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3db1a3fa Merge tag 'staging-5.11-rc1' of git://git.kernel...
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=107df123500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2764fc28a92339f9
dashboard link: https://syzkaller.appspot.com/bug?extid=fff41d21ca02315bd004
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fff41d21ca02315bd004@syzkaller.appspotmail.com

RBP: 00007f349d602ca0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000030
R13: 00007fff8446099f R14: 00007f349d6039c0 R15: 000000000119bf8c
general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 0 PID: 5549 Comm: syz-executor.0 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:tipc_aead_key_size include/uapi/linux/tipc.h:254 [inline]
RIP: 0010:tipc_crypto_key_xmit net/tipc/crypto.c:2245 [inline]
RIP: 0010:tipc_crypto_key_distr+0x218/0xa70 net/tipc/crypto.c:2211
Code: 02 00 0f 85 51 08 00 00 48 8b 45 00 49 8d 4d 20 48 89 ca 48 89 4c 24 10 48 c1 ea 03 48 89 04 24 48 b8 00 00 00 00 00 fc ff df <0f> b6 14 02 48 89 c8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 3d
RSP: 0018:ffffc900025073f0 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff88804fc22e00 RCX: 0000000000000020
RDX: 0000000000000004 RSI: ffffffff88771597 RDI: ffff88804fc22e40
RBP: ffff888016bc3000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000001
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f349d603700(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa36516cdb8 CR3: 0000000025ae0000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __tipc_nl_node_set_key net/tipc/node.c:3008 [inline]
 tipc_nl_node_set_key+0xcb4/0xf30 net/tipc/node.c:3023
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2336
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2390
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2423
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e149
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f349d602c68 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 000000000045e149
RDX: 0000000000000000 RSI: 0000000020000340 RDI: 0000000000000003
RBP: 00007f349d602ca0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000030
R13: 00007fff8446099f R14: 00007f349d6039c0 R15: 000000000119bf8c
Modules linked in:
---[ end trace a296abf4d3e5aa59 ]---
RIP: 0010:tipc_aead_key_size include/uapi/linux/tipc.h:254 [inline]
RIP: 0010:tipc_crypto_key_xmit net/tipc/crypto.c:2245 [inline]
RIP: 0010:tipc_crypto_key_distr+0x218/0xa70 net/tipc/crypto.c:2211
Code: 02 00 0f 85 51 08 00 00 48 8b 45 00 49 8d 4d 20 48 89 ca 48 89 4c 24 10 48 c1 ea 03 48 89 04 24 48 b8 00 00 00 00 00 fc ff df <0f> b6 14 02 48 89 c8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 3d
RSP: 0018:ffffc900025073f0 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff88804fc22e00 RCX: 0000000000000020
RDX: 0000000000000004 RSI: ffffffff88771597 RDI: ffff88804fc22e40
RBP: ffff888016bc3000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000001
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f349d603700(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa36516cdb8 CR3: 0000000025ae0000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
