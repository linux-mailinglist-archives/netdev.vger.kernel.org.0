Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC076D945D
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 12:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237045AbjDFKrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 06:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235352AbjDFKrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 06:47:00 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459DE4ED0
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 03:46:56 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id d7so5242620lfj.3
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 03:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680778014;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B2BzjQV0Pgg1DKvuOn1ZFphHP1RdJIg2N34YNYw46iY=;
        b=jzmPdWIsIDnq+MiduuP1tjldTyDoLsHcCykiu247BLfxl70th03c/DDkBBEkDFaN/Q
         lfGal2GyLX9AUqEMuX90hkOsYTtYrwC6ldAmWjd9KzHK2MX/ORfDUgmJYmQ7DnnYsLjA
         eySUvTI8d4VfryC8KuP3dBo9rgfYbJddbxk9lt80ZwOIqWaeYC9d3ipHbOW3JSeWNRdC
         eXCfxNfSmU+dbrhCmHdbT/qTXOjv1E/D2sU0Oe97V0/PpQNYjk+FxYkOHGB93sRbhkIz
         HkoCHdefmN657El2myvAiZTTC2eNRZcBZJb1f/cqeOMekPDwxIM28kSoGeubKZjIhmaJ
         XQ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680778014;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B2BzjQV0Pgg1DKvuOn1ZFphHP1RdJIg2N34YNYw46iY=;
        b=3reqxYwaZOwWEUhVSgRjy80ukgE/nhvnFW2UD4AptozUURr9Zk42I9adRNr1Inq+iC
         rOgazu9VGcRqGv81ZLxIZsXCcFkiGWxuXkL+xS4qu8cCOdbEGpH7EDhC0QYAzRYm63gi
         lroQy+3+a6NOwPv+2C2T68C7hG0Ab/FpW+r6/gleLBfJSrcHSzsFQ+nQPHZGE8gacuPV
         SY27+rytAVBPVDdrhtUXdimCfr6s96vmXJzwzhUxevUOduWwnT+231so/q35m+M4/upc
         BVbHMNUmeYVGAuCYiOdzwdDpu5K3UQiU3iC/df8iEsHnTOfJSYsZQ8WUKqXrlL18tfdY
         69Ng==
X-Gm-Message-State: AAQBX9fRZVuhI0LLZNw59jkGcKIFrMVtR9PXTNGBh2SbzGuA4Ho0kwwV
        Er96OfuL1fRQdE/+vz4SFfeTFgHRVhLtAAuiwIh015QaDpSvMgOv
X-Google-Smtp-Source: AKy350bU649T5YluFK0J+R3PU7d20Sh3wi51pNWfpw6aJwdFpGQX1msWyMwuelRmee1ZNIzi6YF4w/kdVW0yHAxS8RE=
X-Received: by 2002:ac2:4911:0:b0:4eb:f3d:94b3 with SMTP id
 n17-20020ac24911000000b004eb0f3d94b3mr2907075lfi.6.1680778014493; Thu, 06 Apr
 2023 03:46:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230404074733.22869-1-liangchen.linux@gmail.com>
 <7331d6d3f9044e386e425e89b1fc32d60b046cf3.camel@gmail.com>
 <20230404182116.5795563c@kernel.org> <CAKhg4tLnSOxB7eeMqna1K3cmOn30cofxH=duOPLRs0h+59j01w@mail.gmail.com>
 <CAKgT0UfPvkiRSqxOjDUsEVapSbtV++AqSLctZHKKs=_gSxtWfA@mail.gmail.com>
 <CAKhg4t+omfRPP3pe4Suq65GiJCT2QtpB=6f+T=dWrmu7_SrZZQ@mail.gmail.com> <CANn89iJwMOAD_r+4eUpV65PmhMoSHbr0GOE-WA0APZDh3zpiPQ@mail.gmail.com>
