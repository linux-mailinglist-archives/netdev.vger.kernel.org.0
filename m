Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7AA65995A
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 15:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234988AbiL3Odj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 09:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiL3Odi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 09:33:38 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8052140DF
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 06:33:36 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id z19-20020a921a53000000b0030b90211df1so13302705ill.2
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 06:33:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LnEs1TL27OPQdvVbOp23jIied9lfmHTrZ8ctaahhx1k=;
        b=RNuB7RkEq3t7P6UCtky/BVZnhStlANLfLna7XXxt7PomhONHY829DvHGjnEEgzZdRK
         5zOT0FbSL2h3MdrYxRMXtGH5Wax4r/4qJ3xLJXYofb1XeLwFysvpP6sH2G85hIjn1ksI
         opu8DdrP2LSzeAhu98iBWmacA5kGS5lt1chrYJYj7WmNly/jCg4BHpwYBKinmrKd/VWc
         OpoK+qU53f1RxI9dxJ3LiuDdyl+YqRwYrMsfp4JmX/HE4VOH62sezVe6tXgyuRLiVr1X
         7z113yrcSar0v4Hjov1vf6nDYfPC/wOgxwaKq9rr7ppS4S2VQTCIWo6P9la//ya7JA8I
         HcPw==
X-Gm-Message-State: AFqh2koOZ4vcadDzqQejoc1vJmAagDHzQ5FyVet/mQLCGK3SZRivqS/K
        KpPBS607BiYmYMua/RBF4/KbL14FYO8XrwVeSD6qA7XFwnHx
X-Google-Smtp-Source: AMrXdXvfLz8Yhbf0r0mDClEm+RYGdBUp03tMuWPzCu1J2ky8Q8fXFGKUWjXaSeq5WfxPp15YapmBCUJ/X61NiQjOuHixQ7vkmWOE
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:532:b0:302:ce48:40ee with SMTP id
 h18-20020a056e02053200b00302ce4840eemr1804883ils.157.1672410816080; Fri, 30
 Dec 2022 06:33:36 -0800 (PST)
Date:   Fri, 30 Dec 2022 06:33:36 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009c74e505f10c7c6c@google.com>
Subject: [syzbot] BUG: corrupted list in nfc_llcp_local_put
From:   syzbot <syzbot+ecb2ae7b1add2a4120de@syzkaller.appspotmail.com>
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

Hello,

syzbot found the following issue on:

HEAD commit:    1b929c02afd3 Linux 6.2-rc1
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1798d8ff880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=68e0be42c8ee4bb4
dashboard link: https://syzkaller.appspot.com/bug?extid=ecb2ae7b1add2a4120de
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14dcc04c480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2d8c5072480f/disk-1b929c02.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/46687f1395db/vmlinux-1b929c02.xz
kernel image: https://storage.googleapis.com/syzbot-assets/26f1afa5ec00/bzImage-1b929c02.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ecb2ae7b1add2a4120de@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __list_del_entry_valid+0xa6/0x130 lib/list_debug.c:62
Read of size 8 at addr ffff88807b0cf008 by task syz-executor.3/20702

CPU: 1 PID: 20702 Comm: syz-executor.3 Not tainted 6.2.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1b1/0x290 lib/dump_stack.c:106
 print_address_description+0x74/0x340 mm/kasan/report.c:306
 print_report+0x107/0x1f0 mm/kasan/report.c:417
 kasan_report+0xcd/0x100 mm/kasan/report.c:517
 __list_del_entry_valid+0xa6/0x130 lib/list_debug.c:62
 __list_del_entry include/linux/list.h:134 [inline]
 list_del include/linux/list.h:148 [inline]
 local_release net/nfc/llcp_core.c:171 [inline]
 kref_put include/linux/kref.h:65 [inline]
 nfc_llcp_local_put+0x63/0x230 net/nfc/llcp_core.c:181
 nfc_unregister_device+0x18a/0x290 net/nfc/core.c:1179
 virtual_ncidev_close+0x55/0x90 drivers/nfc/virtual_ncidev.c:163
 __fput+0x3ba/0x880 fs/file_table.c:320
 task_work_run+0x243/0x300 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop+0x124/0x150 kernel/entry/common.c:171
 exit_to_user_mode_prepare+0xb2/0x140 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x26/0x60 kernel/entry/common.c:296
 do_syscall_64+0x49/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f0f5343df5b
