Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3999487681
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 12:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347117AbiAGLaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 06:30:22 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:40856 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347124AbiAGLaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 06:30:22 -0500
Received: by mail-il1-f199.google.com with SMTP id k2-20020a056e02156200b002b6978faaceso1866678ilu.7
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 03:30:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=twH3lIsDg1mK6ZZSNQSJNyI5AQBsCC6K6+Ds2Qz7NWk=;
        b=Nl8BaPDXNcNEEz5QfGgooPYhED1GCarzmHlBwUaux2WXL+SeKfS0+sNRnM07enT5IX
         LcdIBDcOgSf9IML2D4Scub9Yacu+ykwcH1kWVvF2pMV2H7jkg1hlJ2DqXNOwq3KWxndd
         Pv8ddO/YphsqkVmniWiUEpKCojfPPp+WuDcCqZujhbY9a2klJTMJQ7bdLQt9W4Wq/wdb
         wS0jnfd8utC7h6aDZvav9NFMOFLz/XmIFkg4nc1wyP4WikSR4QEEaKhJ+eGo3phYAg4Q
         jhdScI2GLZCV3DXtE7apqPJbH6n9fHmnZ7f6T/Tbx7ryEkAzkKFY/2BGyFTqsyl7n6eD
         wj6w==
X-Gm-Message-State: AOAM531QdNG+bt1uk2yHM48wbJL7lyWdUgf+s4USJMYettSNdVuIgSld
        P+Q3xRBMT4g4Xj939C3zUjqPKgEenSLztQTj4X5/oa+bu6OU
X-Google-Smtp-Source: ABdhPJx8+AuwAbAyNythFIFEgT9WXemyq3V4aiVKpF35RZGmzmc1IDHPqct/QgSSivDa9dO9u0zHh2QWwMTSfHQM4KqSie6FNJrE
MIME-Version: 1.0
X-Received: by 2002:a05:6638:4192:: with SMTP id az18mr29573189jab.252.1641555021228;
 Fri, 07 Jan 2022 03:30:21 -0800 (PST)
Date:   Fri, 07 Jan 2022 03:30:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000eb759205d4fc4f58@google.com>
Subject: [syzbot] KMSAN: uninit-value in ip_fast_csum (2)
From:   syzbot <syzbot+2e4b07b74e6ce750cd4d@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, dsahern@kernel.org,
        glider@google.com, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    81c325bbf94e kmsan: hooks: do not check memory in kmsan_in..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=11fb290db00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2d8b9a11641dc9aa
