Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E2240087C
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 01:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350640AbhICX4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 19:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbhICX4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 19:56:48 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C106FC061575;
        Fri,  3 Sep 2021 16:55:47 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id fz10so611677pjb.0;
        Fri, 03 Sep 2021 16:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=W7zxbP1Zyrtssv0WIVqynVpoLsGQ+DoV8NfjADU6u1c=;
        b=dOsVM49/ZTe5pvA0yG9W6u7jCGfoYRmVnIEggmHnxeZbofSQj+Snlk8Dht9V4dfiML
         XHf2Sf/RpXAjELexfq+RQCNRPLigvAX929sFFN2DUO7SwHCTueis3G4Kh676pH7yH8+v
         pJfAkiXdGQt0gm5u7/Se2wHRdnjidCftVDuxIeMDA9wUOsVwquM2glQWvdpI9HgImrzx
         6teWi4H2jCCmuwyh1dj2UA9r2f2vgn7nj4do5MLXjrJUT+7XGwSeVg0KAFLXzInCDOkN
         o45vybgNP1kRHP5i9QWnexSLPXgQ0MN0QvlFX7De5gwXT05MN5qrQwoJTFOm3WEqgsBo
         8wOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W7zxbP1Zyrtssv0WIVqynVpoLsGQ+DoV8NfjADU6u1c=;
        b=qlfe3QmPI1SKBRowhHWVdcq1ZFZZLlkRI41GOxQVSduPH14VRZheaAx9dMyjMWzCKs
         ahCkO06WUJKQHY/Eb5huIzI5eVi3YKpEJeLt104eE8+yfeHSOV1yulNDjQY5GQJLAxFw
         FhJTgJ6jNQMJDL8fKibL3Uv91BnHv3XLgJxWxvIQ7yVlM0fv9iqvTsx0ICXbwrbwtezo
         VpNT1m+SPfJfftWCD4CruZHtpzMhk91pw7ixHqWk63g3OlHoZf9j1aQMScTo2pkpzrYM
         VxSmNwn1IIlezJiT1793Jcc7ekKQTfcHDjwRZjQY1q0wOAbXL/EsQPeBfeBglCfT3Lpy
         2ZDw==
X-Gm-Message-State: AOAM533lgwsldiqzarX2zWwK0TllB6KqpgMRkR26upGjX1AeVWfFvDEG
        NbFX2hQCwc1K1CF7YDZGp/A=
X-Google-Smtp-Source: ABdhPJwCMaWq77ESGvD452htF3cZlcHQSHnCsdHPTAYc4QyTfiWbq8f0e4VfGVgrXZu0MPjnU/FvBQ==
X-Received: by 2002:a17:90a:4498:: with SMTP id t24mr1334314pjg.235.1630713347254;
        Fri, 03 Sep 2021 16:55:47 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id t28sm438912pfe.144.2021.09.03.16.55.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 16:55:46 -0700 (PDT)
Subject: Re: [syzbot] WARNING: kmalloc bug in hash_net_create
To:     syzbot <syzbot+2b8443c35458a617c904@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000f0cdb005cb1ff6ec@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <97f5adcc-fc8c-1de2-7363-4fbf9a305ea4@gmail.com>
Date:   Fri, 3 Sep 2021 16:55:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <000000000000f0cdb005cb1ff6ec@google.com>
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
> console output: https://syzkaller.appspot.com/x/log.txt?x=117f0915300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=1ac29107aeb2a552
> dashboard link: https://syzkaller.appspot.com/bug?extid=2b8443c35458a617c904
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12fba55d300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15bd2f49300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+2b8443c35458a617c904@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 8432 at mm/util.c:597 kvmalloc_node+0x111/0x120 mm/util.c:597
> Modules linked in:
> CPU: 0 PID: 8432 Comm: syz-executor044 Not tainted 5.14.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
> Code: 01 00 00 00 4c 89 e7 e8 ed 11 0d 00 49 89 c5 e9 69 ff ff ff e8 90 55 d1 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 7f 55 d1 ff <0f> 0b e9 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 66
> RSP: 0018:ffffc900018f7288 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffffc900018f73a0 RCX: 0000000000000000
> RDX: ffff88803d6ca300 RSI: ffffffff81a3f651 RDI: 0000000000000003
> RBP: 0000000000400dc0 R08: 000000007fffffff R09: 000000000000001f
> R10: ffffffff81a3f60e R11: 000000000000001f R12: 0000000400000018
> R13: 0000000000000000 R14: 00000000ffffffff R15: ffff88801743d000
> FS:  0000000001d7c300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000046 CR3: 000000001e0d4000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  hash_net_create+0x3dd/0x1220 net/netfilter/ipset/ip_set_hash_gen.h:1524
>  ip_set_create+0x782/0x15a0 net/netfilter/ipset/ip_set_core.c:1100
>  nfnetlink_rcv_msg+0xbc9/0x13f0 net/netfilter/nfnetlink.c:296
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
>  nfnetlink_rcv+0x1ac/0x420 net/netfilter/nfnetlink.c:654
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
> RIP: 0033:0x43f039
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc97697a28 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f039
> RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000003
> RBP: 0000000000403020 R08: 0000000000000005 R09: 0000000000400488
> R10: 0000000000000002 R11: 0000000000000246 R12: 00000000004030b0
> R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488
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
