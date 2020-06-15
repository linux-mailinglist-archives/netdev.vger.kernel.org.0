Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9346B1F9CA0
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 18:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730557AbgFOQJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 12:09:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34915 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729772AbgFOQJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 12:09:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592237347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dD7tNXdGDRCEoYSmAc4X5T9NYduNoAow0i5S91tnK3o=;
        b=JdDIjnL635FoKGQqJ5ufsOKJ50SupFRGd5cXrq8GcHzYcLYoAIBPNhEMS7v5fC8d2OpxhJ
        NPYJntNnBYFWFhCWN0cwyD7M8skt0YHv70LoorEPrS7QHNzLa/wfR+Hn5SMhfmm331bEkQ
        OFux4B+uKaHs/qUTp3Tbr+nse3VkBUM=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-qpCNwUhlP5-QztxftiNchA-1; Mon, 15 Jun 2020 12:09:06 -0400
X-MC-Unique: qpCNwUhlP5-QztxftiNchA-1
Received: by mail-qt1-f197.google.com with SMTP id o11so14336810qti.23
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 09:09:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dD7tNXdGDRCEoYSmAc4X5T9NYduNoAow0i5S91tnK3o=;
        b=R125KLQl3VScKPqUZv7u5Lip1rbr0jb221v/Hqsamt/2qOkopAGu9MvUE8HAXITKwa
         K0a5zGibB6qDV6ZWLLQEBUzK9CAvWV/pnYfhy7Fb6kyih7mQwqRvbXLxNFvl3OrzR5m4
         IHsU5cRy6hfkgvXh9/YjXlyMzS6961m8pNDBGnw+GZE370d7hHZA9KIGiy/99lJdwED2
         kIcK6wqS446PxpzNADYfkgLHbtyD3fvDxzuJddz5jJbIvwn9LPvtUrgCtONNxDzGYlcm
         eme+dJLhijwKmImV0flN7sHIEGlab3seevoDqVwniDVz56XGioxdJOPWS2p/W+WiGQLC
         eO2Q==
X-Gm-Message-State: AOAM531xF06XyIHuuZb6wG2c4OcmSnTmkRxw0O9eDMI+XVJaLxQmvy1o
        P9+1WG7rULAfYsQeTgyPkj6v1IEn7OIhCPW037RCOFgedISAoUR1Y2ujZjx8bCXWF2kO6ylJeK2
        r5lZh6gIGHplZ2bYpiuD9ZL0cTwidy70E
X-Received: by 2002:ac8:3f14:: with SMTP id c20mr16738144qtk.22.1592237344852;
        Mon, 15 Jun 2020 09:09:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpS1Kdurf9uTEpkOBlos6NoVuaASp8bWDmXIL5rXLq0vAjOs1nz+Kwx2KgvqKmP4AbnV8lx1ddDhVxBf3Hd1I=
X-Received: by 2002:ac8:3f14:: with SMTP id c20mr16738019qtk.22.1592237343340;
 Mon, 15 Jun 2020 09:09:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200611113404.17810-1-mst@redhat.com> <20200611113404.17810-4-mst@redhat.com>
In-Reply-To: <20200611113404.17810-4-mst@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Mon, 15 Jun 2020 18:08:27 +0200
Message-ID: <CAJaqyWfytTY7OvBdQNNPVDccvxbX4j-wmgUobU+OEYsOi77Mig@mail.gmail.com>
Subject: Re: [PATCH RFC v8 03/11] vhost/net: pass net specific struct pointer
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 11, 2020 at 1:34 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> In preparation for further cleanup, pass net specific pointer
> to ubuf callbacks so we can move net specific fields
> out to net structures.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/vhost/net.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index bf5e1d81ae25..ff594eec8ae3 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -94,7 +94,7 @@ struct vhost_net_ubuf_ref {
>          */
>         atomic_t refcount;
>         wait_queue_head_t wait;
> -       struct vhost_virtqueue *vq;
> +       struct vhost_net_virtqueue *nvq;
>  };
>
>  #define VHOST_NET_BATCH 64
> @@ -231,7 +231,7 @@ static void vhost_net_enable_zcopy(int vq)
>  }
>
>  static struct vhost_net_ubuf_ref *
> -vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
> +vhost_net_ubuf_alloc(struct vhost_net_virtqueue *nvq, bool zcopy)
>  {
>         struct vhost_net_ubuf_ref *ubufs;
>         /* No zero copy backend? Nothing to count. */
> @@ -242,7 +242,7 @@ vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
>                 return ERR_PTR(-ENOMEM);
>         atomic_set(&ubufs->refcount, 1);
>         init_waitqueue_head(&ubufs->wait);
> -       ubufs->vq = vq;
> +       ubufs->nvq = nvq;
>         return ubufs;
>  }
>
> @@ -384,13 +384,13 @@ static void vhost_zerocopy_signal_used(struct vhost_net *net,
>  static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
>  {
>         struct vhost_net_ubuf_ref *ubufs = ubuf->ctx;
> -       struct vhost_virtqueue *vq = ubufs->vq;
> +       struct vhost_net_virtqueue *nvq = ubufs->nvq;
>         int cnt;
>
>         rcu_read_lock_bh();
>
>         /* set len to mark this desc buffers done DMA */
> -       vq->heads[ubuf->desc].len = success ?
> +       nvq->vq.heads[ubuf->desc].in_len = success ?

This change should access .len, not .in_len, until patch 6 (net:
convert to new API) in this series. Not very important, but make
easier to debug these intermediate commits.

Thanks!

>                 VHOST_DMA_DONE_LEN : VHOST_DMA_FAILED_LEN;
>         cnt = vhost_net_ubuf_put(ubufs);
>
> @@ -402,7 +402,7 @@ static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
>          * less than 10% of times).
>          */
>         if (cnt <= 1 || !(cnt % 16))
> -               vhost_poll_queue(&vq->poll);
> +               vhost_poll_queue(&nvq->vq.poll);
>
>         rcu_read_unlock_bh();
>  }
> @@ -1525,7 +1525,7 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
>         /* start polling new socket */
>         oldsock = vhost_vq_get_backend(vq);
>         if (sock != oldsock) {
> -               ubufs = vhost_net_ubuf_alloc(vq,
> +               ubufs = vhost_net_ubuf_alloc(nvq,
>                                              sock && vhost_sock_zcopy(sock));
>                 if (IS_ERR(ubufs)) {
>                         r = PTR_ERR(ubufs);
> --
> MST
>

