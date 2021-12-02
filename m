Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3BF465AF6
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 01:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354618AbhLBAgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 19:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354603AbhLBAgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 19:36:21 -0500
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E5AC06174A
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 16:33:00 -0800 (PST)
Received: by mail-ua1-x936.google.com with SMTP id p37so52656316uae.8
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 16:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b4P4AFmr1o0CqAks59ddkKqik87nG6DMLLaOOd9eVYk=;
        b=my6PTohKFXRmgj6IzicPnG6u+cLQoki2itaX4sIy9PYIqrePDhe3gf47l/FJceEey4
         bei2DhI0JypIGaShAKQuS7R4slv2W7CQ6LcFcXISr2vofqNkyRsorI48MgPet3Vnv4tp
         StOyhNrWft2X2Jxq+O9rWeDZwDfkTS8i0N+Uso17H0srStfzVuhZ6dmzBdbulz6rhr0y
         aK+zRO672La+kJgvZEy3vs2/NptH4YDb8vcJ9cEcIFaD2evtRCtPTpWwHHt9bRahrOGp
         8SBCEhwCc/UVDbWy1bzO9HkfeCYdlUH1PAkwdK4XTH1IOyV9j+3BqK1E7EPxOvN1/Mlh
         IE7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b4P4AFmr1o0CqAks59ddkKqik87nG6DMLLaOOd9eVYk=;
        b=0lYllA0svmiY7I8OMN/1Hwj7HJmba7HZSXkpqr8mMpqFUPGRevVo14JQh+EBErDlPd
         znN7W1TYzk/c1eNUh2Q7+bKf+kH9MOSjHu1ZjFbncyIuTe9yvlZ3pFyX+dek+vL4yiJP
         qD8DAh+U55FBVS933lhQiz8pTzcYfOmgMBChy9ZRfEnxf+Y33mysGmyI4wT3YrXXvUlg
         +vXCLgh4B1SeV3Sjf4SotkI4YfbeSx4RUGeRLATKdG+Dw/PS0ZW7TNJzdlJMq1Px4l5z
         FnKI4G2/DPGyiH/YFu3z43k5KwEpjqjGvIB1i4HyN35fWvTE5lepIMJ2qx5oaXEOfJ/J
         UFZQ==
X-Gm-Message-State: AOAM5303ovZT/xSu78XyCszn9Jz7miuCcNKOwHIsONcutAvp2a/A//fc
        S5WMS7hrsmHIHG5giyoM9G4vQK7P3MuPYQ==
X-Google-Smtp-Source: ABdhPJwBjnAARWqtdPRlSQWnxm/EmLcvSGlWxVHKXId4DcwdBuwJ/T9qvvy/gep01zg7CVi7/fkvuQ==
X-Received: by 2002:a67:2f05:: with SMTP id v5mr12280181vsv.25.1638405179605;
        Wed, 01 Dec 2021 16:32:59 -0800 (PST)
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com. [209.85.222.50])
        by smtp.gmail.com with ESMTPSA id r13sm432789vkl.13.2021.12.01.16.32.58
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 16:32:58 -0800 (PST)
Received: by mail-ua1-f50.google.com with SMTP id i6so52593370uae.6
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 16:32:58 -0800 (PST)
X-Received: by 2002:a05:6102:3053:: with SMTP id w19mr7289791vsa.60.1638405178379;
 Wed, 01 Dec 2021 16:32:58 -0800 (PST)
MIME-Version: 1.0
References: <cover.1638282789.git.asml.silence@gmail.com> <CA+FuTSf-N08d6pcbie2=zFcQJf3_e2dBJRUZuop4pOhNfSANUA@mail.gmail.com>
 <0d82f4e2-730f-4888-ec82-2354ffa9c2d8@gmail.com>
In-Reply-To: <0d82f4e2-730f-4888-ec82-2354ffa9c2d8@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 1 Dec 2021 19:32:21 -0500
X-Gmail-Original-Message-ID: <CA+FuTSf1dk-ZCN_=oFcYo31XdkLLAaHJHHNfHwJKe01CVq3X+A@mail.gmail.com>
Message-ID: <CA+FuTSf1dk-ZCN_=oFcYo31XdkLLAaHJHHNfHwJKe01CVq3X+A@mail.gmail.com>
Subject: Re: [RFC 00/12] io_uring zerocopy send
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> # discussion / questions
> >>
> >> I haven't got a grasp on many aspects of the net stack yet, so would
> >> appreciate feedback in general and there are a couple of questions
> >> thoughts.
> >>
> >> 1) What are initialisation rules for adding a new field into
> >> struct mshdr? E.g. many users (mainly LLD) hand code initialisation not
> >> filling all the fields.
> >>
> >> 2) I don't like too much ubuf_info propagation from udp_sendmsg() into
> >> __ip_append_data() (see 3/12). Ideas how to do it better?
> >
> > Agreed that both of these are less than ideal.
> >
> > I can't comment too much on the io_uring aspect of the patch series.
> > But msg_zerocopy is probably used in a small fraction of traffic (even
> > if a high fraction for users who care about its benefits). We have to
> > try to minimize the cost incurred on the general hot path.
>
> One thing, I can hide the initial ubuf check in the beginning of
> __ip_append_data() under a common
>
> if (sock_flag(sk, SOCK_ZEROCOPY)) {}
>
> But as SOCK_ZEROCOPY is more of a design problem workaround,
> tbh not sure I like from the API perspective. Thoughts?

Agreed. io_uring does not have the legacy concerns that msg_zerocopy
had to resolve.

It is always possible to hide runtime overhead behind a static_branch,
if nothing else.

Or perhaps do pass the flag and use that:

  - if (flags & MSG_ZEROCOPY && length && sock_flag(sk, SOCK_ZEROCOPY)) {
  + if (flags & MSG_ZEROCOPY && length) {
  +         if (uarg) {

  etc.


> I hope
> I can also shuffle some of the stuff in 5/12 out of the
> hot path, need to dig a bit deeper.
>
> > I was going to suggest using the standard msg_zerocopy ubuf_info
> > alloc/free mechanism. But you explicitly mention seeing omalloc/ofree
> > in the cycle profile.
> >
> > It might still be possible to somehow signal to msg_zerocopy_alloc
> > that this is being called from within an io_uring request, and
> > therefore should use a pre-existing uarg with different
> > uarg->callback. If nothing else, some info can be passed as a cmsg.
> > But perhaps there is a more direct pointer path to follow from struct
> > sk, say? Here my limited knowledge of io_uring forces me to hand wave.
>
> One thing I consider important though is to be able to specify a
> ubuf per request, but not somehow registering it in a socket. It's
> more flexible from the userspace API perspective. It would also need
> constant register/unregister, and there are concerns with
> referencing/cancellations, that's where it came from in the first
> place.

What if the ubuf pool can be found from the sk, and the index in that
pool is passed as a cmsg?
