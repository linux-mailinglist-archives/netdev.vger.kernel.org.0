Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D397662EAD8
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 02:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240143AbiKRBYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 20:24:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235160AbiKRBYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 20:24:50 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2296D491
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 17:24:48 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id 11so2860203iou.0
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 17:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R4T4enbQOsqO6XmAV2f5zgRx0vHX3wK4skHjCmqpICo=;
        b=tRE8MM8ca79bEn0b3rkDQO5fw0/vkOWKZR1tr+6audLccXPFKXC4mMpzZrEnQ9Rstr
         I4lbu9pQcWPcS5m05iK8xB2g6dLdJikgg+I7JKxU3RSpVo7rYenwhKYV+maXu5Gnb8sa
         da9yZCzhVhRxfwlmoD01NV8jLinl+wLctMmxx2+PLcrUNdxNQUJolSTlrIXOg62ccbhf
         Pt+GqFxBC4fZ4c2/o5Z94wZuBvxnvPMnVz6W13PArWGHzVfScmN/bqWlDq8KiDpmkyNS
         gU6G67Z5VCRqDUGFk9bhZz3789ejikfK7LH83pOfy0jt0E/NQgtBT4+wDBKuO6302iyQ
         kP+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R4T4enbQOsqO6XmAV2f5zgRx0vHX3wK4skHjCmqpICo=;
        b=CdOT9+xp4GHM6rsUw9J6XCAME1KXs81EvfBeZfEmIplwjaTYk3S1n1GcyrEDAsW7Zn
         Sa3oDTbpPCFHyNHRsFC6UK0CN5qr5MUaM8V6/Lm0xVT7GQ/aeqlHVNe3tlCeNWVhlC/D
         hYBdEwQr4GiTzJROAxYjPyj3/X8C37TAOsoD6JFBeePByuCOEpa5QCRi//qEoNal706f
         Jt4i3Hril7rGlQTBrnNnJ57mkQce3qQbDinlpjfXwIdOtXKCcTPKEEXlBFzeX8JY+wAb
         ra0Y7ONcH+f/fwyRS2dRZ1f6ky9LSTqahgWrLsai275QxOPBKgfMj3qpo1GFm02aO0bQ
         0sRA==
X-Gm-Message-State: ANoB5pnb9vDx/QMWP2MPWlf2HPaRzhXvKQ3F2PFbg/evhukihIgp3ocI
        uccQZyYSsAG6vREPl+i/F5slt1Bv5qhuf69k049S3g==
X-Google-Smtp-Source: AA0mqf6NkBSAY4uvxVSPwmaPsyhvjtFX0CdumrT/0Ae0/Afz6RGYfmyK7Nfejp1L55e1tCG1ilHwXKgSN00I+OwRtQE=
X-Received: by 2002:a6b:6d0d:0:b0:6c4:ad4d:b23a with SMTP id
 a13-20020a6b6d0d000000b006c4ad4db23amr2378611iod.2.1668734687862; Thu, 17 Nov
 2022 17:24:47 -0800 (PST)
MIME-Version: 1.0
References: <202211171422.7A7A7A9@keescook> <CANn89iLQcLNX+x_gJCMy5kD5GW3Xg8U4s0VGHtSuN8iegmhjxQ@mail.gmail.com>
 <202211171513.28D070E@keescook> <CANn89iKgMvhLbTi=SHn41R--rBQ8As=E52Hnecch6nOhXVYGrg@mail.gmail.com>
 <202211171624.963F44FCE@keescook>
