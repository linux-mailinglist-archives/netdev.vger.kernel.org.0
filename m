Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD206E15A3
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 22:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjDMUGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 16:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjDMUGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 16:06:52 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B2398A4D;
        Thu, 13 Apr 2023 13:06:50 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id y6so15084399plp.2;
        Thu, 13 Apr 2023 13:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681416410; x=1684008410;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nBcrNL0x26L/Qu5KMY8TTdN3XgtdEwaO/iwEU5Rq3rs=;
        b=I/QgqeR2HrdVntMtPG8voTIBo4KdpSjxaadnMuToXyHRo4GZezQt3BstmQx8wBKBoW
         kt5p+XpwtExNpw01nkonGDpdpLXT+WUqpozLWkCFhoDlDpdL9KfjIYMUTHKgaadOqVJG
         s1+gDFopMHp9oH9Rn/Tt3hztUEddmtOFCdQ1ot6K6+ErcHG4KSE8IEGptXqvSov4k1kN
         e5vieK9iltlDwlAt2amkOlwd18uuq6Blq//FYKH0Y9LQnprP3odO/u6TCWeH1FCUy/WJ
         wljoRdT/x/kYki5xyF2LNEjd+9YLJ1A4aO0hRoxFlc9lcgFIID6990kDiIriI2zPCcrJ
         s6gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681416410; x=1684008410;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nBcrNL0x26L/Qu5KMY8TTdN3XgtdEwaO/iwEU5Rq3rs=;
        b=J/J9XHZmX4eAF64LX9RnPa0cvOkepEi5Kd9Ewvp9Opy4WGngAEOiU6R0rRVH22k+9n
         R34zAt17mNw+i3DASS4UU8VcCG3kyXn81eWVTtlfA14Sh++YrgR3RW6GGheef0sRE+zf
         X7g9M8N3XKjWxfSfaYMVIStyMqcfRCuZ0VZUOe0ylUg2JpDpkJO6t9Pyh9FmdOmASEzZ
         dEU1yLQx4A39aInbgEnBBNVl/ID1r4DtcFas+3lIDWIm7VbrJRI63vWDKbO09EbK0wT0
         ODbWrEHC3rNszP7fZF0JGI0H31Lmc12DSBRxAFaU156DTcU5foKr27pvVvWR1kumlvhM
         ErZA==
X-Gm-Message-State: AAQBX9f/sCPA9Nl+ddHX8bdFSMwpg0Wj1JF8gwoTOU6eA068QGa+cVVn
        w2G6eZg08Te3OuwetbPW/FE=
X-Google-Smtp-Source: AKy350YEIHFQ+36voeFfiuYRzz/AR+jrEbnFej7UmBu6L/F1dfas4hU1ONF1WenKUKcjSrFD4/JV8w==
X-Received: by 2002:a05:6a20:a60b:b0:d8:cb1a:f4e5 with SMTP id bb11-20020a056a20a60b00b000d8cb1af4e5mr2730466pzb.23.1681416409496;
        Thu, 13 Apr 2023 13:06:49 -0700 (PDT)
Received: from localhost ([98.97.116.12])
        by smtp.gmail.com with ESMTPSA id j2-20020aa78002000000b0062ddefe02dfsm1801048pfi.171.2023.04.13.13.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 13:06:48 -0700 (PDT)
Date:   Thu, 13 Apr 2023 13:06:45 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@isovalent.com>,
        Eric Dumazet <edumazet@google.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, will@isovalent.com
Message-ID: <643860d554e5f_496ba2085d@john.notmuch>
In-Reply-To: <CAADnVQ+43oW3F3_R2cz76ivfeJNDt6Nf66jOdXADjsp=jJZxgQ@mail.gmail.com>
References: <20230407171654.107311-1-john.fastabend@gmail.com>
 <20230407171654.107311-4-john.fastabend@gmail.com>
 <CAADnVQ+43oW3F3_R2cz76ivfeJNDt6Nf66jOdXADjsp=jJZxgQ@mail.gmail.com>
Subject: Re: [PATCH bpf v6 03/12] bpf: sockmap, improved check for empty queue
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
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

