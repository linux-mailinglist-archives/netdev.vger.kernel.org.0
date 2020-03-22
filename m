Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB08718ECD1
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 23:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgCVWKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 18:10:17 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:55473 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgCVWKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 18:10:16 -0400
Received: by mail-io1-f69.google.com with SMTP id k5so10032162ioa.22
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 15:10:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=B9V+9G16l/n/I5DhGTuXZFS/jqwZ2Fhm405AxG9r1pg=;
        b=dtiXDktp1j2YkhrN61bpzXSk9wNL2qFHo9+A2jZQrWJPCQ1Q2aAgpXRt+ayEj3KNID
         WK+wQvwIpPe2HU22n9QXdeVhisd5NQaTwaM71NKeFaGdGmmDm5lqCY+2m2dJzh2+Vw/r
         Ad3zdOdwZvWzB3y94ojFD/g/ZLRWsNucK8pS15dhFqmXioJ+dEBmgibta+RPMkznn580
         NiphnyGIMTKLcc7VYj8IGYKSOeH8FMjD023xLeEbWeylQpone+6ZRq94KwxSQUBJL8lr
         blGUzoRslPUCmP7Uh5g78pTJFxOJ8aHIusyfzbluo+1XmnAouWvvLDu+HA+2S3q5nRMU
         NALw==
X-Gm-Message-State: ANhLgQ0vlKzkAyo4ohwhuum1IUF58hwvR7ZUudb9wnM5Ic9Co/U+NtM8
        dPhIH+4AAusfNh9t9OTe+iy5PkdWIf37yHyWjVAXo9vXq7zA
X-Google-Smtp-Source: ADFU+vuVzjeEae7o1I+HmgNwpk7n+z9OFE7PjR4XzqQ7rReEZvT7Bk7TowM0Ye8DlHwyauMrZFI30PW97b+EynOafYnyNSP79YIR
MIME-Version: 1.0
X-Received: by 2002:a92:6b0f:: with SMTP id g15mr12326695ilc.69.1584915013914;
 Sun, 22 Mar 2020 15:10:13 -0700 (PDT)
Date:   Sun, 22 Mar 2020 15:10:13 -0700
In-Reply-To: <000000000000e9e518059fd84189@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006758f505a178c84f@google.com>
Subject: Re: KASAN: use-after-free Write in hci_sock_bind (2)
From:   syzbot <syzbot+04e804c8c2224b6a9497@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    770fbb32 Add linux-next specific files for 20200228
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=108618ade00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=576314276bce4ad5
dashboard link: https://syzkaller.appspot.com/bug?extid=04e804c8c2224b6a9497
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11fc5e75e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10707013e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+04e804c8c2224b6a9497@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_write include/linux/instrumented.h:71 [inline]
BUG: KASAN: use-after-free in atomic_inc include/asm-generic/atomic-instrumented.h:240 [inline]
BUG: KASAN: use-after-free in hci_sock_bind+0x591/0x1140 net/bluetooth/hci_sock.c:1250
Write of size 4 at addr ffff888089679078 by task syz-executor918/10028

CPU: 1 PID: 10028 Comm: syz-executor918 Not tainted 5.6.0-rc3-next-20200228-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x315 mm/kasan/report.c:374
 __kasan_report.cold+0x1a/0x32 mm/kasan/report.c:506
 kasan_report+0xe/0x20 mm/kasan/common.c:618
 check_memory_region_inline mm/kasan/generic.c:185 [inline]
 check_memory_region+0x128/0x190 mm/kasan/generic.c:192
 instrument_atomic_write include/linux/instrumented.h:71 [inline]
 atomic_inc include/asm-generic/atomic-instrumented.h:240 [inline]
 hci_sock_bind+0x591/0x1140 net/bluetooth/hci_sock.c:1250
 __sys_bind+0x20e/0x250 net/socket.c:1662
 __do_sys_bind net/socket.c:1673 [inline]
 __se_sys_bind net/socket.c:1671 [inline]
 __x64_sys_bind+0x6f/0xb0 net/socket.c:1671
 do_syscall_64+0xf6/0x790 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4435a9
Code: e8 1c e7 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 ab 06 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd328c7b48 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 00000000004435a9
RDX: 0000000000000006 RSI: 0000000020000080 RDI: 0000000000000006
RBP: 0000000000000005 R08: 00000000000003e8 R09: 00000000000003e8
R10: 00000000000003e8 R11: 0000000000000246 R12: 0000000000dc6914
R13: 000000000000000b R14: 0000000000000000 R15: 0000000000000000

Allocated by task 10029:
 save_stack+0x1b/0x40 mm/kasan/common.c:49
 set_track mm/kasan/common.c:57 [inline]
 __kasan_kmalloc mm/kasan/common.c:492 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:465
 kmem_cache_alloc_trace+0x153/0x7d0 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 hci_alloc_dev+0x3e/0x1e20 net/bluetooth/hci_core.c:3249
 __vhci_create_device+0x100/0x5b0 drivers/bluetooth/hci_vhci.c:99
 vhci_create_device drivers/bluetooth/hci_vhci.c:148 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:205 [inline]
 vhci_write+0x2bf/0x450 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write+0x49c/0x700 fs/read_write.c:483
 __vfs_write+0xc9/0x100 fs/read_write.c:496
 vfs_write+0x262/0x5c0 fs/read_write.c:558
 ksys_write+0x127/0x250 fs/read_write.c:611
 do_syscall_64+0xf6/0x790 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 10029:
 save_stack+0x1b/0x40 mm/kasan/common.c:49
 set_track mm/kasan/common.c:57 [inline]
 kasan_set_free_info mm/kasan/common.c:314 [inline]
 __kasan_slab_free+0xf7/0x140 mm/kasan/common.c:453
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x109/0x2b0 mm/slab.c:3757
 bt_host_release+0x15/0x20 net/bluetooth/hci_sysfs.c:86
 device_release+0x71/0x200 drivers/base/core.c:1358
 kobject_cleanup lib/kobject.c:693 [inline]
 kobject_release lib/kobject.c:722 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1e7/0x2e0 lib/kobject.c:739
 put_device+0x1b/0x30 drivers/base/core.c:2586
 vhci_release+0x78/0xe0 drivers/bluetooth/hci_vhci.c:341
 __fput+0x2da/0x850 fs/file_table.c:280
 task_work_run+0x13f/0x1b0 kernel/task_work.c:113
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop+0x2fa/0x360 arch/x86/entry/common.c:165
 prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
 syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
 do_syscall_64+0x672/0x790 arch/x86/entry/common.c:305
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff888089678000
 which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 4216 bytes inside of
 8192-byte region [ffff888089678000, ffff88808967a000)
The buggy address belongs to the page:
page:ffffea0002259e00 refcount:1 mapcount:0 mapping:00000000baf255d8 index:0x0 head:ffffea0002259e00 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfffe0000010200(slab|head)
raw: 00fffe0000010200 ffffea0002a19608 ffffea0002500e08 ffff8880aa0021c0
raw: 0000000000000000 ffff888089678000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888089678f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888089678f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888089679000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                                ^
 ffff888089679080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888089679100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

