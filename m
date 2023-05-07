Return-Path: <netdev+bounces-736-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6D546F971A
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 07:59:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23FA01C21616
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 05:59:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 514C317F5;
	Sun,  7 May 2023 05:59:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7E717D8
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 05:59:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17BC11D89
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 22:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683439183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f3vnav72jiBSDlUv6QQjHr2dDSLqhQhKBN44HYd9MYY=;
	b=V6yiGzwKQRHbxyDoAKV4RMaRREhkIoAMSc+Fq7m/x/THyHx+wPVO1xSIeUaxynPRvaj9t/
	CJX6JBrqckFAofviaid+Ptmumsve3XbiKWfeSCGT7fSYEhPP19yDy3mXy5OCZ+HkD9h0z2
	fRpbdWxye5uetHHqOcH+WX/c0JeC93I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-QK4EF-tyMNOcRgAD0hBpwQ-1; Sun, 07 May 2023 01:59:42 -0400
X-MC-Unique: QK4EF-tyMNOcRgAD0hBpwQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f32b3835e9so12339885e9.1
        for <netdev@vger.kernel.org>; Sat, 06 May 2023 22:59:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683439181; x=1686031181;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f3vnav72jiBSDlUv6QQjHr2dDSLqhQhKBN44HYd9MYY=;
        b=N/LctD5hp1IxSZh7EIcrsfuoP7wYJzLlmixx+31eXZi7a/ZKVxBMSi7KQaTwYU6sWv
         jXmfuKfw3rZdMzth+FUq8WixKDuSDXegyLSqLypnFYXNbwkD4OuLVGh7+SBkbhR8MNuq
         J1aghvONoJl/MeWOteR2HwtvZFBLXn57i/3RXHTyXrvxEq3PtF6hdSnFGZH4pQ67DlAl
         xgbQLBN7PmUUmeLJ6p9dogdXtLeQCUhjByLqdJWL2D3gfSbEMy8qBfuJNn0F5j1zwawc
         iwmHXyOk7T8zWCQucykpIED6v+auOo14Xvh0lVXm+awYOd1Ms5UUv3b9ztjL1P2Ghxov
         FUUA==
X-Gm-Message-State: AC+VfDzKSLeJ6T2NiXpWCRC+qOH4rKMXIDvQ3N5CRbU6cZl5KWjxqatl
	h/iWPfpz9njxxmMO63hGd6cGNqnsZOWrXXsbRK9memCCJ57MJXpKgx/NIYKIzwfJUvKaDaQ6T5g
	EXTQFP2gVoCXSWXGv
X-Received: by 2002:a7b:c3cf:0:b0:3f4:21cf:b4a4 with SMTP id t15-20020a7bc3cf000000b003f421cfb4a4mr793837wmj.20.1683439181083;
        Sat, 06 May 2023 22:59:41 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5DUhiBqArpzzgosy6y74xywVU2Y2452GBQMAxT+LK1BKQwrXh1Hycvooc6PGiDtpgWSWRPyQ==
X-Received: by 2002:a7b:c3cf:0:b0:3f4:21cf:b4a4 with SMTP id t15-20020a7bc3cf000000b003f421cfb4a4mr793825wmj.20.1683439180804;
        Sat, 06 May 2023 22:59:40 -0700 (PDT)
Received: from redhat.com ([2.52.158.28])
        by smtp.gmail.com with ESMTPSA id k22-20020a05600c0b5600b003f40049a65bsm11545710wmr.21.2023.05.06.22.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 May 2023 22:59:40 -0700 (PDT)
Date: Sun, 7 May 2023 01:59:35 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Hao Chen <chenh@yusur.tech>
Cc: Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"open list:VIRTIO CORE AND NET DRIVERS" <virtualization@lists.linux-foundation.org>,
	"open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>, huangml@yusur.tech,
	zy@yusur.tech
Subject: Re: [PATCH] virtio_net: set default mtu to 1500 when 'Device maximum
 MTU' bigger than 1500
Message-ID: <20230507015819-mutt-send-email-mst@kernel.org>
References: <20230506021529.396812-1-chenh@yusur.tech>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230506021529.396812-1-chenh@yusur.tech>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 06, 2023 at 10:15:29AM +0800, Hao Chen wrote:
> When VIRTIO_NET_F_MTU(3) Device maximum MTU reporting is supported.
> If offered by the device, device advises driver about the value of its
> maximum MTU. If negotiated, the driver uses mtu as the maximum
> MTU value. But there the driver also uses it as default mtu,
> some devices may have a maximum MTU greater than 1500, this may
> cause some large packages to be discarded, so I changed the MTU to a more
> general 1500 when 'Device maximum MTU' bigger than 1500.
> 
> Signed-off-by: Hao Chen <chenh@yusur.tech>

I don't see why not use the maximum. Bigger packets = better
performance.

> ---
>  drivers/net/virtio_net.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8d8038538fc4..e71c7d1b5f29 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -4040,7 +4040,10 @@ static int virtnet_probe(struct virtio_device *vdev)
>  			goto free;
>  		}
>  
> -		dev->mtu = mtu;
> +		if (mtu > 1500)
> +			dev->mtu = 1500;
> +		else
> +			dev->mtu = mtu;
>  		dev->max_mtu = mtu;
>  	}
>  
> -- 
> 2.27.0