Alexei Starovoitov wrote:
> On Fri, Apr 7, 2023 at 10:17=E2=80=AFAM John Fastabend <john.fastabend@=
gmail.com> wrote:
> >
> > We noticed some rare sk_buffs were stepping past the queue when syste=
m was
> > under memory pressure. The general theory is to skip enqueueing
> > sk_buffs when its not necessary which is the normal case with a syste=
m
> > that is properly provisioned for the task, no memory pressure and eno=
ugh
> > cpu assigned.
> >
> > But, if we can't allocate memory due to an ENOMEM error when enqueuei=
ng
> > the sk_buff into the sockmap receive queue we push it onto a delayed
> > workqueue to retry later. When a new sk_buff is received we then chec=
k
> > if that queue is empty. However, there is a problem with simply check=
ing
> > the queue length. When a sk_buff is being processed from the ingress =
queue
> > but not yet on the sockmap msg receive queue its possible to also rec=
v
> > a sk_buff through normal path. It will check the ingress queue which =
is
> > zero and then skip ahead of the pkt being processed.
> >
> > Previously we used sock lock from both contexts which made the proble=
m
> > harder to hit, but not impossible.
> >
> > To fix also check the 'state' variable where we would cache partially=

> > processed sk_buff. This catches the majority of cases. But, we also
> > need to use the mutex lock around this check because we can't have bo=
th
> > codes running and check sensibly. We could perhaps do this with atomi=
c
> > bit checks, but we are already here due to memory pressure so slowing=

