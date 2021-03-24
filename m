Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EEB346F66
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 03:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234844AbhCXCWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 22:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbhCXCVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 22:21:52 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC87DC061763
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 19:21:51 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id u21so12361940ejo.13
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 19:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vm7Trzr3UXMzMsWRo+QhPtYKpWMPwZW78mIyQrebMTk=;
        b=Plz8gBmPbWsfS1tkeKAElCneUOPEdVI3PMQyXcY9iEWvXz/qHvABPnqLcUoCb/ah7g
         jSj9X+WSiekv+egmcDNUCGkywrHow91dWEUOAnakpslPiGVzxZqrUyFN/wJ3EorqaXze
         o9PBWQXEzHj8TM/yiQA2mKXO9BO6g2t/Vz/5nybidypaoD0r7PfmSSfg/2vq5w76GqcC
         3V6hHrCwtRWjDAVVqupx2NR5yIVItxpV3U2a8TbHoRQAETwQGOSegVU8mmfR73bWqV0y
         M1v1R/cCu04CIsC2jb8NeG5D9dzqs1Jx9ULPy73o10Eh2MZMhto12DmYG7sKaTvmkFFJ
         a93g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vm7Trzr3UXMzMsWRo+QhPtYKpWMPwZW78mIyQrebMTk=;
        b=O1OBDiWsSWQegOXSbwRThH9o1ebOQ4jTZFNN+UOP/pMc5zBqvdvbDBkMcgjk42AYvf
         ixEVlKSQ2vAY4nhI07zmQCpWNQnp9d1HNFj6KGX081CEbKnsINWP5Rv818PY61HN6qFG
         Zpc+1Ji/tOcBfOqGtBnH1qdYR6gMwjZtn4K/9LLpMW/uDyIINyjBxx3f7bzJJq1g3TqN
         FvQGKaZPeY1D32FrAP2be0Vujz13dhbz1A89zEooiVAwd2+H+PoiwQukpDkEKLqsACas
         8Qcdiz+eoOtUOIj3b/l8yQA4L0bT4O5yN2xbwlV7CGhQZ5Gs5/Ed+GSiO+4r5TOr1t/y
         bXfg==
X-Gm-Message-State: AOAM5337icCBS1d+Mu9ZO6xlzYHaSwKxiDLKe4XsFOdhCtRAa+7b1DTJ
        +him7gOk95y5uxYNDTSmJMGx5GjGhMA=
X-Google-Smtp-Source: ABdhPJz+HIa32shdwT3VTXmiBhe5mpEN/3qHUu0QgrodxvZ+WoI4Rkpt/3fz7kl/qL9V3bpcROEgTA==
X-Received: by 2002:a17:906:f203:: with SMTP id gt3mr1168996ejb.346.1616552509992;
        Tue, 23 Mar 2021 19:21:49 -0700 (PDT)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com. [209.85.221.51])
        by smtp.gmail.com with ESMTPSA id h22sm231807eji.80.2021.03.23.19.21.49
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 19:21:49 -0700 (PDT)
Received: by mail-wr1-f51.google.com with SMTP id e18so22840097wrt.6
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 19:21:49 -0700 (PDT)
X-Received: by 2002:a05:6000:1803:: with SMTP id m3mr885715wrh.50.1616552508658;
 Tue, 23 Mar 2021 19:21:48 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616345643.git.pabeni@redhat.com> <c77bb9511c1c10193cc05651ed785506d6aee3e8.1616345643.git.pabeni@redhat.com>
 <CA+FuTSefLQ07od6Et6H2wO=p8+V2F28VYix4EgghHz6R0Bn9nw@mail.gmail.com> <22bec3983ac3849298fbc15f6284f7643cbe4907.camel@redhat.com>
In-Reply-To: <22bec3983ac3849298fbc15f6284f7643cbe4907.camel@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 23 Mar 2021 22:21:10 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfhU9ng6DuC7W6D8=OTk=5SJpqdz+xrQ12GYg4VtrdDZA@mail.gmail.com>
Message-ID: <CA+FuTSfhU9ng6DuC7W6D8=OTk=5SJpqdz+xrQ12GYg4VtrdDZA@mail.gmail.com>
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

On Mon, Mar 22, 2021 at 1:12 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Mon, 2021-03-22 at 09:42 -0400, Willem de Bruijn wrote:
> > On Sun, Mar 21, 2021 at 1:01 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > Currently the UDP protocol delivers GSO_FRAGLIST packets to
> > > the sockets without the expected segmentation.
> > >
> > > This change addresses the issue introducing and maintaining
> > > a per socket bitmask of GSO types requiring segmentation.
> > > Enabling GSO removes SKB_GSO_UDP_L4 from such mask, while
> > > GSO_FRAGLIST packets are never accepted
> > >
> > > Note: this also updates the 'unused' field size to really
> > > fit the otherwise existing hole. It's size become incorrect
> > > after commit bec1f6f69736 ("udp: generate gso with UDP_SEGMENT").
> > >
> > > Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
> > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > ---
> > >  include/linux/udp.h | 10 ++++++----
> > >  net/ipv4/udp.c      | 12 +++++++++++-
> > >  2 files changed, 17 insertions(+), 5 deletions(-)
> > >

> > >         /*
> > >          * Following member retains the information to create a UDP header
> > >          * when the socket is uncorked.
> > > @@ -68,7 +68,10 @@ struct udp_sock {
> > >  #define UDPLITE_SEND_CC  0x2           /* set via udplite setsockopt         */
> > >  #define UDPLITE_RECV_CC  0x4           /* set via udplite setsocktopt        */
> > >         __u8             pcflag;        /* marks socket as UDP-Lite if > 0    */
> > > -       __u8             unused[3];
> > > +       __u8             unused[1];
> > > +       unsigned int     unexpected_gso;/* GSO types this socket can't accept,
> > > +                                        * any of SKB_GSO_UDP_L4 or SKB_GSO_FRAGLIST
> > > +                                        */
> >
> > An extra unsigned int for this seems overkill.
>
> Should be more clear after the next patch.
>
> Using an explicit 'acceptable GSO types' field makes the patch 5/8
> quite simple.
>
> After this patch the 'udp_sock' struct size remains unchanged and even
> the number of 'udp_sock' cachelines touched for every packet is
> unchanged.

But there is opportunity cost, of course. Next time we need to add
something to the struct, we will add a new cacheline.

A 32-bit field for just 2 bits, where 1 already exists does seem like overkill.

More importantly, I just think it's less obvious code than a pair of fields

  accepts_udp_l4:1,
  accepts_udp_fraglist:1,

Local sockets can only accept the first, as there does not exist an
interface to pass along the multiple frag sizes that a frag_list based
approach might have.

Sockets with encap_rcv != NULL may opt-in to being able to handle either.

I think explicit code will be more maintainable. At the cost of
perhaps two branches instead of one, admittedly. But that seems
premature optimization.
