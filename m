Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD25167B70
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 12:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgBULCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 06:02:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37345 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727034AbgBULCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 06:02:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582282924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hUoay77NnYHID9nGLoLanlEf83tufjpRQXj47Pm5vbI=;
        b=O9TeM2/DF28iTg4AV/eNJOVchvk8guqOh8Oj0AsndGzNXd81ADqXqapJGw6FlyFkugndeW
        m9tCYwF+4gMgljEVBZ6fb4iUui0+UX/J4xZBRetrQ5g4BO6KyHnocvzsTsw50LtCuurngP
        LuDTOebPq5XPyhx46x67nRSSpoFKuac=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-2jog5L5-NCmPUxMS6X-AHw-1; Fri, 21 Feb 2020 06:01:55 -0500
X-MC-Unique: 2jog5L5-NCmPUxMS6X-AHw-1
Received: by mail-qk1-f198.google.com with SMTP id z73so1323483qkb.10
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 03:01:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=hUoay77NnYHID9nGLoLanlEf83tufjpRQXj47Pm5vbI=;
        b=R+GOvcIlCDes6EAfTEXnBtH1g+vAL4Vztdwx69r63D4ckS+Q2l06J1yiZIvfbaTl7f
         iv2FqamysC/Ac2JS1Xmsu+gfEFHYNQtamfiRUsFUxKFVk/qJ92RT0d0hMd1DAWn8Ay7O
         s+T0dpLcGWA8lEIL9ghV/CoWCT31WlEDP2Viu1VaB80TP7oIDCEOHXiSDFMGcGM4QL/0
         ADtGXvSCwnEMMOX0S+EiFRn48WeNU+eKAoh7GRgDR2w0TCdLBOmzX1uet6TsX1twcm97
         whUnzVbLU6m57KS8X/U+1EMRZhAjpUV1QSf2n0KE+xn/2cX7X0vTbd6RhWrEENUohOfS
         pe+g==
X-Gm-Message-State: APjAAAVyBa3W6d53tfT4eMyW/G06dUSgpDZ1CrUf+ko0pR+FDO+IT7TV
        CRAHMjOXYQJazubxDHbabg764TJaiTypOe/83R+mvsNKuRnwSzupTKG44Ht/EfWHcu9czDy8HnL
        nLJfbNLDX3wcrT6Sx
X-Received: by 2002:a37:6153:: with SMTP id v80mr7092197qkb.257.1582282913021;
        Fri, 21 Feb 2020 03:01:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqwpDh5WHyhgA5iqetUV4fOSii4YN0pccjuZPHfEIB81Vxi77KmquOXE3jOcIo0p7uQYOTJLNw==
X-Received: by 2002:a37:6153:: with SMTP id v80mr7091872qkb.257.1582282909406;
        Fri, 21 Feb 2020 03:01:49 -0800 (PST)
Received: from redhat.com (bzq-109-67-14-209.red.bezeqint.net. [109.67.14.209])
        by smtp.gmail.com with ESMTPSA id 73sm1328674qtg.40.2020.02.21.03.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 03:01:48 -0800 (PST)
Date:   Fri, 21 Feb 2020 06:01:42 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yuya Kusakabe <yuya.kusakabe@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>, andriin@fb.com, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com
Subject: Re: [PATCH bpf-next v5] virtio_net: add XDP meta data support
Message-ID: <20200221060048-mutt-send-email-mst@kernel.org>
References: <0c5eaba2-dd5a-fc3f-0e8f-154f7ad52881@redhat.com>
 <20200220085549.269795-1-yuya.kusakabe@gmail.com>
 <5bf11065-6b85-8253-8548-683c01c98ac1@redhat.com>
 <8fafd23d-4c80-539d-9f74-bc5cda0d5575@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8fafd23d-4c80-539d-9f74-bc5cda0d5575@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 05:36:08PM +0900, Yuya Kusakabe wrote:
