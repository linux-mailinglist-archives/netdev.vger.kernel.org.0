Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348B21F9CB6
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 18:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730881AbgFOQLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 12:11:50 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36994 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730553AbgFOQLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 12:11:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592237506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s3Y9+xXDyttebs3/fVIigjv1aP9MsZuTcGKyOjbOlrk=;
        b=RUlyA9C1yldMWgNtIwDeFLL/ywlWYyEUuz5T7NXXQKJ2EQy2p3f9siYTgXxAcqm4l51chG
        jmoxDb23K626sUkr6tkAo7RsZtBZlXGj6kZET4EqdHOYIPRwj5AGYhV67ANutZ3S5TQPRt
        HQKiJ5T7WjaPsrl/B7N7hg5jF3NQgwU=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-zV5gzZjZMk6R18gxxbiPLA-1; Mon, 15 Jun 2020 12:11:42 -0400
X-MC-Unique: zV5gzZjZMk6R18gxxbiPLA-1
Received: by mail-qk1-f200.google.com with SMTP id 205so14648370qkh.5
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 09:11:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s3Y9+xXDyttebs3/fVIigjv1aP9MsZuTcGKyOjbOlrk=;
        b=rYcpbh2XNdtu6QoeAf0+9sIy2+YYk4jsw8QK6h33Qn1i3oa9UaVEcw9rmGFXKl+ap7
         2UxkSI0GWHdOW9BgtVaucgspOV8Ww4C4MCx4sRyfCJNBpF7xpt2umgnQuVM/Ik0Ew1Uc
         sm9qqAEJ4mAf5VPxsWIAnRsjCyVEUHnhv9Zfhe5w8r80MLbPLVwho2/Qc2ayyjUiknFN
         v6cEr1hknfc0ZzX8Ce9zHhiWTqpNu3MxpKeO4pla8b2ivzwwZALYl/R2RaAssu47DFaB
         ZGLdr6r4DB4TEpF9LzSwUoQ8XmqLGK08S/NuHrpQgMxYaaw1cAzHwmSxOw9BCPfxiGUm
         n0lA==
X-Gm-Message-State: AOAM532hT3zocR6yDWcDmjRxASc/MnZmP7F5cQP8Hzys6YXy0iRDVUrP
        /1xElDx0OvwyaADyoZPoW5hDQsDlnLGAsS/OWbPjk7e38SX525/zItWxEbucegQftQuhkGA3Kqg
        /AVE6sxRzc5dHbAKq5zPVJbWRASFCQPPa
X-Received: by 2002:ac8:312e:: with SMTP id g43mr16444502qtb.308.1592237502359;
        Mon, 15 Jun 2020 09:11:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJf2dKPK+iYSVWjob0YFgJrsLx4Y6zwMor0rx3TpwaUzXHN6d9uezxdspNtpgbkwdstqV1JKgXVMQuYTR4Z48=
X-Received: by 2002:ac8:312e:: with SMTP id g43mr16444416qtb.308.1592237501400;
 Mon, 15 Jun 2020 09:11:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200611113404.17810-1-mst@redhat.com> <20200611113404.17810-6-mst@redhat.com>
