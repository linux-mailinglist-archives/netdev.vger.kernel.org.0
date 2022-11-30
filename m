Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76FC663D2BE
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 11:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235407AbiK3KFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 05:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234983AbiK3KFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 05:05:46 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F76D3057D
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 02:05:43 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id k11-20020a056e021a8b00b003030ec907c7so8944394ilv.10
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 02:05:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=de2ArgXkoR8qnX+OvhIZ12OIL7QVCDGTxUoulz68rP8=;
        b=KoLBStHXgYVY054H+awsyKq3YHmSUUTTCiW9I+njdWbF1Xs4AKTychyv5SG1T4bFSn
         iIn/o76mHEmVtu3tlHHQuOIjAwzwMzMAs/LSqmszEg5/7TtNfR2ox/+9sLoFWAWEWIdU
         A2A+YPqNbdiE8QHWUclSgMgMGF9dwdl7oCA4qupcc541Z+r/dRf9ENt7AJOPWNQgr4vC
         JLs5bXQPIcBuSx40mq9qf3eIA8A+njqU/WND3DGrWuONKUI9ssZCWd/1Gdh1d/PMjq9K
         BjjUNDaDV9p5kavYN+eubLFLfNaEU0sqVqSVFOwqZODnJFvPA1AbuV54/Lr4uBFx6ti+
         5gjA==
X-Gm-Message-State: ANoB5pkxu5oXwPymA8guTWogQp291QMg56po+kvLtEcsFITcHJNznDt4
        tY+8hLXSiR3abqw0UZHD1E7Vm6QKngV2QMXKwMmbXLs1Cgne
X-Google-Smtp-Source: AA0mqf4i3QwU0ZWplRH0APMOvGdaS55JBygspezK7+igjlCWDyI+NP4WM4XxwrpIlKK6hsppzu/zvPv4ZGTTa13FUoB58wuc2pGM
MIME-Version: 1.0
X-Received: by 2002:a92:cccd:0:b0:302:58d0:2510 with SMTP id
 u13-20020a92cccd000000b0030258d02510mr20748628ilq.27.1669802742899; Wed, 30
 Nov 2022 02:05:42 -0800 (PST)
Date:   Wed, 30 Nov 2022 02:05:42 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000055eb2f05eead3f2c@google.com>
Subject: [syzbot] KASAN: use-after-free Read in nfc_llcp_find_local
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

Hello,

syzbot found the following issue on:

HEAD commit:    9e46a7996732 Add linux-next specific files for 20221125
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=112c4e5b880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=11e19c740a0b2926
dashboard link: https://syzkaller.appspot.com/bug?extid=e7ac69e6a5d806180b40
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/758d818cf966/disk-9e46a799.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f7c8696b40a5/vmlinux-9e46a799.xz
kernel image: https://storage.googleapis.com/syzbot-assets/810f9750b87f/bzImage-9e46a799.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e7ac69e6a5d806180b40@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in nfc_llcp_find_local+0xcf/0xe0 net/nfc/llcp_core.c:285
Read of size 8 at addr ffff8880765d0000 by task syz-executor.1/21762

CPU: 1 PID: 21762 Comm: syz-executor.1 Not tainted 6.1.0-rc6-next-20221125-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:253 [inline]
 print_report+0x15e/0x45d mm/kasan/report.c:364
 kasan_report+0xbf/0x1f0 mm/kasan/report.c:464
 nfc_llcp_find_local+0xcf/0xe0 net/nfc/llcp_core.c:285
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
RIP: 0033:0x7fe7de43df8b
Code: 0f 05 48 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8 63 fc ff ff 8b 7c 24 0c 41 89 c0 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 89 44 24 0c e8 a1 fc ff ff 8b 44
RSP: 002b:00007fff7e5d0830 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00007fe7de43df8b
RDX: 0000000000000000 RSI: 0000001b2f226ef4 RDI: 0000000000000003
RBP: 00007fe7de5ad980 R08: 0000000000000000 R09: 0000000008337a43
R10: 0000000000000000 R11: 0000000000000293 R12: 000000000003c192
R13: 00007fff7e5d0930 R14: 00007fe7de5abf80 R15: 0000000000000032
 </TASK>

Allocated by task 21775:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:376 [inline]
 ____kasan_kmalloc mm/kasan/common.c:335 [inline]
 __kasan_kmalloc+0xa5/0xb0 mm/kasan/common.c:385
 kmalloc include/linux/slab.h:571 [inline]
 kzalloc include/linux/slab.h:711 [inline]
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

Freed by task 21772:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:518
 ____kasan_slab_free mm/kasan/common.c:241 [inline]
 ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:205
 kasan_slab_free include/linux/kasan.h:178 [inline]
 slab_free_hook mm/slub.c:1763 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1789
 slab_free mm/slub.c:3696 [inline]
 __kmem_cache_free+0xaf/0x3b0 mm/slub.c:3709
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

The buggy address belongs to the object at ffff8880765d0000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 0 bytes inside of
 2048-byte region [ffff8880765d0000, ffff8880765d0800)

The buggy address belongs to the physical page:
page:ffffea0001d97400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x765d0
head:ffffea0001d97400 order:3 compound_mapcount:0 subpages_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffff888012442000 ffffea00017cf400 dead000000000002
raw: 0000000000000000 0000000080080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5317, tgid 5317 (syz-executor.3), ts 88511557138, free_ts 88441802170
 prep_new_page mm/page_alloc.c:2541 [inline]
 get_page_from_freelist+0x119c/0x2cd0 mm/page_alloc.c:4293
 __alloc_pages+0x1cb/0x5b0 mm/page_alloc.c:5551
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2285
 alloc_slab_page mm/slub.c:1833 [inline]
 allocate_slab+0x25f/0x350 mm/slub.c:1980
 new_slab mm/slub.c:2033 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3211
 __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3310
 slab_alloc_node mm/slub.c:3395 [inline]
 __kmem_cache_alloc_node+0x1a9/0x430 mm/slub.c:3472
 kmalloc_trace+0x26/0x60 mm/slab_common.c:1049
 kmalloc include/linux/slab.h:571 [inline]
 rtnl_newlink+0x4a/0xa0 net/core/rtnetlink.c:3633
 rtnetlink_rcv_msg+0x43e/0xca0 net/core/rtnetlink.c:6141
 netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2564
 netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1356
 netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1932
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xd3/0x120 net/socket.c:734
 __sys_sendto+0x23a/0x340 net/socket.c:2117
 __do_sys_sendto net/socket.c:2129 [inline]
 __se_sys_sendto net/socket.c:2125 [inline]
 __x64_sys_sendto+0xe1/0x1b0 net/socket.c:2125
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1448 [inline]
 free_pcp_prepare+0x65c/0xc00 mm/page_alloc.c:1498
 free_unref_page_prepare mm/page_alloc.c:3379 [inline]
 free_unref_page+0x1d/0x490 mm/page_alloc.c:3474
 qlink_free mm/kasan/quarantine.c:168 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
 kasan_quarantine_reduce+0x192/0x220 mm/kasan/quarantine.c:294
 __kasan_slab_alloc+0x66/0x90 mm/kasan/common.c:307
 kasan_slab_alloc include/linux/kasan.h:202 [inline]
 slab_post_alloc_hook mm/slab.h:761 [inline]
 slab_alloc_node mm/slub.c:3433 [inline]
 slab_alloc mm/slub.c:3441 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3448 [inline]
 kmem_cache_alloc+0x1e3/0x430 mm/slub.c:3457
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
 ffff8880765cff00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880765cff80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880765d0000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff8880765d0080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880765d0100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
