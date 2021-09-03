Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC70400880
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 01:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350576AbhICX5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 19:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350621AbhICX5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 19:57:06 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47177C061575;
        Fri,  3 Sep 2021 16:56:06 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id r13so716772pff.7;
        Fri, 03 Sep 2021 16:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=g1KqY0f6crH7t3dYaR6YkyI0UCBDvk4VEmnUNlQndu0=;
        b=dLOWGbM1XA+XmBSvbZCmIwK9tbXf5MreFJ/zl7YfCn5UX9cQW9KRQrvxLPLMgoBmWy
         MIyjti+ni0BjPCLDvjs5vMqSXKBrySyF5WQ1ZMMW7CaO3158kU5+AmDj4yOi4IHnHDx6
         wa1cNB3lzARtoySOfIgEumdL/RPOySuBwDYwTChHlWt4HUHx2Z0ZaBJTs1coP80FxR0N
         3BT5OBKc/Ua9DYE4klmQWmrt/HYOb8J0pHayNGT0blmEbecUzs9HFmDW8uR1Sorstfqf
         UAyuDE3E6mzwLrLpbSYh4YmJjY4Ker0V+XnX3bEc1Y+n90y4pYA/BUuYC10UTeAlmaee
         N+ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g1KqY0f6crH7t3dYaR6YkyI0UCBDvk4VEmnUNlQndu0=;
        b=oPSxm1oYV0TRYhzvcC3TCSLi5RI3l5pWmsrtT73mqL5SzH7ISzlSmGO1COFIYpuZ4R
         zy3K6NZpaeir/4GD+6gJ3bAuY4kNcEiF18GXCiiGZMv2vyRUDhmGF7335nTIzcL1Hb5T
         ARQKEh4df7bcCOZVz6zBizyJ4inRIpvQuDmWxPBroer7rkfUJJDgrz4YIn9/mODckL2P
         6c/Ls58gn2ikMfmM1VVaoYQfkDZFt5X9L9bc0wXzgtp6ehau3uqzb0RT2BQHkm2LKV/Y
         P59iuYCrETDenfjOrzA7/Wtb+No589Ze/EPnq9je/X+4wg3AuFLJ7AV5XGVQHxOlkwzY
         qC8g==
X-Gm-Message-State: AOAM533p3xbBiR53Sa4brJnpL/Qp4V+DMYW2tUDV7eaW9QBK6oUUAjDx
        gj7d+MZV2B+vuhQN4cBAGLA=
X-Google-Smtp-Source: ABdhPJz53LiS7b3/H6tTOf7wBqL2swjnVlz0Kl+SIoeNxkh073xdxkt4Vwuky2WdDWAMdeW9gRxzUA==
X-Received: by 2002:a62:1888:0:b029:3c9:7957:519b with SMTP id 130-20020a6218880000b02903c97957519bmr1227204pfy.17.1630713365805;
        Fri, 03 Sep 2021 16:56:05 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id l18sm422059pff.24.2021.09.03.16.56.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 16:56:05 -0700 (PDT)
Subject: Re: [syzbot] WARNING: kmalloc bug in hash_ip_create
To:     syzbot <syzbot+3493b1873fb3ea827986@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000ea2f2605cb1ff6f6@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <061e1f77-eab6-e9c3-f821-fa44a398263b@gmail.com>
Date:   Fri, 3 Sep 2021 16:56:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <000000000000ea2f2605cb1ff6f6@google.com>
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
> console output: https://syzkaller.appspot.com/x/log.txt?x=13246f25300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7860a0536ececf0c
> dashboard link: https://syzkaller.appspot.com/bug?extid=3493b1873fb3ea827986
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11602f35300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10e8fbf5300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+3493b1873fb3ea827986@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 8430 at mm/util.c:597 kvmalloc_node+0x111/0x120 mm/util.c:597
> Modules linked in:
> CPU: 1 PID: 8430 Comm: syz-executor792 Not tainted 5.14.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
> Code: 01 00 00 00 4c 89 e7 e8 8d 12 0d 00 49 89 c5 e9 69 ff ff ff e8 f0 21 d1 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 df 21 d1 ff <0f> 0b e9 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 c6
> RSP: 0018:ffffc9000108f280 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffffc9000108f3a0 RCX: 0000000000000000
> RDX: ffff88801bfd5580 RSI: ffffffff81a4f621 RDI: 0000000000000003
> RBP: 0000000000400dc0 R08: 000000007fffffff R09: 00000000ffffffff
> R10: ffffffff81a4f5de R11: 000000000000001f R12: 0000000200000018
> R13: 0000000000000000 R14: 00000000ffffffff R15: ffff888028b41a00
> FS:  0000000002409300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000006 CR3: 00000000127f1000 CR4: 0000000000350ee0
> Call Trace:
>  hash_ip_create+0x4bb/0x13d0 net/netfilter/ipset/ip_set_hash_gen.h:1524
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
> RIP: 0033:0x43f029
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd662e8c48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f029
> RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000003
> RBP: 0000000000403010 R08: 0000000000000005 R09: 0000000000400488
> R10: 0000000000000001 R11: 0000000000000246 R12: 00000000004030a0
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

