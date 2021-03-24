Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB881348467
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 23:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238740AbhCXWN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 18:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238745AbhCXWNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 18:13:11 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76718C06174A
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 15:13:10 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id x21so209219eds.4
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 15:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s6wMBFgXbT/6Nm9J0MgyCyQctgOJ/PucAd/7ao/VXl8=;
        b=AUP1JuNWz3qXbIBa5p+n4xQ6IXAmHgSMnKg/W4F0Et5sbdKltXGBJUHazB7nfOayeD
         W8VBRtMk8L3jbDU1S6XiE7KRb5P46J7lxNAIXzeCQd3biZiwk0bR9mO7rZydIi7Ck1Yl
         QI76H32ww9+iMnUoa4O8GH1Ju6P48KZIG+DIby2v+q5jVObMxQ+hgHGzkTturQJwU8tJ
         HaoxFwtKAVRZFqJUgOtf4phImQjCMWdvCIcaMfHBTzxl3j5EHWHiNKfy1IzHyXQBXAzp
         E4uCTjS/W3NYXLtm+Ej6oNuXkBTxoYbpa57yqjM5+PwRifAIseLibdD/JM2r25cVqeTS
         eWNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s6wMBFgXbT/6Nm9J0MgyCyQctgOJ/PucAd/7ao/VXl8=;
        b=gQV2ub27XM+5B5gye+JvSrI2zw2mEPTK98h/kdHM+wB3eN1kHyfCFN6h3noyQq1mrj
         6q+aRj0QBKWaai2Lj+FxBoAElL8RcxTjsxkwgmr5fnEytDzvVNUW3CjK+MacFJC0yc4z
         SCo6VjPE9+BopRhx532BgEwNRR4i6CT6TQ8Ie7DkQXbmdJeI3DWbqiKSw7QY+gWV6/N3
         5N0mC6j8Gh+MCEQuAPioFFS3q0f2YGi3Myf+ghDL/es0iIsU4C/pr/Rr1kctwbioLyPb
         rdN9YUZysfp3a7aYWFY6QMqe0mglPkf59z/hJHJuxpcjYXUxii+iis7ilSaYwzqOV4ji
         TH7Q==
X-Gm-Message-State: AOAM5301WJlkNijUXMYrChfk6zNhAqFokq5QlJk4pJqUFTa6bDV5PUa3
        zJnpqoFpF9o2qBpw77TNCiGLJlxHr58=
