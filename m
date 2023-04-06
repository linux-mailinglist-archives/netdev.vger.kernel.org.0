Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BF96D936B
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 11:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235907AbjDFJ6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 05:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235967AbjDFJ5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 05:57:46 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7036A4D
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:56:24 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id u97so3424012ybi.10
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 02:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680774984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7KurTyXnxBCoSzUjD15l4nc9MiOTLWJOEPxsTLaOMXs=;
        b=Eo70zCYbM10XY0kh5sx6x9X5twcg4z6ur7XGudNaiiB7Hw0yj7rwc/UsZw8t1vUhAa
         6HlDoNUYa41LOXeetOrEiMwBT4kUqmfro31v/7TG7si+hDtWW0KRD3sjVUUlnOzMGZUo
         Kyb7L/qOlRpgTluBNbsIhpJ0xRbk2Om3RRyMwUnAmHm2xqBtt7uAefLyW5rRzXsmxf80
         cYHhe38D3qfr/O4T3bRxNHJZjrNze5j+r/oR8V0/uFY/nw1bclpfECLumEjPmgiPhCqQ
         D3pBww3CpOkhmmyQXd8If7TbdCvUPRqALHKnPGGqRumxwm+3u58RoMtgb2+YpyOcVo3t
         dWiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680774984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7KurTyXnxBCoSzUjD15l4nc9MiOTLWJOEPxsTLaOMXs=;
        b=eM+LilB6syxZTi9FQ5w65h7Jscgy3JfLxeysBVCaPAWTLRLyy2xdQ1nUbBlKnUHJgf
         2U85PkqoFqTvMVPSym6NqORbYvs0yWP5BGVTVD4nxZAQkF+2o9yz/0IdgyPFFa/+s9Ia
         PHNqMn/BDwyvfb44w2h3JhM+qoRrVvEq8Myre5rBRNJmO1BFo6J1uKXZh+5guACDfoXN
         RFiWzj2yCqQgsSpPyYSilfRnbd3mYEsyDCC+fgHUi40kxh9NfOhh73WQICKIxNz2kIha
         bmmWc9pob40cnWhhtShjFFlHIBkjEgwuOFSEvnvcFJUsLU9ILH+bjR6AouY9eReauuO3
         V04w==
X-Gm-Message-State: AAQBX9cowCsxTsd5uz3B30Bvmv8y1GQ2CsIPZ/RI6YYhtnVi0c4Ffjt3
        lpNOwVdeo8mbpOSudxbV0Q57aa5BrvShW1u1h1/0DA==
X-Google-Smtp-Source: AKy350afuw9aOESufzPFVVooeXGrh+gznWhb3Mrz5VhiQm1RIo8okhsjYSPGJWU2bNOoP93if/vi3v93AttziOTnEtA=
X-Received: by 2002:a25:c650:0:b0:b8b:ee74:e4da with SMTP id
 k77-20020a25c650000000b00b8bee74e4damr1411882ybf.4.1680774983982; Thu, 06 Apr
 2023 02:56:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230404074733.22869-1-liangchen.linux@gmail.com>
 <7331d6d3f9044e386e425e89b1fc32d60b046cf3.camel@gmail.com>
 <20230404182116.5795563c@kernel.org> <CAKhg4tLnSOxB7eeMqna1K3cmOn30cofxH=duOPLRs0h+59j01w@mail.gmail.com>
 <CAKgT0UfPvkiRSqxOjDUsEVapSbtV++AqSLctZHKKs=_gSxtWfA@mail.gmail.com> <CAKhg4t+omfRPP3pe4Suq65GiJCT2QtpB=6f+T=dWrmu7_SrZZQ@mail.gmail.com>
In-Reply-To: <CAKhg4t+omfRPP3pe4Suq65GiJCT2QtpB=6f+T=dWrmu7_SrZZQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 6 Apr 2023 11:56:13 +0200
Message-ID: <CANn89iJwMOAD_r+4eUpV65PmhMoSHbr0GOE-WA0APZDh3zpiPQ@mail.gmail.com>
Subject: Re: [PATCH] skbuff: Fix a race between coalescing and releasing SKBs
To:     Liang Chen <liangchen.linux@gmail.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, ilias.apalodimas@linaro.org,
        hawk@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        netdev@vger.kernel.org
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

On Thu, Apr 6, 2023 at 5:28=E2=80=AFAM Liang Chen <liangchen.linux@gmail.co=
m> wrote:
>
> On Wed, Apr 5, 2023 at 11:06=E2=80=AFPM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Wed, Apr 5, 2023 at 1:19=E2=80=AFAM Liang Chen <liangchen.linux@gmai=
l.com> wrote:
> > >
> > > On Wed, Apr 5, 2023 at 9:21=E2=80=AFAM Jakub Kicinski <kuba@kernel.or=
g> wrote:
> > > >
> > > > On Tue, 04 Apr 2023 08:51:18 -0700 Alexander H Duyck wrote:
> > > > > I'm not quite sure I agree with the fix. Couldn't we just modify =
the
> > > > > check further down that does:
> > > > >
> > > > >         if (!skb_cloned(from))
> > > > >                 from_shinfo->nr_frags =3D 0;
> > > > >
> > > > > And instead just make that:
> > > > >       if (!skb->cloned || (!skb_cloned(from) && !from->pp_recycle=
))
> > > > >                 from_shinfo->nr_frags =3D 0;
> > > > >
> > > > > With that we would retain the existing behavior and in the case o=
f
> > > > > cloned from frames we would take the references and let the origi=
nal
> > > > > from skb freed to take care of pulling the pages from the page po=
ol.
> > > >
> > > > Sounds like a better fix, indeed. But this sort of code will requir=
e
> > > > another fat comment above to explain why. This:
> > > >
> > > >         if (to->pp_recycle =3D=3D from->pp_recycle && !skb_cloned(f=
rom))
> > > >
> > > > is much easier to understand, no?
> > > >
> > > > We should at least include that in the explanatory comment, I recko=
n...
> > >
> > > Sure, the idea of dealing with the case where @from transitioned into=
 non cloned
> > > skb in the function retains the existing behavior, and gives more
> > > opportunities to
> > > coalesce skbs. And it seems (!skb_cloned(from) && !from->pp_recycle) =
is enough
> > > here.
> > > I will take a closer look at the code path for the fragstolen case
> > > before making v2
> > > patch  -  If @from transitioned into non cloned skb before "if
> > > (skb_head_is_locked(from))"
> > >
> > > Thanks for the reviews.
> >
> > Actually I am not sure that works now that I look at it closer. The
> > problem with using (!skb_cloned(from) && !from->pp_recycle) is that it
> > breaks the case where both from and to are pp_recycle without being
> > cloned.
>
> Yeah, it would break that case. Thanks!
> >
> > So it probably needs to be something actually the setup Jakub
> > suggested would probably work better:
> >   if (to->pp_recycle =3D=3D from->pp_recycle && !skb_cloned(from))
> >
>
> I agree. That's better.

Same feeling on my side.
I prefer not trying to merge mixed pp_recycle skbs "just because we
could" at the expense
of adding more code in a fast path.
