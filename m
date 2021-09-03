Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E60A4003F9
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 19:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350130AbhICROc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 13:14:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23265 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232117AbhICROb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 13:14:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630689211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yHJyQTuhQ2rUo4HEpkrQXS+C/jFPNpqCCL4OYhPvFJs=;
        b=P+MrMyKce4Q+zsN6ckx3kh8yefQPpAD2LkLgVJd1yMRenRyqwyO8MmNTOc6nlpp4nPikqh
        JPSDa0XDUhg2FyTkLEh5Lp89n9qX7StvVVwpcxtEJeUp3VLkLfsOEWjCcpW7peEwz/9vpA
        LJzcvCSc+6g3qJDyH8UcRYgfolNPcJE=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-IuKpXPnKPkWvTMrV3AZ-ag-1; Fri, 03 Sep 2021 13:13:30 -0400
X-MC-Unique: IuKpXPnKPkWvTMrV3AZ-ag-1
Received: by mail-yb1-f197.google.com with SMTP id 83-20020a251956000000b0059948f541cbso7197190ybz.7
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 10:13:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yHJyQTuhQ2rUo4HEpkrQXS+C/jFPNpqCCL4OYhPvFJs=;
        b=Q3d8nhI6KRfFJ7AHa6ZdnrHCpLKCX1iuifwm/RsJQSZEZR0NOZ9XJIEpLGOE+e4BBB
         10aLLE3xj///PkatIopaXHspPsob+oyDe5rNDJjU+5P+nDBGxQddJhwu3bhodyy5wivD
         /1tzbgXhyaDoMZ5a8urvvDcehBwXDpaQ+LInnm0WaPCYFzU0akZ/WWWZhUunVE5Vo6nS
         I+D+WOlH3uSbvcIAgXUE0vU+Mm6FdQqOZh+SoN+LUJcRGQCIky187c/ldCHvDQ7bhkrr
         JjfXH47V1LIL5vWUYgc8h8qR1WcACVrWIjQc9hcrIJO2fYEQFFNlUtAeAkQlLMq0BrrM
         UQ1Q==
X-Gm-Message-State: AOAM532f68Iy6vC0ApMSty4T9c+E6h7mB1jj8Yq1P4xwlTtPndH/zwhS
        HpzJev2VUM+vsxHdAwHnQAuYkdDrXM9El70OZnGPRUoCLkIkLz3TdhuITKyzdlwK865KI5br0u4
        XD8QJKZnkoWWdBnlBgmV055m9enQ1+q8K
X-Received: by 2002:a25:c005:: with SMTP id c5mr158251ybf.168.1630689210022;
        Fri, 03 Sep 2021 10:13:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzn64tX3wVU8FQE/8IxOa46/3bOs07liCcjapLECaEcqfxtXRfkxmGyJeh0V2xmOGq4e8Mife4ldeUUuZVuHq4=
X-Received: by 2002:a25:c005:: with SMTP id c5mr158209ybf.168.1630689209747;
 Fri, 03 Sep 2021 10:13:29 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1629473233.git.lorenzo@kernel.org> <ab0c64f1543239256ef63ec9b40f35a7491812c6.1629473233.git.lorenzo@kernel.org>
 <612eb79343225_6b872087a@john-XPS-13-9370.notmuch>
In-Reply-To: <612eb79343225_6b872087a@john-XPS-13-9370.notmuch>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Fri, 3 Sep 2021 19:13:18 +0200
Message-ID: <CAJ0CqmWGNapcmVae52UJNAg7XKS7f0F2dmQMoO+1sL3zp=oFTw@mail.gmail.com>
Subject: Re: [PATCH v12 bpf-next 01/18] net: skbuff: add size metadata to
 skb_shared_info for xdp
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Sarkar, Tirthendu" <tirthendu.sarkar@intel.com>,
        Toke Hoiland Jorgensen <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> Lorenzo Bianconi wrote:
> > Introduce xdp_frags_tsize field in skb_shared_info data structure
> > to store xdp_buff/xdp_frame truesize (xdp_frags_tsize will be used
> > in xdp multi-buff support). In order to not increase skb_shared_info
> > size we will use a hole due to skb_shared_info alignment.
> > Introduce xdp_frags_size field in skb_shared_info data structure
> > reusing gso_type field in order to store xdp_buff/xdp_frame paged size.
> > xdp_frags_size will be used in xdp multi-buff support.
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>
> I assume we can use xdp_frags_tsize for anything else above XDP later?
> Other than simple question looks OK to me.

yes, right as we did for gso_type/xdp_frags_size.

Regards,
Lorenzo

>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
>
> > ---
> >  include/linux/skbuff.h | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 6bdb0db3e825..1abeba7ef82e 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -522,13 +522,17 @@ struct skb_shared_info {
> >       unsigned short  gso_segs;
> >       struct sk_buff  *frag_list;
> >       struct skb_shared_hwtstamps hwtstamps;
> > -     unsigned int    gso_type;
> > +     union {
> > +             unsigned int    gso_type;
> > +             unsigned int    xdp_frags_size;
> > +     };
> >       u32             tskey;
> >
> >       /*
> >        * Warning : all fields before dataref are cleared in __alloc_skb()
> >        */
> >       atomic_t        dataref;
> > +     unsigned int    xdp_frags_tsize;
> >
> >       /* Intermediate layers must ensure that destructor_arg
> >        * remains valid until skb destructor */
> > --
> > 2.31.1
> >
>
>