X-Google-Smtp-Source: ABdhPJyvnRWlaTHgQNN95Ndr6DAC3sCEVb89WmUTYd/5kv59J/GQaXOLAdXQyOheTfhrpVGPbOLr/A==
X-Received: by 2002:a05:6402:888:: with SMTP id e8mr5650607edy.51.1616623988610;
        Wed, 24 Mar 2021 15:13:08 -0700 (PDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id q16sm1518922ejd.15.2021.03.24.15.13.07
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 15:13:07 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id j7so351600wrd.1
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 15:13:07 -0700 (PDT)
X-Received: by 2002:a05:6000:1803:: with SMTP id m3mr5724805wrh.50.1616623986696;
 Wed, 24 Mar 2021 15:13:06 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616345643.git.pabeni@redhat.com> <c77bb9511c1c10193cc05651ed785506d6aee3e8.1616345643.git.pabeni@redhat.com>
 <CA+FuTSefLQ07od6Et6H2wO=p8+V2F28VYix4EgghHz6R0Bn9nw@mail.gmail.com>
 <22bec3983ac3849298fbc15f6284f7643cbe4907.camel@redhat.com>
 <CA+FuTSfhU9ng6DuC7W6D8=OTk=5SJpqdz+xrQ12GYg4VtrdDZA@mail.gmail.com> <73664dd000dcbb432358a6559acbbf6b21d64150.camel@redhat.com>
In-Reply-To: <73664dd000dcbb432358a6559acbbf6b21d64150.camel@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 24 Mar 2021 18:12:29 -0400
X-Gmail-Original-Message-ID: <CA+FuTSd4m811Xa0TY=9VTtO7yqPyO7S+ugPHkNwWojuBnJRpTA@mail.gmail.com>
Message-ID: <CA+FuTSd4m811Xa0TY=9VTtO7yqPyO7S+ugPHkNwWojuBnJRpTA@mail.gmail.com>
Subject: Re: [PATCH net-next 4/8] udp: never accept GSO_FRAGLIST packets
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 3:00 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Tue, 2021-03-23 at 22:21 -0400, Willem de Bruijn wrote:
> > On Mon, Mar 22, 2021 at 1:12 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > On Mon, 2021-03-22 at 09:42 -0400, Willem de Bruijn wrote:
> > > > On Sun, Mar 21, 2021 at 1:01 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > > Currently the UDP protocol delivers GSO_FRAGLIST packets to
> > > > > the sockets without the expected segmentation.
> > > > >
> > > > > This change addresses the issue introducing and maintaining
> > > > > a per socket bitmask of GSO types requiring segmentation.
> > > > > Enabling GSO removes SKB_GSO_UDP_L4 from such mask, while
> > > > > GSO_FRAGLIST packets are never accepted
> > > > >
> > > > > Note: this also updates the 'unused' field size to really
> > > > > fit the otherwise existing hole. It's size become incorrect
> > > > > after commit bec1f6f69736 ("udp: generate gso with UDP_SEGMENT").
> > > > >
> > > > > Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
> > > > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > > > ---
> > > > >  include/linux/udp.h | 10 ++++++----
> > > > >  net/ipv4/udp.c      | 12 +++++++++++-
> > > > >  2 files changed, 17 insertions(+), 5 deletions(-)
> > > > >
> > > > >         /*
> > > > >          * Following member retains the information to create a UDP header
> > > > >          * when the socket is uncorked.
> > > > > @@ -68,7 +68,10 @@ struct udp_sock {
> > > > >  #define UDPLITE_SEND_CC  0x2           /* set via udplite setsockopt         */
> > > > >  #define UDPLITE_RECV_CC  0x4           /* set via udplite setsocktopt        */
> > > > >         __u8             pcflag;        /* marks socket as UDP-Lite if > 0    */
> > > > > -       __u8             unused[3];
> > > > > +       __u8             unused[1];
> > > > > +       unsigned int     unexpected_gso;/* GSO types this socket can't accept,
> > > > > +                                        * any of SKB_GSO_UDP_L4 or SKB_GSO_FRAGLIST
> > > > > +                                        */
> > > >
> > > > An extra unsigned int for this seems overkill.
> > >
> > > Should be more clear after the next patch.
> > >
> > > Using an explicit 'acceptable GSO types' field makes the patch 5/8
> > > quite simple.
> > >
> > > After this patch the 'udp_sock' struct size remains unchanged and even
> > > the number of 'udp_sock' cachelines touched for every packet is
> > > unchanged.
> >
> > But there is opportunity cost, of course. Next time we need to add
> > something to the struct, we will add a new cacheline.
> >
> > A 32-bit field for just 2 bits, where 1 already exists does seem like overkill.
> >
> > More importantly, I just think it's less obvious code than a pair of fields
> >
> >   accepts_udp_l4:1,
> >   accepts_udp_fraglist:1,
> >
> > Local sockets can only accept the first, as there does not exist an
> > interface to pass along the multiple frag sizes that a frag_list based
> > approach might have.
> >
> > Sockets with encap_rcv != NULL may opt-in to being able to handle either.
> >
> > I think explicit code will be more maintainable.
>
> ok
>
> > At the cost of
> > perhaps two branches instead of one, admittedly. But that seems
> > premature optimization.
>
> well, if it don't hurt too much your eyes, something along the
> following could save udp_sock space and code branches:
>
>     rejects_udp_l4_fraglist:2;
>
> #define SKB_GSO_UDP_L4_SHIFT (NETIF_F_GSO_UDP_L4_BIT - NETIF_F_GSO_SHIFT)
>  static inline bool udp_unexpected_gso(struct sock *sk, struct sk_buff *skb)
>  {
>         BUILD_BUG_ON(1 << SKB_GSO_UDP_L4_SHIFT != SKB_GSO_UDP_L4);
>         BUILD_BUG_ON(1 << (SKB_GSO_UDP_L4_SHIFT + 1) != SKB_GSO_FRAGLIST);
>         return skb_is_gso(skb) && skb_shinfo(skb)->gso_type &
>                 (udp_sk(sk)->rejects_udp_l4_fraglist << SKB_GSO_UDP_L4_SHIFT);
>  }
>
> (not sure if /me runs/hides ;)

:)

My opinion is just one, but I do find this a lot less readable and
hence maintainable than

  if (likely(!skb_is_gso(skb)))
     return true;

  if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4 && !udp_sk(sk)->accept_udp_l4)
    return false;

  if (skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST &&
!udp_sk(sk)->accept_udp_fraglist)
    return false;

  return true;

at no obvious benefit. The tunnel gso code is hard enough to fathom as it is.

> /P
>
>
>
