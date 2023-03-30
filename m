Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5936D03B4
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 13:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbjC3LpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 07:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbjC3LpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 07:45:07 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71256A5D3
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 04:44:44 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id h187so6428803iof.7
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 04:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680176668;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2RONu2RZBNLLDub3ywrjKSonV/K6wEcd/t7CVxMvR2g=;
        b=rst5GuAKuiF5fjwagYk5jSZQoy0UWXU7Z3LMCkwykrsGX6Xo9/TxxCNIxMtGw7r6MJ
         SjTPSnfc9IKUd5NHfRF+L5yRuoZ8dUdJ8Hmxkiv8s27bCgLUpDWpBf+isxaTuareLRz1
         Y0kHy/ZtAVBCs3OgOk0oY7DHNVwr3aNg5nyxVLKxtZNLrgvQufwLt4A0DSWBISY+jvs0
         q1TABfFdELWgbcgOzJe3B9Hgi6cHeHtMLCN9oHEFx9W69L8L+Lfd/1uyi3JIDgF0+2LJ
         Y2YCS+o/JPztCJHSvTT/mrvWiZw5GfhwdXifxEkpGztB3meatJzvEDp0KIq9JMdHLDwP
         YLgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680176668;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2RONu2RZBNLLDub3ywrjKSonV/K6wEcd/t7CVxMvR2g=;
        b=ZxpIrbe/4eLzlafpxIqpTBaSfgxO6YAkyczyR5SYYdxdIg6Jbfh02zcuFQL0HxAv6C
         evMdcbavRxdZoCGIJlONcZfiI0jgXS7cpV7VQjEV8KJy/tP260j2LsosPzS7XVAdtGbt
         ykLu2bg1KbkxMrGtnMoJNak4XVm4WPHEKkWqERkYXjl4HclH/JlaM/PV2wuZkOIRz6Ig
         JE0avQ8yZZpjvBCFgWicqiQIXWrKYPcxdhNhlQbxr6qzEdfLA2zEJi/CQRZMNKl1hm0y
         1aGjWoCP0A663taDyNK/usPU2rNmHAJsVnKAc/VqFLbuNcosGn3kpZPPLCUynKfBpLci
         887Q==
X-Gm-Message-State: AO0yUKWnvAeuqu3QeTLrskEjsl8FUnknUdx6NEcGvlCxmxGB3lYCenlG
        m6hRm6VLbVPXcdn6uXVeTWLd9zmVE5kDG5hcaN/m9w==
X-Google-Smtp-Source: AK7set+W7TKyDVptyqLv290aCYpcXrSVqj8SBPsqEgNQ7Qjfe5FrECzx+OnEjhMZGdgjHkIpHQTFfOvYKEcLj8I3FAY=
X-Received: by 2002:a5e:c810:0:b0:74c:bb62:6763 with SMTP id
 y16-20020a5ec810000000b0074cbb626763mr8605550iol.1.1680176667631; Thu, 30 Mar
 2023 04:44:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230328235021.1048163-1-edumazet@google.com> <20230328235021.1048163-5-edumazet@google.com>
 <CAL+tcoAEZ3nGfk6OVMY3O0W_c37cUMw94ugUNJsRaFuQz8_TbA@mail.gmail.com> <bbda81c4ca4d9d3ee458f4f2e1d58b2c3326732f.camel@redhat.com>
In-Reply-To: <bbda81c4ca4d9d3ee458f4f2e1d58b2c3326732f.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 30 Mar 2023 13:44:16 +0200
Message-ID: <CANn89iJaGs6pzTkkzW6eXDtKTcxCHVhz3MdRTQpW12zqY+7+jw@mail.gmail.com>
Subject: Re: [PATCH net-next 4/4] net: optimize ____napi_schedule() to avoid
 extra NET_RX_SOFTIRQ
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Jason Xing <kerneljasonxing@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Xing <kernelxing@tencent.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 1:39=E2=80=AFPM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On Thu, 2023-03-30 at 17:50 +0800, Jason Xing wrote:
> > On Wed, Mar 29, 2023 at 7:53=E2=80=AFAM Eric Dumazet <edumazet@google.c=
om> wrote:
> > >
> > > ____napi_schedule() adds a napi into current cpu softnet_data poll_li=
st,
> > > then raises NET_RX_SOFTIRQ to make sure net_rx_action() will process =
it.
> > >
> > > Idea of this patch is to not raise NET_RX_SOFTIRQ when being called i=
ndirectly
> > > from net_rx_action(), because we can process poll_list from this poin=
t,
> > > without going to full softirq loop.
> > >
> > > This needs a change in net_rx_action() to make sure we restart
> > > its main loop if sd->poll_list was updated without NET_RX_SOFTIRQ
> > > being raised.
> > >
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > Cc: Jason Xing <kernelxing@tencent.com>
> > > ---
> > >  net/core/dev.c | 22 ++++++++++++++++++----
> > >  1 file changed, 18 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index f34ce93f2f02e7ec71f5e84d449fa99b7a882f0c..0c4b21291348d4558f036=
fb05842dab023f65dc3 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -4360,7 +4360,11 @@ static inline void ____napi_schedule(struct so=
ftnet_data *sd,
> > >         }
> > >
> > >         list_add_tail(&napi->poll_list, &sd->poll_list);
> > > -       __raise_softirq_irqoff(NET_RX_SOFTIRQ);
> > > +       /* If not called from net_rx_action()
> > > +        * we have to raise NET_RX_SOFTIRQ.
> > > +        */
> > > +       if (!sd->in_net_rx_action)
> > > +               __raise_softirq_irqoff(NET_RX_SOFTIRQ);
> > >  }
> > >
> > >  #ifdef CONFIG_RPS
> > > @@ -6648,6 +6652,7 @@ static __latent_entropy void net_rx_action(stru=
ct softirq_action *h)
> > >         LIST_HEAD(list);
> > >         LIST_HEAD(repoll);
> > >
> > > +start:
> > >         sd->in_net_rx_action =3D true;
> > >         local_irq_disable();
> > >         list_splice_init(&sd->poll_list, &list);
> > > @@ -6659,9 +6664,18 @@ static __latent_entropy void net_rx_action(str=
uct softirq_action *h)
> > >                 skb_defer_free_flush(sd);
> > >
> > >                 if (list_empty(&list)) {
> > > -                       sd->in_net_rx_action =3D false;
> > > -                       if (!sd_has_rps_ipi_waiting(sd) && list_empty=
(&repoll))
> > > -                               goto end;
> > > +                       if (list_empty(&repoll)) {
> > > +                               sd->in_net_rx_action =3D false;
> > > +                               barrier();
> > > +                               /* We need to check if ____napi_sched=
ule()
> > > +                                * had refilled poll_list while
> > > +                                * sd->in_net_rx_action was true.
> > > +                                */
> > > +                               if (!list_empty(&sd->poll_list))
> > > +                                       goto start;
> >
> > I noticed that since we decide to go back and restart this loop, it
> > would be better to check the time_limit. More than that,
> > skb_defer_free_flush() can consume some time which is supposed to take
> > into account.
>
> Note that we can have a __napi_schedule() invocation with sd-
> >in_net_rx_action only after executing the napi_poll() call below and
> thus after the related time check (that is - after performing at least
> one full iteration of the main for(;;) loop).
>
> I don't think another check right here is needed.

I was about to say the same thing.

Back to READ_ONCE() and WRITE_ONCE(), I originally had them in my tree,
then simply realized they were not needed and confusing as a matter of fact=
.

barrier() is the right thing here, and only one is needed, because
others are implicit,
because before hitting reads, we must call out of line functions.
