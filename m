Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1A731819F1
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 14:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729514AbgCKNgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 09:36:17 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:33748 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729528AbgCKNgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 09:36:16 -0400
Received: by mail-io1-f70.google.com with SMTP id b4so1503133iok.0
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 06:36:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=B6+pwT0gZafpVjC1uFsztM6A9cG4YUfExspz24y936U=;
        b=q35zcCROzt3irRzakjY7O4L5UFNTS4XV/a1gW97RUsG1yZozTQi+nVuF3RgM0WjtaJ
         lVv75hMFjxFzdo3I20mkTf69uogiU06Pz6C2WFoNTdTszWyI5yRlxQS1ABqZZxLjINyF
         kHQu3BG5Vl32tQgV/i5zYPpXRUBd8R4GltpZ8lSjvCccXfCAvtuKQinVck6fKTwOZ34n
         N+NWtWKwhJqRirndkB0KEDL5w/0rwE5jgVWi3KGTfchBUuMHq10zOfJz2yZbAP86cFGI
         JGh/T2pT45W2yELaxu8YIFkm81SR/ez25Qd5/DV4ReV0t9cU1zPmCszPdSk3IhSe5281
         CCgw==
X-Gm-Message-State: ANhLgQ1UhpcE5h85fxdX9Z5dcKQ9AcMz18q/1w0mtyUPfYnAjv6BDKlk
        0ufVZDJrhpAGSjaSAOGl2hKx9wv9SIpYhGYGDYIoch7fEBK4
X-Google-Smtp-Source: ADFU+vuLxefO+UDW/tYunN18EVyA6TyIEtNg86ZkgNJ7UPyQWxTCqY1YwLupkTwbW3PKLI13wVWZKuk2yLt5OeZ1mHHX7C7I3CU5
MIME-Version: 1.0
X-Received: by 2002:a92:9edc:: with SMTP id s89mr3251008ilk.229.1583933775736;
 Wed, 11 Mar 2020 06:36:15 -0700 (PDT)
Date:   Wed, 11 Mar 2020 06:36:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000cf74105a094527d@google.com>
Subject: general protection fault in ir_raw_event_store_with_filter
From:   syzbot <syzbot+34008406ee9a31b13c73@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, andriin@fb.com, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, kafai@fb.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org, mchehab@kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    d6ff8147 usb: gadget: add raw-gadget interface
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=14d0f655e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=90a3d9bed5648419
dashboard link: https://syzkaller.appspot.com/bug?extid=34008406ee9a31b13c73
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1743a061e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1775f5c3e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+34008406ee9a31b13c73@syzkaller.appspotmail.com

rc rc0: IR event FIFO is full!
rc rc0: IR event FIFO is full!
rc rc0: IR event FIFO is full!
rc rc0: IR event FIFO is full!
rc rc0: IR event FIFO is full!
general protection fault, probably for non-canonical address 0xdffffc0000000219: 0000 [#1] SMP KASAN
KASAN: probably user-memory-access in range [0x00000000000010c8-0x00000000000010cf]
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.6.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ir_raw_event_store_with_filter+0x41b/0x580 drivers/media/rc/rc-ir-raw.c:186
Code: 80 3c 02 00 0f 85 5b 01 00 00 4c 8b a5 f0 05 00 00 48 b8 00 00 00 00 00 fc ff df 49 8d bc 24 c8 10 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 4b 01 00 00 48 ba 00 00 00 00 00 fc ff df 48 89
RSP: 0018:ffff8881db309948 EFLAGS: 00010002
RAX: dffffc0000000000 RBX: ffff8881db3099b8 RCX: 0000000000000000
RDX: 0000000000000219 RSI: ffffffff8406b41d RDI: 00000000000010c8
RBP: ffff8881ccc8c000 R08: 000000000000001e R09: ffffed103b66439f
R10: ffffed103b66439e R11: ffff8881db321cf3 R12: 0000000000000000
R13: ffff8881db3099bd R14: 000000000001f400 R15: ffff8881ccc8c5f0
FS:  0000000000000000(0000) GS:ffff8881db300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc50e2e1000 CR3: 00000001ce093000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 sz_push.isra.0+0xa4/0x1e0 drivers/media/rc/streamzap.c:118
 sz_push_half_space drivers/media/rc/streamzap.c:182 [inline]
 streamzap_callback+0x337/0x8a0 drivers/media/rc/streamzap.c:234
 __usb_hcd_giveback_urb+0x1f2/0x470 drivers/usb/core/hcd.c:1648
 usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1713
 dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
 call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers kernel/time/timer.c:1773 [inline]
 __run_timers kernel/time/timer.c:1740 [inline]
 run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786
 __do_softirq+0x21e/0x950 kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x178/0x1a0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:546 [inline]
 smp_apic_timer_interrupt+0x141/0x540 arch/x86/kernel/apic/apic.c:1146
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:default_idle+0x28/0x300 arch/x86/kernel/process.c:696
Code: cc cc 41 56 41 55 65 44 8b 2d 94 c9 72 7a 41 54 55 53 0f 1f 44 00 00 e8 16 bb b5 fb e9 07 00 00 00 0f 00 2d 3a 5f 53 00 fb f4 <65> 44 8b 2d 70


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
