Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9304C3A9412
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 09:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhFPHf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 03:35:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34394 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231132AbhFPHfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 03:35:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623828799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hrgvDAnzVX2X+p3GDVnqhUL+PO1Rl1aPuqwOMhTlNvY=;
        b=YZUGhHocUskXfJYRbadNDS9jbdJApRz9dJYl2kSuVSfDFE12IHMAvdAsPYf2g7M5/Msarm
        iISh28Lx+ClOLINHLZ27LvHVTzJP4it/1p5EAWML4QMtEU78Q+zph9Nj7UirPqcXE5qZFj
        74C4OybJyuLDuUDk7z8SHFTsf3PImQY=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-owQHEP_0OjSk3kWyj_Pcxw-1; Wed, 16 Jun 2021 03:33:18 -0400
X-MC-Unique: owQHEP_0OjSk3kWyj_Pcxw-1
Received: by mail-pg1-f199.google.com with SMTP id k193-20020a633dca0000b029021ff326b222so970874pga.9
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 00:33:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=hrgvDAnzVX2X+p3GDVnqhUL+PO1Rl1aPuqwOMhTlNvY=;
        b=bQEISg0LJU0joa6L4Yf83xF91v6E5x3RUS/b8vM2IAPckacDgbdc7eT4e5ZfHtrPAh
         Qm0ggvRDigZLbP+VI8FNPxwMy1g5UzVOMwSWG9pvWPR00i3zfF4TfI2jwf9UhgxlSTHk
         QNANmVF3VRmX0yVQPoLKTETqK+z6SkVaMxLF1W2wvg0nlPtGhyQeQGMTlb5FmKlOvCkd
         zVswUCwo4DCMh3EgROYZ3zrOxMVdtwJQhn4/gVqvh4BzcqHd+Z0XAF7laxS7yBEUFh6N
         cfWt2DCySc7cu+f0p/SV3hFCsUtIP5zqKqlNq9VJKZqAMSkj9cxMPStTuGf/fadiU54E
         yQbQ==
X-Gm-Message-State: AOAM531CzttdZCQAUQJcTTmUAxI9Q3fH9Pt3FaCYFlYJTqiGWGjvE1Ys
        7E9fVlqbRFFDO9NJQPey7Wu0Yei/9fsfJ5tc2GymmMeKr6hIoSpg5u6BGk9wtgai8tznR/4NK2e
        htXfDJpVfYRWbMXJd
X-Received: by 2002:a63:6982:: with SMTP id e124mr3579001pgc.439.1623828797133;
        Wed, 16 Jun 2021 00:33:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUIq7Lz8HKOFEufm/jp52GRliBWs0Lz4CE/qd3l1hSi1Xms0UsuSTNWK3gwkAMa0A5d6uFvw==
X-Received: by 2002:a63:6982:: with SMTP id e124mr3578973pgc.439.1623828796837;
        Wed, 16 Jun 2021 00:33:16 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y7sm1229445pfy.153.2021.06.16.00.33.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 00:33:16 -0700 (PDT)
Subject: Re: [PATCH net-next v5 08/15] virtio-net: split the receive_mergeable
 function
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        "dust . li" <dust.li@linux.alibaba.com>
References: <20210610082209.91487-1-xuanzhuo@linux.alibaba.com>
 <20210610082209.91487-9-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <52720442-a3e6-69f9-72f5-246dab2c8e5f@redhat.com>
Date:   Wed, 16 Jun 2021 15:33:05 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210610082209.91487-9-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/10 ÏÂÎç4:22, Xuan Zhuo Ð´µÀ:
> receive_mergeable() is too complicated, so this function is split here.
> One is to make the function more readable. On the other hand, the two
> independent functions will be called separately in subsequent patches.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/net/virtio_net.c | 181 ++++++++++++++++++++++++---------------
>   1 file changed, 111 insertions(+), 70 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 3fd87bf2b2ad..989aba600e63 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -733,6 +733,109 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
>   	return NULL;
>   }
>   
> +static void merge_drop_follow_bufs(struct net_device *dev,
> +				   struct receive_queue *rq,
> +				   u16 num_buf,
> +				   struct virtnet_rq_stats *stats)