> On 2/21/20 1:23 PM, Jason Wang wrote:
> > 
> > On 2020/2/20 下午4:55, Yuya Kusakabe wrote:
> >> Implement support for transferring XDP meta data into skb for
> >> virtio_net driver; before calling into the program, xdp.data_meta points
> >> to xdp.data, where on program return with pass verdict, we call
> >> into skb_metadata_set().
> >>
> >> Tested with the script at
> >> https://github.com/higebu/virtio_net-xdp-metadata-test.
> >>
> >> Fixes: de8f3a83b0a0 ("bpf: add meta pointer for direct access")
> > 
> > 
> > I'm not sure this is correct since virtio-net claims to not support metadata by calling xdp_set_data_meta_invalid()?
> 
> virtio_net doesn't support by calling xdp_set_data_meta_invalid() for now.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/drivers/net/virtio_net.c?id=e42da4c62abb547d9c9138e0e7fcd1f36057b5e8#n686
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/drivers/net/virtio_net.c?id=e42da4c62abb547d9c9138e0e7fcd1f36057b5e8#n842
> 
> And xdp_set_data_meta_invalid() are added by de8f3a83b0a0.
> 
> $ git blame ./drivers/net/virtio_net.c | grep xdp_set_data_meta_invalid
> de8f3a83b0a0f (Daniel Borkmann           2017-09-25 02:25:51 +0200  686)                xdp_set_data_meta_invalid(&xdp);
> de8f3a83b0a0f (Daniel Borkmann           2017-09-25 02:25:51 +0200  842)                xdp_set_data_meta_invalid(&xdp);
> 
> So I added `Fixes: de8f3a83b0a0 ("bpf: add meta pointer for direct access")` to the comment.


Fixes basically means "must be backported to any kernel that has
de8f3a83b0a0 in order to fix a bug". This looks more like
a feature than a bug though, so I'm not sure Fixes
is approproate. Correct me if I'm wrong.

