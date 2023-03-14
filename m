Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531436B8A7C
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 06:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjCNFhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 01:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjCNFhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 01:37:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFFA7BA08
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 22:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678772187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CUNqowlHsOHTiRljuMolx/A+uVnVqERrix3vDx9FlvY=;
        b=hqriddXLrPf/fO8qjIoVYYPdx9RrMeqBweeTh3vxyl5vM6XfX4asAGfYSiEXlB4bk1pZxU
        c/YUdcfPOoJoUhc/xrM+Hu6yh+sZmOHXr1p+NnPiev2dGzrQLaOvafrRlLCXWo5qMaPsdn
        LGYESD482bHNV+Uum21rOtE8fzAg4h8=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-199-oydlcIAPPwOhcP1ESLDZfg-1; Tue, 14 Mar 2023 01:36:26 -0400
X-MC-Unique: oydlcIAPPwOhcP1ESLDZfg-1
Received: by mail-ot1-f72.google.com with SMTP id p21-20020a9d6955000000b00696141d38e6so729461oto.8
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 22:36:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678772185;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CUNqowlHsOHTiRljuMolx/A+uVnVqERrix3vDx9FlvY=;
        b=XT17T9OiCsPTIAfIivSt6hz7Nj/TphD/pIjf8jY0mH/+bRKFXgtAAestA0q/0//wTI
         xxFur37jAeAnKT4PtFyWG1DRkhn7HJox8FBjoQS8arQ2woPe/TNki97MKdvPosvlCHuf
         SBwNZaEXPUZGNAZGwb9Q+RKkIUbGPOdfiWjmY7DfJXoZJELSTiUqIoIAKUZ1q6DkZFn8
         mWTUzsNoI0KcTriDoR//54n7/Tb1oIjvmvWZt/wJVMGi6n7Gbx+14WS9+V0YM0gR4eIL
         s2M9ejFYZjo94ICMcnrCMefIL395FfIbkJK0r4dyN4NVKHHuQAw21jY5ESSqPM4f43ds
         T3dw==
X-Gm-Message-State: AO0yUKUy6BDpo64rJGJ4RWUvwUE/1/Dfe7NNzNpeILVyWOZOACYuZTZ8
        MxRyWrPjpf/gL8aX0AQfMcjIfEutR2HSoadZTFBQLga3HQSVLt19OORU9OSImqhdk9jWL6hRRkm
        22EAqSEHTzNgEv+STkANi00yk3q/CwWRd
X-Received: by 2002:a9d:60d0:0:b0:688:d1d6:2029 with SMTP id b16-20020a9d60d0000000b00688d1d62029mr12568431otk.2.1678772185640;
        Mon, 13 Mar 2023 22:36:25 -0700 (PDT)
X-Google-Smtp-Source: AK7set+kN4AtoVa9aWxyktypjoY9bQX/jqJh/j0S1GrS5sbNhOwjiFrtu8xIdNunTOUI244RxuH+n3UiLO9HYeAQIRc=
X-Received: by 2002:a9d:60d0:0:b0:688:d1d6:2029 with SMTP id
 b16-20020a9d60d0000000b00688d1d62029mr12568426otk.2.1678772185358; Mon, 13
 Mar 2023 22:36:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230302113421.174582-1-sgarzare@redhat.com> <20230302113421.174582-9-sgarzare@redhat.com>
