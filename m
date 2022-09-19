Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4372D5BC261
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 06:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiISEyj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 19 Sep 2022 00:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiISEyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 00:54:37 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF43E2DD6
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 21:54:35 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id k3-20020a056e02156300b002f5623faa62so3022290ilu.0
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 21:54:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=cFauf4yP9Y+7kIkrAYjg64CBqQa89jBPQijKo3j3WWo=;
        b=V3ssBQkELCinKLzfZQec7nG462luXOPOMxPFZ0TuV2Vc+0H49BjJ+zCWFR6cPsKsLO
         VeOy+Nb9k6Ha2rzCzMKCg7v2pzW8U1dQhD+JzUSUZRL9ZgudXiCXFJfLypM/ImtF7Kev
         hrguhm16qfBRfuMB1tiDaqTiZASKHC1hUTEYhg6AfEajdHiDk5ZHJNrN/gTj6M9loVbm
         x+Vo1Q0NK24fTk2ldTcqoKAg4MyZNgUY0Vi6YwdqXC8Ipc0Q1ERjFkzxz9rrlDOUnkHC
         21kP5t7SjYRuK2K95ZBNlimhPJdJ0JaAoHPmiXUYF/UB7bRJ8IV5DJ2oYtokV2JFfx6/
         8KYw==
X-Gm-Message-State: ACrzQf1348xVxuiKwekNeIGWN8mG7qdzC+/pF68lqQmFCosSnabuTyDd
        +3VG/KUU9HFLG7h8qaGuxxnLuwpe98wkzKMVCcRUiUZfIm7L
X-Google-Smtp-Source: AMsMyM5+Wg39U35ym7vG4ptPnS6gQbFNWoydFNYYWb19c8ZwsOmwbSFyYqp4uMckaSy1hnIbahyvYqYyz4BjpDqf8XcVu8YQRFT8
MIME-Version: 1.0
X-Received: by 2002:a92:6a0d:0:b0:2e5:afe7:8d95 with SMTP id
 f13-20020a926a0d000000b002e5afe78d95mr6882087ilc.262.1663563275238; Sun, 18
 Sep 2022 21:54:35 -0700 (PDT)
Date:   Sun, 18 Sep 2022 21:54:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001506a805e90082ea@google.com>
Subject: [syzbot] WARNING: refcount bug in p9_req_put (2)
From:   syzbot <syzbot+3ba8f2097df93bc26d2f@syzkaller.appspotmail.com>
To:     asmadeus@codewreck.org, davem@davemloft.net, edumazet@google.com,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux_oss@crudebyte.com, lucho@ionkov.net, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
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

HEAD commit:    80e78fcce86d Linux 6.0-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10397700880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d4cc03e6a78af26d
dashboard link: https://syzkaller.appspot.com/bug?extid=3ba8f2097df93bc26d2f
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3ba8f2097df93bc26d2f@syzkaller.appspotmail.com

9p: Unknown Cache mode f��*ux�lI��cache
9pnet: Tag 65535 still in use
------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 1 PID: 11668 at lib/refcount.c:28 refcount_warn_saturate+0x1d1/0x1e0 lib/refcount.c:28
Modules linked in:
CPU: 1 PID: 11668 Comm: syz-executor.3 Not tainted 6.0.0-rc5-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
RIP: 0010:refcount_warn_saturate+0x1d1/0x1e0 lib/refcount.c:28
Code: e9 db fe ff ff 48 89 df e8 1c a6 c9 fd e9 8a fe ff ff e8 62 07 7e fd 48 c7 c7 e0 a0 48 8a c6 05 81 f7 cb 09 01 e8 41 36 3d 05 <0f> 0b e9 af fe ff ff 0f 1f 84 00 00 00 00 00 41 56 41 55 41 54 55
RSP: 0018:ffffc90006bff9f0 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff81611e08 RDI: fffff52000d7ff30
RBP: 0000000000000003 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000001 R12: 0000000000000000
R13: ffff8880706a4808 R14: ffff888025838400 R15: dffffc0000000000
FS:  00007f2496ffe700(0000) GS:ffff88802c900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020003000 CR3: 000000006f38b000 CR4: 0000000000150ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __refcount_sub_and_test include/linux/refcount.h:283 [inline]
 __refcount_dec_and_test include/linux/refcount.h:315 [inline]
 refcount_dec_and_test include/linux/refcount.h:333 [inline]
 p9_req_put+0x1f2/0x250 net/9p/client.c:374
 p9_tag_cleanup net/9p/client.c:401 [inline]
 p9_client_destroy.cold+0x20/0xcc net/9p/client.c:1027
 v9fs_session_init+0x1003/0x1810 fs/9p/v9fs.c:488
 v9fs_mount+0xba/0xc90 fs/9p/vfs_super.c:126
 legacy_get_tree+0x105/0x220 fs/fs_context.c:610
 vfs_get_tree+0x89/0x2f0 fs/super.c:1530
 do_new_mount fs/namespace.c:3040 [inline]
 path_mount+0x1326/0x1e20 fs/namespace.c:3370
 do_mount fs/namespace.c:3383 [inline]
 __do_sys_mount fs/namespace.c:3591 [inline]
 __se_sys_mount fs/namespace.c:3568 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3568
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f24980893c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2496ffe168 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f249819c050 RCX: 00007f24980893c9
RDX: 0000000020000580 RSI: 0000000020000540 RDI: 0000000020000240
RBP: 00007f24980e433f R08: 0000000020000640 R09: 0000000000000000
R10: 0000000000004000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffcf7d7d3df R14: 00007f2496ffe300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
