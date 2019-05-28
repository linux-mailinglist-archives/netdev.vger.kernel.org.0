Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3CF62CB36
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 18:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfE1QKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 12:10:32 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42336 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726941AbfE1QKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 12:10:32 -0400
Received: by mail-pl1-f196.google.com with SMTP id go2so8520648plb.9
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 09:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wEXLjO7twlBLWsDnRZX4vaTbOKswjo2GYMipIiu7cow=;
        b=iGbxJl150LnJCcI3sy3CJLWA+kzxhoQD1otiMa3pg7VjM5UKcBSFkrb+8B98+WrKnt
         Mva85wYjl2jmvat3XvvZdLigrO4VO1xbO6f41HCOC23MWFfhAiqAMgNZTQf4cuML35y0
         eq7kTkc7EW97Z+dpms9zNZ1/ZzkxPRigMoI8I1TcNJNYZXP2xTjOovJNR06oxqhf9ysa
         wHbi511CwSQtIXu7YF8jG1UnjD9dW70n3Ft82DqxbBCNn93BSL8cw825cYyxqmBwA77F
         5BmjRnjTWNtVAWcuyvp3xWi80xIoe9wjfqBIpBcdDDrIpahT/sntIXFMJFc3818523WW
         Biuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wEXLjO7twlBLWsDnRZX4vaTbOKswjo2GYMipIiu7cow=;
        b=ScPgDBTa0wXa5upR1fjhF38Tyxx7rYt62ou9WtT8MZ/75Ra0FDF5m1jPkv4sHapfut
         2wSOhnO9Ibs7OKSL/HfDGhhNBd35UCdzf2mVo7ZhZJObhZP/1XfoZBSKz+IW227258jg
         35Kk+TUFKCXR96yleqoTVdF4yy0tDbOd/0xSt0RzFHjX4+gRllZbu9IiyWCdwsLV5Gf3
         /hDH+HeXVz/GHelshbAtE0B6SRgjrkUssse+dZBhraPuOBzaLIQ/VwS5NmcHzZgckc79
         RuKj+QN+hEC/5v711zNGTRf45YCibzo03UhKO++YO4d+7Zrz4hhzjBzzJ6trpZxBUjwe
         Dt8Q==
X-Gm-Message-State: APjAAAWbJ0LXwDcvflib70FhoE/oTkeITGm+sDXtGK0uu8tr8Sff5l/+
        VMcSYGoowcBKK1AKr9udAcUXasUBe1RF8edGCBXSkg==
X-Google-Smtp-Source: APXvYqyjZi8ZR9WB1rNh/MG7/BaYTX2xMS56Ei6EVhBDoVgELP3E/L/JPmV5KCdty1OSHtPixSh3qvR5bQDEuxzCvkw=
X-Received: by 2002:a17:902:1566:: with SMTP id b35mr18724410plh.147.1559059830876;
 Tue, 28 May 2019 09:10:30 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000727264058653d9a7@google.com>
In-Reply-To: <000000000000727264058653d9a7@google.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Tue, 28 May 2019 18:10:19 +0200
Message-ID: <CAAeHK+ykfXmn9-6-qcU1rz-hsSpH=n9HU5NSuF+xesX_pShy6w@mail.gmail.com>
Subject: Re: INFO: trying to register non-static key in rtl_c2hcmd_launcher
To:     syzbot <syzbot+1fcc5ef45175fc774231@syzkaller.appspotmail.com>,
        pkshih@realtek.com, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 12, 2019 at 1:46 PM syzbot
