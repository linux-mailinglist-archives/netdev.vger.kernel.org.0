Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD75B48E785
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 10:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236096AbiANJ2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 04:28:21 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:44987 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiANJ2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 04:28:20 -0500
Received: by mail-il1-f199.google.com with SMTP id i7-20020a056e0212c700b002b52f079761so5793687ilm.11
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 01:28:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=al7eFBuh4sFwLCL4GiOXmiXiy1H4469bZvRRUWVvLdA=;
        b=F6RYH5dMROvt0cYwnfUAOdFIv7PHbnpMfiGEktNNuG+HWOIsb0gna+qLE2bA+RwJhE
         fbl52SL9HrBAaO9EjZYymoenDqTwQp85N0kGXeoJI11fzGRSGZPW0WksIp7PWTQ42Z96
         UFjik6XOqKF0BrdabJ8V9Ilr/+8IDMlFOfQwJTmb3WqBuYcTWW/ldoBZFEtHOeKyv53i
         roGMX4eaJAtX/C6It9YKH712qJ+AQBypXD4uGnFyujnaBPW9ak7gIt82t8qfQsqD714w
         4X6LWWOJh+cV3ITM5MQp2xRcwZEQS7NildBBihhy0dz+TH7AHVCvYLL81Qjf/Hejccmj
         bUXg==
X-Gm-Message-State: AOAM533StpEUjMuwXDwAH74abdeJaf28uv+imjdLTJPHkafuDUDU9jEO
        xwaTKlFGnLWidS9SW3rTLezvDlqh5PzHj+wQafO0XDJtNFZt
X-Google-Smtp-Source: ABdhPJxyXr0SBcgR05CtxsGITEYhHVGsVTH3amDHmbiFuXEEPQXjM4u7Ifq2Z/daTNoBSH+81dLAkvlbNRIQ74v76uwVeMr2DQ8S
MIME-Version: 1.0
X-Received: by 2002:a02:9108:: with SMTP id a8mr3729402jag.284.1642152499779;
 Fri, 14 Jan 2022 01:28:19 -0800 (PST)
Date:   Fri, 14 Jan 2022 01:28:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006aa20b05d5876c1f@google.com>
Subject: [syzbot] KASAN: null-ptr-deref Write in kcm_tx_work (2)
From:   syzbot <syzbot+25ca556057c68f8a03a2@syzkaller.appspotmail.com>
To:     aahringo@redhat.com, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, paskripkin@gmail.com,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        unixbhaskar@gmail.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    df0cc57e057f Linux 5.16
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12a89d2db00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ea1f52f5503d3ac3
dashboard link: https://syzkaller.appspot.com/bug?extid=25ca556057c68f8a03a2
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+25ca556057c68f8a03a2@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_write include/linux/instrumented.h:86 [inline]
BUG: KASAN: null-ptr-deref in clear_bit include/asm-generic/bitops/instrumented-atomic.h:41 [inline]
BUG: KASAN: null-ptr-deref in kcm_tx_work+0xff/0x160 net/kcm/kcmsock.c:741
Write of size 8 at addr 0000000000000008 by task kworker/u4:47/7955

CPU: 1 PID: 7955 Comm: kworker/u4:47 Not tainted 5.16.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: kkcmd kcm_tx_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 __kasan_report mm/kasan/report.c:437 [inline]
 kasan_report.cold+0x66/0xdf mm/kasan/report.c:450
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_write include/linux/instrumented.h:86 [inline]
 clear_bit include/asm-generic/bitops/instrumented-atomic.h:41 [inline]
 kcm_tx_work+0xff/0x160 net/kcm/kcmsock.c:741
 process_one_work+0x9b2/0x1660 kernel/workqueue.c:2298
 worker_thread+0x65d/0x1130 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
==================================================================
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 7955 Comm: kworker/u4:47 Tainted: G    B             5.16.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: kkcmd kcm_tx_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 panic+0x2b0/0x6dd kernel/panic.c:232
 end_report.cold+0x63/0x6f mm/kasan/report.c:128
 __kasan_report mm/kasan/report.c:440 [inline]
 kasan_report.cold+0x71/0xdf mm/kasan/report.c:450
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_write include/linux/instrumented.h:86 [inline]
 clear_bit include/asm-generic/bitops/instrumented-atomic.h:41 [inline]
 kcm_tx_work+0xff/0x160 net/kcm/kcmsock.c:741
 process_one_work+0x9b2/0x1660 kernel/workqueue.c:2298
 worker_thread+0x65d/0x1130 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