In-Reply-To: <202211171624.963F44FCE@keescook>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 17 Nov 2022 17:24:36 -0800
Message-ID: <CANn89iJ1ciQkv5nt5XgRXAXPVzEW6J=GdiUYvqrYgjUU440OtQ@mail.gmail.com>
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 4:25 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Nov 17, 2022 at 03:22:22PM -0800, Eric Dumazet wrote:
> > On Thu, Nov 17, 2022 at 3:14 PM Kees Cook <keescook@chromium.org> wrote:
> > >
> > > On Thu, Nov 17, 2022 at 02:49:55PM -0800, Eric Dumazet wrote:
> > > > On Thu, Nov 17, 2022 at 2:22 PM coverity-bot <keescook@chromium.org> wrote:
> > > > >
> > > > > Hello!
> > > > >
> > > > > This is an experimental semi-automated report about issues detected by
> > > > > Coverity from a scan of next-20221117 as part of the linux-next scan project:
> > > > > https://scan.coverity.com/projects/linux-next-weekly-scan
> > > > >
> > > > > You're getting this email because you were associated with the identified
> > > > > lines of code (noted below) that were touched by commits:
> > > > >
> > > > >   Wed Nov 16 12:42:01 2022 +0000
> > > > >     4ebf802cf1c6 ("net: __sock_gen_cookie() cleanup")
> > > > >
> > > > > Coverity reported the following:
> > > > >
> > > > > *** CID 1527347:  Error handling issues  (CHECKED_RETURN)
> > > > > net/core/sock_diag.c:33 in __sock_gen_cookie()
> > > > > 27     {
> > > > > 28      u64 res = atomic64_read(&sk->sk_cookie);
> > > > > 29
> > > > > 30      if (!res) {
> > > > > 31              u64 new = gen_cookie_next(&sock_cookie);
> > > > > 32
> > > > > vvv     CID 1527347:  Error handling issues  (CHECKED_RETURN)
> > > > > vvv     Calling "atomic64_try_cmpxchg" without checking return value (as is done elsewhere 8 out of 9 times).
> > > > > 33              atomic64_try_cmpxchg(&sk->sk_cookie, &res, new);
> > > >
> > > >
> > > > Hmmm. for some reason I thought @res was always updated...
> > > >
> > > > A fix would be to read sk->sk_cookie, but I guess your tool will still
> > > > complain we do not care
> > > > of  atomic64_try_cmpxchg() return value ?
> > > >
> > > > diff --git a/net/core/sock_diag.c b/net/core/sock_diag.c
> > > > index b11593cae5a09b15a10d6ba35bccc22263cb8fc8..58efb9c1c8dd4f8e5a3009a0176e1b96487daaff
> > > > 100644
> > > > --- a/net/core/sock_diag.c
> > > > +++ b/net/core/sock_diag.c
> > > > @@ -31,6 +31,10 @@ u64 __sock_gen_cookie(struct sock *sk)
> > > >                 u64 new = gen_cookie_next(&sock_cookie);
> > > >
> > > >                 atomic64_try_cmpxchg(&sk->sk_cookie, &res, new);
> > > > +               /* Another cpu/thread might have won the race,
> > > > +                * reload the final value.
> > > > +                */
> > > > +               res = atomic64_read(&sk->sk_cookie);
> > > >         }
> > > >         return res;
> > > >  }
> > >
> > > I think it's saying it was expecting an update loop -- i.e. to make sure
> > > the value actually got swapped (the "try" part...)?
> >
> > The value has been updated, either by us or someone else.
> >
> > We do not particularly care who won the race, since the value is
> > updated once only.
>
> Ah! Okay, now I understand the added comment. Thanks :)

I guess we could simply go back to atomic64_cmpxchg() to avoid a false positive.

This boils to avoid the loop we had prior to 4ebf802cf1c6

diff --git a/net/core/sock_diag.c b/net/core/sock_diag.c
index b11593cae5a09b15a10d6ba35bccc22263cb8fc8..7b9e321e0f6b15f2fb7af9f53fceb874439cbd02
100644
--- a/net/core/sock_diag.c
+++ b/net/core/sock_diag.c
@@ -30,7 +30,11 @@ u64 __sock_gen_cookie(struct sock *sk)
        if (!res) {
                u64 new = gen_cookie_next(&sock_cookie);

-               atomic64_try_cmpxchg(&sk->sk_cookie, &res, new);
+               atomic64_cmpxchg(&sk->sk_cookie, res, new);
+               /* Another cpu/thread might have won the race,
+                * load the final value.
+                */
+               res = atomic64_read(&sk->sk_cookie);
        }
        return res;
 }
