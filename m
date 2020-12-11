Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE512D7FCE
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 21:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgLKUL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 15:11:58 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:52116 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390751AbgLKULw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 15:11:52 -0500
Received: by mail-il1-f200.google.com with SMTP id 1so4670961ilg.18
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 12:11:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=GVX9/CI9tqNteYCMCXCHoxN97w4Mon0uddpJWLCYX+I=;
        b=gXxa+Lw5fTBBEyF6TOgdmTeNINJ1LewIo+Xo8a4VmcHJC26nRV9y7YcB2KkXdeJ98/
         wJHznTR2sIBouxanl8u128bcJckY27ch1a+8yMes/wwtjCYQTyhh33+3Ik0PrHsSTTWb
         ruYCnG+aq7nU2cLKG5i6X2IFzsGT9IAHqPzhppvOyGt4qYOpZiFTazFdx2cxNO24B+Ie
         Yh/EAM0TmdGur9rgERqJn/Ah2e3xxVy8nsaczLTCU2FDecxknaflf8LpVeTMns3Uve2l
         /oUHYuEv++xew+FqFl8kw7jnRO5h4qGccNXsYDR1KiE3VsscdLYwUjawxw89uA24l09E
         nTmw==
X-Gm-Message-State: AOAM5305tPyd7vjFTBri0Ek1KumfcYDeQs0DGXZZThcA/jDybfNpt55F
        YfUv8sX3uPpYLkDmqzPu0DjeJ6G/9otmhhtDdXyuMetZBR5W
X-Google-Smtp-Source: ABdhPJwXNSJv0Y70GjITxLk1OWWjifb3kjnuZjeSFNwQ923sGU+t9wnYNMf+SDVllS6HdZw0W/vkXQ4Ruz8LOaa4xr6x15QjyLuF
MIME-Version: 1.0
X-Received: by 2002:a02:ce8a:: with SMTP id y10mr17286758jaq.102.1607717471175;
 Fri, 11 Dec 2020 12:11:11 -0800 (PST)
Date:   Fri, 11 Dec 2020 12:11:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c4ccad05b635e468@google.com>
Subject: KASAN: slab-out-of-bounds Read in rtl_fw_do_work
From:   syzbot <syzbot+7b774a105bad5f282322@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, davem@davemloft.net, kuba@kernel.org,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pkshih@realtek.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3db4c21c usb: typec: tcpm: Update vbus_vsafe0v on init
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=179809f3500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d24ee9ecd7ce968e
dashboard link: https://syzkaller.appspot.com/bug?extid=7b774a105bad5f282322
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7b774a105bad5f282322@syzkaller.appspotmail.com

usb 1-1: Direct firmware load for rtlwifi/rtl8192cufw.bin failed with error -2
==================================================================
BUG: KASAN: slab-out-of-bounds in rtl_fw_do_work+0x407/0x430 drivers/net/wireless/realtek/rtlwifi/core.c:87
Read of size 8 at addr ffff888142b2ff58 by task kworker/0:6/7385

CPU: 0 PID: 7385 Comm: kworker/0:6 Not tainted 5.10.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events request_firmware_work_func
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x4c8 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 rtl_fw_do_work+0x407/0x430 drivers/net/wireless/realtek/rtlwifi/core.c:87
 request_firmware_work_func+0x12c/0x230 drivers/base/firmware_loader/main.c:1079
 process_one_work+0x933/0x1520 kernel/workqueue.c:2272
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
 kthread+0x38c/0x460 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Allocated by task 16159:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:461
 kmalloc include/linux/slab.h:557 [inline]
 tomoyo_realpath_from_path+0xc3/0x620 security/tomoyo/realpath.c:254
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_number_perm+0x1d5/0x590 security/tomoyo/file.c:723
 security_file_ioctl+0x50/0xb0 security/security.c:1481
 __do_sys_ioctl fs/ioctl.c:747 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0xb3/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x40 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 16159:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0x102/0x140 mm/kasan/common.c:422
 slab_free_hook mm/slub.c:1544 [inline]
 slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1577
 slab_free mm/slub.c:3142 [inline]
 kfree+0xe5/0x5e0 mm/slub.c:4124
 tomoyo_realpath_from_path+0x191/0x620 security/tomoyo/realpath.c:291
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_number_perm+0x1d5/0x590 security/tomoyo/file.c:723
 security_file_ioctl+0x50/0xb0 security/security.c:1481
 __do_sys_ioctl fs/ioctl.c:747 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0xb3/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x40 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff888142b2e000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 3928 bytes to the right of
 4096-byte region [ffff888142b2e000, ffff888142b2f000)
The buggy address belongs to the page:
page:00000000104f6cd2 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x142b28
head:00000000104f6cd2 order:3 compound_mapcount:0 compound_pincount:0
flags: 0x200000000010200(slab|head)
raw: 0200000000010200 dead000000000100 dead000000000122 ffff888100042140
raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888142b2fe00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888142b2fe80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888142b2ff00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                                    ^
 ffff888142b2ff80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888142b30000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
