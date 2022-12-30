Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C802C65976D
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 11:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234836AbiL3Klr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 05:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234879AbiL3Klp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 05:41:45 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA0717E08
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 02:41:43 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id b24-20020a056602219800b006e2bf9902cbso6426962iob.4
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 02:41:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U751i9cY6TeoWaPae69g7NjvC/WLPbyn2lFLGzvEkj4=;
        b=zKyej8JR/L77gnIMU4T7DzyU9LtFdUAewjLy0D/Zd/1CiWOkz9jZF/kMC2njGa9fyJ
         x9ISweAeNzaLja1oIQkq+WCq9p6rc53MlhLw51rH3JrYUAh0f/vkoipFiuMZ3dT+TOsk
         U4eMXAbyyLPYWjmpxBAEZaQtnU1mA3b7QGa1m3007hboSlqYTocZ2NtFmLmXWn+fUJxW
         xJgjEq8H60yIF4qx69FGNpg82l1WHjaC/ahV8KmpHvMMtaR8WCpQEeRLrgPMLdcdGO0a
         2KydWZRYGZ3Zk4XHuRv8Oy5VrrszbqXnkEvIQYSwYb3VVjsUu7zSvnksO4+6njyF7ElT
         YKbQ==
X-Gm-Message-State: AFqh2kqAqP6O0Rmw6Xk3f46lmQOVqR3Iw2tCl0vERc7iTZyXJ/HFNjsM
        vZUPyVHDQjhxKqVR2QEn0TMWqu8uqsqZllJbyLLfrc2PWXn1
X-Google-Smtp-Source: AMrXdXuP89fWY9Xs8EKSitggFjgcZ9inravJ86p5PyqrrrjZMMKnm7GFYXm+CpdTGQETSXp5uv3VDVzxpy/gYifMar6mungK+DcS
MIME-Version: 1.0
X-Received: by 2002:a02:a482:0:b0:38a:5b26:8cf8 with SMTP id
 d2-20020a02a482000000b0038a5b268cf8mr2577760jam.82.1672396902597; Fri, 30 Dec
 2022 02:41:42 -0800 (PST)
Date:   Fri, 30 Dec 2022 02:41:42 -0800
In-Reply-To: <0000000000006f759505ee84d8d7@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004d893c05f1093ff1@google.com>
Subject: Re: [syzbot] BUG: corrupted list in nfc_llcp_unregister_device
From:   syzbot <syzbot+81232c4a81a886e2b580@syzkaller.appspotmail.com>
To:     309386628@qq.com, davem@davemloft.net,
        dominic.coppola@gatoradeadvert.com, dvyukov@google.com,
        edumazet@google.com, krzysztof.kozlowski@linaro.org,
        kuba@kernel.org, linma@zju.edu.cn, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, zahiabdelmalak0@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    2258c2dc850b Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13c52432480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=555d27e379d75ff1
dashboard link: https://syzkaller.appspot.com/bug?extid=81232c4a81a886e2b580
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=170f1214480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c7ce28c7893b/disk-2258c2dc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/467de08be04b/vmlinux-2258c2dc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d5b6a70e73f2/bzImage-2258c2dc.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+81232c4a81a886e2b580@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in nfc_llcp_unregister_device+0x65/0x1b0 net/nfc/llcp_core.c:1610
Read of size 8 at addr ffff88802ca38000 by task syz-executor.1/6961

CPU: 1 PID: 6961 Comm: syz-executor.1 Not tainted 6.2.0-rc1-syzkaller-00043-g2258c2dc850b #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e3/0x2d0 lib/dump_stack.c:106
 print_address_description+0x74/0x340 mm/kasan/report.c:306
 print_report+0x107/0x220 mm/kasan/report.c:417
 kasan_report+0x139/0x170 mm/kasan/report.c:517
 nfc_llcp_unregister_device+0x65/0x1b0 net/nfc/llcp_core.c:1610
 nfc_unregister_device+0x18a/0x290 net/nfc/core.c:1179
 virtual_ncidev_close+0x55/0x90 drivers/nfc/virtual_ncidev.c:163
 __fput+0x3ba/0x880 fs/file_table.c:320
 task_work_run+0x243/0x300 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop+0x134/0x160 kernel/entry/common.c:171
 exit_to_user_mode_prepare+0xad/0x110 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x2e/0x60 kernel/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fd45fe3df5b
Code: 0f 05 48 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8 63 fc ff ff 8b 7c 24 0c 41 89 c0 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 89 44 24 0c e8 a1 fc ff ff 8b 44
RSP: 002b:00007ffd4c417c70 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00007fd45fe3df5b
RDX: 0000001b2e720000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00007fd45ffad980 R08: 0000000000000000 R09: 0000000000000010
R10: 00007ffd4c55f0b8 R11: 0000000000000293 R12: 000000000018c31c
R13: 00007ffd4c417d70 R14: 00007fd45ffac120 R15: 0000000000000032
 </TASK>

