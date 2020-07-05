Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65666214AE2
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 09:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgGEHUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 03:20:20 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:53357 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbgGEHUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 03:20:19 -0400
Received: by mail-il1-f199.google.com with SMTP id r4so25388281ilq.20
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 00:20:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=FOlJXX0kPCdtjXZxOviZj/hAmzpp9NZrYwqmJx5sypE=;
        b=W8weGtJREZknz8EeteFIsdAxMcQhp4FE5Nrrs/SdoK0chdqriPQl7bqY6Vh+4yOiRl
         H9ACcvmT1ACfcLH0FpOgywPA5nIocMzKrgW38GMbd08bOAkWY46od4CYCr4lUKOs1srr
         tMH+emMPeRfx5ThmFifWrpyVaeW2pi0uAyUradM5skknX/JrfbZNna7SSh7xQPuG5BaR
         ggZoIBPJuo/vzjnKfYZHCFpeZCQIqTmGVJF/2otuaKAFT+O6WdEMIGH4nqi+743A2aS8
         yuTyWvXso8lA5NzxaYeSAOZTSQ4LbPegADoALvvH1dYdLmm0dauT9AcoyV+e8iSSlMp3
         K7uw==
X-Gm-Message-State: AOAM532U4NWcmDN4Ras3/SH3p8nIXIYd5nMftjHzqSpmkam0RyBVelpa
        OaAVF02kpeeytNbgKnvASsCpZNbHL3dJOGQHpNO8y0ckyPvv
X-Google-Smtp-Source: ABdhPJzo3oVkqh8i32lF2qfsXAkIgUHoJ0GchH80zWwOgQ53U2tG+OfKjlm7F+FBATFutgdODTKnfP7Yw/Vrr0z8y2c2noeRkFt4
MIME-Version: 1.0
X-Received: by 2002:a05:6602:134d:: with SMTP id i13mr20437934iov.113.1593933618231;
 Sun, 05 Jul 2020 00:20:18 -0700 (PDT)
Date:   Sun, 05 Jul 2020 00:20:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001c3bf005a9ac975c@google.com>
Subject: KASAN: slab-out-of-bounds Read in __xfrm_state_lookup
From:   syzbot <syzbot+deb366561a1f28f6c13d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    c28e58ee Add linux-next specific files for 20200629
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14fe1b17100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dcd26bbca17dd1db
dashboard link: https://syzkaller.appspot.com/bug?extid=deb366561a1f28f6c13d
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+deb366561a1f28f6c13d@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in __xfrm_state_lookup.isra.0+0x809/0x870 net/xfrm/xfrm_state.c:938
Read of size 8 at addr ffff88809585dab8 by task syz-executor.1/12920

CPU: 1 PID: 12920 Comm: syz-executor.1 Not tainted 5.8.0-rc3-next-20200629-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 __xfrm_state_lookup.isra.0+0x809/0x870 net/xfrm/xfrm_state.c:938
 xfrm_state_find+0x1d57/0x4d70 net/xfrm/xfrm_state.c:1100
 xfrm_tmpl_resolve_one net/xfrm/xfrm_policy.c:2384 [inline]
 xfrm_tmpl_resolve+0x2f3/0xd20 net/xfrm/xfrm_policy.c:2429
 xfrm_resolve_and_create_bundle+0x123/0x24f0 net/xfrm/xfrm_policy.c:2719
 xfrm_lookup_with_ifid+0x235/0x2100 net/xfrm/xfrm_policy.c:3042
 xfrm_lookup net/xfrm/xfrm_policy.c:3166 [inline]
 xfrm_lookup_route+0x36/0x1e0 net/xfrm/xfrm_policy.c:3177
 ip6_dst_lookup_flow+0x159/0x1d0 net/ipv6/ip6_output.c:1160
 rawv6_sendmsg+0xc82/0x38f0 net/ipv6/raw.c:928
 inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:814
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x331/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmmsg+0x195/0x480 net/socket.c:2496
 __do_sys_sendmmsg net/socket.c:2525 [inline]
 __se_sys_sendmmsg net/socket.c:2522 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2522
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45cb29
Code: Bad RIP value.
RSP: 002b:00007f46d295bc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00000000004fd720 RCX: 000000000045cb29
RDX: 00000000000002e9 RSI: 0000000020000480 RDI: 0000000000000008
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000903 R14: 00000000004cbe13 R15: 00007f46d295c6d4

Allocated by task 23:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:494
 __do_kmalloc mm/slab.c:3659 [inline]
 __kmalloc+0x18f/0x4d0 mm/slab.c:3668
 kmalloc include/linux/slab.h:559 [inline]
 kzalloc include/linux/slab.h:666 [inline]
 xfrm_hash_alloc+0xbd/0xe0 net/xfrm/xfrm_hash.c:21
 xfrm_hash_resize+0x96/0x14a0 net/xfrm/xfrm_state.c:135
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Freed by task 1:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf2/0x130 mm/kasan/common.c:455
 __cache_free mm/slab.c:3422 [inline]
 kfree+0x103/0x2c0 mm/slab.c:3760
 tomoyo_path_perm+0x234/0x3f0 security/tomoyo/file.c:842
 security_inode_getattr+0xcf/0x140 security/security.c:1278
 vfs_getattr fs/stat.c:121 [inline]
 vfs_statx_fd+0x70/0xf0 fs/stat.c:151
 vfs_fstat include/linux/fs.h:3172 [inline]
 __do_sys_newfstat+0x88/0x100 fs/stat.c:398
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff88809585da00
 which belongs to the cache kmalloc-128 of size 128
The buggy address is located 56 bytes to the right of
 128-byte region [ffff88809585da00, ffff88809585da80)
The buggy address belongs to the page:
page:ffffea0002561740 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0002526348 ffffea00022f4588 ffff8880aa000400
raw: 0000000000000000 ffff88809585d000 0000000100000010 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88809585d980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88809585da00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88809585da80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                        ^
 ffff88809585db00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88809585db80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
