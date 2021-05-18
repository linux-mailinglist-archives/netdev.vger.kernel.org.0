Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01913875CC
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 11:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348072AbhERJ4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 05:56:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58822 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243182AbhERJ4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 05:56:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621331700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+VCDqtzyoP1/MzTBF9IVeYAYQ0ccxPfD6Ur9tV2oQ+o=;
        b=QxslfdtDobxarcH53NHc1d5Yvhmg2VC8nDhk3/a3yfeAJ6Yy1BRYx2S3ylP5cgriCo741d
        IE5LpTQobzL57pZfBfuJEeJhkqis5vvd9Qa22d5ux1eyTSC6KMKyukgKff7k8/jXV7F83g
        pkTgw6sRJZ6KC/iPjhZu6yC8c4DNJkw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-8oQkVnykN-2gllHtUlmf4w-1; Tue, 18 May 2021 05:54:58 -0400
X-MC-Unique: 8oQkVnykN-2gllHtUlmf4w-1
Received: by mail-wr1-f70.google.com with SMTP id a9-20020adfc4490000b0290112095ca785so120913wrg.14
        for <netdev@vger.kernel.org>; Tue, 18 May 2021 02:54:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+VCDqtzyoP1/MzTBF9IVeYAYQ0ccxPfD6Ur9tV2oQ+o=;
        b=oozfEzThEpKGMOT8yfPIme5lhZZ1UpuEfzgyo1nmSM4wz8Oyof5g2Fv+SG8UHvDB8n
         Rdu+Mh+UpT/PLp2PIw7igcyWnDLcXTYIi8QW8XDdMhBzf1ijk/jxVOl5rFWtNZSCuI8Y
         wf10laBGCO0tCZaxMMnFxa4ouhsokWLfKYcK44605bz5yWmVak0qsvAkYhtrWnVSBs5W
         n4mZmvnFATZjtNbQrdlghmId6bzjUIH0ONisnh9ZUJmT5NmVbUEauPtEF0YITCZwG4Co
         zjcfEHRRxybCYw2Vfg9n3T6ZzfARGKGh5fqtfx45sNsq2Pwet7yioaDarVBf2jNgnrZk
         kI1A==
X-Gm-Message-State: AOAM5320TGdXiW+Y1HZYQYhCPdEJPbyYv1scE1c6BEPSnyxqZlhPVKx6
        xaDaHAvkX8WwWlN3wGR6ekNCM5b3N0zmr0mR6HdaDj/Y1mQDy6njq9cd0yiusOeW3OHBXVxy0nD
        zGtvsuueeMkp3s7Ls
X-Received: by 2002:a1c:ed0a:: with SMTP id l10mr4484504wmh.151.1621331697560;
        Tue, 18 May 2021 02:54:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwtNhcvWHDo9BYsG3WxxnHpLZNjEaHmYXrXsXLGKZi1sCaVICC9ZVl/Fur/33Pf1AoORsMwvA==
X-Received: by 2002:a1c:ed0a:: with SMTP id l10mr4484493wmh.151.1621331697424;
        Tue, 18 May 2021 02:54:57 -0700 (PDT)
Received: from redhat.com ([2a10:800c:1fa6:0:3809:fe0c:bb87:250e])
        by smtp.gmail.com with ESMTPSA id f6sm24076804wru.72.2021.05.18.02.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 02:54:56 -0700 (PDT)
Date:   Tue, 18 May 2021 05:54:54 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xianting Tian <xianting.tian@linux.alibaba.com>
Cc:     jasowang@redhat.com, davem@davemloft.net, kuba@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_net: Remove BUG() to aviod machine dead
Message-ID: <20210518055336-mutt-send-email-mst@kernel.org>
References: <a351fbe1-0233-8515-2927-adc826a7fb94@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a351fbe1-0233-8515-2927-adc826a7fb94@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

typo in subject

On Tue, May 18, 2021 at 05:46:56PM +0800, Xianting Tian wrote:
> When met error, we output a print to avoid a BUG().
> 
> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index c921ebf3ae82..a66174d13e81 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1647,9 +1647,8 @@ static int xmit_skb(struct send_queue *sq, struct
> sk_buff *skb)
>  		hdr = skb_vnet_hdr(skb);
> 
>  	if (virtio_net_hdr_from_skb(skb, &hdr->hdr,
> -				    virtio_is_little_endian(vi->vdev), false,
> -				    0))
> -		BUG();
> +				virtio_is_little_endian(vi->vdev), false, 0))
> +		return -EPROTO;
> 

why EPROTO? can you add some comments to explain what is going on pls?

is this related to a malicious hypervisor thing?

don't we want at least a WARN_ON? Or _ONCE?

>  	if (vi->mergeable_rx_bufs)
>  		hdr->num_buffers = 0;
> -- 
> 2.17.1

