Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34BE27BD12
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 08:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbgI2GXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 02:23:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24858 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725306AbgI2GXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 02:23:47 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601360626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WDstdGqtEAJju1eS1p93fmGiOcQC93sT9aqMaSNKp3U=;
        b=eWMe0NZRXAfuTGKbgCnSlx1FPfpDKksv0p6vF+tH4EZZEcrblCZuwGS7k4No7iVkROixBy
        X5fcEtmOET0Ofz361yEwSxY53KiocVJriKtPgKBkvJQ90J+hMqJ601jm2Y/oYriIUP+yIp
        dLrmzRnbCvWT61eSR4QljixYvhiAanE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-oOy2cntWOfSJwobCSVKgdg-1; Tue, 29 Sep 2020 02:23:43 -0400
X-MC-Unique: oOy2cntWOfSJwobCSVKgdg-1
Received: by mail-wm1-f69.google.com with SMTP id t8so1299251wmj.6
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 23:23:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WDstdGqtEAJju1eS1p93fmGiOcQC93sT9aqMaSNKp3U=;
        b=GriEdracdkzyBw9TAA5+xUSIJOd0mllzvu6jY0sijvvOldlhb3PsES4tEV9LiQRYLe
         aoCTsF6zdRDFz1YgcY58mEhU0ANcNYFvMi74x5iaiT5i2R26jiswPeF06il+LcNTSgHu
         BhVvG2gv69+S9cEH6+7QdKkbomZBuMGr9P0x0zrTe2PsLDjqVwJh+4A+rxhDSDUMZzWd
         OA3NoZHpKTmQVoge6NR/5ie5RyM2PYD3p4Jsgy+sqhgehSqG+XE7iYQWjddS+9iW9mm0
         0svKqM3c3grnyXMGqgFJeCkCYj4SezKX1t0uTgPHkXXH8Oh9tpj6PGeGNqkMVRTJAcAL
         AQtQ==
X-Gm-Message-State: AOAM530DswC8cs/90UruldljwbpSZa+Uy91B+jBFz21fx0LjRDu4+aMt
        W6Y1uqDtmuLxZxklzrIW8RF/BSMuOrj7xg7OeEckQiZSAh8P1j1xH3fETmUY40V16UB/fmkK1zp
        pigvaLFEVzc0LrvZL
X-Received: by 2002:a5d:6cb1:: with SMTP id a17mr2355533wra.386.1601360622339;
        Mon, 28 Sep 2020 23:23:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx02L8sSPi89+xS1T3nWYZeBR3AqSnXDP1arIPk/zaS8YRXPdPULp0o9ujn5tiIhHfcqjAwaQ==
X-Received: by 2002:a5d:6cb1:: with SMTP id a17mr2355522wra.386.1601360622182;
        Mon, 28 Sep 2020 23:23:42 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id x16sm4424846wrq.62.2020.09.28.23.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 23:23:41 -0700 (PDT)
Date:   Tue, 29 Sep 2020 02:23:39 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     xiangxia.m.yue@gmail.com
Cc:     jasowang@redhat.com, willemb@google.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] virtio-net: don't disable guest csum when disable
 LRO
Message-ID: <20200929022246-mutt-send-email-mst@kernel.org>
References: <20200929015806.19171-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929015806.19171-1-xiangxia.m.yue@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 09:58:06AM +0800, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> Open vSwitch and Linux bridge will disable LRO of the interface
> when this interface added to them. Now when disable the LRO, the
> virtio-net csum is disable too. That drops the forwarding performance.
> 
> Fixes: a02e8964eaf9 ("virtio-net: ethtool configurable LRO")
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
> v2:
> * change the fix-tag
> ---
>  drivers/net/virtio_net.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 7145c83c6c8c..21b71148c532 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -63,6 +63,11 @@ static const unsigned long guest_offloads[] = {
>  	VIRTIO_NET_F_GUEST_CSUM
>  };
>  
> +#define GUEST_OFFLOAD_LRO_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
> +				(1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
> +				(1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
> +				(1ULL << VIRTIO_NET_F_GUEST_UFO))
> +

I think I'd rather we open-coded this, the macro is only
used in one place ...

>  struct virtnet_stat_desc {
>  	char desc[ETH_GSTRING_LEN];
>  	size_t offset;
> @@ -2531,7 +2536,8 @@ static int virtnet_set_features(struct net_device *dev,
>  		if (features & NETIF_F_LRO)
>  			offloads = vi->guest_offloads_capable;
>  		else
> -			offloads = 0;
> +			offloads = vi->guest_offloads_capable &
> +				   ~GUEST_OFFLOAD_LRO_MASK;
>  
>  		err = virtnet_set_guest_offloads(vi, offloads);
>  		if (err)

> -- 
> 2.23.0

