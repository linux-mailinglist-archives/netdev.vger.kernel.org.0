Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27EC3272936
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbgIUO4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 10:56:21 -0400
Received: from mail-io1-f78.google.com ([209.85.166.78]:39824 "EHLO
        mail-io1-f78.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgIUO4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:56:21 -0400
Received: by mail-io1-f78.google.com with SMTP id y16so10094692ioy.6
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 07:56:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=X494KYDH9UJUyj96W5LQtORQMzd+WMrT10MmALrBCuk=;
        b=lGJlTdnhHUgD7l6cxcjQGJOd78ptm3jT96XTrR52TCprJJjnHcKU4Z/qHMvEG4EX62
         eHU6VUfDbbRmMe0SSZuXhvvLDBBtuTatcYgH31mg8S0xChOyHWncdFKYIKA4umnVrvfJ
         kzP+HQqCPvZ+Na6iw8AfDCqME0OY+Uh5WJMnWTEjnFw3hS1hyubNQjGBxqVoy5OqviM6
         kQaEJY9N0XQPQhXArKznbwmhzASQgi137ePUVXShvDzAdshwN1+1574oVoacIjkiJ3Jv
         y2v62STTpNKZ14LeExp/+VKF11RMsyfQYRXyDQOxgebgZ6uj7h8a3+A/mCkVbDOXVJE7
         hVXg==
X-Gm-Message-State: AOAM531BW5krzvY+ERUw1cF5C1OCCl3ZdkM8PPTPTerivNyi1PkGm7bF
        2gzEcYOszJ3sekXJkb7qpiuCG9sC4NNbxEx5bmIRVVj8WumS
X-Google-Smtp-Source: ABdhPJx0BHqSrjQ0MKpr5g0u4KiHtoaqea2CXDOLFPmsTbEgZiYCW2oia/g9YAKq5Jx6CxAmJd1OR2rHoCwcRPm/iQzTQCAPNttY
MIME-Version: 1.0
X-Received: by 2002:a6b:7017:: with SMTP id l23mr36545774ioc.120.1600700180053;
 Mon, 21 Sep 2020 07:56:20 -0700 (PDT)
Date:   Mon, 21 Sep 2020 07:56:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009fc91605afd40d89@google.com>
Subject: KASAN: stack-out-of-bounds Read in xfrm_selector_match (2)
From:   syzbot <syzbot+577fbac3145a6eb2e7a5@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    eb5f95f1 Merge tag 's390-5.9-6' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13996ad5900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ffe85b197a57c180
dashboard link: https://syzkaller.appspot.com/bug?extid=577fbac3145a6eb2e7a5
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+577fbac3145a6eb2e7a5@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: stack-out-of-bounds in xfrm_flowi_dport include/net/xfrm.h:877 [inline]
BUG: KASAN: stack-out-of-bounds in __xfrm6_selector_match net/xfrm/xfrm_policy.c:216 [inline]
BUG: KASAN: stack-out-of-bounds in xfrm_selector_match+0xf36/0xf60 net/xfrm/xfrm_policy.c:229
Read of size 2 at addr ffffc9001914f55c by task syz-executor.4/15633

CPU: 0 PID: 15633 Comm: syz-executor.4 Not tainted 5.9.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0x5/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 xfrm_flowi_dport include/net/xfrm.h:877 [inline]
 __xfrm6_selector_match net/xfrm/xfrm_policy.c:216 [inline]
 xfrm_selector_match+0xf36/0xf60 net/xfrm/xfrm_policy.c:229
 xfrm_state_look_at.constprop.0+0x144/0x3f0 net/xfrm/xfrm_state.c:1022
 xfrm_state_find+0x1a16/0x4d50 net/xfrm/xfrm_state.c:1092
 xfrm_tmpl_resolve_one net/xfrm/xfrm_policy.c:2384 [inline]
 xfrm_tmpl_resolve+0x2f3/0xd40 net/xfrm/xfrm_policy.c:2429
 xfrm_resolve_and_create_bundle+0x123/0x2590 net/xfrm/xfrm_policy.c:2719
 xfrm_lookup_with_ifid+0x235/0x2130 net/xfrm/xfrm_policy.c:3053
 xfrm_lookup net/xfrm/xfrm_policy.c:3177 [inline]
 xfrm_lookup_route+0x36/0x1e0 net/xfrm/xfrm_policy.c:3188
 ip_route_output_flow+0xa6/0xc0 net/ipv4/route.c:2769
 udp_sendmsg+0x1a16/0x26c0 net/ipv4/udp.c:1201
 udpv6_sendmsg+0x14dd/0x2b90 net/ipv6/udp.c:1344
 inet6_sendmsg+0x99/0xe0 net/ipv6/af_inet6.c:638
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x331/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmmsg+0x195/0x480 net/socket.c:2497
 __do_sys_sendmmsg net/socket.c:2526 [inline]
 __se_sys_sendmmsg net/socket.c:2523 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2523
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45d5f9
Code: 5d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f8aa009cc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 0000000000027a40 RCX: 000000000045d5f9
RDX: 00000000000005c3 RSI: 0000000020000240 RDI: 0000000000000004
RBP: 000000000118cf88 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cf4c
R13: 000000000169fb6f R14: 00007f8aa009d9c0 R15: 000000000118cf4c


addr ffffc9001914f55c is located in stack of task syz-executor.4/15633 at offset 220 in frame:
 udp_sendmsg+0x0/0x26c0 net/ipv4/udp.c:2708

this frame has 5 objects:
 [32, 40) 'rt'
 [64, 104) 'ipc'
 [144, 200) 'fl4_stack'
 [240, 296) 'cork'
 [336, 408) 'opt_copy'

Memory state around the buggy address:
 ffffc9001914f400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffffc9001914f480: f1 f1 f1 f1 00 f2 f2 f2 00 00 00 00 00 f2 f2 f2
>ffffc9001914f500: f2 f2 00 00 00 00 00 00 00 f2 f2 f2 f2 f2 00 00
                                                    ^
 ffffc9001914f580: 00 00 00 00 00 f2 f2 f2 f2 f2 00 00 00 00 00 00
 ffffc9001914f600: 00 00 00 f3 f3 f3 f3 f3 00 00 00 00 00 00 00 00
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
