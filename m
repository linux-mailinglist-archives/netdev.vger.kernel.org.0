Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E14311968
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbhBFDEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 22:04:31 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:32828 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbhBFCvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:51:10 -0500
Received: by mail-il1-f197.google.com with SMTP id k5so8021579ilu.0
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 18:50:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=VsiGLxe2e7ZTfooYEbo1itR42rh9SSIAHwtJBDBn774=;
        b=mRKu1Xh6N7VlHy8lFqoJDX+4Xs76+y5QufFtltbiDfJfTBeuiQCAQKa5PQDgYqtDb+
         LrEK4uCN1n5y7TQWwt/0FtR//6pNoE3ENYMBXee5IzXlI8xmmjkjHYtbZJacaltjKP5j
         gcN+HLY5D4k/pnAbOfDIWeYtmPNHXmGC+chprS5m+Dmd4zrIalOspST4p6m0u2RF8qBw
         EfYz/NQoBt/iEykzjyiNQpq22eeT69ym79oQP7EVAgpBiJnnZJGAPlP1H61RyXWSMOlZ
         A/LgsaHcXgtsgKl7MPriVgj8S7leP98sFIYrMCm0YSh0zZM0akqDk2xbLx1yUnipvPlf
         Uyyw==
X-Gm-Message-State: AOAM530YB1t6vHnvGod1oswY1r02t0a/t14njIwfaTdg7AbOZqWaGu9H
        zqfb9jvOPm+WRnD2ZMmF93qCgP/b2iwoMQblHG29IIVCj06X
X-Google-Smtp-Source: ABdhPJzWlgGt8254LNi6r+xvYlvlUufzmYnlmbqubZh4/z5YQFrPvnQZ2XsKsDCjnQu6h5qygIzpptS8NCiKxtZzt73kh966jZpb
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:18c9:: with SMTP id s9mr6904592ilu.265.1612579822571;
 Fri, 05 Feb 2021 18:50:22 -0800 (PST)
Date:   Fri, 05 Feb 2021 18:50:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007f199405baa1ffc4@google.com>
Subject: WARNING in init_timer_key
From:   syzbot <syzbot+105896fac213f26056f9@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    1048ba83 Linux 5.11-rc6
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10b58bd8d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3ae5569643a9955f
dashboard link: https://syzkaller.appspot.com/bug?extid=105896fac213f26056f9
compiler:       Debian clang version 11.0.1-2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16f0e564d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147075e8d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+105896fac213f26056f9@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: init active (active state 0) object type: timer_list hint: 0x0
WARNING: CPU: 0 PID: 8458 at lib/debugobjects.c:508 debug_print_object lib/debugobjects.c:505 [inline]
WARNING: CPU: 0 PID: 8458 at lib/debugobjects.c:508 __debug_object_init+0x9b7/0x17a0 lib/debugobjects.c:588
Modules linked in:
CPU: 0 PID: 8458 Comm: syz-executor705 Not tainted 5.11.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:debug_print_object lib/debugobjects.c:505 [inline]
RIP: 0010:__debug_object_init+0x9b7/0x17a0 lib/debugobjects.c:588
Code: 4c 89 ff e8 9b 93 ee fd 4d 8b 07 48 c7 c7 a0 db 0d 8a 48 c7 c6 c0 d9 0d 8a 48 89 da 44 89 f1 4c 8b 0c 24 31 c0 e8 f9 ba 7a fd <0f> 0b 4c 8b 64 24 28 ff 05 88 3f 47 09 48 8b 5c 24 60 48 83 c3 18
RSP: 0018:ffffc900016af680 EFLAGS: 00010246
RAX: b203bb0491a65600 RBX: ffffffff8a0ddd60 RCX: ffff888021e83780
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc900016af7b8 R08: ffffffff815fa2d2 R09: ffffed10173860b8
R10: ffffed10173860b8 R11: 0000000000000000 R12: ffff8880189ebe4c
R13: dffffc0000000000 R14: 0000000000000000 R15: ffffffff89b0ad80
FS:  0000000001cb8300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055c12944c038 CR3: 00000000133b0000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 debug_timer_init kernel/time/timer.c:722 [inline]
 debug_init kernel/time/timer.c:770 [inline]
 init_timer_key+0x39/0x110 kernel/time/timer.c:814
 ieee80211_ibss_setup_sdata+0x3c/0x170 net/mac80211/ibss.c:1734
 ieee80211_setup_sdata+0x627/0xc20 net/mac80211/iface.c:1534
 ieee80211_runtime_change_iftype net/mac80211/iface.c:1640 [inline]
 ieee80211_if_change_type+0x727/0xc00 net/mac80211/iface.c:1662
 ieee80211_change_iface+0x29/0x200 net/mac80211/cfg.c:157
 rdev_change_virtual_intf net/wireless/rdev-ops.h:69 [inline]
 cfg80211_change_iface+0x608/0xaa0 net/wireless/util.c:1067
 nl80211_set_interface+0x497/0x7f0 net/wireless/nl80211.c:3839
 genl_family_rcv_msg_doit net/netlink/genetlink.c:739 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0xe4e/0x1280 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2494
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x9ae/0xd50 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 __sys_sendto+0x438/0x5c0 net/socket.c:1975
 __do_sys_sendto net/socket.c:1987 [inline]
 __se_sys_sendto net/socket.c:1983 [inline]
 __x64_sys_sendto+0xda/0xf0 net/socket.c:1983
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x402c66
Code: 48 c7 c0 ff ff ff ff eb b7 66 2e 0f 1f 84 00 00 00 00 00 90 41 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 11 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 72 c3 90 55 48 83 ec 30 44 89 4c 24 2c 4c 89
RSP: 002b:00007ffd20868618 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007ffd208686e0 RCX: 0000000000402c66
RDX: 0000000000000024 RSI: 00007ffd20868730 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007ffd20868624 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000003 R14: 0000000000000000 R15: 00007ffd20868730


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
