Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA981316AB4
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 17:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbhBJQGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 11:06:06 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:43236 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbhBJQF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 11:05:58 -0500
Received: by mail-il1-f197.google.com with SMTP id b4so2862990ilj.10
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 08:05:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=SeMnrx8u2Er1+j2xRdaXYwb30WK+Viy2uB6pLm6nCnc=;
        b=jjlu4PtuVb69Xqcx4uuBblXgFLMUmSxLws4ezwErz111DCI59izyGb+ovQwx5qYksv
         23nW2slVXYdKh/ue7Q3qFNzMQrb4GTXfm4JV8OCRrlkP0FtX10GX4igm2H+cPjbDFx4t
         bvhJUZj8RTAR3x27lTiSspQRTZq9xii6qPi2yQvmWbTYulDSs7q5KkYBUHtZQRJOPs5t
         QoqaWNFBU2Rovmm5ghxJONg7jQpK1hGtD3kl7626ZhoA4GYVbJASmHrHDXYQa9VLfAMb
         luJqn516umxc0nREOfK8n67cNBfB1mJSYw3V74F+nbEKpt+BHjnDwPti++vbmVUVGKkV
         0FUg==
X-Gm-Message-State: AOAM532S/ehwWR/8DlxwTc730y0xrIUYeED8q/YFYHK/DvvLmi5hrHHk
        DetgXDEZKhB2iaEHDLarjkhFJaA3WhVzsoysHk6AJf6esFjg
X-Google-Smtp-Source: ABdhPJwZWHxhwUVK0sL3usQDRUJC4b3ogHJG+SFp98HT1k+7Vo7cqdMZV0miDXIix/7wMPSMQVyH1hs/Ox5eZVGTasqpsgK1NeOO
MIME-Version: 1.0
X-Received: by 2002:a92:d30d:: with SMTP id x13mr1672388ila.217.1612973116341;
 Wed, 10 Feb 2021 08:05:16 -0800 (PST)
Date:   Wed, 10 Feb 2021 08:05:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a1c5d705bafd914f@google.com>
Subject: KASAN: invalid-free in ieee80211_ibss_leave
From:   syzbot <syzbot+93976391bf299d425f44@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b75dba7f Merge tag 'libnvdimm-fixes-5.11-rc7' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1570c95f500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e83e68d0a6aba5f6
dashboard link: https://syzkaller.appspot.com/bug?extid=93976391bf299d425f44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=136f4d08d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1278c7fcd00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+93976391bf299d425f44@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: double-free or invalid-free in ieee80211_ibss_leave+0x83/0xe0 net/mac80211/ibss.c:1876

CPU: 0 PID: 8472 Comm: syz-executor100 Not tainted 5.11.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2c6 mm/kasan/report.c:230
 kasan_report_invalid_free+0x51/0x80 mm/kasan/report.c:355
 ____kasan_slab_free+0xcc/0xe0 mm/kasan/common.c:341
 kasan_slab_free include/linux/kasan.h:192 [inline]
 __cache_free mm/slab.c:3424 [inline]
 kfree+0xed/0x270 mm/slab.c:3760
 ieee80211_ibss_leave+0x83/0xe0 net/mac80211/ibss.c:1876
 rdev_leave_ibss net/wireless/rdev-ops.h:545 [inline]
 __cfg80211_leave_ibss+0x19a/0x4c0 net/wireless/ibss.c:212
 __cfg80211_leave+0x327/0x430 net/wireless/core.c:1172
 cfg80211_leave net/wireless/core.c:1221 [inline]
 cfg80211_netdev_notifier_call+0x9e8/0x12c0 net/wireless/core.c:1335
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2040
 call_netdevice_notifiers_extack net/core/dev.c:2052 [inline]
 call_netdevice_notifiers net/core/dev.c:2066 [inline]
 __dev_close_many+0xee/0x2e0 net/core/dev.c:1586
 __dev_close net/core/dev.c:1624 [inline]
 __dev_change_flags+0x2cb/0x730 net/core/dev.c:8476
 dev_change_flags+0x8a/0x160 net/core/dev.c:8549
 dev_ifsioc+0x210/0xa70 net/core/dev_ioctl.c:265
 dev_ioctl+0x1b1/0xc40 net/core/dev_ioctl.c:511
 sock_do_ioctl+0x148/0x2d0 net/socket.c:1060
 sock_ioctl+0x477/0x6a0 net/socket.c:1177
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x446c99
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa8353b02f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000004cb440 RCX: 0000000000446c99
RDX: 00000000200008c0 RSI: 0000000000008914 RDI: 0000000000000005
RBP: 00000000004cb44c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000049b07c
R13: 0031313230386c6e R14: 0ba62cdd87f75d44 R15: 00000000004cb448