Code: 0f 05 48 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8 63 fc ff ff 8b 7c 24 0c 41 89 c0 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 89 44 24 0c e8 a1 fc ff ff 8b 44
RSP: 002b:00007ffc1c71db30 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00007f0f5343df5b
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000003
RBP: 00007f0f535ad980 R08: 0000000000000000 R09: 00007f0f530000b8
R10: 0000000000000000 R11: 0000000000000293 R12: 000000000011f70c
R13: 00007ffc1c71dc30 R14: 00007f0f535ac050 R15: 0000000000000032
 </TASK>

Allocated by task 20699:
 kasan_save_stack mm/kasan/common.c:45 [inline]
 kasan_set_track+0x3d/0x60 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:371 [inline]
 __kasan_kmalloc+0x97/0xb0 mm/kasan/common.c:380
 kmalloc include/linux/slab.h:580 [inline]
 kzalloc include/linux/slab.h:720 [inline]
 nfc_llcp_register_device+0x51/0x800 net/nfc/llcp_core.c:1566
 nfc_register_device+0x68/0x320 net/nfc/core.c:1124
 nci_register_device+0x7b5/0x8f0 net/nfc/nci/core.c:1257
 virtual_ncidev_open+0x138/0x1b0 drivers/nfc/virtual_ncidev.c:148
 misc_open+0x346/0x3c0 drivers/char/misc.c:165
 chrdev_open+0x53b/0x5f0 fs/char_dev.c:414
 do_dentry_open+0x85f/0x11b0 fs/open.c:882
 do_open fs/namei.c:3557 [inline]
 path_openat+0x25ba/0x2dd0 fs/namei.c:3714
 do_filp_open+0x264/0x4f0 fs/namei.c:3741
 do_sys_openat2+0x124/0x4e0 fs/open.c:1310
 do_sys_open fs/open.c:1326 [inline]
 __do_sys_openat fs/open.c:1342 [inline]
 __se_sys_openat fs/open.c:1337 [inline]
 __x64_sys_openat+0x243/0x290 fs/open.c:1337
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 20698:
 kasan_save_stack mm/kasan/common.c:45 [inline]
 kasan_set_track+0x3d/0x60 mm/kasan/common.c:52
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
 exit_to_user_mode_loop+0x124/0x150 kernel/entry/common.c:171
 exit_to_user_mode_prepare+0xb2/0x140 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x26/0x60 kernel/entry/common.c:296
 do_syscall_64+0x49/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Last potentially related work creation:
 kasan_save_stack+0x2b/0x50 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xb0/0xc0 mm/kasan/generic.c:488
 insert_work+0x54/0x3e0 kernel/workqueue.c:1358
 __queue_work+0xaaa/0xd60 kernel/workqueue.c:1517
 queue_work_on+0x11b/0x200 kernel/workqueue.c:1545
 queue_work include/linux/workqueue.h:503 [inline]
 schedule_work include/linux/workqueue.h:564 [inline]
 rfkill_register+0x723/0x880 net/rfkill/core.c:1090
 nfc_register_device+0x13f/0x320 net/nfc/core.c:1132
 nci_register_device+0x7b5/0x8f0 net/nfc/nci/core.c:1257
 virtual_ncidev_open+0x138/0x1b0 drivers/nfc/virtual_ncidev.c:148
 misc_open+0x346/0x3c0 drivers/char/misc.c:165
 chrdev_open+0x53b/0x5f0 fs/char_dev.c:414
 do_dentry_open+0x85f/0x11b0 fs/open.c:882
 do_open fs/namei.c:3557 [inline]
 path_openat+0x25ba/0x2dd0 fs/namei.c:3714
 do_filp_open+0x264/0x4f0 fs/namei.c:3741
 do_sys_openat2+0x124/0x4e0 fs/open.c:1310
 do_sys_open fs/open.c:1326 [inline]
 __do_sys_openat fs/open.c:1342 [inline]
 __se_sys_openat fs/open.c:1337 [inline]
 __x64_sys_openat+0x243/0x290 fs/open.c:1337
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff88807b0cf000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 8 bytes inside of
 2048-byte region [ffff88807b0cf000, ffff88807b0cf800)

