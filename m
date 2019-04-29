Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 448AADC39
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 08:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfD2Gwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 02:52:36 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:55221 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727173AbfD2Gwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 02:52:35 -0400
Received: by mail-it1-f196.google.com with SMTP id a190so14680580ite.4
        for <netdev@vger.kernel.org>; Sun, 28 Apr 2019 23:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zvLVbK2/lAdTa2UCC0jErpN68Rn8naIN0RD5L8v9Ppc=;
        b=Jp+ULjlyqj0Lx7cDHB7EdrtvNTCf2aAKRYCIRQx7MU9BGkjFX6ahgejNpO8hnJ/QcC
         bHbmQsHSNKRUrJUpo6a5Dq7iWsBrHhzCI3g9wtgLCmETcBLwOV7SHnZzQ3OAdirkcZJB
         4KpTx7nz968wHASPa3pR+Tj5YdLx2Ld/Vw+lr7ITMT+W+ayJqneeNhC4m9KYQlBjg962
         qMpbXAX0pbilKQQobc8yC91jTHk6QlV1HOSillnifoOiWdfBIEpHu6n5JlgUBQUeWQSZ
         15BHun1dduloQekUYDVAxMqYgQZ629emW/htJJTdTPHRC1xyuFFktLuB+etEtrWH/K9k
         7WHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zvLVbK2/lAdTa2UCC0jErpN68Rn8naIN0RD5L8v9Ppc=;
        b=palqsjJCQPagYLz4J0LsjBjINHEAfPYz8osexoKh3Dv0LsCDAagiHf/P5jV76QrdhD
         h5W2DZHV3OCchABC8vmnz0ViJprU5Rr/TvuURiOyt/4o419xVMChV+IXS9grJNhuIWcp
         +a+FvHwZxIRjIvzK8VEwYVGyPmb/D81onpKvKojnQtylSHjwX8d+Op+fWoxdEAawRjLs
         Pq9EFx0SRTgBhpx8QYrqel9vYWWyc8oo6EGewWn2z23u7mcNgotJn7f4bTaYKH+pgLEf
         mnqMbtOpnrqP20sotC+K03QAlaErbCjqPjlj881DrryzR1CBFmZFh4dEHT6UKC/Z+2sw
         XSdQ==
X-Gm-Message-State: APjAAAVnaa6ysu/SVE2GT8CGGH+lnHa0uHeI8rml7xIw/m/4syQv+SBK
        jIwBU1xP9ZettsuO1l+5Fsjbabro0zVqdAN94xo8jA==
X-Google-Smtp-Source: APXvYqxzb/C2FBh7CRQQXMtC33Ktk+38p1MO2hRC05YJeaNCeXgIiNir0AcA42Mk7ymeqg1LU+FKDH9HK1ocdy1b79E=
X-Received: by 2002:a24:7893:: with SMTP id p141mr16468909itc.166.1556520754247;
 Sun, 28 Apr 2019 23:52:34 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000006b30f30587a5b569@google.com>
In-Reply-To: <0000000000006b30f30587a5b569@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 29 Apr 2019 08:52:23 +0200
Message-ID: <CACT4Y+bVXqwUC=af43XOddD0JxcrEw4556jMAER830hY6wDmRw@mail.gmail.com>
Subject: Re: general protection fault in ip6_dst_lookup_tail (2)
To:     syzbot <syzbot+58d8f704b86e4e3fb4d3@syzkaller.appspotmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 8:51 AM syzbot
<syzbot+58d8f704b86e4e3fb4d3@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    fdfdf867 net: phy: marvell: Fix buffer overrun with stats ..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=12be0d38a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a42d110b47dd6b36
> dashboard link: https://syzkaller.appspot.com/bug?extid=58d8f704b86e4e3fb4d3
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+58d8f704b86e4e3fb4d3@syzkaller.appspotmail.com

Eric, can this be fixed by your "ipv6: fix races in ip6_dst_destroy()"?
https://patchwork.ozlabs.org/patch/1092328/


> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 20190 Comm: syz-executor.0 Not tainted 5.1.0-rc6+ #184
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:ip6_route_get_saddr include/net/ip6_route.h:119 [inline]
> RIP: 0010:ip6_dst_lookup_tail+0xf0e/0x1b30 net/ipv6/ip6_output.c:971
> Code: e6 07 e8 55 57 61 fb 48 85 db 0f 84 83 08 00 00 e8 47 57 61 fb 48 8d
> 7b 7c 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48
> 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 07
> RSP: 0018:ffff888063406f40 EFLAGS: 00010207
> RAX: dffffc0000000000 RBX: 00c0200001ffff88 RCX: ffffc90005fe4000
> RDX: 0018040000400000 RSI: ffffffff860f35a9 RDI: 00c0200002000004
> RBP: ffff888063407098 R08: ffff888085a7c000 R09: ffffed1015d25bc8
> R10: ffffed1015d25bc7 R11: ffff8880ae92de3b R12: ffff8880653b3270
> R13: 0000000000000000 R14: 0000000000000000 R15: ffff8880653b3298
> FS:  00007f58b1851700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000001fc96f0 CR3: 000000006d91d000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   ip6_dst_lookup_flow+0xa8/0x220 net/ipv6/ip6_output.c:1094
>   sctp_v6_get_dst+0x785/0x1d80 net/sctp/ipv6.c:293
>   sctp_transport_route+0x132/0x370 net/sctp/transport.c:312
>   sctp_assoc_add_peer+0x53e/0xfc0 net/sctp/associola.c:678
>   sctp_process_param net/sctp/sm_make_chunk.c:2548 [inline]
>   sctp_process_init+0x249f/0x2b20 net/sctp/sm_make_chunk.c:2361
>   sctp_sf_do_unexpected_init net/sctp/sm_statefuns.c:1556 [inline]
>   sctp_sf_do_unexpected_init.isra.0+0x7cd/0x1350 net/sctp/sm_statefuns.c:1456
>   sctp_sf_do_5_2_1_siminit+0x35/0x40 net/sctp/sm_statefuns.c:1685
>   sctp_do_sm+0x12c/0x5770 net/sctp/sm_sideeffect.c:1188
>   sctp_assoc_bh_rcv+0x343/0x660 net/sctp/associola.c:1074
>   sctp_inq_push+0x1ea/0x290 net/sctp/inqueue.c:95
>   sctp_backlog_rcv+0x196/0xbe0 net/sctp/input.c:354
>   sk_backlog_rcv include/net/sock.h:943 [inline]
>   __release_sock+0x12e/0x3a0 net/core/sock.c:2413
>   release_sock+0x59/0x1c0 net/core/sock.c:2929
>   sctp_wait_for_connect+0x316/0x540 net/sctp/socket.c:9048
>   __sctp_connect+0xac2/0xce0 net/sctp/socket.c:1241
>   sctp_connect net/sctp/socket.c:4858 [inline]
>   sctp_inet_connect+0x2a2/0x340 net/sctp/socket.c:4874
>   __sys_connect+0x266/0x330 net/socket.c:1808
>   __do_sys_connect net/socket.c:1819 [inline]
>   __se_sys_connect net/socket.c:1816 [inline]
>   __x64_sys_connect+0x73/0xb0 net/socket.c:1816
>   do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x458da9
> Code: ad b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> ff 0f 83 7b b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f58b1850c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000458da9
> RDX: 000000000000001c RSI: 0000000020000200 RDI: 0000000000000003
> RBP: 000000000073bfa0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f58b18516d4
> R13: 00000000004bf1f1 R14: 00000000004d02c0 R15: 00000000ffffffff
> Modules linked in:
> ---[ end trace 04c26bfcf25dca59 ]---
> RIP: 0010:ip6_route_get_saddr include/net/ip6_route.h:119 [inline]
> RIP: 0010:ip6_dst_lookup_tail+0xf0e/0x1b30 net/ipv6/ip6_output.c:971
> Code: e6 07 e8 55 57 61 fb 48 85 db 0f 84 83 08 00 00 e8 47 57 61 fb 48 8d
> 7b 7c 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48
> 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 07
> RSP: 0018:ffff888063406f40 EFLAGS: 00010207
> RAX: dffffc0000000000 RBX: 00c0200001ffff88 RCX: ffffc90005fe4000
> RDX: 0018040000400000 RSI: ffffffff860f35a9 RDI: 00c0200002000004
> RBP: ffff888063407098 R08: ffff888085a7c000 R09: ffffed1015d25bc8
> R10: ffffed1015d25bc7 R11: ffff8880ae92de3b R12: ffff8880653b3270
> R13: 0000000000000000 R14: 0000000000000000 R15: ffff8880653b3298
> FS:  00007f58b1851700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000070c09b CR3: 000000006d91d000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/0000000000006b30f30587a5b569%40google.com.
> For more options, visit https://groups.google.com/d/optout.
