Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3973F534C14
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 10:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243925AbiEZI5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 04:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbiEZI5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 04:57:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 29AAAA7E3F
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 01:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653555461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wZpmyj3OZQ3pBrXt/5TVuYqgh1eNpvGfVJnmbN2oiSY=;
        b=dO5EkKVjhdhnkPqMNpleLatDOFu41WN94sXoC3WJAsKwL5N+vNbSYr0rrijIZIiDryOE7D
        FbSez67kgYwyjNbCXVB4ftmC/zR5fnI+RbrtjOP8XIkt1LiGG+2Y0fTM6glr78sQcgvAMH
        pEhGIwzqyzVCQC3PcRBX5wItuaZLkUM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-cvwrpgL0Oh-tw8XoLpdpYA-1; Thu, 26 May 2022 04:57:40 -0400
X-MC-Unique: cvwrpgL0Oh-tw8XoLpdpYA-1
Received: by mail-qk1-f200.google.com with SMTP id bj2-20020a05620a190200b005084968bb24so842971qkb.23
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 01:57:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wZpmyj3OZQ3pBrXt/5TVuYqgh1eNpvGfVJnmbN2oiSY=;
        b=FBzwvPKLDASMQDT/+3Fnmy1et09JJqIF+G5LR9oVB48X9XjMKkBEE/yv0/lWS47cEm
         ubVkYoML5yvssrGDGGi8owfCppwquNNTEhm9AkmZLl8LVRp1HJTywiuRCKZH2/FN0GMg
         8ZrwBcFvovwTjQa95BXxwSYSMlQPVZR2znuya/c0PJbLQO72kn86VvcWqlBKn7tyomhp
         iuSqDB303zAbwYSoY3tidLb65dW/jET7DFrh6CrDgiJMUulLXlfhlNVdQOnoXCYWn6on
         AZ5dSMPb5L42mrrGB2sKzLXm6rf/1jUmXcHq4Zqr790dLV3hMpWRTYAsIIAgx9qoyU49
         szhg==
X-Gm-Message-State: AOAM532W5XbDVHs3Hx0ZllpZuQ9tOwu+jOtU1+jM93bm1X5wV8uAmEIH
        Qf5IL06tGyLzLskn89SMfQLE2AGWpjeVD9egWwZXyg5zQPiliG4aM15LavRAx9GlZOXDEWDdJtM
        OFcNBgsGOL7ejq2RF70U72Bj8j+dMBKjl
X-Received: by 2002:a05:622a:1899:b0:2f3:b09e:dbe9 with SMTP id v25-20020a05622a189900b002f3b09edbe9mr27814522qtc.199.1653555459682;
        Thu, 26 May 2022 01:57:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjIaLlyyFKyzCNM0eVOxdzZFqpQOposlyXO+xlUZBqq0LkEO+INJ4wUrqjhNoPeHr4YKiQ02LEvGSr1//hqf4=
X-Received: by 2002:a05:622a:1899:b0:2f3:b09e:dbe9 with SMTP id
 v25-20020a05622a189900b002f3b09edbe9mr27814485qtc.199.1653555459453; Thu, 26
 May 2022 01:57:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220525105922.2413991-1-eperezma@redhat.com> <20220525105922.2413991-3-eperezma@redhat.com>
 <BL1PR12MB582520CC9CE024149141327499D69@BL1PR12MB5825.namprd12.prod.outlook.com>
In-Reply-To: <BL1PR12MB582520CC9CE024149141327499D69@BL1PR12MB5825.namprd12.prod.outlook.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 26 May 2022 10:57:03 +0200
Message-ID: <CAJaqyWc9_ErCg4whLKrjNyP5z2DZno-LJm7PN=-9uk7PUT4fJw@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] vhost-vdpa: introduce STOP backend feature bit
To:     "Dawar, Gautam" <gautam.dawar@amd.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "martinh@xilinx.com" <martinh@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "dinang@xilinx.com" <dinang@xilinx.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Xie Yongji <xieyongji@bytedance.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "martinpo@xilinx.com" <martinpo@xilinx.com>,
        "pabloc@xilinx.com" <pabloc@xilinx.com>,
        Longpeng <longpeng2@huawei.com>,
        "Piotr.Uminski@intel.com" <Piotr.Uminski@intel.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "lvivier@redhat.com" <lvivier@redhat.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        "hanand@xilinx.com" <hanand@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 25, 2022 at 1:23 PM Dawar, Gautam <gautam.dawar@amd.com> wrote:
