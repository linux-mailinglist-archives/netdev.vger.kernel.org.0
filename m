Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 372D16B87E8
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 02:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjCNB5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 21:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjCNB5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 21:57:17 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174FF83151;
        Mon, 13 Mar 2023 18:57:12 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id eh3so268378edb.11;
        Mon, 13 Mar 2023 18:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678759030;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2R5dLWskw4zGJffn3hlu9SO470LjxuFORReTwwt/MFA=;
        b=Akq1bwzHjrs41/v3r36zOY/3USAF3Gfa9Npfrk5o18l7XV+6qnExXIKa5QV01Z1RKy
         JjEQD+tzMSQ2qquc9i0LzF8ScVfQ27KWZ8XiimENodBfWM5LvthRJ8a7cW/YpPJumDv4
         GfehL3Cl8AdT1VGnRXbK/E1wzUPzaqxkRGe0PoLb/oqSOl3GWPgSlFy/MUTlFFZhqACp
         tgK/87ORBvdW8G7o5cuUdq4hWqsvbCx3xfmWqGMty09gIF3kIMWMNAZBxbrWTU7t4Xci
         xMcla5SCLngMrVaiHHTpXGJ2cczsfYcCGUQ7LqY5vXMfkIWUk2lWY+PaiIZKoQP0wkHN
         A8Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678759030;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2R5dLWskw4zGJffn3hlu9SO470LjxuFORReTwwt/MFA=;
        b=XBkeeW7CfHBiF5UMG0lT2W+h+OlawSh1kuIaOfekx4rYe4UJMkSvk+ebwsU/WMYjjS
         YrAVLvAWCwVB62ClI8mOFrGivXmK+Mo/ri0NeGs0B9/y/MpwV4c4gCGdKcNOuBV0Pwpf
         bIwzt7Op3Gi3xQfu8Y3IuVZGmdfUO7fzVfEbkQQr+FYsKo+bgIleMc8B7xgR1oInLRc0
         OgiEIcx00PseF6MVkr3x5ewE8vMiYZF17Z3Zz/nCdjf/QgdrQ76KndJvky4yyxIxbLuG
         dmeg9y/WTB4XMW6TpDAljHJhQcdwffU7C1haBUke6n9EKFmCJbeu6d8tcuoqAZ/6xuzZ
         twSg==
X-Gm-Message-State: AO0yUKWqVLyPqMjqtpO4YsIqYeB3r8JslKqggKq+VboS0ZbNkggQhAtN
        cjK/zTZiF/Y/6OZDSqYQ5Ks76XztVIQgFnA4x0M=
X-Google-Smtp-Source: AK7set/mCNnmILf+U7d2XNAcigukVducIDe8fPHpmWNLX1v45Ea9pHbBicrbn/HFFLN0m6maf0hwCMqDQLHz7/BR5PI=
X-Received: by 2002:a17:906:58c6:b0:877:747f:f6e5 with SMTP id
 e6-20020a17090658c600b00877747ff6e5mr276558ejs.11.1678759030128; Mon, 13 Mar
 2023 18:57:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230311163614.92296-1-kerneljasonxing@gmail.com>
 <CAL+tcoAwodpnE2NjMLPhBbmHUvmKMgSykqx0EQ4YZaQHjrx0Hw@mail.gmail.com> <ZA+CbyVQxsKQ4BLp@corigine.com>
In-Reply-To: <ZA+CbyVQxsKQ4BLp@corigine.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 14 Mar 2023 09:56:33 +0800
Message-ID: <CAL+tcoDpNx4p8zgo_ZeqGAmVLJkMnTt9O7uidcCc9aC70ngrFg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: introduce budget_squeeze to help us tune rx behavior
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, kuniyu@amazon.com,
        liuhangbin@gmail.com, xiangxia.m.yue@gmail.com, jiri@nvidia.com,
        andy.ren@getcruise.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 4:07=E2=80=AFAM Simon Horman <simon.horman@corigine=