dashboard link: https://syzkaller.appspot.com/bug?extid=2e4b07b74e6ce750cd4d
compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2e4b07b74e6ce750cd4d@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in do_csum lib/checksum.c:51 [inline]
BUG: KMSAN: uninit-value in ip_fast_csum+0x429/0x5b0 lib/checksum.c:108
 do_csum lib/checksum.c:51 [inline]
 ip_fast_csum+0x429/0x5b0 lib/checksum.c:108
 ip_send_check net/ipv4/ip_output.c:95 [inline]
 ip_frag_next+0xd92/0xfd0 net/ipv4/ip_output.c:740
 ip_do_fragment+0x1158/0x2a30 net/ipv4/ip_output.c:886
 ip_fragment+0x378/0x4e0
 __ip_finish_output+0x69b/0x960 net/ipv4/ip_output.c:297
 ip_finish_output+0x15c/0x4d0 net/ipv4/ip_output.c:309
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0x333/0x6d0 net/ipv4/ip_output.c:423
 dst_output include/net/dst.h:450 [inline]
 NF_HOOK+0x180/0x450 include/linux/netfilter.h:307
 raw_send_hdrinc+0x1a42/0x1f20 net/ipv4/raw.c:429
 raw_sendmsg+0x276d/0x2e90 net/ipv4/raw.c:660
 inet_sendmsg+0x15b/0x1d0 net/ipv4/af_inet.c:819
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 kernel_sendmsg+0x22c/0x2f0 net/socket.c:744
 sock_no_sendpage+0x227/0x2c0 net/core/sock.c:3080
 inet_sendpage+0x2c2/0x2f0 net/ipv4/af_inet.c:834
 kernel_sendpage+0x4a0/0x5a0 net/socket.c:3504
 sock_sendpage+0x161/0x1a0 net/socket.c:1003
 pipe_to_sendpage+0x3f1/0x510 fs/splice.c:364
 splice_from_pipe_feed fs/splice.c:418 [inline]
 __splice_from_pipe+0x5c3/0x1000 fs/splice.c:562
 splice_from_pipe fs/splice.c:597 [inline]
 generic_splice_sendpage+0x1d5/0x2c0 fs/splice.c:746
 do_splice_from fs/splice.c:767 [inline]
 direct_splice_actor+0x1a4/0x240 fs/splice.c:936
 splice_direct_to_actor+0xa7a/0x1410 fs/splice.c:891
 do_splice_direct+0x3b2/0x600 fs/splice.c:979
 do_sendfile+0xe3c/0x1f50 fs/read_write.c:1245
 __do_sys_sendfile64 fs/read_write.c:1310 [inline]
 __se_sys_sendfile64 fs/read_write.c:1296 [inline]
 __x64_sys_sendfile64+0x367/0x400 fs/read_write.c:1296
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:524 [inline]
 slab_alloc_node mm/slub.c:3251 [inline]
 __kmalloc_node_track_caller+0xe0c/0x1510 mm/slub.c:4974
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 __alloc_skb+0x545/0xf90 net/core/skbuff.c:426
 alloc_skb include/linux/skbuff.h:1126 [inline]
 ip_frag_next+0x1b9/0xfd0 net/ipv4/ip_output.c:686
 ip_do_fragment+0x1158/0x2a30 net/ipv4/ip_output.c:886
 ip_fragment+0x378/0x4e0
 __ip_finish_output+0x69b/0x960 net/ipv4/ip_output.c:297
 ip_finish_output+0x15c/0x4d0 net/ipv4/ip_output.c:309
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0x333/0x6d0 net/ipv4/ip_output.c:423
 dst_output include/net/dst.h:450 [inline]
 NF_HOOK+0x180/0x450 include/linux/netfilter.h:307
 raw_send_hdrinc+0x1a42/0x1f20 net/ipv4/raw.c:429
 raw_sendmsg+0x276d/0x2e90 net/ipv4/raw.c:660
 inet_sendmsg+0x15b/0x1d0 net/ipv4/af_inet.c:819
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 kernel_sendmsg+0x22c/0x2f0 net/socket.c:744
 sock_no_sendpage+0x227/0x2c0 net/core/sock.c:3080
 inet_sendpage+0x2c2/0x2f0 net/ipv4/af_inet.c:834
 kernel_sendpage+0x4a0/0x5a0 net/socket.c:3504
 sock_sendpage+0x161/0x1a0 net/socket.c:1003
 pipe_to_sendpage+0x3f1/0x510 fs/splice.c:364
 splice_from_pipe_feed fs/splice.c:418 [inline]
 __splice_from_pipe+0x5c3/0x1000 fs/splice.c:562
 splice_from_pipe fs/splice.c:597 [inline]
 generic_splice_sendpage+0x1d5/0x2c0 fs/splice.c:746
 do_splice_from fs/splice.c:767 [inline]
 direct_splice_actor+0x1a4/0x240 fs/splice.c:936
 splice_direct_to_actor+0xa7a/0x1410 fs/splice.c:891
 do_splice_direct+0x3b2/0x600 fs/splice.c:979
 do_sendfile+0xe3c/0x1f50 fs/read_write.c:1245
 __do_sys_sendfile64 fs/read_write.c:1310 [inline]
 __se_sys_sendfile64 fs/read_write.c:1296 [inline]
 __x64_sys_sendfile64+0x367/0x400 fs/read_write.c:1296
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

CPU: 1 PID: 6492 Comm: syz-executor.3 Not tainted 5.16.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
