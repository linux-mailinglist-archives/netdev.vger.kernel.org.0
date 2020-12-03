Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704B72CCAFB
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 01:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgLCAZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 19:25:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLCAZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 19:25:52 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970A3C0613D6
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 16:25:06 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id f14so110774pju.4
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 16:25:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lCAFZtoVd0pJkTf4tY/zYmd8iM9rj8MlFqyLk5BHZjQ=;
        b=X1bYSNjnuQMTtDKrR1dQtrUtgOoaBCSNp+ur41g2lV8QNVOKe9IciMSuNqxcL022kZ
         xDAwc97JtGvSVfDeg+q8E/dzd0nQXX+SkcVvfx3WyI9dNFFza4jATCxAj3/+XOqlife5
         PxJVKVpdBDoJ6xOGBRwK7f4bKqd35Mn8E9MbYuvFunB1wcZmmyvEnwZZVju76qG8tw5T
         AsktVzUlclKno/SIEbqR8yqp9qH5GEort9QjqKxkQkHPUWwE+oi1cMRijvY8Jk74gFX2
         X5ld9dVmdhTzWu4J3TUPvX1DatCdJjA+IBgniUO8xFXU+72TE8V24EfTyWdplMRPzaS8
         790g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lCAFZtoVd0pJkTf4tY/zYmd8iM9rj8MlFqyLk5BHZjQ=;
        b=oQh/OgnkWwOC7sWBfGaiEH0xK9h+rAW41fyYcAkfzMCdmBO3FbwRCYBZk6Way+tuRO
         6NztLiL/9BtY3mGRQo0jdHWwO+IseUTOCYCuEQFPnxErM/8SjpJda8kai1HKAZJgY3li
         KTdkJhQ5angkf9YJ75eT7aav1mTUSx40lIaSrqEy6XeSPlDCf1PreLPJlMlyE6sV1pEM
         e60kJ2q7v2HmWOxuNuj5M8s72CuSwoqc4Mg8mop72Dss5NlgMg7HPCjR2ddqXvuub6YC
         zwl2UNjaxncOlkoz5GyXuCeG/HeJGWidjliaTOVIqkRrItpAAi4VqUR04GAwc6vDWLAd
         9A1w==
X-Gm-Message-State: AOAM533VB91HdCv/R3nFiOIisUxvFkZHfSW+xdQettsBU6HUP9+/JJdk
        Uw9vICfZEZ3Mc8z7QT8SxK0TCfkBcIEcgHgBk/PAOg==
X-Google-Smtp-Source: ABdhPJyoTMX5hWd3W1YWLNUB+c0MLW4iO5GioxWlGmaZr9V2c0BVzSNv+HhJRvYIRpUxaWQjl3bYnLV3z3GpycgbWps=
X-Received: by 2002:a17:902:9049:b029:d5:eadd:3d13 with SMTP id
 w9-20020a1709029049b02900d5eadd3d13mr576135plz.15.1606955105648; Wed, 02 Dec
 2020 16:25:05 -0800 (PST)
MIME-Version: 1.0
References: <20201202220945.911116-1-arjunroy.kdev@gmail.com>
 <20201202220945.911116-2-arjunroy.kdev@gmail.com> <20201202161527.51fcdcd7@hermes.local>
In-Reply-To: <20201202161527.51fcdcd7@hermes.local>
From:   Arjun Roy <arjunroy@google.com>
Date:   Wed, 2 Dec 2020 16:24:54 -0800
Message-ID: <CAOFY-A3zsv2Ui9dqHVOoY3JNgedfs1H0qt0q6BipbFpYrFBfXg@mail.gmail.com>
Subject: Re: [net-next v2 1/8] net-zerocopy: Copy straggler unaligned data for
 TCP Rx. zerocopy.
To:     stephen@networkplumber.org
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 2, 2020 at 4:15 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Wed,  2 Dec 2020 14:09:38 -0800
> Arjun Roy <arjunroy.kdev@gmail.com> wrote:
>
> > diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
> > index cfcb10b75483..62db78b9c1a0 100644
> > --- a/include/uapi/linux/tcp.h
> > +++ b/include/uapi/linux/tcp.h
> > @@ -349,5 +349,7 @@ struct tcp_zerocopy_receive {
> >       __u32 recv_skip_hint;   /* out: amount of bytes to skip */
> >       __u32 inq; /* out: amount of bytes in read queue */
> >       __s32 err; /* out: socket error */
> > +     __u64 copybuf_address;  /* in: copybuf address (small reads) */
> > +     __s32 copybuf_len; /* in/out: copybuf bytes avail/used or error */
> >  };
> >  #endif /* _UAPI_LINUX_TCP_H */
>
> You can't safely grow the size of a userspace API without handling the
> case of older applications.  Logic in setsockopt() would have to handle
> both old and new sizes of the structure.

Acknowledged, but tcp zerocopy receive is a special case: it does not
exist in setsockopt().
Regarding old applications in the getsockopt() case: the current
layout should handle older and newer callers as is (it devolves to
only use the features the application provides buffer space for).

Please note also v3 for this patchset; it's the same as this but I
forgot the signed-off-by statements here in v2.

Thanks,
-Arjun
