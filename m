Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B333019CEB0
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 04:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390428AbgDCC1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 22:27:08 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:39785 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390376AbgDCC1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 22:27:08 -0400
Received: by mail-il1-f199.google.com with SMTP id w76so5442892ila.6
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 19:27:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ldIUD6GXlOztVQ20FlFoahBnQnEqE9wDJgWCVkrMhlo=;
        b=dNbCNsu+jOksTpotKbbJGQ9TMfFedZEWEeYOw+IAgVo4piHzZDe+DHkDzEj+YzaauT
         SfFTfL51Mxrzcn+RTs7zdkDfNfj+JExjUhC6/9HYcVxhKV5WX0c7uSA4/nbEdQ4+MrgX
         o/7bBpXVS9BSN+923UYU1lqdGc4qk6fkRDTaA694wTSKrTmtY2DdW0WdJ+UC6a435TDh
         pKTqzfr2TwgpSPsU85mWmmUti1iBqAOgEj3rAhduuCRx2rMqg+0YcdPSSETsrwSR6B8T
         MLTsZ58iQ/0V46Dkz9LQET0NSFFwr2645e9YQ7iJIAfyO8ADE6cJnubs0Tca88sNh4sS
         6PlA==
X-Gm-Message-State: AGi0PuYyqJhCiK4nZ8JWQc9fi8PBHyMjNxrcp5nEP9aGv3b72aGLQfg9
        gtpv706IJEWjiyF4iH62kmYV+OXKOYmbMLYFxBlDfbXwH/lV
X-Google-Smtp-Source: APiQypK4wgeO0JlZsmZDRmKPB6/9EMhs9brN5yIWeIeGyl9FEPhb1hMfFOamL1fEzgFKq+AYua+vHc4IYPgb6rEaEaxvor7w60ik
MIME-Version: 1.0
X-Received: by 2002:a6b:6c01:: with SMTP id a1mr5756126ioh.196.1585880825022;
 Thu, 02 Apr 2020 19:27:05 -0700 (PDT)
Date:   Thu, 02 Apr 2020 19:27:05 -0700
In-Reply-To: <CADG63jAUxAFXRpxeyQodbt5kPouvfd+XoaXWWawd3kVMwMWwxg@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003b4ce705a259a70f@google.com>
Subject: Re: general protection fault in ath9k_hif_usb_rx_cb
From:   syzbot <syzbot+40d5d2e8a4680952f042@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, anenbupt@gmail.com,
        ath9k-devel@qca.qualcomm.com, davem@davemloft.net,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer still triggered crash:
general protection fault in ath9k_hif_usb_rx_cb

