Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8336A3D1
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 10:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbfGPI2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 04:28:07 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:49855 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbfGPI2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 04:28:07 -0400
Received: by mail-io1-f70.google.com with SMTP id x24so22645835ioh.16
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 01:28:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=CVLQM8IBnuMyhd+kVWwjL1tPc6jemdNZxgtAMCa55Gs=;
        b=Xk6TDFHw5CmnMbEJBxYg+86IxNOm5NrY5+DTa/0ZgsVKghdjFzqi1WdOuIhrAFR3tQ
         wx+Ae9swyAWgb3qdormXQGNhlIKCHmrZTmmM72LO5tpnJQVNACySdU7GiBKpF5Gc5BeU
         Idvm8XkUiBO9Wh2jg0poF1kBZVjUqCA2TJuWX0csUC9aaPFnZWIpIoZOi7hH+fQBaNUg
         Vyoy2O/W18btJ5vEvmisPRBT6FnY2asAxIgeySiOdLHBVNMyROp+JnDUj/bxSEQJG4aA
         aO3sqFrkwVOla8IhZPmNKqL9OyyN6ks2/XlpzO7tPq88jAI6KUvIcylRwHIg7k7rLhjq
         BSRw==
X-Gm-Message-State: APjAAAXTIx9JLHBWIXTI51k5p0ivlMKzrJyRn9d7tb/kOONklztwU29E
        iWspQSxJhh517QSAQGyj9+xoV+9gM4hbyv5h7BLNJpCt1iaw
X-Google-Smtp-Source: APXvYqwL8itxGkwnLH68ViD0OECko2w0UnIpUkiM1tUzPGYjXPGEgZj+DPi8Pf/Kg3xCG0NQkYVIeFkAdo4j7rj01rTb64knj9kk
MIME-Version: 1.0
X-Received: by 2002:a05:6602:144:: with SMTP id v4mr25804506iot.202.1563265686396;
 Tue, 16 Jul 2019 01:28:06 -0700 (PDT)
Date:   Tue, 16 Jul 2019 01:28:06 -0700
In-Reply-To: <000000000000111cbe058dc7754d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ed664f058dc82773@google.com>
Subject: Re: memory leak in new_inode_pseudo (2)
From:   syzbot <syzbot+e682cca30bc101a4d9d9@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    be8454af Merge tag 'drm-next-2019-07-16' of git://anongit...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13d5f750600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d23a1a7bf85c5250
dashboard link: https://syzkaller.appspot.com/bug?extid=e682cca30bc101a4d9d9
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=155c5800600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1738f800600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e682cca30bc101a4d9d9@syzkaller.appspotmail.com

executing program
executing program
executing program
executing program
BUG: memory leak
unreferenced object 0xffff888128ea0980 (size 768):
   comm "syz-executor303", pid 7044, jiffies 4294943526 (age 13.490s)
   hex dump (first 32 bytes):
     01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<000000005ba542b8>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000005ba542b8>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<000000005ba542b8>] slab_alloc mm/slab.c:3319 [inline]
     [<000000005ba542b8>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
     [<000000006532a1e9>] sock_alloc_inode+0x1c/0xa0 net/socket.c:238
     [<0000000014ddc967>] alloc_inode+0x2c/0xe0 fs/inode.c:227
     [<0000000056541455>] new_inode_pseudo+0x18/0x70 fs/inode.c:916
     [<000000003b5b5444>] sock_alloc+0x1c/0x90 net/socket.c:554
     [<00000000e623b353>] __sock_create+0x8f/0x250 net/socket.c:1378
     [<000000000e094708>] sock_create_kern+0x3b/0x50 net/socket.c:1483
     [<000000009fe4f64f>] smc_create+0xae/0x160 net/smc/af_smc.c:1975
     [<0000000056be84a7>] __sock_create+0x164/0x250 net/socket.c:1414
     [<000000005915e5fe>] sock_create net/socket.c:1465 [inline]
     [<000000005915e5fe>] __sys_socket+0x69/0x110 net/socket.c:1507
     [<00000000afa837b2>] __do_sys_socket net/socket.c:1516 [inline]
     [<00000000afa837b2>] __se_sys_socket net/socket.c:1514 [inline]
     [<00000000afa837b2>] __x64_sys_socket+0x1e/0x30 net/socket.c:1514
     [<00000000d0addad1>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<000000004e8e7c22>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811faeeab8 (size 56):
   comm "syz-executor303", pid 7044, jiffies 4294943526 (age 13.490s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 0a ea 28 81 88 ff ff d0 ea ae 1f 81 88 ff ff  ...(............
   backtrace:
     [<000000005ba542b8>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000005ba542b8>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<000000005ba542b8>] slab_alloc mm/slab.c:3319 [inline]
     [<000000005ba542b8>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
     [<000000008ca63096>] kmem_cache_zalloc include/linux/slab.h:738 [inline]
     [<000000008ca63096>] lsm_inode_alloc security/security.c:522 [inline]
     [<000000008ca63096>] security_inode_alloc+0x33/0xb0  
security/security.c:875
     [<00000000b335d930>] inode_init_always+0x108/0x200 fs/inode.c:169
     [<0000000015dcffb3>] alloc_inode+0x49/0xe0 fs/inode.c:234
     [<0000000056541455>] new_inode_pseudo+0x18/0x70 fs/inode.c:916
     [<000000003b5b5444>] sock_alloc+0x1c/0x90 net/socket.c:554
     [<00000000e623b353>] __sock_create+0x8f/0x250 net/socket.c:1378
     [<000000000e094708>] sock_create_kern+0x3b/0x50 net/socket.c:1483
     [<000000009fe4f64f>] smc_create+0xae/0x160 net/smc/af_smc.c:1975
     [<0000000056be84a7>] __sock_create+0x164/0x250 net/socket.c:1414
     [<000000005915e5fe>] sock_create net/socket.c:1465 [inline]
     [<000000005915e5fe>] __sys_socket+0x69/0x110 net/socket.c:1507
     [<00000000afa837b2>] __do_sys_socket net/socket.c:1516 [inline]
     [<00000000afa837b2>] __se_sys_socket net/socket.c:1514 [inline]
     [<00000000afa837b2>] __x64_sys_socket+0x1e/0x30 net/socket.c:1514
     [<00000000d0addad1>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<000000004e8e7c22>] entry_SYSCALL_64_after_hwframe+0x44/0xa9


