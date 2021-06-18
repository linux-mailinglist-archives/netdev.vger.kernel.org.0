Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E5F3ACB1B
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 14:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbhFRMkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 08:40:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58680 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229730AbhFRMka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 08:40:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624019898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8BPRFSs4ZDIzsU3WeQFolZqPnT6BylD3v05yUAKiC4I=;
        b=AhGKUxu0ffCzsgG696WX6ysaRLgQLrcEvATcClIZeJux4zPSEWmvIJpjaas+dGZjyV7CKl
        bic6oY7Q0fGtFR8dn06zUzvt9dJZMlUEuOwrWbIzYgemy5+AUvjxTfEjo+6ULZaI28MGDq
        5MyFIoBtbBnLPlNnpQMwLMAn2BDZjC0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-Lv8ewOzgNiWvgaYVEunPOA-1; Fri, 18 Jun 2021 08:38:17 -0400
X-MC-Unique: Lv8ewOzgNiWvgaYVEunPOA-1
Received: by mail-wr1-f69.google.com with SMTP id k25-20020a5d52590000b0290114dee5b660so4321196wrc.16
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 05:38:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8BPRFSs4ZDIzsU3WeQFolZqPnT6BylD3v05yUAKiC4I=;
        b=o//PuKq/T0yRe0UwjyLeRdWHiETy3v0lfPqezinso5wL2ERU3yUQNsR+Dz2a1REO8+
         6OVlNtl3K+9ShDqA0ZyIQXZ/A6+M1BfEyZmeVh6dHrPzGaGL6j45CUbHBTElEP2MxTSS
         bqU7UWZNWEnpypvJvr8esglhwVywOT/Vfm+rEoqJaZPmXvTqgeFFlZGL870/V8bOtBUX
         gR/uirlWCGTcABpql6TrqpSmbRMQ2ZKSzEf9KTK/bpJiD7+wM+7wkKNEguimpbV2uTXi
         6hEhbCbf3Z3Y9chS/+9GsomlKTLtX35JqDtR+TyiXV8zQVVztYx9Epu3QA0J8iK5N5ge
         a8cA==
X-Gm-Message-State: AOAM532ZlEeT8XIzC3Df4zX/24ptG1aXaGH7fOc7GsaLnfBQ0qplXe1a
        kLMdq2ydcbuA2DsGPVafp5OSJSj7xz+zyCi64OAfM11pnkl+uXW1l7h+MUqzQffR18yF13Fsp1v
        M6UtSpRCBMoGU3jfE
X-Received: by 2002:a5d:5983:: with SMTP id n3mr12218317wri.241.1624019896285;
        Fri, 18 Jun 2021 05:38:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy6buMSygSMET2HRRFto0utYr5pHmbiCUKzswQXXbWqPi3keYL8lMRIvXzbPyrGGaftLze7cQ==
X-Received: by 2002:a5d:5983:: with SMTP id n3mr12218290wri.241.1624019896020;
        Fri, 18 Jun 2021 05:38:16 -0700 (PDT)
Received: from redhat.com ([77.126.22.11])
        by smtp.gmail.com with ESMTPSA id b71sm2236262wmb.2.2021.06.18.05.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 05:38:14 -0700 (PDT)
Date:   Fri, 18 Jun 2021 08:38:10 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Keiichi Watanabe <keiichiw@chromium.org>
Cc:     netdev@vger.kernel.org, chirantan@chromium.org,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_net: Enable MSI-X vector for ctrl queue
Message-ID: <20210618083650-mutt-send-email-mst@kernel.org>
References: <20210618072625.957837-1-keiichiw@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210618072625.957837-1-keiichiw@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 04:26:25PM +0900, Keiichi Watanabe wrote:
> When we use vhost-user backend on the host, MSI-X vector should be set
> so that the vmm can get an irq FD and send it to the backend device
> process with vhost-user protocol.
> Since whether the vector is set for a queue is determined depending on
> the queue has a callback, this commit sets an empty callback for
> virtio-net's control queue.
> 
> Signed-off-by: Keiichi Watanabe <keiichiw@chromium.org>

I'm confused by this explanation. If the vmm wants to get
an interrupt it can do so - why change the guest driver?

> ---
>  drivers/net/virtio_net.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 11f722460513..002e3695d4b3 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2696,6 +2696,11 @@ static void virtnet_del_vqs(struct virtnet_info *vi)
>  	virtnet_free_queues(vi);
>  }
>  
> +static void virtnet_ctrlq_done(struct virtqueue *rvq)
> +{
> +	/* Do nothing */
> +}
> +
>  /* How large should a single buffer be so a queue full of these can fit at
>   * least one full packet?
>   * Logic below assumes the mergeable buffer header is used.
> @@ -2748,7 +2753,7 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
>  
>  	/* Parameters for control virtqueue, if any */
>  	if (vi->has_cvq) {
> -		callbacks[total_vqs - 1] = NULL;
> +		callbacks[total_vqs - 1] = virtnet_ctrlq_done;
>  		names[total_vqs - 1] = "control";
>  	}
>  
> -- 
> 2.32.0.288.g62a8d224e6-goog

