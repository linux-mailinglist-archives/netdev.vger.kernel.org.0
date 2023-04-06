Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA066D8DF6
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 05:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235172AbjDFDWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 23:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235170AbjDFDWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 23:22:47 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54F95B97
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 20:22:44 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id h11so42216892lfu.8
        for <netdev@vger.kernel.org>; Wed, 05 Apr 2023 20:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680751363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jLsdkKSOG2rq0aV8V5BIigN4MrlmAhfq4cfWPS9Ha5U=;
        b=K89ygBQsh/ifz78AM5AOkVoAwrLbVO7T94CBw9keEPZflOn93km+xjTzALaxrIT6N0
         zTBVq8Njn4ON6TmvxSRIfWlLmC0K+fHVzrZ3lSpEQFaOiQGQQbuff7p4pQTQ2iZ1z6Kf
         PNxKKqIfvJ0uD4279nQE9LJmR1q9LsN7P2N5yg/FNABZJ9BdMSfCVml6V+VApEFE+RMD
         rbYUBqGixX4wzLeNH+a2M0IK8M9RWyQ5cERCnSCNEjFC84Lc9zTma/gjtqGxbeDDdvun
         jHTSBvd6Eg6leliiIa2uGjF4afkT8i1mFAQMZFvbfAC2V4b5KYpSw+kCQsjBsJsAVF6y
         jzEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680751363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jLsdkKSOG2rq0aV8V5BIigN4MrlmAhfq4cfWPS9Ha5U=;
        b=x8Isc/iqyd78fh7lCICNO3AAw2xtBsSwteEMxl276ND3TIG5icC8vWdby2N6p5yDBA
         m9R2QExjeoFvhWW1ZXIqMSvnVzbvmX+DsImNVPixktCxHphn2K5XhK0IgNlfA1T7xlFf
         JlElnDvE/uapKyX0n2t9eLpDAyYMjv+ZMDUdZNc7y3WFYZ1Z6zBHH/6EIr6YYw9IBcSp
         Wsy/AUGlmUZtYL5jR/DSq1EGsOEtn1ZAIlw3pLgXHt0TjY8cn8ipKkFT4Fu1E+qLN4PU
         vt7DLK/YWS7PTpbyqlFncZSlGkzWgWLQTdGdcUIQo3cde7XDT82DmiFzxHdVUw1JWjzq
         Hhlw==
X-Gm-Message-State: AAQBX9c4vf3VDg7ivDPS1AnO0GekzJMJtAhVEwMfUPBNbOarZOXqt4U9
        F0A234iK8QCNncckfjerOoCXzSSlrbO3USqjvS0=
X-Google-Smtp-Source: AKy350ar5fmY8kuwnE6/Pu6kYDSbBNWTg1qOGCpDkAdstk1D7mh6BpUPmXM01TjLwNzmE0n8Mn5Jz648vmTrXBygcbo=
X-Received: by 2002:ac2:5923:0:b0:4e8:44ee:e2d with SMTP id
 v3-20020ac25923000000b004e844ee0e2dmr2534336lfi.5.1680751362880; Wed, 05 Apr
 2023 20:22:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230404074733.22869-1-liangchen.linux@gmail.com>
 <7331d6d3f9044e386e425e89b1fc32d60b046cf3.camel@gmail.com>
 <20230404182116.5795563c@kernel.org> <CAKhg4tLnSOxB7eeMqna1K3cmOn30cofxH=duOPLRs0h+59j01w@mail.gmail.com>
 <20230405075050.2fbc4502@kernel.org>
In-Reply-To: <20230405075050.2fbc4502@kernel.org>
From:   Liang Chen <liangchen.linux@gmail.com>
Date:   Thu, 6 Apr 2023 11:22:30 +0800
Message-ID: <CAKhg4tJLW35D-euBFM+_ph=deSq1uHjpYQVWuZUHdCL8D3h5Og@mail.gmail.com>
Subject: Re: [PATCH] skbuff: Fix a race between coalescing and releasing SKBs
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander H Duyck <alexander.duyck@gmail.com>,
        ilias.apalodimas@linaro.org, hawk@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
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

On Wed, Apr 5, 2023 at 10:50=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Wed, 5 Apr 2023 16:18:47 +0800 Liang Chen wrote:
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
>
> Well, that's pretty much what Alex suggested minus the optimization he
> put in for "was never cloned" which is probably worth having. So if
> you're gonna do this just use his code.
>
> My point was that !from->pp_recycle requires the reader to understand
> the relationship between this check and the previous condition at entry.
> While to->pp_recycle =3D=3D from->pp_recycle seems much more obvious to m=
e -
> directly shifting frags between skbs with different refcount styles is
> dangerous.
>

Yeah, I agree with the point that to->pp_recycle =3D=3D from->pp_recycle
is easier to understand, and will use it in the next iteration of the
patch. Thanks!

> Maybe it's just me, so whatever.
> Make sure you write a good comment.

Sure.
>
> > I will take a closer look at the code path for the fragstolen case
> > before making v2
> > patch  -  If @from transitioned into non cloned skb before "if
> > (skb_head_is_locked(from))"
> >

I took a closer look at the code path for the "fragstolen" case, and
it indeed requires a special handle for the situation addressed in
this patch. Something like,

    if( to->pp_recycle !=3D from->pp_recycle )
        get_page(page);

before  "*fragstolen =3D true;".   But this makes the logic a bit
complicated. Anyway, I will include the logic in the v2 patch. Let's
see if it looks better.

> > Thanks for the reviews.