<syzbot+1fcc5ef45175fc774231@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    9a33b369 usb-fuzzer: main usb gadget fuzzer driver
> git tree:       https://github.com/google/kasan/tree/usb-fuzzer
> console output: https://syzkaller.appspot.com/x/log.txt?x=14d4c1af200000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=23e37f59d94ddd15
> dashboard link: https://syzkaller.appspot.com/bug?extid=1fcc5ef45175fc774231
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15b6f0f3200000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140c7c2d200000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+1fcc5ef45175fc774231@syzkaller.appspotmail.com
>
> usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> rtl_usb: reg 0xf0, usbctrl_vendorreq TimeOut! status:0xffffffb9 value=0x0
> rtl8192cu: Chip version 0x10
> rtl_usb: reg 0xa, usbctrl_vendorreq TimeOut! status:0xffffffb9 value=0x0
> rtl_usb: Too few input end points found
> INFO: trying to register non-static key.
> the code is fine but needs lockdep annotation.
> turning off the locking correctness validator.
> CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.1.0-rc4-319354-g9a33b36 #3
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Workqueue: usb_hub_wq hub_event
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0xe8/0x16e lib/dump_stack.c:113
>   assign_lock_key kernel/locking/lockdep.c:786 [inline]
>   register_lock_class+0x11b8/0x1250 kernel/locking/lockdep.c:1095
>   __lock_acquire+0xfb/0x37c0 kernel/locking/lockdep.c:3582
>   lock_acquire+0x10d/0x2f0 kernel/locking/lockdep.c:4211
>   __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>   _raw_spin_lock_irqsave+0x44/0x60 kernel/locking/spinlock.c:152
>   rtl_c2hcmd_launcher+0xd1/0x390
> drivers/net/wireless/realtek/rtlwifi/base.c:2344
>   rtl_deinit_core+0x25/0x2d0 drivers/net/wireless/realtek/rtlwifi/base.c:574
>   rtl_usb_probe.cold+0x861/0xa70
> drivers/net/wireless/realtek/rtlwifi/usb.c:1093
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
> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] SMP KASAN PTI
> CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.1.0-rc4-319354-g9a33b36 #3
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Workqueue: usb_hub_wq hub_event
> RIP: 0010:rtl_free_entries_from_scan_list
> drivers/net/wireless/realtek/rtlwifi/base.c:1933 [inline]
> RIP: 0010:rtl_deinit_core+0x84/0x2d0
> drivers/net/wireless/realtek/rtlwifi/base.c:575
> Code: 4c 89 f2 48 c1 ea 03 80 3c 02 00 0f 85 52 02 00 00 4d 8b bc 24 c8 c4
> 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 fa 48 c1 ea 03 <80> 3c 02 00 0f
> 85 22 02 00 00 4d 39 f7 4d 8b 2f 4c 89 ff 0f 84 3d
> RSP: 0018:ffff8880a84b7278 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 1ffffffff27960ab
> RDX: 0000000000000000 RSI: ffffffff88da7445 RDI: ffff888093c00b68
> RBP: ffff888093c00b20 R08: ffff8880a8498000 R09: ffffed101278051d
> R10: ffffed101278051c R11: ffff888093c028e3 R12: ffff888093c02540
> R13: ffff88821add7848 R14: ffff888093c0ea08 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8880ad000000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fd01db19000 CR3: 000000009c01a000 CR4: 00000000001406f0
> Call Trace:
>   rtl_usb_probe.cold+0x861/0xa70
> drivers/net/wireless/realtek/rtlwifi/usb.c:1093
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
> Modules linked in:
> ---[ end trace 38ab7b2a1beef511 ]---
> RIP: 0010:rtl_free_entries_from_scan_list
> drivers/net/wireless/realtek/rtlwifi/base.c:1933 [inline]
> RIP: 0010:rtl_deinit_core+0x84/0x2d0
> drivers/net/wireless/realtek/rtlwifi/base.c:575
> Code: 4c 89 f2 48 c1 ea 03 80 3c 02 00 0f 85 52 02 00 00 4d 8b bc 24 c8 c4
> 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 fa 48 c1 ea 03 <80> 3c 02 00 0f
> 85 22 02 00 00 4d 39 f7 4d 8b 2f 4c 89 ff 0f 84 3d
> RSP: 0018:ffff8880a84b7278 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 1ffffffff27960ab
> RDX: 0000000000000000 RSI: ffffffff88da7445 RDI: ffff888093c00b68
> RBP: ffff888093c00b20 R08: ffff8880a8498000 R09: ffffed101278051d
> R10: ffffed101278051c R11: ffff888093c028e3 R12: ffff888093c02540
> R13: ffff88821add7848 R14: ffff888093c0ea08 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8880ad000000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fd01db19000 CR3: 000000009c01a000 CR4: 00000000001406f0

This is currently the top crasher on the USB syzbot fuzzing instance.

AFAICT the issue is that rtl_usb_probe() can goto error_out and call
rtl_deinit_core()->rtl_c2hcmd_launcher()->spin_lock_irqsave(&rtlpriv->locks.c2hcmd_lock)
before locks.c2hcmd_lock is initialized by rtl_init_core().

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
