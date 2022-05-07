Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0110551E66E
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 12:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384256AbiEGK2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 06:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384181AbiEGK2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 06:28:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5323151E54
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 03:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651919055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4PoBOISP8502+nd/TluX0Q/uA/xl55xp5kvTHh9E1rY=;
        b=a5ljnaH0s24KegPP1Cg2WUH7D72K0DFf+jyRSjNoMgHzAKANQvGuFLhtcljyFMUOI99tbI
        QcSIrneNGLUXUApvrQsDnTzLedsCftPsiEKZ69GEBL8llTCkYD3UtjK9UcnZ+md3xVgB7L
        7yhipC6HtsMQK3LjNJ/wPwzmutHUCSI=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-218-W1oNBFbtM5-lj6HXo5JjQA-1; Sat, 07 May 2022 06:24:14 -0400
X-MC-Unique: W1oNBFbtM5-lj6HXo5JjQA-1
Received: by mail-lf1-f71.google.com with SMTP id br16-20020a056512401000b004739cf51722so4328218lfb.6
        for <netdev@vger.kernel.org>; Sat, 07 May 2022 03:24:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4PoBOISP8502+nd/TluX0Q/uA/xl55xp5kvTHh9E1rY=;
        b=3McT0cJx21uCAhTkn6CvbO2U31Mn2MTodY0Metr0MYy8K6D8uHzfVYP/gbMRUN3PH5
         0twwtykJC0c0FzqXctTbtlMBbHiwiOj4MEFeBdefmN6+VTjvNJ8eJjPvTgnGe/w+ba9w
         HnLcg3C/6R8BC72O1g3J1dq5nVGwEfrMu1XhohL2mlxpq9Ggo69tPoCB9TZ4g1ElIqt9
         9ETlSzquCyrBrVzk947inYCblrnrK6mvqyxG+Tq+fhEVyvmaBQe8TAat6mBFdrcFaKGU
         PntJoV+X6VWYeh92YBDJ7XBdEdBimlfSXoDHXOAkgZ2VaSVm2iVh5hec6Es/gMCO7RZH
         AuFw==
X-Gm-Message-State: AOAM530mcvOJq10mxtwAmQSqRbe0ZcOfKXwykI8Lfuv3fJBXXNK/pUt0
        /eCO532yZid44N6ZCDtIlSwwewZ+EkVraoVO/jNR3eiQFA2uqopA3SoHZRP0Gj/kgCOnfdr4gC/
        6m8Uiy0HW9TnC0n1Z47ljeqypfx11nn26
X-Received: by 2002:a05:6512:1291:b0:473:b522:ef58 with SMTP id u17-20020a056512129100b00473b522ef58mr5750427lfs.190.1651919052527;
        Sat, 07 May 2022 03:24:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBkSADYnmPq4A3x/NWAvWkAeLc4ZsoI6A7WmoO/Lzfr8dbiNj97TIDdDmRpnVxVhewWo+zcjaeWglINT6o+6w=
X-Received: by 2002:a05:6512:1291:b0:473:b522:ef58 with SMTP id
 u17-20020a056512129100b00473b522ef58mr5750394lfs.190.1651919052232; Sat, 07
 May 2022 03:24:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220330180436.24644-1-gdawar@xilinx.com> <20220330180436.24644-16-gdawar@xilinx.com>
 <CACGkMEvL3rFaw9WP2ARmEkY4t-VppJ73NnapdUgwO=vCZ_Eg6A@mail.gmail.com> <BY5PR02MB698077E814EC867CEBAE2211B1FD9@BY5PR02MB6980.namprd02.prod.outlook.com>
