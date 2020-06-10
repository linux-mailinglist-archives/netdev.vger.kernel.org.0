Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481831F5317
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 13:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgFJLZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 07:25:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42952 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728338AbgFJLZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 07:25:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591788316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A9nN+fjgfVmeHBRbYE/i0LUTg+I1/s8XskscLexNwaY=;
        b=NB0wJzXa2UXAzrACqV3+DyRe7gyC34iCuMGEpCT5YshlKuXV1PXdFwS0ctQ3Jb3vg6ecrX
        4WJ+U1PLv+flN73pX33BOU+G25pCVorr9BdlOJKLrc4zSrdrYacBpmXa9Z/1l0Xm/GjsmM
        zTEcMmo/oUiQKSiefF3c7tNVN2J/6S4=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-NgziB4vlMSGkDi1gFGmm3w-1; Wed, 10 Jun 2020 07:25:13 -0400
X-MC-Unique: NgziB4vlMSGkDi1gFGmm3w-1
Received: by mail-lj1-f200.google.com with SMTP id h14so257875ljk.7
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 04:25:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=A9nN+fjgfVmeHBRbYE/i0LUTg+I1/s8XskscLexNwaY=;
        b=MlpUmJVXYBCMaofSnIl+6EMECIC0JFoQkhOic6wxHmISrmnaTIzkmD9fI0IW0paUZD
         iT0tQKvEsDtX30M5ZWg7m2G1DHmK4st6VmEPXmGvTiOB6L50YJkqauLGXBuwJmjgxi4j
         1Tsee6KibBW8Y6AY74jAb4P3QdGlotxrr4pXdNI6VdouPYYxmiXCH4eyC+OjyyTQs779
         Mjfv8VM6ooGFNpjF8WyY+6d761uIIMQWdPmsdnYywf8kPY0c0X+s+QqTPdqsXglnyqcz
         UocNS60G7jzmFsVqSNAm9jVvaOn16Hg69hUmKzAkpu1NQPkuPtz8RoqRKanQ/4miQFXl
         efBQ==
X-Gm-Message-State: AOAM5323chTpaHd5ZUB5Cc85TzaMAWkwhJVp/g+TwyGBizqIdHI37djD
        Tbfw7/ZoSHZz0aEYn2u2Ytnyk/U1m012UlKvghKnrlOwQb479CpzOGfk1q//F8FV0eej0rFmtua
        yYlzHFtPVCcuh9i0Q/BVT0EfbQZxyj7eE
X-Received: by 2002:a2e:a54f:: with SMTP id e15mr1722523ljn.263.1591788311764;
        Wed, 10 Jun 2020 04:25:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw3l12ye0TrhCY/uYiDrQNYxrFiz+5lszrBwu4lv4vF27XHYbHHLzZZlrrk3+mWP866n2GTQVqSWSIrXYhSVD0=
X-Received: by 2002:a2e:a54f:: with SMTP id e15mr1722496ljn.263.1591788311208;
 Wed, 10 Jun 2020 04:25:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200608125238.728563-1-mst@redhat.com> <20200608125238.728563-3-mst@redhat.com>
