Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBF73A27C
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 01:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbfFHXrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 19:47:13 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46841 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727424AbfFHXrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 19:47:13 -0400
Received: by mail-pg1-f196.google.com with SMTP id v9so1338483pgr.13
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 16:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=IkGCY4eEKnwl0itjV2RvEoTeNU6SXrF/5KeYoir+cQQ=;
        b=q/T6Ts/pH1OGXxEFlb/v/YIpdU/MXp6sJR1jRSfJtxRskGnMVksbj9VGccAiSd2bFz
         4oV/KVRQ2c2x0IP69nDgTRI2kuLNbkcU9iboPSOQFAncSNcivS3lIbKdAYMs9hD7zVRx
         5oATLQGPAJvwjSU9tsVR7KGYHrskDbdZ5UrPNItI9jaupGSZMAPmdI4l8AZe6FbyilAn
         GDh6niPlgkK5OaeME/vacOraNT5+jU/rxOSaRJFAz0E5QxaG8wrm/V9KOTzV/ZXBmrQK
         Cj0Y5BP4nfZE2SgLmn17r6Cp5ELiLaN7eYzTHA1rDqDepmDQzUwDkF5fCYiMXbqrXXlA
         qetw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=IkGCY4eEKnwl0itjV2RvEoTeNU6SXrF/5KeYoir+cQQ=;
        b=sCUfaIsGmt4r1CvFUcMtRRRzWTZZW+oVHw5v+JoSv4UqHZZRmpU/wi9/I+rZNcmFkE
         5UolEAQoTUhzHW5H13bltBPDK+YMqZeSwJWd8SGoObmL0fV6P9mJkZAD4nU/w45h+sZ6
         lPSPi1FJWymNSUpWr6X7rdV1k5ppsm+coCnvtmBSr8Vb7dVSl5OSXITK3AsWI+AeeeJO
         8NC3wsb0olrxHrThcfM2DKkytfOR7Ws32khjsqZOgi5FZniCBrXy6qr9ZjR+g1m1TPLn
         PsqcijWTgY85wo9d8C5Aj0ClbfPiaYp0sTE2uU5RSuK9m+FSdacKJJRpKvm0hJZGcX5B
         mSrQ==
X-Gm-Message-State: APjAAAUNsfNphMC9N3YKLadV2PYGsIJeq94ZBehSGEzzVhS7wRIolEqr
        fPgNp0n+RLzVATYFQJFLZU8r1g==
X-Google-Smtp-Source: APXvYqw/kCE5eMQytwsTDy7JvmNdQaSFGTIW1FeQ6noUVR5chO0sAzMym5o5pnYv2/qiTUjcLUukRQ==
X-Received: by 2002:a62:87c5:: with SMTP id i188mr10038978pfe.118.1560037631781;
        Sat, 08 Jun 2019 16:47:11 -0700 (PDT)
Received: from cakuba.netronome.com (cpe-76-172-122-34.san.res.rr.com. [76.172.122.34])
        by smtp.gmail.com with ESMTPSA id p17sm2947795pjo.1.2019.06.08.16.47.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 08 Jun 2019 16:47:11 -0700 (PDT)
Date:   Sat, 8 Jun 2019 16:47:04 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     syzbot <syzbot+06537213db7ba2745c4a@syzkaller.appspotmail.com>
Cc:     aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: memory leak in create_ctx
Message-ID: <20190608164704.742c18da@cakuba.netronome.com>
In-Reply-To: <000000000000a420af058ad4bca2@google.com>
References: <000000000000a420af058ad4bca2@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 08 Jun 2019 12:13:06 -0700, syzbot wrote:
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

This one creates a TCPv6 socket, puts it in repair mode, connects and
then adds a tls ULP.  Apparently that leaks the entire TLS context but 
I can't repro..

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

