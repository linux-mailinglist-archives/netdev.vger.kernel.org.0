Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84DD1F5E3E
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 10:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfKIJeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 04:34:10 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:50248 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbfKIJeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 04:34:10 -0500
Received: by mail-io1-f69.google.com with SMTP id t193so7867182iof.17
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 01:34:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=HJN5dpXp+JxR2Vi/mOdLRgDPgSY/+zHIEh7nQdnXI88=;
        b=XT0suUD7bRbXBAr9uWYMQsupIDNG8h1VyZBZcGummsLdZyw3eFyYRpomdtd88wTDSs
         W2M1Zi24/hriK+OYrv6gIhk9sLxGUEPAZNk6kYOjzdUEQ217WNHyCzwEmJkC7Pn11gq8
         qrvb2llwHmtjFM/3eLpn1lsMc+eDEEwLwceriePcQzNGYrzee0fAGfpaKxtIJXgeuk1V
         ou/bEdA1Eaiq6ZSBWxh9X//3pV22Wf4K5HhJgIeIcO8oJ03208JdlCDBlowoeZ7z3z3f
         HXL+WYM7oiYIsgDs17hjOM35ZZAwjiO9m+20XPVBmxI6Go7YqfPUFdlf784CGt8MqYIF
         wTHA==
X-Gm-Message-State: APjAAAUXglK8X9g3KrKAry6SLI7LZSJHMAPQvCMya4YmK2kaqhOshnJN
        LaVhdFnvCqYkwG6zM6V/3pJbPYdhVkeRrivJL7YII/ZxVWnh
X-Google-Smtp-Source: APXvYqz0ajtUcokhaBDo4+t14JiKDbK361OwmMUltNTQqOyIvOc4nEh/GBcrnZWdD1H0GKdFzW/KAz6/su64w5nPlXYhGnI67is0
MIME-Version: 1.0
X-Received: by 2002:a6b:ee1a:: with SMTP id i26mr902733ioh.202.1573292048755;
 Sat, 09 Nov 2019 01:34:08 -0800 (PST)
Date:   Sat, 09 Nov 2019 01:34:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b1b3090596e699ca@google.com>
Subject: KMSAN: uninit-value in __copy_skb_header (3)
From:   syzbot <syzbot+47c1f21c8f16b76ba687@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, davem@davemloft.net, glider@google.com,
        herbert@gondor.apana.org.au, jakub.kicinski@netronome.com,
        linux-kernel@vger.kernel.org, lirongqing@baidu.com,
        netdev@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp,
        ptalbert@redhat.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    6f88939b kmsan: don't unpoison memory in do_read_cache_pag..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=16f17da2e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9e324dfe9c7b0360
dashboard link: https://syzkaller.appspot.com/bug?extid=47c1f21c8f16b76ba687
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1417c17ce00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17e09b84e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+47c1f21c8f16b76ba687@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in __skb_dst_copy include/net/dst.h:279 [inline]
BUG: KMSAN: uninit-value in skb_dst_copy include/net/dst.h:285 [inline]
BUG: KMSAN: uninit-value in __copy_skb_header+0x2bf/0x720  
net/core/skbuff.c:935
CPU: 0 PID: 11989 Comm: syz-executor450 Not tainted 5.4.0-rc5+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x128/0x220 mm/kmsan/kmsan_report.c:108
  __msan_warning+0x73/0xe0 mm/kmsan/kmsan_instr.c:245
  __skb_dst_copy include/net/dst.h:279 [inline]
  skb_dst_copy include/net/dst.h:285 [inline]
  __copy_skb_header+0x2bf/0x720 net/core/skbuff.c:935
  __skb_clone+0xa2/0x970 net/core/skbuff.c:987
  skb_clone+0x402/0x5d0 net/core/skbuff.c:1455
  do_one_broadcast net/netlink/af_netlink.c:1435 [inline]
  netlink_broadcast_filtered+0xbec/0x1c10 net/netlink/af_netlink.c:1510
  netlink_broadcast+0xf6/0x110 net/netlink/af_netlink.c:1534
  uevent_net_broadcast_untagged lib/kobject_uevent.c:330 [inline]
  kobject_uevent_net_broadcast lib/kobject_uevent.c:408 [inline]
  kobject_uevent_env+0x1c4e/0x27c0 lib/kobject_uevent.c:592
  kobject_uevent+0x6f/0x80 lib/kobject_uevent.c:641
  device_add+0x25a3/0x2df0 drivers/base/core.c:2201
  hci_register_dev+0x61a/0xfd0 net/bluetooth/hci_core.c:3308
  hci_uart_register_dev drivers/bluetooth/hci_ldisc.c:682 [inline]
  hci_uart_set_proto drivers/bluetooth/hci_ldisc.c:706 [inline]
  hci_uart_tty_ioctl+0xe61/0x1140 drivers/bluetooth/hci_ldisc.c:760
  tty_ioctl+0x23e2/0x3100 drivers/tty/tty_io.c:2666
  do_vfs_ioctl+0xea8/0x2c50 fs/ioctl.c:46
  ksys_ioctl fs/ioctl.c:713 [inline]
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl+0x1da/0x270 fs/ioctl.c:718
  __x64_sys_ioctl+0x4a/0x70 fs/ioctl.c:718
  do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
RIP: 0033:0x4412f9
Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 9b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd6393cca8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004412f9
RDX: 0000000000000001 RSI: 00000000400455c8 RDI: 0000000000000003
RBP: 000000000001cbad R08: 00000009004002c8 R09: 00000009004002c8
R10: 00000009004002c8 R11: 0000000000000246 R12: 0000000000402120
R13: 00000000004021b0 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:151 [inline]
  kmsan_internal_poison_shadow+0x60/0x120 mm/kmsan/kmsan.c:134
  kmsan_slab_alloc+0xaa/0x120 mm/kmsan/kmsan_hooks.c:88
  slab_alloc_node mm/slub.c:2799 [inline]
  slab_alloc mm/slub.c:2808 [inline]
  kmem_cache_alloc+0x8d9/0xd20 mm/slub.c:2813
  skb_clone+0x326/0x5d0 net/core/skbuff.c:1448
  do_one_broadcast net/netlink/af_netlink.c:1435 [inline]
  netlink_broadcast_filtered+0xbec/0x1c10 net/netlink/af_netlink.c:1510
  netlink_broadcast+0xf6/0x110 net/netlink/af_netlink.c:1534
  uevent_net_broadcast_untagged lib/kobject_uevent.c:330 [inline]
  kobject_uevent_net_broadcast lib/kobject_uevent.c:408 [inline]
  kobject_uevent_env+0x1c4e/0x27c0 lib/kobject_uevent.c:592
  kobject_uevent+0x6f/0x80 lib/kobject_uevent.c:641
  device_add+0x25a3/0x2df0 drivers/base/core.c:2201
  hci_register_dev+0x61a/0xfd0 net/bluetooth/hci_core.c:3308
  hci_uart_register_dev drivers/bluetooth/hci_ldisc.c:682 [inline]
  hci_uart_set_proto drivers/bluetooth/hci_ldisc.c:706 [inline]
  hci_uart_tty_ioctl+0xe61/0x1140 drivers/bluetooth/hci_ldisc.c:760
  tty_ioctl+0x23e2/0x3100 drivers/tty/tty_io.c:2666
  do_vfs_ioctl+0xea8/0x2c50 fs/ioctl.c:46
  ksys_ioctl fs/ioctl.c:713 [inline]
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl+0x1da/0x270 fs/ioctl.c:718
  __x64_sys_ioctl+0x4a/0x70 fs/ioctl.c:718
  do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
