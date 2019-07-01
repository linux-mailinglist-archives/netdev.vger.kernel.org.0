Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 427025B3E9
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 07:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbfGAF2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 01:28:42 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:43647 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbfGAF2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 01:28:41 -0400
Received: by mail-io1-f67.google.com with SMTP id k20so25846112ios.10;
        Sun, 30 Jun 2019 22:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:message-id:in-reply-to:references:subject:mime-version
         :content-transfer-encoding;
        bh=eM5ultCmo3QJu6zYaPCbkgYVYQQjp1S3p9nqPDbmWUE=;
        b=B/3hkEICijgMZG3Ya9njDHW6vTpZF0HkAnPmmAuJ7oBoYpkwnkqliLjgf9QS05eLfI
         C//EnroSYq1QxAV1t9W9FuM4J+gUL+/ixiSIyyl8HQh2sS7FLYW7ONzLxToC6Lk9qoFc
         Zy1jcAWcOx15z5LjU6jL2r48jJFLZWNC5xrknpa56CKmHIGiZyOa9eWSG+PfYgPbQag0
         0ab87/1dVVc5vmeMhi27qlQp0FbmwFRioHIUBROGQ+ZxdwHlyW4Cw6F8Wxn1+UFa+pRl
         C0Bf9AV9I41qToNJ/qvcA+6XLlXkGK+wrLg74A/IBXPQfSjD1jaLHxVjLaPAM4UOcGOo
         2KYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:message-id:in-reply-to:references
         :subject:mime-version:content-transfer-encoding;
        bh=eM5ultCmo3QJu6zYaPCbkgYVYQQjp1S3p9nqPDbmWUE=;
        b=mtkxOjKvtPmtXqbinKdf8bvy5YDv3u7kCRUZ92rPYaRugy9tAkkx8PT4fNhEyPG7Ye
         rgFdkEoMigwQnMH+NkyYh8qQZV5NIWp/qEsqRVkibzv8fY0sbMdm22tZCmsHbFd8F2+D
         IUS7hdEXmVywb/fSE3HQODBnVSYI+pbEazu4fuEN/JdgkAeRvTIaSSQY2FFaJClgw1Pu
         TK/Dakeed7P6JKhP/Rc/kCu0fuKjF64YpLWvZhpDnRYAzkm00hY3ucedAjfkKbyhri+5
         r2rp4Yx+InxQcAxNH8SvapJRGooAqf/nsn/uBaPh/7BJSNOpn1lh4uFbMvtiWeFvnVcx
         iztA==
X-Gm-Message-State: APjAAAXB6NKdBGCNEwqrJZAOKf2rZR/ugav8p4T4VG/XUBQOz7NE6r4q
        sosuQrYVcgcTSE/V0LHk1wvBwxozVKk=
X-Google-Smtp-Source: APXvYqzJkgsT50whDeF4owfvcuuHaCR+yuNF6ooAulDPFlegpwpTcv8kt2CnrvgCjx4zxckrUbXh7A==
X-Received: by 2002:a05:6602:104:: with SMTP id s4mr16870342iot.200.1561958920100;
        Sun, 30 Jun 2019 22:28:40 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a7sm14891886iok.19.2019.06.30.22.28.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 30 Jun 2019 22:28:39 -0700 (PDT)
Date:   Sun, 30 Jun 2019 22:28:31 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     syzbot <syzbot+06537213db7ba2745c4a@syzkaller.appspotmail.com>,
        aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Message-ID: <5d1999ff323f_18a42abda71925b4cf@john-XPS-13-9370.notmuch>