Patch looks good. Nit here, I guess we need a better name, how about 
"merge_buffers()" for this and "drop_buffers()" for the next function?

Thanks


> +{
> +	struct page *page;
> +	unsigned int len;
> +	void *buf;
> +
> +	while (num_buf-- > 1) {
> +		buf = virtqueue_get_buf(rq->vq, &len);
> +		if (unlikely(!buf)) {
> +			pr_debug("%s: rx error: %d buffers missing\n",
> +				 dev->name, num_buf);
> +			dev->stats.rx_length_errors++;
> +			break;
> +		}
> +		stats->bytes += len;
> +		page = virt_to_head_page(buf);
> +		put_page(page);
> +	}
> +}
> +
> +static struct sk_buff *merge_receive_follow_bufs(struct net_device *dev,
> +						 struct virtnet_info *vi,
> +						 struct receive_queue *rq,
> +						 struct sk_buff *head_skb,
> +						 u16 num_buf,
> +						 struct virtnet_rq_stats *stats)
> +{
> +	struct sk_buff *curr_skb;
> +	unsigned int truesize;
> +	unsigned int len, num;
> +	struct page *page;
> +	void *buf, *ctx;
> +	int offset;
> +
> +	curr_skb = head_skb;
> +	num = num_buf;
> +
> +	while (--num_buf) {
> +		int num_skb_frags;
> +
> +		buf = virtqueue_get_buf_ctx(rq->vq, &len, &ctx);
> +		if (unlikely(!buf)) {
> +			pr_debug("%s: rx error: %d buffers out of %d missing\n",
> +				 dev->name, num_buf, num);
> +			dev->stats.rx_length_errors++;
> +			goto err_buf;
> +		}
> +
> +		stats->bytes += len;
> +		page = virt_to_head_page(buf);
> +
> +		truesize = mergeable_ctx_to_truesize(ctx);
> +		if (unlikely(len > truesize)) {
> +			pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
> +				 dev->name, len, (unsigned long)ctx);
> +			dev->stats.rx_length_errors++;
> +			goto err_skb;
> +		}
> +
> +		num_skb_frags = skb_shinfo(curr_skb)->nr_frags;
> +		if (unlikely(num_skb_frags == MAX_SKB_FRAGS)) {
> +			struct sk_buff *nskb = alloc_skb(0, GFP_ATOMIC);
> +
> +			if (unlikely(!nskb))
> +				goto err_skb;
> +			if (curr_skb == head_skb)
> +				skb_shinfo(curr_skb)->frag_list = nskb;
> +			else
> +				curr_skb->next = nskb;
> +			curr_skb = nskb;
> +			head_skb->truesize += nskb->truesize;
> +			num_skb_frags = 0;
> +		}
> +		if (curr_skb != head_skb) {
> +			head_skb->data_len += len;
> +			head_skb->len += len;
> +			head_skb->truesize += truesize;
> +		}
> +		offset = buf - page_address(page);
> +		if (skb_can_coalesce(curr_skb, num_skb_frags, page, offset)) {
> +			put_page(page);
> +			skb_coalesce_rx_frag(curr_skb, num_skb_frags - 1,
> +					     len, truesize);
> +		} else {
> +			skb_add_rx_frag(curr_skb, num_skb_frags, page,
> +					offset, len, truesize);
> +		}
> +	}
> +
> +	return head_skb;
> +
> +err_skb:
> +	put_page(page);
> +	merge_drop_follow_bufs(dev, rq, num_buf, stats);
> +err_buf:
> +	stats->drops++;
> +	dev_kfree_skb(head_skb);
> +	return NULL;
> +}
> +
>   static struct sk_buff *receive_small(struct net_device *dev,
>   				     struct virtnet_info *vi,
>   				     struct receive_queue *rq,
> @@ -909,7 +1012,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   	u16 num_buf = virtio16_to_cpu(vi->vdev, hdr->num_buffers);
>   	struct page *page = virt_to_head_page(buf);
>   	int offset = buf - page_address(page);
> -	struct sk_buff *head_skb, *curr_skb;
> +	struct sk_buff *head_skb;
>   	struct bpf_prog *xdp_prog;
>   	unsigned int truesize = mergeable_ctx_to_truesize(ctx);
>   	unsigned int headroom = mergeable_ctx_to_headroom(ctx);
> @@ -1054,65 +1157,15 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   
>   	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
>   			       metasize, !!headroom);
> -	curr_skb = head_skb;
> -
> -	if (unlikely(!curr_skb))
> +	if (unlikely(!head_skb))
>   		goto err_skb;
> -	while (--num_buf) {
> -		int num_skb_frags;
>   
> -		buf = virtqueue_get_buf_ctx(rq->vq, &len, &ctx);
> -		if (unlikely(!buf)) {
> -			pr_debug("%s: rx error: %d buffers out of %d missing\n",
> -				 dev->name, num_buf,
> -				 virtio16_to_cpu(vi->vdev,
> -						 hdr->num_buffers));
> -			dev->stats.rx_length_errors++;
> -			goto err_buf;
> -		}
> -
> -		stats->bytes += len;
> -		page = virt_to_head_page(buf);
> -
> -		truesize = mergeable_ctx_to_truesize(ctx);
> -		if (unlikely(len > truesize)) {
> -			pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
> -				 dev->name, len, (unsigned long)ctx);
> -			dev->stats.rx_length_errors++;
> -			goto err_skb;
> -		}
> -
> -		num_skb_frags = skb_shinfo(curr_skb)->nr_frags;
> -		if (unlikely(num_skb_frags == MAX_SKB_FRAGS)) {
> -			struct sk_buff *nskb = alloc_skb(0, GFP_ATOMIC);
> -
> -			if (unlikely(!nskb))
> -				goto err_skb;
> -			if (curr_skb == head_skb)
> -				skb_shinfo(curr_skb)->frag_list = nskb;
> -			else
> -				curr_skb->next = nskb;
> -			curr_skb = nskb;
> -			head_skb->truesize += nskb->truesize;
> -			num_skb_frags = 0;
> -		}
> -		if (curr_skb != head_skb) {
> -			head_skb->data_len += len;
> -			head_skb->len += len;
> -			head_skb->truesize += truesize;
> -		}
> -		offset = buf - page_address(page);
> -		if (skb_can_coalesce(curr_skb, num_skb_frags, page, offset)) {
> -			put_page(page);
> -			skb_coalesce_rx_frag(curr_skb, num_skb_frags - 1,
> -					     len, truesize);
> -		} else {
> -			skb_add_rx_frag(curr_skb, num_skb_frags, page,
> -					offset, len, truesize);
> -		}
> -	}
> +	if (num_buf > 1)
> +		head_skb = merge_receive_follow_bufs(dev, vi, rq, head_skb,
> +						     num_buf, stats);
> +	if (head_skb)
> +		ewma_pkt_len_add(&rq->mrg_avg_pkt_len, head_skb->len);
>   
> -	ewma_pkt_len_add(&rq->mrg_avg_pkt_len, head_skb->len);
>   	return head_skb;
>   
>   err_xdp:
> @@ -1120,19 +1173,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   	stats->xdp_drops++;
>   err_skb:
>   	put_page(page);
> -	while (num_buf-- > 1) {
> -		buf = virtqueue_get_buf(rq->vq, &len);
> -		if (unlikely(!buf)) {
> -			pr_debug("%s: rx error: %d buffers missing\n",
> -				 dev->name, num_buf);
> -			dev->stats.rx_length_errors++;
> -			break;
> -		}
> -		stats->bytes += len;
> -		page = virt_to_head_page(buf);
> -		put_page(page);
> -	}
> -err_buf:
> +	merge_drop_follow_bufs(dev, rq, num_buf, stats);
>   	stats->drops++;
>   	dev_kfree_skb(head_skb);
>   xdp_xmit:

