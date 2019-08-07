Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3F1F84EA6
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 16:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388197AbfHGOYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 10:24:33 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:47336 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387523AbfHGOYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 10:24:33 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4988D60D35; Wed,  7 Aug 2019 14:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565187872;
        bh=TqtXjvA2wys2lfRDwlvy5cmn7QfUdRI/dG4BW9afB0U=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=fBsaSif4hsdkDInR7tBbq2VjdMzqZKU7kTiZu2qzNwRbsGlgRK5QT3rynx1fFKe/S
         6EfEGf9I77lNahiT6WYmQfVkB9iqYp59Rma31Md6DmKZF95PaW6tNP4EmXqh71Uyt7
         E6BzQ1phFFpUeffZDaXZyrVLSq3v9j8g0igtbL0s=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D8EBA60A50;
        Wed,  7 Aug 2019 14:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565187861;
        bh=TqtXjvA2wys2lfRDwlvy5cmn7QfUdRI/dG4BW9afB0U=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=hf3M+D7QOGDj0cYAxjj2gENhaH8OaWy82MwWW7LeLwU5+g8fRv6xDaRGQU6ZKBTGf
         PMaeTDnua2YdCpLJawSv/LDwwQrDZtlTvW1r/6EJ8q7bfov1NJbMrd9XyaBkviNjco
         Ho2MdKAdvSgmD65eob0Sx5Fm+gGkT3xAv6TRZaVc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D8EBA60A50
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Andrey Konovalov <andreyknvl@google.com>,
        syzbot <syzbot+74c65761783d66a9c97c@syzkaller.appspotmail.com>,
        USB list <linux-usb@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Daniel Drake <dsd@gentoo.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: WARNING in zd_mac_clear
References: <00000000000075a7a6058653d977@google.com>
        <CAAeHK+zW61WK67wcwhXVCuU0dx_PicpiXmbDCPtJzX-viQ2R0A@mail.gmail.com>
        <1565187539.15973.6.camel@suse.com>
Date:   Wed, 07 Aug 2019 17:24:16 +0300
In-Reply-To: <1565187539.15973.6.camel@suse.com> (Oliver Neukum's message of
        "Wed, 07 Aug 2019 16:18:59 +0200")
Message-ID: <87lfw5dpf3.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oliver Neukum <oneukum@suse.com> writes:

