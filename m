Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669F24008AA
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 02:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350860AbhIDAI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 20:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350601AbhIDAI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 20:08:26 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050A1C061575;
        Fri,  3 Sep 2021 17:07:26 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so554827pje.0;
        Fri, 03 Sep 2021 17:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Myq6bRmVy0VPz7UOQnNxBiQSZVbmCyYoGJRM61g0+C4=;
        b=A9G4KhtufPhoOA8gvqml423oqLYCKrmLp2WVGtlkAY2WLWHrWloZX/LQkD2w0xa5PG
         GWS+iKch3cYRLecm4ovgybpc1X8Mr0I5uNToKcfAzqU3QTf2r3ftwGwCVo+Pj74wpFVJ
         Ov/FlvOSGPKGsODcR85Gfyx2q5EGxxzk3m+8gky8aY3GfZf5klLD9ph1EQdMq2qgxWrU
         fWCJVawGjMIPCkB0E73qtZgu7Wee/PFuOZPHzP7QQg/dxNNYLgw6erfdLFpNkNMAo66a
         xkn6SKX/eKRIBgmNncDRjH63PlTAHe/ETvPH/8OecTRouJt3LyuOn+sh+VhUyUiuWwOo
         j/ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Myq6bRmVy0VPz7UOQnNxBiQSZVbmCyYoGJRM61g0+C4=;
        b=XnCMI3YVcaZiHjITjj42Wb6LNo+6VNGO6KL6LERjjWq+rIm9HINajhBEsPEIhW5wS2
         S1SEO3PhiJQDN+bBtDI/NONanGSU3jbna62heIyTVIafzeXeHadWpJVHTmPqlzyjneO5
         wY/WAlHc6jyxyLu+8mAUAIcnckjhNzsvqqg49VY8a8Ecjp3Z6I9mwKbfrhmLga29AR18
         /tsaKlGI658X/bHoriJs/OMYDk3/MFD73jbdU4nMTPyBctM5KTxO4OXxgt3PRL8/D1ud
         pkMVneqn/XrlzbCp+KOgODRuqWQGkoYfIt9EX2IWA/5WW6EW9FDGg718wUmQKiPUj7wt
         9cvQ==
X-Gm-Message-State: AOAM533wNLk3Ujx+6No7j5azbykxOXtcnXYdgr0x5a4A6cWH/nUAhwlE
        gFxxgrVsGjytHYRjqBRAhxo=
X-Google-Smtp-Source: ABdhPJyx/gQkg5in+KQuvrev3VebglsQMJxualNgy5/M+zPrYTL2ts4BQaJ8iHGY1k9XCP23CgmUsA==
X-Received: by 2002:a17:902:8d8b:b0:138:e09d:d901 with SMTP id v11-20020a1709028d8b00b00138e09dd901mr1167727plo.34.1630714045562;
        Fri, 03 Sep 2021 17:07:25 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id z67sm425437pfb.169.2021.09.03.17.07.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 17:07:25 -0700 (PDT)
Subject: Re: [syzbot] WARNING: kmalloc bug in hash_netport_create
To:     syzbot <syzbot+3f5904753c2388727c6c@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
References: <0000000000003166f105cb201ea6@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <78f147d2-3f26-462e-4263-2029e0dc4d98@gmail.com>
Date:   Fri, 3 Sep 2021 17:07:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <0000000000003166f105cb201ea6@google.com>
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
> console output: https://syzkaller.appspot.com/x/log.txt?x=12a90fb1300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=1ac29107aeb2a552
> dashboard link: https://syzkaller.appspot.com/bug?extid=3f5904753c2388727c6c
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14581b33300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13579a69300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+3f5904753c2388727c6c@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 8430 at mm/util.c:597 kvmalloc_node+0x111/0x120 mm/util.c:597
> Modules linked in:
> CPU: 1 PID: 8430 Comm: syz-executor891 Not tainted 5.14.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
> Code: 01 00 00 00 4c 89 e7 e8 ed 11 0d 00 49 89 c5 e9 69 ff ff ff e8 90 55 d1 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 7f 55 d1 ff <0f> 0b e9 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 66
> RSP: 0018:ffffc900010a7078 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffffc900010a7190 RCX: 0000000000000000
> RDX: ffff88801d93e300 RSI: ffffffff81a3f651 RDI: 0000000000000003
> RBP: 0000000000400dc0 R08: 000000007fffffff R09: 000000000000001f
> R10: ffffffff81a3f60e R11: 000000000000001f R12: 0000000400000018
> R13: 0000000000000000 R14: 00000000ffffffff R15: ffff88803040e000
> FS:  0000000002161300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000080 CR3: 000000003ea95000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  hash_netport_create+0x3dd/0x1220 net/netfilter/ipset/ip_set_hash_gen.h:1524
>  ip_set_create+0x782/0x15a0 net/netfilter/ipset/ip_set_core.c:1100
>  nfnetlink_rcv_msg+0xbc9/0x13f0 net/netfilter/nfnetlink.c:296
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
>  nfnetlink_rcv+0x1ac/0x420 net/netfilter/nfnetlink.c:654
>  netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
>  netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
>  sock_sendmsg_nosec net/socket.c:704 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:724
>  sock_no_sendpage+0xf3/0x130 net/core/sock.c:2980
>  kernel_sendpage.part.0+0x1a0/0x340 net/socket.c:3504
>  kernel_sendpage net/socket.c:3501 [inline]
>  sock_sendpage+0xe5/0x140 net/socket.c:1003
>  pipe_to_sendpage+0x2ad/0x380 fs/splice.c:364
>  splice_from_pipe_feed fs/splice.c:418 [inline]
>  __splice_from_pipe+0x43e/0x8a0 fs/splice.c:562
>  splice_from_pipe fs/splice.c:597 [inline]
>  generic_splice_sendpage+0xd4/0x140 fs/splice.c:746
>  do_splice_from fs/splice.c:767 [inline]
>  do_splice+0xb7e/0x1960 fs/splice.c:1079
>  __do_splice+0x134/0x250 fs/splice.c:1144
>  __do_sys_splice fs/splice.c:1350 [inline]
>  __se_sys_splice fs/splice.c:1332 [inline]
>  __x64_sys_splice+0x198/0x250 fs/splice.c:1332
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x43efb9
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd3f03c028 EFLAGS: 00000246 ORIG_RAX: 0000000000000113
> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043efb9
> RDX: 0000000000000004 RSI: 0000000000000000 RDI: 0000000000000003
> RBP: 0000000000402fa0 R08: 0000000100000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000403030
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
