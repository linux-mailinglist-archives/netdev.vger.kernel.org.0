Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAFA017382F
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 14:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgB1NUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 08:20:07 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35550 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgB1NUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 08:20:07 -0500
Received: by mail-ed1-f68.google.com with SMTP id c7so3336840edu.2
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 05:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a1o3ZaVxV/UHmnlqOInMF9HnyNuLw4+witDWbmSfAHA=;
        b=fY67vAMmBHerQM7XkvTQBkSA8tEf+aCHqDBjwlzp5a4bTCOvfypvTHAj/eaojnLgpC
         V0+x4GMOypHHEgXfD1t8O8qsBR/iRbzm6ukGvgnPNS39YyBh4c1F4r5dWQQ8wNXxJvE0
         cjU7yXLgSVLiUvLfB/ngIGRXrStBYZo2mQNeA4qs6oR6KnhRzFgurZq0RkEVC5ao11bZ
         aPLkKZ10jKrw/5QDiUmqA4dWZtCMucPm1f8fo1E3pgBCQIDF7t++cfKSWXScAmAFpOgZ
         BG5crqbc3wGq04qzPo04HjySY5if6xLywXFJw+5r7Y/pKWEM9y763qH/a38E2wKuE1Hg
         14Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a1o3ZaVxV/UHmnlqOInMF9HnyNuLw4+witDWbmSfAHA=;
        b=TvB0yP3Q9qvbo4LGr+qTFYQXsgAmP7QE07LeyQGsnhisXBPG81EqE2llUL79w6tmiV
         sWv17RlMRt26eGbEnG5Rft5mHV9ZlNiQ/zTFXUtehL75OhspMrATdVCMiYY++VmOvAUf
         /eekq4pNPcC6C/TQAU8cmFkZ0XbfiPdQMcWVsKLOLE/usIh4vGdHChOKBOxK9sBTt1rv
         pnV5jBQOb8P5w+YTYvGUKX8r8eni5bLWaUf0yP0z/2/b4B/6llWKZX4t+KTfZrPNLu50
         JANKHb/mj5zIVT7Vxx7rKPWWOZ0ionC9JOx1kBgyKPs6DEpsnVZ1Q18lVJ9Ink/8Uwf5
         odjA==
X-Gm-Message-State: APjAAAWQvVlsIOaEl1EoztVH5/OnX/tz5JX6h2EAB8IsEZuCXqa9y+Zq
        i47K82PSk6sguAE32/Xc1BjoMykgJQRQvdgYhnPyAQ==
X-Google-Smtp-Source: APXvYqyJQGGzScOu1xNpz+S7N8XNCiv+gfOglc2WrYXHEDHviX3IvuW5D87BD0xwI83XTKj18Iegtoqje98Vl3Zxp2M=
X-Received: by 2002:a05:6402:1694:: with SMTP id a20mr3977439edv.211.1582896005450;
 Fri, 28 Feb 2020 05:20:05 -0800 (PST)
MIME-Version: 1.0
References: <20200228105435.75298-1-lrizzo@google.com> <20200228132941.2c8b8d01@carbon>
In-Reply-To: <20200228132941.2c8b8d01@carbon>
From:   Luigi Rizzo <lrizzo@google.com>
Date:   Fri, 28 Feb 2020 05:19:54 -0800
Message-ID: <CAMOZA0KnC0n+U+n3vjx4bb6o_1_MtzLxUfoGj22NdNVQO33uAA@mail.gmail.com>
Subject: Re: [PATCH v4] netdev attribute to control xdpgeneric skb linearization
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>, sameehj@amazon.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 4:30 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
> On Fri, 28 Feb 2020 02:54:35 -0800
> Luigi Rizzo <lrizzo@google.com> wrote:
>
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index dbbfff123196..c539489d3166 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -4520,9 +4520,12 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
> >       /* XDP packets must be linear and must have sufficient headroom
> >        * of XDP_PACKET_HEADROOM bytes. This is the guarantee that also
> >        * native XDP provides, thus we need to do it here as well.
> > +      * For non shared skbs, xdpgeneric_linearize controls linearization.
> >        */
> > -     if (skb_cloned(skb) || skb_is_nonlinear(skb) ||
> > -         skb_headroom(skb) < XDP_PACKET_HEADROOM) {
> > +     if (skb_cloned(skb) ||
> > +         (skb->dev->xdpgeneric_linearize &&
> > +          (skb_is_nonlinear(skb) ||
> > +           skb_headroom(skb) < XDP_PACKET_HEADROOM))) {
> >               int hroom = XDP_PACKET_HEADROOM - skb_headroom(skb);
> >               int troom = skb->tail + skb->data_len - skb->end;
> >
>
> Have you checked that calling bpf_xdp_adjust_tail() is not breaking anything?

It won't leak memory or cause crashes if that is what you mean.
Of course if there are more segments the effect won't be the desired one,
as it will chop off the tail of the first segment.

But this is an opt-in feature and requires the same permissions needed to load
an xdp program, so I expect it to be used consciously.

It would be nice if we had a flag in the xdp_buff to communicate that
the packet is
incomplete, but there isn't a way that I can see.

cheers
luigi
