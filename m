Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0B92214D0
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 21:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgGOTCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 15:02:20 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:48081 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgGOTCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 15:02:18 -0400
Received: by mail-il1-f198.google.com with SMTP id o2so1970962ilg.14
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 12:02:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=IvBAlDcCZSy6gieOWJ3Kbyh8aqBj4OB6TL5Ylx9sPEE=;
        b=K+8jGJwy+bH16AlZ0cmAcc/3r4W5kfuqibc65vZ0JCU6Of50Pwuahy/ee7Ef510nci
         omX8bypg8KpZv5NMGitXo6hiZfIH4UDwvE96C2ERBGAN9wH2D89r2JyG7+B9qNvOdThr
         Le3ujHlD6kNtYJjf4ledZF58ggy1T1+Sy+pLgXGOxn5tGzzUyGXdtebICnVfHdu4xt+W
         P1+ylRkedDKlVEnhDUXsr4B+EtN+7zXtqbrum/EiPWR6G3SYfMKud+WqHDZ4s0nBtsP9
         3aBcor6ZHEJudfP6KTRLcJQbX7vZxsPrvdpCtetfEcwY8iR/Re5GULkuXvCEgX1GaZzF
         wGoA==
X-Gm-Message-State: AOAM531hKcFwcnInjbadXmMKaEG10DWIEl30pfX9J2RZQ9fR8nc3FU08
        uHxlX8R0xUhyfa0zb8+aMxa7JjYKvVDGHz2QuqVSxb7E8UaN
X-Google-Smtp-Source: ABdhPJz8udE03kBEjB3evt74sZ2m5j1npU80K8rneJClVSbdZLksXrPdiIpSAdIWyqbtvvi+uXJ3t7+pwzWCIZNvGcvMPrwcx/mN
MIME-Version: 1.0
X-Received: by 2002:a92:150d:: with SMTP id v13mr865761ilk.297.1594839737406;
 Wed, 15 Jul 2020 12:02:17 -0700 (PDT)
Date:   Wed, 15 Jul 2020 12:02:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000059b7205aa7f906f@google.com>
Subject: KASAN: use-after-free Read in __xfrm6_tunnel_spi_lookup
From:   syzbot <syzbot+72ff2fa98097767b5a27@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    5fb3d604 Add linux-next specific files for 20200714
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1107074f100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2c76d72659687242
dashboard link: https://syzkaller.appspot.com/bug?extid=72ff2fa98097767b5a27
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+72ff2fa98097767b5a27@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __xfrm6_tunnel_spi_lookup+0x3a9/0x3b0 net/ipv6/xfrm6_tunnel.c:79
Read of size 8 at addr ffff88809b08a228 by task syz-executor.4/3359
CPU: 0 PID: 3359 Comm: syz-executor.4 Not tainted 5.8.0-rc5-next-20200714-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 __xfrm6_tunnel_spi_lookup+0x3a9/0x3b0 net/ipv6/xfrm6_tunnel.c:79
 xfrm6_tunnel_spi_lookup+0x8a/0x1d0 net/ipv6/xfrm6_tunnel.c:95
 xfrmi6_rcv_tunnel+0xb9/0x100 net/xfrm/xfrm_interface.c:810
 tunnel46_rcv+0xef/0x2b0 net/ipv6/tunnel6.c:193
 ip6_protocol_deliver_rcu+0x2e8/0x1670 net/ipv6/ip6_input.c:433
 ip6_input_finish+0x7f/0x160 net/ipv6/ip6_input.c:474
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x9c/0xd0 net/ipv6/ip6_input.c:483
 dst_input include/net/dst.h:449 [inline]
 ip6_rcv_finish net/ipv6/ip6_input.c:76 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x28e/0x3c0 net/ipv6/ip6_input.c:307
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5287
 __netif_receive_skb+0x27/0x1c0 net/core/dev.c:5401
 netif_receive_skb_internal net/core/dev.c:5503 [inline]
 netif_receive_skb+0x159/0x990 net/core/dev.c:5562
 tun_rx_batched.isra.0+0x460/0x720 drivers/net/tun.c:1518
 tun_get_user+0x23b2/0x35b0 drivers/net/tun.c:1972
 tun_chr_write_iter+0xba/0x151 drivers/net/tun.c:2001
 call_write_iter include/linux/fs.h:1879 [inline]
 new_sync_write+0x422/0x650 fs/read_write.c:515
 vfs_write+0x59d/0x6b0 fs/read_write.c:595
 ksys_write+0x12d/0x250 fs/read_write.c:648
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x416661
Code: Bad RIP value.
RSP: 002b:00007f9187100c60 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000000000050ac20 RCX: 0000000000416661
RDX: 000000000000004a RSI: 0000000020000340 RDI: 00000000000000f0
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 00007f91871019d0 R11: 0000000000000293 R12: 00000000ffffffff
R13: 0000000000000c36 R14: 00000000004ce81f R15: 00007f91871016d4
Allocated by task 3905:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 __do_kmalloc mm/slab.c:3655 [inline]
 __kmalloc+0x1a8/0x320 mm/slab.c:3664
 kmalloc include/linux/slab.h:559 [inline]
 tomoyo_realpath_from_path+0xc3/0x620 security/tomoyo/realpath.c:254
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x212/0x3f0 security/tomoyo/file.c:822
 security_inode_getattr+0xcf/0x140 security/security.c:1287
 vfs_getattr fs/stat.c:121 [inline]
 vfs_statx+0x170/0x390 fs/stat.c:206
 vfs_lstat include/linux/fs.h:3176 [inline]
 __do_sys_newlstat+0x91/0x110 fs/stat.c:374
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
Freed by task 3905:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0xd8/0x120 mm/kasan/common.c:422
 __cache_free mm/slab.c:3418 [inline]
 kfree+0x103/0x2c0 mm/slab.c:3756
 tomoyo_realpath_from_path+0x191/0x620 security/tomoyo/realpath.c:291
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x212/0x3f0 security/tomoyo/file.c:822
 security_inode_getattr+0xcf/0x140 security/security.c:1287
 vfs_getattr fs/stat.c:121 [inline]
 vfs_statx+0x170/0x390 fs/stat.c:206
 vfs_lstat include/linux/fs.h:3176 [inline]
 __do_sys_newlstat+0x91/0x110 fs/stat.c:374
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
The buggy address belongs to the object at ffff88809b08a000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 552 bytes inside of
 4096-byte region [ffff88809b08a000, ffff88809b08b000)
The buggy address belongs to the page:
page:000000003cd8428c refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x9b08a
head:000000003cd8428c order:1 compound_mapcount:0
flags: 0xfffe0000010200(slab|head)
raw: 00fffe0000010200 ffffea00027afa88 ffffea00016acc88 ffff8880aa000900
raw: 0000000000000000 ffff88809b08a000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected
Memory state around the buggy address:
 ffff88809b08a100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88809b08a180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88809b08a200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                  ^
 ffff88809b08a280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88809b08a300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
