Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C852E8217
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 22:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgLaVJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 16:09:57 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:41927 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgLaVJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Dec 2020 16:09:57 -0500
Received: by mail-il1-f197.google.com with SMTP id f19so18599384ilk.8
        for <netdev@vger.kernel.org>; Thu, 31 Dec 2020 13:09:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ImUavmO9HuvNyGGDB8IPh6YqAjU+wI3gTPYJmrthYXU=;
        b=DAT3mdjcEZ4MSXt9IdRju+U1gVeYhnjcv4b2EC1KtH57aogTjYh2A39tnFTHrRztrF
         pOQKUgPahYPEz5fjYur5wzEOUqLL6fgexxuU8gTroFo9uu52cR8qtglM36zfzC8lV9a1
         dRDxbsY9sVsbNxXoesgltz6dG2uNFPDHKVWTSpdFMi7aEH6UveLni4gnBR6bNDdqIszs
         SyokorwqkJchUKQpRMazWrAAgrVujgFXLTN9mJh/yziBjZFE/C4mlwmkgFZR98m0HrUW
         5nP9M2neZqiyUOiM4JKzhCoK0icWt29UY0hqkjnlg+99QCIcSNA02z/ZQQxLUfjsmvls
         vtHQ==
X-Gm-Message-State: AOAM533YlIzoO2A/6ILcq4p6Tk3kwl6cqKBVgT1mncjC3/sDDNhpaN2O
        SheQ11HxpR6Z1Kdfq2QnjZ/ufnSiDbyXlMXDhB8TIuMEhN6y
X-Google-Smtp-Source: ABdhPJx1u4Mvpeq4U3rJyyiMGjuuW5woFFx+b/iIzO2y+OdVVxvV6d665xsfUnub9vDZ7kuyebI1yrMoIa9ieCL84RJ0T9+u9zrp
MIME-Version: 1.0
X-Received: by 2002:a02:7650:: with SMTP id z77mr50509422jab.134.1609448956306;
 Thu, 31 Dec 2020 13:09:16 -0800 (PST)
Date:   Thu, 31 Dec 2020 13:09:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000532e0205b7c90942@google.com>
Subject: UBSAN: shift-out-of-bounds in gred_change
From:   syzbot <syzbot+1819b70451246ed8cf57@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=155708db500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2ae878fbf640b72b
dashboard link: https://syzkaller.appspot.com/bug?extid=1819b70451246ed8cf57
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=176b78c0d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12993797500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1819b70451246ed8cf57@syzkaller.appspotmail.com

IPVS: ftp: loaded support on port[0] = 21
================================================================================
UBSAN: shift-out-of-bounds in ./include/net/red.h:252:22
shift exponent 255 is too large for 32-bit type 'int'
CPU: 0 PID: 8465 Comm: syz-executor194 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
 red_set_parms include/net/red.h:252 [inline]
 gred_change_vq net/sched/sch_gred.c:506 [inline]
 gred_change.cold+0xce/0xe2 net/sched/sch_gred.c:702
 qdisc_change net/sched/sch_api.c:1331 [inline]
 tc_modify_qdisc+0xd4e/0x1a30 net/sched/sch_api.c:1633
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
RIP: 0033:0x440e69
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 0b 10 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff634be6d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004a2730 RCX: 0000000000440e69
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
RBP: 00007fff634be6e0 R08: 0000000120080522 R09: 0000000120080522
R10: 0000000120080522 R11: 0000000000000246 R12: 00000000004a2730
R13: 0000000000402390 R14: 0000000000000000 R15: 0000000000000000
================================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