In-Reply-To: <20230302113421.174582-9-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 14 Mar 2023 13:36:13 +0800
Message-ID: <CACGkMEt1hBcRdh0oQYCs4meRs0mvDu9X9o-zK4aS87hrN+QPxA@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] vdpa_sim: add support for user VA
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
> The new "use_va" module parameter (default: false) is used in
> vdpa_alloc_device() to inform the vDPA framework that the device
> supports VA.
>
> vringh is initialized to use VA only when "use_va" is true and the
> user's mm has been bound. So, only when the bus supports user VA
> (e.g. vhost-vdpa).
>
> vdpasim_mm_work_fn work is used to attach the kthread to the user
> address space when the .bind_mm callback is invoked, and to detach
> it when the .unbind_mm callback is invoked.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>
> Notes:
>     v2:
>     - `use_va` set to true by default [Eugenio]
>     - supported the new unbind_mm callback [Jason]
>     - removed the unbind_mm call in vdpasim_do_reset() [Jason]
>     - avoided to release the lock while call kthread_flush_work() since w=
e
>       are now using a mutex to protect the device state
>
>  drivers/vdpa/vdpa_sim/vdpa_sim.h |  1 +
>  drivers/vdpa/vdpa_sim/vdpa_sim.c | 98 +++++++++++++++++++++++++++++++-
>  2 files changed, 97 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdp=
a_sim.h
> index 4774292fba8c..3a42887d05d9 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
> @@ -59,6 +59,7 @@ struct vdpasim {
>         struct vdpasim_virtqueue *vqs;
>         struct kthread_worker *worker;
>         struct kthread_work work;
> +       struct mm_struct *mm_bound;
>         struct vdpasim_dev_attr dev_attr;
>         /* mutex to synchronize virtqueue state */
>         struct mutex mutex;
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdp=
a_sim.c
> index a28103a67ae7..eda26bc33df5 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -35,10 +35,77 @@ module_param(max_iotlb_entries, int, 0444);
>  MODULE_PARM_DESC(max_iotlb_entries,
>                  "Maximum number of iotlb entries for each address space.=
 0 means unlimited. (default: 2048)");
>
> +static bool use_va =3D true;
> +module_param(use_va, bool, 0444);
> +MODULE_PARM_DESC(use_va, "Enable/disable the device's ability to use VA"=
);
> +
>  #define VDPASIM_QUEUE_ALIGN PAGE_SIZE
>  #define VDPASIM_QUEUE_MAX 256
>  #define VDPASIM_VENDOR_ID 0
>
> +struct vdpasim_mm_work {
> +       struct kthread_work work;
> +       struct mm_struct *mm;
> +       bool bind;
> +       int ret;
> +};
> +
> +static void vdpasim_mm_work_fn(struct kthread_work *work)
> +{
> +       struct vdpasim_mm_work *mm_work =3D
> +               container_of(work, struct vdpasim_mm_work, work);
> +
> +       mm_work->ret =3D 0;
> +
> +       if (mm_work->bind) {
> +               kthread_use_mm(mm_work->mm);
> +               //TODO: should we attach the cgroup of the mm owner?
> +       } else {
> +               kthread_unuse_mm(mm_work->mm);
> +       }
> +}
> +
> +static void vdpasim_worker_queue_mm(struct vdpasim *vdpasim,
> +                                   struct vdpasim_mm_work *mm_work)
> +{

Nit: we need to tweak the name as it does flush besides queuing the work.

> +       struct kthread_work *work =3D &mm_work->work;
> +
> +       kthread_init_work(work, vdpasim_mm_work_fn);
> +       kthread_queue_work(vdpasim->worker, work);
> +
> +       kthread_flush_work(work);
> +}
> +
> +static int vdpasim_worker_bind_mm(struct vdpasim *vdpasim,
> +                                 struct mm_struct *new_mm)
> +{
> +       struct vdpasim_mm_work mm_work;
> +
> +       mm_work.mm =3D new_mm;
> +       mm_work.bind =3D true;
> +
> +       vdpasim_worker_queue_mm(vdpasim, &mm_work);
> +
> +       if (!mm_work.ret)
> +               vdpasim->mm_bound =3D new_mm;
> +
> +       return mm_work.ret;
> +}
> +
> +static void vdpasim_worker_unbind_mm(struct vdpasim *vdpasim)
> +{
> +       struct vdpasim_mm_work mm_work;
> +
> +       if (!vdpasim->mm_bound)
> +               return;
> +
> +       mm_work.mm =3D vdpasim->mm_bound;
> +       mm_work.bind =3D false;

Can we simply use mm_work.mm =3D NULL for unbinding?

> +
> +       vdpasim_worker_queue_mm(vdpasim, &mm_work);
> +
> +       vdpasim->mm_bound =3D NULL;

And change the mm_bound in the worker?

Thanks

> +}
>  static struct vdpasim *vdpa_to_sim(struct vdpa_device *vdpa)
>  {
>         return container_of(vdpa, struct vdpasim, vdpa);
> @@ -59,8 +126,10 @@ static void vdpasim_queue_ready(struct vdpasim *vdpas=
im, unsigned int idx)
>  {
>         struct vdpasim_virtqueue *vq =3D &vdpasim->vqs[idx];
>         uint16_t last_avail_idx =3D vq->vring.last_avail_idx;
> +       bool va_enabled =3D use_va && vdpasim->mm_bound;
>
> -       vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, true, f=
alse,
> +       vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, true,
> +                         va_enabled,
>                           (struct vring_desc *)(uintptr_t)vq->desc_addr,
>                           (struct vring_avail *)
>                           (uintptr_t)vq->driver_addr,
> @@ -151,7 +220,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_att=
r *dev_attr,
>         vdpa =3D __vdpa_alloc_device(NULL, ops,
>                                    dev_attr->ngroups, dev_attr->nas,
>                                    dev_attr->alloc_size,
> -                                  dev_attr->name, false);
> +                                  dev_attr->name, use_va);
>         if (IS_ERR(vdpa)) {
>                 ret =3D PTR_ERR(vdpa);
>                 goto err_alloc;
> @@ -571,6 +640,27 @@ static int vdpasim_set_map(struct vdpa_device *vdpa,=
 unsigned int asid,
>         return ret;
>  }
>
> +static int vdpasim_bind_mm(struct vdpa_device *vdpa, struct mm_struct *m=
m)
> +{
> +       struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
> +       int ret;
> +
> +       mutex_lock(&vdpasim->mutex);
> +       ret =3D vdpasim_worker_bind_mm(vdpasim, mm);
> +       mutex_unlock(&vdpasim->mutex);
> +
> +       return ret;
> +}
> +
> +static void vdpasim_unbind_mm(struct vdpa_device *vdpa)
> +{
> +       struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
> +
> +       mutex_lock(&vdpasim->mutex);
> +       vdpasim_worker_unbind_mm(vdpasim);
> +       mutex_unlock(&vdpasim->mutex);
> +}
> +
>  static int vdpasim_dma_map(struct vdpa_device *vdpa, unsigned int asid,
>                            u64 iova, u64 size,
>                            u64 pa, u32 perm, void *opaque)
> @@ -667,6 +757,8 @@ static const struct vdpa_config_ops vdpasim_config_op=
s =3D {
>         .set_group_asid         =3D vdpasim_set_group_asid,
>         .dma_map                =3D vdpasim_dma_map,
>         .dma_unmap              =3D vdpasim_dma_unmap,
> +       .bind_mm                =3D vdpasim_bind_mm,
> +       .unbind_mm              =3D vdpasim_unbind_mm,
>         .free                   =3D vdpasim_free,
>  };
>
> @@ -701,6 +793,8 @@ static const struct vdpa_config_ops vdpasim_batch_con=
fig_ops =3D {
>         .get_iova_range         =3D vdpasim_get_iova_range,
>         .set_group_asid         =3D vdpasim_set_group_asid,
>         .set_map                =3D vdpasim_set_map,
> +       .bind_mm                =3D vdpasim_bind_mm,
> +       .unbind_mm              =3D vdpasim_unbind_mm,
>         .free                   =3D vdpasim_free,
>  };
>
> --
> 2.39.2
>

