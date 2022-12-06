Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9612644D25
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 21:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiLFUPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 15:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiLFUOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 15:14:47 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B2E37227
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 12:14:45 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id p3-20020a6bfa03000000b006df8582e11cso12516142ioh.22
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 12:14:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qnNBXL6kcYkM4JU17dCyWrc0ktdoztzz3AUB0q+GQJ4=;
        b=fz4Nw24oa6T0fEK5OEifWKjHGtTYgXsgvSQjePSa4fcgFip5itLYwzbFxYibHm7A/6
         J6S+5328hR97FNRo33WEKgq0u56m42/Jcy/9YVdfvwtzX+DdUfUzke8ZyOmhC0pWcBdW
         wGm6bV3vCXO/q3Ec3mvl4EACcXuVK5mWnW7WmK5q4XzhQH0W/+7h0hM5kTWA+oE0N3/m
         6up+sZzZiqKodR8fyLu7MwfehKrE6/mf8Cv8p8BLSBLbYEGRMG0lRg+CCt8o7GIHNapj
         hYqXEgD2AxW4sKDTSmOY95/5K1AOx1Z9Quti+ZEjiwlc7WT5utpGA+fp77OYRDc6dn+w
         E35g==
X-Gm-Message-State: ANoB5pmjrnLh4GyOWImjyaIVVyh29kMXbshqS9k5X+zx+AYdTdZSpzPu
        RzTuxNnXkgZSElGnT2ARzffDK4Pt6lDi7ChymZsWZ1HWOMSX
X-Google-Smtp-Source: AA0mqf7ehY5ZmhDboAIGOrGcNAJUlY1hwBCU9QWF4A6F8xUdQHXxfc+LRIKG322F+BnvGroA8vbsrJkbxRgqgtr7FBhGZEYTYDTG
MIME-Version: 1.0
X-Received: by 2002:a5d:81ca:0:b0:6e0:2991:584c with SMTP id
 t10-20020a5d81ca000000b006e02991584cmr1720266iol.78.1670357684824; Tue, 06
 Dec 2022 12:14:44 -0800 (PST)
Date:   Tue, 06 Dec 2022 12:14:44 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000073b14905ef2e7401@google.com>
Subject: [syzbot] BUG: stack guard page was hit in inet6_release
From:   syzbot <syzbot+04c21ed96d861dccc5cd@syzkaller.appspotmail.com>
To:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        jakub@cloudflare.com, john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
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

HEAD commit:    6a30d3e3491d selftests: net: Use "grep -E" instead of "egr..
git tree:       net
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1576b11d880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cc4b2e0a8e8a8366
dashboard link: https://syzkaller.appspot.com/bug?extid=04c21ed96d861dccc5cd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14e1656b880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1077da23880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/bbee3d5fc908/disk-6a30d3e3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bf9e258de70e/vmlinux-6a30d3e3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/afaa6696b9e0/bzImage-6a30d3e3.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+04c21ed96d861dccc5cd@syzkaller.appspotmail.com

