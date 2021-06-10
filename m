Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C663A33DB
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 21:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhFJTVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 15:21:24 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:40691 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbhFJTVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 15:21:23 -0400
Received: by mail-il1-f198.google.com with SMTP id b4-20020a920b040000b02901dc81bf7e72so2019429ilf.7
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 12:19:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=AZmsQXd5CZpxLe8fqTa7gGyaG//gGPqyJgcMYH0vyds=;
        b=WkVkk83D0DDxU98gk4nYid5YnwtUuf9QdSllPr53J4gcX6iLgBFIRLV7KHYHmLljiy
         Ljev+tH4T26Gu/elJBhP6BHN0b7xSmMlEsk2pdn3C+eMjYjzsLR4C/Hz1ul1WaC/S83z
         Debt8JWQ/EECHza6moJBKi+enWciIQeSBovPeUf1P99BdcPLv8ejACuuPuL0DPBabs56
         Q2cl57lmXrxwHPj+pGF0ZVdBJ+LxMs4ZtY9XfUYWxAMTDHumY1kUcMVv0d5UmDkQOvg6
         UVp4UGVFHGEtniLokqfpJA0XlmlxcMEU9Evxe8kIC4YKR8kalc6JggJQF4gfTmqkpQKH
         EPAw==
X-Gm-Message-State: AOAM53210JtbuFDbzXl+bxEXZJEhMXuk0qCM/dtaDPBCQ8WVSGCaVepm
        JMbnp7qqLk27Cr7FvYZrL6IFgBnDBif5+f4h7oiQB847Cy0U
X-Google-Smtp-Source: ABdhPJwOTuOREVmyJLMfd0rKxf6hD5AT2c32N5qlbJgWMCMcoS80jYs13pv08ezNuKH3FnJRUiOAi7FMzP1cpLmRwXyq2JbusYfK
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2145:: with SMTP id y5mr112285ioy.4.1623352766662;
 Thu, 10 Jun 2021 12:19:26 -0700 (PDT)
Date:   Thu, 10 Jun 2021 12:19:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000008a6c05c46e45a4@google.com>
Subject: [syzbot] UBSAN: shift-out-of-bounds in xfrm_selector_match
From:   syzbot <syzbot+e4c1dd36fc6b98c50859@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    13c62f53 net/sched: act_ct: handle DNAT tuple collision
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=16635470300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=770708ea7cfd4916
dashboard link: https://syzkaller.appspot.com/bug?extid=e4c1dd36fc6b98c50859

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e4c1dd36fc6b98c50859@syzkaller.appspotmail.com

UBSAN: shift-out-of-bounds in ./include/net/xfrm.h:838:23
shift exponent -64 is negative
CPU: 0 PID: 12625 Comm: syz-executor.1 Not tainted 5.13.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:327
 addr4_match include/net/xfrm.h:838 [inline]
 __xfrm4_selector_match net/xfrm/xfrm_policy.c:201 [inline]
 xfrm_selector_match.cold+0x35/0x3a net/xfrm/xfrm_policy.c:227
 xfrm_state_look_at+0x16d/0x440 net/xfrm/xfrm_state.c:1022
 xfrm_state_find+0x16c0/0x4d10 net/xfrm/xfrm_state.c:1096
 xfrm_tmpl_resolve_one net/xfrm/xfrm_policy.c:2394 [inline]
 xfrm_tmpl_resolve+0x2f3/0xd40 net/xfrm/xfrm_policy.c:2439
 xfrm_resolve_and_create_bundle+0x123/0x2590 net/xfrm/xfrm_policy.c:2729
 xfrm_lookup_with_ifid+0x227/0x20e0 net/xfrm/xfrm_policy.c:3063
 xfrm_lookup net/xfrm/xfrm_policy.c:3187 [inline]
 xfrm_lookup_route+0x36/0x1e0 net/xfrm/xfrm_policy.c:3198
 ip_route_output_flow+0x114/0x150 net/ipv4/route.c:2733
 udp_sendmsg+0x1a2f/0x2730 net/ipv4/udp.c:1206
 inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:821
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x331/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmmsg+0x195/0x470 net/socket.c:2490
 __do_sys_sendmmsg net/socket.c:2519 [inline]
 __se_sys_sendmmsg net/socket.c:2516 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2516
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb1023dd188 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665d9
RDX: 000000000800001d RSI: 0000000020007fc0 RDI: 0000000000000003
RBP: 00000000004bfcb9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffc4542d68f R14: 00007fb1023dd300 R15: 0000000000022000
================================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
