Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98E6BC3AA9
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfJAQil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:38:41 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38893 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfJAQik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 12:38:40 -0400
Received: by mail-pl1-f193.google.com with SMTP id w8so5275427plq.5
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 09:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LjRIVUxaXCrSIxbGWJHGoDo4fLkBBHBHnXAVTmZ8aiM=;
        b=pkov2Bae5sU8YuIgY8uJoQV4kwxMA7X91SEV+EZx5im6cV/hwcBusbygW5iFP0CFhG
         6JNhqQ5bRG5r5LbS9TqMxAlKrn8S9a5rlib4GMZnWgByWSGsI59MF+6PwKfD58U92lIh
         EtYILnQa/rAVy96wa11Wroc5mx5AYydcV+Fvo67FYlsw3XCGNB5fWMWMELDn8l4dYVNp
         27JcQqctRlUIJW2+lA23IvJObR8JwLDbsMhRnQBBcd3sbU1RqRy1nTrWtfLVkmHsmnkt
         kTs33yx3gpcJlJEWut7Gv6J9QcBaDWK0kvR4hoJqfek3/bDpvgJsnh5rvckwZh6Ibwip
         i6aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LjRIVUxaXCrSIxbGWJHGoDo4fLkBBHBHnXAVTmZ8aiM=;
        b=L0ryD1QyacfDXdfJGNU+DBHXxomtYPkffms9ocX1SJyP7YfJLGwr6Yp99aJVroiwVR
         J5jfMrMCIUodskG+cUmlE7x9xW1lnHKSwv7NnnXeCXqVdR1ckTvhJG7XWMBdVBCMi6BI
         001+cA9ck3jc//uCu1d8INuJMB4cVa8vU88vDe0DqVw0xJT8wgr+coDi+1Pn+WqAexnb
         KkJTHCrhz8zBDteYrz8WoqqtkxSp5q9/Z+iYvKB5gn8aG/dt9lg65WbP6xwu+89wP0yt
         cmzc02QkvXSeGzB6iolFpitETMD6WQbChGIjRKIjkkFlCPPLgpeVGbjHZ7euHoAlghOg
         3koA==
X-Gm-Message-State: APjAAAXg2iYKYWnr6WMZzz/vjBlw/NX718kBygVGQ6FavThe0Oia4lm0
        /Qs483mWkRPbLhZZpra76OQDgBzarzzTm5J8L30/1w==
X-Google-Smtp-Source: APXvYqz8eA2+nkdXATdhm4snuqQqiXDwm1582VhK4FDolzAbqXRskHKauQMej1AdrKCRUJihCPH7hQCMph3opm/hl9I=
X-Received: by 2002:a17:902:9a95:: with SMTP id w21mr26520522plp.336.1569947919398;
 Tue, 01 Oct 2019 09:38:39 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000008e825105865615e3@google.com>
