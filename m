Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB6286761
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 18:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390259AbfHHQpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 12:45:07 -0400
Received: from mail-ot1-f72.google.com ([209.85.210.72]:55595 "EHLO
        mail-ot1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390243AbfHHQpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 12:45:06 -0400
Received: by mail-ot1-f72.google.com with SMTP id p7so62887479otk.22
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 09:45:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=CTN/UWjTmOzg5lWgh/1z4OS5rMon92kj3u7gixuyddI=;
        b=dZdTy/hM5Hjn/1GzHlvXHUsqazpddtO2nbOjxH7Kg8RciE7OLLHkbFonEBX+4jFOOB
         1cBuQJYl9Qp7OLo7phOird1di1Ci/FwWqDqaDhj+8bx5HpbAuhLaXlGBEpn9qh1a2UCs
         orZgrL09iKf4AvfbuJ8PDwHM95fM1f5F+YBNT6dxB2B7Sdm55bQKpW5835dAavR+mqEf
         etagL4Uj0uCNX9OlV4OVaHextj3VCAhEhdAFYyrsEK9qEktVcLuy05kKDCTCVv2rW+1O
         SKh7vdCrjx/o9E9w7EzeZAJBit/bOrfmAh1Xg2R9ZEaFkXwh0IWudl1+xwB80xwXQD0t
         VGWQ==
X-Gm-Message-State: APjAAAU66LTl+Sv+3icKqZvzaJufsK3j3pa4mklqn+kyBjwt+losdV9t
        5N6LZo1iK6akusFP2RTNDzwSHqJQGRfQ2Megabq4UvieR/LL
X-Google-Smtp-Source: APXvYqyp+n8vo6H1NRj68YFZPvskIq0GKhnXnfwzys6Mb7jCF82DrbJHZzW8YdVq8vPIft52GgmkWoOP9cnuQUPEzbj4k3B8p/av
MIME-Version: 1.0
X-Received: by 2002:a02:c615:: with SMTP id i21mr1483678jan.135.1565282705702;
 Thu, 08 Aug 2019 09:45:05 -0700 (PDT)
Date:   Thu, 08 Aug 2019 09:45:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a585f2058f9dc7b3@google.com>
Subject: WARNING in xfrm_policy_inexact_list_reinsert
From:   syzbot <syzbot+8cc27ace5f6972910b31@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    4010b622 Merge branch 'dax-fix-5.3-rc3' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13e2829fa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e397351d2615e10
dashboard link: https://syzkaller.appspot.com/bug?extid=8cc27ace5f6972910b31
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+8cc27ace5f6972910b31@syzkaller.appspotmail.com

WARNING: CPU: 1 PID: 6756 at net/xfrm/xfrm_policy.c:877  
xfrm_policy_inexact_list_reinsert+0x625/0x6e0 net/xfrm/xfrm_policy.c:877
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 6756 Comm: syz-executor.1 Not tainted 5.3.0-rc2+ #57
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1d8/0x2f8 lib/dump_stack.c:113
  panic+0x29b/0x7d9 kernel/panic.c:219
  __warn+0x22f/0x230 kernel/panic.c:576
  report_bug+0x190/0x290 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  do_error_trap+0xd7/0x440 arch/x86/kernel/traps.c:272
  do_invalid_op+0x36/0x40 arch/x86/kernel/traps.c:291
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1026
RIP: 0010:xfrm_policy_inexact_list_reinsert+0x625/0x6e0  
net/xfrm/xfrm_policy.c:877
Code: ef e8 6f 32 0f fb 4d 8b 6d 00 4c 39 6d 90 0f 85 81 fa ff ff e9 b0 00  
00 00 e8 c7 87 d4 fa 0f 0b e9 fa fa ff ff e8 bb 87 d4 fa <0f> 0b e9 75 ff  
ff ff e8 af 87 d4 fa 0f 0b eb a9 44 89 f1 80 e1 07
RSP: 0018:ffff888052caf080 EFLAGS: 00010283
RAX: ffffffff86a35975 RBX: 00000000ffffff20 RCX: 0000000000040000
RDX: ffffc9000816a000 RSI: 00000000000005cd RDI: 00000000000005ce
RBP: ffff888052caf110 R08: ffffffff86a358ac R09: ffffffff86a3514c
R10: ffff88805914c380 R11: 0000000000000002 R12: 0000000000000000
R13: ffff888092fa6aa0 R14: 000000000000007e R15: 000000000000000a
  xfrm_policy_inexact_node_reinsert net/xfrm/xfrm_policy.c:922 [inline]
  xfrm_policy_inexact_node_merge net/xfrm/xfrm_policy.c:958 [inline]
  xfrm_policy_inexact_insert_node+0x537/0xb50 net/xfrm/xfrm_policy.c:1023
  xfrm_policy_inexact_alloc_chain+0x62b/0xbd0 net/xfrm/xfrm_policy.c:1139
  xfrm_policy_inexact_insert+0xe8/0x1540 net/xfrm/xfrm_policy.c:1182
  xfrm_policy_insert+0xdf/0xce0 net/xfrm/xfrm_policy.c:1574
  xfrm_add_policy+0x4cf/0x9b0 net/xfrm/xfrm_user.c:1670
  xfrm_user_rcv_msg+0x46b/0x720 net/xfrm/xfrm_user.c:2676
  netlink_rcv_skb+0x1f0/0x460 net/netlink/af_netlink.c:2477
  xfrm_netlink_rcv+0x74/0x90 net/xfrm/xfrm_user.c:2684
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x809/0x9a0 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0xa70/0xd30 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg net/socket.c:657 [inline]
  ___sys_sendmsg+0x66b/0x9a0 net/socket.c:2311
  __sys_sendmsg net/socket.c:2356 [inline]
  __do_sys_sendmsg net/socket.c:2365 [inline]
  __se_sys_sendmsg net/socket.c:2363 [inline]
  __x64_sys_sendmsg+0x1cf/0x290 net/socket.c:2363
  do_syscall_64+0xfe/0x140 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459829
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f16cc51ec78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459829
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f16cc51f6d4
R13: 00000000004c776b R14: 00000000004dceb8 R15: 00000000ffffffff
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