Allocated by task 8465:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:401 [inline]
 ____kasan_kmalloc.constprop.0+0x7f/0xa0 mm/kasan/common.c:429
 kasan_kmalloc include/linux/kasan.h:219 [inline]
 __do_kmalloc mm/slab.c:3659 [inline]
 __kmalloc_track_caller+0x20a/0x440 mm/slab.c:3674
 kmemdup+0x23/0x50 mm/util.c:128
 kmemdup include/linux/string.h:520 [inline]
 ieee80211_ibss_join+0x8cf/0xfe0 net/mac80211/ibss.c:1824
 rdev_join_ibss net/wireless/rdev-ops.h:535 [inline]
 __cfg80211_join_ibss+0x807/0x1200 net/wireless/ibss.c:144
 nl80211_join_ibss+0xcbb/0x12b0 net/wireless/nl80211.c:10229
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2345
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2432
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 8473:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:356
 ____kasan_slab_free+0xb0/0xe0 mm/kasan/common.c:362
 kasan_slab_free include/linux/kasan.h:192 [inline]
 __cache_free mm/slab.c:3424 [inline]
 kfree+0xed/0x270 mm/slab.c:3760
 ieee80211_ibss_leave+0x83/0xe0 net/mac80211/ibss.c:1876
 rdev_leave_ibss net/wireless/rdev-ops.h:545 [inline]
 __cfg80211_leave_ibss+0x19a/0x4c0 net/wireless/ibss.c:212
 __cfg80211_leave+0x327/0x430 net/wireless/core.c:1172
 cfg80211_leave net/wireless/core.c:1221 [inline]
 cfg80211_netdev_notifier_call+0x9e8/0x12c0 net/wireless/core.c:1335
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2040
 call_netdevice_notifiers_extack net/core/dev.c:2052 [inline]
 call_netdevice_notifiers net/core/dev.c:2066 [inline]
 __dev_close_many+0xee/0x2e0 net/core/dev.c:1586
 __dev_close net/core/dev.c:1624 [inline]
 __dev_change_flags+0x2cb/0x730 net/core/dev.c:8476
 dev_change_flags+0x8a/0x160 net/core/dev.c:8549
 dev_ifsioc+0x210/0xa70 net/core/dev_ioctl.c:265
 dev_ioctl+0x1b1/0xc40 net/core/dev_ioctl.c:511
 sock_do_ioctl+0x148/0x2d0 net/socket.c:1060
 sock_ioctl+0x477/0x6a0 net/socket.c:1177
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0x87/0xb0 mm/kasan/generic.c:344
 insert_work+0x48/0x370 kernel/workqueue.c:1331
 __queue_work+0x5c1/0xf00 kernel/workqueue.c:1497
 queue_work_on+0xc7/0xd0 kernel/workqueue.c:1524
 queue_work include/linux/workqueue.h:507 [inline]
 call_usermodehelper_exec+0x1f0/0x4c0 kernel/umh.c:433
 kobject_uevent_env+0xf9f/0x1680 lib/kobject_uevent.c:617
 kobject_synth_uevent+0x701/0x850 lib/kobject_uevent.c:208
 uevent_store+0x20/0x50 drivers/base/core.c:2160
 dev_attr_store+0x50/0x80 drivers/base/core.c:1861
 sysfs_kf_write+0x110/0x160 fs/sysfs/file.c:139
 kernfs_fop_write_iter+0x342/0x500 fs/kernfs/file.c:296
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write+0x426/0x650 fs/read_write.c:518
 vfs_write+0x791/0xa30 fs/read_write.c:605
 ksys_write+0x12d/0x250 fs/read_write.c:658
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Second to last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0x87/0xb0 mm/kasan/generic.c:344
 insert_work+0x48/0x370 kernel/workqueue.c:1331
 __queue_work+0x5c1/0xf00 kernel/workqueue.c:1497
 queue_work_on+0xc7/0xd0 kernel/workqueue.c:1524
 queue_work include/linux/workqueue.h:507 [inline]
 call_usermodehelper_exec+0x1f0/0x4c0 kernel/umh.c:433
 kobject_uevent_env+0xf9f/0x1680 lib/kobject_uevent.c:617
 kobject_synth_uevent+0x701/0x850 lib/kobject_uevent.c:208
 uevent_store+0x20/0x50 drivers/base/core.c:2160
 dev_attr_store+0x50/0x80 drivers/base/core.c:1861
 sysfs_kf_write+0x110/0x160 fs/sysfs/file.c:139
 kernfs_fop_write_iter+0x342/0x500 fs/kernfs/file.c:296
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write+0x426/0x650 fs/read_write.c:518
 vfs_write+0x791/0xa30 fs/read_write.c:605
 ksys_write+0x12d/0x250 fs/read_write.c:658
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff88801c155f00
 which belongs to the cache kmalloc-192 of size 192
The buggy address is located 0 bytes inside of
 192-byte region [ffff88801c155f00, ffff88801c155fc0)
The buggy address belongs to the page:
page:000000001221e238 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88801c155900 pfn:0x1c155
flags: 0xfff00000000200(slab)
raw: 00fff00000000200 ffffea0000928b48 ffffea00006de508 ffff888010c40000
raw: ffff88801c155900 ffff88801c155000 000000010000000d 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88801c155e00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88801c155e80: 00 00 00 fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88801c155f00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88801c155f80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff88801c156000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