general protection fault, probably for non-canonical address 0xdffffc0000000015: 0000 [#1] SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000000a8-0x00000000000000af]
CPU: 0 PID: 3247 Comm: kworker/0:5 Not tainted 5.6.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: usb_hub_wq hub_event
RIP: 0010:usb_get_intfdata include/linux/usb.h:265 [inline]
RIP: 0010:ath9k_hif_usb_rx_cb+0x103/0xf70 drivers/net/wireless/ath/ath9k/hif_usb.c:643
Code: 83 3c 24 00 48 89 c3 0f 84 19 04 00 00 e8 25 bb 6e fe 48 8d bb a8 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 27 0c 00 00 4c 8b a3 a8 00 00 00 4d 85 e4 0f 84
RSP: 0018:ffff8881db209930 EFLAGS: 00010002
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff835ef3fc
RDX: 0000000000000015 RSI: ffffffff82d09cfb RDI: 00000000000000a8
RBP: ffff8881c6aa1100 R08: ffff8881bda26200 R09: ffffed103b115045
R10: ffffed103b115044 R11: ffff8881d88a8223 R12: 00000000ffffffb9
R13: ffff8881d4d98000 R14: ffff8881c6aa1100 R15: ffff8881c6aa1100
FS:  0000000000000000(0000) GS:ffff8881db200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000076c061 CR3: 00000001bdacb000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
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
RIP: 0010:lock_is_held_type+0x1ce/0x240 kernel/locking/lockdep.c:4526
Code: 89 f9 48 c1 e9 03 0f b6 0c 11 48 89 fa 83 e2 07 83 c2 03 38 ca 7c 04 84 c9 75 6e c7 83 4c 08 00 00 00 00 00 00 ff 74 24 08 9d <48> 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f c3 31 c0 eb a8 48 83 c4
RSP: 0018:ffff8881cc707698 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000001 RBX: ffff8881bda26200 RCX: 0000000000000000
RDX: 0000000000000007 RSI: ffffffff871e1540 RDI: ffff8881bda26a4c
RBP: ffff8881bda26200 R08: ffff8881bda26200 R09: fffffbfff0e3c29d
R10: ffff8881cc707830 R11: ffffffff871e14e7 R12: ffff8881bda26a48
R13: ffffed1037b44d49 R14: ffffffff871e1540 R15: ffff8881bda26af0
 lock_is_held include/linux/lockdep.h:361 [inline]
 kernfs_active+0xb3/0xf0 fs/kernfs/dir.c:29
 __kernfs_remove fs/kernfs/dir.c:1301 [inline]
 __kernfs_remove+0x173/0x9b0 fs/kernfs/dir.c:1282
 kernfs_remove_by_name_ns+0x51/0xb0 fs/kernfs/dir.c:1516
 kernfs_remove_by_name include/linux/kernfs.h:586 [inline]
 remove_files.isra.0+0x76/0x190 fs/sysfs/group.c:27
 sysfs_remove_group+0xb3/0x1b0 fs/sysfs/group.c:288
 sysfs_remove_groups fs/sysfs/group.c:312 [inline]
 sysfs_remove_groups+0x5c/0xa0 fs/sysfs/group.c:304
 device_remove_groups drivers/base/core.c:1602 [inline]
 device_remove_attrs+0xa9/0x150 drivers/base/core.c:1784
 device_del+0x479/0xd30 drivers/base/core.c:2676
 device_unregister+0x22/0xc0 drivers/base/core.c:2709
 usb_remove_ep_devs+0x3e/0x80 drivers/usb/core/endpoint.c:215
 remove_intf_ep_devs+0x108/0x1d0 drivers/usb/core/message.c:1113
 usb_disable_device+0x235/0x790 drivers/usb/core/message.c:1237
 usb_disconnect+0x293/0x900 drivers/usb/core/hub.c:2211
 hub_port_connect drivers/usb/core/hub.c:5046 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5335 [inline]
 port_event drivers/usb/core/hub.c:5481 [inline]
 hub_event+0x1a1d/0x4300 drivers/usb/core/hub.c:5563
 process_one_work+0x94b/0x1620 kernel/workqueue.c:2266
 worker_thread+0x96/0xe20 kernel/workqueue.c:2412
 kthread+0x318/0x420 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace 37b88c5796d54927 ]---
RIP: 0010:usb_get_intfdata include/linux/usb.h:265 [inline]
RIP: 0010:ath9k_hif_usb_rx_cb+0x103/0xf70 drivers/net/wireless/ath/ath9k/hif_usb.c:643
Code: 83 3c 24 00 48 89 c3 0f 84 19 04 00 00 e8 25 bb 6e fe 48 8d bb a8 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 27 0c 00 00 4c 8b a3 a8 00 00 00 4d 85 e4 0f 84
RSP: 0018:ffff8881db209930 EFLAGS: 00010002
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff835ef3fc
RDX: 0000000000000015 RSI: ffffffff82d09cfb RDI: 00000000000000a8
RBP: ffff8881c6aa1100 R08: ffff8881bda26200 R09: ffffed103b115045
R10: ffffed103b115044 R11: ffff8881d88a8223 R12: 00000000ffffffb9
R13: ffff8881d4d98000 R14: ffff8881c6aa1100 R15: ffff8881c6aa1100
FS:  0000000000000000(0000) GS:ffff8881db200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000076c061 CR3: 00000001bdacb000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


Tested on:

commit:         0fa84af8 Merge tag 'usb-serial-5.7-rc1' of https://git.ker..
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=14c6c02be00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a782c087b1f425c6
dashboard link: https://syzkaller.appspot.com/bug?extid=40d5d2e8a4680952f042
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=125bf733e00000

