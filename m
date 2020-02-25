Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFE2716BF79
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 12:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730432AbgBYLTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 06:19:45 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26172 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726039AbgBYLTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 06:19:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582629582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U3hPikohRml3lL8Jogc7iVoQHY1Ph6Jcqk0meeV3PT4=;
        b=LtFNel6glRAsmWsWPrgUNsD4m5ETvQJYK7a13H5RzEACZIkNfo63C2klMEKPbZY4wGAn/h
        PLVTmShrDsy+K78owDlDXqXe7i6TCxCiW2ONDv4Sia45mPGloFfaEy3ZSo1uPNdE130DM7
        ZPzay6qb1pacKzJyHiNseZO6FNg5odI=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-NomJKf6kOruBv41HxyNnYg-1; Tue, 25 Feb 2020 06:19:37 -0500
X-MC-Unique: NomJKf6kOruBv41HxyNnYg-1
Received: by mail-qt1-f199.google.com with SMTP id t9so14490792qtn.2
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 03:19:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U3hPikohRml3lL8Jogc7iVoQHY1Ph6Jcqk0meeV3PT4=;
        b=ATaZqhgGy9ZgZVWNCl4/oByQURuygT/EbUPnH1uEUJR6NkwrXOAq7fA5KCcR6zcSF1
         1naXAlpwjGShBQYqQ6cZbhgvixRKaWHkDS8mlkvyNnpyQaQzenX2Ns5PtWHfcKez62OB
         EW636gPJYkCL8uisGfU6XToa60h+/A/SG4gaj0dc750lJVPubj/5wtRPR7oYtFf7NWHU
         8uhNlur93n3luZYMJYrFpEvCh/gv6YblNdGTzZ/O3WKG4jKX9WY0+hUkPoyLsDta8+No
         qLJTjGP/aFeoY3DonP5rQfjrl8BHzrKUO+CRhxZYK0CK6S8Xy4Th4b6iaQ54j+LDELG+
         WNQA==
X-Gm-Message-State: APjAAAUHwmWGlbzgO0+QoOC3WFjnhRW32pVn0HlCwzRVJ2C3kGMHnE5b
        IQJ27bx11wuO2O4oVigIAVo1VGTj8HTh6AJzkkz97PJQqT4QXHXYoGy1ASjHHDbGW6j3QDDSajP
        dYhETWtMWJwQVbuvw
X-Received: by 2002:a0c:cc89:: with SMTP id f9mr33125095qvl.17.1582629577149;
        Tue, 25 Feb 2020 03:19:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqyzqcUgpQYhMUX/J07TlPjovku9kP6MRHH8Rhup5+jLZ30rCBS87MFDxy5DJWXwBXW2rSktqg==
X-Received: by 2002:a0c:cc89:: with SMTP id f9mr33125064qvl.17.1582629576871;
        Tue, 25 Feb 2020 03:19:36 -0800 (PST)
Received: from redhat.com (bzq-79-178-2-214.red.bezeqint.net. [79.178.2.214])
        by smtp.gmail.com with ESMTPSA id t6sm3732951qke.57.2020.02.25.03.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 03:19:36 -0800 (PST)
Date:   Tue, 25 Feb 2020 06:19:30 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yuya Kusakabe <yuya.kusakabe@gmail.com>
Cc:     jasowang@redhat.com, andriin@fb.com, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com
Subject: Re: [PATCH bpf-next v6 2/2] virtio_net: add XDP meta data support
Message-ID: <20200225061923-mutt-send-email-mst@kernel.org>
References: <20200225033103.437305-1-yuya.kusakabe@gmail.com>
 <20200225033212.437563-1-yuya.kusakabe@gmail.com>
 <20200225033212.437563-2-yuya.kusakabe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225033212.437563-2-yuya.kusakabe@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 12:32:12PM +0900, Yuya Kusakabe wrote:
> Implement support for transferring XDP meta data into skb for
> virtio_net driver; before calling into the program, xdp.data_meta points
> to xdp.data, where on program return with pass verdict, we call
> into skb_metadata_set().
> 
> Tested with the script at
> https://github.com/higebu/virtio_net-xdp-metadata-test.
> 
> Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>
> ---

Acked-by: Michael S. Tsirkin <mst@redhat.com>

