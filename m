Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069BD453485
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 15:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237622AbhKPOpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 09:45:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53419 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237797AbhKPOoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 09:44:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637073685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AfHc271RXOUnz4mYvex1noJIxI7ZHKxUfmBIzMbPzoE=;
        b=iPAQuoLAgIFKF32cXr6pC+7DmO4BOT/c3Bx82OAq8x68XvsDlEgFPzF+f6hwfm7Ruix08k
        w2GRV1Jg/CCbPIciXFdJojbgGu8e3PiPjIdKOvxO0VMFaI0cPi378OnqZvuWh9SOgEGfIQ
        +2i682iPuNB42P85Te9OqXaV5rcMOjc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-HCNma_9WMAmVzso0ZAphzw-1; Tue, 16 Nov 2021 09:41:24 -0500
X-MC-Unique: HCNma_9WMAmVzso0ZAphzw-1
Received: by mail-ed1-f70.google.com with SMTP id q17-20020aa7da91000000b003e7c0641b9cso5755685eds.12
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 06:41:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AfHc271RXOUnz4mYvex1noJIxI7ZHKxUfmBIzMbPzoE=;
        b=MWkFxYpztZBiEahWxfzFD1D/rihiDKajsMX5Gmgsq2Iv1Kt8EcZvA4z5LWD+FGezep
         hTC09+wxt/nMOEi50BshNkDhWlc1h1wkb0fnlSBYGJeAOHcoVBXq+/0UtLTSzZfpL+vT
         as0XzZLD4dyDAuBTwTjk2MZIqdqfoyTx+Ye+JrFY3HxvOU0uD3FUSIfSY4ObccrJ+Rv/
         CDSWolMrFpmoxD2apZc6wA7pLQ9fr2HyfWWjne5bLVs4a7vikqkrcAm0oIZmRC4sirYj
         x0tK3ioaFkA8jJg4NPJBTCn/b4lWNqz44PljS+DYlTFGgJ7LBnKYiAntGoFotP7cv2Un
         UhRg==
X-Gm-Message-State: AOAM5306FdesUnqyTZHX2n+Jz/M8m05UhPry8SRRI+7FCU9lF0nyAb5X
        QQSPt/Rz9vXuWAGgwL5MFJCXBylPVjm5t/YH4ftosgluSkkFUkok2elj6BxnSM9JXa34Ho0z+FK
        Ay2D6Wr3n8w2LMvSg
X-Received: by 2002:a50:f18a:: with SMTP id x10mr10933209edl.193.1637073683465;
        Tue, 16 Nov 2021 06:41:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxB2sbwGvYxWKbC+UMKYgg2LVMQ3q254bvGdk6QiC2h+UbWm6XEbEkZoXht5LV0mMQvzs1Y0Q==
X-Received: by 2002:a50:f18a:: with SMTP id x10mr10933184edl.193.1637073683291;
        Tue, 16 Nov 2021 06:41:23 -0800 (PST)
Received: from steredhat (host-87-10-72-39.retail.telecomitalia.it. [87.10.72.39])
        by smtp.gmail.com with ESMTPSA id hv13sm8368872ejc.75.2021.11.16.06.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 06:41:22 -0800 (PST)
Date:   Tue, 16 Nov 2021 15:41:19 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Andrey Ryabinin <arbn@yandex-team.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] vhost: get rid of vhost_poll_flush() wrapper
Message-ID: <20211116144119.56ph52twuyc4jtdr@steredhat>
References: <20211115153003.9140-1-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20211115153003.9140-1-arbn@yandex-team.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 06:29:58PM +0300, Andrey Ryabinin wrote:
>vhost_poll_flush() is a simple wrapper around vhost_work_dev_flush().
>It gives wrong impression that we are doing some work over vhost_poll,
>while in fact it flushes vhost_poll->dev.
>It only complicate understanding of the code and leads to mistakes
>like flushing the same vhost_dev several times in a row.
>
>Just remove vhost_poll_flush() and call vhost_work_dev_flush() directly.
>
>Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
>---
> drivers/vhost/net.c   |  4 ++--
> drivers/vhost/test.c  |  2 +-
> drivers/vhost/vhost.c | 12 ++----------
> drivers/vhost/vsock.c |  2 +-
> 4 files changed, 6 insertions(+), 14 deletions(-)
>
>diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
>index 28ef323882fb..11221f6d11b8 100644
>--- a/drivers/vhost/net.c
>+++ b/drivers/vhost/net.c
>@@ -1375,8 +1375,8 @@ static void vhost_net_stop(struct vhost_net *n, struct socket **tx_sock,
>
> static void vhost_net_flush_vq(struct vhost_net *n, int index)
> {
>-	vhost_poll_flush(n->poll + index);
>-	vhost_poll_flush(&n->vqs[index].vq.poll);
>+	vhost_work_dev_flush(n->poll[index].dev);
>+	vhost_work_dev_flush(n->vqs[index].vq.poll.dev);
> }
>
> static void vhost_net_flush(struct vhost_net *n)
>diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
>index a09dedc79f68..1a8ab1d8cb1c 100644
>--- a/drivers/vhost/test.c
>+++ b/drivers/vhost/test.c
>@@ -146,7 +146,7 @@ static void vhost_test_stop(struct vhost_test *n, void **privatep)
>
> static void vhost_test_flush_vq(struct vhost_test *n, int index)
> {
>-	vhost_poll_flush(&n->vqs[index].poll);
>+	vhost_work_dev_flush(n->vqs[index].poll.dev);
> }
>
> static void vhost_test_flush(struct vhost_test *n)
>diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>index 59edb5a1ffe2..ca088481da0e 100644
>--- a/drivers/vhost/vhost.c
>+++ b/drivers/vhost/vhost.c
>@@ -245,14 +245,6 @@ void vhost_work_dev_flush(struct vhost_dev *dev)
> }
> EXPORT_SYMBOL_GPL(vhost_work_dev_flush);
>
>-/* Flush any work that has been scheduled. When calling this, don't hold any
>- * locks that are also used by the callback. */
>-void vhost_poll_flush(struct vhost_poll *poll)
>-{
>-	vhost_work_dev_flush(poll->dev);
>-}
>-EXPORT_SYMBOL_GPL(vhost_poll_flush);
>-
> void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
> {
> 	if (!dev->worker)
>@@ -663,7 +655,7 @@ void vhost_dev_stop(struct vhost_dev *dev)
> 	for (i = 0; i < dev->nvqs; ++i) {
> 		if (dev->vqs[i]->kick && dev->vqs[i]->handle_kick) {
> 			vhost_poll_stop(&dev->vqs[i]->poll);
>-			vhost_poll_flush(&dev->vqs[i]->poll);
>+			vhost_work_dev_flush(dev->vqs[i]->poll.dev);

Not related to this patch, but while looking at vhost-vsock I'm 
wondering if we can do the same here in vhost_dev_stop(), I mean move 
vhost_work_dev_flush() outside the loop and and call it once. (In 
another patch eventually)

Stefano

