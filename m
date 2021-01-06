Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA222EBB51
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 09:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbhAFIvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 03:51:00 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:56152 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbhAFIvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 03:51:00 -0500
Received: by mail-il1-f198.google.com with SMTP id c13so2051065ilg.22
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 00:50:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=FsvQnsUURhV2OmdsEUEnsDCv+OlmKNzEOUKXr4QWTqA=;
        b=N6//EtlJXOzcX8KbA/e8gWziEWM6bab+CTS72EJ9Mg5uMvakBQmEOVEk4+qhROKQdQ
         Ax3LrciBdKMUrtpgdD5Me+UQRy494ccizB0p+Yg9BHI7KiLozIfRipbXysrYCcv67Jtx
         p8SABAmM+wf2FtYLF7nxYnxD+HfRqeaO0O+Epn8BgFSUAa6eN5jpp4dliP7QLpi/ogxE
         +eYY/CE78gUh8vTKThYOy74r1A8BiU3+t+yUImTHn0IasN6l46XgXeGRC9kxMPUGk+0o
         ZMb3kSMBvcvA8p/B/jPaydYjYqlFUanjCy0LzRzmtpRf6BhXROTq8C4munO5L6SO5FOE
         up6Q==
X-Gm-Message-State: AOAM533wM/NNSgLbctIpT0l2Yph/so7rG0hH1AAayFzuBlOVsK1PwvMj
        TTiXfVboNN/YUM2V2RoqnSgUPflW7tIaGh4gGeLSbp57Pq4Z
X-Google-Smtp-Source: ABdhPJxC6iwpniVCevtAsbkQZmeqHoCOk5aS8CU+gRoT5hxw0rXkOnyvPOVKjfrFWyt/lhjeB3T76UnmKUcLbhj/lNwNQHd7Q8F7
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:104a:: with SMTP id p10mr3152877ilj.247.1609923018986;
 Wed, 06 Jan 2021 00:50:18 -0800 (PST)
Date:   Wed, 06 Jan 2021 00:50:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a99c7105b83769d7@google.com>
Subject: UBSAN: array-index-out-of-bounds in qfq_update_agg
From:   syzbot <syzbot+7c315a573dd9374a3220@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3db1a3fa Merge tag 'staging-5.11-rc1' of git://git.kernel...
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1286be67500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a6e6725884106332
dashboard link: https://syzkaller.appspot.com/bug?extid=7c315a573dd9374a3220
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7c315a573dd9374a3220@syzkaller.appspotmail.com

================================================================================
UBSAN: array-index-out-of-bounds in net/sched/sch_qfq.c:300:24
index 29 is out of range for type 'qfq_group [25]'
CPU: 0 PID: 20516 Comm: syz-executor.3 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_out_of_bounds.cold+0x62/0x6c lib/ubsan.c:356
 qfq_update_agg+0x7b8/0x7d0 net/sched/sch_qfq.c:300
 qfq_add_to_agg+0x75/0x500 net/sched/sch_qfq.c:317
 qfq_change_class+0x5da/0x18f0 net/sched/sch_qfq.c:510
 tc_ctl_tclass+0x526/0xc70 net/sched/sch_api.c:2111
 rtnetlink_rcv_msg+0x493/0xb40 net/core/rtnetlink.c:5564
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x907/0xe10 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd3/0x130 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2336
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2390
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2423
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e219
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fe1c8c30c68 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045e219
RDX: 0000000000000000 RSI: 0000000020000540 RDI: 0000000000000003
RBP: 000000000119c068 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119c034
R13: 00007ffc62cfe08f R14: 00007fe1c8c319c0 R15: 000000000119c034
================================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