>  drivers/net/virtio_net.c | 52 ++++++++++++++++++++++++----------------
>  1 file changed, 32 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index f39d0218bdaa..12d115ef5e74 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -371,7 +371,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  				   struct receive_queue *rq,
>  				   struct page *page, unsigned int offset,
>  				   unsigned int len, unsigned int truesize,
> -				   bool hdr_valid)
> +				   bool hdr_valid, unsigned int metasize)
>  {
>  	struct sk_buff *skb;
>  	struct virtio_net_hdr_mrg_rxbuf *hdr;
> @@ -393,6 +393,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  	else
>  		hdr_padded_len = sizeof(struct padded_vnet_hdr);
>  
> +	/* hdr_valid means no XDP, so we can copy the vnet header */
>  	if (hdr_valid)
>  		memcpy(hdr, p, hdr_len);
>  
> @@ -405,6 +406,11 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  		copy = skb_tailroom(skb);
>  	skb_put_data(skb, p, copy);
>  
> +	if (metasize) {
> +		__skb_pull(skb, metasize);
> +		skb_metadata_set(skb, metasize);
> +	}
> +
>  	len -= copy;
>  	offset += copy;
>  
> @@ -450,10 +456,6 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
>  	struct virtio_net_hdr_mrg_rxbuf *hdr;
>  	int err;
>  
> -	/* virtqueue want to use data area in-front of packet */
> -	if (unlikely(xdpf->metasize > 0))
> -		return -EOPNOTSUPP;
> -
>  	if (unlikely(xdpf->headroom < vi->hdr_len))
>  		return -EOVERFLOW;
>  
> @@ -644,6 +646,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
>  	unsigned int delta = 0;
>  	struct page *xdp_page;
>  	int err;
> +	unsigned int metasize = 0;
>  
>  	len -= vi->hdr_len;
>  	stats->bytes += len;
> @@ -683,8 +686,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
>  
>  		xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
>  		xdp.data = xdp.data_hard_start + xdp_headroom;
> -		xdp_set_data_meta_invalid(&xdp);
>  		xdp.data_end = xdp.data + len;
> +		xdp.data_meta = xdp.data;
>  		xdp.rxq = &rq->xdp_rxq;
>  		orig_data = xdp.data;
>  		act = bpf_prog_run_xdp(xdp_prog, &xdp);
> @@ -695,6 +698,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
>  			/* Recalculate length in case bpf program changed it */
>  			delta = orig_data - xdp.data;
>  			len = xdp.data_end - xdp.data;
> +			metasize = xdp.data - xdp.data_meta;
>  			break;
>  		case XDP_TX:
>  			stats->xdp_tx++;
> @@ -740,6 +744,9 @@ static struct sk_buff *receive_small(struct net_device *dev,
>  		memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
>  	} /* keep zeroed vnet hdr since XDP is loaded */
>  
> +	if (metasize)
> +		skb_metadata_set(skb, metasize);
> +
>  err:
>  	return skb;
>  
> @@ -760,8 +767,8 @@ static struct sk_buff *receive_big(struct net_device *dev,
>  				   struct virtnet_rq_stats *stats)
>  {
>  	struct page *page = buf;
> -	struct sk_buff *skb = page_to_skb(vi, rq, page, 0, len,
> -					  PAGE_SIZE, true);
> +	struct sk_buff *skb =
> +		page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0);
>  
>  	stats->bytes += len - vi->hdr_len;
>  	if (unlikely(!skb))
> @@ -793,6 +800,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  	unsigned int truesize;
>  	unsigned int headroom = mergeable_ctx_to_headroom(ctx);
>  	int err;
> +	unsigned int metasize = 0;
>  
>  	head_skb = NULL;
>  	stats->bytes += len - vi->hdr_len;
> @@ -839,8 +847,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  		data = page_address(xdp_page) + offset;
>  		xdp.data_hard_start = data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
>  		xdp.data = data + vi->hdr_len;
> -		xdp_set_data_meta_invalid(&xdp);
>  		xdp.data_end = xdp.data + (len - vi->hdr_len);
> +		xdp.data_meta = xdp.data;
>  		xdp.rxq = &rq->xdp_rxq;
>  
>  		act = bpf_prog_run_xdp(xdp_prog, &xdp);
> @@ -848,24 +856,27 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  
>  		switch (act) {
>  		case XDP_PASS:
> +			metasize = xdp.data - xdp.data_meta;
> +
>  			/* recalculate offset to account for any header
> -			 * adjustments. Note other cases do not build an
> -			 * skb and avoid using offset
> +			 * adjustments and minus the metasize to copy the
> +			 * metadata in page_to_skb(). Note other cases do not
> +			 * build an skb and avoid using offset
>  			 */
> -			offset = xdp.data -
> -					page_address(xdp_page) - vi->hdr_len;
> +			offset = xdp.data - page_address(xdp_page) -
> +				 vi->hdr_len - metasize;
>  
> -			/* recalculate len if xdp.data or xdp.data_end were
> -			 * adjusted
> +			/* recalculate len if xdp.data, xdp.data_end or
> +			 * xdp.data_meta were adjusted
>  			 */
> -			len = xdp.data_end - xdp.data + vi->hdr_len;
> +			len = xdp.data_end - xdp.data + vi->hdr_len + metasize;
>  			/* We can only create skb based on xdp_page. */
>  			if (unlikely(xdp_page != page)) {
>  				rcu_read_unlock();
>  				put_page(page);
> -				head_skb = page_to_skb(vi, rq, xdp_page,
> -						       offset, len,
> -						       PAGE_SIZE, false);
> +				head_skb = page_to_skb(vi, rq, xdp_page, offset,
> +						       len, PAGE_SIZE, false,
> +						       metasize);
>  				return head_skb;
>  			}
>  			break;
> @@ -921,7 +932,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  		goto err_skb;
>  	}
>  
> -	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog);
> +	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
> +			       metasize);
>  	curr_skb = head_skb;
>  
>  	if (unlikely(!curr_skb))
> -- 
> 2.24.1

