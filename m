Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E58184E25
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 16:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729887AbfHGOEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 10:04:07 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43757 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729516AbfHGOEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 10:04:06 -0400
Received: by mail-pl1-f196.google.com with SMTP id 4so33987206pld.10
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 07:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Uc65rpe23o0A2nQdvHrvtNgdgXxy1SG12eSfYS2ryvE=;
        b=GOskT8et6JiKHY9AxG/NKv7WscQ3CCeua4bi858HHIhr5NXxmGfa+2GJ9SVLLVVipu
         I+A4sn8jgC4Yzl8TI2GQ3DQ8BihEvMqk8JlPPB2jI3jVVmCnQfx+cCqhQDOp7At2w+uY
         FdSR09NF/SgEZHB1EdAIpWp6Os1p5YpHVcYtCZgblBrBVwdH9l0O5GD65S8Rit5juxMy
         JR7VQaxUMXUzmN/weQJ9sbUku2DWncZM1Of3f2T1GTeQPZl/wLKnQGYqTGv/GW7ZrvKY
         dbHNcp8uZ9s3G+O+PjqO3SWr05a1fSOlFqP3tZDlJYARuExD8ly0xWA4+w8tqbo8g0iE
         qsHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Uc65rpe23o0A2nQdvHrvtNgdgXxy1SG12eSfYS2ryvE=;
        b=JnJhurptCiFkArKgrpgepNHTArOVWR7qh12kBLzjAHZRIxCuBs4A9tLGHYnJemzpzA
         4jvfq+Uz8XHfkuQ/ExM1YcNs7eza9iZEq6hys/2E0V8VTFgW20n46jpRe9wIdqR5vNZI
         SG+rfuWQyu15ULLnJloxja6Zz0Kfr1J1zu7LasUsWnQPy17nznECX5F8chosir0yhGm2
         UnncfgVftmOmhnhePmSqjQVsKCHtXGnDArCmabWUV8X4xJM7jKi4kmOjx0XCOm3SGANZ
         BVouFu1LpCLtlctqogfHZ6ZDcMEoCXTpHhlK+tZZAoDAFNA5VjWeql3PoZMFKwYsByFw
         H/Vw==
X-Gm-Message-State: APjAAAU5wIuECTXZ7ejO46drioDnjZXSPoJTj9SIG2e5l9K9EkjG3OEO
        tZ0t8hnjD/ujwbIg8WB9I4QkMSfHe2qJ5O+yOYBQAA==
X-Google-Smtp-Source: APXvYqwhtTnXHIZt5BWUuuZlK1xosmm0aCgifyhr5DN0sowb29Nm06yezyMPOIY+SYNU8K8ssr8QHGix4pV0cc2nrdA=
X-Received: by 2002:a63:c442:: with SMTP id m2mr8060697pgg.286.1565186645311;
 Wed, 07 Aug 2019 07:04:05 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000d9f094057a17b97b@google.com> <000000000000b439370586498dff@google.com>
 <CAAeHK+zUHJswwHfVUCV0qTgvFVFZpT0hJqioLyYgbA0yQC0H8Q@mail.gmail.com>
In-Reply-To: <CAAeHK+zUHJswwHfVUCV0qTgvFVFZpT0hJqioLyYgbA0yQC0H8Q@mail.gmail.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Wed, 7 Aug 2019 16:03:54 +0200
Message-ID: <CAAeHK+w+asSQ3axWymToQ+uzPfEAYS2QimVBL85GuJRBtxkjDA@mail.gmail.com>
Subject: Re: WARNING in rollback_registered_many (2)
To:     syzbot <syzbot+40918e4d826fb2ff9b96@syzkaller.appspotmail.com>,
        USB list <linux-usb@vger.kernel.org>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>, avagin@virtuozzo.com,
        "David S. Miller" <davem@davemloft.net>,
        devel@driverdev.osuosl.org,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <edumazet@google.com>,
        florian.c.schilhabel@googlemail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kai Heng Feng <kai.heng.feng@canonical.com>,
        ktkhai@virtuozzo.com, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, straube.linux@gmail.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        tyhicks@canonical.com, Matthew Wilcox <willy@infradead.org>,
        Oliver Neukum <oneukum@suse.com>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 12, 2019 at 1:32 PM Andrey Konovalov <andreyknvl@google.com> wrote:
