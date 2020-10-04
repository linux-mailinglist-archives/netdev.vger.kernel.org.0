Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545DF2829AC
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 10:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgJDIsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 04:48:25 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:45823 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbgJDIsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 04:48:25 -0400
Received: by mail-il1-f197.google.com with SMTP id 18so1377747ilj.12
        for <netdev@vger.kernel.org>; Sun, 04 Oct 2020 01:48:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=HUrxEfrvGltaT0f64KMeac1neV4ySMf1wCAqKa4nV/A=;
        b=nN8eVETLe2ROJCDTd8QHS2UX5P2RHX98DDYyg9UgpezMuJWaqE3+fLvb0W05RrQDve
         m/Ilrwr3p/g1+1xz6FJ02jksDFRNdriy0URCNDyfdDcnjYymzHyS6qYhQt9ZGu40E1pb
         YAoNuYZdd02/4yWf96PFOklJgIU8+ipcrMBNoIgc+jEGxg8Zys8RwWKhiqyaZi8AHoYv
         Wt+O3TSFyZzJwgtITHQcALizXw6G10WQI63VUsYDkLZNkYjcl5bE/Bgx+Mw1TUwUpmOh
         kVhzdb1DIbOp6SJZ8jD3RNV2Wb4oAA74GK9uO/2uX4gZ72tohSheGMUDJExbVZVVakg8
         1hsg==
X-Gm-Message-State: AOAM530em7KuguoWwd6WCSeaN30/U53xRaWWmz971EGkM2wu9q/qtSvE
        LPLzymI/Gr6DNGE3Q6TnTgpMb9f0xs60YhQ4SWvUlSFuuXx9
X-Google-Smtp-Source: ABdhPJzDl8C9Z7q03u+hEUQKs8tiSWla+HXZPH0qQl8tPWCwQbOln0XKy/CyZn4mKZsmBgAlIoRXmjbg2FbC7cY2cxWoNhQ2Q6L8
MIME-Version: 1.0
X-Received: by 2002:a92:b503:: with SMTP id f3mr7725977ile.23.1601801302683;
 Sun, 04 Oct 2020 01:48:22 -0700 (PDT)
Date:   Sun, 04 Oct 2020 01:48:22 -0700
In-Reply-To: <000000000000b3d57105b05ab856@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a5b86105b0d46d59@google.com>
Subject: Re: BUG: unable to handle kernel paging request in tcf_action_dump_terse
From:   syzbot <syzbot+5f66662adc70969940fd@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    2172e358 Add linux-next specific files for 20201002
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12ba75ff900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=70698f530a7e856f
dashboard link: https://syzkaller.appspot.com/bug?extid=5f66662adc70969940fd
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=142fd4af900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ffcdeb900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5f66662adc70969940fd@syzkaller.appspotmail.com

BUG: unable to handle page fault for address: fffffffffffffff0
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD a291067 P4D a291067 PUD a293067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8162 Comm: syz-executor344 Not tainted 5.9.0-rc7-next-20201002-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:tcf_action_dump_terse+0x8c/0x4e0 net/sched/act_api.c:759
Code: 3c 03 0f 8e 0a 03 00 00 48 89 da 44 8b ad b8 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 10 04 00 00 <48> 8b 03 4c 8d 60 10 4c 89 e7 e8 55 5b 58 fd 4c 89 e1 be 01 00 00
RSP: 0018:ffffc90009bff178 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: fffffffffffffff0 RCX: 0000000000000000
RDX: 1ffffffffffffffe RSI: ffffffff867eb859 RDI: ffff888097102eb8
RBP: ffff888097102e00 R08: 0000000000000000 R09: ffff88809ea92024
R10: 0000000000000000 R11: 0000000000000000 R12: fffffffffffffff0
R13: 0000000000000024 R14: ffff88809ea92000 R15: ffff888097102ec0
FS:  00007f6bfe65f700(0000) GS:ffff8880ae500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffffffffffff0 CR3: 0000000096ec4000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 tcf_action_dump_1+0xd2/0x5a0 net/sched/act_api.c:788
 tcf_dump_walker net/sched/act_api.c:249 [inline]
 tcf_generic_walker+0x207/0xba0 net/sched/act_api.c:343
 tc_dump_action+0x6d5/0xe60 net/sched/act_api.c:1610
 netlink_dump+0x4df/0xba0 net/netlink/af_netlink.c:2268
 __netlink_dump_start+0x643/0x900 net/netlink/af_netlink.c:2373
 netlink_dump_start include/linux/netlink.h:246 [inline]
 rtnetlink_rcv_msg+0x70f/0xad0 net/core/rtnetlink.c:5526
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2489
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x331/0x810 net/socket.c:2362
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2416
 __sys_sendmmsg+0x196/0x4b0 net/socket.c:2506
 __do_sys_sendmmsg net/socket.c:2535 [inline]
 __se_sys_sendmmsg net/socket.c:2532 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2532
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x44a569
Code: e8 8c e7 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 5b 05 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f6bfe65ed98 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00000000006dfc48 RCX: 000000000044a569
RDX: 010efe10675dec16 RSI: 0000000020000200 RDI: 0000000000000003
RBP: 00000000006dfc40 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dfc4c
R13: 0000000000000005 R14: 00a3a20740000000 R15: 0507002400000038
Modules linked in:
CR2: fffffffffffffff0
---[ end trace c7fd3dfeaf54c122 ]---
RIP: 0010:tcf_action_dump_terse+0x8c/0x4e0 net/sched/act_api.c:759
Code: 3c 03 0f 8e 0a 03 00 00 48 89 da 44 8b ad b8 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 10 04 00 00 <48> 8b 03 4c 8d 60 10 4c 89 e7 e8 55 5b 58 fd 4c 89 e1 be 01 00 00
RSP: 0018:ffffc90009bff178 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: fffffffffffffff0 RCX: 0000000000000000
RDX: 1ffffffffffffffe RSI: ffffffff867eb859 RDI: ffff888097102eb8
RBP: ffff888097102e00 R08: 0000000000000000 R09: ffff88809ea92024
R10: 0000000000000000 R11: 0000000000000000 R12: fffffffffffffff0
R13: 0000000000000024 R14: ffff88809ea92000 R15: ffff888097102ec0
FS:  00007f6bfe65f700(0000) GS:ffff8880ae500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffffffffffff0 CR3: 0000000096ec4000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

