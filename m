Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698163B24EA
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 04:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhFXC00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 22:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbhFXC0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 22:26:25 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365FFC061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 19:24:07 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id gt18so6964908ejc.11
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 19:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rVvtMQYXM1F8JMRUz4usVQmC96HluIpODkLNrUEf8w8=;
        b=a8ph9LEFzssBrwLcRljFTgAfZOuywYiIVyZ7/3OJnfW8beGoA1z7yFqdhkqOPtvd0h
         N/G+DdUCVxROR/wtjiI0azT0DQNnixDwKiAMmxnx8h9dZAMylNfM6UCbGBIJNV4xjHZs
         nqNJy60b7LcYnHeC/0ZW/P9KcYRm47qcecnsOH0yrWs2R2d28W/wzyThmV2djnOEosqW
         xCysU9Xl8onE7R0oNxBeRQc28GAGjAkM3acm0Hr9dgHKqJJMIUOym1YCeqrH2+KID2V+
         9ZPSflQanb3TvvkFcWFWLjXMcMmAVRE1Jf7pPjUcLD5NG2wNPrA0yocwQWKPqLV366UV
         4Ayg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rVvtMQYXM1F8JMRUz4usVQmC96HluIpODkLNrUEf8w8=;
        b=MfoQHOf4ZRJri/OF4f0YF9KMmVEBa/g6fysoPQbuPQm5Vksr5SYUJIiE0FjU2D7seb
         JP0468QcLQaijs/v/XjVxkhy2VBYIPRuXDpX3xHNRgnANyAJAIhpSIQ6G+xB+tGfTeEf
         yL25MuQ9Ybn1SZNrnlGBnnKhqybOGxNA1PSp6FrbUHfvES7cmBJdS+AIWHvSNQXTfeci
         I9Uth5Fi0c5zwOeNH1L9J43nXWaHWfzbnTf8hxvGQCPi6muD9bhGvVDjLzorEPupSOXI
         nCDN43XXGcZDisyouYiYLhxUbDGNui4ZXIKzldoMLxs8eijOUMWLmciNXCKx1rFH2enW
         /e0g==
X-Gm-Message-State: AOAM530a18eiY9Cqf9XLRAsKjWUvdhv+WfvIOt584gPbG2rAfNnKUPvQ
        9fc1QZU6iEFukPzb3B1uHPRncLDnRCrGzA==
X-Google-Smtp-Source: ABdhPJzgYDZUpMwIylyZdPiWHkd3uy9QRORtTiCrxINCWWsgi8boCutcFJiZcqM0O5Ic3FsEL7MGSQ==
X-Received: by 2002:a17:907:c87:: with SMTP id gi7mr2915685ejc.452.1624501445863;
        Wed, 23 Jun 2021 19:24:05 -0700 (PDT)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com. [209.85.128.45])
        by smtp.gmail.com with ESMTPSA id yc20sm564607ejb.5.2021.06.23.19.24.05
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 19:24:05 -0700 (PDT)
Received: by mail-wm1-f45.google.com with SMTP id u8-20020a7bcb080000b02901e44e9caa2aso2464582wmj.4
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 19:24:05 -0700 (PDT)
X-Received: by 2002:a7b:c104:: with SMTP id w4mr1248068wmi.87.1624501444663;
 Wed, 23 Jun 2021 19:24:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210623162328.2197645-1-kuba@kernel.org> <20210623214555.5c683821@carbon>
 <20210623140717.22997203@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210623140717.22997203@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 23 Jun 2021 22:23:28 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdHRsEH-tmXr=H_LqJ+o0T0crmdD5GPqvOQP9DEvYgBNg@mail.gmail.com>
Message-ID: <CA+FuTSdHRsEH-tmXr=H_LqJ+o0T0crmdD5GPqvOQP9DEvYgBNg@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net: ip: avoid OOM kills with large UDP sends
 over loopback
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, davem@davemloft.net,
        netdev@vger.kernel.org, eric.dumazet@gmail.com, dsahern@gmail.com,
        yoshfuji@linux-ipv6.org, Dave Jones <dsj@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 5:07 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 23 Jun 2021 21:45:55 +0200 Jesper Dangaard Brouer wrote:
> > > diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> > > index c3efc7d658f6..790dd28fd198 100644
> > > --- a/net/ipv4/ip_output.c
> > > +++ b/net/ipv4/ip_output.c
> > > @@ -1077,7 +1077,9 @@ static int __ip_append_data(struct sock *sk,
> > >                     if ((flags & MSG_MORE) &&
> > >                         !(rt->dst.dev->features&NETIF_F_SG))
> > >                             alloclen = mtu;
> > > -                   else if (!paged)
> > > +                   else if (!paged &&
> > > +                            (fraglen + hh_len + 15 < SKB_MAX_ALLOC ||
> >
> > What does the number 15 represent here?
>
> No idea, it's there on the allocation line, so I need to include it on
> the size check.
>
> Looking at super old code (2.4.x) it looks like it may have gotten
> copy & pasted mistakenly? The hard headers are rounded up to 16B,
> and there is code which does things like:
>
>         skb_alloc(size + dev->hard_header_len + 15);
>         skb_reserve(skb, (dev->hard_header_len + 15) & ~15);
>
> in other spots. So if I was to guess I'd say someone decided to add the
> 15B "to be safe" even though hh_len already includes the round up here.

The 15 seems to come from alignment indeed. Not sure when it was
introduced, but until 56951b54e87a there is also this

                /*
                 *      Get the memory we require with some space left
for alignment.
                 */

                skb = sock_alloc_send_skb(sk, fraglen+hh_len+15, 0,
flags&MSG_DONTWAIT, &err);
