Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453613B1E6C
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 18:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhFWQQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 12:16:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26658 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhFWQQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 12:16:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624464854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nj23NkvOz6EzLV20ZpL38A+OlYN1UWETlVYZQZsTA/A=;
        b=KHXrpb/BP3rWWeEkPdFFn2LPfUqDF4O7ZKaMPCf9MLVPoBy4XVRDoQ9vXua0trzU3l2CDq
        rRg9HGMc+ho5WHLPbULRqSonm9kvWOQsoHNq3nQvgkbIxqTcvw55mgOoDYnvvigirgVPRg
        P7wqjc3Dqoq+j8/VgOblMGAZd6QPVPg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-KhX4pDt8MsOajfb5WBA0Fw-1; Wed, 23 Jun 2021 12:14:13 -0400
X-MC-Unique: KhX4pDt8MsOajfb5WBA0Fw-1
Received: by mail-ej1-f72.google.com with SMTP id g6-20020a1709064e46b02903f57f85ac45so1161063ejw.15
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 09:14:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nj23NkvOz6EzLV20ZpL38A+OlYN1UWETlVYZQZsTA/A=;
        b=j2ZrA5BBYEE50YHpUfEG4nJ0n3P8hyRwvNlbaKdvjPw+zrex+zBhdyhC3gfTh4GiLh
         DZF0plMZKAG0alv7qNEQTCBISdqtg5Ris8YLA5XQiQ2uQcJVXK18tBmWHkoZ0GG51ZRA
         WawC5CCYY/F06NTNEKaEOv6EZk64bK55Ge/wfR9aH9NjfvnMgz9D+j7N+8fh09hsGz2T
         4bDkGlzpmTxdRGS9EsaLNQ47A+OLgNQh0Wik6Vtq200VGn09mV+m/dlz7wiBI5a/2DCX
         K8ftHdbbZxf9oqBnZ1k0xDE+2l8WEvXIKTg5ClxVXrujh+5LOFqWwg5s7sX0+1zmLfwg
         dp9Q==
X-Gm-Message-State: AOAM530pptA47WcbFQDAPSqXRYejndl8KySYbqzhLJSRk37Mkp1T7mrI
        ez0huHR5XOX0+WSQsCDjhryCulL7FKYTN4x6VXrWhnOwSG8TLmGQosnfu393+4Kvg30sw+VLU1U
        ZnHfj+CBFNByfVTJF
X-Received: by 2002:a05:6402:358:: with SMTP id r24mr694014edw.69.1624464852042;
        Wed, 23 Jun 2021 09:14:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYtrsEjivOh9pUUY54YkoZINzNJahBEuMWFaogEOzw9HISbTNQJpM83z5DvSQQAP7UL/KVEw==
X-Received: by 2002:a05:6402:358:: with SMTP id r24mr693976edw.69.1624464851854;
        Wed, 23 Jun 2021 09:14:11 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id em20sm101445ejc.70.2021.06.23.09.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 09:14:11 -0700 (PDT)
Date:   Wed, 23 Jun 2021 18:14:08 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Xianting Tian <xianting_tian@126.com>
Cc:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xianting Tian <xianting.tian@linux.alibaba.com>
Subject: Re: [PATCH] virtio_net: Use virtio_find_vqs_ctx() helper
Message-ID: <20210623161408.vzq3fizljtkyig76@steredhat>
References: <1624461382-8302-1-git-send-email-xianting_tian@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1624461382-8302-1-git-send-email-xianting_tian@126.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 11:16:22AM -0400, Xianting Tian wrote:
>virtio_find_vqs_ctx() is defined but never be called currently,
>it is the right place to use it.
>
>Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
>---
> drivers/net/virtio_net.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>index 78a01c7..9061c55 100644
>--- a/drivers/net/virtio_net.c
>+++ b/drivers/net/virtio_net.c
>@@ -2830,8 +2830,8 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
> 			ctx[rxq2vq(i)] = true;
> 	}
>
>-	ret = vi->vdev->config->find_vqs(vi->vdev, total_vqs, vqs, callbacks,
>-					 names, ctx, NULL);
>+	ret = virtio_find_vqs_ctx(vi->vdev, total_vqs, vqs, callbacks,
>+				  names, ctx, NULL);
> 	if (ret)
> 		goto err_find;
>
>-- 
>1.8.3.1
>

