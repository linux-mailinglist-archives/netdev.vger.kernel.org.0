Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE589646B78
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 10:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiLHJIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 04:08:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiLHJH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 04:07:56 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFEC2718;
        Thu,  8 Dec 2022 01:07:40 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so4014136pjj.2;
        Thu, 08 Dec 2022 01:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ENJxr9FvEXoX1xujZQToKReVEYQcyg6+XQFDmfXVQhU=;
        b=nlPE047uAXcYnxsuOVd0h4CrqYD4W2U/gcExvJkbbGDugIynBplXJ3Bwtp2jMSg3Lf
         LO1H5/UflGvx4WwsqcARtJFLrZ2bG9RKBgheqQwBYyq/cUCisnr3yZT/93/geuCHwIAl
         gNHoZEHgh7JWDV2VD/s3nY71xbo1u3rtU0E5qx58C0a9/1kh2Dj43J7Z/U7HYzphkUd5
         w5PBmw4iqH+JHqyyvtow5MG/HZXCkmnRTcHr1qXxkIC62GY3CpoHhAjVGvjOmSRWDSYz
         ajqHAGgRSWZWofZyz+gf7z/NRC90CheDjtkBLIFDJ1e0FxT5w3JI9oqsJ57jrwSd3V54
         sJxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ENJxr9FvEXoX1xujZQToKReVEYQcyg6+XQFDmfXVQhU=;
        b=JPnjAg1PKBv48FiK/L6wBGx9fagu6MrblJ3Aa9LddiaD0LzzkbCg1frF3RU3XZBylA
         KiUeaIYWvAsbEoDnqgvEjbo8H/b6px+/MGgySKlE9djCOsBcX7JP7pB7VS5cO11K/oHU
         wgctdv52qa1DLjIKiOrOr5gpx/sp2G8/KnZQIZ6jHV6H5ykWKak6BWm+iNihbBfuknbi
         0ah+gDLhvktoYolrb+1K4ys4uEvq3+/Oyyk4nqS0oTGtX7X/9HrPsUn2iCn4xYqedCYT
         oa0cIyvtbBj03f/CfvYx0Vl5A2+hQtA/5sfX2NYwNkJmZNRbv55eSTXAYlg5CCQqQUs2
         Kjjg==
X-Gm-Message-State: ANoB5pkn1mYQIs5VppuyosB0UnRBL6GMCO7omThY2BiEWzGr5xEC4L5V
        YgvFQ6FP8om5uPYRLoNhQAA=
X-Google-Smtp-Source: AA0mqf4d5ECtHyhoW1R9koTgyv/d1/H/NmgWhR8LvUV9ODP4GAd+n8o0b75dqM6wI1ZAfyyDp8420A==
X-Received: by 2002:a17:90a:d58c:b0:219:741f:c3af with SMTP id v12-20020a17090ad58c00b00219741fc3afmr35926642pju.68.1670490459893;
        Thu, 08 Dec 2022 01:07:39 -0800 (PST)
Received: from localhost ([98.97.38.190])
        by smtp.gmail.com with ESMTPSA id q15-20020a17090311cf00b00176b63535adsm16168499plh.260.2022.12.08.01.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 01:07:39 -0800 (PST)
Date:   Thu, 08 Dec 2022 01:07:36 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     syzbot <syzbot+04c21ed96d861dccc5cd@syzkaller.appspotmail.com>,
        bpf@vger.kernel.org, davem@davemloft.net, jakub@cloudflare.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Message-ID: <6391a95864c5e_1ec2b208a@john.notmuch>
In-Reply-To: <CANn89iK2UN1FmdUcH12fv_xiZkv2G+Nskvmq7fG6aA_6VKRf6g@mail.gmail.com>
References: <00000000000073b14905ef2e7401@google.com>
 <639034dda7f92_bb36208f5@john.notmuch>
 <CANn89iK2UN1FmdUcH12fv_xiZkv2G+Nskvmq7fG6aA_6VKRf6g@mail.gmail.com>
