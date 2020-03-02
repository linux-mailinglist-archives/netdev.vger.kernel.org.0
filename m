Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C181176224
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 19:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbgCBSNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 13:13:13 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:54685 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgCBSNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 13:13:13 -0500
Received: by mail-io1-f71.google.com with SMTP id c1so303546ioa.21
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 10:13:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=enaO3WnemnSAhq2pBNyk9x5WY6fbVpF5APw5359ae28=;
        b=OTqmFNNa+N5EuQqBgcRoDU5cSARhzUMS6+W3bsc6KP5/MsZpg2RqhDqZlUbOPNsjyl
         ryICTU467IcJJEf/lqO19sf2/Os/BKmJbf8Af9KqaKF72w1yDVG+Cgdtc0FBEsrFPfPe
         5rYOthm7PimhD4BY0fTFw02VWgpwFKU3f0FOD4Wj48jnX2ZdIP3S+CeHMR5xSjcf9c7k
         l8Hk/Slfe8xVmcqLqisl87UlsuaNSG/Q6nJTPQmvX7KvLIrhQMcXkGcnr/KbkcM6mlui
         sOAIyufrn6AGhqZfo5VhYaUpF2ijIFRbmOjFCvvzzqIl8Jt3O4YlLrBQKtCMs6mz5mcr
         Kf5A==
X-Gm-Message-State: ANhLgQ3KvHCpmW7EoTnN7sKrK01GJLiiMZhFua6id+Lw2A8glSIUEX5v
        zsGBtHvtB4I0wZXTQL/gWhWyvvXhjnv12HbPtHZKmmbXrHy3
X-Google-Smtp-Source: ADFU+vsLu/ggNeHFlojmtvyYhvgRezTV9RK5MMXPUdgC2Jz/xKZa9eAKDgJEBOOJ/lpziGymDNnFsn2/6B+gDZhw/T56ptLnL8MK
MIME-Version: 1.0
X-Received: by 2002:a6b:d207:: with SMTP id q7mr663366iob.49.1583172792602;
 Mon, 02 Mar 2020 10:13:12 -0800 (PST)
Date:   Mon, 02 Mar 2020 10:13:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ebdc39059fe32327@google.com>
Subject: memory leak in nf_tables_parse_netdev_hooks (2)
From:   syzbot <syzbot+a2ff6fa45162a5ed4dd3@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    63623fd4 Merge tag 'for-linus' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10060a2de00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6951e37c8d613538
dashboard link: https://syzkaller.appspot.com/bug?extid=a2ff6fa45162a5ed4dd3
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15acfa81e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=172f9d09e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a2ff6fa45162a5ed4dd3@syzkaller.appspotmail.com

