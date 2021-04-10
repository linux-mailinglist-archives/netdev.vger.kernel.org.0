Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58BE35ACB5
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 12:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbhDJKTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 06:19:32 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:39306 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbhDJKTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 06:19:32 -0400
Received: by mail-io1-f69.google.com with SMTP id y26so3437640ioq.6
        for <netdev@vger.kernel.org>; Sat, 10 Apr 2021 03:19:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=hgSXG9YBnaSp6Ilz4xmiRDkeX/YTSm22NjoFotcBRY8=;
        b=AkL6N1aJ97YwYC3Dpr+bDJITzos1zVnjpR0EE86YjJN74M5cE6+f+RZ7uU1Fz/RHzO
         49iBCtMw1PDWna5tkDZz9ZM/dr9BXeykdC2EJ3KH7VMO5kZWcKiIQYNJybQRzTQHBrnK
         xM2xMklaWv2CHd9T7BETdUtj+LrWH6vxvzmju9iozCjinvhV02TWjkHziFgdupNHy1sQ
         KGFTlUMym2i/lWYnqBqaJ3WoRyItG1nWAzkctdnMienwBFuul/qeSaTFLfnSgzsDTh90
         SJWbAa3X4ubaShtoJ48rf/7KD2/r6sePpgFyDvWOhiS7S1z7KOOmWVEoFJlk2qHsGWww
         Jw9A==
X-Gm-Message-State: AOAM5339KKM8f4dtMR1BS7x+mbDdaR2bS5t1PpyLePi5xRH95uiRun4p
        b7Hv9aR4F0YaO4Flo2jIX5jXgXF/5S9J74Fj22dgBVm0gcKs
X-Google-Smtp-Source: ABdhPJzN+SpBEPIBq7vts6GZVLRlUjiaiDY68lmVWNbRbvt+gnOlT5rwC4Q7qEaedrBqUrhUcpG49AMj3H2Bfk06nPoQGxlIKqJd
MIME-Version: 1.0
X-Received: by 2002:a02:69c9:: with SMTP id e192mr1159544jac.143.1618049955851;
 Sat, 10 Apr 2021 03:19:15 -0700 (PDT)
Date:   Sat, 10 Apr 2021 03:19:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d8f55905bf9b9cbd@google.com>
Subject: [syzbot] memory leak in skb_clone
From:   syzbot <syzbot+1f68113fa907bf0695a8@syzkaller.appspotmail.com>
To:     alex.aring@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, stefan@datenfreihafen.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    17e7124a Merge tag '5.12-rc6-smb3' of git://git.samba.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11a62c6ad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b8dbd3c72fdc7777
dashboard link: https://syzkaller.appspot.com/bug?extid=1f68113fa907bf0695a8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=179321a6d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11922ba1d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1f68113fa907bf0695a8@syzkaller.appspotmail.com

