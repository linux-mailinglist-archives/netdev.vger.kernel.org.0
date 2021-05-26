Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329F1391B71
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 17:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235428AbhEZPQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 11:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235399AbhEZPQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 11:16:43 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94621C061574;
        Wed, 26 May 2021 08:15:11 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id v12so1544228wrq.6;
        Wed, 26 May 2021 08:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zKJ+d2xdcQaoB86Ynp+qKaVBKetJQslZOwN/xQshRB8=;
        b=KES3ksYHStQ8/mkQZCs5zeLeMkaAH4nC6yhbnk9UPF7+IfT858MJijVOdsVUBP7HRc
         5pIh67hsUI8/kjjmVKZW0jVxpsfhwy7sS49DQ7t1GsCwkTfBXZzwvzjwMwLgAG3ycyot
         BsEU2khpD+3Xhgfe/XM3G/NGbNTf+Q3o3NPNNIVx5qWbd9D/SxNKeRdoZB5rQ6Mjq586
         uI9l/U6fU+yHOsAJHciWoKZnWzCQAPHUQJ17xawm7IsV1A9UgbSTLwuugRr8K4UKl+Ii
         nynya7Z67fF3cjfgnzErQrByX/+0jYaT5U5OCRhBPQdzy8zfHTacbzEJrk7CdRnPlOIq
         7KdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zKJ+d2xdcQaoB86Ynp+qKaVBKetJQslZOwN/xQshRB8=;
        b=ImWfOLFgK5OMySJis/AYshEZIe2D2clz0zrz9XlVKIoU+/cbvxyu1OLCv4ccUuuaHk
         Db62ufPm5Xjp0j/7AsSbC2g3r3mM7WcM9XyBzkObooc+c4oldi9jtpI8miljzNjpBCTe
         Osk9zXqiuOqIzFkRcTv1A++8AXAsAip+UErvDVSREqv0EEhw0MzwYyvWHPCNVWJKhBC4
         vjfy7zbg18ejktLLuJK6Ezkg459oMOy2IKFVSDXU9VNJVwJCzXV83L+BWOsQhZxJGz7t
         dymgSO3xG6bW5wi1NVc1tlRf1zwhfYGxonpyVE+Z3fp0KeWbsV8wzGkpbsRcRfoS/erU
         KBaw==
X-Gm-Message-State: AOAM530ReUx7sY1wVDEv6dTnPB+fgfI8GbHuEMR2xykbO3eiQWpgF4Te
        7rziupQBKPQwhhWlPUjveMU=
X-Google-Smtp-Source: ABdhPJy9NnY2LhH3kKQdhNXpEedeixyGrR0OX9dVm2JF4HKUWdQTid8aqP3v4clKFGZKsGe/8G02Bw==
X-Received: by 2002:a5d:45c6:: with SMTP id b6mr33464058wrs.333.1622042110246;
        Wed, 26 May 2021 08:15:10 -0700 (PDT)
Received: from [10.0.0.2] ([37.170.107.4])
        by smtp.gmail.com with ESMTPSA id k7sm20137292wro.8.2021.05.26.08.15.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 08:15:09 -0700 (PDT)
Subject: Re: [PATCH v3 4/4] virtio_net: disable cb aggressively
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>
References: <20210526082423.47837-1-mst@redhat.com>
 <20210526082423.47837-5-mst@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <18b47c22-8c8a-7699-ffaf-ccfdcbf39d37@gmail.com>
Date:   Wed, 26 May 2021 17:15:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210526082423.47837-5-mst@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/26/21 10:24 AM, Michael S. Tsirkin wrote:
> There are currently two cases where we poll TX vq not in response to a
> callback: start xmit and rx napi.  We currently do this with callbacks
> enabled which can cause extra interrupts from the card.  Used not to be
> a big issue as we run with interrupts disabled but that is no longer the
> case, and in some cases the rate of spurious interrupts is so high
> linux detects this and actually kills the interrupt.
> 
> Fix up by disabling the callbacks before polling the tx vq.


It is not clear why we want to poll TX completions from ndo_start_xmit() in napi mode ?

This seems not needed, adding costs to sender thread, this might
reduce the ability to use a different cpu for tx completions.

Also this will likely conflict with BQL model if we want to use BQL at some point.

> 

This probably needs a Fixes: tag 

> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/net/virtio_net.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index c29f42d1e04f..a83dc038d8af 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1433,7 +1433,10 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
>  		return;
>  
>  	if (__netif_tx_trylock(txq)) {
> -		free_old_xmit_skbs(sq, true);
> +		do {
> +			virtqueue_disable_cb(sq->vq);
> +			free_old_xmit_skbs(sq, true);
> +		} while (unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
>  
>  		if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
>  			netif_tx_wake_queue(txq);
> @@ -1605,12 +1608,17 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>  	struct netdev_queue *txq = netdev_get_tx_queue(dev, qnum);
>  	bool kick = !netdev_xmit_more();
>  	bool use_napi = sq->napi.weight;
> +	unsigned int bytes = skb->len;
>  
>  	/* Free up any pending old buffers before queueing new ones. */
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
>  	/* timestamp packet in software */
>  	skb_tx_timestamp(skb);
> 
