Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3327C3305E7
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 03:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233537AbhCHCap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 21:30:45 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:55219 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbhCHCaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 21:30:39 -0500
Received: by mail-il1-f199.google.com with SMTP id w8so6317546ilg.21
        for <netdev@vger.kernel.org>; Sun, 07 Mar 2021 18:30:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=bxTzn20sw0YqGPnteZcFUQodhglpJ7rCkRvt/JGA98w=;
        b=V+d1gBoWPVcpRdl4qsrNXb4OTm58LSzIQEtq4ONmr+S+Hagf6G6aqKPbtJTwvAdCw8
         Wic9Wp75Kw9iQzhNStzsBvB7TunPiNEgGQy7Ywf5xqp0xQ3qKQthi3FcrMD05fbFEjei
         YvFmr5IFW3GoCBJpM82G+k+57StWDkRUNgQTF7lrgztvnIq/eVF7Ja4soHDlH4adiYjY
         qXCyAx4YtM2KPplDRTiS3XbLZJcWtrMSEsyDYKlLWkt71aCiOY069DFknAMjtvfHJGCq
         JaSKVcO59O4QoSnsqrTnvFPMeA19UgL4684VS+py3BGXUQ7TldTDqX7tOWs56UgKYdch
         yxHg==
X-Gm-Message-State: AOAM531rohtvgv++WTYr8+uAAKO6q0gSg5NejsSPj3iDFmFO6WpCg/sb
        K98ZVjP/J2LdttmLy2v30mGcnW83VotnlxKet+koVbx/l/q2
X-Google-Smtp-Source: ABdhPJzr6F69xiYl85TA2EDzpPaEUsnYs2z1zwMY6xt6rXuRW0WGjtsXN11doPLldAFW/KoiyC1CvLZbQtSFkHJAaen3IMTUnSxu
MIME-Version: 1.0
X-Received: by 2002:a02:971a:: with SMTP id x26mr20900603jai.61.1615170627920;
 Sun, 07 Mar 2021 18:30:27 -0800 (PST)
Date:   Sun, 07 Mar 2021 18:30:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000087674b05bcfd37a0@google.com>
Subject: [syzbot] WARNING: ODEBUG bug in net_dm_cmd_trace
From:   syzbot <syzbot+779559d6503f3a56213d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d310ec03 Merge tag 'perf-core-2021-02-17' of git://git.ker..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=108adb32d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2b8307379601586a
dashboard link: https://syzkaller.appspot.com/bug?extid=779559d6503f3a56213d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12ad095cd00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+779559d6503f3a56213d@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: init active (active state 0) object type: timer_list hint: sched_send_work+0x0/0x60 include/linux/list.h:135
WARNING: CPU: 1 PID: 8649 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Modules linked in:
CPU: 1 PID: 8649 Comm: syz-executor.0 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd 40 4c bf 89 4c 89 ee 48 c7 c7 40 40 bf 89 e8 64 79 fa 04 <0f> 0b 83 05 15 e0 ff 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffc900021df438 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: ffff888020cd1bc0 RSI: ffffffff815b4c85 RDI: fffff5200043be79
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815ade9e R11: 0000000000000000 R12: ffffffff896d8ea0
R13: ffffffff89bf4540 R14: ffffffff8161d660 R15: ffffffff900042b0
FS:  00007f73bb69e700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7a4370f470 CR3: 000000001334a000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __debug_object_init+0x524/0xd10 lib/debugobjects.c:588
 debug_timer_init kernel/time/timer.c:722 [inline]
 debug_init kernel/time/timer.c:770 [inline]
 init_timer_key+0x2d/0x340 kernel/time/timer.c:814
 net_dm_trace_on_set net/core/drop_monitor.c:1111 [inline]
 set_all_monitor_traces net/core/drop_monitor.c:1188 [inline]
 net_dm_monitor_start net/core/drop_monitor.c:1295 [inline]
 net_dm_cmd_trace+0x720/0x1220 net/core/drop_monitor.c:1339
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2348
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2402
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2435
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x465ef9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f73bb69e188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000465ef9
RDX: 0000000000000800 RSI: 0000000020000500 RDI: 0000000000000005
RBP: 00007f73bb69e1d0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 00007ffdb1c8cb0f R14: 00007f73bb69e300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
