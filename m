Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4B357DAA1
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 09:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234308AbiGVHIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 03:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234120AbiGVHH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 03:07:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DBCF68E6FA
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 00:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658473676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GzF+ETyrmoD747FNPp3QPTAixHepqvjTlPacCwfRImE=;
        b=eHkyNN3kKWfK2vn4ZEo2RbC3p+/nKmZ/AGrFXU6mJA3k4L3flQqpPTzlEOCBVCzryUcd2X
        u+X8egnLpsSwy1Yi99XDGrLmrEXQ7gCpoJlxEIgg7HLSKNBHZm2kJ+AQj6FZef9JmNYnCk
        LlDxl6hbJWUzQDjgWEKUSheySeffWl0=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-128-tbeows4qPRe7A9yedk-RPg-1; Fri, 22 Jul 2022 03:07:54 -0400
X-MC-Unique: tbeows4qPRe7A9yedk-RPg-1
Received: by mail-qk1-f198.google.com with SMTP id i15-20020a05620a404f00b006b55998179bso3110806qko.4
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 00:07:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GzF+ETyrmoD747FNPp3QPTAixHepqvjTlPacCwfRImE=;
        b=sb7kIkr1XOSslu1HpWaemOWbyVbWbBlGMHjZaNk6cHxw77gAnwJQsX/peJPttRTSpX
         LHeKWMLP7ILJwcAOlCjMD0mTjv90NOYB+URpHXhyq3SMQ1jyY0R/1eedAh6sLbsxeKm0
         iDw9N5Xsjf9b7laTEj//mpVaML3oWqjcYRzxzR9yEbfOXydOAtOfUZYTseKvWVeSdPkc
         CB/Zhzzt5Y6ejSaxqQlSa6F14vjpBDZXzGHNLFpQiNzxSg2g64pFi6k2EmADygvbozre
         HxFh11xvinipEAlMKev31Vvcn8TzobfS93weVXUI+5xYeE0k2c6ssMtweW5h2fwQEiYx
         B8mg==
X-Gm-Message-State: AJIora8oixb9hI7nZi9ZAhkwjAx3L2I1xhn5EKa8Ic+JrQkYRUJR9M3+
        P8wp2EI+kWNTGG7xpv+jQYXBUPWRaW8Eyt6PgYUPYIDK7AMFtaCP1WX9DS6xvYXxcpxJUYschDg
        Bnuqc+2+zAprHxWtCsTNL6gUyuhpt+GPV
X-Received: by 2002:a05:620a:1456:b0:6b5:dbd5:3c50 with SMTP id i22-20020a05620a145600b006b5dbd53c50mr1461412qkl.193.1658473673325;
        Fri, 22 Jul 2022 00:07:53 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tQ0kj38FLk62rI6HiTNXcfww0XVcykkgM94yuuMiYSYCs5w7Fk992trjfXKTwluazLnKzTUeAHv/rR/019B4w=
X-Received: by 2002:a05:620a:1456:b0:6b5:dbd5:3c50 with SMTP id
 i22-20020a05620a145600b006b5dbd53c50mr1461407qkl.193.1658473673036; Fri, 22
 Jul 2022 00:07:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220721084341.24183-1-qtxuning1999@sjtu.edu.cn> <20220721084341.24183-2-qtxuning1999@sjtu.edu.cn>
