Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6EFB251DE6
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 19:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgHYRNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 13:13:54 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:51962 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgHYRNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 13:13:25 -0400
Received: by mail-il1-f197.google.com with SMTP id f22so9521316ill.18
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 10:13:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ep+DsuyAmWsazblTEOVrewteCHG+sHXnccEH6Iu0R/c=;
        b=qOs9xSzSS92XNsBClVjy6XOG/0H+LMTeTfhHGotzJZXL3wkKNZz8CfcemFAc0qo8zO
         +cgx4qbH2AcCNDi9tfpie8cySGr1Qm4HxEI8k6QlTYjHa0bFtSkNR/KLmD0Qwcc/x4Nu
         wqhD/6fnz2FN6haALgcxJQuWC5ALhp4DgeCtw+U8HQB7C4IvnNAGA6xETxk/CW4UCBf0
         JCsxgGT/ywpBQ6Y8htPbbMKS9b1v3ZwdnB9uo7UM/pouQiD13Mn/sHarZB/4IpdNJxWy
         jbSJ1hCSR0kp6PmXmmu8mkny49CpZfrYzG0vGKnClBcIXGL9qjX/BM6ob2lU2XBBYYR0
         /IwQ==
X-Gm-Message-State: AOAM532CzQ9up3+txARyf9SIlAIvrInCSlUl/ySglgx9Me02/efJES3S
        bZ6YCdHenwe5UAmmn6KYX1YTp8Y1IlyYLAYpd8h5Sl6NsP+5
X-Google-Smtp-Source: ABdhPJy4rZok+wcE1queuo86SuHNhGp4mUTkPPKETthZwliyP7AUH5bEvlP5H8dqW85tdV8DLUWWyfIPuDrpQ7M9l6XIR27RRUUC
MIME-Version: 1.0
X-Received: by 2002:a92:9a94:: with SMTP id c20mr8972530ill.37.1598375603959;
 Tue, 25 Aug 2020 10:13:23 -0700 (PDT)
Date:   Tue, 25 Aug 2020 10:13:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000177d5605adb6d2c7@google.com>
Subject: general protection fault in addrconf_notify
From:   syzbot <syzbot+8f00ab65043d135664b9@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    494d311a Add linux-next specific files for 20200821
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=170c9051900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a61d44f28687f508
dashboard link: https://syzkaller.appspot.com/bug?extid=8f00ab65043d135664b9
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8f00ab65043d135664b9@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc00e0dffffe: 0000 [#1] PREEMPT SMP KASAN
KASAN: probably user-memory-access in range [0x0000000706fffff0-0x0000000706fffff7]
CPU: 1 PID: 19287 Comm: syz-executor.3 Not tainted 5.9.0-rc1-next-20200821-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:addrconf_ifdown.isra.0+0x33b/0x1570 net/ipv6/addrconf.c:3743
Code: 84 d2 01 00 00 e8 25 80 88 fa 48 81 eb 48 01 00 00 0f 84 c0 01 00 00 e8 13 80 88 fa 48 8d bb 38 01 00 00 48 89 f8 48 c1 e8 03 <80> 3c 28 00 0f 85 62 05 00 00 4c 39 bb 38 01 00 00 75 9b e8 ed 7f
RSP: 0018:ffffc900188cf8e0 EFLAGS: 00010202
RAX: 00000000e0dffffe RBX: 0000000706fffeb8 RCX: ffffffff815b5270
RDX: ffff8881f7dfa3c0 RSI: ffffffff86ebf2ad RDI: 0000000706fffff0
RBP: dffffc0000000000 R08: 0000000000000001 R09: 0000000000000003
R10: fffff52003119f0e R11: 0000000000000001 R12: 0000000000000054
R13: ffff8881f5370328 R14: 0000000000000000 R15: ffff88809a0d5800
FS:  000000000271d940(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30d2c000 CR3: 00000001f4c2b000 CR4: 00000000001526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 addrconf_notify+0x55c/0x2310 net/ipv6/addrconf.c:3627
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2033
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 dev_close_many+0x30b/0x650 net/core/dev.c:1634
 rollback_registered_many+0x3a8/0x1210 net/core/dev.c:9260
 rollback_registered net/core/dev.c:9328 [inline]
 unregister_netdevice_queue+0x2dd/0x570 net/core/dev.c:10409
 unregister_netdevice include/linux/netdevice.h:2774 [inline]
 __tun_detach+0xff6/0x1310 drivers/net/tun.c:673
 tun_detach drivers/net/tun.c:690 [inline]
 tun_chr_close+0xd9/0x180 drivers/net/tun.c:3390
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:141
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:139 [inline]
 exit_to_user_mode_prepare+0x195/0x1c0 kernel/entry/common.c:166
 syscall_exit_to_user_mode+0x59/0x2b0 kernel/entry/common.c:241
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x416e21
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48 83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffd36a5d3b0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000006 RCX: 0000000000416e21
RDX: 0000000000000000 RSI: 0000000000000eff RDI: 0000000000000005
RBP: 0000000000000001 R08: 00000000f18eaf02 R09: 0000000000000000
R10: 00007ffd36a5d4a0 R11: 0000000000000293 R12: 000000000118d940
R13: 000000000118d940 R14: ffffffffffffffff R15: 000000000118d08c
Modules linked in:
---[ end trace 46271974e693cee0 ]---
RIP: 0010:addrconf_ifdown.isra.0+0x33b/0x1570 net/ipv6/addrconf.c:3743
Code: 84 d2 01 00 00 e8 25 80 88 fa 48 81 eb 48 01 00 00 0f 84 c0 01 00 00 e8 13 80 88 fa 48 8d bb 38 01 00 00 48 89 f8 48 c1 e8 03 <80> 3c 28 00 0f 85 62 05 00 00 4c 39 bb 38 01 00 00 75 9b e8 ed 7f
RSP: 0018:ffffc900188cf8e0 EFLAGS: 00010202
RAX: 00000000e0dffffe RBX: 0000000706fffeb8 RCX: ffffffff815b5270
RDX: ffff8881f7dfa3c0 RSI: ffffffff86ebf2ad RDI: 0000000706fffff0
RBP: dffffc0000000000 R08: 0000000000000001 R09: 0000000000000003
R10: fffff52003119f0e R11: 0000000000000001 R12: 0000000000000054
R13: ffff8881f5370328 R14: 0000000000000000 R15: ffff88809a0d5800
FS:  000000000271d940(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30d2c000 CR3: 00000001f4c2b000 CR4: 00000000001526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
