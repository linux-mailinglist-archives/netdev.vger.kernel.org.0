Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF4F322C35
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 15:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbhBWO1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 09:27:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29800 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232500AbhBWO1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 09:27:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614090357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j59T9PY61/DvPyamE3fR/tpe611NAXL0hjfPHhn4QIs=;
        b=PTSeqYosqG7BxZTfhL0cjrSas97zA6y3DBKrPaBbiDq3QNbGJw5XdF9RRvsME+G98P5znm
        CHgNJ2YRxUJWGnFUf+ZwJK3TsZGOhpBZ17H+qGo5y2d0NBcd2G6a7ZvrfRj7XpTqQcfegt
        zEM19AQq/54JrqMEBxD+JxgtBuxdOvs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-A7-ll72gPXGdlSINjJBeHw-1; Tue, 23 Feb 2021 09:25:56 -0500
X-MC-Unique: A7-ll72gPXGdlSINjJBeHw-1
Received: by mail-wm1-f69.google.com with SMTP id h20so718870wmq.9
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 06:25:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j59T9PY61/DvPyamE3fR/tpe611NAXL0hjfPHhn4QIs=;
        b=E38j8AKPW8H2DFnkahTXstmGuSKYpDAXg6cT01/ux/CDNi6kelBGweXxBcUFowtDDk
         +42XKvcsXYJLtz2LqCrkN2dtOw85uGg9lOhf5SC5WisOHOkgtMY67EM++7PRQO9FfPX1
         /LvN9vVS8zKsSYxVUvgyvjk2vyZ53LOvSOeCzYpPfuXaYKoLGftcwA+g/RPRpqN4ynje
         QpMM1D0vA5UphZ7vhi34N9RTT6g9WSTd2WKyx0+K+/J9xJDGqXj+y8eYWsetZCFCypyX
         dIGfPUzPOFRqQLHauWSrLgzykh36gPqxVcukNyeF5E6oRdCWiebFfbZffWN3rP2EXcgh
         kzfw==
X-Gm-Message-State: AOAM533FsMvHVny/d0LGYnbt+dmVeOXdaeDMZ5HDOGxtbvS9lOI2xVCA
        mZCCSdtEco/jEYVLmc8TGB0eytU2PfqJMfy87nWfiV0Pj771GDJgC6NFhu7wkfYx8gadbcdqkwd
        okxjb4b39PlaOz3ew
X-Received: by 2002:a05:600c:214f:: with SMTP id v15mr14622938wml.62.1614090354955;
        Tue, 23 Feb 2021 06:25:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwOjX93fAAfT9DnNw4YOICn2RYl95gjK/GlFsQv/m7FcoRtKye19LOKEmxxQFHD91P6//mglQ==
X-Received: by 2002:a05:600c:214f:: with SMTP id v15mr14622928wml.62.1614090354823;
        Tue, 23 Feb 2021 06:25:54 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id a14sm2245520wrg.84.2021.02.23.06.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 06:25:54 -0800 (PST)
Date:   Tue, 23 Feb 2021 09:25:51 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Wei Wang <weiwan@google.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v2 0/2] virtio-net: suppress bad irq warning for tx
 napi
Message-ID: <20210223092434-mutt-send-email-mst@kernel.org>
References: <20210220014436.3556492-1-weiwan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210220014436.3556492-1-weiwan@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 19, 2021 at 05:44:34PM -0800, Wei Wang wrote:
> With the implementation of napi-tx in virtio driver, we clean tx
> descriptors from rx napi handler, for the purpose of reducing tx
> complete interrupts. But this could introduce a race where tx complete
> interrupt has been raised, but the handler found there is no work to do
> because we have done the work in the previous rx interrupt handler.
> This could lead to the following warning msg:
> [ 3588.010778] irq 38: nobody cared (try booting with the
> "irqpoll" option)
> [ 3588.017938] CPU: 4 PID: 0 Comm: swapper/4 Not tainted
> 5.3.0-19-generic #20~18.04.2-Ubuntu
> [ 3588.017940] Call Trace:
> [ 3588.017942]  <IRQ>
> [ 3588.017951]  dump_stack+0x63/0x85
> [ 3588.017953]  __report_bad_irq+0x35/0xc0
> [ 3588.017955]  note_interrupt+0x24b/0x2a0
> [ 3588.017956]  handle_irq_event_percpu+0x54/0x80
> [ 3588.017957]  handle_irq_event+0x3b/0x60
> [ 3588.017958]  handle_edge_irq+0x83/0x1a0
> [ 3588.017961]  handle_irq+0x20/0x30
> [ 3588.017964]  do_IRQ+0x50/0xe0
> [ 3588.017966]  common_interrupt+0xf/0xf
> [ 3588.017966]  </IRQ>
> [ 3588.017989] handlers:
> [ 3588.020374] [<000000001b9f1da8>] vring_interrupt
> [ 3588.025099] Disabling IRQ #38
> 
> This patch series contains 2 patches. The first one adds a new param to
> struct vring_virtqueue to control if we want to suppress the bad irq
> warning. And the second patch in virtio-net sets it for tx virtqueues if
> napi-tx is enabled.

I'm going to be busy until March, I think there should be a better
way to fix this though. Will think about it and respond in about a week.


> Wei Wang (2):
>   virtio: add a new parameter in struct virtqueue
>   virtio-net: suppress bad irq warning for tx napi
> 
>  drivers/net/virtio_net.c     | 19 ++++++++++++++-----
>  drivers/virtio/virtio_ring.c | 16 ++++++++++++++++
>  include/linux/virtio.h       |  2 ++
>  3 files changed, 32 insertions(+), 5 deletions(-)
> 
> -- 
> 2.30.0.617.g56c4b15f3c-goog

