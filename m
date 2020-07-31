Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A542349BB
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 18:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733072AbgGaQyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 12:54:23 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:38265 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728958AbgGaQyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 12:54:22 -0400
Received: by mail-io1-f70.google.com with SMTP id a65so12423047iog.5
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 09:54:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ARDRp3KNxJ0Mur5k39eF0BHl1nLpOy5JRf/QHvN6dFk=;
        b=E/3hjAhvWBFWurOu+X6zDWnNHJkNCTVfiI4yFJRbkMGNFbVQ7Bn+vhkXbTzqOgh9TO
         aWXGQPMX6mF0CDDsk69+UTMxGn37pFV5AUeC6nakYTaXX7vQUpmjmQ5serMafZmSrpAs
         B73SVvwRsvXMaHOJqFHyeErttHqr2t6TCbljvoisUVRfNr4p+JYMHjRrbxN+HgoBZd9J
         uyi0rKeplgOGqOPyTOoOil4BoaNZ17Flak3UvzS7lOoO0zbZ8W0GruD0E39rAkpM4Ynp
         mO1WO2x3yBJG9TE7+vMLaiZW+7qVSiz257CgK62LQ/+gqf2S32xHD7+yTky78WHk2INB
         GRIw==
X-Gm-Message-State: AOAM531gpzJO3K+5CcQNzGr7LjpdUePFzrNprd8fSYvOggqP5ds/DxQJ
        ic+8BMT7P2+ATpq+DmjNfrnTZACakl4n4gzYXHhNu/MbbggT
X-Google-Smtp-Source: ABdhPJxP2PbBB8deYKj2Tc4M1SS2BCEM0juaeT3FHB8Zzq3MURwrPnYltjduqem2f6JiZYRpGP2INyzeumkyJnqkAJRd8iw1hVjt
MIME-Version: 1.0
X-Received: by 2002:a6b:4407:: with SMTP id r7mr4409152ioa.77.1596214461310;
 Fri, 31 Jul 2020 09:54:21 -0700 (PDT)
Date:   Fri, 31 Jul 2020 09:54:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f3b11a05abbfa345@google.com>
Subject: INFO: trying to register non-static key in skb_dequeue
From:   syzbot <syzbot+fadfba6a911f6bf71842@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    83bdc727 random32: remove net_rand_state from the latent e..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=119bc404900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c0cfcf935bcc94d2
dashboard link: https://syzkaller.appspot.com/bug?extid=fadfba6a911f6bf71842
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16ce9270900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1485c092900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fadfba6a911f6bf71842@syzkaller.appspotmail.com

IPVS: ftp: loaded support on port[0] = 21
INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 1 PID: 6833 Comm: syz-executor596 Not tainted 5.8.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 assign_lock_key kernel/locking/lockdep.c:894 [inline]
 register_lock_class+0x157d/0x1630 kernel/locking/lockdep.c:1206
 __lock_acquire+0xfa/0x56e0 kernel/locking/lockdep.c:4259
 lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:4959
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x8c/0xc0 kernel/locking/spinlock.c:159
 skb_dequeue+0x1c/0x180 net/core/skbuff.c:3038
 skb_queue_purge+0x21/0x30 net/core/skbuff.c:3076
 l2cap_chan_del+0x61d/0x1300 net/bluetooth/l2cap_core.c:657
 l2cap_conn_del+0x46a/0x9e0 net/bluetooth/l2cap_core.c:1890
 l2cap_disconn_cfm net/bluetooth/l2cap_core.c:8159 [inline]
 l2cap_disconn_cfm+0x85/0xa0 net/bluetooth/l2cap_core.c:8152
 hci_disconn_cfm include/net/bluetooth/hci_core.h:1355 [inline]
 hci_conn_hash_flush+0x114/0x220 net/bluetooth/hci_conn.c:1536
 hci_dev_do_close+0x5c6/0x1080 net/bluetooth/hci_core.c:1761
 hci_unregister_dev+0x1a3/0xe20 net/bluetooth/hci_core.c:3606
 vhci_release+0x70/0xe0 drivers/bluetooth/hci_vhci.c:340
 __fput+0x33c/0x880 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:135
 exit_task_work include/linux/task_work.h:25 [inline]
 do_exit+0xb72/0x2a40 kernel/exit.c:805
 do_group_exit+0x125/0x310 kernel/exit.c:903
 __do_sys_exit_group kernel/exit.c:914 [inline]
 __se_sys_exit_group kernel/exit.c:912 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:912
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x444fe8
Code: Bad RIP value.
RSP: 002b:00007ffde50eda98 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 0000000000444fe8
RDX: 0000000000000001 RSI: 000000000000003c RDI: 0000000000000001
RBP: 00000000004cce10 R08: 00000000000000e7 R09: ffffffffffffffd0
R10: 00007f0c43ebb700 R11: 0000000000000246 R12: 0000000000000001
R13: 00000000006e0200 R14: 0000000001898850 R15: 0000000000000001


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
