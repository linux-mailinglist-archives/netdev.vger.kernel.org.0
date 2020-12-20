Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF882DF654
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 18:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbgLTRyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 12:54:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48358 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726470AbgLTRyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Dec 2020 12:54:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608486756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pVoF1GuSzUjJXCw3G/HdhD3nhCcK87FV2ryidN/EbJk=;
        b=M4v6kkZE81DIIDKM8L6NNMFTzvUIeJu8CXpOKGtbg6QYzB9dcsxUPx1CkoKl7lEBgTeRIY
        +aUyapimtpnkVKtYw2OVofg9aEcm5dA7oGmpFFUZiCDLrv3MoC3mvpnZr8fUt9fk3LEsmg
        bbBtaPEuyjmXHkPtXiK1WqLIxEdeTSg=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-n8vEkiI-NpWJ60iOEzhd-A-1; Sun, 20 Dec 2020 12:52:34 -0500
X-MC-Unique: n8vEkiI-NpWJ60iOEzhd-A-1
Received: by mail-yb1-f197.google.com with SMTP id g67so11402162ybb.9
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 09:52:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pVoF1GuSzUjJXCw3G/HdhD3nhCcK87FV2ryidN/EbJk=;
        b=g8uGyIn7nJFmvIzF57mF6R5cjDRfUDA5jSeFGWbuiIDGfCGC2bklCN05rBOOeyI5QJ
         FuZg+xuFHV7VJw625zyZWc+6BVWAIlveOZCcnalIlaAUEZ0FkB4L44GpqWGYEbCueO9K
         Rodawiam2XlTQp3Tb4yil8yMXFnt6HNVieiyuEIHCAXRfEcSkTEt2AO6Q58+pq0jLMnq
         1ch3qDA07bzwz4zjEC+Sp+EXHoh+7nMSIC29weqD8n5jWBfGdGSmn6MH+q+9X+2HpYaJ
         bI1JBhPJYc0BolGwOCEsLLJMOFgGgdrX/FsY4Jmk1PHZDXZ/jP58Bm4m4qJd4FD2ZJEJ
         XNjQ==
X-Gm-Message-State: AOAM5332kZ7XGsNgaux2R98W2TnJVZZQCO3MTRMSGBDYSQm7NovVHFln
        a+C35EUB86O0mqHfzo5TiGqLOascWzQ9WIcclF/egu/LMEkdTacK2u6TharEZRHZ0VZIlrJuRs4
        Vv0xjBRNEIO9B948E8K7TXYo1XTtuyT8r
X-Received: by 2002:a25:3a04:: with SMTP id h4mr1935470yba.285.1608486753409;
        Sun, 20 Dec 2020 09:52:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwv3EKIyYiOTEQmymOosTLMxXi+rc/bNY99x4v7vvEV+VuUAPJO6yGTyIAwbDCGB67vPincINDo7Lpb9SXjnO8=
X-Received: by 2002:a25:3a04:: with SMTP id h4mr1935447yba.285.1608486753133;
 Sun, 20 Dec 2020 09:52:33 -0800 (PST)
MIME-Version: 1.0
References: <cover.1607349924.git.lorenzo@kernel.org> <21d27f233e37b66c9ad4073dd09df5c2904112a4.1607349924.git.lorenzo@kernel.org>
 <5465830698257f18ae474877648f4a9fe2e1eefe.camel@kernel.org>
 <20201208110125.GC36228@lore-desk> <pj41zlk0tdq22i.fsf@u68c7b5b1d2d758.ant.amazon.com>
