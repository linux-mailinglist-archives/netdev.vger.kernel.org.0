Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C816B9A94
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjCNQED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbjCNQDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:03:47 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F267E8BE
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:03:26 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id h11-20020a17090a2ecb00b00237c740335cso15625570pjs.3
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678809806;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yert8XYQoW/L/Z24hlch2pu0EFI77+DiHZvVh/lS4h0=;
        b=WjKpQ9LI+lIlIw8CcPe/Vc+KNiio0ReUNFqu2WqFS/NAVgGaJR2qNVOy11SCQ+Jyae
         +8h2ra0jM11VsneR592HMIh6t9WDKLJTFCSbOEXyvIExPl24yKdvrJzlk/9wJQe7MUjk
         m3GjNoOjU3qaLtiPQkVT3U9xR8gJS76q8aXLfXrdQrltLxaPUCj2VLBqRWDdUqLeaLAY
         rhGZHqdg+mYH28PQfbrBB0cX9n5ov2xN0KPsxccJ+T21vFBH1smzWtenr3A2QFds0vRw
         E5bODr4H03OW/6S1QlNmeETQoyYAdzuV02o7sZgO9AMiHAwCKi84VQvmztxn2LjF44zA
         o2oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678809806;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yert8XYQoW/L/Z24hlch2pu0EFI77+DiHZvVh/lS4h0=;
        b=Vcm8pJ7mxRC6PU174vqSebOtF55m/wBrylu37Cj7uUWKjQR0JcLCORAi/dFseNOraJ
         5fBqOYsqlW4PIkTD2FojWYEVkjE7oLcc7cDnqY4RVopdYefQb/AzTa7D364LUIKy77tQ
         7B6Cr3TWJMbXHktZTNtVDakQ2xewHg1RtoVToXeV3TkD46KCjCJ0nlWEfghxhm9wkh3K
         5vYlp2j8EIi+HNsL5u3VHSmFFsp8qWv1bEwRd/ZqXPi2Q9Af37MEyirvMdDjwcz9eyJj
         9JZ39moLt0VoLLp738FjOxF8Cc/3YIL69jS1Uvzpgd76rc9JTUThvF+ZHaUF7SGYuNTB
         ggSA==
X-Gm-Message-State: AO0yUKXDk82nUh5hRpvJlvj0gEzCvzPbPWzyERSlrlSgNb4NKrh9rb6p
        hrjDMATf7tZ3zYc6AYdtkKhK6PmoreUb3xzs2R4=
X-Google-Smtp-Source: AK7set8jkXc/UNzJ5HIpaCy3Z5DsBSwgy2zaSkWftu8AEHlgUo7F4BYNJ+MrqiDhs0e4k+52CYemvR4nxGlOnqgbv4U=
X-Received: by 2002:a17:90a:ac16:b0:23d:4ab8:b1a3 with SMTP id
 o22-20020a17090aac1600b0023d4ab8b1a3mr313445pjq.1.1678809805785; Tue, 14 Mar
 2023 09:03:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAL87dS0sSsKQOcf22gcHuHu7PjG_j1uiOx-AfRKdT7rznVfJ6Q@mail.gmail.com>
 <20230310213804.26304-1-kuniyu@amazon.com> <CAL87dS3Brkkbi-j-_W3LYORWJ+VOXockpiBwNZQ84rWk+o8SXw@mail.gmail.com>
 <CANn89iK4+SoBG3QwvumauH+X8GOxWZyd8S7YC_bFC-3AW8H-aA@mail.gmail.com>
In-Reply-To: <CANn89iK4+SoBG3QwvumauH+X8GOxWZyd8S7YC_bFC-3AW8H-aA@mail.gmail.com>
From:   mingkun bian <bianmingkun@gmail.com>
Date:   Wed, 15 Mar 2023 00:03:14 +0800
Message-ID: <CAL87dS1ZCNaX6F+NGNm=RTFNJ0pE7zfceX2YCJc_N-K8cMPefQ@mail.gmail.com>
Subject: Re: [ISSUE]soft lockup in __inet_lookup_established() function which
 one sock exist in two hash buckets(tcp_hashinfo.ehash)
To:     Eric Dumazet <edumazet@google.com>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>, kerneljasonxing@gmail.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
    I find a patch about tw sock, and we encountered a similar
problem(my problem maybe the same "sock reuse" issue).

https://patchwork.ozlabs.org/project/netdev/patch/20181220232856.1496-1-edu=
mazet@google.com/

    I have some doubts about this patch, why does a freed tw sock(I
think "sk refcnts is 0" indicate that the tw sock have deleted the
twsk timer) can fires twsk timer after a minute later?

1. First something iterating over sockets finds already freed tw socket:
refcount_t: increment on 0; use-after-free.
WARNING: CPU: 2 PID: 2738 at lib/refcount.c:153 refcount_inc+0x26/0x30

2. then a minute later twsk timer fires and hits two bad refcnts
for this freed socket:
refcount_t: decrement hit 0; leaking memory.
WARNING: CPU: 31 PID: 0 at lib/refcount.c:228 refcount_dec+0x2e/0x40


