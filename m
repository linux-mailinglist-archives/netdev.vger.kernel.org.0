Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B26229947C
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 15:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388860AbfHVNIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 09:08:10 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44828 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388851AbfHVNIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 09:08:09 -0400
Received: by mail-pl1-f196.google.com with SMTP id t14so3432636plr.11
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 06:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qohOIjLTZ3ihn9x3N6euNmP6rCWo+cb3m1PqDtwjGYs=;
        b=OldMupOLYD08MOzZC+lN80ib1KDeoHXh4WMku2QC6LMKDS5DEHumBoH7/sUDFXUg4H
         ZuEQnWpQP55CwBNNNAk4+PToDwiFJsBvfJLuziKA1wU4tgV7yXpphyBtVjsYeZLnrGbs
         4LUT83JkOw2FFRJ8wX+3Vk2A05+DWXFxwub1Uu+EjBoJjIeMPVOW65CKqRJHMgIM9Qoj
         NoAVVaKEtUr44B5SDHIoZV2yswoUhrIZ39L1N11XdmhIoVqGeTaxgUxLp3M8SY+Twb8Y
         jmDo8f9recdvreTf3TWSYZfqhPasXnTtadaG+uaRNFH7tJ63dWn/cDHqacjOchWjdQPK
         sXQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qohOIjLTZ3ihn9x3N6euNmP6rCWo+cb3m1PqDtwjGYs=;
        b=BAWR+j/fOogxtVV6pKO69csEPQ8+fQkk2oDo8qJeTFM4y+n4//FHNEF/1dMkzFPmDa
         Vb4amrR15b6/lBXG7f8zf6YcEnNcSjcxPOllHWgJu9xYhhFrbBH48WqsBcPv2peWiN5U
         bsquqi7UciOuxU12aRwm8QLEEMCYxwySM0vXeJ/cifnRo7suog01dBwF8dXxXb6pGW/V
         ndhrfrdmtTlJjUCYKKKx5C+lDL1Flvf+5xdnwAXjlJG7xTXhEg6lu1BdPlYM6qfZZo0a
         Ce8DU14GWNEHYHpXr5VSZllKzUDi2R09AinArpfA+2qgAgyqP+9DnmBX895zZAvIQ/hM
         vDsg==
X-Gm-Message-State: APjAAAVxdeX9L9SCqi9PWIQK8lIb7oUksfcauP1Xod8f+RE2lVRtYHjo
        OZd5vhHcRyHThQn/aHLTqSKVhnQlEW/HZttMoCmWhg==
X-Google-Smtp-Source: APXvYqzz8/twTxFslwlhiYdMrZakH/5uA7mpoWknVikw32YDRRyZ9rhcW3D4RTA5jZI3Xd6yXaWDGO3CjyGGBx9+Rho=
X-Received: by 2002:a17:902:bb94:: with SMTP id m20mr38692301pls.336.1566479288588;
 Thu, 22 Aug 2019 06:08:08 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000d9f094057a17b97b@google.com> <000000000000b439370586498dff@google.com>
 <CAAeHK+zUHJswwHfVUCV0qTgvFVFZpT0hJqioLyYgbA0yQC0H8Q@mail.gmail.com> <CAAeHK+w+asSQ3axWymToQ+uzPfEAYS2QimVBL85GuJRBtxkjDA@mail.gmail.com>
In-Reply-To: <CAAeHK+w+asSQ3axWymToQ+uzPfEAYS2QimVBL85GuJRBtxkjDA@mail.gmail.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Thu, 22 Aug 2019 15:07:56 +0200
Message-ID: <CAAeHK+y-2DZ1sWUE5bESrd=dUAaGrHXzR5+gFJFgiAaWo+D2dw@mail.gmail.com>
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

