Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6291307810
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 15:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbhA1OaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 09:30:00 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:34993 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbhA1O37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 09:29:59 -0500
Received: by mail-io1-f72.google.com with SMTP id a1so4354660ios.2
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 06:29:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=eTjvVgUwEQzRKvPj1q/adiwq2RrMpviFLY4V+Ohfj0A=;
        b=mxlYv8vAD1qKowP3cC/+CcTFgM/33llyPUtkBwNlg0YUFT37MCi311y7YrcdUME5qE
         AWlNIQmGYFE2Ckk3dJX+x3Y2ovoMOmpWJmd3FX64puekSOQcb/9g4/RHfcPNjF+AnL5X
         TpDgqdxw4H/sKRmfMuebk7srKk4kkytCmJ76AAiiS5V3MQayL51Ngz0UadNfLqAxCv/H
         w3qmIa0MhRhBISGno18eDiXJ4fiV4VUhCgNq/H0egv7ib1DQbhcEM8J34oYWRYUDHIaa
         ynmWMnRbywHtsjoUCQ/E0br3PKSBkxokBmnB5sxwgsc2h160YlY3mEadIe4ZIWdE7gY9
         Gazw==
X-Gm-Message-State: AOAM531vSeTNHvxgHfM/LRZpwlNcwjp+V37PzjtLEg9D28DnNq7h66KH
        9Laq6PgiBCybg1TaZfEKktN1QdD25wkIhByFk7mgrBKT4Ite
X-Google-Smtp-Source: ABdhPJzNOwP2xhPVRR5zQYSgGSasJVfqUmVhonZNlABMLRYMmQ6Qg2X0hfnJx6d2Gy2vtgD6WIx0B0yWRIxQ8DgGy2CC2aym6RmW
MIME-Version: 1.0
X-Received: by 2002:a05:6602:20c9:: with SMTP id 9mr11297171ioz.51.1611844157764;
 Thu, 28 Jan 2021 06:29:17 -0800 (PST)
Date:   Thu, 28 Jan 2021 06:29:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000074fd2305b9f6b6be@google.com>
Subject: WARNING: ODEBUG bug in ieee80211_ibss_setup_sdata
From:   syzbot <syzbot+e6d0c38bbcbe4d450b6c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes.berg@intel.com,
        johannes@sipsolutions.net, kuba@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, ramonreisfontes@gmail.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    e1ae4b0b Merge branch 'mtd/fixes' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10bb1c78d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=be33d8015c9de024
dashboard link: https://syzkaller.appspot.com/bug?extid=e6d0c38bbcbe4d450b6c
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10c346b4d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15a0e944d00000

The issue was bisected to:

commit 7dfd8ac327301f302b03072066c66eb32578e940
Author: Ramon Fontes <ramonreisfontes@gmail.com>
Date:   Thu Oct 10 18:13:07 2019 +0000

    mac80211_hwsim: add support for OCB

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12a22930d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11a22930d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=16a22930d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e6d0c38bbcbe4d450b6c@syzkaller.appspotmail.com
Fixes: 7dfd8ac32730 ("mac80211_hwsim: add support for OCB")

------------[ cut here ]------------
ODEBUG: init active (active state 0) object type: timer_list hint: 0x0
WARNING: CPU: 1 PID: 8473 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Modules linked in:
CPU: 0 PID: 8473 Comm: syz-executor073 Not tainted 5.11.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd c0 eb 9e 89 4c 89 ee 48 c7 c7 c0 df 9e 89 e8 46 18 f6 04 <0f> 0b 83 05 65 f3 40 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffc900016bf470 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: ffff8880149bb780 RSI: ffffffff815b6bc5 RDI: fffff520002d7e80
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815afd9e R11: 0000000000000000 R12: ffffffff894d8a40
R13: ffffffff899ee4c0 R14: ffffffff8161c7f0 R15: ffffffff8f305280
FS:  00000000018be880(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056278b5def48 CR3: 000000001841b000 CR4: 0000000000350ef0
Call Trace:
 __debug_object_init+0x524/0xd10 lib/debugobjects.c:588
 debug_timer_init kernel/time/timer.c:722 [inline]
 debug_init kernel/time/timer.c:770 [inline]
 init_timer_key+0x2d/0x340 kernel/time/timer.c:814
 ieee80211_ibss_setup_sdata+0x34/0x1b0 net/mac80211/ibss.c:1734
 ieee80211_setup_sdata+0xc3a/0xed0 net/mac80211/iface.c:1534
 ieee80211_runtime_change_iftype net/mac80211/iface.c:1636 [inline]
 ieee80211_if_change_type+0x535/0x620 net/mac80211/iface.c:1656
 ieee80211_change_iface+0x26/0x210 net/mac80211/cfg.c:157
 rdev_change_virtual_intf net/wireless/rdev-ops.h:69 [inline]
 cfg80211_change_iface+0x307/0xf10 net/wireless/util.c:1067
 nl80211_set_interface+0x65c/0x8d0 net/wireless/nl80211.c:3839
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 __sys_sendto+0x21c/0x320 net/socket.c:1975
 __do_sys_sendto net/socket.c:1987 [inline]
 __se_sys_sendto net/socket.c:1983 [inline]
 __x64_sys_sendto+0xdd/0x1b0 net/socket.c:1983
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x401b33
Code: ff ff ff f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb cd 66 0f 1f 44 00 00 83 3d dd 7b 2d 00 00 75 17 49 89 ca b8 2c 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 f1 0b 00 00 c3 48 83 ec 08 e8 57 01 00 00
RSP: 002b:00007ffd65808028 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007ffd658080e0 RCX: 0000000000401b33
RDX: 0000000000000024 RSI: 00007ffd65808130 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007ffd65808030 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007ffd65808130 R15: 0000000000000003


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
