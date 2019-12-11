Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3286411BA8B
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 18:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730388AbfLKRpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 12:45:12 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:44842 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730158AbfLKRpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 12:45:11 -0500
Received: by mail-il1-f199.google.com with SMTP id h87so17678798ild.11
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 09:45:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=bGzEf9LzAP4gAwQXTzFAj2TI2z3taIqnFPDrr/8/SGg=;
        b=PeoCE0cVUenyIC2orO5TUJLUKnfW4BIVESG23RWinQKtdMMn5I2LxhyWYDvpf6IdXa
         JQkQfYajiDWqcVgg1LOqfgLvQXCUJU8B40OobeNCqKTfXTGPjyGR4j3cKcL/vCjbiOrh
         VNkWFkHYNaoAKgeZULx5j8LlaqHzvPVVB2eW3KAqoW6Jx58uo3pp1Va67R2+XDxz1p2r
         HBXbgJ68v4ct1oCjqPNN1dCVRhpdsWhHXXALIuHcyuRU2cEhAhAj2TI85fgsd0NSkxE+
         FuCacv52WofTPm1RnrwmC1MKUxobsj9EWx6RiYL8y0ur8vXksbnxOXZaEid+mY9u3PY6
         2tzQ==
X-Gm-Message-State: APjAAAVo/BYAhza2S9Ork9d74FPM5NA2Iy6WCgdM3L4BmC/J+ZxOmE+u
        BLjpfM10tZuX4ZEw+Qo2XmIVHsvaeGIkox30iUmBO7PhKSN/
X-Google-Smtp-Source: APXvYqzUUKN1p5zT2a4uMPfP7ORghqGAEJstkGMCW1zjf9dai9MpVLMMFFxPltPBFa/6Sn104Ldm1BARPYI1J8scjMCseLRMw9Fj
MIME-Version: 1.0
X-Received: by 2002:a92:1f16:: with SMTP id i22mr4345985ile.206.1576086310881;
 Wed, 11 Dec 2019 09:45:10 -0800 (PST)
Date:   Wed, 11 Dec 2019 09:45:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b214580599713029@google.com>
Subject: KMSAN: uninit-value in __tipc_nl_compat_dumpit
From:   syzbot <syzbot+b1fd2bf2c89d8407e15f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, jon.maloy@ericsson.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    5ef742ba net: kasan: kmsan: support CONFIG_GENERIC_CSUM on..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=11b40861e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8fd289db07d24f0c
dashboard link: https://syzkaller.appspot.com/bug?extid=b1fd2bf2c89d8407e15f
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13f45aeae00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17560232e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b1fd2bf2c89d8407e15f@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in __nlmsg_parse include/net/netlink.h:661 [inline]
BUG: KMSAN: uninit-value in nlmsg_parse_deprecated  
include/net/netlink.h:706 [inline]
BUG: KMSAN: uninit-value in __tipc_nl_compat_dumpit+0x553/0x11e0  
net/tipc/netlink_compat.c:215
CPU: 0 PID: 12425 Comm: syz-executor062 Not tainted 5.5.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c9/0x220 lib/dump_stack.c:118
  kmsan_report+0x128/0x220 mm/kmsan/kmsan_report.c:108
  __msan_warning+0x57/0xa0 mm/kmsan/kmsan_instr.c:245
  __nlmsg_parse include/net/netlink.h:661 [inline]
  nlmsg_parse_deprecated include/net/netlink.h:706 [inline]
  __tipc_nl_compat_dumpit+0x553/0x11e0 net/tipc/netlink_compat.c:215
  tipc_nl_compat_dumpit+0x761/0x910 net/tipc/netlink_compat.c:308
  tipc_nl_compat_handle net/tipc/netlink_compat.c:1252 [inline]
  tipc_nl_compat_recv+0x12e9/0x2870 net/tipc/netlink_compat.c:1311
  genl_family_rcv_msg_doit net/netlink/genetlink.c:672 [inline]
  genl_family_rcv_msg net/netlink/genetlink.c:717 [inline]
  genl_rcv_msg+0x1dd0/0x23a0 net/netlink/genetlink.c:734
  netlink_rcv_skb+0x431/0x620 net/netlink/af_netlink.c:2477
  genl_rcv+0x63/0x80 net/netlink/genetlink.c:745
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0xfa0/0x1100 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x11f0/0x1480 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:639 [inline]
  sock_sendmsg net/socket.c:659 [inline]
  ____sys_sendmsg+0x1362/0x13f0 net/socket.c:2330
  ___sys_sendmsg net/socket.c:2384 [inline]
  __sys_sendmsg+0x4f0/0x5e0 net/socket.c:2417
  __do_sys_sendmsg net/socket.c:2426 [inline]
  __se_sys_sendmsg+0x97/0xb0 net/socket.c:2424
  __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2424
  do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:295
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x444179
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 1b d8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd2d6409c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002e0 RCX: 0000000000444179
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 00000000006ce018 R08: 0000000000000000 R09: 00000000004002e0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401e20
R13: 0000000000401eb0 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:149 [inline]
  kmsan_internal_poison_shadow+0x5c/0x110 mm/kmsan/kmsan.c:132
  kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:86
  slab_alloc_node mm/slub.c:2774 [inline]
  __kmalloc_node_track_caller+0xe47/0x11f0 mm/slub.c:4382
  __kmalloc_reserve net/core/skbuff.c:141 [inline]
  __alloc_skb+0x309/0xa50 net/core/skbuff.c:209
  alloc_skb include/linux/skbuff.h:1049 [inline]
  nlmsg_new include/net/netlink.h:888 [inline]
  tipc_nl_compat_dumpit+0x6e4/0x910 net/tipc/netlink_compat.c:301
  tipc_nl_compat_handle net/tipc/netlink_compat.c:1252 [inline]
  tipc_nl_compat_recv+0x12e9/0x2870 net/tipc/netlink_compat.c:1311
  genl_family_rcv_msg_doit net/netlink/genetlink.c:672 [inline]
  genl_family_rcv_msg net/netlink/genetlink.c:717 [inline]
  genl_rcv_msg+0x1dd0/0x23a0 net/netlink/genetlink.c:734
  netlink_rcv_skb+0x431/0x620 net/netlink/af_netlink.c:2477
  genl_rcv+0x63/0x80 net/netlink/genetlink.c:745
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0xfa0/0x1100 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x11f0/0x1480 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:639 [inline]
  sock_sendmsg net/socket.c:659 [inline]
  ____sys_sendmsg+0x1362/0x13f0 net/socket.c:2330
  ___sys_sendmsg net/socket.c:2384 [inline]
  __sys_sendmsg+0x4f0/0x5e0 net/socket.c:2417
  __do_sys_sendmsg net/socket.c:2426 [inline]
  __se_sys_sendmsg+0x97/0xb0 net/socket.c:2424
  __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2424
  do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:295
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