On Wed, Aug 7, 2019 at 4:03 PM Andrey Konovalov <andreyknvl@google.com> wrote:
>
> On Fri, Apr 12, 2019 at 1:32 PM Andrey Konovalov <andreyknvl@google.com> wrote:
> >
> > On Fri, Apr 12, 2019 at 1:29 AM syzbot
> > <syzbot+40918e4d826fb2ff9b96@syzkaller.appspotmail.com> wrote:
> > >
> > > syzbot has found a reproducer for the following crash on:
> > >
> > > HEAD commit:    9a33b369 usb-fuzzer: main usb gadget fuzzer driver
> > > git tree:       https://github.com/google/kasan/tree/usb-fuzzer
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=10d552b7200000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=23e37f59d94ddd15
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=40918e4d826fb2ff9b96
> > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17a4c1af200000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=121b274b200000
> > >
> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > Reported-by: syzbot+40918e4d826fb2ff9b96@syzkaller.appspotmail.com
> > >
> > > usb 1-1: r8712u: MAC Address from efuse = 00:e0:4c:87:00:00
> > > usb 1-1: r8712u: Loading firmware from "rtlwifi/rtl8712u.bin"
> > > usb 1-1: USB disconnect, device number 2
> > > usb 1-1: Direct firmware load for rtlwifi/rtl8712u.bin failed with error -2
> > > usb 1-1: r8712u: Firmware request failed
> > > WARNING: CPU: 0 PID: 575 at net/core/dev.c:8152
> > > rollback_registered_many+0x1f3/0xe70 net/core/dev.c:8152
> > > Kernel panic - not syncing: panic_on_warn set ...
> > > CPU: 0 PID: 575 Comm: kworker/0:4 Not tainted 5.1.0-rc4-319354-g9a33b36 #3
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > > Google 01/01/2011
> > > Workqueue: usb_hub_wq hub_event
> > > Call Trace:
> > >   __dump_stack lib/dump_stack.c:77 [inline]
> > >   dump_stack+0xe8/0x16e lib/dump_stack.c:113
> > >   panic+0x29d/0x5f2 kernel/panic.c:214
> > >   __warn.cold+0x20/0x48 kernel/panic.c:571
> > >   report_bug+0x262/0x2a0 lib/bug.c:186
> > >   fixup_bug arch/x86/kernel/traps.c:179 [inline]
> > >   fixup_bug arch/x86/kernel/traps.c:174 [inline]
> > >   do_error_trap+0x130/0x1f0 arch/x86/kernel/traps.c:272
> > >   do_invalid_op+0x37/0x40 arch/x86/kernel/traps.c:291
> > >   invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:973
> > > RIP: 0010:rollback_registered_many+0x1f3/0xe70 net/core/dev.c:8152
> > > Code: 05 00 00 31 ff 44 89 fe e8 5a 15 f3 f4 45 84 ff 0f 85 49 ff ff ff e8
> > > 1c 14 f3 f4 0f 1f 44 00 00 e8 12 14 f3 f4 e8 0d 14 f3 f4 <0f> 0b 4c 89 e7
> > > e8 33 72 f2 f6 31 ff 41 89 c4 89 c6 e8 27 15 f3 f4
> > > RSP: 0018:ffff88809d087698 EFLAGS: 00010293
> > > RAX: ffff88809d058000 RBX: ffff888096240000 RCX: ffffffff8c7eb146
> > > RDX: 0000000000000000 RSI: ffffffff8c7eb163 RDI: 0000000000000001
> > > RBP: ffff88809d0877c8 R08: ffff88809d058000 R09: fffffbfff2708111
> > > R10: fffffbfff2708110 R11: ffffffff93840887 R12: ffff888096240070
> > > R13: dffffc0000000000 R14: ffff88809d087758 R15: 0000000000000000
> > >   rollback_registered+0xf7/0x1c0 net/core/dev.c:8228
> > >   unregister_netdevice_queue net/core/dev.c:9275 [inline]
> > >   unregister_netdevice_queue+0x1dc/0x2b0 net/core/dev.c:9268
> > >   unregister_netdevice include/linux/netdevice.h:2655 [inline]
> > >   unregister_netdev+0x1d/0x30 net/core/dev.c:9316
> > >   r871xu_dev_remove+0xe7/0x223 drivers/staging/rtl8712/usb_intf.c:604
> > >   usb_unbind_interface+0x1c9/0x980 drivers/usb/core/driver.c:423
> > >   __device_release_driver drivers/base/dd.c:1082 [inline]
> > >   device_release_driver_internal+0x436/0x4f0 drivers/base/dd.c:1113
> > >   bus_remove_device+0x302/0x5c0 drivers/base/bus.c:556
> > >   device_del+0x467/0xb90 drivers/base/core.c:2269
> > >   usb_disable_device+0x242/0x790 drivers/usb/core/message.c:1235
> > >   usb_disconnect+0x298/0x870 drivers/usb/core/hub.c:2197
> > >   hub_port_connect drivers/usb/core/hub.c:4940 [inline]
> > >   hub_port_connect_change drivers/usb/core/hub.c:5204 [inline]
> > >   port_event drivers/usb/core/hub.c:5350 [inline]
> > >   hub_event+0xcd2/0x3b00 drivers/usb/core/hub.c:5432
> > >   process_one_work+0x90f/0x1580 kernel/workqueue.c:2269
> > >   process_scheduled_works kernel/workqueue.c:2331 [inline]
> > >   worker_thread+0x7b0/0xe20 kernel/workqueue.c:2417
> > >   kthread+0x313/0x420 kernel/kthread.c:253
> > >   ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
> > > Kernel Offset: disabled
> > > Rebooting in 86400 seconds..
> > >
> >
> > +linux-usb mailing list
>
> This USB bug is the most frequently triggered one right now with over
> 27k kernel crashes.

OK, this report is confusing. It was initially reported on the
upstream instance a long time ago, but since then has stopped
happening, as it was probably fixed. Then when we launched the USB
fuzzing instance, it has started producing similarly named reports
(with a different root cause though), and they were bucketed into this
bug by syzkaller. I've improved parsing titles of such reports in
syzkaller, so I'm invalidating this one, and syzbot should send a
properly attributed USB report soon.

#syz invalid
