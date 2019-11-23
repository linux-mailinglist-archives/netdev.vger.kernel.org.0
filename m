Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 689D8107D31
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 06:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfKWFpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 00:45:09 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:42756 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfKWFpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 00:45:09 -0500
Received: by mail-il1-f198.google.com with SMTP id n16so8407746ilm.9
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 21:45:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=LkojqSBqnUQnexhTlqeh98FCBKu7z7iV+YBLwkN9/K4=;
        b=mgjF0hHmR9yYzWhexQ1A8XjNJj6Ahxlbu+OcjgE9jMjzgVRcH7rmk5NBiELNZrUTfB
         lkoqTbJy8NlwfgLJLzeAwQCYAb9rhnkaepfDoOXir4paqOIL0GfkmKjUKNuNgpPq8jC6
         xtTaiPh/nuoUvKDbIu2wpZb2nr13Vr6JCi4fh28WDnaIERvVg8+9kZAOXZt3XVoSyA+j
         cnaHSU48mWIckKO0PUSjsNoLdauoM3tGKVhNrsMJFQx/TdICETwXTO/GQ+vtVNhP5paj
         8SFWKKpGZLlzlcbJI4thr/jbn9Gy716KEsW3WLFexHn2UTWt1a0St3eN8DM0XcxWrN1x
         cj2A==
X-Gm-Message-State: APjAAAXNo/FxXjluXlif/LkRrbMeoXuUD8W9fmFELRx8lZXU1CkKvOCe
        IUrOHpFK92b3GNKYOzfmAKvj+kZHtUxGiVjPdJ2Yd/TwRBL0
X-Google-Smtp-Source: APXvYqyNuQ0NFoZx3tG6qtprLLBOV5ATWkhxh0h/aQI2BODsAZQ/zOZZVipTC3aOa/YHK1CGErJ0uT2ZJWo91bQdqgluBjd6i8F9
MIME-Version: 1.0
X-Received: by 2002:a92:5a45:: with SMTP id o66mr6509329ilb.67.1574487908165;
 Fri, 22 Nov 2019 21:45:08 -0800 (PST)
Date:   Fri, 22 Nov 2019 21:45:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000078348e0597fd08f4@google.com>
Subject: KASAN: use-after-free Read in slip_open
From:   syzbot <syzbot+4d5170758f3762109542@syzkaller.appspotmail.com>
To:     davem@davemloft.net, gregkh@linuxfoundation.org,
        jouni.hogander@unikie.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    af42d346 Linux 5.4-rc8
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=113a01cee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4737c15fc47048f2
dashboard link: https://syzkaller.appspot.com/bug?extid=4d5170758f3762109542
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13d90bbae00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16e529d2e00000

Bisection is inconclusive: the first bad commit could be any of:

6ef35398 rtc: Add Amlogic Virtual Wake RTC
1d74f099 dt-bindings: rtc: add bindings for FlexTimer Module
ed162396 dt-bindings: rtc: new binding for Amlogic VRTC
7b0b551d rtc: fsl-ftm-alarm: add FTM alarm driver
a6f26606 rtc: rv3029: revert error handling patch to rv3029_eeprom_write()
80ba9363 rtc: ds1672: remove unnecessary check
903e259f dt-bindings: rtc: sun6i: Add compatible for H6 RTC
44c638ce rtc: remove superfluous error message
b60ff2cf rtc: sun6i: Add support for H6 RTC
924068e5 rtc: class: add debug message when registration fails
e788771c rtc: pcf2127: convert to devm_rtc_allocate_device
bbfe3a7a rtc: pcf2127: cleanup register and bit defines
cb36cf80 rtc: pcf2123: add proper compatible string
7f43020e rtc: pcf2127: bugfix: read rtc disables watchdog
d5b626e1 rtc: pcf2123: let the core handle range offsetting
0e735eaa rtc: pcf2127: add watchdog feature support
935a7f45 rtc: pcf2123: convert to devm_rtc_allocate_device
03623b4b rtc: pcf2127: add tamper detection support
9a5aeaad rtc: pcf2123: remove useless error path goto
28abbba3 rtc: pcf2127: bugfix: watchdog build dependency
9126a2b1 rtc: pcf2123: rename struct and variables
6fd4fe9b rtc: snvs: fix possible race condition
d3bad602 rtc: pcf2123: stop using dev.platform_data
577f6482 rtc: pcf2123: implement .alarm_irq_enable
79610340 rtc: snvs: set range
c59a9fc7 rtc: snvs: switch to rtc_time64_to_tm/rtc_tm_to_time64
d0ce6ef7 rtc; pcf2123: fix possible alarm race condition
5bdf40da rtc: pcf2123: don't use weekday alarm
7ef66122 rtc: pcf85363/pcf85263: fix regmap error in set_time
59a7f24f rtc: max77686: convert to devm_i2c_new_dummy_device()
faac9102 rtc: Remove dev_err() usage after platform_get_irq()
4053e749 rtc: s35390a: convert to devm_i2c_new_dummy_device()
b0a3fa44 rtc: mxc: use spin_lock_irqsave instead of spin_lock_irq in IRQ  
context
41a8e19f rtc: bd70528: fix driver dependencies
cd646ec0 rtc: pcf8563: add Epson RTC8564 compatible
cb3cab06 rtc: remove w90x900/nuc900 driver
deaa3ff4 rtc: pcf8563: add Microcrystal RV8564 compatible
8d3f805e rtc: pcf8563: convert to devm_rtc_allocate_device
aae364d2 rtc: s5m: convert to i2c_new_dummy_device
c7d5f6db rtc: pcf8563: remove useless indirection
ca83542c rtc: s35390a: convert to i2c_new_dummy_device
7150710f rtc: max77686: convert to i2c_new_dummy_device
f648d40b rtc: pcf8563: let the core handle range offsetting
46eabee1 rtc: isl12026: convert to i2c_new_dummy_device
d76a81d0 rtc: sun6i: Allow using as wakeup source from suspend
4a9eb815 dt-bindings: rtc: ds1307: add rx8130 compatible
56422541 dt-bindings: rtc: Remove the PCF8563 from the trivial RTCs
e02e3dda rtc: sc27xx: Remove clearing SPRD_RTC_POWEROFF_ALM_FLAG flag
f7234a98 rtc: imxdi: use devm_platform_ioremap_resource() to simplify code
874532cd rtc: mxc_v2: use devm_platform_ioremap_resource() to simplify code
b99a3120 rtc: meson: mark PM functions as __maybe_unused
9dbd83f6 Merge tag 'rtc-5.4' of  
git://git.kernel.org/pub/scm/linux/kernel/git/abelloni/linux

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11bbd3bae00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4d5170758f3762109542@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in sl_sync drivers/net/slip/slip.c:725 [inline]
BUG: KASAN: use-after-free in slip_open+0xecd/0x11b7  
drivers/net/slip/slip.c:801
Read of size 8 at addr ffff88809431cb48 by task syz-executor276/8797

