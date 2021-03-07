Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5509F32FF7F
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 08:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhCGHes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 02:34:48 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:50492 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbhCGHeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 02:34:14 -0500
Received: by mail-io1-f70.google.com with SMTP id w15so5261478ioa.17
        for <netdev@vger.kernel.org>; Sat, 06 Mar 2021 23:34:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=WBQ/EAYCbN0tLwutD0WrUqw4VY+LDOs0Bm/BlJkcyZw=;
        b=Hw4qB3F6o3RKTFjuMyzhSgGzxc8HZVv0tBeL0TJWR+dDSJO+/b+HCA/M8Ki9K5SFiR
         zXjWB2by5/mV1UPD4dkgeulYw+kPZ1VVkKbeehQ8Lnh/8p4Y1JLdvCkEOcQ/3TvF1h4o
         M1uB6Ho+nbKq5lkYin8FLx2UqzQThc87QRMWA63u1QryNaAiKI4FvuUcjv7wfAZT769K
         1cwH8iZrJvTNwzK1KRd3gK918VJY4B2UZfFTurjNCgyWe9SkvDgE8pLuE3S+7lvaddLA
         R+sDJoao5eo7Lx1Zs5QAnTo8ugLJ1aDoll4T5Wir/FTte8zBPWbXiRjJUSjfk7HM+S0t
         fc3g==
X-Gm-Message-State: AOAM531RhbEbwAk5x/7Dotpsx3c3GPFpg56DCmii2SNtZyoBXuA2Da+y
        PHUMB7R3CUSK+otPfx3sD/fJm+aCxRRy7i3XaMr7tw/RXynr
X-Google-Smtp-Source: ABdhPJxgpQsWEf/5SsXz2WjydRJQf7N1i7LbrLl4oJ4qPP87uszQI27mICsw3SfpRxX5NWE55yvfpjnWIDsS5dHGrBwN3xXTqjmd
MIME-Version: 1.0
X-Received: by 2002:a6b:db15:: with SMTP id t21mr14298466ioc.133.1615102454214;
 Sat, 06 Mar 2021 23:34:14 -0800 (PST)
Date:   Sat, 06 Mar 2021 23:34:14 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000f35a405bced58e3@google.com>
Subject: [syzbot] general protection fault in bt_accept_unlink (2)
From:   syzbot <syzbot+582be673ab4f59f68c5e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    95b39f07 net: ethernet: mtk-star-emac: fix wrong unmap in ..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=13658a5cd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e2d5ba72abae4f14
dashboard link: https://syzkaller.appspot.com/bug?extid=582be673ab4f59f68c5e

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+582be673ab4f59f68c5e@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xf7775c0000001777: 0000 [#1] PREEMPT SMP KASAN
KASAN: maybe wild-memory-access in range [0xbbbb00000000bbb8-0xbbbb00000000bbbf]
CPU: 0 PID: 6057 Comm: kworker/0:6 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events l2cap_chan_timeout
RIP: 0010:__list_del_entry_valid+0x81/0xf0 lib/list_debug.c:51
Code: 0f 84 af d4 08 05 48 b8 22 01 00 00 00 00 ad de 49 39 c4 0f 84 b0 d4 08 05 48 b8 00 00 00 00 00 fc ff df 4c 89 e2 48 c1 ea 03 <80> 3c 02 00 75 51 49 8b 14 24 48 39 ea 0f 85 67 d4 08 05 49 8d 7d
RSP: 0018:ffffc90002bafb28 EFLAGS: 00010a06
RAX: dffffc0000000000 RBX: ffff8880283424b8 RCX: 0000000000000000
RDX: 1777600000001777 RSI: ffffffff87ebecff RDI: ffff8880283424c0
RBP: ffff8880283424b8 R08: ffffffff8a7af760 R09: ffffffff87f99626
R10: 0000000000000004 R11: 0000000000000005 R12: bbbb00000000bbbb
R13: bb00000000000000 R14: ffff888028341020 R15: 0000000000000005
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000002349848 CR3: 0000000018f19000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __list_del_entry include/linux/list.h:132 [inline]
 list_del_init include/linux/list.h:204 [inline]
 bt_accept_unlink+0x35/0x2f0 net/bluetooth/af_bluetooth.c:187
 l2cap_sock_teardown_cb+0x197/0x660 net/bluetooth/l2cap_sock.c:1542
 l2cap_chan_del+0xbc/0xa80 net/bluetooth/l2cap_core.c:618
 l2cap_chan_close+0x1bc/0xaf0 net/bluetooth/l2cap_core.c:823
 l2cap_chan_timeout+0x17e/0x2f0 net/bluetooth/l2cap_core.c:436
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Modules linked in:
---[ end trace 7d7f7782958a606a ]---
RIP: 0010:__list_del_entry_valid+0x81/0xf0 lib/list_debug.c:51
Code: 0f 84 af d4 08 05 48 b8 22 01 00 00 00 00 ad de 49 39 c4 0f 84 b0 d4 08 05 48 b8 00 00 00 00 00 fc ff df 4c 89 e2 48 c1 ea 03 <80> 3c 02 00 75 51 49 8b 14 24 48 39 ea 0f 85 67 d4 08 05 49 8d 7d
RSP: 0018:ffffc90002bafb28 EFLAGS: 00010a06
RAX: dffffc0000000000 RBX: ffff8880283424b8 RCX: 0000000000000000
RDX: 1777600000001777 RSI: ffffffff87ebecff RDI: ffff8880283424c0
RBP: ffff8880283424b8 R08: ffffffff8a7af760 R09: ffffffff87f99626
R10: 0000000000000004 R11: 0000000000000005 R12: bbbb00000000bbbb
R13: bb00000000000000 R14: ffff888028341020 R15: 0000000000000005
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f53667bf000 CR3: 000000002623d000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
