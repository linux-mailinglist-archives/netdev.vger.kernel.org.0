Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181CE395581
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 08:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhEaGgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 02:36:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36953 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230070AbhEaGgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 02:36:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622442868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tsg5GGKLkxbsyGYTd9aXnL4iv/849gVD3+1fI3sYsVU=;
        b=gN9mLMjpyQ1EO8FZUw9OBjDw+650p7mdpxK0Y03oKD61+dmUqN04O579FM+voEWKBByhV6
        xHyJ3LFddy/FZzfIF09bEmIdWejH8BtP9vLZFhReT/aoKpsY+6Pp67LX7zhZoksyjjE/fn
        EwgNA3/OGISMibM2WklnkidbcpsmIEU=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-3ypGhmLBO8Ce_iA3oboCgw-1; Mon, 31 May 2021 02:34:26 -0400
X-MC-Unique: 3ypGhmLBO8Ce_iA3oboCgw-1
Received: by mail-pj1-f72.google.com with SMTP id v10-20020a17090a7c0ab029015f673a4c30so7900270pjf.5
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 23:34:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=tsg5GGKLkxbsyGYTd9aXnL4iv/849gVD3+1fI3sYsVU=;
        b=aFJEqzPy+zS60ScaoWk08twaw2bojtrxn2+LubGbwk0xnr01Pca3XDEWWIo2Ec3LPa
         S0ypkhn0eO07NZAZag7UguEM6a6zpMnPxke1vrgHhL537XufLNLGBedDl3poStx58UpE
         YpjtDt/pXc2ae37u7ViayoEn8g0ryJYoZrjGt82YVjwl4ZYTzU+WdlpBtuspEuK7wLnX
         1LeSRawEjx1OA3GgoKQYxoCPbvSXd671LDMYxYBKiAB35ZAeRFsYg9//UjmYM/2PEW+b
         K2d6tH0E7GuMF91TncyOkXPdF4IKiTLu/JHaKggzW2BWkwUJkLH8XybJtaedWAFPrJU+
         O46g==
X-Gm-Message-State: AOAM531mwW15LfX6Ot3jIvqcYHzXBsw1F21GIMGRPCRrfnQLw0rzdFQW
        umAVFF6nnW8lsKuY1bHpIbMQXa6tvYDJSnjWh9xvkYEmGgJsrr95obo+EDSPxlVpnyaTuIdiZ+2
        ddjIGX3lcwapbNIgANcbUyqupLd/7TyD+roDM9lMbQRevpT1C/HMNV7JNLrFWRa5uvrr0
X-Received: by 2002:a17:90a:7345:: with SMTP id j5mr17475737pjs.64.1622442864854;
        Sun, 30 May 2021 23:34:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzFb8EfTvkxMFMlIjMbDEB4OqIHs6rtiQvEP0itBg0SNFfkGDpbAyofVggBgFw2WcbkeTEEqQ==
X-Received: by 2002:a17:90a:7345:: with SMTP id j5mr17475708pjs.64.1622442864485;
        Sun, 30 May 2021 23:34:24 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c17sm10740228pgm.3.2021.05.30.23.34.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 May 2021 23:34:24 -0700 (PDT)
Subject: Re: [PATCH] virtio: Introduce a new kick interface
 virtqueue_kick_try()
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20210519114757.6143-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <fdfca0e9-dd2c-13a2-39ed-b360f7bcb881@redhat.com>
Date:   Mon, 31 May 2021 14:34:16 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210519114757.6143-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/5/19 ÏÂÎç7:47, Xuan Zhuo Ð´µÀ:
> Unlike virtqueue_kick(), virtqueue_kick_try() returns true only when the
> kick is successful. In virtio-net, we want to count the number of kicks.
> So we need an interface that can perceive whether the kick is actually
> executed.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


> ---
>   drivers/net/virtio_net.c     |  8 ++++----
>   drivers/virtio/virtio_ring.c | 20 ++++++++++++++++++++
>   include/linux/virtio.h       |  2 ++
>   3 files changed, 26 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 9b6a4a875c55..167697030cb6 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -617,7 +617,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>   	ret = nxmit;
>   
>   	if (flags & XDP_XMIT_FLUSH) {
> -		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq))
> +		if (virtqueue_kick_try(sq->vq))
>   			kicks = 1;
>   	}
>   out:
> @@ -1325,7 +1325,7 @@ static bool try_fill_recv(struct virtnet_info *vi, struct receive_queue *rq,
>   		if (err)
>   			break;
>   	} while (rq->vq->num_free);
> -	if (virtqueue_kick_prepare(rq->vq) && virtqueue_notify(rq->vq)) {
> +	if (virtqueue_kick_try(rq->vq)) {
>   		unsigned long flags;
>   
>   		flags = u64_stats_update_begin_irqsave(&rq->stats.syncp);
> @@ -1533,7 +1533,7 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
>   
>   	if (xdp_xmit & VIRTIO_XDP_TX) {
>   		sq = virtnet_xdp_get_sq(vi);
> -		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
> +		if (virtqueue_kick_try(sq->vq)) {
>   			u64_stats_update_begin(&sq->stats.syncp);
>   			sq->stats.kicks++;
>   			u64_stats_update_end(&sq->stats.syncp);
> @@ -1710,7 +1710,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>   	}
>   
>   	if (kick || netif_xmit_stopped(txq)) {
> -		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
> +		if (virtqueue_kick_try(sq->vq)) {
>   			u64_stats_update_begin(&sq->stats.syncp);
>   			sq->stats.kicks++;
>   			u64_stats_update_end(&sq->stats.syncp);
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 71e16b53e9c1..1462be756875 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -1874,6 +1874,26 @@ bool virtqueue_kick(struct virtqueue *vq)
>   }
>   EXPORT_SYMBOL_GPL(virtqueue_kick);
>   
> +/**
> + * virtqueue_kick_try - try update after add_buf
> + * @vq: the struct virtqueue
> + *
> + * After one or more virtqueue_add_* calls, invoke this to kick
> + * the other side.
> + *
> + * Caller must ensure we don't call this with other virtqueue
> + * operations at the same time (except where noted).
> + *
> + * Returns true if kick success, otherwise false.
> + */
> +bool virtqueue_kick_try(struct virtqueue *vq)
> +{
> +	if (virtqueue_kick_prepare(vq) && virtqueue_notify(vq))
> +		return true;
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(virtqueue_kick_try);
> +
>   /**
>    * virtqueue_get_buf - get the next used buffer
>    * @_vq: the struct virtqueue we're talking about.
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index b1894e0323fa..45cd6a0af24d 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -59,6 +59,8 @@ int virtqueue_add_sgs(struct virtqueue *vq,
>   
>   bool virtqueue_kick(struct virtqueue *vq);
>   
> +bool virtqueue_kick_try(struct virtqueue *vq);
> +
>   bool virtqueue_kick_prepare(struct virtqueue *vq);
>   
>   bool virtqueue_notify(struct virtqueue *vq);

