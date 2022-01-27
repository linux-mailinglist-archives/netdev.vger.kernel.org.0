Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830C449DBD8
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 08:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237479AbiA0Hrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 02:47:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30755 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237445AbiA0Hrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 02:47:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643269667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xkdPq4yx3Zwg5TsWMNJ53xqznx4G+wL2Z4oOgHdThh4=;
        b=FGCx5kuOiUQifFFTV0QbaTZCg4bozGiXTbF5WaJdWx6Q7Odc5j8yt9RwR2ubzUS7UxD15E
        zqKtYR2dr/lKK1pO0SM2y3pIhJpr8drxisHclEVI60+Hhi2h6TCd7dmoijzzmHd7ovZ2tq
        Q4D7YVTGNeDwV55yg9/zD5QM0z3kyHg=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-194-q2VvxjErNJab4_DsY27SMg-1; Thu, 27 Jan 2022 02:47:45 -0500
X-MC-Unique: q2VvxjErNJab4_DsY27SMg-1
Received: by mail-pj1-f72.google.com with SMTP id i8-20020a17090a718800b001b35ee7ac29so1437795pjk.3
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 23:47:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xkdPq4yx3Zwg5TsWMNJ53xqznx4G+wL2Z4oOgHdThh4=;
        b=RkyI/kw0J0nHJxxzV4a++9q1cg38Eh5vKXunDhPdZLggs+XuofTN4PLiGzRLbxijBj
         XXkcdTGIHqxpx8YL5TtY5JhZT1/yXaTOC5SbWtsgXWZQOKx78olFSp00VZYzOXEGXdTZ
         JDT1p47VEtwRDPtBnB1RXvoBtiqMRiFTaNw+xzRSOfIG6VCxJJDz7+aaE6YrXuDvPhU3
         eY0G79sGX6v/fyq+NZ8io+7qr22mKpwiqKcEd0PGbgmkHnZaDt8sTg/LV2Nx3daL/QPe
         lj7GkAA5HmdIzEer/VP6lXuRuhxV/qZ5StNsMLXhU5g6E0ftP73WpVE0Fx6rA/txyzjQ
         HOFQ==
X-Gm-Message-State: AOAM530EJfFfbat3qEfKnxeKkEEikKhffhNguwPwc12ZdPttszPyA2DE
        P1jzFPeShCX62Q8acXhyIbFHQJLqIqh5reoIxZrL4wqvMmYrtiI/0qwOSj13dEb8cqnfdSUUbck
        EuZLNytHAANDaN/y2
X-Received: by 2002:a63:7d0b:: with SMTP id y11mr1940248pgc.402.1643269664432;
        Wed, 26 Jan 2022 23:47:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwhkb6CFMMrOoWSQ7BaMpDPFHK9eL1ryoIoea8/zX+wWjUvBqsI5uIZGY8tiftBLWLZZexr9w==
X-Received: by 2002:a63:7d0b:: with SMTP id y11mr1940238pgc.402.1643269664195;
        Wed, 26 Jan 2022 23:47:44 -0800 (PST)
Received: from [10.72.13.149] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 25sm5282463pje.22.2022.01.26.23.47.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 23:47:43 -0800 (PST)
Message-ID: <acef3625-566b-6438-61a8-49d4363a148a@redhat.com>
Date:   Thu, 27 Jan 2022 15:47:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH v2 1/4] drivers/net/virtio_net: Fixed padded vheader to
 use v1 with hash.
Content-Language: en-US
To:     Andrew Melnychenko <andrew@daynix.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
References: <20220117080009.3055012-1-andrew@daynix.com>
 <20220117080009.3055012-2-andrew@daynix.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220117080009.3055012-2-andrew@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/1/17 下午4:00, Andrew Melnychenko 写道:
> The header v1 provides additional info about RSS.
> Added changes to computing proper header length.
> In the next patches, the header may contain RSS hash info
> for the hash population.
>
> Signed-off-by: Andrew Melnychenko <andrew@daynix.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/net/virtio_net.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 569eecfbc2cd..05fe5ba32187 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -242,13 +242,13 @@ struct virtnet_info {
>   };
>   
>   struct padded_vnet_hdr {
> -	struct virtio_net_hdr_mrg_rxbuf hdr;
> +	struct virtio_net_hdr_v1_hash hdr;
>   	/*
>   	 * hdr is in a separate sg buffer, and data sg buffer shares same page
>   	 * with this header sg. This padding makes next sg 16 byte aligned
>   	 * after the header.
>   	 */
> -	char padding[4];
> +	char padding[12];
>   };
>   
>   static bool is_xdp_frame(void *ptr)
> @@ -1266,7 +1266,8 @@ static unsigned int get_mergeable_buf_len(struct receive_queue *rq,
>   					  struct ewma_pkt_len *avg_pkt_len,
>   					  unsigned int room)
>   {
> -	const size_t hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
> +	struct virtnet_info *vi = rq->vq->vdev->priv;
> +	const size_t hdr_len = vi->hdr_len;
>   	unsigned int len;
>   
>   	if (room)
> @@ -2851,7 +2852,7 @@ static void virtnet_del_vqs(struct virtnet_info *vi)
>    */
>   static unsigned int mergeable_min_buf_len(struct virtnet_info *vi, struct virtqueue *vq)
>   {
> -	const unsigned int hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
> +	const unsigned int hdr_len = vi->hdr_len;
>   	unsigned int rq_size = virtqueue_get_vring_size(vq);
>   	unsigned int packet_len = vi->big_packets ? IP_MAX_MTU : vi->dev->max_mtu;
>   	unsigned int buf_len = hdr_len + ETH_HLEN + VLAN_HLEN + packet_len;

