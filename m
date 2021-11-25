Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25AD845D50B
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 08:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348819AbhKYHFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 02:05:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38583 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348845AbhKYHDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 02:03:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637823636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YvGutxBVxczmzzfrYB1SU+rxjor3OVuX04qAGxlXkWA=;
        b=GCkUuSwp3pG/dFEnu2vtYGD1mjm/XdgIvbc8hZhFeqzSLcHzwsyFhom5agGBcrIYVjmNvm
        P2q5iXPNemMjzB2qB1iEkoeafujxQzAc4HjxmV+RpDVeLtaoEkh0k2lSco591GtOFCZDJk
        AlG9giB0oU4OoGgtCYknHZVk/11/pms=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-392-Zjvuia7aNt-2G0hQhIbSUQ-1; Thu, 25 Nov 2021 02:00:34 -0500
X-MC-Unique: Zjvuia7aNt-2G0hQhIbSUQ-1
Received: by mail-ed1-f71.google.com with SMTP id m12-20020a056402430c00b003e9f10bbb7dso4595601edc.18
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 23:00:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YvGutxBVxczmzzfrYB1SU+rxjor3OVuX04qAGxlXkWA=;
        b=P+OMQ+P9mvU9vWVosTh1xSHf20MlLZWruibwJ/GNEYlbK2yqssq445DuVNMeRUQxRq
         sk+4CweWHkJrX4WzqJC3WEhp5bjvb2Za9mv0h8yym4FWmHRn8UBgvaxSmiEYcFj1Wkds
         gXe24S4csaOvtentGmWYSOb76kD8nNN/bG/hN6hr28iADjUa1gjQAYK+nTwxu0Z9mLEZ
         zEC3LS3HLzLpocUU69CCwcC/Pijf7zMzgmGSwPo5BAIHA9jlmq8qnUe+VgyJPzYR3aKN
         hKUBKw4giff0PqLEJ49jEN2TjikBczlkmKOxXbeeccTYDgeL1XD5TMg6fg4M6jllTFxn
         svCA==
X-Gm-Message-State: AOAM532O9yu9NwT3iBaFeM+rL0O0VnCP38tG3/kZiHFsZXzbPyOrpCaW
        KEoq/YwKhO6Z6QZhSteN6UT+5U8kb8YUDpxn5KvF3ySR8HH7mqxbnpSdQXHy+CwL7a5hq5rnkQB
        aIbU9yAp2tBTwgtYG
X-Received: by 2002:a05:6402:514d:: with SMTP id n13mr37269609edd.380.1637823633726;
        Wed, 24 Nov 2021 23:00:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwt9AzGmm67AiDU2VeyIbtxIKZbPDa65Cxd5iNtULGb5LEPNWYW+LlxsIXin1YtDVEPx7kHTQ==
X-Received: by 2002:a05:6402:514d:: with SMTP id n13mr37269578edd.380.1637823633552;
        Wed, 24 Nov 2021 23:00:33 -0800 (PST)
Received: from redhat.com ([45.15.18.67])
        by smtp.gmail.com with ESMTPSA id z8sm1418082edb.5.2021.11.24.23.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 23:00:32 -0800 (PST)
Date:   Thu, 25 Nov 2021 02:00:26 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eli Cohen <elic@nvidia.com>
Subject: Re: [PATCH net] virtio-net: enable big mode correctly
Message-ID: <20211125015532-mutt-send-email-mst@kernel.org>
References: <20211125060547.11961-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125060547.11961-1-jasowang@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 02:05:47PM +0800, Jason Wang wrote:
> When VIRTIO_NET_F_MTU feature is not negotiated, we assume a very
> large max_mtu. In this case, using small packet mode is not correct
> since it may breaks the networking when MTU is grater than
> ETH_DATA_LEN.
> 
> To have a quick fix, simply enable the big packet mode when
> VIRTIO_NET_F_MTU is not negotiated.

This will slow down dpdk hosts which disable mergeable buffers
and send standard MTU sized packets.

> We can do optimization on top.

I don't think it works like this, increasing mtu
from guest >4k never worked, we can't regress everyone's
performance with a promise to maybe sometime bring it back.

> Reported-by: Eli Cohen <elic@nvidia.com>
> Cc: Eli Cohen <elic@nvidia.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
>
> ---
>  drivers/net/virtio_net.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 7c43bfc1ce44..83ae3ef5eb11 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3200,11 +3200,12 @@ static int virtnet_probe(struct virtio_device *vdev)
>  		dev->mtu = mtu;
>  		dev->max_mtu = mtu;
>  
> -		/* TODO: size buffers correctly in this case. */
> -		if (dev->mtu > ETH_DATA_LEN)
> -			vi->big_packets = true;
>  	}
>  
> +	/* TODO: size buffers correctly in this case. */
> +	if (dev->max_mtu > ETH_DATA_LEN)
> +		vi->big_packets = true;
> +
>  	if (vi->any_header_sg)
>  		dev->needed_headroom = vi->hdr_len;
>  
> -- 
> 2.25.1