In-Reply-To: <20200611113404.17810-6-mst@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Mon, 15 Jun 2020 18:11:05 +0200
Message-ID: <CAJaqyWeEdydJu6=Mxptgi0doiCBVS9pF9pg39FMcy1-8jN9G9Q@mail.gmail.com>
Subject: Re: [PATCH RFC v8 05/11] vhost: format-independent API for used buffers
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
> Add a new API that doesn't assume used ring, heads, etc.
> For now, we keep the old APIs around to make it easier
> to convert drivers.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/vhost/vhost.c | 73 +++++++++++++++++++++++++++++++++++++------
>  drivers/vhost/vhost.h | 17 +++++++++-
>  2 files changed, 79 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index c38605b01080..03e6bca02288 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2335,13 +2335,12 @@ static void unfetch_descs(struct vhost_virtqueue *vq)
>   * number of output then some number of input descriptors, it's actually two
>   * iovecs, but we pack them into one and note how many of each there were.
>   *
> - * This function returns the descriptor number found, or vq->num (which is
> - * never a valid descriptor number) if none was found.  A negative code is
> - * returned on error. */
> -int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> -                     struct iovec iov[], unsigned int iov_size,
> -                     unsigned int *out_num, unsigned int *in_num,
> -                     struct vhost_log *log, unsigned int *log_num)
> + * This function returns a value > 0 if a descriptor was found, or 0 if none were found.
> + * A negative code is returned on error. */
> +int vhost_get_avail_buf(struct vhost_virtqueue *vq, struct vhost_buf *buf,
> +                       struct iovec iov[], unsigned int iov_size,
> +                       unsigned int *out_num, unsigned int *in_num,
> +                       struct vhost_log *log, unsigned int *log_num)
>  {
>         int ret = fetch_descs(vq);
>         int i;
> @@ -2354,6 +2353,8 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>         *out_num = *in_num = 0;
>         if (unlikely(log))
>                 *log_num = 0;
> +       buf->in_len = buf->out_len = 0;
> +       buf->descs = 0;
>
>         for (i = vq->first_desc; i < vq->ndescs; ++i) {
>                 unsigned iov_count = *in_num + *out_num;
> @@ -2383,6 +2384,7 @@ int (struct vhost_virtqueue *vq,
>                         /* If this is an input descriptor,
>                          * increment that count. */
>                         *in_num += ret;
> +                       buf->in_len += desc->len;
>                         if (unlikely(log && ret)) {
>                                 log[*log_num].addr = desc->addr;
>                                 log[*log_num].len = desc->len;
> @@ -2398,9 +2400,11 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>                                 goto err;
>                         }
>                         *out_num += ret;
> +                       buf->out_len += desc->len;
>                 }
>
> -               ret = desc->id;
> +               buf->id = desc->id;
> +               ++buf->descs;
>
>                 if (!(desc->flags & VRING_DESC_F_NEXT))
>                         break;
> @@ -2408,12 +2412,41 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>
>         vq->first_desc = i + 1;
>
> -       return ret;
> +       return 1;
>
>  err:
>         unfetch_descs(vq);
>
> -       return ret ? ret : vq->num;
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(vhost_get_avail_buf);
> +
> +/* Reverse the effect of vhost_get_avail_buf. Useful for error handling. */
> +void vhost_discard_avail_bufs(struct vhost_virtqueue *vq,
> +                             struct vhost_buf *buf, unsigned count)
> +{
> +       vhost_discard_vq_desc(vq, count);
> +}
> +EXPORT_SYMBOL_GPL(vhost_discard_avail_bufs);
> +
> +/* This function returns the descriptor number found, or vq->num (which is
> + * never a valid descriptor number) if none was found.  A negative code is
> + * returned on error. */
> +int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> +                     struct iovec iov[], unsigned int iov_size,
> +                     unsigned int *out_num, unsigned int *in_num,
> +                     struct vhost_log *log, unsigned int *log_num)
> +{
> +       struct vhost_buf buf;
> +       int ret = vhost_get_avail_buf(vq, &buf,
> +                                     iov, iov_size, out_num, in_num,
> +                                     log, log_num);
> +
> +       if (likely(ret > 0))
> +               return buf->id;

This should be buf.id, isn't it?

> +       if (likely(!ret))
> +               return vq->num;
> +       return ret;
>  }
>  EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
>
> @@ -2507,6 +2540,26 @@ int vhost_add_used(struct vhost_virtqueue *vq, unsigned int head, int len)
>  }
>  EXPORT_SYMBOL_GPL(vhost_add_used);
>
> +int vhost_put_used_buf(struct vhost_virtqueue *vq, struct vhost_buf *buf)
> +{
> +       return vhost_add_used(vq, buf->id, buf->in_len);
> +}
> +EXPORT_SYMBOL_GPL(vhost_put_used_buf);
> +
> +int vhost_put_used_n_bufs(struct vhost_virtqueue *vq,
> +                         struct vhost_buf *bufs, unsigned count)
> +{
> +       unsigned i;
> +
> +       for (i = 0; i < count; ++i) {
> +               vq->heads[i].id = cpu_to_vhost32(vq, bufs[i].id);
> +               vq->heads[i].len = cpu_to_vhost32(vq, bufs[i].in_len);
> +       }
> +
> +       return vhost_add_used_n(vq, vq->heads, count);
> +}
> +EXPORT_SYMBOL_GPL(vhost_put_used_n_bufs);
> +
>  static bool vhost_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
>  {
>         __u16 old, new;
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index fed36af5c444..28eea0155efb 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -67,6 +67,13 @@ struct vhost_desc {
>         u16 id;
>  };
>
> +struct vhost_buf {
> +       u32 out_len;
> +       u32 in_len;
> +       u16 descs;
> +       u16 id;
> +};
> +
>  /* The virtqueue structure describes a queue attached to a device. */
>  struct vhost_virtqueue {
>         struct vhost_dev *dev;
> @@ -195,7 +202,12 @@ int vhost_get_vq_desc(struct vhost_virtqueue *,
>                       unsigned int *out_num, unsigned int *in_num,
>                       struct vhost_log *log, unsigned int *log_num);
>  void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
> -
> +int vhost_get_avail_buf(struct vhost_virtqueue *, struct vhost_buf *buf,
> +                       struct iovec iov[], unsigned int iov_count,
> +                       unsigned int *out_num, unsigned int *in_num,
> +                       struct vhost_log *log, unsigned int *log_num);
> +void vhost_discard_avail_bufs(struct vhost_virtqueue *,
> +                             struct vhost_buf *, unsigned count);
>  int vhost_vq_init_access(struct vhost_virtqueue *);
>  int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int len);
>  int vhost_add_used_n(struct vhost_virtqueue *, struct vring_used_elem *heads,
> @@ -204,6 +216,9 @@ void vhost_add_used_and_signal(struct vhost_dev *, struct vhost_virtqueue *,
>                                unsigned int id, int len);
>  void vhost_add_used_and_signal_n(struct vhost_dev *, struct vhost_virtqueue *,
>                                struct vring_used_elem *heads, unsigned count);
> +int vhost_put_used_buf(struct vhost_virtqueue *, struct vhost_buf *buf);
> +int vhost_put_used_n_bufs(struct vhost_virtqueue *,
> +                         struct vhost_buf *bufs, unsigned count);
>  void vhost_signal(struct vhost_dev *, struct vhost_virtqueue *);
>  void vhost_disable_notify(struct vhost_dev *, struct vhost_virtqueue *);
>  bool vhost_vq_avail_empty(struct vhost_dev *, struct vhost_virtqueue *);
> --
> MST
>

