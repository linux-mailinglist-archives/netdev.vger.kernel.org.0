Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83E83925E3
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 06:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbhE0ELY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 00:11:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29373 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229815AbhE0ELW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 00:11:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622088587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wBe+WAqe1LvMNei/i+ZstF+sRF4xUcPxxYumZ/kXj0k=;
        b=dDFLOQi7BJ8zp0Q66KRDVwOyet/07ROWq9dkCY3AtqKQpz20CXsBaLyYjP4sCxCvz14SBw
        NZ2AnnUPadAyLLmZvxYPul4XhBW+vry0BoEt1H8LXBrLineIHHxdZokr4bQJ6bH6Ma7gz6
        KVeyHzAF6SrFK76hmACynr+yh0JwuFo=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-rtSoETBYMteiHN5WfmBe_g-1; Thu, 27 May 2021 00:09:43 -0400
X-MC-Unique: rtSoETBYMteiHN5WfmBe_g-1
Received: by mail-pj1-f72.google.com with SMTP id j8-20020a17090a94c8b029015f7f304d3cso1754388pjw.2
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 21:09:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=wBe+WAqe1LvMNei/i+ZstF+sRF4xUcPxxYumZ/kXj0k=;
        b=Zzamz2KgDk+9hrBOa7QZw0QUapu5+w2TNIT6bHn6MqHXMdst8Ps6/54aO2vatmXwCS
         qytgnopsYvuIXWKVnNIICobMtUmdEfUd51pQd4W8hb5lX3pAO37i2kDiMKvNUCpthNA2
         e8DF8oSKGNh2PjXV3C4vEfH6ULrulhmPBMYV8idsxN7cJ3nWZy0bKhzt+fdtHwL41moq
         3Eqau6ADAI3K6oyEtlrsPaK1m2JhBL8CVZ4+EExZwyIJYgw980mIxCcBNHYqIS/tKsFS
         G0zbT3Q1BaTRGQD1XI6vmV9qsRSZvTbpLxwt0APPGLwbvhZ+aPW+wn7HcY/3zjqQS+SZ
         eQHg==
X-Gm-Message-State: AOAM532m6oGRhh24pEKPw5+dy+tchcIcgxE8yNbNxaz4PniLfXt2yDIt
        JXnZFDDC3wQLftxnclZefsheurXb32OsnxgdPNiBAL2QpDSmIYg7kcMQS2l65ERHO4DkQSWHTYW
        1wktWFVtPQ7m/uBfZ
X-Received: by 2002:a63:5c1:: with SMTP id 184mr1861062pgf.75.1622088582029;
        Wed, 26 May 2021 21:09:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTAHP0gw/F59OqCLLOcCwr9JK2POhGoj1X/tPOGqlOz0+IIpsFpiVxngu3r0GxYENND8bG8Q==
X-Received: by 2002:a63:5c1:: with SMTP id 184mr1861048pgf.75.1622088581778;
        Wed, 26 May 2021 21:09:41 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 21sm583262pfh.103.2021.05.26.21.09.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 21:09:41 -0700 (PDT)
Subject: Re: [PATCH v3 4/4] virtio_net: disable cb aggressively
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org
References: <20210526082423.47837-1-mst@redhat.com>
 <20210526082423.47837-5-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <93ed586a-d805-2fda-60e7-68eca9e8ac97@redhat.com>
Date:   Thu, 27 May 2021 12:09:31 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210526082423.47837-5-mst@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/5/26 ÏÂÎç4:24, Michael S. Tsirkin Ð´µÀ:
> There are currently two cases where we poll TX vq not in response to a
> callback: start xmit and rx napi.  We currently do this with callbacks
> enabled which can cause extra interrupts from the card.  Used not to be
> a big issue as we run with interrupts disabled but that is no longer the
> case, and in some cases the rate of spurious interrupts is so high
> linux detects this and actually kills the interrupt.
>
> Fix up by disabling the callbacks before polling the tx vq.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   drivers/net/virtio_net.c | 16 ++++++++++++----
>   1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index c29f42d1e04f..a83dc038d8af 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1433,7 +1433,10 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
>   		return;
>   
>   	if (__netif_tx_trylock(txq)) {
> -		free_old_xmit_skbs(sq, true);
> +		do {
> +			virtqueue_disable_cb(sq->vq);
> +			free_old_xmit_skbs(sq, true);
> +		} while (unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
>   
>   		if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
>   			netif_tx_wake_queue(txq);
> @@ -1605,12 +1608,17 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>   	struct netdev_queue *txq = netdev_get_tx_queue(dev, qnum);
>   	bool kick = !netdev_xmit_more();
>   	bool use_napi = sq->napi.weight;
> +	unsigned int bytes = skb->len;
>   
>   	/* Free up any pending old buffers before queueing new ones. */
> -	free_old_xmit_skbs(sq, false);
> +	do {
> +		if (use_napi)
> +			virtqueue_disable_cb(sq->vq);
>   
> -	if (use_napi && kick)
> -		virtqueue_enable_cb_delayed(sq->vq);
> +		free_old_xmit_skbs(sq, false);
> +
> +	} while (use_napi && kick &&
> +	       unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
>   
>   	/* timestamp packet in software */
>   	skb_tx_timestamp(skb);


I wonder whehter we can simple disable cb during ndo_start_xmit(), or is 
there a way to make xmit and napi work in parallel?

Thanks


