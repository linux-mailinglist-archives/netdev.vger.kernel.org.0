Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC16B33B112
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 12:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhCOL2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 07:28:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48430 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229796AbhCOL2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 07:28:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615807716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6+Ab4d7pdKrk5yb3Huo0eOHzorz4U2kFO+nloggYgTE=;
        b=OcUYvPCdxjkF2sc/qvdK0P4v6Pja5Sfm3ns5etFBiZeoVnPsGUpiIbSJrYU1uTvDy9Lp3x
        8noaAOtJl6mW4gXstQxMX07GMX/W+VWbKZ7heSzZDtzQsZVo6X1v8KdBR3VtWt/Pyliq8P
        1RJrYO4OihV/L/BFSP3iD/MxfKX5IaY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-8RkpiChSOFmL2BY_p1_YIA-1; Mon, 15 Mar 2021 07:28:34 -0400
X-MC-Unique: 8RkpiChSOFmL2BY_p1_YIA-1
Received: by mail-wr1-f72.google.com with SMTP id r6so1681045wrt.20
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 04:28:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6+Ab4d7pdKrk5yb3Huo0eOHzorz4U2kFO+nloggYgTE=;
        b=sQ+YorsjTytdQYv4lzu29Qi0gvlcCjLfLQ2HhbVz86ABLO6uuK3Xpu+KnrwPDnhRzq
         b3MMEa/OhgznDofkChrfo6QYPRFQRGvrq9CqXp5qjZfPEJtPP3To+NI3tuut2fq+y6+0
         gdyNH1E8VZOHsb0JD0N95DyyrHJsADEouv1nBNCirPrFvI5aspvYToxWEtkP1eoCWeV/
         kHH7Z3pX0IPD0bcqDGnW/YB+OWHqUpSkZiZSnkL4lLBNKNyXM+w3SWLC4X8aJ2ktJzT6
         oTLzHy4PMouIo9mjYIFUAY1zVOX2oYoV3q6Q1b4gJuuGUgeQ15zwNREt9qsf8H80HNpy
         f2Vg==
X-Gm-Message-State: AOAM5317uMWiuNRilpmmAWw0yqzKXwKOUFvKYLR9CQ2INjVWr0U8zXm+
        bD5yk/zuPIW79RRQpI7YFGccRbgRyh6mnEMWDeFuBWD4QTmx9bER5cGvdrCbsdJEiYrsufoSQZ4
        +At+4dEwprANoZ6yM
X-Received: by 2002:a1c:f30a:: with SMTP id q10mr26369001wmq.159.1615807713328;
        Mon, 15 Mar 2021 04:28:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxB7EBmQowN5naQMkVQx5KsUpgIu5+ZOQSWr7rwjRrAdNKAoaTOGMg/KcI/Bgs8opSa6gMvzg==
X-Received: by 2002:a1c:f30a:: with SMTP id q10mr26368990wmq.159.1615807713161;
        Mon, 15 Mar 2021 04:28:33 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id 1sm12342744wmj.2.2021.03.15.04.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 04:28:32 -0700 (PDT)
Date:   Mon, 15 Mar 2021 12:28:30 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v6 16/22] vhost/vsock: SEQPACKET feature bit support
Message-ID: <20210315112830.3yqqjnqcgym2sdpg@steredhat>
References: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
 <20210307180344.3466469-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210307180344.3466469-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 07, 2021 at 09:03:41PM +0300, Arseny Krasnov wrote:
>This adds handling of SEQPACKET bit: if guest sets features with
>this bit cleared, then SOCK_SEQPACKET support will be disabled.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> drivers/vhost/vsock.c | 6 +++++-
> 1 file changed, 5 insertions(+), 1 deletion(-)

I think is better to move this patch after we set the seqpackets ops,
so we are really able to handle SEQPACKET traffic.

>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index 5e78fb719602..3b0a50e6de12 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -31,7 +31,8 @@
>
> enum {
> 	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
>-			       (1ULL << VIRTIO_F_ACCESS_PLATFORM)
>+			       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
>+			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET)
> };
>
> enum {
>@@ -785,6 +786,9 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
> 			goto err;
> 	}
>
>+	if (features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
>+		vhost_transport.seqpacket_allow = true;
>+
> 	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
> 		vq = &vsock->vqs[i];
> 		mutex_lock(&vq->mutex);
>-- 
>2.25.1
>

