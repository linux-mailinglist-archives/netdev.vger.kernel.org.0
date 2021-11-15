Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F2545000D
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 09:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhKOIl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 03:41:29 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:33790 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhKOIlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 03:41:21 -0500
Received: by mail-il1-f198.google.com with SMTP id c17-20020a92b751000000b0027392cd873aso10156391ilm.0
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 00:38:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=45KPnjgNpXV74fXbnG/ZGDYPdj4xK0W4REEDBd8I3to=;
        b=YzG3wHhGZYKYSdc8m7L5lOg/yi95pSjvGoYIowFIYM8/roheeM1sk7cyEB3Zrxx5Zx
         0sG4nKRx9pSjizqBs2b0fN1OO8De2VtUO8R0FoA9PwCarxYMyc/ugrIMSec2UxcB0JRk
         SjRqb9UikmHBAYJgevNKbE+VmmgO7BCG95NDhaGqY0G9vrF60rjYnYvSZD2VHAaYmknY
         NXHvM17xNvxeexA5RkNdaF9uGC04SHUg+fr0SzRzbh/I/7Tg7R08XS8UyCE6uC1L/ja8
         88BaXy+2REQC+3JxkUK32I8OVGDAksD4LdasJT8zGkSYibThFzFrsBIzRxl2E2uZ49rL
         HU0w==
X-Gm-Message-State: AOAM530KxjiD/M7xr59J3Mqa5Ez04YQ5SxE47KnUgE69hzSmaBC41xml
        cWGvCAate1/n925nvljUnXs5uo4CmyPDBwzti14fmWKnXuoO
X-Google-Smtp-Source: ABdhPJwRgQGr9EeOkC+KCTUBhnSP/m0VgHnHjs2I2tJ7M/+PX+Hmz23heH5Bg+sNdDoDS7TWf3T155tJpzm/VH6FveybAeC4BKcs
MIME-Version: 1.0
X-Received: by 2002:a5d:80c4:: with SMTP id h4mr24747166ior.40.1636965505998;
 Mon, 15 Nov 2021 00:38:25 -0800 (PST)
Date:   Mon, 15 Nov 2021 00:38:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007ea16705d0cfbb53@google.com>
Subject: [syzbot] kernel BUG in pskb_expand_head
From:   syzbot <syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com>
To:     anthony.l.nguyen@intel.com, davem@davemloft.net,
        intel-wired-lan@lists.osuosl.org, jesse.brandeburg@intel.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    debe436e77c7 Merge tag 'ext4_for_linus' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17cdbcf1b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dcce4e862d74e466
dashboard link: https://syzkaller.appspot.com/bug?extid=4c63f36709a642f801c5
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:1695!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 13268 Comm: syz-executor.1 Not tainted 5.15.0-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
RIP: 0010:pskb_expand_head+0xb28/0x1060 net/core/skbuff.c:1695
Code: 8d 75 ff e9 60 fe ff ff e8 75 dd 5a fa 48 c7 c6 a0 60 8c 8a 4c 89 f7 e8 c6 d6 8d fa 0f 0b e8 5f dd 5a fa 0f 0b e8 58 dd 5a fa <0f> 0b e8 51 dd 5a fa 41 81 cc 00 00 02 00 e9 f6 f5 ff ff e8 40 dd
RSP: 0018:ffffc90005a6f2e0 EFLAGS: 00010212
RAX: 0000000000030e8b RBX: ffff88801fa215c0 RCX: ffffc90020bf5000
RDX: 0000000000040000 RSI: ffffffff871c2298 RDI: 0000000000000003
RBP: 00000000ffffffbb R08: 0000000000000001 R09: ffff88801fa2169f
R10: ffffffff871c1842 R11: 0000000000000000 R12: 0000000000000a20
R13: 0000000000000002 R14: 0000000000000001 R15: 0000000000000000
FS:  00007f39135d8700(0000) GS:ffff88802ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020004038 CR3: 0000000065ef5000 CR4: 0000000000150ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Call Trace:
 <TASK>
 __skb_pad+0x181/0x5f0 net/core/skbuff.c:1929
 __skb_put_padto include/linux/skbuff.h:3331 [inline]
 skb_put_padto include/linux/skbuff.h:3350 [inline]
 eth_skb_pad include/linux/etherdevice.h:584 [inline]
 e1000_xmit_frame+0x2de3/0x4650 drivers/net/ethernet/intel/e1000/e1000_main.c:3125
 __netdev_start_xmit include/linux/netdevice.h:4987 [inline]
 netdev_start_xmit include/linux/netdevice.h:5001 [inline]
 xmit_one net/core/dev.c:3590 [inline]
 dev_hard_start_xmit+0x1eb/0x920 net/core/dev.c:3606
 sch_direct_xmit+0x19f/0xbc0 net/sched/sch_generic.c:342
 __dev_xmit_skb net/core/dev.c:3817 [inline]
 __dev_queue_xmit+0x149c/0x3630 net/core/dev.c:4194
 llc_sap_action_send_test_c+0x22e/0x2c0 net/llc/llc_s_ac.c:144
 llc_exec_sap_trans_actions net/llc/llc_sap.c:153 [inline]
 llc_sap_next_state net/llc/llc_sap.c:182 [inline]
 llc_sap_state_process+0x22a/0x4f0 net/llc/llc_sap.c:209
 llc_ui_sendmsg+0x9f3/0x10b0 net/llc/af_llc.c:964
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x331/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmmsg+0x195/0x470 net/socket.c:2549
 __do_sys_sendmmsg net/socket.c:2578 [inline]
 __se_sys_sendmmsg net/socket.c:2575 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2575
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f3916062ae9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f39135d8188 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f3916175f60 RCX: 00007f3916062ae9
RDX: 03fffffffffffeed RSI: 0000000020001380 RDI: 0000000000000005
RBP: 00007f39160bcf6d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe4b72644f R14: 00007f39135d8300 R15: 0000000000022000
 </TASK>
Modules linked in:
---[ end trace 518f993fe030bf9b ]---
RIP: 0010:pskb_expand_head+0xb28/0x1060 net/core/skbuff.c:1695
Code: 8d 75 ff e9 60 fe ff ff e8 75 dd 5a fa 48 c7 c6 a0 60 8c 8a 4c 89 f7 e8 c6 d6 8d fa 0f 0b e8 5f dd 5a fa 0f 0b e8 58 dd 5a fa <0f> 0b e8 51 dd 5a fa 41 81 cc 00 00 02 00 e9 f6 f5 ff ff e8 40 dd
RSP: 0018:ffffc90005a6f2e0 EFLAGS: 00010212
RAX: 0000000000030e8b RBX: ffff88801fa215c0 RCX: ffffc90020bf5000
RDX: 0000000000040000 RSI: ffffffff871c2298 RDI: 0000000000000003
RBP: 00000000ffffffbb R08: 0000000000000001 R09: ffff88801fa2169f
R10: ffffffff871c1842 R11: 0000000000000000 R12: 0000000000000a20
R13: 0000000000000002 R14: 0000000000000001 R15: 0000000000000000
FS:  00007f39135d8700(0000) GS:ffff88802ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020004038 CR3: 0000000065ef5000 CR4: 0000000000150ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
