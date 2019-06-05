Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2914436379
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 20:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfFESmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 14:42:08 -0400
Received: from mail-it1-f198.google.com ([209.85.166.198]:50327 "EHLO
        mail-it1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbfFESmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 14:42:08 -0400
Received: by mail-it1-f198.google.com with SMTP id o128so2521548ita.0
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 11:42:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=3okqULPcAgdoeedd1PDGpImOC3L3SFyDDmY6mEYAMdQ=;
        b=CH8IE8QHebuc41Vs1fQG0TTkDoGewt37H/G7QJd+Z/BBJIcW8VrvcvUdMShLiEMdFq
         jTdid0BmlLx/bj0wLZDPyTN98r/yY4QOxAqQa8wyefF8lKid55ahtlrO3Lqwnnxhw1Pn
         ZFxhYCFnjyk4St+FaUngFynUgQE81pM0ahHXbP3/g9+uPICxTLuELtskV31m0K3DcXDV
         cqeqy8+hgfsVpGZwxum9ec9tyelxqPAWMBstCj4mpZ5/CX3b/ECQGMnBlgV3lfrHvdTx
         drq/CeQF5WuDlWi+mDe/prrHFCApyimGDRbNsWhoOEgrI9FuBMdbUsWDUDbzizp2pRWn
         gbEw==
X-Gm-Message-State: APjAAAXVo49QGXK0qpFwCk9GYnDLYuLCDuxU/4id9MRL6TMCxAGYcsGF
        WrNGK3w5vyDSMnOW9d1cVNvp3+VAD5zKkr/2Qy87nSvyPRYg
X-Google-Smtp-Source: APXvYqwEFmJdggWYL1n939zpSWwWRp+XTc3vYWE5BXtDYnmUdcQJb6IK6F4InNX6cGWQFTFgfPt1ph5OOjamCntrNzXYrpHbxKQE
MIME-Version: 1.0
X-Received: by 2002:a02:1649:: with SMTP id a70mr28077698jaa.116.1559760127379;
 Wed, 05 Jun 2019 11:42:07 -0700 (PDT)
Date:   Wed, 05 Jun 2019 11:42:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000053d7e9058a97f4ca@google.com>
Subject: memory leak in cfserl_create
From:   syzbot <syzbot+7ec324747ce876a29db6@syzkaller.appspotmail.com>
To:     alexios.zavras@intel.com, allison@lohutok.net, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rfontana@redhat.com, swinslow@gmail.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    788a0249 Merge tag 'arc-5.2-rc4' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=123efa5aa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d5c73825cbdc7326
dashboard link: https://syzkaller.appspot.com/bug?extid=7ec324747ce876a29db6
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=171ca536a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+7ec324747ce876a29db6@syzkaller.appspotmail.com

TDEV_CHANGE): hsr_slave_1: link becomes ready
2019/06/05 07:03:42 executed programs: 14
2019/06/05 07:03:48 executed programs: 15
2019/06/05 07:03:56 executed programs: 30
BUG: memory leak
unreferenced object 0xffff88810d22ca00 (size 128):
   comm "syz-executor.1", pid 7571, jiffies 4294948034 (age 9.460s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000d4b3552e>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000d4b3552e>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000d4b3552e>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000d4b3552e>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<00000000409297cb>] kmalloc include/linux/slab.h:547 [inline]
     [<00000000409297cb>] kzalloc include/linux/slab.h:742 [inline]
     [<00000000409297cb>] cfserl_create+0x24/0x76 net/caif/cfserl.c:36
     [<000000000b6ebed9>] caif_device_notify+0x347/0x3bc  
net/caif/caif_dev.c:388
     [<0000000052e58523>] notifier_call_chain+0x66/0xb0 kernel/notifier.c:95
     [<0000000016b2101e>] __raw_notifier_call_chain kernel/notifier.c:396  
[inline]
     [<0000000016b2101e>] raw_notifier_call_chain+0x2e/0x40  
kernel/notifier.c:403
     [<0000000041e2ecf0>] call_netdevice_notifiers_info+0x33/0x70  
net/core/dev.c:1749
     [<00000000f45634e0>] call_netdevice_notifiers_extack  
net/core/dev.c:1761 [inline]
     [<00000000f45634e0>] call_netdevice_notifiers net/core/dev.c:1775  
[inline]
     [<00000000f45634e0>] register_netdevice+0x445/0x600 net/core/dev.c:8734
     [<0000000043f37c7e>] ldisc_open+0x1f7/0x350  
drivers/net/caif/caif_serial.c:359
     [<0000000048b48475>] tty_ldisc_open.isra.0+0x40/0x70  
drivers/tty/tty_ldisc.c:469
     [<000000001b540e53>] tty_set_ldisc+0x149/0x240  
drivers/tty/tty_ldisc.c:596
     [<00000000987d85c0>] tiocsetd drivers/tty/tty_io.c:2332 [inline]
     [<00000000987d85c0>] tty_ioctl+0x366/0xa30 drivers/tty/tty_io.c:2592
     [<00000000bdb74dbb>] vfs_ioctl fs/ioctl.c:46 [inline]
     [<00000000bdb74dbb>] file_ioctl fs/ioctl.c:509 [inline]
     [<00000000bdb74dbb>] do_vfs_ioctl+0x62a/0x810 fs/ioctl.c:696
     [<0000000021ef067c>] ksys_ioctl+0x86/0xb0 fs/ioctl.c:713
     [<00000000d1d65c38>] __do_sys_ioctl fs/ioctl.c:720 [inline]
     [<00000000d1d65c38>] __se_sys_ioctl fs/ioctl.c:718 [inline]
     [<00000000d1d65c38>] __x64_sys_ioctl+0x1e/0x30 fs/ioctl.c:718
     [<000000001056684e>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<0000000010a5606e>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