call trace:
[11182399.994652] RIP: 0010:refcount_error_report+0xa0/0xa4
[11182399.994654] Code: 09 00 00 48 8b 95 80 00 00 00 49 8d 8c 24 e0
0a 00 00 41 89 c1 44 89 2c 24 48 89 de 48 c7 c7 c8 7f 87 96 31 c0 e8
20 fa ff ff <0f> 0b eb 88 0f 1f 44
00 00 55 48 89 e5 41 56 41 55 41 54 49 89 fc
[11182399.994655] RSP: 0000:ffff938fdf8c3d28 EFLAGS: 00010282
[11182399.994656] RAX: 0000000000000000 RBX: ffffffff9687408b RCX:
0000000000000007
[11182399.994656] RDX: 0000000000000000 RSI: 0000000000000082 RDI:
ffff938fdf8d6a40
[11182399.994657] RBP: ffff938fdf8c3de8 R08: 0000000000000000 R09:
0000000000000d47
[11182399.994658] R10: 0000000000000001 R11: 0000000000000000 R12:
ffff938f830d1ec0
[11182399.994658] R13: 00000000000004b0 R14: ffffffff9605507b R15:
0000000000000006
[11182399.994660] FS:  000015030c545700(0000)
GS:ffff938fdf8c0000(0000) knlGS:0000000000000000
[11182399.994661] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[11182399.994662] CR2: 0000556bbabfc008 CR3: 0000002f6d632005 CR4:
00000000007606e0
[11182399.994662] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[11182399.994663] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[11182399.994664] PKRU: 55555554
[11182399.994664] Call Trace:
[11182399.994667]  <IRQ>
[11182399.994674]  ex_handler_refcount+0x4e/0x80
[11182399.994676]  fixup_exception+0x35/0x40
[11182399.994681]  do_trap+0xbf/0x120
[11182399.994683]  do_invalid_op+0x3d/0x50
[11182399.994688]  ? csum_partial_copy_generic+0x11bb/0x1fd0
[11182399.994691]  invalid_op+0x14/0x20
[11182399.994693] RIP: 0010:inet_twsk_bind_unhash+0x53/0x60
[11182399.994694] Code: 48 c7 83 e0 00 00 00 00 00 00 00 48 8b 7e 18
48 89 d6 e8 a0 f2 ff ff f0 ff 8b 80 00 00 00 0f 84 37 d6 0e 00 0f 88
31 d6 0e 00 <5b> c3 90 66 2e 0f 1f
84 00 00 00 00 00 0f 1f 44 00 00 55 53 48 8b
[11182399.994695] RSP: 0000:ffff938fdf8c3e98 EFLAGS: 00010246
[11182399.994696] RAX: ffff9365bac9c998 RBX: ffff938f5f339100 RCX:
ffff938f5f339180
[11182399.994697] RDX: ffff9377d7471980 RSI: ffff9377d7471980 RDI:
ffff936107d7ce00
[11182399.994697] RBP: ffffba854dffdd70 R08: 0000000000000001 R09:
0000000000000000
[11182399.994698] R10: ffff938f5f339dc0 R11: fffff9b93d7cce00 R12:
ffffffff9749dac0
[11182399.994698] R13: ffffffff95f67ba0 R14: 0000000000000000 R15:
0000000000000000
[11182399.994700]  ? inet_twsk_kill+0xe0/0xe0
[11182399.994702]  ? inet_twsk_bind_unhash+0x40/0x60
[11182399.994703]  inet_twsk_kill+0xaa/0xe0
[11182399.994709]  call_timer_fn+0x2d/0x140
[11182399.994711]  run_timer_softirq+0x1e2/0x440
[11182399.994713]  ? hrtimer_init+0x190/0x190
[11182399.994714]  ? hrtimer_wakeup+0x1e/0x30
[11182399.994717]  ? sched_clock+0x5/0x10
[11182399.994719]  __do_softirq+0xe2/0x2d7
[11182399.994722]  irq_exit+0xec/0x100
[11182399.994724]  smp_apic_timer_interrupt+0x74/0x140
[11182399.994725]  apic_timer_interrupt+0xf/0x20
[11182399.994726]  </IRQ>
[11182399.994728] RIP: 0033:0x15031c22bcd8
[11182399.994729] Code: 85 c0 74 05 f0 83 43 20 01 5b c3 0f 1f 80 00
00 00 00 48 85 f6 74 14 48 8b 05 f4 bc 21 00 53 48 89 fb ff 50 08 f0
83 6b 20 01 <5b> f3 c3 0f 1f 44 00
00 55 48 89 cd 53 48 89 fb 48 83 ec 08 48 8b
[11182399.994729] RSP: 002b:000015030c5448e0 EFLAGS: 00000206
ORIG_RAX: ffffffffffffff13
[11182399.994731] RAX: 00001502b00e4000 RBX: 00000000021a5000 RCX:
000000062cee1707
[11182399.994731] RDX: 000000062cee1707 RSI: 00001501f8625000 RDI:
00000000021a5000
[11182399.994732] RBP: 0000150240154980 R08: 0000000000000000 R09:
0000000000000000
[11182399.994732] R10: 0000000000000000 R11: 000000000000007d R12:
0000000000000000
[11182399.994733] R13: 00001502fd665200 R14: 0000150314002ae0 R15:
000014fffb8d9ef0
[11182399.994735] ---[ end trace 95abde8bce3c2d44 ]---
...
[16236452.868245] IPv4: Attempt to release TCP socket in state 10
0000000011560d2c
[16236456.869176] BUG: unable to handle kernel paging request at
00000000000ac8f7
[16236456.869661] RIP: 0010:listening_get_next.isra.36+0x5e/0xf0
[16236456.869756] Code: 45 1c 01 48 63 45 18 49 8b 55 68 48 c1 e0 04
48 85 d2 4c 8d b0 00 db 49 97 75 0b eb 41 48 8b 52 68 48 85 d2 74 38
48 83 ea 68 <48> 3b 5a 30 75 ed 41
0f b7 04 24 66 39 42 10 75 e2 48 89 d0 5b 5d
[16236456.869875] RSP: 0018:ffffba856217bdf8 EFLAGS: 00010202
[16236456.869969] RAX: 000000000000000a RBX: ffffffff96b951c0 RCX:
0000000000000000
[16236456.870065] RDX: 00000000000ac8c7 RSI: ffff938b83f294f8 RDI:
ffffffff9749dc70
[16236456.870163] RBP: ffff938f6f196b00 R08: 0000000000001000 R09:
0000000000000000
[16236456.870260] R10: 0000000000000000 R11: ffffba856217bbf0 R12:
ffffffff96bb0fc8
[16236456.870356] R13: 00000000000001b0 R14: ffffffff9749dc70 R15:
ffff938b83f29480
[16236456.871083] FS:  00007fbe9dffb700(0000)
GS:ffff938fdf9c0000(0000) knlGS:0000000000000000
[16236456.871789] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[16236456.872187] CR2: 00000000000ac8f7 CR3: 0000001195dc2002 CR4:
00000000007606e0
[16236456.872907] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[16236456.873612] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[16236456.874320] PKRU: 55555554
[16236456.874710] Call Trace:
[16236456.875110]  tcp_seq_next+0x5a/0x90
[16236456.875506]  seq_read+0x27d/0x430
[16236456.875900]  proc_reg_read+0x38/0x70
[16236456.876305]  vfs_read+0x89/0x140
[16236456.876710]  ksys_read+0x52/0xc0
[16236456.877118]  do_syscall_64+0x5b/0x1b0
[16236456.877531]  entry_SYSCALL_64_after_hwframe+0x65/0xca
[16236456.877943] RIP: 0033:0x7fbf23f85fad
[16236456.878355] Code: cf 2d 00 00 75 10 b8 00 00 00 00 0f 05 48 3d
01 f0 ff ff 73 31 c3 48 83 ec 08 e8 9e cc 01 00 48 89 04 24 b8 00 00
00 00 0f 05 <48> 8b 3c 24 48 89 c2
e8 e7 cc 01 00 48 89 d0 48 83 c4 08 48 3d 01


