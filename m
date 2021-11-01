Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B8844158C
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 09:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhKAIqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 04:46:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44458 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231695AbhKAIqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 04:46:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635756248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2Ad4v/ujl0t03/UsIys5jLvOTiR3MOz3oTeEO3GUsRw=;
        b=UdxHmithQu3Z860J0B8MI1vr1m86BAPBmp43ufKVyqUVGkICbWxGZlwLsin8SKjYD9/Sku
        XFf0QJpRk81zhLDw/2XM6AmkpFX8RfZdSMgMd2u9Magq2o3/pTSboijJZGZmsxpD6Vynw0
        pN2JdQDPQtGgP5CBl9FEvJ1U5qUWDNs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-LSZ7E_fkNLSOOXqNhV_P0g-1; Mon, 01 Nov 2021 04:44:07 -0400
X-MC-Unique: LSZ7E_fkNLSOOXqNhV_P0g-1
Received: by mail-ed1-f70.google.com with SMTP id d11-20020a50cd4b000000b003da63711a8aso14842598edj.20
        for <netdev@vger.kernel.org>; Mon, 01 Nov 2021 01:44:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2Ad4v/ujl0t03/UsIys5jLvOTiR3MOz3oTeEO3GUsRw=;
        b=DMvxnp25jONCRyLwjfdcfDnK2znlAsBToCD7l/B7BxkNhpP6z3ZmNz454YZk2U27oa
         v/kVGhw9duOKuGJ9XnVueL2sb+1EN+5MHK9/iY2VnU7E0pSYVoY8jxuXKSe+FwmpMBLh
         TmDVLIKF4oT3f3cEpFUbNus+j/nzqP7qvFHJdo7sTHi65IkIIPOjOi7LpzG6CBoOojtz
         QP1Ful2EYW9lbUQ7g83E52Vqer6QfBfTZL22yp0n19yQK9PYPvqBUUCm+0p9kC5LRNRu
         v/95NEcKdCSTmptwTArUUjmfEs6VGwwsog2fjl2MDT44WoOZSW6UARzEtxizXoRb6F3X
         UaUw==
X-Gm-Message-State: AOAM533HMQlsq2xcrk++h35WRjYeT93S7zfdWuJUEWk+1vYhQZKSNuME
        BoEGS9sAbbDOglDgSOooOvi/Co3+nuyv61aDzQDFAtMfRV6aUGWgqq/1/UZXcPApe/yQScjsGa7
        iR4Yusx8ByssF1Mi5
X-Received: by 2002:a17:906:6a08:: with SMTP id qw8mr16861432ejc.200.1635756246073;
        Mon, 01 Nov 2021 01:44:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyd49MFk73UCNOr557C1b0YMN2BJsE8P1scufrL9YzNQZV1E2Ocll2Ydrc/TjafnpwIacvjTA==
X-Received: by 2002:a17:906:6a08:: with SMTP id qw8mr16861416ejc.200.1635756245941;
        Mon, 01 Nov 2021 01:44:05 -0700 (PDT)
Received: from redhat.com ([176.12.204.186])
        by smtp.gmail.com with ESMTPSA id ho17sm1128483ejc.111.2021.11.01.01.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 01:44:05 -0700 (PDT)
Date:   Mon, 1 Nov 2021 04:44:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Andrew Melnychenko <andrew@daynix.com>
Cc:     jasowang@redhat.com, davem@davemloft.net, kuba@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuri.benditovich@daynix.com,
        yan@daynix.com
Subject: Re: [RFC PATCH 2/4] drivers/net/virtio_net: Changed mergeable buffer
 length calculation.
Message-ID: <20211101044051-mutt-send-email-mst@kernel.org>
References: <20211031045959.143001-1-andrew@daynix.com>
 <20211031045959.143001-3-andrew@daynix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211031045959.143001-3-andrew@daynix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 31, 2021 at 06:59:57AM +0200, Andrew Melnychenko wrote:
> Now minimal virtual header length is may include the entire v1 header
> if the hash report were populated.
> 
> Signed-off-by: Andrew Melnychenko <andrew@daynix.com>

subject isn't really descriptive. changed it how?

And I couldn't really decypher what this log entry means either.

> ---
>  drivers/net/virtio_net.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index b72b21ac8ebd..abca2e93355d 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -393,7 +393,9 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  	hdr_p = p;
>  
>  	hdr_len = vi->hdr_len;
> -	if (vi->mergeable_rx_bufs)
> +	if (vi->has_rss_hash_report)
> +		hdr_padded_len = sizeof(struct virtio_net_hdr_v1_hash);
> +	else if (vi->mergeable_rx_bufs)
>  		hdr_padded_len = sizeof(*hdr);
>  	else
>  		hdr_padded_len = sizeof(struct padded_vnet_hdr);
> @@ -1252,7 +1254,7 @@ static unsigned int get_mergeable_buf_len(struct receive_queue *rq,
>  					  struct ewma_pkt_len *avg_pkt_len,
>  					  unsigned int room)
>  {
> -	const size_t hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
> +	const size_t hdr_len = ((struct virtnet_info *)(rq->vq->vdev->priv))->hdr_len;
>  	unsigned int len;
>  
>  	if (room)

Is this pointer chasing the best we can do?

> @@ -2817,7 +2819,7 @@ static void virtnet_del_vqs(struct virtnet_info *vi)
>   */
>  static unsigned int mergeable_min_buf_len(struct virtnet_info *vi, struct virtqueue *vq)
>  {
> -	const unsigned int hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
> +	const unsigned int hdr_len = vi->hdr_len;
>  	unsigned int rq_size = virtqueue_get_vring_size(vq);
>  	unsigned int packet_len = vi->big_packets ? IP_MAX_MTU : vi->dev->max_mtu;
>  	unsigned int buf_len = hdr_len + ETH_HLEN + VLAN_HLEN + packet_len;
> -- 
> 2.33.1

