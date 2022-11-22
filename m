Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2A063344B
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 05:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbiKVEBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 23:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbiKVEBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 23:01:35 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2396C2B19E
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 20:01:33 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id 7so15924329ybp.13
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 20:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WatjMgsu8xYDbCS6d5NbWnjjIAmZ/HrprlfizZ5FLsU=;
        b=GfZOxqIIytBbS6vy0PXSumrG4xHO0gdSnhJJ67oMv/i907sBdpEM7xelnH5Q11aInw
         VJn+gavX55mvcg1d+NB/CxKNqK38OeD/Gx2kvBfF2p9EhOwn/2b2iNqsuUYq1jVZUJmF
         m0mwtphgR47Zou609pI3rJfYR7v7xQDAOtc5P9x2re7CmPAF6MEobM6h7FxVevYEo4Hx
         MUSmhFxIBXw37OVGQdeJxQ3Fjg8suKTL7boAow3lwfEth2B2v3TE2sZ2bvk0eiuGccFN
         Xm9SEHxVRXwuuqZ8a77hg+lC1liUuQN0P/Fm8M4U6l+EkDT0260Pm47tsi8ZVKK4Li72
         qpGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WatjMgsu8xYDbCS6d5NbWnjjIAmZ/HrprlfizZ5FLsU=;
        b=gIkklvLt7ASUqmGhx9jyikW5qYxKJu2YbtfHh6p+7UkOPkmGi70hnSdKuHvSDGZVyT
         3EoeEvt4gDwzZrPp05izoIdren4SfzAT+pX7x9yOIs7njBsNNVvajD+1YzUM7Trc8Hv7
         ImY7wf+JWcdYBYWTOqEyvZeMdpR6Q9K1oO6EYRP5cL4gAKw7C4htB7TwnM1Olht7ig59
         Cd+JQFey2JdUCC3LUMTIiLAbzdfQycOENO5HuO5lNvAxseIF9Ti7H9sMLkNUex6jxwSW
         U3Y2hAhn5+HrVi9So7+Q7RYWIu1bvqP8XTiKN6efRFjKDCIULkh6uRQnriJT5AQbWrLp
         L+Fw==
X-Gm-Message-State: ANoB5pkpWrtI6s0zoiqmmbqGFi+pFGW7S8AhyXoZCwrcwlY/iN/NM2LR
        Yrg1kf2ljJEUl2QLrAs/NkxooBiM/v9VlOumTVOsMw==
X-Google-Smtp-Source: AA0mqf4TZp/WK8/83DOLhafmMO6oEv0HTrYpVFGcGA9b+Ct8+WeENqGYc8WnpT/Z0duqnUSeSAkDSSeNuGxL05Lr9Pk=
X-Received: by 2002:a25:6641:0:b0:6ca:b03:7111 with SMTP id
 z1-20020a256641000000b006ca0b037111mr19875661ybm.598.1669089691912; Mon, 21
 Nov 2022 20:01:31 -0800 (PST)
MIME-Version: 1.0
References: <CAO4mrfdvyjFpokhNsiwZiP-wpdSD0AStcJwfKcKQdAALQ9_2Qw@mail.gmail.com>
 <20221121231028.50834-1-kuniyu@amazon.com>
In-Reply-To: <20221121231028.50834-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 21 Nov 2022 20:01:20 -0800
Message-ID: <CANn89iKjFGSdm8uO8dKx5fYuGkb0a9ThiZvswM5ue0qfZusJUg@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in sk_diag_fill
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     harperchen1110@gmail.com, Jason@zx2c4.com,
        chentao.kernel@linux.alibaba.com, davem@davemloft.net,
        harshit.m.mogalapalli@oracle.com, keescook@chromium.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 3:10 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> Hi Wei,
