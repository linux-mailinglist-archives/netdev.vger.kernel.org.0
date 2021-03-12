Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A79338608
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 07:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhCLGjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 01:39:45 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:45567 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhCLGjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 01:39:16 -0500
Received: by mail-il1-f198.google.com with SMTP id h17so17438511ila.12
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 22:39:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=g3zjpdswFE2kA27UXZk7hLq/73z12NA10NHqfoa280k=;
        b=jvt1AJV4UYPkI46nX6+yfHRCdBkZ3lmBoXTCi0kUeXjjKG8uZI2GKNrIVv218SnKqj
         TmDf0bVBp4HpzI+f1/JG2NrPstcxqw+hh0m4WFJ2Ki0HJJDW4vbKz6KyNcT2N3dXHBLA
         xR3AJNXXN5CKYzOiXPIwRYtEWQA9G2hkFTjdfpZC3u1Sh25drz/3kw6ntxzjrfWzOzzQ
         TuXvXMOBMKZQoiw67sW5j3Z1/RZ/nC0u1T/Qv12qu7RwZ5kdHsv+PHL8rvWdgD3eddrO
         LeNJSYpdQOnLleUXsX4XSYMNYgWZHAsb8VJXBwn85MroBzn05rokE7yTNbykW2eOlOaw
         e55g==
X-Gm-Message-State: AOAM533yByewwjyQhkFSgcz72JvJOfwZJ+T47nlQMnP6fZ6FFLthBW36
        b8SyEpAby6Ttnx7vLTCLF6vYcaxaJdjf7+XQPvOj+3pGu//S
X-Google-Smtp-Source: ABdhPJymlvH42sOil6uLqdn+S94g+eap5aObLWy+OCHp8jQIADHRiWr8qS9ScR5ieVxVBAKy9cFABjLclDQ+ORH1R0vbFKrZqevb
MIME-Version: 1.0
X-Received: by 2002:a05:6638:d47:: with SMTP id d7mr7174593jak.2.1615531156128;
 Thu, 11 Mar 2021 22:39:16 -0800 (PST)
Date:   Thu, 11 Mar 2021 22:39:16 -0800
In-Reply-To: <000000000000540c0405ba3e9dff@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000af467105bd5128fc@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in firmware_fallback_sysfs
From:   syzbot <syzbot+de271708674e2093097b@syzkaller.appspotmail.com>
To:     broonie@kernel.org, catalin.marinas@arm.com,
        gregkh@linuxfoundation.org, kristina.martsenko@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, mbenes@suse.cz, mcgrof@kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        syzkaller-bugs@googlegroups.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    47142ed6 net: dsa: bcm_sf2: Qualify phydev->dev_flags base..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=11ccd12ad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=eec733599e95cd87
dashboard link: https://syzkaller.appspot.com/bug?extid=de271708674e2093097b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15437d56d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+de271708674e2093097b@syzkaller.appspotmail.com

platform regulatory.0: Direct firmware load for regulatory.db failed with error -2
platform regulatory.0: Falling back to sysfs fallback for: regulatory.db
==================================================================
BUG: KASAN: use-after-free in __list_add_valid+0x81/0xa0 lib/list_debug.c:23
Read of size 8 at addr ffff888028830ac8 by task syz-executor.4/9852

CPU: 0 PID: 9852 Comm: syz-executor.4 Not tainted 5.12.0-rc2-syzkaller #0
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
RIP: 0033:0x465f69
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6d26af9188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000465f69
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000003
RBP: 00000000004bfa8f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 00007ffdd4adb6bf R14: 00007f6d26af9300 R15: 0000000000022000

Allocated by task 9835:
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

Freed by task 9835:
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

The buggy address belongs to the object at ffff888028830a00
 which belongs to the cache kmalloc-256 of size 256
The buggy address is located 200 bytes inside of
 256-byte region [ffff888028830a00, ffff888028830b00)
The buggy address belongs to the page:
page:ffffea0000a20c00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x28830
head:ffffea0000a20c00 order:1 compound_mapcount:0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 dead000000000100 dead000000000122 ffff888010841b40
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888028830980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888028830a00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888028830a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                              ^
 ffff888028830b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888028830b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================

