Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99CF7400883
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 01:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350770AbhICX5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 19:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350743AbhICX50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 19:57:26 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D3AC061575;
        Fri,  3 Sep 2021 16:56:25 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id u6so756790pfi.0;
        Fri, 03 Sep 2021 16:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=YPeZoqb23xCBYIKyQQr8xebdjfODkky7kJR1l2zlHz8=;
        b=PQpF709ZsJwQRNBwpUJr3Wu7g7q3BDQNuaQurhNEtSza1DMVxKV89ZSCxdsvd392Zl
         Zhr3b/Fdyai3iC8FwcjGMUflwgp69dFztmO3/GMj57JlT2P5rEU2zaOJRO3ZT5GGkyxo
         b0UI4u4VNBd+MCdwx4W6x7DzDAPCVvMiZx1Uw2c3eqUIhjrtA5BnqPGPccmKLdPJuLTa
         /QHl52g8JPnSXcRRkxXY2R6tzAnlGgYqWZ6HtCxBSzW8uNODTxrjnExkS4A0Dbj7SFMS
         ngHa4/LoMqIwn+rqL1BffmIEDYv7unXqd2teemefJE2cYm5wMgWyPNlZH/53rA2WpTS0
         MYmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YPeZoqb23xCBYIKyQQr8xebdjfODkky7kJR1l2zlHz8=;
        b=GdY19XVz8DvKWMectJTraynXrczTp7UvwhqJpKZ9Bohel5AMNIt6SkiNgoK9pijimc
         nIbfcjSYQgJK5D+I5kn64m+iLo5Nromf55OIm0RzU39/HN/0qI2CgALXHbDTGLnjubcC
         nFslZw1JskFo3LokeGruV8Q09+xWNwizqd4OdDVRy8GFf5PF7WtQ2gY6Sa96eSa7ePPX
         RX2U6S2KXijNDsOuWF1IPCuiG1C6I67+h/Xpa1O389SzTtPVKamVaeO9/NgdsOCDsdqh
         2ucZcxoImJq2GbdNu4pvSqrTQ0k1MQIiYdO833KLK997bl5rxJAdrs84lKkGtCPme2O0
         3ntA==
X-Gm-Message-State: AOAM530zzKGyZRnQ2OlYDAaS8aOe+Gl/+StTxWNfkVCMFdMkdjKicCEs
        7QochO33Gd73GP4QNbaSFFY=
X-Google-Smtp-Source: ABdhPJxfSWlSI9g6NUXJfM+y1MI8wZ+FjW71edjUsluzx2qDzsgSfq4gm9NzMtv7M/aCjd3XXgi2pg==
X-Received: by 2002:a62:6143:0:b029:3c9:3117:c620 with SMTP id v64-20020a6261430000b02903c93117c620mr1313102pfb.30.1630713385266;
        Fri, 03 Sep 2021 16:56:25 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id v26sm418459pfi.207.2021.09.03.16.56.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 16:56:24 -0700 (PDT)
Subject: Re: [syzbot] WARNING: kmalloc bug in nf_tables_newset
To:     syzbot <syzbot+cd43695a64bcd21b8596@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000ed8c0a05cb1ff6d8@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <4600da1f-bf35-049d-058a-78860d8c126a@gmail.com>
Date:   Fri, 3 Sep 2021 16:56:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <000000000000ed8c0a05cb1ff6d8@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/21 4:50 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    a9c9a6f741cd Merge tag 'scsi-misc' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=119f0915300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7860a0536ececf0c
> dashboard link: https://syzkaller.appspot.com/bug?extid=cd43695a64bcd21b8596
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13281b33300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1077b4b9300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+cd43695a64bcd21b8596@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 8421 at mm/util.c:597 kvmalloc_node+0x111/0x120 mm/util.c:597
> Modules linked in:
> CPU: 1 PID: 8421 Comm: syz-executor968 Not tainted 5.14.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
> Code: 01 00 00 00 4c 89 e7 e8 8d 12 0d 00 49 89 c5 e9 69 ff ff ff e8 f0 21 d1 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 df 21 d1 ff <0f> 0b e9 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 c6
> RSP: 0018:ffffc90006f2f330 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff8880259c0000 RSI: ffffffff81a4f621 RDI: 0000000000000003
> RBP: 0000000000000dc0 R08: 000000007fffffff R09: 00000000ffffffff
> R10: ffffffff81a4f5de R11: 0000000000000000 R12: 0000000400000108
> R13: 0000000000000000 R14: 00000000ffffffff R15: dffffc0000000000
> FS:  0000000001785300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f6394785000 CR3: 000000001dd56000 CR4: 0000000000350ef0
> Call Trace:
>  kvmalloc include/linux/mm.h:806 [inline]
>  kvzalloc include/linux/mm.h:814 [inline]
>  nf_tables_newset+0x1512/0x3340 net/netfilter/nf_tables_api.c:4341
>  nfnetlink_rcv_batch+0x1710/0x25f0 net/netfilter/nfnetlink.c:513
>  nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
>  nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:652
>  netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
>  netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
>  sock_sendmsg_nosec net/socket.c:704 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:724
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x43f189
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd36aa47e8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f189
> RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000003
> RBP: 0000000000403170 R08: 0000000000000a00 R09: 0000000000400488
> R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000403200
> R13: 0000000000000000 R14: 00000000004ad018 R15: 0000000000400488
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 

As mentioned to Linus earlier, this bug comes after recent patch

commit 7661809d493b426e979f39ab512e3adf41fbcc69
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jul 14 09:45:49 2021 -0700

    mm: don't allow oversized kvmalloc() calls
    
    'kvmalloc()' is a convenience function for people who want to do a
    kmalloc() but fall back on vmalloc() if there aren't enough physically
    contiguous pages, or if the allocation is larger than what kmalloc()
    supports.
    
    However, let's make sure it doesn't get _too_ easy to do crazy things
    with it.  In particular, don't allow big allocations that could be due
    to integer overflow or underflow.  So make sure the allocation size fits
    in an 'int', to protect against trivial integer conversion issues.
    
    Acked-by: Willy Tarreau <w@1wt.eu>
    Cc: Kees Cook <keescook@chromium.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

