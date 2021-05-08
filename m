Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A61377244
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 16:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbhEHOEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 10:04:22 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:49989 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhEHOES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 10:04:18 -0400
Received: by mail-io1-f69.google.com with SMTP id i204-20020a6bb8d50000b02903f266b8e1c5so8000469iof.16
        for <netdev@vger.kernel.org>; Sat, 08 May 2021 07:03:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=v1mqmsdKbpYWWWC/cunBC+D1Q4CtmOHwBOPxbId+Re0=;
        b=Vx8cJ1s+KaYyh4ouJXoE2rNTiCfe02w5y89duQDD2LWp11H79v4iuwNp601af2Xzo3
         9oqg4NZiqtv2Gt2PctZ/vmsKI9iqZJV1gQTpOWkeniijk4VrziXN9Qcm70ooCaiCY6lb
         vNallXjGL2M3iuvnJtFN9c8SRAxapALDjOZnC2gBlciT/yAoH1ZW8RyT5iWUbx/V74XA
         1WZh1hlEMyP9Zijl2yiaeROk0leW9CH5np/QkjAM0Q6EHuyv+nMYF8Ru+BmUCpDkTBfk
         UtoS7bm6RfxNxmo3+aJ16chs2l/andyHtZKuViUvxxa3sVGis7IQUkT9TLtxbD2hu6WB
         93xQ==
X-Gm-Message-State: AOAM530rnKovrMIyd/x8dTkIKNhO/dkz8AH7CfzGbQHJuv7wbAysyWnf
        CViF2saKj40UZb5tpyihK913isDO7LgxkeHd7VbxM2BMSrJ1
X-Google-Smtp-Source: ABdhPJxa4e5I+ObeT8L8aldFFpOLFXprETEe3QqaftUenSZxrsFVObvfrTqAnkB64XOQtEjT0gvSu9pZRY5A/uSvSTqG/BYS7UVH
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3414:: with SMTP id n20mr11332248ioz.43.1620482596426;
 Sat, 08 May 2021 07:03:16 -0700 (PDT)
Date:   Sat, 08 May 2021 07:03:16 -0700
In-Reply-To: <000000000000cc615405c13e4dfe@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000086605105c1d201bc@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in nfc_llcp_put_ssap
From:   syzbot <syzbot+e4689b43d2ed2ed63611@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    95aafe91 net: ethernet: ixp4xx: Support device tree probing
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15a8c01dd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7668018815a66138
dashboard link: https://syzkaller.appspot.com/bug?extid=e4689b43d2ed2ed63611
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15ed2663d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e4689b43d2ed2ed63611@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __mutex_lock_common kernel/locking/mutex.c:931 [inline]
BUG: KASAN: use-after-free in __mutex_lock+0x1034/0x1120 kernel/locking/mutex.c:1096
Read of size 8 at addr ffff888143d92080 by task syz-executor.5/9920

CPU: 0 PID: 9920 Comm: syz-executor.5 Not tainted 5.12.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:232
 __kasan_report mm/kasan/report.c:399 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
 __mutex_lock_common kernel/locking/mutex.c:931 [inline]
 __mutex_lock+0x1034/0x1120 kernel/locking/mutex.c:1096
 nfc_llcp_put_ssap+0x49/0x2e0 net/nfc/llcp_core.c:492
 llcp_sock_release+0x1d2/0x580 net/nfc/llcp_sock.c:626
 __sock_release+0xcd/0x280 net/socket.c:599
 sock_close+0x18/0x20 net/socket.c:1258
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:140
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
 exit_to_user_mode_prepare+0x249/0x250 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x41940b
Code: 0f 05 48 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8 63 fc ff ff 8b 7c 24 0c 41 89 c0 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 89 44 24 0c e8 a1 fc ff ff 8b 44
RSP: 002b:00007ffcfd298030 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 000000000041940b
RDX: ffffffffffffffbc RSI: 0000000000000001 RDI: 0000000000000004
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000001b325200c4
R10: 00007ffcfd298120 R11: 0000000000000293 R12: 00000000000158d7
R13: 00000000000003e8 R14: 000000000056bf60 R15: 00000000000158c2

Allocated by task 1:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:427 [inline]
 ____kasan_kmalloc mm/kasan/common.c:506 [inline]
 ____kasan_kmalloc mm/kasan/common.c:465 [inline]
 __kasan_kmalloc+0x99/0xc0 mm/kasan/common.c:515
 kmalloc include/linux/slab.h:554 [inline]
 kzalloc include/linux/slab.h:684 [inline]
 nfc_llcp_register_device+0x45/0x9d0 net/nfc/llcp_core.c:1572
 nfc_register_device+0x6d/0x360 net/nfc/core.c:1124
 nfcsim_device_new+0x345/0x5c1 drivers/nfc/nfcsim.c:408
 nfcsim_init+0x71/0x14d drivers/nfc/nfcsim.c:455
 do_one_initcall+0x103/0x650 init/main.c:1226
 do_initcall_level init/main.c:1299 [inline]
 do_initcalls init/main.c:1315 [inline]
 do_basic_setup init/main.c:1335 [inline]
 kernel_init_freeable+0x63e/0x6c2 init/main.c:1537
 kernel_init+0xd/0x1b8 init/main.c:1424
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Freed by task 9921:
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
 local_release net/nfc/llcp_core.c:175 [inline]
 kref_put include/linux/kref.h:65 [inline]
 nfc_llcp_local_put net/nfc/llcp_core.c:183 [inline]
 nfc_llcp_local_put+0x194/0x200 net/nfc/llcp_core.c:178
 llcp_sock_destruct+0x81/0x150 net/nfc/llcp_sock.c:950
 __sk_destruct+0x4b/0x900 net/core/sock.c:1795
 sk_destruct+0xbd/0xe0 net/core/sock.c:1839
 __sk_free+0xef/0x3d0 net/core/sock.c:1850
 sk_free+0x78/0xa0 net/core/sock.c:1861
 sock_put include/net/sock.h:1813 [inline]
 llcp_sock_release+0x3c9/0x580 net/nfc/llcp_sock.c:644
 __sock_release+0xcd/0x280 net/socket.c:599
 sock_close+0x18/0x20 net/socket.c:1258
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:140
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
 exit_to_user_mode_prepare+0x249/0x250 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888143d92000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 128 bytes inside of
 2048-byte region [ffff888143d92000, ffff888143d92800)
The buggy address belongs to the page:
page:ffffea00050f6400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x143d90
head:ffffea00050f6400 order:3 compound_mapcount:0 compound_pincount:0
flags: 0x57ff00000010200(slab|head)
raw: 057ff00000010200 dead000000000100 dead000000000122 ffff888010842000
raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888143d91f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888143d92000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888143d92080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888143d92100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888143d92180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