"RIP: 0010:listening_get_next.isra.36+0x5e/0xf0" means that sock_net(sk) is
illegal, sk is 00000000000ac8f7

static void *listening_get_next(struct seq_file *seq, void *cur)
{
                ...

sk =3D sk_next(sk);
get_sk:
sk_for_each_from(sk) {
if (!net_eq(sock_net(sk), net))
continue;
if (sk->sk_family =3D=3D afinfo->family)
return sk;
}
spin_unlock(&ilb->lock);
st->offset =3D 0;
if (++st->bucket < INET_LHTABLE_SIZE)
goto get_head;
return NULL;
}

On Mon, 13 Mar 2023 at 20:30, Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Mar 10, 2023 at 10:46=E2=80=AFPM mingkun bian <bianmingkun@gmail.=
com> wrote:
> >
> > Hi,
> >
> >     I am sorry that a newer kernel is not available to us for a period
> > of time for other reasons, this issue is still found in 4.19 of arm,
> > maybe this issue has nothing to do with kernel version, please tell me
> > if you find any patch about this issue.
> >
>
> The 'maybe' question needs to be answered by you...
>
> 4.19 is too vague.
>
> Also you mention arm, but your crash output refers to x86_64.
>
> What exact kernel version have you tried ?
>
>
> > Thanks.
> >
> > On Sat, 11 Mar 2023 at 05:38, Kuniyuki Iwashima <kuniyu@amazon.com> wro=
te:
> > >
> > > From:   mingkun bian <bianmingkun@gmail.com>
> > > Date:   Fri, 10 Mar 2023 22:51:31 +0800
> > > > Hi,
> > > >
> > > >     I am sorry to submit the same post, because the format of the
> > > > previous post is wrong.
> > > >
> > > >     I have encountered the same issue which causes loop in
> > > > __inet_lookup_established for 22 seconds, then kernel crash,
> > > > similarly, we have thousands of devices with heavy network traffic,
> > > > but only a few of them crash every day due to this reason.
> > > >
> > > >  https://lore.kernel.org/lkml/CAL+tcoDAY=3DQ5pohEPgkBTNghxTb0AhmbQD=
58dPDghyxmrcWMRQ@mail.gmail.com/T/#mb7b613de68d86c9a302ccf227292ac273cbe7f7=
c
> > > >
> > > >     Kernel version is 4.18.0, I analyzed the vmcore and find the po=
int
> > >
> > > Thanks for the report, but you should not use 4.18.0 at least, which
> > > is no longer supported.  Could you try reproducing it on the net-next
> > > tree or another stable versions listed below ?
> > >
> > > https://www.kernel.org/category/releases.html
> > >
> > > Thanks,
> > > Kuniyuki
> > >
> > >
> > > > of infinite loop is that one sock1 pointers exist in two hash
> > > > buckets(tcp_hashinfo.ehash),
> > > >
> > > >     tcp_hashinfo.ehash is as following:
> > > >     buckets0:
> > > >     buckets1:->sock1*->0x31(sock1->sk_nulls_node.next =3D 0x31, whi=
ch
> > > > means that sock1* is the end of buckets1), sock1* should not be her=
e
> > > > at buckets1,the real vmcore also has only one sock* in buckets1.
> > > >     buckets2:
> > > >     buckets3:->sock1*->0x31, sock1* is in the correct position at b=
uckets3
> > > >     buckets4:->sock2*
> > > >     ...
> > > >     buckets:N->sockn*
> > > >
> > > >     then a skb(inet_ehashfn=3D0x1) came, it matched to buckets1, an=
d the
> > > > condition validation(sk->sk_hash !=3D hash) failed, then entered
> > > > condition validation(get_nulls_value(node) !=3D slot) ,
> > > >     get_nulls_value(node) =3D 3
> > > >     slot =3D 1
> > > >     finally, go to begin, and infinite loop.
> > > >
> > > >     begin:
> > > >     sk_nulls_for_each_rcu(sk, node, &head->chain) {
> > > >     if (sk->sk_hash !=3D hash)
> > > >         continue;
> > > >     }
> > > >     ...
> > > >     if (get_nulls_value(node) !=3D slot)
> > > >         goto begin;
> > > >
> > > >    why does sock1 can exist in two hash buckets, are there some
> > > > scenarios where the sock is not deleted from the tcp_hashinfo.ehash
> > > > before sk_free?
> > > >
> > > >
> > > >   The detailed three vmcore information is as follow=EF=BC=9A
> > > >   vmcore1' info:
> > > >   1. print the skb, skb is 0xffff94824975e000 which stored in stack=
.
> > > >
> > > >    crash> p *(struct tcphdr *)(((struct
> > > > sk_buff*)0xffff94824975e000)->head + ((struct
> > > > sk_buff*)0xffff94824975e000)->transport_header)
> > > >   $4 =3D {
> > > >   source =3D 24125,
> > > >   dest =3D 47873,
> > > >   seq =3D 4005063716,
> > > >   ack_seq =3D 1814397867,
> > > >   res1 =3D 0,
> > > >   doff =3D 8,
> > > >   fin =3D 0,
> > > >   syn =3D 0,
> > > >   rst =3D 0,
> > > >   psh =3D 1,
> > > >   ack =3D 1,
> > > >   urg =3D 0,
> > > >   ece =3D 0,
> > > >   cwr =3D 0,
> > > >   window =3D 33036,
> > > >   check =3D 19975,
> > > >   urg_ptr =3D 0
> > > > }
> > > >
> > > > 2. print the sock1, tcp is in TIME_WAIT,the detailed analysis proce=
ss
> > > > is as follows:
> > > > a. R14 is 0xffffad2e0dc8a210, which is &hashinfo->ehash[slot].
> > > >
> > > > crash> p *((struct inet_ehash_bucket*)0xffffad2e0dc8a210)
> > > > $14 =3D {
> > > >   chain =3D {
> > > >     first =3D 0xffff9483ba400f48
> > > >   }
> > > > }
> > > >
> > > > b. sock* =3D 0xffff9483ba400f48 - offset(sock, sk_nulls_node) =3D 0=
xffff9483ba400ee0
> > > >
> > > > we can see sock->sk_nulls_node is:
> > > >   skc_nulls_node =3D {
> > > >         next =3D 0x4efbf,
> > > >         pprev =3D 0xffffad2e0dd2cef8
> > > >       }
> > > >
> > > > c. skb inet_ehashfn is 0x13242 which is in R15.
> > > >
> > > > sock->skc_node is 0x4efbf, then its real slot is 0x4efbf >> 1 =3D 0=
x277df
> > > > then bukets[0x277df] is (0x277df - 0x13242) * 8 + 0xffffad2e0dc8a21=
0 =3D
> > > > 0xFFFFAD2E0DD2CEF8
> > > >
> > > > d. print bukets[0x277df], find 0xffff9483ba400f48 is the same  as
> > > > bukets[0x13242]
> > > >
> > > > crash> p *((struct inet_ehash_bucket*)0xFFFFAD2E0DD2CEF8)
> > > > $32 =3D {
> > > >   chain =3D {
> > > >     first =3D 0xffff9483ba400f48
> > > >   }
> > > > }
> > > >
> > > > crash> p *((struct inet_timewait_sock*)0xffff9483ba400ee0)
> > > > $5 =3D {
> > > >   __tw_common =3D {
> > > >     {
> > > >       skc_addrpair =3D 1901830485687183552,
> > > >       {
> > > >         skc_daddr =3D 442804416,
> > > >         skc_rcv_saddr =3D 442804416
> > > >       }
> > > >     },
> > > >     {
> > > >       skc_hash =3D 2667739103,
> > > >       skc_u16hashes =3D {30687, 40706}
> > > >     },
> > > >     {
> > > >       skc_portpair =3D 3817294857,
> > > >       {
> > > >         skc_dport =3D 19465,
> > > >         skc_num =3D 58247
> > > >       }
> > > >     },
> > > >     skc_family =3D 2,
> > > >     skc_state =3D 6 '\006',
> > > >     skc_reuse =3D 0 '\000',
> > > >     skc_reuseport =3D 0 '\000',
> > > >     skc_ipv6only =3D 0 '\000',
> > > >     skc_net_refcnt =3D 0 '\000',
> > > >     skc_bound_dev_if =3D 0,
> > > >     {
> > > >       skc_bind_node =3D {
> > > >         next =3D 0x0,
> > > >         pprev =3D 0xffff9492a8950538
> > > >       },
> > > >       skc_portaddr_node =3D {
> > > >         next =3D 0x0,
> > > >         pprev =3D 0xffff9492a8950538
> > > >       }
> > > >     },
> > > >     skc_prot =3D 0xffffffff9b9a9840,
> > > >     skc_net =3D {
> > > >       net =3D 0xffffffff9b9951c0
> > > >     },
> > > >     skc_v6_daddr =3D {
> > > >       in6_u =3D {
> > > >         u6_addr8 =3D
> > > > "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
> > > >         u6_addr16 =3D {0, 0, 0, 0, 0, 0, 0, 0},
> > > >         u6_addr32 =3D {0, 0, 0, 0}
> > > >       }
> > > >     },
> > > >     skc_v6_rcv_saddr =3D {
> > > >       in6_u =3D {
> > > >         u6_addr8 =3D
> > > > "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
> > > >         u6_addr16 =3D {0, 0, 0, 0, 0, 0, 0, 0},
> > > >         u6_addr32 =3D {0, 0, 0, 0}
> > > >       }
> > > >     },
> > > >     skc_cookie =3D {
> > > >       counter =3D 0
> > > >     },
> > > >     {
> > > >       skc_flags =3D 18446744072025102208,
> > > >       skc_listener =3D 0xffffffff9b995780,
> > > >       skc_tw_dr =3D 0xffffffff9b995780
> > > >     },
> > > >     skc_dontcopy_begin =3D 0xffff9483ba400f48,
> > > >     {
> > > >       skc_node =3D {
> > > >         next =3D 0x4efbf,
> > > >         pprev =3D 0xffffad2e0dd2cef8
> > > >       },
> > > >       skc_nulls_node =3D {
> > > >         next =3D 0x4efbf,
> > > >         pprev =3D 0xffffad2e0dd2cef8
> > > >       }
> > > >     },
> > > >     skc_tx_queue_mapping =3D 0,
> > > >     skc_rx_queue_mapping =3D 0,
> > > >     {
> > > >       skc_incoming_cpu =3D -1680142171,
> > > >       skc_rcv_wnd =3D 2614825125,
> > > >       skc_tw_rcv_nxt =3D 2614825125
> > > >     },
> > > >     skc_refcnt =3D {
> > > >       refs =3D {
> > > >         counter =3D 3
> > > >       }
> > > >     },
> > > >     skc_dontcopy_end =3D 0xffff9483ba400f64,
> > > >     {
> > > >       skc_rxhash =3D 320497927,
> > > >       skc_window_clamp =3D 320497927,
> > > >       skc_tw_snd_nxt =3D 320497927
> > > >     }
> > > >   },
> > > >   tw_mark =3D 0,
> > > >   tw_substate =3D 6 '\006',
> > > >   tw_rcv_wscale =3D 10 '\n',
> > > >   tw_sport =3D 34787,
> > > >   tw_kill =3D 0,
> > > >   tw_transparent =3D 0,
> > > >   tw_flowlabel =3D 0,
> > > >   tw_pad =3D 0,
> > > >   tw_tos =3D 0,
> > > >   tw_timer =3D {
> > > >     entry =3D {
> > > >       next =3D 0xffff9483ba401d48,
> > > >       pprev =3D 0xffff9481680177f8
> > > >     },
> > > >     expires =3D 52552264960,
> > > >     function =3D 0xffffffff9ad67ba0,
> > > >     flags =3D 1339031587,
> > > >     rh_reserved1 =3D 0,
> > > >     rh_reserved2 =3D 0,
> > > >     rh_reserved3 =3D 0,
> > > >     rh_reserved4 =3D 0
> > > >   },
> > > >   tw_tb =3D 0xffff9492a8950500
> > > > }
> > > > 3.call stack
> > > > [48256841.222682]  panic+0xe8/0x25c
> > > > [48256841.222766]  ? secondary_startup_64+0xb6/0xc0
> > > > [48256841.222853]  watchdog_timer_fn+0x209/0x210
> > > > [48256841.222939]  ? watchdog+0x30/0x30
> > > > [48256841.223027]  __hrtimer_run_queues+0xe5/0x260
> > > > [48256841.223117]  hrtimer_interrupt+0x122/0x270
> > > > [48256841.223209]  ? sched_clock+0x5/0x10
> > > > [48256841.223296]  smp_apic_timer_interrupt+0x6a/0x140
> > > > [48256841.223384]  apic_timer_interrupt+0xf/0x20
> > > > [48256841.223471] RIP: 0010:__inet_lookup_established+0xe9/0x170
> > > > [48256841.223562] Code: f6 74 33 44 3b 62 a4 75 3d 48 3b 6a 98 75 3=
7
> > > > 8b 42 ac 85 c0 75 24 4c 3b 6a c8 75 2a 5b 5d 41 5c 41 5d 41 5e 48 8=
9
> > > > f8 41 5f c3 <48> d1 ea 49 39 d7 0f 85 5a ff ff ff 31 ff eb e2 39 44=
 24
