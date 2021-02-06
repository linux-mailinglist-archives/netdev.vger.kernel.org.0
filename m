Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A42311C38
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 09:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhBFIg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 03:36:59 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:56046 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhBFIgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 03:36:54 -0500
Received: by mail-io1-f72.google.com with SMTP id a2so8266904iod.22
        for <netdev@vger.kernel.org>; Sat, 06 Feb 2021 00:36:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Vjllui7uaJPc8hueRFxPXFS2fUrnK2hwtttKy49Se7c=;
        b=aPVvjqkGXaHcWa5I3glyRmVGEztn5B8k77Nj01nIOPBwaPsgJDNOKB4iKUvFPS+kGz
         5OCMgjb2thmlVkFWsKyYVOmPEsXN7rkWd9sALxSlxK1TzLIgsalNJL4GvCLip0jCVVD6
         0aH+DMWFJa42LLwJG8+plLchEEUX/SS5R+XfuYBe4+W6bc2x63wdLw73bavy6pwmVEO0
         SV+tf5f5d/+sSG3O9WcsHnu4vI/B8aKBmybLYGR0fvFTbXnlp4IXRRBT3MenP2Lylgtf
         LxnNtEQ3dieUvqU4GeFcAHTIafoMPUqQwMCVOkVdzfSwDg8sDAu3lFGP52RneSAoomMu
         zVQQ==
X-Gm-Message-State: AOAM532gneHdH5pQdSIOq5A6Vs0W7BVselcib//7slKAjPEkPYMYOur3
        K3xMXJuMLKYvHN3L9O+x8e5P9OM/MBIwsB952EO1qxkc0W4V
X-Google-Smtp-Source: ABdhPJxdYczRveQpCPBHDtTkJB7uRbqfviBPRd7k0i4Q1KOsXvzGLGjVkTTmxVFUU3t6/hf80LeKtMR7PaCztG8NUy+cBum5e6ty
MIME-Version: 1.0
X-Received: by 2002:a6b:fb0f:: with SMTP id h15mr7682245iog.27.1612600573798;
 Sat, 06 Feb 2021 00:36:13 -0800 (PST)
Date:   Sat, 06 Feb 2021 00:36:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005dacd805baa6d46e@google.com>
Subject: KASAN: wild-memory-access Write in l2cap_chan_put
From:   syzbot <syzbot+a384548b03ddcbbaf619@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    88bb507a Merge tag 'media/v5.11-3' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=112bab6f500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6e95b9873f64b36c
dashboard link: https://syzkaller.appspot.com/bug?extid=a384548b03ddcbbaf619
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a384548b03ddcbbaf619@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: wild-memory-access in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
BUG: KASAN: wild-memory-access in atomic_fetch_sub_release include/asm-generic/atomic-instrumented.h:220 [inline]
BUG: KASAN: wild-memory-access in __refcount_sub_and_test include/linux/refcount.h:272 [inline]
BUG: KASAN: wild-memory-access in __refcount_dec_and_test include/linux/refcount.h:315 [inline]
BUG: KASAN: wild-memory-access in refcount_dec_and_test include/linux/refcount.h:333 [inline]
BUG: KASAN: wild-memory-access in kref_put include/linux/kref.h:64 [inline]
BUG: KASAN: wild-memory-access in l2cap_chan_put+0x35/0x2e0 net/bluetooth/l2cap_core.c:502
Write of size 4 at addr aaaa00aaaaaaaac2 by task kworker/2:22/10838

CPU: 2 PID: 10838 Comm: kworker/2:22 Not tainted 5.11.0-rc6-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Workqueue: events l2cap_chan_timeout
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 __kasan_report mm/kasan/report.c:400 [inline]
 kasan_report.cold+0x5f/0xd5 mm/kasan/report.c:413
 check_memory_region_inline mm/kasan/generic.c:179 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:185
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_fetch_sub_release include/asm-generic/atomic-instrumented.h:220 [inline]
 __refcount_sub_and_test include/linux/refcount.h:272 [inline]
 __refcount_dec_and_test include/linux/refcount.h:315 [inline]
 refcount_dec_and_test include/linux/refcount.h:333 [inline]
 kref_put include/linux/kref.h:64 [inline]
 l2cap_chan_put+0x35/0x2e0 net/bluetooth/l2cap_core.c:502
 l2cap_sock_kill+0xd0/0x240 net/bluetooth/l2cap_sock.c:1217
 l2cap_chan_timeout+0x1cc/0x2f0 net/bluetooth/l2cap_core.c:438
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
==================================================================
Kernel panic - not syncing: panic_on_warn set ...
CPU: 2 PID: 10838 Comm: kworker/2:22 Tainted: G    B             5.11.0-rc6-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Workqueue: events l2cap_chan_timeout
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 panic+0x306/0x73d kernel/panic.c:231
 end_report+0x58/0x5e mm/kasan/report.c:100
 __kasan_report mm/kasan/report.c:403 [inline]
 kasan_report.cold+0x67/0xd5 mm/kasan/report.c:413
 check_memory_region_inline mm/kasan/generic.c:179 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:185
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_fetch_sub_release include/asm-generic/atomic-instrumented.h:220 [inline]
 __refcount_sub_and_test include/linux/refcount.h:272 [inline]
 __refcount_dec_and_test include/linux/refcount.h:315 [inline]
 refcount_dec_and_test include/linux/refcount.h:333 [inline]
 kref_put include/linux/kref.h:64 [inline]
 l2cap_chan_put+0x35/0x2e0 net/bluetooth/l2cap_core.c:502
 l2cap_sock_kill+0xd0/0x240 net/bluetooth/l2cap_sock.c:1217
 l2cap_chan_timeout+0x1cc/0x2f0 net/bluetooth/l2cap_core.c:438
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
Dumping ftrace buffer:
   (ftrace buffer empty)
Kernel Offset: disabled
Rebooting in 1 seconds..
ACPI MEMORY or I/O RESET_REG.


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