The buggy address belongs to the physical page:
page:ffffea0001ec3200 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7b0c8
head:ffffea0001ec3200 order:3 compound_mapcount:0 subpages_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffff888012842000 dead000000000100 dead000000000122
raw: 0000000000000000 0000000080080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2a20(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5154, tgid 5154 (syz-executor.1), ts 1066603778215, free_ts 1066516954258
 prep_new_page mm/page_alloc.c:2531 [inline]
 get_page_from_freelist+0x742/0x7c0 mm/page_alloc.c:4283
 __alloc_pages+0x259/0x560 mm/page_alloc.c:5549
 alloc_slab_page+0xbd/0x190 mm/slub.c:1851
 allocate_slab+0x5e/0x3c0 mm/slub.c:1998
 new_slab mm/slub.c:2051 [inline]
 ___slab_alloc+0x782/0xe20 mm/slub.c:3193
 __slab_alloc mm/slub.c:3292 [inline]
 __slab_alloc_node mm/slub.c:3345 [inline]
 slab_alloc_node mm/slub.c:3442 [inline]
 __kmem_cache_alloc_node+0x25b/0x340 mm/slub.c:3491
 __do_kmalloc_node mm/slab_common.c:967 [inline]
 __kmalloc_node_track_caller+0x9c/0x190 mm/slab_common.c:988
 kmalloc_reserve net/core/skbuff.c:492 [inline]
 pskb_expand_head+0x18a/0x1210 net/core/skbuff.c:1899
 netlink_trim+0x17f/0x210 net/netlink/af_netlink.c:1312
 netlink_broadcast+0x64/0x1170 net/netlink/af_netlink.c:1508
 nlmsg_multicast include/net/netlink.h:1082 [inline]
 nlmsg_notify+0xfa/0x1c0 net/netlink/af_netlink.c:2607
 __dev_notify_flags+0xf9/0x5e0 net/core/dev.c:8565
 dev_change_flags+0xe8/0x190 net/core/dev.c:8607
 do_setlink+0xef5/0x3d40 net/core/rtnetlink.c:2827
 __rtnl_newlink net/core/rtnetlink.c:3590 [inline]
 rtnl_newlink+0x1780/0x2020 net/core/rtnetlink.c:3637
 rtnetlink_rcv_msg+0x822/0xf10 net/core/rtnetlink.c:6141
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1446 [inline]
 free_pcp_prepare+0x751/0x780 mm/page_alloc.c:1496
 free_unref_page_prepare mm/page_alloc.c:3369 [inline]
 free_unref_page+0x19/0x4c0 mm/page_alloc.c:3464
 qlist_free_all+0x2b/0x70 mm/kasan/quarantine.c:187
 kasan_quarantine_reduce+0x156/0x170 mm/kasan/quarantine.c:294
 __kasan_slab_alloc+0x1f/0x70 mm/kasan/common.c:302
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slab.h:761 [inline]
 slab_alloc_node mm/slub.c:3452 [inline]
 __kmem_cache_alloc_node+0x1e0/0x340 mm/slub.c:3491
 kmalloc_trace+0x26/0x60 mm/slab_common.c:1062
 kmalloc include/linux/slab.h:580 [inline]
 kzalloc include/linux/slab.h:720 [inline]
 nsim_fib4_rt_create drivers/net/netdevsim/fib.c:280 [inline]
 nsim_fib4_rt_insert drivers/net/netdevsim/fib.c:426 [inline]
 nsim_fib4_event drivers/net/netdevsim/fib.c:464 [inline]
 nsim_fib_event drivers/net/netdevsim/fib.c:884 [inline]
 nsim_fib_event_work+0x10d5/0x57c0 drivers/net/netdevsim/fib.c:1492
 process_one_work+0x877/0xdb0 kernel/workqueue.c:2289
 process_scheduled_works kernel/workqueue.c:2352 [inline]
 worker_thread+0xe16/0x1330 kernel/workqueue.c:2438
 kthread+0x266/0x300 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

Memory state around the buggy address:
 ffff88807b0cef00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88807b0cef80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88807b0cf000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff88807b0cf080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807b0cf100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
