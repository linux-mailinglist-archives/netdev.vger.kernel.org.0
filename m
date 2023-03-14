Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9ABF6B89EB
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 05:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjCNEzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 00:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjCNEzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 00:55:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D6F26CEA
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 21:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678769651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mhbeQsCOWkBmfbdwAK6IkHvnb648Y/rpGHwMeBRvTFU=;
        b=CifTnEFe9qkDYFQsR3/zb0dGmRhS/M+CKN4CE0x6EkI69/IzDUZEtU40WTXssM0li1RUl9
        rg6J5Uw3pCcoH11QVMgbpLnaPeBIFAbmkjImDoR3coJPtgp9I+peHhusbZ5H5uB5jfFdfg
        zK+6YhXTeEEOUrMmhXnJT6ikmI5RcHM=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-nnWgTqHENKKr9CJmUuw-Xg-1; Tue, 14 Mar 2023 00:54:10 -0400
X-MC-Unique: nnWgTqHENKKr9CJmUuw-Xg-1
Received: by mail-ot1-f72.google.com with SMTP id p21-20020a9d6955000000b00696141d38e6so690627oto.8
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 21:54:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678769649;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mhbeQsCOWkBmfbdwAK6IkHvnb648Y/rpGHwMeBRvTFU=;
        b=ld2JVkwwbKJs4wDAXNqE2ZFiLa1DR0vihQm2AwY6SNhVe6zQzBIOQ9U4mWgdZJcH7O
         FEa38KkuFQMIDMN7dr7Iesmt+9h1VHeejtZ1uDs1JwUjwRgkAppY/3O21nx0edvbehFj
         690cbAz6Ci7GMg9BxN+zAaTc5NHhdDZwJfaC/ofSyqTQIsYM0KtbyRV/Xx6UP3uuhDMl
         /jQJshE7E6apaGmw41EohddS22Y7A3A7qtEJ2hoFX+sLfBFaubErPFTPknBB3mYCc/Ui
         95LbVDf23FiYPZWgPD7K/zoyd6n6I3xP2PjxkANjMpRynbk8/7VgJj58uen1qcaf9fwS
         iNXQ==
X-Gm-Message-State: AO0yUKXAznJG2Ze/dZodeXEYO6Chdt4UIlNDtnEIzo/KjJMC56w4GoD1
        3v/hjOWtYR8n5mlRcy70E03KrRnlugO6ujqvks236SJFrU7Zi4v6Niz6Hz+az4D/Yu6oLDGLv0a
        WZZF85CVyko5MWn4xHOlSP36YkRL6zkgg
X-Received: by 2002:a05:6870:5147:b0:177:b9c0:bcba with SMTP id z7-20020a056870514700b00177b9c0bcbamr2444288oak.3.1678769649246;
        Mon, 13 Mar 2023 21:54:09 -0700 (PDT)
X-Google-Smtp-Source: AK7set+nRM380JVzXg4oGG6ZzdC0Wyk+h+IHs+whvfeimKYfKtBA7Fkefnns9aW+jmQB5Dnx/xRGCvWfvJjeLfw2NKQ=
X-Received: by 2002:a05:6870:5147:b0:177:b9c0:bcba with SMTP id
 z7-20020a056870514700b00177b9c0bcbamr2444279oak.3.1678769648938; Mon, 13 Mar
 2023 21:54:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230302113421.174582-1-sgarzare@redhat.com> <20230302113421.174582-5-sgarzare@redhat.com>
