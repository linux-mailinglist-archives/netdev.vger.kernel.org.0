Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF33849BC22
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 20:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiAYTbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 14:31:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:35270 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230109AbiAYTbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 14:31:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643139083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1y3rvxPiO/9emawQnXo32bBBh9nL/eYXEjpNfFj991A=;
        b=OPwu7babQZ/xtc72zj7EUUNeS0bp7qsIt//PBIippxKPUD+c7GpZunpbWpSUd6tQq9O+JH
        RC+qryePgc4VDZuRcH4/1T6/ICKsHGDbu/L+ykZNgZyFRdyl0ywkZrtUCoOvBY5PABAjvS
        fUhuMxP85Su48rbSzzb6YJf5FIsE0r8=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-_WOFwQrrNVW9vEGPDb9kzA-1; Tue, 25 Jan 2022 14:31:15 -0500
X-MC-Unique: _WOFwQrrNVW9vEGPDb9kzA-1
Received: by mail-lj1-f199.google.com with SMTP id u4-20020a2e8544000000b0023aeea9107dso1866748ljj.21
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 11:31:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1y3rvxPiO/9emawQnXo32bBBh9nL/eYXEjpNfFj991A=;
        b=acuI9P8ZrSqDS6hb/84hxefayOQGatD2LieKnQIAGD/gak2INZKxWsI9nn57M4iIAg
         OjIrnzHFNgZAQNq/+lhrI4uWrFGkTQCHYRJPO5rfBzEaOH4bROoVzyWGHIQg8u5W9p0X
         WLFAwCqT30tGadYuxWZU75PNpp4V9pacjTks/DZcF8S8fsqqUxAaErM+cBgmVmn0cJVo
         hbXs325dhAZGw+Z2FuWCecCOp7VxFCE6FPRENizMdkso7LdakFtl87EyMVSsKQD0rn//
         8feQ/EQuwneNO6D+ak6+BR8ZGviu0ANE1vYZy1XCZdyPbz/uBAHNYrOSHwlGTiaDwcIe
         M0yg==
X-Gm-Message-State: AOAM533oF74ACmzYjG5pEsLSt4TMfOPoK2cUVk/8sHvp3FvAwWId9plO
        8j17qAZbntfGyOgJFS+qWazmDH4Yzm3Syx+BPl1QmXSmh4/3XWbC75bMCKt0RZ1jq+4ZEpsm1ts
        z+w4KmPoLdcz+wGeb
X-Received: by 2002:a05:6512:2216:: with SMTP id h22mr31665lfu.155.1643139073549;
        Tue, 25 Jan 2022 11:31:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwZcH0aJ/a9DBOcxqASffCbpLGVyuJBXzBRwot1LsOd1f4QjOwT+3Ljc8MBb8XNCWiArZCXLA==
X-Received: by 2002:a17:906:175b:: with SMTP id d27mr17480756eje.476.1643139052011;
        Tue, 25 Jan 2022 11:30:52 -0800 (PST)
Received: from redhat.com ([176.12.185.204])
        by smtp.gmail.com with ESMTPSA id o11sm8670746edh.75.2022.01.25.11.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 11:30:48 -0800 (PST)
Date:   Tue, 25 Jan 2022 14:30:44 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V2 3/4] vhost_vdpa: don't setup irq offloading when
 irq_num < 0
Message-ID: <20220125143008-mutt-send-email-mst@kernel.org>
References: <20220125091744.115996-1-lingshan.zhu@intel.com>
 <20220125091744.115996-4-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125091744.115996-4-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 05:17:43PM +0800, Zhu Lingshan wrote:
> When irq number is negative(e.g., -EINVAL), the virtqueue
> may be disabled or the virtqueues are sharing a device irq.
> In such case, we should not setup irq offloading for a virtqueue.
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vhost/vdpa.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 851539807bc9..909891d518e8 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -96,6 +96,9 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
>  	if (!ops->get_vq_irq)
>  		return;
>  
> +	if (irq < 0)
> +		return;
> +
>  	irq = ops->get_vq_irq(vdpa, qid);

So it's used before it's initialized. Ugh.
How was this patchset tested?

>  	irq_bypass_unregister_producer(&vq->call_ctx.producer);
>  	if (!vq->call_ctx.ctx || irq < 0)
> -- 
> 2.27.0