>
> On Fri, Apr 12, 2019 at 1:29 AM syzbot
> <syzbot+40918e4d826fb2ff9b96@syzkaller.appspotmail.com> wrote:
> >
> > syzbot has found a reproducer for the following crash on:
> >
> > HEAD commit:    9a33b369 usb-fuzzer: main usb gadget fuzzer driver
> > git tree:       https://github.com/google/kasan/tree/usb-fuzzer
> > console output: https://syzkaller.appspot.com/x/log.txt?x=10d552b7200000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=23e37f59d94ddd15
> > dashboard link: https://syzkaller.appspot.com/bug?extid=40918e4d826fb2ff9b96
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17a4c1af200000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=121b274b200000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+40918e4d826fb2ff9b96@syzkaller.appspotmail.com
> >
> > usb 1-1: r8712u: MAC Address from efuse = 00:e0:4c:87:00:00
> > usb 1-1: r8712u: Loading firmware from "rtlwifi/rtl8712u.bin"
> > usb 1-1: USB disconnect, device number 2
> > usb 1-1: Direct firmware load for rtlwifi/rtl8712u.bin failed with error -2
> > usb 1-1: r8712u: Firmware request failed
> > WARNING: CPU: 0 PID: 575 at net/core/dev.c:8152
> > rollback_registered_many+0x1f3/0xe70 net/core/dev.c:8152
> > Kernel panic - not syncing: panic_on_warn set ...
> > CPU: 0 PID: 575 Comm: kworker/0:4 Not tainted 5.1.0-rc4-319354-g9a33b36 #3
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > Workqueue: usb_hub_wq hub_event
> > Call Trace:
> >   __dump_stack lib/dump_stack.c:77 [inline]
> >   dump_stack+0xe8/0x16e lib/dump_stack.c:113
> >   panic+0x29d/0x5f2 kernel/panic.c:214
> >   __warn.cold+0x20/0x48 kernel/panic.c:571
> >   report_bug+0x262/0x2a0 lib/bug.c:186
> >   fixup_bug arch/x86/kernel/traps.c:179 [inline]
> >   fixup_bug arch/x86/kernel/traps.c:174 [inline]
> >   do_error_trap+0x130/0x1f0 arch/x86/kernel/traps.c:272
> >   do_invalid_op+0x37/0x40 arch/x86/kernel/traps.c:291
> >   invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:973
> > RIP: 0010:rollback_registered_many+0x1f3/0xe70 net/core/dev.c:8152
> > Code: 05 00 00 31 ff 44 89 fe e8 5a 15 f3 f4 45 84 ff 0f 85 49 ff ff ff e8
> > 1c 14 f3 f4 0f 1f 44 00 00 e8 12 14 f3 f4 e8 0d 14 f3 f4 <0f> 0b 4c 89 e7
> > e8 33 72 f2 f6 31 ff 41 89 c4 89 c6 e8 27 15 f3 f4
> > RSP: 0018:ffff88809d087698 EFLAGS: 00010293
> > RAX: ffff88809d058000 RBX: ffff888096240000 RCX: ffffffff8c7eb146
> > RDX: 0000000000000000 RSI: ffffffff8c7eb163 RDI: 0000000000000001
> > RBP: ffff88809d0877c8 R08: ffff88809d058000 R09: fffffbfff2708111
> > R10: fffffbfff2708110 R11: ffffffff93840887 R12: ffff888096240070
> > R13: dffffc0000000000 R14: ffff88809d087758 R15: 0000000000000000
> >   rollback_registered+0xf7/0x1c0 net/core/dev.c:8228
> >   unregister_netdevice_queue net/core/dev.c:9275 [inline]
> >   unregister_netdevice_queue+0x1dc/0x2b0 net/core/dev.c:9268
> >   unregister_netdevice include/linux/netdevice.h:2655 [inline]
> >   unregister_netdev+0x1d/0x30 net/core/dev.c:9316
> >   r871xu_dev_remove+0xe7/0x223 drivers/staging/rtl8712/usb_intf.c:604
> >   usb_unbind_interface+0x1c9/0x980 drivers/usb/core/driver.c:423
> >   __device_release_driver drivers/base/dd.c:1082 [inline]
> >   device_release_driver_internal+0x436/0x4f0 drivers/base/dd.c:1113
> >   bus_remove_device+0x302/0x5c0 drivers/base/bus.c:556
> >   device_del+0x467/0xb90 drivers/base/core.c:2269
> >   usb_disable_device+0x242/0x790 drivers/usb/core/message.c:1235
> >   usb_disconnect+0x298/0x870 drivers/usb/core/hub.c:2197
> >   hub_port_connect drivers/usb/core/hub.c:4940 [inline]
> >   hub_port_connect_change drivers/usb/core/hub.c:5204 [inline]
> >   port_event drivers/usb/core/hub.c:5350 [inline]
> >   hub_event+0xcd2/0x3b00 drivers/usb/core/hub.c:5432
> >   process_one_work+0x90f/0x1580 kernel/workqueue.c:2269
> >   process_scheduled_works kernel/workqueue.c:2331 [inline]
> >   worker_thread+0x7b0/0xe20 kernel/workqueue.c:2417
> >   kthread+0x313/0x420 kernel/kthread.c:253
> >   ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
> > Kernel Offset: disabled
> > Rebooting in 86400 seconds..
> >
>
> +linux-usb mailing list

This USB bug is the most frequently triggered one right now with over
27k kernel crashes.
