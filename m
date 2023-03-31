Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E39586D1728
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 08:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjCaGOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 02:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjCaGOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 02:14:41 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C93549CF;
        Thu, 30 Mar 2023 23:14:40 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id cn12so85571100edb.4;
        Thu, 30 Mar 2023 23:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680243278; x=1682835278;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fMJJkvIp6qgkk4S3jZRJjj/i+K8gFfgEHSPCXp2e6WQ=;
        b=gpl73dKeDrR8rcifSGZTXbI0mnAz8fM0G7rtO73ocBPSywmQNNq+c3VvUzJzAz/Zk7
         RWL0am66Q6mPKXqn08+82N6PfXGMrLdHnvVwWqWjl2cqbmmMc825QLrYW2kAz9T3ZqKo
         +CeEGGZRA6r+mnSplbTWbKtr7OgQQTRTI3Va8sMpF7nm6GKFB4DcWS8W+OTvAESy6MbP
         VItX/7BNQ6qkG4c7+DRwOV2oBdvkekKqiHQUpUFsFUxvjNWMY4t8hi5nFtq69mAM/kPm
         2e4glRtL3hH7hMr7LElnQ2Q6sBpfINSkLt5qEJdZd4+6PQRaRZMNecHHtz01ZNIgQZvP
         BVAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680243278; x=1682835278;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fMJJkvIp6qgkk4S3jZRJjj/i+K8gFfgEHSPCXp2e6WQ=;
        b=XJbwuYLpwAc7x1tqZ3kB1CDLAriUSeH6SXlPckOaolM9y3/sUfOBN6dQhGTPmENr6U
         aFdFhw8Rqc5BbQ9qeK//Pm2rINRZzBocj8vM7XT4kaj/ZuTF+Pn2jpupk3surEzfFNpp
         LPGzpBOtVZGKSMBy37pIX7wtbIGdExbkyZIZYBb57s5JLihccD4T5Oci4k/bxxh9HzAI
         MEUJON70WumlhDTySAg5VKgU7N9NJ3xqxiPxdGH3RdUvYWx4cfr+8OYObEvFxPjrE+6p
         qiAl1w2Rnmg68B3j+LErEAwev9NyVeGqn7DKSKxR0GEGDEOvqUfO59Lo1VPM3PV3kQbj
         RGzg==
X-Gm-Message-State: AAQBX9cJRkv2QvrLTYioEgQKjG72MESZA715O7zfxNs2Smzpycg0RAfl
        h7tnMAoc03OAc4VXK5tIUV6OMIguRis0WKvHTA4=
X-Google-Smtp-Source: AKy350a9Azp5drvmQWz6/az9KNdYEz/N14hcFhMRcJgyYvap/RWKv252xuhmxsHHbDFqXDbG7Xk3Obr8jbUxk/k/SZo=
X-Received: by 2002:a50:ab5a:0:b0:4bb:e549:a2ad with SMTP id
 t26-20020a50ab5a000000b004bbe549a2admr13008496edc.4.1680243278475; Thu, 30
 Mar 2023 23:14:38 -0700 (PDT)
