Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A26D343234
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 13:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhCUMCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 08:02:18 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:35245 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbhCUMCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 08:02:16 -0400
Received: by mail-il1-f199.google.com with SMTP id y8so15466114ill.2
        for <netdev@vger.kernel.org>; Sun, 21 Mar 2021 05:02:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=QCEyVThkVzn64njBrL2b27yz3oFttL7a84jMyNGtByk=;
        b=coqszxQrSikLo7tKBeSoPUbQzzOk59A4AELzkwaVGCODROz7jqp2vQqENys4pz7YWN
         I1iNxBka25tHBbg76vlfu3P6sOoYMoas6mGcKQoNBATihFjSUV2OXLdsl0sIxXadz1RM
         oRjJ3btDeyOZCymR/O5L4q1dZ3n304rGz7apxs6Ybl/B1ucIv6M6bhbJHHBHJYMpgQ1C
         ccoxUJNpYdH2GxGEmsLVyAiPJlrrB0PWZyeXzk2cwAqe3cm0cF94h4JKR7oB2uxRQsyb
         wo0eVqBIxJf5rBjARQEBOWEu1ahd1pcUVTQVUl1fWYMBc/40f/p1nynPPpMQLFN9TiJK
         yk4w==
X-Gm-Message-State: AOAM533Mc/4JecycD54n/VUrq7AD3KbqNZ3r4PkNNMMYDyw8/JIFK2/o
        KQ4nnW6M3WYJ+Wd9nWX+iJ0HNwAWOE3Ssj2Xl+iUuYnYAgW1
X-Google-Smtp-Source: ABdhPJwcm4F32/08S17OtUQzmHwUOgMOrHTEMBm/tbs33P0677U8Vpg9EHFBJzvnL7mpyKRkpNT6k0euaqz3dr3g0Nfs17bPSEhg
MIME-Version: 1.0
X-Received: by 2002:a02:272d:: with SMTP id g45mr7616749jaa.117.1616328136223;
 Sun, 21 Mar 2021 05:02:16 -0700 (PDT)
Date:   Sun, 21 Mar 2021 05:02:16 -0700
In-Reply-To: <000000000000540c0405ba3e9dff@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000666eb305be0ab854@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in firmware_fallback_sysfs
From:   syzbot <syzbot+de271708674e2093097b@syzkaller.appspotmail.com>
To:     allan.newby@bpchargemaster.com, broonie@kernel.org,
        catalin.marinas@arm.com, gregkh@linuxfoundation.org,
        hdanton@sina.com, kristina.martsenko@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, mbenes@suse.cz, mcgrof@kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org, sunjunyong@xiaomi.com,
        syzkaller-bugs@googlegroups.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    a1e6f641 Revert "net: dsa: sja1105: Clear VLAN filtering o..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1637614ed00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c2371621441fef8b
dashboard link: https://syzkaller.appspot.com/bug?extid=de271708674e2093097b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17bc70bed00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=148b5fe6d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+de271708674e2093097b@syzkaller.appspotmail.com

platform regulatory.0: Falling back to sysfs fallback for: regulatory.db
==================================================================
BUG: KASAN: use-after-free in __list_add_valid+0x81/0xa0 lib/list_debug.c:23
Read of size 8 at addr ffff888034b802c8 by task syz-executor067/9770

CPU: 0 PID: 9770 Comm: syz-executor067 Not tainted 5.12.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:232
 __kasan_report mm/kasan/report.c:399 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
 __list_add_valid+0x81/0xa0 lib/list_debug.c:23
 __list_add include/linux/list.h:67 [inline]
 list_add include/linux/list.h:86 [inline]
 fw_load_sysfs_fallback drivers/base/firmware_loader/fallback.c:516 [inline]
 fw_load_from_user_helper drivers/base/firmware_loader/fallback.c:581 [inline]
 firmware_fallback_sysfs+0x455/0xe20 drivers/base/firmware_loader/fallback.c:657
 _request_firmware+0xa80/0xe80 drivers/base/firmware_loader/main.c:831
 request_firmware+0x32/0x50 drivers/base/firmware_loader/main.c:875
 reg_reload_regdb+0x7a/0x240 net/wireless/reg.c:1095
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4499f9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 01 16 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f657d03e318 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004d5288 RCX: 00000000004499f9
RDX: 0000000000000000 RSI: 00000000200003c0 RDI: 0000000000000003
RBP: 00000000004d5280 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0031313230386c6e
R13: 00007ffd24e61cff R14: 00007f657d03e400 R15: 0000000000022000

Allocated by task 9764:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:427 [inline]
 ____kasan_kmalloc mm/kasan/common.c:506 [inline]
 ____kasan_kmalloc mm/kasan/common.c:465 [inline]
 __kasan_kmalloc+0x99/0xc0 mm/kasan/common.c:515
 kmalloc include/linux/slab.h:554 [inline]
 kzalloc include/linux/slab.h:684 [inline]
 __allocate_fw_priv drivers/base/firmware_loader/main.c:186 [inline]
 alloc_lookup_fw_priv drivers/base/firmware_loader/main.c:250 [inline]
 _request_firmware_prepare drivers/base/firmware_loader/main.c:744 [inline]
 _request_firmware+0x2de/0xe80 drivers/base/firmware_loader/main.c:806
 request_firmware+0x32/0x50 drivers/base/firmware_loader/main.c:875
 reg_reload_regdb+0x7a/0x240 net/wireless/reg.c:1095
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 9764:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:357
 ____kasan_slab_free mm/kasan/common.c:360 [inline]
 ____kasan_slab_free mm/kasan/common.c:325 [inline]
 __kasan_slab_free+0xf5/0x130 mm/kasan/common.c:367
 kasan_slab_free include/linux/kasan.h:199 [inline]
 slab_free_hook mm/slub.c:1562 [inline]
 slab_free_freelist_hook+0x92/0x210 mm/slub.c:1600
 slab_free mm/slub.c:3161 [inline]
 kfree+0xe5/0x7f0 mm/slub.c:4213
 __free_fw_priv drivers/base/firmware_loader/main.c:282 [inline]
 kref_put include/linux/kref.h:65 [inline]
 free_fw_priv+0x2b1/0x4d0 drivers/base/firmware_loader/main.c:289
 firmware_free_data drivers/base/firmware_loader/main.c:584 [inline]
 release_firmware.part.0+0xc7/0xf0 drivers/base/firmware_loader/main.c:1053
 release_firmware drivers/base/firmware_loader/main.c:840 [inline]
 _request_firmware+0x709/0xe80 drivers/base/firmware_loader/main.c:839
 request_firmware+0x32/0x50 drivers/base/firmware_loader/main.c:875
 reg_reload_regdb+0x7a/0x240 net/wireless/reg.c:1095
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888034b80200
 which belongs to the cache kmalloc-256 of size 256
The buggy address is located 200 bytes inside of
 256-byte region [ffff888034b80200, ffff888034b80300)
The buggy address belongs to the page:
page:ffffea0000d2e000 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x34b80
head:ffffea0000d2e000 order:1 compound_mapcount:0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 dead000000000100 dead000000000122 ffff888010841b40
raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888034b80180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888034b80200: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888034b80280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                              ^
 ffff888034b80300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888034b80380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================

