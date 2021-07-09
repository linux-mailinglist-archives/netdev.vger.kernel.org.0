Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE163C22AB
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 13:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhGILUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 07:20:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53992 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229641AbhGILUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 07:20:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625829474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UJ6+jTPvm3zp6vRVEAiXqOney7J+GbGODAZVlnLKWIE=;
        b=eDQ1OVjV5X7iWlIaxXEZte2hpLDqI0jeXrtQrCzHIPI4z1Ede+gtKcbkg0PALE3d+iE8PQ
        1+8Q8gG7DWnCUFzVSDxRVb9c11GvFzRk4lAE26ehEc0n3PJlNqxJLi6U3Ys4S+yRkIiGuh
        fWXDPvm34p++1+7sGAmYLZDLiS4kafs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-K2dJnxP1NeiMKgEoN1qGBA-1; Fri, 09 Jul 2021 07:17:53 -0400
X-MC-Unique: K2dJnxP1NeiMKgEoN1qGBA-1
Received: by mail-ed1-f69.google.com with SMTP id f20-20020a0564020054b0290395573bbc17so5049662edu.19
        for <netdev@vger.kernel.org>; Fri, 09 Jul 2021 04:17:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UJ6+jTPvm3zp6vRVEAiXqOney7J+GbGODAZVlnLKWIE=;
        b=rNvbStSsWlY83SIalIn/nNVAqTqbbrBBbbDbk/nYUHuLlmVBe8o57hce/i3QmldJAP
         YhJNAwrw1xk/SzJ1IVx/VMiyxB5hTq3CKBQ33kd06ok7ry3KsuYCzq5DNB4KwUNTV8bs
         1IR2qQDk0kqDBLPjz55FeR6racV+e3lUCI0hAR/18yPazqthD8mtdCI8vDE1zxV05Pqj
         A1g1l0pTh2XY1O92KzMwOylzh/hnYq6yh39YA9vjMx6Oun1zgWAqTkEOgM60TacT64zA
         2H0LTL0cMGAgYchuBQKfmEWfalUy6D+15wptOtjI35AsBh/RBkT0y3l6+YshSjHAxEq2
         TnKQ==
X-Gm-Message-State: AOAM533R1qoQExfQ1LQu5z3if7d6Sod1xcSZPzhcltRbx798buTfbgr2
        dzNkxrq1odtO/hXEdSZAiiy37jrYhApFjAzoOfnv5baLfC1zzK1L8bWW/OZvJNSH7gYvnsDJfqW
        uwADI4kouYYtxSSHL
X-Received: by 2002:a50:fc04:: with SMTP id i4mr34094549edr.285.1625829472634;
        Fri, 09 Jul 2021 04:17:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1Z4NMEv9yVGQ+I6pTSRYUGS0hxCozpWxVUL1H577kKHysyTvq8pucELd4qQ5eWTQyrENPzw==
X-Received: by 2002:a50:fc04:: with SMTP id i4mr34094528edr.285.1625829472474;
        Fri, 09 Jul 2021 04:17:52 -0700 (PDT)
Received: from redhat.com ([2.55.150.102])
        by smtp.gmail.com with ESMTPSA id lv15sm2259974ejb.76.2021.07.09.04.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 04:17:51 -0700 (PDT)
Date:   Fri, 9 Jul 2021 07:17:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        jasowang@redhat.com, dingxiaoxiong@huawei.com
Subject: Re: [PATCH net-next] virtio_net: check virtqueue_add_sgs() return
 value
Message-ID: <20210709071626-mutt-send-email-mst@kernel.org>
References: <1625826091-42668-1-git-send-email-wangyunjian@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1625826091-42668-1-git-send-email-wangyunjian@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 09, 2021 at 06:21:31PM +0800, wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> As virtqueue_add_sgs() can fail, we should check the return value.
> 
> Addresses-Coverity-ID: 1464439 ("Unchecked return value")
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> ---
> v2:
>   add warn log and remove fix tag
> ---
>  drivers/net/virtio_net.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index b0b81458ca94..30a0ca2fef1a 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1743,6 +1743,7 @@ static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
>  {
>  	struct scatterlist *sgs[4], hdr, stat;
>  	unsigned out_num = 0, tmp;
> +	int ret;
>  
>  	/* Caller should know better */
>  	BUG_ON(!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ));
> @@ -1762,7 +1763,12 @@ static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
>  	sgs[out_num] = &stat;
>  
>  	BUG_ON(out_num + 1 > ARRAY_SIZE(sgs));
> -	virtqueue_add_sgs(vi->cvq, sgs, out_num, 1, vi, GFP_ATOMIC);
> +	ret = virtqueue_add_sgs(vi->cvq, sgs, out_num, 1, vi, GFP_ATOMIC);
> +	if (ret < 0) {
> +		dev_warn(&vi->vdev->dev,
> +			 "Failed to add sgs for vq: %d\n.", ret);


That's not too clear. Pls make it clear that it's the command vq
that failed.


> +		return false;
> +	}
>  
>  	if (unlikely(!virtqueue_kick(vi->cvq)))
>  		return vi->ctrl->status == VIRTIO_NET_OK;
> -- 
> 2.23.0

