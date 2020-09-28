Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B4B27B52B
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 21:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgI1TVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 15:21:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53974 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726500AbgI1TVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 15:21:17 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601320876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2OhlWzkl3+ngLI58gPOC/Z0lJ6eOh7uuWEoKpx328TM=;
        b=eoqmqQVNXx9hkQ7bxVoN+Vj9DJtkJYxXo+yXGy6eeDM3uh8XT/hhMMGnzYiCLg8SHPYCZ4
        jtYQ9Gh7urlqp7w45COr6jYOp6oDyO17Y/GV30Tg4FNh/G4pCFpxQzyYTaxeIA2W5uXm8G
        SXn1DPfZb1dZYFKCP4SJTp+jhO4C2lk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-ZgcapL0zMMyY-aIg4QqozA-1; Mon, 28 Sep 2020 15:21:14 -0400
X-MC-Unique: ZgcapL0zMMyY-aIg4QqozA-1
Received: by mail-wr1-f71.google.com with SMTP id l15so779550wro.10
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 12:21:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2OhlWzkl3+ngLI58gPOC/Z0lJ6eOh7uuWEoKpx328TM=;
        b=KBlSrftYsnq8t9yIA87DAt7j5Lm2m/KgPjr/hF3RBiICgFayAsTCW4vh80kkfidqpw
         I/oF3hX5aVOQSNk37yu6f5e62r0X2LR+uyD7AcHIYRR+owmbkzA0tct1hUJ97MCImqy4
         C9ug+qq45S6GCNhhQ3ypQSCm2lVGE0YFb5WUBJlIWspa7yt+xNtm7DkwSp5J8yMuhAxs
         FGI/mY/k8Y8tg9PRiRr8aAmDtLRo0FEPUMpBn7wG0jL0hu8vtABCm8H/qhpTOdAn6+HI
         ItW1LCyaiP0u83N6DH7N3H2ucmmurZnf60wsOm+rpScPWxiTlB3hheLxLlTBigE1SfFC
         wSjQ==
X-Gm-Message-State: AOAM5321HKqMt9R25Wq3mh6e+vVXVM4CH+cr70QXnIZESqeCuMUWOZZZ
        7mdJSMf0cJ9z3Rpb9amhsKh0OLo95S69uGR6mw8FBXve1ULP3ggi7Ag+/jsu7A4UPCsc8CPR02E
        Jyrr6HOT8lKz9gbRA
X-Received: by 2002:a5d:5306:: with SMTP id e6mr40834wrv.156.1601320871512;
        Mon, 28 Sep 2020 12:21:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7okRmYrVVUx0n6LCWLSnUOaq34NYTzgvkcsJF1a1sHoHmoT1V3VxY05bZkSpuaLhksN/TeA==
X-Received: by 2002:a5d:5306:: with SMTP id e6mr40820wrv.156.1601320871351;
        Mon, 28 Sep 2020 12:21:11 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id f6sm2551606wro.5.2020.09.28.12.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 12:21:10 -0700 (PDT)
Date:   Mon, 28 Sep 2020 15:21:07 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     xiangxia.m.yue@gmail.com
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH 1/2] virtio-net: don't disable guest csum when disable LRO
Message-ID: <20200928151531-mutt-send-email-mst@kernel.org>
References: <20200928033915.82810-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928033915.82810-1-xiangxia.m.yue@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 11:39:14AM +0800, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> Open vSwitch and Linux bridge will disable LRO of the interface
> when this interface added to them. Now when disable the LRO, the
> virtio-net csum is disable too. That drops the forwarding performance.
> 
> Fixes: e59ff2c49ae1 ("virtio-net: disable guest csum during XDP set")

I am a bit confused by this tag. Did this change bring about
disabling checksum when LRO is disabled? I am not sure
I follow how ...

> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
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

