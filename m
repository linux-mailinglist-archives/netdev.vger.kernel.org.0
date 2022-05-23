Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4EE530E02
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 12:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233766AbiEWJ5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 05:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233711AbiEWJ5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 05:57:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 44B72193FC
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 02:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653299865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j7po0GtrBtc9y8cOPJ/0GbOoVIs2F1iXmywPEu00Vik=;
        b=J6zxkoz0H9vVogJE1vypwCVe96UJgkDINcVSZfKvvBxl/jEgO3DFS6ZO5fN5HGka4AVU36
        sroiGsSoss1FEKmfYeb40LlpwuWIgoieNOjW8QJs6kWVuoWQ/akO05J8Y1IrDVBHObxAYI
        FAfC9ZLnWeRO0WM8dTT9LGoxCn339hk=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-263-hio2DSgpOCKEsu8T0S3Z4w-1; Mon, 23 May 2022 05:57:44 -0400
X-MC-Unique: hio2DSgpOCKEsu8T0S3Z4w-1
Received: by mail-qv1-f71.google.com with SMTP id x11-20020a056214052b00b00461f2984c36so9423434qvw.20
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 02:57:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=j7po0GtrBtc9y8cOPJ/0GbOoVIs2F1iXmywPEu00Vik=;
        b=dF+HTcGHe05YtPqpRpklbg6LDo5cy8V0xMNpnIoQreZGPDe93iA30yoXsbt03LJ+UP
         3YVLRpkkp1iiZHB5GHJPlo8StKDE1bJ7nFuBFoJe9OcpH7Ksb6U0XpRyN6fc+4Kfqmsf
         gs3f0/ZgvKpa7B7UBhd8VotP4omZ+vXoxzXOpkS8+bAAG/hrlMhozIur9oueHDn+9Pnc
         p2EoxR7ZmaBMluBdti1dW2ZoyFUGBozmOil6k+k8BjZ4GmxX0cEXa3fVRcxJzOrk3KzI
         Efz94ow3JaRIzunO39XsrmXXTluJLQyyoOchr8TAc/T2Y/r83elaJVukkkToNDeJx8hv
         PUtg==
X-Gm-Message-State: AOAM531mc8B78wnLp2603ro7UjBMneBnemFMd6SNJJdFnEycCGsNEkwc
        2jJJ/bxSJzLzvjsF4648CAbvDKlhVKqaD6ZBhZBBl+m4C2Ca4UpGe/47A0yCqJ870ShiYvz7zBl
        vtuo0Hr5uEbKMTg81Xmdc6S/y1UfN8FvO
X-Received: by 2002:ac8:4e81:0:b0:2f9:34e4:8955 with SMTP id 1-20020ac84e81000000b002f934e48955mr3214655qtp.459.1653299863497;
        Mon, 23 May 2022 02:57:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvbFG1aDvatEqz9FXE4l2jp7/tHOGW5uKpg80Hd8pzafG0zBsY8brrzQMiJMaoyoUAVsq3ctLvZhaXY1yEfaE=
X-Received: by 2002:ac8:4e81:0:b0:2f9:34e4:8955 with SMTP id
 1-20020ac84e81000000b002f934e48955mr3214627qtp.459.1653299863283; Mon, 23 May
 2022 02:57:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220520172325.980884-1-eperezma@redhat.com> <20220520172325.980884-3-eperezma@redhat.com>
 <c1a31c3f-46c0-f0a2-eb43-757914d46ac3@oracle.com>
