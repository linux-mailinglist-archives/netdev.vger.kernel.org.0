Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3696CF95C
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 04:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjC3C5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 22:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjC3C5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 22:57:54 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFAE5592
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 19:57:50 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id u8so9155412ilb.2
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 19:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680145069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=enRFx+KlPxY3UL5cwkQ3t/M6kssz+4eycwnbkWbrjBY=;
        b=mzneDRvrTDoyI4gVggM8oqKMcBaEdnhVhg5MZHT5gjGdYsGiL4mffIai/0u5S4tG3u
         +YREP5OMgX3b3zfzbXsY3V/6YDsvcQmqiZTJky44scEtt4WwG2IJtPlfT8BR8UDrDGR9
         KxZ9P9+NZ8naDJ0iz/fPx3Y6kI3LHOJJ1oUNsHDY0cU0z/jI0aElR+mDPDAH2/LaaiQn
         DnPnPBxo7BCwIhfvl36HBPiZtyCaoxS9HSpba5u7qeH2O6pNOH2T3Sn3tvFsArPPAcUM
         Fb6pBujIZlom7cUy/HWwRQJSgF4o/PEuzVhxDpLtLJXJLnqxL7/3FznavErupDk9gRim
         y0nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680145069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=enRFx+KlPxY3UL5cwkQ3t/M6kssz+4eycwnbkWbrjBY=;
        b=ctadoi4uW6sqKZW4qKs0FgWtFJ23oW4COgTCsTEIlHhOjN4OLUMThWT76AdjYMOYId
         XppOavY0eh4HCq5p7S5HewiRE2yWBtKs9PwvMykmGtvBsoCx4dg+MeL9mKJQJViqIA7a
         sCD23jhyqm2FvGJH/sdVw9bFXEhFUFHE5VnhsEvHXRkP5b/o8BkthCllJHsOIU7mqK6p
         OjOangzEecMav4M3R/FMiUWJl9b0Yslnjc2Lg1Xfz1uDtIq8B06k3PkS5MnLNBGa9l6e
         tY5ERd7+rA3DkJbsBbe1Xe+BRGYfSmfSMk2EGo9gLXAqompyD7uUivZQnlNErYTu41yZ
         /Bkg==
X-Gm-Message-State: AAQBX9ckZYj8ZBLjIY11ddPjgBNvpEJS+GM8FoG/BgrVyXo+KDU2zf6C
        fWIjy/JfBW5NIH8imBMh9JYtbtsepSSRnu+WaHosPw==
X-Google-Smtp-Source: AKy350b3VSjPPhtzQyYv0E6TLZBfIOCKnVLcKr66P7tcsHF2tppONFLIWX2CVPb9kwocRRZfWCe0LXKk2sss2pAaQso=
X-Received: by 2002:a05:6e02:ec7:b0:310:d631:cd72 with SMTP id
 i7-20020a056e020ec700b00310d631cd72mr11237611ilk.2.1680145069266; Wed, 29 Mar
 2023 19:57:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230328235021.1048163-1-edumazet@google.com> <20230328235021.1048163-5-edumazet@google.com>
 <fa860d02-0310-2666-1043-6909dc68ea01@huawei.com> <CANn89iLmugenUSDAQT9ryHTG9tRuKUfYgc8OqPMQwVv-1-ajNg@mail.gmail.com>
 <8610abc4-65c6-6808-e5d4-c2da8083595a@huawei.com>
In-Reply-To: <8610abc4-65c6-6808-e5d4-c2da8083595a@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 30 Mar 2023 04:57:37 +0200
Message-ID: <CANn89iJCYSA_LmpTRXz3rWRgYYHgiGsia_utwTxZa03ct7hfiQ@mail.gmail.com>
Subject: Re: [PATCH net-next 4/4] net: optimize ____napi_schedule() to avoid
 extra NET_RX_SOFTIRQ
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
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