In-Reply-To: <BY5PR02MB698077E814EC867CEBAE2211B1FD9@BY5PR02MB6980.namprd02.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Sat, 7 May 2022 18:24:01 +0800
Message-ID: <CACGkMEtqDRrnJ9C2L32rW1YE=6_5yqDy-kCVMJLS5+CvmoA6WQ@mail.gmail.com>
Subject: Re: [PATCH v2 15/19] vhost-vdpa: support ASID based IOTLB API
To:     Gautam Dawar <gdawar@xilinx.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Martin Porter <martinpo@xilinx.com>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        "tanuj.kamde@amd.com" <tanuj.kamde@amd.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        eperezma <eperezma@redhat.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Eli Cohen <elic@nvidia.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 2:28 PM Gautam Dawar <gdawar@xilinx.com> wrote:
>
> -----Original Message-----
> From: Jason Wang <jasowang@redhat.com>
> Sent: Friday, April 1, 2022 9:55 AM
> To: Gautam Dawar <gdawar@xilinx.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>; kvm <kvm@vger.kernel.org>; virtu=
alization <virtualization@lists.linux-foundation.org>; netdev <netdev@vger.=
kernel.org>; linux-kernel <linux-kernel@vger.kernel.org>; Martin Petrus Hub=
ertus Habets <martinh@xilinx.com>; Harpreet Singh Anand <hanand@xilinx.com>=
; Martin Porter <martinpo@xilinx.com>; Pablo Cascon <pabloc@xilinx.com>; Di=
nan Gunawardena <dinang@xilinx.com>; tanuj.kamde@amd.com; habetsm.xilinx@gm=
ail.com; ecree.xilinx@gmail.com; eperezma <eperezma@redhat.com>; Gautam Daw=
ar <gdawar@xilinx.com>; Wu Zongyong <wuzongyong@linux.alibaba.com>; Christo=
phe JAILLET <christophe.jaillet@wanadoo.fr>; Eli Cohen <elic@nvidia.com>; Z=
hu Lingshan <lingshan.zhu@intel.com>; Stefano Garzarella <sgarzare@redhat.c=
om>; Xie Yongji <xieyongji@bytedance.com>; Si-Wei Liu <si-wei.liu@oracle.co=
m>; Parav Pandit <parav@nvidia.com>; Longpeng <longpeng2@huawei.com>; Dan C=
arpenter <dan.carpenter@oracle.com>; Zhang Min <zhang.min9@zte.com.cn>
> Subject: Re: [PATCH v2 15/19] vhost-vdpa: support ASID based IOTLB API
>
> On Thu, Mar 31, 2022 at 2:17 AM Gautam Dawar <gautam.dawar@xilinx.com> wr=
ote:
> >
> > This patch extends the vhost-vdpa to support ASID based IOTLB API. The
> > vhost-vdpa device will allocated multiple IOTLBs for vDPA device that
> > supports multiple address spaces. The IOTLBs and vDPA device memory
> > mappings is determined and maintained through ASID.
> >
> > Note that we still don't support vDPA device with more than one
> > address spaces that depends on platform IOMMU. This work will be done
> > by moving the IOMMU logic from vhost-vDPA to vDPA device driver.
> >
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
> > ---
> >  drivers/vhost/vdpa.c  | 109 ++++++++++++++++++++++++++++++++++--------
> >  drivers/vhost/vhost.c |   2 +-
> >  2 files changed, 91 insertions(+), 20 deletions(-)
> >
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c index
> > 6c7ee0f18892..1f1d1c425573 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -28,7 +28,8 @@
> >  enum {
> >         VHOST_VDPA_BACKEND_FEATURES =3D
> >         (1ULL << VHOST_BACKEND_F_IOTLB_MSG_V2) |
> > -       (1ULL << VHOST_BACKEND_F_IOTLB_BATCH),
> > +       (1ULL << VHOST_BACKEND_F_IOTLB_BATCH) |
> > +       (1ULL << VHOST_BACKEND_F_IOTLB_ASID),
> >  };
> >
> >  #define VHOST_VDPA_DEV_MAX (1U << MINORBITS) @@ -57,12 +58,20 @@
> > struct vhost_vdpa {
> >         struct eventfd_ctx *config_ctx;
> >         int in_batch;
> >         struct vdpa_iova_range range;
> > +       u32 batch_asid;
> >  };
> >
> >  static DEFINE_IDA(vhost_vdpa_ida);
> >
> >  static dev_t vhost_vdpa_major;
> >
> > +static inline u32 iotlb_to_asid(struct vhost_iotlb *iotlb) {
> > +       struct vhost_vdpa_as *as =3D container_of(iotlb, struct
> > +                                               vhost_vdpa_as, iotlb);
> > +       return as->id;
> > +}
> > +
> >  static struct vhost_vdpa_as *asid_to_as(struct vhost_vdpa *v, u32
> > asid)  {
> >         struct hlist_head *head =3D &v->as[asid %
> > VHOST_VDPA_IOTLB_BUCKETS]; @@ -75,6 +84,16 @@ static struct vhost_vdpa_=
as *asid_to_as(struct vhost_vdpa *v, u32 asid)
> >         return NULL;
> >  }
> >
> > +static struct vhost_iotlb *asid_to_iotlb(struct vhost_vdpa *v, u32
> > +asid) {
> > +       struct vhost_vdpa_as *as =3D asid_to_as(v, asid);
> > +
> > +       if (!as)
> > +               return NULL;
> > +
> > +       return &as->iotlb;
> > +}
> > +
> >  static struct vhost_vdpa_as *vhost_vdpa_alloc_as(struct vhost_vdpa
> > *v, u32 asid)  {
> >         struct hlist_head *head =3D &v->as[asid %
> > VHOST_VDPA_IOTLB_BUCKETS]; @@ -83,6 +102,9 @@ static struct vhost_vdpa_=
as *vhost_vdpa_alloc_as(struct vhost_vdpa *v, u32 asid)
> >         if (asid_to_as(v, asid))
> >                 return NULL;
> >
> > +       if (asid >=3D v->vdpa->nas)
> > +               return NULL;
> > +
> >         as =3D kmalloc(sizeof(*as), GFP_KERNEL);
> >         if (!as)
> >                 return NULL;
> > @@ -94,6 +116,17 @@ static struct vhost_vdpa_as *vhost_vdpa_alloc_as(st=
ruct vhost_vdpa *v, u32 asid)
> >         return as;
> >  }
> >
> > +static struct vhost_vdpa_as *vhost_vdpa_find_alloc_as(struct vhost_vdp=
a *v,
> > +                                                     u32 asid) {
> > +       struct vhost_vdpa_as *as =3D asid_to_as(v, asid);
> > +
> > +       if (as)
> > +               return as;
> > +
> > +       return vhost_vdpa_alloc_as(v, asid); }
> > +
> >  static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)  {
> >         struct vhost_vdpa_as *as =3D asid_to_as(v, asid); @@ -692,6
> > +725,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_=
iotlb *iotlb,
> >         struct vhost_dev *dev =3D &v->vdev;
> >         struct vdpa_device *vdpa =3D v->vdpa;
> >         const struct vdpa_config_ops *ops =3D vdpa->config;
> > +       u32 asid =3D iotlb_to_asid(iotlb);
> >         int r =3D 0;
> >
> >         r =3D vhost_iotlb_add_range_ctx(iotlb, iova, iova + size - 1, @=
@
> > -700,10 +734,10 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, stru=
ct vhost_iotlb *iotlb,
> >                 return r;
> >
> >         if (ops->dma_map) {
> > -               r =3D ops->dma_map(vdpa, 0, iova, size, pa, perm, opaqu=
e);
> > +               r =3D ops->dma_map(vdpa, asid, iova, size, pa, perm,
> > + opaque);
> >         } else if (ops->set_map) {
> >                 if (!v->in_batch)
> > -                       r =3D ops->set_map(vdpa, 0, iotlb);
> > +                       r =3D ops->set_map(vdpa, asid, iotlb);
> >         } else {
> >                 r =3D iommu_map(v->domain, iova, pa, size,
> >                               perm_to_iommu_flags(perm)); @@ -725,17
> > +759,24 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v,  {
> >         struct vdpa_device *vdpa =3D v->vdpa;
> >         const struct vdpa_config_ops *ops =3D vdpa->config;
> > +       u32 asid =3D iotlb_to_asid(iotlb);
> >
> >         vhost_vdpa_iotlb_unmap(v, iotlb, iova, iova + size - 1);
> >
> >         if (ops->dma_map) {
> > -               ops->dma_unmap(vdpa, 0, iova, size);
> > +               ops->dma_unmap(vdpa, asid, iova, size);
> >         } else if (ops->set_map) {
> >                 if (!v->in_batch)
> > -                       ops->set_map(vdpa, 0, iotlb);
> > +                       ops->set_map(vdpa, asid, iotlb);
> >         } else {
> >                 iommu_unmap(v->domain, iova, size);
> >         }
> > +
> > +       /* If we are in the middle of batch processing, delay the free
> > +        * of AS until BATCH_END.
> > +        */
> > +       if (!v->in_batch && !iotlb->nmaps)
> > +               vhost_vdpa_remove_as(v, asid);
> >  }
> >
> >  static int vhost_vdpa_va_map(struct vhost_vdpa *v, @@ -943,19 +984,38
> > @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 a=
sid,
> >         struct vhost_vdpa *v =3D container_of(dev, struct vhost_vdpa, v=
dev);
> >         struct vdpa_device *vdpa =3D v->vdpa;
> >         const struct vdpa_config_ops *ops =3D vdpa->config;
> > -       struct vhost_vdpa_as *as =3D asid_to_as(v, 0);
> > -       struct vhost_iotlb *iotlb =3D &as->iotlb;
> > +       struct vhost_iotlb *iotlb =3D NULL;
> > +       struct vhost_vdpa_as *as =3D NULL;
> >         int r =3D 0;
> >
> > -       if (asid !=3D 0)
> > -               return -EINVAL;
> > -
> >         mutex_lock(&dev->mutex);
> >
> >         r =3D vhost_dev_check_owner(dev);
> >         if (r)
> >                 goto unlock;
> >
> > +       if (msg->type =3D=3D VHOST_IOTLB_UPDATE ||
> > +           msg->type =3D=3D VHOST_IOTLB_BATCH_BEGIN) {
> > +               as =3D vhost_vdpa_find_alloc_as(v, asid);
>
> I wonder if it's better to mandate the ASID to [0, dev->nas), otherwise u=
ser space is free to use arbitrary IDs which may exceeds the #address space=
s that is supported by the device.
> [GD>>] Isn=E2=80=99t the following check in vhost_vdpa_alloc_as () suffic=
ient to ensure ASID's value in the range [0, dev->nas):
>         if (asid >=3D v->vdpa->nas)
>                 return NULL;

I think you're right.

So we are fine.

Thanks

>
> Thanks
>
> > +               if (!as) {
> > +                       dev_err(&v->dev, "can't find and alloc asid %d\=
n",
> > +                               asid);
> > +                       return -EINVAL;
> > +               }
> > +               iotlb =3D &as->iotlb;
> > +       } else
> > +               iotlb =3D asid_to_iotlb(v, asid);
> > +
> > +       if ((v->in_batch && v->batch_asid !=3D asid) || !iotlb) {
> > +               if (v->in_batch && v->batch_asid !=3D asid) {
> > +                       dev_info(&v->dev, "batch id %d asid %d\n",
> > +                                v->batch_asid, asid);
> > +               }
> > +               if (!iotlb)
> > +                       dev_err(&v->dev, "no iotlb for asid %d\n", asid=
);
> > +               return -EINVAL;
> > +       }
> > +
> >         switch (msg->type) {
> >         case VHOST_IOTLB_UPDATE:
> >                 r =3D vhost_vdpa_process_iotlb_update(v, iotlb, msg); @=
@
> > -964,12 +1024,15 @@ static int vhost_vdpa_process_iotlb_msg(struct vhos=
t_dev *dev, u32 asid,
> >                 vhost_vdpa_unmap(v, iotlb, msg->iova, msg->size);
> >                 break;
> >         case VHOST_IOTLB_BATCH_BEGIN:
> > +               v->batch_asid =3D asid;
> >                 v->in_batch =3D true;
> >                 break;
> >         case VHOST_IOTLB_BATCH_END:
> >                 if (v->in_batch && ops->set_map)
> > -                       ops->set_map(vdpa, 0, iotlb);
> > +                       ops->set_map(vdpa, asid, iotlb);
> >                 v->in_batch =3D false;
> > +               if (!iotlb->nmaps)
> > +                       vhost_vdpa_remove_as(v, asid);
> >                 break;
> >         default:
> >                 r =3D -EINVAL;
> > @@ -1057,9 +1120,17 @@ static void vhost_vdpa_set_iova_range(struct
> > vhost_vdpa *v)
> >
> >  static void vhost_vdpa_cleanup(struct vhost_vdpa *v)  {
> > +       struct vhost_vdpa_as *as;
> > +       u32 asid;
> > +
> >         vhost_dev_cleanup(&v->vdev);
> >         kfree(v->vdev.vqs);
> > -       vhost_vdpa_remove_as(v, 0);
> > +
> > +       for (asid =3D 0; asid < v->vdpa->nas; asid++) {
> > +               as =3D asid_to_as(v, asid);
> > +               if (as)
> > +                       vhost_vdpa_remove_as(v, asid);
> > +       }
> >  }
> >
> >  static int vhost_vdpa_open(struct inode *inode, struct file *filep)
> > @@ -1095,12 +1166,9 @@ static int vhost_vdpa_open(struct inode *inode, =
struct file *filep)
> >         vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
> >                        vhost_vdpa_process_iotlb_msg);
> >
> > -       if (!vhost_vdpa_alloc_as(v, 0))
> > -               goto err_alloc_as;
> > -
> >         r =3D vhost_vdpa_alloc_domain(v);
> >         if (r)
> > -               goto err_alloc_as;
> > +               goto err_alloc_domain;
> >
> >         vhost_vdpa_set_iova_range(v);
> >
> > @@ -1108,7 +1176,7 @@ static int vhost_vdpa_open(struct inode *inode,
> > struct file *filep)
> >
> >         return 0;
> >
> > -err_alloc_as:
> > +err_alloc_domain:
> >         vhost_vdpa_cleanup(v);
> >  err:
> >         atomic_dec(&v->opened);
> > @@ -1233,8 +1301,11 @@ static int vhost_vdpa_probe(struct vdpa_device *=
vdpa)
> >         int minor;
> >         int i, r;
> >
> > -       /* Only support 1 address space and 1 groups */
> > -       if (vdpa->ngroups !=3D 1 || vdpa->nas !=3D 1)
> > +       /* We can't support platform IOMMU device with more than 1
> > +        * group or as
> > +        */
> > +       if (!ops->set_map && !ops->dma_map &&
> > +           (vdpa->ngroups > 1 || vdpa->nas > 1))
> >                 return -EOPNOTSUPP;
> >
> >         v =3D kzalloc(sizeof(*v), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c index
> > d1e58f976f6e..5022c648d9c0 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -1167,7 +1167,7 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *de=
v,
> >                                 ret =3D -EINVAL;
> >                                 goto done;
> >                         }
> > -                       offset =3D sizeof(__u16);
> > +                       offset =3D 0;
> >                 } else
> >                         offset =3D sizeof(__u32);
> >                 break;
> > --
> > 2.30.1
> >
>