>
> [AMD Official Use Only - General]
>
> -----Original Message-----
> From: Eugenio P=C3=A9rez <eperezma@redhat.com>
> Sent: Wednesday, May 25, 2022 4:29 PM
> To: Michael S. Tsirkin <mst@redhat.com>; netdev@vger.kernel.org; linux-ke=
rnel@vger.kernel.org; kvm@vger.kernel.org; virtualization@lists.linux-found=
ation.org; Jason Wang <jasowang@redhat.com>
> Cc: Zhu Lingshan <lingshan.zhu@intel.com>; martinh@xilinx.com; Stefano Ga=
rzarella <sgarzare@redhat.com>; ecree.xilinx@gmail.com; Eli Cohen <elic@nvi=
dia.com>; Dan Carpenter <dan.carpenter@oracle.com>; Parav Pandit <parav@nvi=
dia.com>; Wu Zongyong <wuzongyong@linux.alibaba.com>; dinang@xilinx.com; Ch=
ristophe JAILLET <christophe.jaillet@wanadoo.fr>; Xie Yongji <xieyongji@byt=
edance.com>; Dawar, Gautam <gautam.dawar@amd.com>; lulu@redhat.com; martinp=
o@xilinx.com; pabloc@xilinx.com; Longpeng <longpeng2@huawei.com>; Piotr.Umi=
nski@intel.com; Kamde, Tanuj <tanuj.kamde@amd.com>; Si-Wei Liu <si-wei.liu@=
oracle.com>; habetsm.xilinx@gmail.com; lvivier@redhat.com; Zhang Min <zhang=
.min9@zte.com.cn>; hanand@xilinx.com
> Subject: [PATCH v3 2/4] vhost-vdpa: introduce STOP backend feature bit
>
> [CAUTION: External Email]
>
> Userland knows if it can stop the device or not by checking this feature =
bit.
>
> It's only offered if the vdpa driver backend implements the stop() operat=
ion callback, and try to set it if the backend does not offer that callback=
 is an error.
>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> ---
>  drivers/vhost/vdpa.c             | 16 +++++++++++++++-
>  include/uapi/linux/vhost_types.h |  2 ++
>  2 files changed, 17 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c index 1f1d1c4255=
73..32713db5831d 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -347,6 +347,14 @@ static long vhost_vdpa_set_config(struct vhost_vdpa =
*v,
>         return 0;
>  }
>
> +static bool vhost_vdpa_can_stop(const struct vhost_vdpa *v) {
> +       struct vdpa_device *vdpa =3D v->vdpa;
> +       const struct vdpa_config_ops *ops =3D vdpa->config;
> +
> +       return ops->stop;
> [GD>>] Would it be better to explicitly return a bool to match the return=
 type?

I'm not sure about the kernel code style regarding that casting. Maybe
it's better to return !!ops->stop here. The macros likely and unlikely
do that.

Thanks!

> +}
> +
>  static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user *fe=
aturep)  {
>         struct vdpa_device *vdpa =3D v->vdpa; @@ -575,7 +583,11 @@ static=
 long vhost_vdpa_unlocked_ioctl(struct file *filep,
>         if (cmd =3D=3D VHOST_SET_BACKEND_FEATURES) {
>                 if (copy_from_user(&features, featurep, sizeof(features))=
)
>                         return -EFAULT;
> -               if (features & ~VHOST_VDPA_BACKEND_FEATURES)
> +               if (features & ~(VHOST_VDPA_BACKEND_FEATURES |
> +                                BIT_ULL(VHOST_BACKEND_F_STOP)))
> +                       return -EOPNOTSUPP;
> +               if ((features & BIT_ULL(VHOST_BACKEND_F_STOP)) &&
> +                    !vhost_vdpa_can_stop(v))
>                         return -EOPNOTSUPP;
>                 vhost_set_backend_features(&v->vdev, features);
>                 return 0;
> @@ -624,6 +636,8 @@ static long vhost_vdpa_unlocked_ioctl(struct file *fi=
lep,
>                 break;
>         case VHOST_GET_BACKEND_FEATURES:
>                 features =3D VHOST_VDPA_BACKEND_FEATURES;
> +               if (vhost_vdpa_can_stop(v))
> +                       features |=3D BIT_ULL(VHOST_BACKEND_F_STOP);
>                 if (copy_to_user(featurep, &features, sizeof(features)))
>                         r =3D -EFAULT;
>                 break;
> diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_=
types.h
> index 634cee485abb..2758e665791b 100644
> --- a/include/uapi/linux/vhost_types.h
> +++ b/include/uapi/linux/vhost_types.h
> @@ -161,5 +161,7 @@ struct vhost_vdpa_iova_range {
>   * message
>   */
>  #define VHOST_BACKEND_F_IOTLB_ASID  0x3
> +/* Stop device from processing virtqueue buffers */ #define
> +VHOST_BACKEND_F_STOP  0x4
>
>  #endif
> --
> 2.27.0
>

