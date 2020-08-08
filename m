Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCC423F721
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 11:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgHHJqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 05:46:24 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:52809 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgHHJqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 05:46:22 -0400
Received: by mail-io1-f71.google.com with SMTP id k12so3467444iom.19
        for <netdev@vger.kernel.org>; Sat, 08 Aug 2020 02:46:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Mgd7GqjjHZbKTVg1oMh8UpWpxgZW/6tvB9gNkmYnfYE=;
        b=DyaHqsiBN+aUtZSTXUzZUVrS1q4Eo4fMQjzb4lnyqfrcePDKXPFqH1WUZ3X92M2D7J
         YXxEUMziBpggsjEQ3J04K9hMgVBpsktsx0L9xK6H4ccXnMPzfXS/FlBC8sNrnJ0HcOrJ
         L9I1nZ+AlIaRS2bHUnPj/guf2u7f0IaIzJ7+oM6fnzXMyhodyDwhp+/UfDx6x1jhvh27
         XvXaTYBf5B6nRGR+KWrXi0bJnmviAEDMaO70S49GiPrqDJexEI6s5Aoi6omShaCSP+kb
         RDboSqtSM6MPL0koAzXs2qJ4LCGKH21WH2ouVOTjSJtdC6ackb/vuYWeWOD7lf+1zZdA
         2zMQ==
X-Gm-Message-State: AOAM533lDCkhCtrEmnFv/YBfhUjfKqx+Ce5CPzRyuX7YKMHlJOnjyQ+h
        +1IjDXy2b0aPYnbN/ulLUq2Goc62a2Txt4uEVvcBrqIHsPzV
X-Google-Smtp-Source: ABdhPJzW8/kOTaphgcikkhZB1BACCXuyS9i2Q48y8/n1Uc0jg23uS5/J2KZB4W9dkahJKWLM4/ndHDDc3MSj9hj88H1XQl04F5BJ
MIME-Version: 1.0
X-Received: by 2002:a6b:3e04:: with SMTP id l4mr8449851ioa.206.1596879981392;
 Sat, 08 Aug 2020 02:46:21 -0700 (PDT)
Date:   Sat, 08 Aug 2020 02:46:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000a389a05ac5a9864@google.com>
Subject: KASAN: null-ptr-deref Write in l2cap_chan_put
From:   syzbot <syzbot+452e9465a3b2817fa4c2@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    5631c5e0 Merge tag 'xfs-5.9-merge-7' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15c21934900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=afba7c06f91e56eb
dashboard link: https://syzkaller.appspot.com/bug?extid=452e9465a3b2817fa4c2
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=131e96aa900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+452e9465a3b2817fa4c2@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_write include/linux/instrumented.h:71 [inline]
BUG: KASAN: null-ptr-deref in atomic_fetch_sub_release include/asm-generic/atomic-instrumented.h:220 [inline]
BUG: KASAN: null-ptr-deref in refcount_sub_and_test include/linux/refcount.h:266 [inline]
BUG: KASAN: null-ptr-deref in refcount_dec_and_test include/linux/refcount.h:294 [inline]
BUG: KASAN: null-ptr-deref in kref_put include/linux/kref.h:64 [inline]
BUG: KASAN: null-ptr-deref in l2cap_chan_put+0x28/0x230 net/bluetooth/l2cap_core.c:502
Write of size 4 at addr 0000000000000018 by task kworker/0:1/7077

CPU: 0 PID: 7077 Comm: kworker/0:1 Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events l2cap_chan_timeout
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 __kasan_report mm/kasan/report.c:517 [inline]
 kasan_report.cold+0x5/0x37 mm/kasan/report.c:530
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
 instrument_atomic_write include/linux/instrumented.h:71 [inline]
 atomic_fetch_sub_release include/asm-generic/atomic-instrumented.h:220 [inline]
 refcount_sub_and_test include/linux/refcount.h:266 [inline]
 refcount_dec_and_test include/linux/refcount.h:294 [inline]
 kref_put include/linux/kref.h:64 [inline]
 l2cap_chan_put+0x28/0x230 net/bluetooth/l2cap_core.c:502
 l2cap_sock_kill+0xbd/0x180 net/bluetooth/l2cap_sock.c:1217
 l2cap_chan_timeout+0x1c1/0x450 net/bluetooth/l2cap_core.c:438
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
==================================================================
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 7077 Comm: kworker/0:1 Tainted: G    B             5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events l2cap_chan_timeout
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:231
 end_report+0x4d/0x53 mm/kasan/report.c:104
 __kasan_report mm/kasan/report.c:520 [inline]
 kasan_report.cold+0xd/0x37 mm/kasan/report.c:530
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
 instrument_atomic_write include/linux/instrumented.h:71 [inline]
 atomic_fetch_sub_release include/asm-generic/atomic-instrumented.h:220 [inline]
 refcount_sub_and_test include/linux/refcount.h:266 [inline]
 refcount_dec_and_test include/linux/refcount.h:294 [inline]
 kref_put include/linux/kref.h:64 [inline]
 l2cap_chan_put+0x28/0x230 net/bluetooth/l2cap_core.c:502
 l2cap_sock_kill+0xbd/0x180 net/bluetooth/l2cap_sock.c:1217
 l2cap_chan_timeout+0x1c1/0x450 net/bluetooth/l2cap_core.c:438
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
