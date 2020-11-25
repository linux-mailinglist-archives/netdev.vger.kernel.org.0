Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15E52C3682
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 03:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgKYCF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 21:05:27 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:54451 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgKYCF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 21:05:26 -0500
Received: by mail-il1-f198.google.com with SMTP id z8so597909ilq.21
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 18:05:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ydIVKAHcDRGuG08LnEyerZ5j/7+ixmUeiapj72gclQo=;
        b=OOxnBVV6REQHvx5+yVfp9zu0h/fZg+8LKDAjlgZ5D3WSSxji6259ChS1y21DBqL9HT
         IYO/WPGaOoZPnwgQ+KZfkoOba+g2cxFRVlD7A8s4qwqTq5BFeVAo3w/pcsiwKMvfck37
         BZvetPp0rTzAqR1ElC5qls4UPILm7R4vQ8bJ3tvMKLqb5M+1IVyH8OQto9oiNIRMrAN2
         Tl43LAClTRWCPJN3SCpn4+/O6pBcTQI4D+TLBe/jekY5RWoD2kgl8jLs9CdavXeXYxRn
         31KkpJNlSMMjdEGNjlwEmjXAb1SSAi/OJBgUBrO/7suy3XcXMgtrctPFyBoyVvgae2vS
         WNJw==
X-Gm-Message-State: AOAM533e7l0e2HrGNxKCi673Ae+kseX7tnZGkDX3bOl6Eho/puRX+eyW
        pqRhysrrXdc4nH/btESD6ryWxSEI2RkYlDnyHgY+3xT4v2dX
X-Google-Smtp-Source: ABdhPJwAdCdhNb0eFfC3e+VKNGoU7hzCnyrf0XhGwPZEMrRPIE9Vxu16A2cUWmiW4w7kPGJBte3QAJYhXDxEQh8BA3Jv8CTbbZ3i
MIME-Version: 1.0
X-Received: by 2002:a02:a619:: with SMTP id c25mr1362414jam.119.1606269922804;
 Tue, 24 Nov 2020 18:05:22 -0800 (PST)
