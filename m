Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F1265513D
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 15:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236382AbiLWOQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 09:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236377AbiLWOQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 09:16:47 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5860A389FD
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 06:16:45 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id c11-20020a056e020bcb00b0030be9d07d63so1007160ilu.0
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 06:16:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0ckFOFX+kFxvZtVr6GXcBwjL/m8NryAfaPpIEBZkElM=;
        b=FWJg/aKZQaCfsYqQ+m0SByqQaLRd4q7dmF2saQ6URIJPrWQGTMHTt5ANJAJ5npAiLX
         VLtJ4FWoBQxwKO/2psT6qlMXjF5wac0zeCVTiSatKuxRfHvF5E0LzvySDEBzsPwW83Dk
         Fn0T76+dUSGTl3lC+91X6a8FSJf+wCTqu9B1nVRL6Y2T/OFF/adH0YidcRBeVrijjbNM
         kFKSYM9hmxMM/F2/3OwhA6JjN4L53ci6R8EXtSeTSpEPFzNOv1hf5U0rH1Q5Fd7wZuld
         KHLNWpgvn6oR4TrXErOuwyDt/BSD/8//+PuELXMjsOqGSDtzcrNAk+XAExwnPSQQ6j73
         fXag==
X-Gm-Message-State: AFqh2kqJjIZPb8JN1HHm2WFzGPHs2J98HgIyJW5Ws/jtzJRKJ+dyFHa+
        h9nDUVKXvZFkbABWwSA/fxZDKeC/N6Gdghml1k3tbruxc2F2
X-Google-Smtp-Source: AMrXdXvPrzLKYe9DKpxrtdj0xNOTSGms0WkO93wellZglONj4QGz3trpp04rDNc4IQICBk74TpaitxpvsmcYoohb8HHzUZz9vdet
MIME-Version: 1.0
X-Received: by 2002:a6b:b297:0:b0:6eb:d90:3caa with SMTP id
 b145-20020a6bb297000000b006eb0d903caamr718432iof.111.1671805004649; Fri, 23
 Dec 2022 06:16:44 -0800 (PST)
Date:   Fri, 23 Dec 2022 06:16:44 -0800
In-Reply-To: <00000000000055eb2f05eead3f2c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006f9a3905f07f6fc5@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in nfc_llcp_find_local
From:   syzbot <syzbot+e7ac69e6a5d806180b40@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dvyukov@google.com, edumazet@google.com,
        krzysztof.kozlowski@linaro.org, kuba@kernel.org, linma@zju.edu.cn,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
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

HEAD commit:    8395ae05cb5a Merge tag 'scsi-misc' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10cde6df880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=85327a149d5f50f
dashboard link: https://syzkaller.appspot.com/bug?extid=e7ac69e6a5d806180b40
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e01f64480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f373fc37f71c/disk-8395ae05.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6c99ebdbc565/vmlinux-8395ae05.xz
kernel image: https://storage.googleapis.com/syzbot-assets/729b050376f0/bzImage-8395ae05.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e7ac69e6a5d806180b40@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in nfc_llcp_find_local+0xc5/0xe0 net/nfc/llcp_core.c:286
Read of size 8 at addr ffff8880208b0010 by task syz-executor.4/3877

CPU: 1 PID: 3877 Comm: syz-executor.4 Not tainted 6.1.0-syzkaller-14446-g8395ae05cb5a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:306 [inline]
 print_report+0x15e/0x45d mm/kasan/report.c:417
 kasan_report+0xbf/0x1f0 mm/kasan/report.c:517
 nfc_llcp_find_local+0xc5/0xe0 net/nfc/llcp_core.c:286
 nfc_llcp_unregister_device+0x1a/0x260 net/nfc/llcp_core.c:1610
 nfc_unregister_device+0x196/0x330 net/nfc/core.c:1179
 virtual_ncidev_close+0x52/0xb0 drivers/nfc/virtual_ncidev.c:163
 __fput+0x27c/0xa90 fs/file_table.c:320
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fd09943df5b
Code: 0f 05 48 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8 63 fc ff ff 8b 7c 24 0c 41 89 c0 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 89 44 24 0c e8 a1 fc ff ff 8b 44
RSP: 002b:00007fd0996cfb80 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00007fd09943df5b
RDX: 00007fd099001c60 RSI: ffffffffffffffff RDI: 0000000000000003
RBP: 00007fd0995ad980 R08: 0000000000000000 R09: 00007fd099000000
R10: 00007fd099001c68 R11: 0000000000000293 R12: 00000000001bc27e
R13: 00007fd0996cfc80 R14: 00007fd0995abf80 R15: 0000000000000032
 </TASK>