In-Reply-To: <20230302113421.174582-5-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 14 Mar 2023 12:53:57 +0800
Message-ID: <CACGkMEui+-8JcTOsF+=b3W7oduMLsaL3Y7upUDmAMu4zPcrQTg@mail.gmail.com>
Subject: Re: [PATCH v2 4/8] vringh: support VA with iotlb
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 2, 2023 at 7:35=E2=80=AFPM Stefano Garzarella <sgarzare@redhat.=
com> wrote:
>
> vDPA supports the possibility to use user VA in the iotlb messages.
> So, let's add support for user VA in vringh to use it in the vDPA
> simulators.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>
> Notes:
>     v2:
>     - replace kmap_atomic() with kmap_local_page() [see previous patch]
>     - fix cast warnings when build with W=3D1 C=3D1
>
>  include/linux/vringh.h            |   5 +-
>  drivers/vdpa/mlx5/net/mlx5_vnet.c |   2 +-
>  drivers/vdpa/vdpa_sim/vdpa_sim.c  |   4 +-
>  drivers/vhost/vringh.c            | 247 ++++++++++++++++++++++++------
>  4 files changed, 205 insertions(+), 53 deletions(-)
>
> diff --git a/include/linux/vringh.h b/include/linux/vringh.h
> index 1991a02c6431..d39b9f2dcba0 100644
> --- a/include/linux/vringh.h
> +++ b/include/linux/vringh.h
> @@ -32,6 +32,9 @@ struct vringh {
>         /* Can we get away with weak barriers? */
>         bool weak_barriers;
>
> +       /* Use user's VA */
> +       bool use_va;
> +
>         /* Last available index we saw (ie. where we're up to). */
>         u16 last_avail_idx;
>
> @@ -279,7 +282,7 @@ void vringh_set_iotlb(struct vringh *vrh, struct vhos=
t_iotlb *iotlb,
>                       spinlock_t *iotlb_lock);
>
>  int vringh_init_iotlb(struct vringh *vrh, u64 features,
> -                     unsigned int num, bool weak_barriers,
> +                     unsigned int num, bool weak_barriers, bool use_va,
>                       struct vring_desc *desc,
>                       struct vring_avail *avail,
>                       struct vring_used *used);
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/ml=
x5_vnet.c
> index 3a0e721aef05..babc8dd171a6 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -2537,7 +2537,7 @@ static int setup_cvq_vring(struct mlx5_vdpa_dev *mv=
dev)
>
>         if (mvdev->actual_features & BIT_ULL(VIRTIO_NET_F_CTRL_VQ))
>                 err =3D vringh_init_iotlb(&cvq->vring, mvdev->actual_feat=
ures,
> -                                       MLX5_CVQ_MAX_ENT, false,
> +                                       MLX5_CVQ_MAX_ENT, false, false,
>                                         (struct vring_desc *)(uintptr_t)c=
vq->desc_addr,
>                                         (struct vring_avail *)(uintptr_t)=
cvq->driver_addr,
>                                         (struct vring_used *)(uintptr_t)c=
vq->device_addr);
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdp=
a_sim.c
> index 6a0a65814626..481eb156658b 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -60,7 +60,7 @@ static void vdpasim_queue_ready(struct vdpasim *vdpasim=
, unsigned int idx)
>         struct vdpasim_virtqueue *vq =3D &vdpasim->vqs[idx];
>         uint16_t last_avail_idx =3D vq->vring.last_avail_idx;
>
> -       vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, true,
> +       vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, true, f=
alse,
>                           (struct vring_desc *)(uintptr_t)vq->desc_addr,
>                           (struct vring_avail *)
>                           (uintptr_t)vq->driver_addr,
> @@ -81,7 +81,7 @@ static void vdpasim_vq_reset(struct vdpasim *vdpasim,
>         vq->cb =3D NULL;
>         vq->private =3D NULL;
>         vringh_init_iotlb(&vq->vring, vdpasim->dev_attr.supported_feature=
s,
> -                         VDPASIM_QUEUE_MAX, false, NULL, NULL, NULL);
> +                         VDPASIM_QUEUE_MAX, false, false, NULL, NULL, NU=
LL);
>
>         vq->vring.notify =3D NULL;
>  }
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index 0ba3ef809e48..61c79cea44ca 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -1094,15 +1094,99 @@ EXPORT_SYMBOL(vringh_need_notify_kern);
>
>  #if IS_REACHABLE(CONFIG_VHOST_IOTLB)
>
> -static int iotlb_translate(const struct vringh *vrh,
> -                          u64 addr, u64 len, u64 *translated,
> -                          struct bio_vec iov[],
> -                          int iov_size, u32 perm)
> +static int iotlb_translate_va(const struct vringh *vrh,
> +                             u64 addr, u64 len, u64 *translated,
> +                             struct iovec iov[],
> +                             int iov_size, u32 perm)
>  {
>         struct vhost_iotlb_map *map;
>         struct vhost_iotlb *iotlb =3D vrh->iotlb;
> +       u64 s =3D 0, last =3D addr + len - 1;
>         int ret =3D 0;
> +
> +       spin_lock(vrh->iotlb_lock);
> +
> +       while (len > s) {
> +               u64 size;
> +
> +               if (unlikely(ret >=3D iov_size)) {
> +                       ret =3D -ENOBUFS;
> +                       break;
> +               }
> +
> +               map =3D vhost_iotlb_itree_first(iotlb, addr, last);
> +               if (!map || map->start > addr) {
> +                       ret =3D -EINVAL;
> +                       break;
> +               } else if (!(map->perm & perm)) {
> +                       ret =3D -EPERM;
> +                       break;
> +               }
> +
> +               size =3D map->size - addr + map->start;
> +               iov[ret].iov_len =3D min(len - s, size);
> +               iov[ret].iov_base =3D (void __user *)(unsigned long)
> +                                   (map->addr + addr - map->start);
> +               s +=3D size;
> +               addr +=3D size;
> +               ++ret;
> +       }
> +
> +       spin_unlock(vrh->iotlb_lock);
> +
> +       if (translated)
> +               *translated =3D min(len, s);
> +
> +       return ret;
> +}
> +
> +static inline int copy_from_va(const struct vringh *vrh, void *dst, void=
 *src,
> +                              u64 len, u64 *translated)
> +{
> +       struct iovec iov[16];
> +       struct iov_iter iter;
> +       int ret;
> +
> +       ret =3D iotlb_translate_va(vrh, (u64)(uintptr_t)src, len, transla=
ted, iov,
> +                                ARRAY_SIZE(iov), VHOST_MAP_RO);
> +       if (ret =3D=3D -ENOBUFS)
> +               ret =3D ARRAY_SIZE(iov);
> +       else if (ret < 0)
> +               return ret;
> +
> +       iov_iter_init(&iter, ITER_SOURCE, iov, ret, *translated);
> +
> +       return copy_from_iter(dst, *translated, &iter);
> +}
> +
> +static inline int copy_to_va(const struct vringh *vrh, void *dst, void *=
src,
> +                            u64 len, u64 *translated)
> +{
> +       struct iovec iov[16];
> +       struct iov_iter iter;
> +       int ret;
> +
> +       ret =3D iotlb_translate_va(vrh, (u64)(uintptr_t)dst, len, transla=
ted, iov,
> +                                ARRAY_SIZE(iov), VHOST_MAP_WO);
> +       if (ret =3D=3D -ENOBUFS)
> +               ret =3D ARRAY_SIZE(iov);
> +       else if (ret < 0)
> +               return ret;
> +
> +       iov_iter_init(&iter, ITER_DEST, iov, ret, *translated);
> +
> +       return copy_to_iter(src, *translated, &iter);
> +}
> +
> +static int iotlb_translate_pa(const struct vringh *vrh,
> +                             u64 addr, u64 len, u64 *translated,
> +                             struct bio_vec iov[],
> +                             int iov_size, u32 perm)
> +{
> +       struct vhost_iotlb_map *map;
> +       struct vhost_iotlb *iotlb =3D vrh->iotlb;
>         u64 s =3D 0, last =3D addr + len - 1;
> +       int ret =3D 0;
>
>         spin_lock(vrh->iotlb_lock);
>
> @@ -1141,28 +1225,61 @@ static int iotlb_translate(const struct vringh *v=
rh,
>         return ret;
>  }
>
> +static inline int copy_from_pa(const struct vringh *vrh, void *dst, void=
 *src,
> +                              u64 len, u64 *translated)
> +{
> +       struct bio_vec iov[16];
> +       struct iov_iter iter;
> +       int ret;
> +
> +       ret =3D iotlb_translate_pa(vrh, (u64)(uintptr_t)src, len, transla=
ted, iov,
> +                                ARRAY_SIZE(iov), VHOST_MAP_RO);
> +       if (ret =3D=3D -ENOBUFS)
> +               ret =3D ARRAY_SIZE(iov);
> +       else if (ret < 0)
> +               return ret;
> +
> +       iov_iter_bvec(&iter, ITER_SOURCE, iov, ret, *translated);
> +
> +       return copy_from_iter(dst, *translated, &iter);
> +}
> +
> +static inline int copy_to_pa(const struct vringh *vrh, void *dst, void *=
src,
> +                            u64 len, u64 *translated)
> +{
> +       struct bio_vec iov[16];
> +       struct iov_iter iter;
> +       int ret;
> +
> +       ret =3D iotlb_translate_pa(vrh, (u64)(uintptr_t)dst, len, transla=
ted, iov,
> +                                ARRAY_SIZE(iov), VHOST_MAP_WO);
> +       if (ret =3D=3D -ENOBUFS)
> +               ret =3D ARRAY_SIZE(iov);
> +       else if (ret < 0)
> +               return ret;
> +
> +       iov_iter_bvec(&iter, ITER_DEST, iov, ret, *translated);
> +
> +       return copy_to_iter(src, *translated, &iter);
> +}
> +
>  static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
>                                   void *src, size_t len)
>  {
>         u64 total_translated =3D 0;
>
>         while (total_translated < len) {
> -               struct bio_vec iov[16];
> -               struct iov_iter iter;
>                 u64 translated;
>                 int ret;
>
> -               ret =3D iotlb_translate(vrh, (u64)(uintptr_t)src,
> -                                     len - total_translated, &translated=
,
> -                                     iov, ARRAY_SIZE(iov), VHOST_MAP_RO)=
;
> -               if (ret =3D=3D -ENOBUFS)
> -                       ret =3D ARRAY_SIZE(iov);
> -               else if (ret < 0)
> -                       return ret;
> -
> -               iov_iter_bvec(&iter, ITER_SOURCE, iov, ret, translated);
> +               if (vrh->use_va) {
> +                       ret =3D copy_from_va(vrh, dst, src,
> +                                          len - total_translated, &trans=
lated);
> +               } else {
> +                       ret =3D copy_from_pa(vrh, dst, src,
> +                                          len - total_translated, &trans=
lated);
> +               }
>
> -               ret =3D copy_from_iter(dst, translated, &iter);
>                 if (ret < 0)
>                         return ret;
>
> @@ -1180,22 +1297,17 @@ static inline int copy_to_iotlb(const struct vrin=
gh *vrh, void *dst,
>         u64 total_translated =3D 0;
>
>         while (total_translated < len) {
> -               struct bio_vec iov[16];
> -               struct iov_iter iter;
>                 u64 translated;
>                 int ret;
>
> -               ret =3D iotlb_translate(vrh, (u64)(uintptr_t)dst,
> -                                     len - total_translated, &translated=
,
> -                                     iov, ARRAY_SIZE(iov), VHOST_MAP_WO)=
;
> -               if (ret =3D=3D -ENOBUFS)
> -                       ret =3D ARRAY_SIZE(iov);
> -               else if (ret < 0)
> -                       return ret;
> -
> -               iov_iter_bvec(&iter, ITER_DEST, iov, ret, translated);
> +               if (vrh->use_va) {
> +                       ret =3D copy_to_va(vrh, dst, src,
> +                                        len - total_translated, &transla=
ted);
> +               } else {
> +                       ret =3D copy_to_pa(vrh, dst, src,
> +                                        len - total_translated, &transla=
ted);
> +               }
>
> -               ret =3D copy_to_iter(src, translated, &iter);
>                 if (ret < 0)
>                         return ret;
>
> @@ -1210,20 +1322,37 @@ static inline int copy_to_iotlb(const struct vrin=
gh *vrh, void *dst,
>  static inline int getu16_iotlb(const struct vringh *vrh,
>                                u16 *val, const __virtio16 *p)
>  {
> -       struct bio_vec iov;
> -       void *kaddr, *from;
>         int ret;
>
>         /* Atomic read is needed for getu16 */
> -       ret =3D iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p), NULL,
> -                             &iov, 1, VHOST_MAP_RO);
> -       if (ret < 0)
> -               return ret;
> +       if (vrh->use_va) {
> +               struct iovec iov;
> +               __virtio16 tmp;
> +
> +               ret =3D iotlb_translate_va(vrh, (u64)(uintptr_t)p, sizeof=
(*p),
> +                                        NULL, &iov, 1, VHOST_MAP_RO);
> +               if (ret < 0)
> +                       return ret;

Nit: since we have copy_to_va/copy_to_pa variants, let's introduce
getu16_iotlb_va/pa variants?

>
> -       kaddr =3D kmap_local_page(iov.bv_page);
> -       from =3D kaddr + iov.bv_offset;
> -       *val =3D vringh16_to_cpu(vrh, READ_ONCE(*(__virtio16 *)from));
> -       kunmap_local(kaddr);
> +               ret =3D __get_user(tmp, (__virtio16 __user *)iov.iov_base=
);
> +               if (ret)
> +                       return ret;
> +
> +               *val =3D vringh16_to_cpu(vrh, tmp);
> +       } else {
> +               struct bio_vec iov;
> +               void *kaddr, *from;
> +
> +               ret =3D iotlb_translate_pa(vrh, (u64)(uintptr_t)p, sizeof=
(*p),
> +                                        NULL, &iov, 1, VHOST_MAP_RO);
> +               if (ret < 0)
> +                       return ret;
> +
> +               kaddr =3D kmap_local_page(iov.bv_page);

If we decide to have a use_va switch, is kmap_local_page() still required h=
ere?

Other looks good.

Thanks

> +               from =3D kaddr + iov.bv_offset;
> +               *val =3D vringh16_to_cpu(vrh, READ_ONCE(*(__virtio16 *)fr=
om));
> +               kunmap_local(kaddr);
> +       }
>
>         return 0;
>  }
> @@ -1231,20 +1360,37 @@ static inline int getu16_iotlb(const struct vring=
h *vrh,
>  static inline int putu16_iotlb(const struct vringh *vrh,
>                                __virtio16 *p, u16 val)
>  {
> -       struct bio_vec iov;
> -       void *kaddr, *to;
>         int ret;
>
>         /* Atomic write is needed for putu16 */
> -       ret =3D iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p), NULL,
> -                             &iov, 1, VHOST_MAP_WO);
> -       if (ret < 0)
> -               return ret;
> +       if (vrh->use_va) {
> +               struct iovec iov;
> +               __virtio16 tmp;
>
> -       kaddr =3D kmap_local_page(iov.bv_page);
> -       to =3D kaddr + iov.bv_offset;
> -       WRITE_ONCE(*(__virtio16 *)to, cpu_to_vringh16(vrh, val));
> -       kunmap_local(kaddr);
> +               ret =3D iotlb_translate_va(vrh, (u64)(uintptr_t)p, sizeof=
(*p),
> +                                        NULL, &iov, 1, VHOST_MAP_RO);
> +               if (ret < 0)
> +                       return ret;
> +
> +               tmp =3D cpu_to_vringh16(vrh, val);
> +
> +               ret =3D __put_user(tmp, (__virtio16 __user *)iov.iov_base=
);
> +               if (ret)
> +                       return ret;
> +       } else {
> +               struct bio_vec iov;
> +               void *kaddr, *to;
> +
> +               ret =3D iotlb_translate_pa(vrh, (u64)(uintptr_t)p, sizeof=
(*p), NULL,
> +                                        &iov, 1, VHOST_MAP_WO);
> +               if (ret < 0)
> +                       return ret;
> +
> +               kaddr =3D kmap_local_page(iov.bv_page);
> +               to =3D kaddr + iov.bv_offset;
> +               WRITE_ONCE(*(__virtio16 *)to, cpu_to_vringh16(vrh, val));
> +               kunmap_local(kaddr);
> +       }
>
>         return 0;
>  }
> @@ -1306,6 +1452,7 @@ static inline int putused_iotlb(const struct vringh=
 *vrh,
>   * @features: the feature bits for this ring.
>   * @num: the number of elements.
>   * @weak_barriers: true if we only need memory barriers, not I/O.
> + * @use_va: true if IOTLB contains user VA
>   * @desc: the userpace descriptor pointer.
>   * @avail: the userpace avail pointer.
>   * @used: the userpace used pointer.
> @@ -1313,11 +1460,13 @@ static inline int putused_iotlb(const struct vrin=
gh *vrh,
>   * Returns an error if num is invalid.
>   */
>  int vringh_init_iotlb(struct vringh *vrh, u64 features,
> -                     unsigned int num, bool weak_barriers,
> +                     unsigned int num, bool weak_barriers, bool use_va,
>                       struct vring_desc *desc,
>                       struct vring_avail *avail,
>                       struct vring_used *used)
>  {
> +       vrh->use_va =3D use_va;
> +
>         return vringh_init_kern(vrh, features, num, weak_barriers,
>                                 desc, avail, used);
>  }
> --
> 2.39.2
>

