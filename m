Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 983316BC199
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 00:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbjCOXkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 19:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233732AbjCOXkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 19:40:20 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F248AA701
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:38:34 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-5416698e889so277808087b3.2
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678923445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dHrvVwIWp49Bk9eZeESJ106vHxBrFF69Ev6yIqFp/SA=;
        b=XFvDVVC1r4aXGy/a07g3koptGVFUkmcmzXauDJ87lnwJjxWxfPXOHx1+faPktOEl+r
         w7j0hs7OqD2n9yx3TaxYFgL6w/MF3Og+4TAJW6uzjVpa1ldtCXqDcbMqIaaM8B7WcdZb
         OChIXg5Z1qnoNxT4mn+QHvIFbsUWBeOAra1S97rrOsm5G93M5qbV3q44/WIvXftEfsC4
         tPmW3M+A6PS/NPLK5VvcF2I2ckYvyEgxNL2Kr+58GVe0Yu6ULsqIR/O5OzEKbUe0ozKD
         g6kmDySbT2KYyZUBPxZB2PTz/L9kpNcanUSbnDZUm+yZQn2rWCqgkThvPukNjpF081G6
         IV6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678923445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dHrvVwIWp49Bk9eZeESJ106vHxBrFF69Ev6yIqFp/SA=;
        b=ul+FKdwZWg9EaeAmp9hcvuV7KIbhaDK8XDNimhos7WKiarfgqbp75xKKe+QXMXL1t9
         ONFemrUxze4lDgbngyZ+3wM4bjLqsFiDbH3ihDOtBSmjeR5mXtnDAj2y3RXlZnEgfKDC
         xjQcmGx2xepGsD1ZNmDngPjU+JzAuypwi3VhQ0fGI/X9YTEhvLhiguGpRzluzl07Divg
         2jdyjtFare2Hwp5LQgRLfk/6DUZfy48mpgSA3AWYthqrvea9ijU2848JsAky7S/rb8ys
         iAZBKbZ3ExK6zYQhhlV98WRGNrO8tqKP8cA7ASS8Q5vFZNl7Nzp1VAEhHwOUC0KY67AH
         K7gg==
X-Gm-Message-State: AO0yUKV8/B6CXudyL2mH0fs3jcoEi7+D1NBu7AtEq+ROFxa9k+3avFW+
        Gz7GiTvGD5QnHvSu1g8XDxFBM/v47x893T69rLWzXg==
X-Google-Smtp-Source: AK7set8TYWloaNpsAkkIgiZKGft8ylJN/JpBqTjMMunboHI/hJhYxELd6Cu5q22yTj0LG4C66sq+qreLYGLea8jWC1c=
X-Received: by 2002:a81:ca4b:0:b0:52e:e095:d840 with SMTP id
 y11-20020a81ca4b000000b0052ee095d840mr1057155ywk.0.1678923445121; Wed, 15 Mar
 2023 16:37:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230315154245.3405750-1-edumazet@google.com> <20230315154245.3405750-2-edumazet@google.com>
 <20230315142841.3a2ac99a@kernel.org> <CANn89iLbOqjWVmgZKdGjbdsHw1EwO9d_w+dgKsyzLoq9pOsurQ@mail.gmail.com>
 <CAHk-=wiPUfe8aji5KojAhDKjWhJJU2F9kfzyL660=jRkY+Uzyg@mail.gmail.com>
In-Reply-To: <CAHk-=wiPUfe8aji5KojAhDKjWhJJU2F9kfzyL660=jRkY+Uzyg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 15 Mar 2023 16:37:14 -0700
Message-ID: <CANn89iKA3E0CnXD=3EmP8-Ojav-tYEFeBaBu3B7CgzPaX6EC6A@mail.gmail.com>
Subject: Re: [PATCH net-next 1/8] inet: preserve const qualifier in inet_sk()
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Wed, Mar 15, 2023 at 4:21=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, Mar 15, 2023 at 3:38=E2=80=AFPM Eric Dumazet <edumazet@google.com=
> wrote:
> >
> > Maybe something like this?
>
> Please no.
>
> > +#define promote_to_type(ptr, oldtype, newtype)                 \
> > +       _Generic(ptr,                                           \
> > +                const oldtype *: ((const newtype *)(ptr)),     \
> > +                oldtype *: ((newtype *)(ptr))                  \
> > +       )
>
> That's just a very ugly way to just do a cast. It's wrong.
>
> > +#define inet_sk(sk) promote_to_type(sk, struct sock, struct inet_sock)
>
> This is horrid.
>
> Why isn't this just doing
>
>    #define inet_sk(ptr) container_of(ptr, struct inet_sock, sk)
>
> which is different from a plain cast in that it actually checks that
> "yes, struct inet_sock has a member called 'sk' that has the right
> type, so now we can convert from that sk to the containing structure".
>
> That's very different from just randomly casting a pointer to another
> pointer, like the current inet_sk() does, and like that disgusting
> promote_to_type() macro does.
>
> We really strive for proper type safety in the kernel. And that very
> much means *not* doing random casts.
>
> At least that "inet_sk(sk)" version using generics didn't take random
> pointer types. But I really don't see why you don't just use
> "container_of()", which is actually type-safe, and would allow "struct
> inet_sock" to contain the "struct sock" somewhere else than in the
> first field.
>
> Hmm? Am I missing something that is happening in linux-next?


Yep. my goal was to have const awareness.

https://patchwork.kernel.org/project/netdevbpf/patch/20230315154245.3405750=
-2-edumazet@google.com/

(and whole series in
https://patchwork.kernel.org/project/netdevbpf/list/?series=3D730398&state=
=3D*
)

This:

#define inet_sk(ptr) container_of(ptr, struct inet_sock, sk)

does not really cover what I wanted, does it ?

>
>                 Linus
