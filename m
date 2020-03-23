Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E833B18FB82
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 18:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbgCWRaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 13:30:22 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:45687 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbgCWRaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 13:30:19 -0400
Received: by mail-io1-f70.google.com with SMTP id h76so12425133iof.12
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 10:30:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=5E378JM8LsVrD9iDrEpSw6Vzgvb0BZRqiwewTYdYXT4=;
        b=RFpw1FST7JAG6PaiQwAehQRVuUSKoz/lWSggAnD6KsGKEU/xMm2eFTUJsuUcQiiwHx
         a4GpWaf7bNcHKHP0WnC8ytsohoegJyfcyM/ML4tqVVR0ihe6dshzOeFNyllPB2UHG0re
         kNlffsM7shN8e+JRnTsBCFYSVZZ/mAIRdKTVUuDf8MpU6HXzp1n9rM+02WpD2Gg3iGN7
         Qaap1acCufJf9Wm21LDJ7Y1pwC7M3U8dme2MxhcAGYB7YLLxt+kEIN1AjOR47UTa9Jbh
         d1gJxzbGz9UbKj0xoJtXK9GUrKbzMtiQIgoJF3HdcyGUevmz6nH5Dl5VRqUoJ9gqK4xF
         LvxA==
X-Gm-Message-State: ANhLgQ1YXVLFjB6+anUgM4tWf4qNdISwWcMOLJxOSdgHdWBJDhqfkSrO
        MSKUuul1WqauMP8J41lpoPqXEhG5Kcfg9NwFDmJZAn++Nt37
X-Google-Smtp-Source: ADFU+vufIfdNltTiaPeRMLFy9hvk6mV5Ra1g//arujxWNB4RNQDkIyxTiKIYNaxIzlzuYxVKf3Ogb5H/GCrOGuLKoY+WML8dnSKq
MIME-Version: 1.0
X-Received: by 2002:a5d:958f:: with SMTP id a15mr19833391ioo.170.1584984617398;
 Mon, 23 Mar 2020 10:30:17 -0700 (PDT)
Date:   Mon, 23 Mar 2020 10:30:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000183b7e05a188fd79@google.com>
Subject: WARNING: ODEBUG bug in __init_work
From:   syzbot <syzbot+5470940d8c65601e282f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    770fbb32 Add linux-next specific files for 20200228
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17625e75e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=576314276bce4ad5
dashboard link: https://syzkaller.appspot.com/bug?extid=5470940d8c65601e282f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=109c2b19e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+5470940d8c65601e282f@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: init active (active state 0) object type: work_struct hint: route4_delete_filter_work+0x0/0x20 net/sched/cls_route.c:256
WARNING: CPU: 0 PID: 9602 at lib/debugobjects.c:485 debug_print_object+0x160/0x250 lib/debugobjects.c:485
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 9602 Comm: syz-executor.3 Not tainted 5.6.0-rc3-next-20200228-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:175 [inline]
 fixup_bug arch/x86/kernel/traps.c:170 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:debug_print_object+0x160/0x250 lib/debugobjects.c:485
Code: dd 00 25 72 88 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 bf 00 00 00 48 8b 14 dd 00 25 72 88 48 c7 c7 60 1a 72 88 e8 48 06 b1 fd <0f> 0b 83 05 bb f8 f2 06 01 48 83 c4 20 5b 5d 41 5c 41 5d c3 48 89
RSP: 0018:ffffc90002497198 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815c4e91 RDI: fffff52000492e25
RBP: 0000000000000001 R08: ffff88808b212080 R09: ffffed1015cc6661
R10: ffffed1015cc6660 R11: ffff8880ae633307 R12: ffffffff8997bf00
R13: ffffffff814ac650 R14: ffffffff8c7fc668 R15: 1ffff92000492e4b
 __debug_object_init+0x572/0xe20 lib/debugobjects.c:568
 __init_work+0x48/0x50 kernel/workqueue.c:502
 tcf_queue_work+0x19/0xf0 net/sched/cls_api.c:205
 route4_change+0xe8e/0x2250 net/sched/cls_route.c:550
 tc_new_tfilter+0xa59/0x20b0 net/sched/cls_api.c:2103
 rtnetlink_rcv_msg+0x810/0xad0 net/core/rtnetlink.c:5431
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
 do_syscall_64+0xf6/0x790 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45c849
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fbb327afc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fbb327b06d4 RCX: 000000000045c849
RDX: 0000000000000000 RSI: 0000000020000280 RDI: 0000000000000004
RBP: 000000000076bfa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000009f9 R14: 00000000004ccb11 R15: 000000000076bfac
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
