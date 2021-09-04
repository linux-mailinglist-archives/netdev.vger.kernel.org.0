Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962E44008A4
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 02:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350827AbhIDAH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 20:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241161AbhIDAH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 20:07:57 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E88DC061575;
        Fri,  3 Sep 2021 17:06:56 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id u1so475279plq.5;
        Fri, 03 Sep 2021 17:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xaoHiweSdsgNXsYn8GeMGyTDRryw+OlFigbP6DTFrPo=;
        b=pEMvGzCD4rR48TWlNy5K6HGuhTIX3z7Of7r3ie7EjPfDE9yP+vf3+jfMZZ8Wqo8S5z
         LwmsX6dKV/+JV6BFEv4oqiSK0fa2hgdBy+ZsUcLz5YcB/phjqPzQFo7f6I6oRw/CBzKa
         Cm5cYxykmKqesOeSxOxC9C8ZCGs8gyIgFcODIJQgwlkkRhX23c/lSHWC9ta6lwZGoxv/
         rrhJcii+RYPrVQMbiQVHKEvvbWn2OWA15vcAccvSRE079oUOZDBvSVRWPjeAj/P/G3Fk
         4aKHs77C6U968JDefi+f2CZjsjLD1yZuA7QCaLWuwkliDPFgnGvQpNP1gM01e+S7uIWN
         Hqjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xaoHiweSdsgNXsYn8GeMGyTDRryw+OlFigbP6DTFrPo=;
        b=Nq2NCkm/X9WbszK2yMD+O7f8eGj+ixbrs58L0ZLYmT8W1qHYZkV+lmSiHqS0scQqCg
         PcVIGHfUM05sHwvdjENgH4iER5S4JnM5/BWDaoBsKUIyxviJCAlbhSXbNwd4aT9LbiI9
         7Yp01lctcNXfyUR/3kFYg46PIs7nFlyJcChuxsxuINU5djL9B/aOmM1M1bb5VL8HLsyq
         HUyBXvl47LvQj9TPqsHNx4gdxTZDcMN4dv6a1/OxMf2arNpamfHJP33x7bRwsOrnMgFH
         mI+PY2QDqAkBr4xnfJTSHLy23zafOxwiTARn8Cg7GiKqT3IFwMPVTVX6Yn1bwGqwzX28
         HF+w==
X-Gm-Message-State: AOAM532Rlyuuey1XeEt12Cb1hPnoSNovqLcU7KhZG6w32RhC54AoGHRa
        GnIgJ4C5P3Kkhx/7ZnnFVJM=
X-Google-Smtp-Source: ABdhPJwdVOBvcMDZvmVqokbCZ94DKQ3Gu4lDUMNUWGIrO/36My8R2WcrkQdvQqEJp1YTMbM7usJJJQ==
X-Received: by 2002:a17:90b:ec8:: with SMTP id gz8mr1460491pjb.41.1630714016075;
        Fri, 03 Sep 2021 17:06:56 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id m12sm349632pjc.18.2021.09.03.17.06.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 17:06:55 -0700 (PDT)
Subject: Re: [syzbot] WARNING: kmalloc bug in hash_ipmark_create
To:     syzbot <syzbot+5a5a70ab7329b98649e7@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
References: <00000000000029697605cb201ed2@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <83e6e77a-fb61-bf4b-6d6e-36895923bedc@gmail.com>
Date:   Fri, 3 Sep 2021 17:06:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <00000000000029697605cb201ed2@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/21 5:01 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    a9c9a6f741cd Merge tag 'scsi-misc' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16490fb1300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=1ac29107aeb2a552
> dashboard link: https://syzkaller.appspot.com/bug?extid=5a5a70ab7329b98649e7
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=115e5ccd300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=178b4cb9300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+5a5a70ab7329b98649e7@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 8416 at mm/util.c:597 kvmalloc_node+0x111/0x120 mm/util.c:597
> Modules linked in:
> CPU: 0 PID: 8416 Comm: syz-executor566 Not tainted 5.14.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
> Code: 01 00 00 00 4c 89 e7 e8 ed 11 0d 00 49 89 c5 e9 69 ff ff ff e8 90 55 d1 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 7f 55 d1 ff <0f> 0b e9 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 66
> RSP: 0018:ffffc90001cb7280 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffffc90001cb73a0 RCX: 0000000000000000
> RDX: ffff8880292f8100 RSI: ffffffff81a3f651 RDI: 0000000000000003
> RBP: 0000000000400dc0 R08: 000000007fffffff R09: 000000000000001e
> R10: ffffffff81a3f60e R11: 000000000000001f R12: 0000000200000018
> R13: 0000000000000000 R14: 00000000ffffffff R15: ffff888015dc1800
> FS:  00000000016c3300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000146 CR3: 00000000168e4000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  hash_ipmark_create+0x4bd/0x1370 net/netfilter/ipset/ip_set_hash_gen.h:1524
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
> RSP: 002b:00007ffdcfb9e628 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f039
> RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000003
> RBP: 0000000000403020 R08: 0000000000000005 R09: 0000000000400488
> R10: 0000000000000001 R11: 0000000000000246 R12: 00000000004030b0
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
