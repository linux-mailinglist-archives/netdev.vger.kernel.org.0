Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2BC846871C
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 19:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244930AbhLDShe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 13:37:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbhLDShe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 13:37:34 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0DDC061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 10:34:08 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id g17so19132370ybe.13
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 10:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MsoqQQ4ecuvv+wgmnqQ4ZGCRyiGu1Rpd5uUcGXp3oLk=;
        b=sP4e0zO9SY/6hlTWJBEoahZfbos89Nlth36hDotJM6hCA3NqjVLGeVBcW+Z7/oWD78
         CfGKBMBQPG6ue70l53tv1QR3szAlpnWL1ZTQHAEDw63fAAWkEFQAlPzDhHruzMDiQn/O
         +CR8ovfb7dYeaGDJI78T+8p2EQGl15rZ9UU5vaM3tR1vk42j/vKjhduqnzJ/DY+o4KRu
         /lM8VVCkxp7OoMXZc2F8Fy+Dzpw4R2QnPcV06bWPtbU3ExUOceA1sFhZMhI6GRmMTf3y
         U9dDFCk2itMQlQS16S7fbv5JmGx1LC5jxcRouiQmxeFJx/SFziqHL3SmTckrASkBMTsf
         Ku3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MsoqQQ4ecuvv+wgmnqQ4ZGCRyiGu1Rpd5uUcGXp3oLk=;
        b=m5DpdfO42lqQ3MYF+LjCqm/N4X/16x9EpTgfHUjGjadpYpa+acCMSEwr9CBbaA+PpU
         p1qHbMy6bkG12+ciBBomgkovb8PdOu6pQHUa4FjaTEhN0Vm45hqg2hMpWh/FN5RJxQBp
         FY1j1SZX6HjEK/jgRYpRsSL0D3zpb7a+pKJr7kp5yGIjMWtuC3jUFhGH0Ks6Xpy4VUHa
         SzY7riZXE2//oXI1mzvdHvAbm1IW/8sRmjGY1rN8DtJ5V+LjYcSCfNnc6sWFHrOvPP9P
         TvZFRfo/ToouRBTwB3XFxy+QXpEkYKLiuT1pk57/TvrURDQNStwZaPcBwALiuK4rChfT
         AIDA==
X-Gm-Message-State: AOAM5309rxkmwZlpzporeU9XuuIuFul9EdDUNZtdWAYHqo3xfnnFqUVg
        61YykMnzC42uEpIhB8qQvOps1GSTNF9XVqyh9RGOxkkRaSs=
X-Google-Smtp-Source: ABdhPJxhUEdMT6tS/d9rBzgLQF9FYpfMB2R2kKG903Q/ENlCrYjoyGWImg8mNAExhbcewZsQt0ih3j4xHF2IcHOxk6w=
X-Received: by 2002:a25:df4f:: with SMTP id w76mr33354269ybg.711.1638642847108;
 Sat, 04 Dec 2021 10:34:07 -0800 (PST)
MIME-Version: 1.0
References: <20211203185238.2011081-1-eric.dumazet@gmail.com>
 <202112041104.gPgP3Z6U-lkp@intel.com> <CANn89i+m2O9EQCZq5r39ZbnE2dO82pxnj-KshbfWjNH3a5zqWQ@mail.gmail.com>
 <d85835b339f345c2b5acd67b71f4b435@AcuMS.aculab.com>
In-Reply-To: <d85835b339f345c2b5acd67b71f4b435@AcuMS.aculab.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 4 Dec 2021 10:33:55 -0800
Message-ID: <CANn89i+bondpbSEbXp5jF6_keYMGNfwAS8YXQBYMNyKgGb3WEA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: fix recent csum changes
To:     David Laight <David.Laight@aculab.com>
Cc:     kernel test robot <lkp@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        David Lebrun <dlebrun@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 4, 2021 at 6:00 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Eric Dumazet
> > Sent: 04 December 2021 04:41
> >
> > On Fri, Dec 3, 2021 at 7:34 PM kernel test robot <lkp@intel.com> wrote:
> > >
> > > I love your patch! Perhaps something to improve:
> ...
> >
> > Yes, keeping sparse happy with these checksum is not easy.
> >
> > I will add and use this helper, unless someone has a better idea.
> >
> > diff --git a/include/net/checksum.h b/include/net/checksum.h
> > index 5b96d5bd6e54532a7a82511ff5d7d4c6f18982d5..5218041e5c8f93cd369a2a3a46add3e6a5e41af7
> > 100644
> > --- a/include/net/checksum.h
> > +++ b/include/net/checksum.h
> > @@ -180,4 +180,8 @@ static inline void remcsum_unadjust(__sum16 *psum,
> > __wsum delta)
> >         *psum = csum_fold(csum_sub(delta, (__force __wsum)*psum));
> >  }
> >
> > +static inline __wsum wsum_negate(__wsum val)
> > +{
> > +       return (__force __wsum)-((__force u32)val);
> > +}
> >  #endif
>
> I was thinking that the expression also requires some comments.
> So maybe put a #define / static inline in checksum.h like:
>
> /* Subract the checksum of a buffer.
>  * The domain is __wsum is [1..~0u] (ie excludes zero)
>  * so ~csum_partial() cannot be used.
>  * The two's compliment gives the right answer provided the old 'csum'
>  * isn't zero - which it shouldn't be. */
> #define csum_partial_sub(buf, len, csum) (-csum_partial(buf, len, -(csum))
>
> and then add the annotations there to keep sparse happy there.
>
> will sparse accept '1 + ~csum' ? The compiler should use negate for it.
> It actually makes it slightly more obvious why the code is right.

Sparse is not happy with  1 + ~csum,

So we unfortunately would need something ugly like

(__force __wsum)(1 + ~(__force u32)csum)

Which most readers of this code will not find obvious.


>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