>
> Thanks for reporting the issue.
>
> From:   Wei Chen <harperchen1110@gmail.com>
> Date:   Mon, 21 Nov 2022 21:34:50 +0800
> > Dear Linux Developer,
> >
> > Recently when using our tool to fuzz kernel, the following crash was triggered.
> >
> > HEAD commit: 147307c69ba
> > git tree: upstream
> > compiler: clang 12.0.0
> > console output:
> > https://drive.google.com/file/d/1WZBgd9dodq3qWgqIXNNBHNEpayHthWr5/view?usp=share_link
> > kernel config: https://drive.google.com/file/d/1NAf4S43d9VOKD52xbrqw-PUP1Mbj8z-S/view?usp=share_link
> >
> > Unfortunately, I didn't have a reproducer for this crash. My manual
> > check identifies that sk->sk_socket in sk_user_ns is null.
>
> This gave me a hint.
>
> I guess syzbot is dumping an AF_UNIX sk while close()ing it concurrently.
> Then, there seems to be a minor race like
>
> unix_release                  unix_diag_handler_dump  <-- called after refcnt reaches 0
>   unix_release_sock              unix_diag_get_exact
>                                    unix_lookup_by_ino
>                                      sock_hold
>     unix_remove_socket  <-- after this, sk cannot be seen in the hash table
>     unix_remove_bsd_socket
>     sock_orphan

Note that sock_orphan() is called while sk_refcnt is not 0 yet.
(sock_put() is called at line 655)

>       sk->sk_socket = NULL  <-- clear the sk->sk_socket
>                                    sk_diag_fill
>                                       sk_diag_dump_uid
>                                         sk_user_ns
>                                           sk->sk_socket->file->f_cred->user_ns  <-- NULL deref
>
> It seems we need to call refcnt_inc_not_zero() instead of sock_hold() in
> unix_lookup_by_ino(), so the fix would be like this.

If this was the case, unix_find_socket_byname() would have a similar issue ?

