Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2FB67AFE1
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 11:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235636AbjAYKmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 05:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235057AbjAYKml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 05:42:41 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1CE21A0D
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:42:40 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id g11-20020a056e021a2b00b0030da3e7916fso12393252ile.18
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:42:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c2orMjLOVvDEreFzT3yDkDcGRcoylFJF29UL7OlIXu4=;
        b=WyylXEUUsafx9WP1wdFcJoYGEGWcZzBMOw+iQY+tmgAEW6STuVS8CPD/C8aFiwo2h/
         EXWTgDcpoFOHa3hK/jgZyRlk+olsrjU/neRzsUa2dAIQjSWZj78PchOXpS0uR8Kg82N+
         4EsTWQ/MkORnpwXTgtLWSvZIR9HyKdO5T9+2XnfC0HkofRdqUFQiskdw9+WpV9torajv
         1isR3G/33NUDoJNIHWP1jzEV0RtNkxxzcZmiHILTHfHp72gQjwjt+RA9YjJVkp86lYU4
         kzpKCN/gEZN8SFxWHD7BjtPjKENhEXlzkMTrlEyjA3xkpaxfVRQeiP1a56io0t4R5LcB
         of9w==
X-Gm-Message-State: AFqh2koy1Jz/dz7ifs3r1Q9hYrW95C4CayCGdExFfOJ8C/LnOiurXhWT
        eqAGgk110IjMhe3Xs3VmlcTIp+gtAML7FuMv7fiFZw2Hi7KG
X-Google-Smtp-Source: AMrXdXsDyHMwPyrfIR3G7jVx7r39rE62in+kvwIsTTWGz8uGjf+f/YEon21aM3hzF0jeA2HWa1EI9UrRxuaVLrb4/JL4/W7nQiTp
MIME-Version: 1.0
X-Received: by 2002:a02:cf9e:0:b0:3a5:73ac:b6c1 with SMTP id
 w30-20020a02cf9e000000b003a573acb6c1mr3306246jar.40.1674643359334; Wed, 25
 Jan 2023 02:42:39 -0800 (PST)
Date:   Wed, 25 Jan 2023 02:42:39 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008f0a6505f3144a6c@google.com>
Subject: [syzbot] KMSAN: uninit-value in qrtr_tx_resume
From:   syzbot <syzbot+4436c9630a45820fda76@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, glider@google.com,
        kuba@kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mani@kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    41c66f470616 kmsan: silence -Wmissing-prototypes warnings
git tree:       https://github.com/google/kmsan.git master
console+strace: https://syzkaller.appspot.com/x/log.txt?x=155a4ffe480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a9a22da1efde3af6
dashboard link: https://syzkaller.appspot.com/bug?extid=4436c9630a45820fda76
compiler:       clang version 15.0.0 (https://github.com/llvm/llvm-project.git 610139d2d9ce6746b3c617fb3e2f7886272d26ff), GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12254a76480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11cdf796480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/69d5eef879e6/disk-41c66f47.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e91a447c44a2/vmlinux-41c66f47.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c549edb9c410/bzImage-41c66f47.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4436c9630a45820fda76@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in qrtr_tx_resume+0x185/0x1f0 net/qrtr/af_qrtr.c:230
 qrtr_tx_resume+0x185/0x1f0 net/qrtr/af_qrtr.c:230
 qrtr_endpoint_post+0xf85/0x11b0 net/qrtr/af_qrtr.c:519
 qrtr_tun_write_iter+0x270/0x400 net/qrtr/tun.c:108
 call_write_iter include/linux/fs.h:2189 [inline]
 aio_write+0x63a/0x950 fs/aio.c:1600
 io_submit_one+0x1d1c/0x3bf0 fs/aio.c:2019
 __do_sys_io_submit fs/aio.c:2078 [inline]
 __se_sys_io_submit+0x293/0x770 fs/aio.c:2048
 __x64_sys_io_submit+0x92/0xd0 fs/aio.c:2048
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:766 [inline]
 slab_alloc_node mm/slub.c:3452 [inline]
 __kmem_cache_alloc_node+0x71f/0xce0 mm/slub.c:3491
 __do_kmalloc_node mm/slab_common.c:967 [inline]
 __kmalloc_node_track_caller+0x114/0x3b0 mm/slab_common.c:988
 kmalloc_reserve net/core/skbuff.c:492 [inline]
 __alloc_skb+0x3af/0x8f0 net/core/skbuff.c:565
 __netdev_alloc_skb+0x120/0x7d0 net/core/skbuff.c:630
 qrtr_endpoint_post+0xbd/0x11b0 net/qrtr/af_qrtr.c:446
 qrtr_tun_write_iter+0x270/0x400 net/qrtr/tun.c:108
 call_write_iter include/linux/fs.h:2189 [inline]
 aio_write+0x63a/0x950 fs/aio.c:1600
 io_submit_one+0x1d1c/0x3bf0 fs/aio.c:2019
 __do_sys_io_submit fs/aio.c:2078 [inline]
 __se_sys_io_submit+0x293/0x770 fs/aio.c:2048
 __x64_sys_io_submit+0x92/0xd0 fs/aio.c:2048
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

CPU: 0 PID: 4984 Comm: syz-executor328 Not tainted 6.2.0-rc5-syzkaller-80200-g41c66f470616 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/12/2023
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
