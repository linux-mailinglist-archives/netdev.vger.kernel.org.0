Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0085276D50
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 11:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727694AbgIXJ1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 05:27:07 -0400
Received: from mail-io1-f80.google.com ([209.85.166.80]:48115 "EHLO
        mail-io1-f80.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727352AbgIXJ02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 05:26:28 -0400
Received: by mail-io1-f80.google.com with SMTP id a15so1924895ioc.14
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 02:26:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=lKlrAGi+eyrd8zC5Zvr/WU9bXgo79OUvMpHFZeKuFmw=;
        b=Z4V/9gHr7GHGO3LjLfdCXlZWjIVCfqCyBRJihmm4VO56ClkaUeqcdWZ5KYOdbW2DLi
         bgLMOqLRfbIfiEkToyufZ9XQcS3AMoy7gHBEdSxv4YByw7j4LKeatbRbivmnXgb+8L5g
         V1USA5pxJyb6otVAGVGeuALxv2MRIYZwiD1TogpwcXA81DapWX+gw0JpKRktlma6V8Y0
         bvOR9qAhoDc+J6JNR0SSQ4etCEKjqZaX7a99hLo94fXFMvSfY59fd4QSk7HgG8VkUv/R
         3LtMinzhgmB7v72otVVmIP2VxvPLQeLBYp8aLSGmJ264cJO42QXpTc7taVG4avfiYDYD
         /LoA==
X-Gm-Message-State: AOAM530VjVG0EoOzk+Qez8gWyn7wxLsFLfpHGk7lXQcPURJY6Eh3+KEe
        ID7w4J7BNDGOkAWBUanCNjCTdtan0vdE2pB0NVpupd+Gyfaf
X-Google-Smtp-Source: ABdhPJw9jg/gq+1ZA5IdnhW4HLsVV4Cdn6aEtihx4wg6L+dXlAjcGYm79ogPqjFkSH35WhM+zX7Ilecn7xhuEa/czHZyMab1y5OI
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2d55:: with SMTP id d21mr2522579iow.134.1600939586782;
 Thu, 24 Sep 2020 02:26:26 -0700 (PDT)
Date:   Thu, 24 Sep 2020 02:26:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000608c1705b00bcb89@google.com>
Subject: KMSAN: uninit-value in ieee80211_skb_resize
From:   syzbot <syzbot+32fd1a1bfe355e93f1e2@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, johannes@sipsolutions.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c5a13b33 kmsan: clang-format core
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1366df53900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20f149ad694ba4be
dashboard link: https://syzkaller.appspot.com/bug?extid=32fd1a1bfe355e93f1e2
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14e95cd3900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11abf481900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+32fd1a1bfe355e93f1e2@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in ieee80211_skb_resize+0x8c0/0x980 net/mac80211/tx.c:1955
CPU: 0 PID: 8539 Comm: syz-executor053 Not tainted 5.9.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:122
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:219
 ieee80211_skb_resize+0x8c0/0x980 net/mac80211/tx.c:1955
 ieee80211_build_hdr+0x2939/0x41f0 net/mac80211/tx.c:2825
 __ieee80211_subif_start_xmit+0x172a/0x7300 net/mac80211/tx.c:3999
 ieee80211_subif_start_xmit+0x14b/0x19a0 net/mac80211/tx.c:4144
 __netdev_start_xmit include/linux/netdevice.h:4634 [inline]
 netdev_start_xmit include/linux/netdevice.h:4648 [inline]
 xmit_one+0x3cf/0x750 net/core/dev.c:3561
 dev_hard_start_xmit+0x196/0x420 net/core/dev.c:3577
 sch_direct_xmit+0x5d3/0x1a50 net/sched/sch_generic.c:314
 qdisc_restart net/sched/sch_generic.c:377 [inline]
 __qdisc_run+0x35b/0x490 net/sched/sch_generic.c:385
 qdisc_run include/net/pkt_sched.h:134 [inline]
 __dev_xmit_skb net/core/dev.c:3752 [inline]
 __dev_queue_xmit+0x2cfa/0x4470 net/core/dev.c:4105
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4169
 packet_snd net/packet/af_packet.c:2989 [inline]
 packet_sendmsg+0x8542/0x9a80 net/packet/af_packet.c:3014
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 __sys_sendto+0x9dc/0xc80 net/socket.c:1992
 __do_sys_sendto net/socket.c:2004 [inline]
 __se_sys_sendto+0x107/0x130 net/socket.c:2000
 __x64_sys_sendto+0x6e/0x90 net/socket.c:2000
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x441ea9
Code: e8 bc 00 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fffc4414388 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000441ea9
RDX: 000000000000000e RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000004800 R11: 0000000000000246 R12: 0000000000000032
R13: 0000000000000000 R14: 000000000000000c R15: 0000000000000004

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:143 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:126
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:80
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0x9aa/0x12f0 mm/slub.c:4511
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x35f/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1094 [inline]
 alloc_skb_with_frags+0x1f2/0xc10 net/core/skbuff.c:5771
 sock_alloc_send_pskb+0xc83/0xe50 net/core/sock.c:2348
 packet_alloc_skb net/packet/af_packet.c:2837 [inline]
 packet_snd net/packet/af_packet.c:2932 [inline]
 packet_sendmsg+0x6abb/0x9a80 net/packet/af_packet.c:3014
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 __sys_sendto+0x9dc/0xc80 net/socket.c:1992
 __do_sys_sendto net/socket.c:2004 [inline]
 __se_sys_sendto+0x107/0x130 net/socket.c:2000
 __x64_sys_sendto+0x6e/0x90 net/socket.c:2000
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
