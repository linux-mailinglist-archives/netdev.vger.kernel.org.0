Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287B16D9689
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 13:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237065AbjDFL5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 07:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238761AbjDFL5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 07:57:10 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5FABB86
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 04:54:39 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id y20so50505834lfj.2
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 04:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680782077;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1UfyJSUwsLSLM9WMD7rmJ8z1ch5pKjgdAjOycSofO6Q=;
        b=dIFXFuOVie4dJAtXVYdiMce0IMfw49TsJKA5mY7mUWeN+Ae1G41Ady4HEkuZqjKt1s
         qlTfk2MrnxnoFhoPfRUcYyouQWesE45sERrbFlQbXsMyAL4CV9PsrDJAPlC/aEpJ5ITJ
         0kk6GoFniAd+41M5aINVVFPqpHnJuKSi0NKh4RZ1ko83b+HoZgRGu9yc5VQVdISto2ay
         azONvO6sbWm5X9jtXOHg/nV80mKsT4BuokMMKuMNi51Q/pkbeCWqU80N+PMSJPNMbwwH
         xPh9ODJOLKaoHt2JMuZWRHklB3MRZqpbxyL5lMtSDE9GKfCoro7eMfcrTADpk8cQpYjf
         B+3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680782077;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1UfyJSUwsLSLM9WMD7rmJ8z1ch5pKjgdAjOycSofO6Q=;
        b=iYdFIkl1QwvAhMrcMpiAH5BUQSfFaCjgnQ1mKQK4I0/J7BUHSgh2rWDMoUQBQ3lnLO
         7qDoUD0a+T0rQdXfktTbPK3NSb4FpxgzlFzglRGHWuW3uFYnmDhlNmfFkBZLRUeLSbyi
         DCATmMlt5wYErRau146E9RbVKnt5HIw1CSLMoe0MivpZwIEoD6huTLr/0K4Kx3/iqHCO
         kNcLSaMfGIWh0o2JEPgnaqgYGwIkvbUZQrGmTYNJpkAKkztL7h5vTYtd+S/wg+rtzbix
         1oBmj1zesJphjzHYNCvElzAee/lMQTKn7ZWttl9i12DUubx18f52kkqrfQUi6VCecmFy
         Zszg==
X-Gm-Message-State: AAQBX9dxFjN1z07dhbC0uBPZ1grA9cxku3Inqxf3yyNAeuWZgMqblET+
        BEAp9CH445HUJXFPoqP+J7Z4bqURr9A28ORAGIw=
X-Google-Smtp-Source: AKy350YXhS0LkCnBH7ZQnYvz3HhDS6snaSQwdIdvh5hTRYNLKBKkHdWMhy3kmJo1jmCR2CKJI8MVfJ45MKDhV2Eaams=
X-Received: by 2002:ac2:5519:0:b0:4e8:5371:c884 with SMTP id
 j25-20020ac25519000000b004e85371c884mr2975298lfk.5.1680782076467; Thu, 06 Apr
 2023 04:54:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230404074733.22869-1-liangchen.linux@gmail.com>
 <7331d6d3f9044e386e425e89b1fc32d60b046cf3.camel@gmail.com>
 <20230404182116.5795563c@kernel.org> <CAKhg4tLnSOxB7eeMqna1K3cmOn30cofxH=duOPLRs0h+59j01w@mail.gmail.com>
 <CAKgT0UfPvkiRSqxOjDUsEVapSbtV++AqSLctZHKKs=_gSxtWfA@mail.gmail.com>
 <CAKhg4t+omfRPP3pe4Suq65GiJCT2QtpB=6f+T=dWrmu7_SrZZQ@mail.gmail.com>
 <CANn89iJwMOAD_r+4eUpV65PmhMoSHbr0GOE-WA0APZDh3zpiPQ@mail.gmail.com> <CAC_iWjJD-g34ABOhu8f9wMLF0a9YYAZdh_uh2Vq44C-fAU3Nag@mail.gmail.com>
In-Reply-To: <CAC_iWjJD-g34ABOhu8f9wMLF0a9YYAZdh_uh2Vq44C-fAU3Nag@mail.gmail.com>
From:   Liang Chen <liangchen.linux@gmail.com>
Date:   Thu, 6 Apr 2023 19:54:23 +0800
Message-ID: <CAKhg4tK0D2CqbcCm5TW6LeoBuyQKq7ThrQTS7fLHBUXfoFe1XA@mail.gmail.com>
Subject: Re: [PATCH] skbuff: Fix a race between coalescing and releasing SKBs
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, hawk@kernel.org,
        davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org
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

