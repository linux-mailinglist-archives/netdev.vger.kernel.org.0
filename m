Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1007B62EBCC
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 03:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240871AbiKRCQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 21:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240865AbiKRCQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 21:16:16 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0881287575
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 18:16:15 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id h14so3274818pjv.4
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 18:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+SkZRkkef+v6G+0a9+2iS5p4d3ejFxRmaBjvvBIsMgg=;
        b=eEoKCv3TZAm+ottsO1B4CP5IM82E8KOLN6QySwO8bqXZqYslWxeaMnokpMhMqBjF3u
         NwEsQ3qwp166kcRrwJcusmJ1zwWRhnJAuBmDlvQBjtO+AnM4ZkuZaa9Imjghi/qj/WM4
         tzD3a9eP674896nEw3EBljo2xY0mGNohU3GUk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+SkZRkkef+v6G+0a9+2iS5p4d3ejFxRmaBjvvBIsMgg=;
        b=zf3EaQN8jBgLgUL2vNiBTISl6TwPFuTpQDiMgtuzot3YTg7Jht2qw7haXasmeSm/Z2
         oLtsdqVW2laZsJ/MZH7XNFgxhQSMfH3NaoMnyvwK4eDPhFTCqOEi7CYWfK8TtYm3UoOg
         V8lnVmFBj4ldyhAbVqhv6eqy4FzGDjUAzwWGUtWaoKZ22X8DDVXk1mp9T/pEgT6WOeTW
         3adOWMqxvPeNl09uWZuHOcusPu1q9wkv5lU8+9jze2O5CShShBmmH6mS3Z4E9CdvU9PO
         Bsq5vRqRFHxXakr0FT+bPMawFCh0CPZGd1OiIOyjsc/4iRDFRaWyN+ltCsDwhMVgpzf6
         k4fg==
X-Gm-Message-State: ANoB5pnXUe6M/85U41q4E3KiMlcAOMOnbwMbpFv2UZt9GGE0jkxBMIWE
        GtjT55rCwF6ioKt8h1GgC23OZg==
X-Google-Smtp-Source: AA0mqf4hAKoAqczugH/ufOKcBGcmCRT4026qHVeOERU/ya6eaV8vq/bdEj/zV8RJtOP/t4+9HlVXEg==
X-Received: by 2002:a17:902:8645:b0:188:d6e1:b82b with SMTP id y5-20020a170902864500b00188d6e1b82bmr5400452plt.146.1668737774485;
        Thu, 17 Nov 2022 18:16:14 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q17-20020a170902dad100b001886863c6absm2175114plx.97.2022.11.17.18.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 18:16:13 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:16:12 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Eric Dumazet <edumazet@google.com>
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
Subject: Re: Coverity: __sock_gen_cookie(): Error handling issues
Message-ID: <202211171815.D076ED9C@keescook>
References: <202211171422.7A7A7A9@keescook>
 <CANn89iLQcLNX+x_gJCMy5kD5GW3Xg8U4s0VGHtSuN8iegmhjxQ@mail.gmail.com>
 <202211171513.28D070E@keescook>
 <CANn89iKgMvhLbTi=SHn41R--rBQ8As=E52Hnecch6nOhXVYGrg@mail.gmail.com>
 <202211171624.963F44FCE@keescook>
 <CANn89iJ1ciQkv5nt5XgRXAXPVzEW6J=GdiUYvqrYgjUU440OtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJ1ciQkv5nt5XgRXAXPVzEW6J=GdiUYvqrYgjUU440OtQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 05:24:36PM -0800, Eric Dumazet wrote:
> On Thu, Nov 17, 2022 at 4:25 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Thu, Nov 17, 2022 at 03:22:22PM -0800, Eric Dumazet wrote:
> > > On Thu, Nov 17, 2022 at 3:14 PM Kees Cook <keescook@chromium.org> wrote:
> > > >
> > > > On Thu, Nov 17, 2022 at 02:49:55PM -0800, Eric Dumazet wrote:
> > > > > On Thu, Nov 17, 2022 at 2:22 PM coverity-bot <keescook@chromium.org> wrote:
> > > > > >
> > > > > > Hello!
> > > > > >
> > > > > > This is an experimental semi-automated report about issues detected by
> > > > > > Coverity from a scan of next-20221117 as part of the linux-next scan project:
> > > > > > https://scan.coverity.com/projects/linux-next-weekly-scan
> > > > > >
> > > > > > You're getting this email because you were associated with the identified
> > > > > > lines of code (noted below) that were touched by commits:
> > > > > >
> > > > > >   Wed Nov 16 12:42:01 2022 +0000
> > > > > >     4ebf802cf1c6 ("net: __sock_gen_cookie() cleanup")
> > > > > >
> > > > > > Coverity reported the following:
> > > > > >
> > > > > > *** CID 1527347:  Error handling issues  (CHECKED_RETURN)
> > > > > > net/core/sock_diag.c:33 in __sock_gen_cookie()
> > > > > > 27     {
> > > > > > 28      u64 res = atomic64_read(&sk->sk_cookie);
> > > > > > 29
> > > > > > 30      if (!res) {
> > > > > > 31              u64 new = gen_cookie_next(&sock_cookie);
> > > > > > 32
> > > > > > vvv     CID 1527347:  Error handling issues  (CHECKED_RETURN)
> > > > > > vvv     Calling "atomic64_try_cmpxchg" without checking return value (as is done elsewhere 8 out of 9 times).
> > > > > > 33              atomic64_try_cmpxchg(&sk->sk_cookie, &res, new);
> > > > >
> > > > >
> > > > > Hmmm. for some reason I thought @res was always updated...
> > > > >
> > > > > A fix would be to read sk->sk_cookie, but I guess your tool will still
> > > > > complain we do not care
> > > > > of  atomic64_try_cmpxchg() return value ?
> > > > >
> > > > > diff --git a/net/core/sock_diag.c b/net/core/sock_diag.c
> > > > > index b11593cae5a09b15a10d6ba35bccc22263cb8fc8..58efb9c1c8dd4f8e5a3009a0176e1b96487daaff
> > > > > 100644
> > > > > --- a/net/core/sock_diag.c
> > > > > +++ b/net/core/sock_diag.c
> > > > > @@ -31,6 +31,10 @@ u64 __sock_gen_cookie(struct sock *sk)
> > > > >                 u64 new = gen_cookie_next(&sock_cookie);
> > > > >
> > > > >                 atomic64_try_cmpxchg(&sk->sk_cookie, &res, new);
> > > > > +               /* Another cpu/thread might have won the race,
> > > > > +                * reload the final value.
> > > > > +                */
> > > > > +               res = atomic64_read(&sk->sk_cookie);
> > > > >         }
> > > > >         return res;
> > > > >  }
> > > >
> > > > I think it's saying it was expecting an update loop -- i.e. to make sure
> > > > the value actually got swapped (the "try" part...)?
> > >
> > > The value has been updated, either by us or someone else.
> > >
> > > We do not particularly care who won the race, since the value is
> > > updated once only.
> >
> > Ah! Okay, now I understand the added comment. Thanks :)
> 
> I guess we could simply go back to atomic64_cmpxchg() to avoid a false positive.

It looks like the existing code already works as intended, so no need to
silence the warning. The comment and reload might be nice to add, just
to clarify for anyone looking at it again in the future, though.

-- 
Kees Cook
