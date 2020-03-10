Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C41F6180B47
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgCJWPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:15:19 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:41018 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbgCJWPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:15:18 -0400
Received: by mail-io1-f72.google.com with SMTP id n15so81735iog.8
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 15:15:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=XwSC3MbibdHjebc+VGMl0nkJts274Y/XDwLyneFu6mk=;
        b=jyYykkaAFYalL6q6aM3ZemTFjwz9ofIwjugh2ab0qYb+RCOqKn1/eiGQpdJ5PsDDHx
         oNR8g+37p545WG/fQ8MgI1O7FsBLMT+II5AhCfuB24HQIbLITjlajMUKezdzmb4CIDbA
         ibLxwAQfJ9qU1Z9nybVkzIFwYydLeJqVAi5rshxZWyhyfMreee+y9Bh/o9I3ohRKmP00
         Av16cj5419AbiiFArw/UZ7qppWtvdE8e0nQK4Nl4yRisT6BUpSX8Fh46ZtnV1wAfMD5q
         C348ru0yuMoMW2l3L8Qh5GRKQfLAfA8yTQfBLJsL/O6VnmhGZYB5BtaTMcWl+DT11yq2
         gmMw==
X-Gm-Message-State: ANhLgQ2QQnZkO5Xj0JtsD8YDIs95f5q0BL7rNOIkAFlzZIxGwvtIp2pC
        lFiDkOfWFaUA8JPTqOJl7qRRmxIvYjFX97axXhfLlvXQvuHm
X-Google-Smtp-Source: ADFU+vv6ZN70tvOfUP0eFBlVowXEeuFKOydoGdOxRek97JbwclNxOPEVBmLDt9gXhEuXMZuirstirK6k/Vpilcm/t5m7h8FCiOtu
MIME-Version: 1.0
X-Received: by 2002:a92:589a:: with SMTP id z26mr228050ilf.19.1583878517647;
 Tue, 10 Mar 2020 15:15:17 -0700 (PDT)
Date:   Tue, 10 Mar 2020 15:15:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000696eaf05a0877436@google.com>
Subject: WARNING: refcount bug in __tcf_action_put
From:   syzbot <syzbot+91aff155f11242aeafbe@syzkaller.appspotmail.com>
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

HEAD commit:    2c523b34 Linux 5.6-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17ae6ee3e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c2e311dba9a02ba9
dashboard link: https://syzkaller.appspot.com/bug?extid=91aff155f11242aeafbe
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12220af9e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+91aff155f11242aeafbe@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 0 PID: 9857 at lib/refcount.c:87 refcount_dec_not_one lib/refcount.c:87 [inline]
WARNING: CPU: 0 PID: 9857 at lib/refcount.c:87 refcount_dec_not_one+0x1be/0x1e0 lib/refcount.c:74
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 9857 Comm: syz-executor.0 Not tainted 5.6.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 fixup_bug arch/x86/kernel/traps.c:169 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:refcount_dec_not_one lib/refcount.c:87 [inline]
RIP: 0010:refcount_dec_not_one+0x1be/0x1e0 lib/refcount.c:74
Code: 1d d5 68 d2 06 31 ff 89 de e8 2e 52 e3 fd 84 db 75 82 e8 f5 50 e3 fd 48 c7 c7 00 aa 51 88 c6 05 b5 68 d2 06 01 e8 8a 63 b5 fd <0f> 0b e9 63 ff ff ff 48 89 ef e8 93 0e 20 fe e9 be fe ff ff e8 b9
RSP: 0018:ffffc90002346f08 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815bf4f1 RDI: fffff52000468dd3
RBP: ffff88809722641c R08: ffff8880989e4040 R09: ffffed1015cc6659
R10: ffffed1015cc6658 R11: ffff8880ae6332c7 R12: 00000000ffffffff
R13: ffffc90002346f30 R14: 1ffff92000468de2 R15: ffff888097226400
 refcount_dec_and_mutex_lock+0x1c/0xe0 lib/refcount.c:115
 __tcf_action_put+0x3f/0x130 net/sched/act_api.c:129
 __tcf_idr_release net/sched/act_api.c:165 [inline]
 __tcf_idr_release+0x52/0xe0 net/sched/act_api.c:145
 tcf_action_destroy+0xc6/0x150 net/sched/act_api.c:724
 tcf_exts_destroy+0x42/0xc0 net/sched/cls_api.c:3001
 tcf_exts_change+0xf4/0x150 net/sched/cls_api.c:3059
 tcindex_set_parms+0xed8/0x1a00 net/sched/cls_tcindex.c:456
 tcindex_change+0x203/0x2e0 net/sched/cls_tcindex.c:518
 tc_new_tfilter+0xa59/0x20b0 net/sched/cls_api.c:2103
 rtnetlink_rcv_msg+0x810/0xad0 net/core/rtnetlink.c:5427
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
 do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
 do_fast_syscall_32+0x270/0xe8f arch/x86/entry/common.c:408
 entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
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