In-Reply-To: <pj41zlk0tdq22i.fsf@u68c7b5b1d2d758.ant.amazon.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Sun, 20 Dec 2020 18:52:29 +0100
Message-ID: <CAJ0CqmWUJzrpOpQ01sr+e5hr1K1U4tsqEiF=FdLL--wLYpu3DA@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 03/14] xdp: add xdp_shared_info data structure
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
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
> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>
> >> On Mon, 2020-12-07 at 17:32 +0100, Lorenzo Bianconi wrote:
> >> > Introduce xdp_shared_info data structure to contain info
> >> > about
> >> > "non-linear" xdp frame. xdp_shared_info will alias
> >> > skb_shared_info
> >> > allowing to keep most of the frags in the same cache-line.
> [...]
> >>
> >> > +  u16 nr_frags;
> >> > +  u16 data_length; /* paged area length */
> >> > +  skb_frag_t frags[MAX_SKB_FRAGS];
> >>
> >> why MAX_SKB_FRAGS ? just use a flexible array member
> >> skb_frag_t frags[];
> >>
> >> and enforce size via the n_frags and on the construction of the
> >> tailroom preserved buffer, which is already being done.
> >>
> >> this is waste of unnecessary space, at lease by definition of
> >> the
> >> struct, in your use case you do:
> >> memcpy(frag_list, xdp_sinfo->frags, sizeof(skb_frag_t) *
> >> num_frags);
> >> And the tailroom space was already preserved for a full
> >> skb_shinfo.
> >> so i don't see why you need this array to be of a fixed
> >> MAX_SKB_FRAGS
> >> size.
> >
> > In order to avoid cache-misses, xdp_shared info is built as a
> > variable
> > on mvneta_rx_swbm() stack and it is written to "shared_info"
> > area only on the
> > last fragment in mvneta_swbm_add_rx_fragment(). I used
> > MAX_SKB_FRAGS to be
> > aligned with skb_shared_info struct but probably we can use even
> > a smaller value.
> > Another approach would be to define two different struct, e.g.
> >
> > stuct xdp_frag_metadata {
> >       u16 nr_frags;
> >       u16 data_length; /* paged area length */
> > };
> >
> > struct xdp_frags {
> >       skb_frag_t frags[MAX_SKB_FRAGS];
> > };
> >
> > and then define xdp_shared_info as
> >
> > struct xdp_shared_info {
> >       stuct xdp_frag_metadata meta;
> >       skb_frag_t frags[];
> > };
> >
> > In this way we can probably optimize the space. What do you
> > think?
>
> We're still reserving ~sizeof(skb_shared_info) bytes at the end of
> the first buffer and it seems like in mvneta code you keep
> updating all three fields (frags, nr_frags and data_length).
> Can you explain how the space is optimized by splitting the
> structs please?

using xdp_shared_info struct we will have the first 3 fragments in the
same cacheline of nr_frags while using skb_shared_info struct only the
first fragment will be in the same cacheline of nr_frags. Moreover
skb_shared_info has multiple fields unused by xdp.

Regards,
Lorenzo

>
> >>
> >> > +};
> >> > +
> >> > +static inline struct xdp_shared_info *
> >> >  xdp_get_shared_info_from_buff(struct xdp_buff *xdp)
> >> >  {
> >> > -  return (struct skb_shared_info *)xdp_data_hard_end(xdp);
> >> > +  BUILD_BUG_ON(sizeof(struct xdp_shared_info) >
> >> > +               sizeof(struct skb_shared_info));
> >> > +  return (struct xdp_shared_info *)xdp_data_hard_end(xdp);
> >> > +}
> >> > +
> >>
> >> Back to my first comment, do we have plans to use this tail
> >> room buffer
> >> for other than frag_list use cases ? what will be the buffer
> >> format
> >> then ? should we push all new fields to the end of the
> >> xdp_shared_info
> >> struct ? or deal with this tailroom buffer as a stack ?
> >> my main concern is that for drivers that don't support frag
> >> list and
> >> still want to utilize the tailroom buffer for other usecases
> >> they will
> >> have to skip the first sizeof(xdp_shared_info) so they won't
> >> break the
> >> stack.
> >
> > for the moment I do not know if this area is used for other
> > purposes.
> > Do you think there are other use-cases for it?
> >
>
> Saeed, the stack receives skb_shared_info when the frames are
> passed to the stack (skb_add_rx_frag is used to add the whole
> information to skb's shared info), and for XDP_REDIRECT use case,
> it doesn't seem like all drivers check page's tailroom for more
> information anyway (ena doesn't at least).
> Can you please explain what do you mean by "break the stack"?
>
> Thanks, Shay
>
> >>
> [...]
> >
> >>
>

