Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1281262E97E
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 00:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240381AbiKQXWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 18:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239771AbiKQXWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 18:22:35 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DA1742E1
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 15:22:34 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-39115d17f3dso27929477b3.1
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 15:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FXOYABrnPgmp9jzsBlpFNkATp6bu50ERFKeMiB3FwT4=;
        b=cBRkXp7/oBqBkFbBArBcjw6enjHfL3c5C4se/3b2EPPjNVaVcxDZ0nzxv0kZHvxHhK
         vA1Njoe6VFnuU06abq5ovlF3Azi6Z6+/NnUKwobpSxrorCdSUxeo/Z0z9ElCO+1oa7Xn
         rJHLLYVChnAOgRCTrvozFEuYt60shSGQJYpEeG7eC4JETCS6jJjtAJhnYZn50q1IJBP9
         xrEnqwRFweRpk5zLkKozTeIeE6ACpCWbmSUR2gqAlrEnGn7AzOddW5c7NycrLYlVAK3t
         jPPFmM8a4ZRkWuMc42/AtZ78qZW5KTOIMhsa6YTup/5OR+1scWDa7Ys1lbxJiID8Qa0p
         Kpdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FXOYABrnPgmp9jzsBlpFNkATp6bu50ERFKeMiB3FwT4=;
        b=6q6effdd9r4Eb4Bc9mSR3wa4KdqqacCbGOUgV3p3DKIJOhNu9Eun2rQrLh2Ytnh7v0
         L0WWSJa5LvMlZwGIiJCpn/Cu8BX/DkXy0SkQ9R05gvDa1lUdyDqHOFB9A1ynwGM3w8cT
         fDL9C1sPNO2RVegOnq/c06xhXVX4N2EDZ0Quswqta98P7nkMd01chDd2NpmGR5EPQ+47
         44/k1759L7691ifLuFZZRVFSCbjuKvRjk5X+3MOgNuKu/cpgmhPlISpait1/KJLPN2Mf
         ozlx6oE1wSNIJbQ4pulLzG1awHB+UFUf4Kuw7CK7NtO6m4ay4xk0X73EDBVUNpzlPobe
         1uxA==
X-Gm-Message-State: ANoB5pkARSeTnqfztpQ7X+chnWXNQZTyGMV+qOvz2TWVa7HcwddYe8fN
        u0DRsmaqwc+8VWYw/4oiHrrNsGTZVZPanqio85UOww==
X-Google-Smtp-Source: AA0mqf5vaOFwz4tcnPWNfoMxKmyd3C8pAR80ciAvjiQIlyM2UWM6SF8XDCmfQFtc/uQ7Gs4S4X9b3ww217tLEW6zinE=
X-Received: by 2002:a05:690c:b0d:b0:377:6947:a6b4 with SMTP id
 cj13-20020a05690c0b0d00b003776947a6b4mr4013023ywb.332.1668727353234; Thu, 17
 Nov 2022 15:22:33 -0800 (PST)
MIME-Version: 1.0
References: <202211171422.7A7A7A9@keescook> <CANn89iLQcLNX+x_gJCMy5kD5GW3Xg8U4s0VGHtSuN8iegmhjxQ@mail.gmail.com>
 <202211171513.28D070E@keescook>
In-Reply-To: <202211171513.28D070E@keescook>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 17 Nov 2022 15:22:22 -0800
Message-ID: <CANn89iKgMvhLbTi=SHn41R--rBQ8As=E52Hnecch6nOhXVYGrg@mail.gmail.com>
Subject: Re: Coverity: __sock_gen_cookie(): Error handling issues
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-next@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 3:14 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Nov 17, 2022 at 02:49:55PM -0800, Eric Dumazet wrote:
> > On Thu, Nov 17, 2022 at 2:22 PM coverity-bot <keescook@chromium.org> wrote:
> > >
> > > Hello!
> > >
> > > This is an experimental semi-automated report about issues detected by
> > > Coverity from a scan of next-20221117 as part of the linux-next scan project:
> > > https://scan.coverity.com/projects/linux-next-weekly-scan
> > >
> > > You're getting this email because you were associated with the identified
> > > lines of code (noted below) that were touched by commits:
> > >
> > >   Wed Nov 16 12:42:01 2022 +0000
> > >     4ebf802cf1c6 ("net: __sock_gen_cookie() cleanup")
> > >
> > > Coverity reported the following:
> > >
> > > *** CID 1527347:  Error handling issues  (CHECKED_RETURN)
> > > net/core/sock_diag.c:33 in __sock_gen_cookie()
> > > 27     {
> > > 28      u64 res = atomic64_read(&sk->sk_cookie);
> > > 29
> > > 30      if (!res) {
> > > 31              u64 new = gen_cookie_next(&sock_cookie);
> > > 32
> > > vvv     CID 1527347:  Error handling issues  (CHECKED_RETURN)
> > > vvv     Calling "atomic64_try_cmpxchg" without checking return value (as is done elsewhere 8 out of 9 times).
> > > 33              atomic64_try_cmpxchg(&sk->sk_cookie, &res, new);
> >
> >
> > Hmmm. for some reason I thought @res was always updated...
> >
> > A fix would be to read sk->sk_cookie, but I guess your tool will still
> > complain we do not care
> > of  atomic64_try_cmpxchg() return value ?
> >
> > diff --git a/net/core/sock_diag.c b/net/core/sock_diag.c
> > index b11593cae5a09b15a10d6ba35bccc22263cb8fc8..58efb9c1c8dd4f8e5a3009a0176e1b96487daaff
> > 100644
> > --- a/net/core/sock_diag.c
> > +++ b/net/core/sock_diag.c
> > @@ -31,6 +31,10 @@ u64 __sock_gen_cookie(struct sock *sk)
> >                 u64 new = gen_cookie_next(&sock_cookie);
> >
> >                 atomic64_try_cmpxchg(&sk->sk_cookie, &res, new);
> > +               /* Another cpu/thread might have won the race,
> > +                * reload the final value.
> > +                */
> > +               res = atomic64_read(&sk->sk_cookie);
> >         }
> >         return res;
> >  }
>
> I think it's saying it was expecting an update loop -- i.e. to make sure
> the value actually got swapped (the "try" part...)?

The value has been updated, either by us or someone else.

We do not particularly care who won the race, since the value is
updated once only.
