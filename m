Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD45409F7B
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 00:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239465AbhIMWML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 18:12:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26534 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229502AbhIMWML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 18:12:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631571054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rQ0acbjQtHAV3rFR5+GgJ07ft28vuOa09pEy82ng1BQ=;
        b=F8i5643mJyzt8I8sEbw8QtFSZu6n7IMM6QHpcYi1TvOChFK4oEJbjAnRY1oKgN6uS4gEV1
        Kf1QjKkvBzLffQ87E4zDvwb8QoA+JobjOzxArwSaBSCChLz79UcZXL5co4X46LdV4zfRD4
        5tNchioARI++9RATzj5y2Yw6f04wAEs=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-pe_lJmGQMMWOQ6kbFGs4eA-1; Mon, 13 Sep 2021 18:10:53 -0400
X-MC-Unique: pe_lJmGQMMWOQ6kbFGs4eA-1
Received: by mail-ej1-f72.google.com with SMTP id g18-20020a17090670d200b005f0df5ce29bso1594151ejk.1
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 15:10:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rQ0acbjQtHAV3rFR5+GgJ07ft28vuOa09pEy82ng1BQ=;
        b=WN3ewDyfCJnr4VZjofB0ffNpdAYc0tbp3RYZ9TnNm0g94SwslOQroO1HPvQ2vr1JWB
         urD5HqjHAEOMm4E0+9uHop8u1w4oJ4BzjYp0hhTPz2JUi2SnTNv81OHlFqWMb2cK04Lv
         1fqjtAju1SUx5iSX4zD8yfSFgQo23p9fYLfG46VwOm7p3W43osMq/LXLCL5Nv3FdbZ8L
         6IVNQ6mQc7aHMLV+VlnDwfjnGYzjnMiwH4/l3jcchrjpOYs+0d8iFUXN3Fe+GHGbb2tY
         XAE6kdki+/XKwCaGK8owPvHD63T+4VqaUHhWlxBua1OCu5vuV3I+pJ4LAwC9V4gx/VgW
         Y5Pw==
X-Gm-Message-State: AOAM5322G4X1tRrxYv/7i3pZ8HAOF0/K3W1VA3X+4Yvl7HmC3jsO1jI3
        atpqIGv7GTF6ylDZdNVL01+IxtWXrQgZQYi0P5md/rwCHjvyCC4Y8LfGe8aL9dnmt2NQ0ILEgOF
        KAA/R6GDLClXCFzQL
X-Received: by 2002:a05:6402:897:: with SMTP id e23mr15548548edy.366.1631571051919;
        Mon, 13 Sep 2021 15:10:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKdcPr8fwbCL2Ow/xmTE9skucboofEHn/co0DLPi+a/8HIN/dV9hXHxNksTjN78Se4W+uCLA==
X-Received: by 2002:a05:6402:897:: with SMTP id e23mr15548500edy.366.1631571051760;
        Mon, 13 Sep 2021 15:10:51 -0700 (PDT)
Received: from redhat.com ([2.55.151.134])
        by smtp.gmail.com with ESMTPSA id b8sm4483234edv.96.2021.09.13.15.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 15:10:51 -0700 (PDT)
Date:   Mon, 13 Sep 2021 18:10:49 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH][net-next][v2] virtio_net:
 s/raw_smp_processor_id/smp_processor_id/ in virtnet_xdp_get_sq
Message-ID: <20210913181040-mutt-send-email-mst@kernel.org>
References: <1631173771-43848-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1631173771-43848-1-git-send-email-lirongqing@baidu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 09, 2021 at 03:49:31PM +0800, Li RongQing wrote:
> virtnet_xdp_get_sq() is called in non-preemptible context, so
> it's safe to call the function smp_processor_id(), and keep
> smp_processor_id(), and remove the calling of raw_smp_processor_id(),
> this way we'll get a warning if this is ever called in a preemptible
> context in the future
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> diff with v1: change log based on Michael S. Tsirkin's suggestion
> 
>  drivers/net/virtio_net.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 2e42210..2a7b368 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -528,19 +528,20 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
>   * functions to perfectly solve these three problems at the same time.
>   */
>  #define virtnet_xdp_get_sq(vi) ({                                       \
> +	int cpu = smp_processor_id();                                   \
>  	struct netdev_queue *txq;                                       \
>  	typeof(vi) v = (vi);                                            \
>  	unsigned int qp;                                                \
>  									\
>  	if (v->curr_queue_pairs > nr_cpu_ids) {                         \
>  		qp = v->curr_queue_pairs - v->xdp_queue_pairs;          \
> -		qp += smp_processor_id();                               \
> +		qp += cpu;                                              \
>  		txq = netdev_get_tx_queue(v->dev, qp);                  \
>  		__netif_tx_acquire(txq);                                \
>  	} else {                                                        \
> -		qp = smp_processor_id() % v->curr_queue_pairs;          \
> +		qp = cpu % v->curr_queue_pairs;                         \
>  		txq = netdev_get_tx_queue(v->dev, qp);                  \
> -		__netif_tx_lock(txq, raw_smp_processor_id());           \
> +		__netif_tx_lock(txq, cpu);                              \
>  	}                                                               \
>  	v->sq + qp;                                                     \
>  })
> -- 
> 1.7.1

