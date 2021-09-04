Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A134008AE
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 02:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350870AbhIDAIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 20:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241161AbhIDAIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 20:08:48 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E9DC061575;
        Fri,  3 Sep 2021 17:07:48 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id q68so602323pga.9;
        Fri, 03 Sep 2021 17:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+mVoTqIs56bNQ1deG3V1aZN0U7vd3lwsv7VdJpsX3pg=;
        b=J1zuwtUE54/m4VyBOYyLqAYApxPMjGinwcUU2XK+mghE60bXs6SvUdB+qficVILeHw
         TrKKw1dHDhAXRDCPH5bHBtciF+s5RUG38zYlSGM5JT0obXJnXv6WvGVntbQuGGhm1+jT
         pcyDnUMuxtW8QJc8MR5wVGwmcw6gFAxctFLjoU2t6k2JamnegVt7Y0T0UEmzYUCx0UmC
         uiPVtSpoNlanH8u4eEs65QwPSrFs78URrdZzHkDI/inzvwr6ihV3fNUohZyAltLgjDDH
         onPUVJ3JpNGUqDmFB/o+h2wm3g2G6L+M0INM5tSEqUBSNz6xUc7tzIWxWDKUs4EqTmSu
         lAbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+mVoTqIs56bNQ1deG3V1aZN0U7vd3lwsv7VdJpsX3pg=;
        b=RP2es2EbHPujseuJeXNb2s+pQC1v+rsfrKp1YWUJME4cNdm0UMxU5/vZ/c0y0Xh7Ka
         vd0LKW08fvVQJSrhogYE7P0O1vBBqgvl2Vsx4Z4q0sCLVLegqJRj5N3JJLyvxfSOiUJD
         51v5wK9mDMMPjOqGvnyqslh4mwAtSaG2d03CGc1et3QYRSJY5Mwo4ZKCccp0tX1bVI9R
         tLyZdJfwK8xU18xY4qS9FTAYoh3ied2vemDIWplYrA1rLyejSq3xerH7XVzVws6JBso+
         l9efx23pIjMfQYC7/N6Ah/EnDd8/FxS+ZwDlWq02iYEnD1Hwq7HKZbPC960igrC7DlwF
         2Y7g==
X-Gm-Message-State: AOAM532J0wiUYbrnXL1VCAFNDSwpviLJ4xkzlRjHW9ettZSoDlMM78I3
        3LgIan4LtcPCrL3Nf7eQx3w=
X-Google-Smtp-Source: ABdhPJyGImxIg0ZYhhgtw848pfK3F40/rUKHw7q7gUWNs7rquTlSHexBcZYH3NoUVOyUmbUcfE5bSg==
X-Received: by 2002:a63:b54b:: with SMTP id u11mr704980pgo.163.1630714067663;
        Fri, 03 Sep 2021 17:07:47 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id gg22sm344445pjb.19.2021.09.03.17.07.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 17:07:47 -0700 (PDT)
Subject: Re: [syzbot] WARNING: kmalloc bug in hash_ipmac_create
To:     syzbot <syzbot+cf28dc7802e9fcee1305@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
References: <0000000000006b591e05cb1ffa15@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2ad16067-2d2c-e835-896b-944ca33872da@gmail.com>
Date:   Fri, 3 Sep 2021 17:07:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <0000000000006b591e05cb1ffa15@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/21 4:51 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    a9c9a6f741cd Merge tag 'scsi-misc' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=176e5ccd300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=1ac29107aeb2a552
> dashboard link: https://syzkaller.appspot.com/bug?extid=cf28dc7802e9fcee1305
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1076ba86300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10b3e6a3300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+cf28dc7802e9fcee1305@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 8431 at mm/util.c:597 kvmalloc_node+0x111/0x120 mm/util.c:597
> Modules linked in:
> CPU: 0 PID: 8431 Comm: syz-executor142 Not tainted 5.14.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
> Code: 01 00 00 00 4c 89 e7 e8 ed 11 0d 00 49 89 c5 e9 69 ff ff ff e8 90 55 d1 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 7f 55 d1 ff <0f> 0b e9 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 66
> RSP: 0018:ffffc90001a27288 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffffc90001a273a0 RCX: 0000000000000000
> RDX: ffff8880167301c0 RSI: ffffffff81a3f651 RDI: 0000000000000003
> RBP: 0000000000400dc0 R08: 000000007fffffff R09: 000000000000001f
> R10: ffffffff81a3f60e R11: 000000000000001f R12: 0000000400000018
> R13: 0000000000000000 R14: 00000000ffffffff R15: ffff88801767fe00
> FS:  0000000000d00300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000006 CR3: 000000001e129000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  hash_ipmac_create+0x3dd/0x1220 net/netfilter/ipset/ip_set_hash_gen.h:1524
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
> RSP: 002b:00007fff67f70028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f039
> RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000003
> RBP: 0000000000403020 R08: 0000000000000009 R09: 0000000000400488
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
