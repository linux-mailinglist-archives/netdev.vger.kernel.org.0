Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8E2D84E3C
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 16:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388028AbfHGOHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 10:07:25 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37132 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387976AbfHGOHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 10:07:24 -0400
Received: by mail-pl1-f194.google.com with SMTP id b3so41037044plr.4
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 07:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L/4uctSN16w5FDnlADERKiGVsjicCimkmW4qcNy8xbg=;
        b=AfHpXxiEPip+Rtb5t/FLGlTsLhvQAqJLJmrat97joDcfH+cATHii2A99mfLWhZWY6S
         2LQwLyV+PSua04urGwtjBFK1evfU3Y2FWqdrqXxJzbJNldkB3/Ww+xYGpw+k/XrzN/aE
         gSVLSu7wXlNkuKTtSUfsVZW7NYdF6U/nQlPmfNLjz98gTRN2YvPKEI7oDNfJDC6Sn7o0
         Gm57lNtX498istNd82QWk3L10iSma1P0FJYpGcO15ekJ5uxhIJ8e6OcE/Keudm+67+ym
         HpAkBi+pxTm4Nsoy9dBlUf1BYcL6cTa6RI+I7C3HM8BaGakCmUP/wEFWNCofBTeB8plV
         EtMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L/4uctSN16w5FDnlADERKiGVsjicCimkmW4qcNy8xbg=;
        b=O2nCFuypFAGNeLWrEo/DaxyzTu6mOkVC2hPrv3zaz2t1IN1Ym06tI143n1f9p+PK0l
         0BK5lhRVPla9lsgpfU5T314weijvNGSJ3Qk1Z0qc5PTQEqPLBY72AMPoNeym+RJL+syW
         UUsm3ihbtdDXjpUae8KkdUdjc3SoYsn4HbQQe5hUgyS5Lh5e1rhFr64bqIy3z+I5qRDl
         E4yRu3BTA+6jJ5nzikkrTYgAThL0o8DsfRzhx4QWdfTOuBKqJlkSIyL5IYfk+OHT+287
         i41ee8pb2zCHycVuvnw0HTLRlL5yPjPWUtU9RTMFKSrMbl3wMd8fIZEnmw88tFmIZz5E
         MJpA==
X-Gm-Message-State: APjAAAVAq8EVHEfALKP/OUzcuz6T3jbhyiXfzfGq4gL1FwLdtnWZaI8H
        q/Ut75bhsSVpu5YHx39zaEX1NPRTMHCeWYGByGR6BA==
X-Google-Smtp-Source: APXvYqy3F+/wIlgU3h+8CDWNKewl1Ci0/BoPT91G/t/z/eG5zxmKdluF99yVq1pwZEMyKpEzO3y5b6OMeUpp2z7iSIA=
X-Received: by 2002:a17:902:ab96:: with SMTP id f22mr1612218plr.147.1565186843588;
 Wed, 07 Aug 2019 07:07:23 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000075a7a6058653d977@google.com>
In-Reply-To: <00000000000075a7a6058653d977@google.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Wed, 7 Aug 2019 16:07:12 +0200
Message-ID: <CAAeHK+zW61WK67wcwhXVCuU0dx_PicpiXmbDCPtJzX-viQ2R0A@mail.gmail.com>
Subject: Re: WARNING in zd_mac_clear
To:     syzbot <syzbot+74c65761783d66a9c97c@syzkaller.appspotmail.com>,
        USB list <linux-usb@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 12, 2019 at 1:46 PM syzbot
