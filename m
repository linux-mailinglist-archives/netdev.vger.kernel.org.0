Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8422271A54
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 07:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgIUFMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 01:12:22 -0400
Received: from mail-io1-f78.google.com ([209.85.166.78]:51286 "EHLO
        mail-io1-f78.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgIUFMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 01:12:22 -0400
Received: by mail-io1-f78.google.com with SMTP id q12so9139686iob.18
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 22:12:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Ds3GkKEaOskN3v3iZHyWFgI5IXn4mwKM9v/O5vRR7ew=;
        b=eJrzh/FeKR2VNMXOOkwBoZoYOhjOI/HxvSi+oBQQ1gXZLpIWvG27s0D1qvi8urYSOo
         HxKRa9Z5GS2KiK0B+g2k/OnbZa9rJP+kbf8KYmE+WQrJQTTWl294YKmjlZwS7KNmTfD0
         Jj3ZGkGchcbDv2SdJZ854q8KsBVa8a4fd8OQb2fsszWnjCm50QiXfAIV2txKwZrbE3BC
         xG15ZxEFrM8jknJrCNbodPGgBsm5uwsFAvOktC7X1ICKY/yttW4RLN1TE5u71LBEAIE4
         ml7z3em6t4PXZxpEkzvIaEsi2MXUIbXHsvnmdpmevom9xbZXRxeNpnnHy+d25ll6NORn
         HoMw==
X-Gm-Message-State: AOAM530/uRhy28WPbxpnFNwbtSdEuDz58BNw3d93Iv+NILnGmKisgBqj
        YfriSsi+Sfj6y2XGkXQ6z+grVlSt9qwdWD3DvCvJ99zh1Q2u
X-Google-Smtp-Source: ABdhPJz+F8J8NwBY2tAz5v72BRt9HldYud/npOCxSObZ0/VIVnPtUTjwJ7fAq4nkUtQT3P/8MkzG7djOAQoPkTBZF3vMFDlf142m
MIME-Version: 1.0
X-Received: by 2002:a5e:9419:: with SMTP id q25mr35583038ioj.205.1600665141281;
 Sun, 20 Sep 2020 22:12:21 -0700 (PDT)
Date:   Sun, 20 Sep 2020 22:12:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000026880b05afcbe562@google.com>
Subject: KMSAN: uninit-value in hsr_fill_frame_info
From:   syzbot <syzbot+e267bed19bfc5478fb33@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, m-karicheri2@ti.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c5a13b33 kmsan: clang-format core
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=13ef204b900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20f149ad694ba4be
dashboard link: https://syzkaller.appspot.com/bug?extid=e267bed19bfc5478fb33
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1015be73900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1185669b900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e267bed19bfc5478fb33@syzkaller.appspotmail.com

hsr0: VLAN not yet supported
=====================================================
BUG: KMSAN: uninit-value in hsr_fill_frame_info+0x3d3/0x570 net/hsr/hsr_forward.c:457
CPU: 1 PID: 8700 Comm: syz-executor512 Not tainted 5.9.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:122
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:219
 hsr_fill_frame_info+0x3d3/0x570 net/hsr/hsr_forward.c:457
 fill_frame_info net/hsr/hsr_forward.c:520 [inline]
 hsr_forward_skb+0xc63/0x2610 net/hsr/hsr_forward.c:537
 hsr_dev_xmit+0x133/0x230 net/hsr/hsr_device.c:220
 __netdev_start_xmit include/linux/netdevice.h:4634 [inline]
 netdev_start_xmit include/linux/netdevice.h:4648 [inline]
 xmit_one+0x3cf/0x750 net/core/dev.c:3561
 dev_hard_start_xmit net/core/dev.c:3577 [inline]
 __dev_queue_xmit+0x3aad/0x4470 net/core/dev.c:4136
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
RIP: 0033:0x443d79
Code: e8 8c 07 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 bb 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffdeb5a7c88 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000443d79
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00007ffdeb5a7ca0 R08: 0000000020000000 R09: 0000000000000014
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffdeb5a7cb0
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

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