> > 
> > 
> >> Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>
> >> ---
> >> v5:
> >>   - page_to_skb(): copy vnet header if hdr_valid without checking metasize.
> >>   - receive_small(): do not copy vnet header if xdp_prog is availavle.
> >>   - __virtnet_xdp_xmit_one(): remove the xdp_set_data_meta_invalid().
> >>   - improve comments.
> >> v4:
> >>   - improve commit message
> >> v3:
> >>   - fix preserve the vnet header in receive_small().
> >> v2:
> >>   - keep copy untouched in page_to_skb().
> >>   - preserve the vnet header in receive_small().
> >>   - fix indentation.
> >> ---
> >>   drivers/net/virtio_net.c | 54 ++++++++++++++++++++++++----------------
> >>   1 file changed, 33 insertions(+), 21 deletions(-)
> >>
> >> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> >> index 2fe7a3188282..4ea0ae60c000 100644
> >> --- a/drivers/net/virtio_net.c
> >> +++ b/drivers/net/virtio_net.c
> >> @@ -371,7 +371,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
> >>                      struct receive_queue *rq,
> >>                      struct page *page, unsigned int offset,
> >>                      unsigned int len, unsigned int truesize,
> >> -                   bool hdr_valid)
> >> +                   bool hdr_valid, unsigned int metasize)
> >>   {
> >>       struct sk_buff *skb;
> >>       struct virtio_net_hdr_mrg_rxbuf *hdr;
> >> @@ -393,6 +393,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
> >>       else
> >>           hdr_padded_len = sizeof(struct padded_vnet_hdr);
> >>   +    /* hdr_valid means no XDP, so we can copy the vnet header */
> >>       if (hdr_valid)
> >>           memcpy(hdr, p, hdr_len);
> >>   @@ -405,6 +406,11 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
> >>           copy = skb_tailroom(skb);
> >>       skb_put_data(skb, p, copy);
> >>   +    if (metasize) {
> >> +        __skb_pull(skb, metasize);
> >> +        skb_metadata_set(skb, metasize);
> >> +    }
> >> +
> >>       len -= copy;
> >>       offset += copy;
> >>   @@ -450,10 +456,6 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
> >>       struct virtio_net_hdr_mrg_rxbuf *hdr;
> >>       int err;
> >>   -    /* virtqueue want to use data area in-front of packet */
> >> -    if (unlikely(xdpf->metasize > 0))
> >> -        return -EOPNOTSUPP;
> >> -
> >>       if (unlikely(xdpf->headroom < vi->hdr_len))
> >>           return -EOVERFLOW;
> >>   @@ -644,6 +646,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
> >>       unsigned int delta = 0;
> >>       struct page *xdp_page;
> >>       int err;
> >> +    unsigned int metasize = 0;
> >>         len -= vi->hdr_len;
> >>       stats->bytes += len;
> >> @@ -683,8 +686,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
> >>             xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
> >>           xdp.data = xdp.data_hard_start + xdp_headroom;
> >> -        xdp_set_data_meta_invalid(&xdp);
> >>           xdp.data_end = xdp.data + len;
> >> +        xdp.data_meta = xdp.data;
> >>           xdp.rxq = &rq->xdp_rxq;
> >>           orig_data = xdp.data;
> >>           act = bpf_prog_run_xdp(xdp_prog, &xdp);
> >> @@ -695,6 +698,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
> >>               /* Recalculate length in case bpf program changed it */
> >>               delta = orig_data - xdp.data;
> >>               len = xdp.data_end - xdp.data;
> >> +            metasize = xdp.data - xdp.data_meta;
> >>               break;
> >>           case XDP_TX:
> >>               stats->xdp_tx++;
> >> @@ -735,11 +739,14 @@ static struct sk_buff *receive_small(struct net_device *dev,
> >>       }
> >>       skb_reserve(skb, headroom - delta);
> >>       skb_put(skb, len);
> >> -    if (!delta) {
> >> +    if (!xdp_prog) {
> >>           buf += header_offset;
> >>           memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
> >>       } /* keep zeroed vnet hdr since packet was changed by bpf */
> > 
> > 
> > I prefer to make this an independent patch and cc stable.
> > 
> > Other looks good.
> > 
> > Thanks
> 
> I see. So I need to revert to delta from xdp_prog?
> 
> Thank you.
> 
> > 
> >>   +    if (metasize)
> >> +        skb_metadata_set(skb, metasize);
> >> +
> >>   err:
> >>       return skb;
> >>   @@ -760,8 +767,8 @@ static struct sk_buff *receive_big(struct net_device *dev,
> >>                      struct virtnet_rq_stats *stats)
> >>   {
> >>       struct page *page = buf;
> >> -    struct sk_buff *skb = page_to_skb(vi, rq, page, 0, len,
> >> -                      PAGE_SIZE, true);
> >> +    struct sk_buff *skb =
> >> +        page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0);
> >>         stats->bytes += len - vi->hdr_len;
> >>       if (unlikely(!skb))
> >> @@ -793,6 +800,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
> >>       unsigned int truesize;
> >>       unsigned int headroom = mergeable_ctx_to_headroom(ctx);
> >>       int err;
> >> +    unsigned int metasize = 0;
> >>         head_skb = NULL;
> >>       stats->bytes += len - vi->hdr_len;
> >> @@ -839,8 +847,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
> >>           data = page_address(xdp_page) + offset;
> >>           xdp.data_hard_start = data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
> >>           xdp.data = data + vi->hdr_len;
> >> -        xdp_set_data_meta_invalid(&xdp);
> >>           xdp.data_end = xdp.data + (len - vi->hdr_len);
> >> +        xdp.data_meta = xdp.data;
> >>           xdp.rxq = &rq->xdp_rxq;
> >>             act = bpf_prog_run_xdp(xdp_prog, &xdp);
> >> @@ -848,24 +856,27 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
> >>             switch (act) {
> >>           case XDP_PASS:
> >> +            metasize = xdp.data - xdp.data_meta;
> >> +
> >>               /* recalculate offset to account for any header
> >> -             * adjustments. Note other cases do not build an
> >> -             * skb and avoid using offset
> >> +             * adjustments and minus the metasize to copy the
> >> +             * metadata in page_to_skb(). Note other cases do not
> >> +             * build an skb and avoid using offset
> >>                */
> >> -            offset = xdp.data -
> >> -                    page_address(xdp_page) - vi->hdr_len;
> >> +            offset = xdp.data - page_address(xdp_page) -
> >> +                 vi->hdr_len - metasize;
> >>   -            /* recalculate len if xdp.data or xdp.data_end were
> >> -             * adjusted
> >> +            /* recalculate len if xdp.data, xdp.data_end or
> >> +             * xdp.data_meta were adjusted
> >>                */
> >> -            len = xdp.data_end - xdp.data + vi->hdr_len;
> >> +            len = xdp.data_end - xdp.data + vi->hdr_len + metasize;
> >>               /* We can only create skb based on xdp_page. */
> >>               if (unlikely(xdp_page != page)) {
> >>                   rcu_read_unlock();
> >>                   put_page(page);
> >> -                head_skb = page_to_skb(vi, rq, xdp_page,
> >> -                               offset, len,
> >> -                               PAGE_SIZE, false);
> >> +                head_skb = page_to_skb(vi, rq, xdp_page, offset,
> >> +                               len, PAGE_SIZE, false,
> >> +                               metasize);
> >>                   return head_skb;
> >>               }
> >>               break;
> >> @@ -921,7 +932,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
> >>           goto err_skb;
> >>       }
> >>   -    head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog);
> >> +    head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
> >> +                   metasize);
> >>       curr_skb = head_skb;
> >>         if (unlikely(!curr_skb))
> > 

