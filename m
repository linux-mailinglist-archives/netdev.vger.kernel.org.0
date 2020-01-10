Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A371013764D
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 19:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgAJSoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 13:44:16 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:47414 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728428AbgAJSoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 13:44:12 -0500
Received: by mail-il1-f197.google.com with SMTP id x69so2138673ill.14
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 10:44:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=UtgqWyCMHEbuMc1chkx9FfigMbDl2qVQb2WRO39xvW8=;
        b=GgKi7IuDvyvS8UrzXw2ZAuWP3XjE4kgKBEDl9yb679p0c1fKZLIDgZJco1cio9AsB9
         7/aJSUHFFLqr/bBj4349o8l27lEotAqJtqPsJTGEFaLs9/dIS8Mqp/nQrU6fLgOh/5uW
         1+qS2qIQlw52lsR50fMt6ncyjnOp52sE51VcRUqNIDOKrfqfroGDDDgxpd4xPvbdwduv
         grhmIcAqwYTVVzrtmf/+g69o9GE0lgDA40smEGlm+1vLu73DpUptoQYL5+PkSFIS1/5t
         Ior++RW8HH0lsjOoO2FceFzmcn54DOqfkC7yoWuLdkLIFl5hNse8XPseONYVzlPhFDIQ
         V5bg==
X-Gm-Message-State: APjAAAWQqTTEmtR0egObgwT8Yc1zoCkA5BsbUQeDje3O0+gQCbNf2gNH
        MpGN7UTggrqSi0MrV8nZZqvWJ89WzHgGosjNNh4dUaZfvBGq
X-Google-Smtp-Source: APXvYqz/absesZKveMvYc0mhZ7cQ4Ny4xIv6iOqFCtlPa1fHpSpzkHhTbbUQGL1GiI5GNSBDPPcZOL+G8hHdpLSrUr+ykFDhxjQy
MIME-Version: 1.0
X-Received: by 2002:a02:6a10:: with SMTP id l16mr4151275jac.77.1578681851625;
 Fri, 10 Jan 2020 10:44:11 -0800 (PST)
Date:   Fri, 10 Jan 2020 10:44:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fac92e059bcd82f4@google.com>
Subject: WARNING in set_precision (2)
From:   syzbot <syzbot+6693adf1698864d21734@syzkaller.appspotmail.com>
To:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        johannes@sipsolutions.net, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        mkubecek@suse.cz, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    1ece2fbe ptp: clockmatrix: Rework clockmatrix version info..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1709d58ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ff06bf0a19e7467d
dashboard link: https://syzkaller.appspot.com/bug?extid=6693adf1698864d21734
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15380c66e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=131916aee00000

The bug was bisected to:

commit 2b4a8990b7df55875745a80a609a1ceaaf51f322
Author: Michal Kubecek <mkubecek@suse.cz>
Date:   Fri Dec 27 14:55:18 2019 +0000

     ethtool: introduce ethtool netlink interface

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11c40c66e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=13c40c66e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=15c40c66e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6693adf1698864d21734@syzkaller.appspotmail.com
Fixes: 2b4a8990b7df ("ethtool: introduce ethtool netlink interface")

netlink: 179916 bytes leftover after parsing attributes in process  
`syz-executor273'.
------------[ cut here ]------------
precision 33020 too large
WARNING: CPU: 0 PID: 9618 at lib/vsprintf.c:2471 set_precision+0x150/0x180  
lib/vsprintf.c:2471
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 9618 Comm: syz-executor273 Not tainted 5.5.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  panic+0x2e3/0x75c kernel/panic.c:221
  __warn.cold+0x2f/0x3e kernel/panic.c:582
  report_bug+0x289/0x300 lib/bug.c:195
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  fixup_bug arch/x86/kernel/traps.c:169 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:set_precision+0x150/0x180 lib/vsprintf.c:2471
Code: 24 07 e8 23 30 9f f9 5b 41 5c 41 5d 41 5e 5d c3 e8 15 30 9f f9 89 de  
48 c7 c7 60 c1 f7 88 c6 05 64 4b a1 02 01 e8 5f de 6f f9 <0f> 0b e9 60 ff  
ff ff be 08 00 00 00 4c 89 e7 e8 4c e5 dc f9 e9 04
RSP: 0018:ffffc90001d87280 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 00000000000080fc RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815e8fc6 RDI: fffff520003b0e42
RBP: ffffc90001d872a0 R08: ffff88808d0702c0 R09: fffffbfff165f9ab
R10: fffffbfff165f9aa R11: ffffffff8b2fcd57 R12: ffffc90001d87320
R13: 0000000000000000 R14: ffffc90001d87327 R15: ffffc90001d87360
  vsnprintf+0xa7b/0x19a0 lib/vsprintf.c:2547
  kvasprintf+0xb2/0x170 lib/kasprintf.c:22
  kasprintf+0xbb/0xf0 lib/kasprintf.c:59
  hwsim_del_radio_nl+0x63a/0x7e0 drivers/net/wireless/mac80211_hwsim.c:3625
  genl_family_rcv_msg_doit net/netlink/genetlink.c:672 [inline]
  genl_family_rcv_msg net/netlink/genetlink.c:717 [inline]
  genl_rcv_msg+0x67d/0xea0 net/netlink/genetlink.c:734
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  genl_rcv+0x29/0x40 net/netlink/genetlink.c:745
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:643 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:663
  ____sys_sendmsg+0x753/0x880 net/socket.c:2342
  ___sys_sendmsg+0x100/0x170 net/socket.c:2396
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2429
  __do_sys_sendmsg net/socket.c:2438 [inline]
  __se_sys_sendmsg net/socket.c:2436 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2436
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4401f9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe53b2d788 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004401f9
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401a80
R13: 0000000000401b10 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