MIME-Version: 1.0
References: <0429FBD6-9BCC-4E97-BB7D-71D694D19797@amazon.co.jp>
In-Reply-To: <0429FBD6-9BCC-4E97-BB7D-71D694D19797@amazon.co.jp>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Fri, 31 Mar 2023 14:14:02 +0800
Message-ID: <CAL+tcoBqjXtAxAxZH-FYKhTuY2a9W2ffeH+JxrOQ2P9pUOeHVw@mail.gmail.com>
Subject: Re: general protection fault in raw_seq_start
To:     "Iwashima, Kuniyuki" <kuniyu@amazon.co.jp>
Cc:     "threeearcat@gmail.com" <threeearcat@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 1:40=E2=80=AFPM Iwashima, Kuniyuki <kuniyu@amazon.c=
o.jp> wrote:
>
> From: Jason Xing <kerneljasonxing@gmail.com>
> Date: Fri, 31 Mar 2023 13:31:01 +0800
> > On Fri, Mar 31, 2023 at 6:08=3DE2=3D80=3DAFAM Kuniyuki Iwashima <kuniyu=
@amazon.com> wro
> > te:
> > >
> > > From:   "Dae R. Jeong" <threeearcat@gmail.com>
> > > Date:   Sun, 26 Mar 2023 21:12:08 +0900
> > > > Hi,
> > > >
> > > > We observed an issue "general protection fault in raw_seq_start"
> > > > during fuzzing.
> > > >
> > > > Unfortunately, we have not found a reproducer for the crash yet. We
> > > > will inform you if we have any update on this crash.
> > > > Detailed crash information is attached below.
> > > >
> > > > Best regards,
> > > > Dae R. Jeong
> > > >
> > > > -----
> > > >
> > > > - Kernel version
> > > >   6.2
> > > >
> > > > - Last executed input
> > > >   unshare(0x40060200)
> > > >   r0 =3D3D syz_open_procfs(0x0, &(0x7f0000002080)=3D3D'net/raw\x00'=
)
> > > >   socket$inet_icmp_raw(0x2, 0x3, 0x1)
> > > >   ppoll(0x0, 0x0, 0x0, 0x0, 0x0)
> > > >   socket$inet_icmp_raw(0x2, 0x3, 0x1)
> > > >   pread64(r0, &(0x7f0000000000)=3D3D""/10, 0xa, 0x10000000007f)
> > >
> > > Thanks for reporting the issue.
> > >
> > > It seems we need to use RCU variant in raw_get_first().
> > > I'll post a patch.
> > >
> > > ---
> > > diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
> > > index 3cf68695b40d..fe0d1ad20b35 100644
> > > --- a/net/ipv4/raw.c
> > > +++ b/net/ipv4/raw.c
> > > @@ -957,7 +957,7 @@ static struct sock *raw_get_first(struct seq_file=
 *se
> > q, int bucket)
> > >         for (state->bucket =3D3D bucket; state->bucket < RAW_HTABLE_S=
IZE;
> > >                         ++state->bucket) {
> > >                 hlist =3D3D &h->ht[state->bucket];
> > > -               sk_nulls_for_each(sk, hnode, hlist) {
> > > +               sk_nulls_for_each_rcu(sk, hnode, hlist) {
> >
> > Hello Kuniyuki,
> >
> > I'm wondering if we should also use rcu_read_lock()/_unlock() pair to p=
rote
> > ct?
>
> It's used.  See raw_seq_start() and raw_seq_stop().

Yes, it is.

>
>
> >
> > CC: Eric
> >
> > It seems that we have to convert all the sk_nulls_for_each() to
> > sk_nulls_for_each_rcu() with the rcu_read_lock/_unlock protection in
> > net/ipv4/raw.c?
>
> Yes, I'm preparing the change including raw_diag.c, and I think we
> need sk_null_next_rcu() as the issue happend in raw_get_next() this
> time.
>
> Also, I have the same change for ping.c

Great !

>
> Thanks,
> Kuniyuki
>
>
> >
> > Thanks,
> > Jason
> >
> > >                         if (sock_net(sk) =3D3D=3D3D seq_file_net(seq)=
)
> > >                                 return sk;
> > >                 }
> > > ---
> > >
> > > Thanks,
> > > Kuniyuki
> > >
> > >
> > >
> > > >
> > > > - Crash report
> > > > general protection fault, probably for non-canonical address 0xdfff=
fc00
> > 00000005: 0000 [#1] PREEMPT SMP KASAN
> > > > KASAN: null-ptr-deref in range [0x0000000000000028-0x00000000000000=
2f]
> > > > CPU: 2 PID: 20952 Comm: syz-executor.0 Not tainted 6.2.0-g048ec869b=
afd-
> > dirty #7
> > > > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.1=
4.0-
> > 0-g155821a1990b-prebuilt.qemu.org 04/01/2014
> > > > RIP: 0010:read_pnet include/net/net_namespace.h:383 [inline]
> > > > RIP: 0010:sock_net include/net/sock.h:649 [inline]
> > > > RIP: 0010:raw_get_next net/ipv4/raw.c:974 [inline]
> > > > RIP: 0010:raw_get_idx net/ipv4/raw.c:986 [inline]
> > > > RIP: 0010:raw_seq_start+0x431/0x800 net/ipv4/raw.c:995
> > > > Code: ef e8 33 3d 94 f7 49 8b 6d 00 4c 89 ef e8 b7 65 5f f7 49 89 e=
d 49
> >  83 c5 98 0f 84 9a 00 00 00 48 83 c5 c8 48 89 e8 48 c1 e8 03 <42> 80 3c=
 30 0
> > 0 74 08 48 89 ef e8 00 3d 94 f7 4c 8b 7d 00 48 89 ef
> > > > RSP: 0018:ffffc9001154f9b0 EFLAGS: 00010206
> > > > RAX: 0000000000000005 RBX: 1ffff1100302c8fd RCX: 0000000000000000
> > > > RDX: 0000000000000028 RSI: ffffc9001154f988 RDI: ffffc9000f77a338
> > > > RBP: 0000000000000029 R08: ffffffff8a50ffb4 R09: fffffbfff24b6bd9
> > > > R10: fffffbfff24b6bd9 R11: 0000000000000000 R12: ffff88801db73b78
> > > > R13: fffffffffffffff9 R14: dffffc0000000000 R15: 0000000000000030
> > > > FS:  00007f843ae8e700(0000) GS:ffff888063700000(0000) knlGS:0000000=
0000
> > 00000
> > > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > CR2: 000055bb9614b35f CR3: 000000003c672000 CR4: 00000000003506e0
> > > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > > Call Trace:
> > > >  <TASK>
> > > >  seq_read_iter+0x4c6/0x10f0 fs/seq_file.c:225
> > > >  seq_read+0x224/0x320 fs/seq_file.c:162
> > > >  pde_read fs/proc/inode.c:316 [inline]
> > > >  proc_reg_read+0x23f/0x330 fs/proc/inode.c:328
> > > >  vfs_read+0x31e/0xd30 fs/read_write.c:468
> > > >  ksys_pread64 fs/read_write.c:665 [inline]
> > > >  __do_sys_pread64 fs/read_write.c:675 [inline]
> > > >  __se_sys_pread64 fs/read_write.c:672 [inline]
> > > >  __x64_sys_pread64+0x1e9/0x280 fs/read_write.c:672
> > > >  do_syscall_x64 arch/x86/entry/common.c:51 [inline]
> > > >  do_syscall_64+0x4e/0xa0 arch/x86/entry/common.c:82
> > > >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > > RIP: 0033:0x478d29
> > > > Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 4=
8 89
> >  f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01=
 f0 f
> > f ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> > > > RSP: 002b:00007f843ae8dbe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000=
011
> > > > RAX: ffffffffffffffda RBX: 0000000000791408 RCX: 0000000000478d29
> > > > RDX: 000000000000000a RSI: 0000000020000000 RDI: 0000000000000003
> > > > RBP: 00000000f477909a R08: 0000000000000000 R09: 0000000000000000
> > > > R10: 000010000000007f R11: 0000000000000246 R12: 0000000000791740
> > > > R13: 0000000000791414 R14: 0000000000791408 R15: 00007ffc2eb48a50
> > > >  </TASK>
> > > > Modules linked in:
> > > > ---[ end trace 0000000000000000 ]---
> > > > RIP: 0010:read_pnet include/net/net_namespace.h:383 [inline]
> > > > RIP: 0010:sock_net include/net/sock.h:649 [inline]
> > > > RIP: 0010:raw_get_next net/ipv4/raw.c:974 [inline]
> > > > RIP: 0010:raw_get_idx net/ipv4/raw.c:986 [inline]
> > > > RIP: 0010:raw_seq_start+0x431/0x800 net/ipv4/raw.c:995
> > > > Code: ef e8 33 3d 94 f7 49 8b 6d 00 4c 89 ef e8 b7 65 5f f7 49 89 e=
d 49
> >  83 c5 98 0f 84 9a 00 00 00 48 83 c5 c8 48 89 e8 48 c1 e8 03 <42> 80 3c=
 30 0
> > 0 74 08 48 89 ef e8 00 3d 94 f7 4c 8b 7d 00 48 89 ef
> > > > RSP: 0018:ffffc9001154f9b0 EFLAGS: 00010206
> > > > RAX: 0000000000000005 RBX: 1ffff1100302c8fd RCX: 0000000000000000
> > > > RDX: 0000000000000028 RSI: ffffc9001154f988 RDI: ffffc9000f77a338
> > > > RBP: 0000000000000029 R08: ffffffff8a50ffb4 R09: fffffbfff24b6bd9
> > > > R10: fffffbfff24b6bd9 R11: 0000000000000000 R12: ffff88801db73b78
> > > > R13: fffffffffffffff9 R14: dffffc0000000000 R15: 0000000000000030
> > > > FS:  00007f843ae8e700(0000) GS:ffff888063700000(0000) knlGS:0000000=
0000
> > 00000
> > > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > CR2: 00007f92ff166000 CR3: 000000003c672000 CR4: 00000000003506e0
> > > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>
