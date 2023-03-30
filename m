Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B0A6D0444
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 14:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjC3MDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 08:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbjC3MDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 08:03:46 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63DDA24E
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 05:03:44 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id x3so75408696edb.10
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 05:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680177823; x=1682769823;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JslQDnTl2qT8x35HKGKb2Xj5kaoLGPxcLTVbku0+hKM=;
        b=oo5tJwMH2aEA7gKnHjKP146I33lqxVCXdO1/kv+hA2jWHIxLCw7tnX1oj9hI5CpRfM
         JOISNoEGfjwf7TLRPmHyqsM/BGuAim+gWJ+wVTlbfW1+JXiLL/VOTHZDqDyVwMyf7dBM
         f6ubI2KSCjNOg89Ohcm6nqqNGQOxFk6CJQOIK2tuepaDd7D2kbzEV6g/wHu4F03gX5p3
         NqscSxPqVo0uQPvQXMb3uHBLwhlZWIqUgUtWnyYJnPyP/Or2Qo9rZXgBPyOTnV+lbess
         CUIF9EkJVG3nhK/w0DbwGlzRcktqJyCfhBE0ZEYJX/cNtIH9s6tZY1af7F/Oz/lWazKK
         oHQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680177823; x=1682769823;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JslQDnTl2qT8x35HKGKb2Xj5kaoLGPxcLTVbku0+hKM=;
        b=D5C1UnZ+iVXxBT7gDX5wfADhI7xAiwvJfS2SkfmuVFXZXu+5RfZfDGMLN5oPuAzORw
         qEq7qLnW07B4dlY67gJ9UsvKp1MrF0yVbQpXed+0PUV60jRADisHCGndEAuA9hWqUFLw
         T10l30uRZ7/n+mGePag5adcfpfEgnrhdk0xhP5Lii5jy0VyXqxnqRpD33kMrSRSeiCVp
         MEyPeun6t0QLOSYbyVo0oYUad0M6RjsLYYU1IWApQPCnxmZCsg8vDt7ZZK1Xmvu+VCNO
         b9ISvoBwO27Q/wuBDGG3+vKfe5BYczdWB4Wv4OCw/zioXvgedkknwy0hv1gdBE4Ia7Mt
         aTeg==
X-Gm-Message-State: AAQBX9eZACK4eaxJ3WpCCfNOdBPmfZijcDJ/rQspkknV7Rmh/D5n4gRz
        5Wnoxh1GZfwYyJI6xH6ZGL3k8oU7h23T05JN2bYSVs1u
X-Google-Smtp-Source: AKy350a/erRgznMmLEkmPt1J5008sB7z0DfcInJKPZqEKWmFMeEhjg38K58Df+X8IovYmpZr5h1uocYjBkYzsrljpn8=
X-Received: by 2002:a50:9f47:0:b0:502:1f98:e14c with SMTP id
 b65-20020a509f47000000b005021f98e14cmr11331759edf.4.1680177823356; Thu, 30
 Mar 2023 05:03:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230328235021.1048163-1-edumazet@google.com> <20230328235021.1048163-5-edumazet@google.com>
 <CAL+tcoAEZ3nGfk6OVMY3O0W_c37cUMw94ugUNJsRaFuQz8_TbA@mail.gmail.com> <bbda81c4ca4d9d3ee458f4f2e1d58b2c3326732f.camel@redhat.com>
In-Reply-To: <bbda81c4ca4d9d3ee458f4f2e1d58b2c3326732f.camel@redhat.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Thu, 30 Mar 2023 20:03:07 +0800
Message-ID: <CAL+tcoAqfB_o9wS3c3GUwGs_1pQ22O89Y3DKtgwKaqcWuhTL5g@mail.gmail.com>
Subject: Re: [PATCH net-next 4/4] net: optimize ____napi_schedule() to avoid
 extra NET_RX_SOFTIRQ
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Xing <kernelxing@tencent.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
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

On Thu, Mar 30, 2023 at 7:39=E2=80=AFPM Paolo Abeni <pabeni@redhat.com> wro=
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

Hello Paolo,

It also took me for a while to consider. I'm not that sure if we
should check again so I added "just for consideration".

Thanks,
Jason

>
> I don't think another check right here is needed.
>
> Thanks,
>
> Paolo
>
