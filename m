Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E341F0580
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 08:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbgFFGxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 02:53:17 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:42008 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgFFGxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jun 2020 02:53:17 -0400
Received: by mail-il1-f200.google.com with SMTP id j71so7987011ilg.9
        for <netdev@vger.kernel.org>; Fri, 05 Jun 2020 23:53:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=YHGzKlRr1x6wwe8+Xsd7XnVO9fRZA3zp66TEx6YNRM4=;
        b=UBANlLnPcrRtREMGE5K81eEaDind/Uolf7+gkqb0i4ZzaNA/rjeHxUMsJ1YkQ6E6C3
         w0vPbUMvh9ISYqLKjMnMs1NMU2ln/aMJousONtJ7iZOCmCLWqUWBpre6I43SjQplsfJx
         kol9Wbth7L+g+4zhSB/a0E/42SGReg49jNwADd/2Mva7obG+9PjrCJvS7b8JSZujUrXq
         5XG6SqWPO3F4J8cXrn+xfFTA8H7Ylz0eFFJp9XYJq6081HvGLUDOAsvy/qEcWwYeFctW
         uZxSSJuBfa4qbVebUmk6yzNz0OJPDcY50hA9edTST+VC7c6pKsJpG0D0qVBDrBl5Ruv/
         cI+w==
X-Gm-Message-State: AOAM533vMtWxNFbggZ/6mF4PPErzHzOAphGtJLzHqJ4zzTgzr7DQHhaE
        +ku6H9DNO4felb+Rh9FcOyrYv5csvey0LB8fncpnK2iJgDOq
X-Google-Smtp-Source: ABdhPJy4/P7iEG0CqThevVgFExOxhIMriL6fmbiKTYRSFhBPA3ikqmu7n9qIyuu6SkDU5iXOEunr4/hu0K4ghkGSOdOC/h1Kyoqc
MIME-Version: 1.0
X-Received: by 2002:a6b:8d44:: with SMTP id p65mr11887540iod.24.1591426395917;
 Fri, 05 Jun 2020 23:53:15 -0700 (PDT)
Date:   Fri, 05 Jun 2020 23:53:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000003d19705a764d5ee@google.com>
Subject: KMSAN: uninit-value in slhc_compress (2)
From:   syzbot <syzbot+801c60509310ac8083dd@syzkaller.appspotmail.com>
To:     adobriyan@gmail.com, davem@davemloft.net, edumazet@google.com,
        glider@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f0d5ec90 kmsan: apply __no_sanitize_memory to dotraplinkag..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=12a3dcca100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=86e4f8af239686c6
dashboard link: https://syzkaller.appspot.com/bug?extid=801c60509310ac8083dd
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+801c60509310ac8083dd@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in slhc_compress+0x2c5/0x2fb0 drivers/net/slip/slhc.c:251
CPU: 0 PID: 18018 Comm: syz-executor.3 Not tainted 5.7.0-rc4-syzkaller #0
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
RIP: 0033:0x45ca69
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f1e75341c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000128
RAX: ffffffffffffffda RBX: 00000000004facc0 RCX: 000000000045ca69
RDX: 1000000000000021 RSI: 00000000200003c0 RDI: 0000000000000006
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000879 R14: 00000000004cb58e R15: 00007f1e753426d4

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


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