In-Reply-To: <20220721084341.24183-2-qtxuning1999@sjtu.edu.cn>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 22 Jul 2022 09:07:17 +0200
Message-ID: <CAJaqyWcP3CQoqN=oQ2c3d9UbGPgSS+j18CA5NO5JGAW64Z+H-Q@mail.gmail.com>
Subject: Re: [RFC 1/5] vhost: reorder used descriptors in a batch
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Michael Tsirkin <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 10:44 AM Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
>
> Device may not use descriptors in order, for example, NIC and SCSI may
> not call __vhost_add_used_n with buffers in order.  It's the task of
> __vhost_add_used_n to order them.  This commit reorder the buffers using
> vq->heads, only the batch is begin from the expected start point and is
> continuous can the batch be exposed to driver.  And only writing out a
> single used ring for a batch of descriptors, according to VIRTIO 1.1
> spec.
>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> ---
>  drivers/vhost/vhost.c | 44 +++++++++++++++++++++++++++++++++++++++++--
>  drivers/vhost/vhost.h |  3 +++
>  2 files changed, 45 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 40097826c..e2e77e29f 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -317,6 +317,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>         vq->used_flags = 0;
>         vq->log_used = false;
>         vq->log_addr = -1ull;
> +       vq->next_used_head_idx = 0;
>         vq->private_data = NULL;
>         vq->acked_features = 0;
>         vq->acked_backend_features = 0;
> @@ -398,6 +399,8 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
>                                           GFP_KERNEL);
>                 if (!vq->indirect || !vq->log || !vq->heads)
>                         goto err_nomem;
> +
> +               memset(vq->heads, 0, sizeof(*vq->heads) * dev->iov_limit);
>         }
>         return 0;
>
> @@ -2374,12 +2377,49 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
>                             unsigned count)
>  {
>         vring_used_elem_t __user *used;
> +       struct vring_desc desc;
>         u16 old, new;
>         int start;
> +       int begin, end, i;
> +       int copy_n = count;
> +
> +       if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
> +               /* calculate descriptor chain length for each used buffer */
> +               for (i = 0; i < count; i++) {
> +                       begin = heads[i].id;
> +                       end = begin;
> +                       vq->heads[begin].len = 0;
> +                       do {
> +                               vq->heads[begin].len += 1;
> +                               if (unlikely(vhost_get_desc(vq, &desc, end))) {
> +                                       vq_err(vq, "Failed to get descriptor: idx %d addr %p\n",
> +                                              end, vq->desc + end);
> +                                       return -EFAULT;
> +                               }
> +                       } while ((end = next_desc(vq, &desc)) != -1);
> +               }
> +
> +               count = 0;
> +               /* sort and batch continuous used ring entry */
> +               while (vq->heads[vq->next_used_head_idx].len != 0) {
> +                       count++;
> +                       i = vq->next_used_head_idx;
> +                       vq->next_used_head_idx = (vq->next_used_head_idx +
> +                                                 vq->heads[vq->next_used_head_idx].len)
> +                                                 % vq->num;
> +                       vq->heads[i].len = 0;
> +               }

You're iterating vq->heads with two different indexes here.

The first loop is working with indexes [0, count), which is fine if
heads is a "cache" and everything can be overwritten (as it used to be
before this patch).

The other loop trusts in vq->next_used_head_idx, which is saved between calls.

So both uses are going to conflict with each other.

A proposal for checking this is to push the data in the chains
incrementally at the virtio_test driver, and check that they are
returned properly. Like, the first buffer in the chain has the value
of N, the second one N+1, and so on.

Let's split saving chains in its own patch.


> +               /* only write out a single used ring entry with the id corresponding
> +                * to the head entry of the descriptor chain describing the last buffer
> +                * in the batch.
> +                */

Let's delay the batching for now, we can add it as an optimization on
top in the case of devices.

My proposal is to define a new struct vring_used_elem_inorder:

struct vring_used_elem_inorder {
    uint16_t written'
    uint16_t num;
}

And create a per vq array of them, with vq->num size. Let's call it
used_inorder for example.

Everytime the device uses a buffer chain of N buffers, written L and
first descriptor id D, it stores vq->used_inorder[D] = { .written = L,
.num = N }. .num == 0 means the buffer is not available.

After storing that information, you have your next_used_head_idx. You
can check if vq->used_inorder[next_used_head_idx] is used (.num != 0).
In case is not, there is no need to perform any actions for now.

In case it is, you iterate vq->used_inorder. First you write as used
next_used_head_idx. After that, next_used_head_idx increments by .num,
and we need to clean .num. If vq->used_inorder[vq->next_used_head_idx]
is used too, repeat.

I think we could even squash vq->heads and vq->used_inorder with some
tricks, because a chain's length would always be bigger or equal than
used descriptor one, but to store in a different array would be more
clear.

> +               heads[0].id = i;
> +               copy_n = 1;

The device must not write anything to the used ring if the next
descriptor has not been used. I'm failing to trace how this works when
the second half of the batch in vhost/test.c is used here.

Thanks!


> +       }
>
>         start = vq->last_used_idx & (vq->num - 1);
>         used = vq->used->ring + start;
> -       if (vhost_put_used(vq, heads, start, count)) {
> +       if (vhost_put_used(vq, heads, start, copy_n)) {
>                 vq_err(vq, "Failed to write used");
>                 return -EFAULT;
>         }
> @@ -2410,7 +2450,7 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
>
>         start = vq->last_used_idx & (vq->num - 1);
>         n = vq->num - start;
> -       if (n < count) {
> +       if (n < count && !vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
>                 r = __vhost_add_used_n(vq, heads, n);
>                 if (r < 0)
>                         return r;
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index d9109107a..7b2c0fbb5 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -107,6 +107,9 @@ struct vhost_virtqueue {
>         bool log_used;
>         u64 log_addr;
>
> +       /* Sort heads in order */
> +       u16 next_used_head_idx;
> +
>         struct iovec iov[UIO_MAXIOV];
>         struct iovec iotlb_iov[64];
>         struct iovec *indirect;
> --
> 2.17.1
>

