Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718C51D4F98
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 15:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgEONxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 09:53:17 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:35308 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgEONxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 09:53:16 -0400
Received: by mail-il1-f200.google.com with SMTP id w16so2210874ilm.2
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 06:53:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=dtg5GgafUw4jGvE5P1d7UwvG3o7ee9JspFTKmxqu558=;
        b=F41vdk5mduZRVJe328KMU+KNr0cnfqmuCbW4ErlkJl4Fub7jwnvs8foCvXZGLh8ZNk
         LkPhf27hBeeti368WhGuZuLCpAmfgnUdOWFYoWsIgkSL9EadRAawkUOxXQmI9TIxzNOU
         rlObOo6SPqSwAck8DcoCaVphxNkcoGH+kGAWIaqAme5WzGcV9mA4fTR0L8AXzBeUt44g
         x28A2tKrpzQXoTIW6g89pRX3bB8rnaXITYgoYPe2djft5ad2GICQFkN1SIdKz529uhnS
         TI8hZN6+2JGX5kw2bKMRIJ1gQr3FqOQyZYaqrj8qJo0sApkrqWX9jmWgU5zeKAVzWxK+
         mCQQ==
X-Gm-Message-State: AOAM533eVyi+cTCYwNvhm7HrA0GxH3z3RTadXKw7q4astwNX+CU//eSd
        0fuM6eJ22Gfn1M8tDPtejuLqna49ClyeGf6vfhG5UEGZRE5g
X-Google-Smtp-Source: ABdhPJxDlPbOh9OWF6qG9IvAhXCBtqfBvJwis/9Oapte4FHxuB9lhIi0dKU+PZ58mGCwVUhotu+kex36s31TAvSfQRrAkVgnlieQ
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:f81:: with SMTP id v1mr3317412ilo.246.1589550794365;
 Fri, 15 May 2020 06:53:14 -0700 (PDT)
Date:   Fri, 15 May 2020 06:53:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000735f5205a5b02279@google.com>
Subject: BUG: unable to handle kernel paging request in fl_dump_key
From:   syzbot <syzbot+9c1be56e9317b795e874@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    99addbe3 net: broadcom: Select BROADCOM_PHY for BCMGENET
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=173e568c100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b0212dbee046bc1f
dashboard link: https://syzkaller.appspot.com/bug?extid=9c1be56e9317b795e874
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9c1be56e9317b795e874@syzkaller.appspotmail.com

BUG: unable to handle page fault for address: fffffbfff4a9538a
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffe5067 P4D 21ffe5067 PUD 21ffe4067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 5831 Comm: syz-executor.3 Not tainted 5.7.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:fl_dump_key+0x8c/0x1980 net/sched/cls_flower.c:2514
Code: 04 f2 04 f2 c7 40 0c 04 f3 f3 f3 65 48 8b 04 25 28 00 00 00 48 89 84 24 b0 00 00 00 31 c0 e8 3b 0d 20 fb 48 89 e8 48 c1 e8 03 <42> 0f b6 04 30 84 c0 74 08 3c 03 0f 8e 6f 17 00 00 44 8b 75 00 31
RSP: 0018:ffffc900019672d8 EFLAGS: 00010a03
RAX: 1ffffffff4a9538a RBX: ffffffffa54a9a8f RCX: ffffc9000f733000
RDX: 000000000000080f RSI: ffffffff86532275 RDI: ffff88808f68b800
RBP: ffffffffa54a9c57 R08: ffff888096266200 R09: ffff888097a5603c
R10: ffff888097a56036 R11: ffffed1012f4ac06 R12: ffff88808f68b800
R13: ffff88806780a100 R14: dffffc0000000000 R15: ffff88806780a100
FS:  00007f0a86395700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4a9538a CR3: 0000000099de6000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 fl_tmplt_dump+0xcf/0x250 net/sched/cls_flower.c:2784
 tc_chain_fill_node+0x48e/0x7c0 net/sched/cls_api.c:2707
 tc_chain_notify+0x189/0x2e0 net/sched/cls_api.c:2733
 tc_ctl_chain+0xb82/0x1080 net/sched/cls_api.c:2919
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5454
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
 ___sys_sendmsg+0x100/0x170 net/socket.c:2416
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45c829
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f0a86394c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000500d20 RCX: 000000000045c829
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 000000000078c040 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000a05 R14: 00000000004ccbdd R15: 00007f0a863956d4
Modules linked in:
CR2: fffffbfff4a9538a
---[ end trace da47bdc433f8d794 ]---
RIP: 0010:fl_dump_key+0x8c/0x1980 net/sched/cls_flower.c:2514
Code: 04 f2 04 f2 c7 40 0c 04 f3 f3 f3 65 48 8b 04 25 28 00 00 00 48 89 84 24 b0 00 00 00 31 c0 e8 3b 0d 20 fb 48 89 e8 48 c1 e8 03 <42> 0f b6 04 30 84 c0 74 08 3c 03 0f 8e 6f 17 00 00 44 8b 75 00 31
RSP: 0018:ffffc900019672d8 EFLAGS: 00010a03
RAX: 1ffffffff4a9538a RBX: ffffffffa54a9a8f RCX: ffffc9000f733000
RDX: 000000000000080f RSI: ffffffff86532275 RDI: ffff88808f68b800
RBP: ffffffffa54a9c57 R08: ffff888096266200 R09: ffff888097a5603c
R10: ffff888097a56036 R11: ffffed1012f4ac06 R12: ffff88808f68b800
R13: ffff88806780a100 R14: dffffc0000000000 R15: ffff88806780a100
FS:  00007f0a86395700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4a9538a CR3: 0000000099de6000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
