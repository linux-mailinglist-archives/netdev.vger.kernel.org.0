Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B388D1696C3
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 09:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgBWIPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 03:15:02 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41023 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726236AbgBWIPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 03:15:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582445700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PwdD0natVuJxLWn8vGJsJeHYLsiMkR1Di0XtxpWtDAY=;
        b=gMjr2qHJawm2O2Q4JIL0FIQ/Ed38MC1t8z1qqxn2K873ytfx2YCJLU8IkCSNoybJSmvesa
        X0z3ubJMxGO1teNVCfK+61cOpj3/wNKT7D6W1c5tKguqTT6Gx/Qy1yoqlTZxUpCLezz2wo
        nBVjM0QcKfbK7c6zRz1wPwzeO4FJoA8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-UTdNjuJiMzyJYhzKe2mFxw-1; Sun, 23 Feb 2020 03:14:51 -0500
X-MC-Unique: UTdNjuJiMzyJYhzKe2mFxw-1
Received: by mail-wr1-f71.google.com with SMTP id v17so3630307wrm.17
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 00:14:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=PwdD0natVuJxLWn8vGJsJeHYLsiMkR1Di0XtxpWtDAY=;
        b=D96x7HbdIfxktrKyQoJmuU8ulkbxls0HN69GczeKq3GF5VRAniNdmNGV1AAgVLm4R7
         pOmIT8G5HzEs2IgHzgxAlUa6qPnmkFEIU0I5knsMOxbcXljwdlgGdDaR176tbM43cHHu
         fOhviUrTbEdYe49Fa5CwUNgoNw0lzP25T02PW6mexlXbPMk+07eO94eYi3176vQAF7A5
         nw6QqQQpG0ea2YJZIuT+d8DWI12jNcX41htcBmPMNQBUvwMHTRpu8mwCgikNPrARiVke
         WlrBFdtOa8au6GAflqYwxHkz3eGWQzJ4CJt4PUqgmAAwwHWtg4hmtZUzSn89OrfHJ5+e
         J3sg==
X-Gm-Message-State: APjAAAUSvXV4uSdYYLKlkXohGCLszPLE9gO1RbIjfpuuJJuEScoSH/VJ
        lLWPZsmRtORL3l1vVuK5Q9Hg/vJvik2sKVRitLqRwEEitmclr9RJMaaScYxkpTyaCPIlwIMdMpD
        5BiM/cD2GTLGS3Vh2
X-Received: by 2002:adf:fa05:: with SMTP id m5mr8951894wrr.352.1582445689540;
        Sun, 23 Feb 2020 00:14:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqw4eV7SBMcOtXhDZvtzF7yFJB1onfszcmg2n527AAqxUWr/dFnENHw2O+XbecHUjY91BorlJg==
X-Received: by 2002:adf:fa05:: with SMTP id m5mr8951854wrr.352.1582445689169;
        Sun, 23 Feb 2020 00:14:49 -0800 (PST)
Received: from redhat.com (bzq-79-178-2-214.red.bezeqint.net. [79.178.2.214])
        by smtp.gmail.com with ESMTPSA id t10sm11858301wmi.40.2020.02.23.00.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 00:14:48 -0800 (PST)
Date:   Sun, 23 Feb 2020 03:14:45 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yuya Kusakabe <yuya.kusakabe@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>, andriin@fb.com, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com
Subject: Re: [PATCH bpf-next v5] virtio_net: add XDP meta data support
Message-ID: <20200223031314-mutt-send-email-mst@kernel.org>
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
> 
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

So maybe send a 2 patch series: 1/2 is this chunk with the appropriate
description. Actually for netdev David prefers that people do not
cc stable directly, just include Fixes tag and mention in the
commit log it's also needed for stable. Patch 2/2 is the rest
handling metadata.

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

