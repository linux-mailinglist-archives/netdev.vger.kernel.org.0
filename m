Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32DB640F1BC
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 07:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244613AbhIQFsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 01:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbhIQFsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 01:48:15 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A721C061574
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 22:46:54 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id k23-20020a17090a591700b001976d2db364so6552487pji.2
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 22:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v5mbwJz1odNy/ykJXb9ZQ7wE8P1tliZYE55MzD70ZWY=;
        b=k/bPyvX0+UHTeHgz0xTR4ahxZO8F7dohaHIt3pvDpytmbAzROCKgiIc1xpUOM/0fCM
         JipbaraVTG+OpllrmUUzSvKAg6abwhD0Rn3sqoPtSNcNoebH6yzFpf8/6c+Zg2MF77Bj
         ohv+g/MYlNP6eiMxLmRKu9UHct6aKDmnVTS0m6hYoYO0LlVpZ519p2SjVfwu+ttcPmPN
         nO9wqMk5m41efXRtbrHvfzMbC5IpFXulrKrjbZKjO/cADf0a5fRa2RyAosCBPcSafeOx
         9/2cTsUXXX9thYQPErdTtDlLAmvok/3jIstpQa0jSEdQKH7twjQpZ2dDGEVVoldb1OSK
         8gSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v5mbwJz1odNy/ykJXb9ZQ7wE8P1tliZYE55MzD70ZWY=;
        b=eAClv0MTNFjghuOgaIOT4XEAhqSnFjP7v9nmVCZQnou2u1ok20cgj8YNT5Fier+KoF
         vjmnWQq5fnnGM6WPivgLwoiyGAvsr6N4mOz/TUaOAXKA42I+OTWge2o8NRXGKZSGWZau
         F4LoXbP8WJHgvX1CoCW+B93gBrsnf2lVzECfeDEU+geYjVY7bMd/7mznRH/ZDkPIATJV
         ttuS1L8rTncprfoQFEMMCG+ydugKg3JHhCaK0Bx+sVqnYYRAWVEwpOmLx8OYRpXrOTmI
         vh9sN0D/45muBI/n9B3t3nglpmhnWnhrLLbuJ9S0ANtHemkcPr486AAaboqA4jhde+Co
         1wGw==
X-Gm-Message-State: AOAM5338Zt72OkspkhV1D5tXoSjALlpW9Jub01XWHUm4Z/r0oswjfPkU
        W8z5n/an27IjTW/Z/uWfFsuEUTF7g1HZ7osgXrQ=
X-Google-Smtp-Source: ABdhPJyj1tN1gbh991CsOzX2JgpFMbed13/0ZztYT20sm4MKqUPRjwHZBPL08IL6+S/12DHaNmzVJ10+Fu81/qd/H3U=
X-Received: by 2002:a17:902:c408:b0:138:e3df:e999 with SMTP id
 k8-20020a170902c40800b00138e3dfe999mr7951220plk.30.1631857613828; Thu, 16 Sep
 2021 22:46:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210913225332.662291-1-kuba@kernel.org> <20210913225332.662291-2-kuba@kernel.org>
 <CAM_iQpVec_FY-71n3VUUgo8YCcn00+QzBBck9h1RGNaFzXX_ig@mail.gmail.com> <20210915123642.218f7f11@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210915123642.218f7f11@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 16 Sep 2021 22:46:42 -0700
Message-ID: <CAM_iQpW553fnxXxC+BLkhzsGixoufNrjzRTrhFKo_gsE9xPwbQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: sched: update default qdisc visibility
 after Tx queue cnt changes
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Eric Dumazet <edumazet@google.com>,
        Matthew Massey <matthewmassey@fb.com>,
        Dave Taht <dave.taht@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 12:36 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 15 Sep 2021 09:31:08 -0700 Cong Wang wrote:
> > On Mon, Sep 13, 2021 at 3:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index 74fd402d26dd..f930329f0dc2 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -2921,6 +2921,8 @@ int netif_set_real_num_tx_queues(struct net_device *dev, unsigned int txq)
> > >                 if (dev->num_tc)
> > >                         netif_setup_tc(dev, txq);
> > >
> > > +               dev_qdisc_change_real_num_tx(dev, txq);
> > > +
> >
> > Don't we need to flip the device with dev_deactivate()+dev_activate()?
> > It looks like the only thing this function resets is qdisc itself, and only
> > partially.
>
> We're only making the qdiscs visible, there should be
> no datapath-visible change.

Isn't every qdisc under mq visible to datapath?

Packets can be pending in qdisc's, and qdisc's can be scheduled
in TX softirq, so essentially we need to flip the device like other
places.

>
> > >                 dev->real_num_tx_queues = txq;
> > >
> > >                 if (disabling) {
>
> > > diff --git a/net/sched/sch_mq.c b/net/sched/sch_mq.c
> > > index e79f1afe0cfd..db18d8a860f9 100644
> > > --- a/net/sched/sch_mq.c
> > > +++ b/net/sched/sch_mq.c
> > > @@ -125,6 +125,29 @@ static void mq_attach(struct Qdisc *sch)
> > >         priv->qdiscs = NULL;
> > >  }
> > >
> > > +static void mq_change_real_num_tx(struct Qdisc *sch, unsigned int new_real_tx)
> >
> > This is nearly identical to mqprio_change_real_num_tx(), can we reuse
> > it?
>
> Indeed, I was a little unsure where best to place the helper.
> Since mq is always built if mqprio is my instinct would be to
> export mq_change_real_num_tx and use it in mqprio. But I didn't
> see any existing exports (mq_attach(), mq_queue_get() are also
> identical and are not shared) so I just copy&pasted the logic.

What about net/sched/sch_generic.c?

>
> LMK if (a) that's fine; (b) I should share the new code;
> (c) I should post a patch to share all the code that's identical;...

I think you can put the code in net/sched/sch_generic.c and export
it for mqprio (mq is built-in so can just call it).

Thanks.