Allocated by task 3890:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:371 [inline]
 ____kasan_kmalloc mm/kasan/common.c:330 [inline]
 __kasan_kmalloc+0xa5/0xb0 mm/kasan/common.c:380
 kmalloc include/linux/slab.h:580 [inline]
 kzalloc include/linux/slab.h:720 [inline]
 nfc_llcp_register_device+0x49/0x9e0 net/nfc/llcp_core.c:1566
 nfc_register_device+0x70/0x3b0 net/nfc/core.c:1124
 nci_register_device+0x7cb/0xb50 net/nfc/nci/core.c:1257
 virtual_ncidev_open+0x14f/0x230 drivers/nfc/virtual_ncidev.c:148
 misc_open+0x37a/0x4a0 drivers/char/misc.c:165
 chrdev_open+0x26a/0x770 fs/char_dev.c:414
 do_dentry_open+0x6cc/0x13f0 fs/open.c:882
 do_open fs/namei.c:3557 [inline]
 path_openat+0x1bbc/0x2a50 fs/namei.c:3714
 do_filp_open+0x1ba/0x410 fs/namei.c:3741
 do_sys_openat2+0x16d/0x4c0 fs/open.c:1310
 do_sys_open fs/open.c:1326 [inline]
 __do_sys_openat fs/open.c:1342 [inline]
 __se_sys_openat fs/open.c:1337 [inline]
 __x64_sys_openat+0x143/0x1f0 fs/open.c:1337
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 3888:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:518
 ____kasan_slab_free mm/kasan/common.c:236 [inline]
 ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
 kasan_slab_free include/linux/kasan.h:177 [inline]
 slab_free_hook mm/slub.c:1781 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1807
 slab_free mm/slub.c:3787 [inline]
 __kmem_cache_free+0xaf/0x3b0 mm/slub.c:3800
 local_release net/nfc/llcp_core.c:173 [inline]
 kref_put include/linux/kref.h:65 [inline]
 nfc_llcp_local_put net/nfc/llcp_core.c:181 [inline]
 nfc_llcp_local_put net/nfc/llcp_core.c:176 [inline]
 nfc_llcp_unregister_device+0x1ba/0x260 net/nfc/llcp_core.c:1619
 nfc_unregister_device+0x196/0x330 net/nfc/core.c:1179
 virtual_ncidev_close+0x52/0xb0 drivers/nfc/virtual_ncidev.c:163
 __fput+0x27c/0xa90 fs/file_table.c:320
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:488
 insert_work+0x48/0x350 kernel/workqueue.c:1358
 __queue_work+0x693/0x13b0 kernel/workqueue.c:1517
 queue_work_on+0xf2/0x110 kernel/workqueue.c:1545
 queue_work include/linux/workqueue.h:503 [inline]
 schedule_work include/linux/workqueue.h:564 [inline]
 rfkill_register+0x67c/0xb00 net/rfkill/core.c:1090
 nfc_register_device+0x124/0x3b0 net/nfc/core.c:1132
 nci_register_device+0x7cb/0xb50 net/nfc/nci/core.c:1257
 virtual_ncidev_open+0x14f/0x230 drivers/nfc/virtual_ncidev.c:148
 misc_open+0x37a/0x4a0 drivers/char/misc.c:165
 chrdev_open+0x26a/0x770 fs/char_dev.c:414
 do_dentry_open+0x6cc/0x13f0 fs/open.c:882
 do_open fs/namei.c:3557 [inline]
 path_openat+0x1bbc/0x2a50 fs/namei.c:3714
 do_filp_open+0x1ba/0x410 fs/namei.c:3741
 do_sys_openat2+0x16d/0x4c0 fs/open.c:1310
 do_sys_open fs/open.c:1326 [inline]
 __do_sys_openat fs/open.c:1342 [inline]
 __se_sys_openat fs/open.c:1337 [inline]
 __x64_sys_openat+0x143/0x1f0 fs/open.c:1337
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Second to last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:488
 insert_work+0x48/0x350 kernel/workqueue.c:1358
 __queue_work+0x693/0x13b0 kernel/workqueue.c:1517
 queue_work_on+0xf2/0x110 kernel/workqueue.c:1545
 queue_work include/linux/workqueue.h:503 [inline]
 schedule_work include/linux/workqueue.h:564 [inline]
 rfkill_register+0x67c/0xb00 net/rfkill/core.c:1090
 nfc_register_device+0x124/0x3b0 net/nfc/core.c:1132
 nci_register_device+0x7cb/0xb50 net/nfc/nci/core.c:1257
 virtual_ncidev_open+0x14f/0x230 drivers/nfc/virtual_ncidev.c:148
 misc_open+0x37a/0x4a0 drivers/char/misc.c:165
 chrdev_open+0x26a/0x770 fs/char_dev.c:414
 do_dentry_open+0x6cc/0x13f0 fs/open.c:882
 do_open fs/namei.c:3557 [inline]
 path_openat+0x1bbc/0x2a50 fs/namei.c:3714
 do_filp_open+0x1ba/0x410 fs/namei.c:3741
 do_sys_openat2+0x16d/0x4c0 fs/open.c:1310
 do_sys_open fs/open.c:1326 [inline]
 __do_sys_openat fs/open.c:1342 [inline]
 __se_sys_openat fs/open.c:1337 [inline]
 __x64_sys_openat+0x143/0x1f0 fs/open.c:1337
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff8880208b0000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 16 bytes inside of
 2048-byte region [ffff8880208b0000, ffff8880208b0800)