On Thu, Apr 6, 2023 at 6:46=E2=80=AFPM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> On Thu, 6 Apr 2023 at 12:56, Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Thu, Apr 6, 2023 at 5:28=E2=80=AFAM Liang Chen <liangchen.linux@gmai=
l.com> wrote:
> > >
> > > On Wed, Apr 5, 2023 at 11:06=E2=80=AFPM Alexander Duyck
> > > <alexander.duyck@gmail.com> wrote:
> > > >
> > > > On Wed, Apr 5, 2023 at 1:19=E2=80=AFAM Liang Chen <liangchen.linux@=
gmail.com> wrote:
> > > > >
> > > > > On Wed, Apr 5, 2023 at 9:21=E2=80=AFAM Jakub Kicinski <kuba@kerne=
l.org> wrote:
> > > > > >
> > > > > > On Tue, 04 Apr 2023 08:51:18 -0700 Alexander H Duyck wrote:
> > > > > > > I'm not quite sure I agree with the fix. Couldn't we just mod=
ify the
> > > > > > > check further down that does:
> > > > > > >
> > > > > > >         if (!skb_cloned(from))
> > > > > > >                 from_shinfo->nr_frags =3D 0;
> > > > > > >
> > > > > > > And instead just make that:
> > > > > > >       if (!skb->cloned || (!skb_cloned(from) && !from->pp_rec=
ycle))
> > > > > > >                 from_shinfo->nr_frags =3D 0;
> > > > > > >
> > > > > > > With that we would retain the existing behavior and in the ca=
se of
> > > > > > > cloned from frames we would take the references and let the o=
riginal
> > > > > > > from skb freed to take care of pulling the pages from the pag=
e pool.
> > > > > >
> > > > > > Sounds like a better fix, indeed. But this sort of code will re=
quire
> > > > > > another fat comment above to explain why. This:
> > > > > >
> > > > > >         if (to->pp_recycle =3D=3D from->pp_recycle && !skb_clon=
ed(from))
> > > > > >
> > > > > > is much easier to understand, no?
> > > > > >
> > > > > > We should at least include that in the explanatory comment, I r=
eckon...
> > > > >
> > > > > Sure, the idea of dealing with the case where @from transitioned =
into non cloned
> > > > > skb in the function retains the existing behavior, and gives more
> > > > > opportunities to
> > > > > coalesce skbs. And it seems (!skb_cloned(from) && !from->pp_recyc=
le) is enough
> > > > > here.
> > > > > I will take a closer look at the code path for the fragstolen cas=
e
> > > > > before making v2
> > > > > patch  -  If @from transitioned into non cloned skb before "if
> > > > > (skb_head_is_locked(from))"
> > > > >
> > > > > Thanks for the reviews.
> > > >
> > > > Actually I am not sure that works now that I look at it closer. The
> > > > problem with using (!skb_cloned(from) && !from->pp_recycle) is that=
 it
> > > > breaks the case where both from and to are pp_recycle without being
> > > > cloned.
> > >
> > > Yeah, it would break that case. Thanks!
> > > >
> > > > So it probably needs to be something actually the setup Jakub
> > > > suggested would probably work better:
> > > >   if (to->pp_recycle =3D=3D from->pp_recycle && !skb_cloned(from))
> > > >
> > >
> > > I agree. That's better.
> >
> > Same feeling on my side.
> > I prefer not trying to merge mixed pp_recycle skbs "just because we
> > could" at the expense
> > of adding more code in a fast path.
>
> +1 here.  The intention of recycling was to affect the normal path as
> less as possible.  On top of that, we've some amount of race
> conditions over the years, trying to squeeze more performance with
> similar tricks.  I'd much rather be safe here, since recycling by
> itself is a great performance boost
>
> Regards
> /Ilias

Sorry, I didn't check my inbox before sending out the v2 patch.

Yeah, It is a bit complicated as we expected. The patch is sent out.
Please take a look to see if it is the way to go, or We should stay
with the current patch for simplicity reasons. Thanks!