Subject: Re: [syzbot] BUG: stack guard page was hit in inet6_release
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_SBL_A autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet wrote:
> On Wed, Dec 7, 2022 at 7:38 AM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    6a30d3e3491d selftests: net: Use "grep -E" instead of "egr..
> > > git tree:       net
> > > console+strace: https://syzkaller.appspot.com/x/log.txt?x=1576b11d880000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=cc4b2e0a8e8a8366
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=04c21ed96d861dccc5cd
> > > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14e1656b880000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1077da23880000
> > >
> > > Downloadable assets:
> > > disk image: https://storage.googleapis.com/syzbot-assets/bbee3d5fc908/disk-6a30d3e3.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/bf9e258de70e/vmlinux-6a30d3e3.xz
> > > kernel image: https://storage.googleapis.com/syzbot-assets/afaa6696b9e0/bzImage-6a30d3e3.xz
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+04c21ed96d861dccc5cd@syzkaller.appspotmail.com
> > >
> > > BUG: TASK stack guard page was hit at ffffc90003cd7fa8 (stack is ffffc90003cd8000..ffffc90003ce0000)
> > > stack guard page: 0000 [#1] PREEMPT SMP KASAN
> > > CPU: 0 PID: 3636 Comm: syz-executor238 Not tainted 6.1.0-rc7-syzkaller-00135-g6a30d3e3491d #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> > > RIP: 0010:mark_lock.part.0+0x26/0x1910 kernel/locking/lockdep.c:4593
> > > Code: 00 00 00 00 41 57 41 56 41 55 41 89 d5 48 ba 00 00 00 00 00 fc ff df 41 54 49 89 f4 55 53 48 81 ec 38 01 00 00 48 8d 5c 24 38 <48> 89 3c 24 48 c7 44 24 38 b3 8a b5 41 48 c1 eb 03 48 c7 44 24 40
> > > RSP: 0018:ffffc90003cd7fb8 EFLAGS: 00010096
> > > RAX: 0000000000000004 RBX: ffffc90003cd7ff0 RCX: ffffffff8162a7bf
> > > RDX: dffffc0000000000 RSI: ffff88801f65e238 RDI: ffff88801f65d7c0
> > > RBP: ffff88801f65e25a R08: 0000000000000000 R09: ffffffff910f4aff
> > > R10: fffffbfff221e95f R11: 0000000000000000 R12: ffff88801f65e238
> > > R13: 0000000000000002 R14: 0000000000000000 R15: 0000000000040000
> > > FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: ffffc90003cd7fa8 CR3: 000000000c28e000 CR4: 00000000003506f0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > Call Trace:
> > >  <TASK>
> > >  mark_lock kernel/locking/lockdep.c:4598 [inline]
> > >  mark_usage kernel/locking/lockdep.c:4543 [inline]
> > >  __lock_acquire+0x847/0x56d0 kernel/locking/lockdep.c:5009
> > >  lock_acquire kernel/locking/lockdep.c:5668 [inline]
> > >  lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
> > >  lock_sock_nested+0x3a/0xf0 net/core/sock.c:3447
> > >  lock_sock include/net/sock.h:1721 [inline]
> > >  sock_map_close+0x75/0x7b0 net/core/sock_map.c:1610
> >
> > I'll take a look likely something recent.
> 
> Fact that sock_map_close  can call itself seems risky.
> We might issue a one time warning and keep the host alive.

Agree seems better to check the condition than loop on close.
I still need to figure out the bug that got into this state
though. Thanks.

> 
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index 81beb16ab1ebfcb166f51f89a029fe1c28a629a4..a79771a6627b9b2f38ae6ce153ceff9e8c0be8d4
> 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -1612,17 +1612,25 @@ void sock_map_close(struct sock *sk, long timeout)
>         psock = sk_psock_get(sk);
>         if (unlikely(!psock)) {
>                 rcu_read_unlock();
> +               saved_close = sk->sk_prot->close;
>                 release_sock(sk);
> -               return sk->sk_prot->close(sk, timeout);
> +       } else {
> +               saved_close = psock->saved_close;
> +               sock_map_remove_links(sk, psock);
> +               rcu_read_unlock();
> +               sk_psock_stop(psock);
> +               release_sock(sk);
> +               cancel_work_sync(&psock->work);
> +               sk_psock_put(sk, psock);
> +       }
> +       /* Make sure we do not recurse to us.
> +        * This is a bug, we can leak the socket instead
> +        * of crashing on a stack overflow.
> +        */
> +       if (saved_close == sock_map_close) {
> +               WARN_ON_ONCE(1);
> +               return;
>         }
> -
> -       saved_close = psock->saved_close;
> -       sock_map_remove_links(sk, psock);
> -       rcu_read_unlock();
> -       sk_psock_stop(psock);
> -       release_sock(sk);
> -       cancel_work_sync(&psock->work);
> -       sk_psock_put(sk, psock);
>         saved_close(sk, timeout);
>  }
>  EXPORT_SYMBOL_GPL(sock_map_close);