.com> wrote:
>
> On Mon, Mar 13, 2023 at 10:05:18AM +0800, Jason Xing wrote:
> > On Sun, Mar 12, 2023 at 12:36=E2=80=AFAM Jason Xing <kerneljasonxing@gm=
ail.com> wrote:
> > >
> > > From: Jason Xing <kernelxing@tencent.com>
> > >
> > > When we encounter some performance issue and then get lost on how
> > > to tune the budget limit and time limit in net_rx_action() function,
> > > we can separately counting both of them to avoid the confusion.
> > >
> > > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > > ---
> > > note: this commit is based on the link as below:
> > > https://lore.kernel.org/lkml/20230311151756.83302-1-kerneljasonxing@g=
mail.com/
> > > ---
> > >  include/linux/netdevice.h |  1 +
> > >  net/core/dev.c            | 12 ++++++++----
> > >  net/core/net-procfs.c     |  9 ++++++---
> > >  3 files changed, 15 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > > index 6a14b7b11766..5736311a2133 100644
> > > --- a/include/linux/netdevice.h
> > > +++ b/include/linux/netdevice.h
> > > @@ -3157,6 +3157,7 @@ struct softnet_data {
> > >         /* stats */
> > >         unsigned int            processed;
> > >         unsigned int            time_squeeze;
> > > +       unsigned int            budget_squeeze;
> > >  #ifdef CONFIG_RPS
> > >         struct softnet_data     *rps_ipi_list;
> > >  #endif
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index 253584777101..bed7a68fdb5d 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -6637,6 +6637,7 @@ static __latent_entropy void net_rx_action(stru=
ct softirq_action *h)
> > >         unsigned long time_limit =3D jiffies +
> > >                 usecs_to_jiffies(READ_ONCE(netdev_budget_usecs));
> > >         int budget =3D READ_ONCE(netdev_budget);
> > > +       bool is_continue =3D true;
> >
> > I kept thinking during these days, I think it looks not that concise
> > and elegant and also the name is not that good though the function can
> > work.
> >
> > In the next submission, I'm going to choose to use 'while()' instead
> > of 'for()' suggested by Stephen.
> >
> > Does anyone else have some advice about this?
>
> What about:
>
>         int done =3D false
>
>         while (!done) {
>                 ...
>         }
>
> Or:
>
>         for (;;) {
>                 int done =3D false;
>
>                 ...
>                 if (done)
>                         break;
>         }
>

Great, that looks much better:)

Thanks,
Jason

> >
> > Thanks,
> > Jason
> >
> > >         LIST_HEAD(list);
> > >         LIST_HEAD(repoll);
> > >
> > > @@ -6644,7 +6645,7 @@ static __latent_entropy void net_rx_action(stru=
ct softirq_action *h)
> > >         list_splice_init(&sd->poll_list, &list);
> > >         local_irq_enable();
> > >
> > > -       for (;;) {
> > > +       for (; is_continue;) {
> > >                 struct napi_struct *n;
> > >
> > >                 skb_defer_free_flush(sd);
> > > @@ -6662,10 +6663,13 @@ static __latent_entropy void net_rx_action(st=
ruct softirq_action *h)
> > >                  * Allow this to run for 2 jiffies since which will a=
llow
> > >                  * an average latency of 1.5/HZ.
> > >                  */
> > > -               if (unlikely(budget <=3D 0 ||
> > > -                            time_after_eq(jiffies, time_limit))) {
> > > +               if (unlikely(budget <=3D 0)) {
> > > +                       sd->budget_squeeze++;
> > > +                       is_continue =3D false;
> > > +               }
> > > +               if (unlikely(time_after_eq(jiffies, time_limit))) {
> > >                         sd->time_squeeze++;
> > > -                       break;
> > > +                       is_continue =3D false;
> > >                 }
> > >         }
> > >
> > > diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
> > > index 97a304e1957a..4d1a499d7c43 100644
> > > --- a/net/core/net-procfs.c
> > > +++ b/net/core/net-procfs.c
> > > @@ -174,14 +174,17 @@ static int softnet_seq_show(struct seq_file *se=
q, void *v)
> > >          */
> > >         seq_printf(seq,
> > >                    "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x=
 %08x %08x %08x "
> > > -                  "%08x %08x\n",
> > > -                  sd->processed, sd->dropped, sd->time_squeeze, 0,
> > > +                  "%08x %08x %08x %08x\n",
> > > +                  sd->processed, sd->dropped,
> > > +                  0, /* was old way to count time squeeze */
> > > +                  0,
> > >                    0, 0, 0, 0, /* was fastroute */
> > >                    0,   /* was cpu_collision */
> > >                    sd->received_rps, flow_limit_count,
> > >                    0,   /* was len of two backlog queues */
> > >                    (int)seq->index,
> > > -                  softnet_input_pkt_queue_len(sd), softnet_process_q=
ueue_len(sd));
> > > +                  softnet_input_pkt_queue_len(sd), softnet_process_q=
ueue_len(sd),
> > > +                  sd->time_squeeze, sd->budget_squeeze);
> > >         return 0;
> > >  }
> > >
> > > --
> > > 2.37.3
> > >
> >
