Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E759E3BC279
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 20:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhGESLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 14:11:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21706 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229725AbhGESLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 14:11:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625508508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+XDBgAIxW6pdEejIaonmOo/MplTpWCHPD2NVSNjT1SA=;
        b=V87CLZkTqPM0AuLIoNUApKZRRKiuZi2juuH8h63Rsxnj5htNNSSRgGcdjAbzpENvTbhPhh
        7sjS9dcxLedwX1WU2S/NoE9ZLyQY43JhNaysXNO7oTdYpGvvz54ceLVSLT+TdWP3a9QnX0
        qAgMVbeoJY+7YcuhNmM9zjl8mxxlHgE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-89ApJas6NSSFnvf2lTQv-A-1; Mon, 05 Jul 2021 14:08:27 -0400
X-MC-Unique: 89ApJas6NSSFnvf2lTQv-A-1
Received: by mail-ej1-f72.google.com with SMTP id u4-20020a1709061244b02904648b302151so5285697eja.17
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 11:08:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+XDBgAIxW6pdEejIaonmOo/MplTpWCHPD2NVSNjT1SA=;
        b=r4AQtEWRx5F3bR6BTwk2SFtCT05WFcRE4TDUeDlbH3EqWKrR4hTxsBZqcm4zyqvdO+
         U5qZ+pZj3HV33atcH/1+6+755zs2zMPSYaexGo/2jbhymTj6e7jX8zpWxBiyLmsLx54L
         f7HuUnHtdYvR5RU5YhzqCy6gsTnYIDV3Bqipc9jkfiD5PXQKD7qDx104KC9P6FrF1j6N
         /bYqnFrdjIWRDwU483bUVDZAvdmy85vNvzppZyO1m1myfRc4N0bUUJOCNIBhhIfyk+QO
         YkJrGanGS2DCN5sEzrVW0BvcT++Z4fwVHAuEUwQyfdR5XAxGvjlvvicnG2pj8z2PTtHM
         HYpQ==
X-Gm-Message-State: AOAM5320IcfhBdmkRX7S1RroqnO6UJgIWgLHiGid3bDw1Qj7jm3UgKPC
        1N/CuBFyLOS3AzD33uNxBWyAHBraPgfP4BHSmoo13H4JhT0Lxi8HlEkINGDEzKMaPNG47YTw6sJ
        3DQKMfGed+UH8vx5Q
X-Received: by 2002:a17:906:25d5:: with SMTP id n21mr14622123ejb.156.1625508506153;
        Mon, 05 Jul 2021 11:08:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzx0csAmCPBvgJN2qcgJ2LBHypBgXDhn2ZX3wnzq6YN56MELAQQsGKH3g2ad49ggziNI8A80g==
X-Received: by 2002:a17:906:25d5:: with SMTP id n21mr14622106ejb.156.1625508505979;
        Mon, 05 Jul 2021 11:08:25 -0700 (PDT)
Received: from redhat.com ([2.55.8.91])
        by smtp.gmail.com with ESMTPSA id j1sm5871273edl.80.2021.07.05.11.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 11:08:25 -0700 (PDT)
Date:   Mon, 5 Jul 2021 14:08:22 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        jasowang@redhat.com, dingxiaoxiong@huawei.com
Subject: Re: [PATCH net] virtio_net: check virtqueue_add_sgs() return value
Message-ID: <20210705140505-mutt-send-email-mst@kernel.org>
References: <63453491987be2b31062449bd59224faca9f546a.1625486802.git.wangyunjian@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63453491987be2b31062449bd59224faca9f546a.1625486802.git.wangyunjian@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 05, 2021 at 09:53:39PM +0800, wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> As virtqueue_add_sgs() can fail, we should check the return value.
> 
> Addresses-Coverity-ID: 1464439 ("Unchecked return value")
> Fixes: a7c58146cf9a ("virtio_net: don't crash if virtqueue is broken.")

What does this have to do with it?

> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> ---
>  drivers/net/virtio_net.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index b0b81458ca94..2b852578551e 100644
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
> @@ -1762,7 +1763,9 @@ static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
>  	sgs[out_num] = &stat;
>  
>  	BUG_ON(out_num + 1 > ARRAY_SIZE(sgs));
> -	virtqueue_add_sgs(vi->cvq, sgs, out_num, 1, vi, GFP_ATOMIC);
> +	ret = virtqueue_add_sgs(vi->cvq, sgs, out_num, 1, vi, GFP_ATOMIC);
> +	if (ret < 0)
> +		return false;

and maybe dev_warn here. these things should not happen.


>  
>  	if (unlikely(!virtqueue_kick(vi->cvq)))
>  		return vi->ctrl->status == VIRTIO_NET_OK;
> -- 
> 2.23.0