Allocated by task 6975:
 kasan_save_stack mm/kasan/common.c:45 [inline]
 kasan_set_track+0x4c/0x70 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:371 [inline]
 __kasan_kmalloc+0x97/0xb0 mm/kasan/common.c:380
 kmalloc include/linux/slab.h:580 [inline]
 kzalloc include/linux/slab.h:720 [inline]
 nfc_llcp_register_device+0x51/0x800 net/nfc/llcp_core.c:1566
 nfc_register_device+0x68/0x320 net/nfc/core.c:1124
 nci_register_device+0x7c7/0x900 net/nfc/nci/core.c:1257
 virtual_ncidev_open+0x138/0x1b0 drivers/nfc/virtual_ncidev.c:148
 misc_open+0x346/0x3c0 drivers/char/misc.c:165
 chrdev_open+0x5fb/0x680 fs/char_dev.c:414
 do_dentry_open+0x85f/0x11b0 fs/open.c:882
 do_open fs/namei.c:3557 [inline]
 path_openat+0x25cc/0x2de0 fs/namei.c:3714
 do_filp_open+0x275/0x500 fs/namei.c:3741
 do_sys_openat2+0x13b/0x500 fs/open.c:1310
 do_sys_open fs/open.c:1326 [inline]
 __do_sys_openat fs/open.c:1342 [inline]
 __se_sys_openat fs/open.c:1337 [inline]
 __x64_sys_openat+0x243/0x290 fs/open.c:1337
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 6966:
 kasan_save_stack mm/kasan/common.c:45 [inline]
 kasan_set_track+0x4c/0x70 mm/kasan/common.c:52
 kasan_save_free_info+0x27/0x40 mm/kasan/generic.c:518
 ____kasan_slab_free+0xd6/0x120 mm/kasan/common.c:236
 kasan_slab_free include/linux/kasan.h:177 [inline]
 slab_free_hook mm/slub.c:1781 [inline]
 slab_free_freelist_hook+0x12e/0x1a0 mm/slub.c:1807
 slab_free mm/slub.c:3787 [inline]
 __kmem_cache_free+0x71/0x110 mm/slub.c:3800
 local_release net/nfc/llcp_core.c:173 [inline]
 kref_put include/linux/kref.h:65 [inline]
 nfc_llcp_local_put+0x209/0x230 net/nfc/llcp_core.c:181
 nfc_unregister_device+0x18a/0x290 net/nfc/core.c:1179
 virtual_ncidev_close+0x55/0x90 drivers/nfc/virtual_ncidev.c:163
 __fput+0x3ba/0x880 fs/file_table.c:320
 task_work_run+0x243/0x300 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop+0x134/0x160 kernel/entry/common.c:171
 exit_to_user_mode_prepare+0xad/0x110 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x2e/0x60 kernel/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff88802ca38000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 0 bytes inside of
 2048-byte region [ffff88802ca38000, ffff88802ca38800)

The buggy address belongs to the physical page:
page:ffffea0000b28e00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2ca38
head:ffffea0000b28e00 order:3 compound_mapcount:0 subpages_mapcount:0 compound_pincount:0
anon flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffff888012842000 0000000000000000 dead000000000001
raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 26, tgid 26 (kworker/1:1), ts 13630378390, free_ts 0
 prep_new_page mm/page_alloc.c:2531 [inline]
 get_page_from_freelist+0x72b/0x7a0 mm/page_alloc.c:4283
 __alloc_pages+0x259/0x560 mm/page_alloc.c:5549
 alloc_slab_page+0xbd/0x190 mm/slub.c:1851
 allocate_slab+0x5e/0x3c0 mm/slub.c:1998
 new_slab mm/slub.c:2051 [inline]
 ___slab_alloc+0x7f4/0xeb0 mm/slub.c:3193
 __slab_alloc mm/slub.c:3292 [inline]
 __slab_alloc_node mm/slub.c:3345 [inline]
 slab_alloc_node mm/slub.c:3442 [inline]
 __kmem_cache_alloc_node+0x25b/0x340 mm/slub.c:3491
 kmalloc_trace+0x26/0x60 mm/slab_common.c:1062
 kmalloc include/linux/slab.h:580 [inline]
 kzalloc include/linux/slab.h:720 [inline]
 fw_create_instance+0x59/0x180 drivers/base/firmware_loader/sysfs.c:402
 fw_load_from_user_helper+0xcb/0x1f0 drivers/base/firmware_loader/fallback.c:151
 _request_firmware+0x44b/0x6a0 drivers/base/firmware_loader/main.c:856
 request_firmware_work_func+0x125/0x270 drivers/base/firmware_loader/main.c:1105
 process_one_work+0x81c/0xd10 kernel/workqueue.c:2289
 worker_thread+0xb14/0x1330 kernel/workqueue.c:2436
 kthread+0x266/0x300 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
page_owner free stack trace missing

Memory state around the buggy address:
 ffff88802ca37f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88802ca37f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88802ca38000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88802ca38080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88802ca38100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

