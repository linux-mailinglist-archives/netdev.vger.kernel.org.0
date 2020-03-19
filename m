Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2717218C014
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 20:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgCSTHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 15:07:18 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:50161 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgCSTHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 15:07:17 -0400
Received: by mail-il1-f197.google.com with SMTP id 75so2891253ilv.16
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 12:07:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=JK4j91aQp8xu0adgIRNWGetww6zGg0DWJPZzVkz/f5s=;
        b=WPcLgsDrrh2hltsc0qREggt1QfE8kTXp89dzxPKrqsjIOGvtIdHX9yFGvWCjp3s0kw
         dUSuprN1+u+2bIXvhCP+6MqDQzIPtrMclzV4mV5LTWx4zuKppKDTAboTA5iUW3BZheRC
         /DlAUfFDbMrTN/+JTAh3r20GTZ6cgpxxqTzpEEEIodzfEq5wj/hjQ1fgFU9oMp00KWKT
         40dkWiZyoM0MFAKMIfqD/jgDUhbmLhCvhQFLyYxLfoh+yTdexuu/ChnJfy/GH9T+wrkK
         yeCs3uWNMzrHQAbbM02X7rrNZCE+kpMLetrTpjfL2NwHm+u6nq2DsSbUvgTy5WoH7RbX
         B0QA==
X-Gm-Message-State: ANhLgQ1RVS8LUAqlRU4brQAg2o58Z0gKsq//zoQvdRKYY64XQO0bWUuy
        k0s8ZakOjyBXaPPYbkl/nZUjZv6FyJEK5WnxKvT2p8+HF1AL
X-Google-Smtp-Source: ADFU+vtvBsH7etlrl1Zx74wee00IqMfrHha6pAhzcBYU4nKxhFmdO8EF/gSiaAdL5UWYDiwqoAN6Zej/knvSVfttizzdrh8HPPpU
MIME-Version: 1.0
X-Received: by 2002:a92:358b:: with SMTP id c11mr4415053ilf.64.1584644834463;
 Thu, 19 Mar 2020 12:07:14 -0700 (PDT)
Date:   Thu, 19 Mar 2020 12:07:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000074219d05a139e082@google.com>
Subject: general protection fault in sctp_ulpevent_nofity_peer_addr_change
From:   syzbot <syzbot+3950016bd95c2ca0377b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    5076190d mm: slub: be more careful about the double cmpxch..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14d2a61de00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9f894bd92023de02
dashboard link: https://syzkaller.appspot.com/bug?extid=3950016bd95c2ca0377b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1162bbe3e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13c93b45e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3950016bd95c2ca0377b@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000017: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000000b8-0x00000000000000bf]
CPU: 0 PID: 10161 Comm: syz-executor044 Not tainted 5.6.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:sctp_ulpevent_nofity_peer_addr_change+0xed/0xa30 net/sctp/ulpevent.c:347
Code: 03 80 3c 02 00 0f 85 19 08 00 00 48 8b ab a8 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d bd bc 00 00 00 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 70
RSP: 0018:ffffc900022a7308 EFLAGS: 00010207
RAX: dffffc0000000000 RBX: ffff888096004150 RCX: 0000000000000000
RDX: 0000000000000017 RSI: 0000000000000000 RDI: 00000000000000bc
RBP: 0000000000000000 R08: ffff88809419a500 R09: ffffc900022a7358
R10: fffff52000454e7a R11: ffffc900022a73d7 R12: 0000000000000000
R13: 0000000000000004 R14: 0000000000000000 R15: ffff888096004150
FS:  0000000000000000(0000) GS:ffff8880ae600000(0063) knlGS:000000000935d840
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000020000180 CR3: 0000000093589000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 sctp_assoc_set_primary+0x6c/0x300 net/sctp/associola.c:435
 sctp_assoc_rm_peer+0x77c/0xa40 net/sctp/associola.c:508
 sctp_assoc_update+0x50a/0xe30 net/sctp/associola.c:1116
 sctp_cmd_assoc_update net/sctp/sm_sideeffect.c:836 [inline]
 sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1305 [inline]
 sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
 sctp_do_sm+0x1c57/0x4ed0 net/sctp/sm_sideeffect.c:1156
 sctp_assoc_bh_rcv+0x386/0x6d0 net/sctp/associola.c:1044
 sctp_inq_push+0x1da/0x270 net/sctp/inqueue.c:80
 sctp_backlog_rcv+0x1f3/0x1290 net/sctp/input.c:344
 sk_backlog_rcv include/net/sock.h:963 [inline]
 __release_sock+0x134/0x3a0 net/core/sock.c:2440
 release_sock+0x54/0x1b0 net/core/sock.c:2956
 sctp_wait_for_connect+0x308/0x530 net/sctp/socket.c:9280
 __sctp_connect+0x9d2/0xc70 net/sctp/socket.c:1225
 __sctp_setsockopt_connectx+0x127/0x180 net/sctp/socket.c:1321
 sctp_setsockopt_connectx net/sctp/socket.c:1353 [inline]
 sctp_setsockopt net/sctp/socket.c:4698 [inline]
 sctp_setsockopt+0x15a1/0x7090 net/sctp/socket.c:4655
 compat_sock_common_setsockopt+0xf6/0x120 net/core/sock.c:3165
 __compat_sys_setsockopt+0x15d/0x310 net/compat.c:384
 __do_compat_sys_setsockopt net/compat.c:397 [inline]
 __se_compat_sys_setsockopt net/compat.c:394 [inline]
 __ia32_compat_sys_setsockopt+0xb9/0x150 net/compat.c:394
 do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
 do_fast_syscall_32+0x270/0xe8f arch/x86/entry/common.c:408
 entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
Modules linked in:
---[ end trace a970df05c462f077 ]---
RIP: 0010:sctp_ulpevent_nofity_peer_addr_change+0xed/0xa30 net/sctp/ulpevent.c:347
Code: 03 80 3c 02 00 0f 85 19 08 00 00 48 8b ab a8 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d bd bc 00 00 00 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 70
RSP: 0018:ffffc900022a7308 EFLAGS: 00010207
RAX: dffffc0000000000 RBX: ffff888096004150 RCX: 0000000000000000
RDX: 0000000000000017 RSI: 0000000000000000 RDI: 00000000000000bc
RBP: 0000000000000000 R08: ffff88809419a500 R09: ffffc900022a7358
R10: fffff52000454e7a R11: ffffc900022a73d7 R12: 0000000000000000
R13: 0000000000000004 R14: 0000000000000000 R15: ffff888096004150
FS:  0000000000000000(0000) GS:ffff8880ae600000(0063) knlGS:000000000935d840
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000020000180 CR3: 0000000093589000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
