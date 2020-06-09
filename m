Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22BFA1F48C3
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 23:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgFIVVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 17:21:30 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:39637 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbgFIVV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 17:21:28 -0400
Received: by mail-il1-f200.google.com with SMTP id o12so50896ilf.6
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 14:21:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=NSyl9LGsAtmwy93eIPaRM+kNwixkelOTwR/Z9dLPDoI=;
        b=VPWs7hiXCAo+h7gYpIiShjQP+lis5sqsFtv/jATOUPuLxPylLGOti/L/uzc+Bg/xtl
         wia32BEAiFz8MP40oaBiNJ7gpyVz1gjsOAcPIaxMKIM+x7QIKifqu5opsL/vMrOvqCH6
         fXsbdMWWGFZkBGpCHqOTjIi+5Dta/gTHokqrszh/9/7kKmUgDqD0L8AlNTurdzzPQuW6
         SCRCt574fO62jrqD4rCa/8LUO1EU+1tDhoiyo1klDY8BmRH4nI1ZMcq11VP6GulpWLsk
         5cWgi/nxLWLFetI/PkCb7Y7DoNwSceHTqFdb3vhALw8IDkYOG5P7HR/6O6jNZdYOlHrE
         gluA==
X-Gm-Message-State: AOAM531xDnUjO4wWNuQS+D230fv1e6NwiewaRxmQgT+gd49TJbTrxS30
        dGxC6b1p71MgBVltWTc1B9VndSGVLeJ+653ZS4NrAWGc+Wpd
X-Google-Smtp-Source: ABdhPJwto8akOcvT4yl7dgwb+4TYYWnVdkWbAqBEJHGcVxXjBKZsKBCHNOiDvm5gg++yi2HEiBp+osqyMVLuYjyCsBMwEYmeppbG
MIME-Version: 1.0
X-Received: by 2002:a6b:ea10:: with SMTP id m16mr75992ioc.180.1591737687789;
 Tue, 09 Jun 2020 14:21:27 -0700 (PDT)
Date:   Tue, 09 Jun 2020 14:21:27 -0700
In-Reply-To: <00000000000003d19705a764d5ee@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000074d91105a7ad4fe9@google.com>
Subject: Re: KMSAN: uninit-value in slhc_compress (2)
From:   syzbot <syzbot+801c60509310ac8083dd@syzkaller.appspotmail.com>
To:     adobriyan@gmail.com, davem@davemloft.net, edumazet@google.com,
        glider@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    f0d5ec90 kmsan: apply __no_sanitize_memory to dotraplinkag..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=10495a36100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=86e4f8af239686c6
dashboard link: https://syzkaller.appspot.com/bug?extid=801c60509310ac8083dd
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a2b432100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=164753a6100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+801c60509310ac8083dd@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in slhc_compress+0x2c5/0x2fb0 drivers/net/slip/slhc.c:251
CPU: 0 PID: 9204 Comm: syz-executor789 Not tainted 5.7.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 slhc_compress+0x2c5/0x2fb0 drivers/net/slip/slhc.c:251
 ppp_send_frame drivers/net/ppp/ppp_generic.c:1637 [inline]
 __ppp_xmit_process+0x1902/0x2970 drivers/net/ppp/ppp_generic.c:1495
 ppp_xmit_process+0x147/0x2f0 drivers/net/ppp/ppp_generic.c:1516
 ppp_write+0x6bb/0x790 drivers/net/ppp/ppp_generic.c:512
 do_loop_readv_writev fs/read_write.c:718 [inline]
 do_iter_write+0xa0a/0xdc0 fs/read_write.c:1001
 vfs_writev fs/read_write.c:1072 [inline]
 do_pwritev+0x487/0x7d0 fs/read_write.c:1169
 __do_sys_pwritev fs/read_write.c:1216 [inline]
 __se_sys_pwritev+0xc6/0xe0 fs/read_write.c:1211
 __x64_sys_pwritev+0x62/0x80 fs/read_write.c:1211
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:297
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4412f9
Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd3ec8cf78 EFLAGS: 00000246 ORIG_RAX: 0000000000000128
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004412f9
RDX: 0000000000000003 RSI: 0000000020000480 RDI: 0000000000000003
RBP: 0000000000014688 R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402120
R13: 00000000004021b0 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:80
 slab_alloc_node mm/slub.c:2802 [inline]
 __kmalloc_node_track_caller+0xb40/0x1200 mm/slub.c:4436
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2fd/0xac0 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1083 [inline]
 ppp_write+0x115/0x790 drivers/net/ppp/ppp_generic.c:500
 do_loop_readv_writev fs/read_write.c:718 [inline]
 do_iter_write+0xa0a/0xdc0 fs/read_write.c:1001
 vfs_writev fs/read_write.c:1072 [inline]
 do_pwritev+0x487/0x7d0 fs/read_write.c:1169
 __do_sys_pwritev fs/read_write.c:1216 [inline]
 __se_sys_pwritev+0xc6/0xe0 fs/read_write.c:1211
 __x64_sys_pwritev+0x62/0x80 fs/read_write.c:1211
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:297
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================

