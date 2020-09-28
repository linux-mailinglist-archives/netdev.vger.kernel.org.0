Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753F727A8B1
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 09:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgI1HfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 03:35:25 -0400
Received: from mail-io1-f80.google.com ([209.85.166.80]:41605 "EHLO
        mail-io1-f80.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgI1HfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 03:35:25 -0400
Received: by mail-io1-f80.google.com with SMTP id j4so120230iob.8
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 00:35:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=CJQvC4HTF83zOtIUthVZPbqguyH85VyIuX34JkoyPQ8=;
        b=qMIaVjeROpT5NOJesiB8dwHfrKtKuY1xw75FhXow6D+7DK7xehT0Xjn9iYyfG1SxVs
         v75YAcyB3wWWWtHMYxrYMza+z94Yop9OO+T3k+l6mXxlUhedyhr8yPBzTrZZ9OGtxdcv
         cpH1ggj+CJ17FsVby9y9iVbWWkz44BvSQl+3fjFnpXhmmuQ4ot1p6HJSSGQflWoUhfL3
         ph+7paRmpO7FvAjzKyowWr0AqBvMspTQrtu71zxBzKqRaecSYPrr3tdo5xdJZmUv+PCQ
         P84gOlitXEmrqmou42NG+z15BIbDrUO3iKjFtHkOpUaGVXlEH54iW8nDFR2Rbraop3rZ
         g0Ww==
X-Gm-Message-State: AOAM5331/lFqdFe5JMmHqh3yUkgXFYZUqyEgBlb/TkA5wLJXRCk4MUMO
        hDoXIqvG8EaKNVubD4/LXw6EE0lzbKI/iwoT/d7IVZ61hn24
X-Google-Smtp-Source: ABdhPJwHSw48W+RND0fHB847K7SkU4zxV5vMkiMW/kbIBeVMerY/8kllZCOhccmFtlm4jE/gbEfvD81vk9/DEAxyDX04uWVTxMpv
MIME-Version: 1.0
X-Received: by 2002:a05:6638:134a:: with SMTP id u10mr168048jad.88.1601278524106;
 Mon, 28 Sep 2020 00:35:24 -0700 (PDT)
Date:   Mon, 28 Sep 2020 00:35:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009dac0205b05ab52a@google.com>
Subject: general protection fault in tcf_generic_walker
From:   syzbot <syzbot+b47bc4f247856fb4d9e1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ad2b9b0f tcp: skip DSACKs with dubious sequence ranges
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=13baee3d900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5f4c828c9e3cef97
dashboard link: https://syzkaller.appspot.com/bug?extid=b47bc4f247856fb4d9e1
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b47bc4f247856fb4d9e1@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 0 PID: 22478 Comm: syz-executor.4 Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:tcf_dump_walker net/sched/act_api.c:240 [inline]
RIP: 0010:tcf_generic_walker+0x367/0xba0 net/sched/act_api.c:343
Code: 24 31 ff 48 89 de e8 b8 6c ed fa 48 85 db 74 3f e8 2e 70 ed fa 48 8d 7d 30 48 b9 00 00 00 00 00 fc ff df 48 89 f8 48 c1 e8 03 <80> 3c 08 00 0f 85 26 07 00 00 48 8b 5d 30 31 ff 48 2b 1c 24 48 89
RSP: 0018:ffffc90006657268 EFLAGS: 00010202
RAX: 0000000000000004 RBX: c000000100004f6c RCX: dffffc0000000000
RDX: 0000000000040000 RSI: ffffffff8688ce12 RDI: 0000000000000020
RBP: fffffffffffffff0 R08: 0000000000000000 R09: ffff8880a6270207
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88809d5c3d40
R13: 0000000000000000 R14: 00000000ffffffff R15: 0000000000000000
FS:  00007f9807b99700(0000) GS:ffff8880ae400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f01a8629db8 CR3: 00000000553cb000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 tc_dump_action+0x6d5/0xe60 net/sched/act_api.c:1623
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
 ____sys_sendmsg+0x331/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmmsg+0x195/0x480 net/socket.c:2497
 __do_sys_sendmmsg net/socket.c:2526 [inline]
 __se_sys_sendmmsg net/socket.c:2523 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2523
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e179
Code: 3d b2 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 0b b2 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f9807b98c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 0000000000027f40 RCX: 000000000045e179
RDX: 049249249249252e RSI: 0000000020000140 RDI: 0000000000000003
RBP: 000000000118cf88 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cf4c
R13: 00007fff4792d6cf R14: 00007f9807b999c0 R15: 000000000118cf4c
Modules linked in:
---[ end trace dd2fc9d645cefc73 ]---
RIP: 0010:tcf_dump_walker net/sched/act_api.c:240 [inline]
RIP: 0010:tcf_generic_walker+0x367/0xba0 net/sched/act_api.c:343
Code: 24 31 ff 48 89 de e8 b8 6c ed fa 48 85 db 74 3f e8 2e 70 ed fa 48 8d 7d 30 48 b9 00 00 00 00 00 fc ff df 48 89 f8 48 c1 e8 03 <80> 3c 08 00 0f 85 26 07 00 00 48 8b 5d 30 31 ff 48 2b 1c 24 48 89
RSP: 0018:ffffc90006657268 EFLAGS: 00010202
RAX: 0000000000000004 RBX: c000000100004f6c RCX: dffffc0000000000
RDX: 0000000000040000 RSI: ffffffff8688ce12 RDI: 0000000000000020
RBP: fffffffffffffff0 R08: 0000000000000000 R09: ffff8880a6270207
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88809d5c3d40
R13: 0000000000000000 R14: 00000000ffffffff R15: 0000000000000000
FS:  00007f9807b99700(0000) GS:ffff8880ae400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000016a9e60 CR3: 00000000553cb000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
