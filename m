Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572DC2DF65B
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 18:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgLTR5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 12:57:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33133 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726772AbgLTR5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Dec 2020 12:57:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608486974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LCmK0g+hEJlNqpZfmeNoL1Zzda9xUQE2Tu/lOz3fGGU=;
        b=QyQ8/zZKvrHsLyssSG8A10MaJk/0FfLXkZbKhep1vHJk0o3VTBKauMGlCim1AsssRYfu2O
        jKO/Npg8s3gozphH266lBJhDcRn/cTZfyH1/q9kOglEKhux+T2rrWmoGUqLgIKHZYwIVht
        ijRVqz/ymzM7KfUSsJ0kLliC/cRyraE=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-_RxCL4mcM6GKukLiirC3CQ-1; Sun, 20 Dec 2020 12:56:12 -0500
X-MC-Unique: _RxCL4mcM6GKukLiirC3CQ-1
Received: by mail-yb1-f198.google.com with SMTP id z62so11287947yba.23
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 09:56:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LCmK0g+hEJlNqpZfmeNoL1Zzda9xUQE2Tu/lOz3fGGU=;
        b=tg9ykbdsMcMMUmhh0X7R86cOXO1Q9bb3IcU0hUx+aHlWeDC/r+DQLFV+S6OgsjDaKQ
         b4t3dlRprxO9Abd0u825nl7F0lZrRaeULaikJiYXSMJqUWMha1FDL811KYwDQtBXFFnK
         4olIwYxYfhd2pEgwrWKJt8SJhgM3ZUf+I/EBrymlQ4xTZBtX7PkuSZjoPfp+b+tW873C
         tYoJVsX7sP7Ur/+Su07PUSB0EM8OKM7qFrEomkIyvGhCWiBfGMbz5jkmxn7JvyBzBMQL
         rU+/cgKfR2P0/yq4SNdqlgLAXk7j4dU0V4CnrjRq9+hTLsSMiSFxpZOxYaR/y2MGnfmf
         AKvw==
X-Gm-Message-State: AOAM532uGbrWPaBbqopxqVYSs3uheW1wrTv/WRzEf+sJIlg+Z4WhKYH9
        0HaKcJvBBIYlmIxMAX3ZGBjEOjVN7jpV0h/IzvD4J7wQbjZ6sSi/eterX0VUJu/tIIpxoWP8ogb
        vq3A0/I6qbsQWciaDYNnfyhe7GwRgTU+b
X-Received: by 2002:a25:76d2:: with SMTP id r201mr17876127ybc.107.1608486972281;
        Sun, 20 Dec 2020 09:56:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxZAO2PtXbI9hLd0CBlv4eoDVGdGIgeRyNO9tRffiFJDk0lLl8dYVpQa8K4XuNWY/1wHNmpW13bJ3I1+9jMxaE=
X-Received: by 2002:a25:76d2:: with SMTP id r201mr17876115ybc.107.1608486972108;
 Sun, 20 Dec 2020 09:56:12 -0800 (PST)
MIME-Version: 1.0
References: <cover.1607349924.git.lorenzo@kernel.org> <a12bf957bf99fa86d229f383f615f11ee7153340.1607349924.git.lorenzo@kernel.org>
 <pj41zleejlpu3c.fsf@u68c7b5b1d2d758.ant.amazon.com>
In-Reply-To: <pj41zleejlpu3c.fsf@u68c7b5b1d2d758.ant.amazon.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Sun, 20 Dec 2020 18:56:07 +0100
Message-ID: <CAJ0CqmXB2fBoUHgOcpXOkEhfV2Bp=Np+2rhKSOCaZiFdz4WZPQ@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 11/14] bpf: cpumap: introduce xdp multi-buff support
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jubran, Samih" <sameehj@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
>
> Lorenzo Bianconi <lorenzo@kernel.org> writes:
>
> > Introduce __xdp_build_skb_from_frame and
> > xdp_build_skb_from_frame
> > utility routines to build the skb from xdp_frame.
> > Add xdp multi-buff support to cpumap
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  include/net/xdp.h   |  5 ++++
> >  kernel/bpf/cpumap.c | 45 +---------------------------
> >  net/core/xdp.c      | 73
> >  +++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 79 insertions(+), 44 deletions(-)
> >
> [...]
> > diff --git a/net/core/xdp.c b/net/core/xdp.c
> > index 6c8e743ad03a..55f3e9c69427 100644
> > --- a/net/core/xdp.c
> > +++ b/net/core/xdp.c
> > @@ -597,3 +597,76 @@ void xdp_warn(const char *msg, const char
> > *func, const int line)
> >       WARN(1, "XDP_WARN: %s(line:%d): %s\n", func, line, msg);
> >  };
> >  EXPORT_SYMBOL_GPL(xdp_warn);
> > +
> > +struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame
> > *xdpf,
> > +                                        struct sk_buff *skb,
> > +                                        struct net_device *dev)
> > +{
> > +     unsigned int headroom = sizeof(*xdpf) + xdpf->headroom;
> > +     void *hard_start = xdpf->data - headroom;
> > +     skb_frag_t frag_list[MAX_SKB_FRAGS];
> > +     struct xdp_shared_info *xdp_sinfo;
> > +     int i, num_frags = 0;
> > +
> > +     xdp_sinfo = xdp_get_shared_info_from_frame(xdpf);
> > +     if (unlikely(xdpf->mb)) {
> > +             num_frags = xdp_sinfo->nr_frags;
> > +             memcpy(frag_list, xdp_sinfo->frags,
> > +                    sizeof(skb_frag_t) * num_frags);
> > +     }
>
> nit, can you please move the xdp_sinfo assignment inside this 'if'
> ? This would help to emphasize that regarding xdp_frame tailroom
> as xdp_shared_info struct (rather than skb_shared_info) is correct
> only when the mb bit is set
>
> thanks,
> Shay

ack, will do in v6.

Regards,
Lorenzo

>
> > +
> > +     skb = build_skb_around(skb, hard_start, xdpf->frame_sz);
> > +     if (unlikely(!skb))
> > +             return NULL;
> [...]
>