On Thu, Mar 30, 2023 at 4:33=E2=80=AFAM Yunsheng Lin <linyunsheng@huawei.co=
m> wrote:
>
> On 2023/3/29 23:47, Eric Dumazet wrote:
> > On Wed, Mar 29, 2023 at 2:47=E2=80=AFPM Yunsheng Lin <linyunsheng@huawe=
i.com> wrote:
> >>
> >> On 2023/3/29 7:50, Eric Dumazet wrote:
> >>> ____napi_schedule() adds a napi into current cpu softnet_data poll_li=
st,
> >>> then raises NET_RX_SOFTIRQ to make sure net_rx_action() will process =
it.
> >>>
> >>> Idea of this patch is to not raise NET_RX_SOFTIRQ when being called i=
ndirectly
> >>> from net_rx_action(), because we can process poll_list from this poin=
t,
> >>> without going to full softirq loop.
> >>>
> >>> This needs a change in net_rx_action() to make sure we restart
> >>> its main loop if sd->poll_list was updated without NET_RX_SOFTIRQ
> >>> being raised.
> >>>
> >>> Signed-off-by: Eric Dumazet <edumazet@google.com>
> >>> Cc: Jason Xing <kernelxing@tencent.com>
> >>> ---
> >>>  net/core/dev.c | 22 ++++++++++++++++++----
> >>>  1 file changed, 18 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/net/core/dev.c b/net/core/dev.c
> >>> index f34ce93f2f02e7ec71f5e84d449fa99b7a882f0c..0c4b21291348d4558f036=
fb05842dab023f65dc3 100644
> >>> --- a/net/core/dev.c
> >>> +++ b/net/core/dev.c
> >>> @@ -4360,7 +4360,11 @@ static inline void ____napi_schedule(struct so=
ftnet_data *sd,
> >>>       }
> >>>
> >>>       list_add_tail(&napi->poll_list, &sd->poll_list);
> >>> -     __raise_softirq_irqoff(NET_RX_SOFTIRQ);
> >>> +     /* If not called from net_rx_action()
> >>> +      * we have to raise NET_RX_SOFTIRQ.
> >>> +      */
> >>> +     if (!sd->in_net_rx_action)
> >>
> >> It seems sd->in_net_rx_action may be read/writen by different CPUs at =
the same
> >> time, does it need something like READ_ONCE()/WRITE_ONCE() to access
> >> sd->in_net_rx_action?
> >
> > You probably missed the 2nd patch, explaining the in_net_rx_action is
> > only read and written by the current (owning the percpu var) cpu.
> >
> > Have you found a caller that is not providing to ____napi_schedule( sd
> > =3D this_cpu_ptr(&softnet_data)) ?
>
> You are right.
>
> The one small problem I see is that ____napi_schedule() call by a irq han=
dle
> may preempt the running net_rx_action() in the current cpu, I am not sure=
 if
> it worth handling, given that it is expected that the irq should be disab=
led
> when net_rx_action() is running?

And what will happen ? If the interrupts comes before

in_net_rx_action =3D val;

The interrupt handler will see the old value, this is fine really in all po=
ints.

If it comes after the assignment, the interrupt handler will see the new va=
lue,
because a cpu can not reorder its own reads/writes.

Otherwise simple things like this would fail:

a =3D 2;
b =3D a ;
assert (b =3D=3D 2) ;


1) Note that the local_irq_disable(); after the first

sd->in_net_rx_action =3D true;

in net_rx_action() already provides a strong barrier.

2) sd->in_net_rx_action =3D false before the barrier() is enough to
provide needed safety for _this_ cpu.

3) Final sd->in_net_rx_action =3D false; at the end of net_rx_action()
is performed while hard irq are masked.




> Do we need to protect against buggy hw or unbehaved driver?

If you think there is an issue please elaborate with the exact call
site/ interruption point, because I do not see any.


>
> >
> >
> >
> >>
> >>> +             __raise_softirq_irqoff(NET_RX_SOFTIRQ);
> >>>  }
> >>>
> >>>  #ifdef CONFIG_RPS
> >>> @@ -6648,6 +6652,7 @@ static __latent_entropy void net_rx_action(stru=
ct softirq_action *h)
> >>>       LIST_HEAD(list);
> >>>       LIST_HEAD(repoll);
> >>>
> >>> +start:
> >>>       sd->in_net_rx_action =3D true;
> >>>       local_irq_disable();
> >>>       list_splice_init(&sd->poll_list, &list);
> >>> @@ -6659,9 +6664,18 @@ static __latent_entropy void net_rx_action(str=
uct softirq_action *h)
> >>>               skb_defer_free_flush(sd);
> >>>
> >>>               if (list_empty(&list)) {
> >>> -                     sd->in_net_rx_action =3D false;
> >>> -                     if (!sd_has_rps_ipi_waiting(sd) && list_empty(&=
repoll))
> >>> -                             goto end;
> >>> +                     if (list_empty(&repoll)) {
> >>> +                             sd->in_net_rx_action =3D false;
> >>> +                             barrier();
> >>
> >> Do we need a stronger barrier to prevent out-of-order execution
> >> from cpu?
> >
> > We do not need more than barrier() to make sure local cpu wont move thi=
s
> > write after the following code.
>
> Is there any reason why we need the barrier() if we are not depending
> on how list_empty() is coded?
> It seems not obvious to me at least:)
>
> >
> > It should not, even without the barrier(), because of the way
> > list_empty() is coded,
> > but a barrier() makes things a bit more explicit.
>
> In that case, a comment explaining that may help a lot.
>
> Thanks.
>
> >
> >> Do we need a barrier between list_add_tail() and sd->in_net_rx_action
> >> checking in ____napi_schedule() to pair with the above barrier?
> >
> > I do not think so.
> >
> > While in ____napi_schedule(), sd->in_net_rx_action is stable
> > because we run with hardware IRQ masked.
> >
> > Thanks.
> >
> >
> >
