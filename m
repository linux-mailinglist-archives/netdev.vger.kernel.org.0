Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA66235550
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 06:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgHBElr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 00:41:47 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35758 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725772AbgHBElq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 00:41:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596343301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WSdrvg2YvYascbYVHHvTm85An234N2vCK73IsEKQab0=;
        b=PmTvjwn0EQ1kX4v+v3uA1Qnvu2VOV8zsVmO3CsbowfGELkeVsXxgMJJPFrMsby0hRVyNjO
        g32NXcIRrqu6PRmYFDD/W7ipHm/ZZkw7SQ5ogRHOumgDRpiVsJva9gMz+/EUrayXKDX6qN
        exsyiZV1mOPcnB6I4UmE0ABm0obpYmM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-fZEZ2H9CNdKOyiDEWC3kfQ-1; Sun, 02 Aug 2020 00:40:31 -0400
X-MC-Unique: fZEZ2H9CNdKOyiDEWC3kfQ-1
Received: by mail-wr1-f71.google.com with SMTP id t12so10321320wrp.0
        for <netdev@vger.kernel.org>; Sat, 01 Aug 2020 21:40:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WSdrvg2YvYascbYVHHvTm85An234N2vCK73IsEKQab0=;
        b=eLyXazW8NIquLzilBOsSWzzSgHN0f/1chxUyN8midNuGYMpoYUTfJJphx4t8rwdPcL
         7/4MdA9TC5qjbIYYlaCpBmwIzd6DZyDE0IvF3Mmd06pwDXrdlKGsPrH/NiboCfL5DeXL
         XbwGjsmCPeSYPL5Um/vEd2SiqtaLFYzdqMxtGBK3nLTL7O64albYZPVJlPOjgec0Uuu0
         4XU8Yu0REbsSYqn/Z88KHuRJ6z6OnPhooatUrCYUjUdP59x6lEtrkyfTPhm+hMBn6M4x
         jJEqTUkaAo9vTEBFmME+y/iT5o3+na/GKLzz3a8XOXVKpNxYnjrrnydYtOXbmzjb7TGQ
         F2bg==
X-Gm-Message-State: AOAM533jdgeQoKY6MyqSo/USOccSi8GLRTdyqaDpIT7evjQmYclTiWTd
        fi7fE2x6IfBxo1puO/1NDS0paRdGr6nJG0j+kVFAZ/tuwUsjxGShtf9RYq6xSIFiV6Hd9EQLUbr
        598o1CvmR8DhC6Xcb
X-Received: by 2002:a1c:9d86:: with SMTP id g128mr10841346wme.78.1596343230570;
        Sat, 01 Aug 2020 21:40:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzIxjatp+nqrvLKOYt9i54Gx1LoTDJJzyK4onWQ5TgTLx5/oAahS//xHn7N1dRol4syEj960A==
X-Received: by 2002:a1c:9d86:: with SMTP id g128mr10841340wme.78.1596343230416;
        Sat, 01 Aug 2020 21:40:30 -0700 (PDT)
Received: from redhat.com (bzq-79-179-105-63.red.bezeqint.net. [79.179.105.63])
        by smtp.gmail.com with ESMTPSA id p14sm20510323wrx.90.2020.08.01.21.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2020 21:40:29 -0700 (PDT)
Date:   Sun, 2 Aug 2020 00:40:25 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mao Wenan <wenan.mao@linux.alibaba.com>
Cc:     jasowang@redhat.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH -next] virtio_net: Avoid loop in virtnet_poll
Message-ID: <20200802003818-mutt-send-email-mst@kernel.org>
References: <1596339683-117617-1-git-send-email-wenan.mao@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596339683-117617-1-git-send-email-wenan.mao@linux.alibaba.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 02, 2020 at 11:41:23AM +0800, Mao Wenan wrote:
> The loop may exist if vq->broken is true,
> virtqueue_get_buf_ctx_packed or virtqueue_get_buf_ctx_split
> will return NULL, so virtnet_poll will reschedule napi to
> receive packet, it will lead cpu usage(si) to 100%.
> 
> call trace as below:
> virtnet_poll
> 	virtnet_receive
> 		virtqueue_get_buf_ctx
> 			virtqueue_get_buf_ctx_packed
> 			virtqueue_get_buf_ctx_split
> 	virtqueue_napi_complete
> 		virtqueue_napi_schedule //it will reschedule napi
> 
> Signed-off-by: Mao Wenan <wenan.mao@linux.alibaba.com>

I think it's more a bug in virtqueue_poll : virtqueue_get_buf reports
NULL on broken, so virtqueue_poll should report false for consistency.



> ---
>  drivers/net/virtio_net.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index ba38765..a058da1 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -327,7 +327,8 @@ static void virtqueue_napi_complete(struct napi_struct *napi,
>  
>  	opaque = virtqueue_enable_cb_prepare(vq);
>  	if (napi_complete_done(napi, processed)) {
> -		if (unlikely(virtqueue_poll(vq, opaque)))
> +		if (unlikely(virtqueue_poll(vq, opaque)) &&
> +		    unlikely(!virtqueue_is_broken(vq)))
>  			virtqueue_napi_schedule(napi, vq);
>  	} else {
>  		virtqueue_disable_cb(vq);
> -- 
> 1.8.3.1