write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
BUG: memory leak
unreferenced object 0xffff88810f644600 (size 232):
  comm "softirq", pid 0, jiffies 4294967032 (age 81.270s)
  hex dump (first 32 bytes):
    10 7d 4b 12 81 88 ff ff 10 7d 4b 12 81 88 ff ff  .}K......}K.....
    00 00 00 00 00 00 00 00 40 7c 4b 12 81 88 ff ff  ........@|K.....
  backtrace:
    [<ffffffff83651d4a>] skb_clone+0xaa/0x2b0 net/core/skbuff.c:1496
    [<ffffffff83fe1b80>] ieee802154_raw_deliver net/ieee802154/socket.c:369 [inline]
    [<ffffffff83fe1b80>] ieee802154_rcv+0x100/0x340 net/ieee802154/socket.c:1070
    [<ffffffff8367cc7a>] __netif_receive_skb_one_core+0x6a/0xa0 net/core/dev.c:5384
    [<ffffffff8367cd07>] __netif_receive_skb+0x27/0xa0 net/core/dev.c:5498
    [<ffffffff8367cdd9>] netif_receive_skb_internal net/core/dev.c:5603 [inline]
    [<ffffffff8367cdd9>] netif_receive_skb+0x59/0x260 net/core/dev.c:5662
    [<ffffffff83fe6302>] ieee802154_deliver_skb net/mac802154/rx.c:29 [inline]
    [<ffffffff83fe6302>] ieee802154_subif_frame net/mac802154/rx.c:102 [inline]
    [<ffffffff83fe6302>] __ieee802154_rx_handle_packet net/mac802154/rx.c:212 [inline]
    [<ffffffff83fe6302>] ieee802154_rx+0x612/0x620 net/mac802154/rx.c:284
    [<ffffffff83fe59a6>] ieee802154_tasklet_handler+0x86/0xa0 net/mac802154/main.c:35
    [<ffffffff81232aab>] tasklet_action_common.constprop.0+0x5b/0x100 kernel/softirq.c:557
    [<ffffffff846000bf>] __do_softirq+0xbf/0x2ab kernel/softirq.c:345
    [<ffffffff81232f4c>] do_softirq kernel/softirq.c:248 [inline]
    [<ffffffff81232f4c>] do_softirq+0x5c/0x80 kernel/softirq.c:235
    [<ffffffff81232fc1>] __local_bh_enable_ip+0x51/0x60 kernel/softirq.c:198
    [<ffffffff8367a9a4>] local_bh_enable include/linux/bottom_half.h:32 [inline]
    [<ffffffff8367a9a4>] rcu_read_unlock_bh include/linux/rcupdate.h:745 [inline]
    [<ffffffff8367a9a4>] __dev_queue_xmit+0x7f4/0xf60 net/core/dev.c:4221
    [<ffffffff83fe2db4>] raw_sendmsg+0x1f4/0x2b0 net/ieee802154/socket.c:295
    [<ffffffff8363af16>] sock_sendmsg_nosec net/socket.c:654 [inline]
    [<ffffffff8363af16>] sock_sendmsg+0x56/0x80 net/socket.c:674
    [<ffffffff8363deec>] __sys_sendto+0x15c/0x200 net/socket.c:1977
    [<ffffffff8363dfb6>] __do_sys_sendto net/socket.c:1989 [inline]
    [<ffffffff8363dfb6>] __se_sys_sendto net/socket.c:1985 [inline]
    [<ffffffff8363dfb6>] __x64_sys_sendto+0x26/0x30 net/socket.c:1985