BUG: TASK stack guard page was hit at ffffc90003cd7fa8 (stack is ffffc90003cd8000..ffffc90003ce0000)
stack guard page: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 3636 Comm: syz-executor238 Not tainted 6.1.0-rc7-syzkaller-00135-g6a30d3e3491d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:mark_lock.part.0+0x26/0x1910 kernel/locking/lockdep.c:4593
Code: 00 00 00 00 41 57 41 56 41 55 41 89 d5 48 ba 00 00 00 00 00 fc ff df 41 54 49 89 f4 55 53 48 81 ec 38 01 00 00 48 8d 5c 24 38 <48> 89 3c 24 48 c7 44 24 38 b3 8a b5 41 48 c1 eb 03 48 c7 44 24 40
RSP: 0018:ffffc90003cd7fb8 EFLAGS: 00010096
RAX: 0000000000000004 RBX: ffffc90003cd7ff0 RCX: ffffffff8162a7bf
RDX: dffffc0000000000 RSI: ffff88801f65e238 RDI: ffff88801f65d7c0
RBP: ffff88801f65e25a R08: 0000000000000000 R09: ffffffff910f4aff
R10: fffffbfff221e95f R11: 0000000000000000 R12: ffff88801f65e238
R13: 0000000000000002 R14: 0000000000000000 R15: 0000000000040000
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90003cd7fa8 CR3: 000000000c28e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 mark_lock kernel/locking/lockdep.c:4598 [inline]
 mark_usage kernel/locking/lockdep.c:4543 [inline]
 __lock_acquire+0x847/0x56d0 kernel/locking/lockdep.c:5009
 lock_acquire kernel/locking/lockdep.c:5668 [inline]
 lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
 lock_sock_nested+0x3a/0xf0 net/core/sock.c:3447
 lock_sock include/net/sock.h:1721 [inline]
 sock_map_close+0x75/0x7b0 net/core/sock_map.c:1610
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 sock_map_close+0x6dc/0x7b0 net/core/sock_map.c:1616
 inet_release+0x132/0x270 net/ipv4/af_inet.c:428
 inet6_release+0x50/0x70 net/ipv6/af_inet6.c:488
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x1c/0x20 net/socket.c:1365
 __fput+0x27c/0xa90 fs/file_table.c:320
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xb3d/0x2a30 kernel/exit.c:820
 do_group_exit+0xd4/0x2a0 kernel/exit.c:950
 get_signal+0x21b1/0x2440 kernel/signal.c:2858
 arch_do_signal_or_restart+0x86/0x2300 arch/x86/kernel/signal.c:869
 exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
 exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f48595660b9
Code: Unable to access opcode bytes at 0x7f485956608f.
RSP: 002b:00007ffebff98f98 EFLAGS: 00000246 ORIG_RAX: 0000000000000120
RAX: 0000000000000007 RBX: 0000000000000000 RCX: 00007f48595660b9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007ffebff99138 R09: 00007ffebff99138
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f4859529940
R13: 431bde82d7b634db R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:mark_lock.part.0+0x26/0x1910 kernel/locking/lockdep.c:4593
Code: 00 00 00 00 41 57 41 56 41 55 41 89 d5 48 ba 00 00 00 00 00 fc ff df 41 54 49 89 f4 55 53 48 81 ec 38 01 00 00 48 8d 5c 24 38 <48> 89 3c 24 48 c7 44 24 38 b3 8a b5 41 48 c1 eb 03 48 c7 44 24 40
RSP: 0018:ffffc90003cd7fb8 EFLAGS: 00010096
RAX: 0000000000000004 RBX: ffffc90003cd7ff0 RCX: ffffffff8162a7bf
RDX: dffffc0000000000 RSI: ffff88801f65e238 RDI: ffff88801f65d7c0
RBP: ffff88801f65e25a R08: 0000000000000000 R09: ffffffff910f4aff
R10: fffffbfff221e95f R11: 0000000000000000 R12: ffff88801f65e238
R13: 0000000000000002 R14: 0000000000000000 R15: 0000000000040000
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90003cd7fa8 CR3: 000000000c28e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	41 57                	push   %r15
   6:	41 56                	push   %r14
   8:	41 55                	push   %r13
   a:	41 89 d5             	mov    %edx,%r13d
   d:	48 ba 00 00 00 00 00 	movabs $0xdffffc0000000000,%rdx
  14:	fc ff df
  17:	41 54                	push   %r12
  19:	49 89 f4             	mov    %rsi,%r12
  1c:	55                   	push   %rbp
  1d:	53                   	push   %rbx
  1e:	48 81 ec 38 01 00 00 	sub    $0x138,%rsp
  25:	48 8d 5c 24 38       	lea    0x38(%rsp),%rbx
* 2a:	48 89 3c 24          	mov    %rdi,(%rsp) <-- trapping instruction
  2e:	48 c7 44 24 38 b3 8a 	movq   $0x41b58ab3,0x38(%rsp)
  35:	b5 41
  37:	48 c1 eb 03          	shr    $0x3,%rbx
  3b:	48                   	rex.W
  3c:	c7                   	.byte 0xc7
  3d:	44 24 40             	rex.R and $0x40,%al


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