> > things down a bit seems OK and simpler to just grab a lock.
> >
> > To reproduce issue we run NGINX compliance test with sockmap running =
and
> > observe some flakes in our testing that we attributed to this issue.
> >
> > Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
> > Tested-by: William Findlay <will@isovalent.com>
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >  net/core/skmsg.c | 20 +++++++++++++++++++-
> >  1 file changed, 19 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > index 198bed303c51..f8731818b5c3 100644
> > --- a/net/core/skmsg.c
> > +++ b/net/core/skmsg.c
> > @@ -987,6 +987,7 @@ EXPORT_SYMBOL_GPL(sk_psock_tls_strp_read);
> >  static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_=
buff *skb,
> >                                   int verdict)
> >  {
> > +       struct sk_psock_work_state *state;
> >         struct sock *sk_other;
> >         int err =3D 0;
> >         u32 len, off;
> > @@ -1003,13 +1004,28 @@ static int sk_psock_verdict_apply(struct sk_p=
sock *psock, struct sk_buff *skb,
> >
> >                 skb_bpf_set_ingress(skb);
> >
> > +               /* We need to grab mutex here because in-flight skb i=
s in one of
> > +                * the following states: either on ingress_skb, in ps=
ock->state
> > +                * or being processed by backlog and neither in state=
->skb and
> > +                * ingress_skb may be also empty. The troublesome cas=
e is when
> > +                * the skb has been dequeued from ingress_skb list or=
 taken from
> > +                * state->skb because we can not easily test this cas=
e. Maybe we
> > +                * could be clever with flags and resolve this but be=
ing clever
> > +                * got us here in the first place and we note this is=
 done under
> > +                * sock lock and backlog conditions mean we are alrea=
dy running
> > +                * into ENOMEM or other performance hindering cases s=
o lets do
> > +                * the obvious thing and grab the mutex.
> > +                */
> > +               mutex_lock(&psock->work_mutex);
> > +               state =3D &psock->work_state;
> =

> This splat says that above is wrong:
> =

> [   98.732763] BUG: sleeping function called from invalid context at
> kernel/locking/mutex.c:580
> [   98.733483] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid:
> 370, name: test_progs
> [   98.734103] preempt_count: 102, expected: 0
> [   98.734416] RCU nest depth: 4, expected: 0
> [   98.734739] 6 locks held by test_progs/370:
> [   98.735046]  #0: ffff888106475530 (sk_lock-AF_INET){+.+.}-{0:0},
> at: inet_shutdown+0x43/0x150
> [   98.735695]  #1: ffffffff84250ba0 (rcu_read_lock){....}-{1:2}, at:
> __ip_queue_xmit+0x5/0xa00
> [   98.736325]  #2: ffffffff84250ba0 (rcu_read_lock){....}-{1:2}, at:
> process_backlog+0xc0/0x360
> [   98.736971]  #3: ffffffff84250ba0 (rcu_read_lock){....}-{1:2}, at:
> ip_local_deliver_finish+0xbb/0x220
> [   98.737668]  #4: ffff8881064748b0 (slock-AF_INET/1){+.-.}-{2:2},
> at: tcp_v4_rcv+0x1b72/0x1d80
> [   98.738297]  #5: ffffffff84250ba0 (rcu_read_lock){....}-{1:2}, at:
> sk_psock_verdict_recv+0x5/0x3a0
> [   98.738973] Preemption disabled at:
> [   98.738976] [<ffffffff8238bb41>] ip_finish_output2+0x171/0xfa0
> [   98.739687] CPU: 1 PID: 370 Comm: test_progs Tainted: G           O
>       6.3.0-rc5-00193-g9149a3b041d2 #942
> [   98.740379] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> [   98.741164] Call Trace:
> [   98.741338]  <IRQ>
> [   98.741483]  dump_stack_lvl+0x60/0x70
> [   98.741735]  __might_resched+0x21c/0x340
> [   98.742005]  __mutex_lock+0xb4/0x12a0
> [   98.743721]  ? mutex_lock_io_nested+0x1070/0x1070
> [   98.744053]  ? lock_is_held_type+0xda/0x130
> [   98.744337]  ? preempt_count_sub+0x14/0xc0
> [   98.744624]  ? sk_psock_verdict_apply+0x1a3/0x2f0
> [   98.744936]  sk_psock_verdict_apply+0x1a3/0x2f0
> [   98.745242]  ? preempt_count_sub+0x14/0xc0
> [   98.745530]  sk_psock_verdict_recv+0x1e7/0x3a0
> [   98.745858]  ? preempt_count_sub+0x14/0xc0
> [   98.746168]  tcp_read_skb+0x19c/0x2d0
> [   98.746447]  ? sk_psock_strp_read+0x390/0x390
> [   98.746774]  ? tcp_alloc_md5sig_pool+0x230/0x230
> [   98.747116]  ? rcu_read_lock_held+0x91/0xa0
> [   98.747427]  ? rcu_read_lock_sched_held+0xc0/0xc0
> [   98.747772]  ? __rcu_read_unlock+0x6b/0x2a0
> [   98.748087]  sk_psock_verdict_data_ready+0x99/0x2d0
> [   98.748446]  tcp_data_queue+0xd39/0x19b0
> [   98.748749]  ? tcp_send_rcvq+0x280/0x280
> [   98.749038]  ? tcp_urg+0x7f/0x4c0
> [   98.749298]  ? tcp_ack_update_rtt.isra.55+0x910/0x910
> [   98.749644]  ? lockdep_hardirqs_on+0x79/0x100
> [   98.749940]  ? ktime_get+0x112/0x120
> [   98.750225]  ? ktime_get+0x86/0x120
> [   98.750498]  tcp_rcv_established+0x3fb/0xcc0
> [   98.752087]  tcp_v4_do_rcv+0x34a/0x4c0
> [   98.752400]  tcp_v4_rcv+0x1c9a/0x1d80
> [   98.754137]  ip_protocol_deliver_rcu+0x4f/0x4d0
> [   98.754562]  ip_local_deliver_finish+0x146/0x220
> [   98.754928]  ip_local_deliver+0x100/0x2e0
> [   98.756055]  ip_rcv+0xb6/0x2b0
> [   98.757689]  __netif_receive_skb_one_core+0xd2/0x110
> [   98.759121]  process_backlog+0x160/0x360
> [   98.759446]  __napi_poll+0x57/0x300
> [   98.759725]  net_rx_action+0x555/0x600
> [   98.760029]  ? napi_threaded_poll+0x2b0/0x2b0
> [   98.760444]  __do_softirq+0xeb/0x4e7
> [   98.760728]  ? ip_finish_output2+0x391/0xfa0
> [   98.761059]  do_softirq+0xa1/0xd0
> =

> I'm afraid I have to revert this set from bpf tree.

OK thanks. We also got a syzkaller complaint so will fix these two things=
.=
