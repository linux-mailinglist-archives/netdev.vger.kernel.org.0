Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A423231B14
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 10:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbgG2IUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 04:20:17 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:48772 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbgG2IUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 04:20:16 -0400
Received: by mail-il1-f197.google.com with SMTP id w23so5643756ila.15
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 01:20:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=cl416RZjUF3O9jXjZQ0k7KWHBcYWC7cjCtLUFQMx9CY=;
        b=UD9qe2p967K3ERwUY2b6ZZbWneeraxsuLUvz64fs0ywzCO/vmuU5xZbSdnpbDzOGkl
         9//Y0Mjjux3FBT9XA8Hf9zXpH0CZMapt69Lwxuhe86AJdzDZPmnNF492X653VsIeZNmK
         uwk/kQzy7XEw/UhyIUtnqn1IuNpGqarzfZdjP5q6p/egQJtAFwnWDzu+dHBnMObIqWNB
         CXS4vyeH5IzQ0FFkjMsI7fdykemohWgtQYRXrclGlbbkzGhSaOPy304NI/Mp/rV/dKrj
         c5hcGBtLO/dT++aWgDoEc5weBOaMw/bFhMKg64IRuPvvqxVGUJTmNW+jdzueRWfam72i
         Xn+A==
X-Gm-Message-State: AOAM5307Y//ni1TkURunNLWkwN187kk5ON+u5+kouCW//zL9XhN1NpgS
        ND3+EqnlmNPkpaU9X13bGIenrFBLuBhWhAj8arW0zuKYKsHH
X-Google-Smtp-Source: ABdhPJxL9LdW97OSd1IKs5yaFXouU/Fjr1b85o13NOy0MxxGgoXq2IBV5g08QwJaz1+n03lC8bIroLaMPPMFiHTm61YSOLmmcwN7
MIME-Version: 1.0
X-Received: by 2002:a05:6602:154d:: with SMTP id h13mr33043619iow.210.1596010814962;
 Wed, 29 Jul 2020 01:20:14 -0700 (PDT)
Date:   Wed, 29 Jul 2020 01:20:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000af016405ab903954@google.com>
Subject: KASAN: vmalloc-out-of-bounds Read in get_counters
From:   syzbot <syzbot+a450cb4aa95912e62487@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    68845a55 Merge branch 'akpm' into master (patches from And..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13668964900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f87a5e4232fdb267
dashboard link: https://syzkaller.appspot.com/bug?extid=a450cb4aa95912e62487
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a450cb4aa95912e62487@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: vmalloc-out-of-bounds in get_counters+0x593/0x610 net/ipv6/netfilter/ip6_tables.c:780
Read of size 8 at addr ffffc9000528b048 by task syz-executor.1/6968

CPU: 1 PID: 6968 Comm: syz-executor.1 Not tainted 5.8.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0x5/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 get_counters+0x593/0x610 net/ipv6/netfilter/ip6_tables.c:780
 do_ip6t_get_ctl+0x516/0x910 net/ipv6/netfilter/ip6_tables.c:821
 nf_sockopt net/netfilter/nf_sockopt.c:104 [inline]
 nf_getsockopt+0x72/0xd0 net/netfilter/nf_sockopt.c:122
 ipv6_getsockopt+0x1bf/0x270 net/ipv6/ipv6_sockglue.c:1468
 tcp_getsockopt+0x86/0xd0 net/ipv4/tcp.c:3893
 __sys_getsockopt+0x14b/0x2e0 net/socket.c:2172
 __do_sys_getsockopt net/socket.c:2187 [inline]
 __se_sys_getsockopt net/socket.c:2184 [inline]
 __x64_sys_getsockopt+0xba/0x150 net/socket.c:2184
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45ee7a
Code: Bad RIP value.
RSP: 002b:0000000000c9f618 EFLAGS: 00000212 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 0000000000c9f640 RCX: 000000000045ee7a
RDX: 0000000000000041 RSI: 0000000000000029 RDI: 0000000000000003
RBP: 0000000000744ca0 R08: 0000000000c9f63c R09: 0000000000004000
R10: 0000000000c9f740 R11: 0000000000000212 R12: 0000000000000003
R13: 0000000000000000 R14: 0000000000000029 R15: 00000000007445e0


Memory state around the buggy address:
 ffffc9000528af00: f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9
 ffffc9000528af80: f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9
>ffffc9000528b000: 00 00 00 00 00 00 00 00 f9 f9 f9 f9 f9 f9 f9 f9
                                              ^
 ffffc9000528b080: f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9
 ffffc9000528b100: f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