BUG: memory leak
unreferenced object 0xffff88810dae5200 (size 512):
  comm "syz-executor749", pid 8387, jiffies 4294967560 (age 75.990s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8364aeff>] kmalloc_reserve net/core/skbuff.c:353 [inline]
    [<ffffffff8364aeff>] __alloc_skb+0xdf/0x280 net/core/skbuff.c:424
    [<ffffffff836539e3>] __pskb_copy_fclone+0x73/0x330 net/core/skbuff.c:1601
    [<ffffffff82ad4213>] __pskb_copy include/linux/skbuff.h:1167 [inline]
    [<ffffffff82ad4213>] pskb_copy include/linux/skbuff.h:3191 [inline]
    [<ffffffff82ad4213>] hwsim_hw_xmit+0xd3/0x140 drivers/net/ieee802154/mac802154_hwsim.c:132
    [<ffffffff83fe63d7>] drv_xmit_async net/mac802154/driver-ops.h:16 [inline]
    [<ffffffff83fe63d7>] ieee802154_tx+0xc7/0x190 net/mac802154/tx.c:83
    [<ffffffff83fe65c8>] ieee802154_subif_start_xmit+0x58/0x70 net/mac802154/tx.c:132
    [<ffffffff83679e31>] __netdev_start_xmit include/linux/netdevice.h:4825 [inline]
    [<ffffffff83679e31>] netdev_start_xmit include/linux/netdevice.h:4839 [inline]
    [<ffffffff83679e31>] xmit_one net/core/dev.c:3605 [inline]
    [<ffffffff83679e31>] dev_hard_start_xmit+0xe1/0x330 net/core/dev.c:3621
    [<ffffffff8371d125>] sch_direct_xmit+0x1c5/0x500 net/sched/sch_generic.c:313
    [<ffffffff8371d661>] qdisc_restart net/sched/sch_generic.c:376 [inline]
    [<ffffffff8371d661>] __qdisc_run+0x201/0x810 net/sched/sch_generic.c:384
    [<ffffffff8367ad4f>] qdisc_run include/net/pkt_sched.h:136 [inline]
    [<ffffffff8367ad4f>] qdisc_run include/net/pkt_sched.h:128 [inline]
    [<ffffffff8367ad4f>] __dev_xmit_skb net/core/dev.c:3807 [inline]
    [<ffffffff8367ad4f>] __dev_queue_xmit+0xb9f/0xf60 net/core/dev.c:4162
    [<ffffffff83fe2db4>] raw_sendmsg+0x1f4/0x2b0 net/ieee802154/socket.c:295
    [<ffffffff8363af16>] sock_sendmsg_nosec net/socket.c:654 [inline]
    [<ffffffff8363af16>] sock_sendmsg+0x56/0x80 net/socket.c:674
    [<ffffffff8363deec>] __sys_sendto+0x15c/0x200 net/socket.c:1977
    [<ffffffff8363dfb6>] __do_sys_sendto net/socket.c:1989 [inline]
    [<ffffffff8363dfb6>] __se_sys_sendto net/socket.c:1985 [inline]
    [<ffffffff8363dfb6>] __x64_sys_sendto+0x26/0x30 net/socket.c:1985
    [<ffffffff842ded2d>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810e079d00 (size 232):
  comm "softirq", pid 0, jiffies 4294967560 (age 75.990s)
  hex dump (first 32 bytes):
    10 71 4b 12 81 88 ff ff 10 71 4b 12 81 88 ff ff  .qK......qK.....
    00 00 00 00 00 00 00 00 40 70 4b 12 81 88 ff ff  ........@pK.....
  backtrace:
    [<ffffffff83651d4a>] skb_clone+0xaa/0x2b0 net/core/skbuff.c:1496
    [<ffffffff83fe1b80>] ieee802154_raw_deliver net/ieee802154/socket.c:369 [inline]
    [<ffffffff83fe1b80>] ieee802154_rcv+0x100/0x340 net/ieee802154/socket.c:1070
    [<ffffffff8367cc7a>] __netif_receive_skb_one_core+0x6a/0xa0 net/core/dev.c:5384
    [<ffffffff8367cd07>] __netif_receive_skb+0x27/0xa0 net/core/dev.c:5498
    [<ffffffff8367cdd9>] netif_receive_skb_internal net/core/dev.c:5603 [inline]
    [<ffffffff8367cdd9>] netif_receive_skb+0x59/0x260 net/core/dev.c:5662
    [<ffffffff83fe6302>] ieee802154_deliver_skb net/mac802154/rx.c:29 [inline]
    [<ffffffff83fe6302>] ieee802154_subif_frame net/mac802154/rx.c:102 [inline]
    [<ffffffff83fe6302>] __ieee802154_rx_handle_packet net/mac802154/rx.c:212 [inline]
    [<ffffffff83fe6302>] ieee802154_rx+0x612/0x620 net/mac802154/rx.c:284
    [<ffffffff83fe59a6>] ieee802154_tasklet_handler+0x86/0xa0 net/mac802154/main.c:35
    [<ffffffff81232aab>] tasklet_action_common.constprop.0+0x5b/0x100 kernel/softirq.c:557
    [<ffffffff846000bf>] __do_softirq+0xbf/0x2ab kernel/softirq.c:345
    [<ffffffff81232f4c>] do_softirq kernel/softirq.c:248 [inline]
    [<ffffffff81232f4c>] do_softirq+0x5c/0x80 kernel/softirq.c:235
    [<ffffffff81232fc1>] __local_bh_enable_ip+0x51/0x60 kernel/softirq.c:198
    [<ffffffff8367a9a4>] local_bh_enable include/linux/bottom_half.h:32 [inline]
    [<ffffffff8367a9a4>] rcu_read_unlock_bh include/linux/rcupdate.h:745 [inline]
    [<ffffffff8367a9a4>] __dev_queue_xmit+0x7f4/0xf60 net/core/dev.c:4221
    [<ffffffff83fe2db4>] raw_sendmsg+0x1f4/0x2b0 net/ieee802154/socket.c:295
    [<ffffffff8363af16>] sock_sendmsg_nosec net/socket.c:654 [inline]
    [<ffffffff8363af16>] sock_sendmsg+0x56/0x80 net/socket.c:674
    [<ffffffff8363deec>] __sys_sendto+0x15c/0x200 net/socket.c:1977
    [<ffffffff8363dfb6>] __do_sys_sendto net/socket.c:1989 [inline]
    [<ffffffff8363dfb6>] __se_sys_sendto net/socket.c:1985 [inline]
    [<ffffffff8363dfb6>] __x64_sys_sendto+0x26/0x30 net/socket.c:1985

write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