executing program
BUG: memory leak
unreferenced object 0xffff88810b2b2080 (size 96):
  comm "syz-executor089", pid 7270, jiffies 4294941532 (age 13.520s)
  hex dump (first 32 bytes):
    00 21 2b 0b 81 88 ff ff 40 06 37 1a 81 88 ff ff  .!+.....@.7.....
    20 47 c7 82 ff ff ff ff 00 60 2e 2a 81 88 ff ff   G.......`.*....
  backtrace:
    [<00000000f3a29219>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    [<00000000f3a29219>] slab_post_alloc_hook mm/slab.h:586 [inline]
    [<00000000f3a29219>] slab_alloc mm/slab.c:3320 [inline]
    [<00000000f3a29219>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3549
    [<000000005471dca6>] kmalloc include/linux/slab.h:555 [inline]
    [<000000005471dca6>] nft_netdev_hook_alloc+0x3f/0xd0 net/netfilter/nf_tables_api.c:1653
    [<00000000547b3e6d>] nf_tables_parse_netdev_hooks+0xaa/0x220 net/netfilter/nf_tables_api.c:1702
    [<000000005c4bc909>] nf_tables_flowtable_parse_hook net/netfilter/nf_tables_api.c:6097 [inline]
    [<000000005c4bc909>] nf_tables_newflowtable+0x407/0x930 net/netfilter/nf_tables_api.c:6297
    [<000000004e57b3ed>] nfnetlink_rcv_batch+0x353/0x8c0 net/netfilter/nfnetlink.c:433
    [<0000000095bbce6c>] nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:543 [inline]
    [<0000000095bbce6c>] nfnetlink_rcv+0x189/0x1c0 net/netfilter/nfnetlink.c:561
    [<000000002a197f31>] netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
    [<000000002a197f31>] netlink_unicast+0x223/0x310 net/netlink/af_netlink.c:1329
    [<000000002fe97501>] netlink_sendmsg+0x2c0/0x570 net/netlink/af_netlink.c:1918
    [<0000000072a2eef7>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<0000000072a2eef7>] sock_sendmsg+0x54/0x70 net/socket.c:672
    [<0000000049691ba6>] ____sys_sendmsg+0x2d0/0x300 net/socket.c:2343
    [<00000000466e69b2>] ___sys_sendmsg+0x8a/0xd0 net/socket.c:2397
    [<0000000086270dd0>] __sys_sendmsg+0x80/0xf0 net/socket.c:2430
    [<000000001b2586e4>] __do_sys_sendmsg net/socket.c:2439 [inline]
    [<000000001b2586e4>] __se_sys_sendmsg net/socket.c:2437 [inline]
    [<000000001b2586e4>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2437
    [<0000000005b8b511>] do_syscall_64+0x73/0x220 arch/x86/entry/common.c:294
    [<000000005e09659b>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810b2b2100 (size 96):
  comm "syz-executor089", pid 7270, jiffies 4294941532 (age 13.520s)
  hex dump (first 32 bytes):
    40 06 37 1a 81 88 ff ff 80 20 2b 0b 81 88 ff ff  @.7...... +.....
    20 47 c7 82 ff ff ff ff 00 e0 1d 25 81 88 ff ff   G.........%....
  backtrace:
    [<00000000f3a29219>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    [<00000000f3a29219>] slab_post_alloc_hook mm/slab.h:586 [inline]
    [<00000000f3a29219>] slab_alloc mm/slab.c:3320 [inline]
    [<00000000f3a29219>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3549
    [<000000005471dca6>] kmalloc include/linux/slab.h:555 [inline]
    [<000000005471dca6>] nft_netdev_hook_alloc+0x3f/0xd0 net/netfilter/nf_tables_api.c:1653
    [<00000000547b3e6d>] nf_tables_parse_netdev_hooks+0xaa/0x220 net/netfilter/nf_tables_api.c:1702
    [<000000005c4bc909>] nf_tables_flowtable_parse_hook net/netfilter/nf_tables_api.c:6097 [inline]
    [<000000005c4bc909>] nf_tables_newflowtable+0x407/0x930 net/netfilter/nf_tables_api.c:6297
    [<000000004e57b3ed>] nfnetlink_rcv_batch+0x353/0x8c0 net/netfilter/nfnetlink.c:433
    [<0000000095bbce6c>] nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:543 [inline]
    [<0000000095bbce6c>] nfnetlink_rcv+0x189/0x1c0 net/netfilter/nfnetlink.c:561
    [<000000002a197f31>] netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
    [<000000002a197f31>] netlink_unicast+0x223/0x310 net/netlink/af_netlink.c:1329
    [<000000002fe97501>] netlink_sendmsg+0x2c0/0x570 net/netlink/af_netlink.c:1918
    [<0000000072a2eef7>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<0000000072a2eef7>] sock_sendmsg+0x54/0x70 net/socket.c:672
    [<0000000049691ba6>] ____sys_sendmsg+0x2d0/0x300 net/socket.c:2343
    [<00000000466e69b2>] ___sys_sendmsg+0x8a/0xd0 net/socket.c:2397
    [<0000000086270dd0>] __sys_sendmsg+0x80/0xf0 net/socket.c:2430
    [<000000001b2586e4>] __do_sys_sendmsg net/socket.c:2439 [inline]
    [<000000001b2586e4>] __se_sys_sendmsg net/socket.c:2437 [inline]
    [<000000001b2586e4>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2437
    [<0000000005b8b511>] do_syscall_64+0x73/0x220 arch/x86/entry/common.c:294
    [<000000005e09659b>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