In-Reply-To: <000000000000a420af058ad4bca2@google.com>
References: <000000000000a420af058ad4bca2@google.com>
Subject: RE: memory leak in create_ctx
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    79c3ba32 Merge tag 'drm-fixes-2019-06-07-1' of git://anong..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=170e0bfea00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d5c73825cbdc7326
> dashboard link: https://syzkaller.appspot.com/bug?extid=06537213db7ba2745c4a
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10aa806aa00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+06537213db7ba2745c4a@syzkaller.appspotmail.com
> 
> IPv6: ADDRCONF(NETDEV_CHANGE): team0: link becomes ready
> 2019/06/08 14:55:51 executed programs: 15
> 2019/06/08 14:55:56 executed programs: 31
> 2019/06/08 14:56:02 executed programs: 51
> BUG: memory leak
> unreferenced object 0xffff888117ceae00 (size 512):
>    comm "syz-executor.3", pid 7233, jiffies 4294949016 (age 13.640s)
>    hex dump (first 32 bytes):
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<00000000e6550967>] kmemleak_alloc_recursive  
> include/linux/kmemleak.h:55 [inline]
>      [<00000000e6550967>] slab_post_alloc_hook mm/slab.h:439 [inline]
>      [<00000000e6550967>] slab_alloc mm/slab.c:3326 [inline]
>      [<00000000e6550967>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
>      [<0000000014132182>] kmalloc include/linux/slab.h:547 [inline]
>      [<0000000014132182>] kzalloc include/linux/slab.h:742 [inline]
>      [<0000000014132182>] create_ctx+0x25/0x70 net/tls/tls_main.c:601
>      [<00000000e08e1a44>] tls_init net/tls/tls_main.c:787 [inline]
>      [<00000000e08e1a44>] tls_init+0x97/0x1e0 net/tls/tls_main.c:769
>      [<0000000037b0c43c>] __tcp_set_ulp net/ipv4/tcp_ulp.c:126 [inline]
>      [<0000000037b0c43c>] tcp_set_ulp+0xe2/0x190 net/ipv4/tcp_ulp.c:147
>      [<000000007a284277>] do_tcp_setsockopt.isra.0+0x19a/0xd60  
> net/ipv4/tcp.c:2784
>      [<00000000f35f3415>] tcp_setsockopt+0x71/0x80 net/ipv4/tcp.c:3098
>      [<00000000c840962c>] sock_common_setsockopt+0x38/0x50  
> net/core/sock.c:3124
>      [<0000000006b0801f>] __sys_setsockopt+0x98/0x120 net/socket.c:2072
>      [<00000000a6309f52>] __do_sys_setsockopt net/socket.c:2083 [inline]
>      [<00000000a6309f52>] __se_sys_setsockopt net/socket.c:2080 [inline]
>      [<00000000a6309f52>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2080
>      [<00000000fa555bbc>] do_syscall_64+0x76/0x1a0  
> arch/x86/entry/common.c:301
>      [<00000000a06d7d1a>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> BUG: memory leak
> unreferenced object 0xffff88810965dc00 (size 512):
>    comm "syz-executor.2", pid 7235, jiffies 4294949016 (age 13.640s)
>    hex dump (first 32 bytes):
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<00000000e6550967>] kmemleak_alloc_recursive  
> include/linux/kmemleak.h:55 [inline]
>      [<00000000e6550967>] slab_post_alloc_hook mm/slab.h:439 [inline]
>      [<00000000e6550967>] slab_alloc mm/slab.c:3326 [inline]
>      [<00000000e6550967>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
>      [<0000000014132182>] kmalloc include/linux/slab.h:547 [inline]
>      [<0000000014132182>] kzalloc include/linux/slab.h:742 [inline]
>      [<0000000014132182>] create_ctx+0x25/0x70 net/tls/tls_main.c:601
>      [<00000000e08e1a44>] tls_init net/tls/tls_main.c:787 [inline]
>      [<00000000e08e1a44>] tls_init+0x97/0x1e0 net/tls/tls_main.c:769
>      [<0000000037b0c43c>] __tcp_set_ulp net/ipv4/tcp_ulp.c:126 [inline]
>      [<0000000037b0c43c>] tcp_set_ulp+0xe2/0x190 net/ipv4/tcp_ulp.c:147
>      [<000000007a284277>] do_tcp_setsockopt.isra.0+0x19a/0xd60  
> net/ipv4/tcp.c:2784
>      [<00000000f35f3415>] tcp_setsockopt+0x71/0x80 net/ipv4/tcp.c:3098
>      [<00000000c840962c>] sock_common_setsockopt+0x38/0x50  
> net/core/sock.c:3124
>      [<0000000006b0801f>] __sys_setsockopt+0x98/0x120 net/socket.c:2072
>      [<00000000a6309f52>] __do_sys_setsockopt net/socket.c:2083 [inline]
>      [<00000000a6309f52>] __se_sys_setsockopt net/socket.c:2080 [inline]
>      [<00000000a6309f52>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2080
>      [<00000000fa555bbc>] do_syscall_64+0x76/0x1a0  
> arch/x86/entry/common.c:301
>      [<00000000a06d7d1a>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> BUG: memory leak
> unreferenced object 0xffff8881207d7600 (size 512):
>    comm "syz-executor.5", pid 7244, jiffies 4294949019 (age 13.610s)
>    hex dump (first 32 bytes):
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<00000000e6550967>] kmemleak_alloc_recursive  
> include/linux/kmemleak.h:55 [inline]
>      [<00000000e6550967>] slab_post_alloc_hook mm/slab.h:439 [inline]
>      [<00000000e6550967>] slab_alloc mm/slab.c:3326 [inline]
>      [<00000000e6550967>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
>      [<0000000014132182>] kmalloc include/linux/slab.h:547 [inline]
>      [<0000000014132182>] kzalloc include/linux/slab.h:742 [inline]
>      [<0000000014132182>] create_ctx+0x25/0x70 net/tls/tls_main.c:601
>      [<00000000e08e1a44>] tls_init net/tls/tls_main.c:787 [inline]
>      [<00000000e08e1a44>] tls_init+0x97/0x1e0 net/tls/tls_main.c:769
>      [<0000000037b0c43c>] __tcp_set_ulp net/ipv4/tcp_ulp.c:126 [inline]
>      [<0000000037b0c43c>] tcp_set_ulp+0xe2/0x190 net/ipv4/tcp_ulp.c:147
>      [<000000007a284277>] do_tcp_setsockopt.isra.0+0x19a/0xd60  
> net/ipv4/tcp.c:2784
>      [<00000000f35f3415>] tcp_setsockopt+0x71/0x80 net/ipv4/tcp.c:3098
>      [<00000000c840962c>] sock_common_setsockopt+0x38/0x50  
> net/core/sock.c:3124
>      [<0000000006b0801f>] __sys_setsockopt+0x98/0x120 net/socket.c:2072
>      [<00000000a6309f52>] __do_sys_setsockopt net/socket.c:2083 [inline]
>      [<00000000a6309f52>] __se_sys_setsockopt net/socket.c:2080 [inline]
>      [<00000000a6309f52>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2080
>      [<00000000fa555bbc>] do_syscall_64+0x76/0x1a0  
> arch/x86/entry/common.c:301
>      [<00000000a06d7d1a>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches

#syz test: git://github.com/cilium/linux ktls-unhash
