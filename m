Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6C46D8DFB
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 05:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235201AbjDFD2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 23:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235280AbjDFD2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 23:28:24 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F429762
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 20:28:17 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id d7so4182377lfj.3
        for <netdev@vger.kernel.org>; Wed, 05 Apr 2023 20:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680751696;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=759LQl2gs39bkfixSaMEvbp+mvBbsjx/0enfWUWKnzU=;
        b=R1dyq6BUSVmpHTDVhHtSifdkJOika4OFvi9sB6pdmJoMSds9kT5crFY69+dfoa7l4W
         P5CgiYDODwBmkc256mOZITGAiLeR/dJpMKBm8w+ylVlFso6wbLaBe3yoNyunB2GllKQY
         FAIJF7rTsWObkHNdyG6Gl+MpFvL3s1v+/QAAhCwNwEnkz7POQZgPF+ZtHJ0yMe4JVRhp
         j7sSEKQoiErCUsvrUVh7D0VYevJW8ny3ZmKk1KV4UUWGd388wfOk28HePqcLLCwNRo/o
         gd8x1+uswrHaFfN+gZbRlIgKu+aoXBqCTX7sUQ+7LL3LgZhpu/iKngUZ8606K0Vid4tI
         O4sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680751696;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=759LQl2gs39bkfixSaMEvbp+mvBbsjx/0enfWUWKnzU=;
        b=s2fwCdxK9GCLM1N/dj0girHZa0l7QQsAgqI099Jovn6v3L6jXd1VkEFaQaR3gG6Zrq
         7pK8/YVcGqFVvpK1+cUpSMQ06DCx4VgyPVJ5Cu43KnSokqxm0FY7pufj7l5Z4w/WAKVh
         qUcPrJ15xJXNg9TavlBm6YCzQ7casP3FxmXZh34DDiKXX3YTaF9ZOTAkFPptrgKxI2Jq
         J4pZawvR/Dmy++Yoa/8hGBKMPYKSXA6i/S0at0PUr6rfVv3i0wuOO75yPG2b16O5bygl
         Q/XhzWGjoCX7jtlzlJfIKV3GWxhqC3oXLHNWGyFOGsLJbO3Upj+NFgC3qYmy13QHA3G0
         E62A==
X-Gm-Message-State: AAQBX9dFGt9cmQXDal5twTjU2IhAeigbmaBdqFh0O2b2359cqNb0CfSF
        O22kUb7UFQQPE/WEQa7Z6MOZ/FwYew+kvF0GEpQ=
X-Google-Smtp-Source: AKy350Zrp3U+nC0zjLrcIerP+a68sX52tbDDJpt97K2YpO8/uDsnoszYbuQhhVWf7nZ7SbTlvR/hyf+dwpRTzLDZ87M=
X-Received: by 2002:ac2:5519:0:b0:4e8:5371:c884 with SMTP id
 j25-20020ac25519000000b004e85371c884mr2604231lfk.5.1680751695599; Wed, 05 Apr
 2023 20:28:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230404074733.22869-1-liangchen.linux@gmail.com>
 <7331d6d3f9044e386e425e89b1fc32d60b046cf3.camel@gmail.com>
 <20230404182116.5795563c@kernel.org> <CAKhg4tLnSOxB7eeMqna1K3cmOn30cofxH=duOPLRs0h+59j01w@mail.gmail.com>
 <CAKgT0UfPvkiRSqxOjDUsEVapSbtV++AqSLctZHKKs=_gSxtWfA@mail.gmail.com>
In-Reply-To: <CAKgT0UfPvkiRSqxOjDUsEVapSbtV++AqSLctZHKKs=_gSxtWfA@mail.gmail.com>
From:   Liang Chen <liangchen.linux@gmail.com>
Date:   Thu, 6 Apr 2023 11:28:03 +0800
Message-ID: <CAKhg4t+omfRPP3pe4Suq65GiJCT2QtpB=6f+T=dWrmu7_SrZZQ@mail.gmail.com>
Subject: Re: [PATCH] skbuff: Fix a race between coalescing and releasing SKBs
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, ilias.apalodimas@linaro.org,
        hawk@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
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

On Wed, Apr 5, 2023 at 11:06=E2=80=AFPM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Wed, Apr 5, 2023 at 1:19=E2=80=AFAM Liang Chen <liangchen.linux@gmail.=
com> wrote:
> >
> > On Wed, Apr 5, 2023 at 9:21=E2=80=AFAM Jakub Kicinski <kuba@kernel.org>=
 wrote:
> > >
> > > On Tue, 04 Apr 2023 08:51:18 -0700 Alexander H Duyck wrote:
> > > > I'm not quite sure I agree with the fix. Couldn't we just modify th=
e
> > > > check further down that does:
> > > >
> > > >         if (!skb_cloned(from))
> > > >                 from_shinfo->nr_frags =3D 0;
> > > >
> > > > And instead just make that:
> > > >       if (!skb->cloned || (!skb_cloned(from) && !from->pp_recycle))
> > > >                 from_shinfo->nr_frags =3D 0;
> > > >
> > > > With that we would retain the existing behavior and in the case of
> > > > cloned from frames we would take the references and let the origina=
l
> > > > from skb freed to take care of pulling the pages from the page pool=
.
> > >
> > > Sounds like a better fix, indeed. But this sort of code will require
> > > another fat comment above to explain why. This:
> > >
> > >         if (to->pp_recycle =3D=3D from->pp_recycle && !skb_cloned(fro=
m))
> > >
> > > is much easier to understand, no?
> > >
> > > We should at least include that in the explanatory comment, I reckon.=
..
> >
> > Sure, the idea of dealing with the case where @from transitioned into n=
on cloned
> > skb in the function retains the existing behavior, and gives more
> > opportunities to
> > coalesce skbs. And it seems (!skb_cloned(from) && !from->pp_recycle) is=
 enough
> > here.
> > I will take a closer look at the code path for the fragstolen case
> > before making v2
> > patch  -  If @from transitioned into non cloned skb before "if
> > (skb_head_is_locked(from))"
> >
> > Thanks for the reviews.
>
> Actually I am not sure that works now that I look at it closer. The
> problem with using (!skb_cloned(from) && !from->pp_recycle) is that it
> breaks the case where both from and to are pp_recycle without being
> cloned.

Yeah, it would break that case. Thanks!
>
> So it probably needs to be something actually the setup Jakub
> suggested would probably work better:
>   if (to->pp_recycle =3D=3D from->pp_recycle && !skb_cloned(from))
>

I agree. That's better.
> Basically we just have to guarantee that if we are copying frags over
> the frag destructor is the same for the origin and destination.
> Otherwise we can take a reference and convert them to being reference
> counted.