The buggy address belongs to the physical page:
page:ffffea0000822c00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x208b0
head:ffffea0000822c00 order:3 compound_mapcount:0 subpages_mapcount:0 compound_pincount:0
anon flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffff888012442000 0000000000000000 dead000000000001
raw: 0000000000000000 0000000080080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x1d20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 5194, tgid 5194 (syz-executor.2), ts 1617275289730, free_ts 1617247416997
 prep_new_page mm/page_alloc.c:2531 [inline]
 get_page_from_freelist+0x119c/0x2ce0 mm/page_alloc.c:4283
 __alloc_pages+0x1cb/0x5b0 mm/page_alloc.c:5549
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2285
 alloc_slab_page mm/slub.c:1851 [inline]
 allocate_slab+0x25f/0x350 mm/slub.c:1998
 new_slab mm/slub.c:2051 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3193
 __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3292
 __slab_alloc_node mm/slub.c:3345 [inline]
 slab_alloc_node mm/slub.c:3442 [inline]
 __kmem_cache_alloc_node+0x1a4/0x430 mm/slub.c:3491
 __do_kmalloc_node mm/slab_common.c:967 [inline]
 __kmalloc+0x4a/0xd0 mm/slab_common.c:981
 kmalloc include/linux/slab.h:584 [inline]
 kzalloc include/linux/slab.h:720 [inline]
 ip6t_alloc_initial_table+0x6a/0x6f0 net/ipv6/netfilter/ip6_tables.c:42
 ip6table_mangle_table_init+0x1b/0x60 net/ipv6/netfilter/ip6table_mangle.c:81
 xt_find_table_lock+0x3a2/0x680 net/netfilter/x_tables.c:1259
 xt_request_find_table_lock+0x2b/0x100 net/netfilter/x_tables.c:1284
 get_info+0x16a/0x730 net/ipv4/netfilter/ip_tables.c:965
 do_ip6t_get_ctl+0x156/0xa10 net/ipv6/netfilter/ip6_tables.c:1663
 nf_getsockopt+0x76/0xd0 net/netfilter/nf_sockopt.c:116
 ipv6_getsockopt+0x1ef/0x2a0 net/ipv6/ipv6_sockglue.c:1511
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1446 [inline]
 free_pcp_prepare+0x65c/0xc00 mm/page_alloc.c:1496
 free_unref_page_prepare mm/page_alloc.c:3369 [inline]
 free_unref_page+0x1d/0x490 mm/page_alloc.c:3464
 __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2637
 qlink_free mm/kasan/quarantine.c:168 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
 kasan_quarantine_reduce+0x192/0x220 mm/kasan/quarantine.c:294
 __kasan_slab_alloc+0x66/0x90 mm/kasan/common.c:302
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slab.h:761 [inline]
 slab_alloc_node mm/slub.c:3452 [inline]
 slab_alloc mm/slub.c:3460 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3467 [inline]
 kmem_cache_alloc+0x1e4/0x430 mm/slub.c:3476
 getname_flags.part.0+0x50/0x4f0 fs/namei.c:139
 getname_flags include/linux/audit.h:320 [inline]
 getname+0x92/0xd0 fs/namei.c:218
 do_sys_openat2+0xf5/0x4c0 fs/open.c:1304
 do_sys_open fs/open.c:1326 [inline]
 __do_sys_openat fs/open.c:1342 [inline]
 __se_sys_openat fs/open.c:1337 [inline]
 __x64_sys_openat+0x143/0x1f0 fs/open.c:1337
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Memory state around the buggy address:
 ffff8880208aff00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880208aff80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880208b0000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff8880208b0080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880208b0100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

