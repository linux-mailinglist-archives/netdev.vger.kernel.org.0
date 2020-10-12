Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B09128B60F
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 15:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbgJLNVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 09:21:25 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:38501 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727502AbgJLNVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 09:21:24 -0400
Received: by mail-il1-f198.google.com with SMTP id p17so12576696ilb.5
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 06:21:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=7Z6adHB6iiE50ME5jgXJ1GMZydlGjJsbWFTrhmRv32M=;
        b=rBZW9twzFIPFgYpXuTr/xdpLaw0OT3MVz9/n5qslJ3aULl5XFXPCkW+9NedgeLuecc
         mtDa+DDN7v/nFUQqdD8rZ8rBJ2Nh6iQBMY5JJAv8JN01N3sRJOmubKvf6mRfgkv5X3qH
         pSveNYkXWrWDUtBeE58Dw5jJ+NXAWYqscrdmbpOH6uYqRhq61PnBkwZ22Wkw7nXVuZ48
         o7CirELXBcu576cXVlSRplZ0y/iecQNP+LelegZ8b8b4y2/roMpnZB12DKCwvFhGNZYV
         Fi1L4q5/YZKQBRyTRBEzB+eVW1pheQJRK1bk0p8XbcT9l/dDLCrUdJu7weLhQBpHxmsO
         /lNA==
X-Gm-Message-State: AOAM532fY1HMTzHVPisi5Nkvrq9Dmw9+eL5m4zoIXuCbSiRF0QEh7nJU
        jXW8ryZ5JMKCyACOnFdxPwhLUZP+SDcTzG7nVo73cdYFsP99
X-Google-Smtp-Source: ABdhPJy0c29nx/xk7zaSu9U3AKcDKmqVE2M0FWxALgmOiu88PLU3VvaUx9qSjKfN9cRBh09F0AecfALyD48S6zI7/En8rH85ypkn
MIME-Version: 1.0
X-Received: by 2002:a92:910:: with SMTP id y16mr18572381ilg.254.1602508883752;
 Mon, 12 Oct 2020 06:21:23 -0700 (PDT)
Date:   Mon, 12 Oct 2020 06:21:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c3fd7d05b1792ca0@google.com>
Subject: WARNING in drv_remove_interface
From:   syzbot <syzbot+2e5c1e55b9e5c28a3da7@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    874fb9e2 ipv4: Restore flowi4_oif update before call to xf..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=137f6078500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c06bcf3cc963d91c
dashboard link: https://syzkaller.appspot.com/bug?extid=2e5c1e55b9e5c28a3da7
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=156cf31b900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15e110ab900000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17c9459f900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1429459f900000
console output: https://syzkaller.appspot.com/x/log.txt?x=1029459f900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2e5c1e55b9e5c28a3da7@syzkaller.appspotmail.com

------------[ cut here ]------------
wlan0: Failed check-sdata-in-driver check, flags: 0x4
WARNING: CPU: 1 PID: 12353 at net/mac80211/driver-ops.c:97 drv_remove_interface+0x3b7/0x4b0 net/mac80211/driver-ops.c:97
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 12353 Comm: syz-executor404 Not tainted 5.9.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 panic+0x382/0x7fb kernel/panic.c:231
 __warn.cold+0x20/0x4b kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:drv_remove_interface+0x3b7/0x4b0 net/mac80211/driver-ops.c:97
Code: 00 00 48 85 db 0f 84 91 00 00 00 e8 83 08 b7 f9 48 89 dd e8 7b 08 b7 f9 44 89 ea 48 89 ee 48 c7 c7 20 d2 5e 89 e8 6b 45 87 f9 <0f> 0b e9 a8 fd ff ff e8 5d 08 b7 f9 0f 0b e9 d4 fc ff ff e8 51 08
RSP: 0018:ffffc9000a407770 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff8880945bc000 RCX: 0000000000000000
RDX: ffff8880a3d28140 RSI: ffffffff815f5a55 RDI: fffff52001480ee0
RBP: ffff8880945bc000 R08: 0000000000000001 R09: ffff8880ae5318e7
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8880859e0c80
R13: 0000000000000004 R14: ffff8880945bd250 R15: 000000000000000f
 ieee80211_do_stop+0x103c/0x2100 net/mac80211/iface.c:1054
 ieee80211_stop+0x1a/0x20 net/mac80211/iface.c:1081
 __dev_close_many+0x1b3/0x2e0 net/core/dev.c:1605
 __dev_close net/core/dev.c:1617 [inline]
 __dev_change_flags+0x2cb/0x730 net/core/dev.c:8346
 dev_change_flags+0x8a/0x160 net/core/dev.c:8419
 devinet_ioctl+0x14fd/0x1ca0 net/ipv4/devinet.c:1143
 inet_ioctl+0x1ea/0x330 net/ipv4/af_inet.c:967
 packet_ioctl+0xad/0x260 net/packet/af_packet.c:4144
 sock_do_ioctl+0xcb/0x2d0 net/socket.c:1047
 sock_ioctl+0x3b8/0x730 net/socket.c:1198
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x44cd69
Code: e8 1c e6 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 1b 02 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fa19e2fbce8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000006eaa08 RCX: 000000000044cd69
RDX: 0000000020001000 RSI: 0000000000008914 RDI: 0000000000000003
RBP: 00000000006eaa00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006eaa0c
R13: 00007fff5b3daaff R14: 00007fa19e2fc9c0 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