>
> After checking other paths (at least netlink_dump_start() path) and doing
> some tests, I'll submit a patch.
>
> ---8<---
> diff --git a/net/unix/diag.c b/net/unix/diag.c
> index 105f522a89fe..581500296515 100644
> --- a/net/unix/diag.c
> +++ b/net/unix/diag.c
> @@ -241,8 +241,8 @@ static struct sock *unix_lookup_by_ino(struct net *net, unsigned int ino)
>         for (i = 0; i < UNIX_HASH_SIZE; i++) {
>                 spin_lock(&net->unx.table.locks[i]);
>                 sk_for_each(sk, &net->unx.table.buckets[i]) {
> -                       if (ino == sock_i_ino(sk)) {
> -                               sock_hold(sk);
> +                       if (ino == sock_i_ino(sk) &&
> +                           refcount_inc_not_zero(&sk->sk_refcnt)) {
>                                 spin_unlock(&net->unx.table.locks[i]);
>                                 return sk;
>                         }
> ---8<---
>
> Thank you.
>
>
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: Wei Chen <harperchen1110@gmail.com>
> >
> > BUG: kernel NULL pointer dereference, address: 0000000000000270
> > #PF: supervisor read access in kernel mode
> > #PF: error_code(0x0000) - not-present page
> > PGD 12bbce067 P4D 12bbce067 PUD 12bc40067 PMD 0
> > Oops: 0000 [#1] PREEMPT SMP
> > CPU: 0 PID: 27942 Comm: syz-executor.0 Not tainted 6.1.0-rc5-next-20221118 #2
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> > rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
> > RIP: 0010:sk_user_ns include/net/sock.h:920 [inline]
> > RIP: 0010:sk_diag_dump_uid net/unix/diag.c:119 [inline]
> > RIP: 0010:sk_diag_fill+0x77d/0x890 net/unix/diag.c:170
> > Code: 89 ef e8 66 d4 2d fd c7 44 24 40 00 00 00 00 49 8d 7c 24 18 e8
> > 54 d7 2d fd 49 8b 5c 24 18 48 8d bb 70 02 00 00 e8 43 d7 2d fd <48> 8b
> > 9b 70 02 00 00 48 8d 7b 10 e8 33 d7 2d fd 48 8b 5b 10 48 8d
> > RSP: 0018:ffffc90000d67968 EFLAGS: 00010246
> > RAX: ffff88812badaa48 RBX: 0000000000000000 RCX: ffffffff840d481d
> > RDX: 0000000000000465 RSI: 0000000000000000 RDI: 0000000000000270
> > RBP: ffffc90000d679a8 R08: 0000000000000277 R09: 0000000000000000
> > R10: 0001ffffffffffff R11: 0001c90000d679a8 R12: ffff88812ac03800
> > R13: ffff88812c87c400 R14: ffff88812ae42210 R15: ffff888103026940
> > FS:  00007f08b4e6f700(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000000270 CR3: 000000012c58b000 CR4: 00000000003506f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  <TASK>
> >  unix_diag_get_exact net/unix/diag.c:285 [inline]
> >  unix_diag_handler_dump+0x3f9/0x500 net/unix/diag.c:317
> >  __sock_diag_cmd net/core/sock_diag.c:235 [inline]
> >  sock_diag_rcv_msg+0x237/0x250 net/core/sock_diag.c:266
> >  netlink_rcv_skb+0x13e/0x250 net/netlink/af_netlink.c:2564
> >  sock_diag_rcv+0x24/0x40 net/core/sock_diag.c:277
> >  netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
> >  netlink_unicast+0x5e9/0x6b0 net/netlink/af_netlink.c:1356
> >  netlink_sendmsg+0x739/0x860 net/netlink/af_netlink.c:1932
> >  sock_sendmsg_nosec net/socket.c:714 [inline]
> >  sock_sendmsg net/socket.c:734 [inline]
> >  ____sys_sendmsg+0x38f/0x500 net/socket.c:2476
> >  ___sys_sendmsg net/socket.c:2530 [inline]
> >  __sys_sendmsg+0x197/0x230 net/socket.c:2559
> >  __do_sys_sendmsg net/socket.c:2568 [inline]
> >  __se_sys_sendmsg net/socket.c:2566 [inline]
> >  __x64_sys_sendmsg+0x42/0x50 net/socket.c:2566
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > RIP: 0033:0x4697f9
> > Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
> > 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> > 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007f08b4e6ec48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> > RAX: ffffffffffffffda RBX: 000000000077bf80 RCX: 00000000004697f9
> > RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
> > RBP: 00000000004d29e9 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 000000000077bf80
> > R13: 0000000000000000 R14: 000000000077bf80 R15: 00007ffdb36bc6c0
> >  </TASK>
> > Modules linked in:
> > CR2: 0000000000000270
> > ---[ end trace 0000000000000000 ]---
> > RIP: 0010:sk_user_ns include/net/sock.h:920 [inline]
> > RIP: 0010:sk_diag_dump_uid net/unix/diag.c:119 [inline]
> > RIP: 0010:sk_diag_fill+0x77d/0x890 net/unix/diag.c:170
> > Code: 89 ef e8 66 d4 2d fd c7 44 24 40 00 00 00 00 49 8d 7c 24 18 e8
> > 54 d7 2d fd 49 8b 5c 24 18 48 8d bb 70 02 00 00 e8 43 d7 2d fd <48> 8b
> > 9b 70 02 00 00 48 8d 7b 10 e8 33 d7 2d fd 48 8b 5b 10 48 8d
> > RSP: 0018:ffffc90000d67968 EFLAGS: 00010246
> > RAX: ffff88812badaa48 RBX: 0000000000000000 RCX: ffffffff840d481d
> > RDX: 0000000000000465 RSI: 0000000000000000 RDI: 0000000000000270
> > RBP: ffffc90000d679a8 R08: 0000000000000277 R09: 0000000000000000
> > R10: 0001ffffffffffff R11: 0001c90000d679a8 R12: ffff88812ac03800
> > R13: ffff88812c87c400 R14: ffff88812ae42210 R15: ffff888103026940
> > FS:  00007f08b4e6f700(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000000270 CR3: 000000012c58b000 CR4: 00000000003506f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > ----------------
> > Code disassembly (best guess):
> >    0: 89 ef                mov    %ebp,%edi
> >    2: e8 66 d4 2d fd        callq  0xfd2dd46d
> >    7: c7 44 24 40 00 00 00 movl   $0x0,0x40(%rsp)
> >    e: 00
> >    f: 49 8d 7c 24 18        lea    0x18(%r12),%rdi
> >   14: e8 54 d7 2d fd        callq  0xfd2dd76d
> >   19: 49 8b 5c 24 18        mov    0x18(%r12),%rbx
> >   1e: 48 8d bb 70 02 00 00 lea    0x270(%rbx),%rdi
> >   25: e8 43 d7 2d fd        callq  0xfd2dd76d
> > * 2a: 48 8b 9b 70 02 00 00 mov    0x270(%rbx),%rbx <-- trapping instruction
> >   31: 48 8d 7b 10          lea    0x10(%rbx),%rdi
> >   35: e8 33 d7 2d fd        callq  0xfd2dd76d
> >   3a: 48 8b 5b 10          mov    0x10(%rbx),%rbx
> >   3e: 48                    rex.W
> >   3f: 8d                    .byte 0x8d
> >
> >
> > Best,
> > Wei