In-Reply-To: <c1a31c3f-46c0-f0a2-eb43-757914d46ac3@oracle.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Mon, 23 May 2022 11:57:07 +0200
Message-ID: <CAJaqyWdg0tuBcDeaB9Q-XkEoPRSqQ=ruFh1eqT40uOeknRwdkw@mail.gmail.com>
Subject: Re: [PATCH 2/4] vhost-vdpa: introduce STOP backend feature bit
To:     Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        Longpeng <longpeng2@huawei.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Harpreet Singh Anand <hanand@xilinx.com>, dinang@xilinx.com,
        Eli Cohen <elic@nvidia.com>,
        Laurent Vivier <lvivier@redhat.com>, pabloc@xilinx.com,
        "Dawar, Gautam" <gautam.dawar@amd.com>,
        Xie Yongji <xieyongji@bytedance.com>, habetsm.xilinx@gmail.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        tanuj.kamde@amd.com, Wu Zongyong <wuzongyong@linux.alibaba.com>,
        martinpo@xilinx.com, Cindy Lu <lulu@redhat.com>,
        ecree.xilinx@gmail.com, Parav Pandit <parav@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 21, 2022 at 12:25 PM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>
>
>
> On 5/20/2022 10:23 AM, Eugenio P=C3=A9rez wrote:
> > Userland knows if it can stop the device or not by checking this featur=
e
> > bit.
> >
> > It's only offered if the vdpa driver backend implements the stop()
> > operation callback, and try to set it if the backend does not offer tha=
t
> > callback is an error.
> >
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > ---
> >   drivers/vhost/vdpa.c             | 13 +++++++++++++
> >   include/uapi/linux/vhost_types.h |  2 ++
> >   2 files changed, 15 insertions(+)
> >
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > index 1f1d1c425573..a325bc259afb 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -347,6 +347,14 @@ static long vhost_vdpa_set_config(struct vhost_vdp=
a *v,
> >       return 0;
> >   }
> >
> > +static bool vhost_vdpa_can_stop(const struct vhost_vdpa *v)
> > +{
> > +     struct vdpa_device *vdpa =3D v->vdpa;
> > +     const struct vdpa_config_ops *ops =3D vdpa->config;
> > +
> > +     return ops->stop;
> > +}
> > +
> >   static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user =
*featurep)
> >   {
> >       struct vdpa_device *vdpa =3D v->vdpa;
> > @@ -577,6 +585,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *=
filep,
> >                       return -EFAULT;
> >               if (features & ~VHOST_VDPA_BACKEND_FEATURES)
> >                       return -EOPNOTSUPP;
> > +             if ((features & VHOST_BACKEND_F_STOP) &&
> VHOST_BACKEND_F_STOP is not part of VHOST_VDPA_BACKEND_FEATURES. There's
> no chance for VHOST_BACKEND_F_STOP to get here.
>

That's right. I think I missed to backport your patches about set
backend_features only once in my testing.

I will re-test with the latest qemu master, thanks!

> -Siwei
> > +                  !vhost_vdpa_can_stop(v))
> > +                     return -EOPNOTSUPP;
> >               vhost_set_backend_features(&v->vdev, features);
> >               return 0;
> >       }
> > @@ -624,6 +635,8 @@ static long vhost_vdpa_unlocked_ioctl(struct file *=
filep,
> >               break;
> >       case VHOST_GET_BACKEND_FEATURES:
> >               features =3D VHOST_VDPA_BACKEND_FEATURES;
> > +             if (vhost_vdpa_can_stop(v))
> > +                     features |=3D VHOST_BACKEND_F_STOP;
> >               if (copy_to_user(featurep, &features, sizeof(features)))
> >                       r =3D -EFAULT;
> >               break;
> > diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhos=
t_types.h
> > index 634cee485abb..2758e665791b 100644
> > --- a/include/uapi/linux/vhost_types.h
> > +++ b/include/uapi/linux/vhost_types.h
> > @@ -161,5 +161,7 @@ struct vhost_vdpa_iova_range {
> >    * message
> >    */
> >   #define VHOST_BACKEND_F_IOTLB_ASID  0x3
> > +/* Stop device from processing virtqueue buffers */
> > +#define VHOST_BACKEND_F_STOP  0x4
> >
> >   #endif
>