> > > > 38 74 d6
> > > > [48256841.224242] RSP: 0018:ffff9497e0e83bf8 EFLAGS: 00000202
> > > > ORIG_RAX: ffffffffffffff13
> > > > [48256841.224904] RAX: ffffad2e0dbf1000 RBX: 0000000088993242 RCX:
> > > > 0000000034d20a82
> > > > [48256841.225576] RDX: 000000000004efbf RSI: 00000000527c6da0 RDI:
> > > > 0000000000000000
> > > > [48256841.226268] RBP: 1e31b4763470e11b R08: 0000000001bb5e3d R09:
> > > > 00000000000001bb
> > > > [48256841.226969] R10: 0000000000005429 R11: 0000000000000000 R12:
> > > > 0000000001bb5e3d
> > > > [48256841.227646] R13: ffffffff9b9951c0 R14: ffffad2e0dc8a210 R15:
> > > > 0000000000013242
> > > > [48256841.228330]  ? apic_timer_interrupt+0xa/0x20
> > > > [48256841.228714]  ? __inet_lookup_established+0x3f/0x170
> > > > [48256841.229097]  tcp_v4_early_demux+0xb0/0x170
> > > > [48256841.229487]  ip_rcv_finish+0x17c/0x430
> > > > [48256841.229865]  ip_rcv+0x27c/0x380
> > > > [48256841.230242]  __netif_receive_skb_core+0x9e9/0xac0
> > > > [48256841.230623]  ? inet_gro_receive+0x21b/0x2d0
> > > > [48256841.230999]  ? recalibrate_cpu_khz+0x10/0x10
> > > > [48256841.231378]  netif_receive_skb_internal+0x42/0xf0
> > > > [48256841.231777]  napi_gro_receive+0xbf/0xe0
> > > >
> > > >
> > > > vmcore2' info:
> > > >  1. print the skb
> > > > crash> p *(struct tcphdr *)(((struct
> > > > sk_buff*)0xffff9d60c008b500)->head + ((struct
> > > > sk_buff*)0xffff9d60c008b500)->transport_header)
> > > > $28 =3D {
> > > >   source =3D 35911,
> > > >   dest =3D 20480,
> > > >   seq =3D 1534560442,
> > > >   ack_seq =3D 0,
> > > >   res1 =3D 0,
> > > >   doff =3D 10,
> > > >   fin =3D 0,
> > > >   syn =3D 1,
> > > >   rst =3D 0,
> > > >   psh =3D 0,
> > > >   ack =3D 0,
> > > >   urg =3D 0,
> > > >   ece =3D 0,
> > > >   cwr =3D 0,
> > > >   window =3D 65535,
> > > >   check =3D 56947,
> > > >   urg_ptr =3D 0
> > > > }
> > > > 2. print the sock1, tcp is in TIME_WAIT, but the sock is ipv4, I do
> > > > not know why skc_v6_daddr and rh_reserved is not zero, maybe memory
> > > > out of bounds?
> > > > crash> p *((struct inet_timewait_sock*)0xFFFF9D6F1997D540)
> > > > $29 =3D {
> > > >   __tw_common =3D {
> > > >     {
> > > >       skc_addrpair =3D 388621010873919680,
> > > >       {
> > > >         skc_daddr =3D 426027200,
> > > >         skc_rcv_saddr =3D 90482880
> > > >       }
> > > >     },
> > > >     {
> > > >       skc_hash =3D 884720419,
> > > >       skc_u16hashes =3D {49955, 13499}
> > > >     },
> > > >     {
> > > >       skc_portpair =3D 156018620,
> > > >       {
> > > >         skc_dport =3D 42940,
> > > >         skc_num =3D 2380
> > > >       }
> > > >     },
> > > >     skc_family =3D 2,
> > > >     skc_state =3D 6 '\006',
> > > >     skc_reuse =3D 1 '\001',
> > > >     skc_reuseport =3D 0 '\000',
> > > >     skc_ipv6only =3D 0 '\000',
> > > >     skc_net_refcnt =3D 0 '\000',
> > > >     skc_bound_dev_if =3D 0,
> > > >     {
> > > >       skc_bind_node =3D {
> > > >         next =3D 0xffff9d8993851448,
> > > >         pprev =3D 0xffff9d89c3510458
> > > >       },
> > > >       skc_portaddr_node =3D {
> > > >         next =3D 0xffff9d8993851448,
> > > >         pprev =3D 0xffff9d89c3510458
> > > >       }
> > > >     },
> > > >     skc_prot =3D 0xffffffff9c7a9840,
> > > >     skc_net =3D {
> > > >       net =3D 0xffffffff9c7951c0
> > > >     },
> > > >     skc_v6_daddr =3D {
> > > >       in6_u =3D {
> > > >         u6_addr8 =3D "$P=EE=A4=86\325\001\354M\213D\021p\323\337\n"=
,
> > > >         u6_addr16 =3D {20516, 42222, 54662, 60417, 35661, 4420, 541=
28, 2783},
> > > >         u6_addr32 =3D {2767081508, 3959543174, 289704781, 182440816=
}
> > > >       }
> > > >     },
> > > >     skc_v6_rcv_saddr =3D {
> > > >       in6_u =3D {
> > > >         u6_addr8 =3D "=CB=B2\231=C2=AA\212*pzf\212\277\325\065=D8=
=84",
> > > >         u6_addr16 =3D {45771, 49817, 35498, 28714, 26234, 49034, 13=
781, 34008},
> > > >         u6_addr32 =3D {3264852683, 1881836202, 3213518458, 22287620=
69}
> > > >       }
> > > >     },
> > > >     skc_cookie =3D {
> > > >       counter =3D 0
> > > >     },
> > > >     {
> > > >       skc_flags =3D 18446744072039782272,
> > > >       skc_listener =3D 0xffffffff9c795780,
> > > >       skc_tw_dr =3D 0xffffffff9c795780
> > > >     },
> > > >     skc_dontcopy_begin =3D 0xffff9d6f1997d5a8,
> > > >     {
> > > >       skc_node =3D {
> > > >         next =3D 0x78647,
> > > >         pprev =3D 0xffffb341cddea918
> > > >       },
> > > >       skc_nulls_node =3D {
> > > >         next =3D 0x78647,
> > > >         pprev =3D 0xffffb341cddea918
> > > >       }
> > > >     },
> > > >     skc_tx_queue_mapping =3D 51317,
> > > >     skc_rx_queue_mapping =3D 9071,
> > > >     {
> > > >       skc_incoming_cpu =3D -720721118,
> > > >       skc_rcv_wnd =3D 3574246178,
> > > >       skc_tw_rcv_nxt =3D 3574246178
> > > >     },
> > > >     skc_refcnt =3D {
> > > >       refs =3D {
> > > >         counter =3D 3
> > > >       }
> > > >     },
> > > >     skc_dontcopy_end =3D 0xffff9d6f1997d5c4,
> > > >     {
> > > >       skc_rxhash =3D 2663156681,
> > > >       skc_window_clamp =3D 2663156681,
> > > >       skc_tw_snd_nxt =3D 2663156681
> > > >     }
> > > >   },
> > > >   tw_mark =3D 0,
> > > >   tw_substate =3D 6 '\006',
> > > >   tw_rcv_wscale =3D 10 '\n',
> > > >   tw_sport =3D 19465,
> > > >   tw_kill =3D 0,
> > > >   tw_transparent =3D 0,
> > > >   tw_flowlabel =3D 201048,
> > > >   tw_pad =3D 1,
> > > >   tw_tos =3D 0,
> > > >   tw_timer =3D {
> > > >     entry =3D {
> > > >       next =3D 0xffff9d6f1997d4c8,
> > > >       pprev =3D 0xffff9d6f1997c6f8
> > > >     },
> > > >     expires =3D 52813074277,
> > > >     function =3D 0xffffffff9bb67ba0,
> > > >     flags =3D 1313865770,
> > > >     rh_reserved1 =3D 14775289730400096190,
> > > >     rh_reserved2 =3D 10703603942626563734,
> > > >     rh_reserved3 =3D 17306812468345150807,
> > > >     rh_reserved4 =3D 9531906593543422642
> > > >   },
> > > >   tw_tb =3D 0xffff9d897232a500
> > > > }
> > > >
> > > > vmcore3' info:
> > > > 1. print the skbcrash> p *(struct tcphdr *)(((struct
> > > > sk_buff*)0xffffa039e93aaf00)->head + ((struct
> > > > sk_buff*)0xffffa039e93aaf00)->transport_header)
> > > > $6 =3D {
> > > >   source =3D 9269,
> > > >   dest =3D 47873,
> > > >   seq =3D 147768854,
> > > >   ack_seq =3D 1282978926,
> > > >   res1 =3D 0,
> > > >   doff =3D 5,
> > > >   fin =3D 0,
> > > >   syn =3D 0,
> > > >   rst =3D 0,
> > > >   psh =3D 0,
> > > >   ack =3D 1,
> > > >   urg =3D 0,
> > > >   ece =3D 0,
> > > >   cwr =3D 0,
> > > >   window =3D 47146,
> > > >   check =3D 55446,
> > > >   urg_ptr =3D 0
> > > > }
> > > > 2. print the sock1, tcp is in TIME_WAIT
> > > > crash> p *((struct inet_timewait_sock*)0xFFFFA0444BAADBA0)
> > > > $7 =3D {
> > > >   __tw_common =3D {
> > > >     {
> > > >       skc_addrpair =3D 2262118455826491584,
> > > >       {
> > > >         skc_daddr =3D 392472768,
> > > >         skc_rcv_saddr =3D 526690496
> > > >       }
> > > >     },
> > > >     {
> > > >       skc_hash =3D 382525308,
> > > >       skc_u16hashes =3D {57212, 5836}
> > > >     },
> > > >     {
> > > >       skc_portpair =3D 1169509385,
> > > >       {
> > > >         skc_dport =3D 19465,
> > > >         skc_num =3D 17845
> > > >       }
> > > >     },
> > > >     skc_family =3D 2,
> > > >     skc_state =3D 6 '\006',
> > > >     skc_reuse =3D 0 '\000',
> > > >     skc_reuseport =3D 0 '\000',
> > > >     skc_ipv6only =3D 0 '\000',
> > > >     skc_net_refcnt =3D 0 '\000',
> > > >     skc_bound_dev_if =3D 0,
> > > >     {
> > > >       skc_bind_node =3D {
> > > >         next =3D 0x0,
> > > >         pprev =3D 0xffffa0528fefba98
> > > >       },
> > > >       skc_portaddr_node =3D {
> > > >         next =3D 0x0,
> > > >         pprev =3D 0xffffa0528fefba98
> > > >       }
> > > >     },
> > > >     skc_prot =3D 0xffffffffa33a9840,
> > > >     skc_net =3D {
> > > >       net =3D 0xffffffffa33951c0
> > > >     },
> > > >     skc_v6_daddr =3D {
> > > >       in6_u =3D {
> > > >         u6_addr8 =3D
> > > > "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
> > > >         u6_addr16 =3D {0, 0, 0, 0, 0, 0, 0, 0},
> > > >         u6_addr32 =3D {0, 0, 0, 0}
> > > >       }
> > > >     },
> > > >     skc_v6_rcv_saddr =3D {
> > > >       in6_u =3D {
> > > >         u6_addr8 =3D
> > > > "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
> > > >         u6_addr16 =3D {0, 0, 0, 0, 0, 0, 0, 0},
> > > >         u6_addr32 =3D {0, 0, 0, 0}
> > > >       }
> > > >     },
> > > >     skc_cookie =3D {
> > > >       counter =3D 20818915981
> > > >     },
> > > >     {
> > > >       skc_flags =3D 18446744072153028480,
> > > >       skc_listener =3D 0xffffffffa3395780,
> > > >       skc_tw_dr =3D 0xffffffffa3395780
> > > >     },
> > > >     skc_dontcopy_begin =3D 0xffffa0444baadc08,
> > > >     {
> > > >       skc_node =3D {
> > > >         next =3D 0x9bef9,
> > > >         pprev =3D 0xffffb36fcde60be0
> > > >       },
> > > >       skc_nulls_node =3D {
> > > >         next =3D 0x9bef9,
> > > >         pprev =3D 0xffffb36fcde60be0
> > > >       }
> > > >     },
> > > >     skc_tx_queue_mapping =3D 0,
> > > >     skc_rx_queue_mapping =3D 0,
> > > >     {
> > > >       skc_incoming_cpu =3D -2041214926,
> > > >       skc_rcv_wnd =3D 2253752370,
> > > >       skc_tw_rcv_nxt =3D 2253752370
> > > >     },
> > > >     skc_refcnt =3D {
> > > >       refs =3D {
> > > >         counter =3D 3
> > > >       }
> > > >     },
> > > >     skc_dontcopy_end =3D 0xffffa0444baadc24,
> > > >     {
> > > >       skc_rxhash =3D 653578381,
> > > >       skc_window_clamp =3D 653578381,
> > > >       skc_tw_snd_nxt =3D 653578381
> > > >     }
> > > >   },
> > > >   tw_mark =3D 0,
> > > >   tw_substate =3D 6 '\006',
> > > >   tw_rcv_wscale =3D 10 '\n',
> > > >   tw_sport =3D 46405,
> > > >   tw_kill =3D 0,
> > > >   tw_transparent =3D 0,
> > > >   tw_flowlabel =3D 0,
> > > >   tw_pad =3D 0,
> > > >   tw_tos =3D 0,
> > > >   tw_timer =3D {
> > > >     entry =3D {
> > > >       next =3D 0xffffa0444baac808,
> > > >       pprev =3D 0xffffa0388b5477f8
> > > >     },
> > > >     expires =3D 33384532933,
> > > >     function =3D 0xffffffffa2767ba0,
> > > >     flags =3D 1313865761,
> > > >     rh_reserved1 =3D 0,
> > > >     rh_reserved2 =3D 0,
> > > >     rh_reserved3 =3D 0,
> > > >     rh_reserved4 =3D 0
> > > >   },
> > > >   tw_tb =3D 0xffffa05cc8322d40
> > > > }