Date:   Tue, 24 Nov 2020 18:05:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000029861705b4e4dc59@google.com>
Subject: memory leak in qrtr_tun_open
From:   syzbot <syzbot+5d6e4af21385f5cfc56a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4d02da97 Merge tag 'net-5.10-rc5' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16f4331e500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c5353ac514ca5a43
dashboard link: https://syzkaller.appspot.com/bug?extid=5d6e4af21385f5cfc56a
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1115d001500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1467f82e500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5d6e4af21385f5cfc56a@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff888117d40180 (size 64):
  comm "syz-executor845", pid 10294, jiffies 4295034653 (age 32.350s)
  hex dump (first 32 bytes):
    c0 24 04 84 ff ff ff ff 00 00 00 00 00 00 00 00  .$..............
    90 01 d4 17 81 88 ff ff 90 01 d4 17 81 88 ff ff  ................
  backtrace:
    [<00000000fcfbf0c5>] kmalloc include/linux/slab.h:552 [inline]
    [<00000000fcfbf0c5>] kzalloc include/linux/slab.h:664 [inline]
    [<00000000fcfbf0c5>] qrtr_tun_open+0x22/0x90 net/qrtr/tun.c:35
    [<000000003dd258a0>] misc_open+0x19c/0x1e0 drivers/char/misc.c:141
    [<00000000c462f734>] chrdev_open+0x10d/0x340 fs/char_dev.c:414
    [<000000006a388b0e>] do_dentry_open+0x1e6/0x620 fs/open.c:817
    [<00000000757d8e01>] do_open fs/namei.c:3252 [inline]
    [<00000000757d8e01>] path_openat+0x74a/0x1b00 fs/namei.c:3369
    [<00000000b8d1608f>] do_filp_open+0xa0/0x190 fs/namei.c:3396
    [<0000000089fdef83>] do_sys_openat2+0xed/0x230 fs/open.c:1168
    [<000000004cd3d1c0>] do_sys_open fs/open.c:1184 [inline]
    [<000000004cd3d1c0>] __do_sys_openat fs/open.c:1200 [inline]
    [<000000004cd3d1c0>] __se_sys_openat fs/open.c:1195 [inline]
    [<000000004cd3d1c0>] __x64_sys_openat+0x7f/0xe0 fs/open.c:1195
    [<00000000d6a554a2>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<0000000099a4af52>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888117d40180 (size 64):
  comm "syz-executor845", pid 10294, jiffies 4295034653 (age 32.440s)
  hex dump (first 32 bytes):
    c0 24 04 84 ff ff ff ff 00 00 00 00 00 00 00 00  .$..............
    90 01 d4 17 81 88 ff ff 90 01 d4 17 81 88 ff ff  ................
  backtrace:
    [<00000000fcfbf0c5>] kmalloc include/linux/slab.h:552 [inline]
    [<00000000fcfbf0c5>] kzalloc include/linux/slab.h:664 [inline]
    [<00000000fcfbf0c5>] qrtr_tun_open+0x22/0x90 net/qrtr/tun.c:35
    [<000000003dd258a0>] misc_open+0x19c/0x1e0 drivers/char/misc.c:141
    [<00000000c462f734>] chrdev_open+0x10d/0x340 fs/char_dev.c:414
    [<000000006a388b0e>] do_dentry_open+0x1e6/0x620 fs/open.c:817
    [<00000000757d8e01>] do_open fs/namei.c:3252 [inline]
    [<00000000757d8e01>] path_openat+0x74a/0x1b00 fs/namei.c:3369
    [<00000000b8d1608f>] do_filp_open+0xa0/0x190 fs/namei.c:3396
    [<0000000089fdef83>] do_sys_openat2+0xed/0x230 fs/open.c:1168
    [<000000004cd3d1c0>] do_sys_open fs/open.c:1184 [inline]
    [<000000004cd3d1c0>] __do_sys_openat fs/open.c:1200 [inline]
    [<000000004cd3d1c0>] __se_sys_openat fs/open.c:1195 [inline]
    [<000000004cd3d1c0>] __x64_sys_openat+0x7f/0xe0 fs/open.c:1195
    [<00000000d6a554a2>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<0000000099a4af52>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888117d40180 (size 64):
  comm "syz-executor845", pid 10294, jiffies 4295034653 (age 32.520s)
  hex dump (first 32 bytes):
    c0 24 04 84 ff ff ff ff 00 00 00 00 00 00 00 00  .$..............
    90 01 d4 17 81 88 ff ff 90 01 d4 17 81 88 ff ff  ................
  backtrace:
    [<00000000fcfbf0c5>] kmalloc include/linux/slab.h:552 [inline]
    [<00000000fcfbf0c5>] kzalloc include/linux/slab.h:664 [inline]
    [<00000000fcfbf0c5>] qrtr_tun_open+0x22/0x90 net/qrtr/tun.c:35
    [<000000003dd258a0>] misc_open+0x19c/0x1e0 drivers/char/misc.c:141
    [<00000000c462f734>] chrdev_open+0x10d/0x340 fs/char_dev.c:414
    [<000000006a388b0e>] do_dentry_open+0x1e6/0x620 fs/open.c:817
    [<00000000757d8e01>] do_open fs/namei.c:3252 [inline]
    [<00000000757d8e01>] path_openat+0x74a/0x1b00 fs/namei.c:3369
    [<00000000b8d1608f>] do_filp_open+0xa0/0x190 fs/namei.c:3396
    [<0000000089fdef83>] do_sys_openat2+0xed/0x230 fs/open.c:1168
    [<000000004cd3d1c0>] do_sys_open fs/open.c:1184 [inline]
    [<000000004cd3d1c0>] __do_sys_openat fs/open.c:1200 [inline]
    [<000000004cd3d1c0>] __se_sys_openat fs/open.c:1195 [inline]
    [<000000004cd3d1c0>] __x64_sys_openat+0x7f/0xe0 fs/open.c:1195
    [<00000000d6a554a2>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<0000000099a4af52>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888117d40180 (size 64):
  comm "syz-executor845", pid 10294, jiffies 4295034653 (age 32.600s)
  hex dump (first 32 bytes):
    c0 24 04 84 ff ff ff ff 00 00 00 00 00 00 00 00  .$..............
    90 01 d4 17 81 88 ff ff 90 01 d4 17 81 88 ff ff  ................
  backtrace:
    [<00000000fcfbf0c5>] kmalloc include/linux/slab.h:552 [inline]
    [<00000000fcfbf0c5>] kzalloc include/linux/slab.h:664 [inline]
    [<00000000fcfbf0c5>] qrtr_tun_open+0x22/0x90 net/qrtr/tun.c:35
    [<000000003dd258a0>] misc_open+0x19c/0x1e0 drivers/char/misc.c:141
    [<00000000c462f734>] chrdev_open+0x10d/0x340 fs/char_dev.c:414
    [<000000006a388b0e>] do_dentry_open+0x1e6/0x620 fs/open.c:817
    [<00000000757d8e01>] do_open fs/namei.c:3252 [inline]
    [<00000000757d8e01>] path_openat+0x74a/0x1b00 fs/namei.c:3369
    [<00000000b8d1608f>] do_filp_open+0xa0/0x190 fs/namei.c:3396
    [<0000000089fdef83>] do_sys_openat2+0xed/0x230 fs/open.c:1168
    [<000000004cd3d1c0>] do_sys_open fs/open.c:1184 [inline]
    [<000000004cd3d1c0>] __do_sys_openat fs/open.c:1200 [inline]
    [<000000004cd3d1c0>] __se_sys_openat fs/open.c:1195 [inline]
    [<000000004cd3d1c0>] __x64_sys_openat+0x7f/0xe0 fs/open.c:1195
    [<00000000d6a554a2>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<0000000099a4af52>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888117d40180 (size 64):
  comm "syz-executor845", pid 10294, jiffies 4295034653 (age 32.680s)
  hex dump (first 32 bytes):
    c0 24 04 84 ff ff ff ff 00 00 00 00 00 00 00 00  .$..............
    90 01 d4 17 81 88 ff ff 90 01 d4 17 81 88 ff ff  ................
  backtrace:
    [<00000000fcfbf0c5>] kmalloc include/linux/slab.h:552 [inline]
    [<00000000fcfbf0c5>] kzalloc include/linux/slab.h:664 [inline]
    [<00000000fcfbf0c5>] qrtr_tun_open+0x22/0x90 net/qrtr/tun.c:35
    [<000000003dd258a0>] misc_open+0x19c/0x1e0 drivers/char/misc.c:141
    [<00000000c462f734>] chrdev_open+0x10d/0x340 fs/char_dev.c:414
    [<000000006a388b0e>] do_dentry_open+0x1e6/0x620 fs/open.c:817
    [<00000000757d8e01>] do_open fs/namei.c:3252 [inline]
    [<00000000757d8e01>] path_openat+0x74a/0x1b00 fs/namei.c:3369
    [<00000000b8d1608f>] do_filp_open+0xa0/0x190 fs/namei.c:3396
    [<0000000089fdef83>] do_sys_openat2+0xed/0x230 fs/open.c:1168
    [<000000004cd3d1c0>] do_sys_open fs/open.c:1184 [inline]
    [<000000004cd3d1c0>] __do_sys_openat fs/open.c:1200 [inline]
    [<000000004cd3d1c0>] __se_sys_openat fs/open.c:1195 [inline]
    [<000000004cd3d1c0>] __x64_sys_openat+0x7f/0xe0 fs/open.c:1195
    [<00000000d6a554a2>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<0000000099a4af52>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888117d40180 (size 64):
  comm "syz-executor845", pid 10294, jiffies 4295034653 (age 32.760s)
  hex dump (first 32 bytes):
    c0 24 04 84 ff ff ff ff 00 00 00 00 00 00 00 00  .$..............
    90 01 d4 17 81 88 ff ff 90 01 d4 17 81 88 ff ff  ................
  backtrace:
    [<00000000fcfbf0c5>] kmalloc include/linux/slab.h:552 [inline]
    [<00000000fcfbf0c5>] kzalloc include/linux/slab.h:664 [inline]
    [<00000000fcfbf0c5>] qrtr_tun_open+0x22/0x90 net/qrtr/tun.c:35
    [<000000003dd258a0>] misc_open+0x19c/0x1e0 drivers/char/misc.c:141
    [<00000000c462f734>] chrdev_open+0x10d/0x340 fs/char_dev.c:414
    [<000000006a388b0e>] do_dentry_open+0x1e6/0x620 fs/open.c:817
    [<00000000757d8e01>] do_open fs/namei.c:3252 [inline]
    [<00000000757d8e01>] path_openat+0x74a/0x1b00 fs/namei.c:3369
    [<00000000b8d1608f>] do_filp_open+0xa0/0x190 fs/namei.c:3396
    [<0000000089fdef83>] do_sys_openat2+0xed/0x230 fs/open.c:1168
    [<000000004cd3d1c0>] do_sys_open fs/open.c:1184 [inline]
    [<000000004cd3d1c0>] __do_sys_openat fs/open.c:1200 [inline]
    [<000000004cd3d1c0>] __se_sys_openat fs/open.c:1195 [inline]
    [<000000004cd3d1c0>] __x64_sys_openat+0x7f/0xe0 fs/open.c:1195
    [<00000000d6a554a2>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<0000000099a4af52>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888117d40180 (size 64):
  comm "syz-executor845", pid 10294, jiffies 4295034653 (age 32.850s)
  hex dump (first 32 bytes):
    c0 24 04 84 ff ff ff ff 00 00 00 00 00 00 00 00  .$..............
    90 01 d4 17 81 88 ff ff 90 01 d4 17 81 88 ff ff  ................
  backtrace:
    [<00000000fcfbf0c5>] kmalloc include/linux/slab.h:552 [inline]
    [<00000000fcfbf0c5>] kzalloc include/linux/slab.h:664 [inline]
    [<00000000fcfbf0c5>] qrtr_tun_open+0x22/0x90 net/qrtr/tun.c:35
    [<000000003dd258a0>] misc_open+0x19c/0x1e0 drivers/char/misc.c:141
    [<00000000c462f734>] chrdev_open+0x10d/0x340 fs/char_dev.c:414
    [<000000006a388b0e>] do_dentry_open+0x1e6/0x620 fs/open.c:817
    [<00000000757d8e01>] do_open fs/namei.c:3252 [inline]
    [<00000000757d8e01>] path_openat+0x74a/0x1b00 fs/namei.c:3369
    [<00000000b8d1608f>] do_filp_open+0xa0/0x190 fs/namei.c:3396
    [<0000000089fdef83>] do_sys_openat2+0xed/0x230 fs/open.c:1168
    [<000000004cd3d1c0>] do_sys_open fs/open.c:1184 [inline]
    [<000000004cd3d1c0>] __do_sys_openat fs/open.c:1200 [inline]
    [<000000004cd3d1c0>] __se_sys_openat fs/open.c:1195 [inline]
    [<000000004cd3d1c0>] __x64_sys_openat+0x7f/0xe0 fs/open.c:1195
    [<00000000d6a554a2>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<0000000099a4af52>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888117d40180 (size 64):
  comm "syz-executor845", pid 10294, jiffies 4295034653 (age 32.930s)
  hex dump (first 32 bytes):
    c0 24 04 84 ff ff ff ff 00 00 00 00 00 00 00 00  .$..............
    90 01 d4 17 81 88 ff ff 90 01 d4 17 81 88 ff ff  ................
  backtrace:
    [<00000000fcfbf0c5>] kmalloc include/linux/slab.h:552 [inline]
    [<00000000fcfbf0c5>] kzalloc include/linux/slab.h:664 [inline]
    [<00000000fcfbf0c5>] qrtr_tun_open+0x22/0x90 net/qrtr/tun.c:35
    [<000000003dd258a0>] misc_open+0x19c/0x1e0 drivers/char/misc.c:141
    [<00000000c462f734>] chrdev_open+0x10d/0x340 fs/char_dev.c:414
    [<000000006a388b0e>] do_dentry_open+0x1e6/0x620 fs/open.c:817
    [<00000000757d8e01>] do_open fs/namei.c:3252 [inline]
    [<00000000757d8e01>] path_openat+0x74a/0x1b00 fs/namei.c:3369
    [<00000000b8d1608f>] do_filp_open+0xa0/0x190 fs/namei.c:3396
    [<0000000089fdef83>] do_sys_openat2+0xed/0x230 fs/open.c:1168
    [<000000004cd3d1c0>] do_sys_open fs/open.c:1184 [inline]
    [<000000004cd3d1c0>] __do_sys_openat fs/open.c:1200 [inline]
    [<000000004cd3d1c0>] __se_sys_openat fs/open.c:1195 [inline]
    [<000000004cd3d1c0>] __x64_sys_openat+0x7f/0xe0 fs/open.c:1195
    [<00000000d6a554a2>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<0000000099a4af52>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
write to /proc/sys/fs/mount-max failed: Bad address
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
write to /proc/sys/fs/mount-max failed: Bad address
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
write to /proc/sys/fs/mount-max failed: Bad address
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
write to /proc/sys/fs/mount-max failed: Bad address
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
write to /proc/sys/fs/mount-max failed: Bad address
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
write to /proc/sys/fs/mount-max failed: Bad address
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
write to /proc/sys/fs/mount-max failed: Bad address
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
write to /proc/sys/fs/mount-max failed: Bad address


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