CPU: 0 PID: 8797 Comm: syz-executor276 Not tainted 5.4.0-rc8 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:634
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  sl_sync drivers/net/slip/slip.c:725 [inline]
  slip_open+0xecd/0x11b7 drivers/net/slip/slip.c:801
  tty_ldisc_open.isra.0+0xa3/0x110 drivers/tty/tty_ldisc.c:469
  tty_set_ldisc+0x30e/0x6b0 drivers/tty/tty_ldisc.c:596
  tiocsetd drivers/tty/tty_io.c:2334 [inline]
  tty_ioctl+0xe8d/0x14f0 drivers/tty/tty_io.c:2594
  vfs_ioctl fs/ioctl.c:46 [inline]
  file_ioctl fs/ioctl.c:509 [inline]
  do_vfs_ioctl+0xdb6/0x13e0 fs/ioctl.c:696
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441149
Code: e8 5c ae 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 bb 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffcfb9185b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441149
RDX: 0000000020000040 RSI: 0000000000005423 RDI: 0000000000000003
RBP: 00007ffcfb9185d0 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffff
R13: 0000000000000004 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 8796:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:510 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:483
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:524
  __do_kmalloc_node mm/slab.c:3615 [inline]
  __kmalloc_node+0x4e/0x70 mm/slab.c:3622
  kmalloc_node include/linux/slab.h:599 [inline]
  kvmalloc_node+0x68/0x100 mm/util.c:564
  kvmalloc include/linux/mm.h:670 [inline]
  kvzalloc include/linux/mm.h:678 [inline]
  alloc_netdev_mqs+0x98/0xde0 net/core/dev.c:9499
  sl_alloc drivers/net/slip/slip.c:751 [inline]
  slip_open+0x38e/0x11b7 drivers/net/slip/slip.c:812
  tty_ldisc_open.isra.0+0xa3/0x110 drivers/tty/tty_ldisc.c:469
  tty_set_ldisc+0x30e/0x6b0 drivers/tty/tty_ldisc.c:596
  tiocsetd drivers/tty/tty_io.c:2334 [inline]
  tty_ioctl+0xe8d/0x14f0 drivers/tty/tty_io.c:2594
  vfs_ioctl fs/ioctl.c:46 [inline]
  file_ioctl fs/ioctl.c:509 [inline]
  do_vfs_ioctl+0xdb6/0x13e0 fs/ioctl.c:696
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 8796:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  kasan_set_free_info mm/kasan/common.c:332 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:471
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:480
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3756
  kvfree+0x61/0x70 mm/util.c:593
  netdev_freemem net/core/dev.c:9453 [inline]
  free_netdev+0x3c0/0x470 net/core/dev.c:9608
  slip_open+0xd70/0x11b7 drivers/net/slip/slip.c:858
  tty_ldisc_open.isra.0+0xa3/0x110 drivers/tty/tty_ldisc.c:469
  tty_set_ldisc+0x30e/0x6b0 drivers/tty/tty_ldisc.c:596
  tiocsetd drivers/tty/tty_io.c:2334 [inline]
  tty_ioctl+0xe8d/0x14f0 drivers/tty/tty_io.c:2594
  vfs_ioctl fs/ioctl.c:46 [inline]
  file_ioctl fs/ioctl.c:509 [inline]
  do_vfs_ioctl+0xdb6/0x13e0 fs/ioctl.c:696
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff88809431c000
  which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 2888 bytes inside of
  4096-byte region [ffff88809431c000, ffff88809431d000)
The buggy address belongs to the page:
page:ffffea000250c700 refcount:1 mapcount:0 mapping:ffff8880aa402000  
index:0x0 compound_mapcount: 0
raw: 01fffc0000010200 ffffea0002a18b88 ffffea0002a14788 ffff8880aa402000
raw: 0000000000000000 ffff88809431c000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88809431ca00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88809431ca80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88809431cb00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                               ^
  ffff88809431cb80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88809431cc00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