<syzbot+74c65761783d66a9c97c@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    9a33b369 usb-fuzzer: main usb gadget fuzzer driver
> git tree:       https://github.com/google/kasan/tree/usb-fuzzer
> console output: https://syzkaller.appspot.com/x/log.txt?x=101a06dd200000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=23e37f59d94ddd15
> dashboard link: https://syzkaller.appspot.com/bug?extid=74c65761783d66a9c97c
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1170c22d200000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1496adbb200000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+74c65761783d66a9c97c@syzkaller.appspotmail.com
>
> usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> usb 1-1: config 0 descriptor??
> usb 1-1: reset low-speed USB device number 2 using dummy_hcd
> usb 1-1: read over firmware interface failed: -71
> usb 1-1: reset low-speed USB device number 2 using dummy_hcd
> WARNING: CPU: 1 PID: 21 at drivers/net/wireless/zydas/zd1211rw/zd_mac.c:238
> zd_mac_clear+0xb0/0xe0 drivers/net/wireless/zydas/zd1211rw/zd_mac.c:238
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 1 PID: 21 Comm: kworker/1:1 Not tainted 5.1.0-rc4-319354-g9a33b36 #3
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Workqueue: usb_hub_wq hub_event
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0xe8/0x16e lib/dump_stack.c:113
>   panic+0x29d/0x5f2 kernel/panic.c:214
>   __warn.cold+0x20/0x48 kernel/panic.c:571
>   report_bug+0x262/0x2a0 lib/bug.c:186
>   fixup_bug arch/x86/kernel/traps.c:179 [inline]
>   fixup_bug arch/x86/kernel/traps.c:174 [inline]
>   do_error_trap+0x130/0x1f0 arch/x86/kernel/traps.c:272
>   do_invalid_op+0x37/0x40 arch/x86/kernel/traps.c:291
>   invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:973
> RIP: 0010:zd_mac_clear+0xb0/0xe0
> drivers/net/wireless/zydas/zd1211rw/zd_mac.c:238
> Code: e8 85 d0 60 f8 48 8d bb f8 2b 00 00 be ff ff ff ff e8 54 5a 46 f8 31
> ff 89 c3 89 c6 e8 d9 d1 60 f8 85 db 75 d4 e8 60 d0 60 f8 <0f> 0b 5b 5d e9
> 57 d0 60 f8 48 c7 c7 58 05 cb 93 e8 fb e0 97 f8 eb
> RSP: 0018:ffff8880a85c7310 EFLAGS: 00010293
> RAX: ffff8880a84de200 RBX: 0000000000000000 RCX: ffffffff8910f507
> RDX: 0000000000000000 RSI: ffffffff8910f510 RDI: 0000000000000005
> RBP: 0000000000000001 R08: ffff8880a84de200 R09: ffffed1012f83a0b
> R10: ffffed1012f83a0a R11: ffff888097c1d057 R12: 00000000ffffffb9
> R13: ffff888097c18b20 R14: ffff888099456630 R15: ffffffff8f979398
>   probe+0x259/0x590 drivers/net/wireless/zydas/zd1211rw/zd_usb.c:1421
>   usb_probe_interface+0x31d/0x820 drivers/usb/core/driver.c:361
>   really_probe+0x2da/0xb10 drivers/base/dd.c:509
>   driver_probe_device+0x21d/0x350 drivers/base/dd.c:671
>   __device_attach_driver+0x1d8/0x290 drivers/base/dd.c:778
>   bus_for_each_drv+0x163/0x1e0 drivers/base/bus.c:454
>   __device_attach+0x223/0x3a0 drivers/base/dd.c:844
>   bus_probe_device+0x1f1/0x2a0 drivers/base/bus.c:514
>   device_add+0xad2/0x16e0 drivers/base/core.c:2106
>   usb_set_configuration+0xdf7/0x1740 drivers/usb/core/message.c:2021
>   generic_probe+0xa2/0xda drivers/usb/core/generic.c:210
>   usb_probe_device+0xc0/0x150 drivers/usb/core/driver.c:266
>   really_probe+0x2da/0xb10 drivers/base/dd.c:509
>   driver_probe_device+0x21d/0x350 drivers/base/dd.c:671
>   __device_attach_driver+0x1d8/0x290 drivers/base/dd.c:778
>   bus_for_each_drv+0x163/0x1e0 drivers/base/bus.c:454
>   __device_attach+0x223/0x3a0 drivers/base/dd.c:844
>   bus_probe_device+0x1f1/0x2a0 drivers/base/bus.c:514
>   device_add+0xad2/0x16e0 drivers/base/core.c:2106
>   usb_new_device.cold+0x537/0xccf drivers/usb/core/hub.c:2534
>   hub_port_connect drivers/usb/core/hub.c:5089 [inline]
>   hub_port_connect_change drivers/usb/core/hub.c:5204 [inline]
>   port_event drivers/usb/core/hub.c:5350 [inline]
>   hub_event+0x138e/0x3b00 drivers/usb/core/hub.c:5432
>   process_one_work+0x90f/0x1580 kernel/workqueue.c:2269
>   worker_thread+0x9b/0xe20 kernel/workqueue.c:2415
>   kthread+0x313/0x420 kernel/kthread.c:253
>   ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
> Kernel Offset: disabled
> Rebooting in 86400 seconds..

This USB bug is the second most frequently triggered one with over 10k
kernel crashes.

>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