> Am Mittwoch, den 07.08.2019, 16:07 +0200 schrieb Andrey Konovalov:
>> On Fri, Apr 12, 2019 at 1:46 PM syzbot
>> <syzbot+74c65761783d66a9c97c@syzkaller.appspotmail.com> wrote:
>> > 
>> > Hello,
>> > 
>> > syzbot found the following crash on:
>> > 
>> > HEAD commit:    9a33b369 usb-fuzzer: main usb gadget fuzzer driver
>> > git tree:       https://github.com/google/kasan/tree/usb-fuzzer
>> > console output: https://syzkaller.appspot.com/x/log.txt?x=101a06dd200000
>> > kernel config:  https://syzkaller.appspot.com/x/.config?x=23e37f59d94ddd15
>> > dashboard link: https://syzkaller.appspot.com/bug?extid=74c65761783d66a9c97c
>> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1170c22d200000
>> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1496adbb200000
>> > 
>> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> > Reported-by: syzbot+74c65761783d66a9c97c@syzkaller.appspotmail.com
>> > 
>> > usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>> > usb 1-1: config 0 descriptor??
>> > usb 1-1: reset low-speed USB device number 2 using dummy_hcd
>> > usb 1-1: read over firmware interface failed: -71
>> > usb 1-1: reset low-speed USB device number 2 using dummy_hcd
>> > WARNING: CPU: 1 PID: 21 at drivers/net/wireless/zydas/zd1211rw/zd_mac.c:238
>> > zd_mac_clear+0xb0/0xe0 drivers/net/wireless/zydas/zd1211rw/zd_mac.c:238
>> > Kernel panic - not syncing: panic_on_warn set ...
>> > CPU: 1 PID: 21 Comm: kworker/1:1 Not tainted 5.1.0-rc4-319354-g9a33b36 #3
>> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
>> > Google 01/01/2011
>> > Workqueue: usb_hub_wq hub_event
>> > Call Trace:
>> >   __dump_stack lib/dump_stack.c:77 [inline]
>> >   dump_stack+0xe8/0x16e lib/dump_stack.c:113
>> >   panic+0x29d/0x5f2 kernel/panic.c:214
>> >   __warn.cold+0x20/0x48 kernel/panic.c:571
>> >   report_bug+0x262/0x2a0 lib/bug.c:186
>> >   fixup_bug arch/x86/kernel/traps.c:179 [inline]
>> >   fixup_bug arch/x86/kernel/traps.c:174 [inline]
>> >   do_error_trap+0x130/0x1f0 arch/x86/kernel/traps.c:272
>> >   do_invalid_op+0x37/0x40 arch/x86/kernel/traps.c:291
>> >   invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:973
>> > RIP: 0010:zd_mac_clear+0xb0/0xe0
>> > drivers/net/wireless/zydas/zd1211rw/zd_mac.c:238
>> > Code: e8 85 d0 60 f8 48 8d bb f8 2b 00 00 be ff ff ff ff e8 54 5a 46 f8 31
>> > ff 89 c3 89 c6 e8 d9 d1 60 f8 85 db 75 d4 e8 60 d0 60 f8 <0f> 0b 5b 5d e9
>> > 57 d0 60 f8 48 c7 c7 58 05 cb 93 e8 fb e0 97 f8 eb
>> > RSP: 0018:ffff8880a85c7310 EFLAGS: 00010293
>> > RAX: ffff8880a84de200 RBX: 0000000000000000 RCX: ffffffff8910f507
>> > RDX: 0000000000000000 RSI: ffffffff8910f510 RDI: 0000000000000005
>> > RBP: 0000000000000001 R08: ffff8880a84de200 R09: ffffed1012f83a0b
>> > R10: ffffed1012f83a0a R11: ffff888097c1d057 R12: 00000000ffffffb9
>> > R13: ffff888097c18b20 R14: ffff888099456630 R15: ffffffff8f979398
>> >   probe+0x259/0x590 drivers/net/wireless/zydas/zd1211rw/zd_usb.c:1421
>> >   usb_probe_interface+0x31d/0x820 drivers/usb/core/driver.c:361
>> >   really_probe+0x2da/0xb10 drivers/base/dd.c:509
>> >   driver_probe_device+0x21d/0x350 drivers/base/dd.c:671
>> >   __device_attach_driver+0x1d8/0x290 drivers/base/dd.c:778
>> >   bus_for_each_drv+0x163/0x1e0 drivers/base/bus.c:454
>> >   __device_attach+0x223/0x3a0 drivers/base/dd.c:844
>> >   bus_probe_device+0x1f1/0x2a0 drivers/base/bus.c:514
>> >   device_add+0xad2/0x16e0 drivers/base/core.c:2106
>> >   usb_set_configuration+0xdf7/0x1740 drivers/usb/core/message.c:2021
>> >   generic_probe+0xa2/0xda drivers/usb/core/generic.c:210
>> >   usb_probe_device+0xc0/0x150 drivers/usb/core/driver.c:266
>> >   really_probe+0x2da/0xb10 drivers/base/dd.c:509
>> >   driver_probe_device+0x21d/0x350 drivers/base/dd.c:671
>> >   __device_attach_driver+0x1d8/0x290 drivers/base/dd.c:778
>> >   bus_for_each_drv+0x163/0x1e0 drivers/base/bus.c:454
>> >   __device_attach+0x223/0x3a0 drivers/base/dd.c:844
>> >   bus_probe_device+0x1f1/0x2a0 drivers/base/bus.c:514
>> >   device_add+0xad2/0x16e0 drivers/base/core.c:2106
>> >   usb_new_device.cold+0x537/0xccf drivers/usb/core/hub.c:2534
>> >   hub_port_connect drivers/usb/core/hub.c:5089 [inline]
>> >   hub_port_connect_change drivers/usb/core/hub.c:5204 [inline]
>> >   port_event drivers/usb/core/hub.c:5350 [inline]
>> >   hub_event+0x138e/0x3b00 drivers/usb/core/hub.c:5432
>> >   process_one_work+0x90f/0x1580 kernel/workqueue.c:2269
>> >   worker_thread+0x9b/0xe20 kernel/workqueue.c:2415
>> >   kthread+0x313/0x420 kernel/kthread.c:253
>> >   ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
>> > Kernel Offset: disabled
>> > Rebooting in 86400 seconds..
>> 
>> This USB bug is the second most frequently triggered one with over 10k
>> kernel crashes.
>
> As far as I can tell this is a false positive. Didn't I submit this
> upstream?
>
> #syz test: https://github.com/google/kasan.git 9a33b369
>
> From ae999d5a437850b65497df7dcca3ffc10f75e697 Mon Sep 17 00:00:00 2001
> From: Oliver Neukum <oneukum@suse.com>
> Date: Tue, 30 Jul 2019 15:59:03 +0200
> Subject: [PATCH] zdnet: remove false assertion from zd_mac_clear()
>
> The function is called before the lock which is asserted was ever used.
> Just remove it.
>
> Reported-by: syzbot+74c65761783d66a9c97c@syzkaller.appspotmail.com
> Signed-off-by: Oliver Neukum <oneukum@suse.com>

Neither google nor patchwork[1] can find the patch. If you think the
patch should be applied, please resubmit it to linux-wireless so
patchwork sees it. Also the title prefix should be "zd1211rw:", not
"zdnet:".

[1] https://patchwork.kernel.org/project/linux-wireless/list/

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