In-Reply-To: <20200608125238.728563-3-mst@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 10 Jun 2020 13:24:35 +0200
Message-ID: <CAJaqyWc0d-X4XNO2HC6Rs30j=PU1Uohr+rn=-=pbQmHhCKhYGw@mail.gmail.com>
Subject: Re: [PATCH RFC v6 02/11] vhost: use batched get_vq_desc version
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 8, 2020 at 2:53 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> As testing shows no performance change, switch to that now.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> Link: https://lore.kernel.org/r/20200401183118.8334-3-eperezma@redhat.com
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/vhost/test.c  |   2 +-
>  drivers/vhost/vhost.c | 318 ++++++++----------------------------------
>  drivers/vhost/vhost.h |   7 +-
>  3 files changed, 65 insertions(+), 262 deletions(-)
>
> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> index 0466921f4772..7d69778aaa26 100644
> --- a/drivers/vhost/test.c
> +++ b/drivers/vhost/test.c
> @@ -119,7 +119,7 @@ static int vhost_test_open(struct inode *inode, struc=
t file *f)
>         dev =3D &n->dev;
>         vqs[VHOST_TEST_VQ] =3D &n->vqs[VHOST_TEST_VQ];
>         n->vqs[VHOST_TEST_VQ].handle_kick =3D handle_vq_kick;
> -       vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
> +       vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV + 64,
>                        VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, true, NU=
LL);
>
>         f->private_data =3D n;
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 180b7b58c76b..41d6b132c234 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -304,6 +304,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>  {
>         vq->num =3D 1;
>         vq->ndescs =3D 0;
> +       vq->first_desc =3D 0;
>         vq->desc =3D NULL;
>         vq->avail =3D NULL;
>         vq->used =3D NULL;
> @@ -372,6 +373,11 @@ static int vhost_worker(void *data)
>         return 0;
>  }
>
> +static int vhost_vq_num_batch_descs(struct vhost_virtqueue *vq)
> +{
> +       return vq->max_descs - UIO_MAXIOV;
> +}
> +
>  static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
>  {
>         kfree(vq->descs);
> @@ -394,6 +400,9 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *=
dev)
>         for (i =3D 0; i < dev->nvqs; ++i) {
>                 vq =3D dev->vqs[i];
>                 vq->max_descs =3D dev->iov_limit;
> +               if (vhost_vq_num_batch_descs(vq) < 0) {
> +                       return -EINVAL;
> +               }
>                 vq->descs =3D kmalloc_array(vq->max_descs,
>                                           sizeof(*vq->descs),
>                                           GFP_KERNEL);
> @@ -1610,6 +1619,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigne=
d int ioctl, void __user *arg
>                 vq->last_avail_idx =3D s.num;
>                 /* Forget the cached index value. */
>                 vq->avail_idx =3D vq->last_avail_idx;
> +               vq->ndescs =3D vq->first_desc =3D 0;
>                 break;
>         case VHOST_GET_VRING_BASE:
>                 s.index =3D idx;
> @@ -2078,253 +2088,6 @@ static unsigned next_desc(struct vhost_virtqueue =
*vq, struct vring_desc *desc)
>         return next;
>  }
>
> -static int get_indirect(struct vhost_virtqueue *vq,
> -                       struct iovec iov[], unsigned int iov_size,
> -                       unsigned int *out_num, unsigned int *in_num,
> -                       struct vhost_log *log, unsigned int *log_num,
> -                       struct vring_desc *indirect)
> -{
> -       struct vring_desc desc;
> -       unsigned int i =3D 0, count, found =3D 0;
> -       u32 len =3D vhost32_to_cpu(vq, indirect->len);
> -       struct iov_iter from;
> -       int ret, access;
> -
> -       /* Sanity check */
> -       if (unlikely(len % sizeof desc)) {
> -               vq_err(vq, "Invalid length in indirect descriptor: "
> -                      "len 0x%llx not multiple of 0x%zx\n",
> -                      (unsigned long long)len,
> -                      sizeof desc);
> -               return -EINVAL;
> -       }
> -
> -       ret =3D translate_desc(vq, vhost64_to_cpu(vq, indirect->addr), le=
n, vq->indirect,
> -                            UIO_MAXIOV, VHOST_ACCESS_RO);
> -       if (unlikely(ret < 0)) {
> -               if (ret !=3D -EAGAIN)
> -                       vq_err(vq, "Translation failure %d in indirect.\n=
", ret);
> -               return ret;
> -       }
> -       iov_iter_init(&from, READ, vq->indirect, ret, len);
> -
> -       /* We will use the result as an address to read from, so most
> -        * architectures only need a compiler barrier here. */
> -       read_barrier_depends();
> -
> -       count =3D len / sizeof desc;
> -       /* Buffers are chained via a 16 bit next field, so
> -        * we can have at most 2^16 of these. */
> -       if (unlikely(count > USHRT_MAX + 1)) {
> -               vq_err(vq, "Indirect buffer length too big: %d\n",
> -                      indirect->len);
> -               return -E2BIG;
> -       }
> -
> -       do {
> -               unsigned iov_count =3D *in_num + *out_num;
> -               if (unlikely(++found > count)) {
> -                       vq_err(vq, "Loop detected: last one at %u "
> -                              "indirect size %u\n",
> -                              i, count);
> -                       return -EINVAL;
> -               }
> -               if (unlikely(!copy_from_iter_full(&desc, sizeof(desc), &f=
rom))) {
> -                       vq_err(vq, "Failed indirect descriptor: idx %d, %=
zx\n",
> -                              i, (size_t)vhost64_to_cpu(vq, indirect->ad=
dr) + i * sizeof desc);
> -                       return -EINVAL;
> -               }
> -               if (unlikely(desc.flags & cpu_to_vhost16(vq, VRING_DESC_F=
_INDIRECT))) {
> -                       vq_err(vq, "Nested indirect descriptor: idx %d, %=
zx\n",
> -                              i, (size_t)vhost64_to_cpu(vq, indirect->ad=
dr) + i * sizeof desc);
> -                       return -EINVAL;
> -               }
> -
> -               if (desc.flags & cpu_to_vhost16(vq, VRING_DESC_F_WRITE))
> -                       access =3D VHOST_ACCESS_WO;
> -               else
> -                       access =3D VHOST_ACCESS_RO;
> -
> -               ret =3D translate_desc(vq, vhost64_to_cpu(vq, desc.addr),
> -                                    vhost32_to_cpu(vq, desc.len), iov + =
iov_count,
> -                                    iov_size - iov_count, access);
> -               if (unlikely(ret < 0)) {
> -                       if (ret !=3D -EAGAIN)
> -                               vq_err(vq, "Translation failure %d indire=
ct idx %d\n",
> -                                       ret, i);
> -                       return ret;
> -               }
> -               /* If this is an input descriptor, increment that count. =
*/
> -               if (access =3D=3D VHOST_ACCESS_WO) {
> -                       *in_num +=3D ret;
> -                       if (unlikely(log && ret)) {
> -                               log[*log_num].addr =3D vhost64_to_cpu(vq,=
 desc.addr);
> -                               log[*log_num].len =3D vhost32_to_cpu(vq, =
desc.len);
> -                               ++*log_num;
> -                       }
> -               } else {
> -                       /* If it's an output descriptor, they're all supp=
osed
> -                        * to come before any input descriptors. */
> -                       if (unlikely(*in_num)) {
> -                               vq_err(vq, "Indirect descriptor "
> -                                      "has out after in: idx %d\n", i);
> -                               return -EINVAL;
> -                       }
> -                       *out_num +=3D ret;
> -               }
> -       } while ((i =3D next_desc(vq, &desc)) !=3D -1);
> -       return 0;
> -}
> -
> -/* This looks in the virtqueue and for the first available buffer, and c=
onverts
> - * it to an iovec for convenient access.  Since descriptors consist of s=
ome
> - * number of output then some number of input descriptors, it's actually=
 two
> - * iovecs, but we pack them into one and note how many of each there wer=
e.
> - *
> - * This function returns the descriptor number found, or vq->num (which =
is
> - * never a valid descriptor number) if none was found.  A negative code =
is
> - * returned on error. */
> -int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> -                     struct iovec iov[], unsigned int iov_size,
> -                     unsigned int *out_num, unsigned int *in_num,
> -                     struct vhost_log *log, unsigned int *log_num)
> -{
> -       struct vring_desc desc;
> -       unsigned int i, head, found =3D 0;
> -       u16 last_avail_idx;
> -       __virtio16 avail_idx;
> -       __virtio16 ring_head;
> -       int ret, access;
> -
> -       /* Check it isn't doing very strange things with descriptor numbe=
rs. */
> -       last_avail_idx =3D vq->last_avail_idx;
> -
> -       if (vq->avail_idx =3D=3D vq->last_avail_idx) {
> -               if (unlikely(vhost_get_avail_idx(vq, &avail_idx))) {
> -                       vq_err(vq, "Failed to access avail idx at %p\n",
> -                               &vq->avail->idx);
> -                       return -EFAULT;
> -               }
> -               vq->avail_idx =3D vhost16_to_cpu(vq, avail_idx);
> -
> -               if (unlikely((u16)(vq->avail_idx - last_avail_idx) > vq->=
num)) {
> -                       vq_err(vq, "Guest moved used index from %u to %u"=
,
> -                               last_avail_idx, vq->avail_idx);
> -                       return -EFAULT;
> -               }
> -
> -               /* If there's nothing new since last we looked, return
> -                * invalid.
> -                */
> -               if (vq->avail_idx =3D=3D last_avail_idx)
> -                       return vq->num;
> -
> -               /* Only get avail ring entries after they have been
> -                * exposed by guest.
> -                */
> -               smp_rmb();
> -       }
> -
> -       /* Grab the next descriptor number they're advertising, and incre=
ment
> -        * the index we've seen. */
> -       if (unlikely(vhost_get_avail_head(vq, &ring_head, last_avail_idx)=
)) {
> -               vq_err(vq, "Failed to read head: idx %d address %p\n",
> -                      last_avail_idx,
> -                      &vq->avail->ring[last_avail_idx % vq->num]);
> -               return -EFAULT;
> -       }
> -
> -       head =3D vhost16_to_cpu(vq, ring_head);
> -
> -       /* If their number is silly, that's an error. */
> -       if (unlikely(head >=3D vq->num)) {
> -               vq_err(vq, "Guest says index %u > %u is available",
> -                      head, vq->num);
> -               return -EINVAL;
> -       }
> -
> -       /* When we start there are none of either input nor output. */
> -       *out_num =3D *in_num =3D 0;
> -       if (unlikely(log))
> -               *log_num =3D 0;
> -
> -       i =3D head;
> -       do {
> -               unsigned iov_count =3D *in_num + *out_num;
> -               if (unlikely(i >=3D vq->num)) {
> -                       vq_err(vq, "Desc index is %u > %u, head =3D %u",
> -                              i, vq->num, head);
> -                       return -EINVAL;
> -               }
> -               if (unlikely(++found > vq->num)) {
> -                       vq_err(vq, "Loop detected: last one at %u "
> -                              "vq size %u head %u\n",
> -                              i, vq->num, head);
> -                       return -EINVAL;
> -               }
> -               ret =3D vhost_get_desc(vq, &desc, i);
> -               if (unlikely(ret)) {
> -                       vq_err(vq, "Failed to get descriptor: idx %d addr=
 %p\n",
> -                              i, vq->desc + i);
> -                       return -EFAULT;
> -               }
> -               if (desc.flags & cpu_to_vhost16(vq, VRING_DESC_F_INDIRECT=
)) {
> -                       ret =3D get_indirect(vq, iov, iov_size,
> -                                          out_num, in_num,
> -                                          log, log_num, &desc);
> -                       if (unlikely(ret < 0)) {
> -                               if (ret !=3D -EAGAIN)
> -                                       vq_err(vq, "Failure detected "
> -                                               "in indirect descriptor a=
t idx %d\n", i);
> -                               return ret;
> -                       }
> -                       continue;
> -               }
> -
> -               if (desc.flags & cpu_to_vhost16(vq, VRING_DESC_F_WRITE))
> -                       access =3D VHOST_ACCESS_WO;
> -               else
> -                       access =3D VHOST_ACCESS_RO;
> -               ret =3D translate_desc(vq, vhost64_to_cpu(vq, desc.addr),
> -                                    vhost32_to_cpu(vq, desc.len), iov + =
iov_count,
> -                                    iov_size - iov_count, access);
> -               if (unlikely(ret < 0)) {
> -                       if (ret !=3D -EAGAIN)
> -                               vq_err(vq, "Translation failure %d descri=
ptor idx %d\n",
> -                                       ret, i);
> -                       return ret;
> -               }
> -               if (access =3D=3D VHOST_ACCESS_WO) {
> -                       /* If this is an input descriptor,
> -                        * increment that count. */
> -                       *in_num +=3D ret;
> -                       if (unlikely(log && ret)) {
> -                               log[*log_num].addr =3D vhost64_to_cpu(vq,=
 desc.addr);
> -                               log[*log_num].len =3D vhost32_to_cpu(vq, =
desc.len);
> -                               ++*log_num;
> -                       }
> -               } else {
> -                       /* If it's an output descriptor, they're all supp=
osed
> -                        * to come before any input descriptors. */
> -                       if (unlikely(*in_num)) {
> -                               vq_err(vq, "Descriptor has out after in: =
"
> -                                      "idx %d\n", i);
> -                               return -EINVAL;
> -                       }
> -                       *out_num +=3D ret;
> -               }
> -       } while ((i =3D next_desc(vq, &desc)) !=3D -1);
> -
> -       /* On success, increment avail index. */
> -       vq->last_avail_idx++;
> -
> -       /* Assume notifications from guest are disabled at this point,
> -        * if they aren't we would need to update avail_event index. */
> -       BUG_ON(!(vq->used_flags & VRING_USED_F_NO_NOTIFY));
> -       return head;
> -}
> -EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
> -
>  static struct vhost_desc *peek_split_desc(struct vhost_virtqueue *vq)
>  {
>         BUG_ON(!vq->ndescs);
> @@ -2428,7 +2191,7 @@ static int fetch_indirect_descs(struct vhost_virtqu=
eue *vq,
>
>  /* This function returns a value > 0 if a descriptor was found, or 0 if =
none were found.
>   * A negative code is returned on error. */
> -static int fetch_descs(struct vhost_virtqueue *vq)
> +static int (struct vhost_virtqueue *vq)
>  {
>         unsigned int i, head, found =3D 0;
>         struct vhost_desc *last;
> @@ -2441,7 +2204,11 @@ static int fetch_descs(struct vhost_virtqueue *vq)
>         /* Check it isn't doing very strange things with descriptor numbe=
rs. */
>         last_avail_idx =3D vq->last_avail_idx;
>
> -       if (vq->avail_idx =3D=3D vq->last_avail_idx) {
> +       if (unlikely(vq->avail_idx =3D=3D vq->last_avail_idx)) {
> +               /* If we already have work to do, don't bother re-checkin=
g. */
> +               if (likely(vq->ndescs))
> +                       return 1;

If this path is taken and vq->ndescs < vhost_vq_num_batch_descs, the
for{} in fetch_descs will never exit. Do we want to accumulate as many
buffers as possible, or to return them early? Maybe to find a proper
threshold?

(Still testing next commits)

> +
>                 if (unlikely(vhost_get_avail_idx(vq, &avail_idx))) {
>                         vq_err(vq, "Failed to access avail idx at %p\n",
>                                 &vq->avail->idx);
> @@ -2532,6 +2299,41 @@ static int fetch_descs(struct vhost_virtqueue *vq)
>         return 1;
>  }
>
> +/* This function returns a value > 0 if a descriptor was found, or 0 if =
none were found.
> + * A negative code is returned on error. */
> +static int fetch_descs(struct vhost_virtqueue *vq)
> +{
> +       int ret;
> +
> +       if (unlikely(vq->first_desc >=3D vq->ndescs)) {
> +               vq->first_desc =3D 0;
> +               vq->ndescs =3D 0;
> +       }
> +
> +       if (vq->ndescs)
> +               return 1;
> +
> +       for (ret =3D 1;
> +            ret > 0 && vq->ndescs <=3D vhost_vq_num_batch_descs(vq);
> +            ret =3D fetch_buf(vq))
> +               ;
> +
> +       /* On success we expect some descs */
> +       BUG_ON(ret > 0 && !vq->ndescs);
> +       return ret;
> +}
> +
> +/* Reverse the effects of fetch_descs */
> +static void unfetch_descs(struct vhost_virtqueue *vq)
> +{
> +       int i;
> +
> +       for (i =3D vq->first_desc; i < vq->ndescs; ++i)
> +               if (!(vq->descs[i].flags & VRING_DESC_F_NEXT))
> +                       vq->last_avail_idx -=3D 1;
> +       vq->ndescs =3D 0;
> +}
> +
>  /* This looks in the virtqueue and for the first available buffer, and c=
onverts
>   * it to an iovec for convenient access.  Since descriptors consist of s=
ome
>   * number of output then some number of input descriptors, it's actually=
 two
> @@ -2540,7 +2342,7 @@ static int fetch_descs(struct vhost_virtqueue *vq)
>   * This function returns the descriptor number found, or vq->num (which =
is
>   * never a valid descriptor number) if none was found.  A negative code =
is
>   * returned on error. */
> -int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
> +int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>                       struct iovec iov[], unsigned int iov_size,
>                       unsigned int *out_num, unsigned int *in_num,
>                       struct vhost_log *log, unsigned int *log_num)
> @@ -2549,7 +2351,7 @@ int vhost_get_vq_desc_batch(struct vhost_virtqueue =
*vq,
>         int i;
>
>         if (ret <=3D 0)
> -               goto err_fetch;
> +               goto err;

This return needs to differentiate between fetch_desc returning 0 (in
that case, it needs to return vq->num) and fetch_descs < 0 (goto err).

(Already noted by you in different thread, but pointing here just to
not forget it).

>
>         /* Now convert to IOV */
>         /* When we start there are none of either input nor output. */
> @@ -2557,7 +2359,7 @@ int vhost_get_vq_desc_batch(struct vhost_virtqueue =
*vq,
>         if (unlikely(log))
>                 *log_num =3D 0;
>
> -       for (i =3D 0; i < vq->ndescs; ++i) {
> +       for (i =3D vq->first_desc; i < vq->ndescs; ++i) {
>                 unsigned iov_count =3D *in_num + *out_num;
>                 struct vhost_desc *desc =3D &vq->descs[i];
>                 int access;
> @@ -2603,24 +2405,26 @@ int vhost_get_vq_desc_batch(struct vhost_virtqueu=
e *vq,
>                 }
>
>                 ret =3D desc->id;
> +
> +               if (!(desc->flags & VRING_DESC_F_NEXT))
> +                       break;
>         }
>
> -       vq->ndescs =3D 0;
> +       vq->first_desc =3D i + 1;
>
>         return ret;
>
>  err:
> -       vhost_discard_vq_desc(vq, 1);
> -err_fetch:
> -       vq->ndescs =3D 0;
> +       unfetch_descs(vq);
>
>         return ret;
>  }
> -EXPORT_SYMBOL_GPL(vhost_get_vq_desc_batch);
> +EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
>
>  /* Reverse the effect of vhost_get_vq_desc. Useful for error handling. *=
/
>  void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
>  {
> +       unfetch_descs(vq);
>         vq->last_avail_idx -=3D n;
>  }
>  EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 87089d51490d..fed36af5c444 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -81,6 +81,7 @@ struct vhost_virtqueue {
>
>         struct vhost_desc *descs;
>         int ndescs;
> +       int first_desc;
>         int max_descs;
>
>         struct file *kick;
> @@ -189,10 +190,6 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned=
 int ioctl, void __user *arg
>  bool vhost_vq_access_ok(struct vhost_virtqueue *vq);
>  bool vhost_log_access_ok(struct vhost_dev *);
>
> -int vhost_get_vq_desc_batch(struct vhost_virtqueue *,
> -                     struct iovec iov[], unsigned int iov_count,
> -                     unsigned int *out_num, unsigned int *in_num,
> -                     struct vhost_log *log, unsigned int *log_num);
>  int vhost_get_vq_desc(struct vhost_virtqueue *,
>                       struct iovec iov[], unsigned int iov_count,
>                       unsigned int *out_num, unsigned int *in_num,
> @@ -261,6 +258,8 @@ static inline void vhost_vq_set_backend(struct vhost_=
virtqueue *vq,
>                                         void *private_data)
>  {
>         vq->private_data =3D private_data;
> +       vq->ndescs =3D 0;
> +       vq->first_desc =3D 0;
>  }
>
>  /**
> --
> MST
>

