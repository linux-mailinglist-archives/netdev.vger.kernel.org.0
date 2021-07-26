Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA193D52FC
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 08:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhGZFW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 01:22:57 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:57151 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhGZFW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 01:22:56 -0400
Received: by mail-io1-f71.google.com with SMTP id k24-20020a6bef180000b02904a03acf5d82so7752483ioh.23
        for <netdev@vger.kernel.org>; Sun, 25 Jul 2021 23:03:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=JfbhjMR66wI1pvpYO16Yx+gCNLgoGcbJx3F6G+TVvgA=;
        b=ekfWwB+wzetmhq7PvlkWM3HDSFvXCWotVC7SztTW0uwKG76UZgdVqx75Z8HpK/vgcq
         6xlXDph5iOo1amqSfETQUPk0wOBNns9q4B2a5TIkcYiMEwz+cRK6ThJ+jNDmhO1eEmln
         HGGuwdmT/3I0tMlaUr1e+Frsvz7KLv59N8oIXH2CSeuSMRCw7RSwy5FKosNDnNqQPVSD
         rBe/sxyCa7DMxT7ht5WH6l1HLkE89cQr6hvDurnk175v9HTwVJHCt9A7SW0aOhvyNUk2
         faWznW3Wl3p8+t7AmTXRoEqKZfkA3OPmJkj/DmORjPcoZ3Kl1sGA5I18gZAdt65JJyJr
         D9wQ==
X-Gm-Message-State: AOAM530yuRTjALz1UijO4i945qUAi8sTIys2aPvrMjI2vSoTAmAj92px
        znjaC8d+mLLIYPdQcPCBMt/RB1KU4nsBjdKz+vx6Z4EhqLlL
X-Google-Smtp-Source: ABdhPJya86IQNZAnEye9luaQvyfeUXdBgmXgr3P9WmnUsu5Zb03TCIxDEm3Z2vwW2/RyIGG7SUYHcUDjKm1H3Cev2VhGJUS9ErTm
MIME-Version: 1.0
X-Received: by 2002:a02:90cb:: with SMTP id c11mr15313659jag.53.1627279404706;
 Sun, 25 Jul 2021 23:03:24 -0700 (PDT)
Date:   Sun, 25 Jul 2021 23:03:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000de2e6105c8008244@google.com>
Subject: [syzbot] kernel BUG in rxrpc_destroy_all_connections
From:   syzbot <syzbot+bf9c3ae5a6f9fd3d043c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        marc.dionne@auristor.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    08f71a1e39a1 selftests/bpf: Check inner map deletion
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11d2d36c300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=da140227e4f25b17
dashboard link: https://syzkaller.appspot.com/bug?extid=bf9c3ae5a6f9fd3d043c

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bf9c3ae5a6f9fd3d043c@syzkaller.appspotmail.com

rxrpc: Assertion failed
------------[ cut here ]------------
kernel BUG at net/rxrpc/conn_object.c:479!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 10 Comm: kworker/u4:1 Tainted: G        W         5.14.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:rxrpc_destroy_all_connections.cold+0x11/0x13 net/rxrpc/conn_object.c:479
Code: c0 48 c7 c1 40 07 a4 8a 48 89 f2 48 c7 c7 c0 03 a4 8a e8 61 f8 c0 ff 0f 0b e8 04 0d 4e f8 48 c7 c7 c0 06 a4 8a e8 4e f8 c0 ff <0f> 0b e8 f1 0c 4e f8 48 c7 c7 80 0b a4 8a e8 3b f8 c0 ff 0f 0b e8
RSP: 0018:ffffc90000cf7b30 EFLAGS: 00010282
RAX: 0000000000000017 RBX: ffff888017690000 RCX: 0000000000000000
RDX: ffff888010a59c40 RSI: ffffffff815d6a45 RDI: fffff5200019ef58
RBP: ffff888017690064 R08: 0000000000000017 R09: 0000000000000000
R10: ffffffff815d087e R11: 0000000000000000 R12: ffff888017690068
R13: ffff888017690078 R14: ffff888017690078 R15: ffff88801768feb8
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055eda1b11928 CR3: 0000000021a6e000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 rxrpc_exit_net+0x155/0x2f0 net/rxrpc/net_ns.c:119
 ops_exit_list+0xb0/0x160 net/core/net_namespace.c:175
 cleanup_net+0x4ea/0xb10 net/core/net_namespace.c:595
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Modules linked in:
---[ end trace 5947326f88ebc62c ]---
RIP: 0010:rxrpc_destroy_all_connections.cold+0x11/0x13 net/rxrpc/conn_object.c:479
Code: c0 48 c7 c1 40 07 a4 8a 48 89 f2 48 c7 c7 c0 03 a4 8a e8 61 f8 c0 ff 0f 0b e8 04 0d 4e f8 48 c7 c7 c0 06 a4 8a e8 4e f8 c0 ff <0f> 0b e8 f1 0c 4e f8 48 c7 c7 80 0b a4 8a e8 3b f8 c0 ff 0f 0b e8
RSP: 0018:ffffc90000cf7b30 EFLAGS: 00010282
RAX: 0000000000000017 RBX: ffff888017690000 RCX: 0000000000000000
RDX: ffff888010a59c40 RSI: ffffffff815d6a45 RDI: fffff5200019ef58
RBP: ffff888017690064 R08: 0000000000000017 R09: 0000000000000000
R10: ffffffff815d087e R11: 0000000000000000 R12: ffff888017690068
R13: ffff888017690078 R14: ffff888017690078 R15: ffff88801768feb8
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055eda1bbf997 CR3: 0000000021a6e000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