In-Reply-To: <0000000000008e825105865615e3@google.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Tue, 1 Oct 2019 18:38:28 +0200
Message-ID: <CAAeHK+zagOE8PZAOkyq6B3-7s1DquTkJ4K8GwPbywbvpXdFSfw@mail.gmail.com>
Subject: Re: general protection fault in ath6kl_usb_alloc_urb_from_pipe
To:     syzbot <syzbot+ead4037ec793e025e66f@syzkaller.appspotmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 12, 2019 at 4:26 PM syzbot
<syzbot+ead4037ec793e025e66f@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    9a33b369 usb-fuzzer: main usb gadget fuzzer driver
> git tree:       https://github.com/google/kasan/tree/usb-fuzzer
> console output: https://syzkaller.appspot.com/x/log.txt?x=12405cd3200000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=23e37f59d94ddd15
> dashboard link: https://syzkaller.appspot.com/bug?extid=ead4037ec793e025e66f
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11acc1af200000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1344acd3200000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+ead4037ec793e025e66f@syzkaller.appspotmail.com
>
> usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> usb 1-1: config 0 descriptor??
> usb 1-1: string descriptor 0 read error: -71
> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] SMP KASAN PTI
> CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.1.0-rc4-319354-g9a33b36 #3
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Workqueue: usb_hub_wq hub_event
> RIP: 0010:__lock_acquire+0xadc/0x37c0 kernel/locking/lockdep.c:3573
> Code: 00 0f 85 c1 1d 00 00 48 81 c4 10 01 00 00 5b 5d 41 5c 41 5d 41 5e 41
> 5f c3 48 b8 00 00 00 00 00 fc ff df 4c 89 ea 48 c1 ea 03 <80> 3c 02 00 0f
> 85 35 1e 00 00 49 81 7d 00 40 39 01 96 0f 84 e8 f5
> RSP: 0018:ffff8880a84b6f78 EFLAGS: 00010006
> RAX: dffffc0000000000 RBX: ffff8880a849c980 RCX: 0000000000000000
> RDX: 0000000000000003 RSI: 0000000000000000 RDI: 0000000000000001
> RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
> R10: 0000000000000000 R11: ffff8880a849c980 R12: 0000000000000000
> R13: 0000000000000018 R14: 0000000000000001 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffff8880ad000000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000004c6768 CR3: 000000009b83e000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   lock_acquire+0x10d/0x2f0 kernel/locking/lockdep.c:4211
>   __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>   _raw_spin_lock_irqsave+0x44/0x60 kernel/locking/spinlock.c:152
>   ath6kl_usb_alloc_urb_from_pipe+0x49/0x2b0
> drivers/net/wireless/ath/ath6kl/usb.c:135
>   ath6kl_usb_post_recv_transfers.constprop.0+0x233/0x400
> drivers/net/wireless/ath/ath6kl/usb.c:410
>   ath6kl_usb_start_recv_pipes drivers/net/wireless/ath/ath6kl/usb.c:484
> [inline]
>   hif_start drivers/net/wireless/ath/ath6kl/usb.c:682 [inline]
>   ath6kl_usb_power_on+0x8d/0x120 drivers/net/wireless/ath/ath6kl/usb.c:1041
>   ath6kl_hif_power_on drivers/net/wireless/ath/ath6kl/hif-ops.h:136 [inline]
>   ath6kl_core_init drivers/net/wireless/ath/ath6kl/core.c:97 [inline]
>   ath6kl_core_init+0x1b8/0x1060 drivers/net/wireless/ath/ath6kl/core.c:66
>   ath6kl_usb_probe+0xc7f/0x1180 drivers/net/wireless/ath/ath6kl/usb.c:1147
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
> ---[ end trace 4efca44223c9b0b0 ]---
> RIP: 0010:__lock_acquire+0xadc/0x37c0 kernel/locking/lockdep.c:3573
> Code: 00 0f 85 c1 1d 00 00 48 81 c4 10 01 00 00 5b 5d 41 5c 41 5d 41 5e 41
> 5f c3 48 b8 00 00 00 00 00 fc ff df 4c 89 ea 48 c1 ea 03 <80> 3c 02 00 0f
> 85 35 1e 00 00 49 81 7d 00 40 39 01 96 0f 84 e8 f5
> RSP: 0018:ffff8880a84b6f78 EFLAGS: 00010006
> RAX: dffffc0000000000 RBX: ffff8880a849c980 RCX: 0000000000000000
> RDX: 0000000000000003 RSI: 0000000000000000 RDI: 0000000000000001
> RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
> R10: 0000000000000000 R11: ffff8880a849c980 R12: 0000000000000000
> R13: 0000000000000018 R14: 0000000000000001 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffff8880ad000000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000004c6768 CR3: 000000009b83e000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
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

#syz fix: ath6kl: fix a NULL-ptr-deref bug in ath6kl_usb_alloc_urb_from_pipe()

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=39d170b3cb62ba98567f5c4f40c27b5864b304e5
