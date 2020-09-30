Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD06427F0AD
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 19:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731400AbgI3RmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 13:42:20 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:36951 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgI3RmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 13:42:20 -0400
Received: by mail-il1-f197.google.com with SMTP id c66so2156135ilf.4
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 10:42:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=gFm1XYQPKEm64e3IzyGsuW+y9Ev3roInvd+o9HWt0+4=;
        b=j8YnK6tieoZKjD0GFWlkqWlfTzdJzxTFPUlb73I1T8hYDFVkXwaCqUeQBoed6iNg8r
         0L5HuwCaZ+asZVH4JmeItKu5igGS3JgGUyRGTnYfSgOUMVvOmNNtXway0CV92rH/4m6o
         tRYGJgxae6gA60aewcHMZ2TjoljeblVWaYL9WX7uJB3O7fgXaXy8YJO5rJEAYSbF9PS4
         7E/g/8eTi1kx3e00rDOxXQQtwVParDvaIDSj+pTN+mkLLGIH++6l6LJbKQKpqZ9LT29j
         xWQoY1LymZI5/xMlzy8kpAHu6DEZz4/rZUooFzDWrpxZC/2pX1laCjxtMBk3Nw78HBQ0
         ftOQ==
X-Gm-Message-State: AOAM533BzgWMQtGnY2ai8bksCeH94CepVRvPFRE0FTGdWFqU8gWpCymO
        EALhXjLK5P22HaLWRkjQL56RZGugYGmwNZPOO73HR4L5uEts
X-Google-Smtp-Source: ABdhPJwnu9ZDb3d6uC4lwGErimwV67tihcQIJZwN2yFAJRDttab0qePiaifswtJFkcHsTrKljmcnCVFQC440Qby+tSYZkoguNzN1
MIME-Version: 1.0
X-Received: by 2002:a05:6602:21cc:: with SMTP id c12mr2455264ioc.81.1601487738554;
 Wed, 30 Sep 2020 10:42:18 -0700 (PDT)
Date:   Wed, 30 Sep 2020 10:42:18 -0700
In-Reply-To: <0000000000009dac0205b05ab52a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c4d11a05b08b6b56@google.com>
Subject: Re: general protection fault in tcf_generic_walker
From:   syzbot <syzbot+b47bc4f247856fb4d9e1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    2b3e981a Merge branch 'mptcp-Fix-for-32-bit-DATA_FIN'
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=16537247900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=99a7c78965c75e07
dashboard link: https://syzkaller.appspot.com/bug?extid=b47bc4f247856fb4d9e1
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1412a5a7900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b47bc4f247856fb4d9e1@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 0 PID: 8855 Comm: syz-executor.1 Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:tcf_dump_walker net/sched/act_api.c:240 [inline]
RIP: 0010:tcf_generic_walker+0x367/0xba0 net/sched/act_api.c:343
Code: 24 31 ff 48 89 de e8 c8 55 eb fa 48 85 db 74 3f e8 3e 59 eb fa 48 8d 7d 30 48 b9 00 00 00 00 00 fc ff df 48 89 f8 48 c1 e8 03 <80> 3c 08 00 0f 85 26 07 00 00 48 8b 5d 30 31 ff 48 2b 1c 24 48 89
RSP: 0018:ffffc9000b6ff3a8 EFLAGS: 00010202
RAX: 0000000000000004 RBX: c0000000ffffaae4 RCX: dffffc0000000000
RDX: ffff8880a82aa140 RSI: ffffffff868ae502 RDI: 0000000000000020
RBP: fffffffffffffff0 R08: 0000000000000000 R09: ffff8880a8c41e07
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88809f226340
R13: 0000000000000000 R14: 00000000ffffffff R15: 0000000000000000
FS:  00007f156f7fa700(0000) GS:ffff8880ae400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055d25128b348 CR3: 00000000a7d3d000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 tc_dump_action+0x6d5/0xe60 net/sched/act_api.c:1609
 netlink_dump+0x4cd/0xf60 net/netlink/af_netlink.c:2246
 __netlink_dump_start+0x643/0x900 net/netlink/af_netlink.c:2354
 netlink_dump_start include/linux/netlink.h:246 [inline]
 rtnetlink_rcv_msg+0x70f/0xad0 net/core/rtnetlink.c:5526
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45dd99
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f156f7f9c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000002d3c0 RCX: 000000000045dd99
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000005
RBP: 000000000118bf60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bf2c
R13: 00007ffc8f863a6f R14: 00007f156f7fa9c0 R15: 000000000118bf2c
Modules linked in:
---[ end trace 5123f6b953bfe0e8 ]---
RIP: 0010:tcf_dump_walker net/sched/act_api.c:240 [inline]
RIP: 0010:tcf_generic_walker+0x367/0xba0 net/sched/act_api.c:343
Code: 24 31 ff 48 89 de e8 c8 55 eb fa 48 85 db 74 3f e8 3e 59 eb fa 48 8d 7d 30 48 b9 00 00 00 00 00 fc ff df 48 89 f8 48 c1 e8 03 <80> 3c 08 00 0f 85 26 07 00 00 48 8b 5d 30 31 ff 48 2b 1c 24 48 89
RSP: 0018:ffffc9000b6ff3a8 EFLAGS: 00010202
RAX: 0000000000000004 RBX: c0000000ffffaae4 RCX: dffffc0000000000
RDX: ffff8880a82aa140 RSI: ffffffff868ae502 RDI: 0000000000000020
RBP: fffffffffffffff0 R08: 0000000000000000 R09: ffff8880a8c41e07
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88809f226340
R13: 0000000000000000 R14: 00000000ffffffff R15: 0000000000000000
FS:  00007f156f7fa700(0000) GS:ffff8880ae400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055d251258ed8 CR3: 00000000a7d3d000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