In-Reply-To: <CANn89iJwMOAD_r+4eUpV65PmhMoSHbr0GOE-WA0APZDh3zpiPQ@mail.gmail.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Thu, 6 Apr 2023 13:46:18 +0300
Message-ID: <CAC_iWjJD-g34ABOhu8f9wMLF0a9YYAZdh_uh2Vq44C-fAU3Nag@mail.gmail.com>
Subject: Re: [PATCH] skbuff: Fix a race between coalescing and releasing SKBs
To:     Eric Dumazet <edumazet@google.com>
Cc:     Liang Chen <liangchen.linux@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, hawk@kernel.org,
        davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Apr 2023 at 12:56, Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Apr 6, 2023 at 5:28=E2=80=AFAM Liang Chen <liangchen.linux@gmail.=
com> wrote:
> >
> > On Wed, Apr 5, 2023 at 11:06=E2=80=AFPM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> > >
> > > On Wed, Apr 5, 2023 at 1:19=E2=80=AFAM Liang Chen <liangchen.linux@gm=
ail.com> wrote:
> > > >
> > > > On Wed, Apr 5, 2023 at 9:21=E2=80=AFAM Jakub Kicinski <kuba@kernel.=
org> wrote:
> > > > >
> > > > > On Tue, 04 Apr 2023 08:51:18 -0700 Alexander H Duyck wrote:
> > > > > > I'm not quite sure I agree with the fix. Couldn't we just modif=
y the
> > > > > > check further down that does:
> > > > > >
> > > > > >         if (!skb_cloned(from))
> > > > > >                 from_shinfo->nr_frags =3D 0;
> > > > > >
> > > > > > And instead just make that:
> > > > > >       if (!skb->cloned || (!skb_cloned(from) && !from->pp_recyc=
le))
> > > > > >                 from_shinfo->nr_frags =3D 0;
> > > > > >
> > > > > > With that we would retain the existing behavior and in the case=
 of
> > > > > > cloned from frames we would take the references and let the ori=
ginal
> > > > > > from skb freed to take care of pulling the pages from the page =
pool.
> > > > >
> > > > > Sounds like a better fix, indeed. But this sort of code will requ=
ire
> > > > > another fat comment above to explain why. This:
> > > > >
> > > > >         if (to->pp_recycle =3D=3D from->pp_recycle && !skb_cloned=
(from))
> > > > >
> > > > > is much easier to understand, no?
> > > > >
> > > > > We should at least include that in the explanatory comment, I rec=
kon...
> > > >
> > > > Sure, the idea of dealing with the case where @from transitioned in=
to non cloned
> > > > skb in the function retains the existing behavior, and gives more
> > > > opportunities to
> > > > coalesce skbs. And it seems (!skb_cloned(from) && !from->pp_recycle=
) is enough
> > > > here.
> > > > I will take a closer look at the code path for the fragstolen case
> > > > before making v2
> > > > patch  -  If @from transitioned into non cloned skb before "if
> > > > (skb_head_is_locked(from))"
> > > >
> > > > Thanks for the reviews.
> > >
> > > Actually I am not sure that works now that I look at it closer. The
> > > problem with using (!skb_cloned(from) && !from->pp_recycle) is that i=
t
> > > breaks the case where both from and to are pp_recycle without being
> > > cloned.
> >
> > Yeah, it would break that case. Thanks!
> > >
> > > So it probably needs to be something actually the setup Jakub
> > > suggested would probably work better:
> > >   if (to->pp_recycle =3D=3D from->pp_recycle && !skb_cloned(from))
> > >
> >
> > I agree. That's better.
>
> Same feeling on my side.
> I prefer not trying to merge mixed pp_recycle skbs "just because we
> could" at the expense
> of adding more code in a fast path.

+1 here.  The intention of recycling was to affect the normal path as
less as possible.  On top of that, we've some amount of race
conditions over the years, trying to squeeze more performance with
similar tricks.  I'd much rather be safe here, since recycling by
itself is a great performance boost

Regards
/Ilias
