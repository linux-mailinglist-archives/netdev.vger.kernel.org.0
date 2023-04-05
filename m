Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3F26D811F
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 17:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238688AbjDEPKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 11:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238334AbjDEPJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 11:09:46 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECD5768A
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 08:06:48 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id gp15-20020a17090adf0f00b0023d1bbd9f9eso39862895pjb.0
        for <netdev@vger.kernel.org>; Wed, 05 Apr 2023 08:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680707201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zqg0YTBi/aRoczoHuEbXWeH+FSGmPC7QlqYkCTzyWE4=;
        b=et5ZVecpqowX3ksQf0JKNZpgZMkjiSuaFHGUntkE8fVuf6RRp2+b4Qdubx3Dq+J6xA
         sLL4/p0OkhhZHjuFh2H3CW4cR1hcG4UsqunKV4P2HlDZiop7smSfJSxU4MvmklVEyJ0P
         e4KhcCi2qMBBzPeB2MAnWDgK0R3op3QG6NDhw8+zX3W++5c1X7PEKOFLkKAZtsD31XfJ
         okwv9JVFrDmZZ4j/tGRWkyIcwfwBIofAIclWFhXqFTt3Je7i2O6PASjVoM1fcqYPgi2+
         6uXQM2EenbsdbWqQ+TFw7oEXx6FU0gUf7dhuwLnwLKAbUzrMLNB8+duKI7kGlUf55f8a
         uB6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680707201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zqg0YTBi/aRoczoHuEbXWeH+FSGmPC7QlqYkCTzyWE4=;
        b=5uK5cisV92HwJ+4qDyUxpt10zuijPTWWKiOpl+hxViuMjXgxac8ZdsZWU5PHhr9Q4y
         y+eHtDUSjrWwW5Xg6fobSTTKf4oPartJm03/wi3AnpARf89HHyYRfqQyrGkmhWeFn12Z
         wh6jsT20qfVcAJJG+Bphzd4Yb6YktgaAZUfRCyoKYszwtUesJyJFqcyqe5o7p+yUC1XZ
         xZn2t0ngoPBD9GAX5eQ4W/lh+5ZU5TiYRqe7ufTluz97TSX6nqjyzNhCVqV2xuwWpkW7
         Vrd3J8seU4t5Btfimjs3nVkZTKvBlIHD9GoXxUba/vygWWevWnyElSvn7nO2HOVirpJk
         ATkg==
X-Gm-Message-State: AAQBX9d6rIanSt/gICuERJFzqWPOBSvazfbOtlCmcOp0xOEQxP8BaI4z
        2BZY05vIYLJTO3Ji73buQhGahko+8Vm9lJ7gOaU=
X-Google-Smtp-Source: AKy350Zwes4SXTkzrJYvmV/pv/nIhr4Lezr9WFGLr0cgFQPRAXHwVK/4nm22YLwEEHRiVEfxDym3YcFIRz8cd71htOc=
X-Received: by 2002:a17:903:50c:b0:19f:2339:b2ef with SMTP id
 jn12-20020a170903050c00b0019f2339b2efmr2728208plb.9.1680707201435; Wed, 05
 Apr 2023 08:06:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230404074733.22869-1-liangchen.linux@gmail.com>
 <7331d6d3f9044e386e425e89b1fc32d60b046cf3.camel@gmail.com>
 <20230404182116.5795563c@kernel.org> <CAKhg4tLnSOxB7eeMqna1K3cmOn30cofxH=duOPLRs0h+59j01w@mail.gmail.com>
In-Reply-To: <CAKhg4tLnSOxB7eeMqna1K3cmOn30cofxH=duOPLRs0h+59j01w@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 5 Apr 2023 08:06:29 -0700
Message-ID: <CAKgT0UfPvkiRSqxOjDUsEVapSbtV++AqSLctZHKKs=_gSxtWfA@mail.gmail.com>
Subject: Re: [PATCH] skbuff: Fix a race between coalescing and releasing SKBs
To:     Liang Chen <liangchen.linux@gmail.com>
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

On Wed, Apr 5, 2023 at 1:19=E2=80=AFAM Liang Chen <liangchen.linux@gmail.co=
m> wrote:
>
> On Wed, Apr 5, 2023 at 9:21=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> w=
rote:
> >
> > On Tue, 04 Apr 2023 08:51:18 -0700 Alexander H Duyck wrote:
> > > I'm not quite sure I agree with the fix. Couldn't we just modify the
> > > check further down that does:
> > >
> > >         if (!skb_cloned(from))
> > >                 from_shinfo->nr_frags =3D 0;
> > >
> > > And instead just make that:
> > >       if (!skb->cloned || (!skb_cloned(from) && !from->pp_recycle))
> > >                 from_shinfo->nr_frags =3D 0;
> > >
> > > With that we would retain the existing behavior and in the case of
> > > cloned from frames we would take the references and let the original
> > > from skb freed to take care of pulling the pages from the page pool.
> >
> > Sounds like a better fix, indeed. But this sort of code will require
> > another fat comment above to explain why. This:
> >
> >         if (to->pp_recycle =3D=3D from->pp_recycle && !skb_cloned(from)=
)
> >
> > is much easier to understand, no?
> >
> > We should at least include that in the explanatory comment, I reckon...
>
> Sure, the idea of dealing with the case where @from transitioned into non=
 cloned
> skb in the function retains the existing behavior, and gives more
> opportunities to
> coalesce skbs. And it seems (!skb_cloned(from) && !from->pp_recycle) is e=
nough
> here.
> I will take a closer look at the code path for the fragstolen case
> before making v2
> patch  -  If @from transitioned into non cloned skb before "if
> (skb_head_is_locked(from))"
>
> Thanks for the reviews.

Actually I am not sure that works now that I look at it closer. The
problem with using (!skb_cloned(from) && !from->pp_recycle) is that it
breaks the case where both from and to are pp_recycle without being
cloned.

So it probably needs to be something actually the setup Jakub
suggested would probably work better:
  if (to->pp_recycle =3D=3D from->pp_recycle && !skb_cloned(from))

Basically we just have to guarantee that if we are copying frags over
the frag destructor is the same for the origin and destination.
Otherwise we can take a reference and convert them to being reference
counted.
