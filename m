Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480CA1C6A80
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 09:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgEFHxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 03:53:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21013 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728280AbgEFHxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 03:53:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588751619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8W0xSmvUlYVndDM8MoTsGUiUlHlecuHz50ZkJqJ3zCY=;
        b=Blpzrd2Wm0O93KkVoSr1gHv6p+sBFkuXSXZOtue0JcgVJj5D4vrnSn0Md2XvG5gsoDvf4z
        rRBUyUEu+fgKB0LTd61nNmnA8rD+0HldQIVjWnFdL4x0xfYrYtuh7TIwd1zsHFf25jy41R
        h+CLBr6obYatALYAFJaZb2dOZV4F93g=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-rcBIN8IeMvmCI8iAgcSXBg-1; Wed, 06 May 2020 03:53:36 -0400
X-MC-Unique: rcBIN8IeMvmCI8iAgcSXBg-1
Received: by mail-wr1-f70.google.com with SMTP id e14so882447wrv.11
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 00:53:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8W0xSmvUlYVndDM8MoTsGUiUlHlecuHz50ZkJqJ3zCY=;
        b=P3IcF77LUSpt+P/oyaRnVNNcAqMuCAleXzi5+BVG2kvtgKS2Ss7t/fqQ2/AsKFpicu
         eAicLF9iKKh7XalT9nh4j+CMcFvvN3qAnGhPDi5YUdgpIoRDcqK8o2w2eQD1WGAASEwZ
         HyfxEjifedLayHHfQoK0ql0WVD+YvOqxCyFir0N3wRfF6k6b3U7+Ez/+5ZdPnAdpEQDA
         t7IBxY80kLlhmf/YLAE5n0mrNrSDF1A+qeOmGYb8df6FvjZ7yMbUnlMbPj1d+8qZrBmC
         2lJVQFDzLnRpASBIrO7Uqi9sCz53ACiiOxc35k9rF/DdRyP+LcJa/e8rcc9NRXsizZi7
         5dJA==
X-Gm-Message-State: AGi0PubFtWzXtYt9XhUtSqujxPl0DyEGU9HbQAPtkz3UXlTW/VtNv0Wm
        PFMhjXUGjMIj9DtmCY84IJEA+JSM7/sewlZQUC8JciSHbfmP+2rs6MSun5gF/Y/QBBup50mQSEV
        dde3gNhGy8fkHwSp+
X-Received: by 2002:a5d:6692:: with SMTP id l18mr8511144wru.423.1588751614938;
        Wed, 06 May 2020 00:53:34 -0700 (PDT)
X-Google-Smtp-Source: APiQypI/1wp+em/vQpb50Bo7ALnQIlQcctHrYO0O4kec4Eg43lHoV1FZjHRLjxj87amFb1+gASDZpQ==
X-Received: by 2002:a5d:6692:: with SMTP id l18mr8511130wru.423.1588751614751;
        Wed, 06 May 2020 00:53:34 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id p190sm1710263wmp.38.2020.05.06.00.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 00:53:34 -0700 (PDT)
Date:   Wed, 6 May 2020 03:53:31 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH net-next 1/2] virtio-net: don't reserve space for vnet
 header for XDP
Message-ID: <20200506033834-mutt-send-email-mst@kernel.org>
References: <20200506061633.16327-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506061633.16327-1-jasowang@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 02:16:32PM +0800, Jason Wang wrote:
> We tried to reserve space for vnet header before
> xdp.data_hard_start. But this is useless since the packet could be
> modified by XDP which may invalidate the information stored in the
> header and there's no way for XDP to know the existence of the vnet
> header currently.

What do you mean? Doesn't XDP_PASS use the header in the buffer?

> So let's just not reserve space for vnet header in this case.

In any case, we can find out XDP does head adjustments
if we need to.


> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/net/virtio_net.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 11f722460513..98dd75b665a5 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -684,8 +684,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
>  			page = xdp_page;
>  		}
>  
> -		xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
> -		xdp.data = xdp.data_hard_start + xdp_headroom;
> +		xdp.data_hard_start = buf + VIRTNET_RX_PAD;
> +		xdp.data = xdp.data_hard_start + xdp_headroom + vi->hdr_len;
>  		xdp.data_end = xdp.data + len;
>  		xdp.data_meta = xdp.data;
>  		xdp.rxq = &rq->xdp_rxq;
> @@ -845,7 +845,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  		 * the descriptor on if we get an XDP_TX return code.
>  		 */
>  		data = page_address(xdp_page) + offset;
> -		xdp.data_hard_start = data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
> +		xdp.data_hard_start = data - VIRTIO_XDP_HEADROOM;
>  		xdp.data = data + vi->hdr_len;
>  		xdp.data_end = xdp.data + (len - vi->hdr_len);
>  		xdp.data_meta = xdp.data;
> -- 
> 2.20.1

