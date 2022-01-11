Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A140F48AE28
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 14:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240242AbiAKNFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 08:05:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:28359 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240093AbiAKNFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 08:05:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641906336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wpzje35ZQJ++DpfcFSJcktDk/9fVWR9cmKQ44GgvnmQ=;
        b=JlgrQPIIIw+E2BjdG32+908WF5JZfGtLCsNqlihfW3/N/+NrxqbbWonKnqqRIbO891T8iw
        nDH8h+LlFu4fIQk8hHO/Zv16DRV1BxeMLqsXpvp4vjNxLrQF2Iirg0kpHSvxqhvSlHCFng
        E0/Q4VhOp34XY24D5owFs5Bimml7C4E=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-w8QAexhlNiS7GozJHevOWA-1; Tue, 11 Jan 2022 08:05:35 -0500
X-MC-Unique: w8QAexhlNiS7GozJHevOWA-1
Received: by mail-yb1-f197.google.com with SMTP id 2-20020a251302000000b006118f867dadso220918ybt.12
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 05:05:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wpzje35ZQJ++DpfcFSJcktDk/9fVWR9cmKQ44GgvnmQ=;
        b=GUc5NGR+froKJdwQ1LP30Tif+cN4dHrC3Xtn8LLcPI48fP52SRk8binHaNVBVY5o5i
         5jEJm0q4Af/LODd7c73DadSBg94d/uA6NQEF8tHuvlWP+51fPjMTZskaxNPxVI2PE/tB
         q+K5FWLoeQSODE44/nN+tL45Wz6euWmBTNiLR18kGf6cdXu1O7nCyFq+dasvRWAm4iTd
         gSW0OZKliOhocQpWytd00YEuxLKWw181wqaFWx/nuIl1Yy1AjQLmes73wMbFameRVlq2
         0IAqKPjJ3z7+ob1SCEmLXAD4CC/doKQLCVefXGjELoHTPeMGoiLtbVM7+MM8GgsoME/V
         /P8A==
X-Gm-Message-State: AOAM532qyBXCK6gXuZhPX+w/x9ywIJ0a+AZPEJzu/eUMNwnCm/Uojmq+
        lzStDE3tAYSwzn3yMzOO4sHI9kwB9yWbaFQmmLQ8yCWtSqGKVSJX1O7SrMwKzPMnUhDiCnzvNkF
        n3Tk6cFnwUrHtFK3bMWRVIHYu0De/JsoX
X-Received: by 2002:a05:6902:110d:: with SMTP id o13mr6658660ybu.715.1641906335047;
        Tue, 11 Jan 2022 05:05:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyJsAYYRDSZYX6e6gogiyOC4FEsDkRLDsOR3cKi9/31EBqC9/2HpkReIPbJz5Y5IOzS526Z85G8eg2mMdWVzTY=
X-Received: by 2002:a05:6902:110d:: with SMTP id o13mr6658623ybu.715.1641906334739;
 Tue, 11 Jan 2022 05:05:34 -0800 (PST)
MIME-Version: 1.0
References: <cover.1641641663.git.lorenzo@kernel.org> <a346f27e55a9117f43f89aceb7e47c5f0743d50a.1641641663.git.lorenzo@kernel.org>
 <YdxgrP1YDMyWXmqL@C02YVCJELVCG>
In-Reply-To: <YdxgrP1YDMyWXmqL@C02YVCJELVCG>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Tue, 11 Jan 2022 14:05:23 +0100
Message-ID: <CAJ0CqmXaeJkJ8SDjTA1u_JNsqpxS8GA4J29S9wGPH0qOmqjp0w@mail.gmail.com>
Subject: Re: [PATCH v21 bpf-next 06/23] net: marvell: rely on
 xdp_update_skb_shared_info utility routine
To:     Andy Gospodarek <andrew.gospodarek@broadcom.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Sarkar, Tirthendu" <tirthendu.sarkar@intel.com>,
        Toke Hoiland Jorgensen <toke@redhat.com>, andy@greyhouse.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> On Sat, Jan 08, 2022 at 12:53:09PM +0100, Lorenzo Bianconi wrote:
> > Rely on xdp_update_skb_shared_info routine in order to avoid
> > resetting frags array in skb_shared_info structure building
> > the skb in mvneta_swbm_build_skb(). Frags array is expected to
> > be initialized by the receiving driver building the xdp_buff
> > and here we just need to update memory metadata.
> >
> > Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
> > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/marvell/mvneta.c | 23 ++++++++++-------------
> >  1 file changed, 10 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> > index 775ffd91b741..267a306d9c75 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -2332,8 +2332,12 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
> >               skb_frag_size_set(frag, data_len);
> >               __skb_frag_set_page(frag, page);
> >
> > -             if (!xdp_buff_is_mb(xdp))
> > +             if (!xdp_buff_is_mb(xdp)) {
> > +                     sinfo->xdp_frags_size = *size;
> >                       xdp_buff_set_mb(xdp);
> > +             }
> > +             if (page_is_pfmemalloc(page))
> > +                     xdp_buff_set_frag_pfmemalloc(xdp);
> >       } else {
> >               page_pool_put_full_page(rxq->page_pool, page, true);
> >       }
> > @@ -2347,7 +2351,6 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
> >       struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> >       struct sk_buff *skb;
> >       u8 num_frags;
> > -     int i;
> >
> >       if (unlikely(xdp_buff_is_mb(xdp)))
> >               num_frags = sinfo->nr_frags;
> > @@ -2362,18 +2365,12 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
> >       skb_put(skb, xdp->data_end - xdp->data);
> >       skb->ip_summed = mvneta_rx_csum(pp, desc_status);
> >
> > -     if (likely(!xdp_buff_is_mb(xdp)))
> > -             goto out;
> > -
> > -     for (i = 0; i < num_frags; i++) {
> > -             skb_frag_t *frag = &sinfo->frags[i];
> > -
> > -             skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
> > -                             skb_frag_page(frag), skb_frag_off(frag),
> > -                             skb_frag_size(frag), PAGE_SIZE);
>
> Maybe I'm missing something but I'm not sure you have a suitable
> replacement for the 3 lines above this in your proposed change.
>

Hi Andy,

mvneta_swbm_add_rx_fragment() initializes frags array in
skb_shared_info for xdp whenever we receive a multi-descriptors frame.
Since frags array is at the same offset for the xdp_buff and for the
new skb and build_skb() in mvneta_swbm_build_skb() does not overwrite
it, we do not need to initialize it again allocating the skb, just
account metadata info running xdp_update_skb_shared_info(). Agree?

> > -     }
> > +     if (unlikely(xdp_buff_is_mb(xdp)))
> > +             xdp_update_skb_shared_info(skb, num_frags,
> > +                                        sinfo->xdp_frags_size,
> > +                                        num_frags * xdp->frame_sz,
> > +                                        xdp_buff_is_frag_pfmemalloc(xdp));
> >
>
> When I did an implementation of this on a different driver I also needed
> to add:
>
>         for (i = 0; i < num_frags; i++)
>                 skb_frag_set_page(skb, i, skb_frag_page(&sinfo->frags[i]));
>
> to make sure that frames that were given XDP_PASS were formatted
> correctly so they could be handled by the stack.  Don't you need
> something similar to make sure frags are properly set?
>
> Thanks,
>
> -andy
>
> P.S.  Sorry for noticing this so late in the process; I realize this version
> was just a rebase of v20 and this would have been useful information
> earlier if I'm correct.
>

no worries :)

Regards,
Lorenzo

> > -out:
> >       return skb;
> >  }
> >
> > --
> > 2.33.1
> >

